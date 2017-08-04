---
title: optiRum 0.37.1 now out
author: Steph
type: post
date: 2015-11-07T19:26:10+00:00
categories:
  - R
tags:
  - '#statuspost'
  - optiRum
  - r
format: aside

---
A while back, I [wrote about how I was waiting][1] to be able to release [optiRum][2] to CRAN, well data.table 1.9.6 was released (a key dependency for new functionality) and I&#8217;ve finally had some quiet time. So optiRum 1.37.1 is now accepted and trickling through the CRAN publish processes.
  
<!--more-->

The package optiRum started out when I worked for [Optimum Credit][3] as a means to give back as we used R a lot. Optimum still use R but for now I&#8217;m still the package maintainer for them.

optiRum has the following key areas of functionality:

  * Financial calcs, like Present Value ([`PV`][4]) 
  * Credit scoring & logistic regressions, like convert from logit to probability ([`logit.prob`][5]) and producing gini charts ([`giniChart`][6])
  * Miscellaneous helper functions, like converting a data.table to XML ([`convertToXML`][7]) and character cleansing for LaTeX tables([`sanitise`][8])

We added functionality for calculating net income in the UK ([`calcNetIncome`][9]). This takes:

  * a data.table of 1 or more people, belonging to 1 or more households (for child tax benefits etc)
  * the level of granularity information is provided at (default is monthly)
  * the year you&#8217;re calculating for
  * any modelling factors you want to trial
  * two data.tables containing general thresholds and tax thresholds

For the most part, only the gross income data.table needs to be provided if you want to do current year modelling. It&#8217;s a fairly complex calculation given all the moving parts and we have checked it against various income calculators but please [file an issue][10] if you find yourself encountering problems or inaccuracies.

 [1]: https://itsalocke.com/optirum-gini-like-a-wizard/
 [2]: https://github.com/stephlocke/optiRum
 [3]: https://www.optimumcredit.co.uk/
 [4]: https://github.com/stephlocke/optiRum/blob/master/R/PV.R
 [5]: https://github.com/stephlocke/optiRum/blob/master/R/logit.prob.R
 [6]: https://github.com/stephlocke/optiRum/blob/master/R/giniChart.R
 [7]: https://github.com/stephlocke/optiRum/blob/master/R/convertToXML.R
 [8]: https://github.com/stephlocke/optiRum/blob/master/R/sanitise.R
 [9]: https://github.com/stephlocke/optiRum/blob/master/R/calcNetIncome.R
 [10]: https://github.com/stephlocke/optiRum/issues/new