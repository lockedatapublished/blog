---
title: 'Quick tip: knitr Python Windows setup checklist'
author: Steph

date: 2017-02-22T16:01:15+00:00
categories:
  - Data Science
  - Misc Technology
  - R
tags:
  - knitr
  - python
  - quick tip
  - windows

---
One of the nifty things about using R is that you can use it for many different purposes and even other languages!

If you want to use Python in your [knitr][1] docs or the newish RStudio R notebook functionality, you might encounter some fiddliness getting all the moving parts running on Windows. This is a quick knitr Python Windows setup checklist to make sure you don&#8217;t miss any important steps.

  1. **Install Python** 
      * I like [Anaconda][2] as it&#8217;s one of the nicest Windows install experiences
      * Try to install for everyone
  2. **Add python to your system&#8217;s PATH** 
      * Here&#8217;s some [general Windows instructions][3] 
      * Here are [Windows 10 instructions][4]
  3. **Restart RStudio** or open it now 
      * The restart is because the PATH would likely have been cached so restarting adds the python executable to your RStudio environment
  4. **Create an rmarkdown document** or R Notebook
  5. **Use chunks beginning with `{python chunkname}`** to execute some code in Python instead of the usual `{r chunkname}`<figure id="attachment_61967" style="width: 602px" class="wp-caption aligncenter">

<img src="../img/SYSTEMVARIABLE_qrhk4u.png" alt="Environment variable editor for PATH in Windows 10" width="602" height="664" class="size-full wp-image-61967" /><figcaption class="wp-caption-text">Environment variable editor for PATH in Windows 10</figcaption></figure>

 [1]: https://yihui.name/knitr/
 [2]: https://www.continuum.io/anaconda-overview
 [3]: http://windowsitpro.com/systems-management/how-can-i-add-new-folder-my-system-path
 [4]: https://betanews.com/2015/11/23/windows-10-finally-adds-a-new-path-editor/