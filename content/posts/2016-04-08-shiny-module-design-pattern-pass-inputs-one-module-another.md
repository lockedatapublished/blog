---
title: 'Shiny module design patterns: Pass a single input to multiple modules'
author: Steph

date: 2016-04-08T10:56:32+00:00
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
For the awesome [Shiny Developers Conference][1] back in January, I endeavoured to learn about shiny modules and [overhaul an application][2] using them in the space of two days. I succeeded and almost immediately switched onto other projects, thereby losing most of the hard-won knowledge! As I rediscover shiny modules and start putting them into more active use, I&#8217;ll be blogging about design patterns. This post takes you through the case of multiple modules receiving the same input value.

## TL;DR

Stick overall config input objects at the app level and pass them in a reactive expression to `callModule()`. Pass the results in as an extra argument into subsequent modules. These are reactive so don&#8217;t forget the brackets. [Steal the code][3] and, as always, if you can improve it do so!

<!--more-->

## Starting out

For the purposes of this post, I&#8217;ll be morphing the dummy application that Rstudio produces when you use **New file > Shiny app**. I&#8217;ve created a [repository][4] to store these design patterns in and the default shiny app that will be converted / mangled is the `01_original.R` file.<figure style="width: 500px" class="wp-caption aligncenter">

[<img src="https://raw.githubusercontent.com/stephlocke/shinymodulesdesignpatterns/master/input_to_multiplemodules/README/original.png" alt="input value being directly used in shiny app" width="500" height="120" />][4]<figcaption class="wp-caption-text">input value being directly used in shiny app</figcaption></figure> 

## Pass a single input to multiple modules

### Make a reactive value

The first thing you might assume you can do when you want to pass an input value to a module is simply do `callModule(chart,"chartA",input$bins)`. Unfortunately, this does not work because the `callModule()` function is not inherently reactive. it has to be forced to be reactive with a reactive value.

We can make a reactive value very simply:

    bins<-reactive({ input$bins })
    

### Make a module that accepts additional arguments

The vanilla module server function construct is `function(input,output,session){}`. There isn&#8217;t room for extra parameters to be passed through so we have to make space for one. In this case, our module skeleton that will hold our histogram code is

    charts <- function( input, output, session, bins) {
    
    }
    

To pass through our reactive value then becomes

    bins<-reactive({ input$bins })
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

To be able to pass an input value to a module, you need to:

  1. Make a reactive variable holding the input value
  2. Add an argument to your module&#8217;s server function arguments
  3. Pass the name of the reactive variable to the module
  4. Use `argument()` not `argument` within the module&#8217;s server function main code

See file [02_singlegloballevelinput.R][5] for the end to end solution.<figure style="width: 500px" class="wp-caption aligncenter">

 <img class="" src="https://raw.githubusercontent.com/stephlocke/shinymodulesdesignpatterns/master/input_to_multiplemodules/README/simplePassthrough.png" alt="Store input in a reactive value to pass value onto modules" width="500" height="123" /></a><figcaption class="wp-caption-text">Store input in a reactive value to pass value onto modules</figcaption></figure> 

* * *

## Further study

  * [My post: Declutter a shiny report&#8217;s code v2.0][6]
  * [Shiny Modules Rstudio article][7]
  * Understanding Modules [webinar][8] and [associated materials][9]
  * [Modularizing Shiny app code][10] video from Shiny Developer Conference

 [1]: https://www.eventbrite.com/e/shiny-developer-conference-registration-19153967031
 [2]: https://itsalocke.com/declutter-a-shiny-reports-code-v2-0/
 [3]: https://github.com/stephlocke/shinymodulesdesignpatterns
 [4]: https://github.com/stephlocke/shinymodulesdesignpatterns/tree/master/input_to_multiplemodules
 [5]: https://github.com/stephlocke/shinymodulesdesignpatterns/blob/master/input_to_multiplemodules/02_singlegloballevelinput.R
 [6]: https://itsalocke.com/declutter-a-shiny-reports-code-v2-0
 [7]: http://shiny.rstudio.com/articles/modules.html
 [8]: https://www.rstudio.com/resources/webinars/
 [9]: https://github.com/rstudio/webinars/blob/master/19-Understanding-modules/01-Modules-Webinar.pdf
 [10]: https://www.rstudio.com/resources/webinars/shiny-developer-conference/