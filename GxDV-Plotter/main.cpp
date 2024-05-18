
#include "Curve.h"
#include "Chart.h"
#include "Note.h"
#include "Plotter.h"
#include "Table_Widget.h"
#include "Plot_name.h"

int main(int argc, char** argv){



//Curve v1("curve #1");
      //cout << v1.name() << '\n';
      //cout << v1.size() << '\n';

//      cin >> v1;
//      cout << v1;

///Curve v2(v1);
////      cout << v2;

//Curve v3;
      
//      cout << " create new curve\n";
//      v3 = v1;
//      v3.name() = "curve #2";
//      v3.color() = Curve::red;
//      v3.style() = Curve::dash; 
//      cout << v3;

QApplication app(argc,argv);




//Note nt( QPoint(400,400), 
//         QStringList() << "first line" << "second line" << "third line"         
//        );
//nt.set_font(Note::bold);
//nt.set_font_size(12.0);
//nt.display();


/*
Chart chart;
chart.set_geometry(100,100,1024,800);
chart.display();
*/


//vector<double> v1{1,2,3}, v2{5,6,7};
//XY_Table table;
//table.show();
/*/
Function_table ftable;
ftable.set_columns(v1,v2);

    QTableView tableView;
    tableView.setModel(&ftable);
    tableView.setAlternatingRowColors(true);
    tableView.setWindowTitle(QObject::tr("Simple Table"));
    tableView.show();

    tableView.show();
*/

//Plot_name pn(QStringList() << "first" << "second" << "third");
//pn.show();


Plotter plot;
plot.show();


return app.exec();

}
