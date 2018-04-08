---
title: Unit testing in SSDT – a quick intro
author: Steph

date: 2016-10-10T08:00:08+00:00
spacious_page_layout:
  - default_layout
categories:
  - DataOps
  - Microsoft Data Platform
tags:
  - mssql
  - sql server
  - ssdt
  - unit testing

---
This post will give you a quick run-through of adding tSQLt to an existing database project destined for Azure SQL DB. This basically covers unit testing in SSDT and there is a lot of excellent info out there, so this focuses on getting you through the initial setup as quickly as possible. This post most especially relies on the information [Ed Elliot][1] and [Ken Ross][2] have published, so do check them out for more info on this topic!

<!--more-->

## Before we get started

### Prerequisites

  * You should be comfortable with [database projects][3] and working with them in Visual Studio. You could do this for your first ever database project, but the learning curve might be a bit steep!
  * You need Visual Studio
  * This can work with Visual Studio 2010 and beyond. AFAIK you can&#8217;t use VS Code with database projects.
  * I&#8217;m using Visual Studio 2015 Enterprise.
  * You need the latest [tSQLt scripts][4].
  * You should install the tool / extension [SSDT-DevPack][5] in Visual Studio.

### Sample

Whilst I won&#8217;t be showing code in this, there is a companion sample database project. This is on GitHub and each key stage is shown by a branch of work. This means you can jump in at most stages and work from there. If you need some git advice, check out my quick [git in 5 presentation][6].

The core DB is a super hero themed database.<figure id="attachment_61790" style="width: 750px" class="wp-caption aligncenter">

<img class="wp-image-61790 size-large" src="../img/sprocoverview_jivemk.png" alt="Database Stored Procedure overview" width="750" height="249" /><figcaption class="wp-caption-text">Database Stored Procedure overview</figcaption></figure> 

## Create a database project (or use an existing one!)<figure id="attachment_61792" style="width: 1014px" class="wp-caption aligncenter">

<img class="wp-image-61792 size-full" src="../img/Progress-Step1_lpizyy.png" alt="SSDT Unit Testing - core DB created" width="1014" height="379" /><figcaption class="wp-caption-text">SSDT Unit Testing &#8211; core DB created</figcaption></figure> 

This will be our database that we deploy to Azure SQL so we don&#8217;t want lots of tests gunking up our production system. We&#8217;re going to keep only the necessary code in here for our actual workloads. Plus, Azure SQL DBs (currently) can&#8217;t have CLR which tSQLt relies upon!

Use an existing project, or use this [sample repo, branch:stubs][7] if you&#8217;d like to play along with my example.

> Make sure your database project is under source control before you start. Not only should you already be doing it but it&#8217;ll save your bacon if you do something wrong during this! 

## Create a testing database project

We now need a project for holding our tSQLt code and our unit tests. The main method I could find is &#8220;deploy tSQLt to a database, then import into a database project&#8221;. For more info on this method, or to follow it, go to &#8220;Version controlling SSDT&#8221; in [Ken&#8217;s useful post][8].

I&#8217;m lazy so I take a copy of an existing minimally-configured tSQLt database project and copy & paste it into the solution&#8217;s directory. I then change the relevant folder / file names and edit the .proj file to use these new names. Once that&#8217;s done, the _Add Existing Project_ option can be used to bring it into the solution. Nab a copy from the [sample repo, branch:stubsandblanktestingdb][9] to have a go at this.

> C&Ping a database project has the disadvantage that the tSQLt code is fixed to a given version, but at the time of writing this post, the last release was 10 months old. 

## Configure test DB project<figure id="attachment_61787" style="width: 300px" class="wp-caption alignleft">

<img class="size-medium wp-image-61787" src="../img/Progress-Step2_ytyen7.png" alt="SSDT Unit Testing - test DB created" width="300" height="112" /><figcaption class="wp-caption-text">SSDT Unit Testing &#8211; test DB created</figcaption></figure> 

For this system to work the test DB will need to take our core DB as part of itself so that we can write tests against the core objects, but do the testing separately. There&#8217;s a neat mechanism in database projects. To do this we _add a database reference_ that puts the core DB as the _same database_.

We now need to get ready for doing some testing.

  * Create a Tests folder in the test DB project.
  * Then open one of your core DB stored procedures.
  * Navigate to Tools > SSDT Dev Pack > Create tSQLt class in the menu
  * Select your Tests folder in the popup directory browser

That yields us a Tests folder, and the unit test space for our first stored procedure. See this in action in the [sample repo, branch:stubsandconfiguredtestingdb][10].

Repeat the opening of stored procedures and creating classes whenever you need to add unit tests for a procedure.

> You will need to build your core DB if you haven&#8217;t already so that it&#8217;s dacpac is up to date and the test DB can get all the references. 

## Write some tests

Wow, after all that setup we can now actually do some testing! With the stored procedure from the previous step still open navigate to Tools > SSDT Dev Pack > Create tSQLt test in the menu.

This gives us a similar popup to the class window we saw. We need to create a test in the stored procedure class folder that tests for something specific.

Ed&#8217;s SSDT-DevPack gives us a good starting point for our tests but, obviously, it&#8217;s a generic placeholder. Consult the [tSQLt docs][11] for more on how to write unit tests.

See some unit tests in action in the [sample repo, branch:stubsandfirsttests][12].

> I usually unit test expected good inputs, edge cases in business logic, expected bad inputs, past bugs / issues 

## Run our tests<figure id="attachment_61788" style="width: 300px" class="wp-caption alignleft">

<img class="size-medium wp-image-61788" src="../img/Progress-Step3_behr1w.png" alt="SSDT Unit Testing - database unit tests run" width="300" height="112" /><figcaption class="wp-caption-text">SSDT Unit Testing &#8211; database unit tests run</figcaption></figure> 

To run our tests, we&#8217;re going to publish to [LocalDB][13]. By publishing to the LocalDB, the PostDeploy script gets kicked off and runs all the tests. The database publish will fail if any of the tests fail. Rinse and repeat until your code passes all your unit tests!

Use the deployment profile in [sample repo, branch:stubsanddeployprofile][14] to do a sample deployment into LocalDB.

> In my actual Azure SQL DB, I&#8217;ve got things like containerised users that aren&#8217;t compatible with LocalDB but thankfully, amending some of the deploy settings easily solves this. Ignore anything like users, credentials, and permissions in Publish &#8230; > Advanced &#8230; for the test DB deployment to LocalDB. 

## Publish for realsies<figure id="attachment_61789" style="width: 300px" class="wp-caption alignleft">

<img class="size-medium wp-image-61789" src="../img/Progress-Step4_bh79az.png" alt="SSDT Unit Testing - core DB deployed to production" width="300" height="112" /><figcaption class="wp-caption-text">SSDT Unit Testing &#8211; core DB deployed to production</figcaption></figure> 

Once you&#8217;ve gotten your code to pass your unit tests, you can then safely deploy your core DB to dev / UAT / production etc. You can also extend this to do continuous integration and deployment if you wanted, instead of manual deployments.

_C&#8217;est fini!_

## Extending things

This sample project used only takes you as far as writing unit tests for stub procedures &#8211; one&#8217;s that don&#8217;t actually do anything but return the inputs. This, of course, means they don&#8217;t serve any purpose. Check out the [master branch][15] as I develop it more and fold further features in it.

 [1]: https://agilesql.club/
 [2]: https://kzhendev.wordpress.com/
 [3]: https://visualstudiomagazine.com/articles/2014/12/01/visual-studio-database-projects.aspx
 [4]: http://tsqlt.org/downloads/
 [5]: https://visualstudiogallery.msdn.microsoft.com/435e7238-0e64-4667-8980-5b8a05dc7906
 [6]: http://stephlocke.info/Rtraining/gitin5.html
 [7]: https://github.com/stephlocke/SSDTUnitTestingSampleRepo/tree/stubs
 [8]: https://kzhendev.wordpress.com/2014/01/08/setting-up-ssdt-database-projects-and-tsqlt/
 [9]: https://github.com/stephlocke/SSDTUnitTestingSampleRepo/tree/stubsandblanktestingdb
 [10]: https://github.com/stephlocke/SSDTUnitTestingSampleRepo/tree/stubsandconfiguredtestingdb
 [11]: http://tsqlt.org/user-guide/
 [12]: https://github.com/stephlocke/SSDTUnitTestingSampleRepo/tree/stubsandfirsttests
 [13]: http://blog.chudinov.net/using-localdb-in-development/
 [14]: https://github.com/stephlocke/SSDTUnitTestingSampleRepo/tree/stubsanddeployprofile
 [15]: https://github.com/stephlocke/SSDTUnitTestingSampleRepo/tree/master