---
title: namer, Automatic Labelling of R Markdown Chunks
author: maelle
type: post
date: 2018-10-31
spacious_page_layout:
  - default_layout
categories:
  - Data Science
  - R
tags:
  - r
  - rmarkdown
  - best-practice

---

We've just [released a sweet package](https://cran.r-project.org/web/packages/namer/index.html) to save you stress from the hassle of unnamed chunks in R Markdown! `namer` will name all your chunks, so you can quickly debug in future. More details in this post!

# Why name your R Markdown chunks?

When writing R Markdown documents, be it a single report or a whole book based on dozens of documents, it's crucial to name your R Markdown chunks. Informative names can help when navigating your files and will be used as informative filenames for figures generated in chunks. But even when not informative, chunk labels are very important! Imagine you're compiling a whole book, and oops, a bug appears in... unnamed-chunk-566. How do you find the culprit?! That name you get in the error message is _not_ written in any file! 

{{< figure src="../img/namer-oh-no.png" title="Sad chibi Stef being told by R that there is an error in unnamed-chunk-12">}} 

Or, since caches are named after chunks, if you delete one chunk in a document full of unnamed chunks, all your caches become useless. The horror!

One good piece of advice would be to always name your chunks. That's what we say when teaching R Markdown, and what's promoted [in this blog post of mine featuring puppy photographs](https://masalmon.eu/2017/08/08/chunkpets/)! But, sadly, we don't always follow best practice, do we? 

# What does `namer` do?

Luckily, thanks to a brilliant idea of Steph's, `namer` is now here to save your (vegan) bacon! This nifty package will name your chunks for you when you've (willingly or unwillingly) forgotten to do so! For any R Markdown document, `namer` creates and saves chunk labels based on the filename stripped from its extension. Therefore, all chunks of "my-fantastic-report.Rmd" get named "my-fantastic-report-1", "my-fantastic-report-2". Voilà!

{{< figure src="../img/namer-yaaasss.png" title="Happy chibi Stef being told by R that there is an error in the chunk labelled test-12">}}

In practice, `namer` provides this service for a single document, or a whole folder at once, and an RStudio add-in for naming the chunks of the current active document.

The screenshot below is [a real-life example](https://github.com/lockedata/pres-datascience/pull/1)  result of running namer::name_dir_chunks("pres"). In each of the files in the dir "pres", it labelled chunks using the filename and numbers.

{{< figure src="../img/namer1.png" title="Difference between two R Markdown reports before and after using namer to label chunks">}} 

# How to use `namer`?

First, install `namer` from CRAN.

```r
install.packages("namer")
```

Then, say you want to name the chunks of a report saved under "reports/my-report.md", type

```r
namer::name_chunks("reports/my-report.md")
```

Here comes a warning from us... When using `namer`, please check the edits before pushing them to your code base. Such automatic chunk labelling is best paired with [version control](http://happygitwithr.com/)!

If you want to label the chunks of all the R Markdown documents of your "reports" folder, use `namer::name_dir_chunks()`:

```r
namer::name_dir_chunks("reports")
```

Now, as life is sometimes a bit more complicated, you might sometimes need to _unname_ all chunks of a report before re-naming it, if you e.g. used `namer` once, then added many chunks, or if you don't like the naming scheme you had been using. We have a function for that too! It will unname all chunks except the setup chunk!

```r
namer::unname_all_chunks("reports/my-report.md")
```

Last but not least, we have a minimal RStudio addin shipped with the package, to name chunks of any R Markdown file. It allows you to select that file thanks to [our very first Hacktoberfest contributor](https://github.com/lockedata/namer/pull/14), [Ellis Valentiner](https://github.com/ellisvalentiner)! Read more about Hacktoberfest at Locke Data [here](https://itsalocke.com/blog/up-your-open-source-game-with-hacktoberfest-at-locke-data/).

# Future plans for even more nifty automatic naming

Like [all our packages](https://itsalocke.com/oss/packages/), `namer` is [developed in the open on GitHub](https://github.com/lockedata/namer) so you can go read what we're planning for the future. In particular, we're aiming to extend the RStudio addin to make it possible to select any file or folder, not just the active document. 

Furthermore, if you're keen to get involved in open-source development, we'd be glad to mentor you, [check out the issues that'd welcome external help](https://github.com/lockedata/namer/issues?q=is%3Aissue+is%3Aopen+label%3A%22help+wanted+%3Araised_hand%3A%22)! As a side-note, if you're into programmatic change or assessment of chunk options, you might be interested in [the `tinkr` package](https://github.com/ropenscilabs/tinkr), that provides a function to transform R Markdown files into XML documents, and another one to save them back as R Markdown. 

In the meantime, go write awesome R Markdown documents, now that the fear of the unnamed chunks no longer dawns on you!
