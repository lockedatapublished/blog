---
title: 'R Quick Tip: Upload multiple files in shiny and consolidate into a dataset'
author: Steph

date: 2017-04-28T10:27:55+00:00
spacious_page_layout:
  - default_layout
categories:
  - R
tags:
  - quick tip
  - r
  - shiny

---
In [shiny][1], you can use the `fileInput` with the parameter `multiple = TRUE` to enable you to upload multiple files at once. But how do you process those multiple files in shiny and consolidate into a single dataset?

The bit we need from shiny is the `input$param$fileinputpath` value.

We can use `lapply()` with [data.table][2]&#8216;s `fread()` to read multiple CSVs from the `fileInput()`. Then to consolidate the data, we can use [data.table][2]&#8216;s `rbindlist()` to consolidate these into a dataset.

For more info on using data.table for consolidating CSVs, read my post on [`rbindlist()`][3]

If you wanted to process things other CSVs then you might consider alternative libraries, and of course, you don&#8217;t just need to put them all into one big table.

https://gist.github.com/stephlocke/c3299992ef3ac3efe1f978bd1cb0b4b2

 [1]: https://cran.r-project.org/package=shiny
 [2]: https://cran.r-project.org/package=data.table
 [3]: https://itsalocke.com/r-quick-tip-collapse-a-lists-of-data-frames-with-data-table/