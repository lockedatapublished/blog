## ----message=FALSE-------------------------------------------------------
library(tabulizer)
library(tidyverse)
library(zoo)
library(tidytext)

## ------------------------------------------------------------------------
"http://www.pass.org/Portals/0/Governance%202016/Financials/pass-budget-2017.pdf?ver=2017-01-25-235556-197" %>%
  tabulizer::extract_text() ->
  rawtxt

str_trunc(rawtxt, 1000)

## ------------------------------------------------------------------------
rawtxt %>%
  tokenize(tokenizer = tokenizer_line()) %>% 
  head()

## ------------------------------------------------------------------------
rawtxt %>%
  tokenize(tokenizer = tokenizer_line()) %>%
  str_replace_all("\\s+", " ") %>%
  str_trim(side = "both") %>%
  str_split(" ") %>% 
  head()

## ------------------------------------------------------------------------
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

## ------------------------------------------------------------------------
rawtxt %>%
  tokenize(tokenizer = tokenizer_line()) %>%
  str_replace_all("\\s+", " ") %>%
  str_trim(side = "both") %>%
  str_split(" ") %>%
  map_df(combineLHS) ->
  rawdata

rawdata %>% 
  head()

## ------------------------------------------------------------------------
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

## ------------------------------------------------------------------------
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

## ----echo=FALSE----------------------------------------------------------
alldata %>%  head()

## ------------------------------------------------------------------------
alldata %>% 
  filter(!IgnoreRow)->
  flaggeddata

## ------------------------------------------------------------------------
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

## ----echo=FALSE----------------------------------------------------------
detaildata %>%  head()

