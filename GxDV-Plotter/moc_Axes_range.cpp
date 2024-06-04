/****************************************************************************
** Meta object code from reading C++ file 'Axes_range.h'
**
** Created by: The Qt Meta Object Compiler version 63 (Qt 4.8.7)
**
** WARNING! All changes made in this file will be lost!
*****************************************************************************/

#include "Axes_range.h"
#if !defined(Q_MOC_OUTPUT_REVISION)
#error "The header file 'Axes_range.h' doesn't include <QObject>."
#elif Q_MOC_OUTPUT_REVISION != 63
#error "This file was generated using the moc from 4.8.7. It"
#error "cannot be used with the include files from this version of Qt."
#error "(The moc has changed too much.)"
#endif

QT_BEGIN_MOC_NAMESPACE
static const uint qt_meta_data_Axes_range[] = {

 // content:
       6,       // revision
       0,       // classname
       0,    0, // classinfo
       6,   14, // methods
       0,    0, // properties
       0,    0, // enums/sets
       0,    0, // constructors
       0,       // flags
       4,       // signalCount

 // signals: signature, parameters, type, tag, flags
      16,   12,   11,   11, 0x05,
      44,   40,   11,   11, 0x05,
      78,   68,   11,   11, 0x05,
     111,  101,   11,   11, 0x05,

 // slots: signature, parameters, type, tag, flags
     141,   11,  137,   11, 0x08,
     153,   11,  137,   11, 0x08,

       0        // eod
};

static const char qt_meta_stringdata_Axes_range[] = {
    "Axes_range\0\0min\0minimum_changed(double)\0"
    "max\0maximum_changed(double)\0intervals\0"
    "intervals_changed(int)\0precision\0"
    "precision_changed(double)\0int\0read_data()\0"
    "close_dialog()\0"
};

void Axes_range::qt_static_metacall(QObject *_o, QMetaObject::Call _c, int _id, void **_a)
{
    if (_c == QMetaObject::InvokeMetaMethod) {
        Q_ASSERT(staticMetaObject.cast(_o));
        Axes_range *_t = static_cast<Axes_range *>(_o);
        switch (_id) {
        case 0: _t->minimum_changed((*reinterpret_cast< const double(*)>(_a[1]))); break;
        case 1: _t->maximum_changed((*reinterpret_cast< const double(*)>(_a[1]))); break;
        case 2: _t->intervals_changed((*reinterpret_cast< const int(*)>(_a[1]))); break;
        case 3: _t->precision_changed((*reinterpret_cast< const double(*)>(_a[1]))); break;
        case 4: { int _r = _t->read_data();
            if (_a[0]) *reinterpret_cast< int*>(_a[0]) = _r; }  break;
        case 5: { int _r = _t->close_dialog();
            if (_a[0]) *reinterpret_cast< int*>(_a[0]) = _r; }  break;
        default: ;
        }
    }
}

const QMetaObjectExtraData Axes_range::staticMetaObjectExtraData = {
    0,  qt_static_metacall 
};

const QMetaObject Axes_range::staticMetaObject = {
    { &QDialog::staticMetaObject, qt_meta_stringdata_Axes_range,
      qt_meta_data_Axes_range, &staticMetaObjectExtraData }
};

#ifdef Q_NO_DATA_RELOCATION
const QMetaObject &Axes_range::getStaticMetaObject() { return staticMetaObject; }
#endif //Q_NO_DATA_RELOCATION

const QMetaObject *Axes_range::metaObject() const
{
    return QObject::d_ptr->metaObject ? QObject::d_ptr->metaObject : &staticMetaObject;
}

void *Axes_range::qt_metacast(const char *_clname)
{
    if (!_clname) return 0;
    if (!strcmp(_clname, qt_meta_stringdata_Axes_range))
        return static_cast<void*>(const_cast< Axes_range*>(this));
    return QDialog::qt_metacast(_clname);
}

int Axes_range::qt_metacall(QMetaObject::Call _c, int _id, void **_a)
{
    _id = QDialog::qt_metacall(_c, _id, _a);
    if (_id < 0)
        return _id;
    if (_c == QMetaObject::InvokeMetaMethod) {
        if (_id < 6)
            qt_static_metacall(this, _c, _id, _a);
        _id -= 6;
    }
    return _id;
}

// SIGNAL 0
void Axes_range::minimum_changed(const double & _t1)
{
    void *_a[] = { 0, const_cast<void*>(reinterpret_cast<const void*>(&_t1)) };
    QMetaObject::activate(this, &staticMetaObject, 0, _a);
}

// SIGNAL 1
void Axes_range::maximum_changed(const double & _t1)
{
    void *_a[] = { 0, const_cast<void*>(reinterpret_cast<const void*>(&_t1)) };
    QMetaObject::activate(this, &staticMetaObject, 1, _a);
}

// SIGNAL 2
void Axes_range::intervals_changed(const int & _t1)
{
    void *_a[] = { 0, const_cast<void*>(reinterpret_cast<const void*>(&_t1)) };
    QMetaObject::activate(this, &staticMetaObject, 2, _a);
}

// SIGNAL 3
void Axes_range::precision_changed(const double & _t1)
{
    void *_a[] = { 0, const_cast<void*>(reinterpret_cast<const void*>(&_t1)) };
    QMetaObject::activate(this, &staticMetaObject, 3, _a);
}
QT_END_MOC_NAMESPACE
