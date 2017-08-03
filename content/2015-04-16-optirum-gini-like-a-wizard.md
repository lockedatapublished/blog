---
title: optiRum – gini like a wizard
author: Steph
type: post
date: 2015-04-16T10:22:38+00:00
categories:
  - Data Science
  - R
tags:
  - gini coefficient
  - logistic regression
  - optiRum
  - r
  - software development in r
  - statistics

---
> <a href="http://cran.r-project.org/web/packages/optiRum/" title="optiRum on CRAN" target="_blank">optiRum</a>, the R package I built and maintain for Optimum on CRAN has gained some extra functions recently. Some of it uses currently experimental data.table functionality so I&#8217;m eagerly awaiting the release to CRAN to deliver optiRum.
> 
> In the interim, I thought I&#8217;d give some brief overviews of **existing** functionality contained in the package. 

I do a lot of regression models and one of the common tools for assessing a regression&#8217;s ability to accurately model an event is to produce a Gini chart and a Gini coefficient. The higher the Gini coefficient, the more your model is able to discriminate probability accurately.

I simplify the process of producing gini charts (`giniChart`) and coefficients (`giniCoef`) so that I get a chart in one simple step.

Under the hood this uses the <a href="http://cran.r-project.org/web/packages/AUC/" title="AUC on CRAN" target="_blank">AUC</a> package to get the coefficient, <a href="http://cran.r-project.org/web/packages/scales/" title="scales on CRAN" target="_blank">scales</a> to format it and <a href="http://docs.ggplot2.org/current/" title="ggplot2 documentation" target="_blank">ggplot2</a> to produce the chart. Using ggplot leads to a better looking chart that can also be tweaked to suit your needs since a ggplot object is returned by the function.

<!--more-->

## Two gini&#8217;s but only one lamp

There are two typical ways of calculating the gini coefficient.

The first utilises a <a href="http://en.wikipedia.org/wiki/Lorenz_curve" title="Lorenz Curve" target="_blank">Lorenz curve</a> which plots the cumulative percentage of goods vs cumulative percentage of bads.

The second is to do a <a href="http://en.wikipedia.org/wiki/Receiver_operating_characteristic" title="ROC curves" target="_blank">Receiver Operating Characteristic (ROC) curve</a> and calculate the Area Under Curve (AUC) for this.

Notionally there is little practical difference in the result (so long as you use one or the other consistently), however, I&#8217;ve utilised the ROC method as it emphasises the ability to correctly predict good behaviour. In my industry, it is much more costly to write a bad loan, than it is to not write a good loan.

## Get the package

  * Install from CRAN: `install.packages(optiRum)`
  * Install the dev version from the github repository using devtools: `devtools::install_github("stephlocke/optiRum")`