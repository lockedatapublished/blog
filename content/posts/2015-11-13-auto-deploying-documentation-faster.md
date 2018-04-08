---
title: 'Auto-deploying documentation: FASTER!'
author: Steph

date: 2015-11-13T09:13:22+00:00
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
  - r
  - rmarkdown
  - software development in r
  - travis-ci

---
Over the past few years I&#8217;ve been delving deeper into automatically building and deploying documentation and reporting in R (with rmarkdown, LaTeX etc). This post covers another step forward on that journey towards awesomeness.

<!--more-->

* * *

### Posts in this series

  1. [Automated documentation hosting on github via Travis-CI][1]
  2. [Auto-deploying documentation: multiple R vignettes][2]
  3. [Auto-deploying documentation: FASTER!][3]
  4. [Auto-deploying documentation: Rtraining][4]
  5. [Auto-deploying documentation: better change tracking of artefacts][5]

* * *

I wrote a while back about how [Robert Flight][6]&#8216;s post helped me [make web pages out of my R package vignette][1] _automatically_ whenever I committed a change to GitHub. I took it further by modifying to [loop through vignettes][2].

I then promised to do one thing: make a much more complex version. Well, that&#8217;s taken me a while and you can check it out in its [current guise for Rtraining][7] but it&#8217;s still not as clean I&#8217;d like because of my pants coding on some of the Rmarkdown docs. Whilst I can&#8217;t blog about a neat solution for that (yet), I wanted to cover the neat, but most importantly fast, solution I was able to crib from [Kieran Healy][8] on using [containerized R builds][9] and how this makes things go whizzy fast!

Part of the big problem I&#8217;ve had when doing my Rtraining auto-doc process has been the amount of time it takes to build my R environment from scratch before generating the documents. When your build takes more than 15 minutes you find other things to do with the intervening time and end up completely forgetting about it.

## How do you solve that full-build issue?

Unfortunately, a long build time is a typical state of affairs with the [R Travic-CI][10] builds at the moment because they require elevated permissions and run on VMs. Travis have been using containers from [docker][11] to do much cooler stuff. By using containers they have less initial setup that needs doing so your build starts quicker, then you can set up some caching of dependencies so that it keeps all your installed stuff lying around ready for use when you commit things. This means that unless a dependency has changed e.g. new version, or no longer required, the cache is still valid and can be used. Overall, between the two pieces it means time is spent on testing your stuff, and less time is spent on the prep for testing.

This can literally take 10-15 minutes off your build time &#8211; woohoo!

## Why isn&#8217;t everyone doing it?

Well, it is pretty new and R support has only just gone into travis generally. There&#8217;s also some permissions issues that go away with `sudo`. At the moment, the [example container R build][12] that Jan Tilly built is still pretty bare bones and isn&#8217;t as easy out of the box as the mainstream version.

## Move on to the cool stuff already!

When I needed to do an [rmarkdown repository][13] for making [R Consortium Infrastructure Proposals][14], I was able to take the opportunity to take Jan&#8217;s code and move forward with it so that the ISC proposal is always web-facing. Here&#8217;s how I did it:

  * Used @jtilly&#8217;s [.travis.yml][15] file as the backbone
  * Emulated @yihui&#8217;s [knitr .travis.yml][16] file in order to get recent versions of pandoc and texlive for rmarkdown to work correctly
  * Used a shell script for sorting out git commits, and my R file for generating the Rmarkdown docs

### What next?

Take a look at the key components (below) or have a play &#8211; take the [proposal boilerplate][13] and follow the instructions on configuring it to work on your account. Try adding new docs or dependencies, or add a package infrastructure &#8211; in other words hack away! Most importantly though, smile at jobs that take just a minute 😀

### The R code

    [embedGitHubContent owner="stephlocke" repo="isc-proposal" path="ghgenerate.R"]
    

### The bash code

    [embedGitHubContent owner="stephlocke" repo="isc-proposal" path=".push_gh_pages.sh"]
    

### The travis yaml

    [embedGitHubContent owner="stephlocke" repo="isc-proposal" path=".travis.yml"]

 [1]: https://itsalocke.com/automated-documentation-hosting-on-github-via-travis-ci/
 [2]: https://itsalocke.com/auto-deploying-documentation-multiple-r-vignettes/
 [3]: https://itsalocke.com/auto-deploying-documentation-faster/
 [4]: https://itsalocke.com/auto-deploying-documentation-rtraining/
 [5]: https://itsalocke.com/auto-deploying-documentation-better-change-tracking-artefacts/
 [6]: https://twitter.com/rmflight
 [7]: https://github.com/stephlocke/Rtraining
 [8]: http://kieranhealy.org/
 [9]: http://kieranhealy.org/blog/archives/2015/10/16/using-containerized-travis-ci-to-check-r-in-rmarkdown-files/
 [10]: http://docs.travis-ci.com/user/languages/r/
 [11]: https://www.docker.com/
 [12]: https://github.com/jtilly/R-travis-container-example
 [13]: https://github.com/stephlocke/isc-proposal
 [14]: https://www.r-consortium.org/about/isc/proposals
 [15]: https://github.com/jtilly/R-travis-container-example/blob/master/.travis.yml
 [16]: https://github.com/yihui/knitr/blob/master/.travis.yml