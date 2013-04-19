---
layout: post
author: Sean
email: smprotocol@gmail.com
title: Introducing Verlet-JS
synopsis: An open source physics engine made for constructing 2D dynamic body simulations.
comments: true
---

Particle meets constraint, and so [verlet-js](/verlet-js/) was born.





A framework for creating
========================

I was experimenting with code one evening and ended up accidentally stumbling onto a new playground for my imagination, and what has now become [verlet-js](/verlet-js/).

It is all based off an iterative technique called [Verlet integration](http://en.wikipedia.org/wiki/Verlet_integration), which greatly simplifies force and motion calculations.  The gist of it is that you can easily model intricate objects and dynamic behaviors*&mdash;and it's insanely fun!*


What I've built so far
----------------------

[![Shapes / Hello world example](/static-content/images/shapes.png)](/verlet-js/examples/shapes.html)
[![Fractal tree example](/static-content/images/tree.png)](/verlet-js/examples/tree.html)
[![Cloth example](/static-content/images/cloth.png)](/verlet-js/examples/cloth.html)
[![Spiderweb example](/static-content/images/spiderweb.png)](/verlet-js/examples/spiderweb.html)


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

    sim.frame(16);

See the [Shapes example](/verlet-js/examples/shapes.html) for full source code.

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

* View the [verlet-js](/verlet-js/) project page for more information.
* Clone, fork, view the [codebase on GitHub](https://github.com/subprotocol/verlet-js). Play with it locally, and go nuts! Contributions in the form of pull requests (bug-fixes, new examples, etc..) are always welcome.