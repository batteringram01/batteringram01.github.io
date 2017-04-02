---
layout: post
title: "Play - the reactive web framework"

meta:
  nav: blog
  author: morpheyesh
  pygments: true
  mathjax: true
---


We saw the world moving from writing web applications from java, to perl, to php, then the rails/django and now its time for something more reactive, Play Framework. Typesafe backed, play2 is written in scala and it is the only scala high-productivity web framework that I have loved working with. Getting started with play is a breeze .

In this blog post, I will be covering about play framework, and how to install it and create a simple app.
ASASPDLMALSDJ



### Let us see play's awesomeness

One of the major role of a web framework is to define a very convincing application architecture that works for a range of applications. A web framework needs to bring  multiple components that is required together in order to make the  web development a lot easier and yes, it helps scalability. With out that, its just bunch of libraries with will cause incompatibility.
Play provides just that, it is a perfect framework to build any types of applications and scale well.

### Non-blocking - asynchronous I/O

Play's http server is JBOSS Netty and hence the non-blocking I/O, which gives the ability to process multiple requests with single thread.

### MVC architecture

MVC design patterns which are widely used gives a loosely coupled architecture which seperates the logic from the other layers making it easy to develop.

### Full stack web framework

Play is a fullstack nextgen web framework which can be used to develop simple apps to complex enterprise applications. Whether you are building a UI centric application with persistent db or writing a REST API with JSON transactions, play is the framework for you.

### Scal(a)e

One of the major reasons why I even looked into play framework was because it is written in scala. It also integrates with Akka, a actor-based concurrency library for scala.
There are much more advanced topics like using enumerators and iteratees for building real-time applications, but I will cover them on my next blog post.

Let us now install play and write a simple app.


### Installing Play framework

Make sure you have jdk installed.

Get the binary package first

    wget http://download.playframework.org/releases/play-2.0.zip

Now, untar inside <code>/home/bin</code>

*Note: I generally install everything with binary packages, so I have a common bin folder
which contains all my languages, framework setups. It makes it a lot easier when you want to format your laptop, just backup your bashrc and bin folders.*


Now open up bashrc and add the line

    export PATH=$PATH:/home/morpheyesh/bin/play-2.0

Close bashrc and either close the terminal window and open it or enter <code>source ~/.bashrc</code>

You should see something like this if you type play on your terminal


If you see this, then you have installed play and ready to start building your applications. Play builds the proper directory structure for you, just type

    play new <appname>
    #Play will setup the basic template to get started
    cd <appname>
    atom ./

*Note: I use Github's atom as my primary IDE, it has multiple packages and it is one of my favourite editor to work with.*

If you get this error

    /home/morpheyesh/bin/play-2.0/play: 51: /home/morpheyesh/bin/play-2.0/play: /home/morpheyesh/bin/play-2.0/framework/build: Permission denied

Then change permissions of your build file

    chmod +rx /home/morpheyesh/bin/play-2.0/framework/build


Now cd into your application and execute <code>play run</code> to start the application on localhost:9000
