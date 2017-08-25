---
title: Photoshop image macro (or something even better!)
author: Steph
type: post
date: 2015-01-13T10:59:21+00:00
categories:
  - Misc Technology
tags:
  - hacks
  - photoshop
  - productivity
  - quick tip
  - wordpress

---
I spend _a lot_ of time in Photoshop for someone in BI. Between cleaning up images, building logos for my latest project, or producing material for user groups, I probably use it at least once a week. Through it all, I usually need to produce variants, in different file formats and sizes. So it can quickly become a dozen uses of the Save As&#8230; or Save for Web functions.

I hate manual work, so you can see why it was frustrating in the extreme. Then I realised how silly I was being by not having already googled for it!

It took a while because my keyword searches weren&#8217;t the terms Photoshop use but I found the Secret Sauce. And if you&#8217;re the sort of person who&#8217;d type &#8220;photoshop image macro&#8221; &#8211; here&#8217;s how you do it!
  
<!--more-->

The trick is the option File > Generate > Image Assets.

Once this is ticked, you can then do one of two things:
    
1. Rename a layer to use a file extension (and the other available syntax) so for instance going from &#8220;MyLayer&#8221; to &#8220;MyLayer.png&#8221;
    
2. Creating a Group (the folder icon at the bottom of the Layers pane) for your layers and using the renaming trick there

Doing a single layer will produce an image with the layers contents in whatever file name you specified into a folder in the same place as your Photoshop file. The Group version also produces an image but for all the layers contained within it.

The Photoshop help article on <a href="http://helpx.adobe.com/photoshop/using/generate-assets-layers.html" title="Generate image assets from layers" target="_blank">generating image assets</a> is pretty good and they have a followup containing more <a href="http://blogs.adobe.com/samartha/2013/09/a-closer-look-at-the-photoshop-generator-syntax.html" title="A closer look at the Photoshop Generator syntax" target="_blank">tips and tricks for the syntax</a>

### Example &#8211; the CaRdiff logo

I thought I&#8217;d give you an example I was working on in the weekend. I had to produce a logo for the <a href="http://www.meetup.com/Cardiff-R-User-Group/" title="Cardiff R User Group" target="_blank">R user group</a> I&#8217;m setting up.

I knew that the logo had to go up on meetup.com and that the image renderer could be funny so I didn&#8217;t know whether a png, gif, or jpeg would work best.

The easy solution was to enable the asset functionality and rename the logo group &#8220;CaRdiff.jpg,CaRdiff.png,CaRdiff.gif&#8221; so that it would generate all three. I also put a white background layer inside the group to make sure Meetup wouldn&#8217;t do something crazy when it was resizing the image.
  
<figure id="attachment_60051" style="width: 851px" class="wp-caption alignnone">[<img src="../img/autogenerating-photoshop-images_vvpl65_m1znjg.png" alt="Autogenerating photoshop images" width="851" height="750" class="size-full wp-image-60051" />][1]<figcaption class="wp-caption-text">The bits needed for generating images in Photoshop</figcaption></figure>

### Conclusion

The option File > Generate > Image Assets is a real time-saver for me and clear evidence of why you shouldn&#8217;t just grin and bear manual labour. OK it can take a while to find the right solution, but boy does it feel good when a task you really dislike is removed.

 [1]: ../img/autogenerating-photoshop-images_vvpl65_m1znjg.png