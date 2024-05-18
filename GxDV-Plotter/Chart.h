
#ifndef CHART_H
#define CHART_H

#include "Curve.h"
#include "std_lib_facilities.h"  
#include "Qt_lib.h"

#include "Axes.h"
#include "Note.h"


#define OUTPUT_PRECISION 2
#define NOTCH_SIZE 4
#define X_OFFSET 40
#define Y_OFFSET 40
#define DEFAULT_WIDTH 1

class Chart: public QWidget{

Q_OBJECT

public:
Chart(QWidget *parent = 0);
int display() { show(); return 0; }
int set_geometry( int x = 0, int y = 0, int w = 400, int h = 400) {  setGeometry(x,y,w,h); 
                                                                     X0 = width() / 2;
                                                                     Y0 = height() / 2;
                                                                     return 0;
                                                                  }
int add_plot(const Curve& curve); 
Qt::GlobalColor define_color(const Curve::Color& clr);
Qt::GlobalColor define_color(const int& clr);

const bool& display_cursor() const { return display_location;}
bool& display_cursor() { return display_location;}

const bool& update_legend() const { return new_legend_position;}
bool& update_legend() { return new_legend_position;}


string& x_label() { return axes_x.label(); }
string& y_label() { return axes_y.label(); }

double x_max() const { return axes_x.max(); }
double x_min() const { return axes_x.min(); }

double& x_max() { return axes_x.max(); }
double& x_min() { return axes_x.min(); }

double y_max() const { return axes_y.max(); }
double y_min() const { return axes_y.min(); }

double& y_max() { return axes_y.max(); }
double& y_min() { return axes_y.min(); }

int& x_notches() { return axes_x.notches(); }
int& y_notches() { return axes_y.notches(); }

const int& x_notches() const { return axes_x.notches(); }
const int& y_notches() const { return axes_y.notches(); }

int& x_precision() { return axes_x.accuracy(); }
int& y_precision() { return axes_y.accuracy(); }

const int& x_precision() const { return axes_x.accuracy(); }
const int& y_precision() const { return axes_y.accuracy(); }

const int& curves_number() const { return plots.size(); }
QStringList curves_names() const { 
                                   QStringList list; 
                                   for(int i=0;i<plots.size();++i) 
                                   list << QString( plots[i].name().c_str() ); 
                                   return list;
                                 }
const int& highlight() const { return high_light; }
int& highlight() { return high_light; }

protected:
// define paint event
void paintEvent(QPaintEvent *event);
void resizeEvent(QResizeEvent *event);
void mouseMoveEvent(QMouseEvent *event);

public slots:
int set_highlight(int index) { high_light = index; update(); return 0;}
int set_highlight_name(const QString& name) {
                                             if ( high_light >= 0 && high_light < plots.size() )  
                                             plots[high_light].name() = name.toStdString(); 

                                             update(); 
                                             return 0;
                                            }
int set_x_label(const string& label) { x_label() = label; update(); return 0;}
int set_y_label(const string& label) { y_label() = label; update(); return 0;}


int set_x_min(const double& min) { x_min() = min; update(); return 0;}
int set_x_max(const double& max) { x_max() = max; update(); return 0;}
int set_x_intervals(const int& intervals) { x_notches() = intervals + 1; update(); return 0;}
int set_x_precision(const double& precision) { x_precision() = precision; update(); return 0;}


int set_y_min(const double& min) { y_min() = min; update(); return 0;}
int set_y_max(const double& max) { y_max() = max; update(); return 0;}
int set_y_intervals(const int& intervals) { y_notches() = intervals + 1; update(); return 0;}
int set_y_precision(const double& precision) { y_precision() = precision; update(); return 0;}

int define_curve(const vector<double>& x, const vector<double>& y, const string& name);
const std::vector<Curve>& curves() const { return plots; }
std::vector<Curve>& curves() { return plots; }

int redefine_plots(const Curves& plts) { plots.clear(); plots = plts; return 0; }
 
private:
int calculate_origin() {

      int Xmax = width() - X_OFFSET; // maximum width of the window
      int Ymax = height() - Y_OFFSET; // maximum height of the window

      int Xmin = X_OFFSET;
      int Ymin = Y_OFFSET; 

      double xmin = axes_x.min(); // minimum limit of the x axis
      double xmax = axes_x.max(); // maximum limit of the x axes

      double ymin = axes_y.min(); // minimum limit of the y axis
      double ymax = axes_y.max(); // maximum limit of the y axes

X0 = (Xmin * xmax- Xmax * xmin) / ( xmax - xmin) ;
Y0 = (Ymin * ymin- Ymax * ymax) / ( ymin - ymax) ;

return 0;
}     


                 
Point convert_to_window_cs(const double& x, const double& y);
Point convert_to_local_cs(const int& X, const int& Y);

int update_geometry() { return 0;}
// scale coordinates
double scale_to_window(const int& Xmax,
                       const int& Xmin, 
                       const double& xmin,
                       const double& xmax,
                       const double& x){

return ( (Xmax - Xmin) / (xmax - xmin) ) * x + 
         (Xmin * xmax- Xmax * xmin) / ( xmax - xmin);

}


double window_to_local_cs(const int& Xmax,
                       const int& Xmin, 
                       const double& xmin,
                       const double& xmax,
                       const int& X){

return (X - (Xmin * xmax- Xmax * xmin) / ( xmax - xmin) ) / 
       ( (Xmax - Xmin) / (xmax - xmin) );

}

// set of the plots
std::vector<Curve> plots;
// axes description
Axes axes_x;
Axes axes_y;
int X0 ; // origin of the axes
int Y0 ; // origin of the axes
// legend description
// cursor location
QPoint cursor_location;
bool display_location {false};
bool new_legend_position {false};
QPoint legend_position;
int high_light {-1};

}; // class chart responsible for the operations with the chart

#endif
