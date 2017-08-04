---
title: The basics of Common Table Expressions (CTEs)
author: Steph
type: post
date: 2014-11-10T15:40:15+00:00
dsq_thread_id:
  - 3740903915
categories:
  - Microsoft Data Platform
tags:
  - mssql
  - quick tip
  - sql fundamentals
  - sql server

---
Another quick post off the back of a SQL Lunch a did a while ago. Explore it via SQLFiddle: <http://sqlfiddle.com/#!6/ad7f5/7/0>

##  What is a CTE?

A Common Table Expression (CTE) is essentially a function defining a relation instead of a table.
  
This function outputs a table (like all queries) that is only present within the session, but data isn&#8217;t stored in tempdb like with a temporary table.

## Why CTE&#8217;s?

CTEs are designed _primarily_ to allow recursion within SQL &#8211; like a loop but ideal at working with hierarchies. This is excellent for tables that are self-referential &#8230; think employees!

Additionally, they&#8217;re great for generating sequences&#8230; think times, dates, etc

## What&#8217;s the syntax?

<pre>WITH [Tbl Name] ([col],[names],..) AS
 (
 SQL
 )</pre>

Produce multiple CTEs by comma separating them

<pre>WITH
 [Tbl Name] ([col],[names],..) AS
 ( SQL ),
 [Tbl Name 2] ([col],[names],..) AS
 ( SQL )</pre>

Then use a standard DML statement after it!

## Where can I learn more?

<https://www.simple-talk.com/sql/t-sql-programming/sql-server-cte-basics/>
  
<http://technet.microsoft.com/en-us/library/ms190766(v=sql.105).aspx>
  
<http://msdn.microsoft.com/en-gb/library/ms175972.aspx>
  
<http://blogs.msdn.com/b/sqlcat/archive/2011/04/28/optimize-recursive-cte-query.aspx>