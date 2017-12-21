---
title: Recent presentations
author: Steph
type: post
date: 2016-06-01T08:09:32+00:00
categories:
  - DataOps
  - Microsoft Data Platform
  - R
tags:
  - 'statuspost'
  - azureml
  - chocolatey
  - conferences
  - dataops
  - docker
  - mssql
  - powerbi
  - presentation
  - r
  - software development in r
  - sql server
  - user group

---
The last month or so has been a whirlwind of awesomeness with a veritable bevvy of user group and conference talks on my part! I thought I would share the materials with you and provide some <del>brief</del> thoughts on how each presentation went.

## Sessions

  * [SQL Saturday Exeter][1] : [Stats 101][2]
  * [London Business Analytics][3] (LBAG) : [Skilling up to code with data][4]
  * [SQLBits][5] & [TUGA][6] : [Cut the R Learning Curve][7]
  * SQLBits & TUGA : [R in the Microsoft Data Platform][8] (full day of training)
  * [IT Pro Portugal][9] : [Being lazy with infrastructure][10]

## SQL Saturday Exeter

My presentation, in my opinion, was exceedingly brave. One, I got people to fill in a survey real-time and I used that as the sole basis of my session &#8211; so relying on wifi, data entry skills & knowledge of what QR codes were. Two, my session aimed to introduce the concepts of statistics in a non-maths and non-technical way. The session worked out surprisingly well and the feedback received from the attendees bowled me over. I got a bit sidetracked with making snazzy revealjs slide decks but didn&#8217;t have chance to make the visualisations as good as I&#8217;d hoped before the presentation.

## LBAG

I really like the London BA Group run by [Mark Wilcock][11]. It&#8217;s an interesting blend of attendees, and they cover some excellent topics. They usually do a single session and then have beers & networking afterwards. I only wish it didn&#8217;t cost so much to travel to London from Cardiff so I could attend!

I did a session aimed at convincing people why they should shift from GUI to code, and I think it was fairly well-received. I hope I convinced people to go further down this route, and maybe they&#8217;ll start attending R User Groups in London like Chiin&#8217;s [R-Ladies Coding Club (London)][12], or Mango&#8217;s [LondonR][13]. As a beginner session to DataOps, I think it did OK but there&#8217;s definite room for tweaking to hit the right pain points!

## SQLBits

I was very lucky to deliver a training day with [Andrew Fryer][14], aiming to teach people R fundamentals in the morning and how to use R in the Microsoft Data Platform in the afternoon. We tried using [Microsoft Data Science VMs][15] but setting up infrastructure on the day caused us some delays. It then took me longer to get through the R fundamentals than I&#8217;d hoped. This left us with little time to get hands on with the Microsoft tools and we instead had to show demos. I didn&#8217;t have an adequate amount of assistants for providing help during exercises &#8211; the rule of thumb is one person per fifteen attendees. I think people, by and large, enjoyed the day and learnt a fair bit, but I think there was definite room for improvement!

<blockquote class="twitter-tweet" data-width="525">
  <p lang="en" dir="ltr">
    My first graph using R. Hurraaai <a href="https://twitter.com/SQLBits">@SQLBits</a> thank you <a href="https://twitter.com/DeepFat">@DeepFat</a> <a href="https://twitter.com/SteffLocke">@SteffLocke</a> 🙂 <a href="https://t.co/nxI7qWWO9Q">pic.twitter.com/nxI7qWWO9Q</a>
  </p>
  
  <p>
    &mdash; Pavel Málek (@malekpav) <a href="https://twitter.com/malekpav/status/727863982531448833">May 4, 2016</a>
  </p>
</blockquote>



One of the limitations of the training day is I don&#8217;t teach people much in the way of modern R. All the data manipulation is done in base R, charting is done in ggplot2, and we don&#8217;t have the time to teach people much in the way of administration or development best practices. Consequently, I was really happy to have a 2-hour session to provide an overview that tackled those issues. Only 15-20 minutes actually teaches people a little R, the rest was pure overview. I think this actually worked well, especially for the senior BI people who were evaluating whether R can work in their organisation. Perhaps the main issue with the session was I used the whole two hours &#8211; the poor attendees didn&#8217;t get a break in the middle or the opportunity to ask a huge amount of questions at the end.

<blockquote class="twitter-tweet" data-width="525">
  <p lang="en" dir="ltr">
    Completely packed room learning R from <a href="https://twitter.com/SteffLocke">@SteffLocke</a> at <a href="https://twitter.com/hashtag/SQLBits?src=hash">#SQLBits</a> 😀 <a href="https://t.co/5dVaGs5DDj">pic.twitter.com/5dVaGs5DDj</a>
  </p>
  
  <p>
    &mdash; Cathrine Wilhelmsen (@cathrinew) <a href="https://twitter.com/cathrinew/status/728538685449359360">May 6, 2016</a>
  </p>
</blockquote>



## IT Pro Portugal

Firstly, when [Andre Melancia][16] asked me if I&#8217;d like to present at the IT Pro group whilst I was in Portugal, I had to ask what an IT Pro was! This is something I hear a lot and it seems the key differentiator between an IT Pro and a developer is that any scripts an IT Pro writes are incidental to the job, not the outcome. Or perhaps from another perspective, an IT Pros scripts help them get their job done, whilst a developer produces scripts that allow others to get the job done.

I was rather nervous about talking infrastructure to a room full of people who would undoubtedly have 10 times more infrastructure knowledge than I did, but instead of tackling &#8220;core&#8221; infrastructure stuff like storage, I looked at some of the ways around my tendency to break my machine! Between a decent overview of [chocolatey][17], a reminder they ought to be using Powershell, and a view of how [Docker][18] can help try stuff without impacting their machines, it went alright. For the most part, people laughed with me, rather than at me, but I think I&#8217;d still be nervous about delivering the talk or similar again!

<blockquote class="twitter-tweet" data-width="525">
  <p lang="en" dir="ltr">
    <a href="https://twitter.com/hashtag/Recursive?src=hash">#Recursive</a> photo: Me snapping <a href="https://twitter.com/rramoscabral">@rramoscabral</a>, who's snapping the video camera that's filming <a href="https://twitter.com/SteffLocke">@SteffLocke</a>&#8230; <a href="https://twitter.com/ITProPT">@ITProPT</a> <a href="https://t.co/xDemcjMqRn">pic.twitter.com/xDemcjMqRn</a>
  </p>
  
  <p>
    &mdash; IT Pro Portugal (@ITProPT) <a href="https://twitter.com/ITProPT/status/732701486371745793">May 17, 2016</a>
  </p>
</blockquote>



## TUGA

At TUGA I got to do the same setup as Bits i.e. a training day on R & the Microsoft Data Platform, and my Cut the R Learning Curve session. There were some differences in terms of constraints:

  * I didn&#8217;t have Andrew as wingman
  * I didn&#8217;t have access to any Azure vouchers
  * I only had 70 minutes for my R session

I beefed up the sections on the Microsoft Data Platform, including using R to call SQL Server to call R! I also circumvented the requirement for people to install things on their machines by hosting a VM with SQL Server 2016 on, and another VM with RStudio Server &#8211; people were able to then use RStudio for the entire day. My attendees were fantastic and I felt the day went much better than the Bits version, not least because I was able to reclaim the better part of an hour from setup. I think I&#8217;m still a little light on the Data Platform, esp. because there are so many more prerequisite installations, and I&#8217;ll improve that over time.

The shorter R session went well. I knew I had to cover slides in less depth so that I could move faster through them, and this worked OK although I didn&#8217;t get to cover the administration considerations as much as I would have liked to. All in all, I&#8217;m quite happy with the slide deck and it seems to be a good mid-ground session between telling people how to do something and why they ought to do something.

<blockquote class="twitter-tweet" data-width="525">
  <p lang="en" dir="ltr">
    Post presentation shots with <a href="https://twitter.com/SteffLocke">@SteffLocke</a> 😁 <a href="https://t.co/Ixs4FqsonQ">pic.twitter.com/Ixs4FqsonQ</a>
  </p>
  
  <p>
    &mdash; Chrissy LeMaire (@cl) <a href="https://twitter.com/cl/status/734104820953534464">May 21, 2016</a>
  </p>
</blockquote>



**If you saw any of my presentations, please give me feedback! I can&#8217;t get better without it**
   
\[contact-form subject='[It%26#039;s a Locke&#8217;\]\[contact-field label=&#8217;Session seen&#8217; type=&#8217;text&#8217;/\]\[contact-field label=&#8217;Feedback&#8217; type=&#8217;textarea&#8217; required=&#8217;1&#8217;/\]\[/contact-form\]

 [1]: http://www.sqlsaturday.com/496/eventhome.aspx
 [2]: http://stephlocke.github.io/Rtraining/stats101.html
 [3]: http://www.meetup.com/London-Business-Analytics-Group/
 [4]: http://stephlocke.github.io/Rtraining/skillinguptocodewithdata.html
 [5]: http://sqlbits.com/
 [6]: http://tugait.pt/
 [7]: http://stephlocke.github.io/Rtraining/RLearningCurve.html
 [8]: http://stephlocke.github.io/RMSFTDP/
 [9]: https://www.facebook.com/ITProPortugal/
 [10]: http://stephlocke.github.io/Rtraining/lazyinfrastructure.html
 [11]: https://www.linkedin.com/in/zomalex
 [12]: http://www.meetup.com/R-Ladies-Coding-Club-London/
 [13]: http://www.londonr.org/
 [14]: https://twitter.com/deepfat
 [15]: https://azure.microsoft.com/en-gb/documentation/articles/machine-learning-data-science-provision-vm/
 [16]: https://twitter.com/AndyPT
 [17]: https://chocolatey.org/
 [18]: http://docker.com/