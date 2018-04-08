---
title: R for database and Excel people
author: Steph

date: 2013-09-15T18:00:27+00:00
categories:
  - Microsoft Data Platform
  - Misc Technology
  - R
tags:
  - analysis
  - mssql
  - r
  - sql server

---
### What is R?

R is a statistical language for doing all sorts of analytics based on many different types of data and it&#8217;s also an open source platform that allows people to extend the base functionality.  <a href="http://www.r-project.org/about.html" target="_blank">More details</a> are available from the horse&#8217;s mouth.

### How can I give it a go?

Download <a href="http://cran.rstudio.com/" target="_blank">R</a> and <a href="http://www.rstudio.com/ide/download/desktop" target="_blank">RStudio</a> an awesome development environment for R.  There is also an excellent online <a href="http://tryr.codeschool.com/" target="_blank">R learning site</a>.  I do not recommend sticking with just R &#8211; we&#8217;re used to a lot more convenience and good development bits and bobs like IntelliSense and Rstudio really delivers.

<!--more-->

### Why should I care about it?

If you do reporting or analysis of any form, R can be \*very\* useful in addition to SQL, Excel, SSRS etc.

If you&#8217;re a pure DBA with very little analytical responsibilities, you may still be interested in it because you can encourage others to utilise it for activities where SQL is not suitable for, thus reducing the database problems.

For developers, it can give you the ability to produce interactive graphics and visualisations on the interweb using <a href="http://www.rstudio.com/shiny/" target="_blank">Shiny</a> or directly embedding in <a href="https://www.simple-talk.com/dotnet/asp.net/creating-a-business-intelligence-dashboard-with-r-and-asp.net-mvc-part-1/" target="_blank">ASP</a>.

### Why &#8216;R for database and Excel people&#8217;?

R was designed and built by academic statisticians who have been using S (the commercial R predecessor), MATLAB, SAS and other odd programs with an insular user group who speak a really weird language full of jackknifes and lassos.  You as someone who more likely comes from a technical/computing/general analytics background are unlikely to understand this easily without a google translate button.  This means the design choices, the language, and the help pages can be almost wholly impenetrable and would provide a constant source of frustration!  After six months grappling with R entirely on my own with just the internet for succour and help, I&#8217;d like to pass on my translations of hard won knowledge to you, the reader.

I&#8217;ll cover topics in the order of relevance to someone with SQL and Excel knowledge would likely look to tackle them.  This means I won&#8217;t cover necessarily cover R topics in the way a stats person might approach them because the challenges we&#8217;ll face tend to be different from a statistician.  I also intend to bypass &#8216;base&#8217; methods for solving typical challenges and skip straight to the way I&#8217;ve found most intuitive after experimenting with different packages.

### What will be covered?

  * Setting up an R server
  * Connecting to SQL Server
  * Effective data storage and the data.table package
  * Pivoting data
  * Aggregations
  * Dealing with time
  * Producing charts
  * Outputting to files
  * Producing reports
  * Building your own packages
  * Source control
  * Unit testing
  * Best practices

### When will these be covered?

I plan on writing and outputting these once a week for your edification.

&nbsp;