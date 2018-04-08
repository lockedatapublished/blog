---
title: HIBPwned, an R package for HaveIBeenPwned.com
author: Steph

date: 2016-03-21T15:02:08+00:00
categories:
  - R
tags:
  - 'statuspost'
  - api
  - haveibeenpwned
  - r
  - security
  - software development in r
  - travis-ci
  - unit testing
format: status

---
The answer in life to the inevitable question of &#8220;How can I do that in R?&#8221; should be &#8220;There&#8217;s a package for that&#8221;. So when I wanted to query [HaveIBeenPwned.com][1] (HIBP) to check whether a bunch of emails had been involved in data breaches and there wasn&#8217;t an R package for HIBP, it meant that the responsibility for making one landed on my shoulders. Now, you can see if your accounts are at risk with the R package for HaveIBeenPwned.com, **HIBPwned**.
  
<figure id="attachment_61581" style="width: 768px" class="wp-caption alignnone"><img src="../img/hibp_os8t5d.png" alt="Have I Been Pwned | HaveIBeenPwned.com" width="768" height="142" class="size-medium_large wp-image-61581" /><figcaption class="wp-caption-text">Have I Been Pwned | HaveIBeenPwned.com</figcaption></figure>

## Current status

The package is currently available on github @ [stephlocke/HIBPwned][2], but I intend to submit to CRAN after getting some feedback from y&#8217;all.

<!--more-->

<pre><code class="r">if(!require("devtools")) install.packages("devtools")
# Get or upgrade from github
devtools::install_github("stephlocke/HIBPwned")
library("HIBPwned")
</code></pre>

## Basic usage

The very first thing you should do after installing is checking to see if your personal email address has been breached.

<pre><code class="r">HIBPwned::account_breaches("foo@bar.com")
</code></pre>

After that, check your significant other, your cat, and your family who you probably provide IT support for.

<pre><code class="r">HIBPwned::account_breaches(c("foo@bar.com", "test@test.com"))
</code></pre>

**Give it a whirl!**

## Package development notes

  * HIBP is a fantastically written API and isn&#8217;t complicated so I&#8217;ve almost got the R package to be feature complete with respect to the API.
  * The package enjoys 100% test coverage as the simplicity of the API has enabled thorough testing
  
    [![Coverage Status][3]][4]
  * The package uses the latest iteration of the [R travis-ci][5] capabilities

 [1]: https://haveibeenpwned.com
 [2]: https://github.com/stephlocke/HIBPwned
 [3]: https://coveralls.io/repos/github/stephlocke/HIBPwned/badge.svg?branch=master
 [4]: https://coveralls.io/github/stephlocke/HIBPwned?branch=master
 [5]: http://blog.rstudio.org/2016/03/09/r-on-travis-ci/