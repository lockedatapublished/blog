---
title: 'Auto-deploying documentation: multiple R vignettes'
author: Steph
type: post
date: 2015-06-05T08:38:44+00:00
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
Following on from my post about the principles behind using travis-ci to commit to a `gh-pages` I wanted to follow-up with how I tackled my &#8220;intermediate&#8221; use case.

* * *

### Posts in this series

  1. [Automated documentation hosting on github via Travis-CI][1]
  2. [Auto-deploying documentation: multiple R vignettes][2]
  3. [Auto-deploying documentation: FASTER!][3]
  4. [Auto-deploying documentation: Rtraining][4]
  5. [Auto-deploying documentation: better change tracking of artefacts][5]

* * *

## Multiple vignettes

In [my original post][1] I show how I pushed the tfsR vignette to `gh-pages`, which involved copying it and renaming it to index.html.

Unfortunately, this wouldn&#8217;t work if I had multiple vignettes that I wanted to be accessible online.

### Requirements

  * An index.html file
  * A way of extracting any number of html files from the vignette folder
  
    <!--more-->

### index.html

The easiest thing to do is create an index.Rmd vignette.

I used my README content inside mine since this should contain an overview of your package already. I then inserted relative URLs to other vignettes at sensible locations.

    See the vignette [Presentation components](presentation.html) for more info
    

If you wanted navigation from &#8220;sub-vignettes&#8221; you could simply point to the index.html file

### Multiple files

The base code from [Robert][6], that I utilised in my [tfsR project][7] had a hardcoded copy and rename of a single vignette to the index file. With multiple files it would soon become wearisome to hard code all the files in. For limited cognitive effort, I turned the copy statement into a loop based on the loop Robert uses for unzipping the package.

The loop is restricted to the docs folder and any html files within it. The simple loop is the primary reason for having an index.Rmd file, as that file ensures there is a destination for landing on [stephlocke.github.io/optiRum][8]

    [embedGitHubContent owner="stephlocke" repo="optiRum" path=".push_gh_pages.sh"]
    

### Putting it all together

When this push file and vignettes get committed and pushed to Travis, the build process will loop through all the generated vignettes (after the package successfully builds) and pushes them into the `gh-pages` branch. This in turn presents the documentation on the `https://[CONTAINER].github.io/[REPO]` URL.

For optiRum this would be: [stephlocke.github.io/optiRum/][9]
  
<figure id="attachment_61364" style="width: 300px" class="wp-caption alignnone">[<img src="../img/2015-06-05-09_33_06-stephlocke_optiRum-Travis-CI_rmnpmy.png" alt="Travis-CI build & autodeploy" width="300" height="86" class="size-medium wp-image-61364" />][10]<figcaption class="wp-caption-text">Travis-CI build & autodeploy</figcaption></figure>

## Where next?

My &#8220;advanced&#8221; use case is publishing a lot of files both standalone and compiled. These aren&#8217;t currently stored as vignettes so it&#8217;s going to be interesting to tackle this, but will form a useful basis for anyone who wants to build a webpage from some analysis they&#8217;ve written in R.

 [1]: https://itsalocke.com/automated-documentation-hosting-on-github-via-travis-ci/
 [2]: https://itsalocke.com/auto-deploying-documentation-multiple-r-vignettes/
 [3]: https://itsalocke.com/auto-deploying-documentation-faster/
 [4]: https://itsalocke.com/auto-deploying-documentation-rtraining/
 [5]: https://itsalocke.com/auto-deploying-documentation-better-change-tracking-artefacts/
 [6]: http://rmflight.github.io/posts/2014/11/travis_ci_gh_pages.html
 [7]: https://github.com/stephlocke/tfsR
 [8]: http://stephlocke.github.io/optiRum
 [9]: http://stephlocke.github.io/optiRum/
 [10]: ../img/2015-06-05-09_33_06-stephlocke_optiRum-Travis-CI_rmnpmy.png