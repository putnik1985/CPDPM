#ifndef AXES_RANGE_H
#define AXES_RANGE_H

#include "Qt_lib.h"
#include "std_lib_facilities.h"

class Axes_range: public QDialog{

Q_OBJECT

public:
Axes_range(const QString& name, QWidget* parent = 0);
const double& max() const {return maximum;}
const double& min() const {return minimum;}
const int& axes_intervals() const {return intervals;}
const double& axes_precision() const {return precision;}

signals:
void minimum_changed(const double& min);
void maximum_changed(const double& max);
void intervals_changed(const int& intervals);
void precision_changed(const double& precision);


private slots:
int read_data();
int close_dialog() { read_data(); close(); return 0; }
private:
QLineEdit *axes_min_edit;
QLineEdit *axes_max_edit;
QLineEdit *axes_step_edit;
QLineEdit *axes_precision_edit;

QLabel *axes_min_label;
QLabel *axes_max_label;
QLabel *axes_step_label;
QLabel *axes_precision_label;
 
QPushButton *apply_button;
QPushButton *ok_button;

double minimum;
double maximum;
int intervals;
double precision;


};

#endif
