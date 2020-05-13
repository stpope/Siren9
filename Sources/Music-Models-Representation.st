

Smalltalk.Siren defineClass: #MusicMagnitude
	superclass: #{Core.Magnitude}
	indexedType: #none
	private: false
	instanceVariableNames: 'value '
	classInstanceVariableNames: ''
	imports: ''
	category: 'Music-Models-Representation'!

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!


!Siren.MusicMagnitude class methodsFor: 'class constants'!

color
	"Answer the default color to display instances with (hack for making pretty graphs)."

	| spec |
	spec := self new species.
	^(spec == MusicMagnitude)
		ifTrue: [ColorValue gray]
		ifFalse: [spec color]!

propertyName
	"Answer the receiver class's default property name."

	^self subclassResponsibility!

relativeMember
	"Answer the receiver class's species member used as a relative magnitude."

	^self subclassResponsibility! !

!Siren.MusicMagnitude class methodsFor: 'instance creation'!

value: aValue
	"Answer and instance with the argument as its value."

	^self new value: aValue! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!


Siren.MusicMagnitude comment:
'Instances of the subclasses of MusicMagnitude are used to represent scalar magnitudes in musical objects. The class MusicMagnitude is a place for the music magnitudes to share their state and basic accessing behavior.

MusicMagnitudes generally implement precise mixed-mode arithmetic and comparison methods using a per-species generality table and auto-coercion within a species.

The "type abstraction" classes (Duration, Pitch, Amplitude, etc.) represent "what"; they are never instantiated; their class creation methods answer instances of their species, but they manage coercion within the classes of their species. The "representational abstraction" classes (NominalMagnitude, OrdinalMagnitude, NumericalMagnitude, RatioMagnitude, etc.) represent "how"; they share value model semantics and coercion techniques. Note that the concrete implementation classes therefore answer their species by property model rather than by implementation subclass (i.e., HertzPitch species --> Pitch rather than NumericalMagnitude).

MusicMagnitudes can have dependents (observers), and send themselves the changed: message when their values are changed.

There are many examples in the implementation classes and the Siren  outline.

Instance variables:
	value		<Number or Symbol> the magnitude''s value
'!

!Siren.MusicMagnitude methodsFor: 'comparing'!

< aValue
	"Answer whether the receiver is less than the argument"
	"100 msec < 0.2 sec"

	| arr more |
	^(aValue class == self class)
		ifTrue: [self value < aValue value]
		ifFalse: [(aValue species == self species)
			ifTrue: [arr := self species generalize: self and: aValue.
				more := arr first.
				more == self 		"if I'm the more general"
					ifTrue: [aValue value < ((self coerceTo: aValue class) value)]
					ifFalse: [self value < ((aValue coerceTo: self class) value)]]
			ifFalse: [value < aValue]]!

= aValue
	"Answer whether the receiver and the argument are equal."

	| arr more less |
	^(aValue class == self class)
		ifTrue: [self value = aValue value]
		ifFalse: [(aValue species == self species)
			ifTrue: [arr := self species generalize: self and: aValue.
				more := arr first.
				less := arr last.
				(more value = (less coerceTo: more class) value)]
			ifFalse: [value = aValue]]!

hash
	"Answer a SmallInteger unique to the receiver."

	^value hash! !

!Siren.MusicMagnitude methodsFor: 'accessing'!

, anArgument
	"Answer en Event with the given magnitude as its first property."
	"440 Hz, 250 msec"

	| event |
	event := MusicEvent new.
	event perform: self species propertyName with: self.
	anArgument isMusicMagnitude ifTrue:
		[event perform: anArgument species propertyName with: anArgument].
	^event!

value
	"Answer the instance variable 'value'."

	^value!

value: theValue
	"Accept the argument, 'theValue', as the new instance variable 'value' 
		and signal any dependents."

	value := theValue.
	self changed: #value with: value! !

!Siren.MusicMagnitude methodsFor: 'testing'!

isImmediate
	"Answer whether the receiver has an immediate representation."

	^self units ~~ nil!

isMusicMagnitude
	"Answer true for the receiver and all subsclasses."

	^true! !

!Siren.MusicMagnitude methodsFor: 'arithmetic'!

* aValue
	"Answer the product of the receiver and the argument"

	| arr more less |
	^(aValue class == self class)
		ifTrue: [self class new value: (self value * aValue value)]
		ifFalse: [(aValue species == self species)
			ifTrue: [arr := self species generalize: self and: aValue.
				more := arr first.
				less := arr last.
				more class new value: (more value * (less coerceTo: more class) value)]
			ifFalse: [self class new value: (value * aValue)]]!

+ aValue
	"Answer the sum of the receiver and the argument, doing generality-based
	class coercion within a species using auto-generated coercion messages."
	"If the same class, add values directly."
	"If the same species, add values coercing generality."
	"1 sec + 10 msec"

	| arr more less |
	^(aValue class == self class)
		ifTrue: [self class new value: (self value + aValue value)]
		ifFalse: [(aValue species == self species)
			ifTrue: [arr := self species generalize: self and: aValue.
				more := arr first.
				less := arr last.
				more class new value: (more value + (less coerceTo: more class) value)]
			ifFalse: [self class new value: (value + aValue)]]!

- aValue
	"Answer the difference of the receiver and the argument"

	| arr more less |
	^(aValue class == self class)
		ifTrue: [self class new value: (self value - aValue value)]
		ifFalse: [(aValue species == self species)
			ifTrue: [arr := self species generalize: self and: aValue.
				more := arr first.
				less := (arr last coerceTo: more class) value.
				more == self
					ifTrue: [more class new value: (more value - less)]
					ifFalse: [more class new value: (less - more value)]]
			ifFalse: [self class new value: (value - aValue)]]!

/ aValue
	"Answer the quotient of the receiver and the argument"

	| arr more less |
	^(aValue class == self class)
		ifTrue: [self class new value: (self value / aValue value)]
		ifFalse: [(aValue species == self species)
			ifTrue: [arr := self species generalize: self and: aValue.
				more := arr first.
				less := (arr last coerceTo: more class) value.
				more == self
					ifTrue: [more class new value: (more value / less)]
					ifFalse: [more class new value: (less / more value)]]
			ifFalse: [self class new value: (value / aValue)]]! !

!Siren.MusicMagnitude methodsFor: 'private'!

species
	"Answer MusicMagnitude."

	^MusicMagnitude! !

!Siren.MusicMagnitude methodsFor: 'printing'!

printOn: aStream
	"Print the receiver on the argument as a MM declaration."

	^self printOn: aStream parens: true!

printOn: aStream parens: useParens
	"Print the receiver on the argument as a MM declaration."

	useParens
		ifTrue: [self isImmediate
			ifFalse: [aStream nextPutAll: '(', self species name, ': ', 
				self printValue, ')']
			ifTrue: [aStream nextPutAll: '(', self printValue, self units, ')']]
		ifFalse: [self isImmediate
			ifFalse: [aStream nextPutAll: self species name, ': ', self printValue]
			ifTrue: [aStream nextPutAll: self printValue, self units]]!

printString
	"Answer a String whose characters are a description of the receiver."

	| aStream |
	aStream := WriteStream on: (String new: 16).
	self printOn: aStream  parens: true.
	^aStream contents!

printStringParens: bool
	"Answer a String whose characters are a description of the receiver."

	| aStream |
	aStream := WriteStream on: (String new: 16).
	self printOn: aStream  parens: bool.
	^aStream contents!

printValue

	value isString ifTrue: [^value].
"	value isFloat ifTrue: [^value printPlaces: 4].
"	^value printString!

storeOn: aStream
	"Store the receiver on the argument as a MM declaration."

	aStream nextPutAll: '(', self class name, ' value: ', value printString, ')'!

units
	"Answer the units string of the receiver."

	^nil! !

!Siren.MusicMagnitude methodsFor: 'converting'!

adaptToNumber: rcvr andSend: selector
	"If I am involved in arithmetic with a number, convert me to a number."

	^self class value: (rcvr perform: selector with: self value)!

coerceTo: type
	"Coerce the receiver to the given class and answer a new object."

	^self perform: type ddMsgName!

ddMsgName
	"Answer the selector to be used in coercing double-dispatching messages."

	^self class ddMsgName!

msec
	"Answer a MSecondDuration."

	^self asMsec!

usec
	"Answer a MSecondDuration."

	^self asUsec! !



Smalltalk.Siren defineClass: #MusicModel
	superclass: #{Siren.MusicMagnitude}
	indexedType: #none
	private: false
	instanceVariableNames: ''
	classInstanceVariableNames: 'generalityTable '
	imports: ''
	category: 'Music-Models-Representation'!

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!


!Siren.MusicModel class methodsFor: 'generality'!

generality
	"Answer the class inst var for the generality table."

	^generalityTable!

generalize: aMag and: otherMag
	"Answer an array of the two arguments with the most general first."

	^(generalityTable at: aMag class) > (generalityTable at: otherMag class)
		ifTrue: [Array with: aMag with: otherMag]
		ifFalse: [Array with: otherMag with: aMag]! !

!Siren.MusicModel class methodsFor: 'examples'!

examples

	"Pitch generalize: (#c pitch) and: (21 key)"
	"Pitch generalize: (#c pitch) and: (220 Hz)"
	"Pitch generalize: (220 Hz) and: (#c pitch)"
	"Amplitude generalize: (21 dB) and: (88 velocity)"
	"Amplitude generalize: (#ff ampl) and: (127 velocity)"
	"Duration generalize: (100 msec) and: ((1/4) beat)"
	"Duration generalize: (100 msec) and: (0.3 sec)"

	 (#ff ampl) - (32 velocity)! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!


Siren.MusicModel comment:
'MusicModel adds the class instance variable generalityTable that is used for "abstract" music magnitude models such as Pitch and Amplitude.

See the class methods for generality.

Class inst Vars:
	generalityTable <Dictionary of (Class ->Integer)> The species generality table
'!



Smalltalk.Siren defineClass: #Ergon
	superclass: #{Siren.MusicModel}
	indexedType: #none
	private: false
	instanceVariableNames: ''
	classInstanceVariableNames: ''
	imports: ''
	category: 'Music-Models-Representation'!

Siren.Ergon comment:
'Class Ergon is the abstract representational class for the amplitude/loudness/dynamic species.
Instances of its subclass species are used to model loudness values.'!



Smalltalk.Siren defineClass: #Amplitude
	superclass: #{Siren.Ergon}
	indexedType: #none
	private: false
	instanceVariableNames: ''
	classInstanceVariableNames: ''
	imports: ''
	category: 'Music-Models-Representation'!

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!


!Siren.Amplitude class methodsFor: 'class constants'!

color
	"Answer the default color to display instances with."

	^ColorValue blue!

initialize
	"Set up the class inst var, a generality table."
	"Amplitude initialize"
	"Amplitude generalize: (21 dB) and: (88 velocity)"
	"Amplitude generalize: (#ff ampl) and: (127 velocity)"

	generalityTable :=
		((DBLoudness -> 80),
		(RatioLoudness -> 80),
		(MIDIVelocity -> 40),
		(SymbolicLoudness -> 20))!

initializeGenerality
	"Set up the class inst var, a generality table."
	"Amplitude initialize"
	"Amplitude generalize: (21 dB) and: (88 velocity)"
	"Amplitude generalize: (#ff ampl) and: (127 velocity)"

	generalityTable :=
		((DBLoudness -> 80),
		(RatioLoudness -> 80),
		(MIDIVelocity -> 40),
		(SymbolicLoudness -> 20))!

mostGeneral
	"Answer the most general-purpose duration--relative"

	^#asRatio!

propertyName
	"Answer the receiver class's default property name."

	^#loudness:!

relativeMember
	"Answer the receiver class's species member used as a relative magnitude."

	^RatioLoudness!

species
	"Answer Amplitude."

	^Amplitude! !

!Siren.Amplitude class methodsFor: 'examples'!

example
	"Print a simple message to the transcript demonstrating the various types."
	"SymbolicLoudness nameMap inspect"
	"Amplitude example"

	| me |
	me := Amplitude value: #mf.
	Transcript show: me printString; cr;
		show: me asRatio printString; cr;
		show: me asMIDI printString; cr.
	me inspect! !

!Siren.Amplitude class methodsFor: 'instance creation'!

value: aValue
	"Answer a new instance of a member of my species."

	aValue species == Amplitude ifTrue: [^aValue].
	(aValue isMemberOf: SmallInteger)
			ifTrue: [^MIDIVelocity new value: aValue].
	(aValue isKindOf: LimitedPrecisionReal)
			ifTrue: [^RatioLoudness new value: aValue].
	(aValue isMemberOf: Fraction)
			ifTrue: [^RatioLoudness new value: aValue].
	(aValue isKindOf: String)
			ifTrue: [^SymbolicLoudness new value: aValue asSymbol].
	^self new value: aValue! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!


Siren.Amplitude comment:
'Instances of classes whose species is Amplitude are used for the loudness parameters of musical events.
Amplitudes come in several flavors, as in the classes RatioMagnitude, MIDIVelocity and SymbolicLoudness.
The class Amplitude is abstract, its class creation method answers an instance of a concrete Amplitude/Loudness class.

Examples:
	Amplitude value: 0.77		"create a ratio instance - range 0.0 to 1.0 (cmusic)"
	Amplitude value: 77		"create an MIDI instance - range 0 to 127"
	Amplitude value: #mp		"create a symbolic instance - range #ppp to #fff"

See also the class example.'!



Smalltalk.Siren defineClass: #Positus
	superclass: #{Siren.MusicModel}
	indexedType: #none
	private: false
	instanceVariableNames: ''
	classInstanceVariableNames: ''
	imports: ''
	category: 'Music-Models-Representation'!

Siren.Positus comment:
'Class Positus is the abstract representational class for the position, space, and direction species.
Instances of its subclass species are used to model spatial and positional values.'!



Smalltalk.Siren defineClass: #Position
	superclass: #{Siren.Positus}
	indexedType: #none
	private: false
	instanceVariableNames: ''
	classInstanceVariableNames: ''
	imports: ''
	category: 'Music-Models-Representation'!

Siren.Position comment:
'Instances of the Position species model the position of sound sources in room simulations or scores.
This class can be used as a concrete one (adding a few methods to fill it out), or like the other representational classes (making concrete classes of this species).
In the later case, the value instance variable could hold a number or point.'!



Smalltalk.Siren defineClass: #Chronos
	superclass: #{Siren.MusicModel}
	indexedType: #none
	private: false
	instanceVariableNames: ''
	classInstanceVariableNames: ''
	imports: ''
	category: 'Music-Models-Representation'!

Siren.Chronos comment:
'Class Chronos is the abstract representational class for the duration and meter species.
Instances of its subclass species are used to model times, durations and metronomes.'!



Smalltalk.Siren defineClass: #Meter
	superclass: #{Siren.Chronos}
	indexedType: #none
	private: false
	instanceVariableNames: ''
	classInstanceVariableNames: ''
	imports: ''
	category: 'Music-Models-Representation'!

Siren.Meter comment:
'Instances of the Meter species model the tempo or metronome used to map durations.
This class can be used as a concrete one (adding a few methods to fill it out), or like the other representational classes (making concrete classes of this species).
In the later case, the value instance variable could hold a number, process or block.'!



Smalltalk.Siren defineClass: #Chroma
	superclass: #{Siren.MusicModel}
	indexedType: #none
	private: false
	instanceVariableNames: ''
	classInstanceVariableNames: ''
	imports: ''
	category: 'Music-Models-Representation'!

Siren.Chroma comment:
'Class Chroma is the abstract representational class for the pitch and mode-element species.
Instances of its subclass species are used to model pitches, gamut members, and frequencies.'!



Smalltalk.Siren defineClass: #ModeMember
	superclass: #{Siren.Chroma}
	indexedType: #none
	private: false
	instanceVariableNames: ''
	classInstanceVariableNames: ''
	imports: ''
	category: 'Music-Models-Representation'!

Siren.ModeMember comment:
'Instances of the ModeMember species model pitches as elements of a mode (e.g., minor) or gamut (e.g., pentatonic on F).
This class can be used as a concrete one (adding a few methods to fill it out), or like the other representational classes (making concrete classes of this species).
In the later case, the value instance variable could hold a number or pitch, and the mode or gamut could be shared.'!



Smalltalk.Siren defineClass: #Pitch
	superclass: #{Siren.Chroma}
	indexedType: #none
	private: false
	instanceVariableNames: ''
	classInstanceVariableNames: ''
	imports: ''
	category: 'Music-Models-Representation'!

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!


!Siren.Pitch class methodsFor: 'class constants'!

color
	"Answer the default color to display instances with."

	^ColorValue green!

initialize
	"Set up the class inst var, a generality table."
	"Pitch initialize"
	"Pitch generalize: (#c pitch) and: (21 key)"
	"Pitch generalize: (#c pitch) and: (220 Hz)"
	"Pitch generalize: (220 Hz) and: (#c pitch)"

	generalityTable :=
		((HertzPitch -> 80),
		(RatioPitch -> 60),
		(MIDIPitch -> 40),
		(SymbolicPitch -> 20))!

initializeGenerality
	"Set up the class inst var, a generality table."
	"Pitch initializeGenerality"
	"Pitch generalize: (#c pitch) and: (21 key)"
	"Pitch generalize: (#c pitch) and: (220 Hz)"
	"Pitch generalize: (220 Hz) and: (#c pitch)"

	generalityTable :=
		((HertzPitch -> 80),
		(RatioPitch -> 60),
		(MIDIPitch -> 40),
		(SymbolicPitch -> 20))!

mostGeneral
	"Answer the most general-purpose duration--Hertz"

	^#asHz!

propertyName
	"Answer the receiver class's default property name."

	^#pitch:!

relativeMember
	"Answer the receiver class's species member used as a relative magnitude."

	^RatioPitch!

species
	"Answer Pitch."

	^Pitch! !

!Siren.Pitch class methodsFor: 'examples'!

example
	"Print a simple message to the transcript demonstrating the various types."
	"SymbolicPitch nameMap inspect"
	"Pitch example"

	| me |
	me := Pitch value: 'c3'.
	Transcript show: me printString; cr;
		show: me asHertz printString; cr;
		show: me asMIDI printString; cr.
	me inspect!

exampleAdC
"Pitch exampleAdC"
	
	"Some examples of where current Pitch implementation is problematic:"

	"440.0 Hz asSymbol"	"shows up as a5, not the standard MIDIname a3."
	"445 Hz asMIDI"		"is quantized down OK, but should be a3/note 69 also."	
	"439.9 Hz asSymbol"			"gets quantized down to g#!!"
	"60 key asHertz asMIDI"		"does not survive conversion as MIDInote 60."

	"My suggestions:"
	"438 Hz asSymbol"  	"rounds to nearest chromatic note, a3."
	"443.5 Hz asMIDI"	"detto."
	"265 Hz asFracMIDI"	"converts to float chromatics; can be rounded, used 						for MIDI pitch bend or for precise synthesis in Hz."
	"61.26 key asHertz"	"float chromatics can also be used directly; for 					microtonal scales this is clearer than Hz (to me at least)."

	"260.0 Hz asFracSymbol inspect" 	"is rounded, but keeps track of offsets in  						an inst var (fracPitch); survives conversions etc."

	"Note that asMIDI and asSymbol can now be used to round pitches to 	chromatics, while asFracMIDI and asFracSymbol keep microtonal 	precision."! !

!Siren.Pitch class methodsFor: 'instance creation'!

value: aValue
	"Answer a new instance of a member of my species."

	aValue species == Pitch ifTrue: [^aValue].
	(aValue isMemberOf: SmallInteger)
			ifTrue: [^MIDIPitch new value: aValue].
	(aValue isKindOf: LimitedPrecisionReal)
			ifTrue: [^HertzPitch new value: aValue].
	(aValue isMemberOf: Fraction)
			ifTrue: [^RatioPitch new value: aValue].
	(aValue isKindOf: String)
			ifTrue: [^SymbolicPitch new value: aValue asSymbol].
	^self new value: aValue! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!


Siren.Pitch comment:
'Instances of classes whose species is Pitch are used for the pitch or frequency parameters of musical events.
Pitches come in several flavors, as in the classes HertzPitch, RatioPitch, MIDIPitch and SymbolicPitch.
The class Pitch is abstract, its class creation method answers an instance of a concrete Pitch class.

Examples:
	Pitch value: 440.0 	"create an instance with units of Hertz"
	Pitch value: 77		"create an instance with units of MIDI key numbers"
	Pitch value: #e4		"create a symbolic instance"
	Pitch value: ''e4''		"same as using a symbol"
	Pitch value: 4/3		"create a ratio instance"

Note that new pitch representations such as music11-like pch (4.11 = 11th note in oct 4) or oct (4.1100 = oct4 + 1100 cts) notations can be added by overriding the float-to-Hz or float-to-midi conversions.

See also the class example.'!



Smalltalk.Siren defineClass: #Duration
	superclass: #{Siren.Chronos}
	indexedType: #none
	private: false
	instanceVariableNames: ''
	classInstanceVariableNames: ''
	imports: ''
	category: 'Music-Models-Representation'!

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!


!Siren.Duration class methodsFor: 'class constants'!

color
	"Answer the default color to display instances with."

	^ColorValue red!

initialize
	"Set up the class inst var, a generality table."
	"Duration initialize"
	"Duration generalize: (100 msec) and: ((1/4) beat)"
	"Duration generalize: (100 msec) and: (0.3 sec)"

	generalityTable :=
		((SecondDuration -> 80),
		(RatioDuration -> 60),
		(MSecondDuration -> 40),
		(ConditionalDuration -> 0))!

initializeGeneralities
	"Set up the class inst var, a generality table."
	"Duration initializeGeneralities"
	"Duration generalize: (100 msec) and: ((1/4) beat)"
	"Duration generalize: (100 msec) and: (0.3 sec)"

	generalityTable :=
		((SecondDuration -> 80),
		(RatioDuration -> 60),
		(MSecondDuration -> 40),
		(ConditionalDuration -> 0))!

mostGeneral
	"Answer the most general-purpose duration--seconds"

	^#asSec!

propertyName
	"Answer the receiver class's default property name."

	^#duration:!

relativeMember
	"Answer the receiver class's species member used as a relative magnitude."

	^RatioDuration!

species
	"Answer Duration."

	^Duration! !

!Siren.Duration class methodsFor: 'examples'!

example
	"Print a simple message to the transcript demonstrating the various types."
	"Duration example"

	| me |
	me := Duration value: 1/4.
	Transcript show: me printString; cr;
		show: me asMS printString; cr.
	me inspect! !

!Siren.Duration class methodsFor: 'instance creation'!

value: aValue
	"Answer a new instance of a member of my species."

	| number |
	aValue species == Duration ifTrue: [^aValue].
	(aValue isMemberOf: SmallInteger)
		ifTrue: [aValue < 10
			ifTrue: [^SecondDuration new value: aValue]
			ifFalse: [^MSecondDuration new value: aValue]].
	(aValue isKindOf: LimitedPrecisionReal)
		ifTrue: [^SecondDuration new value: aValue].
	(aValue isMemberOf: Fraction)
		ifTrue: [^RatioDuration new value: aValue].
	(aValue isKindOf: String)
		ifTrue: [number := Number readFrom: (ReadStream on: aValue).
			number = 0 ifTrue: [^self error: 'Unknown duration value.'].
			^Duration value: number].
	(aValue isMemberOf: BlockContext)
		ifTrue: [^ConditionalDuration new value: aValue].
"	^self error: 'Unknown duration type.'"
	^aValue! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!


Siren.Duration comment:
'Instances of classes whose species is Duration are used for the duration parameters of musical events.
Durations come in several flavors, as in the classes RatioDuration, MSecondDuration and ConditionalDuration.
The class Duration is abstract, its class creation method answers an instance of a concrete Duration class.

Examples:
	Duration value: 0.77		"create an instance with seconds as the unit"
	Duration value: 770		"create an instance with milliseconds as the unit"
	Duration value: 1/4		"create an instance with beats as the unit"
	Duration value: [ :x | x > 4]	"create an instance for: ''until x > 4''"

See also the class example.'!



Smalltalk.Siren defineClass: #PField
	superclass: #{Siren.MusicMagnitude}
	indexedType: #none
	private: false
	instanceVariableNames: 'name field '
	classInstanceVariableNames: ''
	imports: ''
	category: 'Music-Models-Representation'!

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!


!Siren.PField class methodsFor: 'instance creation'!

field: aNumber value: aValue
	"Answer an initialized instance."

	^(self new) field: aNumber; value: aValue!

field: aNumber value: aValue name: aName
	"Answer an initialized instance."

	^(self new) field: aNumber; value: aValue; name: aName! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!


Siren.PField comment:
'Instances of PField magnitudes are used for arbitrary parameters of musical events oriented towards formats with positional parameter declarations, e.g., Music-V-style notelist formats (see uses).

Instance variables:
	field <Integer> field in the score
	name <String or Symbol> the parameter''s name (optional)

Examples:
	PField field: 5 value: 0.7 name: #position
	PField field: 9 value: ''legato'' name: #expression
'!

!Siren.PField methodsFor: 'accessing'!

field
	"Answer the instance variable 'field'."

	^field!

field: theNumber
	"Accept the argument, 'theNumber', as the new instance nariable 'field'."

	field := theNumber!

name
	"Answer the instance variable 'name'."

	^name!

name: theName
	"Accept the argument, 'theName', as the new instance nariable 'name'."

	name := theName! !



Smalltalk.Siren defineClass: #Spatialization
	superclass: #{Siren.Positus}
	indexedType: #none
	private: false
	instanceVariableNames: ''
	classInstanceVariableNames: ''
	imports: ''
	category: 'Music-Models-Representation'!

Siren.Spatialization comment:
'Instances of the Spatialization species model the characteristics and configuration of room simulations in scores.
This class can be used as a concrete one (adding a few methods to fill it out), or like the other representational classes (making concrete classes of this species).
In the later case, the value instance variable would hold a record with the geometry or the room, the positions of default sources, and the listener''s position and features.'!



Smalltalk.Siren defineClass: #Directionality
	superclass: #{Siren.Positus}
	indexedType: #none
	private: false
	instanceVariableNames: ''
	classInstanceVariableNames: ''
	imports: ''
	category: 'Music-Models-Representation'!

Siren.Directionality comment:
'Instances of the Directionality species model the radiation characteristics of sound sources in room simulations.
This class can be used as a concrete one (adding a few methods to fill it out), or like the other representational classes (making concrete classes of this species).
In the later case, the value instance variable would hold a 1- or 2-dimensional position as a number or point.'!

#{Siren.Amplitude} initialize!

#{Siren.Pitch} initialize!

#{Siren.Duration} initialize!
