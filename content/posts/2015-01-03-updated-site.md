---
title: Updated site
author: Steph
type: post
date: 2015-01-03T16:21:11+00:00
socialauthorbio_custom_checkbox_meta:
  - 'a:1:{s:22:"DisableSocialAuthorBio";s:7:"Disable";}'
categories:
  - Misc Technology
tags:
  - '#statuspost'
  - azure
  - blog
  - mysql
  - wordpress
format: aside

---
As I&#8217;ve been using this blog more recently, the page speed has been becoming much more frustrating. So today, I&#8217;ve done some stuff to improve it and it&#8217;s now twice as fast as it used to be. Please let me know what you think of the new style!

<!--more-->

## Azure

I run all my stuff on Azure these days &#8211; it&#8217;s a UI I can cope with, in that it hides the complexities that Amazon used to foist on to me. Plus &#8211; MSDN credits!

### Site sizing

I had the site on the Shared mode.&nbsp;I&#8217;ve now changed this to Standard (S1) and configured it to auto-scale up to two instances if it&#8217;s experiencing sustained&nbsp;high CPU utilisation.

I also took the time to do site backups via the automated facility. I was also hoping to add New Relic monitoring to the site, but alas there is&nbsp;only a .Net agent site extension available on the Azure marketplace.

### Database

I&#8217;ve tried in the past running MSSQL compatible versions of WordPress but unfortunately many WordPress plugin writers do not write ANSI compliant code so you end up with a generally frustrating experience when you try to customise your site. Consequently, I&#8217;m stuck with the ClearDB MySQL databases that you get via Azure which generally seem slow and will encounter network latency for being out of the Azure networks. I will however comment that the ClearDB customer services is generally fantastic.

Up til today, I was using the default MySQL instance which only allowed 4 simultaneous connections. I&#8217;ve upgraded this to their next level, which&#8217;ll cost £5 a month but will allow 10 simultaneous connections.

It is a real shame that there is no MySQL provision on Azure &#8211; maintaining my own VM would be a pain I really don&#8217;t want to have, and the inability to use my MSDN credits with their partner is a drain on my cash. It may become more financially sensible to use a standard hosting provider in the long run.

## WordPress

### Caching

For the past few weeks I&#8217;d been trying the W3 Total Cache, which made no appreciable difference to site performance. I&#8217;ve now deactivated this and activated the file caching from WordFence, one of my security providers.

### Theme

One thing that I was concerned about was my theme &#8211; not all developers are made equal and as a result my theme might not be particularly well optimised. I&#8217;ve moved to the new WordPress 2015 theme that they&#8217;ve provided as it gives a similar look and feel but will have many more man-hours of optimisation behind it.

&nbsp;