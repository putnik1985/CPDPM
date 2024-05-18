
#ifndef CURVE_H
#define CURVE_H

#include "std_lib_facilities.h"  
#include "Qt_lib.h"
#define MAX_COLORS 7


struct Point{
double x {0.0}; // x coordinate 
double y {0.0}; // y coordinate
Point(double xx = 0.0, double yy = 0.0):
x{xx}, y{yy}
{}


}; //responsible for the operations with Point object


class Curve{

public:
Curve(const string& name = "####"):
clr{Color::black},
title{name},
stl{Style::solid}
{};

Curve(const Curve& a);
Curve(const vector<double>& vx, const vector<double>& vy);

Curve& operator=(const Curve& curv);
enum Color { 
             black = 0, 
             brown,
             red, 
             orange,
             yellow,
             green,
             blue,
             violet
           };

enum Style {
            solid = 0,
            dash,
            dash_dot,
             
           }; 

const Color& color() const {return clr;}
Color& color() { return clr; }

const Style& style() const {return stl;}
Style& style() { return stl; }


int add(const Point& p) { v.push_back(p); return 0;}

const string& name() const {return title;}
string& name() { return title; }

const Point& operator()(const int& i) const { return v[i];}

Point& operator()(const int& i) { return v[i];}

int size() const { return v.size(); }

vector<double> x_column() const { 
                                  vector<double> x;
                                  for( int i = 0; i < v.size(); ++i)
                                  x.push_back(v[i].x);
                                  return x;
                                 } 

vector<double> y_column() const { 
                                  vector<double> y;
                                  for( int i = 0; i < v.size(); ++i)
                                  y.push_back(v[i].y);
                                  return y;
                                 } 

private:
vector<Point> v;
string title;
Color clr;
Style stl;

}; // class curve responsible for the operations with curve

istream& operator>>(istream& is, Curve& curve);
ostream& operator<<(ostream& os, const Curve& curve);
ostream& operator<<(ostream& os, const Point& p);

typedef std::vector<Curve> Curves;

#endif
