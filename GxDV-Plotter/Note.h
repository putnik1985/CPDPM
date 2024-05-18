
#ifndef NOTE_H
#define NOTE_H

#include "std_lib_facilities.h"
#include "Qt_lib.h"
#define DEFAULT_SIZE 14
#define DEFAULT_STR_FAMILY "Arial"
class Note{

public:
enum font_weight { normal = 0, bold }; 
Note( 
     const QString& list
     );

int set_font(const font_weight& fw);
int set_font_size(const double& sz);
QFont convert_to_qt_font();
QString& text() { return context; }
const QString& text() const { return context; }
const int& lines() const { return context_lines; }
const int& get_font_size() const { return font_size;} 
const int& width() const { return line_width; }
QRect bound() const { return QRect(0,0,
                                   font_size * line_width,
                                   2 * font_size * context_lines
                                   );
                    }
private:
QString context;
int font_size;
font_weight fnt;
int context_lines;
int line_width {0};


}; // class Note

#endif
