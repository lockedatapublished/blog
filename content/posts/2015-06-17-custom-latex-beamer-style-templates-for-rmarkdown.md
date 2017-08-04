---
title: Custom LaTeX Beamer style templates for rmarkdown
author: Steph
type: post
date: 2015-06-17T12:34:22+00:00
categories:
  - Community
  - R
tags:
  - hacks
  - latex
  - presentation
  - presenting
  - r
  - rmarkdown
format: aside

---
I&#8217;ve been producing presentations via R using [rmarkdown][1] and outputting to either ioslides or slidify. That was excellent, because I could provide a CSS that customised the look and feel (relatively) easily*.

However, when I wanted to produce a PDF version, I couldn&#8217;t make ones that look as good as the pure LaTeX versions I could make on [overleaf.com][2]. So I started RTFMing when I wanted to replicate the look and feel from my presentation, The LaTeX Show.

I didn&#8217;t want to spend a huge amount of time on it, so this little story of hack and slash may feel a bit dirty to you!

<!--more-->

In [my LaTeX deck][3], I had a bunch of associated .sty files &#8211; I copied these down into the directory with my .Rmd file. I then passed in the YAML header `theme: m` and hit Compile PDF in Rstudio.

_It errored!_

But that was only to be expected because I was in a different environment etc, so&nbsp;I started looking at the error messages and commenting out bits of the style until it worked. Stuff included fonts, needing XeLaTeX, and some missing packages.

_It still didn&#8217;t work!_

I eventually got to an error regarding an unknown `Shaded` environment. Swift googling told me that this is sometimes caused by out of date pandoc templates so I went to the github repo & copied the [latest beamer template][4] into a local .tex file and gave that file name in the YAML header for the template.

_Et voila!_

A consistently themed presentation written in rmarkdown and rendered in ever so pretty LaTeX, was achieved in about half an hour of reading, hacking, and googling. You can view my [working example][5] on github and have a play yourself.

&#42; Finding out what elements need styling can be a bit painful &#8211; if you don&#8217;t already have it, I recommend (as per Hadley Wickham&#8217;s recommendation in rvest) that you use [Selector Gadget][6] for working out what elements you need to use. You can also use Chrome&#8217;s developer functionality (hit F12) which allows you to real-time tweak some values and see what effect it has.

 [1]: http://rmarkdown.rstudio.com/
 [2]: http://overleaf.com
 [3]: https://www.overleaf.com/read/zfthwjkxjycm
 [4]: https://github.com/jgm/pandoc-templates/blob/master/default.beamer
 [5]: https://github.com/stephlocke/Rtraining/tree/master/inst/slidedecks/RsFromElbow
 [6]: http://selectorgadget.com/