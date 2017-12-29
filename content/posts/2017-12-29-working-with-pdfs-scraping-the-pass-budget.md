---
title: Working with PDFs - scraping the PASS budget
author: Steph
date: '2017-12-29'
slug: working-with-pdfs-scraping-the-pass-budget
categories:
  - R
  - Data Science
tags:
  - pass
  - Community
  - conferences
---

Using [`tabulizer`](https://github.com/ropensci/tabulizer) we're able to extract information from PDFs so it comes in really handy when people publish data as a PDF! This post takes you through using `tabulizer` and `tidyverse` packages to scrape and clean up some budget data from [PASS](https://sqlpass.org), an association for the Microsoft Data Platform community. The goal is to mainly show some of the tricks of the data wrangling trade that you may need to utilise when you scrape data from PDFs.

``` r
library(tabulizer)
library(tidyverse)
library(zoo)
library(tidytext)
```

Reading the PDF
---------------

With `tabulizer`, if the data is relatively well formatted in a PDF you can use `tabulizer::extract_tables()`. This gives you a bunch of data.frames which you can process. Unfortunately, in the case of the [PASS budget](http://www.pass.org/Portals/0/Governance%202016/Financials/pass-budget-2017.pdf?ver=2017-01-25-235556-197) with 22 pages of tables, including tables that span multiple pages, we're not so lucky!

We need to fall back to `tabulizer::extract_text()` and do a lot of wrangling to reconstruct the tables.

``` r
"http://www.pass.org/Portals/0/Governance%202016/Financials/pass-budget-2017.pdf?ver=2017-01-25-235556-197" %>%
  tabulizer::extract_text() ->
  rawtxt

str_trunc(rawtxt, 1000)
```

    ## [1] "Department Summary Budget 2016 Budget 2017\r\nREVENUE\r\nCorporate Administration - 110 11,000.00$                    11,000.00$                     \r\nInformation Technology - 111 74,000.00$                    106,480.00$                   \r\nBoard Support - 112 -$                               -$                                \r\nMember Services - 114 6,000.00$                      22,500.00$                     \r\nMarketing - 115 -$                               -$                                \r\nChapters - 120 -$                               -$                                \r\nVolunteer Programs & Engagement - 130 -$                               -$                                \r\nSpecial Projects - 140 -$                               -$                                \r\nSQL Saturday - 150 -$                               38,400.00$                     \r\nVirtual Events - 160 51,662.50$                    68,800.00$                     \r\nGlobal Growth - 170 -$                         ..."

Converting the results to tabular data
--------------------------------------

The PDF contents are a continuous string so we need to split this up. Each line seems to be seperated by `\r\n` and we can use the `tidytext` package to easily split these lines out into seperate elements.

``` r
rawtxt %>%
  tokenize(tokenizer = tokenizer_line()) %>% 
  head()
```

    ## [[1]]
    ## [1] "Department Summary Budget 2016 Budget 2017"
    ## 
    ## [[2]]
    ## [1] "REVENUE"
    ## 
    ## [[3]]
    ## [1] "Corporate Administration - 110 11,000.00$                    11,000.00$                     "
    ## 
    ## [[4]]
    ## [1] "Information Technology - 111 74,000.00$                    106,480.00$                   "
    ## 
    ## [[5]]
    ## [1] "Board Support - 112 -$                               -$                                "
    ## 
    ## [[6]]
    ## [1] "Member Services - 114 6,000.00$                      22,500.00$                     "

There's now a load of spaces between the budget item, the 2016 amount, and the 2017 amount. We need to remove excess spaces and transform each of these lines into individual elements using `str_split()`.

``` r
rawtxt %>%
  tokenize(tokenizer = tokenizer_line()) %>%
  str_replace_all("\\s+", " ") %>%
  str_trim(side = "both") %>%
  str_split(" ") %>% 
  head()
```

    ## [[1]]
    ## [1] "Department" "Summary"    "Budget"     "2016"       "Budget"    
    ## [6] "2017"      
    ## 
    ## [[2]]
    ## [1] "REVENUE"
    ## 
    ## [[3]]
    ## [1] "Corporate"      "Administration" "-"              "110"           
    ## [5] "11,000.00$"     "11,000.00$"    
    ## 
    ## [[4]]
    ## [1] "Information" "Technology"  "-"           "111"         "74,000.00$" 
    ## [6] "106,480.00$"
    ## 
    ## [[5]]
    ## [1] "Board"   "Support" "-"       "112"     "-$"      "-$"     
    ## 
    ## [[6]]
    ## [1] "Member"     "Services"   "-"          "114"        "6,000.00$" 
    ## [6] "22,500.00$"

Looking at the splits, we have too many elements from the budget line item names. We need to consolidate the left-hand side contents.

This function looks at each set of split elements and processes them. If there are enough elements and the last one ends with a `$` we can combine everything bar the last two elements into the line item. If there is no `$` line or it's too short, we can put everything into the line item.

``` r
combineLHS <- function(x) {
  n <- length(x)
  if (str_detect(x[n],"\\$$")&n>=3) {
   data_frame(lineItem=paste(x[1:(n - 2)], collapse = " "), 
              b2016=x[n - 1], 
              b2017=x[n])
  } else {
    data_frame(lineItem=paste(x, collapse = " "), 
               b2016="", 
               b2017="")
  }
}
```

This is a non vectorised function which means it can't be applied to every line at once. To get around this we can leverage `purrr::map_df()` to apply the function to every element and combine into one big data.frame.

``` r
rawtxt %>%
  tokenize(tokenizer = tokenizer_line()) %>%
  str_replace_all("\\s+", " ") %>%
  str_trim(side = "both") %>%
  str_split(" ") %>%
  map_df(combineLHS) ->
  rawdata

rawdata %>% 
  head()
```

    ## # A tibble: 6 x 3
    ##   lineItem                                   b2016      b2017      
    ##   <chr>                                      <chr>      <chr>      
    ## 1 Department Summary Budget 2016 Budget 2017 ""         ""         
    ## 2 REVENUE                                    ""         ""         
    ## 3 Corporate Administration - 110             11,000.00$ 11,000.00$ 
    ## 4 Information Technology - 111               74,000.00$ 106,480.00$
    ## 5 Board Support - 112                        -$         -$         
    ## 6 Member Services - 114                      6,000.00$  22,500.00$

Cleaning up
-----------

Now that we have a tabular data set, it now needs to be made useful. We now need to do stuff like like translating the character formatting of the money into a numeric value and tracking whether a row is a title, revenue, or expense item.

I wrote a function to clean up the monetary amounts.

``` r
moneycleaner <- function(x) {
  x %>%
    str_replace_all("[$,]|[[:space:]]", "") %>%
    # Handle $0 amounts
    str_replace_all("^-$", "0") %>%
    # Handle negative amounts
    ifelse(str_detect(., "\\("),
           paste0("-", str_replace_all(., "[()]", "")),
           .) %>%
    as.numeric()
}
```

I'm going to write inline comments about what each bit is doing to avoid a lot of repetition here as I clean up the data.

``` r
rawdata %>%
  mutate(
    ## Count the switches between table types
    TblChange = cumsum(lineItem %in%
                         c("REVENUE", "EXPENSE")),
    ## Check if row is a total line for a table
    Total = str_detect(lineItem, "^TOTAL"),
    ## Check if row is a total based on two tables
    Net = str_detect(lineItem, "^NET"),
    ## Work out if the row contains line items or titles
    Title = b2016 == "" & b2017 == "" ,
    ## Use MOD2 to determine which table type a row belonged to
    Type = ifelse(TblChange %% 2 == 0, "Expense", "Revenue"),
    ## Identify the department if the row has budget 2017
    Dept = ifelse(str_detect(lineItem,"Budget 2017"),
                  str_replace(str_extract(lineItem, "^.+-")," -",""),
                  NA),
    ## We're only interested in actual line items
    IgnoreRow=Total|Net|Title
  ) %>%
  mutate(
    ## Use `zoo`s rolling functions to carry the last non-NA value forward. Essentially doign a fill-down between values
    Dept = zoo::na.locf(Dept, na.rm = FALSE),
    b2016=moneycleaner(b2016),
    b2017=moneycleaner(b2017)) %>% 
  mutate(
    ## Invert the sign of expenses
    b2016=ifelse(Type=="Expense",-1,1)*b2016,
    b2017=ifelse(Type=="Expense",-1,1)*b2017
    ) ->
  alldata
```

    ## Warning in function_list[[k]](value): NAs introduced by coercion

    ## # A tibble: 6 x 10
    ##   lineItem        b2016  b2017 TblCh~ Total Net   Title Type  Dept  Ignor~
    ##   <chr>           <dbl>  <dbl>  <int> <lgl> <lgl> <lgl> <chr> <chr> <lgl> 
    ## 1 Department Sum~    NA     NA      0 F     F     T     Expe~ <NA>  T     
    ## 2 REVENUE            NA     NA      1 F     F     T     Reve~ <NA>  T     
    ## 3 Corporate Admi~ 11000  11000      1 F     F     F     Reve~ <NA>  F     
    ## 4 Information Te~ 74000 106480      1 F     F     F     Reve~ <NA>  F     
    ## 5 Board Support ~     0      0      1 F     F     F     Reve~ <NA>  F     
    ## 6 Member Service~  6000  22500      1 F     F     F     Reve~ <NA>  F

Now we can filter to only rows we need.

``` r
alldata %>% 
  filter(!IgnoreRow)->
  flaggeddata
```

We can further split this into summary tables (the first two) and the detail tables (everything after).

``` r
flaggeddata %>%
  filter(TblChange <= 2)  %>% 
  select(
    ## Remove extraneous rows
   -(TblChange:Title ), -IgnoreRow
    )->
  summarydata

flaggeddata %>%
  filter(TblChange > 2) %>% 
  select(
    ## Remove extraneous rows
   -(TblChange:Title ), -IgnoreRow
    ) ->
  detaildata
```

    ## # A tibble: 6 x 5
    ##   lineItem                               b2016    b2017 Type    Dept      
    ##   <chr>                                  <dbl>    <dbl> <chr>   <chr>     
    ## 1 Gain/Loss on Revaluation of Euro         0        0   Revenue Corporate~
    ## 2 Interest - Miscellaneous             11000    11000   Revenue Corporate~
    ## 3 Misc FY Adjustments                      0        0   Revenue Corporate~
    ## 4 Unrealized Gain/Loss on Investments      0        0   Revenue Corporate~
    ## 5 Accounting - General                - 3500   - 5000   Expense Corporate~
    ## 6 Annual Report                       -   37.0 -   37.0 Expense Corporate~

What's next?
------------

Now that the data is in a consumable format, we can now analyse the budget. That'll be a future blog post and in the interim, you can download the [budget as a CSV](//itsalocke.com/blog/files/budgetdata.csv) to give it a go yourself or improve the [code above](//itsalocke.com/blog/files/2017-12-29-working-with-pdfs-scraping-the-pass-budget.R).
