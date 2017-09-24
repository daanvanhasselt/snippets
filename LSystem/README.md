# LSystem
LSys is an implementation of an L-system (http://en.wikipedia.org/wiki/L-system) made for openFrameworks.

_Usage_

In your testApp.h, #include "LSystem.h" and declare an LSys object. In testApp.cpp, you can then add variables, constants, rules and set a start-state. For a Koch curve:
```
	system.addVariable("F");
	system.printVariables();

	system.addConstant("+");
	system.addConstant("-");
	system.printConstants();
	
	system.setStart("F");
	system.printStart();
	
	system.addRule(LRule("F", "F+F-F-F+F"));
	system.printRules();
```
Call getNextLevel() for the result of the next iteration:

	`string result = system.getNextLevel();`

Or to get a specific level of iteration:

	`string result = system.getLevel(5);`

I've also included a simple turtle graphics class, to use this #include "Turtle.h" and declare a Turtle object in your testApp.h. In setup(), call the constructor like this:

	turtle = Turtle("F", "-", "+");

where the first string is the character for moving forward, the second string is for turning left and the last one is for turning right. You can also set
```
	turtle.lenght = 10;
	turtle.angle = 90;
```
And when you're ready to draw you call

	`turtle.draw(result, 100, 100, 0);	// input string, x, y, starting angle`
