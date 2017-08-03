---
title: 'magrittr: cleaner program flow'
author: Steph
type: post
date: 2015-02-09T11:51:23+00:00
dsq_thread_id:
  - 3725706759
categories:
  - Data Science
  - R
tags:
  - magrittr
  - r
  - software development in r

---
Last year I built a pretty sweet web service in R as part of the day job. However, not being well-versed in stuff like object-oriented programming, I did not do the best job of making the flow of my program particularly clear or robust. It wouldn&#8217;t take multiple inputs properly and I found it to be tough to test. In spare moments, I took to cogitating how to improve things.

I tried simply refactoring some of the functions but found my structure too cumbersome to allow much change. I tried starting afresh with an <a href="http://adv-r.had.co.nz/OO-essentials.html" title="Advanced R - OO programming" target="_blank">S4 system</a> but was soon in a death spiral of class proliferation and no experience in how to stop it. After dabbling with different methods, I was getting pretty frustrated &#8211; I want my code to be better and more maintainable!

Now I&#8217;m looking at <a href="http://cran.r-project.org/web/packages/magrittr/vignettes/magrittr.html" title="magrittr vignette on CRAN" target="_blank">magrittr</a>.

## About magrittr

`magrittr` was designed to better facilitate <a href="http://adv-r.had.co.nz/Functional-programming.html" title="R for functional programming" target="_blank">functional programming</a> based on piping inputs from one function to another. It&#8217;s the same paradigm as the <a href="http://powershell.com/cs/blogs/ebookv2/archive/2012/03/12/chapter-5-the-powershell-pipeline.aspx" title="PowerShell Pipe operator explained" target="_blank">PowerShell operator <code>|</code></a>.

This means you can more succinctly pass an input through various transformation steps (in contrast to my initial method) with a lot less code. The ability to add conditional functions or even new functions on the fly (aka <a href="http://en.wikipedia.org/wiki/Anonymous_function" title="Lambda functions on wikipedia" target="_blank">lambda functions</a>) with a similarly low code burden gives the added benefit of helping with branching logic.
  
<!--more-->

## Example

Obviously, this is a contrived example but please bear with me! I want to take a subset of the iris data and produced a multiplied version of the figures.

  * The 1st method is my old way
  * the skeleton flow is how I mocked it together to make sure the overall logic was in place
  * The new method is how I fleshed out the component functions to deliver the results
  * The final file shows how you can build a function with multiple arguments and pass one main argument through &#8211; this is key for making conditional functions

I think there&#8217;s a massive increase in readability, succinctness and, ultimately, flexibility in the component functions. In terms of flows that work well in `magrittr`, I can highly recommend <a href="http://files.meetup.com/1225993/Hadley_Wickham_pipe-dsls.pdf" title="Pure, predictable, pipeable: creating fluent interfaces with R" target="_blank">Hadley&#8217;s presentation on the topic</a>.

https://gist.github.com/stephlocke/1749e0f9055947037ec2

## Quirks noticed

I struggled with my first hurdle &#8211; I wanted to write a skeleton high-level process and then add the functional flesh bit by bit. This meant I wanted lots of functions which didn&#8217;t do anything but simply passed through the data unaffected initially. The syntax for so many functions that could chain was tough. In the end I settled on `. %>% data.table` as `. %>% .` would lead to recursion issues.

<del datetime="2015-02-09T21:26:45+00:00"><br /> Additionally, I started off trying to make a function in the traditional syntax `myfnc<- function(x, y) { x } ` as I wanted to have arguments that could direct the flow inside lambda statements. Unfortunately, this didn't work too well as the arguments did not seem to stay in scope throughout the steps. I think this is something I need to do more RTFM / experimentation with.</del>

Courtesy of `magrittr`s author <a href="https://twitter.com/stefanbache" title="Stephan Milton Bache" target="_blank">Stephan Milton Bache</a>, I&#8217;m able to scratch that last quirk out as it was, as anticipated, an understanding issue on my part. Damn but I love open source when this sort of assistance happens!