
#include "Table_Widget.h"

Function_table::Function_table(QWidget* parent):
QAbstractTableModel(parent)
{}

//------------------------------------------------------
int Function_table::rowCount(const QModelIndex &parent) const
{
return x.size();
}

//--------------------------------------------------------
int Function_table::columnCount(const QModelIndex &parent) const
{
return 2; // because we have only 2 columns x & y
};

//--------------------------------------------------------
QVariant Function_table::data(const QModelIndex &index, int role) const{

   if ( !index.isValid() ) return QVariant();

   if(role==Qt::TextAlignmentRole)
     return int(Qt::AlignRight | Qt::AlignVCenter);
   else
        if (role == Qt::DisplayRole){

            if (index.column() == 0) // if it is 1st columnn
            return x[index.row()];

            if (index.column() == 1) // if it is 2nd columnn
            return y[index.row()];

        }
}

//-----------------------------------------------------------
QVariant Function_table::headerData(int section, Qt::Orientation orientation,
                                    int role) const
{
    if (role == Qt::DisplayRole){
        if(orientation == Qt::Horizontal){
           if (section==0) return QString("X");
           if (section==1) return QString("Y");
        } 
    }
    return QVariant();
}

//------------------------------------------------------------
XY_Table::XY_Table(QWidget* parent):
QDialog(parent)
{

curve_name = new QLineEdit(this);
add_row_button = new QPushButton("Add Row", this);;
remove_row_button = new QPushButton("Delete Row", this);
///apply_button = new QPushButton("Apply", this);
accept_button = new QPushButton("Accept", this);

    QHBoxLayout *h_layout1 = new QHBoxLayout;
    h_layout1->addWidget(add_row_button);
    h_layout1->addWidget(remove_row_button);

    QHBoxLayout *h_layout2 = new QHBoxLayout;
    ///h_layout2->addWidget(apply_button);
    h_layout2->addWidget(accept_button);

    tableView = new QTableView(this);
    
    tableView->setModel(&tbl);
    tableView->setAlternatingRowColors(true);
    tableView->setWindowTitle(QObject::tr("Function Table"));

    QVBoxLayout *mainlayout = new QVBoxLayout;

    mainlayout->addWidget(curve_name);
    mainlayout->addWidget(tableView);
    mainlayout->addLayout(h_layout1);
    mainlayout->addLayout(h_layout2);   
    setLayout(mainlayout);

    connect(add_row_button, SIGNAL( clicked() ),
            &tbl, SLOT( append_row() )
           );

    connect(remove_row_button, SIGNAL( clicked() ),
            &tbl, SLOT( remove_row() )
           );


    connect(accept_button, SIGNAL( clicked() ),
           this, SLOT( read_data() )
           );
//*/

}

//--------------------------------------------------------------
bool Function_table::setData(const QModelIndex &index, const QVariant &value,
                      int role){
     if (index.isValid() && role == Qt::EditRole ){
         if ( index.column() == 0 ) x[index.row()] = value.toDouble();
         if ( index.column() == 1 ) y[index.row()] = value.toDouble();
         emit dataChanged(index, index);
         return true;
     }

     return false;
}

//----------------------------------------------------------------
Qt::ItemFlags Function_table::flags(const QModelIndex &index) const{

    Qt::ItemFlags flags = QAbstractItemModel::flags(index);
    flags |= Qt::ItemIsEditable;
                          return flags; 

}

//-------------------------------------------------------------------
bool Function_table::append_row(){

insertRows(1);
////std::cout << "insert row:\n";
return true;
}

//------------------------------------------------------------------------

bool Function_table::insertRows(int count, const QModelIndex& parent){

     //if (row<0 || row > x.size()) return false;

     beginInsertRows(parent, x.size(), x.size() + count - 1 ); 

     for(int i=0;i<count;++i)
         x.push_back(0.0);

     for(int i=0;i<count;++i)
         y.push_back(0.0);

     endInsertRows();

return true;
}

//-------------------------------------------------------------------
bool Function_table::remove_row(){
removeRows(1);
///std::cout << " remove row:\n";
return true;
}

//--------------------------------------------------------------------

bool Function_table::removeRows(int count, const QModelIndex& parent){

beginRemoveRows(parent, x.size()-1, x.size()-1);

    vector<double> v(x.size()-1);
    x = v;
    y = v;

endRemoveRows();
////std::cout << "size: " << x.size() << '\n';
return true;
}



