/*
 *  Turtle.h
 *  Lsystem
 *
 *  Created by Daan on 02-04-11.
 *  Copyright 2011 Daan van Hasselt. All rights reserved.
 *
 */

#pragma once

#include "ofMain.h"
#include <vector>

class Turtle {
	
public:
	Turtle();
	Turtle(string forward, string left, string right);
    void setAngle(float angle);
    void setLength(float length);
    
	void draw(string input, float x, float y, float angle);
	void moveForward();
	void turnLeft();
	void turnRight();
    
protected:
	string forward;
	string left;
	string right;
	
	float angle;
	float curAngle;
	float length;
	float x;
	float y;
	
	vector<float> xHis;
	vector<float> yHis;
	vector<float> aHis;
	
	void pushValues();
	void popValues();
};
