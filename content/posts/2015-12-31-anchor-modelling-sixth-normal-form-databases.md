---
title: 'Anchor Modelling: Sixth Normal Form databases'
author: Steph

date: 2015-12-31T11:47:29+00:00
spacious_page_layout:
  - default_layout
enclosure:
  - |
    |
        https://itsalocke.com/wp-content/uploads/2015/12/04.01.2016-12.52.mp4
        2899929
        video/mp4
        
categories:
  - DataOps
  - Microsoft Data Platform
tags:
  - agile
  - anchor model
  - data modelling
  - datawarehouse
  - medrianchor
  - mssql
  - open source
  - sixth normal form
  - sql server

---
## About Anchor Modelling

[Anchor Modelling][1] moves you beyond third normal form and into sixth normal form. What does this mean?

> Not sure about the normal forms? See the normalization process in actions with this [normalisation example][2] 

Essentially it means that an attribute is stored independently against the key, not in a big table with other attributes. This means you can easily store metadata about that attribute and do full change tracking with ease. The historical problem with this methodology is that it makes writing queries a real pain. Anchor Modelling overcomes this by providing views that combine all the attribute data together.

This system means that it&#8217;s super easy to manage new or changing schema requirements as every table is independent, so no deployment takes a table offline or impacts other data. The storage of just data that is present reduces storage requirements. The pervasive auditing makes full change tracking, including changes to the schema, a breeze.

There is a small performance overhead of the system, despite materialised joins, so I wouldn&#8217;t recommend it as the source for reports / queries that require super response times. This performance hit is however vastly outweighed in the agility and auditing of the system for a lot of my use cases.

The neat thing is that you can put an anchor model alongside your existing data warehouse and slowly convert, or use it to prototype a model and then switch over when it&#8217;s stable if you don&#8217;t need all the anchor features or concepts.

## The GUI

The Anchor Modelling guys built a fantastic [GUI][3] to develop and explore Anchor models in. You build a fantastic representation, and then use the export to get your DDL SQL, an XML representation, or even HTML documentation.

The urge to go &#8220;weeeeeeeeee!&#8221; as I play with GUI may, or may not, have been a key deciding factor in my usage of the system 😉

<div style="width: 640px;" class="wp-video">
  <!--[if lt IE 9]><![endif]--><video class="wp-video-shortcode" id="video-61494-1" width="640" height="324" preload="metadata" controls="controls"><source type="video/mp4" src="https://itsalocke.com/wp-content/uploads/2015/12/04.01.2016-12.52.mp4?_=1" />
  
  <a href="https://itsalocke.com/wp-content/uploads/2015/12/04.01.2016-12.52.mp4">https://itsalocke.com/wp-content/uploads/2015/12/04.01.2016-12.52.mp4</a></video>
</div>

## MeDriAnchor

The Anchor Model system is a fantastic GUI and outputs the SQL needed for DDL &#8211; defining the database &#8211; but it doesn&#8217;t help with ETL. At the time, there wasn&#8217;t an existing ETL framework for an anchor datawarehouse and I needed to be able to integrate new data really quickly and I had significant time pressures in the day job. Along with [James Skipwith][4], over 45 working days we built the Metadata Driven Anchor Model or MeDriAnchor for short. This enabled us to store the relationships between source systems and our schema, use the Anchor Model&#8217;s sisulator to build the DDL and then generate the DML stored procedures to pull data from one system to another.

I&#8217;ve had pretty limited time so this has been on the back-burner for a while, but it&#8217;s a nifty system even though it&#8217;s still v1.

**UPDATE: Nowadays, I&#8217;d recommend using the system built by the Anchor modeling team: [sisula][5]**

## Why not temporal tables?

In 2016, [temporal tables][6] will provide a historisation facility that stores old row versions in another table and gives extra predicates for identifying rows at specific points in time. This is certainly a massive step forward for people and will cover a reasonable amount of use cases but it stores more data than necessary, still suffers from problems amending a third normal form schema, and doesn&#8217;t include other concepts of time that an anchor model can.

## Presentation

You can check out [the slides I put together on Anchor Models][7] on Sway.



## About the presentation

I used [Sway][8] to produce the presentation and it was great how easy it was to build a highly visual presentation in it. One thing that&#8217;s important to note though is it will adjust based on the output screen so the interactions can differ between a high-res widescreen laptop, a low res square projector, and a mobile screen.

 [1]: http://www.anchormodeling.com/
 [2]: https://github.com/stephlocke/normalization-example
 [3]: http://www.anchormodeling.com/modeler/latest/
 [4]: https://twitter.com/TheSQLPimp
 [5]: https://github.com/Roenbaeck/sisula/tree/ETL
 [6]: https://msdn.microsoft.com/en-gb/library/dn935015.aspx
 [7]: https://sway.com/Nh8UJdEUTonyDQFF
 [8]: https://sway.com