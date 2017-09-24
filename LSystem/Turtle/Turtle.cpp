/*
 *  Turtle.cpp
 *  Lsystem
 *
 *  Created by Daan on 02-04-11.
 *  Copyright 2011 Daan van Hasselt. All rights reserved.
 *
 */

#include "Turtle.h"

Turtle::Turtle(){
	angle = 90;
	curAngle = 0;
	length = 10;
	x = ofGetWidth()/2;
	y = ofGetHeight()/2;
}

Turtle::Turtle(string _forward, string _left, string _right){
	forward = _forward;
	left = _left;
	right = _right;
	
	angle = 90;
	curAngle = 0;
	length = 10;
	x = ofGetWidth()/2;
	y = ofGetHeight()/2;
}

void Turtle::setAngle(float _angle) {
    angle = _angle;
}

void Turtle::setLength(float _length) {
    length = _length;
}

void Turtle::draw(string input, float _x, float _y, float _angle){
	x = _x;
	y = _y;
	curAngle = _angle;
	
	int length = input.length();	// length of the input string
	
	string substr[length];				// split into 1-char substrings
	for(int i = 0; i < length; i++){
		substr[i] = input.substr(i,1);
	}
	
	for(int i = 0; i < length; i++){		// check every character
		if(substr[i] == forward)			// and act accordingly
			moveForward();
		if(substr[i] == left)
			turnLeft();
		if(substr[i] == right)
			turnRight();
		if(substr[i] == "[")
			pushValues();
		if(substr[i] == "]")
			popValues();
	}	
}

void Turtle::pushValues(){
	xHis.push_back(x);
	yHis.push_back(y);
	aHis.push_back(curAngle);
}

void Turtle::popValues(){
	x = xHis[xHis.size()-1];
	y = yHis[yHis.size()-1];
	curAngle = aHis[aHis.size()-1];
	
	xHis.pop_back();
	yHis.pop_back();
	aHis.pop_back();
}

void Turtle::moveForward(){
	float newX = x + (cos(ofDegToRad(curAngle))*length);
	float newY = y + (sin(ofDegToRad(curAngle))*length);

	//cout << "move forward from: " << x << ", " << y << " to " << newX << ", " << newY << endl;
	ofEnableAlphaBlending();
	ofSetColor(0, 0, 0, 120);
	ofSetLineWidth(2);
	ofLine(x, y, newX, newY);
	x = newX;
	y = newY;
	
}

void Turtle::turnLeft(){
//	cout << "turn left" << endl;
	curAngle += angle;
}

void Turtle::turnRight(){
//	cout << "turn right" << endl;
	curAngle -= angle;
}
