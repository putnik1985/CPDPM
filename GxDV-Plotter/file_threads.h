
#ifndef FILE_THREADS_H
#define FILE_THREADS_H

#include "std_lib_facilities.h"
#include "Qt_lib.h"
#include "Curve.h"
#include "Chart.h"


class write_file_thread: public QThread {
Q_OBJECT
public:
  write_file_thread(
                    const std::vector<Curve>& v,
                    const string& name,
                    QObject *parent = 0
                   );

protected:
  void run();

private:
std::vector<Curve> plots;    
string filename;

};


class read_file_thread: public QThread {
Q_OBJECT
public:
  

  read_file_thread(
                    const string& name,
                    QObject *parent = 0
                   );

  std::vector<Curve> read_plots() const { return plots; }

signals:
void data_read(const Curves& plots);
  
protected:
  void run();

private:
std::vector<Curve> plots;    
string filename;

};


#endif
