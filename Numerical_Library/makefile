cxx = gcc
compile = -c
link = -o
objects = main.o gauss.o rotation.o 
libs = main.c gauss.c rotation.c 
target = algebra

$(target): $(objects) $(libs) 
	$(cxx) $(link) $(target) $(objects) -lm

$(objects): $(libs) 
	$(cxx) $(compile) $(libs)

clean:
	rm -f *.o
