/*
 * portmidi_lite.c -- minimal interface to the portmidi library for Siren
 *
 * Made for use with Visualworks Smalltalk DLLCC
 * Stephen Pope -- stp@create.ucsb.edu -- 2003.07.16
 *
 * The design is based on Siren's earlier MIDI APIs for use with Smalltalk
 * external primitive calls. The basic functions are initialize/terminate, 
 * open/close, and read/poll/write, with special calls for MIDI device and stream management.
 * The driver maintains a list of open streams onto portMIDI interfaces.
 * In-coming controller values can be cached in the driver and bulk-up-loaded to Smalltalk.
 */

#include "SirenDLLCC.h"				// Debug macros
#include "portmidi_lite.h"

#include "porttime.h"				// PortMIDI includes
#include "portmidi.h"

#define INPUT_BUFFER_SIZE 100		// Defaults
#define OUTPUT_BUFFER_SIZE 0
#define DRIVER_INFO NULL
#define TIME_PROC  Pt_Time
#define TIME_INFO NULL
#define TIME_START Pt_Start(1, 0, 0)// timer w/millisecond accuracy

#define PM_OUTPUT 0				// I/O direction flags
#define PM_INPUT 1

// Globals

#define PM_MAX_STREAMS 4		// Allowed # of open streams
#define PM_BUF_LEN 1			// number of events to buffer
#define NUM_Devices 16			// Max PA devices
#define SD_NAMELEN 64			// length of device names

typedef struct {				// the PortMIDI streams we play out or get data from
	int device;				    // which device am I
	int direction;			    // which direction (in/out)
	PmStream * stream;		    // what's my PM stream
} PM_Record;

static PM_Record PM_Records[PM_MAX_STREAMS];	// static device table

/* structure for PA devices */

typedef struct {			
	int direction;			    // which direction (in/out)
	int isDefault;
	char name[SD_NAMELEN]; 
} PMSDevice;

// the array of active devices

static PMSDevice devices[NUM_Devices];	

// the event buffer

static PmEvent events[PM_BUF_LEN];		

static unsigned numDevices = 0;
static int pm_is_inited = 0;				// global driver state flags
static int pm_is_cacheing = 0;

// Controller value caches -- This is the minimum complement.
// A "larger" driver would cache 128*16 controllers and 128*16 key pressures.

static unsigned char pm_controllers[PM_MAX_STREAMS][128];		// Controller value table
static unsigned char pm_key_pressures[PM_MAX_STREAMS][128];	// Polyphonic key pressure table
static unsigned char pm_chan_pressures[PM_MAX_STREAMS][16];	// Channel pressure value table
static short pm_pitch_bend[PM_MAX_STREAMS][16];				// The value of the pitch wheel

// Functions

// Find the first NULL pointer, or the element that matches the given device and direction,
// in the array of MIDI stream info structures

int pm_free_index(int which, int direction) {
	int i;
	PM_Record * rec;
	
	for (i = 0; i < PM_MAX_STREAMS; i++) {
		rec = & PM_Records[i];
		if ((rec->device == which) && (rec->direction == direction)) {
			return i;
		} else if (rec->stream == 0) {
			rec->device = which;			// for thread-safety
			return i;
		}
	}
	return -1;		// too many open streams
}

// PM error handler

void pm_handle_error(PmError err) {
	Pm_Terminate();
	DEBUG_P("\tAn error occured while using PortMIDI\n");
	printf("\tPortMIDI Error number %d: %s\n", err, Pm_GetErrorText(err));	
}

// initialize/terminate calls

int pm_initialize(void) {
	PmError err;
	PMSDevice * devPtr;
	int i;

	DEBUG_P("PM_init\n");
	if (pm_is_inited)
		return 0;
	err = Pm_Initialize();		// call portMIDI
	if (err != pmNoError) {
		printf("PM_init--error");
		pm_handle_error(err);
		oeFail(err);
	}
	for (i = 0; i < PM_MAX_STREAMS; i++) {
		PM_Records[i].device = -1;
		PM_Records[i].direction = -1;
		PM_Records[i].stream = NULL;
	}
	pm_is_inited = 1;
	numDevices = Pm_CountDevices();
#ifdef DEBUG_SIREN							// dump the device list
	printf("MIDI devices (%d):\n", numDevices);
	for (i = 0; i < numDevices; i++) {
		const PmDeviceInfo * info = Pm_GetDeviceInfo(i);
		printf("\t%d: %s, %s  ", i, info->interf, info->name);
		if (info->input)		printf(" in");
		if (info->output)		printf(" out");
		if (i == (int) Pm_GetDefaultInputDeviceID())		printf(" -- default in");
		if (i == (int) Pm_GetDefaultOutputDeviceID())	printf(" -- default out");
		printf("\n");
		devPtr = & devices[i];
		sprintf(devPtr->name, "%s: %s", info->interf, info->name);
		devPtr->direction = info->input ? 1 : 0;
		devPtr->isDefault = ((i == (int) Pm_GetDefaultInputDeviceID())
						|| (i == (int) Pm_GetDefaultOutputDeviceID())) ? 1 : 0;
	}
#endif
	return 0;
}

int pm_terminate(void) {
	DEBUG_P("PM_terminate\n");
	PmError err;
	err = Pm_Terminate();		// call portMIDI
	if (err != pmNoError) {
		pm_handle_error(err);
		oeFail(err);
	}
	pm_is_inited = 0;
	return 0;
}

// pm_open: open the I/O stream; answer the index

int pm_open(int device, unsigned direction) {
	PmError err;
	DEBUG_P3("PM_open: %d - %d  -- ", device , direction);
	if ( ! pm_is_inited)
		pm_initialize();
	int index = pm_free_index(device, direction);	// find the first free index
	if (index < 0) {
		printf("PM_open -- can't find free index!\n");
		return -1;								// no free streams
	}
	PM_Record * rec = & PM_Records[index];		// ptr to current PM record
	if (rec->stream != NULL) {
		DEBUG_P2("found open port %d\n", index);
		return index;
	}
	if (direction == PM_INPUT) {				// open input stream
		DEBUG_P2("PM_open input %d\n", index);
		err = Pm_OpenInput(& rec->stream, 
			(PmDeviceID) device, 
			DRIVER_INFO,
			OUTPUT_BUFFER_SIZE, 
			TIME_PROC,
			TIME_INFO);							// no MIDI thru
		if (err != pmNoError) {
			DEBUG_P("\tPM_openIn error --");
			pm_handle_error(err);
			oeFail(err);
		}										// set up the default input filters
		Pm_SetFilter(rec->stream, PM_FILT_ACTIVE | PM_FILT_CLOCK | PM_FILT_SYSEX);
		while (Pm_Poll(rec->stream))				// flush the input queue
			Pm_Read(rec->stream, events, 1);
		rec->device = device;						// set the device flag
		rec->direction = direction;
//		printf("\topenIn: %d/%d = %x\n", PM_Records[index].device,
//					PM_Records[index].direction, PM_Records[index].stream);
//		DEBUG_P2("\tPM_open returns %d\n", index);
		return index;
	} 
	if (direction == PM_OUTPUT) {					// open output stream
		DEBUG_P2("PM_open output %d\n", index);
		err = Pm_OpenOutput(& rec->stream, 
			(PmDeviceID) device, 
			DRIVER_INFO,
			0,									// no output buffering
			TIME_PROC,
			TIME_INFO, 0l);						// no latency
		if (err != pmNoError) {
			DEBUG_P("--- PM_openOut error --");
			pm_handle_error(err);
			oeFail(err);
		}
		rec->device = device;
		rec->direction = direction;
//		DEBUG_P2("\tPM_open returns %d\n", index);
		return index;
	} 
	printf("\tError in PM_open: unknown direction: %d\n", direction);
	return -1;
}

// pm_close -- close

int pm_close(unsigned which) {
	DEBUG_P2("PM_close %d\n", which);
	PmError err;
	PM_Record * rec = & PM_Records[which];
	if (rec->stream == NULL) {
		printf("\tError in PM_close: unknown device: %d\n", which);
	} else {
		err = Pm_Close(rec->stream);
		if (err != pmNoError) {
			pm_handle_error(err);
			oeFail(err);
		}
	}
	rec->stream = NULL;
	rec->device = -1;
	rec->direction = -1;
	return 0;
}

// Handling devices

int pm_count_devices(void) {
	int val = Pm_CountDevices();
//	DEBUG_P2("\tpm_count_devices answers %d\n", val);
	return val;
}

// answer the direction of the given device

int pm_dev_dir(unsigned which) {
	if (which > numDevices)
		return -1;
	return (int) (devices[which - 1].direction);
}

// answer whether the given device is the default I or O

int pm_default_input_device(void) {
	return Pm_GetDefaultInputDeviceID();
}

int pm_default_output_device(void) {
	return Pm_GetDefaultOutputDeviceID();
}

const char * pm_get_name(unsigned which) {
	if (which > numDevices)
		return NULL;
	const PmDeviceInfo * info = Pm_GetDeviceInfo(which - 1);
//	DEBUG_P2("\tpm_get_name answers %s\n", info->name);
	return (char *) info->name;
}

int pm_has_error(unsigned which) {
	if (PM_Records[which].stream == NULL) {
		printf:("PM: error getting host error on non-existent device %d\n", which);
		return(-100);
	}
	return (Pm_HasHostError(PM_Records[which].stream));
}

// pm_poll -- answer 1 if there's input

int pm_poll(unsigned which) {
	if (PM_Records[which].stream == NULL) {
		DEBUG_P2("PM: error polling non-existent device %d\n", which);
		return 0;
	}
	return Pm_Poll(PM_Records[which].stream);		// portMIDI polling call
}

// Non-blocking threaded read (might return nil)

long pm_get(unsigned which) {
	DEBUG_P("PM_get\n");
	PmError len;
	PM_Record * rec = & PM_Records[which];
	if (rec->stream == NULL)
		oeFail(-1);				// this should be a serious error
								//check for input
	if ( ! Pm_Poll(rec->stream)) 	
		return 0;
								// read input
	len = Pm_Read(rec->stream, events, PM_BUF_LEN);
	if (len < 0) {				// on error
		pm_handle_error(len);
		oeFail(len);
	}
	return(events[0].message);
}

// Blocking threaded read

long pm_read(unsigned which) {
	PmError len;
	PM_Record * rec = & PM_Records[which];
	if (rec->stream == NULL) {
		DEBUG_P2("PM: error reading from non-existent device %d\n", which);
		oeFail(-1);				// this should be a serious error
	}							// loop to wait for input
	while ( ! Pm_Poll(rec->stream)) 	
		usleep(500);				// sleep for 500 usec
								// read input
	len = Pm_Read(rec->stream, events, PM_BUF_LEN);
//	DEBUG_P3("PM_read %d = %d\n", which, len);
	if (len < 0) {				// on error
		pm_handle_error(len);
		oeFail(len);
	}
	if (len == 0)
		return 0;
	long msg = events[0].message;
	unsigned cmd = msg & 0xF0;
	unsigned chan = msg & 0x0F;
//	printf("\tCmd  %x  %d  %d  %d\n", cmd, chan, (Pm_MessageData1(msg)), (Pm_MessageData2(msg)));
	unsigned arg1, arg2;
	if (pm_is_cacheing)  {					// Cache controller values in the driver
		if (cmd == 0xB0) {					// Read a control command
			arg1 = Pm_MessageData1(msg);
			arg2 = Pm_MessageData2(msg);
			pm_controllers[which][arg1] = arg2;
//			printf("\tCtrlr %d.%d = %d\n", which, arg1, arg2);
			return 0;
		}
		if (cmd == 0xE0) {					// Read a pitch wheel change
			arg1 = Pm_MessageData1(msg);
			arg2 = Pm_MessageData2(msg);
			pm_pitch_bend[which][chan] = (arg2 << 7) + arg1;
			return 0;
		}
		if (cmd == 0xA0) {					// Read polyphonic key pressure
			arg1 = Pm_MessageData1(msg);
			arg2 = Pm_MessageData2(msg);
			pm_key_pressures[which][arg1] = arg2;
			return 0;
		}
		if (cmd == 0xD0) {					// Read channel key pressure
			arg1 = Pm_MessageData1(msg);
			arg2 = Pm_MessageData2(msg);
			pm_chan_pressures[which][arg1] = arg2;
			return 0;
		}
	}
	return(msg);
}

// Several formats for the write function

// write a pre-formatted message (a 32-bit long with 3 lower bytes as midi)

int pm_write_short(unsigned which, long msg) {
	DEBUG_P2("PM_write: %x\n", (unsigned int) msg);
	PmError err;
	if (PM_Records[which].stream == NULL)
		oeFail(-1);
	err = Pm_WriteShort(PM_Records[which].stream, 0 /* TIME_PROC(TIME_INFO) */, msg);
	if (err != pmNoError) {
		pm_handle_error(err);
		oeFail(err);
	}
	return 0;
}

// write the 3 given bytes

int pm_write_data3(unsigned which, unsigned char d1, unsigned char d2, unsigned char d3){
	PmError err;
#ifdef DEBUG_SIREN
	printf("PM_write3: %d: %d - %d - %d\n", which, d1, d2, d3);
#endif
	unsigned ww = which;
	if (PM_Records[which].stream == NULL) {
//		DEBUG_P("PM_write3--no stream\n");
//		oeFail(-1);
		ww = Pm_GetDefaultOutputDeviceID();
	}
	err = Pm_WriteShort(PM_Records[ww].stream, 0 /* TIME_PROC(TIME_INFO) */, Pm_Message(d1, d2, d3));
	if (err != pmNoError) {
        printf("\tError in PM_write3 -- [%d: %d %d %d]", ww, d1, d2, d3);
		pm_handle_error(err);
		oeFail(err);
	}
	return 0;
}

// write a 2-byte command

int pm_write_data2(unsigned which, unsigned char d1, unsigned char d2){
	return pm_write_data3(which, d1, d2, 0);
}

// write an array of longs

int pm_write_long(unsigned which, long * msg, unsigned length) {
	DEBUG_P2("PM_write: %x\n", (unsigned int) * msg);
	PmError err;
	int i;
	int todo = (length > PM_BUF_LEN) ? PM_BUF_LEN : length;
	if (PM_Records[which].stream == NULL)
		oeFail(-1);
	for (i = 0; i < todo; i++) {
        events[i].timestamp = 0; // TIME_PROC(TIME_INFO);
		events[i].message = msg[i];
	}
	err = Pm_Write(PM_Records[which].stream, events, todo);
	if (err != pmNoError) {
		pm_handle_error(err);
		oeFail(err);
	}
	return 0;
}

//
// Special calls for cached controllers
//

int pm_start_controller_cacheing(void) {
	DEBUG_P("PM start controller cacheing\n");
	pm_is_cacheing = 1;
	return 0;
}

int pm_stop_controller_cacheing(void) {
	DEBUG_P("PM stop controller cacheing\n");
	pm_is_cacheing = 0;
	return 0;
}

// Copy a block of controllers into the given buffer

int pm_read_controllers(unsigned which, unsigned fromC, unsigned toC, short * data) {
	if ( ! pm_is_cacheing) 
		return -1;	
	int i;
	short * pdata = data;
//	printf("PM read controller %d.%d = %d\n", which, fromC, pm_controllers[which][fromC]);
											// check controller range
	if ((fromC < 0) || (toC > 287) || (fromC > toC))
		return (-1);
	for (i = fromC; i <= toC; i++) {				// Loop to read controllers
		if (i < 128)							// 0-127 = controllers
			*pdata++ = (short) pm_controllers[which][i];
		else if (i < 256)						// 128-255 = key pressures
			*pdata++ = (short) pm_key_pressures[which][i - 128];
		else if (i < 272)						// 256-271 = channel pressures
			*pdata++ = (short) pm_chan_pressures[which][i - 256];
		else 								// 272-287 = pitch bend (16-bit!)
			*pdata++ = (short) pm_pitch_bend[which][i - 272];	// Write ints
	}
	return(toC - fromC + 1);
}

// pm_test -- play a note

void pm_test(void) {
	PmError err;
	int i_in = 0, i_op = 0;		// whether I initialized or opened MIDI
	int which = 0;				// which stream I test on
	DEBUG_P("PM_test\n");
	if ( ! pm_is_inited) {		// lazy initialization
		err = pm_initialize();
		if (err != pmNoError) {
			pm_handle_error(err);
			oeFail(err);
		}
		i_in = 1;
	}
	if (PM_Records[which].stream == NULL) { 	// lazy port open
		err = pm_open(Pm_GetDefaultOutputDeviceID(), PM_OUTPUT);
		if (err != pmNoError) {
			pm_handle_error(err);
			oeFail(err);
		}
		i_op = 1;
		which = err;
	}					// play note-on
	DEBUG_P("\tplaying...\n");
	pm_write_data3(which, 0x90, 48, 100);
	usleep(700000);				// sleep 700 msec, then play note-off
	pm_write_data3(which, 0x80, 48, 100);
	
	if (i_op) {				// if I open, close
		err = pm_close(which);
		if (err != pmNoError) {
			pm_handle_error(err);
			oeFail(err);
		}
	}
	if (i_in) {				// if I init, terminate
		err = pm_terminate();
		if (err != pmNoError) {
			pm_handle_error(err);
			oeFail(err);
		}
	}
}
