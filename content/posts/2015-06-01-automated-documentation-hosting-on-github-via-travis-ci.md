---
title: Automated documentation hosting on github via Travis-CI
author: Steph
type: post
date: 2015-06-01T09:29:21+00:00
categories:
  - Data Science
  - DataOps
  - R
tags:
  - auto deploying r documentation
  - best practices
  - continuous integration
  - documentation
  - git
  - github
  - knitr
  - r
  - rmarkdown
  - software development in r
  - tfsR
  - travis-ci

---
In this post, I&#8217;m going to cover how you can use continuous integration and source control to build and host documentation (or any other static HTML) for free, and in a way that updates every time your code changes. I&#8217;ll cover the generic capability, and then how I apply this to my simplest package, tfsR. In a later post (once I&#8217;ve cracked the best method to do it) I&#8217;ll cover my more complex use case of multiple documents and a dynamically constructed index page.

NB: This is kicked off from a [post][1] from Robert Flight about applying to the technique to R package vignettes. It&#8217;s a very useful post but it was quite specific to his situation and I wanted to understand the principles behind it before I started extending it to my more complex cases.

* * *

### Posts in this series

  1. [Automated documentation hosting on github via Travis-CI][2]
  2. [Auto-deploying documentation: multiple R vignettes][3]
  3. [Auto-deploying documentation: FASTER!][4]
  4. [Auto-deploying documentation: Rtraining][5]
  5. [Auto-deploying documentation: better change tracking of artefacts][6]

* * *

## Requirements

  * Must haves: 
      * Travis-CI
      * GitHub
  * Optional: 
      * A linux machine (so you can test your bash script that Travis-CI will run)
      * R (for following the specific instructions)

## High-level process

  * Get an OAUTH token from github
  * Add OAUTH token to travis
  * Add a *.sh file that gets your HTML (depending on circumstance, you may also need to generate it) and pushes to gh-pages branch
  * Include your .sh file in the `after_success` part of your travis file
  * Commit & push!
  
    <!--more-->

## Detailed process

  * Get a token from [github][7] &#8211; use least privileges so only grant read/write access to public repos<figure id="attachment_61354" style="width: 760px" class="wp-caption alignnone">

[<img class="size-full wp-image-61354" src="../img/OAUTHperms_lbmohc.png" alt="github OAUTH permissions" width="760" height="534" />][8]<figcaption class="wp-caption-text">github OAUTH permissions</figcaption></figure> 

  * Store the OAUTH token on travis with the name GH_TOKEN 
      * I did this by using the environment variables for the repository (in the settings for the repository) as it had the least dependencies required to do and travis-ci will pick up anywhere I use GH_TOKEN in the build process without me having to add it to my `.travis.yml` file
      * You can alternatively use the travis CLI to pass the token to travis-ci, which&#8217;ll return an encrypted version that you can use in your `travis.yml` file
  
        <figure id="attachment_61355" style="width: 765px" class="wp-caption alignnone">[<img class="size-full wp-image-61355" src="../img/environmentvariable_y844pm.png" alt="travis-ci addd an environment variable" width="765" height="428" />][9]<figcaption class="wp-caption-text">travis-ci add an environment variable</figcaption></figure>
  * Add a bash file that gets the HTML and pushes it to the repository. [Robert&#8217;s bash script][1] is a really good example of actual code so I only cover the concept here: 
      * Create an empty directory you can work in
      * Create a git repository to hold all your HTML pages in
      * Commit all the HTML files (make sure there is one called index.html)
      * Push the repo into the gh-pages branch of your destination repo (which will be at `http:://[GH_TOKEN]@github.com/[CONTAINER]/[REPO].git`)
  * Add your bash file to the`.travis.yml` instructions / config file so that it&#8217;ll be taken into account on the next push

    # Do this bit if you encrypted the string via CLI
    env:
    global:
    - secure: "travisCLIreturnedstring"
    
    # Do this bit for every situation as it makes it executable and then executes it once the build passes - we don't docs from bad builds afterall!
    before_install:
    - chmod 755 ./.push_gh_pages.sh
    
    after_success:
    - ./.push_gh_pages.sh
    

  * Commit the two (or potentially more if you need to add your bash file to build ignore files) files and then push the changes. Your next travis build should pick it all up and execute the bash file once the rest of the build has been a success

## Putting it together &#8211; tfsR

I&#8217;ve [been using Travis-CI][10] for [optiRum][11] and [tfsR][12] for a while now. This has given me confidence in that my unit tests are run successfully, and records test coverage. What it didn&#8217;t do though was make my vignette or help documentation available &#8211; you had to read the un-rendered version of the vignette or download and compile. This wasn&#8217;t very accessible, especially for new people.

As this is my simplest package with only one vignette it seemed an ideal test case. To achieve the documentation building I amended or added three files, following Robert&#8217;s instructions for the most part:

### .push\_gh\_pages.sh

    [embedGitHubContent owner="stephlocke" repo="tfsR" path=".push_gh_pages.sh"]
    
    

### .travis.yml

    [embedGitHubContent owner="stephlocke" repo="tfsR" path=".travis.yml"]
    
    

### .Rbuildignore

    [embedGitHubContent owner="stephlocke" repo="tfsR" path=".Rbuildignore"]
    

You can see the finished results at [stephlocke.github.io/tfsR][13]

## Further reading

  * [Robert Flight on Travis-CI to Github Pages][1]
  * [Custom domains for gh-pages][14]
  * [Jekyll github pages][15]
  * [Github pages help][16]

 [1]: http://rmflight.github.io/posts/2014/11/travis_ci_gh_pages.html
 [2]: https://itsalocke.com/automated-documentation-hosting-on-github-via-travis-ci/
 [3]: https://itsalocke.com/auto-deploying-documentation-multiple-r-vignettes/
 [4]: https://itsalocke.com/auto-deploying-documentation-faster/
 [5]: https://itsalocke.com/auto-deploying-documentation-rtraining/
 [6]: https://itsalocke.com/auto-deploying-documentation-better-change-tracking-artefacts/
 [7]: https://github.com/settings/tokens/new
 [8]: ../img/OAUTHperms_lbmohc.png
 [9]: ../img/environmentvariable_y844pm.png
 [10]: https://itsalocke.com/easy-continuous-integration-for-r/
 [11]: https://github.com/stephlocke/optiRum
 [12]: https://github.com/stephlocke/tfsR
 [13]: http://stephlocke.github.io/tfsR
 [14]: https://help.github.com/articles/setting-up-a-custom-domain-with-github-pages/
 [15]: http://jekyllrb.com/docs/github-pages/
 [16]: https://help.github.com/categories/github-pages-basics/