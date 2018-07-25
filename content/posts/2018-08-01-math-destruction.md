---
title: A glass shattering book draw with gganimate
author: maelle
type: post
date: 2018-08-01
spacious_page_layout:
  - default_layout
categories:
  - Data Science
  - R
tags:
  - r

---

It's time for a Twitter book draw again: every month, a random Locke Data Twitter follower wins an excellent data science book! This month's book was [Weapons of Math Destruction : How Big Data Increases Inequality and Threatens Democracy](http://geni.us/mathdestruction). The animation I chose to create was inspired by the idea of _destruction_ and by my wanting to try out the fantastic new API of the `gganimate` package, and a very fast new gif encoder, `gifski`.

Choosing an animation concept
=============================

I am not a designer nor an artist, but I like imagining new animations to announce the book winner, that I want to be **fun**, and **useful** by illustrating the use of some nifty R tools. That's a good way for me and you to learn new R skills! I've reported on [my efforts with `magick` to create a crystal ball for chibi Steph](https://itsalocke.com/blog/a-crystal-clear-book-draw/), R package for image manipulation, and [with `particles`, R package for simulating, well, _particles_, to move followers' names around!](https://itsalocke.com/blog/a-particles-arly-fun-book-draw/). 

This month I thought about what destruction meant to me, and got the rather simple idea to have glass shatter, thus revealing the winner's name.

Planning the my animation implementation
========================================

Feel free to skip over this section and go to the code directly, unless you want to know more about my search and process to write said code!

I wondered how I could shatter glass, i.e. cut a blue square in small pieces and make these pieces fall and somehow ended up thinking that I could draw random points and then use their [Voronoi tiles](https://en.wikipedia.org/wiki/Voronoi_diagram) as fragments. I'm not sure glass shattering really looks like this but I decided against experimenting with my windows.  

I wasn't too sure how to make and use the fragments though. I re-read [Thomas Lin Pedersen's excellent post about making a Christmas card using Voronoi tesselation](https://www.data-imaginist.com/2016/data-driven-x-mas-card/) but as nice and well-explained as it was, it wasn't exactly what I was after. I set out to find a way to create Voronoi tiles as polygons and then to shift at least some of them downwards to create the animation.

I tried using the [`deldir` package](https://cran.r-project.org/web/packages/deldir/index.html) a bit to create Voronoi tesselation out of random points but its output didn't make me too happy since it was _segments_ rather than polygons. Re-creating polygons from them didn't sound too easy. I ditched this idea and googled keywords such as Voronoi and polygons and R and then `sf` the geospatial package since the first results indicated Voronoi tesselation was well supported for mapping stuff, and found this very useful [Stack Overflow post](https://stackoverflow.com/questions/45719790/create-voronoi-polygon-with-simple-feature-in-r) that made me [adapt an example from `sf` documentation](https://r-spatial.github.io/sf/reference/geos_unary.html).

Once I had the polygons, the rest was animation as usual, well not really, since `gganimate` new API by Thomas Lin Pedersen is different, and so powerful! I haven't watched [Thomas' useR! keynote talk about The Grammar of animation](https://www.youtube.com/watch?v=21ZWDrTukEs) yet, but I look forward to it since I both admire his packages, and his [blog writing](https://www.data-imaginist.com/). I only use very basic `gganimate` stuff here. A good intro to its grammar can be found at https://github.com/thomasp85/gganimate/tree/master#gganimate- . 

I was also glad to read that  `gifski` is now on CRAN for all your gif making needs (it's actually the default gif renderer of `gganimate`). This package by [Jeroen Ooms](https://github.com/jeroen) is not only a wrapper to the fastest gif renderer around which is cool enough in itself, but also the first CRAN package that interfaces a Rust library! Read more [about `gifski` in this tech note](https://ropensci.org/technotes/2018/07/23/gifski-release/).

Writing the actual animation code
==================================

The first part of the code consisted of drawing random points and using them as a basis for a Voronoi tesselation inside a box.


```r
# adapted from https://r-spatial.github.io/sf/reference/geos_unary.html
lims <- c(0, 10)
# sample 200 points inside an environment
# with a fix seed
with(set.seed(42),
     points <- sf::st_multipoint(matrix(runif(n = 400, lims[1],
                                              lims[2]),,2)))

# get a square box that'll be the area of our animation 
box <- sf::st_polygon(list(rbind(c(lims[1], lims[1]),
                             c(lims[2], lims[1]),
                             c(lims[2], lims[2]),
                             c(lims[1], lims[2]),
                             c(lims[1], lims[1]))))

# Get the Voronoi polygons of the points
v <- sf::st_sfc(sf::st_voronoi(points, sf::st_sfc(box)))
# Keep only the part of them inside the box
voronoi <- sf::st_intersection(sf::st_cast(v), box)

# Get a data.frame with the polygons
get_df_from_polygon <- function(polygon, index){
  mat <- as.matrix(polygon)
  tibble::tibble(x = mat[,1],
                 y = mat[,2],
                 tile = index)
}

df <- purrr::map2_df(voronoi, 1:length(voronoi),
                     get_df_from_polygon)
```

The animation will consist of two parts:

* The fragments appearing by drawing their borders with different shades from blue like the background to white.

* The fragments falling.

The code below creates the PNGs corresponding to the first part of the animation.

```r
fs::dir_create("august_frames")

plot_one <- function(step, df){
  cols <- colorRampPalette(c("#2165B6", "white"))(10)
  ggplot(df)  +
    geom_polygon(aes(x = x, y = y, group = tile),
                 fill = "#2165B6", col = cols[step]) +
    theme_void()

  outfil <- file.path("august_frames",
                      sprintf("plot1_%02d.png", step))
  ggsave(outfil, width = 6.7, height = 6.7)
  magick::image_read(outfil) %>%
    magick::image_resize("480x480") %>%
    magick::image_write(outfil)


}


purrr::walk(1:10, plot_one, df)
```

Then I made the `data.frame` a bit bigger by adding a second state with most tiles fallen at the bottom. I first create a variable `border` that indicates if the tile pertains to the sides or top because magically these tiles won't fall.

```r
df <- dplyr::group_by(df, tile) %>%
  dplyr::mutate(border = any(x %in% lims) |
                  any(y == lims[2]))

# Define the second state with tiles fallen
df2  <- df
# a bit random but it does look ok!

df2 <- dplyr::group_by(df2, tile) %>%
  dplyr::mutate(y = ifelse(!border,
                           -2 - min(y) + y,
                           y)) %>%
 dplyr::ungroup()

df$frame <- 1
df2$frame <- 2
dfall <- dplyr::bind_rows(df, df2)
```

This was followed by the animating of the second part with `gganimate`, here after creating a fake winner (sorry Steph, you won't get to gift yourself the book). Because we'll need to use PNGs from the first part, we don't use `gganimate`'s built-in gif or video renderers, but instead save PNGs.

Important note: `gganimate` latest version isn't on CRAN yet, follow the instructions in its [GitHub repository](https://github.com/thomasp85/gganimate) or download a built source version of the package [from Appveyor](https://ci.appveyor.com/project/thomasp85/gganimate/build/artifacts).

```r
winner <- list(name = c("Steph Locke"))
p <- ggplot(dfall) +
    annotate("text", label = winner$name,
             x = 5, y = 5,
             size = 12, family = "Roboto",
             col = "#E8830C") +
    geom_polygon(aes(x = x, y = y, group = tile),
                 fill = "#2165B6", col = "white") +
    # Here comes the gganimate code
    # create transition, with the variable frame
    transition_states(
      frame,
      transition_length = 1,
      state_length = 1,
      wrap = FALSE
    ) +
    # use an ease that makes tiles fall faster
    # at the end of the transition
    ease_aes('exponential-in') +
    theme_void() +
    coord_cartesian(xlim = lims, ylim = lims)

  # create and save frames

   animate(p,
   renderer = file_renderer(dir = "august_frames",
                            prefix = "plot2_") )

```

Now we can use all the PNGs that are in the "august_frames" folder, with `gifski`!


```r
images <- sort(as.character(
   fs::dir_ls("august_frames")))

gifski::gifski(images,
                gif_file = path,
                delay = 0.1,
                width = 480,
                height = 480)

# clean
 fs::dir_delete("august_frames")
```

And voilà, a glass shattering animation!

{{< figure src="../img/destruction.gif" title="Glass shattering book winner reveal">}} 

Conclusion and resources round-up
=================================

In this post I explained how I created an animation of glass shattering.

R packages that are important to know for producing animations are:

* `gganimate` that now implements the Grammar of animation, like `ggplot2` implements the Grammar of graphics! I'd recommend to watch [Thomas Lin Pedersen's useR! keynote talk about The Grammar of animation](https://www.youtube.com/watch?v=21ZWDrTukEs) and to follow the impressive activity of the [`gganimate` GitHub repo](https://github.com/thomasp85/gganimate).

* `gifski` for gif rendering. It's used under the hood by `gganimate` but you might need it to combine PNGs yourself if you tweak animations a bit more like we did here. You can read this [tech note about `gifski` by Jeroen Ooms](https://ropensci.org/technotes/2018/07/23/gifski-release/), and to check out the [r-rust Github organization](https://github.com/r-rust). 

* Likewise, if you want to tweak some frames, it'll be useful to know a bit about `magick`, wrapper to [ImageMagick](https://www.imagemagick.org/Magick++/STL.html), an R package for image manipulation developed at [rOpenSci](https://ropensci.org/) by [Jeroen Ooms](https://github.com/jeroen). This package has a [good vignette](https://cran.r-project.org/web/packages/magick/vignettes/intro.html).

Have fun animating R visualizations! And don't forget that next month, again a random Locke Data follower will win a great book: you should follow [Locke Data on Twitter](https://twitter.com/LockeData) to be in with a chance of winning!
