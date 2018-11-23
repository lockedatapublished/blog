---
title: "Python into rmarkdown and bookdown"
author: "Rita Giordano"
date: '2018-11-23'
slug: Python-into-rmarkdown-and-bookdown
categories: [Data Science, Python]
tags: [reticulate, R Studio, R Markdown, Bookdown, python]
draft: yes
---

Python into R?
==============

Usually, I program in Python using Jupyter or Emacs to write the code and I compile the code using the command line by shell. However, while working at Lockedata I wrote some Python training material and I used **R Markdown** and **Bookdown** packages. To include and run piece of Python code in R is very easy with the package **reticulate**. However, I am an enthusiast R user and I think that is delightful to have the possibility to program in Python using the functionality of Rstudio! This was for me the beginning of a interesting experience. I love to mix the two programming languages, I already used time by time *rpy2* with Python in Jupyter notebook to output plot using **ggplot2**. Knowing that I could program in Python using R and RStudio looks to me as a great opportunity to save and enjoy my time! In this post I will present you my experience, but first a bit of context.

Reticulate
==========

Prior to use Python in R environment is required to employ the library **reticulate**. Reticulate is an RStudio package, which provides an interface between Python and R. This package allows to call Python from R, sourcing Python scripts and call Python from R Markdown. Reticulate make also easy the translation between Python and R objects. To use reticulate in R Markdown and Bookdown the first things to do is to call the package in the first chunk.

``` r
library(reticulate)
```

Now R, knows that I want to play with Python! With reticulate is also possible to see different conda environment by specifying it, for example in my case:

``` r
use_condaenv("py36")
```

I specify that I want use the environment that contains Python version 3.6.

Python into R Markdown and Bookdown
===================================

### R Markdown

R Markdown is a very powerful package for writing text that can include piece of code. To include piece of Python code into R Markdown file is very easy, first need to insert a Python chunk, and put your code inside. The advantages of using Python inside R Markdown is that is possible to add texts, description and caption to the figure with only one document. This is very useful if we want to write a blog post or a technical report where is required to show the codes and not only the results. It is also interesting for preparing teaching material and presentation. Here a simple example of Python code inside R Markdown and how to use a Python data frame to create a plot with ggplot2.

``` python
import pandas as pd
# create a data frame
d = {'x':[1,2,3], 'y': [2, 3, 5]}
df = pd.DataFrame(data = d)
print(df)
```

    ##    x  y
    ## 0  1  2
    ## 1  2  3
    ## 2  3  5

``` r
library(ggplot2)
ggplot(py$df, aes(x, y)) + geom_point() + theme_bw()
```

![](Python-into-rmakdown_files/figure-markdown_github/unnamed-chunk-4-1.png)

We see in this example that the Python object `df` is accessible to R using the magic keyword `py`.

### Bookdown

Bookdown is a package that is used to write books, it generates index and all is needed to have a real book on the web and technical documents using R Markdown. Regarding the use of python into bookdown, this was for me a real surprise. In this case for me was very easy to prepare the Python materials, inserting also useful picture to explain difficult concepts and output all Python codes. In bookdown, you need to insert all the informations about reticulate and your environment in the file *index.Rmd*. Here and example:

You can also select the option for the prompt if you want print the piece of python code as a python console.

Conclusion
==========

Now some of you that are reading this post is asking him/herself: Why I have to use R markdown to include Python codes? You could use jupyter of course, but if you are an R/Python User why not use R? If you have already R Studio installed on your system is very easy to write text and Python code using R Markdown. In R is easy, fast and you can have different output using R Markdown, you could also prepare slides for presentation including your Python codes.
