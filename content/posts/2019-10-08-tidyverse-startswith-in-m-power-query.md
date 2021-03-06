---
title: "Tidyverse 'Starts_with' in M/Power Query"
date: 2018-10-08T15:13:39+01:00
author: "David Parr"
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

As a heavy `R` and `Tidyverse` user, I've been playing with Microsofts `m`/Power Query language included in Excel and PowerBI from that perspective, looking for the functions to make my life easier, developing small code pipelines for my processing and trying to get a smooth, clear and maintainable data manipulation process in place. 

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

The general rule is that the variable is encoded in the first part of the column name string, and that the columns with `[variable]_value` hold the actual value while the other three columns (`[variable]_source`, `[variable]_sourceid` and `[variable]_timestamp`) contain metadata we don't really need here.

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
    rawData = Source{[tableId="myData"]}[Data],
    removeSources = Table.RemoveColumns(rawData, List.Select(Table.ColumnNames(rawData), each Text.EndsWith(_, "Source ID") or Text.EndsWith(_, "Source")))
in
    removeSources
```

This code block sources `rawData` and 'lists' the columns matching my requirements (`"_source"` and `"_sourceid"`) using the logical condition `each Text.EndsWith(_, "Source ID") or Text.EndsWith(_, "Source")` on the column names returned from `Table.ColumnNames(rawData)` feeding into `List.Select(...)`. This list is the second argument to the function `Table.RemoveColumns(...)`, which is operating on the `rawData` again, to finally return only the columns I want.

## The Observations

This generally suits the requirements: _relatively_ readable functions, multiple logical conditions operating on the column names that 'select' which I want returned in the next step.

It is admittedly a little more verbose than the `R` I had in mind, and right now I'm not sure if that's me or just the language. There is some repetition in specifying `rawData` in multiple places, which I haven't found a shorthand for if there is one. Parts of it seem only 'functional-ish'? The construction of `each Text.EndsWith(_, "Source ID") or Text.EndsWith(_, "Source"))` is pretty object-oriented. Without wanting to sound insulting maybe `m` is only 'semi-functional' in the technical definition of the term?

## The Caveat

This is the first `m` code I've really written and my knee-jerk first impressions. I'm sure there is a lot more to this language that I have yet to understand and maybe even come to appreciate.

## The Conclusion

Despite these observations I wouldn't discount the potential of `m`/Power Query. While many Microsoft tools let you use R baked in, it's only baked in to the point where you can guarantee `R` is installed on the machine, and it's an undeniable fact of data that we have to work with Excel and Power BI in many situations. I'm actually quite looking forward to working with this not-quite-familar 'functional-ish data language' in the future. When it's the tool for the job at least :)