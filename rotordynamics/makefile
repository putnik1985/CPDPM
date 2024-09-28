link:= g++ 
flags:= -std=c++14
compile:= -c
libs:= main.cpp csv.cpp Matrix.cpp linear_bearing.cpp disk.cpp uniform_shaft.cpp rotor.cpp
headers:= csv.h Matrix.h linear_bearing.h disk.h uniform_shaft.h rotor.h structure.h gyro.h
objects:= main.o csv.o Matrix.o linear_bearing.o disk.o uniform_shaft.o rotor.o
target:= rotor


$(target): $(objects) 
	$(link) $(flags) -o $(target) $(objects) 

$(objects): $(libs) $(headers)
	$(link) $(compile) $(flags) $(libs)

clean:
	rm -f *.o
