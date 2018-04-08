---
title: 'R Quick tip: Microsoft Cognitive Services’ Text Analytics API'
author: Steph

date: 2017-03-01T09:40:46+00:00
spacious_page_layout:
  - default_layout
categories:
  - R
tags:
  - api
  - quick tip
  - r
  - sentiment analysis

---
Today in class, I taught some fundamentals of API consumption in R. As it was aligned to some Microsoft content, we first used [HaveIBeenPwned.com][1]&#8216;s API and then played with [Microsoft Cognitive Services][2]&#8216; Text Analytics API. This brief post overviews what you need to get started, and how you can chain consecutive calls to these APIs in order to perform multi-lingual sentiment analysis.

**UPDATE: See improved code in [Using purrr with APIs – revamping my code][3]**
  
<!--more-->

## Getting started

To use the analytics API, you need two things:

  * A key
  * A URL

Get the key by [signing up for free][4] on the Cognitive Services site for the Text Analytics API. Make sure to verify your email address!

The URL can be retrieved from the [API documentation][5] and you can even play in an [online sandbox][6] before you start implementing it.

To use the API in R, you need:

  * [`httr`][7] 
  * [`jsonlite`][8], which `httr` will kindly install for you

To make some things easier on myself, I&#8217;m also going to use [`dplyr`][9] and [`data.table`][10].

<pre><code class="r">library(httr)
library(jsonlite)
library(data.table)
library(dplyr)
</code></pre>

## Starting info

To talk to the API, we need our URL, our API, and some data.

<pre><code class="r"># Setup
cogapikey&lt;-"XXX"
cogapi&lt;-"https://westus.api.cognitive.microsoft.com/text/analytics/v2.0/languages"

text=c("is this english?"
       ,"tak er der mere kage"
       ,"merci beaucoup"
       ,"guten morgen"
       ,"bonjour"
       ,"merde"
       ,"That's terrible"
       ,"R is awesome")

# Prep data
df&lt;-data_frame(id=1:8,text)
mydata&lt;-list(documents= df)
</code></pre>

## Topic detection

We have some different languages and we need to first do language detection before we can analyse the sentiment of our phrases

<pre><code class="r"># Construct a request
response&lt;-POST(cogapi, 
               add_headers(`Ocp-Apim-Subscription-Key`=cogapikey),
               body=toJSON(mydata))
</code></pre>

Now we need to consume our response such that we can add the language code to our existing data.frame. The structure of the response JSON doesn&#8217;t play well with others so I use data.table&#8217;s nifty `rbindlist`. It is a **very good** candidate for [`purrr`][11] but I&#8217;m not up to speed on that yet.

<pre><code class="r"># Process response
respcontent&lt;-content(response, as="text")
respdf&lt;-data_frame(
    id=as.numeric(fromJSON(respcontent)$documents$id), 
    iso6391Name=rbindlist(
      fromJSON(respcontent)$documents$detectedLanguages
    )$iso6391Name
  )
</code></pre>

Now that we have a table, we can join the two together

<pre><code class="r"># Combine
df%&gt;%
  inner_join(respdf) %&gt;%
  select(id, language=iso6391Name, text) -&gt;
  dft
</code></pre>

## Sentiment analysis

With an ID, text, and a language code, we can now request the sentiment of our text be analysed.

<pre><code class="r"># New info
mydata&lt;-list(documents= dft)
cogapi&lt;-"https://westus.api.cognitive.microsoft.com/text/analytics/v2.0/sentiment"
# Construct a request
response&lt;-POST(cogapi, 
               add_headers(`Ocp-Apim-Subscription-Key`=cogapikey),
               body=toJSON(mydata))
</code></pre>

Processing this response is simpler than processing the language response

    # Process reponse
    respcontent<-content(response, as="text")
    
    fromJSON(respcontent)$documents %>%
       mutate(id=as.numeric(id)) ->
       responses
    
    # Combine
    dft %>%
      left_join(responses) ->
      dfts
    

And&#8230; et voila! A multi-language dataset with the language identified and the sentiment scored where the language can be scored. 😀

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

 [1]: https://haveibeenpwned.com
 [2]: https://www.microsoft.com/cognitive-services/en-us/
 [3]: https://itsalocke.com/using-purrr-with-apis/
 [4]: https://www.microsoft.com/cognitive-services/en-us/sign-up
 [5]: https://www.microsoft.com/cognitive-services/en-us/text-analytics/documentation
 [6]: https://westus.dev.cognitive.microsoft.com/docs/services/TextAnalytics.V2.0
 [7]: https://cran.r-project.org/package=httr
 [8]: https://cran.r-project.org/package=jsonlite
 [9]: https://cran.r-project.org/package=dplyr
 [10]: https://cran.r-project.org/package=data.table
 [11]: https://cran.r-project.org/package=purrr