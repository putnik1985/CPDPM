
#include "file_threads.h"

write_file_thread::write_file_thread(
                                    const std::vector<Curve>& v,
                                    const string& name,
                                    QObject *parent
                                    ):
plots {v},
filename {name},
QThread(parent)
{}

//---------------------------------------------------------
void write_file_thread::run(){

  ofstream ofs(filename,ios_base::out);
  if (ofs){
     //ofs << " write file thread:\n";
     for(int i=0;i<plots.size();++i)
     ofs << plots[i] << "$\n";

     ofs.close();  
  }
  else
      std::cout << "can not open file\n";
}

//---------------------------------------------------------
void read_file_thread::run(){

  ifstream ifs(filename,ios_base::in);
  if (ifs){
      string name, curve_name;
      
      while( ifs >> name >> curve_name  ) {
      //std::cout << name << " " << curve_name << '\n';
      Curve v;
      ifs >> v;
      v.name() = curve_name;
      plots.push_back(v); 
      }
      ifs.close();

         //  for(int i=0; i<plots.size();++i)
         //  std::cout << plots[i] << '\n';

      emit data_read(plots);
      ///std::cout << " read done:\n";
  }
  else
      std::cout << "can not open file\n";
}

//---------------------------------------------------------
read_file_thread::read_file_thread(
                                    const string& name,
                                    QObject *parent
                                    ):
filename {name},
QThread(parent)
{}
