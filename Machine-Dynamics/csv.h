#ifndef CSV_H
#define CSV_H

#include "stl.h"

class Csv {

public:
 Csv(istream& fin = cin, string sep = ","):
  fin(fin), fieldsep(sep) {}

 int getline(string &);
 string getfield(int n);
 int getnfield() const {return nfield; }

private:
 istream& fin; // input file pointer
 string line; // input line
 vector<string> field; // field strings
 int nfield; // number of fields
 string fieldsep; // separator characters

 int split();
 int endofline(char);
 int advplain(const string& line, string& fld, int);
 int advquoted(const string& line, string& fld, int);
};

#endif
