
#include "Chart.h"

Chart::Chart(QWidget *parent):
QWidget(parent)
{
axes_x.direct() = Axes::x;
axes_x.label() = " X axis"; // default values

axes_y.direct() = Axes::y;
axes_y.label() = " Y axis"; // default values

X0 = width() / 2; // start from the center
Y0 = height() / 2; // start from the center

// define background color with white color
QPalette palette;
palette.setColor(this->backgroundRole(),QColor(Qt::white) );
setPalette(palette);
setAutoFillBackground(true);

legend_position = QPoint(X_OFFSET,height() - Y_OFFSET);
}

int Chart::add_plot(const Curve& curve){

plots.push_back(curve);
 
      double x_min = axes_x.min();
      double x_max = axes_x.max();

      double y_min = axes_y.min();
      double y_max = axes_y.max();

      vector<double> x_data = curve.x_column();
      vector<double> y_data = curve.y_column();

      auto p = minmax_element(x_data.begin(),x_data.end());
      axes_x.min() = *(p.first);
      axes_x.max() = *(p.second);
      if ( x_min < axes_x.min() ) axes_x.min() = x_min;       
      if ( x_max > axes_x.max() ) axes_x.max() = x_max;

      p = minmax_element(y_data.begin(),y_data.end());
      axes_y.min() = *(p.first);
      axes_y.max() = *(p.second);
      if ( y_min < axes_y.min() ) axes_y.min() = y_min;       
      if ( y_max > axes_y.max() ) axes_y.max() = y_max;
       
return 0;
}

//-----------------------------------------------------------------------

Point Chart::convert_to_window_cs(const double& x, const double& y){
Point p;
      int Xmax = width() - X_OFFSET; // maximum width of the window
      int Ymax = height() - Y_OFFSET; // maximum height of the window

      int Xmin = X_OFFSET;
      int Ymin = Y_OFFSET; 

      //std::cout << "x= " << x 
      //          << "y= " << y
      //          << '\n';

      double x_min = axes_x.min(); // minimum limit of the x axis
      double x_max = axes_x.max(); // maximum limit of the x axes

      double y_min = axes_y.min(); // minimum limit of the y axis
      double y_max = axes_y.max(); // maximum limit of the y axes

      //std::cout << "xmin= " << x_min 
      //          << "ymin= " << y_min
      //          << '\n';


      //std::cout << "xmax= " << x_max 
      //          << "ymax= " << y_max
      //          << '\n';

      double xs = scale_to_window(Xmax, Xmin, x_min, x_max, x);
      double ys = scale_to_window(Ymax, Ymin, y_max, y_min, y);
      
      p.x = xs;
      p.y = ys;
      
return p;
}
//-----------------------------------------------------------------------


//-----------------------------------------------------------------------

Point Chart::convert_to_local_cs(const int& X, const int& Y){
Point p;
      int Xmax = width() - X_OFFSET; // maximum width of the window
      int Ymax = height() - Y_OFFSET; // maximum height of the window

      int Xmin = X_OFFSET;
      int Ymin = Y_OFFSET; 

      //std::cout << "x= " << x 
      //          << "y= " << y
      //          << '\n';

      double x_min = axes_x.min(); // minimum limit of the x axis
      double x_max = axes_x.max(); // maximum limit of the x axes

      double y_min = axes_y.min(); // minimum limit of the y axis
      double y_max = axes_y.max(); // maximum limit of the y axes

      //std::cout << "xmin= " << x_min 
      //          << "ymin= " << y_min
      //          << '\n';


      //std::cout << "xmax= " << x_max 
      //          << "ymax= " << y_max
      //          << '\n';

      double xs = window_to_local_cs(Xmax, Xmin, x_min, x_max, X);
      double ys = window_to_local_cs(Ymax, Ymin, y_max, y_min, Y);
      
      p.x = xs;
      p.y = ys;
      
return p;
}
//-----------------------------------------------------------------------

void Chart::paintEvent(QPaintEvent *event){
        std::cout << "define painter\n";
     QPainter painter(this);
     calculate_origin();
          std::cout << "painter defined\n";
       // draw X axis
       {
        painter.setPen( define_color(axes_x.color()) ); // should be defined based on the axis color property
        /////cout << axes_x.color() << '\n';
        Point p_min = convert_to_window_cs(axes_x.min(),0.0);
        Point p_max = convert_to_window_cs(axes_x.max(),0.0);

        double x_min = axes_x.min();
        double x_max = axes_x.max();
        ///////////////////////std::cout << x_min << '\n';
        double step = (x_max - x_min) / ( axes_x.notches() - 1 );

        painter.drawLine(QPoint(p_min.x, Y0), QPoint(p_max.x, Y0));

        // let's draw notches for the X axes
            double d = (p_max.x - p_min.x) / ( axes_x.notches()-1 ); // step for each notch
            ///////////////////////////////////////////////////cout << axes_x.notches() << '\n';
            for(int i = 1; i <= axes_x.notches();++i){
              painter.drawLine(QPoint(p_min.x + (i-1)*d, Y0 - NOTCH_SIZE), 
                               QPoint(p_min.x + (i-1)*d, Y0 + NOTCH_SIZE)
                               );

             painter.save(); // save current state of the painter

             QTransform transform;
             transform.translate(
                                 width() / 2 ,
                                 height() - Y_OFFSET / 2
                                );
             transform.rotate(0.0);

             Note nt( QString( axes_x.label().c_str() ) );
             /////std::cout << nt.text().toStdString() << '\n';

             //nt.set_font(Note::bold);
                        
             painter.setTransform(transform);
             painter.setFont( nt.convert_to_qt_font() );

             painter.drawText( QPoint(0,0),
                               nt.text()
                              );
             //std::cout << "text: " << nt.text().toStdString() << '\n';
             painter.restore(); //restore painter initial status
             /*
             painter.drawText( X0 + (p_max.x - X0) * 3 / 4, 
                               Y0 + 4 * NOTCH_SIZE, 
                               QString( axes_x.label().c_str() )
                              );
             */

             ///transform.rotate(-90.0);
 
             // Note nt_x(QPoint( (p_min.x + p_max.x)/2, Y0 + 10), 
             //                   QStringList() << axes_x.label().c_str(),
             //                   this);

              // code to give a notation to the axis notches 
              QByteArray ba = QByteArray::number(x_min + (i-1)*step,'f',axes_x.accuracy()); 
              painter.drawText(p_min.x + (i-1)*d, Y0 + 4 * NOTCH_SIZE, QString(ba));            
           } 

       }

       // draw Y axis
       {
        painter.setPen(define_color(axes_y.color())); // should be defined based on the axis color property
        Point p_min = convert_to_window_cs(0.0, axes_y.min());
        Point p_max = convert_to_window_cs(0.0, axes_y.max());

        double y_min = axes_y.min();
        double y_max = axes_y.max();
        ///////////////////////std::cout << x_min << '\n';
        double step = (y_max - y_min) / ( axes_y.notches()-1 );


        painter.drawLine(QPoint(X0, p_min.y), QPoint(X0, p_max.y));            
        
        // let's draw notches for the Y axes
            double d = (p_max.y - p_min.y) / ( axes_y.notches()-1 ); // step for each notch
            ///////////////////////////////////////////////////cout << axes_x.notches() << '\n';
            for(int i = 1; i <= axes_y.notches();++i){
              painter.drawLine(QPoint(X0 - NOTCH_SIZE, p_min.y + (i-1)*d), 
                               QPoint(X0 + NOTCH_SIZE, p_min.y + (i-1)*d)
                               );  


             painter.save(); // save current state of the painter

             QTransform transform;
             transform.translate(
                                 X_OFFSET / 2,
                                 height() / 2
                                );
             transform.rotate(-90.0);

             Note nt( QString( axes_y.label().c_str() ) );
             /////std::cout << nt.text().toStdString() << '\n';

             ///nt.set_font(Note::bold);
                        
             painter.setTransform(transform);
             painter.setFont( nt.convert_to_qt_font() );

             painter.drawText( QPoint(0,0),
                               nt.text()
                              );
             
             painter.restore(); //restore painter initial status

            
            // code to give a notation to the axis notches  
              QByteArray ba = QByteArray::number(y_min + (i-1)*step,'f',axes_y.accuracy());
              painter.drawText(X0 + 4 * NOTCH_SIZE, p_min.y + (i-1)*d, QString(ba));            
            }
       }


       // draw plots
       {
         //std::cout << "plots: " << plots.size() << '\n';
         //std::cout << "X0: " << X0 << '\n';
         //std::cout << "Y0: " << Y0 << '\n';
   
         int color = 0;
         int legend_item = 0; // point to legend item number
  
         for(int i=0; i < plots.size(); ++i){
               if (color >= MAX_COLORS ) return;

               QPen pen;
               pen.setColor(define_color(color));
               if (i==high_light) { 
                                    pen.setWidth(4 * DEFAULT_WIDTH);
                                    
              
                                   }
               else{
                                    pen.setWidth(DEFAULT_WIDTH);
                                    
               }   
               painter.setPen(pen);
               painter.drawLine(QPoint(legend_position.x() ,legend_position.y() - 20 * legend_item ),
                                QPoint(legend_position.x() + 20,legend_position.y() - 20 * legend_item)
                               ); // 20 is a line lenght on the legend
               painter.drawText(QPoint(legend_position.x() + 40,legend_position.y()- 20 * legend_item),
                                QString(plots[i].name().c_str())
                               );
               ++legend_item; 
               
               Point p1 = (plots[i])(0); // take first point hopefully it exists
               p1 = convert_to_window_cs(p1.x,p1.y);

               ///std::cout << p1 << '\n';
                           
               for(int j = 1; j < plots[i].size(); ++j){ // transform each point
                   Point p2 = (plots[i])(j);
                   p2 = convert_to_window_cs(p2.x,p2.y);
                   ///std::cout << p2 << '\n';

                   painter.drawLine(
                                    QPoint(p1.x, p1.y), 
                                    QPoint(p2.x, p2.y)
                                    );            
                   p1.x = p2.x;
                   p1.y = p2.y;

               }
         ++color;  
         }
       }

   if (display_location &&
       cursor_location.y() >= Y_OFFSET &&  cursor_location.y() <= height() - Y_OFFSET &&
       cursor_location.x() >= X_OFFSET &&  cursor_location.x() <= width() - X_OFFSET
      )
       //draw lines of the cursor position
       {
                   painter.save();
                   QPen pen;
                   pen.setStyle(Qt::DashLine);
                   pen.setWidth(DEFAULT_WIDTH);

                   painter.setPen(pen);

                   painter.drawLine(
                                    QPoint(cursor_location.x(), Y_OFFSET), 
                                    QPoint(cursor_location.x(), height() - Y_OFFSET)
                                    );

                   painter.drawLine(
                                    QPoint(X_OFFSET, cursor_location.y()), 
                                    QPoint(width() - X_OFFSET, cursor_location.y())
                                    );
                   
                   Point p = convert_to_local_cs(cursor_location.x(), cursor_location.y());
                   QByteArray ba = QByteArray::number(p.x,'f',axes_x.accuracy());

                   string x_tip = axes_x.label() + ": " + QString(ba).toStdString();

                   ba = QByteArray::number(p.y,'f',axes_y.accuracy());
                   string y_tip = axes_y.label() + ": " + QString(ba).toStdString();
                   
                   painter.drawText( QPoint(
                                            cursor_location.x() + 4 * NOTCH_SIZE,
                                            cursor_location.y() - 8 * NOTCH_SIZE
                                            ),
                                      QString(x_tip.c_str())
                                     ); 

                   painter.drawText( QPoint(
                                            cursor_location.x() + 4 * NOTCH_SIZE,
                                            cursor_location.y() - 4 * NOTCH_SIZE
                                            ),
                                      QString(y_tip.c_str())
                                     ); 

                   painter.restore(); 
       }

   if (new_legend_position &&
       cursor_location.y() >= Y_OFFSET &&  cursor_location.y() <= height() - Y_OFFSET &&
       cursor_location.x() >= X_OFFSET &&  cursor_location.x() <= width() - X_OFFSET
      )
      legend_position = cursor_location;


       
}

//-----------------------------------------------------------------------------

void Chart::resizeEvent(QResizeEvent *event){
// update parameters during resize event
calculate_origin();

}

//-----------------------------------------------------------------------------
Qt::GlobalColor Chart::define_color(const Curve::Color& clr){

    switch(clr){
    case Curve::Color::black: return Qt::black; 
    case Curve::Color::brown: return Qt::darkGray; 
    case Curve::Color::red: return Qt::red; 
    case Curve::Color::orange: return Qt::darkRed; 
    case Curve::Color::yellow: return Qt::yellow; 
    case Curve::Color::green: return Qt::green; 
    case Curve::Color::blue: return Qt::blue; 
    case Curve::Color::violet: return Qt::darkBlue; 
    default :
            error("no such color");
    };
}

Qt::GlobalColor Chart::define_color(const int& clr){

    switch(clr){
    case 0: return Qt::black; 
    case 1: return Qt::darkGray; 
    case 2: return Qt::red; 
    case 3: return Qt::darkRed; 
    case 4: return Qt::yellow; 
    case 5: return Qt::green; 
    case 6: return Qt::blue; 
    case 7: return Qt::darkBlue; 
    default :
            error("no such color");
    };
}


//-------------------------------------------------------------------------------
void Chart::mouseMoveEvent(QMouseEvent *event){

    cursor_location = event->pos();
    update();
/*
  std::cout << "x = " << cursor_location.x()
            << "y = " << cursor_location.y()
            << '\n';
*/
         
}

//-----------------------------------------------------------------------------------
int Chart::define_curve(const vector<double>& x, const vector<double>& y, const string& name){
Curve curve(x,y);
curve.name() = name;
add_plot(curve);
update();
return 0;
}
