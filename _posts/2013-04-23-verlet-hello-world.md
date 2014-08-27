---
layout: post
author: Sean
email: smprotocol@gmail.com
title: "Verlet Hello World"
synopsis: "Demonstrating draggable objects and constraint stiffness coefficients."
comments: true
image: /images/verlet.png
redirect_from: "/verlet-js/examples/shapes.html"
---

<script type="text/javascript" src="/js/verlet-1.0.0.min.js"></script>

# Verlet Hello World

This is the <i>hello world</i> of Verlet-JS. Simple shapes generated using VerletJS.prototype.tire(origin, radius, segments, spokeStiffness, treadStiffness). Also demonstrating various constraint stiffness coefficients. All objects are draggable.

<canvas id="scratch" style="width: 800px; height: 500px;"></canvas>
<script type="text/javascript">

window.onload = function() {
	var canvas = document.getElementById("scratch");

	// canvas dimensions
	var width = parseInt(canvas.style.width);
	var height = parseInt(canvas.style.height);

	// retina
	var dpr = window.devicePixelRatio || 1;
	canvas.width = width*dpr;
	canvas.height = height*dpr;
	canvas.getContext("2d").scale(dpr, dpr);

	// simulation
	var sim = new VerletJS(width, height, canvas);
	sim.friction = 1;
	
	// entities
	var segment = sim.lineSegments([new Vec2(20,10), new Vec2(40,10), new Vec2(60,10), new Vec2(80,10), new Vec2(100,10)], 0.02);
	var pin = segment.pin(0);
	var pin = segment.pin(4);
	
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
};


</script>


## Source Code

<a href="https://github.com/subprotocol/verlet-js/blob/master/examples/shapes.html">View on GitHub</a>