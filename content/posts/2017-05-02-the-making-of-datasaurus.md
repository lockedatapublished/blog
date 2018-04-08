---
title: The making of datasauRus
author: Steph

date: 2017-05-02T12:10:32+00:00
spacious_page_layout:
  - default_layout
categories:
  - R
tags:
  - best practices
  - continuous integration
  - coveralls
  - git
  - github
  - open source
  - r
  - software development in r
  - travis-ci

---
Around 8:30pm I saw this tweet and duly retweeted

<blockquote class="twitter-tweet" data-width="525">
  <p lang="en" dir="ltr">
    <throws away Anscombe quartet> <a href="https://t.co/WuyU9D6npK">https://t.co/WuyU9D6npK</a>
  </p>
  
  <p>
    &mdash; Richie Cotton (@richierocks) <a href="https://twitter.com/richierocks/status/859126142405677056">May 1, 2017</a>
  </p>
</blockquote>



It turns out awesome folks, [George][1] and [Justin][2], had made a process whereby they can [generate different distributions of points][3] that retain the same summary statistics. They used this process for making some friends for Dino the Datasaurus who was created by [Alberto Cairo][4]. They made the data for Dino and the rest of the Datasaurus Dozen available for download.

The data seemed like an ideal thing to get into R, so it was R package development time!

I know a lot of folks can be a bit scared of producing packages so I thought I&#8217;d share the workflow so folks can see how easy the actual package bits and bobs can be.

## Starting a package

For a long time I&#8217;ve been using [`devtools`][5] to make package building easier, and indeed I still do. However, I wanted to be even lazier so I didn&#8217;t even have to type out the ~10 lines of code to set up a best practice package. To be lazy, I made a package called [`pRojects`][6]. `pRojects` helps with the initial setup of different project types, including packages. It&#8217;s still under development and it&#8217;s a great place to cut your teeth on contributing to a package.

To start the [`datasauRus`][7] package I just did:

<pre><code class="r">install.packages("devtools")
devtools::install_github("lockedata/pRojects")
pRojects::createPackageProject("datasauRus")
</code></pre>

> Well, I&#8217;ve already got those prerequisites so I only did 1 line! 

Then some (optional) online stuff is required to complete the awesomeness:

  1. [Create a new repository on github][8]
  2. [Turn on travis continuous integration][9]
  3. [Turn on coveralls][10]

Then we need to add github repository to our project. I use the git command line for this:

<pre><code class="r">git remote add origin git@github.com:stephlocke/datasauRus.git
git push --set-upstream origin master
</code></pre>

With just these things, I have a package that contains the unit test framework, documentation stubs, continuous integration and test coverage, and source control.

That is all you need to do to get things going!

## Adding package contents

I&#8217;m not going to take you through an in-depth piece on writing package contents as Hadley does that extremely well in [R packages][11] (or get the [book][12]). This package only requires datasets to be built.

[Lucy McGowan][13] made a PR overnight that converted the raw data (stored in `inst/extdata/`) into R datasets (stored in `data`) with this R code:

    [embedGitHubContent owner="stephlocke" repo="datasauRus" path="R/convert.R" cache_id="dd32b0ec8708bcc92c85ed085538ddb9f754c725"]
    

This made `.Rda` files that would now be loaded when the package installed. Lucy also added minimal documentation for each file too in the R package doc created by default in the package setup phase. Each data entry looks like:

    #'Datasaurus Dozen (wide) data
    "datasaurus_dozen_wide"
    

## Adding tests

We don&#8217;t have functions in this package but we do have datasets, so I wanted to write some unit tests for these.

Unit testing with [`testthat`][14] is setup by default so I just needed to add a file beginning with `test-` into the `test/testthat/` directory that contained some tests about the data.

As the code would be repetitive, I made a function that could be applied to each dataset.

<pre><code class="r">context("datasets")

datashapetests&lt;-function(df, ncols, nrows, uniquecol=NULL, nuniques=NULL){
  expect_equal(ncol(df),ncols)
  expect_equal(nrow(df),nrows)
  if(!is.null(uniquecol))
  expect_equal(nrow(unique(df[uniquecol])),nuniques)
}

test_that("box_plots is correctly shaped",{
  datashapetests(box_plots,6,2484)
})

test_that("datasaurus_dozen is correctly shaped",{
  datashapetests(datasaurus_dozen,3,1846,"dataset",13)
})
</code></pre>

## Documentation

I mentioned some of the minimally written dataset documentation. These should be expanded, and the [vignette needs filling in][15]. This could be based on the information I&#8217;ve already provided in the README. Once the documentation is polished, this package could go to CRAN.

## Run checks

Once you&#8217;ve made some changes to your package, you should make sure your code passes it&#8217;s unit tests, that documentation is correctly structured, and that your code compiles. Remove as many warnings and notes as possibles.

Do this with `devtools`:

<pre><code class="r">devtools::check()
</code></pre>

Travis CI will also verify your code passes these checks in a clean environment, and if you hooked up code coverage then you&#8217;ll see how much your tests test your codebase.

## That&#8217;s it

There can be nuance in writing your own functions and coding defensively, but you can now make a great package skeleton in just one line of code. The [`datasauRus`][7] is almost ready to go to CRAN and it took less than 50 lines of code, including the package contents. I hope this has been some useful insight into R package development.

If you want to tackle making your first package, I&#8217;ll happily give you a hand &#8211; book into my [office hours][16] and let&#8217;s do it!

 [1]: https://www.autodeskresearch.com/people/george-fitzmaurice
 [2]: https://www.autodeskresearch.com/people/justin-matejka
 [3]: https://www.autodeskresearch.com/publications/samestats
 [4]: http://www.thefunctionalart.com/
 [5]: https://cran.r-project.org/package=devtools
 [6]: https://github.com/lockedata/pRojects
 [7]: https://github.com/stephlocke/datasauRus
 [8]: https://help.github.com/articles/creating-a-new-repository/
 [9]: https://travis-ci.org/getting_started
 [10]: https://coveralls.zendesk.com/hc/en-us
 [11]: http://r-pkgs.had.co.nz/
 [12]: http://geni.us/rpkgs
 [13]: https://github.com/LucyMcGowan
 [14]: https://cran.r-project.org/package=testthat
 [15]: https://github.com/stephlocke/datasauRus/issues/3
 [16]: https://calendly.com/lockedata/officehours