
#include "Curve.h"

ostream& operator<<(ostream& os, const Point& p){
os << p.x << " " << p.y ;
return os;
}


//-----------------------------------------------------------------------------
istream& operator>>(istream& is, Point& p){
is >> p.x >> p.y;
return is;
}

//-----------------------------------------------------------------------------
Curve::Curve(const Curve& a):
v{a.v},
title{a.title},
clr{a.clr}
{}

Curve& Curve::operator=(const Curve& curv){
v = curv.v;
title = curv.title;
clr = curv.clr;
return *this;
//cout << " curve:\n";
//cout << curv;

/*
// this does not work completely
// this does not work completely
Curve temp{curv};
swap(temp,*this); 
return *this;
*/

}

//-----------------------------------------------------------------------------
istream& operator>>(istream& is, Curve& curve){

string line;
     while( getline(is,line) &&
                                ! (isdigit(line[0]) || line[0]=='-')
          );
     stringstream ss(line);
     Point p;
     ss >> p;
     if (ss) curve.add(p);

     while( getline(is,line) &&
                                (isdigit(line[0]) || line[0]=='-')
          ){
            stringstream ss(line);
            Point p;
            ss >> p;
            if (ss) curve.add(p);
          }

return is;
}

//-----------------------------------------------------------------------------
ostream& operator<<(ostream& os, const Curve& curve){

    os << "name: " << curve.name() << '\n';
    os << "color: " << curve.color() << '\n';
    os << "style: " << curve.style() << '\n';
 
    for(int i = 0; i < curve.size(); ++i)
    os << curve(i) << '\n';
 
return os;
}

//-------------------------------------------------------------------------------
Curve::Curve(const vector<double>& vx, const vector<double>& vy){
      title = " vector curve";
      clr = Color::black;

      for(int i=0;i<vx.size();++i)
       // vx.size == vy.size
       add( Point(vx[i],vy[i]) );
}

