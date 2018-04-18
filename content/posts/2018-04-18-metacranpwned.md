---
title: How many CRAN package maintainers have been pwned?
author: maelle
type: post
date: 2018-04-19T1109:16:40+00:00
spacious_page_layout:
  - default_layout
categories:
  - Data Science
  - R
tags:
  - r

---

The alternative title of this blog post is _`HIBPwned` version 0.1.7 has been released! W00t!_. Steph's [`HIBPwned` package](https://itsalocke.com/hibpwned/) utilises the [HaveIBeenPwned.com API](https://haveibeenpwned.com/API/v2) to check whether email addresses and/or user names have been present in any publicly disclosed data breach. In other words, this package potentially delivers bad news, but useful bad news! 

This release is mainly a maintenance release, with some cool code changes invisible to you, the user, but not only that: you can now get `account_breaches` for several accounts in a `data.frame` instead of a list, and you'll be glad to know that results are cached inside an active R session. You can read about more functionalities of the package in the [function reference](https://itsalocke.com/hibpwned/reference/).

Wouldn't it be a pity, though, to echo the [release notes](https://github.com/lockedata/HIBPwned/releases/tag/v0.1.7) without a nifty use case? Another blog post will give more details about the technical aspects of the release, but here, let's make you curious! How many CRAN package maintainers have been [pwned](https://en.wikipedia.org/wiki/Pwn)?

<!-- README.md is generated from README.Rmd. Please edit that file -->

```{r setup, include = FALSE}
knitr::opts_chunk$set(
  collapse = TRUE,
  cache = TRUE,
  message = FALSE,
  warning = FALSE,
  comment = "#>",
  fig.path = "man/figures/README-",
  out.width = "100%"
)
```
Get the email addresses of CRAN package maintainers
===================================================

```{r}
library("magrittr")
```

Data was gathered thanks to an adaptation of the code published in [this blog post of David Smith's about prolific package maintainers](http://blog.revolutionanalytics.com/2018/03/the-most-prolific-package-maintainers-on-cran.html). _We_ are after the most endangered package maintainers on CRAN!

The helper function below extracts the email address of a string such as "Jane Doe <jane.doe@fakedomain.io>". On top of using the `as.person` conversion, this function also deals with a few particular cases.

```{r}
get_maintainer_email <- function(maintainer_string){
  if(inherits(maintainer_string, "data.frame")){
    maintainer_string <- maintainer_string$Maintainer[1]
  }
  
  if(maintainer_string != "ORPHANED"){
     maintainer_string <- stringr::str_replace_all(maintainer_string,
                                                '"', '')
     maintainer_string <- stringr::str_replace_all(maintainer_string,
                                                ',', '')
     # particular case!
     maintainer_string <- stringr::str_replace_all(maintainer_string,
                                                'Berlin School of Economics and Law', '')
    maintainer <- as.person(maintainer_string)
    maintainer$email
  }else{
    ""
  }
  
}
```

Here it is in action.
```{r}
get_maintainer_email("Jane Doe <jane.doe@fakedomain.io>")

```

The following code then gathers the email addresses of all CRAN package maintainers.

```r
tools::CRAN_package_db() %>%
  .[, c("Package", "Maintainer")] %>%
  tidyr::nest(Maintainer, .key = "Maintainer") %>%
  # get the email out of the maintainer
  dplyr::mutate(email = purrr::map_chr(Maintainer,
                                       get_maintainer_email)) %>%
  dplyr::select(- Maintainer) %>%
  # only keep the ones with email
  dplyr::filter(email != "") %>%
  # save result
  readr::write_csv(path = "data/all_packages.csv")

```

```{r}
emails <- readr::read_csv("data/all_packages.csv")
```

We obtained `r nrow(emails)` packages with `r length(unique(emails$email))` unique email addresses. We do not have to care about their uniqueness: since `HIBPwned` implements caching inside an active R session via [`memoise`](https://github.com/r-lib/memoise) duplicate emails do not mean duplicate requests! :nail_care: Another aspect we users do not need to care about is rate limiting: `HIBPwned` uses the nice [`ratelimitr` package](https://github.com/tarakc02/ratelimitr) in order to automatically pause R when needed.

So, have CRAN package maintainers been pwned?
=============================================

Thanks to setting the new `as_list` option to FALSE we got a data.frame as output. Note that choosing this means we only get back accounts with breaches. Depending on the analysis, we could supplement the original `emails` data.frame with the information using `dplyr::left_join` for instance.

```{r}
pwned <- HIBPwned::account_breaches(emails$email,
                                    as_list = FALSE)
pwned <- unique(pwned)

```

There are `r length(unique(emails$email))` unique CRAN maintainer emails, among which `r length(unique(pwned$account))` i.e. `r round(length(unique(pwned$account))/length(unique(emails$email)), digits = 2)*100`% have been pwned. Dear reader, why not compare this to the proportion of Python module maintainers who've been pwned? Ping us if you complement this analysis!

```{r, echo = FALSE}
pwned %>%
  dplyr::select(- DataClasses) %>%
  readr::write_csv(path = "data/pwned.csv")

```

Looking at these pwned maintainers, here are the number of breaches they've been victims of:

```{r}
pwned %>%
  dplyr::count(account) %>%
  dplyr::summarise(median = median(n),
                   min = min(n),
                   max = max(n)) %>%
  knitr::kable()
```

There are `r length(unique(pwned$Name))` unique breaches. What were the most common ones?

```{r}
pwned %>%
  dplyr::group_by(Title, BreachDate) %>%
  dplyr::tally() %>%
  dplyr::arrange(desc(n)) %>%
  head(10) %>%
  knitr::kable()
```

Maybe or probably some you've heard of, which might make you wonder about your own security, being a CRAN maintainer or not...

What about you?
===============

You could check if you've been victim of any known breach right now by installing `HIBPwned` from CRAN!

```{r}
# install.packages("HIBPwned")
str(HIBPwned::account_breaches("steff.sullivan@gmail.com"))
```

If one of your addresses has been pwned, Steph says you should change passwords in other locations is you re-used passwords. Even if your address hasn't been pwned yet you should use a password manager that will allow you not to re-use passwords, and set up two factor authentication, e.g. read more about [2FA for GitHub](https://help.github.com/articles/securing-your-account-with-two-factor-authentication-2fa/). 

And how could you now right away if a known data breach is of concern to you? Well, don't only let your .Rprofile [tell you you're a rrrrock star](https://twitter.com/annakrystalli/status/985972442219909121), but also add some code checking whether you've been pwned, as explained in [this blog post](https://itsalocke.com/blog/use-your-.rprofile-to-give-you-important-notifications/)! Pro-tip, you can use the `usethis::edit_r_profile` function to easily open your .Rprofile. Steph also says you can register for [HIBPwned.com notifications](https://haveibeenpwned.com/NotifyMe) and ask your organisation to watch breaches at the domain level. Stay safe!
