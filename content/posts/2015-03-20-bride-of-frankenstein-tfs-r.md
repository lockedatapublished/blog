---
title: 'Bride of Frankenstein: TFS + R'
author: Steph

date: 2015-03-20T10:44:35+00:00
dsq_thread_id:
  - 3734047722
categories:
  - DataOps
  - Misc Technology
  - R
tags:
  - git
  - httr
  - productivity
  - r
  - software development in r
  - source control
  - tfs
  - tfsR
  - visual studio online
  - visual studio team services

---
The unholy abomination of trying to use TFS as my central repository for my R code over the past year has been tough and you may or not be looking at the screen as if I&#8217;m a crazy fool for even trying. Of course, now I have good news, because I&#8217;ve broken the back of the main issue I had with TFS. The crucial link was being able to programatically create Git repositories within a single project for small projects.

Using the API, I&#8217;ve been able to write an <a title="tfsR" href="https://github.com/stephlocke/tfsR" target="_blank">R package</a> with functions that now save me at least 15 minutes of time and effort each time I want a new project. So I can happily holler &#8220;IT&#8217;S ALIVE!!&#8221;

<!--more-->

_What&#8217;re you source controlling?_ Well, we have internal developments like R packages, and we have a lot of analysis we&#8217;re doing in R. I also have databases, some web apps and a few other bits and bobs. I&#8217;m a firm believer that many of the best practices of developers are also best practices for DBA and BI professionals, whether we know it or not yet. This means stuff like source control, unit testing, continuous integration, and eventually continuous deployment are big goals in my mind. Therefore I&#8217;m trying to source control pretty much everything that is a script or documentation i.e. all databases, reports, manuals etc.

_Great goal but still, why TFS?_ <a title="TFS Overview" href="https://www.visualstudio.com/en-us/products/tfs-overview-vs.aspx" target="_blank">Team Foundation Server</a> is/was (depending on who you ask) the de facto source control system of the Microsoft IT shop. It has a bunch of current or emerging plus points in its favour:

  * IT are already using it
  * Theoretically, it has nifty build & testing tools/integration
  * The project management layer is quite useful
  * You can use the git engine, instead of the traditional centralised system, so it&#8217;ll work with R etc
  * The recent <a title="VS Online overview" href="https://www.visualstudio.com/en-us/products/what-is-visual-studio-online-vs" target="_blank">Visual Studio Online</a> means that you can start doing your dev in the cloud
  * <a title="VS Community Edition" href="https://www.visualstudio.com/products/visual-studio-community-vs" target="_blank">Visual Studio Community Edition</a> will see more support for open source languages in the future

_But, why not GitHub?_ Well <a title="GitHub" href="https://github.com/" target="_blank">GitHub</a> is super neat and we do release some of our open source stuff on their but we do need commercially sensitive or internal only things to be private and it costs (relatively) a fair bit to use GitHub for BI when you could easily spawn 50 private repos per quarter.

_So, why not BitBucket?_ <a title="BitBucket" href="https://bitbucket.org" target="_blank">BitBucket</a> gives you unlimited private repos and has lots of bells and whistles. This was going to be my next port of call, if I couldn&#8217;t get TFS working.

_OK, I take your point, so what&#8217;s the problem?_ Project creation! When I want to create a project to put some analysis in, I have to open Visual Studio, create a blank solution, go to the Team Explorer pane, tell it to create a new project, go through more than 5 panes of a wizard, wait ages for the sharepoint and SSRS guff to be configured, then switch over to Rstudio (on my linux box dontchaknow) server, pull the blank repository, create a project in it (or drop all my files), commit, then push my project skeleton in. That was incredibly painful. That was compounded by a couple of other facts:
  
1. Visual Studio, is a horrible program when it comes to updates. Most recently, I was unable to use database projects due to a botched upgrade (needed UAC, fine got an admin to put in the details, but _also_ needed to be running VS as an admin, which it didn&#8217;t say until it broke), and of course VS is almost impossible to completely uninstall/repair which meant a complete rebuild. So I hate having to rely on it!
  
2. I have MSDN but do I want to give my head of finance, and myriad other people Visual Studio just to be able to work safely? It&#8217;s a big cost and effort sink. Plus the cognitive dissonance involved for them when I say so to use R, you need to open this completely unrelated program. This was more important, when we weren&#8217;t looking at VS Online.

_Arg, stop talking! I&#8217;m frustrated just listening to you!_ Totally understandable my dear chum, so after a long while of investigating <a title="git-tfs" href="https://github.com/git-tfs/git-tfs" target="_blank">git-tfs</a>, <a title="Cross-Platform Command-Line Client" href="https://msdn.microsoft.com/en-us/library/hh873092(v=vs.110).aspx" target="_blank">Cross-Platform Command Line</a> and finding none could create projects, a delightful chap called <a title="Buck Hodges' blog" href="http://blogs.msdn.com/b/buckh/" target="_blank">Buck Hodges</a> at Microsoft pointed me in the direction of the <a title="Visual Studio Online Git API" href="https://www.visualstudio.com/integrate/api/git/overview" target="_blank">API</a> and suggested creating repositories inside projects. For me, they&#8217;d been the same but no, you can hold many repositories in a single project, and you can create these projects with a call to an API. This made me literally jump for joy and start yammering to Jan, my colleague.

_So now what?_ The icing on the cake, is that using Hadley&#8217;s awesome <a title="httr package" href="https://github.com/hadley/httr" target="_blank">httr</a> package, I&#8217;ve been able to put together an R package that allows you to create repositories in a TFS project inside R so that people never have to go outside Rstudio (or their favourite R IDE) to do their source control work.

_What&#8217;s the catch?_ If you want a standalone project, you still have to go through the old process, and I haven&#8217;t tested on older TFS versions.

_Bye, you crazy so-and-so_ Bye, and if you find yourself wanting to avoid using Visual Studio for managing TFS do take a look at how I&#8217;ve <a title="tfsR" href="https://github.com/stephlocke/tfsR" target="_blank">interacted with the API</a> and write your own tool in the language of your choice.
  
<span style="color: #339966;"><strong>UPDATE: Project creation is nowhere near so bad in VSO &#8211; you can create on the site and the use the instructions to force a local repository into the online one. Although you may have to move some of the arguments around in the <code>git push</code> command VSO gives you.</strong></span>