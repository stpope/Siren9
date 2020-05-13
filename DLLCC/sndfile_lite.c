/*
 * libsndfile_lite.c -- a minimal interface to Erik de Castro Lopo's libsndfile
 *
 * Made for use with Visualworks Smalltalk DLLCC
 * Stephen Pope -- stp@create.ucsb.edu -- 2003.07.16
 */

#include "SirenDLLCC.h"		// Debug macros
#include "sndfile_lite.h"
#include <sndfile.h>

// Globals

				// the snd file structures and their info data
SNDFILE * _sfile[MAX_SND_FILES] = {0, 0, 0, 0, 0, 0, 0, 0 };
SF_INFO _sfinfo[MAX_SND_FILES];

// Find the first NULL pointer in the array of file info structures

int lsf_free_index() {
	int i;
	for (i = 0; i < MAX_SND_FILES; i++) {
		if (_sfile[i] == 0) {
			_sfile[i] = (SNDFILE *) 1;	// for thread-safety
			return i;
		}
	}
	return -1;		// too many open files
}

/* open/close sound files */

// open an existing file

int lsf_open(char * name, unsigned mode) {
//	DEBUG_P2("open sound file %s\n", name);
	int index = lsf_free_index();	// find the first free index
	if (index < 0) {				// no free files
		DEBUG_P2("Error: no free sound file indeces %s\n", name);
		return -1;
	}
	_sfile[index] = sf_open(name, mode, &_sfinfo[index]);
	if (_sfile[index] == NULL) {
		DEBUG_P2("Error: cannot open sound file %s\n", name);
		return -1;
	}
	return index;
}

// create a new file

int lsf_create(char * name, unsigned mode, unsigned format, 
			unsigned rate, unsigned channels) {
	int index = lsf_free_index();	// find the first free index
	if (index < 0) return -1;		// no free files
#ifdef DEBUG_SIREN
	printf("LSF: create sound file %s(%d): m (%x) f (%x) r (%d) c (%d)\n", 
			name, index, mode, format, rate, channels);
#endif
	_sfinfo[index].samplerate = rate;
	_sfinfo[index].channels = channels;
	_sfinfo[index].format = format;
	_sfile[index] = sf_open(name, mode, &_sfinfo[index]);
	if (_sfile[index] == NULL) return -1;
	return index;
}

// close the file and free up the file pointer

int lsf_close(unsigned which) {
	int val = (sf_close(_sfile[which]));
	_sfile[which] = 0;
	return val;
}

/* get sound file header data */

int lsf_get_format(unsigned which) {
	return (_sfinfo[which].format);
}

int lsf_get_rate(unsigned which) {
	return (_sfinfo[which].samplerate);
}

int lsf_get_channels(unsigned which) {
	return (_sfinfo[which].channels);
}

int lsf_get_frames(unsigned which) {
	return ((int)_sfinfo[which].frames);
}

/* seek within a sound file */

int lsf_seek(unsigned which, unsigned pos, unsigned whence) {
	return ((int) sf_seek(_sfile[which], (sf_count_t) pos, whence));
}

/* read/write float samples */

int lsf_read_Fsamples(unsigned which, float * where, unsigned count) {
	return ((int) sf_read_float(_sfile[which], where, (sf_count_t) count));
}

int lsf_write_Fsamples(unsigned which, float * where, unsigned count) {
	return ((int) sf_write_float(_sfile[which], where, (sf_count_t) count));
}

/* read/write short samples */

int lsf_read_Isamples(unsigned which, short * where, unsigned count) {
	return ((int) sf_read_short(_sfile[which], where, (sf_count_t) count));
}

#define SNDBUFSIZE 2048

static short sndFileBuf[SNDBUFSIZE];			// static copy buffer

int lsf_write_Isamples(unsigned which, unsigned short * where, unsigned count) {
	unsigned i, written, justdone, thisround;
	unsigned short * input = where;
	
	DEBUG_P3("LSF: writeISamps: %d/%d\n", which, count);
	written = 0;
	while (written < count) {
		thisround = count - written > SNDBUFSIZE ? SNDBUFSIZE : count - written;
		for (i = 0; i < thisround; i++) 	// copy data
			sndFileBuf[i] = (short) (*input++ - 32767);
		justdone = sf_write_short(_sfile[which], sndFileBuf, (sf_count_t) thisround);
		if (justdone <= 0) {
			printf("SndFile write error: %d\n", justdone);
			return written;
		}
		written += justdone;
	}
	return written;
}

