---
title: Improving automatic document production with R
author: Steph

date: 2017-05-19T08:02:26+00:00
spacious_page_layout:
  - default_layout
categories:
  - Data Science
  - DataOps
  - R
tags:
  - auto deploying r documentation
  - best practices
  - continuous integration
  - presentations
  - productivity
  - rmarkdown
  - travis-ci

---
In this post, I describe the latest iteration of my automatic document production with R. It improves upon the methods used in [Rtraining][1], and previous work on this topic can read by going to the [auto deploying R documentation][2] tag.

I keep banging on about this area because reproducible research / analytical document pipelines is an area I&#8217;ve a keen interest in. I see it as a core part of [DataOps][3] as it&#8217;s vital for helping us ensure our models and analysis are correct in data science and boosting our productivity.

Even after (or because of) a few years of off and on again development to the process, Rtraining had a number of issues:

  * build time was long because all presentations and their respective dependencies were required
  * if a single presentation broke, any later presentations would not get generated
  * the presentation build step was in &#8220;after_success&#8221; so didn&#8217;t trigger notifications
  * the build script for the presentations did a lot of stuff I thought could be removed
  * the dynamic [index page][4] sucks

This post covers how I&#8217;m attempting to fix all bar the last problem (more on that in a later post).

With the problems outlined, let&#8217;s look at my new [base solution][5] and how it addresses these issues.

## Structure

I have built a template that can be used to generate multiple presentations and publish them to a `docs/` directory for online hosting by GitHub. I can now use this template to produce category repositories, based on the folders in `inst/slides/` in Rtraining. I can always split them out further at a later date.

The new repo is structured like so:

  * Package infrastructure 
      * `DESCRIPTION` &#8211; used for managing dependencies primarily
      * `R/` &#8211; store any utility functions
      * `.Rbuildignore` &#8211; avoid non-package stuff getting checked
  * Presentations 
      * `pres/` &#8211; directory for storing presentation .Rmd files
      * `pres/_output.yml` &#8211; file with render preferences
  * Output directory 
      * `docs/` &#8211; directory for putting generated slides in
  * Document generation infrastructure 
      * `.travis.yml` &#8211; used to generate documents every time we push a commit
      * `buildpres.sh` &#8211; shell script doing the git workflow and calling R
      * `buildpres.R` &#8211; R script that performs the render step

## Presentations

  * My Rtraining repo contained all presentations in the `inst/slidedecks/` directory with further categories. This meant that if someone installed Rtraining, they&#8217;d get all the decks. I think this is a sub-optimal experience for people, especially because it mean installing so many packages, and I&#8217;ll be focusing instead on improving the web delivery.
  * Render requirements are now stored in an `_output.yml` file instead of being hard coded into the render step so that I can add more variant later
  * I&#8217;m currently using a modified version of the [`revealjs`][6] package as I&#8217;ve built a heavily customised theme. As I&#8217;m not planning on any of these presentation packages ever going on CRAN, I can use the `Remotes` field in `DESCRIPTION` to describe the location. This simplifies the code significantly.

## Document generation<figure id="attachment_62216" style="width: 485px" class="wp-caption aligncenter">

<img src="../img/processflow_ho0b1d.png" alt="Automatic document generation with R" width="485" height="534" class="size-full wp-image-62216" /><figcaption class="wp-caption-text">Automatic document generation with R</figcaption></figure> 

### Travis

I use [travis-ci][7] to perform the presentation builds. The instructions I provide travis are:

    [embedGitHubContent owner="lockedata" repo="pres-stub" path=".travis.yml"]
    

One important thing to note here is that I used some arguments on my package build and check steps along with `latex: false` to drastically reduce the build time as I have no intention of producing PDFs normally.

The `install` section is the prep work, and then the `script` section does the important bit. Now if there are errors, I&#8217;ll get notified!

### Bash

The script that gets executed in my Travis build:

  * changes over to a GITHUB_PAT based connection to the repo to facilitate pushing changes and does some other config
  * executes the R render step
  * puts the R execution log in `docs/` for debugging
  * commits all the changes using the important prefix `[CI SKIP]` so we don&#8217;t get infinite build loops
  * pushes the changes

    [embedGitHubContent owner="lockedata" repo="pres-stub" path="buildpres.sh"]
    

### R

The R step is now very minimal in that it works out what presentations to generate, then loops through them and builds each one according to the options specified in `_output.yml`

    [embedGitHubContent owner="lockedata" repo="pres-stub" path="buildpres.R"]
    

## Next steps for me

This work has substantially mitigated most of the issues I had with my previous Rtraining workflow. I now have to get all my slide decks building under this new process.

I will be writing about making an improved presentation portal and how to build and maintain your own substantially modified revealjs theme at a later date.

The modified workflow and scripts also have implications on my [pRojects][8] package that I&#8217;m currently developing along with [Jon Calder][9]. I&#8217;d be very interested to hear from you if you have thoughts on how to make things more streamlined.

 [1]: https://github.com/stephlocke/Rtraining
 [2]: https://itsalocke.com/tag/auto-deploying-r-documentation/
 [3]: https://itsalocke.com/dataops-its-a-thing-honest/
 [4]: https://stephlocke.info/Rtraining/
 [5]: https://github.com/lockedata/pres-stub
 [6]: https://cran.r-project.org/package=revealjs
 [7]: https://travis-ci.org
 [8]: https://github.com/lockedata/pRojects
 [9]: https://twitter.com/jonmcalder