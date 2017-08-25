---
title: Conference sessions – basic web scraping in R
author: Steph
type: post
date: 2015-01-11T16:56:22+00:00
categories:
  - Data Science
  - R
tags:
  - blogging
  - data analysis
  - presentations
  - r
  - r basics
  - web scraping

---
It&#8217;s a bit sad but I enjoy dissecting what sessions are submitted to conferences I&#8217;m involved in or speak at. Instead of doing it primarily by eye, I&#8217;ve started dabbling in web scraping in R to do it. Initially, I used RCurl and my latest snippet uses rvest.

The first snippet for <a href="http://sqlbits.com" title="SQLBits" target="_blank">SQLBits</a> bit of R code uses <a href="http://cran.r-project.org/web/packages/RCurl/" title="RCurl on CRAN" target="_blank">RCurl</a> but it&#8217;s cumbersome, plus for <a href="https://www.sqlsaturday.com/372/schedule.aspx" title="SQLSaturday Exeter" target="_blank">SQLSaturday Exeter</a> there is SSL to contend with. Using <a href="http://cran.r-project.org/web/packages/rvest/" title="rvest on CRAN" target="_blank">rvest</a> makes it really easy and it was an excellent excuse to get around to using <a href="http://cran.r-project.org/web/packages/magrittr/" title="magrittr on CRAN" target="_blank">magrittr</a>, Hadley Wickham&#8217;s pipe code paradigm for R.

Blogger tip: I also wanted the opportunity to see how Gists imported into WordPress &#8211; you just c&p the url in (into the code, no URL markup) and WordPress automatically pulls in the Gist. For more info on this see <a href="http://en.support.wordpress.com/gist/" title="Wordpress support - Gist" target="_blank">WordPress&#8217; article on Gist</a>.
  
<!--more-->

### SQLBits

This was my first stab at doing this and I&#8217;m sure I&#8217;ll upgrade it soon!
  
<figure id="attachment_59942" style="width: 500px" class="wp-caption alignnone">[<img src="http://res.cloudinary.com/lockedata/image/upload/c_scale,q_80,w_750/v1499851412/sqlbitssession_yxgi8m_nguwko.png" alt="SQLBits Session distributions" width="500" height="321" class="size-medium wp-image-59942" />][1]<figcaption class="wp-caption-text">SQLBits Session distributions</figcaption></figure>
  
https://gist.github.com/stephlocke/9784217

### SQLSaturday Exeter

This is the code with rvest in. I also took it a step further to do some preliminary analysis of speakers, and to have fun building a wordcloud!
  
<figure id="attachment_59951" style="width: 488px" class="wp-caption alignnone">[<img src="http://res.cloudinary.com/lockedata/image/upload/c_scale,q_80,w_750/v1499851413/exeterwordcloud_cbqhxs_hcu3gx.png" alt="SQL Saturday Exeter 2015 word cloud" width="488" height="500" class="size-medium wp-image-59951" />][2]<figcaption class="wp-caption-text">SQL Saturday Exeter 2015 word cloud</figcaption></figure>

<figure id="attachment_59961" style="width: 500px" class="wp-caption alignnone">[<img src="http://res.cloudinary.com/lockedata/image/upload/c_scale,q_80,w_750/v1499851414/exeterdistn_yrjb25_l2jtde.png" alt="SQL Saturday Exeter 2015 session level distribution" width="500" height="317" class="size-medium wp-image-59961" />][3]<figcaption class="wp-caption-text">SQL Saturday Exeter 2015 session level distribution</figcaption></figure>
  
https://gist.github.com/stephlocke/9687434109f49d80b957

 [1]: http://res.cloudinary.com/lockedata/image/upload//sqlbitssession_yxgi8m.png
 [2]: http://res.cloudinary.com/lockedata/image/upload//exeterwordcloud_cbqhxs.png
 [3]: http://res.cloudinary.com/lockedata/image/upload//exeterdistn_yrjb25.png