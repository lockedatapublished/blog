---
title: "2018 09 08 Cosmos DB for Datascience"
author: "Dave"
date: 2018-09-07T10:54:45+01:00
draft: false
---

Cosmos DB is a snazzy new(ish) Microsoft Azure product. I was able to go to Microsoft Office in London for three days of training on the database service, which was really well structured and well run, with a lot of knowledgeable Microsoft bods around to pass on their considerable knowledge. This post will extract out some key features and benefits of the service, and then discuss how this fit's into a data scientists role.

What is CosmosDB?
=================
From a pure and simple database perspective cosmos is a 'Document Database'. This means it is a _non-relational_ store of _JSON documents_. MongoDB and CouchDB are examples of other Document Databases, but CosmosDB opens a whole new universe of potential.

Two quotes from Microsoft demonstrate this pretty effectively.

> A globally distributed, massively scalable, multi-model database service

> A fully-managed globally distributed database service built to guarantee extremely low latency and massive scale for modern apps

Microsoft seems to me to be targeting a few specific markets with this product. Many of the case studies revolved around IoT, specifically the increasing importance of data from car telemetry systems, web and mobile apps, gaming and retail.

These applications are highly suited to the technology for a number of reasons

Semi-structured data
--------------------

Imagine you have a website where you sell phones, which consumers may want to compare against in relevant ways. For example, your phone data may look like this:

```json
{
phone1:
    {
    brand:"Nokia",
    model:"3310",
    year:"2000",
    cpu:"MAD2WD1"
    }
}
{
phone2:
    {
    brand:"Nokia",
    model:"3310",
    year:"2017",
    soc:"MT6260"
    camera:"2mp"
    }
}
```

Two Nokia 3310s, separated by 17 years. Some properties are identical: `brand` and `model`, some are different: `year`, and some are present in one, but not the other: `cpu`and `soc`, and the two documents have a different length, the `phone2` has a `camera` resolution value.

Imagine a representation of this in a relational database. If both phones were a record, each would have a few `NULL` values. Further, if you were making a schema for this database in 2000, could you have predicted the ubiquity of phone cameras? I doubt it, which will have meant a potentially awkward schema update later. 

The retail market hits this all the time as products are developed, but so does the car industry, as new models are released with improved features: hybrid power > electric power > self-driving > ??hover cars??

<div style="width:100%;height:0;padding-bottom:57%;position:relative;"><iframe src="https://giphy.com/embed/WT40jXYyhIcww" width="100%" height="100%" style="position:absolute" frameBorder="0" class="giphy-embed" allowFullScreen></iframe></div><p>It's 2018. I was robbed. <a href="https://giphy.com/gifs/back-to-the-future-WT40jXYyhIcww">via GIPHY</a></p>

CosmosDB's solution is to make the product 'schemaless'. Writes won't fail because the schema isn't met, there isn't one to validate against. Data is automatically parsed and indexed. The default is for all data to be indexed against, but this is tuneable so you can 

Write optimised
---------------
Internet of Things telemetry data is a growing source of data, and [automobile telemetry](https://en.wikipedia.org/wiki/Telemetry#Transportation) is of particularly high value, and high scale. CosmosDB is a ['write-optimised'](https://www.ascent.tech/wp-content/uploads/documents/microsoft/cosmos-db/cosmos-db.pdf) data store. It has been engineered to write high volumes, fast, every time.

> [All writes are always durably quorum committed in a any region where you write while providing performance guarantees.](https://docs.microsoft.com/en-us/azure/cosmos-db/faq#what-happens-with-respect-to-various-config-settings-for-keyspace-creation-like-simplenetwork)

Some other document databases are similarly noted for their 'fast' writes, however these tend to rely on _in-memory caching_. In the event that someone starts driving their car you have multiple thousands of documents (records) hitting your data base _really fast_. In-memory caching solutions in other databases rely that that stream of data will eventually end and until that point the data is held in memory, before it is written to disk. If the car is being driven for five minutes, maybe the memory caching will hold all the data, which can then be written back to disk in the future. If it's a cross country, 3 hour trip though, it's either going to be really expensive to hold that data, or some data will be lost due to buffer overflow. Literally the data just can't fit into the memory. CosmosDB doesn't rely on this (risky) business, but still maintains supremely fast performance, which is backed by some [pretty big SLAs](https://azure.microsoft.com/en-us/support/legal/sla/cosmos-db/v1_1/).

<div style="width:100%;height:0;padding-bottom:53%;position:relative;"><iframe src="https://giphy.com/embed/6QOQeB0enXhXq" width="100%" height="100%" style="position:absolute" frameBorder="0" class="giphy-embed" allowFullScreen></iframe></div><p>"Oh my God, it's full of documents!" <a href="https://giphy.com/gifs/movie-sci-fi-2001-6QOQeB0enXhXq">via GIPHY</a></p>

Turn-key distribution
---------------------
A distributed database is one that is run across multiple machines, nearly always via a cloud provider. This enables data to be closer to it's users. In the event of a global audience this becomes really important at scale, because the distance the data needs to travel from device to database is one of the factors in determining write speed. Imagine your video game has just launched new DLC, and you are expecting very bursty traffic for a few days as all your users dive into the new maps. Initialise some more clones of your data sets to decrease latency and serve the increase in traffic volume.

If that sounds a little complicated, the 'turn-key' nature should help calm your mind.

{{< figure src="../img/cosmosdb-geo-distribution.gif" caption="Turn-key geo-distribution in cosmosDB is really this easy">}} 

Data storage compliance is another consideration. Some data (such as UK medical data) might not be inherently suited to this architecture, however, cosmosDB is a 'Foundational (Ring 0)' Azure service, so it is available in all azure regions, including their 'Sovereign' and '[Government](https://azure.microsoft.com/en-gb/global-infrastructure/government/)' regions.

<div style="width:100%;height:0;padding-bottom:48%;position:relative;"><iframe src="https://giphy.com/embed/ZyGTx7DbVmHDy" width="100%" height="100%" style="position:absolute" frameBorder="0" class="giphy-embed" allowFullScreen></iframe></div><p>A database army. And I must say, one of the finest we've ever created <a href="https://giphy.com/gifs/clone-ZyGTx7DbVmHDy">via GIPHY</a></p>

Multi-model
----------
And so how do you communicate with this weird alien database? In the creation step for a CosmosDB account you can select  you select an api (and resultant data model) from the following list:
* SQL
* MongoDB
* Cassandra
* Azure Table
* Gremlin (graph)

CosmosDB's data model is then set relative to this selection, however [the query methods can be modified without impacting the underlying data structure](https://vincentlauzon.com/2017/09/10/hacking-changing-cosmos-db-portal-experience-from-graph-to-sql/).

The data models include `key:value`, `column:family`, `document` and `graph` via it's use of [atom-record-sequence type system in the database engine](https://azure.microsoft.com/en-gb/blog/a-technical-overview-of-azure-cosmos-db/). In practical terms this means that you can read in data in a graph form from a data source, but still query it using SQL in a 'relational' way.

<div style="width:100%;height:0;padding-bottom:75%;position:relative;"><iframe src="https://giphy.com/embed/5fLgDwo63DQcg" width="100%" height="100%" style="position:absolute" frameBorder="0" class="giphy-embed" allowFullScreen></iframe></div><p>SQl and Graph at Tenegra! <a href="https://giphy.com/gifs/eyes-temba-5fLgDwo63DQcg">via GIPHY</a></p>

Gotchas
=======
what join does
can't query on non-indexed properties
