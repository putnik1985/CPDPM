/****************************************************************************
** Meta object code from reading C++ file 'Table_Widget.h'
**
** Created by: The Qt Meta Object Compiler version 63 (Qt 4.8.7)
**
** WARNING! All changes made in this file will be lost!
*****************************************************************************/

#include "Table_Widget.h"
#if !defined(Q_MOC_OUTPUT_REVISION)
#error "The header file 'Table_Widget.h' doesn't include <QObject>."
#elif Q_MOC_OUTPUT_REVISION != 63
#error "This file was generated using the moc from 4.8.7. It"
#error "cannot be used with the include files from this version of Qt."
#error "(The moc has changed too much.)"
#endif

QT_BEGIN_MOC_NAMESPACE
static const uint qt_meta_data_Function_table[] = {

 // content:
       6,       // revision
       0,       // classname
       0,    0, // classinfo
       3,   14, // methods
       0,    0, // properties
       0,    0, // enums/sets
       0,    0, // constructors
       0,       // flags
       0,       // signalCount

 // slots: signature, parameters, type, tag, flags
      21,   15,   16,   15, 0x0a,
      34,   15,   16,   15, 0x0a,
      57,   51,   47,   15, 0x0a,

       0        // eod
};

static const char qt_meta_stringdata_Function_table[] = {
    "Function_table\0\0bool\0append_row()\0"
    "remove_row()\0int\0vx,vy\0"
    "set_columns(vector<double>,vector<double>)\0"
};

void Function_table::qt_static_metacall(QObject *_o, QMetaObject::Call _c, int _id, void **_a)
{
    if (_c == QMetaObject::InvokeMetaMethod) {
        Q_ASSERT(staticMetaObject.cast(_o));
        Function_table *_t = static_cast<Function_table *>(_o);
        switch (_id) {
        case 0: { bool _r = _t->append_row();
            if (_a[0]) *reinterpret_cast< bool*>(_a[0]) = _r; }  break;
        case 1: { bool _r = _t->remove_row();
            if (_a[0]) *reinterpret_cast< bool*>(_a[0]) = _r; }  break;
        case 2: { int _r = _t->set_columns((*reinterpret_cast< const vector<double>(*)>(_a[1])),(*reinterpret_cast< const vector<double>(*)>(_a[2])));
            if (_a[0]) *reinterpret_cast< int*>(_a[0]) = _r; }  break;
        default: ;
        }
    }
}

const QMetaObjectExtraData Function_table::staticMetaObjectExtraData = {
    0,  qt_static_metacall 
};

const QMetaObject Function_table::staticMetaObject = {
    { &QAbstractTableModel::staticMetaObject, qt_meta_stringdata_Function_table,
      qt_meta_data_Function_table, &staticMetaObjectExtraData }
};

#ifdef Q_NO_DATA_RELOCATION
const QMetaObject &Function_table::getStaticMetaObject() { return staticMetaObject; }
#endif //Q_NO_DATA_RELOCATION

const QMetaObject *Function_table::metaObject() const
{
    return QObject::d_ptr->metaObject ? QObject::d_ptr->metaObject : &staticMetaObject;
}

void *Function_table::qt_metacast(const char *_clname)
{
    if (!_clname) return 0;
    if (!strcmp(_clname, qt_meta_stringdata_Function_table))
        return static_cast<void*>(const_cast< Function_table*>(this));
    return QAbstractTableModel::qt_metacast(_clname);
}

int Function_table::qt_metacall(QMetaObject::Call _c, int _id, void **_a)
{
    _id = QAbstractTableModel::qt_metacall(_c, _id, _a);
    if (_id < 0)
        return _id;
    if (_c == QMetaObject::InvokeMetaMethod) {
        if (_id < 3)
            qt_static_metacall(this, _c, _id, _a);
        _id -= 3;
    }
    return _id;
}
static const uint qt_meta_data_XY_Table[] = {

 // content:
       6,       // revision
       0,       // classname
       0,    0, // classinfo
       2,   14, // methods
       0,    0, // properties
       0,    0, // enums/sets
       0,    0, // constructors
       0,       // flags
       1,       // signalCount

 // signals: signature, parameters, type, tag, flags
      19,   10,    9,    9, 0x05,

 // slots: signature, parameters, type, tag, flags
      74,    9,   70,    9, 0x08,

       0        // eod
};

static const char qt_meta_stringdata_XY_Table[] = {
    "XY_Table\0\0x,y,name\0"
    "data_changed(vector<double>,vector<double>,string)\0"
    "int\0read_data()\0"
};

void XY_Table::qt_static_metacall(QObject *_o, QMetaObject::Call _c, int _id, void **_a)
{
    if (_c == QMetaObject::InvokeMetaMethod) {
        Q_ASSERT(staticMetaObject.cast(_o));
        XY_Table *_t = static_cast<XY_Table *>(_o);
        switch (_id) {
        case 0: _t->data_changed((*reinterpret_cast< const vector<double>(*)>(_a[1])),(*reinterpret_cast< const vector<double>(*)>(_a[2])),(*reinterpret_cast< const string(*)>(_a[3]))); break;
        case 1: { int _r = _t->read_data();
            if (_a[0]) *reinterpret_cast< int*>(_a[0]) = _r; }  break;
        default: ;
        }
    }
}

const QMetaObjectExtraData XY_Table::staticMetaObjectExtraData = {
    0,  qt_static_metacall 
};

const QMetaObject XY_Table::staticMetaObject = {
    { &QDialog::staticMetaObject, qt_meta_stringdata_XY_Table,
      qt_meta_data_XY_Table, &staticMetaObjectExtraData }
};

#ifdef Q_NO_DATA_RELOCATION
const QMetaObject &XY_Table::getStaticMetaObject() { return staticMetaObject; }
#endif //Q_NO_DATA_RELOCATION

const QMetaObject *XY_Table::metaObject() const
{
    return QObject::d_ptr->metaObject ? QObject::d_ptr->metaObject : &staticMetaObject;
}

void *XY_Table::qt_metacast(const char *_clname)
{
    if (!_clname) return 0;
    if (!strcmp(_clname, qt_meta_stringdata_XY_Table))
        return static_cast<void*>(const_cast< XY_Table*>(this));
    return QDialog::qt_metacast(_clname);
}

int XY_Table::qt_metacall(QMetaObject::Call _c, int _id, void **_a)
{
    _id = QDialog::qt_metacall(_c, _id, _a);
    if (_id < 0)
        return _id;
    if (_c == QMetaObject::InvokeMetaMethod) {
        if (_id < 2)
            qt_static_metacall(this, _c, _id, _a);
        _id -= 2;
    }
    return _id;
}

// SIGNAL 0
void XY_Table::data_changed(const vector<double> & _t1, const vector<double> & _t2, const string & _t3)
{
    void *_a[] = { 0, const_cast<void*>(reinterpret_cast<const void*>(&_t1)), const_cast<void*>(reinterpret_cast<const void*>(&_t2)), const_cast<void*>(reinterpret_cast<const void*>(&_t3)) };
    QMetaObject::activate(this, &staticMetaObject, 0, _a);
}
QT_END_MOC_NAMESPACE
