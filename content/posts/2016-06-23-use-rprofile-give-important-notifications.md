---
title: Use your .Rprofile to give you important notifications
author: Steph
type: post
date: 2016-06-23T09:08:43+00:00
categories:
  - Data Science
  - R
tags:
  - best practices
  - hibpwned
  - r
  - security

---
In R, we can use a file called .Rprofile to do things in R based on a number of triggers. One thing I&#8217;ve done is give myself a DIY notification of how many data breaches I&#8217;ve been involved in!

First of all, you need a file called .Rprofile that&#8217;s stored in your working directory. Some useful resources about .Rprofiles can be found on [.Rprofile CRAN docs][1] and [an .Rprofile intro][2].

Now inside that file, you can add a number of functions that are based on a number of events like loading or closing R. I need a `.First` function for on load and whatever I produce has to be able to print to the console with `cat()`.

With that in mind, instead of showing details, I chose to show the number of breaches I&#8217;m in. You can get [HIBPwned][3] from CRAN and use it to query the awesome website [HaveIBeenPwned.com][4].

One thing that&#8217;s neat about the `account_breach()` function is that I can query multiple email addresses or user formats to get info. Here is my .Rprofile file that gives me notifications on load for data breaches:

[embedGist source=&#8221;https://gist.github.com/stephlocke/74add36831110906c5c784c194def859&#8243;]<figure id="attachment_61656" style="width: 768px" class="wp-caption aligncenter">

<img class="size-medium_large wp-image-61656" src="../img/console_vjc0rh.png" alt="console .Rprofile result" width="768" height="103" /><figcaption class="wp-caption-text">console .Rprofile result</figcaption></figure>

 [1]: https://stat.ethz.ch/R-manual/R-devel/library/base/html/Startup.html
 [2]: http://www.r-bloggers.com/fun-with-rprofile-and-customizing-r-startup/
 [3]: https://cran.r-project.org/package=HIBPwned
 [4]: https://haveibeenpwned.com