

#ifndef NASTRAN_H
#define NASTRAN_H

#define FIELD_WIDTH 8
#define TRANSLAT_FORMAT 10
#define PRECISION 4

#include "stl.h"
#include "Transform.h"

struct lumped_mass{
int eid;
int node;
string mass;
string Ip;
string Id;
lumped_mass(){ eid = 0; node =0;}
};

//CONM2       7540     101       0 14.1760     0.0     0.0     0.0        + 
//+        135.227     0.0 69.1740     0.0     0.0 69.174

istream& operator>>(istream& is, lumped_mass& lm){
         // read first string of numbers

string line; 
           getline(is,line); // first line
           //cout << line << '\n';
StringList list(line);
            lm.node = atoi(list[1].c_str());
            lm.eid =  atoi(list[0].c_str());
            lm.mass = list[3];

            getline(is,line); // second line
            list.set_string(line);
            lm.Ip = list[1];
            lm.Id = list[3];          
return is;
}

ostream& operator<<(ostream& os, const lumped_mass& lm){
       os << setw(FIELD_WIDTH)
          << lm.node
          << setw(FIELD_WIDTH)
          << lm.mass
          << setw(FIELD_WIDTH)
          << lm.Ip
          << setw(FIELD_WIDTH)
          << lm.Id;
return os;
}


struct grid{ // responsible for the operation with grid information
int node;
string x; // read as string becasue Nastran writes numbr unusual way
int ref_cs;
int disp_cs;
string y;
string z;

grid(){ ref_cs = 0; disp_cs = 0; }
};


istream& operator>>(istream& is,grid& gr){
string word;
       is >> setw(FIELD_WIDTH)
          >> gr.node
          >> setw(FIELD_WIDTH)
          >> gr.ref_cs
          >> setw(FIELD_WIDTH)
          >> gr.x
          >> setw(FIELD_WIDTH)
          >> gr.y
          >> setw(FIELD_WIDTH)
          >> gr.z
          >> setw(FIELD_WIDTH)
          >> gr.disp_cs; 
 // GRID         201       0-16.0250 3.191-7     0.0      const lumped_mass& lm 0    
return is;
}

ostream& operator<<(ostream& os, const grid& gr){

       os << setw(FIELD_WIDTH)
          << gr.node
          << setw(FIELD_WIDTH)
          << gr.x
          << setw(FIELD_WIDTH)
          << gr.y
          << setw(FIELD_WIDTH)
          << gr.z;

return os;
}

bool operator==(const grid& gr1,const grid& gr2){
return gr1.node == gr2.node;
}

bool operator==(const grid& gr1,const int& node){
return gr1.node == node;
}

bool operator==(const lumped_mass& lm1,
                const lumped_mass& lm2
                ){
return lm1.node == lm2.node;
}

bool operator==(const lumped_mass& lm1,
                const int node
                ){
return lm1.node == node;
} 


void write_grid(const double& x, const int& node){
cout << setw(FIELD_WIDTH) << "GRID    "
     << setw(FIELD_WIDTH) << node
     << setw(FIELD_WIDTH) << "0"
     << setw(FIELD_WIDTH) << fixed << setprecision(PRECISION) << x
     << setw(FIELD_WIDTH) << "0.0"
     << setw(FIELD_WIDTH) << "0.0"
     << setw(FIELD_WIDTH) << "0"
     << '\n';        
}

void write_spc(const int& spc_number, const int& node, const int& dof){
cout << setw(FIELD_WIDTH) << "SPC     "
     << setw(FIELD_WIDTH) << spc_number
     << setw(FIELD_WIDTH) << node
     << setw(FIELD_WIDTH) << dof
     << '\n';        
}


void write_bush(const int& property, const double& stiffness, const string& dofs,
                const int& node, const int& element)
{
cout << setw(FIELD_WIDTH) << "PBUSH   "
     << setw(FIELD_WIDTH) << property
     << setw(FIELD_WIDTH) << "K       ";
vector<int> v(6);

        for(int i=0; i < dofs.size(); ++i){
          int dof = dofs[i] - '0';
          v[dof-1] = 1;
        }         

        for(int i=0;i<v.size();++i)
         (v[i] == 0 ) ?
                        cout << setw(FIELD_WIDTH) << "0.0"
                      :
                        cout << setw(FIELD_WIDTH) << fixed << setprecision(1) << stiffness;
         cout << '\n';
cout << setw(FIELD_WIDTH) << "CBUSH   "
     << setw(FIELD_WIDTH) << element
     << setw(FIELD_WIDTH) << property
     << setw(FIELD_WIDTH) << node
     << setw(5 * FIELD_WIDTH) << "0"
     << '\n';             
}


void write_conm(const double& mass, const double& Jp, const double& Jd,
                const int& node, const int& element)
{
cout << setw(FIELD_WIDTH) << "CONM2   "
     << setw(FIELD_WIDTH) << element
     << setw(FIELD_WIDTH) << node
     << setw(FIELD_WIDTH) << "0"
     << setw(FIELD_WIDTH) << fixed << setprecision(2) << mass
     << setw(FIELD_WIDTH) << "0.0"
     << setw(FIELD_WIDTH) << "0.0"
     << setw(FIELD_WIDTH) << "0.0"
     << setw(FIELD_WIDTH + 1) << "+"
     <<'\n'
     << setw(FIELD_WIDTH) << "+       "
     << setw(FIELD_WIDTH) << fixed << setprecision(2) << Jp
     << setw(FIELD_WIDTH) << fixed << "0.0"
     << setw(FIELD_WIDTH) << fixed << setprecision(2) << Jd
     << setw(FIELD_WIDTH) << fixed << "0.0"
     << setw(FIELD_WIDTH) << fixed << "0.0"
     << setw(FIELD_WIDTH) << fixed << setprecision(2) << Jd
     << '\n';
}

#endif
