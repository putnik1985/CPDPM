
#include "Note.h"

//-----------------------------------------------------
Note::Note(
           const QString& list
           ):
context {list},
context_lines {list.size()},
font_size {DEFAULT_SIZE},
fnt {font_weight::normal}
{
}


//-------------------------------------------------------------------------------

int Note::set_font(const font_weight& fw ){
fnt = fw;
return 0;
}

//--------------------------------------------------------------------------------
int Note::set_font_size(const double& sz){
font_size = sz;
return 0;
}

//--------------------------------------------------------------------------------
QFont Note::convert_to_qt_font(){

      switch(fnt){
      case font_weight::normal: 
                               return QFont(DEFAULT_STR_FAMILY, font_size, QFont::Normal);
      case font_weight::bold: 
                               return QFont(DEFAULT_STR_FAMILY, font_size,QFont::Bold);
      default:
              error(" no such font weight\n");
      }

}
