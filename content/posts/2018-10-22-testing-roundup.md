---
title: Packages for Testing your R Package
author: maelle
type: post
date: "2018-10-22"
spacious_page_layout:
  - default_layout
categories:
  - Data Science
  - R
tags:
  - r

---

Testing your R package is crucial, and thankfully it only gets easier with time, thanks to your getting experience... and awesome packages helping you setup and improve tests! In this post, we shall offer a roundup of packages for testing R packages, first in a section about general testing setup, and then in a section about testing "peculiar" stuff.

# General package testing infrastructure

## Create tests

If you're brand-new to unit testing your R package, I'd recommend reading [this chapter from Hadley Wickham's book about R packages](http://r-pkgs.had.co.nz/tests.html). 

There's an R package called `RUnit` for unit testing, but in the whole post we'll see resources around the [`testthat` package](https://github.com/r-lib/testthat) since it's the one we use in our packages, and arguably the most famous one. `testthatr` is fantastic. Don't hesitate to reads its docs again if you started using it a while ago, since the [latest major release](https://www.tidyverse.org/articles/2017/12/testthat-2-0-0/) e.g. added the `setup()` and `teardown()` functions to run code before and after all tests, very handy.

To setup testing in an existing package i.e. creating the test folder and adding `testthat` as a dependency, run [`usethis::use_testthat()`](http://usethis.r-lib.org/reference/use_testthat.html). In our WIP [`pRojects` package](https://github.com/lockedata/pRojects), we set up the tests directory for you so you don't forget. Then, in any case, add new test for a function using `usethis::use_test()`.

The [`testthis` package](https://github.com/s-fleck/testthis) might help make your testing workflow even smoother. In particular, `test_this()` "reloads the package and runs tests associated with the currently open R script file.", and there's also a function for opening the test file associated with the current R script.

## Assess your tests

To get a sense of how good your tests are, check out

* [`covr`](https://github.com/r-lib/covr) that computes the _test coverage_ i.e. the percentage of lines of code that are covered by tests. `covr` allows skipping some lines. If run on say Travis or Appveyor, it can send a report to online coverage tools such as CodeCov or Coveralls, allowing you to visualize the coverage. At Locke Data we mostly don't run `covr` locally but instead have it run on Travis. To set that up, [`usethis::use_coverage()`](http://usethis.r-lib.org/reference/ci.html). 

    Here is [Coveralls report for `HIBPwned`](https://coveralls.io/github/lockedata/HIBPwned?branch=master) and [the corresponding badge](https://github.com/lockedata/hibpwned#hibpwned). See a [CodeCov report for comparison](https://codecov.io/github/ropensci/Ropenaq?branch=master).
    
* [`covrpage`](https://github.com/yonicd/covrpage) that creates a detailed coverage report that can serve as a README for your test folder. We've now done that [for `HIBPwned`](https://github.com/lockedata/HIBPwned/tree/master/tests#tests-and-coverage) so now without clicking in a coverage report, thanks to "detailed test results" you can see the tests associated with each context.