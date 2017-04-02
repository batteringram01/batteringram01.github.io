---
layout: post
title: "Docker clustering with Swarm"

meta:
  nav: blog
  author: morpheyesh
  pygments: true
  mathjax: true
---

### Quick intro to swarm

There is quite a bit happening in the docker world with dockercon 2015 which was a huge success that happened last month, with Microsoft, IBM and other huge companies backing docker and much more.

<!-- more -->

There is one interesting project that the docker folks are working on is its clustering service called [swarm](https://github.com/docker/swarm), still in its beta stage and definitely not production ready, the project is picking up some heat, becoming ready to be integrated with apache mesos.

In this post, we will get started with swarm, one good thing about swarm is that, it serves the standard Docker API, so if there is any tool that already communicates with the standard docker API can use swarm to scale up easily.

### Setting up docker swarm cluster

The first step is to install docker(like duh!) on all your hosts. If you just want to try out docker swarm , I suggest you spin up couple of instances to try it out.

First things first,

    $sudo apt-get update

    $sudo apt-get install linux-image-generic-lts-trusty

    $wget -qO- https://get.docker.com/ | sh

*NOTE: Check docker site for latest & more stable version of docker*

We are going to be needing a master and one or more nodes.

* <b>Master</b> -  contains the swarm master
* <b>Node(s)</b> - minimal host(s) with docker engine installed


### Discovery

Swarm uses discovery mechanism to keep track of all the nodes that are connected to the cluster. There are multiple options

* etcd
* consul
* zookeeper

but swarm also provides a default token based discovery which we will be using now.
( I suggest you use etcd or zookeeper for better performance if at all you are using swarm in prod)


Alright, lets get started. Once you have installed docker, run docker in detached modes.

If your docker service is running already then, stop it by

```bash
$sudo service docker stop
```

Start it in detached mode on all your node(s)

```bash
$docker -H <nodeIP>:2375 -d
```

You should see something like this


    morpheyesh@morpheyesh-laptop:~/blog/morpheyesh.github.io$ sudo docker -H 192.168.1.7:2375 -d
    WARN[0000] /!\ DON'T BIND ON ANY IP ADDRESS WITHOUT setting -tlsverify IF YOU DON'T KNOW WHAT YOU'RE DOING /!\
    INFO[0000] Listening for HTTP on tcp (192.168.1.7:2375)
    INFO[0000] [graphdriver] using prior storage driver "aufs"
    WARN[0000] Running modprobe bridge nf_nat failed with message: , error: exit status 1
    WARN[0000] Your kernel does not support swap memory limit.
    INFO[0000] Loading containers: start.
    ..
    INFO[0000] Loading containers: done.
    INFO[0000] Daemon has completed initialization
    INFO[0000] Docker daemon                                 commit=0baf609 execdriver=native-0.2 graphdriver=aufs version=1.7.0

Let us install the <b>swarm master</b>. Clone it into your Go folder and go install it to build the binary. Swarm can also be run as a container but here we are running it as a daemon and not as a container.

    $git clone https://github.com/docker/swarm

*Note: Please follow the instructions on the readme of the swarm repo to build & install swarm binary*

Let us create a swarm token to connect the hosts.

```bash
$swarm create
    //copy the token that just got generated
```
Starting the swarm master
```bash
$swarm manage -H tcp://<masterIP>:2375 token://<generated token>
```

Joining the node(s)

```bash
$swarm join --addr=Node1IP:2375 token://<generated token>
    //make sure you join all your node(s)
```

You could see the nodeIPs getting printed on swarm master logs.

Now we are connected and the cluster is ready to go. You can make any docker api calls
to the masterIP as the endpoint to use the cluster.


Simple example to create a container using docker API on swarm cluster

```go
    //create client with the endpoint
    client,_ := docker.NewClient("192.168.1.7:2375")
    options = docker.CreateContainerOptions{Name: "Tame Impala", Config: &config}

    //creating a new container
    container, err := client.CreateContainer(options)
```

There are many mature docker clustering solutions present today like kubernetes etc, but eagerly looking forward to know what would happen and how docker is planning to place swarm.
