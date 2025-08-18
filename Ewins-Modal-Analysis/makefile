CLINK = g++
FLAGS = -std=c++14
LIB = *.cpp
SDOF = sdof
MDOF = mdof

MDOF: receptance.cpp
	$(CLINK) $(FLAGS) -o $(MDOF) main-mdof.cpp receptance.cpp 
SDOF: receptance.cpp
	$(CLINK) $(FLAGS) -o $(SDOF) main-sdof.cpp receptance.cpp 

clean:
	rm -f *.o $(TARGET)
