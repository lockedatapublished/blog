---
title: DataOps – it’s a thing (honest)
author: Steph
type: post
date: 2015-10-16T20:27:03+00:00
spacious_page_layout:
  - default_layout
categories:
  - DataOps
  - Microsoft Data Platform
  - R
tags:
  - best practices
  - conferences
  - dataops
  - dlm
  - mssql
  - presentation
  - productivity
  - sql server
  - ssis
  - SSRS
  - travis-ci
  - unit testing

---
Today, I presented a [lightning talk on DataOps][1] at [SQL in the City][2]. It was a fantastic day and a great opportunity to catch up with how the database side of things is evolving to embrace [DevOps][3].

My lightning talk was titled _DataOps &#8211; it&#8217;s a thing (honest)_ and focused on what is essentially DevOps ported out of the developer sphere and into the data professional sphere.



<!--more-->

For folks not up on the DevOps side of things, DevOps is bridging the gap between different teams, both culturally and technologically, to reduce the risk and cost of software development in an organisation. Culturally, it means things like ownership of changes, “left-shifting” responsibility for testing, and lower manual approvals. Technologically, it means things like unit testing, immutable architecture, Continuous Integration (CI), Continuous Delivery (CD), real-time application monitoring and alerting.

The first part of DataOps is perhaps the most obvious &#8211; the database! [Database Lifecycle Management (DLM)][4] is the work Microsoft & Redgate are doing to facilitate [unit testing][5], CI & CD, and pipeline management for databases. DLM has been primarily used to improve the development & maintenance of application databases. As such it should be a significant component for a DevOps team. _But_ OLTP is not the only database use case in town &#8211; data warehouses and data marts need some love too. DLM can work well with these, but few devs want to build data warehouses so DLM cannot be solely under the purview of DevOps. So for the developers/analysts building data warehouses, please embrace DLM, and for the tool makers, please help cater to the needs of people who aren&#8217;t always the most comfy with code.

The next aspect is &#8220;traditional BI&#8221; a.k.a data transformation and loading (ETL), cubes, and reporting. These are historically developed using GUIs with limited tooling and support for the sort of practices we could expect in a DevOps environment. It is getting better with BIML, some [unit testing facilities][6], and MS Build but it&#8217;s still not there. It should be. Yeah, applications are the thing which make money, but the insight from BI is what helps people direct the resources into improving said applications and managing the company generally. You need these things, and you need them to be right &#8211; so we should be adding as many facilities to check that things are right as possible.

The final major area is analytics aka data science, statistics, data mining, machine learning. In BI correctness is key – but we’re only ever aiming for correctness at the point of presentation. Analytics is aiming to be reasonably accurate consistently over people and time. That’s a really hard thing since when you start changing things, you can’t tell what would have happened if you hadn’t, unless you experiment. You need to be able to account for changing behaviour over time, and changes to data capture etc. This means your modelling has to be update-able and refinements easy to deploy, and at the same time remaining robust and auditable. Coded analysis, regular retraining, testing, and a validation and deployment pipeline are all needed to facilitate on-going analytics. Analytics has to be automated to be able to cope so incorporating the techniques of DevOps into the area is vital.

So folks, DataOps is a thing and it is the application of DevOps principals to data-centric applications. Enjoy!

 [1]: https://1drv.ms/p/s!AiZm2P6YHtSfjye0xDn_fuL80eSp
 [2]: http://sqlinthecity.red-gate.com/london-2015/
 [3]: https://en.wikipedia.org/wiki/DevOps
 [4]: https://www.red-gate.com/blog/working/the-revolution-starts-here
 [5]: http://artofunittesting.com/definition-of-a-unit-test/
 [6]: https://itsalocke.com/database-bi-related-unit-testing-options/