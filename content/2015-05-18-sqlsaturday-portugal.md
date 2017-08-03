---
title: SQLSaturday Portugal
author: Steph
type: post
date: 2015-05-18T09:42:13+00:00
categories:
  - Community
tags:
  - '#statuspost'
  - agile
  - azure
  - azure data factory
  - conferences
  - presentation
  - presenting

---
[SQLSaturday Portugal 2015][1] has been a huge amount of fun but I&#8217;ve also learnt a lot. A big thank you to the organisers!

Below are my slides and notes from sessions I attended.

## Agile BI

My session slides:



<!--more-->

## Azure data factory &#8211; Allan Mitchell ([@allanSQLIS][2])

My key takeaways filtered by my view of automating everything and ideally doing weird stuff with R

  * Data Factory has an object model stored in JSON so JSON knowledge required
  * Programmatic access via PowerShell
  * w00t &#8211; there&#8217;s an API! Bring on more crazy Azure/R API fun!
  * Extend data factory with C# .dlls by adding in a zip file, hosted in azure storage
  * We could end up with a market place of extensions for data factory

## DAX as BI enabler &#8211; Bruno Basto ([@bvbrasto][3])

Having used PowerPivot I was interested in finding out more about it in it&#8217;s tabular model server version. The key things of use were

  * DirectQuery mode in the server version has connection limitations
  * Next version of tabular will allow many-to-many relationships. Woohoo!
  * Ordering data, before loading in column stores, can aid compression making tabular (and Excel) models smaller
  * [DAXstudio][4] is a really useful IDE for DAX
  * You can import PowerPivot models from SQL Server using restore backup from PowerPivot functionality
  * The [BISM Server Memory Report][5] is pretty useful!
  * Can filter existing measures with CALCULATE for cleaner functionality e.g. `Total:=count(tbl[val]), TotalF:=calculate([Total],tbl[fil]=1)`
  * It&#8217;s possible to return text in a PowerPivot function!!
  * DAX queries evaluate out &#8211;> in, opposite to SQL, algebra and so on

 [1]: http://www.sqlsaturday.com/369/EventHome.aspx
 [2]: https://twitter.com/allansqlis
 [3]: https://twitter.com/bvbasto
 [4]: https://daxstudio.codeplex.com
 [5]: http://www.powerpivotblog.nl/what-is-using-all-that-memory-on-my-analysis-server-instance/