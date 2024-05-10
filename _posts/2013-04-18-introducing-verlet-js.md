---
layout: post
author: Sean
email: smprotocol@gmail.com
title: Introducing Verlet-JS
synopsis: An open source physics engine made for constructing 2D dynamic body simulations.
comments: true
image: /images/verlet-code.png
redirect_from: "/verlet-js/"
---

A framework for creating
========================

Particle meets constraint, and so [verlet-js](https://github.com/subprotocol/verlet-js) was born.


I was experimenting with code one evening and ended up accidentally stumbling onto a new playground for my imagination, and what has now become [verlet-js](https://github.com/subprotocol/verlet-js).

It is all based off an iterative technique called [Verlet integration](http://en.wikipedia.org/wiki/Verlet_integration), which greatly simplifies force and motion calculations.  The gist of it is that you can easily model intricate objects and dynamic behaviors*&mdash;and it's insanely fun!*


What I've built so far
----------------------

[![Shapes / Hello world example](/static-content/images/shapes.png)](/system/verlet-hello-world.html)
[![Fractal tree example](/static-content/images/tree.png)](/system/tree.html)
[![Cloth example](/static-content/images/cloth.png)](/system/cloth.html)
[![Spiderweb example](/static-content/images/spiderweb.png)](/system/spider.html)


How it works
------------

Verlet-js exposes 3 basic primitives to you:

1. **particle:** A point in space.
2. **constraint:** Links particles together given some criteria and operational params.
3. **composite:** A grouping of particles and constraints that let you have many objects in a scene.

With these primitives you just start building and connecting things together. Once you are hooked your imagination and curiosity will run wild!

<!-- more -->

Canonical 'Hello world!'
------------------------

All it takes is an HTML5 canvas, a VerletJS object, and you can be well on your way to creating your very own monstrosity. If the simulation is slow for your computer, lower the steps per frame from 16 to something smaller (like 8):

{% highlight javascript %}
sim.frame(16);
{% endhighlight %}

See the [Shapes example](/system/verlet-hello-world.html) for full source code.

{% highlight javascript %}

// canvas
var canvas = document.getElementById("scratch");
var width = 800;
var height = 500;

// simulation
var sim = new VerletJS(width, height, canvas);

// entities
var tire1 = sim.tire(new Vec2(200,50), 50, 30, 0.3, 0.9);
var tire2 = sim.tire(new Vec2(400,50), 70, 7, 0.1, 0.2);
var tire3 = sim.tire(new Vec2(600,50), 70, 3, 1, 1);

// animation loop
var loop = function() {
	sim.frame(16);
	sim.draw();
	requestAnimFrame(loop);
};

loop();
{% endhighlight %}



Where to go from here?
----------------------

* Clone, fork, view the [codebase on GitHub](https://github.com/subprotocol/verlet-js). Play with it locally, and go nuts! Contributions in the form of pull requests (bug-fixes, new examples, etc..) are always welcome.