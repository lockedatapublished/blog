---
title: SSH tunnels on Windows for R
author: Steph
type: post
date: 2016-03-14T13:41:06+00:00
categories:
  - DataOps
  - Misc Technology
  - R
tags:
  - linux from windows
  - pageant
  - plink
  - putty
  - ssh
  - ssh tunnel

---
Recently I&#8217;ve had to get to grips with SSH tunnels. SSH tunnels are really useful for maintaining remote network integrity and work in a secure fashion. It is, however, a pain to open PuTTY and log in all the time, mainly because I couldn&#8217;t script it in R! It&#8217;s been a trial, but like most things it turned out to be pretty simple in the end so I thought I&#8217;d share it with you.

## What&#8217;s required?

  * [PuTTY][1]
  * [winSCP][2] (optional tool, generally helpful)
  
    <!--more-->

## How To

### Generate key

I generated a key in Rstudio first using openSSH. I&#8217;d put this key on GitHub and a few other places so I didn&#8217;t want to change it. To use the PuTTY tools, you have to use a different key format than the one [openSSH][3] creates so I used pretty much this same method to convert my existing key.

You need to run puttygen.exe, generate a key with a passphrase, and store the public version of the key on the remote machine. DigitalOcean have a really good [article on generating keys and storing them][4] that I recommend you follow.

### Authenticate keys on startup

To avoid interactivity of any sort in my R scripts, I need some way of storing the passphrase for my key. I could generate a key without a password but that&#8217;s just a major security flaw I would prefer not to introduce. So, how can I get my keys to be pre-authenticated by me?

To tackle this persistence, it turns out our buddy PuTTY has a friend called `pageant.exe`. Pageant allows us to stash passphrases for our keys whilst pageant is running &#8211; but it will lose keys when you reboot.

Following [this article on setting pageant to run on startup][5] combined with [an article on startup programs on windows 8.1][6] I set pageant to load on startup and request my passphrase.

The most important things in these two articles were:

  * In the Run dialog type shell:startup and create a shortcut to your Pageant.exe
  * Edit your shortcut to start in your .ssh directory so you can have an easier time referencing multiple key files

### Use plink to build your SSH tunnel

Whilst down the rabbit hole, I discovered just in passing via a [beanstalk article][7] that there&#8217;s actually been a command line interface for [PuTTY][1] called `plink`. D&#8217;oh! This changed the whole direction of the solution to what I present throughout.

Using `plink.exe` as the command line interface for PuTTY we can then connect to our remote network using the key pre-authenticated via pageant. As a consequence, we can now use the `shell()` command in R to use plink. We can then connect to our database using the standard Postgres driver.

    library(RPostgreSQL)
    drv  <- dbDriver("PostgreSQL")
    
    cmd<- paste0(
      "plink ",
      # use key and run in background process
      " -i ../.ssh/id_rsa -N -batch  -ssh",
      # port forwarding
      " -L 5432:127.0.0.1:5432"
      # location of db
      " steph@mydb.com"
    )
    
    shell( cmd, wait=FALSE)
    
    conn <- dbConnect(
      drv,
      host = "127.0.0.1",
      port=5432,
      dbname="mydb"
    )
    
    dbListTables(conn)
    

## I went down the rabbit hole!

When picking up new (for you) technologies it can become an exercise in going down the rabbit hole &#8211; a reference to Alice in Wonderland where you&#8217;re trapped, confused, and running around looking for a way out.

Whilst going through this process I looked at the following:

  * [Win32-OpenSSH][8]
  * Windows Credential Manager
  * PowerShell modules [Posh-Git][9] & [CredentialManager][10]

These would be really cool to get working somehow. It would enable a Powershell script to run on startup that could securely retrieve my key passphrase out of the encrypted credentials database on Windows and pass them to `ssh-agent` so that I could work in an openSSH environment. It was, however, a PITA, with some bugs and limitations due to new process spawns, versions of Posh-Git and more. Plus, the more moving parts, the more unlikely something is to work.

## Followup

So this is a relatively simple method but not all that simple, and I still have to think about how I can make this sensibly work on different OS in order to be able to do the usual testing and continuous integration practices.

I know more about SSH than I ever wished to so if you&#8217;re struggling, give me a shout and I&#8217;ll do my best to help. If you&#8217;re much further along than me, why not comment on how you&#8217;ve solved this challenge &#8211; I&#8217;d love to hear better ways of doing this!

* * *

Image from [cat-o-morphism][11]

 [1]: http://www.chiark.greenend.org.uk/~sgtatham/putty/download.html
 [2]: https://winscp.net/eng/index.php
 [3]: http://www.openssh.com/
 [4]: https://www.digitalocean.com/community/tutorials/how-to-create-ssh-keys-with-putty-to-connect-to-a-vps
 [5]: http://blog.shvetsov.com/2010/03/making-pageant-automatically-load-keys.html
 [6]: http://www.howtogeek.com/208224/how-to-add-programs-files-and-folders-to-system-startup-in-windows-8.1/
 [7]: http://guides.beanstalkapp.com/version-control/git-on-windows.html
 [8]: https://github.com/PowerShell/Win32-OpenSSH
 [9]: https://www.powershellgallery.com/packages/posh-git/
 [10]: https://www.powershellgallery.com/packages/CredentialManager/1.0
 [11]: http://fav.me/d5iu6p0