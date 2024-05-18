
#ifndef AXES_H
#define AXES_H

#include "Curve.h"

#define DEAFAULT_NOTCH 4
#define DEAFAULT_PRECISION 4

class Axes{

public:
enum Direction { x = 0, y };
Axes(const Direction& dir = Direction::x, const double& min = -1.0 , const double& max = 1.0, const string& label = "X label");

double max() const { return maximum; }
double min() const { return minimum; }

double& max() { return maximum; }
double& min() { return minimum; }

Direction direct() const { return direction; }
Direction& direct() { return direction; }
 
string& label() { return axis.name(); }
string label() const { return axis.name(); }

const Curve::Color& color() const { return axis.color(); }

const int& notches() const {return notch;} 
int& notches() { return notch; } 

const int& accuracy() const {return precision;} 
int& accuracy() { return precision; } 

private:
double minimum; // handles maximum of the axis
double maximum; // handles minimum of the axis
Direction direction;
Curve axis; // define line of the axis
int notch; // number of the notches 
int precision;

};


#endif
