---
title: 'R package news: tfsR, HIBPwned, mockaRoo'
author: Steph
type: post
date: 2016-03-24T15:44:03+00:00
categories:
  - R
tags:
  - 'statuspost'
  - hibpwned
  - mockaroo
  - r
  - security
  - software development in r
  - tfsR
  - unit testing
format: status

---
This is a brief update on my packages not currently on CRAN: tfsR, HIBPwned, and mockaRoo.

## tfsR

[tfsR][1] is designed to help you work git repositories in Microsoft Team Foundation Server (TFS) and Visual Studio Team Services (VSTS). I wrote the package a while ago and it has/had just two functions; one for getting a list of git repositories, and one for making a new git repository. The release of httr 1.1 broke the tfsR package, so I&#8217;ve amended the tfsR functions to resolve the problem.

I could submit this package to CRAN but it feels a little light. I have added some candidate features to the [tfsR GitHub issue tracker][2] for an install_tfs function and two more git repo admin functions. If tfsR is a useful package for you and the proposed features may come in handy, you can now use neat new GitHub functionality to add a reaction ( +:-) ) to upvote the functions you&#8217;re interested in.

## HIBPwned

[HIBPWned][3] implements the HaveIBeenPwned.com API in R. It is now feature-complete with respect to the API.

I would like to submit this package to CRAN, but would really appreciate it if folks could play around with it first as it suits my needs but may have some issues or missing functionality for others. For instance, do people want an Rstudio add-in?

## mockaRoo

[mockaRoo][4] provides R users with the means to generate data for testing functionality or producing realistic looking report mockups. Mockaroo.com provides a really cool service for generating such data and the mockaRoo package implements the interface API in R. This package is still in its earliest development stages &#8211; I&#8217;d love to get some collaborators or some very opinionated people to discuss this one with.

## Previous posts

&#8211;&nbsp;[mockaRoo: making realistic test data in R][5]
   
&#8211;&nbsp;[HIBPwned, an R package for HaveIBeenPwned.com][6]
   
&#8211; [Bride of Frankenstein: TFS + R][7]

## Get the packages

<pre><code class="r">if(!require("devtools")) install.packages("devtools")
# Get or upgrade from github
devtools::install_github("stephlocke/tfsR")
devtools::install_github("stephlocke/HIBPwned")
devtools::install_github("stephlocke/mockaRoo")
</code></pre>

 [1]: https://github.com/stephlocke/tfsR
 [2]: https://github.com/stephlocke/tfsR/issues
 [3]: https://github.com/stephlocke/HIBPwned
 [4]: https://github.com/stephlocke/mockaRoo
 [5]: https://itsalocke.com/mockaroo-making-realistic-test-data-in-r/
 [6]: https://itsalocke.com/r-package-haveibeenpwned-com/
 [7]: https://itsalocke.com/bride-of-frankenstein-tfs-r/