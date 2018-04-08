---
title: Azure Storage Accounts – Resource Groups matter to PowerShell!
author: Steph

date: 2016-06-10T09:00:21+00:00
categories:
  - DataOps
tags:
  - azure
  - blob storage
  - powershell

---
I&#8217;m sure that all my PoSh friends out there, who use Azure and PowerShell all the time probably know this already but I thought I&#8217;d share a little snippet of hard-won knowledge.

> When you put an Azure Storage Account into a Resource Group, you can no longer use the default Azure.Storage module. Instead, you&#8217;ve got to use the AzureRM.Storage module. 

All the scripts I encountered whilst googling how to connect to blob storage via PowerShell, including the ones in the script gallery within [Azure Automation][1] seemed to all assume the azure storage account you wanted to connect to was standalone. Unfortunately, the new best practice is to use the [Resource Manager][2] methodology. To work with Azure resources within resource groups requires a different set of PowerShell modules. I&#8217;m guessing this is because it probably have meant fairly major and/or breaking changes to the existing cmdlets to take an extra, optional, resource group parameter.

The problem I had was that I was trying to connect to a specific blob container but I couldn&#8217;t even get passed the `Get-AzureStorageAccountKey` stage. This means that in my instance when I was searching for my azure storage account and it kept saying that no such account existed. I was pretty sure I&#8217;d spelled things correctly but it simply wouldn&#8217;t find the account. It was only when I was typing plaintively to the fabulous [Rob Sewell][3] that I uncovered the issue and solved it for myself.

Hopefully, this little post will help prevent someone else from spending hours trying to solve the same problem of not being able to find their storage accounts. I&#8217;ve also included below a sample script for getting to a container in blob storage under the new resource group paradigm.

[embedGist source=&#8221;https://gist.github.com/stephlocke/db3c0d0decc714fe36ee6e1b9770007e&#8221;]

 [1]: https://azure.microsoft.com/en-gb/services/automation/
 [2]: https://azure.microsoft.com/en-gb/documentation/articles/resource-group-overview/
 [3]: http://sqldbawithabeard.com