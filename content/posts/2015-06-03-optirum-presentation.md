---
title: optiRum – presentation
author: Steph

date: 2015-06-03T15:00:31+00:00
categories:
  - Data Science
  - R
tags:
  - data visualisation
  - knitr
  - latex
  - optiRum
  - r

---
> <a href="http://cran.r-project.org/web/packages/optiRum/" title="optiRum on CRAN" target="_blank">optiRum</a>, the R package I built and support for Optimum on CRAN has gained some extra functions recently. Some of it uses currently experimental data.table functionality so I&#8217;m eagerly awaiting the release to CRAN to deliver optiRum.
> 
> In the interim, I thought I&#8217;d give some brief overviews of **existing** functionality contained in the package. 

The next part of <a href="https://itsalocke.com/optirum-gini-like-a-wizard/" target="_blank">the coverage</a> of <a href="https://github.com/stephlocke/optiRum" target="_blank">optiRum</a> functionality is to talk about the stuff that makes generating outputs easier!
  
<!--more-->

## cut2 in LaTeX

A minor thing but one that caused significant headaches is the wonderful `cut2()` function from [Hmisc][1]. `cut2()` is a more flexible boundary generating function that produces (IMO) better intervals i.e.

  * (0,5] is the `cut` interval and this means all numbers greater than 0 and less than or equal to 5
  * [0,5) is the `cut2` interval and this means all numbers greater than or equal to 0 and less than 5

The `cut2` way ensures there are fewer allocation issues due to rounding with a large number of decimal places. Unfortunately when you try to make a table of these in LaTeX, it thinks you&#8217;re trying to go into &#8220;maths mode&#8221;.

To avoid this I wrote a `sanitise()` function to replace the `sanitize()` function from [knitr][2] so that it will escape any `[` characters a table output from R. Whilst I was giving it a UK name (to save function masking issues), I also extended it to correctly handle the GBP symbol (`£`) since that was also an issue for us.

## Charts

**Opinion: if you&#8217;re using R, you should be using ggplot2 for charts**
  
Life is _much_ easier when using it. Get a very quick primer in <a href="http://stephlocke.github.io/Rtraining/chartintro.html" target="_blank" title="Steph Locke explains gpplot2 basics">my note</a> about building charts using it.

optiRum contains a `theme_optimum()` (after the company, not an adjective) that changes the ggplot2 default chart look. The ggplot2 themes are good to begin with, and others have extended it further e.g. [ggthemes][3], but we wanted a standard within our company that we could use for charts. There were some considerations:

  * colleagues love to print, despite best efforts to dissuade them, but to meet IT halfway they print 4 A4 pages per sheet (2 pages on each side) so the chart labels need to be legible when printed to less than 50% of their intended size
  * a lot of our charts are over time and colleagues like to compare values so having y-axis grid lines can aid them
  * labels whilst needing to be legible should be de-emphasised to help keep focus on the chart&#8217;s message
  * as much of the plot area should be given over to the chart as possible so space for legends should be minimised
  
    <figure id="attachment_61325" style="width: 1000px" class="wp-caption alignnone">[<img src="../img/optimum_adk38b.png" alt="ggplot2 example charts" width="1000" height="333" class="size-full wp-image-61325" />][4]<figcaption class="wp-caption-text">ggplot2 example charts</figcaption></figure>

[gist https://gist.github.com/stephlocke/fb8dd7c819aa11cc222c ]

## Generate PDFs

Using knitr to integrate analysis and content via LaTeX is fantastic. Unfortunately, where we can end up with some pretty complex documents, we often need to make multiple passthroughs of documents to fully typeset.

The handy &#8220;Compile PDF&#8221; button in Rstudio, whilst great for simple documents could end up not doing enough passthroughs. At the same time it would generate lots of extra files and you&#8217;d have no control over the file name when it was generated.

To get around this I first used build scripts that did a lot of compensating work around the `knit2pdf()` function to do the various bits and pieces. This became relatively standard but there would be exceptions or different people would write date suffixes differently. `generatePDF()` is my answer to the various issues we encountered, including some pesky environment interactions with data.table.

`generatePDF()` takes the following arguments (lots have defaults):

  * `srcpath` is a folder relative to the current directory so that you don&#8217;t have to change working directories
  * `srcname` is the file name, less the Rnw extension, as it was easier to type plus enforced the use case
  * `destpath` is the output folder, again relative to the current directory, to give better routing as we rarely wanted the PDF amongst the source code
  * `destname` is the file name we want the document output as (less `.pdf`) so that we&#8217;re no reliant on the source file&#8217;s name
  * `DATED` gives a date suffix to the file meaning different versions can generated over different days with unique file references (enabling the way some folks were, or provided model variants over time)
  * `CLEANUP` says whether to remove all the pesky extra files that generating a PDF can produce
  * `QUIET` allows you to produce a PDF with less console activity, making it less burdensome for automated tasks
  * more like environment and passthroughs to `knit2pdf()`

## Get the package

  * Install from CRAN: `install.packages(optiRum)`
  * Install the dev version from the github repository using devtools: `devtools::install_github("stephlocke/optiRum")`

 [1]: http://cran.r-project.org/web/packages/Hmisc/index.html
 [2]: http://cran.r-project.org/web/packages/knitr/index.html
 [3]: http://cran.r-project.org/web/packages/ggthemes/index.html
 [4]: ../img/optimum_adk38b.png