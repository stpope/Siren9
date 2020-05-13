/*
 * portaudio_lite.h -- minimal interface to the portaudio library
 *
 * Made for use with Visualworks Smalltalk DLLCC
 * Stephen Pope -- stp@create.ucsb.edu -- 2003.07.16
 *				updated to PortAudio V19 Feb 2007
 *
 */

// the ST callback block as a C function pointer typedef

typedef void (* CallbackFcn)(void);

/******* Function Prototypes ********/

/* Initialize/terminate portaudio */

int pa_initialize(void);
int pa_terminate(void);

/* Open the stream, passing in the stream options (channels, rate, sample format, etc.)
 * as well as the (Smalltalk-allocated) I/O buffer pointers and syncronization semaphores */

int pa_open_s(int device, unsigned in_ch, unsigned out_ch, 
		unsigned long format, unsigned rate, unsigned blockSize,
		CallbackFcn cbBlock, unsigned short * in_buffer, unsigned short * out_buffer);

/* Simpler version (does not use call-backs to Smalltalk, output only) */

int pa_open_p(int device, unsigned out_ch, unsigned long format, unsigned rate, unsigned blockSize);

/* Play a sound buffer (used with no-callback open fcn) */

int pa_play(unsigned short * out_buffer, unsigned numChannels, unsigned numFrames, unsigned swap);

/* Start/stop/close the default PA stream */

int pa_start(void);
int pa_stop(void);
int pa_close(void);

/* Accessor methods */

int pa_num_devices(void);

int pa_num_in(void);				// total # of I/O channels for all interfaces
int pa_num_out(void);

int pa_in_rate(void);				// default device rate
int pa_out_rate(void);

int pa_in_device(void);			// default device index
int pa_out_device(void);

/* Queries for a given device */

const char *  pa_get_name(unsigned which);

int pa_dev_in(unsigned which);
int pa_dev_out(unsigned which);

int pa_dev_rate(unsigned which);
