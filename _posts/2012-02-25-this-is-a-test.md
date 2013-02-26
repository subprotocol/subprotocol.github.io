---
layout: post
title: The Circle
synopsis: Need some nice filler text in this spot blah ok need to see how it looks when it wraps
---
Me, just kicking the tires.


And so we begin
===============

Lorem ipsum dolor sit amet, *consectetur adipiscing elit*. Re mihi non aeque satisfacit, **et quidem** locis pluribus. Quamvis enim depravatae non sint, pravae tamen esse possunt. Sin aliud quid voles, postea. Ergo adhuc, [quantum equidem](http://subprotocol.com/) intellego, causa non videtur fuisse mutandi nominis. Duo Reges: constructio interrete. Itaque hic ipse iam pridem est reiectus;


Code Snippit
------------

Ergo adhuc, quantum equidem intellego, causa non videtur fuisse mutandi nominis. Duo Reges: constructio interrete. Itaque hic ipse iam pridem est reiectus;

{% highlight scala %}
class SparkContext(
    val master: String,
    val appName: String,
    val sparkHome: String = null,
    val jars: Seq[String] = Nil,
    val environment: Map[String, String] = Map())
  extends Logging {

  // Ensure logging is initialized before we spawn any threads
  initLogging()

  // Set Spark driver host and port system properties
  if (System.getProperty("spark.driver.host") == null) {
    System.setProperty("spark.driver.host", Utils.localIpAddress)
  }
  if (System.getProperty("spark.driver.port") == null) {
    System.setProperty("spark.driver.port", "0")
  }
}
{% endhighlight %}

Tubulum fuisse, qua illum, cuius is condemnatus est rogatione, P. Quo plebiscito decreta a senatu est consuli quaestio Cn. Ergo id est convenienter naturae vivere, a natura discedere. Estne, quaeso, inquam, sitienti in bibendo voluptas? Ut proverbia non nulla veriora sint quam vestra dogmata. Et quidem, inquit, vehementer errat; Ratio enim nostra consentit, pugnat oratio.

    if (true) {
        print "weeee";
        print "yes";
    }
    


> This is a test to see how this text looks when it is in a blockquote. Hoc sic expositum dissimile est superiori. Quaesita enim virtus est, non quae relinqueret naturam, sed quae tueretur.

<cite>Someone Wise</cite>

----------

Venit enim mihi Platonis in mentem, quem accepimus primum hic disputare solitum; Occultum facinus esse potuerit, gaudebit; Hoc etsi multimodis reprehendi potest, tamen accipio, quod dant.


Something else
--------------

1.   Tubulum fuisse, qua illum, cuius is condemnatus est rogatione, P. Quo plebiscito decreta a senatu est consuli quaestio Cn.

        if (true)
            print "yes";

2. Re mihi non aeque satisfacit, et quidem locis pluribus. Quamvis enim depravatae non sint, pravae tamen esse possunt.
3. Ut proverbia non nulla veriora sint quam vestra dogmata. Et quidem, inquit, vehementer errat; Ratio enim nostra consentit, pugnat oratio.	