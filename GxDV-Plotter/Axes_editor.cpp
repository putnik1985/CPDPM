
#include "Axes_editor.h"


Axes_editor::Axes_editor(const QString& name, QWidget* parent):
QDialog(parent)
{
   setWindowTitle(name);
   axes_title_edit = new QLineEdit;
   apply_button = new QPushButton("Apply");
   ok_button = new QPushButton("Accept");

   QHBoxLayout *hlayout = new QHBoxLayout;
   hlayout->addWidget(apply_button);
   hlayout->addWidget(ok_button);

   QVBoxLayout *vlayout = new QVBoxLayout;
   vlayout->addWidget(axes_title_edit);
   vlayout->addLayout(hlayout);

   setLayout(vlayout);

  connect(
          ok_button, SIGNAL( clicked() ),
          this,SLOT( close_dialog() ) 
         ); // connect create project with action

  connect(
          apply_button, SIGNAL( clicked() ),
          this,SLOT( label() ) 
         ); // connect create project with action

  //connect(
  //        ok_button, SIGNAL( clicked() ),
  //        this,SLOT( reject() ) 
  //       ); // connect create project with action

  //connect(
  //        apply_button, SIGNAL( clicked() ),
  //        this,SLOT( accept() ) 
  //       ); // connect create project with action

}
