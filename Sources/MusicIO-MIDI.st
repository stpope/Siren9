

Smalltalk.Siren defineClass: #MIDIPacket
	superclass: #{Core.Object}
	indexedType: #none
	private: false
	instanceVariableNames: 'length time flags duration data '
	classInstanceVariableNames: ''
	imports: '
			private MIDICommands.*
			'
	category: 'MusicIO-MIDI'!

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!


!Siren.MIDIPacket class methodsFor: 'instance creation'!

bytesFor14BitValue: val
	"Answer a two-element array with the 14-bit values that correspond to the given value."
	"val should be +- 8192"

	| int |
	val abs > 8191
		ifTrue: [self error: '14-bit value out of range.'].
	int := val + 8192.
	^Array with: (int bitAnd: 16r7F) with: ((int bitShift: -7) bitAnd: 16r7F)!

fromBytes: aByteArray
	"Answer a new instance of a MIDI packet instantiated from the given byte array."

	^super new data: aByteArray!

fromInt: anInt at: aTime
	"Answer a new instance of a MIDI packet instantiated from the given 3-byte long value."

	| bytes |
	bytes := ByteArray new: 3.
	bytes at: 3 put: ((anInt bitShift: -16) bitAnd: 16rff).
	bytes at: 2 put: ((anInt bitShift: -8) bitAnd: 16rff).
	bytes at: 1 put: (anInt bitAnd: 16rff).
	^(self new data: bytes) time: aTime!

new
	"Answer a new instance."

	^super new initialize!

new: size
	"Answer a new instance with a data array of the given size."

	^self fromBytes: (ByteArray new: size)!

setPitch: p dur: d loudness: vol
	"Answer an instance of the class with the given parameters."

	^self new pitch: p; velocity: vol; duration: d! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!


Siren.MIDIPacket comment:
'A MIDIPacket represents a simple MIDI datagram with a time-stamp and a data array.

Instance Variables
	data <ByteArray> The MIDI data bytes (may include a MIDI command and running status messages)
	length <Integer> The number of meaningful bytes in the data
	time <Integer> The msec timestamp when the packet was created or received.
	flags <Integer> Any ''flags'' received from the MIDI driver.
	duration <Integer> my event''s length

Pool dictionaries:
	MIDICommands <Dictionary of (command symbol -> octet)> e.g., (#noteOn -> 16r90)
		(It is initialized by class MIDIPort.)

See the class comment in MIDIPort for details.
'!

!Siren.MIDIPacket methodsFor: 'accessing'!

ampl
	"Answer the receiver's MIDI velocity."

	^data at: 3!

ampl: a
	"Set the receiver's MIDI velocity."

	data at: 3 put: a!

channel
	"Answer the receiver's MIDI channel."

	^(data at: 1) bitAnd: 16r0F!

command
	"Answer the receiver's MIDI command nibble."

	^(data at: 1) bitAnd: 16rF0!

data
	"Answer the receiver's 'data' byte array."

	^data!

data: anObject
	"Set the receiver's instance variable 'data' to be anObject."

	data := anObject!

duration
	"Answer the receiver's duration."

	^duration!

duration: d
	"Set the receiver's duration."

	duration := d!

key
	"Answer the receiver's MIDI key number."

	^data at: 2!

key: k
	"Set the receiver's MIDI key number."

	^data at: 2 put: k!

length
	"Answer the receiver's 'length'."

	^length!

length: anObject
	"Set the receiver's instance variable 'length' to be anObject."

	length := anObject!

pitch
	"Answer the receiver's MIDI key number."

	^data at: 2!

pitch: aValue
	"Set the receiver's MIDI key number."

	data at: 2 put: aValue!

second: aValue
	"Set the receiver's MIDI key number."

	data at: 2 put: aValue!

setPitch: p dur: d loudness: vol
	"Answer an instance of the class with the given parameters."

	self pitch: p; velocity: vol; duration: d!

status: s
	"Set the receiver's MIDI command."

	data at: 1 put: s!

third: aValue
	"Set the receiver's MIDI key velocity."

	data at: 3 put: aValue!

time
	"Answer the receiver's 'time'."

	^time!

time: anObject
	"Set the receiver's instance variable 'time' to be anObject."

	time := anObject!

vel
	"Answer the receiver's MIDI velocity."

	^data at: 3!

vel: v
	"Set the receiver's MIDI velocity."

	^data at: 3 put: v!

voice
	"Answer the receiver's MIDI channel."

	^(data at: 1) bitAnd: 16r0F!

voice: v
	"Set the receiver's MIDI channel."

	(data at: 1) put: (((data at: 1) bitAnd: 16rF0) bitOr: v)! !

!Siren.MIDIPacket methodsFor: 'printing'!

print: x on: aStream
	"Store a two-digit hexadecimal version of the 8-bit argument x on the stream."

	| digs |
	digs := '01234567890ABCDEF'.
	aStream nextPut: (digs at: ((x bitAnd: 16r00F0) bitShift: -4) + 1).
	aStream nextPut: (digs at: (x bitAnd: 16r000F) + 1)!

printOn: aStream
	"Store a readable version of the receiver on the argument."

	length ifNil: [length := data size].
	aStream nextPutAll: (MIDICommands keyAtValue: (data first bitAnd: 16rF0) ifAbsent: ['unknown status']).
	aStream nextPutAll: "(time isNil
			ifFalse: [' t: ', time printString]
			ifTrue: ['']), "
		((flags isNil and: [flags ~= 0])
			ifFalse: [' f: ', flags printString]
			ifTrue: ['']), 
		' d: ['.
	1 to: length do:
		[ :ind | 
		self print: (data at: ind) on: aStream.
		aStream space].
	aStream skip: -1; nextPut: $]! !

!Siren.MIDIPacket methodsFor: 'initialize release'!

initialize
	"Set the receiver's time stamp"

	time := Time microsecondClock! !



Smalltalk.Siren defineClass: #MIDIPort
	superclass: #{Siren.PortModel}
	indexedType: #none
	private: false
	instanceVariableNames: 'inputData readProcess '
	classInstanceVariableNames: ''
	imports: '
			private MIDICommands.*
			private MIDIioctls.*
			private GeneralMIDIMap.*
			private GeneralMIDIDrums.*
			'
	category: 'MusicIO-MIDI'!

Siren.MIDIPort defineSharedVariable: #Streams
	private: false
	constant: false
	category: 'As yet unclassified'
	initializer: nil!

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!


!Siren.MIDIPort class methodsFor: 'message tests'!

functionExample
	"Demonstrate control commands by playing a note and making a crescendo with the volume pedal."
	"MIDIPort functionExample"

"Set the sound to organ."
	| event |
	MIDIPort default openOutput; programChange: 0 to: 'Church Organ'.
"Play a note."
	(5 sec, 60 key, 40 velocity, (#voice -> 0)) play.
"Fade it."
	event := FunctionEvent new function: (LinearFunction from: #((0 40) (4 120))).
	event interval: 0.2 sec.							"5 updates per sec"
	event controller: 4.								"tell it what to do, i.e., its MIDI controller"
	event voice: 0.
	event play!

testBend
	"Demonstrate pitch-bend by playing two notes and bending them."
	"MIDIPort testBend"

	| port |
	port := self new.
	port openOutput.
"Set the recorder instrument."
	port programChange: 0 to: 'Recorder'.
	port programChange: 1 to: 'Recorder'.
"Play two notes."
	port play: 76 dur: 5000 amp: 60 voice: 0.
	port play: 80 dur: 5000 amp: 60 voice: 1.
"Bend them--one up, one down."
	0 to: 250 do:
		[ :i |
		port pitchBend: 0 to: 4096 + (i * 16).
		port pitchBend: 1 to: 4096 - (i * 16).
		(Delay forMilliseconds: 5) wait].
	2 wait.
	port close.!

testControlContinuous
	"Demonstrate control commands by playing a note and making a crescendo with the volume pedal."
	"MIDIPort testControlContinuous"

	| port |
	port := self new.
	port openOutput.
"Set the sound to organ."
	port programChange: 0 to: 'Church Organ'.
"Play a note."
	port play: 60 dur: 5000 amp: 30 voice: 0.
"Fade it."
	0 to: 120 do:
		[ :i |
		port controlChange: 0 controller: 4 to: i.
		(Delay forMilliseconds: 30) wait].
	port close.!

testProgramChange
	"Demonstrate program change by setting up an organ instrument to play on."
	"MIDIPort testProgramChange"

	| port |
	port := self default.
	port open.
"Set the flute instrument."
	port programChange: 0 to: 'Church Organ'.
"Play a note."
	port play: 72 dur: 1000 amp: 70 voice: 0.
	port play: 76 dur: 900 amp: 70 voice: 0.!

testSysex
	"Demonstrate system exclusive commands by loading the Santur scale
	and playing a scale."
	"Note that this is a Roland GS sysEx, but it should work on QuickTime Musical Instruments."
	"MIDIPort testSysex"

	| port command |
	port := self default.
	port open.
"Set the flute instrument."
	port programChange: 0 to: 'Sitar'.
"Down-load an alternate tuning scale."
	command := #(16r41 16r10 16r42 16r12 16r40 16r11 "address"
			16r40 16r40 16r72 16r40 16r40 16r0E 16r40 16r40 16r40 16r0E 16r40 16r40 "scale"
			16r0E 16r53 "checksum").
	port sysex: command.
"Play a scale."
	MIDIPort testAScale! !

!Siren.MIDIPort class methodsFor: 'input tests'!

dumpExample
	"Set up a MIDI dump object as a dependent of the input port. Dump for 10 seconds,
	then turn off. The default update: method just dumps the MIDI packet into the transcript; 
	customize this by writing your own update: method."
	"MIDIPort dumpExample"
	"MIDIPort testInputStop"

	| inst port |
"Get a MIDIDump and the input port."
	inst := MIDIDump new.
	port := MIDIPort new openInput.
"Add the dump as a dependent of the port."
	port addDependent: inst.
"Turn on the port for input."
	port startMIDIInput.
"Wait"
	Cursor wait showWhile: [(Delay forSeconds: 5) wait].
"Turn the port off"
	port stopMIDIInput.
	port close.
"Don't forget to remove the dependent."
	port removeDependent: inst.!

testInput
	"Open MIDI, try to read something--dump it to the transcript."
	"MIDIPort testInput"
	"MIDIPort testInputStop"
	"MIDIPort concreteClass someInstance eventsAvailable"

	| port |
	port :=  self new.
	SirenUtility verbosity: 2.
	port openInput.
	port stopMIDIEcho.
	port stopControllerCaching.
	port startMIDIInput.

"Execute this to end the test"
"	| port |
	port :=  MIDIPort concreteClass someInstance.
	port stopMIDIEcho.
	port stopMIDIInput
"!

testInputStop
	"Execute this to end the input test"
	"MIDIPort testInputStop"

	| port |
	port := self concreteClass someInstance.
	SirenUtility verbosity: 1.
	port stopMIDIEcho.
	port stopMIDIInput.
	port close.! !

!Siren.MIDIPort class methodsFor: 'class initialization'!

initializeData
	"Set up the dictionaries of commands, ioctl primitive selectors and arguments, and general MIDI maps."
	"MIDIPort initializeData"

	singleton := nil.
	Streams := IdentityDictionary new.
	useSingleton := true.
	MIDIPort initializeMIDITables.
	self concreteClass initializeData!

initializeMIDITables
	"MIDIPort initializeMIDITables"

	Siren at: #MIDICommands put: Dictionary new.
	(Siren at: #MIDICommands) at: #noteOn put: 16r90.
	(Siren at: #MIDICommands) at: #noteOff put: 16r80.
	(Siren at: #MIDICommands) at: #polyTouch put: 16rA0.
	(Siren at: #MIDICommands) at: #chanTouch put: 16rD0.
	(Siren at: #MIDICommands) at: #ctrlChange put: 16rB0.
	(Siren at: #MIDICommands) at: #progChange put: 16rC0.
	(Siren at: #MIDICommands) at: #pitchWheel put: 16rE0.
	(Siren at: #MIDICommands) at: #sysEx put: 16rF0.

	Siren at: #GeneralMIDIMap put: Dictionary new.
	(Siren at: #GeneralMIDIMap) add: ('Acoustic Grand Piano' asSymbol -> 1).
	(Siren at: #GeneralMIDIMap) add: ('Bright Acoustic Piano' asSymbol -> 2).
	(Siren at: #GeneralMIDIMap) add: ('Electric Grand Piano' asSymbol -> 3).
	(Siren at: #GeneralMIDIMap) add: ('Honky-tonk Piano' asSymbol -> 4).
	(Siren at: #GeneralMIDIMap) add: ('Electric Piano 1' asSymbol -> 5).
	(Siren at: #GeneralMIDIMap) add: ('Electric Piano 2' asSymbol -> 6).
	(Siren at: #GeneralMIDIMap) add: ('Harpsichord' asSymbol -> 7).
	(Siren at: #GeneralMIDIMap) add: ('Clavinet' asSymbol -> 8).
	(Siren at: #GeneralMIDIMap) add: ('Celesta' asSymbol -> 9).
	(Siren at: #GeneralMIDIMap) add: ('Glockenspiel' asSymbol -> 10).
	(Siren at: #GeneralMIDIMap) add: ('Music Box' asSymbol -> 11).
	(Siren at: #GeneralMIDIMap) add: ('Vibraphone' asSymbol -> 12).
	(Siren at: #GeneralMIDIMap) add: ('Marimba' asSymbol -> 13).
	(Siren at: #GeneralMIDIMap) add: ('Xylophone' asSymbol -> 14).
	(Siren at: #GeneralMIDIMap) add: ('Tubular Bells' asSymbol -> 15).
	(Siren at: #GeneralMIDIMap) add: ('Dulcimer' asSymbol -> 16).
	(Siren at: #GeneralMIDIMap) add: ('Drawbar Organ' asSymbol -> 17).
	(Siren at: #GeneralMIDIMap) add: ('Percussive Organ' asSymbol -> 18).
	(Siren at: #GeneralMIDIMap) add: ('Rock Organ' asSymbol -> 19).
	(Siren at: #GeneralMIDIMap) add: ('Church Organ' asSymbol -> 20).
	(Siren at: #GeneralMIDIMap) add: ('Reed Organ' asSymbol -> 21).
	(Siren at: #GeneralMIDIMap) add: ('Accordion' asSymbol -> 22).
	(Siren at: #GeneralMIDIMap) add: ('Harmonica' asSymbol -> 23).
	(Siren at: #GeneralMIDIMap) add: ('Tango Accordion' asSymbol -> 24).
	(Siren at: #GeneralMIDIMap) add: ('Acoustic Guitar (nylon)' asSymbol -> 25).
	(Siren at: #GeneralMIDIMap) add: ('Acoustic Guitar (steel)' asSymbol -> 26).
	(Siren at: #GeneralMIDIMap) add: ('Electric Guitar (jazz)' asSymbol -> 27).
	(Siren at: #GeneralMIDIMap) add: ('Electric Guitar (clean)' asSymbol -> 28).
	(Siren at: #GeneralMIDIMap) add: ('Electric Guitar (muted)' asSymbol -> 29).
	(Siren at: #GeneralMIDIMap) add: ('Overdriven Guitar' asSymbol -> 30).
	(Siren at: #GeneralMIDIMap) add: ('Distortion Guitar' asSymbol -> 31).
	(Siren at: #GeneralMIDIMap) add: ('Guitar harmonics' asSymbol -> 32).
	(Siren at: #GeneralMIDIMap) add: ('Acoustic Bass' asSymbol -> 33).
	(Siren at: #GeneralMIDIMap) add: ('Electric Bass (finger)' asSymbol -> 34).
	(Siren at: #GeneralMIDIMap) add: ('Electric Bass (pick)' asSymbol -> 35).
	(Siren at: #GeneralMIDIMap) add: ('Fretless Bass' asSymbol -> 36).
	(Siren at: #GeneralMIDIMap) add: ('Slap Bass 1' asSymbol -> 37).
	(Siren at: #GeneralMIDIMap) add: ('Slap Bass 2' asSymbol -> 38).
	(Siren at: #GeneralMIDIMap) add: ('Synth Bass 1' asSymbol -> 39).
	(Siren at: #GeneralMIDIMap) add: ('Synth Bass 2' asSymbol -> 40).
	(Siren at: #GeneralMIDIMap) add: ('Violin' asSymbol -> 41).
	(Siren at: #GeneralMIDIMap) add: ('Viola' asSymbol -> 42).
	(Siren at: #GeneralMIDIMap) add: ('Cello' asSymbol -> 43).
	(Siren at: #GeneralMIDIMap) add: ('Contrabass' asSymbol -> 44).
	(Siren at: #GeneralMIDIMap) add: ('Tremolo Strings' asSymbol -> 45).
	(Siren at: #GeneralMIDIMap) add: ('Pizzicato Strings' asSymbol -> 46).
	(Siren at: #GeneralMIDIMap) add: ('Orchestral Harp' asSymbol -> 47).
	(Siren at: #GeneralMIDIMap) add: ('Timpani' asSymbol -> 48).
	(Siren at: #GeneralMIDIMap) add: ('String Ensemble 1' asSymbol -> 49).
	(Siren at: #GeneralMIDIMap) add: ('String Ensemble 2' asSymbol -> 50).
	(Siren at: #GeneralMIDIMap) add: ('SynthStrings 1' asSymbol -> 51).
	(Siren at: #GeneralMIDIMap) add: ('SynthStrings 2' asSymbol -> 52).
	(Siren at: #GeneralMIDIMap) add: ('Choir Aahs' asSymbol -> 53).
	(Siren at: #GeneralMIDIMap) add: ('Voice Oohs' asSymbol -> 54).
	(Siren at: #GeneralMIDIMap) add: ('Synth Voice' asSymbol -> 55).
	(Siren at: #GeneralMIDIMap) add: ('Orchestra Hit' asSymbol -> 56).
	(Siren at: #GeneralMIDIMap) add: ('Trumpet' asSymbol -> 57).
	(Siren at: #GeneralMIDIMap) add: ('Trombone' asSymbol -> 58).
	(Siren at: #GeneralMIDIMap) add: ('Tuba' asSymbol -> 59).
	(Siren at: #GeneralMIDIMap) add: ('Muted Trumpet' asSymbol -> 60).
	(Siren at: #GeneralMIDIMap) add: ('French Horn' asSymbol -> 61).
	(Siren at: #GeneralMIDIMap) add: ('Brass Section' asSymbol -> 62).
	(Siren at: #GeneralMIDIMap) add: ('SynthBrass 1' asSymbol -> 63).
	(Siren at: #GeneralMIDIMap) add: ('SynthBrass 2' asSymbol -> 64).
	(Siren at: #GeneralMIDIMap) add: ('Soprano Sax' asSymbol -> 65).
	(Siren at: #GeneralMIDIMap) add: ('Alto Sax' asSymbol -> 66).
	(Siren at: #GeneralMIDIMap) add: ('Tenor Sax' asSymbol -> 67).
	(Siren at: #GeneralMIDIMap) add: ('Baritone Sax' asSymbol -> 68).
	(Siren at: #GeneralMIDIMap) add: ('Oboe' asSymbol -> 69).
	(Siren at: #GeneralMIDIMap) add: ('English Horn' asSymbol -> 70).
	(Siren at: #GeneralMIDIMap) add: ('Bassoon' asSymbol -> 71).
	(Siren at: #GeneralMIDIMap) add: ('Clarinet' asSymbol -> 72).
	(Siren at: #GeneralMIDIMap) add: ('Piccolo' asSymbol -> 73).
	(Siren at: #GeneralMIDIMap) add: ('Flute' asSymbol -> 74).
	(Siren at: #GeneralMIDIMap) add: ('Recorder' asSymbol -> 75).
	(Siren at: #GeneralMIDIMap) add: ('Pan Flute' asSymbol -> 76).
	(Siren at: #GeneralMIDIMap) add: ('Blown Bottle' asSymbol -> 77).
	(Siren at: #GeneralMIDIMap) add: ('Shakuhachi' asSymbol -> 78).
	(Siren at: #GeneralMIDIMap) add: ('Whistle' asSymbol -> 79).
	(Siren at: #GeneralMIDIMap) add: ('Ocarina' asSymbol -> 80).
	(Siren at: #GeneralMIDIMap) add: ('Lead 1 (square)' asSymbol -> 81).
	(Siren at: #GeneralMIDIMap) add: ('Lead 2 (sawtooth)' asSymbol -> 82).
	(Siren at: #GeneralMIDIMap) add: ('Lead 3 (calliope)' asSymbol -> 83).
	(Siren at: #GeneralMIDIMap) add: ('Lead 4 (chiff)' asSymbol -> 84).
	(Siren at: #GeneralMIDIMap) add: ('Lead 5 (charang)' asSymbol -> 85).
	(Siren at: #GeneralMIDIMap) add: ('Lead 6 (voice)' asSymbol -> 86).
	(Siren at: #GeneralMIDIMap) add: ('Lead 7 (fifths)' asSymbol -> 87).
	(Siren at: #GeneralMIDIMap) add: ('Lead 8 (bass + lead)' asSymbol -> 88).
	(Siren at: #GeneralMIDIMap) add: ('Pad 1 (new age)' asSymbol -> 89).
	(Siren at: #GeneralMIDIMap) add: ('Pad 2 (warm)' asSymbol -> 90).
	(Siren at: #GeneralMIDIMap) add: ('Pad 3 (polysynth)' asSymbol -> 91).
	(Siren at: #GeneralMIDIMap) add: ('Pad 4 (choir)' asSymbol -> 92).
	(Siren at: #GeneralMIDIMap) add: ('Pad 5 (bowed)' asSymbol -> 93).
	(Siren at: #GeneralMIDIMap) add: ('Pad 6 (metallic)' asSymbol -> 94).
	(Siren at: #GeneralMIDIMap) add: ('Pad 7 (halo)' asSymbol -> 95).
	(Siren at: #GeneralMIDIMap) add: ('Pad 8 (sweep)' asSymbol -> 96).
	(Siren at: #GeneralMIDIMap) add: ('FX 1 (rain)' asSymbol -> 97).
	(Siren at: #GeneralMIDIMap) add: ('FX 2 (soundtrack)' asSymbol -> 98).
	(Siren at: #GeneralMIDIMap) add: ('FX 3 (crystal)' asSymbol -> 99).
	(Siren at: #GeneralMIDIMap) add: ('FX 4 (atmosphere)' asSymbol -> 100).
	(Siren at: #GeneralMIDIMap) add: ('FX 5 (brightness)' asSymbol -> 101).
	(Siren at: #GeneralMIDIMap) add: ('FX 6 (goblins)' asSymbol -> 102).
	(Siren at: #GeneralMIDIMap) add: ('FX 7 (echoes)' asSymbol -> 103).
	(Siren at: #GeneralMIDIMap) add: ('FX 8 (sci-fi)' asSymbol -> 104).
	(Siren at: #GeneralMIDIMap) add: ('Sitar' asSymbol -> 105).
	(Siren at: #GeneralMIDIMap) add: ('Banjo' asSymbol -> 106).
	(Siren at: #GeneralMIDIMap) add: ('Shamisen' asSymbol -> 107).
	(Siren at: #GeneralMIDIMap) add: ('Koto' asSymbol -> 108).
	(Siren at: #GeneralMIDIMap) add: ('Kalimba' asSymbol -> 109).
	(Siren at: #GeneralMIDIMap) add: ('Bag pipe' asSymbol -> 110).
	(Siren at: #GeneralMIDIMap) add: ('Fiddle' asSymbol -> 111).
	(Siren at: #GeneralMIDIMap) add: ('Shanai' asSymbol -> 112).
	(Siren at: #GeneralMIDIMap) add: ('Tinkle Bell' asSymbol -> 113).
	(Siren at: #GeneralMIDIMap) add: ('Agogo' asSymbol -> 114).
	(Siren at: #GeneralMIDIMap) add: ('Steel Drums' asSymbol -> 115).
	(Siren at: #GeneralMIDIMap) add: ('Woodblock' asSymbol -> 116).
	(Siren at: #GeneralMIDIMap) add: ('Taiko Drum' asSymbol -> 117).
	(Siren at: #GeneralMIDIMap) add: ('Melodic Tom' asSymbol -> 118).
	(Siren at: #GeneralMIDIMap) add: ('Synth Drum' asSymbol -> 119).
	(Siren at: #GeneralMIDIMap) add: ('Reverse Cymbal' asSymbol -> 120).
	(Siren at: #GeneralMIDIMap) add: ('Guitar Fret Noise' asSymbol -> 121).
	(Siren at: #GeneralMIDIMap) add: ('Breath Noise' asSymbol -> 122).
	(Siren at: #GeneralMIDIMap) add: ('Seashore' asSymbol -> 123).
	(Siren at: #GeneralMIDIMap) add: ('Bird Tweet' asSymbol -> 124).
	(Siren at: #GeneralMIDIMap) add: ('Telephone Ring' asSymbol -> 125).
	(Siren at: #GeneralMIDIMap) add: ('Helicopter' asSymbol -> 126).
	(Siren at: #GeneralMIDIMap) add: ('Applause' asSymbol -> 127).
	(Siren at: #GeneralMIDIMap) add: ('Gunshot' asSymbol -> 128).

	Siren at: #GeneralMIDIDrums put: Dictionary new.
	(Siren at: #GeneralMIDIDrums) add: ('Open Cuica' asSymbol -> 79).
	(Siren at: #GeneralMIDIDrums) add: ('Mute Triangle' asSymbol -> 80).
	(Siren at: #GeneralMIDIDrums) add: ('Open Triangle' asSymbol -> 81).
	(Siren at: #GeneralMIDIDrums) add: ('Acoustic Bass Drum' asSymbol -> 35).
	(Siren at: #GeneralMIDIDrums) add: ('Bass Drum 1' asSymbol -> 36).
	(Siren at: #GeneralMIDIDrums) add: ('Side Stick' asSymbol -> 37).
	(Siren at: #GeneralMIDIDrums) add: ('Acoustic Snare' asSymbol -> 38).
	(Siren at: #GeneralMIDIDrums) add: ('Hand Clap' asSymbol -> 39).
	(Siren at: #GeneralMIDIDrums) add: ('Electric Snare' asSymbol -> 40).
	(Siren at: #GeneralMIDIDrums) add: ('Low Floor Tom' asSymbol -> 41).
	(Siren at: #GeneralMIDIDrums) add: ('Closed Hi Hat' asSymbol -> 42).
	(Siren at: #GeneralMIDIDrums) add: ('High Floor Tom' asSymbol -> 43).
	(Siren at: #GeneralMIDIDrums) add: ('Pedal Hi-Hat' asSymbol -> 44).
	(Siren at: #GeneralMIDIDrums) add: ('Low Tom' asSymbol -> 45).
	(Siren at: #GeneralMIDIDrums) add: ('Open Hi-Hat' asSymbol -> 46).
	(Siren at: #GeneralMIDIDrums) add: ('Low-Mid Tom' asSymbol -> 47).
	(Siren at: #GeneralMIDIDrums) add: ('Hi Mid Tom' asSymbol -> 48).
	(Siren at: #GeneralMIDIDrums) add: ('Crash Cymbal 1' asSymbol -> 49).
	(Siren at: #GeneralMIDIDrums) add: ('High Tom' asSymbol -> 50).
	(Siren at: #GeneralMIDIDrums) add: ('Ride Cymbal 1' asSymbol -> 51).
	(Siren at: #GeneralMIDIDrums) add: ('Chinese Cymbal' asSymbol -> 52).
	(Siren at: #GeneralMIDIDrums) add: ('Ride Bell' asSymbol -> 53).
	(Siren at: #GeneralMIDIDrums) add: ('Tambourine' asSymbol -> 54).
	(Siren at: #GeneralMIDIDrums) add: ('Splash Cymbal' asSymbol -> 55).
	(Siren at: #GeneralMIDIDrums) add: ('Cowbell' asSymbol -> 56).
	(Siren at: #GeneralMIDIDrums) add: ('Crash Cymbal 2' asSymbol -> 57).
	(Siren at: #GeneralMIDIDrums) add: ('Vibraslap' asSymbol -> 58).
	(Siren at: #GeneralMIDIDrums) add: ('Ride Cymbal 2' asSymbol -> 59).
	(Siren at: #GeneralMIDIDrums) add: ('Hi Bongo' asSymbol -> 60).
	(Siren at: #GeneralMIDIDrums) add: ('Low Bongo' asSymbol -> 61).
	(Siren at: #GeneralMIDIDrums) add: ('Mute Hi Conga' asSymbol -> 62).
	(Siren at: #GeneralMIDIDrums) add: ('Open Hi Conga' asSymbol -> 63).
	(Siren at: #GeneralMIDIDrums) add: ('Low Conga' asSymbol -> 64).
	(Siren at: #GeneralMIDIDrums) add: ('High Timbale' asSymbol -> 65).
	(Siren at: #GeneralMIDIDrums) add: ('Low Timbale' asSymbol -> 66).
	(Siren at: #GeneralMIDIDrums) add: ('High Agogo' asSymbol -> 67).
	(Siren at: #GeneralMIDIDrums) add: ('Low Agogo' asSymbol -> 68).
	(Siren at: #GeneralMIDIDrums) add: ('Cabasa' asSymbol -> 69).
	(Siren at: #GeneralMIDIDrums) add: ('Maracas' asSymbol -> 70).
	(Siren at: #GeneralMIDIDrums) add: ('Short Whistle' asSymbol -> 71).
	(Siren at: #GeneralMIDIDrums) add: ('Long Whistle' asSymbol -> 72).
	(Siren at: #GeneralMIDIDrums) add: ('Short Guiro' asSymbol -> 73).
	(Siren at: #GeneralMIDIDrums) add: ('Long Guiro' asSymbol -> 74).
	(Siren at: #GeneralMIDIDrums) add: ('Claves' asSymbol -> 75).
	(Siren at: #GeneralMIDIDrums) add: ('Hi Wood Block' asSymbol -> 76).
	(Siren at: #GeneralMIDIDrums) add: ('Low Wood Block' asSymbol -> 77).
	(Siren at: #GeneralMIDIDrums) add: ('Mute Cuica' asSymbol -> 78).

	Siren at: #GeneralMIDIFamilies put: Dictionary new.
	(Siren at: #GeneralMIDIFamilies) add: ('Pianos' asSymbol -> (1 to: 8)).
	(Siren at: #GeneralMIDIFamilies) add: ('Tuned Pecussion' asSymbol -> (9 to: 16)).
	(Siren at: #GeneralMIDIFamilies) add: ('Organs' asSymbol -> (17 to: 24)).
	(Siren at: #GeneralMIDIFamilies) add: ('Guitars' asSymbol -> (25 to: 32)).
	(Siren at: #GeneralMIDIFamilies) add: ('Bass' asSymbol -> (33 to: 40)).
	(Siren at: #GeneralMIDIFamilies) add: ('Solo Strings' asSymbol -> (41 to: 48)).
	(Siren at: #GeneralMIDIFamilies) add: ('Ensembles' asSymbol -> (49 to: 56)).
	(Siren at: #GeneralMIDIFamilies) add: ('Brass' asSymbol -> (57 to: 64)).
	(Siren at: #GeneralMIDIFamilies) add: ('Reeds' asSymbol -> (65 to: 72)).
	(Siren at: #GeneralMIDIFamilies) add: ('Pipes' asSymbol -> (73 to: 80)).
	(Siren at: #GeneralMIDIFamilies) add: ('Synth Lead' asSymbol -> (81 to: 88)).
	(Siren at: #GeneralMIDIFamilies) add: ('Synth Pad' asSymbol -> (89 to: 96)).
	(Siren at: #GeneralMIDIFamilies) add: ('Synth Effects' asSymbol -> (97 to: 104)).
	(Siren at: #GeneralMIDIFamilies) add: ('Ethnic' asSymbol -> (105 to: 112)).
	(Siren at: #GeneralMIDIFamilies) add: ('Percussion' asSymbol -> (113 to: 120)).
	(Siren at: #GeneralMIDIFamilies) add: ('Sound Effects' asSymbol -> (121 to: 128)).! !

!Siren.MIDIPort class methodsFor: 'examples'!

examples
	"Select and execute the following for usage examples."

"Try to open and close the MIDI port (report to transcript)."
	"MIDIPort testOpenClose"
"Open MIDI, play a 1-sec. note."
	"MIDIPort testANote"
"Open MIDI, play a fast scale."
	"MIDIPort testAScale"
"Open MIDI, play notes based on the mouse position (x --> voice; y --> pitch) until mouse down."
	"MIDIPort testMouseMIDI"

"Open MIDI, try to read something--dump it to the transcript."
	"MIDIPort testInput"
"Execute this to end the input test"
	"MIDIPort testInputStop"
"Get the port's pending input."
	"MIDIPort default eventsAvailable"
	"MIDIPort default readAll"
	"MIDIPort default input"
	"MIDIPort default resetInput"
"Set up a MIDI dump object as a dependent of the input port. Dump for 30 seconds,
then turn off. The default update: method just dumps the MIDI packet into the transcript; 
customize this by writing your own update: method."
	"MIDIPort dumpExample"
"Set up uncached controller reading and dump input to the transcript."
	"MIDIPort testControllerInput"
	"MIDIPort testInputStop"
"Set up uncached controller reading--read controllers from lo to hi as an array and print it; 
stop on mouse press."
	"MIDIPort testControllerCachingFrom: 48 to: 52"

"Play 'num' random pitches spaced 'dur' msec apart."
"This test creates the messages and does the scheduling right here."
	"MIDIPort testRandomPlayLowLevel: 64 dur: 80"
"Play a roll of 'num' notes spaced 'dur' msec apart."
"This version uses the 1-call note command and driver-side scheduler."
	"MIDIPort testRollHighLevel: 64 dur: 50"
"Play a roll of 'num' notes spaced 'dur' msec apart."
"This test creates the messages and does the scheduling right here."
	"MIDIPort testRollLowLevel: 64 dur: 50"

"Demonstrate control commands by playing a note and making a crescendo with the volume pedal."
	"MIDIPort testControlContinuous"
"Demonstrate pitch-bend by playing two notes and bending them."
	"MIDIPort testBend"

"Demonstrate program change by setting up an organ instrument to play on."
	"MIDIPort testProgramChange"
"Down-load a general MIDI patch for a 4-voice organ."
	"MIDIPort setupOrgan. MIDIPort default test"
"Down-load a general MIDI patch for a 16-voice percussion ensemble."
	"MIDIPort setupTunedPercussion. MIDIPort testAScale"

"ANO"
	"MIDIPort allNotesOff"
"Close down and clean up."
	"MIDIPort cleanUp"!

scaleFrom: lo to: hi in: dur
	"Answer array of (start dur pitch amp)"
	"MIDIPort scaleFrom: 48 to: 72 in: 2000"

	| arr size ndur |
	size := hi - lo + 1.
	ndur := (dur / size) truncated.
	arr := Array new: size.
	1 to: size do:
		[ :ind |
		arr at: ind put: (Array with: (ind - 1 * ndur) with: ndur with: (ind + lo - 1) with: 96)].
	^arr! !

!Siren.MIDIPort class methodsFor: 'controller tests'!

testControllerCaching
	"Set up uncached controller reading--make a loop that reads and prints controller 48 
		twice a second (until you press the shift button)."
	"MIDIPort testControllerCaching"
	"MIDIPort testInputStop"

	| inst |
	inst := self new.
	inst openInput: self concreteClass in.			"Edit your controller device # here"
	inst startControllerCaching.
	inst startMIDIInput.
	[InputState default shiftDown]
		whileFalse:
		[Transcript show: 'Ctrl 48: ', (inst readController: 48) printString; cr.
		(Delay forMilliseconds: 500) wait].
	MIDIPort testInputStop!

testControllerCaching2
	"Set up uncached controller reading--read controllers 48-52 as an array and print it; stop on mouse press."
	"MIDIPort testControllerCaching2"
	"MIDIPort testInputStop"

	| array inst |
	inst := self new.
	inst openInput: self concreteClass in.			"Edit your controller device # here"
	inst startControllerCaching.
	inst startMIDIInput.
	array := Array new: 5.
	[InputState default shiftDown]
		whileFalse:
		[inst readControllersFrom: 48 to: 52 into: array.
		Transcript tab; show: array printString; cr.
		(Delay forMilliseconds: 500) wait].
	MIDIPort testInputStop!

testControllerCachingFrom: lo to: hi
	"Set up uncached controller reading--read controllers from lo to hi (inclusive) as an array and print it; 
		stop on <SHIFT> press."
	"MIDIPort testControllerCachingFrom: 48 to: 55"
	"MIDIPort testInputStop"

	| inst array count |
	inst := self new.
	inst openInput: 3.			"Edit your controller device # here"
	inst startControllerCaching.
	inst startMIDIInput.
	array := WordArray new: (hi - lo + 1).
	array gcCopyToHeap.		"this is so that you can pass this ptr to C"
	count := 0.
	[InputState default shiftDown]
		whileFalse:
		[inst readControllersFrom: lo to: hi into: array.
		Transcript tab; show: count printString, '	', array printString; cr.
		(Delay forMilliseconds: 500) wait.
		count := count + 1.].
		Transcript show: 'Done'; cr.
	MIDIPort testInputStop!

testControllerRecording
	"Set up uncached controller reading--make a loop that reads and prints controller 48 
		40 times a second for 5 seconds."
	"MIDIPort testControllerRecording"
	"MIDIPort testInputStop"

	| inst fcn |
	inst := self new.
	inst openInput: 3.			"Edit your controller device # here"
	inst startControllerCaching.
	fcn := Function ofSize: 200.
	inst startMIDIInput.
	200 timesRepeat:
		[fcn add: (inst readController: 48) asFloat / 127.0.
		(Delay forMilliseconds: 25) wait].
	MIDIPort testInputStop.
	fcn edit! !

!Siren.MIDIPort class methodsFor: 'utilities'!

allNotesOff
	"MIDIPort allNotesOff"

	| port |
	port := self concreteClass someInstance.
	port ifNil: [port := self new].
	port allNotesOff!

cleanUp
	"Close down and clean up all MIDI, sound IO, event lists, etc."
	"MIDIPort cleanUp"
	"self concreteClass instanceCount"
	"self concreteClass allInstances"

	singleton := nil.
	self concreteClass instanceCount = 0
		ifFalse: [self concreteClass allInstances do: 
			[ :p | 
			p isActive ifTrue: [p stopMIDIInput]. 
			p isActive ifTrue: [p close]. 
			p release]]. 
	EventScheduler instance flush.
	MIDIVoice flushDefault!

showInput
	"Open MIDI, wait to read something, then dump it to the transcript."
	"This toggles on and off if called repeatedly."
	"MIDIPort showInput"
	"singleton input"

	self default open.
	(singleton reader == nil)
		ifTrue: [Transcript cr; show: 'Stopping MIDI Dump'; cr; cr.
			singleton stopMIDIEcho.
			singleton stopMIDIInput]
		ifFalse: [Transcript cr; cr; show: 'Starting MIDI Dump'; cr.
			singleton startMIDIEcho.
			singleton stopControllerCaching.
			singleton startMIDIInput]! !

!Siren.MIDIPort class methodsFor: 'general MIDI patches'!

setAllInstrumentsTo: iname
	"Set instruments 0-15 to the General MIDI name iname"
	"MIDIPort setAllInstrumentsTo: 'Tenor Sax'. MIDIPort testAScale"
	"MIDIPort setAllInstrumentsTo: 'Music Box'. MIDIPort testAScale"

	| port |
	port := self default.
	0 to: 15 do:
		[ :ind |
		port programChange: ind to: (GeneralMIDIMap at: iname asSymbol)]!

setEnsemble: orch
	"Down-load a general MIDI patch for the given ensemble (a collection of 
	[chan -> name] associations)."
	"MIDIPort setEnsemble: 
			(Array with: (0 -> 'Reed Organ') with: (1 -> 'Rock Organ')
					with: (2 -> 'Church Organ') with: (3 -> 'Drawbar Organ')
					with: (4 -> 'Percussive Organ') with: (5 -> 'Accordion'))"

	| port |
	port := self default.
	port open.
	orch do:
		[ :item |
		port programChange: item key to: (GeneralMIDIMap at: item value asSymbol)]!

setEnsembleInOrder: orch
	"Down-load a general MIDI patch for the given ensemble (a collection of symbolic keys 
	into the General MIDI voice map) mapping the first element to MIDI channel 1, etc."

	| port |
	port := self default.
	port open.
	1 to: orch size do:
		[ :ind |
		port programChange: (ind - 1) to: (GeneralMIDIMap at: (orch at: ind) asSymbol)]!

setupDefaultGeneralMIDI
	"Down-load a general MIDI patch for a 16-voice percussion ensemble."
	"MIDIPort setupDefaultGeneralMIDI. MIDIPort testAScale"

	MIDIPort setEnsembleInOrder: 
			#('Acoustic Grand Piano' 'Bright Acoustic Piano' 'Electric Grand Piano' 'Honky-tonk Piano'
				'Electric Piano 1' 'Electric Piano 2' 'Harpsichord' 'Clavinet' 'Celesta' 'Glockenspiel' 
				'Music Box' 'Vibraphone' 'Marimba' 'Xylophone' 'Tubular Bells' 'Dulcimer').!

setupOrgan
	"Down-load a general MIDI patch for a 4-voice organ."
	"MIDIPort setupOrgan. MIDIPort testAScale"

	MIDIPort setEnsemble: 
			(OrderedCollection with: (0 -> 'Reed Organ') with: (1 -> 'Rock Organ')
					with: (2 -> 'Church Organ') with: (3 -> 'Drawbar Organ')
					with: (4 -> 'Percussive Organ') with: (5 -> 'Accordion'))!

setupTunedPercussion
	"Down-load a general MIDI patch for a 16-voice percussion ensemble."
	"MIDIPort setupTunedPercussion. MIDIPort testAScale"

	MIDIPort setEnsembleInOrder: 
			#(Agogo 'Tinkle Bell' Timpani Xylophone 
				Applause 'Taiko Drum' Glockenspiel 'Synth Drum'
				Gunshot 'Steel Drums' Helicopter Vibraphone
				Woodblock 'Telephone Ring' Kalimba 'Blown Bottle')!

setupWindOrchestra
	"Down-load a general MIDI patch for a 16-voice wind ensemble."
	"This could be done more tersely with the setEnsembleInOrder: method."
	"MIDIPort setupWindOrchestra. MIDIPort default test"
	"GeneralMIDIMap keys asSortedCollection"

	| port orch |
	port := self default.
	port open.
	orch := #(Flute 'English Horn' Bassoon Clarinet Piccolo 'Pan Flute' Recorder 'Tenor Sax'
			  Flute 'English Horn' Bassoon Clarinet Piccolo 'Pan Flute' Recorder 'Tenor Sax').
	1 to: orch size do:
		[ :ind |
		port programChange: (ind - 1) to: (GeneralMIDIMap at: (orch at: ind) asString)]! !

!Siren.MIDIPort class methodsFor: 'driver performance tests'!

testRandomPlayHighLevel: num dur: dur
	"Play 'num' random pitches (molto legato) spaced 'dur' msec apart."
	"This version uses the 1-call note command and driver-side scheduler."
	"MIDIPort testRandomPlayHighLevel: 64 dur: 80"

	| inst rand time |
	rand := Random new.
	inst := MIDIPort default.
	time := Time microsecondClock + 100000.
	num timesRepeat:
		[inst play: (rand next * 36 + 24) truncated "random pitches"
				at: time 
				dur: (dur * 4) truncated 		"molto legato"
				amp: 96 voice: 0.
		time := time + dur].
	(Delay forMicroseconds: ((num * dur) + 1000000)) wait!

testRandomPlayLowLevel: num dur: dur
	"Play 'num' random pitches spaced 'dur' msec apart."
	"This test creates the messages and does the scheduling right here."
	"MIDIPort testRandomPlayLowLevel: 64 dur: 80"

	| inst data rand |
	rand := Random new.
	inst := MIDIPort new.
	inst open.
	data := ByteArray new: 3.
	data at: 3 put: 96.				"velocity"
"	data at: 2 put: 60."
	num timesRepeat:
		[data at: 1 put: 16r90.		"note-on"
		data at: 2 put: (rand next * 36 + 24) truncated.	"pitch"
		inst put: data length: 3.
		(Delay forMilliseconds: dur) wait.
		Processor yield.
		data at: 1 put: 16r80.			"note-off"
		inst put: data length: 3]!

testRollLowLevel: num dur: dur
	"Play a roll of 'num' notes spaced 'dur' msec apart."
	"This test creates the messages and does the scheduling right here."
	"MIDIPort testRollLowLevel: 64 dur: 80"

	| inst data |
	inst := MIDIPort new.
	inst open.
	data := ByteArray new: 3.
	data at: 3 put: 96.				"velocity"
	data at: 2 put: 60.				"pitch"
	num timesRepeat:
		[data at: 1 put: 16r90.		"note-on"
		inst put: data length: 3.
		(Delay forMilliseconds: dur) wait.
		data at: 1 put: 16r80.			"note-off"
		inst put: data length: 3]! !

!Siren.MIDIPort class methodsFor: 'instance creation'!

concreteClass
	"Answer the class to use for MIDI"
	"MIDIPort concreteClass instanceCount"


	^PortMIDIPort! !

!Siren.MIDIPort class methodsFor: 'output tests'!

testANote
	"Open MIDI, play a note."
	"MIDIPort release"
	"MIDIPort testANote"

	| inst |
	inst := MIDIPort new.
	inst openOutput: self concreteClass out.
	inst play: 50 dur: 500 amp: 120 voice: 0.
	1 wait.
	inst close.!

testARandomNote
	"Open MIDI, play a note."
	"MIDIPort testARandomNote"

	| inst err data rand |
	rand := Random new.
	inst := MIDIPort new.
	err := inst open.
	Transcript cr; show: 'open --> ', err printString; cr.
	data := ByteArray new: 3.
	data at: 1 put: 16r90.			"note-on"
	data at: 2 put: (rand next * 36 + 24) truncated.		"pitch"
	data at: 3 put: 96.		"velocity"
	err := inst put: data length: 3.
	Transcript show: 'note-on --> ', err printString; cr.
	(Delay forMilliseconds: 1000) wait.
	data at: 1 put: 16r80.		"silence = note-off"
	err := inst put: data length: 3.
	Transcript show: 'note-off --> ', err printString; cr.!

testAllNotesOff
	"Try to open and close the MIDI port."
	"MIDIPort testAllNotesOff"

	| inst err data |
	inst := MIDIPort new.
	err := inst open.
	Transcript cr; show: 'open --> ', err printString; cr.
	data := ByteArray new: 3.
	data at: 1 put: 16r90.		"note-on"
	data at: 2 put: 60.			"pitch"
	data at: 3 put: 127.		"velocity"
	err := inst put: data length: 3.
	err := inst allNotesOff.
	Transcript show: 'ANO --> ', err printString; cr.
	err := inst close.
	Transcript show: 'close --> ', err printString; cr.!

testInspect
	"Inspect a MIDI port."
	"MIDIPort testInspect"

	| inst err |
	inst := MIDIPort new.
	inst inspect.
"	err := inst open.
	Transcript cr; show: 'open --> ', err printString; cr.
	err := inst test.
	Transcript show: 'test --> ', err printString; cr.
	err := inst close.
	Transcript show: 'close --> ', err printString; cr.
"!

testMouseMIDI
	"Open MIDI, play notes based on the mouse position."
	"x --> voice; y --> pitch."
	"MIDIPort testMouseMIDI"

	| inst moPt ht |
	inst := MIDIPort default.
	inst open.
	MIDIPort setupTunedPercussion.
	(Delay forMilliseconds: 200) wait.
	ht := Screen default bounds height.
	[InputState default mouseButtons = 0] whileTrue:
		[moPt := InputSensor cursorPoint.
		inst play: (ht - moPt y // 20 + 24) dur: 250 amp: 96 
				voice: (moPt x // 50).
		(Delay forMilliseconds: 100) wait].!

testNoteOnOff
	"Open MIDI, play a note, and close it."
	"MIDIPort testNoteOnOff"

	| inst err data |
	inst := MIDIPort new.
	data := ByteArray new: 3.
	data at: 1 put: 16r90.
	data at: 2 put: 64.
	data at: 3 put: 96.
	err := inst open.
	Transcript cr; show: 'open --> ', err printString; cr.
	err := inst put: data length: 3.
	Transcript show: 'play --> ', err printString; cr.
	data at: 3 put: 0.
	err := inst put: data length: 3.
	Transcript show: 'play --> ', err printString; cr.
	err := inst close.
	Transcript show: 'close --> ', err printString; cr.!

testOpenClose
	"Try to open and close the MIDI port."
	"MIDIPort testOpenClose"
	"MIDIPort default close"
	"MIDIPort cleanUp"

	| inst err |
	inst := MIDIPort new.
	err := inst open.
	Transcript cr; show: 'open --> ', err printString; cr.
	err := inst close.
	singleton := nil.
	Transcript show: 'close --> ', err printString; cr.!

testOutput
	"Open MIDI, play some random notes, and close it."
	"MIDIPort testOutput"

	| inst err |
	inst := MIDIPort new.
	err := inst open.
	Transcript cr; show: 'open --> ', err printString; cr.
	err := inst test.
	Transcript show: 'test --> ', err printString; cr.
	err := inst close.
	Transcript show: 'close --> ', err printString; cr.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!


Siren.MIDIPort comment:
'An instance of a subclass of MIDIPort is used for the interface betweeen Siren and external MIDI drivers and devices. It implements both note-oriented (e.g., play: pitch at: aDelay dur: aDur amp: anAmp voice: voice), and data-oriented (e.g., put: data at: delay length: size) behaviors for MIDI I/O. There is an extensive test suite and demo in the class examples method and in the Siren outline view.

There is typically only one instance of MIDIPort. The messages new, default, and instance all answer the sole instance. MIDIPorts use dependency to signal input data, objects wishing to receive input should register themselves as dependents of a port. In the default Siren implementation, the scheduler is all in Smalltalk, and only the simplest MIDI driver is assumed.

Instance Variables:
	readProcess <Process> The loop process to read input data.
	inputData <OrderedCollection of (Integer -> ByteArray)> The available data.
	status <Symbol> #open or #closed
	device <Integer> my IO device''s index

Class Variables:
	Instance <MIDIPort|nil> The sole instance, or nil.
	Debug <Boolean> Debug mode prints all I/O to the Transcript.
	UseSingleton <Boolean> whether to use a singleton instance (not necessary)
	DefaultInputDevice <Integer> the index in the driver of the default input device
	DefaultOutputDevice see above

MIDI Commands Supported:
	0x9x pp vv -- note-on (x=channel, pp=pitch, vv=velocity)
	0x8x pp vv -- note-off (x=channel, pp=pitch, vv=velocity)
	0xCx cc -- program-change (x=channel, pp=pitch)
	0xEx ll hh -- program-change (x=channel, ll=low 7 bits, hh=high 7 bits)
	0xBx cc dd -- control change (x=channel, cc=controller, dd=data)
'!

!Siren.MIDIPort methodsFor: 'accessing'!

input
	"Answer the receiver's Q of input data."
	"MIDIPort default input"

	^inputData!

isActive
	"Answer whether the receiver is active."

	self subclassResponsibility!

reader
	"Answer the receiver's read process"

	^readProcess!

resetInput
	"Reset the receiver's Q of input data."
	"MIDIPort instance resetInput"

	inputData := OrderedCollection new: 16! !

!Siren.MIDIPort methodsFor: 'control commands'!

allNotesOff
	"Turn all MIDI notes off using the channel message 123."
	"MIDIPort default allNotesOff"

	self isActive ifFalse: [self open].
	0 to: 15 do:
		[ :chan |
		self controlChange: chan controller: 123 to: 0]!

allNotesOffVerbose
	"Turn all MIDI notes off (the verbose way)."
	"MIDIPort instance allNotesOff"

	| bytes answer |
	bytes := ByteArray new: 3.
	bytes at: 3 put: 0.
	0 to: 15 do:
		[ :chan |
		0 to: 127 do:
			[ :key |
			bytes at: 1 put: (16r80 bitOr: chan).
			bytes at: 2 put: key.
			answer := self put: bytes length: 3.
			answer = 3
				ifFalse: [self error: 'Error sending note-off.']]]!

controlChange: chan controller: controller to: value
	"Send out a control-change command now."
	"No range-checking on arguments."

	| data |
	data := ByteArray new: 3.
	data at: 1 put: ((MIDICommands at: #ctrlChange) bitOr: chan);
		at: 2 put: controller;
		at: 3 put: value.
	^self put: data length: 3!

pitchBend: chan to: value
	"Send out a pitch-bend command at the given time."

	| data pitchBytes |
	data := ByteArray new: 3.
"Get the two-byte 14-bit value for the argument."
	pitchBytes := MIDIPacket bytesFor14BitValue: value.
	data at: 1 put: ((MIDICommands at: #pitchWheel) bitOr: chan);
		at: 2 put: pitchBytes first;
		at: 3 put: (pitchBytes at: 2).
	self put: data length: 3!

programChange: chan to: value
	"Send out a program-change command at the given time."
	"No range-checking on arguments."

	| data prog answer |
	data := ByteArray new: 2.
	value isInteger
		ifTrue: [prog := value]
		ifFalse: [prog := GeneralMIDIMap at: value asSymbol
						ifAbsent: [self error: 'Instrument not found']].
	data at: 1 put: ((MIDICommands at: #progChange) bitOr: chan);
		at: 2 put: prog - 1.
	answer := self put: data length: 2.
	(Delay forMilliseconds: 50) wait.		"Give the synth some time..."
	^answer!

sysex: command
	"Send out a MIDI system exclusive data packet at the given time."

	| data size |
	size := command size + 2.
	data := ByteArray new: size.
	data at: 1 put: (MIDICommands at: #sysEx).
	1 to: command size do:
		[ :i | data at: (i + 1) put: (command at: i)].
	data at: size put: 16rF7.
	self put: data length: size! !

!Siren.MIDIPort methodsFor: 'initialize release'!

initialize
	"Setup the receiver's instance variables."

	status := #Init.
	device := self class out!

release
	"Release--break and dependencies on the error value."

	super release.! !

!Siren.MIDIPort methodsFor: 'read/write'!

get: packet
	"Read the data from the receiver into the argument (a MIDIPacket). Answer the number of data bytes read."

	self subclassResponsibility!

nextEventInto: anEventAssociation
	"Record via the receiver into the argument."
	"Answer a MusicEvent; if there's no note-off yet, put nil in the duration."

	| pa1 |
	pa1 := inputData first.
	pa1 length = 3
		ifFalse: [self error: ('Unknown MIDI packet (len = ', pa1 length printString, ')')].
	pa1 command = 16r90		"if note-on command..."
		ifTrue: [inputData do:	"look for note off."
			[ :pa2 | 
			pa2 pitch = pa1 pitch
				ifTrue: [(pa2 command = 16r80 or: [pa2 ampl = 0])
					ifTrue: [inputData removeFirst.
						inputData remove: pa2.
						^MusicEvent dur: (pa2 time - pa1 time) 
							pitch: pa1 pitch ampl: pa1 ampl voice: pa1 voice]]]]
		ifFalse: [self error: ('Unknown MIDI packet (cmd = ', 
						pa1 command printString, ')')].
	^MusicEvent dur: nil pitch: pa1 pitch ampl: pa1 ampl voice: pa1 voice!

nextMessage
	"Answer the first (length -> bytes) association from the input data collection."
	"MIDIPort instance nextMessage"

	^inputData isEmpty
		ifTrue: [nil]
		ifFalse: [inputData removeFirst]!

play: aPitch dur: aDur amp: anAmp voice: aVoice
	"Play a note (on/off message pair) with the given parameters on the receiver."
	"This is the default method for drivers with no 1-call noteOn/Off command."
	"Dur is assumed to be in msec."

	self playOn: aPitch amp: anAmp voice: aVoice.
"Schedule note-off in a forked wait block."
	aDur isNil
		ifFalse: [[(Delay forMilliseconds: aDur) wait.
				self playOff: aPitch amp: anAmp voice: aVoice] fork]!

play: streamID pitch: aPitch dur: aDur amp: anAmp voice: aVoice
	"Play a note (on/off message pair) with the given parameters on the receiver."
	"This is the default method for drivers with no 1-call noteOn/Off command."

	 | s v |
	v := (aVoice - 1) max: 0.		"zero-based stream and voice index"
	s := (streamID) " max: 0".
	(#open == status) ifFalse: [self openOutput].
	self playOn: s pitch: aPitch amp: anAmp voice: v.
"Schedule note-off in a forked wait block."
	aDur isNil
		ifFalse: [[(Delay forMilliseconds: aDur) wait.
				self playOff: s pitch: aPitch amp: anAmp voice: v] fork]!

playOff: streamID pitch: aPitch amp: anAmp voice: aVoice
	"Play a note-on command with the given parameters on the receiver."

	self subclassResponsibility!

playOn: streamID pitch: aPitch amp: anAmp voice: aVoice
	"Play a note-on command with the given parameters on the receiver."

	self subclassResponsibility!

put: data length: size
	"Send the argument data to the receiver now."

	self subclassResponsibility!

readController: index
	"Read the given controller value."

	| array |
	array := WordArray new: 1.
	array gcCopyToHeap.
	self readControllersFrom: index to: index into: array.
	^array first!

readControllersFrom: lo to: hi into: array
	"Read a range of controllers"

	self subclassResponsibility! !

!Siren.MIDIPort methodsFor: 'open/close'!

close
	"Close MIDI."
	"MIDIPort instance close"

	self subclassResponsibility!

open
	"Open the MIDI driver -- start the lower-level driver up."
	"MIDIPort default"

	self openOutput: self class out!

openInput
	"Open the MIDI driver -- start the lower-level driver up."
	"MIDIPort default"

	self openInput: self class in!

openInput: which
	"Open the MIDI driver -- start the lower-level driver up."
	"MIDIPort default"

	self subclassResponsibility!

openOutput
	"Open the MIDI driver -- start the lower-level driver up."
	"MIDIPort default"

	self openOutput: self class out!

openOutput: which
	"Open the MIDI driver -- start the lower-level driver up."
	"MIDIPort default"

	self subclassResponsibility!

reset
	"Reset the port."

	self allNotesOff! !

!Siren.MIDIPort methodsFor: 'ioctl'!

eventsAvailable
	"Answer the number of events in the input Q."
	"MIDIPort instance eventsAvailable"

	^inputData size!

hasBuffer
	"Answer whether the MIDI driver has a time-stamped output buffer."

	^false!

hasClock
	"Answer whether the MIDI driver has its own clock."

	^false!

hasControllerCache
	"Answer whether the MIDI driver supports a controller data buffer."

	^false!

hasDurs
	"Answer whether the MIDI driver supports a 1-call note-on/off command."

	^false!

readLoop
	"polling or waiting loop"

	self subclassResponsibility!

startControllerCaching
	"Start caching MIDI controller in the driver."

	self subclassResponsibility!

startMIDIEcho
	"Start echoing MIDI input from the driver."

	^self			"ignored"!

startMIDIInput
	"Start the polling loop (or semaphore waiter) MIDI input."
	"Create and start the reader process."

	self resetInput.
	readProcess := [self readLoop] newProcess.
	readProcess priority: (Processor userBackgroundPriority - 1).
	readProcess resume.!

stopControllerCaching
	"Stop caching MIDI controller in the driver."

	self subclassResponsibility!

stopMIDIEcho
	"Stop echoing MIDI input from the driver."

	^self			"ignored"!

stopMIDIInput
	"Stop signalling the read semaphore on MIDI input."

	readProcess ifNotNil: 
			[readProcess terminate.
			readProcess release].
	readProcess := nil.
	self breakDependents.! !



Smalltalk.Siren defineClass: #PortMIDIPort
	superclass: #{Siren.MIDIPort}
	indexedType: #none
	private: false
	instanceVariableNames: 'driver '
	classInstanceVariableNames: ''
	imports: '
			private MIDICommands.*
			private MIDIioctls.*
			private GeneralMIDIMap.*
			private GeneralMIDIDrums.*
			'
	category: 'MusicIO-MIDI'!

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!


!Siren.PortMIDIPort class methodsFor: 'class initialization'!

initializeData
	"Set up the class defaults."
	"PortMIDIPort initializeData"

	singleton := nil.
	devices := OrderedCollection new.
	properties := Array new.
	mutex := Semaphore forMutualExclusion.
	useSingleton := true.			"PortMIDI allows multiple port objects, but we don't use it..."
	out := SirenUtility defaultMIDIOut.
	in := SirenUtility defaultMIDIIn.
	rate := 0.
	blockSize := 0.! !

!Siren.PortMIDIPort class methodsFor: 'examples'!

dump
	"Dump port names"
	"PortMIDIPort dump"

	Transcript cr; show: 'Midi Device Table'; crtab.
	self devices do: [ :aDev | Transcript show: aDev port printString, ': ', aDev name.
					(aDev out = 1) ifTrue: [Transcript show: ' - in'] ifFalse: [Transcript show: ' - out']]
				separatedBy: [Transcript crtab].
	Transcript cr!

testANote
	"Open MIDI, play a note."
	"PortMIDIPort testANote"

	| inst |
	inst := MIDIPort new.		"this answers an instance of me."
	inst open.
	inst playOn: 48 amp: 100 voice: 0.
	1 wait.
	inst playOff: 48 amp: 100 voice: 0.
	inst close.
	inst terminate.
	MIDIPort cleanUp! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!


Siren.PortMIDIPort comment:
'An instance of PortMIDIPort is the interface to the external driver that talks to the PortMIDI interface.

Instance Variables:
	driver	<PortMidiInterface>  my I/O interface driver

Shared Variables:
	Devices	<Dictionary>  unised
	Streams	<IdentityDictionary key: Integer value: Integer>  the map between Siren devices and interface ports
'!

!Siren.PortMIDIPort methodsFor: 'accessing'!

isActive
	"Answer whether the receiver is active."

	^(status == #open)! !

!Siren.PortMIDIPort methodsFor: 'read/write'!

playOff: aPitch amp: anAmp voice: aVoice
	"Play the argument on the receiver--no duration-->no note-off."

	[self critical: [driver pm_write_data3: (Streams at: device) 
			with: ((MIDICommands at: #noteOff) bitOr: aVoice) 
			with: aPitch with: anAmp]]
		on: Error
		do: [ :ex | Transcript show: 'MIDI write error'; cr]!

playOff: streamID pitch: pitch amp: amp voice: voice
	"Play the argument on the receiver."

	self critical: 
		[driver pm_write_data3: (Streams at: streamID) 
					with: ((MIDICommands at: #noteOn) bitOr: voice) with: pitch with: 0]!

playOn: aPitch amp: anAmp voice: aVoice
	"Play the argument on the receiver--no duration-->no note-off."

	[self critical: [driver pm_write_data3: (Streams at: device)
			with: ((MIDICommands at: #noteOn) bitOr: aVoice) 
			with: aPitch with: anAmp]]
		on: Error
		do: [ :ex | Transcript show: 'MIDI write error.'; cr]!

playOn: streamID pitch: pitch amp: amp voice: voice
	"Play the argument on the receiver--no duration-->no note-off."

	self critical: 
		[driver pm_write_data3: (Streams at: streamID) 
				with: ((MIDICommands at: #noteOn) bitOr: voice) with: pitch with: amp]!

put: streamID data: data length: size
	"Send the argument (a ByteArray for historical reasons) to the receiver now."

	[(size < 2)
		ifTrue: [^self error: 'Unknown MIDI command format -- illegal length'].
	(size = 2)
		ifTrue: [^self critical: [driver pm_write_data2: streamID with: (data at: 1) with: (data at: 2)]].
	(size = 3)
		ifTrue: [^self critical: [driver pm_write_data3: streamID with: (data at: 1) with: (data at: 2) with: (data at: 3)]].
	(size > 3)
		ifTrue: [self halt]] 		"not supported yet"
			on: Error
			do: [ :ex | Transcript show: 'MIDI write error'; cr].
	^nil!

put: data length: size
	"Send the argument (a ByteArray for historical reasons) to the receiver now."

	^self put: (Streams at: device ifAbsent: [self error: 'MIDI port not found']) data: data length: size!

readControllersFrom: lo to: hi into: array
	"Read a range of controllers"

	self critical: [driver pm_read_controllers: (Streams at: device) with: lo with: hi with: array].! !

!Siren.PortMIDIPort methodsFor: 'initialize release'!

initialize
	"Setup the receiver's instance variables."
	"MIDIPort testANote"
	"PortMIDIPort devices"

	| return |
	super initialize.
	driver := PortMidiInterface new.
	return := driver pm_initialize.
	(return = 0)
		ifFalse: [self error: 'MIDI initialize failed'].
	status := #init.
	self class resetDevices.
	self critical: [1 to: driver pm_count_devices do:
		[ :cnt | | nam |
		nam := driver pm_get_name: cnt.
		self class devices add: (DeviceModel new name: nam copyCStringFromHeap asSymbol; 
						port: (cnt - 1); out: (driver pm_dev_dir: cnt))]].
	(SirenUtility verbosity > 1)
		ifTrue: [Transcript cr; show: 'Midi Device Table'; crtab.
			self class devices do: [ :aDev | Transcript show: aDev port printString, ': ', aDev name.
					(aDev out = 1) ifTrue: [Transcript show: ' - in'] ifFalse: [Transcript show: ' - out']]
				separatedBy: [Transcript crtab].
			Transcript cr]!

release
	"Release--break and dependencies on the error value."

	super release.
	[driver ifNotNil: [self critical: [driver pm_terminate]]]
		on: Error
		do: [ :ex | "ignore" ]! !

!Siren.PortMIDIPort methodsFor: 'ioctl'!

readLoop
	"The MIDI driver input process loop."

	| int packet delay dev |
	delay := Delay forMilliseconds: 5.					"default loop delay"
	dev := Streams at: device ifAbsent: [Streams at: self class in].
	self resetInput.
"LOOP"
	[true] whileTrue: 
		[((driver pm_poll: dev) = 0)				"poll"
			ifTrue: [delay wait]
			ifFalse: [self critical: [int := driver pm_read: dev].	"read"
				(int = 0) ifFalse: 
					[packet := MIDIPacket fromInt: int 		"parse"
								at: Time microsecondClock.
					SirenUtility log: '		', packet printString level:2.
					inputData addLast: packet.			"queue"
					self changed: #read]]]					"signal"!

startControllerCaching
	"Start caching MIDI controller in the driver."

	self critical: [driver pm_start_controller_cacheing]!

stopControllerCaching
	"Stop caching MIDI controller in the driver."

	self critical: [driver pm_stop_controller_cacheing]! !

!Siren.PortMIDIPort methodsFor: 'open/close'!

close
	"Close MIDI."
	"MIDIPort instance close"

	self close: device!

close: stream
	"Close MIDI."
	"MIDIPort instance close"

	| which |
	readProcess ifNotNil: 
			[readProcess terminate.
			readProcess release].
	readProcess := nil.
	self breakDependents.
	which := Streams at: stream ifAbsent: [nil].
	self critical: [which ifNotNil:
		[[driver pm_close: which]
			on: Error
			do: [ :ex | Transcript show: 'MIDI close error'; cr]]].
	status := #closed.
	^#OK!

open
	"Open the MIDI driver -- start the lower-level driver up."
	"MIDIPort default"

	self isActive
		ifTrue: [^self].
	^self openOutput: self class out!

openInput: dev
	"Open the MIDI driver -- start the lower-level driver up."
	"MIDIPort default"

	| which |
	[which := driver pm_open: dev with: 1]
		on: Error
		do: [ :ex | Transcript show: 'MIDI openInput error'; cr.
				which := -1].
	(which < 0)
		ifTrue: [self error: 'MIDI open failed'].
	device := dev.
	Streams at: dev put: which.
	status := #open.
	^which!

openOutput: dev
	"Open the MIDI driver -- start the lower-level driver up."
	"MIDIPort default"

	| which |
	status == #open ifTrue: [^self].
	self critical: [[which := driver pm_open: dev with: 0]
		on: Error
		do: [ :ex | which := 0.		"assume first slot"
				Transcript show: 'MIDI open failed'; cr]].
	(which < 0)
		ifTrue: [self error: 'MIDI open failed'].
	Streams at: dev put: which.
	status := #open.
	device := dev.
	^which!

terminate
	"Close MIDI."
	"MIDIPort instance close"

	driver pm_terminate.
	status := #init! !



Smalltalk.Siren defineClass: #MIDIVoice
	superclass: #{Siren.Voice}
	indexedType: #none
	private: false
	instanceVariableNames: 'currentTime '
	classInstanceVariableNames: 'useSingleton singleton default '
	imports: ''
	category: 'MusicIO-MIDI'!

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!


!Siren.MIDIVoice class methodsFor: 'examples'!

randomExample
	"Play some random notes on a voice on a device on a port."
	"MIDIVoice randomExample"

	| events voice |
	events := (EventList randomExample: 80 
		from: ((#duration: -> (20 to: 80)), (#pitch: -> (48 to: 80)),
				(#ampl: -> (84 to: 124)))).
	voice := MIDIVoice default.
	events playOn: voice!

scaleExample
	"Play a scale on a voice on a device on a port to the Apple MIDI Mgr."
	"MIDIVoice scaleExample"
	"MIDIPort allNotesOff"

	| voice device port scale |
	port := MIDIPort default.
	port open.
	device := MIDIDevice on: port.
	voice := MIDIVoice on: device.
	scale := EventList scaleFrom: 24 to: 100 in: 4.0.
"	scale eventsDo: [ :e | e duration: (e duration * 3)]."
	voice play: scale!

voiceInspect
	"MIDIVoice voiceInspect"

	(MIDIVoice on: (MIDIDevice on: (MIDIPort default))) inspect! !

!Siren.MIDIVoice class methodsFor: 'class initialization'!

defaultOutInterface
	"Answer the class's default interface # (use external device list to get the right value)."
	"MIDIVoice defaultOutInterface"

	^SirenUtility defaultMIDIOut!

flushDefault
	"Reset the class's default instance."
	"MIDIVoice flushDefault"

	singleton := nil!

initialize
	"Reset the class's default instance."
	"MIDIVoice initialize"

	singleton := nil.
	useSingleton := false.! !

!Siren.MIDIVoice class methodsFor: 'instance creation'!

default
	"Answer the default MIDIVoice."
	"MIDIVoice default"

	useSingleton
		ifTrue: [singleton ifNil: [singleton := MIDIVoice on: (MIDIDevice on: MIDIPort default)].
			^singleton]
		ifFalse: [^MIDIVoice on: (MIDIDevice on: MIDIPort default)]!

named: aName onDevice: aMidiDevice channel: aChannel
	"set up a MidiVoice on the given device and channel"
	"MIDIVoice named: 'xxx' onDevice: (MIDIDevice on: 1) channel: 1"

	| me |
	me := self new initializeNamed: aName.
	me instrument add: (aChannel -> aMidiDevice).
	^me!

new
	"Cache the latest instance."

	^self default!

on: aMidiDevice
	"Answer up a MidiVoice on the given device."
	"MIDIVoice on: (MIDIDevice on: (MIDIPort default openOutput))"

	| me |
	me := self basicNew initialize.
	me instrument: aMidiDevice.
	^me!

on: aMidiDevice channel: aChannel
	"set up a MidiVoice on the given device and channel"
	"MidiVoice onDevice: (MidiFB01 newOn: 1) channel: 1"

	| me |
	me := self new initializeNamed: aChannel.
	me instrument add: (aChannel -> aMidiDevice).
	^me! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!


Siren.MIDIVoice comment:
'A MidiVoice is used to play note events onto one or more output devices.
I store a MidiDevice (with a MIDIPort) in my instrument variable and play events onto it when asked to.

Instance variables:
	instrument	<MIDIDevice> my instrument, a MidiDevice
'!

!Siren.MIDIVoice methodsFor: 'events'!

play: anEventList
	"Expand the list and play it now."

	anEventList voice: self.
	^anEventList play!

playEvent: anEvent at: aTime
	"Send the given Event to the instrument."

	^aTime isNil
		ifTrue: [instrument play: anEvent at: Time microsecondClock]
		ifFalse: [instrument play: anEvent at: aTime usec value]! !

!Siren.MIDIVoice methodsFor: 'accessing'!

number
	"Answer my channel or icon number"

	| n |
	n := Number readFrom: (ReadStream on: (name)).
	n = 0 ifTrue: [^self channel].
	^n! !

!Siren.MIDIVoice methodsFor: 'initialize-release'!

close
	"Close the stream, device, or whatever."

	instrument close!

initialize
	"Set up a MIDIVoice's time counter."

	super initialize.
	currentTime := nil!

reset
	"Reset my time."
	
	currentTime := nil! !



Smalltalk.Siren defineClass: #MIDIDevice
	superclass: #{Siren.DeviceModel}
	indexedType: #none
	private: false
	instanceVariableNames: ''
	classInstanceVariableNames: ''
	imports: ''
	category: 'MusicIO-MIDI'!

Siren.MIDIDevice defineSharedVariable: #MStream
	private: false
	constant: false
	category: 'As yet unclassified'
	initializer: nil!

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!


!Siren.MIDIDevice class methodsFor: 'examples'!

playOnDevice
	"Play a note out MIDI from the device level."
	"self halt. MIDIDevice playOnDevice"
	"MIDIPort allNotesOff"
	"MIDIDevice initialize"
	"MStream inspect"

	| device port |
	port := MIDIPort new openOutput.
	device := MIDIDevice on: port.
	device play: (60 key, 500 msec, 96 velocity, (#voice -> 0)) at: 0.
	(Delay forSeconds: 1) wait.
	port allNotesOff.
	device close.
	Transcript show: ' done.'; cr.!

scheduleExample
	"Play MIDI using the event scheduler."
	"MIDIDevice scheduleExample"
	"EventScheduler interrupt; flush"

	 | device port voice scale start |
	port := MIDIPort default. 
	device := MIDIDevice on: port.
	voice := MIDIVoice on: device.
	scale := EventList scaleFrom: 36 to: 60 in: 2.0.
	scale scale: #duration by: 2.
	start := Time microsecondClock + 500000.
	scale events do: [ :ass |
		ass event voice: voice.
		ass key: (ass key value + start) usec.
		EventScheduler addClient: ass].
	"self halt."
	EventScheduler run! !

!Siren.MIDIDevice class methodsFor: 'class initialization'!

initialize
	"Set up the one class variable"
	"MIDIDevice initialize"

"	MStream := Transcript.
	MStream := WriteStream on: (String new: 4096).
"	MStream := nil! !

!Siren.MIDIDevice class methodsFor: 'instance creation'!

new
	"Open a generic MidiDevice on the default Port"
	"MIDIDevice new"

	| me |
	me := super new initialize.
"	me port: MIDIPort default open."
	^me!

on: port
	"Open a generic MidiDevice on the given Port"

	| me |
	me := super new initialize.
	me port: port.
	^me! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!


Siren.MIDIDevice comment:
'MIDIDevice is a subclass of Model whose instances are used to model MIDI input/output hardware devices.
The abstract class MIDIDevice implements the generic MIDI note on/off type events.
Subclasses of MIDIDevice exist for specific models of devices and  implement the device-specific (system exclusive) commands.
MIDIDevice are passed Events and channel numbers by their voices and generate commands as ByteArrays that they pass to MIDIPorts.
Several devices may share one port (if there are several MIDI-capable devices on one cable), and one voice may point to several device/channel pairs on one or more devices.

Instance variables:
	port <MidiPort> the MIDIPort I use
	stream <WriteStream> logging stream
	debug <Boolean> verbosity flag for Transcript dumping

Class variable:
	MStream	<WriteStream> the stream I dump by bytes on if my port is nil (good for debugging new subclasses)

Standard MIDI Commands:
		Note On = 9n kk vv
		Note Off = 8n kk vv
		Key Pressure = An kk vv
		Pitch Wheel = En ll ll
		After Touch Channel Pressure = Dn vv
		Control Change = Bn cc vv
		Program change = Cn pp

Relevant Constants for description of MIDI commands:
		n = 4-bit channel number
		kk = 7-bit key number
		vv = 7-bit key velocity
		ll = 7-bit low-order value
		hh = 7-bit high-order value
		cc = 7-bit control number
		pp = 7-bit program number'!

!Siren.MIDIDevice methodsFor: 'note events'!

play: anEvent at: aTime
	"Play the given event on my port as a default MIDI noteOn/noteOff pair."

	| p d a v now strm ch |
	now := Time microsecondClock.
	strm := stream.
	strm ifNil: [strm := SirenUtility defaultMIDIOut].
	(Delay forMicroseconds: aTime - now) wait.
	self checkPort.
	v := self mapVoice: anEvent voice.
	anEvent pitch isNil
		ifFalse: [p := self mapPitch: anEvent pitch.
			d := self mapDuration: anEvent dur.
			a := self mapAmplitude: anEvent ampl.
			debug ifNotNil: [MStream nextPutAll: 
					aTime value printString, ' ', p printString, ' ', 
					d printString,' ', a printString,' ', v printString; cr].
			port play: strm pitch: p value dur: d amp: a voice: v]
		ifTrue: [a := anEvent value rounded.		"if it's a control change"
			ch := anEvent controller.
			ch ifNotNil: [port controlChange: v controller: ch to: a]]! !

!Siren.MIDIDevice methodsFor: 'initialization'!

checkPort
	"Ensure that the receiver's output port is initialized."

	port == nil
		ifTrue: [port := MIDIPort default].!

close
	"Release the receiver's hold on the port."

"	Transcript show: 'MidiDevice reset: ', port printString; cr."
	port close.
	port := nil!

initialize
	"Set the receiver up on the default output port."
 
"	Transcript show: 'MidiDevice init...'; cr."
"	port == nil
		ifTrue: [port := MIDIPort default].
	stream := 1."!

initialize: thePort
	"Set the receiver up on the given output port."

"	Transcript show: 'MidiDevice init...'; cr."
	port == nil
		ifTrue: [port := thePort].!

play: anAss on: channelNumber
	"play the given event on my port as a default MIDI noteOn/noteOff pair"

	| s e |
	s := anAss key.
	e := anAss value.
	self checkPort.
	port ifNil:
		[^MIDIPort default play: (self mapPitch: e pitch) 
			at: s value 
			dur: (self mapDuration: e dur) 
			amp: (self mapAmplitude: e ampl) 
			voice: channelNumber].
	port play: (self mapPitch: e pitch) 
			at: s value 
			dur: (self mapDuration: e dur) 
			amp: (self mapAmplitude: e ampl) 
			voice: channelNumber! !

!Siren.MIDIDevice methodsFor: 'accessing'!

port
	"Answer the receiver's I/O port."

	^port!

port: aPort
	"Set the receiver's I/O port."

	port := aPort!

stream
	"Answer the receiver's MIDI stream ID."

	^stream!

stream: aNumber
	"Set the receiver's MIDI stream ID."

	stream := aNumber! !

!Siren.MIDIDevice methodsFor: 'parameter mapping'!

mapAmplitude: aVal
	"Map a numerical or symbolic amplitude to a MIDI-compatible 
	 volume number (key velocity)"


	^(aVal species == Amplitude 
		ifTrue: [aVal asMIDI value]
		ifFalse: [aVal class == SmallInteger 
			ifTrue: [^aVal]		"assume a volume number"
									"assume a dynamic name"
			ifFalse: [(aVal isNil or: [aVal value isNil])
				ifTrue: [64]
				ifFalse: [Amplitude value: aVal asMIDI]]])!

mapDuration: aVal
	"Map a numerical or symbolic duration value to a 
	 MIDI-compatible duration in msec."

	^(aVal species == Duration
		ifTrue: [aVal asMS value]"if duration type, answer msec"
		ifFalse: [aVal class == SmallInteger
			ifTrue: [aVal]		"if Int, assume mec"
									"else assume a symbolic or float dur"
			ifFalse: [aVal isNil
				ifTrue: [nil]
				ifFalse: [Duration value: aVal asMidi]]])!

mapPitch: aVal
	"Map a numerical or symbolic pitch to a MIDI-compatible note number."

	aVal ifNil: [^nil].
	^(aVal species == Pitch
		ifTrue: [aVal asMIDI value]
		ifFalse: [aVal class == SmallInteger
			ifTrue: [aVal]			"assume a note number"
										"assume a note name or freq"
			ifFalse: [Pitch value: aVal asMidi]])!

mapVoice: aVal
	"Map a numerical or symbolic pitch to a MIDI-compatible note number."

	^(aVal isInteger
		ifTrue: [(aVal truncated min: 15) max: 0]
		ifFalse: [aVal species == Voice
			ifTrue: [aVal asNumber]
			ifFalse: [1]])! !



Smalltalk.Siren defineClass: #MIDIFB01
	superclass: #{Siren.MIDIDevice}
	indexedType: #none
	private: false
	instanceVariableNames: ''
	classInstanceVariableNames: ''
	imports: ''
	category: 'MusicIO-MIDI'!

Siren.MIDIFB01 comment:
'MidiFB01 is a type of MidiDevice for the system exclusive commands of the Yamaha FB-01 synthesiser.
It implements the special commands available here (like note commands with fractional pitch and given duration).

The standard FB01 note command is like:
		2n k f v d1 d2 = cmd:channel, noteNum, frac, vel, durLow, durHigh
'!

!Siren.MIDIFB01 methodsFor: 'note events'!

play: anEvent on: aChannel
	"send FB01-specific code for note with fraction and duration
		2n k f v d1 d2 = cmd:channel, noteNum, frac, vel, durLow, durHigh"

	| bytes realDur |
	bytes := ByteArray new: 6.
	bytes at: 1 put: (16r20 + aChannel).
	bytes at: 2 put: (self mapPitch: anEvent pitch).
	bytes at: 3 put: 0.
	bytes at: 4 put: (self mapAmplitude: anEvent ampl).
	realDur := self mapDuration: anEvent duration.
	bytes at: 5 put: (realDur bitAnd: 127).
	bytes at: 6 put: (realDur bitShift: -7 ).
	port == nil
		ifTrue: [MStream nextPutAll: 'FB01: ', bytes printString; cr]
		ifFalse: [port put: bytes length: 6]! !



Smalltalk.Siren defineClass: #MIDIPF70
	superclass: #{Siren.MIDIDevice}
	indexedType: #none
	private: false
	instanceVariableNames: ''
	classInstanceVariableNames: ''
	imports: ''
	category: 'MusicIO-MIDI'!

Siren.MIDIPF70 comment:
'MidiPF70 is a type of MidiDevice for the system exclusive commands of the Yamaha PF-70 electric piano.
It implements the special commands available here (like note commands with fractional pitch and given duration).

The standard PF70 note command is like:
		2n k f v d1 d2 = cmd:channel, noteNum, frac, vel, durLow, durHigh
'!



Smalltalk.Siren defineClass: #MIDIDump
	superclass: #{UI.Model}
	indexedType: #none
	private: false
	instanceVariableNames: 'eventList live notesOn startedAt '
	classInstanceVariableNames: ''
	imports: '
			private MIDICommands.*
			'
	category: 'MusicIO-MIDI'!

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!


!Siren.MIDIDump class methodsFor: 'instance creation'!

new
	^super new initialize! !

!Siren.MIDIDump class methodsFor: 'examples'!

example
	"Set up a MIDI dump object as a dependent of the input port. Dump for 10 seconds,
	then turn off. The default update: method just dumps the MIDI packet into the transcript; 
	customize this by writing your own update: method."
	"MIDIDump example"

	| inst port |
"Get a MIDIDump and the input port."
	inst := MIDIDump new.
	port := MIDIPort new openInput.
"Add the dump as a dependent of the port."
	port addDependent: inst.
"Turn on the port for input."
	port stopMIDIEcho.
	port stopControllerCaching.
	port startMIDIInput.
"Wait"
	Cursor wait showWhile: [(Delay forSeconds: 5) wait].
"Turn the port off"
	port stopMIDIInput.
	port close.
"Don't forget to remove the dependent."
	port removeDependent: inst.!

exampleEditor
	"Set up a MIDI dump object as a dependent of the input port. Capture it to an event list and update the view in real time BROKEN."
	"MIDIDump exampleEditor"

	| inst port list |
"Get a MIDIDump and the input port."
	inst := MIDIDump new.
	inst live: true.
	list := EventList newAnonymous.
	list edit.
	inst eventList: list.
	port := MIDIPort new openInput.
"Add the dump as a dependent of the port."
	port addDependent: inst.
"Turn on the port for input."
	port stopMIDIEcho.
	port stopControllerCaching.
	port startMIDIInput.
"Wait"
	Cursor wait showWhile: [(Delay forSeconds: 5) wait].
"Turn the port off"
	port stopMIDIInput.
	port close.
"Don't forget to remove the dependent."
	port removeDependent: inst.!

exampleList
	"Set up a MIDI dump object as a dependent of the input port. Capture it to an event list."
	"MIDIDump exampleList"
	"PortMidiInterface unloadLibraries"

	| inst port list |
"Get a MIDIDump and the input port."
	inst := MIDIDump new.
	list := EventList newAnonymous.
	list code: #noteOnOff.
	inst eventList: list.
	port := MIDIPort new openInput.
"Add the dump as a dependent of the port."
	port addDependent: inst.
"Turn on the port for input."
	port stopMIDIEcho.
	port stopControllerCaching.
	port startMIDIInput.
"Wait"
	Cursor wait showWhile: [(Delay forSeconds: 5) wait].
"Turn the port off"
	port stopMIDIInput.
	port close.
"Don't forget to remove the dependent."
	port removeDependent: inst.
	list setDurations.
	list "inspect" edit! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!


Siren.MIDIDump comment:
'An instance of MIDIDump is used as a dependent of the MIDIPort to demonstrate the use of dependency for MIDI input. See the class example.

Instance Variables:
	verbose <Boolean> should I log events to the Transcript?
	live <Boolean> should I match noteOn/Off commands on the fly?
	eventList <EventList> the event list I''m capturing input to
	notesOn <OrderedCollection of MusciEvents> the current playing notes
	startedAt <Integer> the clock time I was started at
'!

!Siren.MIDIDump methodsFor: 'updating'!

update: aspect with: aParameter from: aSender
	"The model (port) changed; add the event to our event list."
	"MIDIDump exampleList"

	| packet evt cmd found time |
	packet := aSender input removeFirst.
	SirenUtility log: packet printString.
	eventList ifNil: [^self].
	cmd := packet command.
	live
		ifTrue: [(cmd = (MIDICommands at: #noteOn) and: [packet ampl ~= 0])
			ifTrue: [^notesOn add: (MusicEvent dur: packet time pitch: packet pitch 
								ampl: packet ampl voice: packet voice)].
			(cmd = (MIDICommands at: #noteOff) or: [packet ampl = 0])
			ifTrue: [found := notesOn removeAllSuchThat: 
					[ :ev | ((ev pitch value = packet pitch) and: [ev voice =  packet voice])].
				found isEmpty
					ifTrue: [^Transcript show: 'No note-on found for ', packet printString; cr].
				evt := found first.
				time := evt dur value.
				evt dur: (packet time - time).			"fix the event's duration"
				^eventList add: evt at: time - startedAt]]
		ifFalse: [^eventList add: ((MusicEvent pitch: packet pitch 
							ampl: packet ampl voice: packet voice) 
						command: cmd) at: (packet time - startedAt)].
	SirenUtility log: 'Unrecognized packet: ', packet printString! !

!Siren.MIDIDump methodsFor: 'accessing'!

eventList

	^eventList!

eventList: aValue

	eventList := aValue!

live: aValue

	live := aValue! !

!Siren.MIDIDump methodsFor: 'initialize release'!

initialize
	"Setup the receiver's instance variables."

	live := false.
	notesOn := OrderedCollection new.
	startedAt := Time microsecondClock! !

#{Siren.MIDIVoice} initialize!

#{Siren.MIDIDevice} initialize!
