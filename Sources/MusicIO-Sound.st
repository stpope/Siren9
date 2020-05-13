

Smalltalk.Siren defineClass: #SoundEvent
	superclass: #{Siren.ActionEvent}
	indexedType: #objects
	private: false
	instanceVariableNames: 'sound '
	classInstanceVariableNames: ''
	imports: ''
	category: 'MusicIO-Sound'!

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!


!Siren.SoundEvent class methodsFor: 'instance creation'!

sound: theSnd
	"Create and answer a new sound event for the given sound"

	| inst |
	inst := self new initialize.
	inst sound: theSnd.
	^inst! !

!Siren.SoundEvent class methodsFor: 'examples'!

example
	"Create and play an event list that plays the same file a few times."
	"SoundEvent example"

	| snd list |
	snd := Sound fromFile: 'wet.snd'.
	list := EventList newNamed: 'SndTest'.
	0 to: 5 do:
		[ :start |
		list add: (SoundEvent sound: snd) at: start].
	list play!

exampleLoops
	"Create and play an event list that loops 2 samples, with one of the loops starting with a rest."
	"SoundEvent exampleLoops"

	| list1 drum bass list2 |
	drum := Sound fromFile: 'JAZZ02.AIF'.
	list1 := EventList newNamed: 'Drums'.
	list1 add: (SoundEvent sound: drum) at: 0.
	list1 loop.

	bass := Sound fromFile: 'JAZZ01.AIF'.
	list2 := EventList newNamed: 'Bass'.
	list2 add: (DurationEvent new duration: 2.99 sec).	"rest"
	list2 add: (SoundEvent sound: bass).
	list2 loop.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!


!Siren.SoundEvent methodsFor: 'accessing'!

sound
	^sound!

sound: aSnd
	sound := aSnd.
	self duration: aSnd duration.
	self action: [sound play]! !



Smalltalk.Siren defineClass: #SoundFile
	superclass: #{Siren.AbstractEvent}
	indexedType: #objects
	private: false
	instanceVariableNames: 'name mode fileFormat sampleFormat rate channels size index position sound '
	classInstanceVariableNames: ''
	imports: ''
	category: 'MusicIO-Sound'!

Siren.SoundFile defineSharedVariable: #SampleFormats
	private: false
	constant: false
	category: 'As yet unclassified'
	initializer: nil!

Siren.SoundFile defineSharedVariable: #FileFormats
	private: false
	constant: false
	category: 'As yet unclassified'
	initializer: nil!

Siren.SoundFile defineSharedVariable: #Interface
	private: false
	constant: false
	category: 'As yet unclassified'
	initializer: nil!

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!


!Siren.SoundFile class methodsFor: 'class initialization'!

initialize
	"Set up the file format and sample format dictionaries to interface with libsndfile."
	"SoundFile initialize"

	LibSndFileInterface initialize.
	FileFormats := (((LibSndFileInterface const: #LSF_FORMAT_WAV) -> #riff),
		((LibSndFileInterface const: #LSF_FORMAT_AIFF) -> #aiff),
		((LibSndFileInterface const: #LSF_FORMAT_AU) -> #au),
		((LibSndFileInterface const: #LSF_FORMAT_IRCAM) -> #bicsf),
		((LibSndFileInterface const: #LSF_FORMAT_RAW) -> #raw)).
	SampleFormats := (((LibSndFileInterface const: #LSF_FORMAT_PCM_S8) -> #lin8bit),
		((LibSndFileInterface const: #LSF_FORMAT_PCM_16) -> #lin16Bit),
		((LibSndFileInterface const: #LSF_FORMAT_PCM_24) -> #lin24Bit),
		((LibSndFileInterface const: #LSF_FORMAT_PCM_32) -> #lin32Bit),
		((LibSndFileInterface const: #LSF_FORMAT_FLOAT) -> #float32),
		((LibSndFileInterface const: #LSF_FORMAT_DOUBLE) -> #float64),
		((LibSndFileInterface const: #LSF_FORMAT_ULAW) -> #mulaw8)
	).! !

!Siren.SoundFile class methodsFor: 'instance creation'!

named: nameString
	"Open the given file (EBICSF, SPARC, or NeXT soundfile format)"
	"SoundFile named: 'b.snd'"

	| me fullName |
	me := self new initialize.
	fullName := SirenUtility findFile: nameString.
	fullName isNil
		ifTrue: [me name: nameString]
		ifFalse: [me name: fullName].
	^me!

openFileNamed: nameString
	"Open the given file (EBICSF, SPARC, AIFF, or NeXT soundfile format)"
	"SoundFile openFileNamed: 'b.snd'"

	| me |
	me := self new initialize.
	me name: (SirenUtility findFile: nameString).
	me openForReading.
	^me!

readFileNamed: nameString
	"Open the given file (EBICSF, SPARC, or NeXT soundfile format)"
	"SoundFile readFileNamed: 'b.snd'"
	"Sound fromFile: 'kombination.snd'"

	| theName me |
	theName := SirenUtility findFile: nameString.
	theName ifNil: [^nil].
	theName isEmpty ifTrue: [^nil].
	me := self new initialize.
	me name: theName.
	me openForReading.
	(me sizeInSamples > 1000000) 
		ifTrue: [(Dialog confirm: 'SoundFile has ' , me sizeInSamples printString, 
					' samples; Load it anyway?')
			ifFalse: [^me]].
	[me readSamples]
		on: Error
		do: [ :ex | "ignore" ].
	^me!

readFileNamed: nameString  answer: theClass
	"Open the given file (EBICSF, SPARC, or NeXT soundfile format)"
	"SoundFile readFileNamed: 'moon.snd'"

	| me |
	me := self new initialize.
	me name: nameString.
	me openForReading.
	(me sizeInSamples > 1000000) 
		ifTrue: [(Dialog confirm: 'SoundFile "', nameString, '" has ' , 
				me samples printString, ' samples.
Load it anyway?')
			ifFalse: [^me]].
	me readSamples: theClass.
	me close.
	^me!

releaseFileIndex: index
	"Free the given sound file index"

	Interface lsf_close: index! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!


Siren.SoundFile comment:
'Instances of SoundFile are used for reading and writing sound objects to/from files using the libSndFile API.
They handle formatting, headers and I/O.

Instance variables:
	sound		<SampledSound> the sound''s samples
	rate		<Number> the sound''s sampling rate
	channels	<Number> the number of channels
	fileName	<String> the file''s name
	file		<ExternalStream> the file''s stream
	position	<Number> the current position
	headerSize	<Number> the size of the soundfile header
	properties	<Dictionary> the property list dictionary of the receiver
	format		<Symbol> the format--currently only #linear16Bit is handled
	size		<Number> the size in samples
'!

!Siren.SoundFile methodsFor: 'read/write'!

readSamples
	"Read samples from the file into the sample buffer."

	| data |
	index ifNil: [self error: 'Cannot operate on unopened file'].
	(position = 0) ifFalse: 
		[Interface lsf_seek: index with: 0 with: (LibSndFileInterface const: #SEEK_SET)].
	(sampleFormat == #lin16Bit)
		ifFalse: [self error: 'Sound file format ', sampleFormat, ' not imlpemented...'].
	sound isNil 
		ifTrue: [data := (WordArray new: size * channels) copyToHeapAsSigned: #malloc:.
				data beGarbageCollectable]
		ifFalse: [sound samples isPointer
			ifTrue: [data := sound samples]
			ifFalse: [data := sound samples copyToHeapAsSigned: #malloc:.
					data beGarbageCollectable]].
	Interface lsf_read_Isamples: index with: data with: (size * channels).
	sound ifNil:
		[sound := SampledSound named: name size: size rate: rate channels: channels 
						format: sampleFormat data: data].
	sound samplesInMemory: channels * size.
	sound at: #fileIndex put: index.!

readSamples: sndClass 
	"Read samples from the file into the sample buffer."

	| data |
	index ifNil: [self error: 'Cannot operate on unopened file'].
	position = 0 ifFalse: [Interface lsf_seek: index with: 0
						with: (LibSndFileInterface const: #SEEK_SET)].
	sampleFormat == #lin16Bit ifFalse: [self error: 'other file formats not imlpemented...'].
	sound isNil
		ifTrue: 
			[data := (WordArray new: size * channels) copyToHeapAsSigned: #malloc:.
			data beGarbageCollectable]
		ifFalse: [sound samples isPointer
				ifTrue: [data := sound samples]
				ifFalse: [data := sound samples copyToHeapAsSigned: #malloc:.
					data beGarbageCollectable]].
	Interface lsf_read_Isamples: index with: data with: size * channels.
	sound ifNil: [sound := sndClass named: name size: size rate: rate 
				channels: channels format: sampleFormat data: data].
	sound samplesInMemory: channels * size!

saveSound: snd
	"Write samples from the given sound to the receiver file."
	"(SampledSound sweepDur: 5.0 rate: 44100 from: 50 to: 1000 chans: 1) 
				scaleBy: 0.1; storeOnFileNamed: 'sweep.aiff'"

	| type which data howMany |
	(snd format == #lin16Bit)
		ifFalse: [self error: 'other file formats not imlpemented...'].
	('*.aiff' match: name)
		ifTrue: [type := LibSndFileInterface const: #LSF_FORMAT_AIFF].
	('*.wav' match: name)
		ifTrue: [type := LibSndFileInterface const: #LSF_FORMAT_WAV].
	('*.snd' match: name)
		ifTrue: [type := LibSndFileInterface const: #LSF_FORMAT_AU].
	('*.sf' match: name)
		ifTrue: [type := LibSndFileInterface const: #LSF_FORMAT_IRCAM].
	type ifNil: [self error: 'Can''t determine sound file format.'].
	data := snd data gcCopyToHeap.
	which := Interface lsf_create: name 
				with: (LibSndFileInterface const: #LSFM_WRITE) 
				with: (type bitOr: (LibSndFileInterface const: #LSF_FORMAT_PCM_16))
				with: snd rate with: snd channels.
	howMany := Interface lsf_write_Isamples: which with: data with: (snd size * snd channels).
	Transcript show: 'Wrote ', howMany printString, ' samples to sound file ', name; cr.
	Interface lsf_close: which.! !

!Siren.SoundFile methodsFor: 'accessing'!

channels
	"Answer the instance variable 'channels'."

	^channels!

channels: theChannels
	"Accept the argument, 'theChannels', as the new instance variable 'channels'."

	channels := theChannels.!

fileFormat

	^fileFormat!

fileFormat: aValue

	fileFormat := aValue!

format

	^fileFormat!

mode: theMode
	"Set the receiver's mode to #read or #write"

	mode := theMode!

name
	"Answer the instance variable 'name'."

	^name!

name: theFileName
	"Accept the argument, 'theFileName', as the new instance variable 'name'."

	name := theFileName.!

rate
	"Return the instance variable 'rate'."

	^ rate!

rate: aRate
	"Set the instance variable 'rate'."

	rate := aRate!

sampleFormat

	^sampleFormat!

sampleFormat: aValue

	sampleFormat := aValue!

samples
	"Return the instance variable 'samples'."

	^sound samples!

size
	"Answer the number of sample frames in the file."

	^size!

size: aNumber
	"Set the number of sample frames in the file."

	^size := aNumber!

sizeInSamples
	"Answer the number of sample frames in the file."

	^size * channels!

sound
	"Answer the instance variable 'sound'."

	^sound!

sound: theSound
	"Accept the argument, 'theSound', as the new instance variable 'sound'."

	sound := theSound! !

!Siren.SoundFile methodsFor: 'printing'!

printOn: aStream 
	"Format and print the receiver on the argument."

	aStream nextPutAll: self class name, 
		' named ', self name printString, 
		' rate: ', self rate printString,
		' channels: ', self channels printString,
		' size: ', size printString; cr.! !

!Siren.SoundFile methodsFor: 'initialize-release'!

close
	"Close the receiver's file."

	index ifNil: [^self].
	Interface lsf_close: index.!

initialize
	"Set up the instance variables of a default sound file."

	self propCheck.
	Interface ifNil: [Interface := LibSndFileInterface new].
	index := nil.
	position := 0.!

open
	"Open the named file and read the header"

	self openForReading.!

openForReading
	"Open the named file and read the header"

	| compFormat |
	mode := #read.
	index := Interface lsf_open: name with: (LibSndFileInterface const: #LSFM_READ).
	(index < 0) ifTrue: [^nil "self error: 'Cannot open soundfile'"].
	compFormat := Interface lsf_get_format: index.
	fileFormat := FileFormats at: (compFormat bitAnd: 16rFFF000)
					ifAbsent: [#LSF_FORMAT_UNKNOWN].
	sampleFormat := SampleFormats at: (compFormat bitAnd: 16r1F)
					ifAbsent: [#LSF_FORMAT_UNKNOWN].
	rate := Interface lsf_get_rate: index.
	channels := Interface lsf_get_channels: index.
	size := Interface lsf_get_frames: index.! !



Smalltalk.Siren defineClass: #SoundPort
	superclass: #{Siren.PortModel}
	indexedType: #none
	private: false
	instanceVariableNames: ''
	classInstanceVariableNames: ''
	imports: ''
	category: 'MusicIO-Sound'!

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!


!Siren.SoundPort class methodsFor: 'class initialization'!

initializeData
	"Set up the defaults for the class constants."
	"PortModel initialize"

	super initializeData.
	useSingleton := true.
	mutex := Semaphore forMutualExclusion.
"defaults: stereo out, no in"
	out := 2.
	in := 0.
	rate := 44100.
	blockSize := 1024.! !

!Siren.SoundPort class methodsFor: 'instance creation'!

concreteClass
	"Answer the appropriate subclass."

	^PortAudioPort!

default
	"Answer a default instance of the appropriate subclass."
	"SoundPort concreteClass instanceCount"
	"SoundPort default"

	| count |
	count := self concreteClass instanceCount.
	(count > 0)
		ifTrue: [^self concreteClass someInstance].
	^self concreteClass basicNew initialize!

defaultOrNil
	"Answer the default instance of the appropriate subclass if it's set up."
	"SoundPort defaultOrNil"

	SoundPort concreteClass instanceCount = 0
		ifTrue: [^nil].
	^SoundPort concreteClass someInstance! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!


Siren.SoundPort comment:
'SoundPort instances are interfaces to real-time sound I/O streams.

Concrete subclasses add primitive interfaces to special devices such as audio ports or coprocessors.'!

!Siren.SoundPort methodsFor: 'initialize/release'!

initialize
	"Answer an initialized version of the receiver."

	^self!

release
	"Terminate and release the receiver."

	^self! !

!Siren.SoundPort methodsFor: 'play/record'!

play: aSound
	"Play the argument on the receiver over the DACs."

	self subclassResponsibility!

play: aSound from: start to: stop
	"Play the argument on the receiver over the DACs."

	self subclassResponsibility!

record: aSound
	"Record into the argument via the receiver."

	self subclassResponsibility! !

!Siren.SoundPort methodsFor: 'open/close'!

close
	"Close the receiver sound port"

	^self!

open
	"Open the receiver sound port"

	^self!

start
	"Start the receiver sound port"

	^self!

stop
	"Stop the receiver sound port"

	^self! !



Smalltalk.Siren defineClass: #PortAudioPort
	superclass: #{Siren.SoundPort}
	indexedType: #none
	private: false
	instanceVariableNames: 'rate format outChannels interface isOpen isRunning bufferSize '
	classInstanceVariableNames: ''
	imports: ''
	category: 'MusicIO-Sound'!

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!


!Siren.PortAudioPort class methodsFor: 'initialize/release'!

stop
	"Stop and close the running instance"
	"PortAudioPort stop"
	"PortAudioPort instanceCount"
	"PortAudioPort someInstance"

	| inst |
	(self instanceCount > 0)
		ifTrue: [inst := self someInstance]
		ifFalse: [^self].
	inst stop.
	inst close.
	inst terminate.
	inst release.
	ObjectMemory garbageCollect! !

!Siren.PortAudioPort class methodsFor: 'examples'!

playSweep
	"Play a swept sine wave using the simple output-only port audio port."
	"PortAudioPort playSweep"
	"SoundPort initialize"

	| port snd |
	port := self new.
	port open.
	1 wait.
	snd := SampledSound sweepDur: 2.0 rate: 44100 from: 60 to: 800 chans: 2.
	snd := snd scaleBy: 0.1.
	port play: snd.
	(snd duration value + 1) wait.
	port close.
	port terminate.!

playSweepLong
	"Play a *long* swept sine wave using the simple output-only port audio port."
	"PortAudioPort playSweepLong"
	"SoundPort initialize"

	| port snd |
	port := self new initialize.
	port open.
	1 wait.
	snd := SampledSound sweepDur: 20.0 rate: 44100 from: 50 to: 500 chans: 2.
	snd := snd scaleBy: 0.1.
	port play: snd.
	(snd duration value + 1) wait.
	port close.
	port terminate.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!


Siren.PortAudioPort comment:
'A PortAudioPort is an interface to the external PortAudio library. It is simple, supports playback only, and does not use callbacks from C into Smalltalk. For a fancier version that supports input as well , see SmartAudioPort.

Instance Variables:
	device <Integer> the PortAudio device flag for my device
	rate <Integer>  the sample rate in Hz
	format <Symbol>  sample format as in #lin16Bit
	outChannels <Integer>  # of out channels
	interface <Siren.PortAudioInterface>  my low-level interface
	isOpen	<Boolean>  am I open?
	isRunning <Boolean>  am I running?
	bufferSize <Integer>  size of the preallocated IO buffers

Shared Variables:
	Devices <Array of: Integer>  my total # of I/O channels and default I/O sample rates
'!

!Siren.PortAudioPort methodsFor: 'play/record'!

play: aSound
	"Play the argument on the receiver over the DACs."
	"PortAudioPort playSweep"

	self play: aSound from: 1 to: aSound size!

play: aSound from: start to: stop
	"Play the argument on the receiver over the DACs."
	"SoundPort default play: (SampledSound sweepDur: 30.0 rate: 44100 from: 20 to: 500 chans: 1)
			from: 300000 to: 400000"

	| samps doGC swap |
	self open.
	self start.
	UninterpretedBytes isBigEndian
		ifTrue: [swap := 1]
		ifFalse: [swap := 0].
"make the pointer shareable"
	samps := aSound data.
	samps isCPointer ifFalse: 
		[doGC := true. 
		samps := samps copyToHeap.
		swap := 1].
	self critical: [interface pa_play: samps + (start * aSound channels) 
					with: aSound channels 
					with: (stop - start) 
					with: swap].
"fork a process to mark the shared buffer as garbage after we're done."
	doGC ifNotNil: [[(aSound duration value + 0.5) wait.
		samps beGarbageCollectable] fork]! !

!Siren.PortAudioPort methodsFor: 'accessing'!

format

	^format!

format: aValue

	format := aValue!

outChannels

	^outChannels!

outChannels: aValue

	outChannels := aValue!

rate

	^rate!

rate: aValue

	rate := aValue! !

!Siren.PortAudioPort methodsFor: 'initialize/release'!

initialize
	"Answer an initialized version of the receiver."
	"PortAudioPort playSweep"
	"SoundPort initialize"
	"PortAudioInterface unloadLibraries"
	"PortAudioPort devices" "PortAudioPort properties"

	| val |
	isOpen := false.
	isRunning := false.
"Set the default settings"
	rate := SoundPort sampleRate.
	format := #lin16Bit.
	outChannels := 2.				"default = stereo"
	bufferSize := self class blockSize.
"Create the external interface"
	interface := PortAudioInterface new.
"Initialize PA"
	val := interface pa_initialize.
	(val = 0)
		ifFalse: [self error: 'PortAudio init returned: ', val printString].
"Get IO data - should I create device objects and load the port names?"
	device := interface pa_out_device.		"output by default"
	self class resetDevices.
	1 to: interface pa_num_devices do:
		[ :cnt | | nam |
"		nam := (String new: 32) gcCopyToHeap."
		nam := interface pa_get_name: cnt.
		self class devices add: (DeviceModel new name: nam copyCStringFromHeap asSymbol; 
						port: cnt; rate: (interface pa_dev_rate: cnt);
						in: (interface pa_dev_in: cnt); out: (interface pa_dev_out: cnt))].
	self class properties:  (Array with: interface pa_num_in with: interface pa_num_out 
					with: interface pa_in_rate with: interface pa_out_rate).
	(SirenUtility verbosity > 1)
		ifTrue: [Transcript cr; show: 'Sound Device Table'; crtab.
			self class devices do: [ :aDev | Transcript show: aDev port printString, ': ', aDev name, ' ',
					aDev in printString, ' in ', aDev out printString, ' out ', aDev rate printString, ' Hz']
				separatedBy: [Transcript crtab].
			Transcript cr.]! !

!Siren.PortAudioPort methodsFor: 'open/close'!

close
	"Close the receiver sound port"

	| val |
	isOpen ifFalse: [^self].
	self stop.
	val := interface pa_close.
	self critical: [interface pa_terminate].
	SirenUtility log: 'PortAudio close returned: ', val printString level: 1.
	isOpen := false.
	self class instance: nil!

open
	"Open the receiver sound port"

	| val |
	isOpen ifTrue: [^self].
	interface ifNil: [self initialize].
"Open the PortAudio interface."
	self critical: [val := interface pa_open_p: device with: outChannels 
				with: (PortAudioInterface const: format) 
				with: rate with: bufferSize].
"Report, set my status, and plug me in as the singleton"
	SirenUtility log: 'PortAudio open returned: ', val printString level: 1.
	isOpen := true.
	self class instance: self!

start
	"Start the receiver sound port"

	isRunning ifTrue: [^self].
	SirenUtility log: 'PortAudio running...' level: 1.
	self critical: [interface pa_start].
	isRunning := true.!

stop
	"Stop the receiver sound port"

	isRunning ifFalse: [^self].
	self critical: [interface pa_stop].
	SirenUtility log: 'PortAudio stopped...' level: 1.
	isRunning := false!

terminate
	"Shut down the receiver."

	isRunning ifTrue: [self stop].
	isOpen ifTrue: [self close].
"Terminate the external interface"
	self critical: [interface pa_terminate].
	interface := nil.
	SirenUtility log: 'PortAudio terminated...' level: 1.! !



Smalltalk.Siren defineClass: #SmartAudioPort
	superclass: #{Siren.PortAudioPort}
	indexedType: #none
	private: false
	instanceVariableNames: 'inChannels callbackBlock useProcess ioProcess ioSemaphore inClient outClients inBuffer outBuffer counter '
	classInstanceVariableNames: ''
	imports: ''
	category: 'MusicIO-Sound'!

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!


!Siren.SmartAudioPort class methodsFor: 'examples'!

testPlay
	"Test playing a sound through the call-back interface"
	"SmartAudioPort testPlay"
	"PortModel initialize"
	"SmartAudioPort instance"

	| port snd dur |
	dur := 4.						" play for 4 seconds"
	port := self new initialize.
	port open.
	snd := (SampledSound sawtoothDur: dur rate: 44100 freq: 10 chans: 1) scaleBy: 0.9.
"	snd := (SampledSound sweepDur: dur rate: 44100 from: 50 to: 500 chans: 2) scaleBy: 0.1.
"	port play: snd.
	(dur + 0.5) wait.
	port close.!

testRecord
	"SmartAudioPort testRecord"

	| port snd |
	port := self new initialize.
	port in: 2.
	port out: 0.
	port setInputDevice.
	port open.
	snd := SampledSound duration: 5.0 named: 'recorded' rate: 44100 channels: 2 format: #lin16Bit.
	port record: snd.
	6 wait.
	snd edit! !

!Siren.SmartAudioPort class methodsFor: 'instance creation'!

new
	"Answer a new instance, or the singleton"

	^useSingleton
		ifTrue:  [singleton ifNil: [singleton := self basicNew initialize]. singleton]
		ifFalse: [self basicNew initialize]! !

!Siren.SmartAudioPort class methodsFor: 'callbacks'!

callback
	"Forward the callback to an instance"

	singleton ifNotNil: [singleton callback]! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!


Siren.SmartAudioPort comment:
'SmartPortAudioPort is a more advanced IO port for PortAudio; it uses a Smalltalk process that sleeps on a semaphore that is signalled by the PortAudio callback. this allows one to synthesize sound interactively or to record into Siren sounds. The methods nextInBuffer and nextInBuffer are used to copy buffers or call synthesis clients.

Instance Variables:
	inChannels	 <Integer>  # of input channels
	ioSemaphore <Semaphore>  semaphore sent from the low-level driver
	inClient	 <Sound -> sample index>  the sound being recorded into
	outClients <OrderedCollection of (aSound -> Integer)>  my playing sounds and their sample indices
	ioProcess <Process>  my IO thread
	inBuffer <WordArray>  sample buffer handed to PortAudio
	outBuffer <WordArray>  sample buffer handed to PortAudio
'!

!Siren.SmartAudioPort methodsFor: 'accessing'!

inChannels

	^inChannels!

inChannels: aValue

	inChannels := aValue!

outClients

	^outClients!

setInputDevice
	"Set the port to use the default input device"

	self critical: [device := interface pa_out_device].		"output by default"! !

!Siren.SmartAudioPort methodsFor: 'play/record'!

callback
	"Handle a callback from PortAudio; this is sent an an external callback"

"	verbose ifTrue: [Transcript show: '.'].
"	useProcess
		ifTrue: [ioSemaphore signal]
		ifFalse: [self doIO].
	^nil!

doIO
	"Handle a callback from PortAudio; this is sent an an external callback through the class"

"	counter := counter + 1."
	inChannels > 0 ifTrue: [self nextInBuffer]. 
	outChannels > 0 ifTrue: [self nextOutBuffer]!

nextInBuffer
	"Get the next input buffer for the clients from the interface."

	| index snd |
	inClient ifNil: [^self].			"no input"
	snd := inClient key.
	index := inClient value.
	1 to: bufferSize do:			"loop copying sample to the destination sound"
		[ :count |
		snd sampleAt: (count + index) put: (inBuffer at: count)].
	inClient value: index + bufferSize!

nextOutBuffer
	"Get the next output buffer from the clients and sum it into my buffer for playing."

"Loop through the output clients asking them to contribute to the buffer."
	1 to: outClients size do:
		[ :count | | ass ind |
		ass := outClients at: count.					" aSound -> anIndex"
		ind := ass key nextBufferInto: outBuffer 
					frames: bufferSize channels: outChannels 
					format: format startingAt: ass value.
"They return their frame index or nil when done."
		ind isNil
			ifTrue: [Transcript show: 'Playing client ', count printString, ' terminated'; cr.
					outClients removeAtIndex: count]
			ifFalse: [ass value: ind]]!

play: aSound
	"Play the argument on the receiver over the DACs."

	outClients add: (aSound -> 0).
	self nextOutBuffer.					"prime the pump"
	self start: aSound duration asSec value.!

record: aSound
	"Record into the argument via the receiver."

	inClient :=  (aSound -> 0).
	self start: aSound duration asSec value.!

start: duration
	"Start the receiver's IO loop for the given duration."

	self open.
"Start up the IO process"
	useProcess
		ifTrue: [ioProcess priority: Processor userInterruptPriority.
			ioProcess resume].
"Set up for the external callback"
	CCallback classPool
		at: #ForeignCallbackPriority
		put: Processor userInterruptPriority - 1.
"Start PA thread"
	self start.
"Fork a process to shut it down"
		[duration wait.
		useProcess ifTrue: [ioProcess terminate].
		self stop] fork! !

!Siren.SmartAudioPort methodsFor: 'initialize/release'!

initialize
	"Answer an initialized version of the receiver."

	super initialize.
	useProcess := true.					"use a separate thread, or do the IO in the callback thread"
	inClient := nil.
	outClients := OrderedCollection new.
	counter := 0.
"Set the default settings"
	bufferSize := self class blockSize.
	inChannels := self class in.			"default = stereo input"
	outChannels := self class out.			"default = stereo input"
"Set up callback block for driver"
	callbackBlock := CCallback do: [SmartAudioPort callback] 
								ofType: interface CallbackFcn.
"Set up semaphore and read/write loop"
	useProcess
		ifTrue: [ioSemaphore := Semaphore new.
			ioProcess := [[ioSemaphore wait. 
				self doIO. 
				true] whileTrue] newProcess]! !

!Siren.SmartAudioPort methodsFor: 'open/close'!

close
	"Close the receiver sound port"

	super close.
	useProcess ifTrue: [ioProcess terminate].
"	Transcript show: counter printString, ' callbacks received'; cr."!

open
	"Open the receiver sound port"

	| val |
	isOpen ifTrue: [^self].
	interface ifNil: [self initialize].
"Allocate I/O buffers and put them in the heap."
	((outChannels > 0) and: [outBuffer isNil])
		ifTrue: [outBuffer := (UninterpretedBytes new: bufferSize * outChannels * 2) gcCopyToHeap].
	((inChannels > 0) and: [inBuffer isNil])
		ifTrue: [inBuffer := (UninterpretedBytes new: bufferSize * inChannels *2) gcCopyToHeap].
"Open the PortAudio interface so that it sends the out-board fnuction."
	self critical: [val := interface pa_open_s: device 
						with: inChannels 
						with: outChannels 
						with: (PortAudioInterface const: format) 
						with: rate 
						with: bufferSize 
						with: callbackBlock 				"the callback fnuction"
						with: inBuffer 
						with: outBuffer].
"Report, set my status, and plug me in as the singleton"
	SirenUtility log: 'SmartAudio open returned: ', val printString level: 1.
	isOpen := true.
	self class instance: self! !

#{Siren.SoundFile} initialize!
