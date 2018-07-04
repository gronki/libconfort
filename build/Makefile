#------------------------------------------------------------------------------#
#------------------------- Makefile for libconfort ----------------------------#
#------------------------------------------------------------------------------#

prefix = /usr/local
includedir = $(prefix)/include
libdir = $(prefix)/lib
fmoddir = $(libdir)/gfortran/modules

#------------------------------------------------------------------------------#

CC := gcc
FC := gfortran
CFLAGS := -g -O2 -Wall
FFLAGS := -g -O2 -Wall -pedantic -fimplicit-none -ffree-line-length-none

OBJECTS := c_routines.o f_routines.o core.o confort.o
VPATH := ../src
INCLUDE := -I. -I../src

#------------------------------------------------------------------------------#

all: libconfort.so libconfort.a

libconfort.so: $(OBJECTS)
	$(FC) $(LDFLAGS) -shared $^ $(LDLIBS) -o $@

libconfort.a: $(OBJECTS)
	$(AR) rcs $@ $^

%.o: %.c
	$(CC) -fPIC $(INCLUDE) $(CPPFLAGS) $(CFLAGS) -c $< -o $@
%.o: %.f90
	$(FC) -fPIC $(INCLUDE) $(FFLAGS) -c $< -o $@
%.o: %.F90
	$(FC) -fPIC $(INCLUDE) $(CPPFLAGS) $(FFLAGS) -c $< -o $@

#------------------------------------------------------------------------------#

install: all
	# headers
	install -d $(DESTDIR)$(includedir)
	install -m 644 ../src/confort.h $(DESTDIR)$(includedir)
	# modules
	install -d $(DESTDIR)$(fmoddir)
	install -m 644 confort.mod $(DESTDIR)$(fmoddir)
	# libraries
	install -d $(DESTDIR)$(libdir)
	install libconfort.so $(DESTDIR)$(libdir)
	install -m 644 libconfort.a $(DESTDIR)$(libdir)
	# pkg config
	install -d $(DESTDIR)$(libdir)/pkgconfig
	@echo "Name: confort" | tee $(DESTDIR)$(libdir)/pkgconfig/confort.pc
	@echo "Description: A minimalistic utility for reading configuration files. \
	Easy to use Fortran 2008 bindings are included. Compatible with GCC \
	and Intel compilers (this copy was built for $(CC) and $(FC))." \
		| tee -a $(DESTDIR)$(libdir)/pkgconfig/confort.pc
	@echo "Version: 180704" | tee -a $(DESTDIR)$(libdir)/pkgconfig/confort.pc
	@echo "Libs: -L$(libdir) -lconfort" | tee -a $(DESTDIR)$(libdir)/pkgconfig/confort.pc
	@echo "Cflags: -I$(includedir) -I$(fmoddir)" | tee -a $(DESTDIR)$(libdir)/pkgconfig/confort.pc

#------------------------------------------------------------------------------#

clean:
	$(RM) *.o *.mod *.smod *.so *.a
	$(MAKE) -C ../test clean

#------------------------------------------------------------------------------#

.PHONY: all install clean

#------------------------------------------------------------------------------#
