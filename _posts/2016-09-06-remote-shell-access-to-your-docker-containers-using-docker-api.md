---
layout: post
title: "Docker development - Remote shell access to your docker containers using docker API"

meta:
  nav: blog
  author: morpheyesh
  pygments: true
  mathjax: true
---


Localhost doesn't really feel home these days, especially with lots of *things* thats going around the developer automation space, koding became an open source company, GitLabCI looks promising, there are gazillion open source orchestration tools,  I'm seriously contemplating moving my entire development workspace to the cloud(give your thoughts in comments). Besides, baremetal servers are cheap too. Anyways, I will write a detailed post on how that went, for now we'll talk about building a tool or extending an existing docker tool to support remove shell access using the docker API.

<!--more-->


## Why??

Many organizations use docker, many even use it in production, most of them use it for development and testing, all have their own orchestration tool which deals with provisioning docker containers on the cloud. You might use swarm or kubernetes for docker clustering to manage nodes and might use corresponding CLI that talks to your remote docker platform for it to do the needful.

Many times you would want to gain shell access to the remote containers for a lot of reasons, like import/export of database dump from service containers, setting up envs, etc.


But it just doesn't end there, this is really helpful when you have all your development happening remotely, Imagine this, you do not have to install all the language runtimes, you do not have to go through the pain of maintaining versions and working with differnet version managers, just keep them as images and all you need is a docker orchestration platform running on your remote server and a cli to perform all docker operations, you are good to go.

Infact you can even have droneCI set on your docker instance and a git push does the magic, docker containers are ephemeral in nature, we are leveraging it to the fullest.

We will look into building a golang server and client with which can be the base for you to extend and build you own tool

***Note: 99% of the operation are covered by docker API itself***


##Approach

Let us call this project `whale`,  the server as `whale-server`(pardon my lack of ability to come up with a better name) and obviously the cli as `whale-cli`. We will be using websocket and establish a connection from the terminal to the container and that is how we get the shell access.
On the server side, we have a websocket handler, pass the websocket object as stdin, stdout and stderr to docker's `Exec`. On the client side, we do a simple `io.copy`. Lets get started..


```go

createExecOpts := docker.CreateExecOptions{
  AttachStdin:  true,
  AttachStdout: true,
  AttachStderr: true,
  Cmd:          commands,
  Container:    ContainerID,
  Tty:          true,
}

```
Above createExecOption object is created with attach stdin, stdout and stderr set to true. `commands` are the commands you want to execute during the `exec` call


NOTE: You can ssh into your container just fine with <hostIP>:<containerPort> provided the container port is exposed. This is just an enchancement you could make to your docker tool which has the right auth mechanism in place. Also it is not a good practice to expose port especially if you are using service containers to test.



##Setting up the websocket handler:

Google on how to setup a basic golang server. Let us include the websocker handler, use  `"golang.org/x/net/websocket"`, makes it a lot easier to work with the standard library.

```go

func main() {
  //define other handlers
	http.Handle("/1.0/shell", websocket.Handler(shellHandler))
	http.ListenAndServe(listen, nil) //listen is a var with address to bind. ex: 0.0.0.0:8080
}


```

Now that you have the routes set, we need to define the shellHandler.

##Interacting with the docker API - Shell access

fsouza's dockerClient is probably the best(and only) go docker client that is out there in the wild. Using the client we need to first create an instance, then create a new Exec and start it.

###Create a NewExec

Once you create a new docker client, make sure to point your docker engine or swarm endpoint. Create a new exec with the previously initialized `createExecOption`, and then start pass the `startExecOptions` with stdin, stdout and stderr.


```go
client, err := docker.NewClient(dockerHost)
if err != nil {
  return err
}


exec, err := client.CreateExec(createExecOption)
if err != nil {
  return err
}

startExecOptions := docker.StartExecOptions{
  InputStream:  stdin,
  OutputStream: stdout,
  ErrorStream:  stderr,
  Tty:          true,
  RawTerminal:  true,
}
err := make(chan error, 1)
go func() {
  errs <- client.StartExec(exec.ID, startExecOptions)
}()
execInfo, err := client.InspectExec(exec.ID)
for !execInfo.Running && err == nil {
  select {
  case startErr := <-err:
    return startErr
  default:
    execInfo, err = client.InspectExec(exec.ID)
  }
}

```

We wrap the `StartExec` in a goroutine along with it we create a buffered channel and using the `select` statement we listen on the channel for errors, keeping the goroutine alive. Good, now that we have the server side all set, let us look into the client side.


##Client side - Using the I/O package

It is no surprise that we'd be using the Go's IO package, which is one of the most fundamental packages of Go's standard library. Go plays well with bytes in any form - streams, invidivual bytes etc. The two basic operations when working with bytes are reading & writing.


###Reader interface

```go
type Reader interface {
        Read(p []byte) (n int, err error)
}
```
The reader interface wraps the basic read method, read reads up bytes and returns an n bytes read and an EOF if it fails. `MultiReader` and `TeeReader` are powerful in dealing with multiple reads.

###Writer interface

```go
type Writer interface {
        Write(p []byte) (n int, err error)
}
```

This is similar to the Reader interface, writer writes bytes. `Multiwriter` can be used when you need multiple sinks. You can find more information on the go documentation. Coming to think of it, I will write a another post explaining the various caveats of reading and writing byte streams in golang, it is a huge and interesting topic. For now, let us focus on finishing up our CLI.

###Copy 'em all

Create a websocket connection, cfg returns a 'websocker.NewConfig' object.

```go
conn, err := websocket.DialConfig(cfg)
if err != nil {
  return err
}
defer conn.Close()

```

Go's defer is so convenient and one of my favs. We use `io.Copy` to copy from src and dst. Let us see how the basic `io.Copy` works,

```go
func  main() {
  r :=  strings.NewReader("booyah") //create a new reader
  if _, err := io.Copy(os.Stdout, r); err != nil { //see?
               log.Fatal(err)
       }
}
```

io.Copy takes a Writer and a Reader, the above example is of no big deal, you can find it in the documentation, but how exactly are we going to keep a persistant connection and perform commands inside my docker over the network?
Righty, I am going to give an admittedly stupid example, let us modify the above code a bit..

```go
func main() {
  q := make(chan bool) //create a go routine
  go func() {
    defer close(q) //beaut!
    if _, err := io.Copy(os.Stdout, os.Stdin); err != nil {
      log.Fatal(err)
    }
  }()
<-q  //wait for the goroutine to die
}
```

Now, if you run it in terminal you'd see this..

**NOTE: Asciicinema uses io to record your video, it doesn't record the video like say, kazam**

Now, coming to your docker implementation, in order to interact with the container, pass the websocket object as Writer and Reader like this.

```go

go io.Copy(conn, os.Stdin)
go func() {
  defer close(done)
  _, err := io.Copy(context.Stdout, conn)
  if err != nil && err != io.EOF {
    errs <- err
  }
}()
<-done
return <-errs

```

##End
I guess that is it, I will try to cook up a simple server and client and share the code on github when I find time. I'm currently building tools that would help me move my dev environment completely to the cloud. I'm planning on Chrome Book + GalliumOS + baremetal server + docker tools(orchestrators) + ofcourse, Docker! Hope the post was helpful.

until next time.
