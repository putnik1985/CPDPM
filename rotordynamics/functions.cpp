#include "functions.h"

double stod(const string& str)
{
  double a;
  stringstream ss(str);
  ss >> a;
  return a;
}
