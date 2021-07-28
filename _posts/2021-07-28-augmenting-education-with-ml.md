---
layout: post
author: Sean
email: smprotocol@gmail.com
title: "Augmenting Education with Machine Learning"
synopsis: "Proof of concept demonstrating the potential for neural networks to scale and optimize the classroom learning environment."
comments: true
image: /images/augmenting-education.png
---

<script src="https://cdn.jsdelivr.net/npm/@tensorflow/tfjs@3.5.0/dist/tf.min.js"></script>

<style type="text/css">
	
	@keyframes card-flip {
		from {
			transform: rotateY(0deg);
		}

		10% {
			transform: rotateY(0deg);
		}
		
		25% {
			transform: rotateY(180deg);
		}
		
		60% {
			transform: rotateY(180deg);
		}

		to {
			transform: rotateY(0deg);
		}
	}
	
	.remark-c {
		color: green;
	}
	
	.remark-w {
		color: orange;
	}
	
	.remark-e {
		color: #f00;
	}
	
</style>





# Augmenting Education with Machine Learning

This rough neural network proof of concept is for a letter formation gap analysis, learning, and screening framework. I dream that it could one day aid students and educators.

Reversing characters (e.g. bd, pq) is a very common struggle for children learning to write.  While normal, it can also be indicative of an underlying visual processing or learning disability. This small demo attempts to perceive letter reversals and case. See below for further details.

**Instructions:** This demo expects you to write a letter (a-Z) in the box matching the letter goal. Press the 'Clear' button and try writing something.  Use the 'Change Letter' button for a different letter goal. A few examples are provided in the drop down.

<div style="display: inline-block; vertical-align: top; margin-right: 1em;">
	Letter Goal: <b id='letter'>e</b>
	
	<br/><br/>
	
	<button id="new_char">Change Letter</button>
	<button id="clear">Clear</button>
	
	<br/>
	<br/>
	<br/>
	<br/>
	
	Examples:
	<br/>
	<br/>
	<select id="examples" style="font-size: 1em;">
		<option data-image="data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABwAAAAcCAYAAAByDd+UAAAAAXNSR0IArs4c6QAAAZdJREFUSEvtlT/KwkAQxV8iQaKIBxD8g2AhhGCTLvbaayvewCOI91A8QNLqBSwUG9NJCtHGSlQEFWwisxDBD+MmQVJ8ZLoks++XebszKziO4yDCEGLgr92OLX1zdDAYwLIsJJNJVCoV9Pv9wI77slTXdcxms4/iiUQCw+EQnU7HF5wLTKfTuN1uXDFVVbFarbh5X4HlchmbzYaJpFIpzOdzKIryEh2Px+h2u6/n7XaLQqHwFeoJNAwDrVaLLSYREvMKQRDYp3w+j91uFw6YzWZxuVzY4mq1CtrH9XqNx+OBTCaD0+mE6/WK/X6P8/n8gvAmpWeF7l9zN+VPQmhgqVR6s1EURdCJpOroIFGF9E6SJByPR7ig0MCglbmO/E8gncxischMiaRCTdOwXC6jA7r712g0MJlMwvVhvV7HYrGAbdue02M6naLZbPruQUoM3IdUzad9ohE3Go24h9sTSFcQTRVeyLIM0zRBdvoJ7m1BIr1eD/f7HYfDgTV9LpdDrVZDu932w3jL8QUMrPplQQz8pZtMK3JLn15H9q1ZPAsIAAAAAElFTkSuQmCC" data-expect="e">e (reversal)</option>
		<option data-image="data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABwAAAAcCAYAAAByDd+UAAAAAXNSR0IArs4c6QAAAYVJREFUSEvtlTGrgmAUhl/D2pSg3yC0tDYJjUlTi5MOrrUE4b+QaMtZyB/Q1OriHwgc2oUgApuL8vLJTW63q9+RG/cufuv3+j7nvHqOQpqmKf7wCDXw3WnXkWaJns9ndDod3O/3p4Q1TcN2u62UOjdSz/NgWVapaZXJKgWGYQhVVXNYo9GAoihIkgTH4/GpCCq0FCgIQm5qGAbW6/UTZDQa5ZE2m01cLhduvIXAxWIB27Yzg8FggCAIfjRrtVq4Xq/ZHaXLQqAoirjdblyj+XyO5XLJ1T2qLQR+jZOb06fgVx3+G1DXdcxms9ImZVlGr9cjBcGNdLVaYTKZkMwoIi6QVb7b7SheJE0hkA05+wjYu/y+0kjOBaJCoGma8H0/e4ztS7Y333HIm4ats3a7/cIcDoeI4xhRFJHqKQVOp1O4rpsbSZKEfr+f7dHD4YDT6ZTfUWaQibl/i/F4jM1mw63+bcAHqdvtYr/fv4Adx8l3LrcqSocUkyoabqRVzCjaGkhJqZLmA78t6q3bWMaPAAAAAElFTkSuQmCC" data-expect="e">e</option>
		<option data-image="data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABwAAAAcCAYAAAByDd+UAAAAAXNSR0IArs4c6QAAAVJJREFUSEvtk7HKgmAUhl8pHISg0VHcHNTFsTUhXPUmXLyVriOdXfIWhChoaAkvoKWoQUV/PiHhV8sjyD/8+G1+HM7zncf3cGVZlvjDw03AsW1PSsFxXGX1eDzCMAykaVpb3mw2CMNwkPVepW/gt65DNmswcLFYgOd53G63+g2z2Qx5npMmHQT0fR+2bdeNmeI4jqvv3W4Hx3F6oWSgIAh4Pp+thm/lbPL7/T4ekIWDhaR5NE3D6XSqrin/kjyh53nYbrctoGma2O/34wN1XcfhcGgB1+s1oigaB2hZ1q8961LGEloUBahJ/aq0uYOiKIIldbVaIUkSqKqKx+NRTfdJeVNJJ7AJYgl9vV4fEzifz5FlWW9CWUEvUFEUnM9nyLKM6/XaaipJUuf9J3onMAgCuK6Ly+WC5XJJejm1qHctqI2odROQaopcNyklq6IW/n+lPxfx2K2MDP76AAAAAElFTkSuQmCC" data-expect="a">a (reversal)</option>
		<option data-image="data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABwAAAAcCAYAAAByDd+UAAAAAXNSR0IArs4c6QAAAUVJREFUSEvtkyGrg2AUhl/BahBsgxWbwb6sQe1isSyb3B9wP8FkXB5idQjalxf8BYJlReziRbnKHMzvk+td8mvyHc/j+3gO07Ztiy8eZgOubXtTurZRUCu1bRvX6xVN00w+YulWEYFVVYHn+dmkS6BEIMMwE5goijidTjifz3g+n/3dasD9fo+iKPqmqqoiTdMR7roufN9fFzikEwRhTDMQwzCEZVn94+12g67rVAM2q3QAflI23Hd6Pc/7HvByueB4PP4vMAgCOI7TQwzDQBzH6wHfB6br/D69tJM6+w9Zlh0XXZZlPB4PvCZ7jSRJEvI8J6acBZKW/nA44H6/TyDdtHZT++kQF797cbfboSzLSQ9FUZBlGaIogmma4x3Hcajr+m9AoqffgiRJoGnabDlVQlogTd0GpLG0qGZTukgXTfHXlf4A8XrbrfDPCBAAAAAASUVORK5CYII=" data-expect="A">A (case)</option>
		<option data-image="data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABwAAAAcCAYAAAByDd+UAAAAAXNSR0IArs4c6QAAAShJREFUSEvtlrGNhDAQRb8REYIGKIAm6ICMgBxERkoLhORkiBqQCKiBCsjoATIkWBmJlZdb387p7A1WS4Zl/ec/M9/A9n3f8caHfYGyak/ThCRJMAwD+r6H7/ukxvy5pIwxqTBlHMjAqqqQZdmvLpQCr85O8XOdAuOnJTsUgaK4dqBpmljX9V5a7UBOeqtDDrRtG/M8Hy61ORTFz3o2TYM4jo9X5UNzQmQ5VApM0xR1Xf87g6RYGIZBKpcSh47jYFmWu7MgCNB13YNTpUMjC7tI1AIsyxJ5nj/toRbg9XbR7pADPM/DOI4/XCp1eA07F9+2Td/QvAq7SFYSi2e9kqVfOZCDwjBE27YH07IsuK6LoigQRRHpf4Z005CViBvJX3yi3sttnw+8AUz3563f1funAAAAAElFTkSuQmCC" data-expect="b">B (case, reversal)</option>
		<option data-image="data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABwAAAAcCAYAAAByDd+UAAAAAXNSR0IArs4c6QAAAVBJREFUSEvtlj+ugkAYxAcLwh8ToaPS1oLoGbQlHEIvQLiBXIEDeApCQ0I8g4mFnZZUkABaGOFlSdZIzHvmbRZi4TZUzC8z+80HQl3XNXo8whfIO+3Pj3S73Tam1+s1k/l/OxQEoQGxDvdnA7Msg67r/TkMwxCWZUFVVRRF0f0dUuBwOESe5/0BFUVBWZbdA3e7HRaLBSaTCU6nU/dAGuloNAIZIJbztha0d8/imqYhTVMWHv4EiqKI2+32Ijwej3E+n/kDqbvVagXXdTGbzRqILMu4XC58gY7jwPf9VskHg0Gz0sjzfr/zBdq2jSAIWkDSP1oH7rt0s9nA87wW0DRNHA6Hblbbfr/HfD5viRuGgSRJugES1edKLJdLxHH8uDfukRLl6XSK4/H4MhySJOF6vfIdGqpGvg5RFD36SFxXVcUEa1L7/iYyZ/fLi71H+gOdn/Ctw70+nAAAAABJRU5ErkJggg==" data-expect="b">b (reversal)</option>
		<option data-image="data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABwAAAAcCAYAAAByDd+UAAAAAXNSR0IArs4c6QAAAVBJREFUSEvtlj+ugkAYxAcLwh8ToaPS1oLoGbQlHEIvQLiBXIEDeApCQ0I8g4mFnZZUkABaGOFlSdZIzHvmbRZi4TZUzC8z+80HQl3XNXo8whfIO+3Pj3S73Tam1+s1k/l/OxQEoQGxDvdnA7Msg67r/TkMwxCWZUFVVRRF0f0dUuBwOESe5/0BFUVBWZbdA3e7HRaLBSaTCU6nU/dAGuloNAIZIJbztha0d8/imqYhTVMWHv4EiqKI2+32Ijwej3E+n/kDqbvVagXXdTGbzRqILMu4XC58gY7jwPf9VskHg0Gz0sjzfr/zBdq2jSAIWkDSP1oH7rt0s9nA87wW0DRNHA6Hblbbfr/HfD5viRuGgSRJugES1edKLJdLxHH8uDfukRLl6XSK4/H4MhySJOF6vfIdGqpGvg5RFD36SFxXVcUEa1L7/iYyZ/fLi71H+gOdn/Ctw70+nAAAAABJRU5ErkJggg==" data-expect="d">d</option>
	</select>
</div>

<canvas id="receptive_field" style="cursor: pointer; user-select: none; display: inline-block; vertical-align: top; margin-right: 1em; border: 3px solid #ccc; border-radius: 5px; box-shadow: 3px 3px 10px rgba(0,0,0,0.1); width: 384px; height: 384px; image-rendering: pixelated;"></canvas>

<div style="display: inline-block; vertical-align: top;">
	Correctness Tolerance
	
	<br/>
	<input type="checkbox" checked="checked" id="allow-reversals" /> <small>Allow Reversals</small>
	<br/>
	<input type="checkbox" checked="checked" id="case-insensitive" /> <small>Case Insensitive</small>
	<br/>
	<br/>
	

	<table id="predictions">
		<thead>
			<tr>
				<th>Result</th>
				<th>Remarks</th>
			</tr>
		</thead>
		<tbody>
			<tr>
				<td>Loading</td>
				<td>...</td>
			</tr>
		</tbody>
	</table>

</div>

<script>
	
	
	const model = tf.loadLayersModel("/js/models/cdnn/model.json");
	const char_classes = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz";
	
	
	function reversalAnimation() {
		let el = document.querySelector("#receptive_field");
		let css = el.style;

		// weird hack to reset animation
		css.animation  = "none";
		el.offsetWidth = el.offsetWidth;

		
		css.transformStyle = "preserve-3d";
		css.animationDuration = "2.5s";
		css.animationName = "card-flip";
	}
	
	function loaded(model) {
		console.log("loaded!");
		
		const canvas = document.querySelector("#receptive_field");
		canvas.width = 28;
		canvas.height = 28;
		const ctx = canvas.getContext("2d");
		ctx.lineWidth = 2;
		ctx.lineJoin = 'round';
		ctx.lineCap = 'round';
		ctx.strokeStyle = '#000';
		// need to blank the canvas so getImageData works
		ctx.fillStyle = '#ffffff';
		ctx.fillRect(0, 0, canvas.width, canvas.height);
		
		
		function validate(image_data, ch, allowReversals, caseInsensitive) {
			
			// normalize tensor, optionally take map function to allow additional transform step (tensor reversal)
			function normalize(tensor, transform=(input) => input) {
				return tf.scalar(1).sub(
					transform(tensor).mean(2).toFloat().div(tf.scalar(255)).expandDims(0).expandDims(-1)
				);
			}
			
			let pixel_tensor = tf.browser.fromPixels(image_data);
			
			let normative_tensor = normalize(pixel_tensor);
			let non_normative_tensor = normalize(pixel_tensor, (transform) => transform.reverse(1));
			
			const normative = tf.topk(model.predict(normative_tensor).as1D(), 1);
			const normative_char = char_classes.charAt(normative.indices.dataSync()[0]);
			
			const non_normative = tf.topk(model.predict(non_normative_tensor).as1D(), 1);
			const non_normative_char = char_classes.charAt(non_normative.indices.dataSync()[0]);
			
			const expectedCaseIfIncorrect = ch == ch.toLowerCase() ? "Uppercase" : "Lowercase";
			
			if (normative_char == ch) {
				// exactly correct
				return {correct: true, reversal: false, caseing: true, message: `<span class="remark-c">Great job!</span>`};
			} else if (normative_char.toLowerCase() == ch.toLowerCase()) {
				// correct with wrong case
				const remarkClass = caseInsensitive ? "remark-w" : "remark-e";
				return {correct: caseInsensitive, reversal: false, caseing: false, message: `<span class="${remarkClass}">${expectedCaseIfIncorrect}</span>`};
			} else if (non_normative_char == ch && allowReversals) {
				// correct reversal
				reversalAnimation();
				return {correct: true, reversal: true, caseing: true, message: `<span class="remark-w">Reversal</span>`};
			} else if (non_normative_char.toLowerCase() == ch.toLowerCase() && allowReversals) {
				reversalAnimation();
				// correct reversal, wrong case
				const remarkClass = caseInsensitive ? "remark-w" : "remark-e";
				return {correct: caseInsensitive, reversal: true, caseing: false, message: `<span class="remark-w">Reversal</span>, <span class="${remarkClass}">${expectedCaseIfIncorrect}</span>`};
			} else {
				// incorrect
				return {correct: false, reversal: true, caseing: false, message: `<span class="remark-e">Expected '${ch}'</span>`};
			}
		}
		
		function predict(ch, allowReversals, caseInsensitive) {
			
			const image_data = ctx.getImageData(0,0,canvas.width,canvas.height);
			
			// uncomment if you want a data:image/png of the canvas printed to the console
			//const png = canvas.toDataURL("image/png");
			//console.log(png);
			
			
			const result = validate(image_data, ch, allowReversals, caseInsensitive);

			let buf = "";
			buf += "<tr>";
			buf += `<td>${result.correct ? "Correct" : "Try Again"}</td>`;
			buf += `<td>${result.message}</td>`
			buf += "</tr>";
			const tbody = document.querySelector("#predictions tbody");
			tbody.innerHTML = buf;
		}
		
		document.querySelector("#clear").addEventListener("click", function(e) {
			ctx.fillStyle = '#ffffff';
			ctx.fillRect(0, 0, canvas.width, canvas.height);
			document.querySelector("#predictions tbody").innerHTML = "";
		});
		
		document.querySelector("#new_char").addEventListener("click", function(e) {
			ctx.fillStyle = '#ffffff';
			ctx.fillRect(0, 0, canvas.width, canvas.height);
			document.querySelector("#predictions tbody").innerHTML = "";
			
			let min = 10;
			let max = char_classes.length-1;
			while (true) {
				let char_index = Math.floor(Math.random() * (max - min + 1) + min);
				
				// continue if we pick the same letter
				if (document.querySelector("#letter").innerText != char_classes[char_index]) {
					document.querySelector("#letter").innerText = char_classes[char_index];
					break;
				}
			}
		});
		
		const examples_el = document.querySelector("#examples");
		examples_el.addEventListener("change", function(e) {
			const selected_example =  document.querySelector("#examples option:checked").getAttribute("data-image");
			const selected_char =  document.querySelector("#examples option:checked").getAttribute("data-expect");
			const ch = selected_char;
			document.querySelector("#letter").innerText = selected_char;
			const allowReversals = !!document.querySelector("#allow-reversals:checked");
			const caseInsensitive = !!document.querySelector("#case-insensitive:checked");
			
			let img = new Image();
			img.src = selected_example;
			img.onload = () => {
				ctx.drawImage(img, 0, 0);
				predict(ch, allowReversals, caseInsensitive);
			}
		});
		
		document.querySelector("#allow-reversals").addEventListener("change", function(e) {
			const ch = document.querySelector("#letter").innerText;
			const allowReversals = !!document.querySelector("#allow-reversals:checked");
			const caseInsensitive = !!document.querySelector("#case-insensitive:checked");
			predict(ch, allowReversals, caseInsensitive);
		});
		
		document.querySelector("#case-insensitive").addEventListener("change", function(e) {
			const ch = document.querySelector("#letter").innerText;
			const allowReversals = !!document.querySelector("#allow-reversals:checked");
			const caseInsensitive = !!document.querySelector("#case-insensitive:checked");
			predict(ch, allowReversals, caseInsensitive);
		});
		
		const evt = document.createEvent("HTMLEvents");
		evt.initEvent("change", false, true);
		examples_el.dispatchEvent(evt);


		
		let resetState = false;
		let mouse = {x: 0, y: 0};
		let last_mouse = {x: 0, y: 0};
	
	
		let fnMove = function(e) {
			last_mouse.x = mouse.x;
			last_mouse.y = mouse.y;
		
			let page_x = e.pageX;
			let page_y = e.pageY;
			
			if (isNaN(page_x) && e.targetTouches) {
				if (e.targetTouches.length != 1) // don't allow multiple touches
					return false;
				
				page_x = e.targetTouches[0].pageX;
				page_y = e.targetTouches[0].pageY;
			}
			
			mouse.x = page_x - this.offsetLeft;
			mouse.y = page_y - this.offsetTop;
			mouse.x *= canvas.width / canvas.clientWidth;
			mouse.y *= canvas.height / canvas.clientHeight;
			
			
			e.preventDefault(); // prevent mobile tocuh events from scrolling page
		};
		
		let fnDown = function(e) {
			resetState = true;
			canvas.addEventListener('mousemove', onPaint, false);
			canvas.addEventListener('touchmove', onPaint, false);
			
			e.preventDefault(); // prevent mobile tocuh events from scrolling page
		};
		
		let fnUp = function(e) {
			canvas.removeEventListener('mousemove', onPaint, false);
			canvas.removeEventListener('touchmove', onPaint, false);
			const ch = document.querySelector("#letter").innerText;
			const allowReversals = !!document.querySelector("#allow-reversals:checked");
			const caseInsensitive = !!document.querySelector("#case-insensitive:checked");
			predict(ch, allowReversals, caseInsensitive);
			
			e.preventDefault(); // prevent mobile tocuh events from scrolling page
		};
		
		canvas.addEventListener('mousemove', fnMove, false);
		canvas.addEventListener('mousedown', fnDown, false);
		canvas.addEventListener('mouseup', fnUp, false);
		
		
		canvas.addEventListener('touchstart', fnDown, false);
		
		canvas.addEventListener('touchmove', fnMove, false);
		canvas.addEventListener('touchstart', fnDown, false);
		canvas.addEventListener('touchend', fnUp, false);
	
		var onPaint = function() {
			
			if (resetState) {
				last_mouse.x = mouse.x;
				last_mouse.y = mouse.y;
				resetState = false;
			}
			
			ctx.beginPath();
			ctx.moveTo(last_mouse.x, last_mouse.y);
			ctx.lineTo(mouse.x, mouse.y);
			ctx.closePath();
			ctx.stroke();
		};


	}
	function failure() {
		console.log("failure");
	}
	model.then(loaded, failure);

	
</script>


## A Personal Perspective

During the pandemic when kids were sent home, I manually performed exactly what this neural network and framework is attempting to accomplish with my Son.

From that experience, an interesting scale and optimization challenge presented itself. An educator couldn't possibly give individualized, highly focused, and synchronous attention to 30 students in a classroom simultaneously.

It struck me that was this was the perfect challenge for neural networks to solve. After conducting extremely thorough research, I discovered something highly logical—Vulcans were using machine learning to [solve education scaling](https://youtu.be/EbEtN-e79Lo?t=96) in the year 2286 :)



## The Learners Perspective

It can be very frustrating to be right and wrong at the same time. My goal is to provide a practice and learning environment with a positive feedback loop—a correct but reversed character needn't be wrong!  Combined with immediate feedback and guidance, that is individually tailored and automated, learners are setup for success.


## Educators and Parents

This framework is capable of measuring and quantifying behind the scenes, with an overarching goal of driving impact.  The collected analytics would be useful on a variety of fronts:

* Tailoring and optimizing learning experiences in the moment.
* Measuring individual improvement and detecting regressions over time.
* Age adjusted percentile charting for [IEP](https://en.wikipedia.org/wiki/Individualized_Education_Program) placement and tracking.
* Aiding the strategic allocation of additional resources and services for students.
* Using automation to regularly/efficiently/scalably screen many students in parallel.
* Most importantly—maximizing outcomes for students and helping our educators.


## Learning Character Formation

One key character reversal mitigation strategy is learning the proper starting point and writing flow for each character. Typically character forming is taught in groups with other similar forming characters.

I'm working on a neural network variant capable of detecting and scoring these formations. Beyond an additional metric, the idea is to detect and create an automated in place learning and reinforcement opportunity—without requiring direct manual observation.


## On Numbers

Though fully stubbed out, numbers are not currently supported.  I've focused on letters as it is the larger technical challenge at hand. Further along numbers will be feathered in.

