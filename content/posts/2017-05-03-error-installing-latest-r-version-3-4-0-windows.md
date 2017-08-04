---
title: Error installing latest R version (3.4.0) on Windows
author: Steph
type: post
date: 2017-05-03T17:57:13+00:00
spacious_page_layout:
  - default_layout
categories:
  - R
tags:
  - r
  - troubleshooting
  - windows

---
**UPDATE: R 3.4.1 does not have this problem so you can install that version instead**
  
If you&#8217;re getting the following error when you&#8217;ve installed R 3.4.0 on Windows, you&#8217;re not alone.

> Error in if (file.exists(dest) && file.mtime(dest) > file.mtime(lib) && :
     
> missing value where TRUE/FALSE needed 

The R team have released a patched version but right now it&#8217;s a little difficult to find out about. If you need/want the patched version, it&#8217;s available at:

[cran.r-project.org/bin/windows/base/rpatched.html][1]

This resolved the issue for me.

If you want more info on the issue and the resolution process, check out the [r-help archive][2].

Hope this helps!

 [1]: https://cran.r-project.org/bin/windows/base/rpatched.html
 [2]: https://www.mail-archive.com/r-help@r-project.org/msg243245.html