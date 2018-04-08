---
title: All my talks in one place (plus a Hugo walkthrough!)
author: steph

date: 2017-06-17T09:29:42+00:00
spacious_page_layout:
  - default_layout
categories:
  - DataOps
  - Microsoft Data Platform
  - R
tags:
  - Community
  - hugo
  - presentations
  - r

---
I mentioned in an earlier post about how I&#8217;m [revamping my presentation slides process][1] but that I hadn&#8217;t tackled the user experience of browsing my slides, which wasted lots of the effort I put in. To tackle this part of it, I&#8217;ve made [lockedata.uk][2] using Hugo to be a way of finding and browsing presentations on R, SQL, and more. As Hugo is so easy, I thought I&#8217;d throw in a quick Hugo walkthrough too so that you could build your own blog/slides/company site if you wanted to.

The great thing about using Hugo with a sort of blog taxonomy system is now all my presentations have categories and tags so you can find something relevant. Additionally, I&#8217;m also ordering slides by the date of the last presentation. This means if you see me present, you can straight away get the slides &#8211; they&#8217;ll be the first thing on the page.

A number of the talks will also include the videos (embedded with [Hugo shortcodes][3] for the most part) from when I&#8217;ve presented the talk as that&#8217;s the most robust way of getting value out of the slides.

<figure id="attachment_62246" style="width: 750px" class="wp-caption aligncenter">[<img src="../img/lockedatapreview_oz7rvc.png" alt="lockedata.uk - presentation website built with Hugo. Read the post to get a hugo walkthrough." width="750" height="371" class="size-large wp-image-62246" />][2]<figcaption class="wp-caption-text">lockedata.uk &#8211; presentation website built with Hugo. Read the post to get a hugo walkthrough.</figcaption></figure>
  
If you&#8217;re interested in the tech behind the site read on&#8230;

## Hugo walkthrough

This site uses [Hugo][4]. Hugo is a &#8220;static site generator&#8221; which means you write a bunch of markdown and it generates html. This is great for building simple sites like company leafletware or blogs.

You can get Hugo across platforms and on Windows it&#8217;s just an executable you can put in your program files. You can then work with it like git in the command line. More details on actually installing Hugo can be found in their [very good install docs][5].

You will want to read some of the [docs][6] to make customisations but the &#8220;happy path&#8221; Hugo walkthrough to get started is:

  1. Make a new site you simply run `hugo new site NAME`
  2. Let&#8217;s do some git, run `git init` inside the new site&#8217;s directory to get your git repo going
  3. Make a repo on GitHub that we&#8217;ll want to push to later on
  4. Find a [theme][7] to suit your needs and go to its github page
  5. Change to the themes directory then clone the theme into the themes directory
  6. Back on the top-level of your site, extract your themes example content with something like `cp -av themes/academic/exampleSite/* .`
  7. Get your site running locally with real-time changes by running `hugo server -w`
  8. Start editing the sample content to meet your needs and using the site (available at `localhost:1313`) to see how it&#8217;s going
  9. When you&#8217;re happy, stop the local server (in Windows, this is ctrl+c) 
 10. Make sure in the `config.toml` file, the site URL reflects where it&#8217;ll go on Github i.e. `http://yourusername.gihub.io/yourreponame/`
 11. Generate your site to the `docs` directory with `hugo -d docs`
 12. Commit everything and push to your GitHub repo
 13. In the Settings page for the Github repo, set the `Github Pages > Source` option to &#8220;master branch /docs folder&#8221;

Now your site will be available `yourusername.gihub.io/yourreponame`

PS If you want to do a lot of R in your blog, you can utilise [blogdown][8] which is an rmarkdown Hugo hybrid.

 [1]: https://itsalocke.com/improving-automatic-document-production-with-r/
 [2]: http://lockedata.uk
 [3]: http://gohugo.io/extras/shortcodes/
 [4]: https://gohugo.io
 [5]: http://gohugo.io/overview/installing/
 [6]: https://gohugo.io/overview/introduction/
 [7]: https://themes.gohugo.io
 [8]: https://github.com/rstudio/blogdown