GCC=gfortran
LIBS=./*.f90 ../Numerical_Library/numerics.f90
TARGET=modal
TARGET: $(LIBS)
	$(GCC) -o $(TARGET) $(LIBS)

clean:
	rm -f *.o
