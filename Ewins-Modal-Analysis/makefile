CLINK = g++
FLAGS = -std=c++14
OBJECTS = main.o
LIB = *.cpp
TARGET = sdof

TARGET: $(LIB)
	$(CLINK) $(FLAGS) -o $(TARGET) $(LIB) 
clean:
	rm -f *.o $(TARGET)
