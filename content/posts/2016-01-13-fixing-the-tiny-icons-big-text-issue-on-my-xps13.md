---
title: Fixing the Tiny Icons, Big Text issue on my XPS13
author: Oz
type: post
date: 2016-01-13T17:32:14+00:00
categories:
  - Misc Technology
tags:
  - dell
  - icons
  - resolution
  - scaling
  - text
  - xps13

---
## The Issue

I love my Dell XPS13. It&#8217;s fast, sleek and gorgeous. It does however have one little problem: the icon and text size. The text was always too big for the buttons and boxes and the icons were so small you could hardly see them. This made it hard to use my machine without an external screen (which doesn&#8217;t have that issue and should have been my first clue!)<figure id="attachment_61507" style="width: 2062px" class="wp-caption aligncenter">

<a href="http://res.cloudinary.com/lockedata/image/upload/v1499850515/Example-of-the-text-and-icon-size-issue_x2xtxn.png" rel="attachment wp-att-61507"><img class="wp-image-61507 size-full" src="http://res.cloudinary.com/lockedata/image/upload/v1499850515/Example-of-the-text-and-icon-size-issue_x2xtxn.png" alt="Example of the text and icon size issue" width="2062" height="982" /></a><figcaption class="wp-caption-text">An example of the issue I was dealing with</figcaption></figure> 

<!--more-->

So OK, really I should have figured this out sooner, but I just put up with it thinking it was a fact of life. For the most part it was just annoying, but then I started to run into problems that were a bit more serious, like the file browser not showing up in some instances!<figure id="attachment_61508" style="width: 1387px" class="wp-caption aligncenter">

<a href="http://res.cloudinary.com/lockedata/image/upload/v1499850513/Wheres-my-file-browser_sbwfb8.png" rel="attachment wp-att-61508"><img class="size-full wp-image-61508" src="http://res.cloudinary.com/lockedata/image/upload/v1499850513/Wheres-my-file-browser_sbwfb8.png" alt="An example of the missing file browser" width="1387" height="970" /></a><figcaption class="wp-caption-text">Where&#8217;s my file browser?</figcaption></figure> 

So now it was personal, and I resolved to fix the issue once and for all. Here&#8217;s how I did it:

## The Fix

I&#8217;m running Windows 10, so things may look different for you, but hopefully this is still valid.

The issue comes from the&nbsp;scaling being applied to combat the high-resolution, so you&#8217;ll need to go to your Display Settings (the simplest way is to right-click your desktop)

From there look for the scaling option and set it to 100%, this will make everything fit more naturally.<figure id="attachment_61509" style="width: 2125px" class="wp-caption aligncenter">

<a href="http://res.cloudinary.com/lockedata/image/upload/v1499850512/Display-scale-setting-before_usjqjg.png" rel="attachment wp-att-61509"><img class="size-full wp-image-61509" src="http://res.cloudinary.com/lockedata/image/upload/v1499850512/Display-scale-setting-before_usjqjg.png" alt="The display scale settings" width="2125" height="1489" /></a><figcaption class="wp-caption-text">Display scale setting before changing it</figcaption></figure> 

This works well but some things still look pretty squished, this is because the default resolution for this device is a whacky&nbsp;3200 X 1800 which is well above what most programs are designed for. This is why the scaling is set as it is in the first place after all.

I would recommend changing the resolution to one more suited to most programs. Here I&#8217;ve gone for 1920 X 1080:<figure id="attachment_61510" style="width: 1034px" class="wp-caption aligncenter">

<a href="http://res.cloudinary.com/lockedata/image/upload/v1499850511/Sacrificing-the-resolution_xmmdua.png" rel="attachment wp-att-61510"><img class="size-full wp-image-61510" src="http://res.cloudinary.com/lockedata/image/upload/v1499850511/Sacrificing-the-resolution_xmmdua.png" alt="An example with the adjusted settings" width="1034" height="636" /></a><figcaption class="wp-caption-text">How it looks with resolution 1920 X 1080 and 100% scale</figcaption></figure> 

And now I finally have my file browser back!<figure id="attachment_61511" style="width: 709px" class="wp-caption aligncenter">

<a href="http://res.cloudinary.com/lockedata/image/upload/v1499850510/Theres-my-file-browser_e6xsp9.png" rel="attachment wp-att-61511"><img class="size-full wp-image-61511" src="http://res.cloudinary.com/lockedata/image/upload/v1499850510/Theres-my-file-browser_e6xsp9.png" alt="The file browser restored" width="709" height="519" /></a><figcaption class="wp-caption-text">There&#8217;s my file browser!</figcaption></figure> 

If you want to&nbsp;quickly change the resolution back to the full for watching films you could look into this solution on&nbsp;<a href="http://blogs.technet.com/b/heyscriptingguy/archive/2010/07/07/hey-scripting-guy-how-can-i-change-my-desktop-monitor-resolution-via-windows-powershell.aspx" target="_blank">Hey, Scripting Guy!</a>&nbsp;or into a neat little program called&nbsp;<a href="https://www.displayfusion.com/" target="_blank">Display Fusion</a>.

Does this solution work with earlier versions of Windows? What other ways have you found of fixing this? Let us know in the comments.