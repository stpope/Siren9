#
# Makefile for Siren DLLCC plug-ins
#	Stephen Travis Pope -- stp@create.ucsb.edu -- 2001.07.16
#		LastEditDate: 2020.05.07
#
#	These commands are for Mac OSX, and should work unchanged on Linux;
#	for other platforms, please see the appropriate DLLCC documentation for 
#	compile/link instructions.
#

# Edit your own include paths in here

# Where are the DLLCC includes?

DLLCC_SRC = -I../../vw8.3pul/dllcc -I../../vw8.3pul/bin/macx/userprim
SIREN_INCL = SirenDLLCC.h

# Tune these flags to your compiler and verbosity level (-DDEBUG_SIREN = verbose)
# These are specific to Mac OS X
#  -arch i386 -arch x86_64

CFLAGS = -I/usr/local/include -O2 -g -fno-common -dynamic -DDEBUG_SIREN  -arch i386 $(DLLCC_SRC) -w

GCC = gcc

# LINKOPTS = -dynamic -bundle -undefined suppress -flat_namespace -L/usr/local/lib -lgcc  -arch i386
LINKOPTS = -dynamic -bundle -undefined suppress -flat_namespace -L/usr/local/lib -arch i386 # /usr/lib/bundle1.o

# Here are the make targets

# Build all by default

all:	file audio midi fftw

# libsndfile plug-in

file:	sndfile_lite.c $(SIREN_INCL)
	$(GCC) -c sndfile_lite.c $(CFLAGS)
	$(GCC) -o sndfile_lite.dylib sndfile_lite.o $(LINKOPTS) -lsndfile -L/usr/local/lib

# portaudio plug-in

audio:	portaudio_lite.c
	$(GCC) -c portaudio_lite.c $(CFLAGS)
	$(GCC) -v -o portaudio_lite.dylib portaudio_lite.o $(LINKOPTS) -lportaudio

# portmidi plug-in

midi:	portmidi_lite.c
	$(GCC) -c portmidi_lite.c $(CFLAGS)
	$(GCC) -o portmidi_lite.dylib portmidi_lite.o $(LINKOPTS) -lportmidi_s \
		/System/Library/Frameworks/CoreMIDI.framework/Versions/Current/CoreMIDI

# FFTW plug-in

fftw:	fftw_lite.c
	$(GCC) -c fftw_lite.c $(CFLAGS)
	$(GCC) -o fftw_lite.dylib fftw_lite.o $(LINKOPTS) -lfftw3f

# Cheap install target

install:
	cp sndfile_lite.dylib portmidi_lite.dylib portaudio_lite.dylib fftw_lite.dylib /usr/local/lib

# clean-up target

clean:
	rm -f *.o *.dylib
