---
title: 'R Quick Tip: parameter re-use within rmarkdown YAML'
author: Steph

date: 2017-05-08T08:32:00+00:00
spacious_page_layout:
  - default_layout
categories:
  - R
tags:
  - quick tip
  - r
  - rmarkdown

---
Ever wondered how to make an rmarkdown title dynamic? Maybe, wanted to use a parameter in multiple locations? Maybe wanted to pass through a publication date? Advanced use of YAML headers can help!

Normally, when we write rmarkdown, we might use something like the basic YAML header that the rmarkdown template gives us.

    ---
    title: "My report"
    date: "18th April, 2017"
    output: pdf_document
    ---
    

You may already know the trick about making the date dynamic to whatever date the report gets rendered on by using the inline R execution mode of rmarkdown to insert a value.

    ---
    title: "My report"
    date: "`r Sys.Date()`"
    output: pdf_document
    ---
    

What you may not already know is that YAML fields get evaluated sequentially so you can use a value created further up in the `params` section, to use it later in the block.

    ---
    params:
      dynamictitle: "My report"
      reportdate: !r Sys.Date()
    output: pdf_document
    title: "`r params$dynamictitle`"
    date: "`r params$reportdate`"
    ---
    

By doing this, you can then pass parameter values into the `render()` function when you want to generate a report.

    rmarkdown::render("MWE.Rmd", 
        params=list(dynamictitle="New",
                    reportdate=Sys.Date()-1)
                    )
    

Parameter re-use within rmarkdown enables you to dynamically generate vital metadata for the report and use values in multiple places within the document. Very handy!