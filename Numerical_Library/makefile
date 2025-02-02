cxx = gcc
compile = -c
link = -o
headers = numeric_c.h 
objects = main.o gauss.o rotation.o hausholder.o square_root.o complex_numbers.o jacobi.o krylov.o laguer.o hess.o
libs = main.c gauss.c rotation.c hausholder.c square_root.c complex_numbers.c jacobi.c krylov.c laguer.c hess.c
target = algebra

$(target): $(objects) $(libs) 
	$(cxx) $(link) $(target) $(objects) -lm

$(objects): $(libs) $(headers)
	$(cxx) $(compile) $(libs)

clean:
	rm -f *.o
