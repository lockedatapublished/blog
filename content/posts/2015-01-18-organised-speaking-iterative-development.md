---
title: Organised speaking – presentation design
author: Steph

date: 2015-01-18T10:52:45+00:00
categories:
  - Community
tags:
  - knitr
  - presentation
  - presenting
  - r
  - rmarkdown
  - speaking
  - user group

---
I wanted to outline my approach to presentation design, or development as I prefer to call it.

Why do I consider it development? Well, it&#8217;s a product that can be manually done & delivered but with the potential to scale to thousands of users, I&#8217;d rather the product be easy to maintain & deploy, deliver real value to the users, and keep up with cutting edge developments in the subject. Also, I call it development because now with the use of <a href="http://rmarkdown.rstudio.com/" title="Rmarkdown" target="_blank">rmarkdown</a>, I do actually code my presentations.

## General presentation design

I&#8217;ve read and studied a lot about presentations, some of the biggest influences being:
   
&#8211; Dr. Andrew Abela and the <a href="http://www.extremepresentation.com/" title="Extreme Presentation Method" target="_blank">Extreme Presentation Method</a>
   
&#8211; <a href="http://blogs.msdn.com/b/buckwoody/" title="Buck's blog" target="_blank">Buck Woody</a> and his fantastic presentation style
   
&#8211; <a href="http://www.brentozar.com/archive/2012/04/writing-better-conference-abstracts-presentations/" title="Brent's blog" target="_blank">Brent Ozar</a> and his excellent materials for presentations
   
&#8211; Solid fundamentals in presentation training courses (things like INTRO: Intro, Need, Title, Range, Objective)

When I first come up with the idea for a presentation, I write the abstract for it. In the abstract I set out the tone, material covered, and outline who should attend. This abstract is my requirements doc for later me &#8211; it tells me whether I&#8217;m selling, educating, or entertaining and what I&#8217;m doing it about.

In my opinion, you should always write the abstract first as not only can you write more abstracts than you can presentations but it distills the idea down and helps you think of your audience first.
  
<!--more-->

https://gist.github.com/stephlocke/acc1e12f45350b25a3f5

## The typical development process

The same sort of iterative dev process you might meet when designing software I apply to my presentations

<table>
  <tr>
    <th>
      Stage
    </th>
    
    <th>
      Translation
    </th>
  </tr>
  
  <tr>
    <td>
      Have idea
    </td>
    
    <td>
      Write abstract
    </td>
  </tr>
  
  <tr>
    <td>
      Build prototype
    </td>
    
    <td>
      Write section headers / outline
    </td>
  </tr>
  
  <tr>
    <td>
      Gain feedback
    </td>
    
    <td>
      Get Oz (and sometimes other peeps) to review
    </td>
  </tr>
  
  <tr>
    <td>
      Develop version
    </td>
    
    <td>
      Incorporate feedback into presentation
    </td>
  </tr>
  
  <tr>
    <td>
      Build version
    </td>
    
    <td>
      Make sure the presentation is done <em>before</em> the day
    </td>
  </tr>
  
  <tr>
    <td>
      Release
    </td>
    
    <td>
      Deliver the presentation
    </td>
  </tr>
  
  <tr>
    <td>
      Gain feedback
    </td>
    
    <td>
      Get organisers & attendees to feedback
    </td>
  </tr>
  
  <tr>
    <td>
      Iterate Develop > Build > Release > Gain Feedback
    </td>
    
    <td>
    </td>
  </tr>
</table>

## Core concepts

Behind the process sits a number of concepts that I feel really help:

  * Customer driven: I have a lot of ideas but only I build presentations when they&#8217;re requested so I&#8217;m only doing the right work
  * Build often: I now build my presentations in R using rmarkdown so that I can make a change and rebuild my presentation with ease
  * Source control: be able to restore if you make an error or liked an earlier version
  * Backups: have them because you&#8217;ll need them! I use <a href="https://github.com/stephlocke" title="Github user: Steph Locke" target="_blank">github</a>, dropbox and <a href="http://rpubs.com/" title="Rpubs" target="_blank">rpubs.com</a> for my presentations so that lots of things can go wrong but I can still present
  * Be open: I make my presentation source code available online so it can used and critiqued
  * Take feedback: I&#8217;m not perfect, nothing I produce is perfect, but I always want to be better so getting that feedback is vital

I&#8217;ll wax lyrical about using rmarkdown another time and I&#8217;ll do a case study with one of my presentations. I think you can apply the dev process and core concepts of strong software design to your presentations, even if you don&#8217;t code them. What techniques do you use that differ from or supplement the above?