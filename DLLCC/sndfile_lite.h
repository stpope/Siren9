/*
 * libsndfile_lite.h -- a minimal interface to Erik de Castro Lopo's libsndfile
 *
 * Made for use with Visualworks Smalltalk DLLCC
 * Stephen Pope -- stp@create.ucsb.edu -- 2003.07.16
 */

#define MAX_SND_FILES	64		// some reasonable value

/******* Function Prototypes ********/

/* open/close sound files */

int lsf_open(char * name, unsigned mode);
int lsf_create(char * name, unsigned mode, unsigned format, 
			unsigned rate, unsigned channels);
int lsf_close(unsigned which);

/* get sound file header data */

int lsf_get_format(unsigned which);
int lsf_get_rate(unsigned which);
int lsf_get_channels(unsigned which);
int lsf_get_frames(unsigned which);

/* seek within a sound file */

int lsf_seek(unsigned which, unsigned pos, unsigned key);

/* read/write float samples */

int lsf_read_Fsamples(unsigned which, float * where, unsigned count);
int lsf_write_Fsamples(unsigned which, float * where, unsigned count);

/* read/wrote short samples */

int lsf_read_Isamples(unsigned which, short * where, unsigned count);
int lsf_write_Isamples(unsigned which, unsigned short * where, unsigned count);
