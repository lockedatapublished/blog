---
title: "Blog_README"
author: "Ellen Talbot"
date: "28/06/2018"
output:
  pdf_document: default
  html_document: default
---

Workflow
========

First things first, in order to use this README you will have to already have the superbuild cloned onto your machine - go there for the instructions on how to do that!

`cd` Stands for change directory - add the file path to blog wherever you have it on your PC (e.g cd /documents/blog)

`git pull` Will Make sure you have the latest version, before you try and make changes

`git status` Will give you the current status of your copy of the files. This is good practise and will help you avoid issues later
--------------------------------------------------------------------------------------

Next up comes an additional step that you should be doing more often than not: You want to keep your master branch clean and create a branch for each new bug or feature. A branch is a copy of your master branch, the `master` branch is the default branch. Use other branches for development and merge them back to the master branch upon completion.

`git checkout -b <name of your new branch>` Creates the branch on your local machine and switches to working on it. (If you need to delete your branch, simply use `git branch -d <name of your branch>`)
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

**If you haven't used a branch for whatever reason then these are the steps you want to follow straight off the bat**.

*This is the bit where you do your actual work and make snazzy new things for the webiste. In this instance it's blogs. Here's a handy piece of code to transform .Rmd files into .md files that render on the website with no problems.*

``` r
rmarkdown::render(
  "path/to/file.Rmd",
  rmarkdown::md_document(variant = "markdown_github",
                         preserve_yaml = TRUE))
```

Then when you're done you can run the following:

`git add <file>` Looks back at your git status and checks what other files and folders also have changes made to them. Pick the ones you want to add to the next commit!

OR

`git add .` You can use the full stop to add all changes.

`git commit -m "add your comment here"` Add a comment to explain what you've been up to/what you're putting out into the big wide world.

`git push origin <name of your branch>` **If you haven't used a branch simply use `master` instead of your branch name and that's you done.**

The new branch *is not available* to others unless you push the branch to your remote repo.

`git push -u origin <name of your branch>` Pushes the branch to github.

Make sure you are in your branch when you want to commit something to it! The **`-u`** command sets the upstream.

`git checkout origin master` Take yourself back to your master branch when you are ready to incorporate your changes.

THEN

`git merge <name of your branch>`

Don't worry, your work isn't out there for all to see yet - and that's a good thing 'cos there's almost definitely a typo in there that snuck past you.

run `hugo server -w` in your terminal and copy and paste the local host address into your browser to see a local version of your changes. At this point, check grammar, spelling and the usual, but also pay attention to heading styles, images, and all other copy because **THIS IS HOW IT WILL ACTUALLY LOOK**. If you spot a problem, you can make edits to your work and see the changes in real time each time you save.

Now go to the superbuild README and follow the steps on there to make your changes live to the entire world free of typos!

Troubleshooting
===============

Credits:
--------

[Roger Dudler](http://rogerdudler.github.io/git-guide/)
