---
title: Setting up WordPress on Azure
author: Steph
type: post
date: 2013-05-11T22:14:43+00:00
dsq_thread_id:
  - 3714606035
categories:
  - Misc Technology
tags:
  - azure
  - blogging
  - ec2
  - wordpress

---
This blog was configured super rapidly with goDaddy and Azure, instead of my previous implementation on EC2.  I&#8217;ve forgone the multi-site installation, with attendant subdomains, and gone for a straight wordpress Website (one of the Azure features).

I already had an Azure account I&#8217;d gone through the billing setup for &#8211; but that was really simple anyway, so getting the blog up and running consisted of:

&nbsp;

<!--more-->

1) Select new on the website tab on <https://manage.windowsazure.com/>

[<img class="alignnone size-medium wp-image-471" alt="azure - new website" src="../img/azurescreenshot1_ujw0yl_finrxl.png" width="300" height="217" />][1]

2)  Select &#8216;From Gallery&#8217;

[<img class="alignnone size-medium wp-image-481" alt="azure - new from gallery" src="../img/azurescreenshot2_k0uu1o_pvqvpq.png" width="300" height="203" />][2]

3) Select Blogs and WordPress

[<img class="alignnone size-medium wp-image-491" alt="azure - select wordpress" src="../img/azurescreenshot3_zbtenv_mbmv6m.png" width="300" height="209" />][3]

4) Specify URL (Azure only) and location

[<img class="alignnone size-medium wp-image-501" alt="azure - name and locale" src="../img/azurescreenshot4_tmk4ee_bed7as.png" width="300" height="196" />][4]

5) Change MySQL db name if not happy and tick t&cs for cloudDB

[<img class="alignnone size-medium wp-image-541" alt="azure - mysql config" src="../img/azurescreenshot5_juf2yb_o9fxrp.png" width="300" height="208" />][5]

Et voila &#8211; that is all the Azure setup required  Wait a little while for Azure to provision and spin up site.  Once done proceed with wordpress config&#8230; of specifying your admin details and blog name!

&nbsp;

So that was the super easy part where you have a blog named xxxx.azurewebsites.net but that doesn&#8217;t look hugely professional so you buy a domain, now what the heck is a CNAME, an A name and what do I to get it all up and running?  I used GoDaddy but hopefully the domain provider you&#8217;re using will offer something similar.

First things first you get Azure ready to have a domain name &#8230; this turns your blog from free to potentially chargeable.

1) Change scale to shared not free

[<img class="alignnone size-medium wp-image-561" alt="azure - scale change" src="../img/azurescreenshot7_fotciv_jjleem.png" width="300" height="227" />][6]

2) Save then go to the Configure tab and select manage domains

[<img class="alignnone size-medium wp-image-571" alt="azure - configure, manage domain" src="../img/azurescreenshot8_yccmal_jgxdhw.png" width="300" height="242" />][7]

3) Read the popup carefully and get ready to do what it says

[<img class="alignnone size-medium wp-image-581" alt="azure - manage domains" src="../img/azurescreenshot9_owes2v_kdrwmi.png" width="300" height="245" />][8]

4) Now go to your dns provider and make sure you have an A Record for the IP, a CNAME for www and a CNAME for the awverify

[<img class="alignnone size-medium wp-image-591" alt="godaddy - configure dns" src="../img/godaddy1_k87dli_skz628.png" width="300" height="78" />][9]

5) Then chuck in your shiny domain name into the Azure popup and when you see a tick appear, you&#8217;ll know all your DNS changes have been made and Azure is picking them up

6) Test by giving your domain a test drive

7) Change the URL on your wordpress config to match your new domain

&nbsp;

And that&#8217;s about it!  This was actually pretty painless, particularly in view of the headache I had with Amazon before

&nbsp;

&nbsp;

&nbsp;

&nbsp;

 [1]: ../img/azurescreenshot1_ujw0yl.png
 [2]: ../img/azurescreenshot2_k0uu1o.png
 [3]: ../img/azurescreenshot3_zbtenv.png
 [4]: ../img/azurescreenshot4_tmk4ee.png
 [5]: ../img/azurescreenshot5_juf2yb.png
 [6]: ../img/azurescreenshot7_fotciv.png
 [7]: ../img/azurescreenshot8_yccmal.png
 [8]: ../img/azurescreenshot9_owes2v.png
 [9]: ../img/godaddy1_k87dli.png