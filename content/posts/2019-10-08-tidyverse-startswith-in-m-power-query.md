---
title: "Tidyverse 'Starts_with' in M/Power Query"
date: 2018-10-08T15:13:39+01:00
draft: true
author: "Dave"
categories:
  - PowerBI
  - Power Query
  - m
tags:
  - tidyverse
  - data processing
  - filtering
  - strings
---

As being a heavy `R` and `Tidyverse` user, I've been playing with Microsofts `m`/Power Query language from that perspective, looking for the functions to make my life easier, developing small code pipelines for my processing and trying to get a smooth, clear and maintainable data manipulation process in place. 

## The Problem

In PowerBI I have data generated from an API call to HubSpot, which deliveres a `json` which is flattened as the first step of the process into a table with hundreds of columns. These columns have a pretty regular naming convention, in a form similar to this:

```
client_notified_timestamp
client_notified_source
client_notified_sourceid
client_notified_value
client_responded_timestamp
client_responded_source
client_responded_sourceid
client_responded_value
```

The general rule is that the general variable is encoded in the first part of the column name string, and that the later parts of the column name hold that value in the `[variable]_value` column and the other three columns (`[variable]_source`, `[variable]_sourceid` and `[variable]_timestamp`) contain metadata we don't really need here.

## The Target

If I was using R to do this job (which _technically_ I could, but was not possible because of the context the PowerBI file is going to be used in), I could use tidyverse to do this pretty simply:

```r
dataset %>%
    select(c(-ends_with("_source"),-ends_with("_sourceid")))
```

Anything that ends with `"_source"` or `"_sourceid"` gets dropped, everything else remains. A nice compact, maintainable and clear expression of a 'rule' of processing.

## The Solution

This is the solution I used:

```m
let
    Source = ...,
    #"My Raw Data" = Source{[tableId="myData"]}[Data],
    #"Removed 'Source's" = Table.RemoveColumns(#"My Raw Data", List.Select(Table.ColumnNames(#"My Raw Data"), each Text.EndsWith(_, "Source ID") or Text.EndsWith(_, "Source")))
in
    #"Removed 'Source's"
```
This code block sources `"My Raw Data"` and 'lists' the columns matching my requirements (`"_source"` and `"_sourceid"`) into the object(step?) `#"All 'Source' and 'Source ID' suffix cols"`. This object is then used as an argument to Remove columns from the original data.

## The Observations

This generally suits the requirements: piped functions, _relatively_ readable, multiple logical conditions operating on the column names that 'select' which I want returned in the next step.

It is admittedly a little more verbose than the `R` I had in mind, and right now I'm not sure if that's me or just the language. There is some repetition in specifying `#"My Raw Data"` in multiple places, which I haven't found a shorthand for if there is one.  Parts of it seem only 'functional-ish'? The construction of `each Text.EndsWith(_, "Source ID") or Text.EndsWith(_, "Source"))` is pretty imperative. Without wanting to sound insulting maybe `m` is only 'semi-functional' in the technical definition of the term?

## The Conclusion

Despite these observations I wouldn't discount the potential of `m`/Power Query. While many tools let you use R baked in, it's only baked in to the point where you can guarantee `R` is installed on the machine, and it's an undeniable fact of data work that we have to work with Excel and Power BI in many situations. I'm quite looking forward to working with this not-quite-familar 'functional-ish piping data language' in the future. When it's the tool for the job at least :)