
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <assert.h>

#include "Nastran.h"

int main(int argc, char *argv[]){


/*



                                  cout << "$\n";
                                  cout << "$ Rotor CMS\n";
                                  cout << "$    Tform Translat Punchfile\n";
                                  cout << setw(10) << "R" << " " << "/free-free_rotor.pch\n";
                                  cout << "$  Station      Grid         X         M        Ip        Id\n";
                                        for(int i=0;i<nodes.size();++i)
                                        cout << setw(10) << i + 1
                                             << setw(10) << nodes[i].station
                                             << setw(10) << setprecision(4) << fixed << nodes[i].x
                                             << setw(10) << setprecision(4) << fixed << nodes[i].Mass
                                             << setw(10) << setprecision(4) << fixed << nodes[i].Ip
                                             << setw(10) << setprecision(4) << fixed << nodes[i].Id
                                             << '\n';
                                  cout << "$\n";



*/

                     bool Translat = false;
                     int global_node = 1; // default node number
                     int global_element = 1; // default element number
                     int spc_number = 1; // default spc number
                     int property_number = 1; // default property

                     for(int i=0;i<argc;++i){
                       if ( strcmp("-Translat",argv[i]) == 0 ) Translat = true;
                       if ( strcmp("-Node",argv[i]) == 0 ) global_node = atoi(argv[i+1]);
                       if ( strcmp("-Element",argv[i]) == 0 ) global_element = atoi(argv[i+1]);
                       if ( strcmp("-Spc",argv[i]) == 0 ) spc_number = atoi(argv[i+1]);
                       if ( strcmp("-Property",argv[i]) == 0 ) property_number = atoi(argv[i+1]);

                     }



          vector<grid> grids;
          vector<lumped_mass> masses;
          vector<int> nodes;
          string line;
          string word;
          stringstream ss;
          while(cin >> word){ // create vector of the grids
          //cout << word << '\n';
                      if (word == "GRID") {
                                            //cout << line << '\n';
                                          grid gr;
                                          cin >> gr;
                                          //cout << gr <<'\n';
                                          grids.push_back(gr);
                      } // if GRID found
                      if (word == "CONM2") {
                                            //cout << line << '\n';
                                         lumped_mass lm;
                                         cin >> lm;
                                         //cout << lm <<'\n';
                                         masses.push_back(lm);
                      } // if CONM2 found
                      if (word == "$EIGENVALUE"
                                               && nodes.size() == 0
                          ) { // time to read nodes


                                   getline(cin,line); // read line of the EIGENVALUE keyword
                                   while( getline(cin,line) ){
                                   //cout << line << '\n';
                                   ss.str(line);
                                   ss >> word;
                                   if (word == "$TITLE") break;
                                      if( isdigit(word[0]) ){
                                           nodes.push_back(atoi(word.c_str()));
                                          //cout << word << '\n';
                                      }


                                   }


                      } // if $EIGENVALUE found

                    if (word=="_bc"){
                    double x;
                    string dofs;
                    cin >> x >> dofs;
                    write_grid(x, global_node);
                         for(int f=0;f<dofs.size();++f){
                           int dof = dofs[f] - '0';
                           write_spc(spc_number, global_node, dof);
                         }
                    ++global_node;
                    } // if _bc found


                    if (word=="_brg"){
                    double x;
                    string dofs;
                    double stiffness;
                    cin >> x >> dofs >> stiffness;
                    write_grid(x, global_node);
                    write_bush(
                               property_number, stiffness, dofs,
                               global_node, global_element
                               );
                    ++global_node;
                    ++global_element;
                    ++property_number;
                    } // if _brg found


                    if (word=="_mass"){
                    double x;
                    double mass;
                    double Jp;
                    double Jd;
                    cin >> x >> mass >> Jp >> Jd;
                    write_grid(x, global_node);
                    write_conm(mass, Jp, Jd, global_node, global_element);
                    ++global_node;
                    ++global_element;

                    } // if _brg found



         } // while processing the stream

                              //    for(int i=0;i<nodes.size();++i)
                              //    cout << nodes[i] << '\n';

                   if (Translat)
                   {
                                  cout << "$\n";
                                  cout << "$ Rotor CMS\n";
                                  cout << "$    Tform NASTRAN Punchfile\n";
                                  cout << setw(TRANSLAT_FORMAT) << "R" << " " << "/free-free-rotor.pch\n";
                                  cout << "$  Station      Grid         X         M        Ip        Id        PF"
                                       << "       1.0       0.0       0.0       0.0       0.0       0.0\n";
                                  //// cout << nodes.size() <<'\n';
                                  int k = 1; // current station to write
                                  for(int i=0;i<nodes.size();++i){
                                  //cout << nodes[i] << '\n';
                                  int node = nodes[i];

                                  vector<grid>::const_iterator p = find(grids.begin(), grids.end(), node);
                                  int station = 0;

                                        ( p == grids.end() ) ? station = -1 : station = p - grids.begin() ;


                                  vector<lumped_mass>::const_iterator pm = find(masses.begin(), masses.end(), node);
                                  int mass_station = 0;

                                        ( pm == masses.end() ) ? mass_station = -1 : mass_station = pm - masses.begin() ;


                                        if (station >= 0){
                                         string mass = "0.0", Jp="0.0", Jd="0.0";
                                         //cout << mass_station << '\n';
                                         if (mass_station >= 0 ) { mass = masses[mass_station].mass;
                                                                  Jp = masses[mass_station].Ip;
                                                                  Jd = masses[mass_station].Id;
                                                                 }

                                        cout << setw(TRANSLAT_FORMAT) << k
                                             << setw(TRANSLAT_FORMAT) << node
                                             << setw(TRANSLAT_FORMAT) << grids[station].x
                                             << setw(TRANSLAT_FORMAT) << mass
                                             << setw(TRANSLAT_FORMAT) << Jp
                                             << setw(TRANSLAT_FORMAT) << Jd
                                             << setw(TRANSLAT_FORMAT) << "1."
                                             << '\n';
                                         ++k;
                                         }

                                  }
                                  cout << "$\n";

                  } // if Translat output required

return 0;
}
