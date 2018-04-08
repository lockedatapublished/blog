---
title: Talking Data and Docker
author: Steph

date: 2017-02-08T16:25:20+00:00
categories:
  - DataOps
  - Misc Technology
tags:
  - 'statuspost'
  - agile
  - best practices
  - conferences
  - docker
  - open source

---
If you need to know about persisting data in the world of containers then I recently did a talk and a spot on a podcast that should help you out. My [NDC London][1] talk _Data + Docker = Disconbobulating?_ cover the basics and architectural decisions. In my podcast spot _Data and Docker_ on [.Net Rocks][2] we go into more depth about the architectural decisions facing you when working with data and Docker.

## Data + Docker = Disconbobulating?

Understanding how you persist data with Docker is important. Without knowing how you can persist data outside of the container, you&#8217;re stuck patching containers, which is a big no-no in the Docker world. This talk takes you from the basics of Docker to different architectural options and considerations when looking to persist data. I provide code samples and a tutorial for trying some of the aspects out, including getting a docker machine going on Azure and using the Azure File Storage Plugin. Use these to get a feel for how data and Docker works.

  * [Slides][3]
  * [Github][4]

## Data and Docker

The guys at .Net Rocks were kind enough to interview me on-site at NDC London. It was a great opportunity to meet folks who have been dedicated the community for so long that they&#8217;d already recorded 1407 other podcasts! They did [Podcast #1][5] back in 2002 &#8211; amazing drive and passion for their community, clearly.

Data and Docker is not a comfortable fit (IMO) so most solutions revolve around how you bust out of the container safely for your needs. We discuss the various options and it was great to discuss them with Rich and Carl who have stronger infrastructure backgrounds than myself.

  * Listen to the [podcast][6]

## Quick opinion about Docker

I still quite like Docker for bundling dependencies, but [I&#8217;ve been really loving Azure Functions][7] and the [lambda architecture][8] paradigm. Both have their respective places and I&#8217;m sure I&#8217;ll continue to use both to deploy data products in future.

 [1]: http://ndc-london.com/
 [2]: http://dotnetrocks.com
 [3]: http://stephlocke.info/datadockerdisconbobulating/datadockerdisconbobulating.html#/
 [4]: https://github.com/stephlocke/datadockerdisconbobulating
 [5]: http://dotnetrocks.com/?show=1
 [6]: http://dotnetrocks.com/?show=1408
 [7]: https://itsalocke.com/i-love-azure-functions/
 [8]: http://lambda-architecture.net/