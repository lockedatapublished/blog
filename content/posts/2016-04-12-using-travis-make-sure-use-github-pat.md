---
title: Using Travis? Make sure you use a Github PAT
author: Steph
type: post
date: 2016-04-12T10:27:03+00:00
categories:
  - Data Science
  - DataOps
  - R
tags:
  - auto deploying r documentation
  - git
  - quick tip
  - r
  - software development in r
  - travis-ci

---
We&#8217;re in the fantastic situation where lots of people are using [Travis-CI][1] to test their R packages or use it to test and deploy their analytics/ documentation / anything really. It&#8217;s popularity has been having a negative side-effect recently though! GitHub [rate limits][2] API access to 5000 requests per hour so sometimes there are more R related jobs running on Travis per hour than this limit, causing builds to error typically with a message that includes

> 403 forbidden 

This error will cause your build to fail, even if you didn&#8217;t do anything wrong. To solve it short-term you can wait a little while and restart your build.<figure id="attachment_61598" style="width: 768px" class="wp-caption aligncenter">

<img class="size-medium_large wp-image-61598" src="http://res.cloudinary.com/lockedata/image/upload/c_scale,q_80,w_750/v1499850336/restartbuilds_hsvpmp.png" alt="How to restart a build in Travis-CI" width="768" height="134" /><figcaption class="wp-caption-text">How to restart a build in Travis-CI</figcaption></figure> 

That is a very short-termist solution and does not solve the problem for future you or other users of the service. The real solution to resolving this issue is to get off the default API access credentials and use your own.

The R integration in Travis makes good use of the [devtools][3]. The devtools package looks for an environment variable called `GITHUB_PAT` that holds a [personal access token][4] (PAT) for using the GitHub API and if it doesn&#8217;t find one it uses a default token. When we get our own PAT and store it in Travis, devtools will pick up our token and use it, meaning you&#8217;ll only ever get rate limited if you do more than 5000 builds in an hour, which is an achievement I&#8217;d love to hear about.
  
<!--more-->

## How to

  1. [Create a PAT][5] with no permissions i.e. untick all the permissions boxes
  2. Copy the key
  3. Go to your repo&#8217;s settings on Travis e.g. https://travis-ci.org/stephlocke/Rtraining/settings
  4. Add an environment variable called GITHUB_PAT and paste in your key. There is a toggle next to it that defaults to not show the value in the log. This key has no permissions but still, keep it private and don&#8217;t toggle!

## Stay secure

If you followed the instructions above your key will be conforming to the [principle of least privileges][6] because it will only be able to perform public actions that anyone can take i.e. read and clone a public repository. That being said, it&#8217;s never wise to let credentials escape out into the wilderness unless you can avoid it. This is where the bit about ensuring the value doesn&#8217;t get printed to the log comes in. If it never gets printed, the only time this key is available for stealing is when you&#8217;re creating it and adding it to Travis.

## Verifying it worked

When you next run a build, you should see some (or all) of the following signs of success, over and above a lack of a 403 error:

    Setting environment variables from repository settings
    $ export GITHUB_PAT=[secure]
    
    
    $ Rscript -e 'devtools::install_github("stephlocke/tfsR",dependencies=TRUE)'
    Using GitHub PAT from envvar GITHUB_PAT

 [1]: https://travis-ci.org/
 [2]: https://developer.github.com/v3/#rate-limiting
 [3]: https://cran.r-project.org/package=devtools
 [4]: https://help.github.com/articles/creating-an-access-token-for-command-line-use/
 [5]: https://github.com/settings/tokens
 [6]: https://en.wikipedia.org/wiki/Principle_of_least_privilege