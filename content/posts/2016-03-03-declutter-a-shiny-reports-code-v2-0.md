---
title: Declutter a shiny report’s code v2.0
author: Steph

date: 2016-03-03T13:40:34+00:00
categories:
  - Data Science
  - R
tags:
  - shiny
  - software development in r

---
I wrote a year ago on [a way to declutter shiny report code][1] which involved putting objects into a `source`d file, however, at that point in time the solution was a bit brittle and clunky. Now there&#8217;s a better way to develop shiny applications &#8211; shiny modules.

In October, RStudio introduced the concept of [modules][2] which involves abstracting code out into self-contained blocks.

Modules are ways of batching your code into discrete chunks &#8211; you keep all the code related to the inputs, manipulation, and presentation for doing something in one module. The really neat thing is that you can build modules based on other modules, enabling you to make composite modules or specific modules. Using a module requires you to source the code first to able to use it, but once you&#8217;ve done that you can create new instances of the module to suit your needs.

To get started, there is the [modules][2] post but beyond that I recommend refactoring one of your existing applications as ameans of learning how best to use them. I did this with my board pack report ([stephlocke/Rtraining/inst/apps][3] to [mangothecat/boardpack][4] ) and I found it very helpful to work my way through it. I did not find it helpful that I tried to add all sorts of bells and whistles in as I went so I really do recommend giving yourself a smack on the wrist each time you think &#8220;oo, I could use XXXX now!&#8221; &#8211; add features when it becomes easier to do so.

Having used modules, I think they&#8217;re a great way to go but I think many R users / developers will struggle with the art of knowing what to put into a module and how to build it for effective usage and future development. With modules we&#8217;re really far into the skillset learnt by standard software developers &#8211; the art of building classes &#8211; and there doesn&#8217;t seem to be a lot of help out there because for the most part &#8220;it depends&#8221;. Putting aside the art of deciding what should be in modules, I think more examples and some Rstudio integration like a shiny modules app project and some code skeletons will really help people get to grips with modules.

**Have you tried modules? What was your experience like?**

 [1]: https://itsalocke.com/declutter-a-shiny-reports-code/
 [2]: http://shiny.rstudio.com/articles/modules.html
 [3]: https://github.com/stephlocke/Rtraining/tree/master/inst/applications/boardpack2
 [4]: https://github.com/MangoTheCat/boardPack