/*
 * portmidi_lite.h -- minimal interface to the portmidi library for Siren
 *
 * Made for use with Visualworks Smalltalk DLLCC
 * Stephen Pope -- stp@create.ucsb.edu -- 2003.07.18
 *
 * The design is based on Siren's earlier MIDI APIs for use with Smalltalk
 * external primitive calls. The basic functions are initialize/terminate, 
 * open/close, and read/poll/write, with special calls for MIDI device and stream management.
 * The driver maintains a list of open streams onto portMIDI interfaces.
 * In-coming controller values can be cached in the driver and bulk-up-loaded to Smalltalk.
 */

// Function Prototypes

// initialize/terminate portmidi 

int pm_initialize(void);
int pm_terminate(void);
int pm_has_error(unsigned which);

// open/close the I/O stream 

int pm_open(int device, unsigned direction);	// open a stream and answer its index in the table
int pm_close(unsigned which);

// devices 

int pm_count_devices(void);

const char * pm_get_name(unsigned which);
int pm_dev_dir(unsigned which);

int pm_default_input_device(void);
int pm_default_output_device(void);

// I/O 

int pm_poll(unsigned which);		// return 1 if data available 
long pm_read(unsigned which);	// blocking read (will be run in a separate thread) 
long pm_get(unsigned which);		// non-blocking read (return nil if no input) 

int pm_write_short(unsigned which, long msg);	// 3 bytes encoded into a long 
int pm_write_data3(unsigned which, unsigned char d1, unsigned char d2, unsigned char d3);
int pm_write_data2(unsigned which, unsigned char d1, unsigned char d2);
int pm_write_long(unsigned which, long * msg, unsigned length);

// special calls for cached controllers 

int pm_start_controller_cacheing(void);
int pm_stop_controller_cacheing(void);
int pm_read_controllers(unsigned which, unsigned fromController, unsigned toController, short * data);

// test -- play a note

void pm_test(void);
