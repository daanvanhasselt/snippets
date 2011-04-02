/*
 *  LSys.cpp
 *  Lsystem
 *
 *  Created by Daan on 01-04-11.
 *  Copyright 2011 Daan van Hasselt. All rights reserved.
 *
 */

#include "LSys.h"


LSys::LSys(){
	level = 0;	
}

void LSys::addVariable(string var){
	variables.push_back(var);
}

void LSys::removeVariable(string var){
	for(int i = 0; i < variables.size(); i++){
		if(variables[i] == var) variables.erase(variables.begin() + i);
	}
}

void LSys::printVariables(){
	cout << "LSys variables:" << endl;
	for(int i = 0; i < variables.size(); i++){
		cout << "\t\t\t\t" << variables[i] << endl;
	}
}

void LSys::addConstant(string cons){
	constants.push_back(cons);
}

void LSys::removeConstant(string cons){
	for(int i = 0; i < constants.size(); i++){
		if(constants[i] == cons) constants.erase(constants.begin() + i);
	}
}

void LSys::printConstants(){
	cout << "LSys constants:" << endl;
	for(int i = 0; i < constants.size(); i++){
		cout << "\t\t\t\t" << constants[i] << endl;
	}
}

void LSys::addRule(LRule rule){
	rules.push_back(rule);
}

void LSys::removeRule(LRule rule){
	for(int i = 0; i < rules.size(); i++){
		if(rules[i] == rule) rules.erase(rules.begin()+i);
	}
}

void LSys::printRules(){
	cout << "LSys rules:" << endl;
	for(int i = 0; i < rules.size(); i++){
		rules[i].print();
	}
}

void LSys::setStart(string _start){
	start = _start;
	curString = start;
}

void LSys::printStart(){
	cout << "LSys start:" << endl;
	cout << "\t\t\t\t" << start << endl;
}

string LSys::getNextLevel(){
	int length = curString.length();	// length of the current string

	string substr[length];				// split into 1-char substrings
	for(int i = 0; i < length; i++){
		substr[i] = curString.substr(i,1);
	}

	for(int i = 0; i < length; i++){	// apply all rules
		for(int j = 0; j < rules.size(); j++){
			if(substr[i] == rules[j].predecessor){
				substr[i] = rules[j].successor;
				j = rules.size();		// if one rule is applied, skip rest of rules
			}
		}
	}
	
	string result;						// merge into resulting string
	for(int i = 0; i < length; i++){
		result.append(substr[i]);
	}
	curString = result;

	level++;
	return curString;						// return current result
}

string LSys::getLevel(int _level){
	curString = start;
	string result;
	for(int i = 0; i < _level; i++){
		result = getNextLevel();
	}
	return result;
}