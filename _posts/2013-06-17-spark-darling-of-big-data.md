---
layout: post
author: Sean
email: smprotocol@gmail.com
title: Spark, Darling of Bigdata
synopsis: "Introduction to Spark, a powerful and fast real-time map/reduce framework."
comments: true
image: /images/spark.png
disqus_url: http://subprotocol.com/2013/06/17/spark-darling-of-big-data.html
---


# Spark, the Darling of Big Data

<img style="float: right;" src="/static-content/images/spark.png" width="127" height="67" alt="Spark project logo" />


[Spark](http://spark-project.org/) is a new up-and-coming open source distributed computing framework from the UC Berkeley [AMPLab](https://amplab.cs.berkeley.edu/).  By using a clever abstraction called an RDD (resilient distributed dataset), it is able to very elegantly unify the batch and streaming worlds into a single comprehensive framework.


<img style="float: right;" src="/static-content/images/spark-workflow.png" width="405" height="282" alt="Spark driver workflow" />


Originally built to solve distributed machine learning problems, Spark has quickly proven to also be the Swiss-Army knife of Bigdata. Companies latching onto the Bigdata movement are able to store mounds of data, but are still stuck with one very perplexing problem: extracting business intelligence is extremely difficult, even with existing tools that sit on top of Hadoop.  Spark helps solve this conundrum by providing a very rich, accessible, and expressive API that makes working with Bigdata a breeze.


<!-- more -->


Resilient Distributed Datasets (RDDs)
-------------------------------------

An RDD can be thought of as a handle to a distributed dataset, with fragments of the data spread all around the cluster.  Instead of relying on replication to make datasets reliable, Spark instead tracks lineage and leverages checkpointing. This allows more cluster resources to go directly toward your computations.  If the cost to recover data is high you can also selectively employ replication on any dataset.

More information about how RDDs works and the research behind Spark can be found on the projects website: [http://spark-project.org/research/](http://spark-project.org/research/)


Scala
-----

The codebase for Spark is Scala, but Java and Python APIs are also provided. What really sets Spark apart from other batch and streaming frameworks is the sheer ease with which computations can be constructed.  Scala is a big enabler of this and provides the perfect blend of type-safety, a clean closure syntax, and in a functional paradigm.

It is somewhat difficult to convey the expressive power that Spark brings to your fingertips with words alone, so here is a small example to give you a taste:


#### Wordcount from HDFS

{% highlight scala %}

// load sentences out of HDFS
val data = spark.textFile("hdfs://hadoop-namenode:8020/sentences.txt")

// convert sentences to words and count each word
val wordCount = data.flatMap(_.split(" ")).map(_ -> 1).reduceByKey(_ + _)

// print number of sentences
println(data.count)

// print number of unique words
println(wordCount.count)

// print top 10 words to console
wordCount.map(_.swap).sortByKey(false).take(10).foreach(println)

{% endhighlight %}


Ecosystem Interoperability
--------------------------

Out of the box Spark can interface with HDFS, HBase and Cassandra.  Spark Streaming interfaces with Kafka, Flume, Akka, 0MQ, and raw text sockets.  There is also full support for Hadoops InputFormats (both new and old hadoop APIs). So if you would like to read/write data to HBase, that is very easy to do:


#### Read data from HBase

{% highlight scala %}

// create configuration
val config = HBaseConfiguration.create()
config.set("hbase.zookeeper.quorum", "localhost")
config.set("hbase.zookeeper.property.clientPort","2181")
config.set("hbase.mapreduce.inputtable", "hbaseTableName")

// read data
val hbaseData = sparkContext.hadoopRDD(new JobConf(config), classOf[TableInputFormat], classOf[ImmutableBytesWritable], classOf[Result])

// count rows
println(hbaseData.count)

{% endhighlight %}



Spark Streaming
---------------

With underpinnings utilizing the RDD abstraction, Spark Streaming differs from other CEP (complex event processing) frameworks such as
 [Storm](https://github.com/nathanmarz/storm/wiki)/[Trident](https://github.com/nathanmarz/storm/wiki/Trident-tutorial), which are event based in nature. This is what allows Spark to blend together the batch and streaming worlds reliably and seamlessly.

Spark Streaming jobs also look syntactically no different than Spark batch jobs. Additional methods are provided to make windowed operations easy.


Unlike higher-level streaming frameworks such as Trident&mdash;which carry along lots of syntactic cruft&mdash;Spark presents you with a very clean interface with minimal boilerplate.

#### Streaming Word Count

{% highlight scala %}

// streaming wordcount
val inputStream = ssc.socketTextStream("some-host", 2134)
inputStream.flatMap(_.split(" ")).map(_ -> 1).reduceByKeyAndWindow(_ + _).print

{% endhighlight %}



Where go go from here
---------------------

An excellent place to dive in is by viewing the examples on github:

* [Spark examples](https://github.com/mesos/spark/tree/master/examples/src/main/scala/spark/examples)
* [Spark Streaming examples](https://github.com/mesos/spark/tree/master/examples/src/main/scala/spark/streaming/examples)


An interactive shell is also included with Spark, so you don't even need to setup a project to get started.  Just start typing code into a prompt locally and you can immediately see it run. For details see:

* [http://spark-project.org/docs/latest/quick-start.html](http://spark-project.org/docs/latest/quick-start.html)



Looking Forward
---------------

Just recently it was announced that Spark will be moving to the ASF (See: [Spark Proposal](http://wiki.apache.org/incubator/SparkProposal)) where the project will no-doubt find a good home.  There has been lots of contribution activity over the last few months, with many performance improvements and feature enhancements going into the project.

Here are some other interesting projects that are already being built on top of Spark:

* [Shark](https://github.com/amplab/shark/wiki): Suped-up port of Hive that runs on Spark.
* [Bagel](https://github.com/mesos/spark/wiki/Bagel-Programming-Guide): An implementation of Google's [Pregel](http://dl.acm.org/citation.cfm?id=1807184) graph processing framework.


