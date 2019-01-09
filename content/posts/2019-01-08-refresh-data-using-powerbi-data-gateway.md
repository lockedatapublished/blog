---
title: 'Refresh Data using PowerBI Data Gateway '
author: "pedh"
date: '2019-01-08'
draft: yes
slug: refresh-data-using-powerbi-data-gateway
tags:
- blog
- R
- tip
categories:
- Power BI
- Microsoft R Open
---
When using R script as data soure in a PowerBI report, refreshing that data source is possible via PowerBI Data Gateway (Personal Mode). Lets get started!

Download / Install Data Gateway (Personal Mode)
------
Following the instruction below, you will always get the latest updates of Data Gateway. 

1. Sign in your PowerBI.com workspace and navigate to top right menu bar, choose the second icon from the left to download "Data Gateway".

2. This will download the .msi installer. 

<br><br>
![](https://raw.githubusercontent.com/nujcharee/powerbi-blog/master/src/pages/RScript/dl_gateway.png)
<br><br>

Install Data Gateway (Personal Mode)
------
This step takes a couple of minutes to complete.

3. Double click on the icon to complete the installation. Note that you will be prompted to choose either standard gateway or personal mode, make sure that ** Personal Mode ** is selected.
<br><br>
![](https://docs.microsoft.com/en-us/power-bi/media/service-gateway-personal-mode/gateway-personal-mode_00.png)
<br><br>
Configure Data Gateway
-----------

4. Navigate to your PowerBI workspace, and choose your dataset to refresh. In this example, my dataset is called "carsv1"
<br><br>
![](https://raw.githubusercontent.com/nujcharee/powerbi-blog/master/src/pages/RScript/found_dataset.png)
<br><br>
5. Click on "Refresh Now"" icon (second from left)
6. You will be navigated to "Settings" page, expand "Gateway Connection" section and select "Personal Gateway" to enable your data gateway installed from the previous steps.
<br><br>
![](https://raw.githubusercontent.com/nujcharee/powerbi-blog/master/src/pages/RScript/personal_gateway_status.png)

Credentials
-----------

7. Edit credential(s) for all data source(s). You will notice R as a data source in the list. Click "Sign In" when prompted with the screen below.
<br><br>
![](https://raw.githubusercontent.com/nujcharee/powerbi-blog/master/src/pages/RScript/configure.png)
<br><br>

Schedule Refresh
-----------
8. Set up schedule for refresh by expanding "Schedule Refresh" section, and add time slot(s).
<br><br>
![](https://raw.githubusercontent.com/nujcharee/powerbi-blog/master/src/pages/RScript/Schedule_refresh.png)
<br><br>


**A couple of notes**
<br>
As of writing, there is a bug with the latest version of the Gateway making R refreshes problematic and there is an older version stored in Dropbox. This is unlikely to be needed beyond January 2019. The latest version of the Gateway can be downloaded from the Power BI site at https://powerbi.microsoft.com/en-us/gateway/

Schedule Refresh requires your machine to be on at the time of refreshes for Power BI to talk to your machine and update the data. 

