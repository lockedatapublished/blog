---
title: R on Windows – weird user name gotcha
author: Steph
type: post
date: 2015-02-07T18:40:09+00:00
categories:
  - R
tags:
  - r
  - windows
format: aside

---
Oz and I being the lazy so and so&#8217;s that we are, share a profile and use it across all our devices. Our username is &#8220;Steph & Oz&#8221; which means the user folder that Windows has for us is `C:UsersSteph & Oz`. Having spaces and special characters is generally not recommended, and gives interesting issues when using R, primarily at initialization and when trying to do package installations.

By default, R will try make the user&#8217;s personal folder the directory which it works under, i.e. limiting its impact on the computer overall, but it&#8217;s Unix/Linux roots mean that it doesn&#8217;t like you doing whacky things like ampersands in folder names.

The result with ours is to cause this error on load:

> Error installing package: Error: ERROR: no packages specified
    
> &#8216;Oz&#8217; is not recognized as an internal or external command,
    
> operable program or batch file.
    
> <!--more--><figure id="attachment_60951" style="width: 547px" class="wp-caption alignnone">

<img src="../img/R-wd-errror_aemelt_hhwtpu.png" alt="R wd errror" width="547" height="409" class="size-full wp-image-60951" /><figcaption class="wp-caption-text">R wd error screenshot</figcaption></figure> 

Now personally, I find the <a href="http://cran.r-project.org/doc/manuals/r-release/R-admin.html" title="R admin manual" target="_blank">R documentation</a> incredibly hard to understand and even the <a href="http://cran.r-project.org/bin/windows/base/rw-FAQ.html" title="R Windows FAQ" target="_blank">FAQs</a> were rather opaque. So here is the simple solution to this issue &#8211; change the default working directory to a place with no spaces or odd characters. To get this change working automatically you need to download this <a href="https://gist.github.com/stephlocke/2d9315e15515ba7fe333" title="Renviron.site download" target="_blank">Renviron.site</a> file, update to your preferred location and copy it into `C:Program FilesRR-3.1.2etc` (or the relevant `/etc` folder for your R version). You may need to elevate your permissions whilst you do this &#8211; I&#8217;m assuming a home PC so it shouldn&#8217;t be a problem to do so.
  
https://gist.github.com/stephlocke/2d9315e15515ba7fe333

### Warning

This will make all users of the computer have the same working directory, which means you can&#8217;t rely on the workspace being the same as how you left it. If you want to keep individual workspaces, change your username or create an alternative one to log into with R &#8211; I didn&#8217;t try changing the folder name as that way is likely to have lots of nasty side effects.