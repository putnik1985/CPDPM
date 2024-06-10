
#ifndef PLOTTER_H
#define PLOTTER_H

#include "Qt_lib.h"
#include "Chart.h"
#include "Axes_editor.h"
#include "Axes_range.h"
#include "Table_Widget.h"
#include "Plot_name.h"
#include "file_threads.h"


#define WINDOW_X 200
#define WINDOW_Y 200


class Plotter: public QMainWindow{
Q_OBJECT

public:
Plotter(QWidget *parent = 0, const int& w = 1024, const int& h = 800);

private slots:
int create_project();
int close_window();
int save_project();
int open_project();

int create_line_from_file();
int allow_cursor_grid();
int create_x_title();
int create_y_title();

int create_x_range();
int create_y_range();

int allow_legend_action();
int read_line_from_table();
int rename_plot();

int run_fourier_analysis();

int run_truck_random_vibrations();
int run_natural_modes_beam();
int run_gears_fatigue_analysis();
int run_shaft_fatigue_analysis();
int run_rainflow_algorithm();
int run_damage_analysis();
int run_effective_analysis();
int run_shaft_lifecycle();


private:
bool project_already_exist;
bool saved;

QMenuBar *menu_bar;  
QMenu *project_menu; 
QMenu *plots_menu;
QMenu *create_plot_menu;

QMenu *axes_menu;
QMenu *axes_x_menu;
QMenu *axes_y_menu;

QMenu *mode_menu;
QMenu *transformation_menu;

QMenu *random_vibrations_menu;
QMenu *uniform_beam_menu;
QMenu *fatigue_menu;
QMenu *composite_menu;

QAction *create_project_action;
QAction *open_project_action;
QAction *save_project_action;
QAction *exit_project_action;

QAction *create_plot_from_file_action;
QAction *create_plot_from_table_action;
QAction *rename_plot_action;


QAction *define_x_title;
QAction *define_x_range;

QAction *define_y_title;
QAction *define_y_range;


QAction *probe_action;
QAction *legend_move_action;


QAction *furier_transform_action;
QAction *laplas_transform_action;
 
 QAction *truck_action;
 QAction *uniform_beam_action;
 QAction *gears_action;
 QAction *shaft_action;
 QAction *rainflow_action;
 QAction *damage_action;
 QAction *effective_modules_action;
 QAction *shaft_lifecycle_action;

int create_menu();
int create_actions();

Chart current_chart;

};

#endif
