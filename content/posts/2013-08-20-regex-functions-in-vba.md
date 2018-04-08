---
title: RegEx functions in VBA
author: Steph

date: 2013-08-20T18:55:37+00:00
categories:
  - Misc Technology
tags:
  - Excel
  - macros
  - vba

---
Regular Expressions (RegEx) is a common string processing technique for handling strings that conform to patterns, as opposed to fixed strings.<figure style="width: 548px" class="wp-caption alignnone">

[<img alt="Perl Problems" src="http://imgs.xkcd.com/comics/perl_problems.png " width="548" height="205" />][1]<figcaption class="wp-caption-text">XKCD Perl Problems</figcaption></figure> 

It is an excellent set of functionality that is available in most programming languages, and even in SQL.  It is however not readily available in Excel or VBA.  This has it downsides if you&#8217;re trying to complex string matching and extraction, so in my personal workbook, I include the RegEx functions available at <http://www.tmehta.com/regexp/> .  These are utilised in my dynamic named range generating macro and have been a real life saver when faced with three different tabs of manual-entry logs that need the finding and identification of file references used in various places.

&nbsp;

Summary:

1) Learn about RegEx at <http://www.regular-expressions.info/>

2) Use it in your coding language of choice, and feel frustrated

3) Bring the frustrations and the benefits into VBA and Excel with <http://www.tmehta.com/regexp/>

 [1]: http://imgs.xkcd.com/comics/perl_problems.png