

Smalltalk.Siren defineClass: #AbstractEvent
	superclass: #{Core.Object}
	indexedType: #none
	private: false
	instanceVariableNames: 'properties '
	classInstanceVariableNames: ''
	imports: ''
	category: 'Music-Events'!

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!


!Siren.AbstractEvent class methodsFor: 'examples'!

eventInspectExample
	"Demonstrate the creation of an AEvent."
	"AbstractEvent example"

	((AbstractEvent new) color: #green; shape: #round) inspect!

example
	"Demonstrate the creation of an AEvent."
	"AbstractEvent example inspect"

	^(AbstractEvent new) color: #green; shape: #round! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!


Siren.AbstractEvent comment:
'AbstractEvent is the base class in the event/event-list hierarchy (although it can be instantiated). Instances of AbstractEvent are objects that can be used as dictionaries or property lists. Their properties can be accessed either with at: and at:put: or by using the new property names themselves as selectors (e.g., (anAEventInstance at: #color put: #green) or (anAEventInstance color: #green)).

Instance variables:
	properties	 <Dictionary or nil> property list dictionary

The global dictionary called Events can be used for sharing event instances.
'!

!Siren.AbstractEvent methodsFor: 'initialize-release'!

initialize
	"Set up the default state of the receiver--add props. dict."

	properties := IdentityDictionary new.!

release
	"Flush the receiver."

	properties == nil
		ifFalse: [properties associationsDo: 
			[ :a |
			a key release.
			a value release]].
	properties  := nil! !

!Siren.AbstractEvent methodsFor: 'accessing'!

, anArgument
	"Add the argument as a property of the receiver."
	"440 Hz, 250 msec, (#voice -> #flute)"
	"(440 Hz, 250 msec, (#voice -> #flute)), 
		((1/4) => (471 Hz, (1/4) beat, (#voice -> #flute)))"

	anArgument isMusicMagnitude
		ifTrue: [self perform: anArgument species propertyName with: anArgument]
		ifFalse: [(anArgument isMemberOf: Association)
			ifTrue: [self perform: (anArgument key, ':') asSymbol with: anArgument value]
			ifFalse: [(anArgument isMemberOf: EventAssociation)
				ifTrue: [^EventList new add: self; add: anArgument]
				ifFalse: [self error: 'Unknown property type.']]]!

date
	"Answer the receiver's 'date'."

	self propCheck.
	^properties at: #date ifAbsent: [nil]!

date: obj
	"Set the receiver's 'date'."

	self propCheck.
	^properties at: #date put: obj!

inspect
	"Inspect the receiver--Use a special inspector for Event types"
	"EventInspectorView open: (EventInspector inspect: MEvent someInstance)"

"	EventInspectorView open: (EventInspector inspect: self)"
	^super inspect!

name
	"Answer the receiver's 'name'."

	self propCheck.
	^properties at: #name ifAbsent: ['']!

open
	"Edit, play (if <shift>) or inspect (if <ctrl>) the receiver, depending on the keyboard state"

	^InputState default shiftDown
		ifTrue: [self play]
		ifFalse: [InputState default ctrlDown
			ifTrue: [self inspect]
			ifFalse: [self edit]]!

species
	"Answer AEvent--all subclasses look like me"

	^AbstractEvent!

version
	"Answer the receiver's 'version'."

	self propCheck.
	^properties at: #version ifAbsent: [nil]!

version: obj
	"Set the receiver's 'version'."

	self propCheck.
	^properties at: #version put: obj! !

!Siren.AbstractEvent methodsFor: 'properties'!

at: aProp
	"Answer a value from the property list dictionary (or an instVar)."

	self propCheck.
	^properties at: aProp ifAbsent: [nil]!

at: aProp ifAbsent: otherCase
	"Answer a value from the property list dictionary or the value of the given block."

"	(self respondsTo: aProp)
		ifTrue: [^self perform: aProp].
	^properties == nil
		ifTrue: [otherCase]
		ifFalse: [properties at: aProp ifAbsent: otherCase value]

"
	properties ifNil: [^nil].
	^properties at: aProp ifAbsent: 
		["(self respondsTo: aProp)
			ifTrue: [self perform: aProp]
			ifFalse: ["otherCase value"]"]!

at: aProp put: aVal
	"Set a value in the receiver's property list dictionary (or instVar)."

	self propCheck.
	properties at: aProp put: aVal!

doesNotUnderstand: aMessage 
	"Handle doesNotUnderstand: to try to access the property dictionary.
	If this is unsuccessful, announce that the receiver does not understand the argument."
	"N.B.: One may want to turn this off for debugging."

	| sel |
	sel := aMessage selector.
	(sel includes: $:)									"access property"
		ifFalse: [(properties ~~ nil and: [properties includesKey: sel])
			ifTrue: [^properties at: sel]]
		ifTrue: [((sel occurrencesOf: $:) = 1)			"set property"
			ifTrue: [^self at: (sel copyUpTo: $:) asSymbol
					put: (aMessage arguments at: 1)]].
	^super doesNotUnderstand: aMessage			"otherwise"!

hasProperty: aSymbol
	"Answer whether or not the receiver's property list dictionary includes the symbol as a key."

	properties ifNil: [^false].
	^properties includesKey: aSymbol!

properties
	"Answer the receiver's property list dictionary."

	^properties!

respondsTo: aSymbol
	"Answer whether the method dictionary of the receiver's class contains 
	aSymbol as a message selector OR if the selector is unary and is a key 
	in the receiver's property dictionary."

	(super respondsTo: aSymbol) ifTrue: [^true].
"	((properties ~~ nil) and: [properties includesKey: aSymbol])
		ifTrue: [^true].
	(aSymbol occurrencesOf: $:) = 1 ifTrue: [^true].
"	^false! !

!Siren.AbstractEvent methodsFor: 'comparing'!

= anObject 
	"Answer whether the receiver and the argument represent the same values."

	^anObject isEvent
		ifFalse: [false]
		ifTrue: [self properties = anObject properties]! !

!Siren.AbstractEvent methodsFor: 'testing'!

isEvent
	"Answer true."

	^true!

isSound
	"Answer false."

	^false! !

!Siren.AbstractEvent methodsFor: 'printing'!

display: showHide field: filter on: stream

	| obj |
	(showHide includes: filter)
		ifTrue: [obj := self at: filter ifAbsent: [''].
			obj isString ifFalse: [obj := obj printString].
			obj isEmpty
				ifFalse: [stream isEmpty 
						ifFalse: [stream nextPutAll: ': '].
					stream nextPutAll: obj]]!

displayField: filter on: stream

	| obj |
	stream isEmpty ifFalse: [stream nextPutAll: ': '].
	obj := self at: filter ifAbsent: [''].
	obj isString ifFalse: [obj := obj printString].
	stream nextPutAll: obj!

printOn: aStream 
	"Format and print the receiver on the argument."

	aStream nextPut: $(.
	super printOn: aStream.
	aStream space.
	properties == nil
		ifFalse: [properties associations asSortedCollection do:
				[ :ass |
				aStream nextPutAll: ' (', ass key, ': ', ass value printString, ')']].
	aStream nextPut: $); cr!

storeOn: aStream 
	"Format and store the source the receiver on the argument."

	aStream nextPutAll: (properties == nil
			ifTrue: ['(', self class name, '']
			ifFalse: ['((', self class name, '']).
	properties == nil
		ifFalse: [aStream nextPutAll: ')'.
			properties associationsDo: [ :ass |
					aStream nextPutAll: ' at: '.
					ass key storeOn: aStream.
					aStream nextPutAll: ' put: '.
					ass value storeOn: aStream.
					aStream nextPut: $;; cr.]].
	aStream nextPutAll: ')'!

templateFields
	"Answer the field names for the instances of the receiver class."

	| coll |
	coll := self class templateFields asOrderedCollection.
	coll remove: #properties.
	properties ifNotNil:
		[coll addAll: properties keys].
	^coll! !

!Siren.AbstractEvent methodsFor: 'scheduling'!

scheduleOn: aChannel
	"Perform or interpret the receiver on the argument; override in subclasses."

	aChannel schedule: self at: 0! !

!Siren.AbstractEvent methodsFor: 'private'!

propCheck
	"Make sure the receiver has a property list dictionary."

	properties == nil
		ifTrue: [properties := IdentityDictionary new].! !



Smalltalk.Siren defineClass: #DurationEvent
	superclass: #{Siren.AbstractEvent}
	indexedType: #none
	private: false
	instanceVariableNames: 'duration index startedAt realTime '
	classInstanceVariableNames: ''
	imports: ''
	category: 'Music-Events'!

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!


!Siren.DurationEvent class methodsFor: 'examples'!

eventInspectExample
	"Demonstrate the creation of a DEvent."
	"DurationEvent example inspect"

	(DurationEvent dur: 250 msec voice: #flute) inspect!

example
	"Demonstrate the creation of a DEvent."
	"DurationEvent example"

	^DurationEvent dur: 250 msec voice: #flute! !

!Siren.DurationEvent class methodsFor: 'instance creation'!

dur: aD
	"Answer a DurationEvent instance initialized with the arguments."

	^self new duration: aD!

dur: aD voice: aVoice
	"Answer a DurationEvent instance initialized with the arguments."

	^self new duration: aD; voice: aVoice! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!


Siren.DurationEvent comment:
'Instances of DurationEvent are events that have special slots for their duration and voice properties.

Instance variables:
	duration <Duration species or nil> duration--a relative time
'!

!Siren.DurationEvent methodsFor: 'accessing'!

ampl
	"Answer the receiver's ampl"

	^nil!

dur
	"Answer the receiver's duration."

	^self duration!

dur: newValue
	"Set the receiver's duration."

	^self duration: newValue!

duration
	"Answer the receiver's duration."

	^duration!

duration: newValue
	"Set the receiver's duration."

	newValue species == Duration
		ifTrue: [duration := newValue]
		ifFalse: [duration := Duration value: newValue]!

index: aNumber
	"Set the receiver's event index."

	index := aNumber!

order
	"Answer the receiver's order."

	^self at: #order ifAbsent: [0].!

order: anOrder
	"Set the receiver's order."

	^self at: #order put: anOrder!

pitch
	"Answer the receiver's pitch"

	^nil!

scaleDuration: newValue
	"Scale the receiver's duration."

	duration := duration * newValue!

scaleDurationBy: newValue
	"Scale the receiver's duration."

	duration := duration * newValue!

voice
	"Answer the receiver's voice or some reasonable default."

	self propCheck.
	^properties at: #voice ifAbsent: [nil]!

voice: aValue
	"Set the receiver's voice to the argument."

	properties at: #voice put: aValue! !

!Siren.DurationEvent methodsFor: 'initialize-release'!

initialize
	"Set up the default state of the receiver--add props. dict."

	super initialize.
	index := nil.
	startedAt := nil.
	realTime :=  true! !

!Siren.DurationEvent methodsFor: 'comparing'!

= anObject 
	"Answer whether the receiver and the argument represent the same values."

	^anObject isEvent
		ifFalse: [false]
		ifTrue: [((self duration = anObject duration) and:
				[super = anObject])]! !

!Siren.DurationEvent methodsFor: 'scheduling'!

isActive
	"Answer whether the receiver is in a schedule"

	^nil ~= index!

nextTime: ignored
	"Answer whether to reschedule the receiver"

	^nil!

play
	"Play the receiver by scheduling it."

	^self playAt: nil!

playAt: aTime
	"Play the receiver on its voice then."
	
	^self playOn: self voice at: aTime!

playOn: aVoice at: aTime
	"This is a no-op in the abstract class"

	^self!

reset
	"Reset the receiver's index."

	index := nil.
	startedAt := Time microsecondClock!

scheduleAt: aTime
	"Play the receiver on its voice then."
	
	self playAt: aTime.
	^self nextTime: aTime! !

!Siren.DurationEvent methodsFor: 'printing'!

printOn: aStream 
	"Format and print the receiver on the argument."

	aStream nextPutAll: '(', self class name.
	duration == nil
		ifFalse: [aStream nextPutAll: ' ', duration printString]. 
	properties == nil
		ifFalse: [properties associationsDo:
				[ :ass |
				aStream nextPutAll: ' (', ass key, ': ', ass value printString, ')']].
	aStream nextPutAll: ')'; cr!

storeOn: aStream 
	"Format and store the source the receiver on the argument."

	aStream nextPutAll: (properties == nil
			ifTrue: ['(', self class name, '']
			ifFalse: ['((', self class name, '']).
	duration == nil
		ifFalse: [aStream nextPutAll: ' dur: ', duration value storeString]. 
	properties == nil
		ifFalse: [aStream nextPutAll: ')'.
			properties associationsDo: [ :ass |
					aStream nextPutAll: ' at: '.
					ass key storeOn: aStream.
					aStream nextPutAll: ' put: '.
					ass value storeOn: aStream.
					aStream nextPut: $;; cr.]].
	aStream nextPutAll: ')'! !



Smalltalk.Siren defineClass: #ActionEvent
	superclass: #{Siren.DurationEvent}
	indexedType: #objects
	private: false
	instanceVariableNames: 'action '
	classInstanceVariableNames: ''
	imports: ''
	category: 'Music-Events'!

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!


!Siren.ActionEvent class methodsFor: 'examples'!

eventExample
	"Demonstrate the creation of an ActionEvent."
	"ActionEvent eventExample play"

	^ActionEvent dur: 250 msec action: 
		[ | gc |
		gc := Window currentWindow graphicsContext.
	 	gc paint: ColorValue red.
		gc displayRectangle: ((20@20) extent: (20@20)).
		(Delay forSeconds: 1) wait.
		Window currentWindow refresh]!

listExample
	"Demonstrate the creation of an ActionEvent by making a list of events that draw rectangles on the top window."
	"ActionEvent listExample"
	"ActionEvent playExample"
	"EventScheduler addClient: ActionEvent listExample; run"
	"Window currentWindow refresh"

	| list gc bounds rand |
	list := EventList newAnonymous.
	rand := Random new.
	gc := Window currentWindow graphicsContext.
	bounds := gc clippingBounds.
	100 timesRepeat:
		[list add: (ActionEvent dur: 50 msec action: 
			[gc paint: ColorValue random.
			gc displayRectangle: (((rand next * bounds width) truncated
							@ (rand next * bounds height) truncated)
				extent: ((rand next * 60) truncated)
							@ (rand next * 60) truncated)])].
	^list!

playExample
	"Demonstrate the performance of a list of ActionEvents."
	"ActionEvent playExample"

	EventScheduler instance addClient: self listExample in: (100 msec).
	EventScheduler instance run.
	(Delay forSeconds: 6) wait.
	Window currentWindow refresh! !

!Siren.ActionEvent class methodsFor: 'instance creation'!

dur: aD action: actionBlock
	"Answer an ActionEvent instance initialized with the arguments."

	^self new duration: aD; action: actionBlock!

dur: aD block: actionBlock
	"Answer an ActionEvent instance initialized with the arguments."

	^self new duration: aD; action: actionBlock! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!


Siren.ActionEvent comment:
'An instance of ActionEvent evaluates a Smalltalk block when scheduled.

Instance variables:
	action  <Block or Value> Something to do
'!

!Siren.ActionEvent methodsFor: 'accessing'!

action
	"Answer the receiver's 'action'."

	^action!

action: anObject
	"Set the receiver's instance variable 'action' to be anObject."

	action := anObject! !

!Siren.ActionEvent methodsFor: 'scheduling'!

play
	"Play the receiver by executing its action block."
	
	^action value!

playAt: aTime
	"Play the receiver by executing its action block."
	
	^action value! !



Smalltalk.Siren defineClass: #MusicEvent
	superclass: #{Siren.DurationEvent}
	indexedType: #none
	private: false
	instanceVariableNames: 'pitch loudness voice '
	classInstanceVariableNames: ''
	imports: ''
	category: 'Music-Events'!

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!


!Siren.MusicEvent class methodsFor: 'examples'!

eventInspectExample
	"Demonstrate the terse format of event description."
	"MusicEvent eventInspectExample"

	(440 Hz, 250 msec, (#voice -> #flute), 0.7071 ampl) inspect
"	((880 Hz, 250 msec, (#voice -> #flute), 0.7071 ampl) accent: #sfz) inspect"!

example
	"Demonstrate the terse format of event description."
	"MusicEvent example inspect"

	^(440 Hz, 250 msec, (#voice -> #flute), 0.7071 ampl)
"	((880 Hz, 250 msec, (#voice -> #flute), 0.7071 ampl) accent: #sfz) inspect"! !

!Siren.MusicEvent class methodsFor: 'class initialization'!

initialize
	"Initialize the global dictionary of Events (optional)."
	"MEvent initializeEventDictionary"

	Smalltalk at: #Events put: Dictionary new!

initializeEventDictionary
	"Initialize the global dictionary of Events (optional)."
	"MEvent initializeEventDictionary"

	Smalltalk at: #Events put: Dictionary new! !

!Siren.MusicEvent class methodsFor: 'instance creation'!

ampl: anA voice: aVoice
	"Answer a MusicEvent instance initialized with the arguments."

	^self new loudness: anA; voice: aVoice!

dur: aD ampl: anA voice: aVoice
	"Answer a MusicEvent instance initialized with the arguments."
	"MusicEvent dur: 1000 ampl: 127 voice: 2"
	"MusicEvent dur: 1/4 ampl: #mf voice: #flute"

	^self new duration: aD;
			loudness: anA;
			voice: aVoice!

dur: aD pitch: aP
	"Answer a MusicEvent instance initialized with the arguments."
	"MusicEvent dur: 1000 pitch: 30"
	"MusicEvent dur: 1/4 pitch: #c3"

	^self new duration: aD; pitch: aP!

dur: aD pitch: aP ampl: anA
	"Answer a MusicEvent instance initialized with the arguments."
	"MusicEvent dur: 1000 pitch: 30 ampl: 127 "
	"MusicEvent dur: 1/4 pitch: #c3 ampl: #mf "

	^self new duration: aD;
			pitch: aP; 
			loudness: anA!

dur: aD pitch: aP ampl: anA voice: aVoice
	"Answer a MusicEvent instance initialized with the arguments."
	"MusicEvent dur: 1000 pitch: 30 ampl: 127 voice: 2"
	"MusicEvent dur: 1/4 pitch: #c3 ampl: #mf voice: #flute"

	^self new duration: aD;
			pitch: aP; 
			loudness: anA;
			voice: aVoice!

dur: aD pitch: aP voice: aVoice
	"Answer a MusicEvent instance initialized with the arguments."

	^self new duration: aD; pitch: aP; voice: aVoice!

dur: aD voice: aVoice ampl: anA
	"Answer a MusicEvent instance initialized with the arguments."
	"MusicEvent dur: 1000 pitch: 30 ampl: 127 voice: 2"
	"MusicEvent dur: 1/4 pitch: #c3 ampl: #mf voice: #flute"

	^self new duration: aD;
			loudness: anA;
			voice: aVoice!

duration: aD pitch: aP
	"Answer a MusicEvent instance initialized with the arguments."
	"MusicEvent dur: 1000 pitch: 30"
	"MusicEvent dur: 1/4 pitch: #c3"

	^self new duration: aD; pitch: aP!

duration: aD pitch: aP ampl: anA
	"Answer a MusicEvent instance initialized with the arguments."
	"MusicEvent dur: 1000 pitch: 30 ampl: 127 "
	"MusicEvent dur: 1/4 pitch: #c3 ampl: #mf "

	^self new duration: aD;
			pitch: aP; 
			loudness: anA!

pitch: aP
	"Answer a MusicEvent instance initialized with the argument."
	"MusicEvent pitch: 440.0"
	"MusicEvent pitch: #c3"

	^self new pitch: aP!

pitch: aP ampl: anA voice: aVoice
	"Answer a MusicEvent instance initialized with the arguments."
	"MusicEvent pitch: 30 ampl: 127 voice: 2"
	"MusicEvent pitch: #c3 ampl: #mf voice: #flute"

	^self new pitch: aP; 
			loudness: anA;
			voice: aVoice! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!


Siren.MusicEvent comment:
'Instances of class MusicEvent are concrete musical note event objects used for eventLists and eventGenerators.

Instance variables:
	pitch <Pitch-species MusicMagnitude> the pitch/frequency
	loudness <Loudness-species MusicMagnitude> the loudness/amplitude
	voice <Voice, Symbol or Number> voice--a voice or key
'!

!Siren.MusicEvent methodsFor: 'accessing'!

ampl
	"Answer the receiver's loudness"

	^loudness!

ampl: aValue
	"Set the receiver's loudness to the argument."

	^self loudness: aValue!

amplitude
	"Answer the receiver's loudness"

	^loudness!

amplitude: aValue
	"Set the receiver's loudness to the argument."

	(aValue species == Amplitude)
		ifFalse: [loudness := Amplitude value: aValue]
		ifTrue: [loudness := aValue]!

loudness
	"Answer the receiver's loudness"

	^loudness!

loudness: aValue
	"Set the receiver's loudness to the argument."

	(aValue species == Amplitude)
		ifFalse: [loudness := Amplitude value: aValue]
		ifTrue: [loudness := aValue]!

pitch
	"Answer the receiver's pitch"

	^pitch!

pitch: aValue
	"Set the receiver's pitch to the argument."

	(aValue species == Pitch)
		ifFalse: [pitch := Pitch value: aValue]
		ifTrue: [pitch := aValue]!

voice
	"Answer the receiver's voice"

	^voice!

voice: aValue
	"Set the receiver's voice to the argument."

	voice := aValue! !

!Siren.MusicEvent methodsFor: 'comparing'!

= anObject 
	"Answer whether the receiver and the argument represent the same values."

	^anObject isEvent
		ifFalse: [false]
		ifTrue: [(self pitch = anObject pitch) and: 
			[(self loudness = anObject loudness) and: 
				[super = anObject]]]! !

!Siren.MusicEvent methodsFor: 'scheduling'!

playOn: aVoice at: aTime
	"Play the receiver on the voice then."

	aVoice == nil
		ifTrue: [^Voice default playEvent: self at: aTime].
	aVoice isVoice
		ifTrue: [aVoice playEvent: self at: aTime].
	(SirenSession voices includesKey: aVoice)
			ifTrue: [^(SirenSession voices at: aVoice) playEvent: self at: aTime].
	aVoice isInteger
			ifTrue: [Voice default playEvent: self at: aTime]! !

!Siren.MusicEvent methodsFor: 'printing'!

printOn: aStream 
	"Format and print the receiver on the argument."

"	^self printVerboseOn: aStream
"	^self printTerseOn: aStream!

printTerseOn: aStream 
	"Format and print the receiver on the argument as tersely as possible."

	duration == nil
		ifFalse: [aStream nextPutAll: duration printString]. 
	pitch == nil
		ifFalse: [aStream nextPutAll: '	', pitch printString].
	loudness == nil
		ifFalse: [aStream nextPutAll: ' ', loudness printString].
	voice == nil
		ifFalse: [aStream nextPutAll: '	(v: ', voice printString, ')'].
	properties == nil
		ifFalse: [properties associations asSortedCollection do:
				[ :ass |
				ass value isLPReal
					ifTrue: [aStream nextPutAll: '	(', ass key, ': '.
						ass value printOn: aStream digits: 4.
						 aStream nextPutAll: ')']
					ifFalse: [aStream nextPutAll: '	(', ass key, ': ', ass value printString, ')']]].
	aStream "nextPutAll: ')';" cr!

printVerboseOn: aStream 
	"Format and print the receiver on the argument."

	aStream nextPutAll: '(MEvent'; crtab.
	duration == nil
		ifFalse: [aStream nextPutAll: ' duration: ', duration printString; crtab]. 
	pitch == nil
		ifFalse: [aStream nextPutAll: ' pitch: ', pitch printString; crtab].
	voice == nil
		ifFalse: [aStream nextPutAll: ' voice: ', voice printString; crtab].
	loudness == nil
		ifFalse: [aStream nextPutAll: ' loudness: ', loudness value printString].
	properties == nil
		ifFalse: [properties associationsDo:
				[ :ass |
				aStream crtab; nextPutAll: ' ', ass key, ': ', ass value printString]].
	aStream nextPutAll: ')'; cr!

readDataFrom: aDataStream size: size
	"Read a new event from the given stream using the compact format."

	| propSize |
	duration := MusicMagnitude readDataFrom: aDataStream.
	pitch := MusicMagnitude readDataFrom: aDataStream.
	loudness := MusicMagnitude readDataFrom: aDataStream.
	voice := aDataStream next.
	propSize := size - self class instSize.
	propSize > 0 ifTrue: [self propCheck].
	propSize timesRepeat:
		[properties at: (aDataStream next) put: (aDataStream next)]!

storeDataOn: aDataStream
	"Store myself on a DataStream. Answer self."
	"Format: 4 normal IVs, properts as key/value (or nil)"

	| cntInstVars cntProps |
	cntInstVars := self class instSize.
	properties isNil
		ifFalse: [cntProps := properties size]
		ifTrue: [cntProps := 0].
	aDataStream
		beginInstance: self class
		size: cntInstVars + cntProps.
	MusicMagnitude store: duration on: aDataStream.
	MusicMagnitude store: pitch on: aDataStream.
	MusicMagnitude store: loudness on: aDataStream.
	aDataStream nextPut: voice.
	properties isNil
		ifFalse: [properties associationsDo: 
				[ :ass |
				aDataStream nextPut: ass key.
				aDataStream nextPut: ass value]]!

storeOn: aStream 
	"Format and store the source the receiver on the argument."

	aStream nextPutAll: (properties == nil
			ifTrue: ['(', self class name, '']
			ifFalse: ['((', self class name, '']).
	duration == nil
		ifFalse: [aStream nextPutAll: ' dur: ', duration value storeString]. 
	pitch == nil
		ifFalse: [aStream nextPutAll: ' pitch: ', pitch value storeString].
	loudness == nil
		ifFalse: [aStream nextPutAll: ' ampl: ', loudness value storeString].
	voice == nil
		ifFalse: [aStream nextPutAll: ' voice: ', voice storeString].
	properties == nil
		ifFalse: [aStream nextPutAll: ')'.
			properties associationsDo: [ :ass |
					aStream nextPutAll: ' at: '.
					ass key storeOn: aStream.
					aStream nextPutAll: ' put: '.
					ass value storeOn: aStream.
					aStream nextPut: $;; cr.]].
	aStream nextPutAll: ')'! !

!Siren.MusicEvent methodsFor: 'processing'!

transposeBy: aStep
	"Add the given step to the receiver's pitch."

	self pitch: (self pitch + aStep)! !



Smalltalk.Siren defineClass: #EventList
	superclass: #{Siren.MusicEvent}
	indexedType: #none
	private: false
	instanceVariableNames: 'events '
	classInstanceVariableNames: ''
	imports: ''
	category: 'Music-Events'!

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!


!Siren.EventList class methodsFor: 'class initialization'!

flush
	"Erase the shared EventList dictionary and try to clean up all events."
	"EventList flush."

	SirenSession initializeEventLists.
	EventList allInstancesDo: [ :el | el release].
	ObjectMemory garbageCollect.
	Transcript cr; show: EventList instanceCount printString, ' event lists  	',
			MusicEvent instanceCount printString, ' events  	',
			Duration instanceCount printString, ' durations'; cr.!

initialize
	"Initialize the shared EventList dictionary."
	"EventList initialize."
	"EventList someInstance"

	SirenSession initializeEventLists!

storeAll
	"Write out all event lists."
	"EventList storeAll"

	| fname fstream |
	fname := Dialog request: 'File name for storing event lists'
			initialAnswer: 'events.st'.
	fname isEmpty ifTrue: [^self].
	fstream := (Filename named: fname) writeStream.
	fstream ifNil: [^self].
	Cursor write showWhile:
		[SirenSession eventLists do:
			[ :list |
			list storeOn: fstream.
			fstream cr; cr]].
	fstream close.! !

!Siren.EventList class methodsFor: 'instance creation'!

basicNew: ignored
	"Create and answer a new default-named instance of me"

	^self basicNew!

fromFile: theName
	"Create and answer a new default un-named (and therefore un-persistent) instance of me"
	"EventList fromFile: (SirenUtility findFile: 'CALYPSO.MID')"

	| tail fName |
	tail := theName asFilename tail.
	fName := SirenUtility findFile: theName.
	[(('*.mid' match: tail) or: ['*.midi' match: tail])
		ifTrue: [ | el mv |
			el := EventList newAnonymous.
			mv := MIDIFileVoice newOn: fName.
			mv readOnto: el.
			mv close.
			^el].
	(('*.ev' match: tail) or: ['*.sm' match: tail])
		 ifTrue: [ | fn | 
			fn := (Filename named: fName).
			fn fileIn.
			^EventList named: fn base]]
	on: Error
	do: [ :ex | ex pass. Transcript show: 'Error reading score file ', theName; cr. ^nil]!

named: myName fromPitches: pitchCollection
	"Answer an event list made with the given collection of pitches."
	"EventList named: (EventList nextName) fromPitches: #(36 38 40 43 45)"

	| me |
	me := self newNamed: (myName asSymbol).
	pitchCollection do:
		[ :item |
		me add: (me defaultEventClass pitch: item)
			at: 0].
	^me!

named: myName fromSelectors: selArray values: valueArrayArray
	"Answer an event list made with the given collection of values applied to the given array of selectors."
	"EventList named: 'phrase1'  
		fromSelectors: #(duration: loudness: phoneme:) 
		values: (Array with: #(595 545 545 540 570 800 540) 
				with: #(0.8 0.6 0.4 0.3 0.4 0.5 0.2) 
				with: #(dun kel kam mer ge sprae che))"

	| me size evt start selector data|
	me := self newNamed: (myName asSymbol).
	size := (valueArrayArray detect: [ :d | d hasItems]) size.
	1 to: size do:
		[ :evtIndex |
		evt := me defaultEventClass new.
		start := nil.
		1 to: (selArray size) do:
			[ :selIndex |
			selector := selArray at: selIndex.
			data := valueArrayArray at: selIndex.
			selector == #start: 
				ifTrue: [start := (Duration value: (data at: evtIndex))]
				ifFalse: [data hasItems
					ifTrue: [evt perform: selector with: (data at: (evtIndex - 1 \\ data size + 1))]
					ifFalse: [evt perform: selector with: data]]].
		start == nil
			ifTrue: [me add: evt]
			ifFalse: [me add: evt at: start]].
	^me!

named: myName fromStartTimes: timeCollection
	"Answer an event list with the given collection of relative start times."
	"EventList named: (EventList nextName) fromStartTimes: #(0 500 1000 1500 2000 2500 3000)"

	| me |
	me := self newNamed: (myName asSymbol).
	timeCollection do:
		[ :item |
		me add: (me defaultEventClass new)
			at: item].
	^me!

new
	"Create and answer a new default-named instance of me"

	^self newAnonymous!

new: ignored
	"Create and answer a new default-named instance of me"

	^self newAnonymous!

newAnonymous
	"Create and answer a new default un-named (and therefore un-persistent) instance of me"

	^super new initializeAnonymous! !

!Siren.EventList class methodsFor: 'examples'!

creationExamples
	"Select the expressions below one-at-a-time and inspect the results."

"	EventList named: (EventList nextName) 
		fromPitches: #(36 38 40 43 45).
"
"	(EventList named: (EventList nextName) 
		fromStartTimes: #(0 500 1000 1500 2000 2500 3000)) inspect.
"
	((440 Hz, 250 msec, (#voice -> #flute)), 
		((1/4) => (471 Hz, (1/4) beat, (#voice -> #flute)))) inspect!

randomExample
	"Create an event list with random data."
	"EventList randomExample"
	"EventList randomExample edit"
	"PitchTimeView randomExample"
	"(EventList newNamed: #pRand)
			addAll: (EventList randomExample);
			addAll: (EventList randomExample)"

	| rand size arr1 arr2 arr3 arr4 |
	rand := Random new.
	size := 64.
	arr1 := Array new: size.
	arr2 := Array new: size.
	arr3 := Array new: size.
	arr4 := Array new: size.
	1 to: size do: [ :i | arr1 at: i put: (rand nextIntFrom: 150 to: 300)].	"dur"
	1 to: size do: [ :i | arr2 at: i put: (rand nextIntFrom: 40 to: 100)].		"amp"
	1 to: size do: [ :i | arr3 at: i put: (rand nextIntFrom: 1 to: 1)].			"voice"
	1 to: size do: [ :i | arr4 at: i put: (rand nextIntFrom: 36 to: 60)].		"pitch"
	^EventList named: 'random1'  
		fromSelectors: #(duration: loudness: voice: pitch:) 
		values: (Array with: arr1 with: arr2 with: arr3 with: arr4)!

randomExample: length
	"Create an event list with random data."
	"EventList randomExample: 200"
	"PitchTimeView randomExample"
	"(EventList randomExample: 40) playOn: MIDIVoice default"

	| rand arr1 arr2 arr3 arr4 |
	rand := Random new.
	arr1 := Array new: length.
	arr2 := Array new: length.
	arr3 := Array new: length.
	arr4 := Array new: length.
	1 to: length do: [ :i | arr1 at: i put: (rand nextFrom: 0.2 to: 0.3)].
	1 to: length do: [ :i | arr2 at: i put: (rand nextIntFrom: 32 to: 80)].
	1 to: length do: [ :i | arr3 at: i put: (rand nextIntFrom: 1 to: 1)].
	1 to: length do: [ :i | arr4 at: i put: (rand nextIntFrom: 48 to: 72)].
	^EventList named: 'random1'  
		fromSelectors: #(duration: loudness: voice: pitch:) 
		values: (Array with: arr1 with: arr2 with: arr3 with: arr4)!

randomExample: length from: data
	"Create an event list with random data."
	"(EventList randomExample: 64 
		from: ((#duration: -> (0.1 to: 0.2)), (#pitch: -> (36 to: 60)),
				(#ampl: -> (48 to: 64)), (#voice: -> (1 to: 4)))) edit"

	| rand arr sels i a |
	rand := Random new.
	arr := Array new: data size.
	sels := Array new: data size.
	i := 1.
	data associationsDo: [ :item | | int |
		int := item value.
		a := Array new: length.
		(int isMemberOf: Interval)
			ifTrue: [int first isInteger
				ifTrue: [1 to: length do: [ :c | 
					a at: c put: (rand nextIntFrom: int first to: int stop)]]
				ifFalse: [1 to: length do: [ :c | 
					a at: c put: (rand nextFrom: int first to: int stop)]]]
			ifFalse: [(int hasItems)
				ifTrue: [1 to: length do: [ :c | 
					a at: c put: (int atRandom: rand)]]
				ifFalse: [1 to: length do: [ :c | 
					a at: c put: int]]].
		arr at: i put: a.
		sels at: i put: item key.
		i := i + 1].
	^EventList named: EventList nextName
		fromSelectors: sels 
		values: arr!

randomSWSSExample
	"Create an event list with random data appropriate for software sound synthesis."
	"EventList randomSWSSExample edit"
	"(EventList newNamed: #sRand)
			addAll: (EventList randomSWSSExample);
			addAll: (EventList randomSWSSExample)"

	| rand size params data |
	rand := Random new.
	size := 128.
	params := 9.
	data := Array new: params.
	1 to: params do:
		[ :i | data at: i put: (Array new: size)].
	1 to: size do: 
		[ :i | (data at: 1) at: i put: (rand nextIntFrom: 200 to: 450)].	"dur"
	1 to: size do: 
		[ :i | (data at: 2) at: i put: (rand nextFrom: 0.3 to: 0.7)].		"ampl"
	1 to: size do: 
		[ :i | (data at: 3) at: i put: (rand nextFrom: 60 to: 500)].		"pitch"
	1 to: size do: 
		[ :i | (data at: 4) at: i put: (rand nextIntFrom: 1.0 to: 5.0)].	"ratio"
	1 to: size do: 
		[ :i | (data at: 5) at: i put: (rand nextFrom: 1.0 to: 8.0)].		"index"
	1 to: size do: 
		[ :i | (data at: 6) at: i put: (rand nextFrom: 0.05 to: 0.1)].	"attack"
	1 to: size do: 
		[ :i | (data at: 7) at: i put: (rand nextFrom: 0.05 to: 0.1)].	"decay"
	1 to: size do: 
		[ :i | (data at: 8) at: i put: (rand nextFrom: 0.01 to: 0.1)].	"i:=attack"
	1 to: size do: 
		[ :i | (data at: 9) at: i put: (rand nextFrom: 0.05 to: 0.1)].	"i:=decay"
	^EventList named: #SWSSExample
		fromSelectors: #(duration: loudness: pitch: cmratio: index: 
					attack: decay: iAttack: iDecay:) 
		values: data!

randomSWSSExample2
	"Create an event list with random data appropriate for software sound synthesis."
	"EventList randomSWSSExample2 edit"
	"((EventList newNamed: #sRand)
			addAll: (EventList randomSWSSExample2);
			addAll: (EventList randomSWSSExample2)) edit"

	| rand size params data |
	rand := Random new.
	size := 64.
	params := 6.
	data := Array new: params.
	1 to: params do:
		[ :i | data at: i put: (Array new: size)].
	1 to: size do: 
		[ :i | (data at: 1) at: i put: (rand nextIntFrom: 300 to: 750)].	"dur"
	1 to: size do: 
		[ :i | (data at: 2) at: i put: (rand nextFrom: 0.35 to: 1.0)].		"ampl"
	1 to: size do: 
		[ :i | (data at: 3) at: i 
					put: ((rand nextIntFrom: 36 to: 80) truncateTo: 2)].	"pitch"
	1 to: size do: 
		[ :i | (data at: 4) at: i put: (LinearFunction exampleEnvelope)].	"envelope"
	1 to: size do: 
		[ :i | (data at: 5) at: i put: (rand nextFrom: 0.0 to: 1.0)].		"position"
	1 to: size do: 
		[ :i | (data at: 6) at: i put: (rand nextFrom: 0.3 to: 1.0)].		"duty"
	^EventList named: #SWSSExample
		fromSelectors: #(duration: loudness: pitch: envelope: position: duty:) 
		values: data!

scaleExample2
	"Answer a scale where the event property types are mixed."
	"EventList scaleExample2"

	| el start stop size arr4 dur ndur |
	start := 48.
	stop := 60.
	size := stop - start.
	dur := 2000.	"msec"
	ndur := (dur / size) truncated.
	arr4 := Array new: size + 1.
	0 to: size do: [ :i | arr4 at: i+1 put: (start + i)].
	el := EventList named: EventList nextName
		fromSelectors: #(duration: loudness: pitch:) 
		values: (Array with: ndur with: 72 with: arr4).
"Scramble the property types"
	el eventsDo:
		[ :ev |
		ev dur: (ev dur perform: (#(asMsec asBeat asSeconds) atRandom)).
		ev pitch: (ev pitch perform: (#(asHz asMIDI asSymbol) atRandom)).
		ev ampl: (ev ampl perform: (#(asDB asMIDI asSymbol asRatio) atRandom))].
	^el!

scaleFrom: start to: stop in: dur
	"Answer an event list with a scale."
	"(EventList scaleFrom: 48 to: 60 in: 1.5) open"
	"(EventList scaleFrom: 36 to: 84 in: 2) play"

	| size arr4 ndur |
	size := (stop - start) abs.
	ndur := (dur / size).
	arr4 := Array new: size + 1.
	start > stop
		ifTrue: [0 to: size do: [ :i | arr4 at: i+1 put: (start - i)]]
		ifFalse: [0 to: size do: [ :i | arr4 at: i+1 put: (start + i)]].
	^EventList named: EventList nextName  
		fromSelectors: #(duration: loudness: pitch:) 
		values: (Array with: ndur with: 120 with: arr4)!

sentenceExample
	"Create an event list for a beautiful sentence."
	"EventList sentenceExample"
	EventList named: 'phrase2'  
		fromSelectors: #(duration: loudness: phoneme:) 
		values: (Array with: #(420 420 720 354    408 420 615 570 
					369 312 369    690 462 477 660 ) 
				with: #(0.4 0.3 0.9 0.6    0.42 0.32 0.8 0.5 
					0.44 0.52 0.2   0.94 0.62 0.46 0.34 ) 
				with: #(#und #die #fra #gen    #sind #die #sae #tze 
					#die #ich #nicht    #aus #spre #chen #kann)).
	^EventList named: 'phrase2'!

serialExample: length from: data
	"Create an event list with serial data."
	"(EventList serialExample: 64 
		from: ((#duration: -> #(0.1 0.1 0.1 0.2)), (#pitch: -> #(48 50 52 53 52)),
				(#ampl: -> #(48 64)), (#voice: -> #(1)))) open"

	| arr sels i a |
	arr := Array new: data size.
	sels := Array new: data size.
	i := 1.
	data associationsDo: [ :item | | list |
		list := item value.
		a := Array new: length.
		1 to: length do: [ :c | 
					a at: c put: (list at: c - 1 \\ list size + 1)].
		arr at: i put: a.
		sels at: i put: item key.
		i := i + 1].
	^EventList named: EventList nextName
		fromSelectors: sels 
		values: arr!

wordExample
	"Create an event list for a long word."
	"EventList wordExample"

	EventList named: 'phrase1'  
		fromSelectors: #(duration: loudness: phoneme:) 
		values: (Array with: #(595 545 545 540 570 800 540) 
				with: #(0.8 0.4 0.5 0.3 0.2 0.7 0.1) 
				with: #(#dun #kel #kam #mer #ge #sprae #che)).
	(EventList named: 'phrase1') inspect! !

!Siren.EventList class methodsFor: 'named constants'!

named: aName
	"Answer the named instance from the dictionary or a new EL."
	"EventList named: #random1"

	| el |
	el := SirenSession eventListNamed: aName asSymbol.
	^el isNil
		ifTrue: [self newNamed: aName]
		ifFalse: [el]!

named: aName ifAbsent: theBlock
	"Answer the named instance from the dictionary or the result of the block."

	| el |
	el := SirenSession eventListNamed: aName asSymbol.
	^el isNil
		ifTrue: [theBlock value]
		ifFalse: [el]!

namedLists
	"Answer the dictionary of named event lists."
	"EventList namedLists"

	^SirenSession eventLists!

newNamed
	"Answer the named instance with a temp name."
	"EventList newNamed"

	^self named: EventList nextName!

newNamed: aName
	"Create and answer a new named (and stored) instance."

	^super new initializeNamed: aName!

nextName
	"Answer a gensym-type ('te6') event list name for which no EL exists in the dictionary."

	| temp |
	temp := 1.
	[(SirenSession eventLists at: #Temp) includesKey: (('te', temp printString) asSymbol)]
			whileTrue: [temp := temp + 1].
	^'te', temp printString asSymbol! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!


Siren.EventList comment:
'Instances of class EventList (subclass of DurationEvent), are used for holding onto multiple timed events. EventLists are events themselves and can have arbitrary properties as well as a collection of (relative start time -> event) associations.

Class EventList implements much collection-style protocol for event processing, as well as having special block application methods. All EventList algorithms are recursive in order to handle arbitrarily-deep hierarchical EventLists (possible because EventList is a subclass of DurationEvent). The class also has numerous powerful and flexible instance creation methods.

Instance Variables:
	events <SortedCollection of EventAssociations (Duration => MEvent)> 
				the list''s events, time/event associations sorted by relative start times
	index <Integer> the current position (used in scheduling)
	startedAt <Integer> the clock value when I started

Standard properties are #tempoScale for the tempo scaling factor (used by the CMN editors as the MS/whole note scale), and #code (#duration, #delta, or #startStop) to support different event coding schemes. The class also supports typed links to other event lists, e.g., "eList1 isTonicAnswerOf: eList2" or "eList1 hasPreviousVersion: eList2", which can be very useful properties in editors and browsers.

The global dictionary EventLists holds onto instances that can be referenced with their name symbols; these can have gensym-like names such as #temp.23. Creating a named EventList automatically adds it to the global dictionary. There are tools for browsing and maintaining this dictionary.
'!

!Siren.EventList methodsFor: 'initialize-release'!

empty
	"Throw away the receiver's events."

	self duration: 0.
	self index: 1.
	self events: SortedCollection new.!

initializeAnonymous
	"Initialize an un-named instance with default state."

	self initialize.
	self propCheck.
	duration := Duration value: 0.
	self name: #anonymous.
	self events: SortedCollection new.
	index := nil.!

initializeNamed: aName
	"Initialize a named instance with default state."

	self initializeAnonymous.
	self name: aName asSymbol.
	SirenSession eventList: aName asSymbol put: self!

release
	"Flush the receiver."

	super release.
	events == nil
		ifFalse: [events do: [ :e | e release]].
	events := nil.
	index := nil! !

!Siren.EventList methodsFor: 'accessing'!

addModifier: aModifier
	"Add the given event modifier to the receiver's special modifier collection"

	properties == nil
		ifTrue: [properties := Dictionary new].
	(properties includesKey: #modifiers)
		ifFalse: [properties at: #modifiers put: OrderedCollection new].
	(properties at: #modifiers) add: aModifier!

code
	"Answer a symbol about the receiver's events' coding, usually #durations or #noteOnOff"

	^properties at: #code ifAbsent: [nil]!

code: aSymbol
	"Set the code about the receiver's events, usually #durations or #noteOnOff"

	self propCheck.
	properties at: #code put: aSymbol!

computeDuration
	"Compute and answer the receiver's duration."

	| du |
	du := events first key + events first value duration.
	events do:
		[ :assoc | | eDu |
			eDu := assoc key + assoc value duration.
			du := du max: eDu].
	self duration: du.
	^self duration!

deepCopy
	"Answer a careful deep copy."

	| newEL |
	newEL := EventList newAnonymous.
	self name == nil
		ifFalse: [newEL name: self name deepCopy asSymbol].	
	properties == nil ifFalse:
		[properties associationsDo: [ :anAssociation |
			newEL at: anAssociation key copy put: anAssociation value copy]].
	self events do: [ :anAssociation |
		newEL add: ((anAssociation key copy) => (anAssociation value copy)) ].
	^newEL!

defaultEventClass
	"Answer the default note event class."

	^MusicEvent!

duration
	"Answer the receiver's duration."

	| du |
	du := events first key + events first value duration.
	events do:
		[ :assoc | | eDu |
			eDu := assoc key + assoc value duration.
			du := du max: eDu].
	^du!

flushVoices
	"Set all the events voices to nil"

	self eventsDo: [ :ev | ev voice: nil]!

name
	"Answer the receiver's name."

	self propCheck.
	^properties at: #name ifAbsent: ['']!

name: aName
	"Set the receiver's name."

	properties at: #name put: aName asSymbol!

next
	"Answer the next event in the list."

	index ifNil: [index := 0].
	^self events at: (index := index + 1)!

removeModifier: aModifier
	"Remove the given event modifier from the receiver's collection."

	^(properties == nil or: [(properties includesKey: #modifiers) not])
		ifTrue: [nil]
		ifFalse: [(properties at: #modifiers) remove: aModifier ifAbsent: [nil]]!

shallowCopy
	"Answer a shallow copy of the receiver's events."

	| newEL |
	newEL := super shallowCopy.
	newEL events: SortedCollection new.
	self events do: 
		[ :anAssociation |
		newEL add: ((anAssociation key copy) => (anAssociation value copy))].
	^newEL!

size
	"Answer the number of events in the receiver."

	events ifNil: [^0].
	^events size!

tempo: someValue
	"Set the tempo to scale the events by."

	self propCheck.
	properties at: #tempoScale put: someValue!

voices
	"Answer the collection of voices used by thereceiver  event list."
	"EventList randomExample voices"

	| coll ev |
	coll := OrderedCollection new.
	events do:
		[ :ass |
		ev := ass event.
		ev voice ifNotNil:
			[(coll includes: ev voice)
				ifFalse: [coll add: ev voice]]].
	^coll! !

!Siren.EventList methodsFor: 'event accessing'!

, anEorA
	"Add a new event or association to the receiver."

	^self add: anEorA!

add: anEorA
	"Add a new event or association to the receiver."

	| newAss val |
	anEorA isAssociation
		ifTrue: [newAss := anEorA key copy => anEorA value.
			val := anEorA value.
			newAss key species == Duration
				ifFalse: [newAss key: (Duration value: newAss key)].
			val isEvent
				ifFalse: [val isMusicMagnitude
					ifTrue: [val := (self defaultEventClass new)
							perform: val species propertyName with: val]
					ifFalse: [self error: 'Unknown EventAssociation value']].
			self events add: newAss.
			val duration == nil
				ifTrue: [self duration: (duration max: newAss key)]
				ifFalse: [self duration: (duration max: (newAss key + val duration))]]
		ifFalse: [self events add: (duration => anEorA).
			anEorA duration ifNotNil: [self duration: duration + anEorA duration]].
	self changed: #added!

add: anEvent at: aTime
	"Add a new event to the receiver at the given relative start time."

	| t |
	t := Duration value: aTime.
	self events add: (t => anEvent).
	anEvent duration == nil
		ifFalse: [duration := duration max: (t + anEvent duration)].
	self changed: #added!

addAll: anEventList
	"Add the given event list's events to the receiver."

	anEventList events do:
		[ :assoc |
			self events add: (assoc key copy => assoc value copy).
			assoc value duration == nil 
				ifTrue: [duration := duration max: assoc key]
				ifFalse: [duration := duration 
							max: (assoc key + assoc value duration)]].
	self changed: #added!

addAll: anEventList at: aTime
	"Add the given event list's events to the receiver."

	anEventList events do:
		[ :assoc |
			self events add: (assoc key + aTime => assoc value).		"need to make copies?"
			assoc value duration == nil 
				ifTrue: [duration := duration max: assoc key]
				ifFalse: [duration := duration 
							max: (assoc key + assoc value duration)]].
	self changed: #added!

addAllAtEnd: anEventList
	"Add the given event list's events to the receiver."

	| aTime |
	aTime := self duration.
	anEventList events do:
		[ :assoc |
			self events add: (assoc key copy + aTime => assoc value copy).
			assoc value duration == nil 
				ifTrue: [duration := duration max: assoc key]
				ifFalse: [duration := duration 
							max: (assoc key + assoc value duration)]].
	self changed: #added!

atRandom
	"Answer a random event value"

	^events atRandom value!

eventKeys
	"Answer the keys (durations) of the receiver's eventDictionary."

	^events keys!

eventNear: aPoint
	"Answer an event within a reasonable distance (100 msec.) of the given point's x."

	| margin oldAss |
	(events includesKey: aPoint x)
		ifTrue: [^events at: aPoint x].
	margin := 100. "ms"
	oldAss := nil.
	events do:
		[ :anAss |
		anAss key > aPoint x
			ifTrue: [oldAss == nil
				ifTrue: [(anAss key - aPoint x) abs < margin
					ifTrue: [^anAss]
					ifFalse: [^nil]]
				ifFalse: [(anAss key - aPoint x) abs < margin
						ifTrue: [^anAss].
					(oldAss key - aPoint x) abs < margin
						ifTrue: [^oldAss].
					^nil]].
		oldAss := anAss].
	^nil!

eventNearTime: aTime
	"Answer an event within a reasonable distance (32 msec.) of the given point."

	| margin oldAss t |
	margin := 32. "ms"
	oldAss := events first.
	events do:
		[ :anAss | 
		t := anAss key value.
		t > aTime
			ifTrue: [oldAss == nil
				ifTrue: [(t - aTime) abs < margin
					ifTrue: [^anAss]
					ifFalse: [^nil]]
				ifFalse: [(t - aTime) abs < margin
						ifTrue: [^anAss].
					(oldAss key - aTime) abs < margin
						ifTrue: [^oldAss].
					^nil]].
		oldAss := anAss].
	^nil!

eventNearestTime: aTime
	"Answer an event within a reasonable distance (32 msec.) of the given point."

	| margin ass d |
	ass := events first.
	margin := ass key value - aTime abs.
	events do:
		[ :anAss | 
		d := (anAss key value - aTime) abs.
		d < margin ifTrue: 
			[margin := d.
			ass := anAss]].
	^ass!

eventValues
	"Answer the values (events) of the receiver's eventDictionary."

	^events values!

events
	"Answer the receiver's eventDictionary."

	^events!

events: anEL
	"Set the receiver's eventDictionary."

	events := anEL.
	self changed: #added!

recomputeDuration
	"Recompute the total duration of the receiver."

	| tDur t d |
	tDur := 0 msec.
	events do:
		[ :ass |
		t := ass key.
		d := ass event duration.
		tDur := tDur max: (t +d)].
	duration := tDur.
	self changed: #duration!

remove: anEv
	"Remove the given event or association from the receiver."

	| which |
	anEv isAssociation ifTrue: [^events remove: anEv].
	which := events detect: [ :ev | ev event == anEv] ifNone: [nil].
	which ifNotNil: [events remove: which].
	self changed: #events! !

!Siren.EventList methodsFor: 'code conversion'!

continueProperties
	"Fill in missing properties with values that are continued from previous ones."
	"((440 Hz, (1/4 beat), (#voice -> #flute)), (1/4 => 460 Hz), (1/2 => 500 Hz), (3/4 => 320 Hz), (4/4 => 440 Hz)) continueProperties"

	| opitch oduration oloudness ovoice ev |
	ev := events first value.
	ev pitch == nil ifFalse: [opitch := ev pitch].
	ev duration == nil ifFalse: [oduration := ev duration].
	ev loudness == nil ifFalse: [oloudness := ev loudness].
	ev voice == nil ifFalse: [ovoice := ev voice].
	events do: [ :evt |
		evt pitch == nil ifTrue: [evt pitch: opitch]
					ifFalse: [opitch := evt pitch].
		evt duration == nil ifTrue: [evt duration: oduration]
					ifFalse: [oduration := evt duration].
		evt loudness == nil ifTrue: [evt loudness: oloudness]
					ifFalse: [oloudness := evt loudness].
		evt voice == nil ifTrue: [evt voice: ovoice]
					ifFalse: [ovoice := evt voice]]!

findNoteOff: anAssociation
	"Locate the noteOff event that corresponds to anAssociation; answer the sum of the delta times between (the duration)"

	| instrument time assoc1 assoc2 event2 event1 |
	instrument := anAssociation value voice.
	time := 0.
	event1 := anAssociation value.
	assoc1 := anAssociation.
	[true] whileTrue:
		[[assoc2 := events after: assoc1]  		"check next"
			on: Error
			do: [ :ex | assoc2 := nil].
		assoc2 isNil ifTrue: [^time].			"if missing."
		time := time + (assoc2 key value).			"sum delta times"
		event2 := assoc2 value.
		event2 voice = instrument						"if same instrument"
			ifTrue: [event2 ampl asMIDI = 0				"if ampl = 0"
				ifTrue: [event2 pitch = event1 pitch		"if same note"
					ifTrue: [^assoc2 key - anAssociation key]]]. "^time"
		event1 := event2.
		assoc1 := assoc2].						"next event"!

setDurations
	"Take a delta-time encoded event list and determine the durations."

	| time sTime event newEventList anAss ind |
	(self code == #noteOnOff)				"if i'm delta not coded"
		ifFalse: [^nil ].
	newEventList := SortedCollection new.
	ind := 1.
	[ind <= events size] whileTrue:			"for all note on events"
		[ | am |
		anAss := events at: ind.
		sTime := anAss key.
		event := anAss value copy.
		am := event ampl value.
		(am notNil and: [am > 0])			"until note off found"
			ifTrue: [((event command) bitAnd: 16rF0) = 16r90
				ifTrue: [time := self findNoteOff: anAss.
					time isNil
						ifTrue: [self error: 'no note off found...' ].
					event duration: (Duration value: time).
									"strip the Midi command"
					event voice: (event voice bitAnd: 16r0F).
					newEventList add: (sTime => event).
					Transcript show: ind printString, ' ']
								"meta or control event"
				ifFalse: ["Transcript show: 'meta event'; cr."
					newEventList add: (sTime => event)]].
		ind := ind + 1].
	self code: #durations.
						"now remove noteOffs"
	newEventList isEmpty
		ifFalse: [self events: newEventList.
			self start: newEventList first key].
	self at: #events put: (events size).
	self changed! !

!Siren.EventList methodsFor: 'processing'!

addValue: theValue toProp: theSelector
	"Add theValue to the aspect refered to by theSelector of all events."
	"someEventList addValue: (MSecondDuration value: 10000) toProp: #duration"
	"someEventList addValue: (MIDIPitch value: 100) toProp: #pitch"

	self applyBlock: [ :v | (v class new value: (v value + theValue))] 
			toProp: theSelector!

applyBlock: theBlock toProp: theSelector
	"Apply the given block to the aspect refered to by theSelector of all events."
	"someEList applyBlock: [ :d | (MSecondDuration value: (d asMS value * 10))] 
			toProp: #duration"

	| anEvent val |
	self events do: 
		[ :anAssociation |
		anEvent := anAssociation value.
		anEvent isEventList
			ifTrue: [anEvent applyBlock: theBlock toProp: theSelector]
			ifFalse: [val := anEvent perform: theSelector.
				anEvent perform: ((theSelector, ':') asSymbol)
						with: (theBlock value: val)]]!

applyBlock: theBlock toProp: theSelector from: t0 to: tN
	"Apply the given block to the aspect refered to by theSelector of all events."
	"someEList applyBlock: [ :d | (MSecondDuration value: (d asMS value * 10))] 
			toProp: #duration"

	self events do: 
		[ :anAssociation | | stTime anEvent val |
		stTime := anAssociation key value.
		anEvent := anAssociation value.
		anEvent isEventList
			ifTrue: [anEvent applyBlock: theBlock toProp: theSelector from: t0 + stTime to: tN + stTime]
			ifFalse: [(stTime >= t0 and: [stTime <= tN])
				ifTrue:[val := anEvent perform: theSelector.
					anEvent perform: ((theSelector, ':') asSymbol)
						with: (theBlock value: val)]]]!

applyFunction: aFunction to: aSelector
	"Apply the given function to the range of the given selector"

	^self applyFunction: aFunction to: aSelector startingAt: 0!

applyFunction: aFunction to: aSelector startingAt: sTime
	"Apply the given function to the range of the given selector starting at sTime."

	| aTime anEvent tDur timeC |
	tDur := self duration value.
	self events do:
		[ :anAssoc |
		aTime := anAssoc key value.
		timeC := anAssoc key class.
		anEvent := anAssoc value.
		aSelector == #tempo
			ifTrue: [anAssoc key: (timeC value: (aTime * (aFunction at: (aTime / tDur))))]
			ifFalse: [anEvent isEventList 
				ifTrue: [anEvent apply: aFunction to: aSelector startingAt: aTime]
				ifFalse: [ | oldVal |
					oldVal := anEvent perform: aSelector.
					anEvent perform: ((aSelector, ':') asSymbol) 
							with: (oldVal class value: (oldVal value * (aFunction at: (aTime / tDur))))]]]!

assignInstruments: instBlock
	"Assign the instruments based on the index using the given block"

	1 to: events size do: 							"plug in instruments"
		[ :ind | | ev |			
		ev := (events at: ind) event.
		ev inst: (instBlock value: ind)].!

chooseRange: theRange toProp: theSelector
	"Select a value from the given range for the aspect refered to by theSelector of all events."
	"someEventList chooseRange: (500 to: 700) toProp: #duration"
	"someEventList chooseRange: #(36 38 40 41 43 45) toProp: #pitch"
	
	| size |
	size := theRange size.
	self applyBlock: [ :v | (v class new value: 
					(theRange at: ((Random new next * size) truncated + 1)))] 
			toProp: theSelector!

edit
	"Open your favorite graphical editor on the receiver (left-shift-sensitive)"

	HauerSteffensView openOnEventList: self

"	InputState default  shiftDown
		ifTrue: [CMNView openOn: ((EventListEditor new) list: self)]
		ifFalse: [InputState default  ctrlDown
			ifTrue: [SequenceView openOn: 
						((EventListEditor new) list: self)]
			ifFalse: [HauerSteffensView openOn: 
					((EventListEditor new) list: self)]]"!

scale: theSelector by: theValue
	"Multiply the aspect refered to by theSelector of all events by theValue."
	"someEventList scale: #duration by: 2"

	self applyBlock: [ :v | (v class new value: (v value * theValue))] 
			toProp: theSelector!

scaleDurationsBy: theValue
	"Multiply the start times all events by theValue."

	self events do: [ :assoc | assoc event scaleDurationBy: theValue].
	self recomputeDuration!

scaleStartTimesBy: theValue
	"Multiply the start times all events by theValue."

	self events do: [ :assoc | assoc key: (assoc key * theValue)].
	self recomputeDuration!

scaleValue: theValue toProp: theSelector
	"Multiply the aspect refered to by theSelector of all events by theValue."
	"someEventList scaleValue: 3 toProp: #duration"

	self applyBlock: [ :v | (v class new value: (v value * theValue))] 
			toProp: theSelector!

setValue: theValue toProp: theSelector
	"Set the aspect refered to by theSelector of all events to theValue."
	"someEventList scaleValue: (MSecondDuration value: 10) toProp: #duration"

	self applyBlock: [ :v | theValue] 
			toProp: theSelector!

spreadValue: theRandomPercent toProp: theSelector
	"Spread the given property of all events by the given random range (%+-)."

	self applyBlock: [ :v | (v class new value: (v value 
				* (1 + ((Random new next - 0.5) 
					* theRandomPercent / 50) rounded)))] 
			toProp: theSelector! !

!Siren.EventList methodsFor: 'collecting'!

collect: aBlock
	"Iterate over the receiver's events with the given block"

	| newList |
	newList := EventList new.
	self events do: 
		[ :anE |
		newList add: (aBlock value: anE)].
	^newList!

collectAll: aBlock
	"Iterate over the receiver's events with the given block"

	| newList |
	newList := EventList new.
	self events do: 
		[ :anE |
		anE isEventList				"hierarchical tree descent"
			ifTrue: [(anE collectAll: aBlock) do:
				[ :evt | newList add: (evt key + anE key) => evt value]]
			ifFalse: [newList add: (aBlock value: anE)]].
	^newList!

do: aBlock
	"Iterate over the receiver's event associations with the given block"

	self events do: aBlock!

eventsDo: aBlock
	"Iterate over the receiver's events with the given block"

	^self events do: [:assoc | aBlock value: (assoc event) ]!

excerptFrom: start to: end
	"Answer a hierarchical list delineated by the given times."

	| newList newEvent |
	newList := EventList newAnonymous.
	events do: 
		[ :anAssoc |				"iterate over all my events"
		(anAssoc key value between: start and: end) 
			ifTrue: [newEvent := anAssoc value.
				(newEvent isEventList)	"map and add normal events"
					ifFalse: [newList add: anAssoc]
									"unfold sub-event lists recursively"
					ifTrue: [newList add:
							(newEvent excerptFrom: 0 
									to: (end - anAssoc key))]]].
	^newList!

expanded
	"Expand all sub-event lists and answer one large flat list."

	| newList newEvent |
	newList := EventList newAnonymous.
	events do: [ :anEvent |				"iterate over all my events"
		newEvent := anEvent value "copy".	"copy them"
		(newEvent species == EventList) 
			ifTrue:						"unfold sub-lists recursively"
				[newEvent expanded do: [ :aSubEvent |
					newList add: (newEvent map: 
						((anEvent key + aSubEvent key) 
								-> aSubEvent value))]]
			ifFalse: 						"map and add normal events"
				[newList add: ( anEvent key -> newEvent)]].
	^newList!

expandedFrom: start to: end
	"Expand all sub-event lists and answer one flat list with events between the given times."

	| newList newEvent |
	((start value = 0) and: [end > duration])
		ifTrue: [^self expanded].
	newList := EventList newAnonymous.
	events do: 
		[ :anEvent |				"iterate over all my events"
		newEvent := anEvent value.
		(anEvent key between: start and: end) 
			ifTrue: [newEvent isEventList
							 "map and add normal events"
				ifFalse: [newList add: 
							(anEvent key => newEvent copy)]
								"unfold sub-event lists recursively"
				ifTrue: [(newEvent
							expandedFrom: (MSecondDuration value: 0)
							to: (end - anEvent key)) 
						do: [ :aSubEvent |
							newList add: (newEvent map: 
									((anEvent key + aSubEvent key) 
										=> aSubEvent value))]]]].
	^newList!

group: selection
	"Group the argument's events as a sub-event list in the receiver's list."

	| temp startTime |
	selection isEventList
		ifFalse: [self remove: selection.
			self add: ((EventList newAnonymous) add: (selection key: 0))
						at: selection key]
		ifTrue: [startTime := selection events first key.
			selection do:
				[ :anAss |
				temp := self remove: anAss.
				temp == nil
					ifTrue: [selection remove: anAss].
				startTime = 0
					ifFalse: [anAss key: (anAss key - startTime)]].
			selection duration: (selection duration value - startTime).
			self add: selection at: startTime]!

includes: anAss
	"Answer whether the given association is in the receiver's event list."

	^self events includes: anAss!

keysAndValuesDo: aBlock
	^self events do:
		[ :assoc |
		aBlock value: assoc key value: assoc value].!

select: aBlock
	"Iterate over the receiver's events with the given block"

	| newList |
	newList := EventList new.
	self events do: 
		[ :anE |
		(aBlock value: anE)
			ifTrue: [newList add: anE]].
	^newList!

selectAll: aBlock
	"Iterate over the receiver's events with the given block"

	| newList |
	newList := EventList new.
	self events do: 
		[ :anE |
			anE isEventList				"hierarchical tree descent"
			ifTrue: [(anE selectAll: aBlock) do:
				[ :evt | newList add: (evt key + anE key) => evt value]]
			ifFalse: [(aBlock value: anE)
				ifTrue: [newList add: anE]]].
	^newList!

selectKey: aBlock
	"Iterate over the receiver's events with the given block"

	| newList |
	newList := EventList new.
	self events do: 
		[ :anE |
		anE isEventList				"hierarchical tree descent"
			ifTrue: [(anE selectKey: aBlock) do:
				[ :evt | newList add: (evt key + anE key) => evt value]]
			ifFalse: [(aBlock value: anE key)
				ifTrue: [newList add: anE]]].
	^newList!

selectValue: aBlock
	"Iterate over the receiver's events with the given block"

	| newList |
	newList := EventList new.
	self events do: 
		[ :anE |
		anE isEventList				"hierarchical tree descent"
			ifTrue: [(anE selectValue: aBlock) do:
				[ :evt | newList add: (evt key + anE key) => evt value]]
			ifFalse: [(aBlock value: anE value)
				ifTrue: [newList add: anE]]].
	^newList!

timesDo: aBlock
	"Iterate over the receiver's events' relative start times with the given block"

	^self events do: [ :assoc | aBlock value: (assoc key) ]! !

!Siren.EventList methodsFor: 'comparing'!

= anObject 
	"Answer whether the receiver and the argument represent the same events."

	^anObject isEventList
		ifFalse: [false]
		ifTrue: [((self duration = anObject duration) and:
				[self events = anObject events])]! !

!Siren.EventList methodsFor: 'testing'!

hasItems
	"Answer whether or not the receiver has items or components (true)."

	^true!

isEmpty
	"Answer whether the receiver is an event list (true)."

	^events isEmpty!

isEventList
	"Answer whether the receiver is an event list (true)."

	^true!

species
	"Answer EventList."

	^EventList! !

!Siren.EventList methodsFor: 'scheduling'!

loop
	"Play the event list by passing it off to the event scheduler."

	EventScheduler addClient: self in: 1 msec loop: true.
	EventScheduler run!

nextTime: now
	"Answer the time of the next appointment"

"	startedAt ifNil: [startedAt := Time microsecondClock]."
"	Transcript show: ((self events at: index) key asMsec value) printString; cr."
	^(self events at: index) key asUsec value + startedAt!

nextTimeFor: ass
	"Answer the time delay between the given event association and the one that follows it."

	| ind next |
	ind := events indexOf: ass ifAbsent: [0].
	ind = 0 ifTrue: [^0 sec].
	ind = events size ifTrue: [^0 sec].
	next := events at: ind + 1.
	^(next start - ass start)!

play
	"Play the event list by passing it off to the event scheduler."

	EventScheduler addClient: self in: 1 msec.
	EventScheduler run!

playOn: aVoice
	"Play the event list on the voice by expanding its events"

	voice := aVoice.
	self play

"	self playOn: aVoice at: Time microsecondClock"!

playOn: aVoice at: startTime
	"Play the event list on the voice by expanding its events"

	aVoice play: self at: startTime.!

scheduleAt: aTime 
	"Expand an eventList for the appointment scheduler."

	| theEvent |
	self events isEmpty ifTrue: [^nil].
	index ifNil: 
		[index := 1.
		startedAt := Time microsecondClock].
	index > self events size
		ifTrue: [index := nil. ^nil].
	theEvent := self events at: index.
	theEvent := self map: theEvent at: aTime.
	theEvent voice ifNil:
		[theEvent voice: voice].
	theEvent play.			"play the next event"
	index := index + 1.
	index > self events size
		ifTrue: [^theEvent duration isNil
			ifTrue: [startedAt + duration asUsec value]
			ifFalse: [aTime + theEvent duration asUsec value]].
	^self nextTime: aTime!

stop
	"Play the event list by passing it off to the event scheduler."

	EventScheduler instance removeClientNamed: self name! !

!Siren.EventList methodsFor: 'printing'!

asExplorerString

	^self name!

asExplorerString: ignored

	^self name!

printOn: aStream
	"Print out the receiver's events on the argument."

	| anEvent count |
	aStream nextPutAll: '(EList ', (self name printString), ' (d: ', duration printString.
	events == nil
		ifTrue: [aStream nextPutAll: ', ', self size printString, ' events'].
	aStream nextPut: $).
"	self pitch == nil
		ifFalse: [aStream nextPutAll: ' pitch: ', self pitch printString].
"	(self at: #tempo) == nil
		ifFalse: [aStream nextPutAll: ' tempo: ', (self at: #tempo) printString].
	aStream cr.
	InputState default shiftDown
			ifFalse: [count := self size min: 20]
			ifTrue: [count := self size].
	1 to: count do: [ :ind |
		anEvent := events at: ind.
		aStream tab; nextPutAll: anEvent key printString, ' => '.
		anEvent value printOn: aStream].
	count = self size 
			ifTrue: [aStream nextPut: $); cr]
			ifFalse: [aStream nextPutAll: ' ... )'; cr]!

readDataFrom: aDataStream size: size
	"Read a new event list from the given stream using the compact format."

	| cntEvents time evt |
	super readDataFrom: aDataStream size: size.	"MusicEvent's compact format"
	cntEvents := (aDataStream byteStream nextNumber: 4) - EventList instSize.
	self events: (SortedCollection new: cntEvents).
	cntEvents timesRepeat:
		["aDataStream byteStream next == 192
			ifFalse: [self error: 'Missing event key in data stream']."
				"check key for events"
		time := MusicMagnitude readDataFrom: aDataStream.
		evt := aDataStream next.
		self add: evt at: time]!

storeDataOn: aDataStream
	"Store myself on a DataStream. Answer self."
	"Format is: inst header, 4 'normal' inst vars, properties as key/val (or nil)
	# of events, events as key/val."
	"Skip index and startedAt inst vars."

	| cntEvents ass |
	super storeDataOn: aDataStream.		"MusicEvent's compact format"
	cntEvents := events size.
	aDataStream byteStream nextNumber: 4 
			put: cntEvents + EventList instSize.
	1 to: cntEvents do:
		[ :i | 
		ass := events at: i.
		"aDataStream byteStream nextPut: 192."		"key for events"
		MusicMagnitude store: ass key on: aDataStream.
		aDataStream byteStream nextPut: 9.
		ass value storeDataOn: aDataStream]!

storeOn: aStream
	"Store source code for the receiver's events on the argument."
	"(((EventList named: #Bach) expandedFrom: 0 to: 12000) 
				name: #Bach3) storeOnFile: 'Bach3.el'"

	| count title1 title2 anAssoc tempo |
	tempo := self at: #tempo.
	(self pitch == nil and: [tempo == nil])
		ifFalse: [aStream nextPutAll: '((', self class name, ' named: ',
							self name storeString, ')'.
			self pitch == nil
					ifFalse: [aStream nextPutAll: '	pitch: ',
								self pitch printString].
			tempo == nil
					ifFalse: [self pitch == nil
							ifFalse: [aStream nextPut: $;].
				aStream nextPutAll: '	tempo: ', tempo printString].
			aStream nextPut: $); cr].
	properties == nil
		ifFalse: [properties associationsDo:
			[ :ass |
			ass key = #name
				ifFalse: [aStream nextPutAll: '(', self class name, ' named: ',
							self name storeString, ')'; tab.
						aStream nextPutAll: ass key, ': ',
							ass value storeString, '.'; cr]]].
	title1 := '(', self class name, ' named: ', self name storeString, ')
add: ('.
	title2 := '); 
add: ('.
	count := events size.
	aStream nextPutAll: title1.
	1 to: count do: [ :ind |
		(ind \\ 10) = 0
			ifTrue: [aStream nextPutAll: ')!!'; cr; nextPutAll: title1].
		anAssoc := events at: ind.
		aStream nextPutAll: anAssoc key asMS value printString, ' => '.
		anAssoc value storeOn: aStream.
		((ind \\ 10) = 9 or: [ind = count])
			ifFalse: [aStream nextPutAll: title2]].
	aStream nextPutAll: ')!!'; cr!

storeOnFile: aName
	"Store out the receiver's events on the file named by the argument."

	| fs |
	fs := (Filename named: aName) writeStream.
	self storeOn: fs.
	fs close.!

templateFields
	"Answer the field names for the instances of the receiver class."

	| coll |
	coll := super templateFields.
	coll remove: #index.
	coll remove: #startedAt.
	^coll! !

!Siren.EventList methodsFor: 'private'!

map: anAssociation
	"Map the receiver's special properties and/or eventModifiers onto the given event."

	| aTime anE |
	aTime := anAssociation key.
	anE := anAssociation value.
	self pitch == nil 			"if i'm transposed"
		ifFalse: [anE pitch: (Pitch value: (anE pitch + self pitch))].
	self loudness == nil 		"or scaled"
		ifFalse: [anE loudness: (anE loudness + self loudness)].
	(properties == nil) 		"or have props"
		ifFalse: [properties associationsDo: [ :ass |
			ass key == #tempo
				ifTrue: [aTime := aTime * ass value.
						anE duration: anE duration * ass value]
				ifFalse: [anE at: ass key put: ass value]]].
	^anAssociation!

map: anAssociation at: startTime
	"Map the receiver's special properties and/or eventModifiers onto the given event."

	| aTime anE |
	aTime := anAssociation key.
	anE := anAssociation value copy.
	(self at: #pitch) == nil 			"if i'm transposed"
		ifFalse: [anE pitch: (anE pitch + (self at: #pitch))]
		ifTrue: [(self pitch) == nil
			ifFalse: [anE pitch: (anE pitch + (self pitch))]].
	(self at: #loudness) == nil 		"or scaled"
		ifFalse: [anE loudness: (anE loudness + (self at: #loudness))]
		ifTrue: [(self loudness) == nil 
			ifFalse: [anE loudness: (anE loudness + (self loudness))]].
	(self at: #tempo) == nil 			"or have a tempo map"
		ifFalse: [aTime := aTime * ((self at: #tempo) at: aTime).
			anE duration: anE duration * ((self at: #tempo) at: anE duration)]. 

	^anE! !



Smalltalk.Siren defineClass: #RestEvent
	superclass: #{Siren.DurationEvent}
	indexedType: #none
	private: false
	instanceVariableNames: ''
	classInstanceVariableNames: ''
	imports: ''
	category: 'Music-Events'!

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!


!Siren.RestEvent class methodsFor: 'instance creation'!

dur: aD
	"Answer a RestEvent instance initialized with the arguments."

	^self new duration: aD! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!


Siren.RestEvent comment:
'RestEvents are rarely used. They represent regular DurationEvents but never play themselves.'!

!Siren.RestEvent methodsFor: 'scheduling'!

play
	"Play the receiver by ignoring it."

	^nil!

playAt: aTime
	"Play the receiver on its voice then."
	
	^nil!

scheduleAt: aTime
	"Play the receiver on its voice then."

	^self! !

#{Siren.MusicEvent} initialize!

#{Siren.EventList} initialize!
