---
layout: post
title: "RESTful API in GO"

meta:
  nav: blog
  author: morpheyesh
  pygments: true
  mathjax: true
---


The web is filled with different API design suggestions/standards with many web services today are moving to API centric architectures, it is important to keep in mind the complexities that can be caused by a poorly designed API.
Remember an API is almost like an interface used by the developers to work on your service and it needs to be well designed, when I mean well designed, it needs to be highly
pragmatic and easy for the developers to understand and quickly get started with.
A good API design will give you the ability to also scale drastically without affecting the service. <!-- more -->
If you have worked with an API before that is poorly designed, then the code you write which consumes the API ends up being messy and bad.

### Key principle of REST
The basic principle of REST is the seperation of the API into logical resources.
Then these resources are accessed by multiple HTTP Methods(GET, POST, PUT, DELETE).

When a developer is consuming the API, make sure to name all the resources as nouns and in plural to reduce confusions.

    POST /v1/accounts                       #Create an account(Post)
    GET  /v1/accounts/:email                #Fetches an email(Show)


I suggest you read up the famous [Roy Fieldings's](https://en.wikipedia.org/wiki/Roy_Fielding) dissertation on [Architectural Styles and
the Design of Network-based Software Architectures](http://www.ics.uci.edu/~fielding/pubs/dissertation/top.htm)

### Keep in mind

* Good Documentation -  Without a good API documentation, dont expect people to consume your API. When I am looking at multiple services for a problem, I first look and pick the one with better documentation.
You definitely need to read this - [Building modern API Documentation](https://lord.io/blog/2013/beautiful-api-docs/)

* Versioning - Versioning all your APIs are crucial. There are contant debates whether to specify versions in the URL or not, I prefer adding versions in the URL.

    GET /v1/accounts

[Stripe](https://stripe.com/docs/api), [twitter](https://dev.twitter.com/overview/documentation) all well designed APIs and I suggest you read up on how stripe moved their API to golang ![How stripe moved to golang]()
Lets get started.

### Web server

Assuming Go is installed, the below code is a basic web server

```go
package main

import (
  "fmt"
   "net/http"
  )

func main() {

  http.HandleFunc("/", HandlerOne)  
  http.ListenAndServe(":3000", nil)

  fmt.Println("[x] Started HTTP Server")


}

  func HandlerOne(w http.ResponseWriter, r *http.Request) {
    fmt.Println("Hello world!")
  }

```

Thats it, fire up a terminal, `touch app.go`, copy paste the code and `go run app.go` then open up another terminal tab and `cURL localhost:3000` to see the server printing hello world.
Notice that we are using **net/http** from the standard library.

### Http request multiplexer

There are a lot of routers out there. But we will be using [pat](github.com/bmizerany/pat) , a light weight sinatra styled mux which works with net/http.
Other alternatives are [gorilla mux]("github.com/gorilla/mux") and route.

```go
package main


import (
"net/http"
"github.com/bmizerany/pat"
"log"
)


const (
  AcctCreate = "/accounts"
  AcctShow = "/accounts/:email"
)

func main() {

  mux := pat.New()

  mux.Post(AcctCreate, http.HandlerFunc(Post))
  mux.Get(AcctShow, http.HandlerFunc(Show))

http.Handle("/", mux)
log.Println("[x] - Starting the server")
http.ListenAndServe(":8000", nil)
log.Println("Listening..")

}

```
As you can see, the above code is similar to the one we saw before, but here we are using the [pat](github.com/bmizerany/pat) package which under the covers does patten matching and gives more flexibility for routing. We just initialize pat, pick the http method and provide patten and the handler. I have another go file with the same package name containing the Post and Show functions which is not visible here. You can get the code here [twine-api](https://github.com/morpheyesh/twine-api)

Catch you soon with more interesting posts on golang's concurrency.
