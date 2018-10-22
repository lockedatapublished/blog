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
  - Package Development
tags:
  - r
  - package development
  - testing
  - testthat

---

Testing your R package is crucial, and thankfully it only gets easier with time, thanks to experience... and awesome packages helping you setup and improve tests! In this post, we shall offer a roundup of packages for testing R packages, first in a section about general testing setup, and then in a section about testing "peculiar" stuff.

# General package testing infrastructure

## Create tests

If you're brand-new to unit testing your R package, I'd recommend reading [this chapter from Hadley Wickham's book about R packages](http://r-pkgs.had.co.nz/tests.html). 

There's an R package called `RUnit` for unit testing, but in the whole post we'll mention resources around the [`testthat` package](https://github.com/r-lib/testthat) since it's the one we use in our packages, and arguably the most popular one. `testthat` is great! Don't hesitate to reads its docs again if you started using it a while ago, since the [latest major release](https://www.tidyverse.org/articles/2017/12/testthat-2-0-0/) added the [`setup()` and `teardown()` functions](http://testthat.r-lib.org/reference/teardown.html) to run code before and after all tests, very handy.

To setup testing in an existing package i.e. creating the test folder and adding `testthat` as a dependency, run [`usethis::use_testthat()`](http://usethis.r-lib.org/reference/use_testthat.html). In our WIP [`pRojects` package](https://github.com/lockedata/pRojects), we set up the tests directory for you so you don't forget. Then, in any case, add new tests for a function using `usethis::use_test()`.

The [`testthis` package](https://github.com/s-fleck/testthis) might help make your testing workflow even smoother. In particular, `test_this()` "reloads the package and runs tests associated with the currently open R script file.", and there's also a function for opening the test file associated with the current R script.

## Assess your tests

To get a sense of how good your tests are, check these out:

* [`covr`](https://github.com/r-lib/covr) computes the _test coverage_ i.e. the percentage of lines of code that are covered by tests. `covr` allows skipping some lines. If run on Travis or Appveyor, for instance, it can send a report to online coverage tools such as CodeCov or Coveralls, allowing you to visualize the coverage. At Locke Data we mostly don't run `covr` locally but instead have it run on Travis. To set that up, [`usethis::use_coverage()`](http://usethis.r-lib.org/reference/ci.html). 
    Here is [Coveralls report for `HIBPwned`](https://coveralls.io/github/lockedata/HIBPwned?branch=master) and [the corresponding badge](https://github.com/lockedata/hibpwned#hibpwned). See a [CodeCov report for comparison](https://codecov.io/github/ropensci/Ropenaq?branch=master).
    
* [`covrpage`](https://github.com/yonicd/covrpage) creates a detailed coverage report that can serve as a README for your test folder. We've done that [for `HIBPwned`](https://github.com/lockedata/HIBPwned/tree/master/tests#tests-and-coverage) so now without clicking in a coverage report, thanks to "detailed test results", you can see the tests associated with each context.

# Test all the things

Now, sometimes you might encounter cases of things that you don't quite know how to test. Here's a small list, but please comment about anything we've forgotten!

## Mocking

Sometimes you need to test whether your package works as expected "if something happens", "if a thing has this value" and can't rely on arguments. E.g. what happens if the environment variable `GITHUB_PAT` doesn't exist, or if a dependency isn't installed? In such cases, what you might be after is _mocking_. The `testthat` package itself has a `with_mock()` function, but it's now recommended to rather use the [`mockery`](https://github.com/jfiksel/mockery) or [`mockr` packages](https://github.com/krlmlr/mockr).

## Webmocking 

If the mocking you need to perform is e.g. mimicking a 404 result from an API, or saving a web API response and replay it to not have to re-query the API at each test, you can use:

* `webmockr` [like we did for `HIBPwned`](https://itsalocke.com/blog/some-web-api-package-development-lessons-from-hibpwned/)

* [`vcr`](https://github.com/ropensci/vcr) and `webmockr` together, see `vcr` docs. It works for both `crul` and `httr`. `vcr` docs include a list of packages using `vcr` for testing in the wild.

* [`httptest`](https://cran.r-project.org/web/packages/httptest/index.html) for `httr` only.

## Test plot outputs

You can test your plot outputs haven't changed by using [`vdiffr`](https://github.com/lionel-/vdiffr). To set things up you need to run `vdiffr::manage_cases()`.

## Test Shiny apps

Fear not, there's a whole package dedicated to help you test Shiny apps! Check out [`shinytest`](https://github.com/rstudio/shinytest).

## Test RStudio add-ins

The `remedy` package by ThinkR has [tests for its add-ins](https://github.com/ThinkR-open/remedy/tree/master/tests). They need to be run only when RStudio is available so a helper defines a [`skip_if_not_rstudio()` function](https://github.com/ThinkR-open/remedy/blob/master/tests/testthat/helper-functions.R#L1). Thanks to [Colin Fay](https://colinfay.me/) for showing it to me.

## Test htmlwidgets?

I'll be honest, I haven't seen examples of this in the wild, which is not surprising given I don't use htmlwidgets a lot. Still, worth mentioning are:

* [`viztest`](https://github.com/schloerke/viztest) tests htmlwidgets based on screenshots.

* the idea to test the content of the html before or after interactions. [`rdom`](https://github.com/cpsievert/rdom) can be a part of such a workflow: `rdom` + `xml2` to scrape the result + `testthat` of course. Thanks to [David Gohel](https://github.com/davidgohel) for telling me this!

## Test interactive behavior?

This is another topic I haven't totally figured out, but I like using `usethis` tests as a reference, be it the [manual/ folder](https://github.com/r-lib/usethis/tree/master/tests/manual) or the [testthat/ folder](https://github.com/r-lib/usethis/tree/master/tests/testthat). [`testthis` tests](https://github.com/s-fleck/testthis/tree/master/tests/testthat) might also be an inspiration.

# Conclusion

The ecosystem for R package testing is getting more and more complete and automatic, which is very exciting. To _deploy_ your tests, you'll need to learn about [continuous integration](https://ropensci.github.io/dev_guide/ci.html), which thankfully is also an area with [exciting](https://github.com/ropenscilabs/travis) [developments](https://github.com/ropenscilabs/tic). Maybe a subject for another post... In the meantime, feel free to tell us about your favourite resources for testing packages!

