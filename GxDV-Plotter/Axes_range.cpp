
#include "Axes_range.h"

Axes_range::Axes_range(const QString& name, QWidget* parent):
QDialog(parent)
{
   setWindowTitle(name);

   axes_min_edit = new QLineEdit;
   axes_max_edit = new QLineEdit;
   axes_step_edit = new QLineEdit;
   axes_precision_edit = new QLineEdit;

   axes_min_label = new QLabel(tr("Minimum"));
   axes_min_label->setBuddy(axes_min_edit);

   axes_max_label = new QLabel(tr("Maximum")); 
   axes_max_label->setBuddy(axes_max_edit);

   axes_step_label = new QLabel(tr("Intervals"));
   axes_step_label->setBuddy(axes_step_edit);

   axes_precision_label = new QLabel(tr("Number Precision"));
   axes_precision_label->setBuddy(axes_precision_edit);

   apply_button = new QPushButton("Apply");
   ok_button = new QPushButton("Accept");
   
   QHBoxLayout *hlayout = new QHBoxLayout;
   hlayout->addWidget(apply_button);
   hlayout->addWidget(ok_button);

   QHBoxLayout *h_minlayout = new QHBoxLayout;
   h_minlayout->addWidget(axes_min_label);
   h_minlayout->addWidget(axes_min_edit);

   QHBoxLayout *h_maxlayout = new QHBoxLayout;
   h_maxlayout->addWidget(axes_max_label);
   h_maxlayout->addWidget(axes_max_edit);


   QHBoxLayout *h_steplayout = new QHBoxLayout;
   h_steplayout->addWidget(axes_step_label);
   h_steplayout->addWidget(axes_step_edit);

   QHBoxLayout *h_precisionlayout = new QHBoxLayout;
   h_precisionlayout->addWidget(axes_precision_label);
   h_precisionlayout->addWidget(axes_precision_edit);

   QVBoxLayout *vlayout = new QVBoxLayout;
   vlayout->addLayout(h_minlayout);
   vlayout->addLayout(h_maxlayout);
   vlayout->addLayout(h_steplayout);
   vlayout->addLayout(h_precisionlayout);
   vlayout->addLayout(hlayout);

   setLayout(vlayout);


  connect(
          ok_button, SIGNAL( clicked() ),
          this,SLOT( close_dialog() ) 
         ); // connect create project with action

  connect(
          apply_button, SIGNAL( clicked() ),
          this,SLOT( read_data() ) 
         ); // connect create project with action

}

//-----------------------------------------------------------------------
int Axes_range::read_data(){
bool done = true;

if( axes_min_edit->text() !="")
minimum = axes_min_edit->text().toDouble(&done);
if (!done) error("wrong number");

if( axes_max_edit->text() !="")
maximum = axes_max_edit->text().toDouble(&done);
if (!done) error("wrong number");

if( axes_step_edit->text() !="")
intervals = axes_step_edit->text().toInt(&done);
if (!done) error("wrong number");

if( axes_precision_edit->text() !="")
precision = axes_precision_edit->text().toDouble(&done);
if (!done) error("wrong number");


emit minimum_changed(minimum);
emit maximum_changed(maximum);
emit intervals_changed(intervals);
emit precision_changed(precision);

    
return 0;
}
