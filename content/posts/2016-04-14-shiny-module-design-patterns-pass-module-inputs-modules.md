---
title: 'Shiny module design patterns: Pass module input to other modules'
author: Steph
type: post
date: 2016-04-14T12:05:55+00:00
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
Following on from looking at the [shiny modules design pattern of passing an input value to many modules][1], I&#8217;m now going to look at a more complex shiny module design pattern: passing an input from one module to another.

## TL;DR

Return the input in a reactive expression from within the server call. Store the `callModule()` result in a variable. Pass the variable into arguments for other modules. [Steal the code][2] and, as always, if you can improve it do so!

<!--more-->

## Starting out

For the purposes of this post, I&#8217;ll be morphing the dummy application that Rstudio produces when you use **New file > Shiny app**. I&#8217;ve created a [repository][3] to store these design patterns in and the default shiny app that will be converted / mangled is the `01_original.R` file.<figure style="width: 500px" class="wp-caption aligncenter">

[<img src="https://raw.githubusercontent.com/stephlocke/shinymodulesdesignpatterns/master/input_to_multiplemodules/README/original.png" alt="input value being directly used in shiny app" width="500" height="120" />][3]<figcaption class="wp-caption-text">input value being directly used in shiny app</figcaption></figure> 

The next step along was passing a top-level input to many modules. See file [02_singlegloballevelinput.R][4] for the end to end solution.<figure style="width: 500px" class="wp-caption aligncenter">

 <img class="" src="https://raw.githubusercontent.com/stephlocke/shinymodulesdesignpatterns/master/input_to_multiplemodules/README/simplePassthrough.png" alt="Store input in a reactive value to pass value onto modules" width="500" height="123" /></a><figcaption class="wp-caption-text">Store input in a reactive value to pass value onto modules</figcaption></figure> 

## Pass module input to other modules

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
    

### Output the input value

In the module with the input parameters, we may need to do stuff with the value and also make it available for other modules. To make the input parameter&#8217;s value available we need to put it within a reactive expression and output the expression as the `return()` value of the module.

    setup<-function(input,output,session){
      bins<-reactive({input$bins})
      return(bins)
    }
    

### Make a module that accepts additional arguments

The vanilla module server function construct is `function(input,output,session){}`. There isn&#8217;t room for extra parameters to be passed through so we have to make space for one. In this case, our module skeleton that will hold our histogram code is

    charts <- function( input, output, session, bins) {
    
    }
    

When we use modules, they **have to** be called in the server function of a shiny app but they **don&#8217;t have to** be stored in a variable. If a module isn&#8217;t stored then whatever values are returned by an explicit `return()` statement will be lost and calling a module with the same ID more than once will result in errors, so to be able to pass the return value to multiple modules we **must** store it and then use it.

    bins<-callModule(setup,"setupA")
    callModules(charts, "chartA", bins)
    

### Use the reactive value

When you reference a reactive value, you reference it like a function. We need to use `bins()` instead so that the result of the reactive value is returned.

Instead of `bins <- seq(min(x), max(x), length.out = input$bins + 1)` in our original, when we use our reactive value in our chart module, it becomes:

    chart <- function(input, output, session, bins) {
      output$distPlot <- renderPlot({
        x    <- faithful[, 2]
        bins <- seq(min(x), max(x), length.out = bins() + 1)
        hist(x,
             breaks = bins,
             col = 'darkgray',
             border = 'white')
      })
    }
    

### Putting it together

To be able to pass an input value from one module to another, you need to:

  1. Make a module that returns a reactive expression for the input value
  2. Store the callModule results in a variable
  3. Add an argument to your module&#8217;s server function arguments
  4. Pass the name of the variable to the module
  5. Use `argument()` not `argument` within the module&#8217;s server function main code

See file [03_inputmodule.R][5] for the end to end solution.

<figure style="width: 500px" class="wp-caption aligncenter"> <a><img class="" src="https://raw.githubusercontent.com/stephlocke/shinymodulesdesignpatterns/master/input_to_multiplemodules/README/inputPassthrough.png"
" alt="Store input in a reactive value to pass value onto modules" width="500" /></a><figcaption class="wp-caption-text">Store callModule to pass into other modules</figcaption></figure>

## Further study

  * [My post: Declutter a shiny report&#8217;s code v2.0][6]
  * [Other shiny design pattern posts][7]
  * [Shiny Modules Rstudio article][8]
  * Understanding Modules [webinar][9] and [associated materials][10]
  * [Modularizing Shiny app code][11] video from Shiny Developer Conference

 [1]: https://itsalocke.com/shiny-module-design-pattern-pass-inputs-one-module-another/
 [2]: https://github.com/stephlocke/shinymodulesdesignpatterns
 [3]: https://github.com/stephlocke/shinymodulesdesignpatterns/tree/master/input_to_multiplemodules
 [4]: https://github.com/stephlocke/shinymodulesdesignpatterns/blob/master/input_to_multiplemodules/02_singlegloballevelinput.R
 [5]: https://github.com/stephlocke/shinymodulesdesignpatterns/blob/master/input_to_multiplemodules/03_inputmodule.R
 [6]: https://itsalocke.com/declutter-a-shiny-reports-code-v2-0
 [7]: https://itsalocke.com/tag/shiny-design-patterns/
 [8]: http://shiny.rstudio.com/articles/modules.html
 [9]: https://www.rstudio.com/resources/webinars/
 [10]: https://github.com/rstudio/webinars/blob/master/19-Understanding-modules/01-Modules-Webinar.pdf
 [11]: https://www.rstudio.com/resources/webinars/shiny-developer-conference/