---
title: Dynamic named ranges – the basics
author: Steph

date: 2013-07-27T19:55:47+00:00
categories:
  - Misc Technology
tags:
  - Excel

---
**Whoah nelly, what&#8217;s a _named range_ first of all let alone a dynamic one?**

A named range is a shorthand or alias for a set of cells in Excel.  These can be created easily by simply selecting one or more cells and using the name box to give it whatever name you feel relevant.  This alias can then be used in formula to make something much more insightful like =A1_VAT as opposed to =A1_0.2<figure id="attachment_58201" style="width: 254px" class="wp-caption alignnone">

[<img class="size-full wp-image-58201" alt="Excel nav bar" src="../img/2013-08-27-20_13_19-Microsoft-Excel-Book1_xkzrvi_calvkf.png" width="254" height="102" />][1]<figcaption class="wp-caption-text">Excel name box</figcaption></figure> 

For more info on these, I can highly recommend the Contextures blog and video:



**Ok, so what&#8217;s a dynamic named range?**

A dynamic named range is one that can grow or shrink dependant how much data there is, instead of a fixed size.

**What&#8217;s the point?**

This allows you to build pivot table connections that always select the relevant amount of data, it allows you create dropdown list for validation that can be easily updated, and it allows you to produce cleaner formula.  There are many other uses including producing charts with the last X entries showing only.

**So, how do I do it?**

You need two functions COUNTA and OFFSET

  * COUNTA (as opposed to just COUNT which will only count numbers) will work out how many rows (or columns) need to be included in the range
  * OFFSET will build the range of cells needed based on a starting cell and some info how the range needs to be built

A dynamic named range formula looks like

=OFFSET(<span style="color: #cc9900;">Sheet1!</span><span style="color: #3366ff;">$A$1</span>, <span style="color: #339966;">0,0,</span> <span style="color: #ff9900;">COUNTA(<span style="color: #cc9900;">Sheet1!</span>$A$1:$A$1000)</span>)

<span style="color: #3366ff;">The start point</span>

<span style="color: #339966;">How many rows and columns it needs to move</span>

<span style="color: #ff9900;">How many rows it needs to extend &#8211; no need to use $A:$A since this uses unnecessary processing power</span>

<span style="color: #cc9900;">Included to allow the formula to be hardcoded to a specific range in a sheet</span>

&nbsp;

&nbsp;

 [1]: ../img/2013-08-27-20_13_19-Microsoft-Excel-Book1_xkzrvi_calvkf.png