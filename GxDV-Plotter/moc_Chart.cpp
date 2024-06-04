/****************************************************************************
** Meta object code from reading C++ file 'Chart.h'
**
** Created by: The Qt Meta Object Compiler version 63 (Qt 4.8.7)
**
** WARNING! All changes made in this file will be lost!
*****************************************************************************/

#include "Chart.h"
#if !defined(Q_MOC_OUTPUT_REVISION)
#error "The header file 'Chart.h' doesn't include <QObject>."
#elif Q_MOC_OUTPUT_REVISION != 63
#error "This file was generated using the moc from 4.8.7. It"
#error "cannot be used with the include files from this version of Qt."
#error "(The moc has changed too much.)"
#endif

QT_BEGIN_MOC_NAMESPACE
static const uint qt_meta_data_Chart[] = {

 // content:
       6,       // revision
       0,       // classname
       0,    0, // classinfo
      16,   14, // methods
       0,    0, // properties
       0,    0, // enums/sets
       0,    0, // constructors
       0,       // flags
       0,       // signalCount

 // slots: signature, parameters, type, tag, flags
      17,   11,    7,    6, 0x0a,
      41,   36,    7,    6, 0x0a,
      75,   69,    7,    6, 0x0a,
      95,   69,    7,    6, 0x0a,
     119,  115,    7,    6, 0x0a,
     141,  137,    7,    6, 0x0a,
     169,  159,    7,    6, 0x0a,
     200,  190,    7,    6, 0x0a,
     224,  115,    7,    6, 0x0a,
     242,  137,    7,    6, 0x0a,
     260,  159,    7,    6, 0x0a,
     281,  190,    7,    6, 0x0a,
     314,  305,    7,    6, 0x0a,
     365,    6,    6,    6, 0x0a,
     365,    6,    6,    6, 0x0a,
     379,  374,    7,    6, 0x0a,

       0        // eod
};

static const char qt_meta_stringdata_Chart[] = {
    "Chart\0\0int\0index\0set_highlight(int)\0"
    "name\0set_highlight_name(QString)\0label\0"
    "set_x_label(string)\0set_y_label(string)\0"
    "min\0set_x_min(double)\0max\0set_x_max(double)\0"
    "intervals\0set_x_intervals(int)\0precision\0"
    "set_x_precision(double)\0set_y_min(double)\0"
    "set_y_max(double)\0set_y_intervals(int)\0"
    "set_y_precision(double)\0x,y,name\0"
    "define_curve(vector<double>,vector<double>,string)\0"
    "curves()\0plts\0redefine_plots(Curves)\0"
};

void Chart::qt_static_metacall(QObject *_o, QMetaObject::Call _c, int _id, void **_a)
{
    if (_c == QMetaObject::InvokeMetaMethod) {
        Q_ASSERT(staticMetaObject.cast(_o));
        Chart *_t = static_cast<Chart *>(_o);
        switch (_id) {
        case 0: { int _r = _t->set_highlight((*reinterpret_cast< int(*)>(_a[1])));
            if (_a[0]) *reinterpret_cast< int*>(_a[0]) = _r; }  break;
        case 1: { int _r = _t->set_highlight_name((*reinterpret_cast< const QString(*)>(_a[1])));
            if (_a[0]) *reinterpret_cast< int*>(_a[0]) = _r; }  break;
        case 2: { int _r = _t->set_x_label((*reinterpret_cast< const string(*)>(_a[1])));
            if (_a[0]) *reinterpret_cast< int*>(_a[0]) = _r; }  break;
        case 3: { int _r = _t->set_y_label((*reinterpret_cast< const string(*)>(_a[1])));
            if (_a[0]) *reinterpret_cast< int*>(_a[0]) = _r; }  break;
        case 4: { int _r = _t->set_x_min((*reinterpret_cast< const double(*)>(_a[1])));
            if (_a[0]) *reinterpret_cast< int*>(_a[0]) = _r; }  break;
        case 5: { int _r = _t->set_x_max((*reinterpret_cast< const double(*)>(_a[1])));
            if (_a[0]) *reinterpret_cast< int*>(_a[0]) = _r; }  break;
        case 6: { int _r = _t->set_x_intervals((*reinterpret_cast< const int(*)>(_a[1])));
            if (_a[0]) *reinterpret_cast< int*>(_a[0]) = _r; }  break;
        case 7: { int _r = _t->set_x_precision((*reinterpret_cast< const double(*)>(_a[1])));
            if (_a[0]) *reinterpret_cast< int*>(_a[0]) = _r; }  break;
        case 8: { int _r = _t->set_y_min((*reinterpret_cast< const double(*)>(_a[1])));
            if (_a[0]) *reinterpret_cast< int*>(_a[0]) = _r; }  break;
        case 9: { int _r = _t->set_y_max((*reinterpret_cast< const double(*)>(_a[1])));
            if (_a[0]) *reinterpret_cast< int*>(_a[0]) = _r; }  break;
        case 10: { int _r = _t->set_y_intervals((*reinterpret_cast< const int(*)>(_a[1])));
            if (_a[0]) *reinterpret_cast< int*>(_a[0]) = _r; }  break;
        case 11: { int _r = _t->set_y_precision((*reinterpret_cast< const double(*)>(_a[1])));
            if (_a[0]) *reinterpret_cast< int*>(_a[0]) = _r; }  break;
        case 12: { int _r = _t->define_curve((*reinterpret_cast< const vector<double>(*)>(_a[1])),(*reinterpret_cast< const vector<double>(*)>(_a[2])),(*reinterpret_cast< const string(*)>(_a[3])));
            if (_a[0]) *reinterpret_cast< int*>(_a[0]) = _r; }  break;
        case 13: _t->curves(); break;
        case 14: _t->curves(); break;
        case 15: { int _r = _t->redefine_plots((*reinterpret_cast< const Curves(*)>(_a[1])));
            if (_a[0]) *reinterpret_cast< int*>(_a[0]) = _r; }  break;
        default: ;
        }
    }
}

const QMetaObjectExtraData Chart::staticMetaObjectExtraData = {
    0,  qt_static_metacall 
};

const QMetaObject Chart::staticMetaObject = {
    { &QWidget::staticMetaObject, qt_meta_stringdata_Chart,
      qt_meta_data_Chart, &staticMetaObjectExtraData }
};

#ifdef Q_NO_DATA_RELOCATION
const QMetaObject &Chart::getStaticMetaObject() { return staticMetaObject; }
#endif //Q_NO_DATA_RELOCATION

const QMetaObject *Chart::metaObject() const
{
    return QObject::d_ptr->metaObject ? QObject::d_ptr->metaObject : &staticMetaObject;
}

void *Chart::qt_metacast(const char *_clname)
{
    if (!_clname) return 0;
    if (!strcmp(_clname, qt_meta_stringdata_Chart))
        return static_cast<void*>(const_cast< Chart*>(this));
    return QWidget::qt_metacast(_clname);
}

int Chart::qt_metacall(QMetaObject::Call _c, int _id, void **_a)
{
    _id = QWidget::qt_metacall(_c, _id, _a);
    if (_id < 0)
        return _id;
    if (_c == QMetaObject::InvokeMetaMethod) {
        if (_id < 16)
            qt_static_metacall(this, _c, _id, _a);
        _id -= 16;
    }
    return _id;
}
QT_END_MOC_NAMESPACE
