link:= g++ 
flags:= -std=c++14
compile:= -c
libs:= main.cpp csv.cpp Matrix.cpp linear_bearing.cpp disk.cpp uniform_shaft.cpp rotor.cpp nvector.cpp analysis.cpp
headers:= csv.h Matrix.h linear_bearing.h disk.h uniform_shaft.h rotor.h structure.h gyro.h nvector.h analysis.h
objects:= main.o csv.o Matrix.o linear_bearing.o disk.o uniform_shaft.o rotor.o nvector.o analysis.o
cobjects:= ../Numerical_Library/gauss.o ../Numerical_Library/rotation.o ../Numerical_Library/complex_numbers.o ../Numerical_Library/jacobi.o
target:= rotor


$(target): $(objects) $(cobjects)
	$(link) $(flags) -o $(target) $(objects) $(cobjects)

$(objects): $(libs) $(headers)
	$(link) $(compile) $(flags) $(libs)

clean:
	rm -f *.o
