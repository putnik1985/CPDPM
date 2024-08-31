
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

connect(
        shaft_lifecycle_action, SIGNAL(triggered()),
        this,
        SLOT(run_shaft_lifecycle())
        );

connect(
        furier_transform_action, SIGNAL(triggered()),
        this,
        SLOT(run_fourier_analysis())
        );
connect(
        bolt_joint_action, SIGNAL(triggered()),
        this,
        SLOT(run_bolt_joint())
        );

connect(
        rectangular_beam_action, SIGNAL(triggered()),
        this,
        SLOT(run_rectangular_beam_analysis())
        );

connect(
        joint_analysis_action, SIGNAL(triggered()),
        this,
        SLOT(run_joint_analysis())
        );

connect(
        msc_nastran_sol101_action, SIGNAL(triggered()),
        this,
        SLOT(run_msc_nastran_sol101())
        );

connect(
       cylindrical_shell_action, SIGNAL(triggered()),
       this,
       SLOT(run_cylindrical_shell())
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

  transformation_menu = new QMenu( tr("&Experimental Frequency Analysis"));
  random_vibrations_menu = new QMenu(tr("&Random Vibrations"));
  uniform_beam_menu = new QMenu(tr("&Beam Vibrations"));
  fatigue_menu = new QMenu(tr("&Fatigue"));
  composite_menu = new QMenu(tr("&Composites"));
  bolt_menu = new QMenu(tr("&Bolts"));

  joint_analysis_menu = new QMenu(tr("&Joint Analysis"));

  msc_nastran_menu = new QMenu(tr("&MSC Nastran"));
  plate_shell_menu = new QMenu(tr("Plates and Shells"));
   
  menu_bar->addMenu(project_menu);
  menu_bar->addMenu(plots_menu);
  menu_bar->addMenu(axes_menu);
  menu_bar->addMenu(mode_menu);
  menu_bar->addMenu(transformation_menu);
  menu_bar->addMenu(random_vibrations_menu);
  menu_bar->addMenu(uniform_beam_menu);
  menu_bar->addMenu(fatigue_menu);
  menu_bar->addMenu(composite_menu);
  menu_bar->addMenu(bolt_menu);
  menu_bar->addMenu(joint_analysis_menu);
  menu_bar->addMenu(msc_nastran_menu);
  menu_bar->addMenu(plate_shell_menu);
  
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
  

  transformation_menu->addAction(furier_transform_action);
  transformation_menu->addAction(laplas_transform_action);  

  random_vibrations_menu->addAction(truck_action);
  uniform_beam_menu->addAction(uniform_beam_action);
  fatigue_menu->addAction(gears_action);
  fatigue_menu->addAction(shaft_action);
  fatigue_menu->addAction(rainflow_action);
  fatigue_menu->addAction(damage_action);
  fatigue_menu->addAction(shaft_lifecycle_action);

  composite_menu->addAction(effective_modules_action);
  composite_menu->addAction(rectangular_beam_action);
  
  bolt_menu->addAction(bolt_joint_action);

  joint_analysis_menu->addAction(joint_analysis_action);
  
  msc_nastran_menu->addAction(msc_nastran_sol101_action);

  plate_shell_menu->addAction(cylindrical_shell_action); 
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


   furier_transform_action = new QAction(tr("Furie Analysis"), this);
   laplas_transform_action = new QAction(tr("Laplas"), this);
   
   truck_action = new QAction( tr("&Truck Displacement"),this);
   uniform_beam_action = new QAction(tr("&Natural Modes"),this);
   gears_action = new QAction(tr("&Gears Fatigue Analysis"),this);
   shaft_action = new QAction(tr("&Aluminium Alloy Circular Shaft Fatigue Analysis"),this);
   rainflow_action = new QAction(tr("&Rainflow Algorithm"),this);
   damage_action = new QAction(tr("&Damage Analysis"),this);
   shaft_lifecycle_action = new QAction(tr("&Shaft Life Cycle Analysis"), this);
   effective_modules_action = new QAction(tr("&Effective Parameters"),this);
   rectangular_beam_action = new QAction(tr("&Rectangular Beam"), this);

   bolt_joint_action = new QAction(tr("&Bolt Joint Stiffness"), this);

   joint_analysis_action = new QAction(tr("&Bolts Joint Analysis"), this);
   
   msc_nastran_sol101_action = new QAction(tr("&SOL101 Nastran File"), this);

   cylindrical_shell_action = new QAction(tr("&Cylindrical Shell(Axisymmetric Static Linear Analysis)"), this);
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

//-------------------------------------------------------------------------------------
int Plotter::run_shaft_lifecycle(){
      system("awk -f ../Fatigue/Shaft_Life/mesh_generator.awk  shaft_commands.dat"); 
      system("../Fatigue/Shaft_Life/shaft"); 
      system("echo Shaft Lifecycle Analysis Completed"); 
      return 0;
}

//-------------------------------------------------------------------------------------
int Plotter::run_fourier_analysis(){
    system("../Frequency-Analysis/signal ../Frequency-Analysis/input.dat > ../Frequency-Analysis/spectrum.out");
    system("echo Fourier Analysis Completed"); 
    return 0;
}

//-------------------------------------------------------------------------------------
int Plotter::run_bolt_joint(){
    system("../bolts/bolt_joint/target/debug/bolt_joint ../bolts/bolt_joint/bolt_joint_input.txt > ../bolts/bolt_joint/bolt_joint.out");
    system("echo Bolt Joint Analysis completed");
    return 0;
}
//-------------------------------------------------------------------------------------
int Plotter::run_rectangular_beam_analysis(){
      system("cd ../composites; echo beam_input.dat | ./beam"); 
      system("echo Rectangular Composite Beam Analysis Completed"); 
      return 0;
}

//-------------------------------------------------------------------------------------
int Plotter::run_joint_analysis(){
      system("awk -f ../joint-analysis/joint_analysis.awk  ../joint-analysis/joint#1.dat > ../joint-analysis/joint#1.out"); 
      system("echo Joint Analysis Completed"); 
      return 0;
}

//-------------------------------------------------------------------------------------
int Plotter::run_msc_nastran_sol101(){
      system("perl ../mscnastran/msc-nastran-beam-linear-static-model-generator.pl  ../mscnastran/utsr-ball-joint.txt > ../mscnastran/utsr-sol101-ball.nas"); 
      system("echo MSC Nastran SOL101 Input File Written"); 
      return 0;
}

//-------------------------------------------------------------------------------------
int Plotter::run_cylindrical_shell(){
////      system("perl ../mscnastran/msc-nastran-beam-linear-static-model-generator.pl  ../mscnastran/utsr-ball-joint.txt > ../mscnastran/utsr-sol101-ball.nas"); 
      system("echo Cylinrical Shell Analysis Completed"); 
      return 0;
}

