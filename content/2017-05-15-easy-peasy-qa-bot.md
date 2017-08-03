---
title: 'Easy-peasy Q&A bot'
author: Steph
type: post
date: 2017-05-15T08:00:27+00:00
spacious_page_layout:
  - default_layout
categories:
  - Microsoft Data Platform
  - Misc Technology
tags:
  - azure functions
  - bot services
  - bots
  - qnamaker
  - skype
  - wordpress

---
Everyone seems to have a live chat option for their site but I&#8217;m frequently away, so I wanted something that people could talk to interactively. This is a perfect scenario for a Q&A bot. Microsoft takes a ton of the pain out of Q&A bots, and it was much easier than I thought to get it added to my WordPress blog. Here is a how to do it for your site.

# Prerequisites

  * A login for Microsoft services
  * An Azure subscription _<-Did you know you can get **free** credit through their [Dev Essentials Program][1]?_
  * A willingness to follow some documentation as instructions might change over time

## Getting started &#8211; Q&As

The first thing we need is our Q&A service. Microsoft make this trivial with their site [qnamaker.io][2].

  * You may need to go through the Create an App process when you first use it. This will hook up to your Azure account, so make sure you&#8217;ve already got a working subscription but it simply gets you some keys.
  * You can have QnA Maker scrape an FAQ page, upload some FAQs, or write your own. _<- Don&#8217;t worry you can add to them later!_<figure id="attachment_62204" style="width: 750px" class="wp-caption aligncenter">

<img src="http://res.cloudinary.com/lockedata/image/upload/h_699,w_750/v1499849510/QNAMaker_c6xkuk.png" alt="Q&A bot starter page" width="750" height="699" class="size-large wp-image-62204" /><figcaption class="wp-caption-text">Q&A bot starter page</figcaption></figure> 

  * Add utterances and responses to your Q&A bot
  * Save and train your bot
  * Give the bot some testing (you can use this an easier way to add additional ways of saying questions)
  * Re-save if you make changes
  * Hit publish
  
    <figure id="attachment_62205" style="width: 750px" class="wp-caption aligncenter"><img src="http://res.cloudinary.com/lockedata/image/upload/h_217,w_750/v1499849509/QNAPROCESS_cezbym.png" alt="Q&A bot development process" width="750" height="217" class="size-large wp-image-62205" /><figcaption class="wp-caption-text">Q&A bot development process</figcaption></figure>
  
    This gives you a Q&A webservice but it&#8217;s not quite a bot.

## Make it into a bot

Now we need to go to [Azure][3] and finish our bot.

Add a new **Bot Service**. You&#8217;ll need to give it a name and set which region you want to host it in. It will then setup everything in the background, and takes a couple of minutes.

Once it is successfully deployed, navigate your bot service and Create an App, making sure to copy and paste the values from the new tab into the interface. Select the Q&A Bot type. It should bring up a poppup that allows you to select your bot from a dropdown.
  
<figure id="attachment_62206" style="width: 750px" class="wp-caption aligncenter"><img src="http://res.cloudinary.com/lockedata/image/upload/h_694,w_750/v1499849507/BOTSETUP_slb930.png" alt="Bot Service setup" width="750" height="694" class="size-large wp-image-62206" /><figcaption class="wp-caption-text">Bot Service setup</figcaption></figure>

Once it&#8217;s deployed &#8211; you can run away from all that code!

Hop over to [botframework.com][4] to manage your bot. Fill in info like a logo and a description.

## Put the bot on Skype

The easiest way of getting the bot on WordPress is to wrap it in the Skype web control. This is again a no-code required activity.

We can easily grab the Skype bot embed code from the Bot Framework site but I preferred using a tool that allowed me to theme my Skype tool. Before we get to the customisation, navigate to your bot&#8217;s settings and grab it&#8217;s ID.
  
<figure id="attachment_62207" style="width: 750px" class="wp-caption aligncenter"><img src="http://res.cloudinary.com/lockedata/image/upload/h_85,w_750/v1499849506/BOTID_m2yrvg.png" alt="Q&A Bot ID" width="750" height="84" class="size-large wp-image-62207" /><figcaption class="wp-caption-text">Q&A Bot ID</figcaption></figure>

Now we can go to the [Skype Web Control Generator][5] and customise the look of our Skype control.
  
<figure id="attachment_62208" style="width: 750px" class="wp-caption aligncenter"><img src="http://res.cloudinary.com/lockedata/image/upload/h_390,w_750/v1499849505/SKYPECUSTOMISER_bxy6ea.png" alt="Customise the Q&A bot&#039;s appearance" width="750" height="390" class="size-large wp-image-62208" /><figcaption class="wp-caption-text">Customise the Q&A bot&#8217;s appearance</figcaption></figure>

Copy the code this generates.

## The last piece &#8211; WordPress widgets

Hopefully, you have a theme with a footer that supports widgets. This make it super easy to add your Q&A Bot, if not you can use widgets elsewhere or add the code to your theme.

Go to the Widgets area of you Admin site (or do live customisation) and select a **Text** widget and drag into a footer widget area.
  
<figure id="attachment_62209" style="width: 477px" class="wp-caption aligncenter"><img src="http://res.cloudinary.com/lockedata/image/upload/v1499849504/WIDGETSPACE_uevldl.png" alt="Add a Text Widget" width="477" height="188" class="size-full wp-image-62209" /><figcaption class="wp-caption-text">Add a Text Widget</figcaption></figure>

Now paste in the code from the Skype Web Control generator and Save!

## Final result

This gives us a floating button on our WordPress blog that allows people to ask questions and get responses back. We can continue to improve our Q&A bot over time, and I need to work on boosting the bot&#8217;s cleverness by utilising [LUIS][6], but I wanted to show you how you can get something pretty darn clever without writing a single line of code. The nifty thing is that it&#8217;s entirely free for under 10,000 transactions per month and super cheap after then. Have a play on my [site][7] and let me know if you make your own bot!
  


PS Many thanks to [Galiya][8], a fab Bot lady at Microsoft, who pointed me in the right direction for the skype control!

 [1]: https://www.visualstudio.com/dev-essentials/
 [2]: https://qnamaker.ai
 [3]: https://portal.azure.com
 [4]: https://dev.botframework.com/bots
 [5]: https://dev.skype.com/webcontrol
 [6]: https://www.luis.ai
 [7]: https://itsalocke.com
 [8]: https://twitter.com/galiyawarrier