/****************************************************************************
** Meta object code from reading C++ file 'Axes_range.h'
**
** Created by: The Qt Meta Object Compiler version 67 (Qt 5.15.12)
**
** WARNING! All changes made in this file will be lost!
*****************************************************************************/

#include <memory>
#include "Axes_range.h"
#include <QtCore/qbytearray.h>
#include <QtCore/qmetatype.h>
#if !defined(Q_MOC_OUTPUT_REVISION)
#error "The header file 'Axes_range.h' doesn't include <QObject>."
#elif Q_MOC_OUTPUT_REVISION != 67
#error "This file was generated using the moc from 5.15.12. It"
#error "cannot be used with the include files from this version of Qt."
#error "(The moc has changed too much.)"
#endif

QT_BEGIN_MOC_NAMESPACE
QT_WARNING_PUSH
QT_WARNING_DISABLE_DEPRECATED
struct qt_meta_stringdata_Axes_range_t {
    QByteArrayData data[12];
    char stringdata0[131];
};
#define QT_MOC_LITERAL(idx, ofs, len) \
    Q_STATIC_BYTE_ARRAY_DATA_HEADER_INITIALIZER_WITH_OFFSET(len, \
    qptrdiff(offsetof(qt_meta_stringdata_Axes_range_t, stringdata0) + ofs \
        - idx * sizeof(QByteArrayData)) \
    )
static const qt_meta_stringdata_Axes_range_t qt_meta_stringdata_Axes_range = {
    {
QT_MOC_LITERAL(0, 0, 10), // "Axes_range"
QT_MOC_LITERAL(1, 11, 15), // "minimum_changed"
QT_MOC_LITERAL(2, 27, 0), // ""
QT_MOC_LITERAL(3, 28, 3), // "min"
QT_MOC_LITERAL(4, 32, 15), // "maximum_changed"
QT_MOC_LITERAL(5, 48, 3), // "max"
QT_MOC_LITERAL(6, 52, 17), // "intervals_changed"
QT_MOC_LITERAL(7, 70, 9), // "intervals"
QT_MOC_LITERAL(8, 80, 17), // "precision_changed"
QT_MOC_LITERAL(9, 98, 9), // "precision"
QT_MOC_LITERAL(10, 108, 9), // "read_data"
QT_MOC_LITERAL(11, 118, 12) // "close_dialog"

    },
    "Axes_range\0minimum_changed\0\0min\0"
    "maximum_changed\0max\0intervals_changed\0"
    "intervals\0precision_changed\0precision\0"
    "read_data\0close_dialog"
};
#undef QT_MOC_LITERAL

static const uint qt_meta_data_Axes_range[] = {

 // content:
       8,       // revision
       0,       // classname
       0,    0, // classinfo
       6,   14, // methods
       0,    0, // properties
       0,    0, // enums/sets
       0,    0, // constructors
       0,       // flags
       4,       // signalCount

 // signals: name, argc, parameters, tag, flags
       1,    1,   44,    2, 0x06 /* Public */,
       4,    1,   47,    2, 0x06 /* Public */,
       6,    1,   50,    2, 0x06 /* Public */,
       8,    1,   53,    2, 0x06 /* Public */,

 // slots: name, argc, parameters, tag, flags
      10,    0,   56,    2, 0x08 /* Private */,
      11,    0,   57,    2, 0x08 /* Private */,

 // signals: parameters
    QMetaType::Void, QMetaType::Double,    3,
    QMetaType::Void, QMetaType::Double,    5,
    QMetaType::Void, QMetaType::Int,    7,
    QMetaType::Void, QMetaType::Double,    9,

 // slots: parameters
    QMetaType::Int,
    QMetaType::Int,

       0        // eod
};

void Axes_range::qt_static_metacall(QObject *_o, QMetaObject::Call _c, int _id, void **_a)
{
    if (_c == QMetaObject::InvokeMetaMethod) {
        auto *_t = static_cast<Axes_range *>(_o);
        (void)_t;
        switch (_id) {
        case 0: _t->minimum_changed((*reinterpret_cast< const double(*)>(_a[1]))); break;
        case 1: _t->maximum_changed((*reinterpret_cast< const double(*)>(_a[1]))); break;
        case 2: _t->intervals_changed((*reinterpret_cast< const int(*)>(_a[1]))); break;
        case 3: _t->precision_changed((*reinterpret_cast< const double(*)>(_a[1]))); break;
        case 4: { int _r = _t->read_data();
            if (_a[0]) *reinterpret_cast< int*>(_a[0]) = std::move(_r); }  break;
        case 5: { int _r = _t->close_dialog();
            if (_a[0]) *reinterpret_cast< int*>(_a[0]) = std::move(_r); }  break;
        default: ;
        }
    } else if (_c == QMetaObject::IndexOfMethod) {
        int *result = reinterpret_cast<int *>(_a[0]);
        {
            using _t = void (Axes_range::*)(const double & );
            if (*reinterpret_cast<_t *>(_a[1]) == static_cast<_t>(&Axes_range::minimum_changed)) {
                *result = 0;
                return;
            }
        }
        {
            using _t = void (Axes_range::*)(const double & );
            if (*reinterpret_cast<_t *>(_a[1]) == static_cast<_t>(&Axes_range::maximum_changed)) {
                *result = 1;
                return;
            }
        }
        {
            using _t = void (Axes_range::*)(const int & );
            if (*reinterpret_cast<_t *>(_a[1]) == static_cast<_t>(&Axes_range::intervals_changed)) {
                *result = 2;
                return;
            }
        }
        {
            using _t = void (Axes_range::*)(const double & );
            if (*reinterpret_cast<_t *>(_a[1]) == static_cast<_t>(&Axes_range::precision_changed)) {
                *result = 3;
                return;
            }
        }
    }
}

QT_INIT_METAOBJECT const QMetaObject Axes_range::staticMetaObject = { {
    QMetaObject::SuperData::link<QDialog::staticMetaObject>(),
    qt_meta_stringdata_Axes_range.data,
    qt_meta_data_Axes_range,
    qt_static_metacall,
    nullptr,
    nullptr
} };


const QMetaObject *Axes_range::metaObject() const
{
    return QObject::d_ptr->metaObject ? QObject::d_ptr->dynamicMetaObject() : &staticMetaObject;
}

void *Axes_range::qt_metacast(const char *_clname)
{
    if (!_clname) return nullptr;
    if (!strcmp(_clname, qt_meta_stringdata_Axes_range.stringdata0))
        return static_cast<void*>(this);
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
    } else if (_c == QMetaObject::RegisterMethodArgumentMetaType) {
        if (_id < 6)
            *reinterpret_cast<int*>(_a[0]) = -1;
        _id -= 6;
    }
    return _id;
}

// SIGNAL 0
void Axes_range::minimum_changed(const double & _t1)
{
    void *_a[] = { nullptr, const_cast<void*>(reinterpret_cast<const void*>(std::addressof(_t1))) };
    QMetaObject::activate(this, &staticMetaObject, 0, _a);
}

// SIGNAL 1
void Axes_range::maximum_changed(const double & _t1)
{
    void *_a[] = { nullptr, const_cast<void*>(reinterpret_cast<const void*>(std::addressof(_t1))) };
    QMetaObject::activate(this, &staticMetaObject, 1, _a);
}

// SIGNAL 2
void Axes_range::intervals_changed(const int & _t1)
{
    void *_a[] = { nullptr, const_cast<void*>(reinterpret_cast<const void*>(std::addressof(_t1))) };
    QMetaObject::activate(this, &staticMetaObject, 2, _a);
}

// SIGNAL 3
void Axes_range::precision_changed(const double & _t1)
{
    void *_a[] = { nullptr, const_cast<void*>(reinterpret_cast<const void*>(std::addressof(_t1))) };
    QMetaObject::activate(this, &staticMetaObject, 3, _a);
}
QT_WARNING_POP
QT_END_MOC_NAMESPACE
