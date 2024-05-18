
#ifndef TABLE_WIDG_H
#define TABLE_WIDG_H

#include "Qt_lib.h"
#include "std_lib_facilities.h"

class Function_table: public QAbstractTableModel{
Q_OBJECT
public:
Function_table(QWidget* parent = 0);

int rowCount(const QModelIndex &parent) const;
int columnCount(const QModelIndex &parent) const;
QVariant data(const QModelIndex &index, int role) const;
QVariant headerData(int section, Qt::Orientation orientation,int role) const;

bool setData(const QModelIndex &index, const QVariant &value,int role);

Qt::ItemFlags flags(const QModelIndex &index) const;

bool insertRows(int count, const QModelIndex& parent = QModelIndex() );
bool removeRows(int count, const QModelIndex& parent = QModelIndex() );

vector<double> x_data() { return x; }
vector<double> y_data() { return y; }

public slots:
bool append_row();
bool remove_row();

int set_columns(
             const vector<double>& vx,
             const vector<double>& vy
             )
{
x = vx ;
y = vy ;
return 0;
}

private:
vector<double> x{0.0,0.0};
vector<double> y{0.0,0.0};

};

class XY_Table: public QDialog{
Q_OBJECT
public:
XY_Table(QWidget* parent = 0);

int set_columns(
             const vector<double>& vx,
             const vector<double>& vy
             )
{
tbl.set_columns(vx,vy);
}

vector<double> x_data() { return tbl.x_data(); }
vector<double> y_data() { return tbl.y_data(); }
QString title() const {return curve_name->text(); }

signals:
void data_changed(const vector<double>& x, const vector<double>& y, const string& name);

private slots:
int read_data() { vector<double> x = x_data();
                  vector<double> y = y_data();
                  string name = title().toStdString();
                  emit data_changed(x, y, name);
                  close(); 
                  return 0;
                }

private:
Function_table tbl;

QTableView *tableView;
QPushButton *add_row_button;
QPushButton *remove_row_button;
//QPushButton *apply_button;
QPushButton *accept_button;
QLineEdit *curve_name;

};

#endif
