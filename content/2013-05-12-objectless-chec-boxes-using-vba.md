---
title: Objectless Check Boxes using VBA
author: Oz
type: post
date: 2013-05-12T14:03:09+00:00
dsq_thread_id:
  - 3720570217
categories:
  - Misc Technology
tags:
  - check boxes
  - Excel
  - macros
  - tick
  - vba

---
For my first ever blog post (be gentle with me!) I wanted to talk about an issue I have with Excel’s check box object, and my way of resolving it. It’s not perfect, and I’d love to hear of any other versions or ideas you may have. So here&#8217;s how I create check boxes in Excel without using Excel check boxes.

&nbsp;

## The Problem with Check Box Objects

They look good and they work well, there’s no denying they do what they’re supposed to, but they also annoy the heck out of me!

<li style="list-style-type: circle;">
  As far as I’ve been able to find they can’t be properly bound to a cell; this means if you want to get rid of them you need to select them and delete them, which can be a big job
</li>
<li style="list-style-type: circle;">
  If you want to refer to their state in simple terms you need to add a linked cell and refer to that, which to me is just plain messy
</li>
<li style="list-style-type: circle;">
  They’re awkward to format and style and if you want a big tick you need a big box and as such you need a big cell… again, messy
</li>

&nbsp;

<span style="color: #99cc00;"><!--more--></span>

## My solution; Objectless Check Boxes

So I wanted to create a way of adding a tick straight into a cell, and be able to add it or remove it by clicking the cell. Simple. I wanted to do this with VBA, and I wanted it to be as dynamic as possible. To do this I utilised the function BeforeDoubleClick, the condition If Not Application.Intersect and the ActiveCell cell reference.

I created a table that included a column for the tick boxes:

[<img class="size-full wp-image-1061 aligncenter" title=" The table in action!" alt="A table with ticked and unticked boxes" src="http://res.cloudinary.com/lockedata/image/upload/v1499851103/Table-Image_zrre67_gbdy4v.png" width="525" height="198" />][1]

To create the ticks I simply set the font for that column to Marlett because a letter a in Marlett creates that lovely tick. Then I used conditional formatting, using the simplest of formulas: =$E3=”a” to set the cells to green with cream text if the cell gets ticked. And that’s the table done. Time for the code!

So here it is:

<pre lang="vb" line="1">Private Sub Worksheet_BeforeDoubleClick(ByVal Target As Range, Cancel As Boolean)
'Auto Tick macro
'Ticks or unticks a Done? cell if double clicked

'The Macro:
    'Detects if the active cell is within the range of the desired columns and only continues if it is
If Not Application.Intersect(ActiveCell, Worksheets("Requests").Range("RequestData[Done]")) Is Nothing Then

    'Unticks the cell if it is currently ticked
If ActiveCell.Value = "a" Then
ActiveCell.Value = ""

    'Ticks the cell if it is currently unticked
Else
If ActiveCell.Value = "" Then
ActiveCell.Value = "a"

    'End of macro
    End If
    End If
    End If
    Cancel = True
    End Sub</pre>

&nbsp;

The code is put in the sheet the table is on.

The function Worksheet_BeforeDoubleClick operates by detecting a double click anywhere within the sheet (and yes, this does mean you can’t use double clicks for anything else in the sheet) and runs the code. I use BeforeDoubleClick because I started off using a detect cell change function but that triggered even if you just passed over a cell with the arrow keys, which I found to be quite annoying, especially in another table I have that allows ticking colours used and as such has five columns (yep, the five colours of land in Magic the Gathering, I have a workbook for MTG, I’m that sad!)

The condition If Not Application.Intersect looks to see if the cell you just double clicked is within the range of the Done? Column and if not then skips to the end of the macro. You may want to find a way to set the range dynamically, but for simplicity I’ve just set a long column length. The next line will ensure we can’t tick boxes further down the column than the table goes.

Next up we have a simple ActiveCell.Offset value check. This looks three column s over to the left of the cell you clicked to see if it is populated. If it isn’t the macro assumes you have clicked further down the column than is needed and skips the macro if it finds that you did indeed click outside of the table. Again, coming up with a way of making the column range dynamic (I assume you’d use a dynamic named range as a function) you wouldn’t need this step.

We then check to see if the cell is ticked or unticked, this way if the cell is ticked already then double clicking it again will untick it. All the macro does is set the cell value to a.

Then we just wrap up the macro. Done!

&nbsp;

## Conclusion

Like I said, there are probably better ways of doing this, and I invite you all to share your ideas on that here, but for my own purposes this works really well. Most importantly it resolves the issues I have with using Excel check boxes.

As a final note, if you are using Excel 2003 change the table range to a range of cells, so for instance change `ToDo[Done]` to `$F$2:$F$400`.

And if you want to have multiple tick box columns simply change the table range to reflect this, so change:

<pre lang="vb" line="1">If Not Application.Intersect(ActiveCell, Worksheets("Requests").Range("RequestData[Done]")) Is Nothing Then</pre>

to

<pre lang="vb" line="1">If Not Application.Intersect(ActiveCell, Worksheets("Requests").Range("RequestData[Started]:RequestData[Done]")) Is Nothing Then</pre>

If doing this I found it helps to interchange the colour of the ticks:

[<img class="size-full wp-image-1061 aligncenter" title=" The table in action!" alt="A table with ticked and unticked boxes" src="http://res.cloudinary.com/lockedata/image/upload/v1499851103/Table-Image_zrre67_gbdy4v.png" />][1]

&nbsp;

&nbsp;

 [1]: http://res.cloudinary.com/lockedata/image/upload/v1499851103/Table-Image_zrre67_gbdy4v.png