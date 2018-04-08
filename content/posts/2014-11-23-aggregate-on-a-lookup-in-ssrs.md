---
title: Aggregate on a Lookup in SSRS
author: Oz

date: 2014-11-23T12:59:13+00:00
dsq_thread_id:
  - 3715896612
categories:
  - Microsoft Data Platform
tags:
  - code
  - hacks
  - lookup
  - SSRS
  - VB

---
## The What

If you need to join multiple datasets inside SSRS, perhaps because of different sources, grains of detail etc, then you often need to aggregate over both datasets.

In SSRS, you can easily perform aggregations over another dataset but it can be tough to do this based on a grouping factor in your main dataset.

A key example of this might be Sales and Purchases &#8211; you want to show both of these by month but they come from two different data sources.

You could build two tables that appear to be just one table but this can be really clunky. Instead, you want just one table with the month, the total sales, and the total purchases in.

Although there&#8217;s no tidy way of doing this built in, you have the power to add your own functions to SSRS using the Code window of the report&#8217;s properties. Provided here is a block of VB script that can be added to your SSRS report to allow you to do those tricky aggregations as if they were just another built in function.

I call it AggLookup.

<!--more-->

## Adding the code

To use this code, it needs to be added to the custom code of the report. To do that:

  1. right click in the area behind the report
  2. select Properties
  3. select Code
  4. copy and paste the below into the Code window
  5. hit OK

## The Code

The code is quite long so I have provided it on [github.com/OzLocke/SSRSAggLookup][1].

This means you can get it from GitHub, log issues with it, and can even contribute improvements to it. If you&#8217;ve not used GitHub before, check out the handy [Getting Started guides][2].

## How to use it

All you need to do to use this code is enter the following expression into a cell:

`=code.AggLookup([aggregation], LookupSet([localValue], [matchValue], [returnValue], [dataset]))`

The aggregation should be entered in lower case, as a string, and the available aggregations are `count`, `sum`, `min`, `max` and `avg`.

So this would allow you to do build a table for your Sales data grouped by month and then sum the Purchase data by that month also, so the figures are unified into one table.

This also has the advantage of enabling dynamic aggregations via a parameter containing the aggregation names for both primary and secondary data sets which is easier than writing `SWITCH` statements that swap functions.&nbsp;This means you can have one report that shows the counts or sums of values depending on the user&#8217;s preference without having to maintain multiple reports or a much bigger report.

 [1]: https://github.com/OzLocke/SSRSAggLookup
 [2]: https://guides.github.com/