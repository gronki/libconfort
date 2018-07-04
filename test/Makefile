#------------------------------------------------------------------------------#
#------------------- Builds and run tests for libconfort ----------------------#
#------------------------------------------------------------------------------#

FSOURCES 	 = $(wildcard test_*.F90)
CSOURCES 	 = $(wildcard test_*.c)
TESTS		 = $(FSOURCES:.F90=_f) $(CSOURCES:.c=_c)
PROGS 	  	 = $(addprefix bin/,$(TESTS))
CERTS 	  	 = $(addprefix out/,$(TESTS))

#------------------------------------------------------------------------------#

CC  	 	 := gcc
FC 		 	 := gfortran

CFLAGS 	 	 := -g -ggdb -Og -Wall
FFLAGS	 	 := $(CFLAGS) -fbackslash -fcheck=all -fbacktrace \
	-pedantic -fimplicit-none -ffree-line-length-none
CPPFLAGS	 := -D__CONFORT_DEBUG

INCLUDE	 	 := -I. -I../build -I../src

#------------------------------------------------------------------------------#

all: $(CERTS)

#------------------------------------------------------------------------------#

out/%: bin/%
	mkdir -p out
	bash runtest.sh $(subst out/,,$@)

bin/%_f: common.o %.F90 ../build/libconfort.a
	mkdir -p bin
	$(FC) $(INCLUDE) $(FFLAGS) $(LDFLAGS) -L.. $^ -o $@

bin/%_c: common_c.o %.c ../build/libconfort.a
	mkdir -p bin
	$(CC) $(INCLUDE) $(CPPFLAGS) $(CFLAGS) $(LDFLAGS) -L.. $^ -o $@

#------------------------------------------------------------------------------#

%.o: %.c
	$(CC)  $(INCLUDE) $(CPPFLAGS) $(CFLAGS) -c $< -o $@
%.o: %.F90
	$(FC)  $(INCLUDE) $(CPPFLAGS) $(FFLAGS) -c $< -o $@

#------------------------------------------------------------------------------#

../build/libconfort.a: $(wildcard ../src/*.F90) $(wildcard ../src/*.c) \
		$(wildcard ../src/*.h)
	$(MAKE) -C ../build CC="$(CC)" CFLAGS="$(CFLAGS)" \
		FC="$(FC)" FFLAGS="$(FFLAGS)" CPPFLAGS="$(CPPFLAGS)"

#------------------------------------------------------------------------------#

clean:
	$(RM) -rv *.o *.mod *.pass *.fail bin out

#------------------------------------------------------------------------------#

.PHONY: all clean

.SECONDARY: $(PROGS)

#------------------------------------------------------------------------------#
