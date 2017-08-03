---
title: Declutter a shiny report’s code
author: Steph
type: post
date: 2015-02-18T11:41:21+00:00
categories:
  - R
tags:
  - r
  - reports
  - shiny
  - software development in r

---
Shiny reports are awesome, but they sure do end up with many lines of code when adding lots of inputs and outputs. A `ui.R` file can rapidly exceed 50 lines of code and I prefer to keep things more compact. The best way I&#8217;ve found of doing that in other languages and in R is to modularise my code &#8211; break it down into independent chunks. Shiny already does this by having a `server()` and `ui()` section and allowing you to <a href="http://shiny.rstudio.com/tutorial/lesson5/" title="Use R scripts and data" target="_blank">source other files</a>.

The arguments for most of the shiny functions are `...` which means you can pass it a list and it&#8217;ll parse all the items in the list. With this in mind, you can make list objects and use these instead of keeping all the individual components inline. Make a separate file that can be `source`d within the `server()` section.

Here is a <a href="https://gist.github.com/stephlocke/1ddbee9f050e818fef41" title="declutter shiny example" target="_blank">simple example</a> using the <a href="http://shiny.rstudio.com/articles/single-file.html" title="Single-file Shiny apps" target="_blank">single file</a> demo code. It has a new file which holds the input controls (in this case a trivial single line, but it could be any number of them) and then references this before the `server()` and `ui()` components are executed.

https://gist.github.com/stephlocke/1ddbee9f050e818fef41

This method should work, but there is another way of adding things to the environment for use by the `ui.R` file. You can <a href="http://shiny.rstudio.com/articles/scoping.html" title="Scoping rules for Shiny apps" target="_blank">utilise a <code>global.R</code> file</a>.