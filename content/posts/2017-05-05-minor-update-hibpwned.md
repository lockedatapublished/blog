---
title: Minor update to HIBPwned
author: Steph

date: 2017-05-05T07:46:42+00:00
spacious_page_layout:
  - default_layout
categories:
  - R
tags:
  - api
  - censornet
  - haveibeenpwned
  - hibpwned
  - r

---
A new version of [`HIBPwned`][1] has been accepted onto CRAN. This occurred yesterday so it could still be filtering into some mirrors.

HIBPwned is an R wrapper for the useful website [HaveIBeenPwned][2] and if you don&#8217;t already utilise the package or the site &#8211; you should. HaveIBeenPwned tells you when your details are included in data breaches. This is vital information to get quickly as it means you can sooner protect yourself from people trying to use the breach information to break into your accounts.

This release is very minor. We previously had to put a rate limiting process on the API requests, when rate limiting was announced. It wasn&#8217;t done in a particularly elegant way, however. Since then, the package [`ratelimitr`][3] has come along and it gives us a sophisticated way of rate limiting the requests.

Get the package from CRAN with `install.packages("HIBPwned")` or install the GitHub version with `devtools::install_github("stephlocke/HIBPwned")`.

 [1]: https://cran.r-project.org/package=HIBPwned
 [2]: https://haveibeenpwned.com
 [3]: https://cran.r-project.org/package=ratelimitr