

Smalltalk.Siren defineClass: #SirenExternalInterface
	superclass: #{External.ExternalInterface}
	indexedType: #none
	private: false
	instanceVariableNames: ''
	classInstanceVariableNames: 'singleton instance '
	imports: '
			private Siren.SirenExternalInterfaceDictionary.*
			'
	category: 'MusicIO-External'
	attributes: #(
			#(#includeFiles #())
			#(#includeDirectories #())
			#(#libraryFiles #())
			#(#libraryDirectories #())
			#(#beVirtual false)
			#(#optimizationLevel #full))!

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!


!Siren.SirenExternalInterface class methodsFor: 'class var accessing'!

flush
	instance := nil!

instance
	"Answer the singleton."

	^singleton! !

!Siren.SirenExternalInterface class methodsFor: 'initialization'!

unload
	"SirenExternalInterface unload"

	SirenExternalInterface allSubclassesDo: [ :cl | cl flush. cl unloadLibraries]! !

!Siren.SirenExternalInterface class methodsFor: 'instance creation'!

new
	"Answer a new instance, OR the singleton"

	instance ifNil: [instance := super new initialize].
	^instance! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!


!Siren.SirenExternalInterface methodsFor: 'initialize-release'!

initialize
	"ignored"

	^self! !



Smalltalk.Siren defineClass: #FFTWInterface
	superclass: #{Siren.SirenExternalInterface}
	indexedType: #none
	private: false
	instanceVariableNames: ''
	classInstanceVariableNames: ''
	imports: '
			private Siren.FFTWInterfaceDictionary.*
			'
	category: 'MusicIO-External'
	attributes: #(
			#(#includeFiles #('fftw_lite.h'))
			#(#includeDirectories #('Siren7.5/DLLCC'))
			#(#libraryFiles #('fftw_lite.dylib' 'libfftw3f.a'))
			#(#libraryDirectories #('/usr/local/lib'))
			#(#beVirtual false)
			#(#optimizationLevel #full))!

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!


!Siren.FFTWInterface class methodsFor: 'examples'!

example
	"Demonstrate using the FFTWInterface by taking the FFT of a sawtooth wave"
	"FFTWInterface example"

	| fft size val samples spectrum incr "e scale" mag signalFcn spectFcn |
	size :=  1024.
"Create a sawtooth"
	samples := UninterpretedBytes new: (size * 4).
	val := -0.8.
	incr := 0.02.
	1 to: size do:					
		[ :ind |
		samples floatAt: (ind - 1 * 4 + 1) put: val.
		val := val + incr.
		(val > 0.8) ifTrue: [val := val - 1.6]].
	samples gcCopyToHeap.
	spectrum := UninterpretedBytes new: (size * 4 + 1).
	spectrum gcCopyToHeap.
"Initialize"
	fft := FFTWInterface new.				"set up the FFT"
	val := fft fftw_initialize: size with: samples with: spectrum.
	Transcript cr; show: 'FFTW_init returned: ', val printString; cr.
"Do the FFT"
	fft fftw_forward_transform.
"Now get the magnitude spectrum"
	signalFcn := Function ofSize: size / 2.
	spectFcn := Function ofSize: size / 2.
"	e := 2.71828183.
	scale := 0.11512925.
"	1 to: size by: 2 do:
		[ :ind | | re im |
		re := spectrum floatAt: (ind - 1 * 4 + 1).
		im := spectrum floatAt: (ind * 4 + 1).
		mag := ((re * re) + (im * im)) sqrt.
"		spectFcn add: (e raisedTo: (mag * scale))"		"amp = exp(a * 0.11512925)"
		spectFcn add: mag.
		signalFcn add: ((samples floatAt: (ind - 1 * 4 + 1)) / 4.0)].
	FunctionView lineWidth: 1.
	InputState default shiftDown
		ifFalse: [FunctionView onFunctions: (Array with: signalFcn with: spectFcn) 
					normalize: #(false true true true) ]
		ifTrue: [spectFcn edit]! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!


!Siren.FFTWInterface methodsFor: 'procedures'!

fftw_float_to_short: data
	<C: void fftw_float_to_short(short * data)>
	^self externalAccessFailedWith: _errorCode!

fftw_forward_transform
	<C: void fftw_forward_transform(void)>
	^self externalAccessFailedWith: _errorCode!

fftw_initialize: size with: samples with: spectrum
	<C: int fftw_initialize(unsigned int size, float * samples, float * spectrum)>
	^self externalAccessFailedWith: _errorCode!

fftw_mag_spectrum: data
	<C: void fftw_mag_spectrum(float * data)>
	^self externalAccessFailedWith: _errorCode!

fftw_phas_spectrum: data
	<C: void fftw_phas_spectrum(float * data)>
	^self externalAccessFailedWith: _errorCode!

fftw_reverse_transform
	<C: void fftw_reverse_transform(void)>
	^self externalAccessFailedWith: _errorCode!

fftw_short_to_float: data
	<C: void fftw_short_to_float(short * data)>
	^self externalAccessFailedWith: _errorCode! !



Smalltalk.Siren defineClass: #PortMidiInterface
	superclass: #{Siren.SirenExternalInterface}
	indexedType: #none
	private: false
	instanceVariableNames: ''
	classInstanceVariableNames: ''
	imports: '
			private Siren.PortMidiInterfaceDictionary.*
			'
	category: 'MusicIO-External'
	attributes: #(
			#(#includeFiles #('portmidi_lite.h'))
			#(#includeDirectories #('Siren7.5/DLLCC'))
			#(#libraryFiles #('portmidi_lite.dylib' 'portmidi.dylib' 'CoreMIDI'))
			#(#libraryDirectories #('/usr/local/lib' '/System/Library/Frameworks/CoreMIDI.framework/Versions/Current'))
			#(#beVirtual false)
			#(#optimizationLevel #full))!

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!


!Siren.PortMidiInterface class methodsFor: 'examples'!

example1
	"Demonstrate using the PortMidiInterface"
	"PortMidiInterface example1"
	"PortMidiInterface unloadLibraries"

	| pm val in out cnt nam dir |
	pm := PortMidiInterface new.
"Initialize PM"
	val := pm pm_initialize.
	Transcript cr; show: 'PM_init returned: ', val printString; cr.
	in := pm pm_default_input_device.
	Transcript tab; show: 'pm_default_input_device returned: ', in printString; cr.
	out := pm pm_default_output_device.
	Transcript tab; show: 'pm_default_output_device returned: ', out printString; cr.
	cnt := pm pm_count_devices.
	Transcript show: 'pm_count_devices returned: ', cnt printString; cr.
	1 to: cnt do: [ :ind |
		nam := pm pm_get_name: ind.
		dir := pm pm_dev_dir: ind.
		Transcript tab; show: ind printString, ' = ', nam copyCStringFromHeap, '  (', dir printString, ')'; cr].
"Open PM device for output"
	out < 0 ifTrue: [Transcript show: 'No devices found; done'. ^self].
	val := pm pm_open: out with: 0.
	Transcript show: 'PM_open returned: ', val printString; cr.
"Test plays a note"
	Transcript show: 'PM_test...'; cr.
	pm pm_test.
"Close & terminate"
	val := pm pm_close: out.
	Transcript show: 'PM_close returned: ', val printString; cr.
	val := pm pm_terminate.
	Transcript show: 'PM_terminate returned: ', val printString; cr.!

testMIDI
	"Demonstrate using the PortMidiInterface to call the test note function in the driver"
	"PortMidiInterface testMIDI"
	"PortMidiInterface unloadLibraries"

	| pm val in out |
	pm := PortMidiInterface new.
	val := pm pm_initialize.
	Transcript cr; show: 'PM_init returned: ', val printString; cr.
	in := pm pm_default_input_device.
	Transcript tab; show: 'pm_default_input_device returned: ', in printString; cr.
	out := pm pm_default_output_device.
	Transcript tab; show: 'pm_default_output_device returned: ', out printString; cr.
	val := pm pm_open: out with: 0.
	Transcript show: 'PM_open returned: ', val printString; cr.
	pm pm_test.			"call the test code in the driver"
	val := pm pm_close: val.
	Transcript show: 'PM_close returned: ', val printString; cr.
	val := pm pm_terminate.
	Transcript show: 'PM_terminate returned: ', val printString; cr.!

testMIDI2
	"Demonstrate using the PortMidiInterface to play a note on/off cmd pair"
	"PortMidiInterface testMIDI2"
	"PortMidiInterface unloadLibraries"

	| pm val which |
	pm := PortMidiInterface new.
"Init"
	val := pm pm_initialize.
	Transcript cr; show: 'PM_init returned: ', val printString; cr.
"Open"
	which := pm pm_open: MIDIVoice defaultOutInterface with: 0.
	Transcript show: 'PM_open returned: ', which printString; cr.
"Send note on"
	pm pm_write_data3: which "MIDIVoice defaultOutInterface" with: 144 with: 48 with: 120.
	1 wait.
"Send note off"
	pm pm_write_data3: which "MIDIVoice defaultOutInterface" with: 128 with: 48 with: 120.
	1 wait.
"Close"
	val := pm pm_close: which.
	Transcript show: 'PM_close returned: ', val printString; cr.
"Terminate"
	val := pm pm_terminate.
	Transcript show: 'PM_terminate returned: ', val printString; cr.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!


!Siren.PortMidiInterface methodsFor: 'types'!

OEoop
	<C: typedef void * OEoop>! !

!Siren.PortMidiInterface methodsFor: 'procedures'!

pm_close: which
	<C: int pm_close(unsigned int which)>
	^self externalAccessFailedWith: _errorCode!

pm_count_devices
	<C: int pm_count_devices(void)>
	^self externalAccessFailedWith: _errorCode!

pm_default_input_device
	<C: int pm_default_input_device(void)>
	^self externalAccessFailedWith: _errorCode!

pm_default_output_device
	<C: int pm_default_output_device(void)>
	^self externalAccessFailedWith: _errorCode!

pm_dev_dir: which
	<C: int pm_dev_dir(unsigned int which)>
	^self externalAccessFailedWith: _errorCode!

pm_get: which
	<C: long pm_get(unsigned int which)>
	^self externalAccessFailedWith: _errorCode!

pm_get_name: which
	<C: const char *  pm_get_name(unsigned int which)>
	^self externalAccessFailedWith: _errorCode!

pm_has_error: which
	<C: int pm_has_error(unsigned int which)>
	^self externalAccessFailedWith: _errorCode!

pm_initialize
	<C: int pm_initialize(void)>
	^self externalAccessFailedWith: _errorCode!

pm_open: device with: direction
	<C: int pm_open(int device, unsigned int direction)>
	^self externalAccessFailedWith: _errorCode!

pm_poll: which
	<C: int pm_poll(unsigned int which)>
	^self externalAccessFailedWith: _errorCode!

pm_read: which
	<C: long pm_read(unsigned int which)>
	^self externalAccessFailedWith: _errorCode!

pm_read_controllers: which with: fromController with: toController with: data
	<C: int pm_read_controllers(unsigned int which, unsigned int fromController, unsigned int toController, short * data)>
	^self externalAccessFailedWith: _errorCode!

pm_start_controller_cacheing
	<C: int pm_start_controller_cacheing(void)>
	^self externalAccessFailedWith: _errorCode!

pm_stop_controller_cacheing
	<C: int pm_stop_controller_cacheing(void)>
	^self externalAccessFailedWith: _errorCode!

pm_terminate
	<C: int pm_terminate(void)>
	^self externalAccessFailedWith: _errorCode!

pm_test
	<C: void pm_test(void)>
	^self externalAccessFailedWith: _errorCode!

pm_write_data2: which with: d1 with: d2
	<C: int pm_write_data2(unsigned int which, unsigned char d1, unsigned char d2)>
	^self externalAccessFailedWith: _errorCode!

pm_write_data3: which with: d1 with: d2 with: d3

	<C: int pm_write_data3(unsigned int which, unsigned char d1, unsigned char d2, unsigned char d3)>
	^self externalAccessFailedWith: _errorCode!

pm_write_long: which with: msg with: length
	<C: int pm_write_long(unsigned int which, long * msg, unsigned int length)>
	^self externalAccessFailedWith: _errorCode!

pm_write_short: which with: msg
	<C: int pm_write_short(unsigned int which, long msg)>
	^self externalAccessFailedWith: _errorCode! !



Smalltalk.Siren defineClass: #LibSndFileInterface
	superclass: #{Siren.SirenExternalInterface}
	indexedType: #none
	private: false
	instanceVariableNames: ''
	classInstanceVariableNames: ''
	imports: '
			private Siren.LibSndFileInterfaceDictionary.*
			'
	category: 'MusicIO-External'
	attributes: #(
			#(#includeFiles #('sndfile_lite.h'))
			#(#includeDirectories #('Siren7.5/DLLCC'))
			#(#libraryFiles #('libsndfile.dylib' 'sndfile_lite.dylib'))
			#(#libraryDirectories #('/usr/local/lib'))
			#(#beVirtual false)
			#(#optimizationLevel #full))!

Siren.LibSndFileInterface defineSharedVariable: #SF_Constants
	private: false
	constant: false
	category: 'As yet unclassified'
	initializer: nil!

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!


!Siren.LibSndFileInterface class methodsFor: 'class initialization'!

const: flag
	
	^SF_Constants at: flag!

initialize
	"Set up the class constants dictionary"
	"LibSndFileInterface initialize"
 
	"	/* file formats */
	SF_FORMAT_WAV			= 0x010000,		/* Microsoft WAV format (little endian default). */
	SF_FORMAT_AIFF			= 0x020000,		/* Apple/SGI AIFF format (big endian). */
	SF_FORMAT_AU				= 0x030000,		/* Sun/NeXT AU format (big endian). */
	SF_FORMAT_RAW			= 0x040000,		/* RAW PCM data. */
	SF_FORMAT_PAF			= 0x050000,		/* Ensoniq PARIS file format. */
	SF_FORMAT_SVX			= 0x060000,		/* Amiga IFF / SVX8 / SV16 format. */
	SF_FORMAT_NIST			= 0x070000,		/* Sphere NIST format. */
	SF_FORMAT_VOC			= 0x080000,		/* VOC files. */
	SF_FORMAT_IRCAM			= 0x0A0000,		/* Berkeley/IRCAM/CARL */

	/* Subtypes from here on. */
	SF_FORMAT_PCM_S8		= 0x0001,		/* Signed 8 bit data */
	SF_FORMAT_PCM_16		= 0x0002,		/* Signed 16 bit data */
	SF_FORMAT_PCM_24		= 0x0003,		/* Signed 24 bit data */
	SF_FORMAT_PCM_32		= 0x0004,		/* Signed 32 bit data */
	SF_FORMAT_PCM_U8		= 0x0005,		/* Unsigned 8 bit data (WAV and RAW only) */
	SF_FORMAT_FLOAT			= 0x0006,		/* 32 bit float data */
	SF_FORMAT_DOUBLE		= 0x0007,		/* 64 bit float data */

	SF_FORMAT_ULAW			= 0x0010,		/* U-Law encoded. */
	SF_FORMAT_ALAW			= 0x0011,		/* A-Law encoded. */

	        /* Modes for opening files. */
	#define LSFM_READ 0x10
	#define LSFM_WRITE 0x20
	#define LSFM_RDWR 0x30
	"
	SF_Constants := IdentityDictionary new.
	SF_Constants at: #LSF_FORMAT_WAV put: 16r010000.
	SF_Constants at: #LSF_FORMAT_AIFF put: 16r020000.
	SF_Constants at: #LSF_FORMAT_AU put: 16r030000.
	SF_Constants at: #LSF_FORMAT_RAW put: 16r040000.
	SF_Constants at: #LSF_FORMAT_IRCAM put: 16r0A0000.

	SF_Constants at: #LSF_FORMAT_PCM_S8 put: 16r0001.
	SF_Constants at: #LSF_FORMAT_PCM_16 put: 16r0002.
	SF_Constants at: #LSF_FORMAT_PCM_24 put: 16r0003.
	SF_Constants at: #LSF_FORMAT_PCM_32 put: 16r0004.
	SF_Constants at: #LSF_FORMAT_FLOAT put: 16r0006.
	SF_Constants at: #LSF_FORMAT_DOUBLE put: 16r0007.
	SF_Constants at: #LSF_FORMAT_ULAW put: 16r0010.

	SF_Constants at: #LSFM_READ put: 16r10.
	SF_Constants at: #LSFM_WRITE put: 16r20.
	SF_Constants at: #LSFM_RDWR put: 16r30.
	SF_Constants at: #SEEK_SET put: 0.
	SF_Constants at: #SEEK_CURRENT put: 1.
	SF_Constants at: #SEEK_END put: 2.! !

!Siren.LibSndFileInterface class methodsFor: 'examples'!

example1: filename
	"Demonstrate using the LibSndFileInterface; this will dump some messages to the transcript"
	"LibSndFileInterface example1: 'unbelichtet.aiff'"

	| interface index val data frames channels |
	interface := LibSndFileInterface new.
"Open a sound file"
	index := interface lsf_open: (SirenUtility findFile: filename) with: (self const: #LSFM_READ).
	Transcript cr; show: 'Open returned: ', index printString; cr.
"Read the file format, rate, # of channels, etc."
	val := interface lsf_get_format: index.
	Transcript show: 'getSndFileFormat returned: ', (val printStringRadix: 16); cr.
	val := interface lsf_get_rate: index.
	Transcript show: 'getSndFileRate returned: ', val printString; cr.
	channels := interface lsf_get_channels: index.
	Transcript show: 'getSndFileChannels returned: ', channels printString; cr.
	frames := interface lsf_get_frames: index.
	Transcript show: 'getSndFileFrames returned: ', frames printString; cr.
"Allocate a buffer of shorts"
	data := (WordArray new: frames * channels) copyToHeapAsSigned: #malloc:.
	data beGarbageCollectable.
"Read samples into it"
	val := interface lsf_read_Isamples: index with: data with: frames.
	Transcript show: 'readSndFileISamples returned: ', val printString; cr.
"Dump the first 100 samples"
	0 to: 99 do:
		[ :in | Transcript show: (data at: in) printString; tab].
"Close the file"
	val := interface lsf_close: index.
	Transcript cr; show: 'closeSndFile returned: ', val printString; cr.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!


!Siren.LibSndFileInterface methodsFor: 'procedures'!

lsf_close: which
	<C: int lsf_close(unsigned int which)>
	^self externalAccessFailedWith: _errorCode!

lsf_create: name with: mode with: format with: rate with: channels
	<C: int lsf_create(char * name, unsigned int mode, unsigned int format, unsigned int rate, unsigned int channels)>
	^self externalAccessFailedWith: _errorCode!

lsf_get_channels: which
	<C: int lsf_get_channels(unsigned int which)>
	^self externalAccessFailedWith: _errorCode!

lsf_get_format: which
	<C: int lsf_get_format(unsigned int which)>
	^self externalAccessFailedWith: _errorCode!

lsf_get_frames: which
	<C: int lsf_get_frames(unsigned int which)>
	^self externalAccessFailedWith: _errorCode!

lsf_get_rate: which
	<C: int lsf_get_rate(unsigned int which)>
	^self externalAccessFailedWith: _errorCode!

lsf_open: name with: mode
	<C: int lsf_open(char * name, unsigned int mode)>
	^self externalAccessFailedWith: _errorCode!

lsf_read_Fsamples: which with: where with: count
	<C: int lsf_read_Fsamples(unsigned int which, float * where, unsigned int count)>
	^self externalAccessFailedWith: _errorCode!

lsf_read_Isamples: which with: where with: count
	<C: int lsf_read_Isamples(unsigned int which, short * where, unsigned int count)>
	^self externalAccessFailedWith: _errorCode!

lsf_seek: which with: pos with: key
	<C: int lsf_seek(unsigned int which, unsigned int pos, unsigned int key)>
	^self externalAccessFailedWith: _errorCode!

lsf_write_Fsamples: which with: where with: count
	<C: int lsf_write_Fsamples(unsigned int which, float * where, unsigned int count)>
	^self externalAccessFailedWith: _errorCode!

lsf_write_Isamples: which with: where with: count
	<C: int lsf_write_Isamples(unsigned int which, short * where, unsigned int count)>
	^self externalAccessFailedWith: _errorCode! !



Smalltalk.Siren defineClass: #PortAudioInterface
	superclass: #{Siren.SirenExternalInterface}
	indexedType: #none
	private: false
	instanceVariableNames: 'cbProcess ioSemaphore '
	classInstanceVariableNames: ''
	imports: '
			private Siren.PortAudioInterfaceDictionary.*
			'
	category: 'MusicIO-External'
	attributes: #(
			#(#includeFiles #('portaudio_lite.h'))
			#(#includeDirectories #('Siren7.5/DLLCC'))
			#(#libraryFiles #('portaudio_lite.dylib' 'libportaudio.dylib'))
			#(#libraryDirectories #('/usr/local/lib'))
			#(#beVirtual false)
			#(#optimizationLevel #full))!

Siren.PortAudioInterface defineSharedVariable: #PA_Constants
	private: false
	constant: false
	category: 'As yet unclassified'
	initializer: nil!

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!


!Siren.PortAudioInterface class methodsFor: 'class initialization'!

const: flag
	
	^PA_Constants at: flag!

initialize
	"Set up the class constants dictionary (PortAudio 19)"
	"PortAudioInterface initialize"
 	"PortAudioInterface const: #lin16Bit"

	"#define paFloat32        ((PaSampleFormat) 0x00000001)
	#define paInt32          ((PaSampleFormat) 0x00000002)
	#define paInt24          ((PaSampleFormat) 0x00000004) 
	#define paInt16          ((PaSampleFormat) 0x00000008)
	#define paInt8           ((PaSampleFormat) 0x00000010)
	#define paUInt8          ((PaSampleFormat) 0x00000020)	"

	PA_Constants := IdentityDictionary new.
	PA_Constants at: #paFloat32 put: 1.
	PA_Constants at: #float32 put: 1.
	PA_Constants at: #paInt32 put: 2.
	PA_Constants at: #int32 put: 2.
	PA_Constants at: #paInt24 put: 4.
	PA_Constants at: #int24 put: 4.
	PA_Constants at: #paInt16 put: 8.
	PA_Constants at: #lin16Bit put: 8.
	PA_Constants at: #paInt8 put: 16.
	PA_Constants at: #int8 put: 16.! !

!Siren.PortAudioInterface class methodsFor: 'examples'!

example0
	"Demonstrate using the PortAudioInterface with the simple interface"
	"PortAudioInterface example0"

	| pa val |
	pa := PortAudioInterface new.
"Initialize PA"
	val := pa pa_initialize.
	Transcript cr; show: 'PA_init returned: ', val printString; cr.
"Get IO data"
		Transcript show: pa pa_num_in printString, ' in ', 
			pa pa_num_out printString, ' out ',
			pa pa_in_rate printString, ' Hz i ',
			pa pa_out_rate printString, ' Hz o '; cr.
	val := pa pa_terminate.
	Transcript show: 'PA_close returned: ', val printString; cr.!

example2
	"Demonstrate using the PortAudioInterface with the non-semaphore-signalling interface"
	"PortAudioInterface example2"

	| pa val bufFrames oChans |
	bufFrames := 1024.
	oChans := 2.
	pa := PortAudioInterface new.
"Initialize PA"
	val := pa pa_initialize.
	Transcript cr; show: 'PA_init returned: ', val printString; cr.
"Open PA"
	val := pa pa_open_p: 1 with: oChans	 	"device, I/O channels"
				with: (self const: #paInt16) 	"sample format"
				with: 44100 					"sample rate"
				with: bufFrames. 				"frames per buffer"
	Transcript show: 'PA_open returned: ', val printString; cr.
"START"
	1 wait.
	val := pa pa_start.
	Transcript cr; show: 'PA_start returned: ', val printString; cr.
"wait"
	1 wait.
"STOP, close, ..."
	val := pa pa_stop.
	Transcript show: 'PA_stop returned: ', val printString; cr.
	val := pa pa_close.
	Transcript show: 'PA_close returned: ', val printString; cr.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!


!Siren.PortAudioInterface methodsFor: 'types'!

Callback
	<C: typedef void (* Callback)(void)>!

CallbackFcn
	<C: typedef void (* CallbackFcn)(void)>!

OEoop
	<C: typedef void * OEoop>! !

!Siren.PortAudioInterface methodsFor: 'accessing'!

cbProcess

	^cbProcess!

cbProcess: aValue

	cbProcess := aValue!

ioSemaphore

	^ioSemaphore!

ioSemaphore: aValue

	ioSemaphore := aValue! !

!Siren.PortAudioInterface methodsFor: 'procedures'!

pa_close
	<C: int pa_close(void)>
	^self externalAccessFailedWith: _errorCode!

pa_dev_in: which
	<C: int pa_dev_in(unsigned int which)>
	^self externalAccessFailedWith: _errorCode!

pa_dev_out: which
	<C: int pa_dev_out(unsigned int which)>
	^self externalAccessFailedWith: _errorCode!

pa_dev_rate: which
	<C: int pa_dev_rate(unsigned int which)>
	^self externalAccessFailedWith: _errorCode!

pa_get_name: which
	<C: const char *  pa_get_name(unsigned int which)>
	^self externalAccessFailedWith: _errorCode!

pa_get_name: which with: resultString
	<C: int pa_get_name(unsigned int which, OEoop resultString)>
	^self externalAccessFailedWith: _errorCode!

pa_in_device
	<C: int pa_in_device(void)>
	^self externalAccessFailedWith: _errorCode!

pa_in_rate
	<C: int pa_in_rate(void)>
	^self externalAccessFailedWith: _errorCode!

pa_initialize
	<C: int pa_initialize(void)>
	^self externalAccessFailedWith: _errorCode!

pa_num_devices
	<C: int pa_num_devices(void)>
	^self externalAccessFailedWith: _errorCode!

pa_num_in
	<C: int pa_num_in(void)>
	^self externalAccessFailedWith: _errorCode!

pa_num_out
	<C: int pa_num_out(void)>
	^self externalAccessFailedWith: _errorCode!

pa_open_p: device with: out_ch with: format with: rate with: blockSize
	<C: int pa_open_p(int device, unsigned int out_ch, unsigned long format, unsigned int rate, unsigned int blockSize)>
	^self externalAccessFailedWith: _errorCode!

pa_open_s: device with: in_ch with: out_ch with: format with: rate with: blockSize with: cbBlock with: in_buffer with: out_buffer
	<C: int _threaded pa_open_s(int device, unsigned int in_ch, unsigned int out_ch, unsigned long format, unsigned int rate, unsigned int blockSize, CallbackFcn cbBlock, unsigned short * in_buffer, unsigned short * out_buffer)>
	^self externalAccessFailedWith: _errorCode!

pa_out_device
	<C: int pa_out_device(void)>
	^self externalAccessFailedWith: _errorCode!

pa_out_rate
	<C: int pa_out_rate(void)>
	^self externalAccessFailedWith: _errorCode!

pa_play: out_buffer with: numChannels with: numFrames
	<C: int pa_play(unsigned short * out_buffer, unsigned int numChannels, unsigned int numFrames)>
	^self externalAccessFailedWith: _errorCode!

pa_play: out_buffer with: numChannels with: numFrames with: swap
	<C: int pa_play(unsigned short * out_buffer, unsigned int numChannels, unsigned int numFrames, unsigned int swap)>
	^self externalAccessFailedWith: _errorCode!

pa_start
	<C: int _threaded pa_start(void)>
	^self externalAccessFailedWith: _errorCode!

pa_stop
	<C: int pa_stop(void)>
	^self externalAccessFailedWith: _errorCode!

pa_terminate
	<C: int pa_terminate(void)>
	^self externalAccessFailedWith: _errorCode! !

#{Siren.LibSndFileInterface} initialize!

#{Siren.PortAudioInterface} initialize!
