---
title: HIBPwned on CRAN
author: Steph
type: post
date: 2016-06-09T08:06:58+00:00
categories:
  - R
tags:
  - 'statuspost'
  - censornet
  - data breaches
  - hibpwned
  - r
  - security

---
Part of my (slowly) working pipeline of coding projects has been an R package that wraps the fantastic [HaveIBeenPwned.com][1] API.

If you&#8217;re not already familiar with HaveIBeenPwned, rectify the situation, NOW! Don&#8217;t worry about continuing to read the rest of the post; getting yourself signed up for account breach notifications is way more important!<figure style="width: 245px" class="wp-caption alignnone">

[<img src="http://i.giphy.com/3o7ZetIsjtbkgNE1I4.gif" width="245" height="160" alt="Go now! /giphy run" class />][2]<figcaption class="wp-caption-text">Go now!
  
/giphy run</figcaption></figure> 

With that stern admonishment out of the way&#8230;

[HIBPwned][3] is a feature complete R package that allows you to use every (currently) available endpoint of the API. It&#8217;s vectorised so no need to loop through email addresses, and it requires no fiddling with authentication or keys.

You can use HIBPwned to do things like:

  1. Set up your own notification system for account breaches of myriad email addresses & user names that you have
  2. Check for compromised company email accounts from within your company Active Directory
  3. Analyse past data breaches and produce charts like [Dave McCandless&#8217; Breach chart][4]

What you can&#8217;t do:

  1. Get account breaches for sensitive data breaches &#8211; these are by notification only
  2. Analyse account overlap between breaches
  3. Produce lists of common passwords

Barring the first item, it&#8217;s possible these could eventually be additional features that could be added to the API. If there are any features you&#8217;d like to see, make a [suggestion][5]. As always, Troy provides this vital service on his own dime, so do consider [donating][6] to support the site!

_PS We shifted HIBPwned to the [Censornet github][7] and released it from there as part of the company&#8217;s commitment to open source endeavours and the InfoSec community. Expect more in future!_

 [1]: https://HaveIBeenPwned.com
 [2]: http://i.giphy.com/3o7ZetIsjtbkgNE1I4.gif
 [3]: https://cran.r-project.org/package=HIBPwned
 [4]: http://www.informationisbeautiful.net/visualizations/worlds-biggest-data-breaches-hacks/
 [5]: https://haveibeenpwned.uservoice.com/forums/275398-general
 [6]: https://haveibeenpwned.com/Donate
 [7]: https://github.com/censornet/HIBPwned