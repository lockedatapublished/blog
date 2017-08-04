---
title: Center across selection
author: Steph
type: post
date: 2013-05-24T15:23:29+00:00
categories:
  - Misc Technology
tags:
  - Excel
  - merge
  - ribbon
  - vba

---
Merging cells is easily done and can help make a spreadsheet look neat, but what you really, really should be doing instead is centering across the selection so it looks merged but isn&#8217;t. Center across selection though is hidden away and therefore time-consuming to use &#8211; no wonder people have bad habits! I wanted to do things the better way, but was lazy, so in the end I made a macro to go in my personal workbook and <a href="http://office.microsoft.com/en-gb/excel-help/assign-a-macro-to-a-button-HA102809517.aspx?CTT=1" title="Assign a button" target="_blank">assigned it to my ribbon</a> (I do this a lot).

The macro is

<pre lang="vb" line="1">Sub CenterAcrossSelection()

    With Selection
        .HorizontalAlignment = xlCenterAcrossSelection
        .VerticalAlignment = xlBottom
        .WrapText = False
        .Orientation = 0
        .AddIndent = False
        .IndentLevel = 0
        .ShrinkToFit = False
        .ReadingOrder = xlContext
        .MergeCells = False
    End With
End Sub
</pre>