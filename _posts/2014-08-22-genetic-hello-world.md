---
layout: post
author: Sean
email: smprotocol@gmail.com
title: "Genetic.js Hello World"
synopsis: "The Hello World of Genetic Algorithms is a simple phrase solver. While useless in terms of utility, it is probably the simplest way to understand this class of algorithm."
comments: true
image: /images/genetic-hello-world.png
---

<script src="/js/genetic-0.1.12.min.js"></script>

# Genetic Algorithm Hello World

The _Hello World of Genetic Algorithms_ is a simple phrase solver.  While useless in terms of utility, it is probably the simplest way to understand this class of algorithm.


## How it Works

Entities in this system start out as randomly generated strings (See `genetic.seed = function()` below).  At each iteration a portion of entites are selected for mutation.  Another portition is selected for crossover (aka. mating).  From there you let the system run and watch it converge on a solution, there isn't much more to it than that!


### Mutation

When an entity (string) is selected for mutation, a character in a random location is either increased or decreased by one lexicographically. See `genetic.mutate = function(entity)` below for code.



### Crossover

In Genetic.js crossover **always** results in two children from from two parents.  In this simulation we implement [two-point crossover](http://en.wikipedia.org/wiki/Crossover_\(genetic_algorithm\)#Two-point_crossover). See `genetic.crossover = function(mother, father)` below.


### Fitness

The phrase solver demo scores entities (strings) by how close they are to the goal.  The formula is simple, add one for each character that matches. Also add fractional points if it is close.  The result is a floating point number, the larger the better.  See `genetic.fitness = function(entity)` for implementation.
	


## Phrase Solver Demo

Refer to [/system/genetic-js.html](/system/genetic-js.html) for all the configuration/options that are available. The code can be cloned from [https://github.com/subprotocol/genetic-js](https://github.com/subprotocol/genetic-js).

<textarea id="quote" style="width: 300px; height: 100px;">Insanity is doing the same thing over and over again and expecting different results</textarea>

<button id="solve">Solve</button>

<table id="results">
	<thead>
		<tr>
			<th>Generation</th>
			<th>Fitness</th>
			<th>Solution</th>
		</tr>
	</thead>
	<tbody style="font-family: monospace;">
		<tr>
			<td colspan="3">Press 'Solve' Button to begin.</td>
		</tr>
	</tbody>
</table>

<script>

var genetic = Genetic.create();

genetic.optimize = Genetic.Optimize.Maximize;
genetic.select1 = Genetic.Select1.Tournament2;
genetic.select2 = Genetic.Select2.Tournament2;

genetic.seed = function() {

	function randomString(len) {
		var text = "";
		var charset = "abcdefghijklmnopqrstuvwxyz0123456789";
		for(var i=0;i<len;i++)
			text += charset.charAt(Math.floor(Math.random() * charset.length));
		
		return text;
	}
	
	// create random strings that are equal in length to solution
	return randomString(this.userData["solution"].length);
};

genetic.mutate = function(entity) {
	
	function replaceAt(str, index, character) {
		return str.substr(0, index) + character + str.substr(index+character.length);
	}
	
	// chromosomal drift
	var i = Math.floor(Math.random()*entity.length)		
	return replaceAt(entity, i, String.fromCharCode(entity.charCodeAt(i) + (Math.floor(Math.random()*2) ? 1 : -1)));
};

genetic.crossover = function(mother, father) {

	// two-point crossover
	var len = mother.length;
	var ca = Math.floor(Math.random()*len);
	var cb = Math.floor(Math.random()*len);		
	if (ca > cb) {
		var tmp = cb;
		cb = ca;
		ca = tmp;
	}
		
	var son = father.substr(0,ca) + mother.substr(ca, cb-ca) + father.substr(cb);
	var daughter = mother.substr(0,ca) + father.substr(ca, cb-ca) + mother.substr(cb);
	
	return [son, daughter];
};

genetic.fitness = function(entity) {
	var fitness = 0;
	
	var i;
	for (i=0;i<entity.length;++i) {
		// increase fitness for each character that matches
		if (entity[i] == this.userData["solution"][i])
			fitness += 1;
		
		// award fractions of a point as we get warmer
		fitness += (127-Math.abs(entity.charCodeAt(i) - this.userData["solution"].charCodeAt(i)))/50;
	}

	return fitness;
};

genetic.generation = function(pop, generation, stats) {
	// stop running once we've reached the solution
	return pop[0].entity != this.userData["solution"];
};

genetic.notification = function(pop, generation, stats, isFinished) {

	function lerp(a, b, p) {
		return a + (b-a)*p;
	}
	
	var value = pop[0].entity;
	this.last = this.last||value;
	
	if (pop != 0 && value == this.last)
		return;
	
	
	var solution = [];
	var i;
	for (i=0;i<value.length;++i) {
		var diff = value.charCodeAt(i) - this.last.charCodeAt(i);
		var style = "background: transparent;";
		if (diff > 0) {
			style = "background: rgb(0,200,50); color: #fff;";
		} else if (diff < 0) {
			style = "background: rgb(0,100,50); color: #fff;";
		}

		solution.push("<span style=\"" + style + "\">" + value[i] + "</span>");
	}
	
	var buf = "";
	buf += "<tr>";
	buf += "<td>" + generation + "</td>";
	buf += "<td>" + pop[0].fitness.toPrecision(5) + "</td>";
	buf += "<td>" + solution.join("") + "</td>";
	buf += "</tr>";
	$("#results tbody").prepend(buf);
	
	this.last = value;
};


$(document).ready(function () {
	$("#solve").click(function () {
		
		$("#results tbody").html("");
		
		var config = {
			"iterations": 4000
			, "size": 250
			, "crossover": 0.3
			, "mutation": 0.3
			, "skip": 20
		};

		var userData = {
			"solution": $("#quote").val()
		};

		genetic.evolve(config, userData);
	});
});

</script>



#### Code


{% highlight javascript linenos %}

var genetic = Genetic.create();

genetic.optimize = Genetic.Optimize.Maximize;
genetic.select1 = Genetic.Select1.Tournament2;
genetic.select2 = Genetic.Select2.Tournament2;

genetic.seed = function() {

	function randomString(len) {
		var text = "";
		var charset = "abcdefghijklmnopqrstuvwxyz0123456789";
		for(var i=0;i<len;i++)
			text += charset.charAt(Math.floor(Math.random() * charset.length));
		
		return text;
	}
	
	// create random strings that are equal in length to solution
	return randomString(this.userData["solution"].length);
};

genetic.mutate = function(entity) {
	
	function replaceAt(str, index, character) {
		return str.substr(0, index) + character + str.substr(index+character.length);
	}
	
	// chromosomal drift
	var i = Math.floor(Math.random()*entity.length)		
	return replaceAt(entity, i, String.fromCharCode(entity.charCodeAt(i) + (Math.floor(Math.random()*2) ? 1 : -1)));
};

genetic.crossover = function(mother, father) {

	// two-point crossover
	var len = mother.length;
	var ca = Math.floor(Math.random()*len);
	var cb = Math.floor(Math.random()*len);		
	if (ca > cb) {
		var tmp = cb;
		cb = ca;
		ca = tmp;
	}
		
	var son = father.substr(0,ca) + mother.substr(ca, cb-ca) + father.substr(cb);
	var daughter = mother.substr(0,ca) + father.substr(ca, cb-ca) + mother.substr(cb);
	
	return [son, daughter];
};

genetic.fitness = function(entity) {
	var fitness = 0;
	
	var i;
	for (i=0;i<entity.length;++i) {
		// increase fitness for each character that matches
		if (entity[i] == this.userData["solution"][i])
			fitness += 1;
		
		// award fractions of a point as we get warmer
		fitness += (127-Math.abs(entity.charCodeAt(i) - this.userData["solution"].charCodeAt(i)))/50;
	}

	return fitness;
};

genetic.generation = function(pop, generation, stats) {
	// stop running once we've reached the solution
	return pop[0].entity != this.userData["solution"];
};

genetic.notification = function(pop, generation, stats, isFinished) {

	function lerp(a, b, p) {
		return a + (b-a)*p;
	}
	
	var value = pop[0].entity;
	this.last = this.last||value;
	
	if (pop != 0 && value == this.last)
		return;
	
	
	var solution = [];
	var i;
	for (i=0;i<value.length;++i) {
		var diff = value.charCodeAt(i) - this.last.charCodeAt(i);
		var style = "background: transparent;";
		if (diff > 0) {
			style = "background: rgb(0,200,50); color: #fff;";
		} else if (diff < 0) {
			style = "background: rgb(0,100,50); color: #fff;";
		}

		solution.push("<span style=\"" + style + "\">" + value[i] + "</span>");
	}
	
	var buf = "";
	buf += "<tr>";
	buf += "<td>" + generation + "</td>";
	buf += "<td>" + pop[0].fitness.toPrecision(5) + "</td>";
	buf += "<td>" + solution.join("") + "</td>";
	buf += "</tr>";
	$("#results tbody").prepend(buf);
	
	this.last = value;
};


$(document).ready(function () {
	$("#solve").click(function () {
		
		$("#results tbody").html("");
		
		var config = {
			"iterations": 4000
			, "size": 250
			, "crossover": 0.3
			, "mutation": 0.3
			, "skip": 20
		};

		var userData = {
			"solution": $("#quote").val()
		};

		genetic.evolve(config, userData);
	});
});

{% endhighlight %}
