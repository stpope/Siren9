/*
 * fftw_lite.h -- a minimal interface to the FFTW FFT library
 *
 * Made for use with Visualworks Smalltalk DLLCC
 * Stephen Pope -- stp@create.ucsb.edu -- 2003.07.17
 */

/******* Function Prototypes ********/

/* initialize FFTW data structures and plans */

int fftw_initialize(unsigned size, float * samples, float * spectrum);

/* perform forward/reverse FFT */

void fftw_forward_transform(void);
void fftw_reverse_transform(void);

/* int/float block copy to/from float sample buffer */

void fftw_short_to_float(short * data);
void fftw_float_to_short(short * data);

/* block copy of spectrum to magnitude buffer */

void fftw_mag_spectrum(float * data);
void fftw_phas_spectrum(float * data);
