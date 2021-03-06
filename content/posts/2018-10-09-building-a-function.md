---
title: "Processing complicated package outputs"
author: Steph
date: '2018-10-09'
always_allow_html: yes
self_contained: false
preserve_yaml: true
categories:
  - R
  - Data Science
tags:
  - development
  - API
  - Google
  - functions
  - r
output_document:
  md_document:
    variant: markdown_github
---

Sometimes packages have functions that don't do the things the way you want them to do them and you have to either re-build the function, or work with it as-is and add code around it to solve your issue.

I've had to do this recently with the `googleway` package and it's `google_distance()` function so I wanted to take you through step by step how I wrote code to go from a single value function to a function that handles many inputs and returns 4 rows per input. I won't be dwelling on how to write a function specifically, just showing you the workflow I often go through.

Requirements
------------

Key functionality we'll need today is:

-   googleway for providing the base function
-   the tidyverse, namely purrr and dplyr, for lots of the data manipulation
-   memoise for caching requests so we spend less cash

``` r
library(tidyverse)
library(memoise)
library(googleway)
```

Google Distance
---------------

To calculate distances we can use the [google distance API](https://developers.google.com/maps/documentation/distance-matrix/start).

This needs a key in order to use it. Note that this service does not have a free tier to use, however it is ~$5 per 1,000 requests and a trial of Google Cloud is available.

``` r
key="AIzaSyBIeuWMWWweyv1SAoAxcY1IZ-2nuErFQY8"
```

Then we need to prep our desired information.

``` r
office = "E14 5EU"
monday_9am = as.POSIXct("2018-12-03 09:00")
```

Handling `google_distance()`
----------------------------

The API is used to working with just a single address at a time so we need to do a bit of prep here to make it work with lots of accounts.

For starters, we can use the memoise package to cache results so if we send the same address multiple times it doesn't need to go back to the API. Phew, since that API costs money to call!

``` r
google_distance_deduped = memoise::memoise(google_distance)
```

Giving this a go with a single example, let's see what google gives us:

``` r
from = "SE3 8UQ"

example_1 = google_distance_deduped(from,
                        office,
                        mode = "transit",
                        arrival_time = monday_9am,
                        key=key)

example_1
```

    ## $destination_addresses
    ## [1] "Canary Wharf, London E14 5EU, UK"
    ## 
    ## $origin_addresses
    ## [1] "Shooters Hill Rd, London SE3 8UQ, UK"
    ## 
    ## $rows
    ##                          elements
    ## 1 5.7 km, 5653, 37 mins, 2221, OK
    ## 
    ## $status
    ## [1] "OK"

The `possibly()` function will mean that if there's an error for a call that it doesn't break everything and we won't have to start all over again.

``` r
google_distance_try = purrr::possibly(google_distance_deduped, "Fail")

from = c(NA)

example_2 = google_distance_try(from,
                        office,
                        mode = "transit",
                        arrival_time = monday_9am,
                        key=key)

example_2
```

    ## [1] "Fail"

Then to make the function work over multiple addresses, we need to change it slightly. The `map()` function will iterate over all the addresses.

``` r
google_distance_loop = function(x,...){
    purrr::map(x, google_distance_try,...)
}

from = rep("SE3 8UQ",2)

example_3 = google_distance_loop(from,
                        office,
                        mode = "transit",
                        arrival_time = monday_9am,
                        key=key)

example_3
```

    ## [[1]]
    ## [[1]]$destination_addresses
    ## [1] "Canary Wharf, London E14 5EU, UK"
    ## 
    ## [[1]]$origin_addresses
    ## [1] "Shooters Hill Rd, London SE3 8UQ, UK"
    ## 
    ## [[1]]$rows
    ##                          elements
    ## 1 5.7 km, 5653, 37 mins, 2221, OK
    ## 
    ## [[1]]$status
    ## [1] "OK"
    ## 
    ## 
    ## [[2]]
    ## [[2]]$destination_addresses
    ## [1] "Canary Wharf, London E14 5EU, UK"
    ## 
    ## [[2]]$origin_addresses
    ## [1] "Shooters Hill Rd, London SE3 8UQ, UK"
    ## 
    ## [[2]]$rows
    ##                          elements
    ## 1 5.7 km, 5653, 37 mins, 2221, OK
    ## 
    ## [[2]]$status
    ## [1] "OK"

So our code is working over multiple cases and handling bad inputs pretty well, but how do we get some meaningful stuff out of it. Looking at the data, we get back a part of a table that contains a response.

``` r
example_1 %>% 
  map("rows") %>% 
  map("elements")
```

    ## $destination_addresses
    ## NULL
    ## 
    ## $origin_addresses
    ## NULL
    ## 
    ## $rows
    ## NULL
    ## 
    ## $status
    ## NULL

We see that there seems to be no way someone can use public transport between the two locations. Perhaps another way of getting there will return a result?

``` r
from = "SE3 8UQ"
example_4 = google_distance_loop(from,
                        office,
                        mode = "walking",
                        arrival_time = monday_9am,
                        key=key)

example_4 %>% 
  map("rows") %>% 
  map("elements") %>% 
  flatten() %>% 
  map("duration") 
```

    ## [[1]]
    ##             text value
    ## 1 1 hour 20 mins  4777

When a commute is possible, we get a response back that includes the number of seconds it might take someone to travel to work for 9am on a Monday.

First of all, we'll need to reliably extract this information from a batch of repsonses. This takes multiple steps due to the way the API gives us info.

``` r
from = c("SE3 8UQ", NA, "SE3 8UQ")

google_distance_tbl = function(x, ...) {
  google_distance_loop(x,...) %>% 
  map("rows") %>% 
  map("elements") %>% 
  flatten() %>% 
  map(unclass) %>% 
  map_df(flatten) %>% 
  cbind(x)
}
  
example_5 = google_distance_tbl(from,
                        office,
                        mode = "walking",
                        arrival_time = monday_9am,
                        key=key)
example_5  
```

    ##             text value    status       x
    ## 1 1 hour 20 mins  4777        OK SE3 8UQ
    ## 2           <NA>    NA NOT_FOUND    <NA>
    ## 3 1 hour 20 mins  4777        OK SE3 8UQ

So now we're going to need to ask about the different transit options for each address to find out the range of values in order to cope with "ZERO\_RETURN" records. Once we have this information, we can then use the `google_distance_all` function to find out how long it'll take someone to drive, walk, cycle, or use public transport to travel between two points.

``` r
from = c("SE3 8UQ", NA, "SE3 8UQ")

google_distance_all = function(x, office, arrival_time, key, ...) {
  
  interested_in = expand.grid(from=x, 
     mode=c("driving", "walking", "bicycling", "transit"), 
      stringsAsFactors = FALSE)

map2_df(interested_in$from,interested_in$mode, 
     ~mutate(
       google_distance_tbl(.x, office, mode=.y,
                        arrival_time = arrival_time,
                        key=key),
       from=.x, mode=.y)
)
}

example_6 = google_distance_all(from, office, monday_9am, key)

example_6
```

    ##              text value    status       x    from      mode
    ## 1         12 mins   739        OK SE3 8UQ SE3 8UQ   driving
    ## 2            <NA>    NA NOT_FOUND    <NA>    <NA>   driving
    ## 3         12 mins   739        OK SE3 8UQ SE3 8UQ   driving
    ## 4  1 hour 20 mins  4777        OK SE3 8UQ SE3 8UQ   walking
    ## 5            <NA>    NA NOT_FOUND    <NA>    <NA>   walking
    ## 6  1 hour 20 mins  4777        OK SE3 8UQ SE3 8UQ   walking
    ## 7         32 mins  1930        OK SE3 8UQ SE3 8UQ bicycling
    ## 8            <NA>    NA NOT_FOUND    <NA>    <NA> bicycling
    ## 9         32 mins  1930        OK SE3 8UQ SE3 8UQ bicycling
    ## 10        37 mins  2221        OK SE3 8UQ SE3 8UQ   transit
    ## 11           <NA>    NA NOT_FOUND    <NA>    <NA>   transit
    ## 12        37 mins  2221        OK SE3 8UQ SE3 8UQ   transit

Having this many functions though clutters things up and makes it difficult to refactor and improve things. We should unpack all the functionality into one big function.

``` r
#' Get distance data between two points based on all the travel mode options. Works for many origin points.
#'
#' @param x A vector of origins in address or postcode format
#' @param dest A single destinationin address or postocde format
#' @param arrival_time A POSIXct datetime that folks need to arrive by
#' @param key A google distance API key
#' @param ... Additional options to pass to `google_distance()`
#'
#' @return Data.frame containing (typically) 4 rows per input element

google_distance_all =  function(x, dest, arrival_time, key, ...){
  
  # simple hygeine stuff
  gd = purrr::possibly(
    memoise::memoise(
      google_distance)
    , "Fail"
  )
  
  # Prep dataset
   interested_in = expand.grid(from=x, 
     mode=c("driving", "walking", "bicycling", "transit"), 
      stringsAsFactors = FALSE)
   # Perform google_distance calls for all combos
  purrr::map2(interested_in$from,interested_in$mode, 
     ~gd(.x, dest, mode=.y,
                        arrival_time = arrival_time,
                        key=key)
  ) %>% 
    # Extract relevant section
    purrr::map("rows") %>% 
    purrr::map("elements") %>% 
    purrr::flatten() %>% 
    # Simplify the data.frames
    purrr::map(unclass) %>% 
    purrr::map_df(purrr::flatten) %>% 
    # Add original lookup values
    cbind(interested_in)
}

results = google_distance_all(
  from,
  office,
  arrival_time = monday_9am,
  key = key
)

results
```

    ##              text value    status    from      mode
    ## 1         12 mins   739        OK SE3 8UQ   driving
    ## 2            <NA>    NA NOT_FOUND    <NA>   driving
    ## 3         12 mins   739        OK SE3 8UQ   driving
    ## 4  1 hour 20 mins  4777        OK SE3 8UQ   walking
    ## 5            <NA>    NA NOT_FOUND    <NA>   walking
    ## 6  1 hour 20 mins  4777        OK SE3 8UQ   walking
    ## 7         32 mins  1930        OK SE3 8UQ bicycling
    ## 8            <NA>    NA NOT_FOUND    <NA> bicycling
    ## 9         32 mins  1930        OK SE3 8UQ bicycling
    ## 10        37 mins  2221        OK SE3 8UQ   transit
    ## 11           <NA>    NA NOT_FOUND    <NA>   transit
    ## 12        37 mins  2221        OK SE3 8UQ   transit

I will undoubtedly want to do some cleaning after this and there's certainly room for improvement on the function but this is a good starting point for getting some data to work with. The iterative way I build functions means I can try to solve a bit at a time -- hopefully this will help you when you're faced with needing to build your own functions.
