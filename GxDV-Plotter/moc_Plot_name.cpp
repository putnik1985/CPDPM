/****************************************************************************
** Meta object code from reading C++ file 'Plot_name.h'
**
** Created by: The Qt Meta Object Compiler version 63 (Qt 4.8.7)
**
** WARNING! All changes made in this file will be lost!
*****************************************************************************/

#include "Plot_name.h"
#if !defined(Q_MOC_OUTPUT_REVISION)
#error "The header file 'Plot_name.h' doesn't include <QObject>."
#elif Q_MOC_OUTPUT_REVISION != 63
#error "This file was generated using the moc from 4.8.7. It"
#error "cannot be used with the include files from this version of Qt."
#error "(The moc has changed too much.)"
#endif

QT_BEGIN_MOC_NAMESPACE
static const uint qt_meta_data_Plot_name[] = {

 // content:
       6,       // revision
       0,       // classname
       0,    0, // classinfo
       3,   14, // methods
       0,    0, // properties
       0,    0, // enums/sets
       0,    0, // constructors
       0,       // flags
       2,       // signalCount

 // signals: signature, parameters, type, tag, flags
      17,   11,   10,   10, 0x05,
      41,   36,   10,   10, 0x05,

 // slots: signature, parameters, type, tag, flags
      63,   11,   59,   10, 0x08,

       0        // eod
};

static const char qt_meta_stringdata_Plot_name[] = {
    "Plot_name\0\0index\0curve_changed(int)\0"
    "name\0new_name(QString)\0int\0"
    "current_index(int)\0"
};

void Plot_name::qt_static_metacall(QObject *_o, QMetaObject::Call _c, int _id, void **_a)
{
    if (_c == QMetaObject::InvokeMetaMethod) {
        Q_ASSERT(staticMetaObject.cast(_o));
        Plot_name *_t = static_cast<Plot_name *>(_o);
        switch (_id) {
        case 0: _t->curve_changed((*reinterpret_cast< int(*)>(_a[1]))); break;
        case 1: _t->new_name((*reinterpret_cast< const QString(*)>(_a[1]))); break;
        case 2: { int _r = _t->current_index((*reinterpret_cast< int(*)>(_a[1])));
            if (_a[0]) *reinterpret_cast< int*>(_a[0]) = _r; }  break;
        default: ;
        }
    }
}

const QMetaObjectExtraData Plot_name::staticMetaObjectExtraData = {
    0,  qt_static_metacall 
};

const QMetaObject Plot_name::staticMetaObject = {
    { &QDialog::staticMetaObject, qt_meta_stringdata_Plot_name,
      qt_meta_data_Plot_name, &staticMetaObjectExtraData }
};

#ifdef Q_NO_DATA_RELOCATION
const QMetaObject &Plot_name::getStaticMetaObject() { return staticMetaObject; }
#endif //Q_NO_DATA_RELOCATION

const QMetaObject *Plot_name::metaObject() const
{
    return QObject::d_ptr->metaObject ? QObject::d_ptr->metaObject : &staticMetaObject;
}

void *Plot_name::qt_metacast(const char *_clname)
{
    if (!_clname) return 0;
    if (!strcmp(_clname, qt_meta_stringdata_Plot_name))
        return static_cast<void*>(const_cast< Plot_name*>(this));
    return QDialog::qt_metacast(_clname);
}

int Plot_name::qt_metacall(QMetaObject::Call _c, int _id, void **_a)
{
    _id = QDialog::qt_metacall(_c, _id, _a);
    if (_id < 0)
        return _id;
    if (_c == QMetaObject::InvokeMetaMethod) {
        if (_id < 3)
            qt_static_metacall(this, _c, _id, _a);
        _id -= 3;
    }
    return _id;
}

// SIGNAL 0
void Plot_name::curve_changed(int _t1)
{
    void *_a[] = { 0, const_cast<void*>(reinterpret_cast<const void*>(&_t1)) };
    QMetaObject::activate(this, &staticMetaObject, 0, _a);
}

// SIGNAL 1
void Plot_name::new_name(const QString _t1)
{
    void *_a[] = { 0, const_cast<void*>(reinterpret_cast<const void*>(&_t1)) };
    QMetaObject::activate(this, &staticMetaObject, 1, _a);
}
QT_END_MOC_NAMESPACE
