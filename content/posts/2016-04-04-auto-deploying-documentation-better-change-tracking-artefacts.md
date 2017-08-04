---
title: 'Auto-deploying documentation: better change tracking of artefacts'
author: Steph
type: post
date: 2016-04-04T11:04:34+00:00
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
As part of my never-ending quest to deploy documentation better, I&#8217;ve made yet another tweak to my scripts that deploy R vignettes or Rmarkdown documents to the `gh-pages` branch of my github repositories via Travis-CI.

The script from [Robert Flight][1] that&#8217;s provided the basis for most of this work does something specific to update the web facing branch of the repository. It would:
  
1. Create a blank repository
  
2. Add the requisite files to the repository
  
3. Add and commit them to the repo
  
4. Force the repo to overwrite the `gh-pages` branch

This had the unfortunate consequence of losing the history of what was previously hosted on the branch and could not tell me what commit to my development branches was responsible for a version of the docs. It took a little bit of playing but the revised script now:
  
1. Clones the gh-pages branch
  
2. Adds the requisite files into the reports
  
3. Add and commit them to the repo
  
4. Push the changes

Using an environment variable ($TRAVIS_COMMIT) the commit message is the commit ID for the latest commit in the build that occurs on Travis, making it very easy to see what changes triggered a documentation update.
  
<!--more-->

This version is designed to extract generated vignettes, but the principal holds for any generated files.

    [embedGitHubContent owner="stephlocke" repo="RMSFTDP" path=".push_gh_pages.sh"]
    

* * *

### Posts in this series

  1. [Automated documentation hosting on github via Travis-CI][2]
  2. [Auto-deploying documentation: multiple R vignettes][3]
  3. [Auto-deploying documentation: FASTER!][4]
  4. [Auto-deploying documentation: Rtraining][5]
  5. [Auto-deploying documentation: better change tracking of artefacts][6]

* * *

 [1]: http://rmflight.github.io/posts/2014/11/travis_ci_gh_pages.html
 [2]: https://itsalocke.com/automated-documentation-hosting-on-github-via-travis-ci/
 [3]: https://itsalocke.com/auto-deploying-documentation-multiple-r-vignettes/
 [4]: https://itsalocke.com/auto-deploying-documentation-faster/
 [5]: https://itsalocke.com/auto-deploying-documentation-rtraining/
 [6]: https://itsalocke.com/auto-deploying-documentation-better-change-tracking-artefacts/