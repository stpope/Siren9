

Smalltalk.Siren defineClass: #Sound
	superclass: #{Siren.Function}
	indexedType: #objects
	private: false
	instanceVariableNames: ''
	classInstanceVariableNames: ''
	imports: '
			private SoundConstants.*
			'
	category: 'Music-Sound'!

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!


!Siren.Sound class methodsFor: 'instance accessing'!

named: aName
	"Answer the sound by the given name, or nil."

	^SirenSession sounds at: aName asSymbol ifAbsent: [nil]!

named: aName put: aSound
	"Put the given sound in the shared dictionary under the given name."

	SirenSession sounds ifNil: [^nil].
	^SirenSession sounds at: aName asSymbol put: aSound! !

!Siren.Sound class methodsFor: 'utilities'!

fromFile: nameString
	"Open the given file (AIFF, IRCAM, NeXT, or SPARC soundfile format)"
	"Sound fromFile: 'kombination.snd'"

	| snd |
	[snd := (SoundFile readFileNamed: nameString).
	snd ifNotNil: [snd := snd sound]]
		on: Core.Error
		do: [ :ex |  "ignore " "self error: 'Cannot read sound file named ', nameString"].
	^snd!

playFile: theName
	"Play the sound file with the given name"

	SirenUtility playSoundFile: theName! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!


Siren.Sound comment:
'Instances of the subclasses of Sound are used to represent sound objects.
The abstract class Sound is vacuous.
Sounds use their Function and DurationEvent behaviors actively.
'!

!Siren.Sound methodsFor: 'cue accessing'!

addCueNamed: cName from: start to: stop
	"Add the given named cue region to the receiver's list."

	| list key |
	self cueList == nil
		ifTrue: [self cueList: OrderedCollection new].
	list := self cueList.
	key := cName asSymbol.
	1 to: list size do:
		[ :ind |
		((list at: ind) key == key)
			ifTrue: [^list at: ind put: (key -> (start to: stop))]].
	list add: (cName asSymbol -> (start to: stop)).!

cueList
	"Answer the receiver's 'cueList'."

	properties ifNil: [^nil].
	^properties at: #cueList ifAbsent: [nil]!

cueList: CollectionOfCues
	"Set the receiver's 'cueList' to be the given OrderedCollection of (#name -> (start to: stop)) cues."

	^properties at: #cueList put: CollectionOfCues!

cueNamed: cName
	"Answer a sound derived from the receiver using the samples between the named cue points."

	^self subclassResponsibility!

cueRegionNamed: cName
	"Answer a indices for the samples between the named cue points."

	| q |
	self cueList == nil
		ifTrue: [self error: 'There is no cue by the name ', 
				cName printString, ' in this sound.'].
	q := self cueList detect: [ :c | c key == cName] ifNone: [nil].
	q == nil
		ifTrue: [self error: 'There is no cue by the name ', 
				cName printString, ' in this sound.'].
	^q value! !

!Siren.Sound methodsFor: 'testing'!

isSound
	"Answer true."

	^true! !

!Siren.Sound methodsFor: 'initialize-release'!

finalize
	"Free the receiver's external data, if any"

	| fileNumber |
	fileNumber := self at: #fileIndex.
	fileNumber ifNotNil:
		[SoundFile releaseFileIndex: fileNumber]!

initialize
	"Set up a default sound."

	self propCheck.
	range := -1.0 to: 1.0! !



Smalltalk.Siren defineClass: #SampledSound
	superclass: #{Siren.Sound}
	indexedType: #objects
	private: false
	instanceVariableNames: 'name rate format channels samplesInMemory firstIndex '
	classInstanceVariableNames: ''
	imports: '
			private SoundConstants.*
			'
	category: 'Music-Sound'!

Siren.SampledSound defineSharedVariable: #MinIntSample
	private: false
	constant: false
	category: 'class constants'
	initializer: nil!

Siren.SampledSound defineSharedVariable: #MaxIntSample
	private: false
	constant: false
	category: 'class constants'
	initializer: nil!

Siren.SampledSound defineSharedVariable: #MagicNumbers
	private: false
	constant: false
	category: 'class constants'
	initializer: nil!

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!


!Siren.SampledSound class methodsFor: 'class constants'!

formatSymbol
	"Answer the symbolic code used for the format of the receiver's instances."

	^#lin16Bit!

maxSample
	"Answer the maximum value of the receiver class."

	^32767!

minSample
	"Answer the minimum value of the receiver class."

	^-32768! !

!Siren.SampledSound class methodsFor: 'examples'!

immediateInspect
	"Answer a sampled sound from immediate data; inspect it."
	"StoredSound immediateInspect"

	| t |
	 t := Array new: 64000. 
	 0 to: 255 do: 
		[ :i | 1 to: 250 do:
			[ :j | t at: ((i * 250) + j) 
			put: (j / 250 * 32000 - 16000) asInteger]].
	(SampledSound fromData: t named: 'ramp' 
			rate: 32000 channels: 1 format: #lin16Bit) inspect!

rmsViewExample
	"Read a sampled sound from the file, take the rms into 64 values, and edit that."
	"SampledSound rmsViewExample"

	| arr snd |
	arr := Array new: 128 withAll: 0.0.
	snd := SampledSound fileExample.
	snd sampleMaxFrom: 1 to: snd size into: arr.
	(Function from: arr) edit.!

sweepExample
	"Open a sound view on a swept sine wave."
	"SampledSound sweepExample"

	^self sweepDur: 2.0 rate: 44100 from: 20 to: 100 chans: 1!

sweepView
	"Open a sound view on a swept sine wave."
	"SampledSound sweepView"

	(SampledSound sweepDur: 2.0 rate: 44100 from: 20 to: 100 chans: 1) edit! !

!Siren.SampledSound class methodsFor: 'standard wave forms'!

constantOfDur: dur value: value rate: rate chans: chans
	"Answer a sound with a constant value."
	"SoundView openOn: (StoredSound constantOfDur: 1 value: 10000 rate: 16000 chans: 1)"

	| snd |
	snd := self duration: dur rate: rate channels: chans 
						format: self formatSymbol.
	1 to: (dur * rate * chans) truncated do: 
		[ :i | snd sampleAt: i put: value].
	^snd!

expSweepDur: dur rate: rate from: start to: stop chans: chans
	"Answer a SampledSound with a swept sine wave."
	"SoundView openOn: (SampledSound expSweepDur: 1.0 rate: 44100 from: 20 to: 2000 chans: 1)"
	"SoundView openOn: (SampledSound expSweepDur: 1.0 
			rate: 44100 from: 20 to: 2000 chans: 1)"

	| scale1 snd incr |
	snd := self duration: dur rate: rate channels: chans format: self formatSymbol.
	scale1 := start asFloat / rate * Float pi * 2.
	incr := (stop / start) ln / (rate * dur) + 1.0.
	chans = 1
		ifTrue: [1 to: (dur * rate) truncated do: 
			[ :i | snd intSampleAt: i put: ((i - 1 * scale1) sin * 32767) truncated.
				scale1 := scale1 * incr]]
		ifFalse: [(1 to: ((dur * rate) truncated - 1) by: 2) do: 
			[ :i | | val |
				val := ((i - 1 * scale1) sin * 32767) truncated.
				snd intSampleAt: i put: val.
				snd intSampleAt: ( i + 1) put: val.
				scale1 := scale1 * incr]].
	^snd!

impulseOfDur: dur width: width rate: rate chans: chans
	"Create a sound with an impulse of the given characteristics."
	"SoundView openOn: (StoredSound impulseOfDur: 1 width: 0.001 rate: 16000 chans: 1)"
	"(SoundFile named: 'impulse.snd') saveSound: 
			(StoredSound impulseOfDur: 1 width: 0.001 
			rate: 16000)"

	| snd pulseLen nsamps samps |
	nsamps := (rate * dur * chans) truncated.
	samps := Array new: nsamps.
	pulseLen := (width * rate * chans) truncated.
	1 to: pulseLen do: 
		[ :i | samps at: i put: 32766].
	pulseLen  to: nsamps do: 
		[ :i | samps at: i put: 0].
	snd := SampledSound fromData: samps 
			rate: rate channels: chans format: self formatSymbol.
	^snd!

linearSweepDur: dur rate: rate from: start to: stop chans: chans
	"Answer a StoredSound with a swept sine wave."
	"SoundView openOn: (StoredSound linearSweepDur: 1.0 rate: 8000 from: 20 to: 2000 chans: 1)"

	| scale snd incr |
	snd := self duration: dur rate: rate channels: chans format: self formatSymbol.
	scale := start asFloat / rate * Float pi * 2.
	incr := ((stop asFloat / rate * Float pi * 2) - scale) / (rate * dur).
	chans = 1
		ifTrue: [1 to: (dur * rate) truncated do: 
			[ :i | snd intSampleAt: i put: ((i - 1 * scale) sin * 32767) truncated.
				scale := scale + incr]]
		ifFalse: [(1 to: (dur * rate) truncated by: 2) do: 
			[ :i | snd intSampleAt: i put: ((i - 1 * scale) sin * 32767) truncated.
				snd intSampleAt: ( i + 1) put: ((i - 1 * scale) sin * 32767) truncated.
				scale := scale + incr]].
	^snd!

pulseTrainDur: dur rate: rate freq: freq width: width chans: chans
	"Answer a StoredSound with a pulse train."
	"SoundView openOn: (StoredSound pulseTrainDur: 1.0 rate: 22050 freq: 10 
				width: 0.001 chans: 1 zero: 0)"
	"(StoredSound pulseTrainDur: 5.0 rate: 16000 freq: 250 width: 0.001 chans: 1) storeOnFileNamed: 'snd/new/square2.snd'"

	^self pulseTrainDur: dur rate: rate freq: freq width: width chans: chans zero: 0!

pulseTrainDur: dur rate: rate freq: freq width: width chans: chans zero: zero
	"Answer a StoredSound with a pulse train."
	"SoundView openOn: (StoredSound pulseTrainDur: 1.0 rate: 22050 freq: 10 
				width: 0.001 chans: 1 zero: 0)"
	"(StoredSound pulseTrainDur: 5.0 rate: 16000 freq: 250 width: 0.001 chans: 1) storeOnFileNamed: 'snd/new/square2.snd'"

	| waveLen snd pSamps |
	snd := self duration: dur rate: rate channels: chans 
					format: self formatSymbol.
	waveLen := (rate / freq) truncated.
	pSamps := (rate * width) truncated.
	chans = 1
		ifTrue: [0 to: (dur * freq - 1) truncated do: 
			[ :i |1 to: pSamps do:
				[ :j | snd intSampleAt: ((i * waveLen + j) min: pSamps) put: 32767].
			pSamps + 1 to: waveLen do:
				[ :j | snd intSampleAt: (i * waveLen + j) put: zero]]]
		ifFalse: [(0 to: (dur * freq - 1) truncated by: 2) do: 
			[ :i |1 to: (pSamps * 2) do:
				[ :j | snd intSampleAt: (i * waveLen + j) put: 32767].
			(pSamps * 2 + 1) to: (waveLen * 2) do:
				[ :j | snd intSampleAt: (i * waveLen + j) put: zero]]].
	^snd!

rampDur: dur rate: rate chans: chans
	"Answer a StoredSound with a single ramp of samples."
	"SoundView openOn: (StoredSound rampDur: 2.0 rate: 16000 chans: 1)"

	| incr snd |
	snd := self duration: dur rate: rate channels: chans format: self formatSymbol.
	incr :=  65536.0 / (rate * dur) asFloat.
	snd size: (dur * rate * chans) truncated.
	chans = 1
		ifTrue: [1 to: snd size do: 
			[ :i | snd intSampleAt: i put: (-32768.0 + (i - 1 * incr)) truncated]]
	ifFalse: [(1 to: snd size by: 2) do: 
			[ :i | snd intSampleAt: i put: (-32768.0 + (i - 1 * incr)) truncated.
				snd intSampleAt: (i + 1) put: (-32768.0 + (i - 1 * incr)) truncated]].
	^snd!

sawtooth
	"Answer a StoredSound with raw sawtooth samples."
	"SampledSound sawtooth"
	"SoundView openOn: SampledSound sawtooth"

	^self sawtoothDur: 1.0 rate: 44100 freq: 50 chans: 1!

sawtoothDur: dur rate: rate freq: freq chans: chans
	"Answer a StoredSound with raw sawtooth samples."
	"StoredSound sawtooth"
	"SoundView openOn: (SampledSound sawtoothDur: 1.0 rate: 22050 freq: 100 chans: 1)"

	| waveLen incr snd index |
	snd := self duration: dur rate: rate channels: chans format: self formatSymbol.
	waveLen := (rate / freq) asFloat.
	incr :=  65536.0 / waveLen.
	chans = 1
		ifTrue: [1 to: (dur * rate) do: 
			[ :i | 
			index := ((i \\ waveLen) asFloat) max: 1.0.
			snd intSampleAt: i put: (-32768.0 + (index - 1.0 * incr))]]
		ifFalse: [(1 to: (dur * rate) truncated by: 2) do: 
			[ :i |
			index := ((i \\ waveLen) asFloat) max: 1.0.
			snd intSampleAt: i put: (-32768.0 + (index - 1.0 * incr)).
			snd intSampleAt: (i + 1) put: (-32768.0 + (index - 1.0 * incr))]].
	^snd!

sineDur: dur rate: rate freq: freq chans: chans
	"Answer a StoredSound with a pulse train."
	"SoundView openOn: (StoredSound sineDur: 0.5 rate: 22050 freq: 200 chans: 1)"
	"(StoredSound sineDur: 5 rate: 16000 freq: 800 chans: 1) storeOnFileNamed: 'snd/new/sine.snd'"

	| scale snd |
	snd := self duration: dur rate: rate channels: chans format: self formatSymbol.
	scale := freq / rate * Float pi * 2.
	chans = 1
		ifTrue: [1 to: (dur * rate) truncated do: 
			[ :i | snd intSampleAt: i put: ((i - 1 * scale) sin * 32767) truncated]]
		ifFalse: [(1 to: (dur * rate) truncated by: 2) do: 
			[ :i | snd intSampleAt: i put: ((i - 1 * scale) sin * 32767) truncated.
				snd intSampleAt: ( i + 1) put: ((i - 1 * scale) sin * 32767) truncated]].
	^snd!

squareDur: dur rate: rate freq: freq chans: chans
	"Answer a StoredSound with a square wave."
	"SoundView openOn: (StoredSound squareDur: 1.0 rate: 1000 freq: 20 chans: 1)"

	^self pulseTrainDur: dur rate: rate freq: freq width: (0.5 / freq) chans: chans zero: -32767!

sweepDur: dur rate: rate from: start to: stop chans: chans
	"Answer a StoredSound with a swept sine wave."
	"SoundView openOn: (SampledSound sweepDur: 0.5 rate: 8000 from: 20 to: 500 chans: 1)"
	"SoundView openOn: (FloatSound sweepDur: 0.5 rate: 8000 from: 20 to: 500 chans: 1)"
	"(SampledSound sweepDur: 2.0 rate: 44100 from: 50 to: 500 chans: 1) 
				storeOnFileNamed: 'snd/new/sweep.snd'"

	^self expSweepDur: dur rate: rate from: start to: stop chans: chans! !

!Siren.SampledSound class methodsFor: 'instance creation'!

default
	"Answer the default empty sound."
	"StoredSound default"

	^self duration: 0.5 rate: 44100 channels: 1!

duration: aDur named: nameString rate: aRate channels: aChannels format: aFormat
	"Answer a new 16-bit linear sound with the given properties."

	^self named: nameString size: (aDur * aRate) truncated rate: aRate 
				channels: aChannels format: aFormat!

duration: aDur rate: aRate channels: aChannels
	"Answer a new sound with the given properties."

	^self named: nil size: (aDur * aRate) truncated rate: aRate 
				channels: aChannels format: self formatSymbol!

duration: aDur rate: aRate channels: aChannels format: aFormat
	"Answer a new sound with the given properties."

	^self named: nil size: (aDur * aRate) truncated rate: aRate 
				channels: aChannels format: aFormat!

fromData: anArray named: nameString rate: aRate channels: aChannels format: aFormat
	"Answer a new sound from the given data."
	"Example: 
		| t |
		 t := Array new: 65536. 
		 0 to: 255 do: 
			[ :i | 1 to: 256 do:
				[ :j | t at: ((i * 256) + j) put: (j / 256 * 32000 - 16000) asInteger]].
		^StoredSound fromData: t named: 'ramp' 
				rate: 16000 channels: 1 format: #lin16Bit"

	| sound |
	sound := self named: nameString size: (anArray size / aChannels) truncated
				rate: aRate channels: aChannels format: aFormat.
	1 to: anArray size do:
		[ :i | sound sampleAt: i  put: (anArray at: i)].
	^sound!

fromData: anArray rate: aRate channels: aChannels format: aFormat
	"Answer a new 16-bit linear sound from the given data."
	"StoredSound immediateInspect"

	^self fromData: anArray named: nil rate: aRate channels: aChannels format: aFormat!

fromDblData: anArray rate: aRate channels: aChannels size: siz
	"Answer a new sound from the given data."

	| sound scale |
	sound := self size: (siz * aChannels) truncated rate: aRate channels: aChannels format: #lin16Bit.
	scale := self maxSample.
	1 to: siz do:
		[ :i | sound sampleAt: i  put: ((anArray valueAt: (i asFloat / aRate)) * scale) truncated].
	^sound!

headerFromFile: nameString
	"Open the given file (EBICSF, NeXT, or SPARC soundfile format)"
	"StoredSound headerFromFile: 'snd/new/orchestra.snd'"

	"FileDirectory on: (FileDirectory dirPathFor: nameString) entries"

	| file sound size |
	file := SoundFile openFileNamed: (SirenUtility findFile: nameString).
	file == nil ifTrue: [^nil].
"	ver := nameString betweenPeriodsIfEmpty: '1.0.0'."
	size := file size.
	sound := self named: nameString size: size rate: file rate 
				channels: file channels format: file format.
	sound duration: (Duration value: (size / sound channels / sound rate) asFloat).
"	ver isEmpty
		ifTrue: [sound version: '1a00']
		ifFalse: [sound version: ver].
"	file properties == nil
		ifFalse: [file properties associationsDo: 
			[ :ass | sound at: ass key put: ass value]].
	file close.
	^sound!

named: aName size: aSize format: formatSymbol
	"Answer a new Sound with the given name and storage size."

	| sound |
	sound := self size: aSize format: formatSymbol channels: 1.
	sound name: aName.
	^sound!

named: nameString size: size rate: rate channels: chans format: formatSymbol
	"Answer a new Sound with the given storage size (in sample frames), etc."

	| sound  nam |
	(((#lin16Bit -> [sound := SampledSound new initialize])),
	(#float32Bit -> [sound := FloatSound new initialize]))
		case: formatSymbol
		otherwise: [sound := SampledSound new initialize
				"self error: 'Unknown sound format.'"].
	sound channels: chans.
	sound rate: rate.
	sound format: formatSymbol.
	sound size: size.
	sound allocateData.
	((nameString == nil) or: [nameString isEmpty])
		ifFalse: [nam :=  nameString asFilename tail.
			sound name: nam.
			sound folder: nameString asFilename head.
			self named: nam put: sound].
	^sound!

named: nameString size: size rate: rate channels: chans format: formatSymbol data: data
	"Answer a new Sound with the given storage size (in sample frames), etc."

	| sound nam |
	((#lin16Bit -> [sound := self new initialize.
			sound samples: data]),
	(#float32Bit -> [sound := FloatSound new initialize.
			sound samples: data]))
		case: formatSymbol
		otherwise: [self error: 'Unknown sound format.'].
	sound channels: chans.
	sound rate: rate.
	sound format: formatSymbol.
	sound size: size.
	nameString == nil
		ifFalse: [nam :=  nameString asFilename tail.
			sound name: nam.
			sound folder: nameString asFilename head.
			self named: nam put: sound].
	^sound!

size: size format: formatSymbol channels: chans
	"Answer a new Sound with the given storage size, etc."

	^self named: nil size: size rate: (SoundPort default class rate) 
				channels: chans format: formatSymbol!

size: size rate: aRate channels: chans
	"Answer a new Sound with the given storage size, etc."

	^self named: nil size: size rate: aRate channels: chans format: self formatSymbol!

size: size rate: rate channels: chans format: formatSymbol
	"Answer a new Sound with the given storage size, etc."

	^self named: nil size: size rate: rate channels: chans format: formatSymbol!

size: size rate: rate format: formatSymbol channels: chans
	"Answer a new Sound with the given storage size, etc."

	^self named: nil size: size rate: rate channels: chans format: formatSymbol! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!


Siren.SampledSound comment:
'Instances of SampledSound represent digitally-sampled sound objects.  Their "samples" are stored in the "data" instance variable inherited from Function. They can be read/written to/from files (using SoundFile objects), displayed (in SoundViews) and played (via SoundPorts).

The class SampledSound is concrete and assumes 16-bit linear encoding of samples; there are subclasses for floating-point and 8-bit Mu-law sample types. There are useful class methods for creating a number of standard sounds such as silence, impulses, swept sine waves, etc. Note that SampledSound uses the ''range'' instance variable inherited from Function as its (integer) size.

Instance variables:
	name <String> the file name or object ID
	rate <Number> the sample rate
	format <Symbol> the sample format, e.g., #lin16Bit
	channels <Integer> the # of channels
	samplesInMemory	<Integer> The number of samples held in memory (may be smaller than 
			size for very large sounds)
	firstIndex	<Integer> The sample index of the start of the in-memory samples  (may be non-zero 
			for very large "paged" sounds)

Other properties, such as the sound''s (optional) file name, its sample rate, or the number of channels, are stored in the property list dictionary that is inherited by virtue of being an event subclass.

KNOWN BUGS:

Note that not all of this class is finished--there are methods that call non-existent user primitives and have no Smalltalk implementations (like the heavy DSP).

'!

!Siren.SampledSound methodsFor: 'envelopes'!

average
	"Answer the average sample value of the receiver (normally the DC offset)."

	| value min max samp |
	min := max := self sampleAt: 1.
	value := 0.
	1 to: self size do:
		[ :i |
		samp := self sampleAt: i.
		value := value + samp.
		(samp > max) ifTrue: [max := samp].
		(samp < min) ifTrue: [min := samp]].
	self domain: (min to: max).
	value := (value / self size) asFloat.
	self at: #average put: value.
	^value!

computeEnvelope: type
	"Compute a sample envelope for the receiver with 128 points per second."

	| eSize env fcn |
	self size = 0 ifTrue: [^self].
	Cursor execute showWhile:
		[eSize := (self duration value truncated max: 1) * 128.
"		Transcript show: 'Creating envelope of size: ', eSize printString; cr."
		env := (Array new: eSize).
		type == #peak
			ifTrue: [self peaksFrom: 1 to: self size into: env]
			ifFalse: [self rmsFrom: 1 to: self size into: env]].
	fcn := Function from: env.
	self envelope: fcn.
	self hasFile
		ifTrue: [Cursor write showWhile: [self writeEnvelope: type]].!

computePeakEnvelope
	"Compute a windowed peak sample envelope for the receiver with 1024 points per 4 seconds."

	self computeEnvelope: #peak!

computeRMSEnvelope
	"Compute a windowed root-mean-square sample envelope for the receiver."

	self computeEnvelope: #RMS!

edit
	"Edit the receiver."

	SoundView openOn: self!

max
	"Answer the maximum value of the samples."

	| max t |
	max := 0.
	1 to: self size do:
		[ :i | 
		t := self sampleAt: i.
		(t abs > max) ifTrue: [max := t abs]].
	^max!

offsetBy: aFactor
	"Answer a copy of the receiver offset by the given factor."

	^self offsetFrom: 1 to: self size by: aFactor!

offsetFrom: aStart to: aStop by: anOffset
	"Answer a copy of the receiver offset by the given factor."

	| newSound |
	newSound := self copyAllButSamples.
	1 to: self size do:
		[ :i |
		newSound sampleAt: i put: ((self sampleAt: i) + anOffset)].
	^newSound!

peakEnvelope
	"Answer the receiver's peak-detected envelope, or compute a new one."

	| env |
	env := self envelope.
	(env ~~ nil and: [env size > 0])
		ifTrue: [^env].
	(self readEnvelope: #peak)
		ifFalse: [self computePeakEnvelope].
	^self envelope!

peaksFrom: aStart to: aStop into: anArray
	"Place a version of the root-mean-square energy of the receiver in the argument array."
	
"	| arr snd |
	arr := Array new: 1024.
	snd := 'Nomad:Squeak:Siren:sounds:kombination.1.aiff' asSoundFile.
	TimeProfileBrowser onBlock: [10 timesRepeat: 
		[snd rmsFrom: 1 to: snd size into: arr]].
	(Function from: arr) edit."

"	<primitive: 17082>
"
	| aSize factor max maxPos peak sample |
	aSize := anArray size.
	aSize > self size
		ifTrue: [^self error: 'Cannot take and rms into a larger array...'].
	factor := ((aStop - aStart) asFloat / (aSize)).
	max := 0.
	aStart = 0
		ifTrue: [0 to: aSize - 1 do:
				[ :i | 
				peak := 0.
				(i * factor) truncated to: (i + 1 * factor) truncated do:
					[ :j |
					sample := (self sampleAt: j) abs.
					sample > max
						ifTrue: [max := sample.
							maxPos := j].
					sample > peak
						ifTrue: [peak := sample]].
				anArray at: i + 1 put: peak truncated]]
		ifFalse: [0 to: aSize - 1 do:
				[ :i |
				peak := 0.0.
				(i * factor) truncated to: (i + 1 * factor) truncated do:
					[ :j |
					sample := (self sampleAt: (aStart + j)) abs.
					sample > max
						ifTrue: [max := sample.
							maxPos := aStart + j].
					sample > peak
						ifTrue: [peak := sample]].
				anArray at: i + 1 put: peak truncated]].
	self at: #maxSample put: max.
	self at: #maxSamplePos put: maxPos!

readEnvelope: type
	"Try to read the sample envelope for the receiver from a file named XXX.env."

	| sfName ext index eName eStream eSize env |
	sfName := self name.
	sfName isEmpty ifTrue: [^false].
	ext := (type == #peak ifTrue: ['pk'] ifFalse: ['env']).
	^self hasFile
		ifTrue: [index := sfName indexOfSubCollection: '.snd' startingAt: 1.
			eName := (sfName copyFrom: 1 to: index), ext.
			eName asFilename exists
				ifTrue: [eStream := eName asFilename readStream binary.
					eSize := eName asFilename fileSize / 2.
"					Transcript show: 'Reading env ', eName, 
							' size ', eSize printString; cr."
					env := Array new: eSize.
					1 to: eSize do:
						[ :i | env at: i put: eStream nextWord].
					eStream close.
					self envelope: env.
					true]
			ifFalse: ["Transcript show: 'No envelope file found ', 
						(sfName copyFrom: 1 to: index), ext; cr. "
					false]]
		ifFalse: [self envelope ~~ nil]!

rmsEnvelope
	"Answer the receiver's envelope, or compute a new one."

	| env |
	env := properties at: #envelope ifAbsent: [nil].
	(env ~~ nil and: [env size > 0])
		ifTrue: [^env].
	(self readEnvelope: #RMS)
		ifFalse: [self computeRMSEnvelope].
	^self envelope!

rmsFrom: aStart to: aStop into: anArray
	"Place a version of the root-mean-square energy of the receiver in the argument array."
	
"	| arr snd |
	arr := Array new: 512.
	snd := StoredSound fileExample.
	snd rmsFrom: 1 to: snd size into: arr.
	(Function from: arr) edit."

	| aSize factor max maxPos sum sample |
	aSize := anArray size.
	aSize > self size
		ifTrue: [^self error: 'Cannot take and rms into a larger array...'].
	factor := ((aStop - aStart) asFloat / (aSize)).
	max := -1.0e30.
	0 to: aSize - 1 do:
		[ :i | 
		sum := 0.0.
		(i * factor) truncated to: (i + 1 * factor) truncated do:
			[ :j |
			sample := self sampleAt: (aStart + j) abs.
			sample > max
				ifTrue: [max := sample.
						maxPos := aStart + j].
			sum := sum + (sample * sample)].
		anArray at: i + 1 put: (sum sqrt / factor) truncated].
	self at: #maxSample put: max.
	self at: #maxSamplePos put: maxPos!

rmsTo: anArray
	"Place a version of the root-mean-square energy of the receiver in the argument array."

	^self rmsFrom: 1 to: self size into: anArray!

scaleBy: aScaleFactor
	"Scale the receiver's samples by the given factor."

	^self scaleFrom: 1 to: self size by: aScaleFactor!

scaleFrom: aStart to: aStop by: aScaleFactor
	"Scale the receiver's damples by the given factor."

	1 to: self size do:
		[ :i |
		self sampleAt: i put: ((self sampleAt: i) * aScaleFactor)].
	^self!

scaledBy: aScaleFactor
	"Answer a copy of the receiver scaled by the given factor."

	^self scaledFrom: 1 to: self size by: aScaleFactor!

scaledByEnvelopeArray: anArray
	"Answer a copy of the receiver scaled by the given envelope array."

	^self scaledFrom: 1 to: self size byEnvelopeArray: anArray!

scaledByFunction: aFunction
	"Answer a copy of the receiver scaled by the given breakpoint envelope expressed as points."

	^self scaledFrom: 1 to: self size byFunction: aFunction!

scaledFrom: aStart to: aStop by: aScaleFactor
	"Answer a copy of the receiver scaled by the given factor."

"	<primitive: 17084>"
	| newSound |
	newSound := self copyAllButSamples.
	1 to: self size do:
		[ :i |
		newSound sampleAt: i put: ((self sampleAt: i) * aScaleFactor)].
	^newSound!

scaledFrom: aStart to: aStop byEnvelopeArray: anArray
	"Answer a copy of the receiver scaled by the given envelope array."

	<primitive: 17086>!

scaledFrom: aStart to: aStop byFunction: aFunction
	"Answer a copy of the receiver scaled by the given breakpoint envelope expressed as points."
	"SoundView openOn: (StoredSound sawtooth scaledByFunction: (LinearFunction from: #((0 0) (1 1))))"

"	<primitive: 17085>"
	| newSound ssize |
	newSound := self copyAllButSamples.
	ssize := 1.0 / self size.
	1 to: self size do:
		[ :i |
		newSound sampleAt: i put: ((self sampleAt: i) * (aFunction at: (i * ssize)))].
	^newSound!

writeEnvelope: type
	"Write the sample envelope for the receiver to a file named XXX.env or XXX.pk."

	| sfName index eName env eStream eSize |
	sfName := self name.
	index := sfName indexOfSubCollection: '.snd' startingAt: 1.
	type == #peak		"or #RMS"
		ifTrue: [eName := (sfName copyFrom: 1 to: index), 'pk']
		ifFalse: [eName := (sfName copyFrom: 1 to: index), 'env'].
	eName asFilename exists
		ifTrue: [(Dialog confirm: 
					'Do you really want to overwrite the envelope file ', eName)
			ifFalse: [^self]].
	eStream := eName asFilename writeStream binary.
	env := self envelope.
	eSize := env size.
"	Transcript show: 'Writing envelope file ', eName, 
						' size ', eSize printString; cr."
	1 to: eSize do:
		[ :i | 
		 eStream nextWordPut: (env at: i)].
	eStream commit; close! !

!Siren.SampledSound methodsFor: 'sample accessing'!

at: anIndex 
	"Answer the value at the given index (between 0 and 1)."

	anIndex isSymbol
		ifTrue: [^ super at: anIndex].
	^ self sampleAt: anIndex					"ignore scale/offset here"!

at: anIndex put: aValue
	"Stuff the given sample at the given index (after lots of checking and testing)."

	| newIndex |
	anIndex isSymbol
		ifTrue: [^ super at: anIndex put: aValue].
	newIndex := self mapSampleIndex: anIndex.
	newIndex <= self size
		ifFalse: [self error: 'Attempt to store past the end of a sound.'].
	(newIndex <= samplesInMemory)
		ifFalse: ["Transcript show: 'Reading next page of sample file.'; cr."
				self realSound readSamplesFrom: newIndex + firstIndex.
				^self sampleAt: newIndex put: aValue].
	^self privateSampleAt: anIndex put: aValue!

cutFrom: startSample to: stopSample
	"Cut the designated section from the receiver; answer a new sound (!!)."

	^GapSound on: self cutFrom: startSample to: stopSample!

floatSampleAt: index
	"Answer the sample at the given index as a normalized floating-point number."

	^(self intSampleAt: index) asFloat / self class maxSample!

floatSampleAt: index put: aValue
	"Stuff the given floating-point sample at the given index after scaling."

	self intSampleAt: index put: (aValue * self class maxSample) truncated!

intSampleAt: index
	"Answer the sample at the given index as an integer."

	^self sampleAt: index!

intSampleAt: index put: aValue
	"Stuff the given integer sample at the given index."

	self sampleAt: index put: aValue!

paste: aSound from: startSample to: stopSample at: index
	"Paste the given sound into the receiver; answer a new sound (!!)."

	^CompositeSound on: self paste: aSound from: startSample to: stopSample at: index!

sampleAt: index
	"Answer the sample at the given index, mapping and paging as necessary."

	| newIndex |
	self samples == nil
			ifTrue: [^self error: 'There are no samples for this sound.'].
	newIndex := self mapSampleIndex: index.
	newIndex > domain last		"answer 0 after end of samples."
		ifTrue: [^0].
	newIndex < domain first		"or before start of samples."
		ifTrue: [^0].
	newIndex <= samplesInMemory
		ifTrue: [^self privateSampleAt: newIndex]
		ifFalse: ["Transcript show: 'Reading next page of sample file.'; cr."
				self realSound readSamplesFrom: newIndex + firstIndex.
				^self sampleAt: newIndex].
	self error: 'Indexing off the end of a sound.'!

sampleAt: anIndex put: aValue
	"Stuff the given sample at the given index (after lots of checking and testing)."

	| newIndex |
	newIndex := self mapSampleIndex: anIndex.
	newIndex <= self size
		ifFalse: [self error: 'Attempt to store past the end of a sound.'].
	(newIndex <= samplesInMemory)
		ifFalse: ["Transcript show: 'Reading next page of sample file.'; cr."
				self realSound readSamplesFrom: newIndex + firstIndex.
				^self sampleAt: newIndex put: aValue].
	^self privateSampleAt: anIndex put: aValue! !

!Siren.SampledSound methodsFor: 'accessing'!

allocateData

	| samps |
	samps := self size * channels.
"	((#lin16Bit -> [data := WordArray new: samps withAll: 0]),
"	((#lin16Bit -> [data := UninterpretedBytes new: samps * 4]),
	(#float32Bit -> [data := UninterpretedBytes new: samps * 4.
			0 to: samps - 1 do: [ :i | data floatAt: (i * 4 + 1) put: 0.0]]))
		case: format
		otherwise: [self error: 'Unknown sound format.'].
	samplesInMemory := samps!

channels
	"Answer the receiver's 'channels'."

	^channels!

channels: anObject
	"Set the receiver's instance variable 'channels' to be anObject."

	channels := anObject!

copy
	"Answer a 'clean' copy of the receiver."

	| newMe |
	newMe := SampledSound named: self name
			size: self size format: self format.
	self properties associationsDo:
		[ :ass |
		newMe at: (ass key) put: (ass value copy)].
	1 to: self size do:
		[ :index |
		newMe sampleAt: index put: (self sampleAt: index)].
	^newMe!

copyAllButSamples
	"Answer a 'clean' copy of the receiver, but don't write in the samples yet."

	| newMe |
	newMe := SampledSound named: self name
			size: self size 
			rate: self rate
			channels: self channels 
			format: self format.
	self properties associationsDo:
		[ :ass |
		newMe at: (ass key) put: (ass value copy)].
	^newMe!

copyFrom: start to: stop
	"Answer a copy of the receiver for the given sample range."
	"((StoredSound sweepDur: 1.0 rate: 44100 from: 50 to: 5000 chans: 1)
				copyFrom: 10000 to: 10512) edit"

	| newMe |
	newMe := self copyAllButSamples.
	newMe size: stop - start + 1.
	newMe allocateData.
	start to: stop - 1 do:
		[ :index |
		newMe sampleAt: index - start + 1 put: (self sampleAt: index)].
	^newMe!

cueNamed: cName
	"Answer a sound derived from the receiver using the samples between the named cue points."

	| snd start stop region |
	region := self cueRegionNamed: cName.
	start := region first.
	stop := region last.
	snd := self copyAllButSamples.
	snd size: (stop - start).
	snd samples: (ByteArray new: (stop - start * self sampleSize)).
	start to: stop do:
		[ :ind |
		snd sampleAt: (ind - start + 1) put: (self sampleAt: ind)].
	^snd.!

envelope
	"Answer the receiver's envelope."

	properties ifNil: [^nil].
	^properties at: #envelope ifAbsent: [nil]!

envelope: anEnv
	"Set the receiver's envelope property."

	properties at: #envelope put: anEnv!

file
	"Answer the sound file for the receiver (if present)."

	| file |
	self hasFile
		ifTrue: [file := SoundFile named: self name.
			file sound: self.
			^file]
		ifFalse: [^nil]!

firstIndex
	"Answer the receiver's 'firstIndex'."

	^firstIndex!

firstIndex: anObject
	"Set the receiver's instance variable 'firstIndex' to be anObject."

	firstIndex := anObject!

floatsFrom: aStart to: aStop
	"Answer a copy of the receiver's data within the given sample range."

	| samps |
	samps := ByteArray new: (aStop - aStart) * 4.
	aStart to: aStop - 1 do:
		[ :i | samps floatAt: (i - aStart + 1) put: (self floatSampleAt: i)].
	^samps!

format
	"Answer the receiver's 'format'."

	^format!

format: fSymbol
	"Set the receiver's instance variable 'format' to be fSymbol."

	format := fSymbol.
	range := ((#lin16Bit -> [-32768 to: 32767]), (#float32Bit -> [-1.0 to: 1.0])) 
		case: fSymbol otherwise: [-1.0 to: 1.0]!

frameRate
	"Answer the receiver's 'rate'."

	^rate!

from: aStart to: aStop
	"Answer a copy of the receiver within the given time range."

	| sound |
	sound := SampledSound named: self name
			size: ((aStart - aStop) asSec * self rate) asInteger
			format: self format.
	((aStart * 2 - 1) max: 1) to: (aStop * 2) by: 2 do:
		[ :i | sound sampleAt: i put: (self sampleAt: i)].
	^sound!

fromSample: start toSample: finish
	"Answer a copy of the receiver within the given sample range."

	| ssize sdata |
	((start == nil) or: [finish == nil])
		ifTrue: [^SampledSound new].
	ssize := finish - start.
	sdata := Array new: ssize.
	1 to: ssize do:
		[ :index |
		sdata at: index put: (self sampleAt: index + start)].
	^SampledSound fromData: sdata
		rate: self rate
		channels: self channels
		format: self format!

hasFile
	"Answer whether the receiver is stored on a file of the same name."

	self name isEmpty ifTrue: [^false].
	^self name asFilename exists!

longFormat
	"Answer the receiver's format as a descriptive string."

	^(	(#lin16Bit -> ['16-bit linear ints']),
		(#float32Bit -> ['32-bit linear floats']),
		(#Mu8Bit -> ['8-bit Mu-law']))
	case: (properties at: #format ifAbsent: [nil])
	otherwise: ['**unknown**']!

name
	"Answer the receiver's 'name'."

	^name!

name: anObject
	"Set the receiver's instance variable 'name' to be anObject."

	name := anObject!

rate
	"Answer the receiver's 'rate'."

	^rate!

rate: anObject
	"Set the receiver's instance variable 'rate' to be anObject."

	rate := anObject!

sampleRate
	"Answer the receiver's 'rate'."

	^rate!

sampleSize
	"Answer the size in bytes of the receiver's samples (2)."

	^2!

samples
	"Answer the instance variable 'data'."

	data ifNil: [self getData].
	^data!

samples: theArray
	"Accept the argument, 'theArray', (a Byte, Word, or Float array, or an UninterpretedBytes)
	as the new instance variable 'samples'."

	data := theArray.
	samplesInMemory := theArray size "/ self sampleSize" .
	self size: data size.!

samplesInMemory
	"Answer the receiver's 'samplesInMemory'."

	^samplesInMemory!

samplesInMemory: anObject
	"Set the receiver's instance variable 'samplesInMemory' to be anObject."

	samplesInMemory := anObject!

size
	"Return the receiver's size in sample frames."

	domain ifNil: [^0].
	domain isInteger ifTrue: [^domain].
	^domain size!

size: aNumber
	"Set the receiver's 'size' in samples."

	domain := 1 to: aNumber.
	self duration: (Duration value: (aNumber asFloat / self rate)).
	data ifNil: [self allocateData]!

sizeInBytes
	"Answer the size in bytes of the receiver."

	^self size * self sampleSize!

sizeInFrames
	"Return the receiver's size in sample frames."

	domain ifNil: [^0].
	domain isInteger ifTrue: [^domain].
	^domain size! !

!Siren.SampledSound methodsFor: 'testing'!

hasGaps
	"Answer whether the receiver has any gaps."

	^false!

isComposite
	"Answer whether the receiver is a composite sound."

	^false!

isEmpty
	"Answer whether the receiver is empty."

	^data isNil!

isVirtual
	"Answer whether the receiver is a virtual sound."

	^false! !

!Siren.SampledSound methodsFor: 'private'!

getData
	"Read samples in from the file if none in memory."

	| realme |
	samplesInMemory > 0
		ifTrue: [data := nil].
	realme := SampledSound fromFile: self fullName.
	data :=  realme data.
	samplesInMemory := realme samplesInMemory.
	domain := realme domain.!

mapSampleIndex: index
	"Map the given sample index according to the 'page' (firstIndex) of the receiver."

	^index truncated - firstIndex!

privateSampleAt: anIndex
	"Answer the sample at the given index as an integer."

	^data isCPointer
		ifTrue: [data isValid
			ifTrue: [data at: anIndex - 1]
			ifFalse: [0]]
		ifFalse: [data shortAt: (anIndex * 2 - 1) bigEndian: (UninterpretedBytes isBigEndian)]!

privateSampleAt: anIndex in: cPtr bigEndian: isBE
	"Answer the sample at the given index as an integer, 
		assuming the output is a cPointer; handle endianness."

	| byteIndex word |
	byteIndex := anIndex - 1 * 2.			"zero-based"
	word := isBE
		ifTrue: [((cPtr at: byteIndex) bitShift: 8) + (cPtr at: byteIndex + 1)]
		ifFalse: [((cPtr at: byteIndex + 1) bitShift: 8) + (cPtr at: byteIndex)].
	^(word bitAnd: 16r7FFF) - (word bitAnd: 16r8000)!

privateSampleAt: anIndex in: cPtr put: value bigEndian: isBE
	"Answer the sample at the given index as an integer, 
		assuming the output is a cPointer; handle endianness."

	| byteIndex word |
	byteIndex := anIndex - 1 * 2.			"zero-based"
	word := (value bitAnd: 16r7FFF) - (value bitAnd: -16r8000).
	isBE
		ifTrue:
			[cPtr at: byteIndex put: (word bitShift: -8).
			cPtr at: byteIndex + 1 put: (word bitAnd: 16rFF)]
		ifFalse:
			[cPtr at: byteIndex + 1 put: (word bitShift: -8).
			cPtr at: byteIndex put: (word bitAnd: 16rFF)]!

privateSampleAt: anIndex put: aValue
	"Stuff the given sample at the given index (safely)."

	data shortAt: (anIndex * 2 - 1) put: (aValue truncated) bigEndian: (UninterpretedBytes isBigEndian)!

readSamplesFrom: index
	"Read in samples from disk starting a bit before the given index."

	| file fSize offset |
	file := self file.
	file == nil
		ifTrue: [self error: 'There is no sound file associated with this sound.'].
	fSize := file size.
	offset := index - 128.
	(offset + samplesInMemory) > fSize
		ifTrue: [offset := fSize - samplesInMemory].
	Cursor read showWhile: [file readSamplesStartingAt: offset].
	firstIndex := offset!

realSound
	"Answer the real sound for the receiver (overridden in virtual subclasses)."

	^self!

scaleSampleIndex: index
	"Scale the given sample index according to the sample size of the receiver."

	^index * self sampleSize - 1.! !

!Siren.SampledSound methodsFor: 'enumerating'!

do: aBlock 
	"Evaluate aBlock with each of the receiver's elements as the argument."

	self samples do: aBlock! !

!Siren.SampledSound methodsFor: 'initialize-release'!

initialize
	"Set up a default sound."

	super initialize.
	firstIndex := 0.
"	folder := ''."
	name := ''.
	rate := 44100.
	channels := 1.
	format := #lin16Bit.
	samplesInMemory := 0! !

!Siren.SampledSound methodsFor: 'play/record'!

nextBufferInto: outBuffer frames: bufferSize channels: outChannels format: sformat startingAt: startFrame
	"Copy data from the receiver into the given output buffer; answer the current sample index."

	| frames numToDo isBE |
"	Transcript show: startFrame printString; cr."
	frames := self size.
	startFrame >= frames ifTrue: [^nil].
	sformat == format ifFalse: [self error: 'Output format not supported.'].
	numToDo := bufferSize min: (frames - startFrame).
	isBE := UninterpretedBytes isBigEndian.
"If the sound and the output buffer are the same # of channels -- copy samples"
	outChannels = channels
		ifTrue: [1 to: (numToDo * channels) do:
				[ :frm | | current samp |
				current := self privateSampleAt: frm in: outBuffer bigEndian: isBE.
				samp := self sampleAt: (startFrame + frm).
				self privateSampleAt: frm in: outBuffer put: (current + samp) bigEndian: isBE].
			^numToDo = bufferSize
				ifFalse: [nil]
				ifTrue: [startFrame + numToDo]].
"else copy mono sound to multi-channel output"
	channels = 1
		ifTrue: [1 to: numToDo do:
				[ :frm | | samp |
				samp := self sampleAt: (startFrame + frm).
				0 to: outChannels - 1 do:
					[ :cha | | pos current |
					pos := frm + cha.
					current := self privateSampleAt: pos in: outBuffer bigEndian: isBE.
					self privateSampleAt: pos in: outBuffer put: (current + samp) bigEndian: isBE]].
			^numToDo = bufferSize
				ifFalse: [nil]
				ifTrue: [startFrame + numToDo]].
	self error: 'unhandled sound output channel mismatch.'!

play
	"Play the receiver out over the default sound port."
	"(SampledSound sweepDur: 2 rate: 44100 from: 20 to: 1000 chans: 1) play"

	SoundPort default play: self! !

!Siren.SampledSound methodsFor: 'interpolating'!

autoCorrelationBetween: index1 and: index2 length: length
	"Answer the cummulative error between the portions of my waveform starting at the given two indices and extending for the given length. The larger this error, the greater the difference between the two waveforms."

	| error i1 e |
	error := 0.
	i1 := index1.
	index2 to: (index2 + length - 1) do: [:i2 |
		e := (self sampleAt: i1) - (self sampleAt: i2).
		e < 0 ifTrue: [e := 0 - e].
		error := error + e.
		i1 := i1 + 1].
	^ error!

errorBetween: sampleArray1 and: sampleArray2
	"Answer the cummulative error between the two sample arrays, which are assumed to be the same size."

	| error e |
	error := 0.
	1 to: sampleArray1 size do: [:i |
		e := (sampleArray1 at: i) - (sampleArray2 at: i).
		e < 0 ifTrue: [e := 0 - e].
		error := error + e].
	^ error!

fadeInOver: fTime
	"Apply a fade-in ramp to the receiver with the given time."

	| fDur |
	fTime > self duration asSec value
		ifTrue: [Transcript show: 'Illegal fade-in time'; cr. ^nil].
	fDur := fTime * self rate * self channels.
	1 to: fDur do:
		[ :index |
		self sampleAt: index 
			put: (self sampleAt: index) * (index / fDur)]!

fadeOutOver: fTime
	"Apply a fade-in ramp to the receiver with the given time."

	| fDur s0 |
	fTime > self duration asSec value
		ifTrue: [Transcript show: 'Illegal fade-in time'; cr. ^nil].
	fDur := fTime * self rate * self channels.
	s0 := domain - fDur.
	s0 to: domain do:
		[ :index |
		self sampleAt: index 
			put: (self sampleAt: index) * (1.0 - (index - s0 / fDur))]!

interpolatedWindowAt: anIndex width: nSamples
	"Return an array of N samples starting at the given index in my data."

	| scale baseIndex scaledFrac scaledOneMinusFrac prevSample nextSample v |
	scale := 10000.
	anIndex isInteger
		ifTrue: [^ (anIndex to: anIndex + nSamples - 1) collect: [ :i | self sampleAt: i]].
	baseIndex := anIndex truncated.
	scaledFrac := ((anIndex asFloat - baseIndex) * scale) truncated.
	scaledOneMinusFrac := scale - scaledFrac.
	prevSample := data at: baseIndex.
	^ (baseIndex + 1 to: baseIndex + nSamples) collect: [:i |
		nextSample := self sampleAt: i.
		v := ((nextSample * scaledFrac) + (prevSample * scaledOneMinusFrac)) // scale.
		prevSample := nextSample.
		v].!

sampleMaxFrom: aStart to: aStop into: anArray
	"Place a version of the root-mean-square energy of the receiver in the argument array."
	
"	| arr snd |
	arr := Array new: 64 withAll: 0.0.
	snd := StoredSound fileExample.
	snd sampleMaxFrom: 1 to: snd size into: arr.
	(Function from: arr) edit."

"	<primitive: 17082>
"
	| factor max |
	anArray size > self size
		ifTrue: [^self error: 'Cannot take and rms into a larger array...'].
	factor := ((aStop - aStart) / (anArray size)) asFloat.
	0 to: anArray size - 1 do:
		[ :i | 
		max := 0.
		(i * factor) asInteger to: (i + 1 * factor) asInteger do:
			[ :j |
			max := max max: (self sampleAt: (aStart + j))].
		anArray at: i + 1 put: (max asFloat / 32767.0) asFloat].!

sampledFrom: aStart to: aStop into: anArray
	"Place a down-sampled version of the receiver in the argument array."

	<primitive: 17081> "ca n'existe pas"!

sampledTo: anArray
	"Place a down-sampled version of the receiver in the argument array."

	^self sampledFrom: 1 to: self size into: anArray! !

!Siren.SampledSound methodsFor: 'printing'!

printOn: aStream
	"pretty-print the receiver."

	aStream nextPutAll: '(', self class name, ' '; cr.
	name == nil
		ifFalse: [aStream tab; nextPutAll: 'named: ', name printString; cr].
	duration == nil
		ifFalse: [aStream tab; nextPutAll: 'duration: ', duration printString; cr].
	rate == nil
		ifFalse: [aStream tab; nextPutAll: 'rate: ', rate printString; cr].
	channels == nil
		ifFalse: [aStream tab; nextPutAll: 'channels: ', channels printString; cr].
	format == nil
		ifFalse: [aStream tab; nextPutAll: 'format: ', format printString; cr].
	range == nil
		ifFalse: [aStream tab; nextPutAll: 'range: ', range printString; cr].
	properties == nil
		ifFalse: [properties associationsDo:
			[ :ass |
			ass key == #envelope
				ifFalse: [aStream tab; nextPutAll: ass key, ': ', ass value printString; cr]]].
	self envelope == nil
		ifFalse: [aStream tab; nextPutAll: 'envelope: ', self envelope size printString, ' values'; cr].
	self cueList == nil
		ifFalse: [aStream tab; nextPutAll: 'cue list: ', self cueList size printString, ' regions'; cr].
	self printSamplesOn: aStream.
	aStream nextPutAll: ')'; cr.!

printSamples
	"pretty-print a few samples."

	| stream |
	stream := WriteStream on: (String new: 4096).
	1 to: 512 do:
		[ :i | stream nextPutAll: ((self sampleAt: i) printString); cr].
	^stream contents!

printSamplesOn: aStream
	"Pretty-print a few samples--32 by default, 1024 if shift-down, *all* of ctrl and shift down."

	| number |
	data ifNil: [^aStream nextPutAll: '(no samples)'].
	number := 128 min: self size.
	aStream tab; nextPutAll: 'samples: #('.
	1 to: number do:
		[ :i | aStream nextPutAll: ((self sampleAt: i) printString), ' '].
	aStream nextPutAll: '...'.
	aStream nextPut: $);  cr.!

storeOnFileNamed: aName
	"Save the receiver on the sound file named by the argument."

	(SoundFile named: aName) saveSound: self! !

!Siren.SampledSound methodsFor: 'merging'!

extractChannel: cNumber into: aSound
	"Extract the given channel from the receiver into the argument sound."

	<primitive: 17021>!

mergeChannel: cNumber from: aSound
	"Merge the argument sound into the given channel of the receiver."

	<primitive: 17022>! !



Smalltalk.Siren defineClass: #FloatSound
	superclass: #{Siren.SampledSound}
	indexedType: #objects
	private: false
	instanceVariableNames: ''
	classInstanceVariableNames: ''
	imports: ''
	category: 'Music-Sound'!

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!


!Siren.FloatSound class methodsFor: 'class constants'!

formatSymbol
	"Answer the symbolic code used for the format of the receiver's instances."

	^#float32Bit!

maxSample
	"Answer the maximum value of the receiver class."

	^1.0!

minSample
	"Answer the minimum value of the receiver class."

	^-1.0! !

!Siren.FloatSound class methodsFor: 'examples'!

fileExample
	"Answer a typical float sound read in from a file."
	"SoundView openOn: FloatSound fileExample"

	^FloatSound fromFile: 'snd/new/orchestra.f.snd'! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!


Siren.FloatSound comment:
'Instances of FloatSound are used for sounds with 32-bit floating-point numbers as samples.
There are behaviors for mapping into other formats.'!

!Siren.FloatSound methodsFor: 'sample accessing'!

intSampleAt: index
	"Answer the sample at the given index as a scaled 16-bit integer."

	^((self sampleAt: index) * 32767.0) rounded!

intSampleAt: index put: aValue
	"Put the given integer sample at the given index after scaling."

	self sampleAt: index put: (aValue asFloat / 32767.0)! !

!Siren.FloatSound methodsFor: 'accessing'!

format
	"Return the receiver's format--a symbol constant."

	^#float32Bit!

sampleSize
	"Answer the size in bytes of the receiver's samples (4)."

	^4! !

!Siren.FloatSound methodsFor: 'private'!

privateSampleAt: index
	"Answer the sample at the given index."

	^data floatAt: (index -1 * 4 + 1)!

privateSampleAt: index put: aValue
	"Stuff the given sample into the data array at the given index (no checking)."

	data floatAt: (index -1 * 4 + 1) put: aValue asFloat! !



Smalltalk.Siren defineClass: #VirtualSound
	superclass: #{Siren.SampledSound}
	indexedType: #objects
	private: false
	instanceVariableNames: 'source '
	classInstanceVariableNames: ''
	imports: ''
	category: 'Music-Sound'!

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!


!Siren.VirtualSound class methodsFor: 'instance creation'!

from: source cue: cName
	"Answer a VirtualSound derived from the argument and named cue region."
	"VirtualSound exampleView"

	| me |
	me := self new initialize.
	me source: source.
	me cue: cName.
	^me! !

!Siren.VirtualSound class methodsFor: 'examples'!

exampleView
	"Open a sound view on a ramp with a chunk cut out of it."
	"VirtualSound exampleView"

	SoundView openOn: (VirtualSound from: 
			(SampledSound fromFile: 'snd/AllGatesAreOpen/nml1.8e.snd') 
				cue: #stream3)! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!


Siren.VirtualSound comment:
'An instance of VirtualSound is a "reference" to another sound, typically by a named cue list entry.

Instance Variables:
	source	<StoredSound> the sound to which the VirtualSound points'!

!Siren.VirtualSound methodsFor: 'sample accessing'!

sampleAt: index put: aValue
	"Stuff the given sample at the given index **after transforming into a 'real' sound**."

	self getReal.
	^super sampleAt: index put: aValue! !

!Siren.VirtualSound methodsFor: 'accessing'!

cue: cueName
	"Set the cue name of the receiver"

	properties at: #cue put: cueName.
	domain := source cueRegionNamed: cueName.
	duration := SecondDuration value: (self size / self rate) asFloat.
	self name: self name, '.', cueName!

source
	"Answer the receiver's source sound."

	^source!

source: aSound
	"Set the receiver's source sound."

	source := aSound.
	self rate: source rate.
	self channels: source channels.
	self name: source name.
	self domain: aSound domain!

start: start
	"Set the argument as the starting sample of the receiver."

	properties at: #start put: start.
	(properties includesKey: #stop)
		ifTrue: [self size: (properties at: #stop) - start].!

stop: stop
	"Set the argument as the ending sample of the receiver."

	properties at: #stop put: stop.
	(properties includesKey: #start)
		ifTrue: [self size: stop - (properties at: #start)].! !

!Siren.VirtualSound methodsFor: 'testing'!

isVirtual
	"Answer whether the receiver is a virtual sound."

	^true! !

!Siren.VirtualSound methodsFor: 'private'!

getReal
	"Answer a 'real sound' based on the receiver."

	| newSound |
	newSound := self copyAllButSamples.
	1 to: self size do:
		[ :ind |
		newSound sampleAt: ind put: (self sampleAt: ind)].
	self become: newSound!

mapSampleIndex: index
	"Map the given sample index according to the 'page' (firstIndex) of the source and the receiver's relative offset."

	^(source mapSampleIndex: index) + firstIndex!

realSound
	"Answer the real sound for the receiver."

	^source! !



Smalltalk.Siren defineClass: #CompositeSound
	superclass: #{Siren.VirtualSound}
	indexedType: #objects
	private: false
	instanceVariableNames: 'components '
	classInstanceVariableNames: ''
	imports: ''
	category: 'Music-Sound'!

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!


!Siren.CompositeSound class methodsFor: 'instance creation'!

on: source paste: newSound from: start to: stop at: index
	"Answer a CompositeSound derived from the argument pasting in the given sound at the given index."
	"CompositeSound exampleView"

	| me |
	me := self new initialize.
	me on: source.
	me paste: newSound from: start to: stop at: index.
	^me! !

!Siren.CompositeSound class methodsFor: 'examples'!

exampleView
	"Open a sound view on a ramp with a chunk of a sine pasted into it."
	"CompositeSound exampleView"

	| ramp sine |
	ramp := SampledSound rampDur: 1.0 rate: 8000 chans: 1.
	sine := SampledSound sineDur: 0.5 rate: 8000 freq: 400 chans: 1.
	SoundView openOn: (ramp paste: sine from: 200 to: 400 at: 1000)! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!


Siren.CompositeSound comment:
'An instance of CompositeSound can be used to represent a sound constructed by "splicing together" sections of other sounds.
It uses its components collection to maintain sounds and sample ranges that have been pasted together.
It responds to sampleAt: and sampleAt:put: just like other sounds, but stores only its components list on files unless explicitly told to store samples.

Instance Variables:
	components <SortedCollection of ComponentSounds> the "sub-sounds" of the CompositeSound'!

!Siren.CompositeSound methodsFor: 'sample accessing'!

sampleAt: index
	"Answer the sample at the given index, mapping and paging as necessary."

	| q |
	1 to: components size do:
		[ :ind | 
		q := components at: ind.
		(q includes: index)
			ifTrue: [^q sound sampleAt: (index - q start + q offset)]].
	self error: 'No sample by that name, Sir.'! !

!Siren.CompositeSound methodsFor: 'accessing'!

on: aSound
	"Set the receiver's source sound."

	components := SortedCollection sortBlock: [ :x :y | x start <= y start].
	components add: (ComponentSound on: aSound start: 1 stop: aSound size).
	self rate: aSound rate.
	self channels: aSound channels.
	self size: aSound size.
	properties := aSound properties copy!

paste: sound from: start to: stop at: index
	"Paste the designated section into the receiver."

	| newItem item number extent oldStop |
	extent := stop - start.
	newItem := ComponentSound on: sound 
				start: index stop: stop - start + index offset: start.
	index >= self size						"if pasting onto the end of the sound"
		ifTrue: [components add: newItem.
				^self].
	number := 1.							" else locate where to put it"
	[(number > components size) | ((components at: number) includes: index)] 
		whileFalse: [number := number + 1].
	item := components at: number.
	index = item stop						"if we're pasting at the end of another splice"
		ifTrue: [self rippleUpFrom: (number + 1) adding: extent.
			components add: newItem.
			^self].
	index = item start						"if we're pasting at the start of another splice"
		ifTrue: [self rippleUpFrom: number adding: extent.
			components add: newItem.
			^self].
											"else we have to break up an existing component"
	self rippleUpFrom: (number + 1) adding: extent.
	oldStop := item stop.
	item stop: index - item start.			"edit the old entry in place"
	components add: newItem.			"insert the new item"
								"add a copy of the old item with new interval and offset"
	components add: (ComponentSound on: item sound 
			start: (index + extent + 1) stop: (oldStop + extent) 
			offset: (item offset + (index - item start) + extent)).
	^self! !

!Siren.CompositeSound methodsFor: 'testing'!

isComposite
	"Answer whether the receiver is a composite sound."

	^true! !

!Siren.CompositeSound methodsFor: 'private'!

rippleUpFrom: start adding: insert
	"Shift all the cues above the given one up by the given insert count."

	| item |
	start to: components size do:
		[ :ind | 
		item := (components at: ind).
		item start: (item start + insert).
		item stop: (item stop + insert)].! !



Smalltalk.Siren defineClass: #ComponentSound
	superclass: #{Siren.Sound}
	indexedType: #objects
	private: false
	instanceVariableNames: 'start stop sound '
	classInstanceVariableNames: ''
	imports: ''
	category: 'Music-Sound'!

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!


!Siren.ComponentSound class methodsFor: 'instance creation'!

on: sound from: start to: stop
	"Answer a new instance initialized with the arguments."

	^(self new) sound: sound; start: start; stop: stop!

on: sound start: start stop: stop
	"Answer a new instance initialized with the arguments."

	^(self new) sound: sound; start: start; stop: stop!

on: sound start: start stop: stop offset: offset
	"Answer a new instance initialized with the arguments."

	^(self new) sound: sound; start: start; stop: stop; offset: offset! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!


Siren.ComponentSound comment:
'A ComponentSound is used as a component (a "splice" element, if you will).
It represents another sound that "composes" the composite.

Instance Variables:
	sound <StoredSound> the "subject" sound 
	start <Integer> the starting sample in the composite
	stop <Integer> the ending sample in the composite
	offset <Number> the offset into the selection'!

!Siren.ComponentSound methodsFor: 'accessing'!

offset
	"Answer the receiver's 'offset'."

	^offset!

offset: anObject
	"Set the receiver's 'offset' to be anObject."

	offset := anObject!

sound
	"Answer the receiver's 'sound'."

	^sound!

sound: anObject
	"Set the receiver's 'sound' to be anObject."

	sound := anObject!

start
	"Answer the receiver's 'start'."

	^start!

start: anObject
	"Set the receiver's 'start' to be anObject."

	start := anObject!

stop
	"Answer the receiver's 'stop'."

	^stop!

stop: anObject
	"Set the receiver's 'stop' to be anObject."

	stop := anObject.
	((start ~~ nil) & (sound ~~ nil))
		ifTrue: [self duration: (stop - start / sound rate) asFloat]! !

!Siren.ComponentSound methodsFor: 'printing'!

printOn: aStream
	"Pretty-print the receiver on the argument."

	| ra |
	sound ifNil: [^super printOn: aStream].
	ra := sound rate asFloat.
	aStream nextPutAll: '(ComponentSound on ', sound name, 
			' from ', ((start asFloat / ra) printWidth: 6), 
			' to ', ((stop asFloat / ra) printWidth: 6).
	offset ifNotNil: 
		[aStream nextPutAll: ' starting at ', offset printString].
	aStream nextPutAll: ')'; cr.! !

!Siren.ComponentSound methodsFor: 'testing'!

includes: anIndex
	"Answer whether the argument is within the range of the receiver."

	^(anIndex >= start) & (anIndex <= stop)! !



Smalltalk.Siren defineClass: #GapSound
	superclass: #{Siren.VirtualSound}
	indexedType: #objects
	private: false
	instanceVariableNames: 'cutList '
	classInstanceVariableNames: ''
	imports: ''
	category: 'Music-Sound'!

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!


!Siren.GapSound class methodsFor: 'instance creation'!

on: source cutFrom: start to: stop
	"Answer a CompositeSound derived from the argument missing the given range."
	"GapSound exampleView"

	| me |
	me := self new initialize.
	me source: source.
	me samplesInMemory: source samplesInMemory.
	me data: source data.
	me cutFrom: start to: stop.
	^me! !

!Siren.GapSound class methodsFor: 'examples'!

exampleView
	"Open a sound view on a ramp with a chunk cut out of it."
	"GapSound exampleView"

	SoundView openOn: ((SampledSound rampDur: 1.0 rate: 16000 chans: 1) 
			cutFrom: 1000 to: 10000)! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!


Siren.GapSound comment:
'An instance of GapSound can be used to represent a sound with samples deleted from it (i.e., a gap).
It uses its cut list instance variable to maintain sample ranges that have been deleted from the sound that comprises it (the source).
It responds to sampleAt: and sampleAt:put: just like other sounds, but stores only its cut list on files unless explicitly told to store samples.

Instance Variables:
	cutList		<SortedCollection of Integers> the list of deleted sections by sample index i.e., pointers denoting sections that have been deleted. For example, having a cutList of (1000 2000) means that samples (1000, 2000] have been virtually cut.
'!

!Siren.GapSound methodsFor: 'accessing'!

allocateData
	"no-op"

	^self!

cutFrom: startSample to: stopSample
	"Cut the designated section from the receiver."

	| realStart realStop |
	realStart := self mapSampleIndex: startSample.
	realStop := self mapSampleIndex: stopSample.
	cutList == nil
		ifTrue: [cutList := SortedCollection new].
	cutList add: realStart.
	cutList add: realStop.
	self size: (self size - (stopSample - startSample)).
	^self!

samples

	^source samples! !

!Siren.GapSound methodsFor: 'testing'!

hasGaps
	"Answer whether the receiver has any gaps."

	^true! !

!Siren.GapSound methodsFor: 'private'!

mapSampleIndex: index
	"Map the given sample index according to the cut list (i.e., deleted sections) of the receiver."

	| mappedIndex |
	((cutList == nil) or: [cutList size < 2])
		ifTrue: [^index - firstIndex].
	mappedIndex := index.
	mappedIndex < cutList first
		ifTrue: [^mappedIndex].
	1 to: cutList size by: 2 do:
		[ :cutIndex |
		mappedIndex := mappedIndex - 
				((cutList at: cutIndex) - (cutList at: cutIndex + 1)).
		(((cutIndex + 1) = cutList size) or: 
				[mappedIndex < (cutList at: cutIndex + 2)])
			ifTrue: [^mappedIndex]].
		^mappedIndex - firstIndex.! !
