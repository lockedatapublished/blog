---
title: 'Auto-deploying documentation: Rtraining'
author: Steph

date: 2015-12-23T10:25:48+00:00
categories:
  - Data Science
  - DataOps
  - R
tags:
  - auto deploying r documentation
  - best practices
  - continuous integration
  - git
  - knitr
  - presentation
  - r
  - rmarkdown
  - software development in r
  - travis-ci

---
In my [last post][1] on using GitHub, Travis-CI, and rmarkdown/knitr for automatically building and deploying documentation, I covered how I was able to do it with a containerised approach so things were faster. I also said my [Rtraining][2] repository was still too brittle to blog about. This has changed &#8211; WOO HOO!

The main thanks for that goes out to the new package [ezknitr][3] from [Dean Attali][4]. ezknitr takes the pain out of working directories, making my hierarchies much more resilient. I made a very simple reproduction of my scenarios in a repo called [ezknitrTest][5] &#8211; you can peruse it online or take a copy to play, but it essentially shows how you can use `ezknitr::ezknit` instead of `rmarkdown::render` and `knitr::knit`. It&#8217;s really handy!

So I went through and converted everything in my Rtraining to this and realised it messed up my slide decks &#8211; it&#8217;s been so long since I had built a pure knitr solution that I forgot that `rmarkdown::render` != `knitr::knit`. For my slidedecks, if I wanted the ioslides_presentation format, I needed to use `rmarkdown::render`. The problem with that has been the relative references to the CSS and the logo.

To solve this I read about the [custom render formats capability][6] and created a [function][7] that produces an ioslides_presentation but with my CSS preloaded by default. This now means that I can produce slides with better file referencing.

All in all, Rtraining is the culmination of my learnings over the past year of developing an analytical document pipeline that fits into my DataOps category. A summary of the features it uses are:

  * dynamic file identification
  * dynamic index page
  * custom render formats
  * custom CSS
  * ezknitr&#8217;d files
  * continuous integration
  * continuous deployment
  * containerised builds

It can now be browsed on [stephlocke/github.io/Rtraining][8].

* * *

### Posts in this series

  1. [Automated documentation hosting on github via Travis-CI][9]
  2. [Auto-deploying documentation: multiple R vignettes][10]
  3. [Auto-deploying documentation: FASTER!][1]
  4. [Auto-deploying documentation: Rtraining][11]
  5. [Auto-deploying documentation: better change tracking of artefacts][12]

* * *

PS If you&#8217;re looking to do a more book-like project, Hadley provides [bookdown][13] for your publication needs.

 [1]: https://itsalocke.com/auto-deploying-documentation-faster/
 [2]: https://github.com/stephlocke/Rtraining
 [3]: https://github.com/daattali/ezknitr
 [4]: https://twitter.com/daattali
 [5]: https://github.com/stephlocke/ezknitrTest
 [6]: http://rmarkdown.rstudio.com/developer_custom_formats.html
 [7]: https://github.com/stephlocke/Rtraining/blob/master/R/stephSlideStyle.R
 [8]: http://stephlocke.github.io/Rtraining/
 [9]: https://itsalocke.com/automated-documentation-hosting-on-github-via-travis-ci/
 [10]: https://itsalocke.com/auto-deploying-documentation-multiple-r-vignettes/
 [11]: https://itsalocke.com/auto-deploying-documentation-rtraining/
 [12]: https://itsalocke.com/auto-deploying-documentation-better-change-tracking-artefacts/
 [13]: https://github.com/hadley/bookdown