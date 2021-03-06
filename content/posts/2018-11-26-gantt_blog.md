---
title: "Project planning with plotly"
author: "Ellen Talbot"
date: "2018-11-26"
output: html_document
---

Something a little different today for a quick chat about my latest
project and why I’m finding the `plotly` package so helpful\!

Are you like me and physically can’t function unless you’ve got a to do
list in front of you? Well even if you’re not, imagine my pain while I’m
wearing my non - Locke Data hat and trying to plan out the final year of
my PhD thesis\!

I needed something that updated easily, something visual and something
to keep my supervisors in the know. I’ve previously made gantt charts
using LaTeX but found it ridiculously clunky to get working and decided
there had to be a better way. And if I could include interactivity then
all the better, which is how I discovered `plotly`.

## Plotly

The plotly package makes interactive, publication quality graphs online.
It uses the JavaScript graphing library and is really versatile\! You
can make graphs, maps, 3D plots and, as I’m about to explain, gantt
charts.

``` r
require(plotly)
```

## Step by Step Gantt Chart

Install the packages you need for generating the gantt chart

``` r
library(RColorBrewer)
library(readxl)
library(widgetframe)
```

Setting fonts isn’t necessary as there are defaults, but it’s always
nice to know how to do it should you want to.

``` r
f <- list(
  family = "Courier New, monospace",
  size = 18,
  color = "#7f7f7f"
)
```

Set a title for the X axis. Uncomment the Y axis if you’d like to label
that too :)

``` r
x <- list(
  title = "Date",
  titlefont = f
)
# y <- list(
#   title = "Task Number",
#   titlefont = f
# ) 
```

### Read in your data

To make this gantt chart work, you need a column with a date you intend
to `start` the task - we’ll make sure this is formatted in a minute. You
also need a column with a `duration` to generate the length of the bar
for each task (this is in days in my case\!) and if you want to group and colour code your tasks, it’s
the `Chapter` column which does this.

The `Task` and `Progress` columns aren’t necessary, but they are good
for labelling and keeping yourself accountable, and an easy way to share
updates with people who are checking up on your
progress\!

``` r
df <- read_xlsx(path = "../../../../Book_thesis/00_Time_Plan/timeplan.xlsx", sheet = 1) 
head(df)
```

    ## # A tibble: 6 x 5
    ##   Task                       start               Duration Chapter Progress
    ##   <chr>                      <dttm>                 <dbl> <chr>   <chr>   
    ## 1 Review literature review … 2018-07-03 00:00:00        2 2       Complet…
    ## 2 2.1 Energy on a larger sc… 2018-07-05 00:00:00        5 2       Complet…
    ## 3 2.1 Energy in a UK context 2018-07-12 00:00:00        7 2       Complet…
    ## 4 2.2 Traditional collectio… 2018-07-23 00:00:00        3 2       Complet…
    ## 5 2.2 New technologies and … 2018-07-26 00:00:00        3 2       Complet…
    ## 6 2.3 Data Bias and Represe… 2018-07-31 00:00:00        3 2       Complet…

Make sure your date column is correctly formatted

``` r
df$start <- as.Date(df$start, format="%Y-%m-%d") 
```

Next generate a list of colours. This corresponds to my `Chapter`
column, so change this accordingly. It creates a list assigning a colour
to each group of
tasks

``` r
cols <- brewer.pal(length(unique(factor(df$Chapter))), name = "Set3") # Generate a list of colours that are as long as your group of tasks
# This won't work if column has blanks

df$color <- factor(df$Chapter, labels = cols) # Attach these colours as factors to each group of tasks
```

The next chunk of code generates a date line updated automatically based
on your computer's system date.

``` r
# annotation
a <- list(text = "Today's date",
          x = Sys.Date(),
          y = 1.02,
          xref = 'x',
          yref = 'paper',
          xanchor = 'left',
          showarrow = FALSE
)

# use shapes to create a line
l <- list(type = line,
          x0 = Sys.Date(),
          x1 = Sys.Date(),
          y0 = 0,
          y1 = 1,
          xref = 'x',
          yref = 'paper',
          line = list(color = 'black',
                      width = 0.7)
)
```

Build your plot combining all the elements you generated earlier. Change
the `text` section to personalise your chart

``` r
p <- plot_ly()
for(i in 1:(nrow(df) - 1)){
  p <- add_trace(p,
                 x = c(df$start[i], df$start[i] + df$Duration[i]), 
                 y = c(i, i), 
                 mode = "lines",
                 line = list(color = df$color[i], width = 20),
                 showlegend = F,
                 hoverinfo = "text",
                 text = paste("Task: ", df$Task[i], "<br>",
                              "Duration: ", df$Duration[i], "days<br>",
                              "Chapter: ", df$Chapter[i], "<br>",
                              "Status: ", df$Progress[i]), "<br>",
                 evaluate = T
  )
}
```

Now simply plot your chart and add axis labels, your title and ‘Today’s
date’ - The plotly package will generate an interactive chart that you
can zoom, hover and share\!

``` r
p %>%
  layout(xaxis = x, 
         # yaxis = y,
         title = "Thesis Schedule",
         annotations = a,
         shapes = l)
```

<iframe id="serviceFrameSend" src="../img/p.html" width="1000" height="1000" frameborder="0"></iframe>

Ta-Dah\! Now all I have to do is stick to it…
