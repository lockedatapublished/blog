---
title: 'R Quick Tip: Collapse a lists of data.frames with data.table'
author: Steph

date: 2016-04-05T14:05:26+00:00
categories:
  - Data Science
  - R
tags:
  - data.table
  - quick tip
  - r

---
With my [HIBPwned][1] package, I consume the [HaveIBeenPwned][2] API and return back a list object with an element for each email address. Each element holds a data.frame of breach data or a stub response with a single column data.frame containing NA. Elements are named with the email addresses they relate to. I had a list of data.frames and I wanted a consolidated data.frame (well, I always want a data.table).

Enter data.table &#8230;

[data.table][3] has a very cool, and [very fast][4] function named `rbindlist()`. This takes a list of data.frames and consolidates them into one data.table, which can, of course, be handled as a data.frame if you didn&#8217;t want to use data.table for anything else.
  
<!--more-->

## Prep

For this post, I need a list with some data.frames in it. For simplicity, I&#8217;m going to split the `iris` dataset into three separate data.frames.

    library(data.table)
    myList<-list( p1=iris[1:50,]
                 , p2=iris[51:100,]
                 , p3=iris[101:150,]
     )
    

## Simplest usage

If all your tables have the same columns and in the same order, then this is super simple.

    > myList<-list( p1=iris[1:50,] , p2=iris[51:100,] , p3=iris[101:150,] )
    > dt<-rbindlist(myList)
    > head(dt)
       Sepal.Length Sepal.Width Petal.Length Petal.Width Species
    1:          5.1         3.5          1.4         0.2  setosa
    2:          4.9         3.0          1.4         0.2  setosa
    3:          4.7         3.2          1.3         0.2  setosa
    4:          4.6         3.1          1.5         0.2  setosa
    5:          5.0         3.6          1.4         0.2  setosa
    6:          5.4         3.9          1.7         0.4  setosa
    
    

## Varying columns

If your data structure varies at all, you can use the arguments `use.names` and `fill` to combine the data.frames without an error. It will put columns on the RHS of the table as they appear within the list.

Here I remove the first column from the first part of our dataset to illustrate.

    > myList<-list( p1=iris[1:50, -1 ] , p2=iris[51:100,] , p3=iris[101:150,] )
    > dt<-rbindlist(myList, use.names=TRUE, fill=TRUE)
    > head(dt)
       Sepal.Width Petal.Length Petal.Width Species Sepal.Length
    1:         3.5          1.4         0.2  setosa           NA
    2:         3.0          1.4         0.2  setosa           NA
    3:         3.2          1.3         0.2  setosa           NA
    4:         3.1          1.5         0.2  setosa           NA
    5:         3.6          1.4         0.2  setosa           NA
    6:         3.9          1.7         0.4  setosa           NA
    

## Adding the list element ID

I didn&#8217;t RTFM very well at first, so when I wanted the name of the element the specific row came from to be present in my data.frame, I (_shudder_) wrote this horror:

    dt<-rbindlist(lapply(1:length(myList)
                         , function(x){ setDT(myList[[x]])[
      , id:=names(myList)[x]]})
      , use.names=TRUE, fill=TRUE)
    

When I write things like that, I know I&#8217;m in the wrong! This hideous inline function, iterating through the elements and updating values in the element, is frankly something I should be slapped for. So with it playing on my mind, I went back to the manual, and lo&#8217; data.table was awesome.

    > myList<-list( p1=iris[1:50, -1 ] , p2=iris[51:100,] , p3=iris[101:150,] ) 
    > dt<-rbindlist(myList
    +   , use.names=TRUE, fill=TRUE, idcol="myList")
    > 
    > head(dt)
       myList Sepal.Width Petal.Length Petal.Width Species Sepal.Length
    1:     p1         3.5          1.4         0.2  setosa           NA
    2:     p1         3.0          1.4         0.2  setosa           NA
    3:     p1         3.2          1.3         0.2  setosa           NA
    4:     p1         3.1          1.5         0.2  setosa           NA
    5:     p1         3.6          1.4         0.2  setosa           NA
    6:     p1         3.9          1.7         0.4  setosa           NA
    

This used the names of the list elements but would use the numeric index number if names weren&#8217;t available.

## Wrap up

So with just three little arguments, data.table&#8217;s `rbindlist()` bundled up my data.frames into a single data.frame whilst handling divergent columns, and providing a reference back to the original list element!

 [1]: https://github.com/stephlocke/HIBPwned
 [2]: https://haveibeenpwned.com/
 [3]: https://cran.r-project.org/package=data.table
 [4]: http://stackoverflow.com/questions/15673550/why-is-rbindlist-better-than-rbind