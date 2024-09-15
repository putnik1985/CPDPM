link:= g++ 
flags:= -std=c++14
compile:= -c
libs:= main.cpp csv.cpp functions.cpp Matrix.cpp linear_bearing.cpp disk.cpp 
target:= rotor
objects:= main.o csv.o functions.o Matrix.o linear_bearing.o disk.o 

target: $(objects)
	$(link) $(flags) -o $(target) $(objects)

objects: $(libs)
	$(link) $(compile) $(flags) $(libs)

clean:
	rm -f *.o
