
#ifndef AXES_EDIT_H
#define AXES_EDIT_H

#include "Qt_lib.h"
#include "std_lib_facilities.h"

class Axes_editor: public QDialog{

Q_OBJECT

public:
Axes_editor(const QString& name, QWidget* parent = 0);
const string& edit_name() const { return title; }

signals:
void title_changed(const string& label);

private slots:
int label() { title = axes_title_edit->text().toStdString(); emit title_changed(title); return 0; }
int close_dialog() { title = axes_title_edit->text().toStdString(); emit title_changed(title); close(); return 0; }

private:
QLineEdit *axes_title_edit;
QPushButton *apply_button;
QPushButton *ok_button;
string title;

};



#endif
