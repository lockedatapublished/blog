---
title: Easy Continuous Integration for R
author: Steph

date: 2015-04-20T09:06:36+00:00
dsq_thread_id:
  - 3716716865
categories:
  - Data Science
  - R
tags:
  - continuous integration
  - git
  - r
  - software development in r
  - test coverage
  - travis-ci
  - unit testing

---
With [excellent guidance][1] and [tooling][2] on making R packages, it&#8217;s becoming really easy to make a package to hold your R functionality. This has a host of benefits, not least source control (via GitHub) and unit testing (via the [`testthat`][3] package). Once you have a package and unit tests, a great way of making sure that as you change things you don&#8217;t break them is to perform [Continuous integration][4].

What this means is that **every** time you make a change, your package is built and thoroughly checked for any issues. If issues are found the &#8220;build&#8217;s broke&#8221; and you have to fix it ASAP.

The easiest, cheapest, and fastest way of setting up continuous integration for R stuff is to use [Travis-CI][5], which is free if you use [GitHub][6] as a remote server for your code.
  
_NB &#8211; it doesn&#8217;t have to be your only remote server_

<!--more-->

## Account setup

The first thing that needs doing is setting up your accounts and turning on CI for your repositories. The website is pretty good so I won&#8217;t go into a lot of detail, but the process is:
   
1. sign up for a Travis-CI account
   
2. link it to your GitHub account
   
3. say which repositories you want to do CI on
   
4. add config to your repositories

Additionally, whilst we&#8217;re doing this we should be awesome and set up test coverage checks as well. The process is really similar, but for [coveralls.io][7] and we only need the one set of config details in our package.

## The config file

Then you add a really simple file into the root of your project called `.travis.yml`.

This should contain, at minimum, the following:

    language: r
    sudo: required
    
    r_github_packages:
     - jimhester/covr
    
    after_success:
      - Rscript -e 'library(covr);coveralls()'
    

_NB &#8211; be careful with the indentation, YAML is very sensitive!_

This is the latest set of values that work as it takes into account the recent support for R, the ability to reference github packages, and also Travis&#8217; move towards docker containers which don&#8217;t accept sudo commands.

Once you&#8217;ve flipped the switch on Travis and Coveralls, every push to GitHub will trigger Travis. Travis will basically build a server with all the requirements needed to run R and build R packages. It&#8217;ll then install all your package&#8217;s dependencies, check the package for minimum quality standards and also run your testthat tests. Once this is done the final bit tests your code coverage and passes the results to Coverall.

## Badge of honour

Great, so you&#8217;ve checked the sites and it&#8217;s working but you should show the world it&#8217;s working! You can get some some snippets of code from each of the sites that you can paste into your README file. These stay up to date with the latest results so that you (and everyone else) can see the status of your package.

**C&#8217;est fini!**

 [1]: http://r-pkgs.had.co.nz/
 [2]: http://cran.r-project.org/web/packages/devtools/
 [3]: http://cran.r-project.org/web/packages/testthat/
 [4]: http://www.thoughtworks.com/continuous-integration
 [5]: https://travis-ci.com/
 [6]: http://github.com
 [7]: https://coveralls.io/