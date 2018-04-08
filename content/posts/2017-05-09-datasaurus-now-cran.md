---
title: datasauRus now on CRAN
author: Steph

date: 2017-05-09T10:02:18+00:00
spacious_page_layout:
  - default_layout
enclosure:
  - |
    |
        https://video.twimg.com/tweet_video/C-7-5qfWsAAAjx9.mp4
        50145
        video/mp4
        
categories:
  - R
tags:
  - cran
  - datasauRus
  - software development in r

---
datasauRus is a package storing the datasets from the paper [Same Stats, Different Graphs: Generating Datasets with Varied Appearance and Identical Statistics through Simulated Annealing][1]. It&#8217;s a useful package for:

  1. Having a dinosaur dataset 
  2. Showing a dinosaur related variant of [Anscombe&#8217;s Quartet][2]

You can now get datasauRus on [CRAN][3], though it might not be on all mirrors just yet.

    install.packages("datasauRus")
    

## Credit

This package wouldn&#8217;t exist without some nifty people:

  * [Alberto Cairo][4], datasaurus creator
  * [Justin Matejka and George Fitzmaurice][1], creator of the datasaurus&#8217; friends
  * Last but not least, [Lucy McGowan][5] who probably did more work on the package than I did

## Examples

We&#8217;ve already started playing with the datasauRus dataset&#8230;

### Me

    library(ggplot2)
    library(datasauRus)
    ggplot(datasaurus_dozen, aes(x=x, y=y, colour=dataset))+
      geom_point()+
      theme_void()+
      theme(legend.position = "none")+
      facet_wrap(~dataset, ncol=3)
    <figure style="width: 864px" class="wp-caption alignnone">

<img src="https://github.com/stephlocke/datasauRus/blob/master/README/README-unnamed-chunk-2-1.png?raw=true" width="864" height="1152" alt="datasauRus dozen!" class="size-large" /><figcaption class="wp-caption-text">datasauRus dozen!</figcaption></figure> 

### [Ramnath][6]

    library(ggplot2)
    library(datasauRus)
    library(gganimate)
    
    p <- ggplot(datasaurus_dozen, aes(x = x, y = y, frame = dataset)) +
      geom_point() +
      theme(legend.position = "none")
    
    gganimate(p, title_frame = FALSE)
    

<div style="width: 640px;" class="wp-video">
  <video class="wp-video-shortcode" id="video-62193-2" width="640" height="360" preload="metadata" controls="controls"><source type="video/mp4" src="https://video.twimg.com/tweet_video/C-7-5qfWsAAAjx9.mp4?_=2" /><a href="https://video.twimg.com/tweet_video/C-7-5qfWsAAAjx9.mp4">https://video.twimg.com/tweet_video/C-7-5qfWsAAAjx9.mp4</a></video>
</div>

### In the package

Every dataset has an example associated with it. These can be found not just in the help files for each dataset but also in a standalone directory ([`inst/examples`][7]). We&#8217;d like to keep building on these so please feel free to add any visualisations you make with the datasets. If you haven&#8217;t worked on a package before and want some help, you can [book some time with me][8] to get your dataviz example into the package.

 [1]: https://www.autodeskresearch.com/publications/samestats
 [2]: https://en.wikipedia.org/wiki/Anscombe%27s_quartet
 [3]: https://cran.r-project.org/package=datasauRus
 [4]: http://www.thefunctionalart.com/2016/08/download-datasaurus-never-trust-summary.html
 [5]: https://twitter.com/LucyStats
 [6]: https://twitter.com/ramnath_vaidya
 [7]: https://github.com/stephlocke/datasauRus/tree/master/inst/examples
 [8]: https://calendly.com/lockedata/pkgdev