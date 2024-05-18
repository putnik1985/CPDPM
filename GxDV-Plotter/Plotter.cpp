
#include "Plotter.h"

Plotter::Plotter(QWidget *parent, const int& w, const int& h):
QMainWindow(parent)
{

  project_already_exist = false;
  saved = false;

  setGeometry(WINDOW_X, WINDOW_Y, w, h);
  create_menu(); 
  setMenuBar(menu_bar);

  connect(
          create_project_action, SIGNAL( triggered() ),
          this,SLOT( create_project() ) 
         ); // connect create project with action

  connect(
          exit_project_action, SIGNAL( triggered() ),
          this,SLOT( close() ) 
         ); // connect create project with action

  connect(
          save_project_action, SIGNAL( triggered() ),
          this,SLOT( save_project() ) 
         ); // connect save project with action


  connect(
          open_project_action, SIGNAL( triggered() ),
          this,SLOT( open_project() ) 
         ); // connect save project with action


  connect(
          create_plot_from_file_action, SIGNAL( triggered() ),
          this,SLOT( create_line_from_file() ) 
         ); // connect create line with action

  connect(
          create_plot_from_table_action, SIGNAL( triggered() ),
          this,SLOT( read_line_from_table() ) 
         ); // connect create line with action


  connect(
          rename_plot_action, SIGNAL( triggered() ),
          this,SLOT( rename_plot() ) 
         ); // connect create line with action


  connect(
          define_x_title, SIGNAL( triggered() ),
          this,SLOT( create_x_title() ) 
         ); // connect create line with action
  connect(
          define_y_title, SIGNAL( triggered() ),
          this,SLOT( create_y_title() ) 
         ); // connect create line with action


  connect(
          define_x_range, SIGNAL( triggered() ),
          this,SLOT( create_x_range() ) 
         ); // connect create line with action
  connect(
          define_y_range, SIGNAL( triggered() ),
          this,SLOT( create_y_range() ) 
         ); // connect create line with action


  connect(
          probe_action, SIGNAL( triggered() ),
          this,SLOT( allow_cursor_grid() ) 
         ); // connect create probe mode with action


  connect(
          legend_move_action, SIGNAL( triggered() ),
          this,SLOT( allow_legend_action() ) 
         ); // connect create legend mode with action

 connect(
         truck_action, SIGNAL(triggered()),
         this,
         SLOT(run_truck_random_vibrations())
         );

connect(
         uniform_beam_action, SIGNAL(triggered()),
         this,
         SLOT(run_natural_modes_beam())
         );

connect(
         gears_action, SIGNAL(triggered()),
         this,
         SLOT(run_gears_fatigue_analysis())
         );

connect(
         shaft_action, SIGNAL(triggered()),
         this,
         SLOT(run_shaft_fatigue_analysis())
         );

connect(
         rainflow_action, SIGNAL(triggered()),
         this,
         SLOT(run_rainflow_algorithm())
         );

connect(
         damage_action, SIGNAL(triggered()),
         this,
         SLOT(run_damage_analysis())
         );

connect(
         effective_modules_action, SIGNAL(triggered()),
         this,
         SLOT(run_effective_analysis())
       );
}

//------------------------------------------------------------------------
int Plotter::create_menu(){ // think if there can be any exception throw

  menu_bar = new QMenuBar;  

  project_menu = new QMenu( tr("&Project")); 

  plots_menu = new QMenu( tr("P&lot"));
  create_plot_menu = new QMenu( tr("Create"));
  create_plot_menu->setEnabled(false);
  plots_menu->addMenu(create_plot_menu);


  axes_menu = new QMenu( tr("A&xes") );
  axes_x_menu = new QMenu( tr("X A&xis") );
  axes_y_menu = new QMenu( tr("Y A&xis") );
  axes_x_menu->setEnabled(false);
  axes_y_menu->setEnabled(false);

  axes_menu->addMenu(axes_x_menu);
  axes_menu->addMenu(axes_y_menu);

  mode_menu = new QMenu( tr("&Mode"));

  transformation_menu = new QMenu( tr("&Transformations"));
  random_vibrations_menu = new QMenu(tr("&Random Vibrations"));
  uniform_beam_menu = new QMenu(tr("&Beam Vibrations"));
  fatigue_menu = new QMenu(tr("&Fatigue"));
  composite_menu = new QMenu(tr("&Composites"));
   
  menu_bar->addMenu(project_menu);
  menu_bar->addMenu(plots_menu);
  menu_bar->addMenu(axes_menu);
  menu_bar->addMenu(mode_menu);
  menu_bar->addMenu(transformation_menu);
  menu_bar->addMenu(random_vibrations_menu);
  menu_bar->addMenu(uniform_beam_menu);
  menu_bar->addMenu(fatigue_menu);
  menu_bar->addMenu(composite_menu);
  
  create_actions(); // create actions

  project_menu->addAction(create_project_action);
  project_menu->addAction(open_project_action);
  project_menu->addAction(save_project_action); 
  project_menu->addAction(exit_project_action); 
  plots_menu->addAction(rename_plot_action);

  create_plot_menu->addAction(create_plot_from_file_action);
  create_plot_menu->addAction(create_plot_from_table_action);

  axes_x_menu->addAction(define_x_title);
  axes_x_menu->addAction(define_x_range);

  axes_y_menu->addAction(define_y_title);
  axes_y_menu->addAction(define_y_range);


  mode_menu->addAction(probe_action);
  mode_menu->addAction(legend_move_action);
  

  transformation_menu->addAction(furie_transform_action);
  transformation_menu->addAction(laplas_transform_action);  

  random_vibrations_menu->addAction(truck_action);
  uniform_beam_menu->addAction(uniform_beam_action);
  fatigue_menu->addAction(gears_action);
  fatigue_menu->addAction(shaft_action);
  fatigue_menu->addAction(rainflow_action);
  fatigue_menu->addAction(damage_action);

  composite_menu->addAction(effective_modules_action);
  
  return 0;
}

//------------------------------------------------------------------------

int Plotter::create_actions(){
  
   create_project_action = new QAction( tr("&Create Project"), this);
   open_project_action = new QAction( tr("&Open Project"), this);
   save_project_action = new QAction( tr("&Save Project"), this);
   exit_project_action = new QAction( tr("&Exit"), this);
 
   create_plot_from_file_action = new QAction( tr("From File"), this);;
   create_plot_from_table_action = new QAction( tr("From Table"), this);;   
   rename_plot_action = new QAction( tr("Rename plot"), this);;

   define_x_title = new QAction(tr("Create title"), this);
   define_x_range = new QAction(tr("Define range"), this);

   define_y_title = new QAction(tr("Create title"), this);
   define_y_range = new QAction(tr("Define range"), this);



   probe_action = new QAction( tr("Probe"), this);
   probe_action->setCheckable(true);

   legend_move_action = new QAction( tr("Legend position"), this);
   legend_move_action->setCheckable(true);


   furie_transform_action = new QAction(tr("Fourie"), this);
   laplas_transform_action = new QAction(tr("Laplas"), this);
   
   truck_action = new QAction( tr("&Truck Displacement"));
   uniform_beam_action = new QAction(tr("&Natural Modes"));
   gears_action = new QAction(tr("&Gears Fatigue Analysis"));
   shaft_action = new QAction(tr("&Aluminium Alloy Circular Shaft Fatigue Analysis"));
   rainflow_action = new QAction(tr("&Rainflow Algorithm"));
   damage_action = new QAction(tr("&Damage Analysis"));
   effective_modules_action = new QAction(tr("&Effective Parameters"));
   
   return 0;
}

//---------------------------------------------------------------------------
int Plotter::create_project(){
   if (!project_already_exist) {
                        /////std::cout << " create project:\n";
                        setCentralWidget(&current_chart);
                        project_already_exist = true;
                        create_plot_menu->setEnabled(true);  
                        axes_x_menu->setEnabled(true);
                        axes_y_menu->setEnabled(true);
   } // if project already exist     

return 0;
}

//-----------------------------------------------------------------------------

int Plotter::close_window(){

 if (!saved) std::cout << " do you want to save\n"; // here message box must invoke
 else close();

 return 0;
}

//------------------------------------------------------------------------------
int Plotter::create_line_from_file(){
//std::cout << " read file\n";
QString filename = 
              QFileDialog::getOpenFileName(
                                           this,
                                           "Open file of the line",
                                           ".",
                                           tr( "Data files (*.dat *.line *.txt)" ) 
                                           );
   if( !filename.isEmpty() ) {
                          //   std::cout << "file: " 
                          //             << filename.toStdString() 
                          //             << '\n';
   ifstream is(
               filename.toStdString(),
               ios_base::in
              );
   Curve curve;
   is >> curve;
   curve.name() = filename.toStdString();

   /////std::cout << curve << '\n';
   current_chart.add_plot(curve);
   is.close();
   }
return 0;
}

//-----------------------------------------------------------------------------
int Plotter::allow_legend_action(){

    current_chart.update_legend() = legend_move_action->isChecked(); 
    probe_action->setChecked(false);
    current_chart.display_cursor() = probe_action->isChecked();
    
    update(); 
    ////std::cout << " changed mode\n";
}

//-----------------------------------------------------------------------------
int Plotter::allow_cursor_grid(){

    current_chart.display_cursor() = probe_action->isChecked(); 
    legend_move_action->setChecked(false);
    current_chart.update_legend() = legend_move_action->isChecked();
    update(); 
    std::cout << " changed mode\n";
}

//------------------------------------------------------------------------------
int Plotter::create_x_title(){
Axes_editor *editor = new Axes_editor(QString("X axis"));

     connect(
             editor, SIGNAL( title_changed(const string&) ),
             &current_chart,SLOT( set_x_label(const string&) )
             );   

editor->exec();
return 0;
}

//------------------------------------------------------------------------------
int Plotter::create_y_title(){
Axes_editor *editor = new Axes_editor(QString("Y axis"));

     connect(
             editor, SIGNAL( title_changed(const string&) ),
             &current_chart,SLOT( set_y_label(const string&) )
             );   

editor->exec();

return 0;
}


//------------------------------------------------------------------------------
int Plotter::create_x_range(){
Axes_range *editor = new Axes_range(QString("X axis"));

     connect(
             editor, SIGNAL( minimum_changed(const double&) ),
             &current_chart,SLOT( set_x_min(const double&) )
             );   

     connect(
             editor, SIGNAL( maximum_changed(const double&) ),
             &current_chart,SLOT( set_x_max(const double&) )
             );   

     connect(
             editor, SIGNAL( intervals_changed(const int&) ),
             &current_chart,SLOT( set_x_intervals(const int&) )
             );   


     connect(
             editor, SIGNAL( precision_changed(const double&) ),
             &current_chart,SLOT( set_x_precision(const double&) )
             );   

editor->exec();

return 0;
}

//------------------------------------------------------------------------------
int Plotter::create_y_range(){
Axes_range *editor = new Axes_range(QString("Y axis"));

     connect(
             editor, SIGNAL( minimum_changed(const double&) ),
             &current_chart,SLOT( set_y_min(const double&) )
             );   

     connect(
             editor, SIGNAL( maximum_changed(const double&) ),
             &current_chart,SLOT( set_y_max(const double&) )
             );   

     connect(
             editor, SIGNAL( intervals_changed(const int&) ),
             &current_chart,SLOT( set_y_intervals(const int&) )
             );   


     connect(
             editor, SIGNAL( precision_changed(const double&) ),
             &current_chart,SLOT( set_y_precision(const double&) )
             );   

editor->exec();

return 0;
}
//------------------------------------------------------------------------------

int Plotter::read_line_from_table(){
XY_Table *table = new XY_Table;

     connect(
             table, SIGNAL( data_changed(const vector<double>&, const vector<double>&, const string&) ),
             &current_chart,SLOT( define_curve(const vector<double>&, const vector<double>&, const string&) )
             );  
 
table->exec();

return 0;
}

//----------------------------------------------------------------------------------
int Plotter::rename_plot(){

///std::cout << "rename plot\n";
QStringList curves = current_chart.curves_names();
Plot_name *rename_form = new Plot_name(curves);
     connect(
             rename_form,SIGNAL( curve_changed(int) ),
             &current_chart, SLOT ( set_highlight(int) )
            );
  
     current_chart.set_highlight(0); // highligh first curve

     if (rename_form->exec()){
     QString name = rename_form->new_name();
     current_chart.set_highlight_name(name);
     }

     //std::cout << name.toStdString() << '\n';
     current_chart.set_highlight(-1); // nothing to highligh 
      
     ////std::cout << rename_form->text().toStdString() << '\n';           
          
return 0;
}

//-------------------------------------------------------------------------------------

int Plotter::save_project(){
   QString filename = 
              QFileDialog::getSaveFileName(
                                           this,
                                           "Save file of the project",
                                           ".",
                                           tr( "Data files (*.dat *.line *.txt)" ) 
                                           );
   if (!filename.isEmpty()) {
   //std::cout << filename.toStdString() << '\n';
   write_file_thread *save_thread = new write_file_thread(current_chart.curves(), filename.toStdString());
   save_thread->start();
   }
   
return 0;
}

//-------------------------------------------------------------------------------------

int Plotter::open_project(){
   QString filename = 
              QFileDialog::getOpenFileName(
                                           this,
                                           "Open file of the project",
                                           ".",
                                           tr( "Data files (*.dat *.line *.txt)" ) 
                                           );
   if (!filename.isEmpty()) {
   ////std::cout << filename.toStdString() << '\n';
   read_file_thread *open_thread = new read_file_thread(filename.toStdString());
   
   qRegisterMetaType<Curves>("Curves");
   connect(
           open_thread, SIGNAL( data_read(const Curves&) ),
           &current_chart, SLOT( redefine_plots(const Curves&) )
           );  

   open_thread->start();
   //current_chart.curves() = open_thread->read_plots();
   //std::cout<< open_thread->isRunning() << '\n';
   }
   
return 0;
}

//-------------------------------------------------------------------------------------
int Plotter::run_truck_random_vibrations(){
      //std::cout << "Random truck displacement \n";
      system("python ./random-vibrations-truck/random-truck.py ./random-vibrations-truck/truck.dat > ./random-vibrations-truck/random-vibrations-truck-results.out"); 
      system("echo Random Vibration Analysis Completed"); 
      return 0;
}

//-------------------------------------------------------------------------------------
int Plotter::run_natural_modes_beam(){
      system("./beam/target/debug/beam  ./beam/beam_input.dat > ./beam/mode.out"); 
      system("echo Natural Mode Analysis Beam Completed"); 
      return 0;
}

//-------------------------------------------------------------------------------------
int Plotter::run_gears_fatigue_analysis(){
      system("./Fatigue/gears  ./Fatigue/input_gears.dat > ./Fatigue/gears_fatigue_analysis.out"); 
      system("echo Gears Fatigue Analysis Completed"); 
      return 0;
}

//-------------------------------------------------------------------------------------
int Plotter::run_shaft_fatigue_analysis(){
      system("./Fatigue/shaft  ./Fatigue/input_aluminium_shaft.dat > ./Fatigue/aluminium_alloy_circular_shaft_fatigue_analysis.out"); 
      system("echo Aluminium Alloy Circular Shaft Fatigue Analysis Completed"); 
      return 0;
}

//-------------------------------------------------------------------------------------
int Plotter::run_rainflow_algorithm(){
      system("./Fatigue/rainflow  ./Fatigue/input_sigma.dat > ./Fatigue/rainflow_algorithm.out"); 
      system("echo Rainflow Algorithm Analysis Completed"); 
      return 0;
}

//-------------------------------------------------------------------------------------
int Plotter::run_effective_analysis(){
      system("cd ./composites; echo layers_input.dat | ./effective  > ./effective_parameters.out"); 
      system("echo Effective Parameters Analysis Completed"); 
      return 0;
}
//-------------------------------------------------------------------------------------
int Plotter::run_damage_analysis(){
      system("perl ./Fatigue/extract_rainflow.pl ./Fatigue/rainflow_algorithm.out > ./Fatigue/rain.dat"); 
      system("./Fatigue/damage ./Fatigue/rain.dat ./Fatigue/input_damage.dat > ./Fatigue/damage_analysis.out"); 
      system("echo Damage Analysis Completed"); 
      return 0;
}
