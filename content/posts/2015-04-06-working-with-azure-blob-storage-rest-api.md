---
title: Working with Azure Blob Storage, some notes
author: Steph

date: 2015-04-06T09:27:05+00:00
dsq_thread_id:
  - 3720652530
categories:
  - DataOps
  - R
tags:
  - api
  - azure
  - blob storage
  - microsoft
  - r
  - software development in r
  - stream analytics

---
I&#8217;m working on building a snazzy <a href="https://github.com/stephlocke/Rtraining/blob/master/inst/slidedecks/shiny/Dashboards.Rmd" title="My shiny presentation" target="_blank">shiny</a> app that a) drops the inputs/parameter values into <a href="http://azure.microsoft.com/en-gb/documentation/articles/storage-introduction/" title="Azure storage intro" target="_blank">blob storage</a> and b) uses <a href="http://azure.microsoft.com/en-gb/services/stream-analytics/" title="Stream Analytics" target="_blank">Stream Analytics</a> to query the values and present back what people are saying at the moment. This&#8217;ll be a fab tool for <a href="https://itsalocke.com/index.php/r-pre-con-sqlsat-exeter/" title="My R Pre-Con: SQLSat Exeter" target="_blank">my pre-con next month</a> if I can get it working in time!

Getting it working, does however mean utilising the <a href="https://msdn.microsoft.com/en-us/library/azure/dd179355.aspx" title="Storage API documentation" target="_blank">Azure Blob Storage API</a> in R which I confess is much harder than expected, especially after the ease of using the Visual Studio Online API for <a href="https://itsalocke.com/index.php/bride-of-frankenstein-tfs-r/" title="Bride of Frankenstein: TFS + R" target="_blank">tfsR</a>. To that end, I thought I&#8217;d write-up some of my findings before I do a bigger write-up that illustrates how to do everything (in R).

I&#8217;m working my way through an [intro to azure storage][1] on the (hopefully reasonable) expectation that more knowledge will make it easier to work with. There&#8217;s additionally the <a href="https://msdn.microsoft.com/en-us/library/azure/dd135733.aspx" title="Blob Storage REST API" target="_blank">online reference</a>, although I found the <a href="https://www.visualstudio.com/en-us/integrate/api/overview" title="Visual Studio Online REST API documentation" target="_blank">VSO REST API</a> documentation easier to understand and get started with.
  
<!--more-->

## Necessary info

To connect to an Azure Blob storage container you need to know your account name, access key, and container that you want to interact with.

  * account name will be the blob storage account name 
  * the access key is either the primary or secondary access keys (either one is fine) and it&#8217;s worth noting that this is encoded in base64 already, so you may need to decode it before you can use it 
  * the container name you want to put blobs in

## Constructing a signature

It&#8217;s a bit weird (in my eyes anyway) but to <a href="https://msdn.microsoft.com/en-us/library/azure/dd179428.aspx" title="Azure Storage Authentication" target="_blank">authenticate your request</a> to use blob storage you have to send the request basically twice &#8211; once as the main request, and second as an identical but encoded signature in the headers of the main request.

When you&#8217;re constructing your request you need to:

  * Fix a date value to be used twice within the signature. This has to be a specific format and in R I create it via:
  
    `x-ms-date <- format(Sys.time(),"%a, %d %b %Y %H:%M:%S %Z", tz="GMT")`
  * Construct a &#8220;Canonicalized Header&#8221; containing the x-ms-date and x-ms-version, separated with line breaks, in the format `headertitle:headervalue`
  * Similarly, build a &#8220;Canonicalized Resource&#8221; holding `/accountname/container` and all query parameters that appear in your API call, i.e. everything after the ?. These parameters needs to be in alphabetical order and separated with line breaks, in the format `headertitle:headervalue`
  * Construct a string of: 
      * the API call verb
      * 12 carriage returns
      * the &#8220;Canonicalized Header&#8221; 
      * the &#8220;Canonicalized Resource&#8221; 

## Encoding the signature

Using the (un-encoded) access key as the key or basis for this next bit you have to:

  * Make sure your signature string is UTF8 encoded
  * Encrypt this using HMAC using the SHA-256 algorithm
  * Encode this into base64

## Sending the signature

Phew! After all that work, the encoded signature string (as the Authorization header), the x-ms-date and x-ms-version all need to be sent in the header of the request.

## My next steps

I have <a href="https://github.com/stephlocke/Rtraining/tree/253b1584c045125ad2be89f65cbf45cc62133452/R" title="Rtraining Azure Blob Storage functions" target="_blank">work in progress R functions for this task in my Rtraining package</a>, I&#8217;m currently working on the sending of JSON to the BLOB storage and verifying how this needs to be handled in my signature string.

**If you see any inaccuracies, misunderstandings, potential improvements, or rational explanations for the stuff above, please let me know by commenting!**

 [1]: http://justazure.com/azure-blob-storage-part-one-introduction/ "Just Azure - working with blob storage"