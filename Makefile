# NAME: Nandish Jha
# NSID: NAJ474
# Student Number: 11282001

HOSTNAME = $(shell hostname)

# COMPILER/FLAG Variables
CC = gcc
CFLAGS = -g -Wa,--noexecstack
CPPFLAGS = -g -std=gnu90 -Wall -pedantic

# Cross Compile Variables
CRSARM = arm-linux-gnueabihf-gcc
CRSPPC = powerpc-linux-gnu-gcc

# Other Variables
PTHREADS = /student/cmpt332/pthreads
PTHREADS_LIB = $(PTHREADS)/lib
OS = $(shell uname -s)
ARCH = $(shell uname -m)

PTHREADS_X86 = $(PTHREADS_LIB)/Linuxx86_64
PTHREADS_ARM = $(PTHREADS_LIB)/Linuxarmv7l
PTHREADS_PPC = $(PTHREADS_LIB)/Linuxppc

# Directories
OBJDIR = build/obj
LIBDIR = build/lib
BINDIR = build/bin

# Targets
X86EXE = $(BINDIR)/x86_64/sample-linux
ARMEXE = $(BINDIR)/arm/sample-linux-arm
PPCEXE = $(BINDIR)/ppc/sample-linux-ppc

# x86: $(X86EXE)
# arm: $(ARMEXE)
# ppc: $(PPCEXE)

.PHONY: all clean

ifeq ($(HOSTNAME),cmpt332-amd64)
all: $(X86EXE) $(ARMEXE) $(PPCEXE)
endif
ifeq ($(ARCH),x86_64)
all: $(X86EXE)
endif
ifeq ($(ARCH),armv7l)
all: $(ARMEXE)
endif
ifeq ($(ARCH),ppc)
all: $(PPCEXE)
endif


# x86 build ------------------- (1)

$(OBJDIR)/x86_64/sample-linux.o: sample-linux.c lab1.h
	mkdir -p $(dir $@)
	$(CC) $(CPPFLAGS) -I$(PTHREADS)/ -I. -c $< -o $@

$(OBJDIR)/x86_64/linux-lib.o: linux-lib.c lab1.h
	mkdir -p $(dir $@)
	$(CC) $(CPPFLAGS) -I$(PTHREADS)/ -I. -c $< -o $@

$(LIBDIR)/x86_64/liblinux-lib.a: $(OBJDIR)/x86_64/linux-lib.o
	mkdir -p $(dir $@)
	ar rcs $@ $<

$(X86EXE): $(OBJDIR)/x86_64/sample-linux.o $(LIBDIR)/x86_64/liblinux-lib.a
	mkdir -p $(dir $@)
	$(CC) $(CPPFLAGS) -L$(PTHREADS_X86) -o $@ $^ -lpthreads -lm



# arm build ------------------- (2)

$(OBJDIR)/arm/sample-linux.o: sample-linux.c lab1.h
	mkdir -p $(dir $@)
	$(CRSARM) $(CPPFLAGS) -I$(PTHREADS)/ -I. -c $< -o $@

$(OBJDIR)/arm/linux-lib.o: linux-lib.c lab1.h
	mkdir -p $(dir $@)
	$(CRSARM) $(CPPFLAGS) -I$(PTHREADS)/ -I. -c $< -o $@

$(LIBDIR)/arm/liblinux-lib.a: $(OBJDIR)/arm/linux-lib.o
	mkdir -p $(dir $@)
	ar rcs $@ $<

$(ARMEXE): $(OBJDIR)/arm/sample-linux.o $(LIBDIR)/arm/liblinux-lib.a
	mkdir -p $(dir $@)
	$(CRSARM) $(CPPFLAGS) -L$(PTHREADS_ARM) -o $@ $^ -lpthreads -lm



# ppc build ------------------- (3)

$(OBJDIR)/ppc/sample-linux.o: sample-linux.c lab1.h
	mkdir -p $(dir $@)
	$(CRSPPC) $(CPPFLAGS) -I$(PTHREADS) -I. -c $< -o $@

$(OBJDIR)/ppc/linux-lib.o: linux-lib.c lab1.h
	mkdir -p $(dir $@)
	$(CRSPPC) $(CPPFLAGS) -I$(PTHREADS) -I. -c $< -o $@

$(LIBDIR)/ppc/liblinux-lib.a: $(OBJDIR)/ppc/linux-lib.o
	mkdir -p $(dir $@)
	ar rcs $@ $<

$(PPCEXE): $(OBJDIR)/ppc/sample-linux.o $(LIBDIR)/ppc/liblinux-lib.a
	mkdir -p $(dir $@)
	$(CRSPPC) $(CPPFLAGS) -L$(PTHREADS_PPC) -o $@ $^ -lpthreads -lm



clean:
	clear
	rm -rf build
	# rm -r *.o
