/*
 * fftw_lite.c -- a minimal interface to the FFTW FFT library
 *
 * Made for use with Visualworks Smalltalk DLLCC
 * Stephen Pope -- stp@create.ucsb.edu -- 2003.07.17
 */

#include <fftw3.h>
#include <math.h>
#include "fftw_lite.h"

// Globals

static fftwf_plan f_plan, r_plan;		// Plans for IFFT
static fftwf_complex * Sspectrum;		// Buffer to store the spectrum
static float * Ssamples;				// Buffer to store samples
static unsigned fft_size;				// FFT length

/* initialize FFTW data structures and plans */

int fftw_initialize(unsigned size, float * samples, float * spectrum) {
	fft_size = size;
	Sspectrum = (fftwf_complex *) spectrum;
	Ssamples = samples;
	f_plan = fftwf_plan_dft_r2c_1d(fft_size, Ssamples, Sspectrum, FFTW_MEASURE);
	r_plan = fftwf_plan_dft_c2r_1d(fft_size, Sspectrum, Ssamples, FFTW_MEASURE);
	return 0;
}

/* perform forward/reverse FFT */

void fftw_forward_transform(void) {
	fftwf_execute(f_plan);	// FFT a window
}

void fftw_reverse_transform(void) {
	fftwf_execute(r_plan);	// IFFT a window
}

/* int/float block copy to/from float sample buffer */

void fftw_short_to_float(short * data) {
	unsigned i;
	short * in = data;
	float * out = Ssamples;
	for (i = 0; i < fft_size; i++)
		*out++ = (float) ((float) *in++) / 32768.0;
}

void fftw_float_to_short(short * data) {
	unsigned i;
	short * out = data;
	float * in = Ssamples;
	for (i = 0; i < fft_size; i++)
		*out++ = (short) (*in++ * 32768.0);
}

/* block copy of spectrum to real magnitude buffer */

void fftw_mag_spectrum(float * data) {
	unsigned i;
	float * out = data;
	float * in = (float *) Sspectrum;
	float re, im;
	for (i = 0; i < fft_size / 2; i++) {
		re = *in++;
		im = *in++;
		*out++ = sqrt((re * re) + (im * im));
	}
}
