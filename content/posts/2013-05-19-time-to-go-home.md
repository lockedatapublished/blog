---
title: Time to go home…
author: Steph
type: post
date: 2013-05-19T15:19:04+00:00
categories:
  - Misc Technology
tags:
  - Excel
  - macros
  - vba

---
I do a lot of work in spreadsheets and some cannot be left open on my PC as that&#8217;d make them locked for the morning report refresh. After a bunch of times having to buy cakes for so delaying the reports, I put something in place to stop it. It also had the very nice side effect of telling me to go home.

The first thing to do is make sure you have a <a href="http://bit.ly/14F9j9y" title="how to make a personal workbook" target="_blank">personal workbook</a>. Then you need to add code in two places.

This code goes in the ThisWorkbook object:

<pre lang="eb" line="1">Private Sub Workbook_Open()
'Feel free to change the time - I just like to be a 9 to 5er  
Application.OnTime TimeValue("17:15:00"), Procedure:="gohome"
End Sub
</pre>

Then, this code goes in one of your modules:

<pre lang="eb" line="1">Sub gohome()
 
Dim WB As Workbook
For Each WB In Workbooks
'Change pathfile to your preferred destination.  Doesn't just Save as you may not want the changes confirmed without your say so
pathfile = "C:UsersslockeDesktop"
namefile = WB.Name
If Not WB.Name = ThisWorkbook.Name Then
 
WB.SaveAs Filename:=pathfile & namefile, addtomru:=True
WB.Close savechanges:=False
End If
Next WB
'Change message, or delete line 
MsgBox("I just had to close your spreadsheets. You'd better go meet Oz since you're late! ")

End Sub
</pre>

The result is a macro that will save to your preferred location any spreadsheet still open at the time you think you should be going home. It saves to my desktop by default so that I don&#8217;t make any changes accidentally.
