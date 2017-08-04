---
title: HIBPwned updated on CRAN
author: Steph
type: post
date: 2016-09-15T07:00:53+00:00
categories:
  - R
tags:
  - '#statuspost'
  - haveibeenpwned
  - hibpwned
format: aside

---
[Haveibeenpwned.com][1] is a fantastic service that helps people find out if they&#8217;ve been involved in a data breach. HIBPwned is an R wrapper for that service.

Recently, due to abuse of the system, Troy Hunt had to [add a limit][2] of one request per 1.5s.

The new version published on CRAN last night adds a delay into each call so that we can continue to use it in R.

Check out the [package on CRAN][3] for vignettes and more information on the package.

 [1]: https://haveibeenpwned.com/
 [2]: https://www.troyhunt.com/the-have-i-been-pwned-api-rate-limiting-and-commercial-use/
 [3]: https://cran.r-project.org/package=HIBPwned