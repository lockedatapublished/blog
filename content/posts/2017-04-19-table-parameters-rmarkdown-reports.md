---
title: 'R Quick Tip: Table parameters for rmarkdown reports'
author: Steph

date: 2017-04-19T08:50:30+00:00
spacious_page_layout:
  - default_layout
categories:
  - R
tags:
  - best practices
  - quick tip
  - r
  - rmarkdown

---
The recent(ish) advent of [parameters][1] in [rmarkdown][2] reports is pretty nifty but there&#8217;s a little bit of behaviour that can come in handy but doesn&#8217;t come across in the documentation. You can use table parameters for rmarkdown reports.

Previously, if you wanted to produce multiple reports based off a dataset, you would make the dataset available and then perform filtering in the report. Now we can pass the filtered data directly to the report, which keeps all the filtering logic in one place.

It&#8217;s actually super simple to add table parameters for rmarkdown reports.



We specify a `params` section and we create a parameter for our table. I use the `!r iris` bit to add default contents to the report so that I can generate the report easily.

With this fragment now, I could easily pass in a new dataset to this report.

<pre><code class="r">rmarkdown::render("MWE.Rmd", params = list(mytbl=mtcars))
</code></pre>

By being able to pass in tables to the report in the `params` argument directly, any filtering logic can now be kept external to the report and kept close to the iterator. This is pretty darn cool in my opinion!

 [1]: http://rmarkdown.rstudio.com/developer_parameterized_reports.html
 [2]: http://rmarkdown.rstudio.com/index.html