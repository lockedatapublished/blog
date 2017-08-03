---
title: Versioning R model objects in SQL Server
author: Steph
type: post
date: 2017-05-26T08:00:04+00:00
spacious_page_layout:
  - default_layout
categories:
  - Data Science
  - DataOps
  - Microsoft Data Platform
  - R
tags:
  - best practices
  - microsoft r server
  - mssql
  - sql server
  - temporal tables

---
# High-level info

If you build a model and never update it you&#8217;re missing a trick. Behaviours change so your model will tend to perform worse over time. You&#8217;ve got to regularly refresh it, whether that&#8217;s adjusting the existing model to fit the latest data (recalibration) or building a whole new model (retraining), but this means you&#8217;ve got new versions of your model that you have to handle. You need to think about your methodology for versioning R model objects, ideally before you lose any versions.

You could store models with ye olde YYYYMMDD style of versioning but that means regularly changing your code to use the latest model version. I&#8217;m too lazy for that!

If we&#8217;re storing our R model objects in SQL Server then we can utilise another new SQL Server capability, [temporal tables][1], to take the pain out of versioning and make it super simple.

Temporal tables will track changes automatically so you would overwrite the previous model with the new one and it would keep a copy of the old one automagically in a history table. You get to always use the latest version via the main table but you can then write temporal queries to extract any version of the model that&#8217;s ever been implemented. Super neat!

For some of you, if you&#8217;re not interested in the technical details you can drop off now with the knowledge that you can store your models in a non-destructive but easy to use way in SQL Server if you need to.

If you want to see how it&#8217;s done, read on!

# The technical info

Below is a working example of how to do versioning R model objects in SQL Server:

  * define a versioned model table
  * write a model into the model table
  * create a new model and overwrite the old
  * create a prediction using the latest model on the fly

> Note this doesn&#8217;t tell you what changed, just that something did change. To identify model changes you will need to load up the models and compare their coefficients or other attributes to identify what exactly changed. 

## SQL objects

### A temporal table

A normal table for storing a model might look like

    CREATE TABLE [companyModels]    (  
      [id] int NOT NULL PRIMARY KEY CLUSTERED   
    , [name] varchar(200) NOT NULL      
    , [modelObj] varbinary(max)    
    , CONSTRAINT unique_modelname UNIQUE ([name]))
    

If we&#8217;re turning it into a temporal table we need to add some extra columns, but we won&#8217;t worry about these extra columns day-to-day.

<pre><code class="sql">CREATE TABLE [companyModels]    (  
  [id] int NOT NULL PRIMARY KEY CLUSTERED   
, [name] varchar(200) NOT NULL      
, [modelObj] varbinary(max)    
, [ValidFrom] datetime2 (2) GENERATED ALWAYS AS ROW START  
, [ValidTo] datetime2 (2) GENERATED ALWAYS AS ROW END  
, PERIOD FOR SYSTEM_TIME (ValidFrom, ValidTo)  
, CONSTRAINT unique_modelname UNIQUE ([name]))
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE = dbo.companyModelsHistory));  
</code></pre>

### A stored procedure

As we have the ID and Valid* columns in our table, we can&#8217;t use RODBCs simple table functions and the ID column doesn&#8217;t play nicely with RevoScaleR&#8217;s `rxWriteObject()` function as that wants to insert a NULL. It&#8217;s not all bad though because we can get around it by using a stored procedure.

This stored procedure will perform an INSERT if it can&#8217;t find a model by the given name, and will perform an UPDATE if it does find a match.

<pre><code class="sql">CREATE PROCEDURE modelUpsert
@modelname  varchar(200) , 
@modelobj varbinary(max) 
AS
WITH MySource as (
    select @modelname as modelName, @modelobj as modelObj
)
MERGE companymodels AS MyTarget
USING MySource
     ON MySource.modelname = MyTarget.modelname
WHEN MATCHED THEN UPDATE SET 
    modelObj = MySource.modelObj
WHEN NOT MATCHED THEN INSERT
    (
        modelname, 
        modelObj
    )
    VALUES (
        MySource.modelname, 
        MySource.modelObj
    );
</code></pre>

## R

### Build a model

We need a model to save!

To be able to store the model in the database we need to use the `serialize()` function to turn it into some raw character thingies and then combine them together with `paste0()` so they go in the same row.

<pre><code class="r">myModelV1&lt;-lm(column1~column2, someData)
preppedDF&lt;-data.frame(modelname="myModel",
                      modelobj=paste0(serialize(myModelV1,NULL)
                                      ,collapse = "")
                      )
</code></pre>

### Call the stored procedure

We need [RODBC]() and [RODBCext]() for executing our stored procedure in our database.

<pre><code class="r">library(RODBC)
library(RODBCext)

dbstring&lt;-'Driver={ODBC Driver 13 for SQL Server};Server=XXX;Database=XXX;Uid=XXX;Pwd=XXX'
dbconn&lt;-RODBC::odbcDriverConnect(dbstring)

RODBCext::sqlExecute(dbconn, "exec modelUpsert @modelname=? , @modelobj=?",
                      data = preppedDF)
</code></pre>

This will now have our model in our database table.

<pre><code class="r">RODBC::sqlQuery(dbconn, "select * from companymodels")
# 1 row
RODBC::sqlQuery(dbconn, "select * from companymodelshistory")
# 0 row
</code></pre>

You should get one row in our main table and no rows in our history table.

### Rinse and repeat

If we make a change to our model and then push the new model with the same name, we&#8217;ll still get one row in our core table, but now we&#8217;ll get a row in our history table that contains our v1 model.

<pre><code class="r">myModelV2&lt;-lm(column1~column2, someData[-1,])
preppedDF&lt;-data.frame(modelname="myModel",
                      modelobj=paste0(serialize(myModelV2,NULL)
                                      ,collapse = "")
)
RODBCext::sqlExecute(dbconn, "exec modelUpsert @modelname=? , @modelobj=?",
                     data = preppedDF)

RODBC::sqlQuery(dbconn, "select * from companymodels")
# 1 row
RODBC::sqlQuery(dbconn, "select * from companymodelshistory")
# 1 row
</code></pre>

## Using our model in SQL

If we want to use our model for predictions in SQL, we can now retrieve it from the table along with some input data and get back our input data plus a prediction.

<pre><code class="sql">DECLARE @mymodel VARBINARY(MAX)=(SELECT modelobj 
                FROM companymodels 
                WHERE modelname='mymodel'
                );
EXEC sp_execute_external_script
@language = N'R',  
@script = N'
OutputDataSet&lt;-cbind(InputDataSet,
    predict(unserialize(as.raw(model)), InputDataSet)
    )
',
@input_data_1 = N'SELECT 42 as column2',  
@params = N'@model varbinary(max)',  
@model =  @mymodel 
</code></pre>

 [1]: https://docs.microsoft.com/en-us/sql/relational-databases/tables/temporal-tables