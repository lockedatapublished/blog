---
title: A particles-arly fun book draw
author: maelle
type: post
date: 2018-05-02
spacious_page_layout:
  - default_layout
categories:
  - Data Science
  - R
tags:
  - r

---

Did you know that every month, a random Locke Data Twitter follower wins a nifty data science book? If you don't, and you don't follow [Locke Data on Twitter](https://twitter.com/LockeData) yet, do it! This month's book was "Tidy text mining" by Julia Silge and David Robinson, a fantastic introduction to Natural Language Processing in R. If you haven't been lucky enough to score a paperback version, you can read it [online](https://www.tidytextmining.com/) for free! You can check out tweets about previous give-aways via [this Twitter moment](https://twitter.com/i/moments/982169969008918528) and see that on top of giving away great books we also try to make the winner announcement fun. In this post I shall explain how we announced this month's winner with an animated gif of followers' screennames using the `particles` package.

# Bag of words, bag of followers

Last month, I had created a magical gif to announce the winner of "Dear Data", in which Wizard chibi Steph made a book image disappear, revealing who the winner was. I used the `particles` package that simulates particles, which allowed us to simulate the movements of pixels.

{{< tweet 980753545262661634 >}}

You can find the R script [here](https://github.com/lockedata/twitter_book_draw/blob/master/R/code_with_particles.R), derived from [this gist by `particles` creator Thomas Lin Pedersen](https://gist.github.com/thomasp85/0938c3ece34b9515d889f3b1f9c3fc9c). This month, I wanted to be slightly more ambitious in order to use _words_ as the basis for the visualization, and in order to dive a bit more into the `particles` package instead of barely adapting an existing gist, and share my learning process with you. 

Learning more about R by visualizing stuff is probably good idea, as phrased in this tweet

{{< tweet 984537744985686016 >}}

I had in mind a wordcloud of all followers' screenames, that would move and all of a sudden change so that only the name remained. How did I achieve that?

# The genesis of the bag

A very good post by Thomas explains [how he animated his blog logo](https://www.data-imaginist.com/2017/animating-the-logo/). I'll write a step-by-step here too. Compared to last month, I dived into `particles` docs which was _fascinating_. A good intro is [the announcement blog post](https://www.data-imaginist.com/2018/let-it-flow-let-it-flow-let-it-flow/), and in general the functions are actually well documented. Last month I had merely looked at them, in order to simply adapt the existing gist, while this time I unsurprisingly learnt more by doing _and_ reading. 

## Drawing a winner

That part is actually the same every month.

```r
# get all followers
set.seed(20180501)
follower_ids <- rtweet::get_followers("lockedata")
followers <- rtweet::lookup_users(follower_ids$user_id)
# draw a random winner
winner <- sample_n(followers, size = 1)$screen_name
```

## Choosing a color by follower

I used the [`charlatan`](https://twitter.com/thomasp85/status/991203238174175232) package by rOpenSci's Scott Chamberlain to draw random colours and get a nice rainbow. That package can help you with many of your fake data creation needs by the way!

```r
# draw one random colour per follower
colors <- charlatan::ch_hex_color(n = nrow(followers))
colors[followers$screen_name == winner] <- "#2165B6"
names(colors) <- followers$screen_name
```

I assigned the official Locke Data blue color to the winner, and named the vector with follower names in order to be able to use it as `ggplot2` color scale values.

## Simulating the movements of names

The following code is the one creating the 62 steps of a simulation of the movements of followers' names!

```r
# now simulate an aquarium of followers
first <- 50
second <- 12
max_it <- first + second
set.seed(1)
sim <- create_lattice(nrow(followers)) %>%
  simulate(velocity_decay = 0,
           setup = petridish_genesis(vel_min = 0),
           alpha_decay = 0) %>%
  evolve(first, function(sim) {
    sim <- record(sim)
    sim
  })%>%
  wield(y_force, y = -10,
        strength = .02) %>%
  evolve(second, function(sim) {
    sim <- record(sim)
    sim
  })
```
The first step consists of creating a lattice as big as the number of followers, and then assigning to each particle a random position withing a circle (a Petri dish! see how fascinating `particles` terminology is?) and a random velocity. I chose to set `velocity_decay` and `alpha_decay` to 0 in order not to let the system cool down. I then let the system evolved for 50 steps, randomly, without setting any constraint, so followers' names partly disappeared from the image at some points, which was fine by me. After that, I added a `y_force` pulling down followers' names. `strength` and the number of steps, 12, were set to get a not too violent downwards movement. Note that since there was no cooling down (no alpha and velocity decay so the particles never got tired of moving), after touching the bottom the cloud of followers' names actually bounced back up hence my stopping the movie at that point.

Being able to add code inside the `evolve` call in order to record the simulation was crucial, since I wanted to prepare the visualization at the end.

As you can imagine, one can spend hours modifying parameters' values, adding and removing forces, etc. A very powerful package, in which even error messages are fun!

{{< tweet 991203238174175232 >}}

## Transforming the simulation history

I wrote a small helper to transform the simulation history into a `data.frame`

```r
transform_to_df <- function(sim, step, followers){
  df <- as_tibble(sim)
  df$step <- step
  df$name <- followers$screen_name
  df
}

sim_df <- purrr::map2_df(sim$history, 1:length(sim$history),
                         transform_to_df,
                         followers)
```

I could have worked directly with the list I guess, since I then had a frame by step in the animation, but I needed the `data.frame` to change the winner's trajectory. A style note, I think `history(sim)` would have been more elegant than `sim$history`, since there's this accessor function.


## Tweaking the winner's trajectory

Ideally I'd have liked the simulation itself to decide on the winner, but that's not how I designed the whole script, so I made the winner's name move from whatever its initial position was to the center.

```r
sim_df$x[sim_df$name == winner] <- seq(sim_df$x[sim_df$name == winner][1], to = 0,
                                       length = length(unique(sim_df$step)))
sim_df$y[sim_df$name == winner] <- seq(sim_df$y[sim_df$name == winner][1], to = 0,
                                       length = length(unique(sim_df$step)))
```

## Plotting all movements

I used the code below to plot all movements. The function takes the simulation at one step (as a `data.frame`) and the colours vector defined previously, and plots the names. Important points are using `theme_void`, and the `Roboto` font which is one of the two fonts Locke Data uses everywhere. Branding!

```r
plot_one_step <- function(df, colors){

  p <- ggplot(df) +
    geom_text(aes(x, y, label = name,
                  col = name),
              size = 2)  +
    scale_color_manual(values = colors)+
    theme_void() +
    theme(legend.position = "none")+
    theme(text=element_text(family="Roboto", size=14)) +
    ylim(-11, 14)
  outfil <- paste0("may_files/sim_", stringr::str_pad(df$step[1], 2, pad = "0"), ".png")
  ggsave(outfil, p, width=5, height=5)

}

split(sim_df, sim_df$step) %>%
  purrr::walk(plot_one_step, colors = colors)

```

## Adding celebratory frames

Now, the winner isn't very clear at the end, so I added more frames to make their name grow. In this function I add the winner name so I "delete" it from the general cloud plotting by plotting in white.

```r
colors[followers$screen_name == winner] <- "#FFFFFF"
plot_win <- function(step, df, colors){
  p <- ggplot(df) +
    geom_text(aes(x, y, label = name,
                  col = name),
              size = 2) +
    geom_text(aes(x, y, label = name),
              col = "#2165B6", size = step/20*15,
              data = df[df$name == winner,]) +
    scale_color_manual(name = colors,
                       values = colors)+
    theme_void() +
    theme(legend.position = "none")+
    theme(text=element_text(family="Roboto", size=14)) +
    ylim(-11, 14)
  outfil <- paste0("may_files/ZZZsim_", stringr::str_pad(step, 2, pad = "0"), ".png")
  ggsave(outfil, p, width=5, height=5)

}
purrr::walk(1:20, plot_win,
            sim_df[sim_df$step == max_it,], colors = colors)
```

## Putting it all together

In _theory_ the code below, using rOpenSci's `magick` package, should have worked and allowed me to add Locke Data logo to the gif.


```r
logo <- magick::image_read("assets/logo.png")
logo <- magick::image_resize(logo, "200x200")

library("magrittr")
dir("may_files", full.names = TRUE) %>%
  magick::image_read() %>%
  magick::image_resize("600x600")  %>%
  magick::image_composite(logo, offset = "+50+50") %>%
  magick::image_write("bagoffollowers.gif", format = "gif")
```

Jeroen Ooms, [`magick`](https://github.com/ropensci/magick) maintainer, even helped me simplify the pipeline, but it still seemed to last ages for the 62 frames, although it worked ok for less frames. It was already time to announce the winner so I used an online tool to create the gif out of the images.

{{< tweet 991401888057880576 >}}

In this tweet, you see why next months' code will use `paste` or `glue` to create the tweet text... There was a "SQLBob"/"SQL_Bob" here, well done me! But well, even more happy readers this month!

# See you next month!

In one short month a new book winner will be drawn so stay tuned! Will Locke Data ever give away a book by [`particles` creator](https://www.data-imaginist.com/about/)? Well since he [publicly said](https://user2018.r-project.org/blog/2018/04/18/interview-with-thomas-lin-pedersen/) he wants to write books... we can be hopeful!
