

Smalltalk.Siren defineClass: #AbstractOSCPacket
	superclass: #{Core.Object}
	indexedType: #none
	private: false
	instanceVariableNames: 'oscBytes '
	classInstanceVariableNames: ''
	imports: ''
	category: 'MusicIO-OSC'!

Siren.AbstractOSCPacket comment:
'AbstractOSCPacket is the parent of the concrete OSC packet classes.

Subclasses must implement the following messages:
	osc>>toOSCBytes:

Instance Variables:
	oscBytes	<ByteArray>  my packet contents
'!

!Siren.AbstractOSCPacket methodsFor: 'accessing'!

oscBytes

	^oscBytes!

oscSize

	^oscBytes size! !

!Siren.AbstractOSCPacket methodsFor: 'osc'!

toOSCBytes: converter 

	self subclassResponsibility.
	^self! !

!Siren.AbstractOSCPacket methodsFor: 'initialize-release'!

init

	| convertor |
	convertor := OSCByteConvertor new.
	self toOSCBytes: convertor.
	oscBytes := convertor contents.
	^self! !



Smalltalk.Siren defineClass: #OSCBundle
	superclass: #{Siren.AbstractOSCPacket}
	indexedType: #none
	private: false
	instanceVariableNames: 'messages time '
	classInstanceVariableNames: ''
	imports: ''
	category: 'MusicIO-OSC'!

Siren.OSCBundle defineSharedVariable: #MillisecToNTP
	private: false
	constant: false
	category: 'Time constants'
	initializer: '((2 raisedTo: 32) / 1000)'!

Siren.OSCBundle defineSharedVariable: #SecsInAYear
	private: false
	constant: false
	category: 'Time constants'
	initializer: '(60 * 60 * 24 * 365)'!

Siren.OSCBundle defineSharedVariable: #MillisecScale
	private: false
	constant: false
	category: 'Time constants'
	initializer: '4295000'!

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!


!Siren.OSCBundle class methodsFor: 'examples'!

example1
	"Simple example"

	^self 
		with: (Array with: OSCMessage scRun with: OSCMessage scIncreaseVolume)!

example2

	^self with: (Array with: self example1 with: OSCMessage scDecreaseVolume)! !

!Siren.OSCBundle class methodsFor: 'class initialization'!

initialize
	"Initialize the values of the shared variables."
	"OSCBundle initialize"

	MillisecScale = 4295000.
	MillisecToNTP:= ((2 raisedTo: 32) / 1000).
	SecsInAYear:= 60 * 60 * 24 * 365! !

!Siren.OSCBundle class methodsFor: 'support'!

asNTPMilliseconds: aTimestamp 
	"Convert aTimestamp to the OSC representation of the same"

	| msec |
	msec := aTimestamp millisecond * MillisecToNTP. "((2 raisedTo: 32) / 1000)"
	^msec asInteger!

asSecondsSince1900: aTimestamp 
	"Convert aTimestamp to seconds since 1900"

	| sec |
	"Gets us the number of seconds since Jan 1. 1901"
	sec := aTimestamp asSeconds.
	"sec := sec + SecsInAYear."
	"Convert that to be GMT-based"
	sec := TimeZone default convertLocalSecondsToGMT: sec.
	"Add one year worth of seconds"
	^sec + SecsInAYear. "(60 * 60 * 24 * 365)"!

timestampToOSC: aTimestamp 
	"Convert aTimestamp to the OSC representation of the same"

	| sec msec |
	sec := self asSecondsSince1900: aTimestamp.
	msec := self asNTPMilliseconds: aTimestamp.
	^(sec bitShift: 32) bitOr: msec! !

!Siren.OSCBundle class methodsFor: 'instance creation'!

with: aCollection
	^self with: aCollection at: Timestamp now!

with: aCollection at: aTimestamp
	^self new init: aCollection time: aTimestamp! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!


Siren.OSCBundle comment:
'OSCBundle represents a bundle of OSC messages

Instance Variables:
	messages	<OrderedCollection of OSCMessage>  my contents
	time	<Integer>  my action time

Shared Variables:
	MillisecScale	<Integer>  msec/year (?)
	MillisecToNTP	<Fraction>  msec scale for NTP
	SecsInAYear	<Integer>  sec/year
'!

!Siren.OSCBundle methodsFor: 'initialize-release'!

init: aCollection 
	self init: aCollection time: Timestamp now!

init: aCollection time: aTime 
	"Initialize the receiver."

	messages := aCollection.
	time := aTime.
	self init! !

!Siren.OSCBundle methodsFor: 'osc'!

timeTagToOSCBytes: aConvertor 
	"Store a time thingy into the given convertor"

	time isNil 
		ifTrue: 
			[8 timesRepeat: [aConvertor nextPut: 0].
			^self].
	(self class asSecondsSince1900: time) toOSCBytes: aConvertor.
	(self class asNTPMilliseconds: time) toOSCBytes: aConvertor!

toOSCBytes: aConvertor 
	"^self"

	'#bundle' toOSCBytes: aConvertor.
	self timeTagToOSCBytes: aConvertor.
	messages
		do: 
			[:aMessage | 
			aMessage oscSize toOSCBytes: aConvertor.
			aConvertor nextPutAll: aMessage oscBytes]! !



Smalltalk.Siren defineClass: #OSCByteConvertor
	superclass: #{Core.Object}
	indexedType: #none
	private: false
	instanceVariableNames: 'packetData '
	classInstanceVariableNames: ''
	imports: ''
	category: 'MusicIO-OSC'!

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!


!Siren.OSCByteConvertor class methodsFor: 'instance creation'!

new

	^super new init! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!


Siren.OSCByteConvertor comment:
'Instances of OSCByteConvertor translate between different OSC formats.

Instance Variables:
	packetData	<PositionableStream>  my contents
'!

!Siren.OSCByteConvertor methodsFor: 'initialize-release'!

init
	packetData := ByteArray new writeStream.
	^self! !

!Siren.OSCByteConvertor methodsFor: 'stream'!

contents
	^packetData contents!

next: t1 put: t2 
	^packetData next: t1 put: t2!

nextPut: t1 
	^packetData nextPut: t1!

nextPutAll: t1 

	^packetData nextPutAll: t1!

nextPutType: char
"	Transcript show: (String with: char); space."
	^self nextPut: char asInteger!

position
	^packetData position! !



Smalltalk.Siren defineClass: #OSCMessage
	superclass: #{Siren.AbstractOSCPacket}
	indexedType: #none
	private: false
	instanceVariableNames: 'address arguments '
	classInstanceVariableNames: ''
	imports: ''
	category: 'MusicIO-OSC'!

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!


!Siren.OSCMessage class methodsFor: 'instance-creation'!

for: addr

	^self new initAddress: addr arguments: #()!

for: addr with: args 
	"Answer a TOM with the given address and arguments"

	^self new initAddress: addr arguments: args! !

!Siren.OSCMessage class methodsFor: 'examples'!

example1
	"OSCMessage example1"

	^self for: '/example1' with: #(100)!

example2
	"OSCMessage example2"

	^self for: '/example2' with: #('tester' 10.4)!

example3
	"OSCMessage example3"

	^self for: '/example3' with: #(20 30 'blah')! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!


Siren.OSCMessage comment:
'OSCMessages are concrete old-format (untyped) OSC messages

Instance Variables:
	address	<String>  my OSC cmomand address
	arguments	<Collection>  the arguments
'!

!Siren.OSCMessage methodsFor: 'printing'!

printOn: aStream

	aStream nextPutAll: 'OSC: ', address, '  ', arguments printString.! !

!Siren.OSCMessage methodsFor: 'osc'!

addressToOSCBytes: convertor 
	"Convert the address to the OSC format"
	address toOSCBytes: convertor.
	^self!

argumentsToOSCBytes: convertor 
	"Add the type tags, then the arguments"

	arguments do: [:each | each toOSCBytes: convertor].
	^self!

toOSCBytes: converter 
	"Convert myself to OSC format"

	self addressToOSCBytes: converter.
	arguments notEmpty ifTrue: [self argumentsToOSCBytes: converter].
	^self!

typesToOSC: converter

	| index numPad |
	arguments isEmpty ifTrue: [^self].
	arguments do: [:each | each toOSCTypeOn: converter].
	index := 1.
	numPad := 4 - (converter position \\ 4).
	"This isn't very ST -- should be numPad do:[converter nextPut: 0]"
	[index <= numPad]
		whileTrue: 
			[converter nextPut: 0.
			index := index + 1].
	^self! !

!Siren.OSCMessage methodsFor: 'initialize-release'!

initAddress: t1 arguments: t2 

	address := t1.
	arguments := t2.
	self init.
	^self! !



Smalltalk.Siren defineClass: #OSCVoice
	superclass: #{Siren.NotelistVoice}
	indexedType: #objects
	private: false
	instanceVariableNames: 'port '
	classInstanceVariableNames: ''
	imports: ''
	category: 'MusicIO-OSC'!

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!


!Siren.OSCVoice class methodsFor: 'parameter maps'!

defaultPMap
	"Answer the default parameterMap for use with OSC."

	^[ :e |  | arr |
	arr := Array
			with: e duration asSec value
			with: e pitch asHz value
			with: e ampl asRatio value.
	TypedOSCMessage for: '/note' with: arr]!

pMapForCSLAdditive
	"Answer the default parameterMap for use with the CSL sum-of-sines instrument.
		This creates an OSC bundle with a 'ps' message for the spectrum followed
		by a 'pn' message to play a note.
		CSL SOSInstrument args: dur, ampl, freq, pos, [att, dec, sus, rel] "
	"OSCVoice sosExample1"	
	"EventScheduler flush"

	^[ :e | | arr spect |
	spect := e at: #spectrum.
	spect := spect copyFrom: 1 to: 10.			"just the first 5 partials for now"
	arr := Array new: 4.
	arr at: 1 put: e duration asSec value.			"required fields"
	arr at: 2 put: e ampl value.
	arr at: 3 put: e pitch asHz value.
	arr at: 4 put: e pos.
													"optional fields"
"	arr at: 5 put: e att.
	arr at: 6 put: e dec.
	arr at: 7 put: e sus.
	arr at: 8 put: e rel."
"	Transcript show: arr printString; cr."
	OSCBundle 
		with: (Array 								"spectrum set message"
			with: (TypedOSCMessage for: '/i1/ps' with: spect)
													"note-on message"
			with: (TypedOSCMessage for: '/i1/pn' with: arr))]!

pMapForCSLFM
	"Answer the default parameterMap for use with the CSL FM example instrument."
	"CSL FMInstrument has args: dur, ampl, c_fr, m_fr, ind, pos, att, dec, sus, rel, i_att, i_dec, i_sus, i_rel"

	| inst cnt |
	cnt := 1.
	^[ :e | | arr |
	arr := Array new: 14.				"set up the parameter map"
	arr at: 1 put: e duration asSec value.
	arr at: 2 put: e ampl value.
	arr at: 3 put: e pitch asHz value.
	arr at: 4 put: e pitch asHz value * e ratio.
	arr at: 5 put: e modIndex.
	arr at: 6 put: e pos.
	arr at: 7 put: e att.
	arr at: 8 put: e dec.
	arr at: 9 put: e sus.
	arr at: 10 put: e rel.
	arr at: 11 put: e iatt.
	arr at: 12 put: e idec.
	arr at: 13 put: e isus.
	arr at: 14 put: e irel.
"	Transcript show: arr printString; cr."
	inst := '/i', cnt printString, '/pn'.
	cnt := cnt +1.
	cnt > 4 ifTrue: [cnt := 1].
	TypedOSCMessage for: inst with: arr]!

pMapForCSLSimpleFM
	"Answer the default parameterMap for use with the CSL FM example instrument."
	"CSL FMInstrument has args: dur, ampl, c_fr, m_fr, ind, pos"

	^[ :e | | arr |
	arr := Array new: 6.				"set up the parameter map"
	arr at: 1 put: e duration asSec value.
	arr at: 2 put: e ampl asRatio value.
	arr at: 3 put: e pitch asHz value.
	arr at: 4 put: e pitch asHz value * e ratio.
	arr at: 5 put: e modIndex.
	arr at: 6 put: e pos.
"	Transcript show: arr printString; cr."
	TypedOSCMessage for: e inst with: arr]!

pMapForCSLSnd
	"Answer the default parameterMap for use with the CSL FM example instrument."
	"CSL SndFileInstrument has args: ampl, pos, start, stop"

	^[ :e | | arr |
	arr := Array new: 4.				"set up the parameter map"
	arr at: 1 put: e ampl value.
	arr at: 2 put: e pos.
	arr at: 3 put: e start.
	arr at: 4 put: e stop.
"	Transcript show: arr printString; cr."
	TypedOSCMessage for: e inst with: arr]!

pMapForMIDI
	"Answer the default parameterMap for use with OSC-to-MIDI. 
	In this class, we create and return a OSCMessage with data taken from the given event."

	^[ :e | 
	| arr timestamp |
	arr := Array
			with: (e voice isInteger ifTrue: [e voice] ifFalse: [1])
			with: e pitch asMIDI value
			with: e ampl asMIDI value.
	timestamp := Timestamp now.
	OSCBundle with: (Array 
			with: (TypedOSCMessage for: '/osc/midi/out/noteOn' with: arr)
			with: (OSCBundle 
				with: (Array with: (TypedOSCMessage for: '/osc/midi/out/noteOff' with: arr))
				at: (timestamp addMilliseconds: e duration asMsec value)))
		at: timestamp]!

pMapForMIDItoFM
	"Answer the default parameterMap for use with the CSL FM example instrument."
	"CSL FMInstrument has args: dur, ampl, pch, index, pos"

	^[ :e | | arr |
	arr := Array new: 6.				"set up the parameter map"
	arr at: 1 put: e duration asSec value.
	arr at: 2 put: e ampl asRatio value.
	arr at: 3 put: e pitch asHz value.
	arr at: 5 put: e modIndex.
	arr at: 6 put: e pos.
"	Transcript show: arr printString; cr."
	TypedOSCMessage for: e inst with: arr]!

pMapWithBundle
	"Answer the default parameterMap for use with OSC-to-MIDI. In this class, we create and return a TypedOSCMessage with data taken from the given event. This allows us to have other versions that create OSC bundles."

	^[ :e | | arr |
	arr := Array with: 1
			with: e pitch asMIDI value
			with: e ampl asMIDI value.
	OSCBundle 
		with: (Array with: (TypedOSCMessage for: '/osc/midi/out/noteOn' with: arr)
				with: (OSCBundle 
						with: (TypedOSCMessage for: '/osc/midi/out/noteOff' with: arr)
						at: (Timestamp now addMilliseconds: e duration asMsec value)))]! !

!Siren.OSCVoice class methodsFor: 'examples'!

fmExample1
	"Play a few random notes on the CSL FM instrument"
	"OSCVoice fmExample1"
	"Startup up the CSL OSC demo (or dumpOSC) and run these"
	"CSL FMInstrument has args: dur, ampl, c_fr, m_fr, ind, pos, att, dec, sus, rel, i_att, i_dec, i_sus, i_rel"

	| events voice  |
	events := (EventList randomExample: 15 					"create the event list"
		from: ((#duration: -> (0.2 to: 0.5)), 
			(#pitch: -> (110.1 to: 220.1)), 
			(#ratio: -> (0.8 to: 5.0)),
			(#ampl: -> (0.2 to: 0.8)), 
			(#modIndex: -> (0.0 to: 8.0)), 
			(#pos: -> (-0.7 to: 0.7)),
			(#att: -> (0.01 to: 0.05)),
			(#dec: -> (0.03 to: 0.05)),
			(#sus: -> (0.3 to: 0.7)),
			(#rel: -> (0.1 to: 0.15)),
			(#iatt: -> (0.05 to: 0.1)),
			(#idec: -> 0.005),
			(#isus: -> 1.0),
			(#irel: -> 0.1))).
	voice := self default.
	voice  instrument: '/i1/pn'.										"default instrument"
	voice parameterMap: self pMapForCSLFM.					"plug in the parameter map"
	events voice: voice.
	events play.!

fmExample2
	"Play molto legato notes on 4 CSL FM instruments and loop until interrupted "
	"OSCVoice fmExample2"		"EventScheduler flush"
	"Startup up the CSL OSC demo and run these"
	"CSL FMInstrument has args: dur, ampl, c_fr, m_fr, ind, pos"

	| evList voice |						"create the event list"
	evList := (EventList randomExample: 20 
		from: ((#duration: -> 1.0),
				(#pitch: -> (40.1 to: 100.1)),
				(#ratio: -> (0.8 to: 1.5)),
				(#ampl: -> (0.1 to: 0.25)), 
				(#modIndex: -> (1.0 to: 4.0)),
				(#pos: -> (-1.0 to: 1.0)))).
	1 to: evList events size do: 
		[ :ind | | ev |			"plug in instruments and expand durations (molto legato)"
		ev := (evList events at: ind) event.
		ev inst: ('/i', (ind - 1 \\ 4 + 1) printString, '/pn').
		ev duration: ev duration * 4].
	voice := self onPort: (OSCPort to: #[127 0 0 1] port: 54321).	"edit this to taste."
	voice parameterMap: self pMapForCSLSimpleFM.	"plug in the parameter map"
	evList voice: voice.
	evList loop										"loop until you stop the scheduler"!

fmExample3
	"Play a long CSL FM note and apply some real-time control functions to it"
	"OSCVoice fmExample3"
	"Startup up the CSL OSC demo and run these"
	"CSL FMInstrument has args: dur, ampl, c_fr, m_fr, ind, pos"

	| evList voice voice2 gliss map2 pan map3 voice3 |
	evList := ((EventList newNamed: #LongNote) add:
		(10.0 sec, 66.0 Hz, -3 dB, (#pos -> -1.0), (#ratio -> 1.17), 
				(#modIndex -> 2.64), (#inst -> '/i1/pn'))).
	voice := self default.
	voice parameterMap: self pMapForCSLSimpleFM.	"plug in the parameter map"
	evList voice: voice.
	evList play.										"start the note"

	2 wait.			"pause 2 sec"

"Now make a glissando down"
	gliss := FunctionEvent new function: (LinearFunction from: #((0 66.0) (8 30.0))).
	gliss interval: 0.1 sec.						"10 per sec"
	map2 :=  [ :e | TypedOSCMessage for: '/i1/cf' with: (Array with: e value)].
	voice2 := self default.
	voice2 parameterMap: map2.					"plug in the parameter map"
	gliss voice: voice2.
	gliss play.

"and pan it"
	pan := FunctionEvent new function: (LinearFunction from: #((0 -1.0) (8 1.0))).
	pan interval: 0.1 sec.						"10 per sec"
	map3 :=  [ :e | TypedOSCMessage for: '/i1/po' with: (Array with: e value)].
	voice3 := self default.
	voice3 parameterMap: map3.					"plug in the parameter map"
	pan voice: voice3.
	pan play.!

fmExample4
	"Play an FM bell using CSL; fork a block that plays a note and waits a bit; 
		stop the scheduler to stop the block."
	"OSCVoice fmExample4"

	| evList voice rand |
	rand := Random new.
	EventScheduler run.
	[[EventScheduler isRunning] whileTrue:		"repeat block to play a bell sound"
		[evList := ((EventList newNamed: #Bell) add:
		(3.0 sec, (rand nextFrom: 1000.0 to: 1200.0) Hz , -18 dB, 
				(#pos -> (rand nextFrom: -1.0 to: 1.0)), 
				(#ratio -> 1.414), 
				(#modIndex -> 2.0), 
				(#inst -> '/i9/pn'))).
		voice := OSCVoice onPort: (OSCPort to: #[127 0 0 1] port: 54321).
		voice parameterMap: self pMapForCSLSimpleFM.	"plug in p-map"
		evList voice: voice.
		evList play.
		(rand nextFrom: 5 to: 10) wait]] forkAt: (Processor userBackgroundPriority - 1)!

functionExample
	"Play a function out to OSC"
	"OSCVoice functionExample"

	| event voice map |							"create the function and event"
	event := FunctionEvent new function: (LinearFunction default scaleBy: 5@1).
	event interval: 0.25 sec.						"4 per sec"
	map :=  [ :e | TypedOSCMessage for: '/osc/1/ampl' with: (Array with: e value)].
	voice := self default.
	voice parameterMap: map.					"plug in the parameter map"
	event voice: voice.
	event play!

midiScaleExample
	"OSCVoice midiScaleExample"

	 | list voice |
	list := EventList scaleFrom: 48 to: 60 in: 2.5.
	voice := self default.
	list voice: voice.
	list play.!

sndExample1
	"Play random notes on the CSL sound file instruments"
	"OSCVoice snd_Example1"
	"Startup up the CSL OSC demo and run these"
	"CSL SndFileInstrument has args: ampl, pos, start, stop"

	| events voice rand |
	rand := Random new.
	events := EventList named: EventList nextName.
	25 timesRepeat:
		[ | in |
		in := rand nextIntFrom: 5 to: 8.
		events add: (MusicEvent new duration: (rand nextFrom: 0.1 to: 0.2); 
				inst: ('/i', in printString, '/pn');
				ampl: (rand nextFrom: 0.05 to: 0.5); 
				pos: (rand nextFrom: -1.0 to: 1.0) ; 
				start: (rand nextFrom: 0.0 to: 0.5); 
				stop: (rand nextFrom: 0.5 to: 1.0))].
	voice := self default.
	voice parameterMap: self pMapForCSLSnd.	"plug in the parameter map"
													"load 4 sound files"
	voice send: '/i5/fi' args: (Array with: (SirenUtility findFile: 'moon.snd')).
	voice send: '/i6/fi' args: (Array with: (SirenUtility findFile: 'wet.snd')).
	voice send: '/i7/fi' args: (Array with: (SirenUtility findFile: 'round.snd')).
	voice send: '/i8/fi' args: (Array with: (SirenUtility findFile: 'shine.snd')).
	events voice: voice.
	events play!

sndExample2
	"Play random notes on the CSL sound file instruments; loop until interrupted"
	"OSCVoice sndExample2"		"EventScheduler flush"
	"Startup up the CSL OSC demo and run these"
	"CSL SndFileInstrument has args: ampl, pos, start, stop"

	| events voice rand |
	rand := Random new.
	events := EventList named: EventList nextName.
	25 timesRepeat:
		[ | in |
		in := rand nextIntFrom: 5 to: 8.
		events add: (MusicEvent new duration: (rand nextFrom: 0.1 to: 0.2); 
				inst: ('/i', in printString, '/pn');
				ampl: (rand nextFrom: 0.01 to: 0.3); 
				pos: (rand nextFrom: -1.0 to: 1.0) ; 
				start: (rand nextFrom: 0.0 to: 0.5); 
				stop: (rand nextFrom: 0.5 to: 1.0)).
		(rand next > 0.5) 							"add 50% rests"
			ifTrue: [events add: (DurationEvent new duration: rand next sec)]].

	voice := self default.
	voice parameterMap: self pMapForCSLSnd.	"plug in the parameter map"
													"load voice files into instruments 5-8"
	voice send: '/i5/fi' args: (Array with: (SirenUtility findFile: 'moon.snd')).
	voice send: '/i6/fi' args: (Array with: (SirenUtility findFile: 'wet.snd')).
	voice send: '/i7/fi' args: (Array with: (SirenUtility findFile: 'round.snd')).
	voice send: '/i8/fi' args: (Array with: (SirenUtility findFile: 'shine.snd')).
	events voice: voice.							"set-up and loop list"
	events loop!

sosExample1
	"Play random notes on the CSL sum-of-sines instruments; loop until interrupted"
	"OSCVoice sosExample1"	
	"EventScheduler flush"
	"Startup up the CSL/OSC additive and run these"
	"CSL AdditiveInstrument has args: dur, ampl, freq, pos, att, dec, sus, rel"

	| events voice rand instr notes pitches freq0 key spect |
	rand := Random new.
	instr := SHARCInstrument fromDir: 'tuba'.			"load a tuba sample"
	notes := Dictionary new.
	instr samples associationsDo:						"make a dict of sample freq -> SOS-array"
		[ :ass |
		notes at: (ass key pitch asHz value) put: (ass value asSumOfSines)].
	pitches := notes keys asSortedCollection. "get the pitches in Hz"
	freq0 := pitches removeFirst.
	pitches := (pitches collect: [ :pt | | int | 				"make a list of freq-interval -> base-freq"
			int := freq0 to: pt. 
			freq0 := pt. 
			int]) asSortedCollection: [ :x :y | x first <= y first ].
	events := EventList EventList newNamed.		"temp event list"
	1 to: 25 do:										"add 25 notes + some rests"
		[ :counter | | pch |
		pch := rand nextFrom: 80.0 to: 440.0.
			key := pitches detect: [ :pt | pt includes: pch] ifNone: [nil].
			key ifNil: [pch < pitches first first
				ifTrue: [spect := notes at: pitches first first]
				ifFalse: [pch > pitches last last
					 ifTrue: [spect := notes at: pitches last last]]]
			ifNotNil: [spect := notes at: key first].
		events add: (MusicEvent new 
				duration: (rand nextFrom: 0.1 to: 0.2); 
				inst: ('/i', (counter \\ 16 + 1) printString);
				ampl: (rand nextFrom: 0.01 to: 0.3); 
				pitch: pch; 
				pos: (rand nextFrom: -1.0 to: 1.0);
				spectrum: spect).
		(rand next > 0.8) 							"add 20% rests"
			ifTrue: [events add: (DurationEvent new duration: (rand next / 4) sec)]].

	voice := self default.
	voice parameterMap: self pMapForCSLAdditive.	"plug in the parameter map"
													"load voice files into instruments 5-8"
	events voice: voice.							"set-up and loop list"
	events play! !

!Siren.OSCVoice class methodsFor: 'instance creation'!

default
	"Answer an OSC voice for use with OSC-to-MIDI by default."

	^self onPort: OSCPort default!

localhost
	"Answer an instance on the local host"

	^self onPort: OSCPort localhost!

map: mapSelector
	"Answer a default instance that uses the given parameter map name"
	"OSCVoice map: #pMapForCSLSimpleFM"

	| inst |
	inst := self default.
	inst parameterMap: (self perform: mapSelector).
	^inst!

onPort: pt
	"Answer an instance on the given port"

	| me |
	(me := self new initialize) port: pt.
	^me!

scHost
	"Answer the default voice for SC over OSC"

	^self onPort: OSCPort scHost! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!


Siren.OSCVoice comment:
'An OSCVoice can play events out to an OSC server using a predefined parameter mapping block to generate the OSC message.

Instance Variables:
	port	<Siren.OSCPort>  my output port
'!

!Siren.OSCVoice methodsFor: 'events'!

oscMessageFrom: event 
	"Answer a message for the given event by passing it to my parameter-mapper block"

	^parameterMap value: event!

play: anEL 
	"Expand the list and play it now."

	self play: anEL at: Time microsecondClock!

playAssociation: ass in: list 
	"Play the association..."

	| realTime |
	realTime := ass key asMsec value.
	self waitTill: realTime.
	port send: (parameterMap value: ass value).
	^self
"
	stream := OrderedCollection new.
	parameterMap do: [ :item | self
			mapProperty: item
			of: ass
			within: list].
	stream size = 0 ifTrue: [^self].
	stream size = 1 ifTrue: [^port send: (stream at: 1)].
"!

playEvent: event at: start 
	"Expand the list and play it at the given time."

	start ifNotNil:
		[self waitTill: start].
	event hasItems ifTrue: [^self play: event at: start].
	port send: (self oscMessageFrom: event)!

waitTill: time

	| now |
	time ifNotNil: 
			[now := Time microsecondClock.
			time > now
				ifTrue: [(Delay forMicroseconds: time - now) wait]
				ifFalse: [nil]].
	^self! !

!Siren.OSCVoice methodsFor: 'accessing'!

port
	"Return the OSCPort"

	^port!

port: aPort 
	"Set the OSCPort"

	port := aPort.
	^self! !

!Siren.OSCVoice methodsFor: 'utilities'!

send: command args: args
	"Send an OSC command with the given arguments"

	port send: (TypedOSCMessage for: command with: args)! !



Smalltalk.Siren defineClass: #TypedOSCMessage
	superclass: #{Siren.OSCMessage}
	indexedType: #none
	private: false
	instanceVariableNames: ''
	classInstanceVariableNames: ''
	imports: ''
	category: 'MusicIO-OSC'!

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!


!Siren.TypedOSCMessage class methodsFor: 'examples'!

changeFreq
	"TypedOSCMessage changeFreq"

	^self for: '/freq' with: #(440)!

scDecreaseVolume
	"TypedOSCMessage scDecreaseVolume"

	^self for: '/sc/mixer/volume' with: #(1 0.2)!

scIncreaseVolume
	"TypedOSCMessage scIncreaseVolume"

	^self for: '/sc/mixer/volume' with: #(1 1.0)!

scRun
	"TypedOSCMessage scRun"

	^self for: '/sc/run'!

scStop
	"TypedOSCMessage scStop"

	^self for: '/sc/stop'!

start
	"TypedOSCMessage start"

	^self for: '/start'! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!


Siren.TypedOSCMessage comment:
'A TypedOSCMessage represents the new form of (typed) OSC messages'!

!Siren.TypedOSCMessage methodsFor: 'osc'!

argumentsToOSCBytes: convertor 
	"Convert the args and type string to OSC format"

	convertor nextPut: $, asInteger.
	self typesToOSC: convertor.
	super argumentsToOSCBytes: convertor.
	^self!

typesToOSC: converter 
	"Convert the arguments to an OSC type string."

	| t2 t3 |
	arguments isEmpty ifTrue: [^self].
	arguments do: [:t4 | t4 toOSCTypeOn: converter].
	t2 := 1.
	t3 := 4 - (converter position \\ 4).
	[t2 <= t3]
		whileTrue: 
			[converter nextPut: 0.
			t2 := t2 + 1].
	^self! !



Smalltalk.Siren defineClass: #OSCPort
	superclass: #{Siren.PortModel}
	indexedType: #none
	private: false
	instanceVariableNames: 'socket address '
	classInstanceVariableNames: ''
	imports: ''
	category: 'MusicIO-OSC'!

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!


!Siren.OSCPort class methodsFor: 'examples'!

demo
	"OSCPort demo"

	self sendStart.
	self sendFreq.
	self sendStop.
	^self!

demo2
	"OSCPort demo2"

	self scHost send: TypedOSCMessage start.
	self scHost send: TypedOSCMessage changeFreq.
	self scHost send: TypedOSCMessage scStop.
	^self!

sendFreq
	"PSCPort sendFreq"

	self localhost send: TypedOSCMessage changeFreq.
	^self!

sendStart
	"OSCPort sendstop"

	self localhost send: TypedOSCMessage start.
	^self!

sendStop
	"Send a stop message"

	self localhost send: TypedOSCMessage scStop.
	^self! !

!Siren.OSCPort class methodsFor: 'instance-creation'!

cslHost
	"Answer the default port for CSL"

	^self to: (IPSocketAddress hostName: 'localhost' port: 54321)!

default
	"Answer the default instance"

	^self to: (IPSocketAddress hostAddress: self defaultIP port: self defaultPort)!

localhost
	"Answer an OSC port on the local host"

	^self to: (IPSocketAddress hostAddress: (ByteArray
				with: 127
				with: 0
				with: 0
				with: 1)
			port: self defaultPort)!

scHost
	"Answer the default OSC server reference"

	^self to: (IPSocketAddress hostAddress: (ByteArray
				with: 192
				with: 168
				with: 61
				with: 1)
			port: self defaultSCOSCPort)!

to: t1 
	"Open a port on the given device"

	^self new init: t1!

to: ip port: port
	"^an OSCPort with the given attributes"
	"OSCPort to: #[127 0 0 1] port: 54321"

	^self to: (IPSocketAddress hostAddress: ip port: port)!

toHostName: t1 
	"Answer an instance on the given host"

	^self to: (IPSocketAddress hostName: t1 port: self defaultPort)!

toHostName: aHostName portNumber: aPort 
	"^an OSCPort 
	Convenience method"

	^self to: (IPSocketAddress hostName: aHostName port: aPort)!

toLocalhostPortNumber: aPort 
	"^an OSCPort 
	Convenience method"

	^self toHostName: 'localhost' port: aPort! !

!Siren.OSCPort class methodsFor: 'defaults'!

defaultIP
	"Answer the class var default"

	^SirenUtility defaultOSCHost!

defaultIP: value
	"Set the class var default"

	SirenUtility defaultOSCHost: value!

defaultPort
	"Answer the class var default"

	^SirenUtility defaultOSCPort!

defaultPort: value
	"Set the class var default"

	SirenUtility defaultOSCPort: value!

defaultSCOSCPort
	"Answer the default port for OSC"

	^57123! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!


Siren.OSCPort comment:
'An OSCPort represents a connection to an OSC client.

Instance Variables:
	socket <SocketAccessor>  how am I connected?
	address <IPSocketAddress>  where do I go?

Shared Variables:
	DefaultIP <ByteArray>  where''s my default server?
	DefaultPort	 <Integer>  where''s my default server?
'!

!Siren.OSCPort methodsFor: 'accessing'!

portNumber: newPortNum 
	"Reset the receiver's UDP socket port number"

	address port: newPortNum! !

!Siren.OSCPort methodsFor: 'actions'!

send: aMessage 
	"Send something"

	SirenUtility log: aMessage printString level: 1.
	self critical: [socket sendTo: address buffer: aMessage oscBytes]! !

!Siren.OSCPort methodsFor: 'initialize-release'!

init: t1 
	"Set up"

	socket := SocketAccessor newUDP.
	address := t1.
	^self! !

#{Siren.OSCBundle.MillisecToNTP} initialize!

#{Siren.OSCBundle.SecsInAYear} initialize!

#{Siren.OSCBundle.MillisecScale} initialize!

#{Siren.OSCBundle} initialize!
