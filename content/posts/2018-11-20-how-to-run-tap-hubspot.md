---
title: How to run tap-hubspot
author: Rita Giordano
date: '2018-11-17'
slug: how-to-run-tap-hubspot
categories: [Data Science]
tags: [Singer]
draft: yes
---

I faced recently with tap-hubspot and I found that is not trivial to obtain all necessary parameters to create the configuration file. In this post I will show you how easily retrieve all parameter and how to run the tap. Tap-hubspot is a Singer tap that produce JSON formatted data. Before to talk about the tap-hubspot I will briefly describe what is *Singer* and a *tap*.

Singer
------

Singer is an open source standard that moves data between databases, web APIs, files and many more. It describes how **taps** (data extraction scripts) and **target** (data loading scripts) should communicate, allowing them to be used in any combination for moving data from any source to any destinations. The taps and targets are simple application with pipes, which communicate with JSON, making them easy to work with.

Tap-HubSpot
-----------

This *tap* allows the communication with HubSpot. The tap pulls raw data from HubSpot's **REST API**, extract some resources, outputs the schema for each resource and incrementally pulls the data based on the input state. The tap take a *confguration* file (config.json) and an optional *state* file as input to produce stream of record, state and schema message as output. A tap can be implemented in any programming language, in this post I will present how to use it with Python 3.

How to install tap-hubspot
--------------------------

Now I will show you what I learn working with the tap-hubspot. Before to start be sure that you have Python 3 installed on your machine. If you work with different tap is advised to create an environment for each of them. The three steps that I am presenting below are valid also for other tap and not only for HubSpot. First you need to create a virtual environment with Python 3, use the command line below and add at the end the name of the tap, which in this case is hubspot.

``` bash
python3 -m venv ~/.virtualenvs/tap-hubspot
```

After you create the environment you run the command source to activate it.

``` bash
source ~/.virtualenvs/tap-hubspot/bin/activate
```

Now you see that the name of the tap is displayed in parenthesis in your shell. Next step is to install the tap using pip.

``` bash
pip install tap-hubspot
```

#### Config file.

Now that you created the virtual environment and install the tap, is time to create the config file config.json, which will include all the necessary credentials or parameter to run the tap on your machine. In the case of HubSpot the details included in the configuration file are the OAuth 2.0 authentication, a cutoff date for syncing historical data and an optional flag that controls collection of anonymous usage metrics. Here an example of the config file for tap-hubspot:

    {
      "redirect_url": "https://api.hubspot.com/",
      
      "client_id": 123456789000,
      
      "client_secret": "my_secret",
      
      "refresh_token": "my_token",
      
      "start_date": "2017-01-01T00:00:00Z",
      
      "disable_collection": false
    }

Before to create the correct config file for tap-hubspot to add the right credentials and parameter there are some steps to do.

#### 1. Create a free HubSpot developer account

To obtain all credential for the config file, you need first to create a free HubSpot developers account using this link:

<https://app.hubspot.com/signup/developers/step/join-hubspot>

Follow the instruction and you will receive a mail that your HubSpot account is created.

#### 2. Create an app on HubSpot

Once you set up your account you can start to create your first app using the developer dashboard. An application is used to identify your integration. It is also a requirement for using the Timeline and Webhooks APIs. <https://developers.hubspot.com/docs/faq/how-do-i-create-an-app-in-hubspot>

Give a name at you app, for example "test app". You can decide if make public of private.

{{< figure src="../img/createApp.png" title="Create an app with HubSpot">}} 

When the app is create you will be automatically redirect to the dashboard.

Click on the app name to check the settings.

{{< figure src="../img/app.png" title="App settings">}} 

You can see that there is a "Client ID" and "Client Secret". These are informations that you have to include into your config file. You can copy and paste in the config.json file.

{{< figure src="../img/test_app.png" title="">}}

#### 3. Get OAuth 2.0 tokens

After you created the account and app is needed now to get the tokens.

1.  Create the authorization URL The authorization URL will identify your app and define the resources that it's requesting access. The query parameters to pass to the URL are the:

-   client\_id that identify your app.
-   scope the scope your application is requestion. This have to be marked in the main page on you application declaration.

1.  Grant the access.

#### 4. Create a test account

To test the authorization you have to create a test portal. The developer portal will not have access to any scope and cannot authorize your app.

On your account page click on testing and start the testing period that is for 90-days. Give the name at your test hub.

To get the authorization you have to put client id and scope in the following URL: <https://app.hubspot.com/oauth/authorize?client_id=xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx&scope=contacts%20automation&redirect_uri=https://www.example.com/>

Or you can use the following bash script.

``` bash
#!/bin/bash
# Define the variables

# Insert your client id that you obtain when you create the app.
CLIENT_ID=XXXX-XXX-XXX

echo $CLIENT_ID
# Insert your scope.
#!!! Very important before to run the script be sure that is the same scope as in the app web page.
SCOPE=contacts

echo $SCOPE

echo

echo 'https://app.hubspot.com/oauth/authorize?client_id='${CLIENT_ID}'''&scope='${SCOPE}'%20automation&redirect_uri=https://www.example.com/'

## If you are not on Mac change open with google_c-chrome or firefox.
open 'https://app.hubspot.com/oauth/authorize?client_id='${CLIENT_ID}'''&scope='${SCOPE}'%20automation&redirect_uri=https://www.example.com/'
```

In this script you have to specify as variable your client id and the scope of your app, save it and give the script the permissions:

``` bash
chmode +x authorization.sh
```

In this script I use the *open* command to open my browser, this is because because I am on macOS if you have another OS please change open with you browser name. You can be redirect directly to example.com, but if you have multiple accounts (or test accounts) there is the case that it will ask you to select an account. HubSpot will ask for your consent to grant the access.

Now to get the token you can use the following command line to copy and paste on your console, change the client id, client secret and the code you obtained previously when you asked for the authorization and run.

``` bash
curl -H "Content-Type: application/x-www-form-urlencoded;charset=utf-8" -X POST -d 'grant_type=authorization_code&client_id=xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx&client_secret=xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx&redirect_uri=https://www.example.com/&code=xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx' https://api.hubapi.com/oauth/v1/token
```

I created another bash script to ask for the token. As for the authorization.sh here you have to put your client id, client secret and code as input variables.

``` bash
#!/bin/bash
# Generate token for config file

# Insert here your client_id and client secret
CLIENT_ID=xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx
CLIENT_SECRET=xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx
# Insert the code that you obtain after the authorisation
CODE=xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx



echo curl -H "Content-Type: application/x-www-form-urlencoded;charset=utf-8" -X POST -d 'grant_type=refresh_token&client_id='$CLIENT_ID'&client_secret='$CLIENT_SECRET'&redirect_uri=http://www.example.com/&code='$CODE'' https://api.hubapi.com/oauth/v1/token

curl -H "Content-Type: application/x-www-form-urlencoded;charset=utf-8" -X POST -d 'grant_type=authorization_code&client_id='$CLIENT_ID'&client_secret='$CLIENT_SECRET'&redirect_uri=https://www.example.com/&code='$CODE'' https://api.hubapi.com/oauth/v1/token
```

Save the informations about the token in a json file, because it will expire in 6 hours and to refresh the token you need the old one.

``` bash
./token.sh > token.json
```

Every time that the token expire you need to ask for a new token to run the tap. You can use a third script, which will ask for you a new token. This time you need also to include the refresh token that you obtain previously, this will not expire.

``` bash
#!/bin/bash
# Generate token for config file

CLIENT_ID=xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx
CLIENT_SECRET=xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx
REFRESH_TOKEN=xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx

echo curl -H "Content-Type: application/x-www-form-urlencoded;charset=utf-8" -X POST -d 'grant_type=refresh_token&client_id='$CLIENT_ID'&client_secret='$CLIENT_SECRET'&redirect_uri=http://www.hubspot.com/&refresh_token='$REFRESH_TOKEN'' https://api.hubapi.com/oauth/v1/token

curl -H "Content-Type: application/x-www-form-urlencoded;charset=utf-8" -X POST -d 'grant_type=refresh_token&client_id='$CLIENT_ID'&client_secret='$CLIENT_SECRET'&redirect_uri=http://www.hubspot.com/&refresh_token='$REFRESH_TOKEN'' https://api.hubapi.com/oauth/v1/token
```

### Run the tap.

Now that you have all the parameters from HubSpot you can include in the config.json file and run the tap. You can run the tap in discovery mode and obtain a file called properties.json. In this case the tap write to *stdout* a list of streams called *properties* in the case of HubSpot. Each entry of the file contains some basic information about the stream and the JSON schema describing the stream data.

``` bash
~/.virtualenvs/tap-hubspot/bin/tap-hubspot --config tap_config.json --discover > properties.json
```

To run in sync mode include --properties and the file properties.json generated using the discovery mode after the config file.

``` bash
 ~/.virtualenvs/tap-hubspot1/bin/tap-hubspot --config config.json --properties properties.json
```

Conclusion
----------

Following this tutorial you will be able to create your config file and run the tap-hubspot without problems.
