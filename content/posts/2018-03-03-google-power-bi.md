---
title: Connect to Google Sheets in Power BI using R
author: Ellen 
date: 2018-02-17
categories:
  - R
  - Power BI
tags:
  - Locke-Data
---

Hello again everyone! This latest blog post comes from [this youtube video](https://www.youtube.com/watch?v=8lWR-_L52Qs) that we published a little while ago.

Here's the step by step instructions for using the 'googlesheets' package in R to enable you to get your data from Google Sheets

Step 1 - Preparation
--------------------

### Create an authentication token for re-use

Run the following:

``` r
library(googlesheets)
token <- gs_auth(cache = FALSE)
gd_token()
saveRDS(token, file="googlesheets_token.rds")
```

This springs open a window in your browser, and asks you to choose your prefered google account. You'll have to choose one, and allow 'tidyverse-googlsheets' access to continue.

You should now see a page stating "Authentication complete. Please return to R."

Step 2 -
--------

### Add R Script into Power BI using token.

Click through the following: + Get data + More + Other + R Script

Into the pop up window, paste the following: (Without wanting to state the obvious...change the relevant file paths to something you want to look at...OR open up that link for a sheet we compiled with loads more great R resources!)

``` r
library(googlesheets)
library(magrittr)
suppressMessages(gs_auth(token = "~/Dropbox/Freelance/Locke_data_files/googlesheets_token.rds", verbose = FALSE))
mySheet<-"https://docs.google.com/spreadsheets/d/12hFJQ117Mu-J3MWvO65hgdwNmQLzuXhbCkuYHfoHmZA/edit#gid=881533400"

mySheet %>% 
  gs_url() %>% 
  gs_read() ->
  surveyresults
```

You will then be able to naviagate through your google docs and load them into your Power BI workspace!

An added extra
--------------

If you want to read and combine all your sheets, here's a handy bit of code to do just that, simply switch it out with the corresponding code in the block above. (Keep all four packages!)

``` r
library(purrr)
library(data.table)

mySheet %>% 
  gs_url() %>% 
  gs_ws_ls() %>% 
  map(~gs_read(gs_url(mySheet),ws=.)) %>% 
  rbindlist(use.names = TRUE, fill=TRUE) ->
  surveyresults
```

Happy analysing!

Ellen :)
