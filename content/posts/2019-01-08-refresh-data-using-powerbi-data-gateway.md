---
title: 'Refresh Data using PowerBI Data Gateway '
author: "ped"
date: '2019-01-08'
output:
  word_document: default
  pdf_document: default
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
While there are many ways to connect PowerBI to your data sources, from flat files such as csv, text, excels to popular databases such as SQL server or Oracle, in certain scenario, some data sources aren't support by PowerBI, a use case below demonstrates the benefit of leveraging R to connect to data from an unsupported data source.

A use case: ![Connect to Google Sheets in PowerBI using R](https://itsalocke.com/blog/connect-to-google-sheets-in-power-bi-using-r/)

When using R script as data soure in a PowerBI report, refreshing that data source is possible via PowerBI Data Gateway (Personal Mode). Before we get started, you may wonder, is installing "Data Gateway" necessary?

Simple answer is, not in all cases. Generally, Data Gateway is used to refresh reports which have data sources located on-premises. Using R to connect and/or transform data requires libraries installed locally on the machine, therefore "Data Gateway" is necessary to automate schedule refresh.

Without Data Gateway, your published report / dashboard will be static. The only workaround is to "Refresh" your data locally using PowerBI desktop. This isn't ideal and could be time consuming. 


<br>
Step 1 - Download / Install Data Gateway (Personal Mode)
------
Following the instruction below, you will always get the latest updates of Data Gateway. 

1. Sign in your PowerBI.com workspace and navigate to top right menu bar, choose the second icon from the left to download "Data Gateway".

2. This will download the .msi installer. 

<br><br>
![](https://raw.githubusercontent.com/nujcharee/powerbi-blog/master/src/pages/RScript/dl_gateway.png)
<br><br>

Step 2 - Install Data Gateway (Personal Mode)
------
This step takes a couple of minutes to complete.

3. Double click on the icon to complete the installation. Note that you will be prompted to choose either standard gateway or personal mode, make sure that ** Personal Mode ** is selected.
<br><br>
![](https://docs.microsoft.com/en-us/power-bi/media/service-gateway-personal-mode/gateway-personal-mode_00.png)
<br><br>
Step 3 - Configure Data Gateway
-----------

4. Navigate to your PowerBI workspace, and choose your dataset to refresh. In this example, my dataset is called "carsv1"
<br><br>
![](https://raw.githubusercontent.com/nujcharee/powerbi-blog/master/src/pages/RScript/found_dataset.png)
<br><br>
5. Click on "Refresh Now"" icon (second from left)
6. You will be navigated to "Settings" page, expand "Gateway Connection" section and select "Personal Gateway" to enable your data gateway installed from the previous steps.
<br><br>
![](https://raw.githubusercontent.com/nujcharee/powerbi-blog/master/src/pages/RScript/personal_gateway_status.png)

Step 4 - Credentials
-----------

7. Edit credential(s) for all data source(s). You will notice R as a data source in the list. Click "Sign In" when prompted with the screen below.
<br><br>
![](https://raw.githubusercontent.com/nujcharee/powerbi-blog/master/src/pages/RScript/configure.png)
<br><br>

Step 5 - Schedule Refresh
-----------
8. Set up schedule for refresh by expanding "Schedule Refresh" section, and add time slot(s).
<br><br>
![](https://raw.githubusercontent.com/nujcharee/powerbi-blog/master/src/pages/RScript/Schedule_refresh.png)
<br><br>


**A couple of notes**
<br>
As of writing, there is a bug with the latest version of the Gateway making R refreshes problematic and there is an older version stored in Dropbox. This is unlikely to be needed beyond January 2019. The latest version of the Gateway can be downloaded from the Power BI site at https://powerbi.microsoft.com/en-us/gateway/

Schedule Refresh requires your machine to be on at the time of refreshes for Power BI to talk to your machine and update the data. 

It has been reported that some users have had a difficulty configuring credentials, there is a workaround following below step.

1. Open the On-premises Data Gateway (personal mode) desktop on the machine where the gateway is installed.
2. Go to the connectors tab and turn off the "Custom data connectors" 
![](https://raw.githubusercontent.com/nujcharee/powerbi-blog/master/src/pages/RScript/custom_connector.png)



