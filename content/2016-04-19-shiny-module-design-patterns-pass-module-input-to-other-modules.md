---
title: 'Shiny module design patterns: Pass module inputs to other modules'
author: Steph
type: post
date: 2016-04-19T10:15:19+00:00
categories:
  - Data Science
  - R
tags:
  - best practices
  - r
  - shiny
  - shiny design patterns
  - software development in r

---
Continuing in the series of [shiny module design patterns][1], this post covers how to pass all the inputs from one module to another.

## TL;DR

Return `input` from within the server call. Store the `callModule()` result in a variable. Pass the variable into arguments for other modules. Access the variable like you would `input`. [Steal the code][2] and, as always, if you can improve it do so!

<!--more-->

## Starting out

For the purposes of this post, I&#8217;ll be morphing the dummy application that Rstudio produces when you use **New file > Shiny app**. I&#8217;ve created a [repository][2] to store these design patterns in and the default shiny app that will be converted / mangled is the `01_original.R` file in each folder. This post covers inputs being passed on to other modules so is held in the [input\_to\_multiplemodules folder][3].<figure style="width: 500px" class="wp-caption aligncenter">

[<img src="https://raw.githubusercontent.com/stephlocke/shinymodulesdesignpatterns/master/input_to_multiplemodules/README/original.png" alt="input value being directly used in shiny app" width="500" height="120" />][3]<figcaption class="wp-caption-text">input value being directly used in shiny app</figcaption></figure> 

## Pass module inputs to other modules

### Make a module that contains inputs

A module must have a server function and can optionally have UI and Input functions. We need a module that has an input function so our skeleton for our setup values is

    setupInput <- function( id ){
    ns<-NS(id)
    
    }
    

Input parameters must be held in a `tagList()` so that the shiny UI knows to handle them like other directly mentioned inputs. The `setupInput` function can contain any number of inputs, including the `bins` input that used to be a global input.

    setupInput<-function(id){
      ns<-NS(id)
      tagList(
      sliderInput(ns("bins"), "Number of bins:",
                  min = 1,  max = 50, value = 30)
      )
    }
    

### Output the inputs

In the module with the input parameters, we may need to do stuff with the value and also make it available for other modules. To make the input parameters available, we need to put the `input` object in the `return()` value of the module.

    setup<-function(input,output,session){
      return(input)
    }
    

In the example file, I also show how to show all inputs for a module in a table. This is very handy for providing a consolidated list of parameters that could be viewed or exported. The `input` object is a reactive [R6][4] object and cannot be directly coerced into a data.frame. To enable the coercion the `reactiveValuesToList()` function needs to be used first. This, of course, can be applied to any reactive value making it easy to extract values where required.

### Make a module that accepts additional arguments

The vanilla module server function construct is `function(input,output,session){}`. There isn&#8217;t room for extra parameters to be passed through so we have to make space for one. In this case, our module skeleton that will hold our histogram code is

    charts <- function( input, output, session, bins) {
    
    }
    

To enable us to utilise the results of the `callModule(setup,"setupA")` we need to store the results, and then pass through the object.

    bins<-callModule(setup,"setupA")
    callModules(charts, "chartA", bins)
    

### Use the input value

When you reference a reactive value, you reference it like a function but what we&#8217;ve passed through is an `input` object. As a result we don&#8217;t need to use `bins()` just `bins` and we can use it just like it was `input` so we can then use `bins$bin`.

Instead of `bins <- seq(min(x), max(x), length.out = input$bins + 1)` in our original, when we use our reactive value in our chart module, it becomes:

    chart <- function(input, output, session, bins) {
      output$distPlot <- renderPlot({
        x    <- faithful[, 2]
        bins <- seq(min(x), max(x), length.out = bins$bin + 1)
        hist(x,
             breaks = bins,
             col = 'darkgray',
             border = 'white')
      })
    }
    

Note that the input values did not receive a namespace so could be labelled directly. If you run the sample file for this design pattern, you&#8217;ll note that the printing of the input values did print the namespaces as the UI output component utilised the `ns()` function.

### Putting it together

To be able to pass all inputs from one module to another, you need to:

  1. Make a module that returns the \`input\` object
  2. Store the callModule results in a variable
  3. Add an argument to your module&#8217;s server function arguments
  4. Pass the name of the variable to the module
  5. Use `argument$inputparamname` within the module&#8217;s server function main code to refer to a specific input parameter

See file [04_allinputsmodule.R][5] for the end to end solution.<figure style="width: 500px" class="wp-caption aligncenter">

 <img class="" src="https://raw.githubusercontent.com/stephlocke/shinymodulesdesignpatterns/master/input_to_multiplemodules/README/inputPassthrough.png
" alt="Store input in a reactive value to pass values onto modules" width="500" /></a><figcaption class="wp-caption-text">Store callModule to pass into other modules</figcaption></figure> 

## Further study

  * [Other shiny design pattern posts][1]
  * [Shiny Modules Rstudio article][6]
  * Understanding Modules [webinar][7] and [associated materials][8]
  * [Modularizing Shiny app code][9] video from Shiny Developer Conference

 [1]: https://itsalocke.com/tag/shiny-design-patterns/
 [2]: https://github.com/stephlocke/shinymodulesdesignpatterns
 [3]: https://github.com/stephlocke/shinymodulesdesignpatterns/tree/master/input_to_multiplemodules
 [4]: https://cran.r-project.org/web/packages/R6/vignettes/Introduction.html
 [5]: https://github.com/stephlocke/shinymodulesdesignpatterns/blob/master/input_to_multiplemodules/04_allinputsmodule.R
 [6]: http://shiny.rstudio.com/articles/modules.html
 [7]: https://www.rstudio.com/resources/webinars/
 [8]: https://github.com/rstudio/webinars/blob/master/19-Understanding-modules/01-Modules-Webinar.pdf
 [9]: https://www.rstudio.com/resources/webinars/shiny-developer-conference/