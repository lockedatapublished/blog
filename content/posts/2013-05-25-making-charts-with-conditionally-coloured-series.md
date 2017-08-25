---
title: Making charts with conditionally coloured series
author: Steph
type: post
date: 2013-05-25T16:05:54+00:00
categories:
  - Misc Technology
tags:
  - chart
  - Excel

---
The example I&#8217;m running through is available at <http://sdrv.ms/11lH3KR>

&nbsp;

The scenario we&#8217;re looking at is where we  want to be able to convey quality within a chart by having differently coloured columns, based on different conditions that we want to specify.  Unfortunately, the ability to natively apply conditional formatting isn&#8217;t yet present, but we can mimic it by overlaying series of the same size that are coloured differently.

&nbsp;

First thing you need is your data:

[<img class="alignnone size-full wp-image-8441" alt="dynamic colours - initial table" src="http://res.cloudinary.com/lockedata/image/upload/v1499851242/2013-05-25-17_10_12-Microsoft-Excel-Dynamic-colors_xat75b_qosxi3.png" width="286" height="193" />][1]

Then you need to add columns with formula that are of the structure **=if(condition to meet, number, &#8220;&#8221;)**

So&#8230;

[<img class="alignnone size-full wp-image-8451" alt="dynamic colours - extra columns added" src="http://res.cloudinary.com/lockedata/image/upload/v1499851243/2013-05-25-17_10_54-Microsoft-Excel-Dynamic-colors_jrqz9i_mzl0zi.png" width="461" height="197" />][2]

where Orange = IF([@[&#8216;# of tickets]]>=AVERAGE([&#8216;# of tickets]),[@[&#8216;# of tickets]],&#8221;&#8221;)

and Red = IF([@[&#8216;# of tickets]]>=PERCENTILE([&#8216;# of tickets],0.75),[@[&#8216;# of tickets]],&#8221;&#8221;)

You can now make a column chart and colour the series as required.  Make sure the series go from left to right in increasing priority.  Change any orders on the &#8216;Select Data&#8217; menu using the up and down arrows.

[<img class="alignnone size-medium wp-image-8391" alt="Dynamic colours - before overlap" src="http://res.cloudinary.com/lockedata/image/upload/c_scale,q_80,w_750/v1499851104/2013-05-25-16_58_50-Microsoft-Excel-Dynamic-colors_fefc6w_k2pc3i.png" width="500" height="297" />][3]

Once done, format a series and set overlap to 100%, and the job is done!

[<img class="alignnone size-medium wp-image-8401" alt="dynamic coulrs - overlap applied" src="http://res.cloudinary.com/lockedata/image/upload/c_scale,q_80,w_750/v1499851239/2013-05-25-17_02_48-Microsoft-Excel-Dynamic-colors_pqgse5_thls3p.png" width="500" height="293" />][4]

&nbsp;

Of course you can tidy it up a bit further

&nbsp;

[<img class="alignnone size-medium wp-image-8411" alt="dynamic colours - cleaned up" src="http://res.cloudinary.com/lockedata/image/upload/c_scale,q_80,w_750/v1499851240/2013-05-25-17_03_20-Microsoft-Excel-Dynamic-colors_c16fei_njagsb.png" width="500" height="277" />][5]

 [1]: http://res.cloudinary.com/lockedata/image/upload/v1499851242/2013-05-25-17_10_12-Microsoft-Excel-Dynamic-colors_xat75b_qosxi3.png
 [2]: http://res.cloudinary.com/lockedata/image/upload/v1499851243/2013-05-25-17_10_54-Microsoft-Excel-Dynamic-colors_jrqz9i_mzl0zi.png
 [3]: http://res.cloudinary.com/lockedata/image/upload//2013-05-25-16_58_50-Microsoft-Excel-Dynamic-colors_fefc6w.png
 [4]: http://res.cloudinary.com/lockedata/image/upload//2013-05-25-17_02_48-Microsoft-Excel-Dynamic-colors_pqgse5.png
 [5]: http://res.cloudinary.com/lockedata/image/upload//2013-05-25-17_03_20-Microsoft-Excel-Dynamic-colors_c16fei.png