CC := gcc
CFLAGS := -g
FC := f95
FFLAGS := -g -fcheck=all
INCLUDE := -I ../build -I ../src

all: test_c.txt test_f.txt

test_c.txt: test.c ../build/libconfort.a
	$(CC) $(INCLUDE) $(CFLAGS) $(LDFLAGS) $^ $(LDLIBS) -o $@
	./test_c &> test_c.txt

test_f.txt: test.F90 ../build/libconfort.a
	$(FC) $(INCLUDE) $(FFLAGS) $(LDFLAGS) $^ $(LDLIBS) -o $@
	./test_f &> test_f.txt

../build/libconfort.a:
	$(MAKE) -C ../build

clean:
	$(RM) test_c test_f