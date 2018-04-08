---
title: Database / BI related unit testing options
author: Steph

date: 2014-11-06T16:18:48+00:00
categories:
  - Microsoft Data Platform
tags:
  - best practices
  - continuous integration
  - mssql
  - sql server
  - ssas
  - ssis
  - SSRS
  - unit testing

---
A quick list of frameworks available for doing unit testing, based on what I covered in today&#8217;s [SQL Lunch][1]

## MSFT

### Database projects

Purpose: unit testing database objects
  
Method: SQL / GUI
  
Site: <http://msdn.microsoft.com/en-us/library/jj851200(v=vs.103).aspx>
  
Cost: Free
  
Pros: Built-in, quite well documented
  
Cons: Requires Visual Studio 2010 Pro or above

## Codeplex

### ssisUnit

Purpose: SSIS unit testing
  
Method: XML / GUI
  
Site: <https://ssisunit.codeplex.com>
  
Cost: Free
  
Pros: Unique
  
Cons: As of writing, only stable version was released in 2008

### BI.Quality

Purpose: unit testing of outputs/results
  
Method: XML / GUI
  
Site: <a href="http://biquality.codeplex.com/" target=_blank>http://biquality.codeplex.com/</a>
  
Cost: Free
  
Pros: Well documented, comprehensive
  
Cons: No recent commits

### unitTestSSRS

Purpose: SSRS unit testing
  
Method: XML
  
Site: <http://unittestssrs.codeplex.com/>
  
Cost: Free
  
Pros: Unique
  
Cons: Documentation isn&#8217;t great, no recent commits

## Others

### tSQLt

Purpose: database object unit testing
  
Method: SQL query execution
  
Site: <http://tsqlt.org/>
  
Cost: Free
  
Pros: SQL, extensive, great documentation, well supported, open source
  
Cons: No GUI

### SQL Test

Purpose: database unit testing
  
Method: GUI / SQL
  
Site: <http://www.red-gate.com/products/sql-development/sql-test/>
  
Cost: £225 per user
  
Pros: GUI, uses tSQLt, has SQL Cop for testing some bad design practices
  
Cons: Costs money

### BI-xPress

Purpose: SSIS unit testing
  
Method: GUI / SQL
  
Site: <http://pragmaticworks.com/Products/BI-xPress>
  
Cost: ~£600 per user
  
Pros: GUI, extensive, lots of other features
  
Cons: Costs money

 [1]: http://www.meetup.com/Cardiff-SQL-Server-User-Group/