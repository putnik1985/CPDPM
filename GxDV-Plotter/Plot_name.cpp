
#include "Plot_name.h"

Plot_name::Plot_name(const QStringList& list, QWidget *parent):
QDialog(parent){

curves_name_combo = new QComboBox(this);

     // populate combo
     curves_name_combo->addItems(list);

new_name_edit = new QLineEdit(this);
accept_button = new QPushButton("Accept", this);
close_button = new QPushButton("Close", this);

        QVBoxLayout *mainlayout = new QVBoxLayout;
        mainlayout->addWidget(curves_name_combo);
        mainlayout->addWidget(new_name_edit);

        QHBoxLayout *hlayout = new QHBoxLayout;
        hlayout->addWidget(accept_button);
        hlayout->addWidget(close_button);

        mainlayout->addLayout(hlayout);
        setLayout(mainlayout);

        connect(
                accept_button, SIGNAL( clicked() ),
                this, SLOT( accept() ) 
               );

        connect(
                close_button, SIGNAL( clicked() ),
                this, SLOT( reject() ) 
               );

        connect(
                curves_name_combo, SIGNAL( currentIndexChanged(int) ),
                this, SIGNAL( curve_changed(int) ) 
               );

   //     connect(
   //             accept_button, SIGNAL( clicked() ),
   //             this, SIGNAL( new_name(const QString) ) 
   //            );

    //    connect(
    //            this, SIGNAL( curve_changed(int)),
   //             this, SLOT(current_index(int)) 
   //            );
     
}
