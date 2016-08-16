---
layout: post
author: Sean
email: smprotocol@gmail.com
title: "Apache Spark with Avro on S3"
synopsis: "Example code that demonstrates how to get Apache Spark, Apache Avro and Amazon S3 all working together smoothly in EC2."
comments: true
image: /images/avro-code.png
---

Apache Spark, Avro, on Amazon EC2 + S3
======================================


Deploying Apache Spark into EC2 has never been easier using [spark-ec2](https://github.com/amplab/spark-ec2) deployment scripts or with [Amazon EMR](https://aws.amazon.com/emr/), which has builtin Spark support. However, I found that getting Apache Spark, Apache Avro and S3 to all work together in harmony required chasing down and implementing a few technical details.

There were various online sources that helped me assemble all the bits I needed together, but none of them had everything required in a single place, or the information was based off deprecated APIs.  So I figured I'd drop all the required pieces here and provide a working example.

My particular need was to read/write a few Terabytes of Avro files to and from S3.  For the curious, there are a few reasons I chose not to use [Apache Parquet](https://parquet.apache.org/) or [Apache ORC](https://orc.apache.org/):

* Kafka parts of the stack are already using Avro
* Columnarizing the data incurs additional cost (cpu)
* For my specific purpose, I wouldn't get to enjoy the benefits of columnar storage. The jobs that I'm running are not useful unless all the data for a record is present during the map phase.


Avro Hadoop Input/Output Formats
--------------------------------

The first step on our journey is determing what Hadoop formats to use, and configuring Spark to use them.  Hadoop input/output formats are specified using a key/value pairs. For my usecase all the information I need is encompased in our Avro record.  So to describe this in Spark we can use newAPIHadoopFile (reading) and saveAsNewAPIHadoopFile (writing) in the following way:

{% highlight scala %}
// read Avro
val conf = sc.hadoopConfiguration
conf.set("avro.schema.input.key", schema.toString)
val rdd = sc.newAPIHadoopFile("s3a://key:secret@my-bucket/path/to/data",
  classOf[AvroKeyInputFormat[MyAvroRecord]],
  classOf[AvroKey[MyAvroRecord]],
  classOf[NullWritable],
  conf
)


// write Avro
val job = Job.getInstance()
AvroJob.setOutputKeySchema(job, schema)
rdd.saveAsNewAPIHadoopFile(
  "s3a://key:secret@my-bucket/path/to/data",
  classOf[AvroKey[MyAvroRecord]],
  classOf[NullWritable]
  classOf[AvroKeyOutputFormat[MyAvroRecord]], // changes to AvroDirectKeyOutputFormat (see below)
  job.getConfiguration
)
{% endhighlight %}




Efficiently writing to Amazon S3 using Spark
--------------------------------------------

Files in hadoop are normally written into a temporary location and then atomically renamed when the job completes. This is performed by some implementation of Hadoops' OutputCommitter interface (generally FileOutputCommitter).

Unfortunately, when using S3 there are performance and consistency issues renaming files, unlike with HDFS.  To make this more efficient and safe for EC2+S3 we can override this behavior by implementing our own OutputComitter. Doing so also requires us to implement our own OutputFormat that uses our custom comitter.


{% highlight scala %}

// Avro requires a FileOutputCommitter, so in order to use the DirectOutputCommitter
// we have to extend and override functionality in FileOutputCommitter.
class DirectFileOutputCommitter(
  outputPath: Path,
  context: JobContext
) extends FileOutputCommitter(outputPath, context) {
  override def isRecoverySupported: Boolean = true
  override def getCommittedTaskPath(context: TaskAttemptContext): Path = getWorkPath
  override def getCommittedTaskPath(appAttemptId: Int, context: TaskAttemptContext): Path = getWorkPath
  override def getJobAttemptPath(context: JobContext): Path = getWorkPath
  override def getJobAttemptPath(appAttemptId: Int): Path = getWorkPath
  override def needsTaskCommit(taskAttemptContext: TaskAttemptContext): Boolean = true
  override def getWorkPath: Path = outputPath
  override def commitTask(context: TaskAttemptContext, taskAttemptPath: Path): Unit = {
    if(outputPath != null) {
      context.progress()
    }
  }
  override def commitJob(jobContext: JobContext): Unit = {
    val conf = jobContext.getConfiguration
    val shouldCreateSuccessFile = jobContext
      .getConfiguration
      .getBoolean("mapreduce.fileoutputcommitter.marksuccessfuljobs", true)
    if (shouldCreateSuccessFile) {
      val outputPath = FileOutputFormat.getOutputPath(jobContext)
      if (outputPath != null) {
        val fileSys = outputPath.getFileSystem(conf)
        val filePath = new Path(outputPath, FileOutputCommitter.SUCCEEDED_FILE_NAME)
        fileSys.create(filePath).close()
      }
    }
  }
}

// just like AvroKeyOutputFormat, but it enables our direct file committer
class AvroDirectKeyOutputFormat[T] extends AvroKeyOutputFormat[T] {
  private var committer: DirectFileOutputCommitter = null
  override def getOutputCommitter(context: TaskAttemptContext): OutputCommitter = {
    synchronized {
      if (committer == null)
        committer = new DirectFileOutputCommitter(FileOutputFormat.getOutputPath(context), context)
      committer
    }
  }
}

{% endhighlight %}


Enabling Kryo with Avro
-----------------------

The next hurdle to jump through is getting everything working with Kryo. This is something very important and should not be neglected! Enabling Kryo drastically improves performance (10x according to the [Spark tuning docs](http://spark.apache.org/docs/latest/tuning.html)).  In fact, when developing Spark applications I always set `spark.kryo.registrationRequired = true` so that I am absolutely sure there aren't classes flying under the radar.

Figuring out how to get Avro, Spark, and Kryo working together was a bit tricky to track down. The gist is that it requires using a custom Kryo Registrator which explicitly designates a Kryo serializer to use for Avro objects. Specifying this just requires a few lines of boilerplate.

I whipped up a generic serialization wrapper class to make the registration of many Avro types easier, example is as follows:


{% highlight scala %}
object MyRegistrator {
  // this is required for avro to function properly
  class AvroSerializerWrapper[T <: SpecificRecord : Manifest] extends Serializer[T] {
    val reader = new SpecificDatumReader[T](manifest[T].runtimeClass.asInstanceOf[Class[T]])
    val writer = new SpecificDatumWriter[T](manifest[T].runtimeClass.asInstanceOf[Class[T]])
    var encoder = null.asInstanceOf[BinaryEncoder]
    var decoder = null.asInstanceOf[BinaryDecoder]
    setAcceptsNull(false)
    def write(kryo: Kryo, output: Output, record: T) = {
      encoder = EncoderFactory.get().directBinaryEncoder(output, encoder)
      writer.write(record, encoder)
    }
    def read(kryo: Kryo, input: Input, klazz: Class[T]): T = this.synchronized {
      decoder = DecoderFactory.get().directBinaryDecoder(input, decoder)
      reader.read(null.asInstanceOf[T], decoder)
    }
  }
}

class MyRegistrator extends KryoRegistrator {
  override def registerClasses(kryo: Kryo): Unit = {
    // register avro specific classes here
    kryo.register(classOf[MyAvroRecord], new AvroSerializerWrapper[MyAvroRecord])
  }
}
{% endhighlight %}


Reading Avro Files with Spark (plus one caveat)
-----------------------------------------------
One issue I ran into that left me scratching my head is that the Avro input format uses a reusable buffer.  There are many benefits to this, but in Spark you will end up with an iterator of objects that point to the same location.  This causes all sorts of strange reading behavior (seeing the same object multiple times, for instance).

The workaround for this if you don't want to worry about it is simple, just make a copy of the Avro object when reading.  I also took the liberty of creating an AvroUtil class to make reading/writing Avro files in Spark as simple as possible:


{% highlight scala %}
// save RDD to /tmp/data.avro
AvroUtil.write(
  path = "/tmp/data.avro",
  schema = MyAvroRecord.getClassSchema,
  directCommit = true, // set to true for S3
  compress = AvroCompression.AvroDeflate(), // enable deflate compression
  avroRdd = dataset // pass in out dataset
)

// read Avro file into RDD
val rddFromFile: RDD[MyAvroRecord] = AvroUtil.read[MyAvroRecord](
  path = "/tmp/data.avro",
  schema = MyAvroRecord.getClassSchema,
  sc = sc
).map(MyAvroRecord.newBuilder(_).build()) // clone after reading from file to prevent buffer reference issues
{% endhighlight %}



<img style="float: right;" src="/static-content/images/avro-schema.png" width="379" height="294" alt="running avro:schema" />

Soup to Nuts Example
--------------------



I pushed up an example project (Apache 2.0 License) to GitHub that puts together all the required pieces into this repository: [https://github.com/subprotocol/spark-avro-example](https://github.com/subprotocol/spark-avro-example).

[SparkAvroExample.scala](https://github.com/subprotocol/spark-avro-example/blob/master/src/main/scala/com/subprotocol/SparkAvroExample.scala) contains the class main that you can run to see it in action.  To compile it (or if you make changes to [MyAvroRecord.avsc](https://github.com/subprotocol/spark-avro-example/blob/master/src/main/avro/MyAvroRecord.avsc)) you may need to run the avro:schema Plugin.
