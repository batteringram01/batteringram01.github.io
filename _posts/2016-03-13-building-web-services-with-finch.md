---
layout: post
title: "Building webservices with finch"

meta:
  nav: blog
  author: morpheyesh
  pygments: true
  mathjax: true
---



I chose scala and akka as the quintessential stack to build the metrics processing engine which would deal with things running concurrently. Initially, the engine was written in golang, goroutines doing all the heavy lifting, I decided to write it in scala, and in a pure functional approach. It is called concorde(yes! I always dreamt of flying in one) and it leverages the akka's actor model to deal with concurrency and uses finch for building other web services.

TBD
