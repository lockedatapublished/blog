---
title: 'Synchronising schema between MSSQL & MySQL with SSIS'
author: Steph
type: post
date: 2013-05-29T16:25:47+00:00
dsq_thread_id:
  - 3718714922
categories:
  - Microsoft Data Platform
tags:
  - datawarehouse
  - mssql
  - mysql
  - ssis

---
The problem:

A system we need to report on that is form based.  Whenever there is a new form, there is a new table, and whenever there is a new or amended* field on the form, there is a new column in the table.  Maintaining the imports of this data into a staging environment would require a lot of code and time to build manually from scratch.

What is required is something that goes through the two schema for all relevant objects and updates our staging area’s schema accordingly.

Points for consideration:

  * Due to the level of change in source system, all loads are dynamically generated SQL
  * Loads run from a data dictionary table, which needs to be updated when we update the schema
  * Loads occur daily

<!--more-->

## Group_concat

On top of existing mysql requirements, we need group_concat – a brilliant function and very useful in this situation.  It is set so that tables with lots of measures can have all the names collapsed into one string without truncation

[<img class="alignnone size-medium wp-image-8491" src="http://res.cloudinary.com/lockedata/image/upload/h_208,w_300/v1499851244/schemasync-pic1_zgmzho_rfaglu.jpg" alt="schemasync - pic1" width="500" height="347" />][1]

## Second up: list of key objects

[<img class="alignnone size-medium wp-image-8511" src="http://res.cloudinary.com/lockedata/image/upload/h_254,w_300/v1499851246/schemasync-pic2_iwfjp1_mlkfqo.jpg" alt="schemasync - pic2" width="500" height="423" />][2]

[<img class="alignnone size-medium wp-image-8521" src="http://res.cloudinary.com/lockedata/image/upload/h_86,w_300/v1499851247/schemasync-pic3_erycfu_qwnsb9.jpg" alt="schemasync - pic3" width="500" height="143" />][3]

## Enumerate through key objects

[<img class="alignnone size-full wp-image-8531" src="http://res.cloudinary.com/lockedata/image/upload/v1499851248/schemasync-pic4_suuixn_jro3e9.png" alt="schemasync - pic4" width="238" height="337" />][4]

[<img class="alignnone size-medium wp-image-8541" src="http://res.cloudinary.com/lockedata/image/upload/h_252,w_300/v1499851249/schemasync-pic5_nmekei_bwqno9.jpg" alt="schemasync - pic5" width="500" height="419" />][5]

&nbsp;

## Drop existing table

Because it’s easier to drop and recreate a table rather than alter it, I proceed to drop and recreate the table &#8211; don&#8217;t do this on tables you report directly from! [<img class="alignnone size-medium wp-image-8551" src="http://res.cloudinary.com/lockedata/image/upload/h_255,w_300/v1499851250/schemasync-pic6_oeekzw_tk35t6.jpg" alt="schemasync - pic6" width="500" height="424" />][6]

Use a variable to make sql dynamic

[<img class="alignnone size-medium wp-image-8561" src="http://res.cloudinary.com/lockedata/image/upload/h_255,w_300/v1499851251/schemasync-pic7_nd0bpp_tzshhe.jpg" alt="schemasync - pic7" width="500" height="424" />][7]

**DropTableSQL** <&#8211; &#8220;drop table if exists worksmart_&#8221;+ @[User::TableToCheck]

## Data flow task: update data dictionary

[<img class="alignnone size-medium wp-image-8571" src="http://res.cloudinary.com/lockedata/image/upload/h_284,w_300/v1499851252/schemasync-pic8_ym6xzk_ccivzs.png" alt="schemasync - pic8" width="500" height="473" />][8]

In Source tasks, dummy sql is required:

<pre>SELECT 
ltrim(lower(COLUMN_NAME)) as systemfield, 
DATA_TYPE
FROM    INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME ='TableToCheck' 
AND data_type&lt;&gt;'image' 
AND COLUMN_NAME NOT IN ('function','pref_name') 
ORDER BY replace(column_name,'_','')</pre>

You will then need to add an expression on the data flow task for the sql to actually pull from a variable:
  
[<img class="alignnone size-medium wp-image-8581" src="http://res.cloudinary.com/lockedata/image/upload/h_292,w_300/v1499851253/schemasync-pic9_r6jtul_od3ib0.jpg" alt="schemasync - pic9" width="500" height="486" />][9]
  
**WorksmartColumnDataSQL** <-

<pre>"SELECT 
ltrim(lower(COLUMN_NAME)) as systemfield, 
DATA_TYPE
FROM    INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME ='TableToCheck' 
AND data_type&lt;&gt;'image' 
AND COLUMN_NAME NOT IN ('function','pref_name') 
ORDER BY replace(column_name,'_','')"</pre>

### Left join data to identify what is already present

[<img class="alignnone size-medium wp-image-8591" src="http://res.cloudinary.com/lockedata/image/upload/h_282,w_300/v1499851254/schemasync-pic10_ap6uyr_zaeeul.jpg" alt="schemasync - pic10" width="500" height="470" />][10]

### Only get new entries

[<img class="alignnone size-medium wp-image-8601" src="http://res.cloudinary.com/lockedata/image/upload/h_156,w_300/v1499851255/schemasync-pic11_vfhh2a_mqeqbr.jpg" alt="schemasync - pic11" width="500" height="259" />][11]

Nb – At this point I go onto add some more details but this is a similar step to above so I won’t cover it

### Add extra columns as required

[<img class="alignnone size-medium wp-image-8611" src="http://res.cloudinary.com/lockedata/image/upload/h_248,w_300/v1499851256/schemasync-pic12_wazpuq_pohswy.jpg" alt="schemasync - pic12" width="500" height="413" />][12]

### Insert into destination

## Create table based on new metadata

Same mechanism as dropping a table – a sql task, and a variable
  
**TableCreationSQL** <-

<pre>"select 
concat(' create table ', table,' (',
GROUP_CONCAT(concat(Field, ' ', fieldtype,' comment ''',coalesce(fielddescription,''),'''')),
coalesce(concat(', primary key(',(
             select group_concat(field) 
             from _data_dictionary d2 
             where d2. table=d. able 
             and d2.Is_PrimaryKey='y' 
             group by table),')'),''), ') 
ENGINE=MyISAM DEFAULT CHARSET=latin1 COLLATE=latin1_general_ci') 
FROM _data_dictionary d 
where systemtable='"+ @[User::TableToCheck] +
"' group by table"</pre>

The Result Set is then passed to the next variable to be executed

## Perform table creation

As above but no mapping, and ActualTableCreationSQL is used

[<img class="alignnone size-full wp-image-8501" src="http://res.cloudinary.com/lockedata/image/upload/v1499851245/schemasync-pic13_y1qg3h_eaqxfz.jpg" alt="schemasync - pic13" width="624" height="533" />][13]

 [1]: http://itsalocke.wpengine.com/wp-content/uploads/2015/04/schemasync-pic1_zgmzho.jpg
 [2]: http://itsalocke.wpengine.com/wp-content/uploads/2015/04/schemasync-pic2_iwfjp1.jpg
 [3]: http://itsalocke.wpengine.com/wp-content/uploads/2015/04/schemasync-pic3_erycfu.jpg
 [4]: http://res.cloudinary.com/lockedata/image/upload/v1499851248/schemasync-pic4_suuixn_jro3e9.png
 [5]: http://itsalocke.wpengine.com/wp-content/uploads/2015/04/schemasync-pic5_nmekei.jpg
 [6]: http://itsalocke.wpengine.com/wp-content/uploads/2015/04/schemasync-pic6_oeekzw.jpg
 [7]: http://itsalocke.wpengine.com/wp-content/uploads/2015/04/schemasync-pic7_nd0bpp.jpg
 [8]: http://itsalocke.wpengine.com/wp-content/uploads/2015/04/schemasync-pic8_ym6xzk.png
 [9]: http://itsalocke.wpengine.com/wp-content/uploads/2015/04/schemasync-pic9_r6jtul.jpg
 [10]: http://itsalocke.wpengine.com/wp-content/uploads/2015/04/schemasync-pic10_ap6uyr.jpg
 [11]: http://itsalocke.wpengine.com/wp-content/uploads/2015/04/schemasync-pic11_vfhh2a.jpg
 [12]: http://itsalocke.wpengine.com/wp-content/uploads/2015/04/schemasync-pic12_wazpuq.jpg
 [13]: http://res.cloudinary.com/lockedata/image/upload/v1499851245/schemasync-pic13_y1qg3h_eaqxfz.jpg