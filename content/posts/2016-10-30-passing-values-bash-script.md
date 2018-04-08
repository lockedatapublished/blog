---
title: 'Quick tip: Passing values to a bash script'
author: Steph

date: 2016-10-30T14:53:01+00:00
categories:
  - Misc Technology
tags:
  - bash
  - linux
  - quick tip
  - scripts

---
This is a very quick post on how you can make a bash script that allows you to provide it values via the command line. Passing values to a bash script uses a 1-based array convention inside the script, that are referenced by prefixing with $ inside the script.

This means that if I provide `.\dummyscript.sh value1 value2`, inside the dummyscript.sh I can retrieve these by referencing their positions:

    echo $1 + $2
    

For improved clarity, you could assign them to new variables

    exp1=$1
    exp2=$2
    echo $exp1 + $exp2
    

This is very simple usage and you can do a lot more sophisticated processing. I found this [bash positional parameters page][1] pretty handy and, of course, the next step would be to do [named parameters][2].

You might like to play with these concepts on a [bash Fiddle][3]!

<!-- more -->

Here&#8217;s a real-world example. I wrote this a few months ago to install Azure File Storage drivers to Docker. It uses a parameter to be able to provide it the name of the config file holding Azure access credentials.

[embedGist source=&#8221;https://gist.github.com/stephlocke/a02d7b8be42604e5b6bbd19d689ab28f&#8221;]

 [1]: http://wiki.bash-hackers.org/scripting/posparams
 [2]: http://wiki.bash-hackers.org/howto/getopts_tutorial
 [3]: https://www.tutorialspoint.com/execute_bash_online.php