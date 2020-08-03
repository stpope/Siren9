

Smalltalk.Siren defineClass: #SHARCInstrument
	superclass: #{Core.Object}
	indexedType: #none
	private: false
	instanceVariableNames: 'name directory range samples '
	classInstanceVariableNames: ''
	imports: ''
	category: 'MusicApps-SHARC'!

Siren.SHARCInstrument defineSharedVariable: #SHARCHome
	private: false
	constant: false
	category: 'As yet unclassified'
	initializer: ''!

Siren.SHARCInstrument defineSharedVariable: #SHARCOrchestra
	private: false
	constant: false
	category: 'As yet unclassified'
	initializer: nil!

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!


!Siren.SHARCInstrument class methodsFor: 'class constants'!

loadOrchDir: dir
	"SHARCInstrument loadOrchDir: 'sharc'"
	"SHARCInstrument orchestra inspect"

	| fullName instrs total |
	fullName := SirenUtility findFile: dir.
	Transcript cr; cr; show: 'Load SHARC database from dir ', fullName; cr.
	SHARCOrchestra := Dictionary new.
	instrs := fullName asFilename directoryNames.
	instrs do: [ :subDir | | in | 
		in := self fromDir: subDir asString.
		SHARCOrchestra at: in name put: in].
	total := SHARCOrchestra values inject: 0 into: 
				[ :su :it | su + it samples size].
	Transcript cr; show: 'Loaded ', SHARCOrchestra size printString,
			' instruments, ', total printString, ' samples.'; cr.
	^SHARCOrchestra!

orchestra
	"SHARCInstrument orchestra inspect"

	^SHARCOrchestra! !

!Siren.SHARCInstrument class methodsFor: 'instance creation'!

fromDir: dirName 
	"Answer a SHARC instrument group read from the CONTENTS file in the 
	 given directory. The contents file describes a number of samples, each
	 of which has a description file with its overtones."
	"Contents file sample descr. line format
		c2  24 152  2099   65.406   65.430  2 25  1  5.440  1.353  314.345 "

	| inst strm pitches nam basename |
"	nam := SirenUtility findFile: dirName."
	SHARCHome ifNil: [SHARCHome := (CEnvironment getenv: 'HOME'), '/Code/CSL6/Data/SHARC/'].
	nam := SHARCHome.
	nam ifNil: [self error: 'Cannot find SHARC database'].
	basename := dirName asFilename tail asString.
	nam := nam, basename.
	Transcript show: 'Load instrument ' , basename , ':  '.
	strm := (nam, '/CONTENTS') asFilename readStream.
	inst := self new initialize.
	inst directory: dirName.
	inst name: basename asSymbol.
	[strm atEnd] whileFalse: 
			[ | samp |
			Cursor read showWhile: 
					[samp := SHARCSample in: nam descr: strm].
			samp ifNotNil: [inst samples at: samp pitch put: samp]].
	strm close.
	pitches := inst samples collect: [ :sa | sa key].
	inst range: (pitches values min to: pitches values max).
	Transcript show: inst samples size printString , ' samples.'; cr.
	^inst! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!


!Siren.SHARCInstrument methodsFor: 'accessing'!

directory
	"Answer the receiver's 'directory'."

	^directory!

directory: anObject
	"Set the receiver's instance variable 'directory' to be anObject."

	directory := anObject!

name
	"Answer the receiver's 'name'."

	^name!

name: anObject
	"Set the receiver's instance variable 'name' to be anObject."

	name := anObject!

range
	"Answer the receiver's 'range'."

	^range!

range: anObject
	"Set the receiver's instance variable 'range' to be anObject."

	range := anObject!

sampleNamed: n
	"Answer the receiver's sample by the given name."

	^samples at: n ifAbsent: [nil]!

sampleWithKey: k
	"Answer the receiver's sample by the given name."

	^samples detect: [ :s | s key = k] ifNone: [nil]!

samples
	"Answer the receiver's 'samples'."

	^samples!

samples: anObject
	"Set the receiver's instance variable 'samples' to be anObject."

	samples := anObject! !

!Siren.SHARCInstrument methodsFor: 'converting'!

asSpectrum

	| sp n frIncr dat base |
	n := 4096.		"default 'simulated' fft window size."
	sp := Spectrum new real; sound: nil; windowSize: 4096;
				stepSize: 4096; name: name;
				folder: directory; setData.
	frIncr := 44100 / n.
	1 to: samples size do:
		[ :ind | | sa |
		dat := Array new: n.
		sa := samples at: ind.			"get the sample"
		base := sa rePitch / frIncr.		"base frequency of sample in bins"
		sa do: 
			[ :ind2 | | pt |
			pt := sa at: ind2.
			dat at: ind2 put: pt x].			"add up partials"
		sp at: ind put: dat]! !

!Siren.SHARCInstrument methodsFor: 'initialize-release'!

initialize

	samples := Dictionary new! !



Smalltalk.Siren defineClass: #SHARCSample
	superclass: #{Siren.Function}
	indexedType: #objects
	private: false
	instanceVariableNames: 'name pitch key nHarm ampl noPitch rePitch centroid '
	classInstanceVariableNames: ''
	imports: ''
	category: 'MusicApps-SHARC'!

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!


!Siren.SHARCSample class methodsFor: 'instance creation'!

in: dirName descr: strm
	"Read a sample's data from the given directory based on the given line from the contents file."
	"SHARCInstrument loadOrchDir: 'sharc'"
	"Format:
		pitch key nHarm ampl noPitch rePitch      skip 5 fields       centroid
		 c#2   24   152    2099   65.406   65.430 [ 2 25  1  5.440  1.353 ] 314.345 "

	| inst pit nHarm fil nam istrm |
	nam := dirName asFilename tail.
	inst := self new initialize.
	inst name: nam asSymbol.
	strm skipSeparators.
	pit := strm upToSeparator asSymbol.
	strm skipSeparators.
	inst pitch: pit.
	inst key: (Number readFrom: strm).
	strm skipSeparators.
	((((strm atEnd) or: [inst name isNil]) or: [inst pitch isEmpty]) or: [inst noPitch = 0.0])
		ifTrue: [^nil  "self error: 'Faulty SHARC data file'"].
"	Transcript tab; show: 'Load sample from file ', dirName, Filename separatorString, 
					nam, '_', pit, '.spect'; cr.
"	nHarm := Number readFrom: strm.
	strm skipSeparators.
	inst nHarm: nHarm.
	inst ampl: (Number readFrom: strm).
	strm skipSeparators.
	inst noPitch: (Float readFrom: strm).
	strm skipSeparators.
	inst rePitch: (Float readFrom: strm).
	strm skipSeparators.
	5 timesRepeat:				"skip 5 fields"
		[strm upToSeparator. strm skipSeparators].
	inst centroid: (Float readFrom: strm).
	fil := (dirName asFilename) filesMatching: ('*', pit, '.spect').
	fil isEmpty ifTrue: [Transcript show: 'File not found: ', (fil asString); cr.
			^inst].
	fil := fil first asFilename.
	fil exists ifFalse: [Transcript show: 'File not found: ', (fil asString); cr.
			^inst].
	istrm := fil readStream.
	[istrm atEnd] whileFalse:
		[ | amp pha |
		istrm skipSeparators.
		amp := Float readFrom: istrm.
		istrm skipSeparators.
		pha := Float readFrom: istrm.
		inst addLast: (amp @ pha).	"harms saved as points: amp @ phase"
		istrm skip: 1].
	^inst! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!


!Siren.SHARCSample methodsFor: 'accessing'!

addLast: newObject 
	"Add newObject to the end of the receiver."

	data addLast: newObject!

ampl
	"Answer the receiver's 'ampl'."

	^ampl!

ampl: anObject
	"Set the receiver's instance variable 'ampl' to be anObject."

	ampl := anObject!

centroid
	"Answer the receiver's 'centroid'."

	^centroid!

centroid: anObject
	"Set the receiver's instance variable 'centroid' to be anObject."

	centroid := anObject!

key
	"Answer the receiver's 'key'."

	^key!

key: anObject
	"Set the receiver's instance variable 'key' to be anObject."

	key := anObject!

nHarm
	"Answer the receiver's 'nHarm'."

	^nHarm!

nHarm: anObject
	"Set the receiver's instance variable 'nHarm' to be anObject."

	nHarm := anObject!

name
	"Answer the receiver's 'name'."

	^name!

name: anObject
	"Set the receiver's instance variable 'name' to be anObject."

	name := anObject!

noPitch
	"Answer the receiver's 'noPitch'."

	^noPitch!

noPitch: anObject
	"Set the receiver's instance variable 'noPitch' to be anObject."

	noPitch := anObject!

pitch
	"Answer the receiver's 'pitch'."

	^pitch!

pitch: anObject
	"Set the receiver's instance variable 'pitch' to be anObject."

	pitch := anObject!

rePitch
	"Answer the receiver's 'rePitch'."

	^rePitch!

rePitch: anObject
	"Set the receiver's instance variable 'rePitch' to be anObject."

	rePitch := anObject! !

!Siren.SHARCSample methodsFor: 'arithmetic'!

transformAmp: dBval
	"Concert a minus-dB amplitude to an amplitude scale."
	"SHARCSample someInstance transformAmp: -32.44"

	^10 raisedTo: (dBval / 20)! !

!Siren.SHARCSample methodsFor: 'converting'!

asSumOfSines
	"Answer a SOS-format description of the receiver."
	"(Function from: (((SHARCInstrument fromDir: 'tuba') samples at: #c3) asWavetable: 512)) open"
	"((SHARCInstrument fromDir: 'tuba') samples at: #c3) asSumOfSines"


	| coll count |
	coll := Array new: self size * 2.
	count := 1.
	1 to: self size do:
		[ :hn | | ha |			"harmonic loop"
		ha := self at: hn.		"get ampl/phase point"
		coll at: count put: (self transformAmp: ha x).
		coll at: (count + 1) put: (ha y).
		count := count + 2].
	^coll!

asWavetable: len
	"Answer a wavetable derived from the receiver."
	"((SHARCInstrument orchestra at: #tuba) samples at: #c3) 
			asWavetable: 512"
	"(GraphMorph new data: (((SHARCInstrument orchestra at: #tuba) 
			samples at: #c3) asWavetable: 360)) openInWorld"

	| table sca |
	table := Array new: len.				"result table"
	sca := 32768.0 / ampl asFloat.		"ampl scale"
	Cursor execute showWhile: [1 to: len do:
		[ :sa | | va in |					"sample loop"
		va := 0.0.						"samp value"
										"scaled index"
		in := (sa asFloat / len asFloat) * Float pi * 2.0.
		1 to: self size do:
			[ :hn | | ha ph |				"harmonic loop"
			ha := self at: hn.			"get ampl/phase point"
			ph := (in * hn) + ha y.		"actual phase"
			va := va + (ph sin * (self transformAmp: ha x) * sca)].
		table at: sa put: va]].
	^table! !

!Siren.SHARCSample methodsFor: 'initialize-release'!

initialize
	"Initialize the receiver for the given size."

	self initialize: 64! !

#{Siren.SHARCInstrument.SHARCHome} initialize!
