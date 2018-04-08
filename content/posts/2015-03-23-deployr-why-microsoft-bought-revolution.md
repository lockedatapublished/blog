---
title: DeployR – why Microsoft bought Revolution?
author: Steph

date: 2015-03-23T10:19:10+00:00
dsq_thread_id:
  - 3725984718
categories:
  - Data Science
  - R
tags:
  - azure
  - machine learning
  - microsoft
  - r
  - software development in r

---
I&#8217;ve been asked by a few people recently about why I don&#8217;t use <a href="http://azure.microsoft.com/en-gb/services/machine-learning/" title="Azure Machine Learning" target="_blank">Azure Machine Learning</a> (ML). I answer that I don&#8217;t use it _yet_, and the reason being that at the moment the robust development life-cycle isn&#8217;t in place around it. I think that will change &#8211; one of the great reasons for the <a href="http://blog.revolutionanalytics.com/2015/01/revolution-acquired.html" title="Microsoft acquire Revolution Analytics" target="_blank">acquisition of Revolution Analytics</a> (in my opinion) is their <a href="http://deployr.revolutionanalytics.com/" title="DeployR" target="_blank">DeployR</a> system.

DeployR is essentially an R web service platform. You develop and test locally, you deploy to the server and test, then an app developer hooks up to the APIs and tests, and then it goes live. I really love that ability to test at each step of the way, along with &#8220;separation of concerns&#8221;. It&#8217;s also an &#8220;on-premises&#8221; solution in that it&#8217;s a server product, with a typical freemium model, so that if you worry about cloud<del datetime="2015-03-23T09:59:11+00:00">s</del>, you can keep everything on servers you control.

Leveraging existing functionality and skills from Revolution, will hopefully mean we get a robust workflow in to ML and have an on-premises version. Of course, you can get the <a href="http://deployr.revolutionanalytics.com/download/" title="Download DeployR" target="_blank">free DeployR</a> today and get the benefits, just without the GUI that ML provides.