---
title: Stumbling into … Azure Automation
author: Steph
type: post
date: 2016-07-11T09:46:12+00:00
categories:
  - DataOps
  - Microsoft Data Platform
tags:
  - aws
  - azure
  - azure automation
  - etl
  - failures
  - powershell

---
I&#8217;ve recently been trying to solve the challenge of working extracting files from AWS and getting them into Azure in my desired format. I wanted a solution that kept everything on the cloud and completely avoid local tin. I wanted it to have built-in auditing and error handling. I wanted something whizzy and new, to be honest! One way in which I attempted to tackle the task was with [Azure Automation][1]. In this post, I&#8217;ll overview Automation and explore how it stacked up for what I was attempting to use it for.

> Overall Task: Get compressed (.tar.gz) files from AWS S3 to Azure, decompress the files, concatenate the contents and put in a different container for analytics magic 

Like with most things I dropped myself into the deep-end on it so had fairly minimal knowledge of PowerShell and the Azure modules, therefore I fully expect more knowledgeable folks to wince at my stuff. General advice, &#8220;you should do it like this, then this&#8230;&#8221;&#8216;s, and resource recommendations are all very welcome &#8211; leave a comment with them in!

## Azure Automation

Azure Automation is essentially a hosted PowerShell script execution service. It seems to be aimed primarily at managing Azure resources, particularly via [Desired State Configurations][2].

It is, however, a general PowerShell powerhouse, with scheduling capabilities and a bunch of useful features for the safe storage of credentials etc. This makes it an excellent tool if you&#8217;re looking to do something with PowerShell on a regular basis and need to interact with Azure.
  
<!--more-->

## Bits I used

### Assets

The [assets][3] aspect of Automation I really loved. This section of functionality allows you to securely store values like API keys and credentials, and also contains schedules and modules but I&#8217;ll cover those separately.

Securely stored values can be retrieved by an Automation job and can continue being passed through the workflow in a secure fashion. This is pretty awesome!

In:

    $rgname = "rg"
    $automation = "posh"
    
    if((Get-AzureAccount).Count -lt 1) {Login-AzureRmAccount}
    
    New-AzureRmAutomationVariable –Name 'aws_accountkey' –Value 'blah' –Encrypted $false  –AutomationAccountName $automation  -ResourceGroupName $rgname
    

Out:

    # Your account access key - must have read access to your S3 Bucket
    $accessKey = (Get-AzureRMAutomationVariable -Name 'aws_accountkey' -ResourceGroupName $rgname -AutomationAccountName $automationaccount ).Value
    

### Modules

<img src="http://res.cloudinary.com/lockedata/image/upload/h_120,w_300/v1499850320/modules_phd06a.png" alt="Azure Automation Modules facility" width="300" height="120" class="alignleft size-medium wp-image-61693" />
  
To be able to work with S3 files, I needed a specific PoweShell module. You are able to add modules easily within the GUI. The nifty thing is you can import modules from the [PowerShell Gallery][4], so I was able to use the [AWSPowerShell][5] module within my runbook.

### Local dev

<img src="http://res.cloudinary.com/lockedata/image/upload/h_300,w_175/v1499850321/automationise_z543r6.png" alt="PowerShell Automation ISE" width="175" height="300" class="alignright size-medium wp-image-61692" />
  
Uploading scripts and running them in just hoping they worked would be a poor development experience. Thankfully, there is an awesome addition to the PowerShell ISE that you can get via the PowerShell Gallery called the [Azure Automation Authoring Toolkit][6]. This enables you to make variables, make local versions of them, draft and publish runbooks. It&#8217;s a vital piece of tech for building Azure Automation runbooks.

## Problems encountered

  * Not a lot of Azure Automation docs use the [Azure Resource Manager][7] PoSh cmdlets, this made it tough sometimes to know what to do
  * I couldn&#8217;t find a purely PowerShell solution for decompressing tar.gz files and the use of an exe like 7zip seemed difficult to achieve

## Wrap up

In the end, I was only able to get the latest files from s3 and dump them into blob storage. I didn&#8217;t succeed at my goal but I was very impressed with Azure Automation and fully intend on using it in future. You can see an example of what I wrote for this task as a [gist][8].

Thanks for reading and tips on improving the code or achieving the decompression of .tar.gz files will be gratefully received. If you haven&#8217;t used Automation yet, I recommend you give it a try.

 [1]: https://azure.microsoft.com/en-gb/services/automation/
 [2]: https://www.simple-talk.com/sysadmin/powershell/powershell-desired-state-configuration-the-basics/
 [3]: https://azure.microsoft.com/en-gb/blog/getting-started-with-azure-automation-automation-assets-2/
 [4]: https://www.powershellgallery.com/
 [5]: https://www.powershellgallery.com/packages/AWSPowerShell
 [6]: https://www.powershellgallery.com/packages/AzureAutomationAuthoringToolkit/0.2.3.4
 [7]: https://azure.microsoft.com/en-gb/documentation/articles/resource-group-overview/
 [8]: https://gist.github.com/stephlocke/410ad30ca863ea5388b5a3fd2d2b1be8