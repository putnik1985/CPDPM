CLINK = g++
FLAGS = -std=c++14
OBJECTS = main.o
LIB = main.cpp
TARGET = sdof

TARGET: $(LIB)
	$(CLINK) $(FLAGS) -o $(TARGET) $(LIB) 
clean:
	rm -f *.o $(TARGET)
