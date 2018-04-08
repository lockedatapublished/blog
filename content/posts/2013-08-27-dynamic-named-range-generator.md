---
title: Dynamic named range generator
author: Steph

date: 2013-08-27T21:00:50+00:00
categories:
  - Misc Technology
tags:
  - Excel
  - macros
  - vba

---
**Why do I use <a title="Dynamic named ranges – the basics" href="https://itsalocke.com/index.php/dynamic-named-ranges-the-basics/" target="_blank">dynamic named ranges</a>?**

Where I work, most reports are exposed via a web front-end and Excel can create an external connection and retrieve the information.&nbsp; This is much safer than using direct database connections in workbooks.&nbsp; A problem with web queries though is that they cannot be converted to Tables in order for referencing columns and the dataset as a whole to be made easier.&nbsp; As a result, dynamic named ranges are a necessity for producing easy to develop and manage spreadsheets since the volumes in the raw data can change over time.

**How I save myself time**

A raw data table with 20 columns will take a long time to create the named ranges for, given that I want:

  1. A dynamic range covering the headers too for pivot tables
  2. A dynamic range without headers for vlookups
  3. A dynamic range for each column without headers

I use a macro, assigned to a nice button on my ribbon, to generate all the relevant ranges.

**What are the special considerations?**

Structure &#8211; raw data tables should ALWAYS be set up in a specific way &#8211; with the Primary Key on the left hand side and always filled in, with no empty rows or columns

Special characters &#8211; range names can&#8217;t contain special characters.&nbsp; The VBA uses the <a title="RegEx functions in VBA" href="https://itsalocke.com/index.php/regex-functions-in-vba/" target="_blank">RegEx</a> functionality to strip these out.

Numbers &#8211; range names can&#8217;t have numbers either.&nbsp; We can&#8217;t just strip out the numbers like we would special characters because they might be important like Grade1, Grade2 and Grade3 and collapsing them all to the name Grade would be a problem.&nbsp; Instead, the macro converts all numbers to the corresponding letter in the alphabet.

How much the data will grow?&nbsp; By default I set the macro to use 10 times the number of records present when I run the macro &#8211; if it&#8217;s already bigger than 25k rows, the number will need to be reduced, and if I don&#8217;t think 10 times the number will be adequate, I&#8217;ll increase the number.

<!--more-->

**What&#8217;s the code then?**

<pre lang="vb">#Const LateBind = True
Function RegExpSubstitute(ReplaceIn, _
        ReplaceWhat As String, ReplaceWith As String)
    #If Not LateBind Then
    Dim RE As RegExp
    Set RE = New RegExp
    #Else
    Dim RE As Object
    Set RE = CreateObject("vbscript.regexp")
        #End If
    RE.Pattern = ReplaceWhat
    RE.Global = True
    RegExpSubstitute = RE.Replace(ReplaceIn, ReplaceWith)
    End Function

Sub createRanges()
' Specify some upfront variables
rCol = ActiveSheet.UsedRange.Columns(1).Column
rRow = ActiveSheet.UsedRange.Rows(1).Row
sName = "'" & ActiveSheet.Name & "'!"
' This is where the row count gets multiplied to allow for growth
LastRow = (ActiveSheet.UsedRange.Rows.Count - 1) * 10
LastColumn = ActiveSheet.UsedRange.Columns.Count

' Build a cleansed sheetname for use in naming the raw data tables
sheetname = ActiveSheet.Name
sheetname = RegExpSubstitute(sheetname, "[^w+]", "")
sheetname = Replace(Replace(Replace(Replace(Replace(Replace(Replace(Replace(Replace(Replace(Replace(sheetname, "0", "a"), "1", "b"), "2", "c"), "3", "d"), "4", "e"), "5", "f"), "6", "g")
, "7", "h"), "8", "i"), "9", "j"), "|", "")

' Build the headered raw data range 
ActiveWorkbook.Names.Add Name:=sheetname, _
        RefersTo:="=Offset(" & sName & Cells(rRow, rCol).Address & ",0,0,counta(" _
        & sName & Cells(rRow, rCol).Address & ":" & Cells(LastRow, rCol).Address _
        & "),counta(" & sName & Cells(rRow, rCol).Address & ":" & Cells(rRow, LastColumn * 3).Address & "))"

' Build the headerless raw data range 
ActiveWorkbook.Names.Add Name:=sheetname & "HEADERLESS", _
        RefersTo:="=Offset(" & sName & Cells(rRow + 1, rCol).Address & ",0,0,counta(" _
        & sName & Cells(rRow + 1, rCol).Address & ":" & Cells(LastRow, rCol).Address _
        & "),counta(" & sName & Cells(rRow, rCol).Address & ":" & Cells(rRow, LastColumn * 3).Address & "))"

' Create individual columns ranges
While rCol &lt;= LastColumn
rangeName = Replace(Cells(rRow, rCol).Value, " ", "")
rangeName = RegExpSubstitute(rangeName, "[^w+]", "")
rangeName = Replace(Replace(Replace(Replace(Replace(Replace(Replace(Replace(Replace(Replace(Replace(rangeName, "0", "a"), "1", "b"), "2", "c"), "3", "d"), "4", "e"), "5", "f"), "6", "g")
, "7", "h"), "8", "i"), "9", "j"), "|", "")
ActiveWorkbook.Names.Add Name:=rangeName, _
    RefersTo:="=Offset(" & sName & Cells(rRow + 1, rCol).Address & ",0,0,counta(" & sName & Cells(rRow + 1, ActiveSheet.UsedRange.Columns(1).Column).Address & ":" & Cells(LastRow, ActiveSheet.UsedRange.Columns(1).Column).Address & "))"
rCol = rCol + 1
Wend

End Sub</pre>

&nbsp;

&nbsp;