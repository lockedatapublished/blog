---
title: Organised speaking – Intro to R case study
author: Steph

date: 2015-01-21T09:48:28+00:00
categories:
  - Community
  - R
tags:
  - presentation
  - presenting
  - rmarkdown
  - speaking

---
In my <a href="https://itsalocke.com/index.php/organised-speaking-iterative-development/" title="Organised speaking – presentation design" target="_blank">iterative presentation design post</a> I promised a case study. I thought I&#8217;d cover my most presented session _Intro to R_, in future called _Knowing your Rs from your elbow_ courtesy of <a href="http://twitter.com/fatherjack" title="Father Jack" target="_blank">@FatherJack</a>.

## A brief history

Where I&#8217;ve been using R for the past couple of years and spent the first months struggling with it, I wanted to give a presentation that I would have wanted to see at the beginning. Not one about random bagging and a bunch of other stats but what are the _best_ ways to do the fundamentals:

  * connecting to my database
  * performing data manipulations, summaries and updates
  * charting my data
  * producing reports

A few packages cover these awesomely and are much better than base R so whilst I was tackling a massive stats project, the things which took the time and stress were things I could have avoided with ease!

So my intro to R, takes people through the things I wish I&#8217;d been taken through thus making those first few months of R pleasant, happy times!
  
<!--more-->

## Version history

Here is the chronology of my presentation to date

  * 25/01/2014 &#8211; Initial prototype &#8211; Cardiff User Group
  * 22/03/2014 &#8211; 1st commit &#8211; SQLSaturday Exeter
  * 03/07/2014 &#8211; UAT &#8211; SQLMidlands user group
  * 19/07/2014 &#8211; Deployed to live &#8211; SQLBits
  * 25/08/2014 &#8211; Minor update &#8211; PASS BI VC
  * 13/10/2014 &#8211; Stress testing &#8211; SQLRelay
  * 20/01/2015 &#8211; Rewrite &#8211; London Business Analytics Group

## Change log (date ascending order)

  1. My <a href="http://rpubs.com/stephlocke/rintro" title="First available Intro to R deck" target="_blank">first major iteration</a> was done in the R presentation format that Rstudio at the time &#8211; it was a markdownesque variant that produced a LaTeX slide deck. I included a number of not too great charts and primarily focused on why you should use it instead of some BI tools and outlining a lot off the features. 40 slides. Lots of people willing to give the R puns a go.
  2. My <a href="http://rpubs.com/stephlocke/Rintro2" title="Intro to R - second iteration" target="_blank">SQLMidlands iteration</a> had a modular basis and used rmarkdown. It was a significantly trimmed presentation compared to the first version. By trying to cover less, I was able to spend more time doing the job of explaining how the code worked. Also 40 slides but had lots of white slides to give me an opportunity to pause and reflect with people.
  3. I trimmed still further for the <a href="http://rpubs.com/stephlocke/sqlbits" title="Intro to R - sqlbits edition" target="_blank">SQLBits iteration</a> post SQLMidlands, shoehorned in some crummy examples of joins at the last-minute, and made the charts much nicer. 33 slides. By far the most responsive audience to date!
  4. I didn&#8217;t really change much between Bits and my latest iteration &#8211; partly, it was good enough and I was busy, and partly because I wanted to practice my speaking on a known deck.
  5. My <a href="https://rawgit.com/stephlocke/Rintro/master/Rintro.html" title="London Business Analytics Group - Intro to R" target="_blank">latest iteration</a> had a significant overhaul. I rebuilt entirely from scratch, focusing on the &#8220;Scenario&#8221; and took people through things as a workflow. I cut out more extraneous stuff and focused on making the content bigger (part of the weaknesses identified during Relay) by splitting the code and the tables & charts. I also went for more reproducability and tried to push people to the <a href="https://github.com/stephlocke/Rintro" title="The intro to R GitHub repo" target="_blank">Github repository</a> to emphasise the play along nature of the task. 32 slides.

_I&#8217;m already starting to think of ways I can improve it further, and if you saw my session at the <a href="http://www.meetup.com/London-Business-Analytics-Group/" title="London Business Analytics Group" target="_blank">London Business Analytics group</a>, why not let me know what you think I could improve?_