
#ifndef PLOT_NAME_H
#define PLOT_NAME_H

#include "Qt_lib.h"
#include "std_lib_facilities.h"

class Plot_name: public QDialog{
Q_OBJECT
public:
Plot_name(const QStringList& list, QWidget *parent = 0 );
QString text() const { return curves_name_combo->currentText(); }
QString new_name() const { return new_name_edit->text(); }

signals:
void curve_changed(int index);
void new_name(const QString name);

private slots:
int current_index(int index) { std::cout << "index:" << index << '\n'; return 0; }

private:
QComboBox *curves_name_combo;
QLineEdit *new_name_edit;
QPushButton *accept_button;
QPushButton *close_button;

};

#endif
