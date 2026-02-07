link:= g++ 
flags:= -std=c++14
compile:= -c
libs:= main.cpp csv.cpp Matrix.cpp component.cpp lumped_mass.cpp machine.cpp nvector.cpp analysis.cpp
headers:= csv.h Matrix.h component.h lumped_mass.h machine.h structure.h nvector.h analysis.h
objects:= main.o csv.o Matrix.o component.o lumped_mass.o machine.o nvector.o analysis.o
cobjects:= ../Numerical_Library/gauss.o ../Numerical_Library/rotation.o ../Numerical_Library/complex_numbers.o ../Numerical_Library/jacobi.o
target:= machine


$(target): $(objects) $(cobjects)
	$(link) $(flags) -o $(target) $(objects) $(cobjects)

$(objects): $(libs) $(headers)
	$(link) $(compile) $(flags) $(libs)

clean:
	rm -f *.o
