---
title: Understanding rolling calculations in R
author: Steph
date: '2018-03-07'
categories:
  - R
  - Data Science
tags:
  - feature engineering
  - r
---

In R, we often need to get values or perform calculations from
information not on the same row. We need to either retrieve specific
values or we need to produce some sort of aggregation. This post explores 
some of the options and explains the weird (to me at least!) behaviours 
around rolling calculations and alignments.

We can retrieve earlier values by using the `lag()` function from
`dplyr`[1]. This by default looks one value earlier in the sequence.

``` r
v=1:10
data.frame(v, l=dplyr::lag(v))
```

    ##     v  l
    ## 1   1 NA
    ## 2   2  1
    ## 3   3  2
    ## 4   4  3
    ## 5   5  4
    ## 6   6  5
    ## 7   7  6
    ## 8   8  7
    ## 9   9  8
    ## 10 10  9

We could even return a value from 2 elements earlier if we wanted.

``` r
data.frame(v, l=dplyr::lag(v,2))
```

    ##     v  l
    ## 1   1 NA
    ## 2   2 NA
    ## 3   3  1
    ## 4   4  2
    ## 5   5  3
    ## 6   6  4
    ## 7   7  5
    ## 8   8  6
    ## 9   9  7
    ## 10 10  8

So these kinda make sense – they bring back a specific value from
earlier in the sequence. There’s also complimentary function that takes
values from later in the sequence called `lead()`.

``` r
data.frame(v, l=dplyr::lead(v,2))
```

    ##     v  l
    ## 1   1  3
    ## 2   2  4
    ## 3   3  5
    ## 4   4  6
    ## 5   5  7
    ## 6   6  8
    ## 7   7  9
    ## 8   8 10
    ## 9   9 NA
    ## 10 10 NA

Unfortunately, a single value isn’t always what we need. We often need
some sort of aggregation that occurs over multiple values either earlier
or later in the sequence.

If we want to get a value that takes into account all prior values and
the current value, we can use functions like `cumsum()` to sum up as we
go further through the sequence.

``` r
data.frame(v, c=cumsum(v))
```

    ##     v  c
    ## 1   1  1
    ## 2   2  3
    ## 3   3  6
    ## 4   4 10
    ## 5   5 15
    ## 6   6 21
    ## 7   7 28
    ## 8   8 36
    ## 9   9 45
    ## 10 10 55

In a cumulative sum, the **window** over which the function operates for
each value is `1:n` so the window varies. The cumulative sum function
can’t be amended to be `1:n-1` so we can mimic that by subtracting the
current value.

``` r
data.frame(v, c=cumsum(v), c_1=cumsum(v)-v)
```

    ##     v  c c_1
    ## 1   1  1   0
    ## 2   2  3   1
    ## 3   3  6   3
    ## 4   4 10   6
    ## 5   5 15  10
    ## 6   6 21  15
    ## 7   7 28  21
    ## 8   8 36  28
    ## 9   9 45  36
    ## 10 10 55  45

All well and good, but what if I want to perform a calculation over a
specific number of prior values, or even values ahead in the sequence?
`cumsum` and `lag` no longer help us. `zoo` and `RcppRoll` give us some
**rolling** functions. The functions will perform an aggregation over a
moving **window** of a fixed size.

``` r
data.frame(v, c=RcppRoll::roll_sum(v))
```

    ##     v  c
    ## 1   1  1
    ## 2   2  2
    ## 3   3  3
    ## 4   4  4
    ## 5   5  5
    ## 6   6  6
    ## 7   7  7
    ## 8   8  8
    ## 9   9  9
    ## 10 10 10

So if we rely on the defaults, `roll_sum()` just returns the current
value. That’s not very useful and you might think it’s pretty weird![2]
Let’s see what happens when we use a different value for the window our
calculation should occur over.

``` r
data.frame(v, c2=RcppRoll::roll_sum(v,2), c3=RcppRoll::roll_sum(v,3))
```

    ## Error in data.frame(v, c2 = RcppRoll::roll_sum(v, 2), c3 = RcppRoll::roll_sum(v, : arguments imply differing number of rows: 10, 9, 8

Ick, an error! The calculation reduces the number of values so we need
to provide a fill.

``` r
data.frame(v, c2=RcppRoll::roll_sum(v,2, fill=NA), c3=RcppRoll::roll_sum(v,3, fill=NA))
```

    ##     v c2 c3
    ## 1   1  3 NA
    ## 2   2  5  6
    ## 3   3  7  9
    ## 4   4  9 12
    ## 5   5 11 15
    ## 6   6 13 18
    ## 7   7 15 21
    ## 8   8 17 24
    ## 9   9 19 27
    ## 10 10 NA NA

So looking at the code I wrote, you may have expected`c2` to hold
`NA, 3, 5, ...` where it’s taking the current value and the prior value
to make a window of width 2. Another reasonable alternative is that you
may have expected `c2` to hold `NA, NA, 3, ...` where it’s summing up
the prior two values. But hey, it’s kinda working like `cumsum()` right
so that’s ok! But wait, check out `c3`. I gave `c3` a window of width 3
and it gave me `NA, 6, 9, ...` which looks like it’s summing the prior
value, the current value, and the next value. …. That’s weird right?

It turns out the default behaviour for these rolling calculations is to
**center align** the window, which means the window sits over the
current value and tries it’s best to fit over the prior and next values
equally. In the case of us giving it an even number it decided to put
the window over the next values more than the prior values.
{{< figure src="../img/centeralign.gif" title="Centre align windows" >}}

Thankfully, with the rolling calculations we can adjust the alignment so
the window aligns **left** or **right**.

``` r
data.frame(v, c_l=RcppRoll::roll_sum(v,2, fill=NA, align="left"),
            c_r=RcppRoll::roll_sum(v,2, fill=NA, align="right"))
```

    ##     v c_l c_r
    ## 1   1   3  NA
    ## 2   2   5   3
    ## 3   3   7   5
    ## 4   4   9   7
    ## 5   5  11   9
    ## 6   6  13  11
    ## 7   7  15  13
    ## 8   8  17  15
    ## 9   9  19  17
    ## 10 10  NA  19

If, like me, you’d expect the left align to be the option for looking at
prior values you’d be very wrong. The convention for these calculations,
is **left align** extends into future values because the window starts
on with the current value on the left. The **right align** covers past
values because the window ends with the current value being on the
right.

 <div class="row">


<div class="col-lg-6"> 
{{< figure src="../img/leftalign.gif" title="Left align windows">}}
</div>
<div class="col-lg-6"> 
{{< figure src="../img/rightalign.gif" title="Right align windows">}}
</div>
</div>
As with `cumsum()` it’s taking into account the current value in all
circumstances. We can interleave our `dplyr::lag()` and `dplyr::lead()`
functions so that the window of the calculation is **offset**.

``` r
data.frame(v, c_l=RcppRoll::roll_sum(dplyr::lead(v),2, fill=NA, align="left"),
            c_r=RcppRoll::roll_sum(dplyr::lag(v),2, fill=NA, align="right"))
```

    ##     v c_l c_r
    ## 1   1   5  NA
    ## 2   2   7  NA
    ## 3   3   9   3
    ## 4   4  11   5
    ## 5   5  13   7
    ## 6   6  15   9
    ## 7   7  17  11
    ## 8   8  19  13
    ## 9   9  NA  15
    ## 10 10  NA  17

[1] The `data.table` function `shift()` could also be used

[2] You’d be right.
