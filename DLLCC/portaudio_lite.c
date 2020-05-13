/*
 * portaudio_lite.c -- minimal interface to the portaudio library
 *
 * Made for use with Visualworks Smalltalk DLLCC
 *	This library interfaces to PortAudio and supports several player clients 
 *	with or without Smalltalk semaphore callbacks.
 *
 * Stephen Pope -- stp@create.ucsb.edu -- 2003.07.16
 *		updated to PortAudio V19 Feb 2007
 */

#include "SirenDLLCC.h"		// Debug macros
#include "portaudio_lite.h"	// my API include (in this folder)
#include "portaudio.h"		// main PortAudio include

/* structure to represent a playing sound (low-level version) */

typedef struct {			
	unsigned short * data;
	unsigned numChannels;
	unsigned totalFrames;
	unsigned currentFrame;
	int doSwap;
} PA_CLIENT;

#define NUM_CLIENTS 8			// Max concurrent ST player clients

#define SD_NAMELEN 32

/* structure for PA devices */

typedef struct {			
	unsigned index;
	float frameRate;
	unsigned maxIn; 
	unsigned maxOut;
	int isIn;
	int isOut;
	char name[SD_NAMELEN]; 
} PADevice;

#define NUM_Devices 8			// Max PA devices

// the array of active clients (playing sounds)

static PA_CLIENT clients[NUM_CLIENTS];		

// the array of active devices

static PADevice devices[NUM_Devices];	

// These are all global; perhaps they should be put in the PortAudio 
// callback data structure, but why bother?

static PaStream * s_pa_stream;			// the PortAudio stream we play out/get data from
										// NB: only one at a time supported in this version!
static short * in_buf = 0, * out_buf = 0;	// I/O buffer pointers given to us by the Smalltalk VM
static int pa_is_inited = 0,				// driver status flags
	pa_is_open = 0, 
	pa_is_running = 0;

static unsigned numDevices = 0;
static unsigned in_ch = 0;					// the # of I/O channels
static unsigned out_ch = 0;
static unsigned numRealInChannels = 0;	    // totals for all interfaces
static unsigned numRealOutChannels = 0;
static unsigned realInRate = 0;
static unsigned realOutRate = 0;
static unsigned defaultIn = 0;				// which interface is the default
static unsigned defaultOut = 0;

static CallbackFcn STupdate;				// the Smalltalk callback block

// the PA callback function for use with the semaphore to Smalltalk

static int pa_callback_to_ST (const void * inputBuffer, void * outputBuffer, unsigned long frames, 
				const PaStreamCallbackTimeInfo * outTime, PaStreamCallbackFlags flags, void * userData) {
//	DEBUG_P("PA callback (s)\n");
	if (out_ch > 0) {						// copy output buffers
		size_t osize = frames * out_ch * sizeof(short);
//		DEBUG_P2("PA callback %d\n", osize);
		memcpy(outputBuffer, out_buf, osize);
		bzero(out_buf, osize);
	}
	if (in_ch > 0) {						// and/or copy input buffers
		memcpy(in_buf, inputBuffer, frames * in_ch * sizeof(short));
	}
	STupdate();							// call ST callback (in this thread)
	return 0;
}

// The callback for use with client playing (no callback to Smalltalk)

static int pa_callback_no_ST (const void * inputBuffer, void * outputBuffer, unsigned long frames, 
				const PaStreamCallbackTimeInfo * outTime, PaStreamCallbackFlags flags, 
				void * userData) {
	short * samples;									// I always use 16-bit shorts in this version
	unsigned i, j, k;
//	DEBUG_P("PA callback\n");
	bzero(outputBuffer, (frames * out_ch * sizeof(short)));	// empty buffer
	for (i = 0; i < NUM_CLIENTS; i++) {
		if (clients[i].totalFrames) {					// if this client is playing
			PA_CLIENT * cli = & clients[i];
			samples = (short *) outputBuffer;
			unsigned cFrame = cli->currentFrame;
			unsigned tFrame = cli->totalFrames;
			unsigned rFrame = tFrame - cFrame;		// remaining frames
			unsigned sChans = cli->numChannels;
			unsigned short * cData = cli->data + (cFrame * sChans);
			unsigned toCopy = frames < rFrame ? frames : rFrame;
			unsigned offset = cli->doSwap ? 32767 : 0;
//			printf("\tfound client %d with %d samples [%d] %d - %d\n", i,  rFrame, toCopy, out_ch, sChans);
			if (sChans == out_ch) {
				for (j = 0; j < (toCopy * sChans); j++) 	// copy data
					*samples++ += (short) (*cData++ - offset);
			} else if (sChans == 1) {
				if (out_ch == 2) {
					short theSamp;
					for (j = 0; j < toCopy; j++) {			// copy frames
						theSamp = (short) (*cData++ - offset);
						*samples++ += theSamp;			// copy samples
						*samples++ += theSamp;
				} } else {
					short theSamp;
					for (j = 0; j < toCopy; j++) {			// copy frames
						theSamp = (short) (*cData++ - offset);
						for (k = 0; k < out_ch; k++)			// copy samples
							*samples++ += theSamp;				
			} } } else {
				printf("\n\tPortAudio error unsupported i/o channel combination\n");			
				return 0;
			}
			cli->currentFrame += toCopy;
			if (cli->currentFrame >= cli->totalFrames) {
//				DEBUG_P3("PA callback: client %d finished %d frames\n", i, cli->totalFrames);
				cli->totalFrames = 0;
	} } }
	return 0;
}

// PA error handler -- print to stdout

void pa_handle_error(PaError err) {
	pa_is_open = 0;
	pa_is_running = 0;
	printf("\n\tPortAudio error: %d\n", err);
	printf("\t\tMessage: %s\n", Pa_GetErrorText(err));	
	if (pa_is_inited)
		Pa_Terminate();
}

// initialize PA and load the device table

int pa_initialize(void) {
	PaError err;
	PaDeviceInfo * pdi;
	PADevice * devPtr;
	unsigned i;
	
	if (pa_is_inited)			// return if already initialized
		return 0;
	DEBUG_P("PA_init\n");
	err = Pa_Initialize();
	if (err != paNoError) {
		pa_handle_error(err);
		oeFail(err);
	}
	pa_is_inited = 1;
	pa_is_open = 0;
	pa_is_running = 0;
	numRealInChannels = 0;
	numRealOutChannels = 0;

	numDevices = (unsigned) Pa_GetDeviceCount();			// count the PA devices
	defaultIn = (unsigned) Pa_GetDefaultInputDevice();
	defaultOut = (unsigned) Pa_GetDefaultOutputDevice();
	for (i = 0; i < numDevices; i++) {
		pdi = Pa_GetDeviceInfo(i);
		devPtr =  & devices[i];
		strncpy(devPtr->name, pdi->name, SD_NAMELEN);
		devPtr->index = i, 
		devPtr->maxIn = pdi->maxInputChannels;
		devPtr->maxOut = pdi->maxOutputChannels;
		devPtr->isIn = (i == (int)Pa_GetDefaultInputDevice()) ? 1 : 0;
		devPtr->isOut = (i == (int)Pa_GetDefaultOutputDevice()) ? 1 : 0;
		devPtr->frameRate = pdi->defaultSampleRate;
		if (devPtr->isIn) realInRate = (unsigned) devPtr->frameRate;
		if (devPtr->isOut) realOutRate = (unsigned) devPtr->frameRate;
		numRealInChannels += pdi->maxInputChannels;
		numRealOutChannels += pdi->maxOutputChannels;
	}
#ifdef DEBUG_SIREN				// Dump the whole device list
	printf("PA_init\n");
//	if (numDevices > 0 )
    printf("Pa_CountDevices returned d\n", numDevices);
	printf("	Found %d PortAudio devices\n", numDevices);
	for (i = 0; i < numDevices; i++) {
		devPtr = & devices[i];
		printf("\t\t%d: %s - %d i %d o ", devPtr->index, devPtr->name, devPtr->maxIn, devPtr->maxOut);
		if (devPtr->isIn) printf(" (def_in)");
		if (devPtr->isOut) printf(" (def_out)");
		printf("  SR: %g\n", devPtr->frameRate);
	}
#endif
	for (i = 0; i < NUM_CLIENTS; i++)
		clients[i].totalFrames = 0;
	return 0;
}

// Open a PA port with the ST callback enabled

int pa_open_s(int device, unsigned in_c, unsigned out_c, 
		unsigned long format, unsigned rate, unsigned blockSize,
		CallbackFcn cbBlock, unsigned short * in_buffer, unsigned short * out_buffer) {
	PaError err;
	PaStreamParameters inputP;
	PaStreamParameters outputP;

	if ( ! pa_is_inited)			// lazy initialization OK
		pa_initialize();
	if (pa_is_open)				// return if already open
		return 0;
#ifdef DEBUG_SIREN
	printf("PA_open_s: dev %d, %d in %d out, sr %d bs %d fmt %x\n", device, in_c, out_c, rate, blockSize, format);
#endif
	STupdate = cbBlock;			// store the callback block fcn ptr
	out_ch = out_c;				// # of channels
	in_ch = in_c;
	in_buf = (short *) in_buffer;	// store I/O buffer pointers
	out_buf = (short *) out_buffer;
								// set up the stream parameter structures
	inputP.device = (PaDeviceIndex) device;
	inputP.channelCount = in_c;
	inputP.sampleFormat = format;
	inputP.suggestedLatency = 0;
	inputP.hostApiSpecificStreamInfo = NULL;

	outputP.device = (PaDeviceIndex) device;
	outputP.channelCount = out_c;
	outputP.sampleFormat = format;
	outputP.suggestedLatency = 0;
	outputP.hostApiSpecificStreamInfo = NULL;
					// now open the specified PA stream
	err = Pa_OpenStream(&s_pa_stream,
				((in_c == 0) ? NULL : & inputP),
				((out_c == 0) ? NULL : & outputP),
				(double) rate, 
				(unsigned long) blockSize,
				paNoFlag,
				pa_callback_to_ST,
				NULL);
	if (err != paNoError) {
		pa_handle_error(err);
		oeFail(err);
	}
	pa_is_open = 1;
	bzero(in_buf, blockSize * in_ch * 2);
	bzero(out_buf, blockSize * out_ch * 2);
	return 0;
}

// Simpler version (does not use call-backs to Smalltalk)

int pa_open_p(int device, unsigned out_c, unsigned long format, unsigned rate, unsigned blockSize) {
	PaError err;
	PaStreamParameters inputP;
	PaStreamParameters outputP;

	if ( ! pa_is_inited)				// lazy initialization OK
		pa_initialize();
	if (pa_is_open)					// return if already open
		return 0;
#ifdef DEBUG_SIREN
	printf("PA_open_p: %d out, sr %d bs %d fmt %x\n", out_c, rate, blockSize, format);
#endif
									// set up the callback data structure	
	out_ch = out_c;
	in_ch = 0;
									// zero out the playing clients
	unsigned  i;
	for (i = 0; i < NUM_CLIENTS; i++)
		clients[i].totalFrames = 0;
									// set up the stream parameter structures
	outputP.device = (PaDeviceIndex) device;
	outputP.channelCount = out_c;
	outputP.sampleFormat = format;
	outputP.suggestedLatency = 0;
	outputP.hostApiSpecificStreamInfo = NULL;
									// now open the specified PA stream
	err = Pa_OpenStream(&s_pa_stream,
				NULL,				// no input
				& outputP,
				(double) rate, (unsigned long) blockSize, paNoFlag,
				pa_callback_no_ST, NULL);
	if (err != paNoError) {
		pa_handle_error(err);
		oeFail(err);
	}
	pa_is_open = 1;
	return 0;
}

// start PA playing

int pa_start(void) {
	PaError err;
	if ( ! pa_is_open) {			// no lazy opening allowed
		printf("Error: cannot start closed portaudio interface\n");
		oeFail(-1);
	}
	if (pa_is_running)				// return if already running
		return 0;
	DEBUG_P("PA_start\n");
	err = Pa_StartStream(s_pa_stream);
	if (err != paNoError) {
		pa_handle_error(err);
		oeFail(err);
	}
	pa_is_running = 1;
	return 0;
}

// stop PA playing

int pa_stop(void) {
	PaError err;
	if ( ! pa_is_running)
		return 0;
	DEBUG_P("PA_stop\n");
	err = Pa_StopStream(s_pa_stream);
	if (err != paNoError) {
		pa_handle_error(err);
		oeFail(err);
	}
	pa_is_running = 0;
	return 0;
}

// close PA stream

int pa_close(void) {
	PaError err;
	if ( ! pa_is_open)
		return 0;
	if (pa_is_running)
		pa_stop();
	DEBUG_P("PA_close\n");
	err = Pa_CloseStream(s_pa_stream);
	if (err != paNoError) {
		pa_handle_error(err);
		oeFail(err);
	}
	pa_is_open = 0;
	return 0;
}

// terminate PA altogether

int pa_terminate(void) {
	PaError err;
	if ( ! pa_is_inited)
		return 0;
	DEBUG_P("PA_terminate\n");
	err = Pa_Terminate();
	if (err != paNoError) {
		pa_is_inited = 0;
		pa_handle_error(err);
		oeFail(err);
	}
	pa_is_inited = 0;
	return 0;
}

// Play a sound buffer -- plug the given data into the client list

int pa_play(unsigned short * out_buffer, unsigned numChannels, unsigned numFrames, unsigned swap) {
	unsigned i;
	for (i = 0; i < NUM_CLIENTS; i++) {
		if (clients[i].totalFrames == 0) {
#ifdef DEBUG_SIREN
//			printf("PA_play %d frames %d ch (%x) cl %d\n", numFrames, numChannels, out_buffer, i);
#endif
			clients[i].data = out_buffer;
			clients[i].numChannels = numChannels;
			clients[i].totalFrames = numFrames;
			clients[i].currentFrame = 0;
			clients[i].doSwap = swap;
			return 0;
} } }

// Accessors return static variables

int pa_num_devices(void) {	return (int) numDevices;			}

int pa_num_in(void) {			return (int) numRealInChannels;	}

int pa_num_out(void) {		return (int) numRealOutChannels;	}

int pa_in_rate(void) {			return (int) realInRate;			}

int pa_out_rate(void) {		return (int) realOutRate;			}

int pa_in_device(void) {		return (int) defaultIn;				}

int pa_out_device(void) {		return (int) defaultOut;			}

// Get name copies a C string to ST

const char * pa_get_name(unsigned which) {
	if (which > numDevices)
		return "";
	return (const char *) (devices[which - 1].name);
}

int pa_dev_in(unsigned which) {
	if (which > numDevices)
		return -1;
	return (int) (devices[which - 1].maxIn);
}

int pa_dev_out(unsigned which) {
	if (which > numDevices)
		return -1;
	return (int) (devices[which - 1].maxOut);
}

int pa_dev_rate(unsigned which) {
	if (which > numDevices)
		return -1;
	return (int) (devices[which - 1].frameRate);
}
