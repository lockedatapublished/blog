---
title: Is my time series additive or multiplicative?
author: Steph

date: 2017-02-20T10:46:20+00:00
categories:
  - Data Science
  - R
tags:
  - r
  - time series

---
Time series data is an important area of analysis, especially if you do a lot of web analytics. To be able to analyse time series effectively, it helps to understand the interaction between general seasonality in activity and the underlying trend.

The interactions between trend and seasonality are typically classified as either additive or multiplicative. This post looks at how we can classify a given time series as one or the other to facilitate further processing.
  
<!--more-->

## Additive or multiplicative?

It&#8217;s important to understand what the difference between a multiplicative time series and an additive one before we go any further.

There are three components to a time series:
  
&#8211; **trend** how things are overall changing
  
&#8211; **seasonality** how things change within a given period e.g. a year, month, week, day
  
&#8211; **error**/**residual**/**irregular** activity not explained by the trend or the seasonal value

How these three components interact determines the difference between a multiplicative and an additive time series.

In a multiplicative time series, the components multiply together to make the time series. If you have an increasing trend, the amplitude of seasonal activity increases. Everything becomes more exaggerated. This is common when you&#8217;re looking at web traffic.

In an additive time series, the components add together to make the time series. If you have an increasing trend, you still see roughly the same size peaks and troughs throughout the time series. This is often seen in indexed time series where the absolute value is growing but changes stay relative.

> You can have a time series that is somewhere in between the two, a statistician&#8217;s &#8220;it depends&#8221;, but I&#8217;m interested in attaining a quick classification so I won&#8217;t be handling this complication here. 

## There&#8217;s a package for that

When I first started doing time series analysis, the only way to visualise how a time series splits into different components was to use base R. About the time I was feeling the pain, someone released a ggplot2 time series extension! I&#8217;ll be using [ggseas][1] where I can.

We&#8217;ll use the `nzbop` data set from ggseas to, first of all, examine a single time series and then process all the time series in the dataset to determine if they&#8217;re multiplicative or additive.

    sample_ts<-nzdata[Account == "Current account" & Category=="Services; Exports total",
                      .(TimePeriod, Value)]
    

| TimePeriod | Value |
|:---------- | -----:|
| 1971-06-30 |    55 |
| 1971-09-30 |    56 |
| 1971-12-31 |    60 |
| 1972-03-31 |    65 |
| 1972-06-30 |    65 |
| 1972-09-30 |    63 |

> I&#8217;ll be using other packages (like data.table) and will only show relevant code snippets as I go along. You can get the whole script in a [GIST][2]. 

## Decomposing the data

To be able to determine if the time series is additive or multiplicative, the time series has to be split into its components.

> Existing functions to decompose the time series include `decompose()`, which allows you pass whether the series is multiplicative or not, and `stl()`, which is [only for additive series without transforming the data][3]. I could use `stl()` with a multiplicative series if I transform the time series by taking the log. For either function, I need to know whether it&#8217;s additive or multiplicative first. 

### The trend

The first component to extract is the trend. There are a number of ways you can do this, and some of the simplest ways involve calculating a moving average or median.

    sample_ts[,trend := zoo::rollmean(Value, 8, fill=NA, align = "right")]
    

| TimePeriod | Value |    trend |
|:---------- | -----:| --------:|
| 2014-03-31 |  5212 | 4108.625 |
| 2014-06-30 |  3774 | 4121.750 |
| 2014-09-30 |  3698 | 4145.500 |
| 2014-12-31 |  4752 | 4236.375 |
| 2015-03-31 |  6154 | 4376.500 |
| 2015-06-30 |  4543 | 4478.875 |

> A moving median is less sensitive to outliers than a moving mean. It doesn&#8217;t work well though if you have a time series that includes periods of inactivity. Lots of 0s can result in very weird trends. 

### The seasonality

Seasonality will be cyclical patterns that occur in our time series once the data has had trend removed.

Of course, the way to de-trend the data needs to additive or multiplicative depending on what type your time series is. Since we don&#8217;t know the type of time series at this point, we&#8217;ll do both.

    sample_ts[,`:=`( detrended_a = Value - trend,  detrended_m = Value / trend )]
    

| TimePeriod | Value |    trend | detrended_a | detrended_m |
|:---------- | -----:| --------:| -----------:| -----------:|
| 2014-03-31 |  5212 | 4108.625 |    1103.375 |   1.2685509 |
| 2014-06-30 |  3774 | 4121.750 |    -347.750 |   0.9156305 |
| 2014-09-30 |  3698 | 4145.500 |    -447.500 |   0.8920516 |
| 2014-12-31 |  4752 | 4236.375 |     515.625 |   1.1217137 |
| 2015-03-31 |  6154 | 4376.500 |    1777.500 |   1.4061465 |
| 2015-06-30 |  4543 | 4478.875 |      64.125 |   1.0143172 |

To work out the seasonality we need to work out what the typical de-trended values are over a cycle. Here I will calculate the mean value for the observations in Q1, Q2, Q3, and Q4.

    sample_ts[,`:=`(seasonal_a = mean(detrended_a, na.rm = TRUE),
                 seasonal_m = mean(detrended_m, na.rm = TRUE)), 
              by=.(quarter(TimePeriod)) ]
    

| TimePeriod | Value |    trend | detrended_a | detrended_m | seasonal_a | seasonal_m |
|:---------- | -----:| --------:| -----------:| -----------:| ----------:| ----------:|
| 2014-03-31 |  5212 | 4108.625 |    1103.375 |   1.2685509 |   574.1919 |  1.2924422 |
| 2014-06-30 |  3774 | 4121.750 |    -347.750 |   0.9156305 |  -111.2878 |  1.0036648 |
| 2014-09-30 |  3698 | 4145.500 |    -447.500 |   0.8920516 |  -219.8363 |  0.9488803 |
| 2014-12-31 |  4752 | 4236.375 |     515.625 |   1.1217137 |   136.7827 |  1.1202999 |
| 2015-03-31 |  6154 | 4376.500 |    1777.500 |   1.4061465 |   574.1919 |  1.2924422 |
| 2015-06-30 |  4543 | 4478.875 |      64.125 |   1.0143172 |  -111.2878 |  1.0036648 |

> My actual needs aren&#8217;t over long economic periods so I&#8217;m not using a better seasonality system for this blog post. There are some much better mechanisms than this. 

### The remainder

Now that we have our two components, we can calculate the residual in both situations and see which has the better fit.

    sample_ts[,`:=`( residual_a = detrended_a - seasonal_a, 
                     residual_m = detrended_m / seasonal_m )]
    

| TimePeriod | Value |    trend | detrended_a | detrended_m | seasonal_a | seasonal_m | residual_a | residual_m |
|:---------- | -----:| --------:| -----------:| -----------:| ----------:| ----------:| ----------:| ----------:|
| 2014-03-31 |  5212 | 4108.625 |    1103.375 |   1.2685509 |   574.1919 |  1.2924422 |   529.1831 |  0.9815146 |
| 2014-06-30 |  3774 | 4121.750 |    -347.750 |   0.9156305 |  -111.2878 |  1.0036648 |  -236.4622 |  0.9122871 |
| 2014-09-30 |  3698 | 4145.500 |    -447.500 |   0.8920516 |  -219.8363 |  0.9488803 |  -227.6637 |  0.9401098 |
| 2014-12-31 |  4752 | 4236.375 |     515.625 |   1.1217137 |   136.7827 |  1.1202999 |   378.8423 |  1.0012620 |
| 2015-03-31 |  6154 | 4376.500 |    1777.500 |   1.4061465 |   574.1919 |  1.2924422 |  1203.3081 |  1.0879763 |
| 2015-06-30 |  4543 | 4478.875 |      64.125 |   1.0143172 |  -111.2878 |  1.0036648 |   175.4128 |  1.0106135 |

## Visualising decomposition

I&#8217;ve done the number crunching, but you could also perform a visual decomposition. ggseas gives us a function `ggsdc()` which we can use.

    ggsdc(sample_ts, aes(x = TimePeriod, y = Value), method = "decompose", 
          frequency = 4, s.window = 8, type = "additive")+ geom_line()+
      ggtitle("Additive")+ theme_minimal()
    


  
The different decompositions produce differently distributed residuals. We need to assess these to identify which decomposition is a better fit.

## Assessing fit

After decomposing our data, we need to compare the residuals. As we&#8217;re just trying to classify the time series, we don&#8217;t need to do anything particularly sophisticated &#8211; a big part of this exercise is to produce a quick function that could be used to perform an initial classification in a batch processing environment so simpler is better.

We&#8217;re going to check the whether how much correlation between data points is still encoded within the residuals. This is the [Auto-Correlation Factor (ACF)][4] and it has a function for calculating it. As some of the correlations could be negative we will select the type with the smallest sum of squares of correlation values.

    ssacf<- function(x) sum(acf(x, na.action = na.omit)$acf^2)
    compare_ssacf<-function(add,mult) ifelse(ssacf(add)< ssacf(mult), "Additive", "Multiplicative") 
    sample_ts[,.(ts_type = compare_ssacf(residual_a, residual_m ))]
    

| ts_type        |
|:-------------- |
| Multiplicative |

## Putting it all together

This isn&#8217;t a fully generalized function (as it doesn&#8217;t have configurable lags, medians, seasonality etc) but if I had to apply to run this exercise over multiple time series from this dataset, my overall function and usage would look like:

    ssacf<- function(x) sum(acf(x, na.action = na.omit, plot = FALSE)$acf^2)
    compare_ssacf<-function(add,mult) ifelse(ssacf(add)< ssacf(mult), 
                                             "Additive", "Multiplicative") 
    additive_or_multiplicative <- function(dt){
      m<-copy(dt)
      m[,trend := zoo::rollmean(Value, 8, fill="extend", align = "right")]
      m[,`:=`( detrended_a = Value - trend,  detrended_m = Value / trend )]
      m[Value==0,detrended_m:= 0]
      m[,`:=`(seasonal_a = mean(detrended_a, na.rm = TRUE),
                      seasonal_m = mean(detrended_m, na.rm = TRUE)), 
                by=.(quarter(TimePeriod)) ]
      m[is.infinite(seasonal_m),seasonal_m:= 1]
      m[,`:=`( residual_a = detrended_a - seasonal_a, 
                       residual_m = detrended_m / seasonal_m)]
      compare_ssacf(m$residual_a, m$residual_m )
    }
    
    # Applying it to all time series in table
    sample_ts<-nzdata[ , .(Type=additive_or_multiplicative(.SD)),
                        .(Account, Category)]
    

| Account           | Category                                       | Type           |
|:----------------- |:---------------------------------------------- |:-------------- |
| Current account   | Inflow total                                   | Additive       |
| Current account   | Balance                                        | Multiplicative |
| Current account   | Goods; Exports (fob) total                     | Additive       |
| Current account   | Services; Exports total                        | Multiplicative |
| Current account   | Primary income; Inflow total                   | Multiplicative |
| Current account   | Secondary income; Inflow total                 | Multiplicative |
| Current account   | Goods balance                                  | Multiplicative |
| Current account   | Services balance                               | Multiplicative |
| Current account   | Primary income balance                         | Additive       |
| Current account   | Outflow total                                  | Additive       |
| Current account   | Goods; Imports (fob) total                     | Additive       |
| Current account   | Services; Imports total                        | Additive       |
| Current account   | Primary income; Outflow total                  | Additive       |
| Current account   | Secondary income; Outflow total                | Multiplicative |
| Capital account   | Inflow total                                   | Multiplicative |
| Capital account   | Outflow total                                  | Multiplicative |
| NA                | Net errors and omissions                       | Multiplicative |
| Financial account | Foreign inv. in NZ total                       | Multiplicative |
| Financial account | Balance                                        | Additive       |
| Financial account | Foreign inv. in NZ; Direct inv. liabilities    | Additive       |
| Financial account | Foreign inv. in NZ; Portfolio inv. liabilities | Multiplicative |
| Financial account | Foreign inv. in NZ; Other inv. liabilities     | Multiplicative |
| Financial account | NZ inv. abroad total                           | Multiplicative |
| Financial account | NZ inv. abroad; Direct inv. assets             | Multiplicative |
| Financial account | NZ inv. abroad; Portfolio inv. assets          | Additive       |
| Financial account | NZ inv. abroad; Financial derivative assets    | Multiplicative |
| Financial account | NZ inv. abroad; Other inv. assets              | Additive       |
| Financial account | NZ inv. abroad; Reserve assets                 | Multiplicative |

## Conclusion

This is a very simple way of quickly assessing whether multiple time series are additive or multiplicative. It gives an effective starting point for conditionally processing batches of time series. Get the [GIST][2] of the code used throughout this blog to work through it yourself. If you&#8217;ve got an easier way of classifying time series, let me know in the comments!

 [1]: https://cran.r-project.org/package=ggseas
 [2]: https://gist.github.com/stephlocke/682f618e36b07945aa48871e0563b3fa
 [3]: https://www.otexts.org/fpp/6/5
 [4]: https://onlinecourses.science.psu.edu/stat510/node/60