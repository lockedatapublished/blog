---
title: Using purrr with APIs – revamping my code
author: Steph

date: 2017-06-13T10:20:40+00:00
spacious_page_layout:
  - default_layout
categories:
  - Data Science
  - Microsoft Data Platform
  - R
tags:
  - api
  - microsoft cognitive services
  - purrr
  - r
  - sentiment analysis

---
I wrote a little while back about [using Microsoft Cognitive Services APIs with R][1] to first of all detect the language of pieces of text and then do sentiment analysis on them. I wasn&#8217;t too happy with the some of the code as it was very inelegant. I knew I could code better than I had, especially as I&#8217;ve been doing a lot more work with purrr recently. However, it had sat in drafts for a while. Then David Smith kindly posted about the [process I used][2] which meant I had to get this nicer version of my code out ASAP!

Get the complete code in this [gist][3].

## Prerequisites

  * API access 
      * [A key][4]
      * [An endpoint][5]
  * Packages 
      * [httr][6]
      * [jsonlite][7]
      * [dplyr][8]
      * [purrr][9]

## Setup

<pre><code class="r">library(httr)
library(jsonlite)
library(dplyr)
library(purrr)

cogapikey&lt;-"XXX"

text=c("is this english?"
       ,"tak er der mere kage"
       ,"merci beaucoup"
       ,"guten morgen"
       ,"bonjour"
       ,"merde"
       ,"That's terrible"
       ,"R is awesome")

# Put data in an object that converts to the expected schema for the API
data_frame(text) %&gt;% 
  mutate(id=row_number()) -&gt;
  textdf

textdf %&gt;% 
  list(documents=.) -&gt;
  mydata
</code></pre>

## Language detection

We need to identify the most likely language for each bit of text in order to send this additional bit of info to the sentiment analysis API to be able to get decent results from the sentiment analysis.

<pre><code class="r">cogapi&lt;-"https://westus.api.cognitive.microsoft.com/text/analytics/v2.0/languages?numberOfLanguagesToDetect=1"

cogapi %&gt;% 
  POST(add_headers(`Ocp-Apim-Subscription-Key`=cogapikey),
       body=toJSON(mydata)) -&gt;
  response

# Process response
response %&gt;% 
  content() %&gt;%
  flatten_df() %&gt;% 
  select(detectedLanguages) %&gt;% 
  flatten_df()-&gt;
  respframe

textdf %&gt;% 
  mutate(language= respframe$iso6391Name) -&gt;
  textdf
</code></pre>

## Sentiment analysis

With an ID, text, and a language code, we can now request the sentiment of our text be analysed.

<pre><code class="r"># New info
mydata&lt;-list(documents = textdf)

# New endpoint
cogapi&lt;-"https://westus.api.cognitive.microsoft.com/text/analytics/v2.0/sentiment"

# Construct a request
cogapi %&gt;% 
  POST(add_headers(`Ocp-Apim-Subscription-Key`=cogapikey),
       body=toJSON(mydata)) -&gt;
  response

# Process response
response %&gt;% 
  content() %&gt;%
  flatten_df() %&gt;% 
  mutate(id=as.numeric(id))-&gt; 
  respframe

# Combine
textdf %&gt;%
  left_join(respframe) -&gt;
  textdf
</code></pre>

And&#8230; et voila! A multi-language dataset with the language identified and the sentiment scored using purrr for easier to read code.

Using purrr with APIs makes code nicer and more elegant as it really helps interact with hierarchies from JSON objects. I feel much better about this code now!

## Original

| id | language | text                  |     score |
| --:|:-------- |:--------------------- | ---------:|
|  1 | en       | is this english?      | 0.2852910 |
|  2 | da       | tak er der mere kage  |        NA |
|  3 | fr       | merci beaucoup        | 0.8121097 |
|  4 | de       | guten morgen          |        NA |
|  5 | fr       | bonjour               | 0.8118965 |
|  6 | fr       | merde                 | 0.0515683 |
|  7 | en       | That&#8217;s terrible | 0.1738841 |
|  8 | en       | R is awesome          | 0.9546152 |

## Revised

| text                  | id | language |     score |
|:--------------------- | --:|:-------- | ---------:|
| is this english?      |  1 | en       | 0.2265771 |
| tak er der mere kage  |  2 | da       | 0.7455934 |
| merci beaucoup        |  3 | fr       | 0.8121097 |
| guten morgen          |  4 | de       | 0.8581840 |
| bonjour               |  5 | fr       | 0.8118965 |
| merde                 |  6 | fr       | 0.0515683 |
| That&#8217;s terrible |  7 | en       | 0.0068665 |
| R is awesome          |  8 | en       | 0.9973871 |

Interestingly the scores for English have not stayed the same &#8211; for instance, Microsoft now sees &#8220;R is awesome&#8221; in a much more positive light. It&#8217;s also great to see German and Danish are now supported!

Get the complete code in this [gist][3].

 [1]: https://itsalocke.com/microsoft-cognitive-services-text-analytics-api/
 [2]: http://blog.revolutionanalytics.com/2017/06/interfacing-with-apis.html
 [3]: https://gist.github.com/stephlocke/441ea493be926b76bac59452a3f57281
 [4]: https://www.microsoft.com/cognitive-services/en-us/sign-up
 [5]: https://www.microsoft.com/cognitive-services/en-us/text-analytics/documentation
 [6]: https://cran.r-project.org/package=httr
 [7]: https://cran.r-project.org/package=jsonlite
 [8]: https://cran.r-project.org/package=dplyr
 [9]: https://cran.r-project.org/package=purrr