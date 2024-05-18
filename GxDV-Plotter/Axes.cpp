
#include "Axes.h"

Axes::Axes(const Direction& dir, const double& min, 
                                 const double& max,  
                                 const string& label
           )
{
notch = DEAFAULT_NOTCH; // default number of the notches
precision = DEAFAULT_PRECISION;

this->minimum = min;
this->maximum = max;
axis.name() = label;
/////cout << axis.color() << '\n';

     direction = dir;
     switch(dir){
     case Direction::x : 
                        axis.add(Point(min,0.0));
                        axis.add(Point(max,0.0));
                        break;                  
     case Direction::y :
                        axis.add(Point(0.0,min));
                        axis.add(Point(0.0,max));
                        break;                  
     default:
          error(" direction is defined incorrectly\n"); // throw an exception
     } // define direction 
     

}
