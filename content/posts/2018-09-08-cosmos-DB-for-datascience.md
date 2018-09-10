---
title: "2018 09 08 Cosmos DB for Data Science"
author: "Dave"
date: 2018-09-07T10:54:45+01:00
draft: false
---

Cosmos DB is a snazzy new(ish) Microsoft Azure product. I was able to go to Microsoft Office in London for three days of training on the database service, which was really well structured and well run, with a lot of knowledgeable Microsoft bods around to pass on their considerable knowledge. This post will extract out some key features and benefits of the service, and then discuss how this fit's into a data scientists role.

What is CosmosDB?
=================
From a pure and simple database perspective cosmos is a 'Document Database'. This means it is a _non-relational_ store of _JSON documents_. MongoDB and CouchDB are examples of other Document Databases, but CosmosDB opens a whole new universe of potential.

Two quotes from Microsoft demonstrate this pretty effectively.

> "A globally distributed, massively scalable, multi-model database service"

> "A fully-managed globally distributed database service built to guarantee extremely low latency and massive scale for modern apps"

Microsoft seems to me to be targeting a few specific markets with this product. Many of the case studies revolved around IoT, specifically the increasing importance of data from car telemetry systems, web and mobile apps, gaming and retail.

These applications are highly suited to the technology for a number of reasons

Semi-structured data
--------------------

Imagine you have a website where you sell phones, which consumers may want to compare against in relevant ways. For example, your phone data may look like this:

```json
{
    "phone1":{
        "brand":"Nokia",
        "model":"3310",
        "year":"2000",
        "cpu":"MAD2WD1"
    },
    "phone2":{
        "brand":"Nokia",
        "model":"3310",
        "year":"2017",
        "soc":"MT6260",
        "camera":"2mp"
    }
}
```

Two Nokia 3310s, separated by 17 years. Some properties are identical: `brand` and `model`, some are different: `year`, and some are present in one, but not the other: `cpu`and `soc`, and the two documents have a different length, the `phone2` has a `camera` resolution value.

Imagine a representation of this in a relational database. If both phones were a record, each would have a few `NULL` values. Further, if you were making a schema for this database in 2000, could you have predicted the ubiquity of phone cameras? I doubt it, which will have meant a potentially awkward schema update later. 

The retail market hits this all the time as products are developed, but so does the car industry, as new models are released with improved features: hybrid power > electric power > self-driving > ??hover cars??

<div style="width:100%;height:0;padding-bottom:57%;position:relative;"><iframe src="https://giphy.com/embed/WT40jXYyhIcww" width="100%" height="100%" style="position:absolute" frameBorder="0" class="giphy-embed" allowFullScreen></iframe></div><p>It's 2018. I was robbed. <a href="https://giphy.com/gifs/back-to-the-future-WT40jXYyhIcww">via GIPHY</a></p>

CosmosDB's solution is to make the product 'schemaless'. Writes won't fail because the schema isn't met, there isn't one to validate against. Data is automatically parsed and indexed. The default is for all data to be indexed.

Write optimised
---------------
Internet of Things telemetry data is a growing source of data, and [automobile telemetry](https://en.wikipedia.org/wiki/Telemetry#Transportation) is of particularly high value, and high scale. CosmosDB is a ['write-optimised'](https://www.ascent.tech/wp-content/uploads/documents/microsoft/cosmos-db/cosmos-db.pdf) data store. It has been engineered to write high volumes, fast, every time.

> [All writes are always durably quorum committed in any region where you write while providing performance guarantees.](https://docs.microsoft.com/en-us/azure/cosmos-db/faq#what-happens-with-respect-to-various-config-settings-for-keyspace-creation-like-simplenetwork)

Some other document databases are similarly noted for their 'fast' writes, however these tend to rely on _in-memory caching_. In the event that someone starts driving their car you have multiple thousands of documents (records) hitting your data base _really fast_. In-memory caching solutions in other databases rely that that stream of data will eventually end and until that point the data is held in memory, before it is written to disk. If the car is being driven for five minutes, maybe the memory caching will hold all the data, which can then be written back to disk in the future. If it's a cross country, 3 hour trip though, it's either going to be really expensive to hold that data, or some data will be lost due to buffer overflow. Literally the data just can't fit into the memory. CosmosDB doesn't rely on this (risky) business, but still maintains supremely fast performance, which is backed by some [pretty big SLAs](https://azure.microsoft.com/en-us/support/legal/sla/cosmos-db/v1_1/).

<div style="width:100%;height:0;padding-bottom:53%;position:relative;"><iframe src="https://giphy.com/embed/6QOQeB0enXhXq" width="100%" height="100%" style="position:absolute" frameBorder="0" class="giphy-embed" allowFullScreen></iframe></div><p>"Oh my God, it's full of documents!" <a href="https://giphy.com/gifs/movie-sci-fi-2001-6QOQeB0enXhXq">via GIPHY</a></p>

Turn-key distribution
---------------------
A distributed database is one that is run across multiple machines, nearly always via a cloud provider. This enables data to be closer to it's users. In the event of a global audience this becomes really important at scale, because the distance the data needs to travel from device to database is one of the factors in determining write speed. Imagine your video game has just launched new DLC, and you are expecting very bursty traffic for a few days as all your users dive into the new maps. Initialise some more clones of your data sets to decrease latency and serve the increase in traffic volume.

If that sounds a little complicated, the 'turn-key' nature should help calm your mind.

{{< figure src="../img/cosmosdb-geo-distribution.gif" caption="Turn-key geo-distribution in cosmosDB is really this easy">}} 

Data storage compliance is another consideration. Some data (such as UK medical data) might not be inherently suited to this architecture, however, cosmosDB is a 'Foundational (Ring 0)' Azure service, so it is available in all Azure regions, including their 'Sovereign' and '[Government](https://azure.microsoft.com/en-gb/global-infrastructure/government/)' regions. This allows compliance control on where, and in what way, the data is stored.

<div style="width:100%;height:0;padding-bottom:48%;position:relative;"><iframe src="https://giphy.com/embed/ZyGTx7DbVmHDy" width="100%" height="100%" style="position:absolute" frameBorder="0" class="giphy-embed" allowFullScreen></iframe></div><p>A database army. And I must say, one of the finest we've ever created <a href="https://giphy.com/gifs/clone-ZyGTx7DbVmHDy">via GIPHY</a></p>

Multi-model
----------
And so how do you communicate with this weird alien database? In the creation step for a CosmosDB account you can select an api (and resultant data model) from the following list:

* SQL
* MongoDB
* Cassandra
* Azure Table
* Gremlin (graph)

CosmosDB's data model is then set relative to this selection, however [the query methods can be modified without impacting the underlying data structure](https://vincentlauzon.com/2017/09/10/hacking-changing-cosmos-db-portal-experience-from-graph-to-sql/).

The data models include `key:value`, `column:family`, `document` and `graph` via it's use of an [atom-record-sequence type system in the database engine](https://azure.microsoft.com/en-gb/blog/a-technical-overview-of-azure-cosmos-db/). In practical terms this means that you can read in data in a graph form from a data source, but still query it using SQL in a 'relational' way. Your social network app may be suited to write in data in a directed network way, but maybe your business intelligence team are highly invested in a SQL toolset. CosmosDB should help to bridge this gap.

<div style="width:100%;height:0;padding-bottom:75%;position:relative;"><iframe src="https://giphy.com/embed/5fLgDwo63DQcg" width="100%" height="100%" style="position:absolute" frameBorder="0" class="giphy-embed" allowFullScreen></iframe></div><p>SQL and Graph at Tenegra! <a href="https://giphy.com/gifs/eyes-temba-5fLgDwo63DQcg">via GIPHY</a></p>

Gotchas
=======

`JOIN`
------
In relational DBs `JOIN` works in a familiar and intuitive way, but with this non-relational data structure what does a `JOIN` mean, and what can we use it for?

Firstly, JSON allows for arrays to be included in a document.

```json
[
  {
    "droid": "BB8",
    "affiliation": "New Republic",
    "series": "BB",
    "films": [
      "The Force Awakens",
      "The Last Jedi"
    ]
  },
  {
    "droid": "BB9E",
    "affiliation": "First Order",
    "series": "BB",
    "films": [
      "The Last Jedi"
    ]
  }
]
```

This can be queried through SQL like this: 
```sql
SELECT
    droids.droid,
    droids.affiliation,
    films
FROM
    droids
JOIN
    films in droids.films
```

Which will return an output like this:
```json
[
    {
        "droid":"BB8",
        "affiliation":"New Republic",
        "films":"The Force Awakens"
    },
    {
        "droid":"BB8",
        "affiliation":"New Republic",
        "films":"The Last Jedi"
    },
    {
        "droid":"BB9E",
        "affiliation":"First Order",
        "films":"The Last Jedi"
    }
]
```

The query has _merged_ multiple documents, into a _single_ _flattened_ results set. Here there is no `INNER`, `LEFT`, or `OUTER` to do subsetting. This is achieved with the `WHERE` clause.
```sql
SELECT
    droids.droid,
    droids.affiliation,
    films
FROM
    droids
JOIN
    films in droids.films
WHERE
    films IN ("The Last Jedi")
```
```json
[
    {
        "droid":"BB8",
        "affiliation":"New Republic",
        "films":"The Last Jedi"
    },
    {
        "droid":"BB9E",
        "affiliation":"First Order",
        "films":"The Last Jedi"
    }
]
```

`JOIN` does just, and only that. Filtering is done in the `WHERE` clause.

Queries and Indexing
--------------------
CosmosDB automatically indexes all data as it comes in by default. For high volume data this might be problematic leading to longer write times, so how can this be mitigated? The index can be selectively applied through an 'index policy'. However the trade off for this means that value will no longer be queryable. 

For instance if your data has information like this:
```json
[
    {
        "affiliation":"Jedi",
        "character_name":"Luke Skywalker"
    },
    {
        "affiliation":"Sith",
        "character_name":"Snoke"
    }
]
```
And `character_name` was excluded by your indexing policy, then
```sql
SELECT
    force_users.affiliation,
    force_users.character_name
FROM
    force_users
WHERE
    force_users.character_name == "Luke Skywalker"
```
would error. It wouldn't know where Luke was!
 
How should a data scientist use CosmosDB?
=========================================

Connection
----------
To make a simple connection to the data base from an R session you can use the [ODBC driver supplied by Microsoft](https://docs.microsoft.com/en-us/azure/cosmos-db/odbc-driver). Once this has been setup you can use the [`odbc` and `DBI` packages](https://db.rstudio.com/odbc/) to run queries against the connection in R, which is even easier using [RStudio's tools](https://db.rstudio.com/rstudio/connections/). However, the connection can be only part of the challenge if you are interested in using a large scale data source.

Computing
---------
With such effortless scaling of data collection and storage, data scientists (& Business Analysts and & Management Information Specialists, etc.) might see this as a simple solution to scale issues. However, remember that this is a '_write_ optimised, data _storage_ layer', frequently for analytics workstreams what we should be looking for is data _computation_ layers. Our workflows can be very _memory_ intensive, though luckily there are solutions.

### HDInsights

Microsoft have a number of implementations of Apache Spark tied into their Azure platform. [HD Insights](https://azure.microsoft.com/en-gb/services/hdinsight/) is a fully managed analytics service, built on Apache Spark (and others) and [is easy to plumb into an R interface](https://azure.microsoft.com/en-gb/services/hdinsight/r-server/)

### Databricks

During the training many examples of scaled out analysis workflow in practice used the [Databricks](https://docs.databricks.com/spark/latest/data-sources/azure/cosmosdb-connector.html) service, a proprietary fork of Apache Spark. This can then be used in an [R session via `SparkR` and `sparklyr`](https://docs.azuredatabricks.net/spark/latest/sparkr/index.html).

### Normal Apache Spark

Of course, as spark is so highly supported, there is nothing to stop you setting up your own standard spark cluster and connecting to it in the traditional way.