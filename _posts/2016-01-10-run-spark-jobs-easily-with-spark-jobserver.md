---
layout: post
title: "Deploying spark jobs with Spark Job Server"

meta:
  nav: blog
  author: morpheyesh
  pygments: true
  mathjax: true
---


In this blog post I am going to quickly talk about this kickass project that was opensourced by the folks at [Ooyala]("https://ooyala.com") called [spark-jobserver]("htps://github.com/spark-jobserver/spark-jobserver"), SJS in short is used to create, submit, run, monitor and delete spark data files, jobs, job contexts and JARs, Tracking and serializing jobs progress, status and results becomes super simple. This provides a RESTful layer to interact with any spark cluster and it also supports YARN and MESOS, so this in my opinion is almost production ready.  
We will look at how to set up a spark-jobserver and submit a job and execute it locally. I am writing one more post on performing sql queries for structured data processing using SQLContext, DataFrames API and such.
<!-- more -->

***NOTE: I am going to run spark-jobserver in dev mode and if you want to deploy in production or so, use the scripts given in the spark-jobserver example repo on github***

### Running spark-jobserver locally

Clone the project and cd into spark-jobserver

```
export VER=`sbt version | tail -1 | cut -f2`
```

Then, run `sbt`

```
>reStart
```

You can then see your spark-jobserver fired-up and running. Go to localhost:8090 for the UI

### Deploying a JAR to run a spark job

In order to run a spark job, the JAR needs to be built and submitted to the `/jars` endpoint
To start with, we can just run the wordcount example..you will find it (here)[https://github.com/spark-jobserver/spark-jobserver/blob/master/job-server-tests/src/spark.jobserver/WordCountExample.scala]

```scala
object WordCountExample extends SparkJob {
  def main(args: Array[String]) {
    val sc = new SparkContext("local[4]", "WordCountExample")
    val config = ConfigFactory.parseString("")
    val results = runJob(sc, config)
    println("Result is " + results)
  }

  override def validate(sc: SparkContext, config: Config): SparkJobValidation = {
    Try(config.getString("input.string"))
      .map(x => SparkJobValid)
      .getOrElse(SparkJobInvalid("No input.string config param"))
  }

  override def runJob(sc: SparkContext, config: Config): Any = {
    sc.parallelize(config.getString("input.string").split(" ").toSeq).countByValue
  }
}
```

Notice the object which implements the SparkJob trait? It should have a validate method and a runJob method which contains the implementation of the job. The validate method just checks whether it is fit to continue and returns an exception.
You can take a look at the Business Intelligence tool that I am currently building at megam called (meglyticsBI)[https://github.com/megamsys/meglyticsBI-core] which involves the process of connecting to multiple data sources, both structured and unstructured to fetch and perform analytics. It is still under heavy development.

We need to build a jar to push it to spark-jobserver, let us build one.

```
sbt job-server-tests/package
```

You will have a jar built, just push it to SJS
```
curl --data-binary @job-server-tests/target/scala-2.10/job-server-tests.jar localhost:8090/jars/myfirstjar
```

Now, all we need to do is submit the jar to the SJS to the '/jobs' endpoint with the name of the jar, that is *myfirstjar* and the classPath.

```
curl -d "input.string = bo au hy la" 'localhost:8090/jobs?appName=myfirstjar&classPath=spark.jobserver.WordCountExample'
```

It will create its own SparkContext and execute the job and return the result back to you with an JobID.
You can use the jobID to check the status and result.

```
curl localhost:8090/jobs/23232g99-12323hhvvauu-asdf-fdfddd233
```

To do a proper deployment, you can find scripts which will help you deploy in ec2 or any other cloud. You need to setup a xyz.conf and xyz.sh and execute the `./server_deploy.sh xyz`.

Hope this article was helpful.
