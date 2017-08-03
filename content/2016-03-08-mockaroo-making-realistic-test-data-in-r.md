---
title: mockaRoo – making realistic test data in R
author: Steph
type: post
date: 2016-03-08T14:00:54+00:00
categories:
  - DataOps
  - R
tags:
  - best practices
  - continuous integration
  - git
  - r
  - software development in r
  - unit testing

---
When I&#8217;m building stuff in R like packages, models, etc. I find myself wishing for realistic looking test data without having to resort to getting data off my production server. To that end I&#8217;ve been on the hunt for a way of generating decent test data. A few months back I stumbled upon the neat system [Mockaroo][1] which provides a GUI to build some data that suits your needs.

Mockaroo is a really impressive service with a wide spread of different data types. They also have simple ways of adding things like within group differences to data so that you can mock realistic class differences. They use the freemium model so you can get a thousand rows per download, which is pretty sweet. The big BUT you can feel coming on is this &#8211; it&#8217;s a GUI! I don&#8217;t want to have spend time hand cranking a data extract.

Thankfully, they have a GUI for getting data too and it&#8217;s pretty simply to use so I&#8217;ve started making a package for it.

I&#8217;ve started the package on [github][2] and will be developing it over the next month or two. It&#8217;s up and working, but only in the most primitive way as I&#8217;d like to get some feedback from folks who might find this useful around how the interface for generating your desired data schema should work.
  
<!--more-->


  
The really nice thing about this is that I should also be able to include a shiny gadget / Rstudio add-in so there can also be a GUI for producing mock data.^

There will be some inherent limitations as the API (currently) does not possess the facility to create scenarios and other Mockaroo concepts &#8211; you can only use existing ones &#8211; but this should be a nice utility package.

Mockaroo requires a JSON representation of the desired schema and aside of some common fields (i.e. name and type) there&#8217;s a lot of optional ones. I&#8217;m most comfortable with tables so I&#8217;m inclined to have some sort of tabular interface that converts to JSON but perhaps people want helper functions like `mock_emails()`.

**Do you have a need for mock data? What have you found to be a challenge in the past? What sort of interface will make the [mockaRoo][2] package an intuitive one for you?**

PS I also made a very [simple Docker container][3] with the mockaroo npm module installed. So if you want to have a JavaScript playground, fill ya boots

^ I am aware of the irony in this part of the proposed package!

 [1]: https://www.mockaroo.com/
 [2]: https://github.com/stephlocke/mockaRoo
 [3]: https://hub.docker.com/r/stephlocke/mockaroo/