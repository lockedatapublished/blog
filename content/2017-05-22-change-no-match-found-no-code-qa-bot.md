---
title: 'How to change “No match found!” on your no-code Q&A bot'
author: Steph
type: post
date: 2017-05-22T08:24:04+00:00
spacious_page_layout:
  - default_layout
categories:
  - Microsoft Data Platform
  - Misc Technology
tags:
  - azure functions
  - bot services
  - bots
  - qnamaker

---
Last week, I blogged about [building a no-code Q&A bot][1] for your website. One little niggle I had with the bot was the response when it could match a user input to a Q&A. I wondered how to change &#8220;No match found!&#8221;.

I looked around the [qnamaker.ai][2] site and couldn&#8217;t find a place I could change this. I submitted some feedback and the great people at the other of the Q&A site responded super quickly. I&#8217;ve raised a number of feedback points with them and I must say they&#8217;ve absolutely amazing at responding. But I digress.

They responded with this link: [Create a question and answer bot][3]

That&#8217;s a great resource for techies but gibberish for someone trying to fudge their way through building these bots like I am!

In essence, if you&#8217;ve already built your Q&A bot, what you need to do change &#8220;No match found!&#8221; for your bot is:

  * Go to [the Azure portal][4]
  * Navigate to the Apps section and select your bot&#8217;s name 
      * This will show a load of code and a file navigation tree on the left hand side
  * Navigate to BasicQnAMakerDialog.csx
  * Go to the line beginning with `public BasicQnAMakerDialog() :`
  * Scroll to the end of the line and put your cursor after the first closing bracket
  * Type a comma (`,`) and then inside two speech marks (`"`) the response you want to return
  * Hit Save

So the relevant line might go from

        public BasicQnAMakerDialog() : base(new QnAMakerService(new QnAMakerAttribute(Utils.GetAppSetting("QnASubscriptionKey"), Utils.GetAppSetting("QnAKnowledgebaseId"))))
    

to

        public BasicQnAMakerDialog() : base(new QnAMakerService(new QnAMakerAttribute(Utils.GetAppSetting("QnASubscriptionKey"), Utils.GetAppSetting("QnAKnowledgebaseId"), "I'm sorry Dave, I'm afraid I can't do that.")))

 [1]: https://itsalocke.com/easy-peasy-qa-bot/
 [2]: https://qnamaker.ai
 [3]: https://docs.microsoft.com/en-us/bot-framework/azure/azure-bot-service-template-question-and-answer
 [4]: https://portal.azure.com