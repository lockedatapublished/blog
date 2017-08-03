---
title: Building an R training environment
author: Steph
type: post
date: 2017-04-24T08:17:13+00:00
spacious_page_layout:
  - default_layout
categories:
  - DataOps
  - Misc Technology
  - R
tags:
  - bash
  - docker
  - magick
  - rocker
  - rstudio
  - training

---
I recently delivered a day of training at [SQLBits][1] and I really upped my game in terms of infrastructure for it. The resultant solution was super smooth and mitigated all the install issues and preparation for attendees. This meant we got to spend the whole day doing R, instead of troubleshooting.

I&#8217;m so happy with the solution for an online R training environment that I want to share the solution, so you can take it and use it for when you need to do training.

## TL;DR<figure id="attachment_62106" style="width: 750px" class="wp-caption aligncenter">

<img src="http://res.cloudinary.com/lockedata/image/upload/h_500,w_750/v1499849764/Workflow_cat6ai.jpg" alt="Workflow for constructing a training environment with RStudio" width="750" height="500" class="size-large wp-image-62106" /><figcaption class="wp-caption-text">Workflow for constructing a training environment with RStudio</figcaption></figure> 

To get a web-facing Rstudio server, with login details for users, and all the prerequisites installed:

  1. Generate usernames and passwords
  2. Build a Docker image based on rocker that contains your users and any prerequisites
  3. Run docker image on VM with a port binding to make the Rstudio accessible externally

## Where the `magick` happens

The first thing I wanted was user names and passwords for people. I wanted these preprepared and, ideally, on something with my contact info. I&#8217;d used [moo][2] before so I knew I could do up to 100 custom cards &#8211; I just needed to make them. I used the package [`random`][3] and the package [`magick`][4] to generate credentials and write them on to PDFs that could then be uploaded to moo.

You can read the whole [gist][5] but the key code includes:

  * A random password generation step

    write.csv(data.frame(usernames=paste0("u",stringr::str_pad(1:n,pad = "0",width = 3))
                         ,pwords=random::randomStrings(n,len = 6,digits = FALSE,loweralpha = FALSE))
              ,"users100.csv",row.names = FALSE)
    

  * A read of my blank card back

<pre><code class="r">myimage &lt;- magick::image_read(myfile,density = 500)
</code></pre>

  * In a loop (there&#8217;s probably a better way!) 
      * Writing out the text to the card back
      * Save a new card back

    myimage2 <- magick::image_annotate(  myimage, "lockedata.biz", font = "Roboto", size = 90, location = "+350+75" )
    magick::image_write(myimage2, paste0("GeneratedBacks/",basename, up[i,"usernames"], ".", baseext))
    

## Making users

The next, and much more tricksy, bit was writing a script that would correctly create users. [Peter Shaw][6] helped me out initially and the code looks like:

    for userdetails in `cat users.csv`
    do
            user=`echo $userdetails | cut -f 1 -d ,`
        passwd=`echo $userdetails | cut -f 2 -d ,`
            useradd $user -m -p `mkpasswd $passwd`
    done
    

This goes through each line in the CSV and adds a user with a specified password. We use the `mkpasswd` utility here to encrypt the password. `mkpasswd` is part of the `whois` program and we&#8217;ll need that tidbit later.

This needs to be done not only to give people login info but a home directory to save their stuff into. If they don&#8217;t have home directories then Rstudio throws a tantrum with them.

## rocker

The next bit was getting some sort of server with Rstudio installed. [Dirk Eddelbuettel][7] made a bunch of Docker containers available under the [`rocker`][8] brand. One of these has [Rstudio server][9] and the [`tidyverse`]() installed. Using this preconfigured container would mean I&#8217;d only have to add my finishing touches to it to get everything I needed.

## Dockerfile

The last but one step was building my own customised Docker container that used rocker as a base, created all my users, and installed anything extra I wanted on top of the tidyverse.

    FROM rocker/tidyverse
    MAINTAINER Steph Locke <steph@itsalocke.com>
    RUN apt-get install libudunits2-0 libudunits2-dev whois
    RUN  R -e 'devtools::install_github("lockedata/TextAnalysis")' 
    RUN  R -e 'devtools::install_github("dgrtwo/widyr")' 
    ADD https://gist.githubusercontent.com/stephlocke/0036331e7a3338e965149833e92c1360/raw/607fb01602e143671c83216a4c5f1ad2deb10bf6/mkusers.sh /
    ADD https://gist.githubusercontent.com/stephlocke/0036331e7a3338e965149833e92c1360/raw/6d967c19d9c73cecd1e2d4da0eed2cd646790bd5/users.csv /
    RUN chmod 777 /mkusers.sh
    RUN /mkusers.sh
    

This starts with the tidyverse & Rstudio then:

  * adds the requisite programs for dependencies in my package and `whois` for `mkpasswd` to be able to work
  * installs packages from github, notably the one designed to facilitate the day of text analysis
  * get the shell script and the csv from the gist
  * make the shell script executable and then run it

## C&#8217;est fini!

The final step was to actually this container on a Digital Ocean virtual machine (but it could be run anywhere) like so:

<pre><code class="bash">docker pull stephlocke/montypythonwkrshopdocker 
docker run -d -p 80:8787 stephlocke/montypythonwkrshopdocker
</code></pre>

You can take my [github repo][10] with the Dockerfile and customise it to suit your own requirements, build it in Docker and then use it whenever you need an R training environment that can be customised to your needs and is accessible from a web browser.

You can use it for general working environments but make sure to read my [data persistence in Docker][11] post first as the `run` command does not have an external volume mapped and if your host for docker crashes, everything will be lost permanently. An extra incentive to use source control maybe!

 [1]: http://sqlbits.com
 [2]: https://www.moo.com/
 [3]: https://cran.r-project.org/package=random
 [4]: https://cran.r-project.org/package=magick
 [5]: https://gist.github.com/stephlocke/32185d02371f29a9ae897aadd28fc1f9
 [6]: https://twitter.com/shawty_ds
 [7]: https://github.com/eddelbuettel
 [8]: https://github.com/rocker-org/
 [9]: https://www.rstudio.com/products/rstudio/download-server/
 [10]: https://github.com/stephlocke/montypythonwkrshopdocker
 [11]: https://itsalocke.com/talking-data-and-docker/