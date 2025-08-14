
#ifndef RECEPTANCE_H
#define RECEPTANCE_H
#include "std-lib.h"

const double M_PI = 3.14159;
class receptance {
  public:
  virtual complex<double> operator()(double w) = 0;
  receptance(double m1, double k1);

  protected:
  double m;
  double k;
  double w0;
};

class viscous_damping: public receptance {
  public:
  complex<double> operator()(double w);
  viscous_damping(double m1, double k1, double c1);
  using receptance::receptance;

  private:
  double c;
};

class structural_damping: public receptance {
  public:
  complex<double> operator()(double w);
  structural_damping(double m1, double k1, double h1);
  using receptance::receptance;

  private:
  double h;
};

struct mobility_plot {
 mobility_plot(receptance&, double, int);
 double fmax;
 int N;
 vector< complex<double> > data;
};

ostream& operator<<(ostream& os, const mobility_plot& mb);
#endif
