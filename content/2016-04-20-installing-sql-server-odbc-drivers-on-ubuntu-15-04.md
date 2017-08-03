---
title: Installing SQL Server ODBC drivers on Ubuntu 15.04
author: Steph
type: post
date: 2016-04-20T14:13:28+00:00
categories:
  - DataOps
  - Microsoft Data Platform
tags:
  - azure
  - mssql
  - odbc
  - sql server

---
**UPDATE 2016-10-21 : You can now get the ODBC 13 driver for Linux with a much smoother install process than below. Get all the relevant information on [the announcement from the Microsoft SQLNCli team blog][1].**

Did you know you can now get [SQL Server ODBC drivers for Ubuntu][2]? Yes, no, maybe? It&#8217;s ok even if you haven&#8217;t since it&#8217;s pretty new! Anyway, this presents me with an ideal opportunity to standardise my SQL Server ODBC connections across the operating systems I use R on i.e. Windows and Ubuntu. My first trial was to get it working on [Travis-CI][3] since that&#8217;s where all my training magic happens and if it can&#8217;t work on a clean build like Travis, then where can it work? Alas, the ODBC 13 driver doesn&#8217;t work Ubuntu 14.04 so this set of instructions has been modified to provide code for Ubuntu 15.04 only.

## TL;DR

It works, but it&#8217;s really hacky right now. Definitely looking forward to the next iterations of this driver.

## Disclaimer

  * This will work for Ubuntu 15.04 but 14.04 has a different set of C compilers
  * This is currently hacky, and Microsoft are on the case for improving it so this post could quickly become out of date.
  * Be very careful installing the driver on an existing machine. Due to the overwriting of unixODBC if already installed and potential compatibility issues with other driver managers you may have installed.

<!--more-->

## Line by line

    wget https://download.microsoft.com/download/2/E/5/2E58F097-805C-4AB8-9FC6-71288AB4409D/msodbcsql-13.0.0.0.tar.gz -P ..
    

Download the compressed file containing all the relevant stuff. This URL is important &#8211; the website does not provide a URL like this and this one is likely to be unstable. Microsoft are aware of this as a problem for users who like to script everything and will hopefully be addressing it in the short to medium term.

The `-P ..` tells the `wget` command to dump the file in the parent directory so that it won&#8217;t set off warnings when I build my R package.

    tar xvzf ../msodbcsql-13.0.0.0.tar.gz -C ..
    

This little line unzips the file we just downloaded to the parent directory.

    sed -i '14d' ../msodbcsql-13.0.0.0/build_dm.sh
    sed -i '/tmp=/c\tmp=/tmp/odbcbuilds' ../msodbcsql-13.0.0.0/build_dm.sh
    

Unfortunately the default script that should be executed next generates a random directory for the unixODBC driver manager. The random directory is present in the output text and not easy to pipe into the next command. Consequently, with much help from [Vin from MSFT][4] we have this current hack to change the directory to a fixed directory.

    ../msodbcsql-13.0.0.0/build_dm.sh --accept-warning
    

This line runs a shell script that **builds** the unixODBC driver manager. Note &#8211; you can&#8217;t rely on the unixODBC driver available via apt-get at this time due to the SQL Server ODBC driver not being compatible (currently) with the latest versions. Also, it wasn&#8217;t noted in the manual but I had to add the `--accept-warning` to suppress some sort of notification that wanted to be triggered. I suspect I just sold my soul and that I&#8217;m encouraging you to do the same.

    cd /tmp/odbcbuilds/unixODBC-2.3.1
    sudo make install
    

These lines shunts us over to the directory for the unixODBC build and installs it. The `sudo` is necessary for the installation to the `usr/` directory.

    cd ~
    

This gets you back to the your starting package directory for continuing on to package install.

    sudo apt-get install libgss3 -y
    

This dependency was needed by the ODBC driver

    ../msodbcsql-13.0.0.0/install.sh verify
    

Verify the driver can be installed. This line wasn&#8217;t so great since it doesn&#8217;t check for a bug/feature &#8211; that you&#8217;re in the right directory &#8211; otherwise, a series of file copies in the install process won&#8217;t work.

    cd ../msodbcsql-13.0.0.0/
    sudo ./install.sh install --accept-license
    

Proceed to install the driver in the right directory

    odbcinst -q -d -n "ODBC Driver 13 for SQL Server"
    

Test the driver is usable

## The final file

    wget https://download.microsoft.com/download/2/E/5/2E58F097-805C-4AB8-9FC6-71288AB4409D/msodbcsql-13.0.0.0.tar.gz -P ..
    tar xvzf ../msodbcsql-13.0.0.0.tar.gz -C ..
    sed -i '14d' ../msodbcsql-13.0.0.0/build_dm.sh
    sed -i '/tmp=/ctmp=/tmp/odbcbuilds' ../msodbcsql-13.0.0.0/build_dm.sh
    ../msodbcsql-13.0.0.0/build_dm.sh --accept-warning
    cd /tmp/odbcbuilds/unixODBC-2.3.1
    sudo make install
    cd ~
    sudo apt-get install libgss3 -y
    ../msodbcsql-13.0.0.0/install.sh verify
    cd ../msodbcsql-13.0.0.0/
    sudo ./install.sh install --accept-license
    odbcinst -q -d -n "ODBC Driver 13 for SQL Server"
    

## The manuals (for reading)

  * [Microsoft ODBC Driver for SQL Server on Linux][5]
  * [Installing the Driver Manager][6]
  * [Installing the Microsoft ODBC Driver for SQL Server on Linux][7]

 [1]: https://blogs.msdn.microsoft.com/sqlnativeclient/2016/10/20/odbc-driver-13-0-for-linux-released/
 [2]: https://www.microsoft.com/en-gb/server-cloud/sql-server-on-linux.aspx
 [3]: https://travis-ci.org
 [4]: https://www.linkedin.com/in/vinson-yu-91475339
 [5]: https://msdn.microsoft.com/en-us/library/hh568451(v=sql.110).aspx
 [6]: https://msdn.microsoft.com/en-us/library/hh568449(v=sql.110).aspx
 [7]: https://msdn.microsoft.com/en-us/library/hh568454(v=sql.110).aspx