

Smalltalk.Siren defineClass: #Peal
	superclass: #{Core.SequenceableCollection}
	indexedType: #objects
	private: false
	instanceVariableNames: 'base directions position finished '
	classInstanceVariableNames: ''
	imports: ''
	category: 'Music-EventGenerators'!

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!


!Siren.Peal class methodsFor: 'examples'!

pealExample1
	"Play a simple bell peal"
	"Peal pealExample1"

	(Peal upon: #(60 62 64 65)) eventList edit.! !

!Siren.Peal class methodsFor: 'instance creation'!

new: size
	"Create a new peal on the given size with 1..size as the base set."

	| newPeal |
	newPeal := self basicNew: size.
	newPeal setBase: (1 to: size).
	^ newPeal!

upon: baseSet
	"Create a new peal on the base set given"

	| newPeal |
	newPeal := self basicNew: baseSet size.
	newPeal setBase: baseSet.
	^ newPeal! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!


Siren.Peal comment:
'Peals are repetitive note-generating sequences.  
This implementation was written by Mark Lentczner in 1986.

Instance variables:
	base <Collection of Numbers> the pitches i use
	directions <Array of +-1> the direction of the current sub-sequence
	position <Number> the current index
	finished <Boolean> an i done?'!

!Siren.Peal methodsFor: 'accessing'!

at: index
	"Answer the element in the base collection currently mapped into the index position."

	^ base at: (self basicAt: index)!

at: index put: object

	^ self error: 'Can''t modify a peal by at:put:'!

currentChange
	"Answer the base as mapped by the current change."

	^(1 to: self size) collect: [ :i  | self at: i ]!

finished
	"Answer is the peal has completed it's last change"

	^ finished!

setBase: baseSet
	"Initialize the base set and everything else."

	base := baseSet.
	directions := Array new: self size withAll: 1.
	position := 1.
	1 to: self size do: [:i | self basicAt: i put: i].
	finished := false.!

size
	"Redone here because SequencableCollection overrides it."

	^ self basicSize! !

!Siren.Peal methodsFor: 'changing'!

change
	"Produce the next change in the peal"

	self changeOrder: 1 bounds: (1 to: self size)! !

!Siren.Peal methodsFor: 'playing'!

eventList

	| list |
	list := EventList new.
	self playOn: list durations: 125 meter: 125 at: 0.
	^list!

play
	self eventList play!

playOn0: out durations: dur meter: mtr at: start
	"Play the receiver"

	| time siz |
	time := start.
	siz := self size.
	[finished] whileFalse:
		[1 to: siz do: 
			[ :i | out play: (self at: i) at: time dur: dur amp: 100. 
				time := time + mtr ].
		self change.
		1 to: siz - 1 do: 
			[ :i | out play: (self at: i) at: time dur: dur amp: 100. 
				time := time + mtr ].
		out play: (self at: siz ) at: time dur: dur + mtr amp: 100.  
				time := time + mtr + mtr.
		self change].
	1 to: siz do: 
			[ :i | out play: (self at: i) at: time dur: dur amp: 100. 
				time := time + mtr ].!

playOn: vox
	self eventList playOn: vox!

playOn: out durations: dur meter: mtr at: start
	"Play the receiver"

	| time siz |
	time := start.
	siz := self size.
	[finished] whileFalse:
		[1 to: siz do: 
			[ :i | out add: time => ((self at: i) note, dur msec, 100 velocity). 
				time := time + mtr].
		self change.
		1 to: siz - 1 do: 
			[ :i | out add: time => ((self at: i) note, dur msec, 100 velocity). 
				time := time + mtr].
		out add: time => ((self at: siz) note, (dur + mtr) msec, 100 velocity).  
				time := time + mtr + mtr.
		self change].
	1 to: siz do: 
			[ :i | out add: time => ((self at: i) note, dur msec, 100 velocity). 
				time := time + mtr].! !

!Siren.Peal methodsFor: 'private'!

changeOrder: n bounds: range
	"Produce the next change in the peal by moving the element n within the range.  If the element wants to move outside the range, alter it's direction and move the next element (recursively call this)."

	| neighbor location |
	location := self indexOfElement: n.
	neighbor := location + (directions at: n).

	(n = self size) ifTrue:
		[(n = 1) ifFalse:
			[self swap: location with: neighbor.
			directions at: n-1 put: (directions at: n-1) negated].
		finished := true.
		^ self].

	(range includes: neighbor) ifTrue:
		[self swap: location with: neighbor]
	ifFalse:
		[directions at: n put: (directions at: n ) negated.
		self changeOrder: n+1 bounds: (range copyWithout: location)]!

indexOfElement: n
	"Answer the index the anElement item  (i.e. the n-th item, not the item = to n) within the receiver."

	1 to: self size do:
		[:i | (self basicAt: i) = n ifTrue: [^ i]].
	^ self error: 'An element does not exist in this peal'!

swap: index1 with: index2
	"We need to redefine this, since we redefined at: & at:put: to map trhrough the base collection"

	| temp |
	temp := self basicAt: index1.
	self basicAt: index1 put: (self basicAt: index2).
	self basicAt: index2 put: temp! !



Smalltalk.Siren defineClass: #EventGenerator
	superclass: #{Siren.EventList}
	indexedType: #none
	private: false
	instanceVariableNames: ''
	classInstanceVariableNames: ''
	imports: ''
	category: 'Music-EventGenerators'!

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!


!Siren.EventGenerator class methodsFor: 'accessing instances'!

all
	"Find the and return instances of me or any subclasses of me."

	| coll |
	coll := Set new.
	self allSubInstancesDo: [ :anI | coll add: anI ].
	^coll!

allPlaying
	"Find all playing instances of me or my subclasses."

	| coll |
	coll := Set new.
	self allSubInstancesDo: [ :anI | anI playing ifTrue: [coll add: anI]].
	^coll!

named: aName 
	"Find the named instance of me or a subclass of me."

	^SirenSession eventLists at: aName
		ifAbsent: [SirenSession events at: aName ifAbsent: [nil]]!

stopAll
	"Find all playing instances of me or my subclasses and terminate them."

	self allSubInstancesDo: [ :anI | anI playing ifTrue: [anI stop]].! !

!Siren.EventGenerator class methodsFor: 'examples'!

randomExample
	"Play random examples from the set of examples in my subclasses"
	"[Sensor anyButtonPressed] whileFalse: [EventGenerator randomExample]"

	((Smalltalk at: 
			(#(Cloud DynamicCloud SelectionCloud DynamicSelectionCloud "Peal") 
					atRandom)) 
		randomExample) play! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!


Siren.EventGenerator comment:
'This class is the parent of most of the simple music-structure classes in this category.
An EventGenerator can create an EventList using its given parameters and a function (block) to use to create Event sequences.  See the subclasses for examples.
'!

!Siren.EventGenerator methodsFor: 'playing'!

edit
	"edit me"

	self eventList edit!

eventList
	"Answer an eventList for the receiver."

	self subclassResponsibility!

play
	"Play the receiver's event list."

	self eventList play! !



Smalltalk.Siren defineClass: #Cluster
	superclass: #{Siren.EventGenerator}
	indexedType: #none
	private: false
	instanceVariableNames: ''
	classInstanceVariableNames: ''
	imports: ''
	category: 'Music-EventGenerators'!

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!


!Siren.Cluster class methodsFor: 'examples'!

example1
	"Cluster example1"
	"play a 2 second c-major chord"

	(Cluster  dur: 2.0
		pitchSet: (#(0 4 7  12 16 19  24 28 31  36 40 43  48) collect: [ :val | val + 24])
		ampl: 100
		voice: 1) play!

example2
	"Cluster example2"
	"play a low 2 second cluster"

	(Cluster  dur: 2.0
		pitchSet: #(48  50  52  54 56)
		ampl: 100
		voice: 6) play! !

!Siren.Cluster class methodsFor: 'instance creation'!

dur: aD list: anEL ampl: anA
	"return an initialized Cluster with the given list as pitches"

	^self new duration: aD; 
		events: anEL; 
		loudness: anA!

dur: aD list: anEL ampl: anA voice: aV
	"return an initialized Cluster with the given list as pitches"

	^self new duration: aD; 
		events: anEL; 
		loudness: anA; 
		voice: aV!

dur: aD pitchSet: aColl ampl: anA voice: aV
	"return an initialized Cluster with the given list as pitches"

	^self new duration: aD; 
		events: aColl; 
		loudness: anA; 
		voice: aV! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!


Siren.Cluster comment:
'Cluster is an abstraction of a set of simultaneous (or same-pitch) events.
A cluster need only have a set of pitches, or a rhythm.
'!

!Siren.Cluster methodsFor: 'playing'!

eventList
	"make the cluster's events"

	| pattern |
	pattern := EventList newAnonymous.
	self events do:
		[ :anEvent |
		pattern add: (MusicEvent 
			dur: self duration
			pitch: ((anEvent isAssociation) 
					ifTrue: [anEvent value pitch]
					ifFalse: [anEvent])
			ampl: self loudness
			voice: self voice)
			at: 0 ].
	^pattern! !



Smalltalk.Siren defineClass: #Roll
	superclass: #{Siren.Cluster}
	indexedType: #none
	private: false
	instanceVariableNames: 'number delta noteDuration '
	classInstanceVariableNames: ''
	imports: ''
	category: 'Music-EventGenerators'!

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!


!Siren.Roll class methodsFor: 'examples'!

rollExample
	"Create and edit/play a few rolls."

	"((Roll length: 2 rhythm: 100 note: 48) ampl: 100) eventList"
	"((Roll length: 2 rhythm: 100 note: 48) ampl: 100) eventList edit"
	((Roll length: 2 rhythm: 50 note: 60) ampl: 80) eventList play.
"	MIDIPort allNotesOff."! !

!Siren.Roll class methodsFor: 'instance creation'!

length: aNumber rhythm: aDuration note: aNote
	"return a new roll of the specified length..."
	"(Roll length: 2 rhythm: 50 note: 60) ampl: 80 - length is in secs, rhy is note dur in msec"

	^self new length: aNumber rhythm: aDuration note: aNote!

number: aNumber duration: aDuration pitch: aNote
	"return a new roll with the specified number of events..."

	^self new number: aNumber rhythm: aDuration note: aNote!

rollLen: aNumber noteLen: aDuration pitch: aNote ampl: anAmpl
	"return a new roll of the specified length..."
	"(Roll rollLen: 2 noteLen 50 pitch: 60) ampl: 80 - length is in secs, rhy is note dur in msec"

	^self new length: aNumber rhythm: aDuration note: aNote ampl: anAmpl! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!


Siren.Roll comment:
'Rolls repeat their single events.
It will eventually be possible to apply pitch, amplitude or duration envelopes to them as well.

Instance variables:
	number <Integer> how many notes to play
	delta <Number> delta time between events
	noteDuration <Number> duration of events'!

!Siren.Roll methodsFor: 'initialize'!

length: aLength rhythm: aDuration note: aNote
	"make a new roll of the specified length..."

	delta := aDuration.
	noteDuration := aDuration.
	number := aLength / aDuration.
	self pitch: (Pitch value: aNote).
	^self!

length: aLength rhythm: aDuration note: aNote ampl: anAmpl
	"make a new roll of the specified length..."

	duration := aLength sec.
	delta := aDuration.
	noteDuration := aDuration.
	number := aLength / (aDuration / 1000).
	self pitch: (Pitch value: aNote).
	self ampl: anAmpl.
	^self!

number: aNumber rhythm: aDuration note: aNote
	"make a new roll with the specified number of notes..."

	delta := aDuration.
	number := aNumber.
	noteDuration := aDuration.
	self pitch: (Pitch value: aNote).
	^self! !

!Siren.Roll methodsFor: 'accessing'!

duration
	"compute and answer the duration"

	^duration == nil 
		ifFalse: [duration]
		ifTrue: [number * noteDuration]! !

!Siren.Roll methodsFor: 'playing'!

eventList
	"return an eventList for me"

	| newList |
	newList := EventList newAnonymous.
	0 to: number do:
		[ :count |
			newList add: (self defaultEventClass 
					dur: noteDuration pitch: self pitch ampl: self loudness) 
				at: (delta * count) ].
	^newList! !



Smalltalk.Siren defineClass: #Cloud
	superclass: #{Siren.EventGenerator}
	indexedType: #none
	private: false
	instanceVariableNames: 'density '
	classInstanceVariableNames: ''
	imports: ''
	category: 'Music-EventGenerators'!

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!


!Siren.Cloud class methodsFor: 'instance creation'!

dur: aD pitch: aP ampl: anA
	"return an initialized Cloud"

	^self new duration: aD; 
		pitch: aP; 
		loudness: anA!

dur: aD pitch: aP ampl: anA voice: aVoice
	"return an initialized Cloud"

	^self new duration: aD; 
		pitch: aP; 
		loudness: anA; 
		voice: aVoice!

dur: aD pitch: aP ampl: anA voice: aVoice density: aDe
	"return an initialized Cloud"

	^self new duration: aD; 
		pitch: aP; 
		loudness: anA; 
		voice: aVoice; 
		density: aDe!

dur: aD voice: aVoice density: aDe
	"return an initialized Cloud"

	^self new duration: aD; 
		voice: aVoice; 
		density: aDe!

fromDictionary: aDictionary
	"Answer an initialized Cloud generated from the given property map dictionary."

	"(Cloud fromDictionary: ((#duration -> 5000), 
			(#pitch -> (48 to: 74)),
			(#loudness -> (50 to: 100)), 
			(#voice -> (1 to: 4)), 
			(#density -> 25))) eventList edit"


	| me |
	me := self new.
	aDictionary associationsDo: 
		[ :ass |
		me perform: ((ass key, ':') asSymbol) with: ass value].
	^me! !

!Siren.Cloud class methodsFor: 'examples'!

dictionaryExample
	"Answer an initialized Cloud generated from the given property map dictionary."
	"Cloud dictionaryExample"

	(Cloud fromDictionary: ((#duration -> 5000), 
			(#pitch -> (48 to: 70)),
			(#loudness -> (50 to: 100)), 
			(#voice -> (1 to: 4)), 
			(#density -> 15))) eventList edit!

example1
	"Create and edit a low 6 second stochastic cloud with 5 events per second"
	"Cloud example1"

	| c |
	c := (Cloud  dur: 6
		pitch: (48 to: 60)  
		ampl: (80 to: 120) 
		voice: (1 to: 4)
		density: 5) eventList.
"	c edit "
	c play
"	c inspect"!

randomExample
	"Play a stochastic cloud with random properties."
	"Cloud randomExample"

	| rand pBase score |
	rand := Random new.
	pBase := 20 + (rand next * 60) rounded.
	score := (Cloud  dur: (2 + (rand next * 6) asInteger)
		pitch: (pBase to: (pBase + (rand next * 40)) rounded)  
		ampl: (80 to: 120) 
		voice: (1 to: 8)
		density: (rand next * 20)) eventList.
	score play.
	(Delay forSeconds: 5) wait.
	MIDIPort allNotesOff
"	score inspect
	score edit
"!

randomExample2
	"Play a stochastic cloud with random properties."
	"Cloud randomExample2"

	| rand pBase score |
	rand := Random new.
	pBase := 20 + (rand next * 60) rounded.
	score := (Cloud  dur: (3 + (rand next * 6))
		pitch: (pBase to: (pBase + (rand next * 40)) rounded)  
		ampl: (80 to: 120) 
		voice: (1 to: 8)
		density: (rand next * 20)) eventList.
	score play.
	MIDIPort allNotesOff
"	score inspect
	score edit
"! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!


Siren.Cloud comment:
'Clouds are eventLists that are describe in terms of their contours or selection criteria.
This can be (e.g.,) POD-style specification of ranges for random selection, or selection from a given set of pitches.
See the class examples of my subclasses for description examples.

Instance variables:
	density		<Number> number of notes per second'!

!Siren.Cloud methodsFor: 'accessing'!

density: theDensity
	"set the density instance variable"

	density := theDensity! !

!Siren.Cloud methodsFor: 'playing'!

eventList
	"Make the cloud's events; assume that the receiver's pitch, loudness and 
	durations are actually intervals"

	| pattern number length start |
	pattern := EventList new.
	number := duration asSeconds value asFloat * density.
	length := (1000 / density) rounded.
	start := 0.
	number truncated timesRepeat:
		[pattern add: (MusicEvent 
				dur: (length * 2) 	"legato"
				pitch: self pitch value atRandom
				ampl: self loudness value atRandom
				voice: ((self voice == nil 
						ifTrue: [nil] 
						ifFalse: [self voice atRandom])))
			at: start.
		start := start + length].
	^pattern!

eventList0
	"Make the cloud's events; assume that the receiver's pitch, loudness and 
	durations are actually intervals"

	| pattern rand number length start |
	pattern := EventList new.
	rand := Random new.
	number := duration asSeconds value asFloat * density.
	length := (1000 / density) rounded.
	start := 0.
	number truncated timesRepeat:
		[pattern add: (MusicEvent 
			dur: (length * 2 "+ (2000 * rand next) rounded")
			pitch: ((self pitch value first) + 
					((rand next * (self pitch value last - self pitch value first)) rounded))
			ampl: ((self loudness value first) + 
					((rand next * (self loudness value last - self loudness value first)) rounded))
			voice: ((self voice == nil 
						ifTrue: [nil] 
						ifFalse: [(self voice first) + 
					((rand next * (self voice last - self voice first)) rounded)])))
			at: start.
		start := start + length].
	^pattern! !



Smalltalk.Siren defineClass: #DynamicCloud
	superclass: #{Siren.Cloud}
	indexedType: #none
	private: false
	instanceVariableNames: ''
	classInstanceVariableNames: ''
	imports: ''
	category: 'Music-EventGenerators'!

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!


!Siren.DynamicCloud class methodsFor: 'examples'!

crescendoExample
	"Create and play an 8-second cloud that goes from soft to loud on the same pitch."
	"DynamicCloud crescendoExample"

	(DynamicCloud  dur: 6  
		pitch: (40 to: 40)
		ampl: #((20 to: 30) (80 to: 100))
		voice: (1 to: 1)
		density: 20) eventList 
	"edit" 
	play.  MIDIPort allNotesOffIn: 8
	"inspect"!

example1
	"Edit a 6-second cloud that goes from low to high and soft to loud."
	"DynamicCloud example1"

	(DynamicCloud  dur: 6  
		pitch: #((30 to: 44) (50 to: 50))
		ampl: #((20 to: 40) (90 to: 120))
		voice: (1 to: 4)
		density: 20) eventList "edit" play "inspect"!

example4
	"Edit a 6 second cloud that focuses on its center"
	"DynamicCloud example4"

	(DynamicCloud  dur: 6  
		pitch: #((30 to: 64) (40 to: 40))
		ampl: #((20 to: 40) (90 to: 120))
		voice: (1 to: 8)
		density: 10) eventList edit!

focusExample
	"Create a 6-second cloud that focuses on its center."
	"DynamicCloud focusExample"

	(DynamicCloud  dur: 6  
		pitch: #((60 to: 84) (68 to: 68))
		ampl: #((20 to: 20) (90 to: 100))
		voice: (1 to: 8)
		density: 10) eventList edit "play" "inspect"!

randomExample
	"Create a dynamic second cloud with random properties."
	"DynamicCloud randomExample edit"

	| rand |
	rand := Random new.
	^DynamicCloud  dur: (rand nextIntFrom: 3 to: 8)  
		pitch: (Array with: ((rand nextIntFrom: 24 to: 48) 
					to: (rand nextIntFrom: 24 to: 54))
				with: ((rand nextIntFrom: 48 to: 60)
					to: (rand nextIntFrom: 60 to: 72)))
		ampl: (Array with: ((rand nextIntFrom: 24 to: 36)
					to: (rand nextIntFrom: 36 to: 48))
				with: ((rand nextIntFrom: 72 to: 88)
					to: (rand nextIntFrom: 80 to: 112)))
		voice: (1 to: 4)
		density: (rand nextIntFrom: 4 to: 16)! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!


Siren.DynamicCloud comment:
'Dynamic clouds are clouds that have starting and ending conditions (ranges or selection sets) and interpolate between them over their duration.'!

!Siren.DynamicCloud methodsFor: 'playing'!

eventList
	"make the cloud's events--assume that the receiver's pitch, loudness and durations are actually ARRAYS of two intervals (for the start and end ranges)"

	| pattern rand number length start percent pRange p1 p2 p3 p4 
		amplRange a1 a2 a3 a4 v1 v2 v3 v4 vRange |
	pattern := EventList new.
	rand := Random new.
	number := duration asSeconds value asFloat * density.
	length := (1000 / density) rounded.
	start := 0.
	(self pitch value isMemberOf: Array)
		ifTrue: [pRange := self pitch value first.
			p1 := self pitch value first first.
			p2 := self pitch value first last.
			p3 := self pitch value last first - p1.
			p4 := self pitch value last last - p2]
		ifFalse: [pRange := self pitch value].
	(self loudness value isMemberOf: Array)
		ifTrue: [amplRange := self loudness value first.
			a1 := self loudness value first first.
			a2 := self loudness value first last.
			a3 := self loudness value last first - a1.
			a4 := self loudness value last last - a2]
		ifFalse: [amplRange := self loudness value].
	(self voice isMemberOf: Array)
		ifTrue: [vRange := self voice first.
			v1 := self voice first first.
			v2 := self voice first last.
			v3 := self voice last first - v1.
			v4 := self voice last last - v2]
		ifFalse: [vRange := self voice].
	1 to: number truncated do:
		[ :count |
		pattern add: (MusicEvent 
			dur: (length * 2 + (length * rand next) rounded)
			pitch: ((pRange first rounded) + 
					((rand next * (pRange last - pRange first)) rounded))
			ampl: ((amplRange first rounded) + 
					((rand next * (amplRange last - amplRange first)) rounded))
			voice: (self voice == nil 
						ifTrue: [nil] 
						ifFalse: [(vRange first rounded) + 
					((rand next * (vRange last - vRange first)) rounded)]))
			at: start.
		start := start + length.
	percent := count / number.
	(self pitch value isMemberOf: Array)
		ifTrue: [pRange := p1 + (p3 * percent) to: p2 + (p4 * percent)].
	(self loudness value isMemberOf: Array)
		ifTrue: [amplRange := a1 + (a3 * percent) to: a2 + (a4 * percent)].
	(self voice isMemberOf: Array)
		ifTrue: [vRange := v1 + (v3 * percent) to: v2 + (v4 * percent)]].
	^pattern! !



Smalltalk.Siren defineClass: #Ostinato
	superclass: #{Siren.EventGenerator}
	indexedType: #none
	private: false
	instanceVariableNames: 'list playing process '
	classInstanceVariableNames: ''
	imports: ''
	category: 'Music-EventGenerators'!

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!


!Siren.Ostinato class methodsFor: 'instance creation'!

named: aSymbol onList: anEL 
	"create an Ostinato on the given EventList."

	| me |
	me := self new initializeNamed: aSymbol.
	me list: anEL.
	^me!

named: aSymbol onList: anEL dur: theDur
	"create an Ostinato on the given EventList."

	| me |
	me := self new initializeNamed: aSymbol.
	me list: anEL.
	me dur: theDur.
	^me!

newNamed: aSymbol onList: anEL 
	"create an Ostinato on the given EventList."

	| me |
	me := self new initializeNamed: aSymbol.
	me list: anEL.
	^me!

onList: anEL 
	"create an Ostinato on the given EventList."

	| me |
	me := self new initializeAnonymous.
	me list: anEL.
	me events: anEL events.
	^me!

onList: anEL dur: theDur
	"create an Ostinato on the given EventList."

	| me |
	me := self new initializeAnonymous.
	me list: anEL.
	me dur: theDur.
	^me! !

!Siren.Ostinato class methodsFor: 'examples'!

ostinatoExamples
	"Create and edit some ostinati."

	"Ostinato onList: (EventList named: #scale1)"
	"Ostinato onList: (EventList named: #scale1) edit"
	"Ostinato newNamed: #scaleO onList: (EventList named: #scale1)"
	"(Ostinato named: #scaleO) play"
	"(Ostinato named: #scaleO) playOn: 1 at: 0"
	"(Ostinato named: #scaleO) stop"!

trillExample
	"Create and edit some ostinati."
	"Ostinato trillExample"

	| el os tm |
	tm := 1/2.
	el := (0 beat => (#c5 pitch, #pp ampl, tm beat)),
		(tm beat =>(#d5 pitch, #pp ampl, tm beat)).
	os := Ostinato onList: el.
	os playOn: MIDIVoice default at: Time microsecondClock usec.
"	(Delay forSeconds: 5) wait.
	el events first event pitch: #e5 pitch.
"	(Delay forSeconds: 4) wait.
	os stop! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!


Siren.Ostinato comment:
'Ostinati can repeat their basic eventList without end, if necessary.

Instance variables:
	list <EventList> my riff
	playing <Boolean> am i on?
	process <Process> the process that''s playing me
'!

!Siren.Ostinato methodsFor: 'initializing'!

initializeAnonymous
	"set up a new Ostinato."

	super initializeAnonymous.
	playing := false.!

initializeNamed: aName
	"Set up a new Ostinato."

	super initializeNamed: aName.
	playing := false.! !

!Siren.Ostinato methodsFor: 'accessing'!

events
	^list events!

list
	^list!

list: anEL
	list := anEL!

process: anBlockOrProc
	process := anBlockOrProc! !

!Siren.Ostinato methodsFor: 'playing'!

play: numberOfTimes
	"return an event list from the given number of times playing"

	| time pattern |
	time := 0 msec.
	pattern := EventList newAnonymous.
	numberOfTimes timesRepeat:
		[pattern add: list at: time.
		time := list duration + time].
	pattern play!

playAt: firstTime
	"Play an ostinato until turned off."

	| startTime rTime | 
	startTime := firstTime.
	rTime := Time microsecondClock.
	playing := true.
	voice := list voice == nil 
		ifFalse: [list voice] 
		ifTrue: [Voice default].
	process := [[playing] whileTrue: 
			[voice play: list at: startTime.
			startTime := startTime + list duration.
			(Delay untilMicroseconds: rTime + startTime - 50000) wait.
		Transcript show: 'x '. ]] fork"At: 5"!

playOn: aVoice at: firstTime
	"Play an ostinato until turned off."
	"Ostinato trillExample"

	| startTime del | 
	startTime := firstTime.
"	self halt.
	list playOn: aVoice at: startTime."
	playing := true.
	process := [[playing] whileTrue: 
			[Transcript show: 'Starting EL at ', startTime printString; cr.
			list playOn: aVoice at: startTime.
			del := list duration asUsec value.
			startTime := startTime + del.
			(startTime > (firstTime + 5000000))
				ifTrue: [Transcript show: 'Ost done'; cr.
					playing := false].
			(Delay forMicroseconds: del) wait]] fork "At: 5".
	Processor yield.  					"give proc a chance to run"!

stop
	"stop a playing Ostinato."
		
	playing := false.
"	self list stop"! !

!Siren.Ostinato methodsFor: 'printing'!

printOn: aStream

	self name isNil ifFalse: [
		aStream nextPutAll: 'Ostinato named: ', self name asString, ' on EventList: (']
	ifTrue: [
		aStream nextPutAll: 'Ostinato on EventList: ('].
	aStream cr.
	list printOn: aStream.
	aStream nextPutAll: ') playing= ', playing printString; cr! !



Smalltalk.Siren defineClass: #SelectionCloud
	superclass: #{Siren.Cloud}
	indexedType: #none
	private: false
	instanceVariableNames: ''
	classInstanceVariableNames: ''
	imports: ''
	category: 'Music-EventGenerators'!

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!


!Siren.SelectionCloud class methodsFor: 'examples'!

example1
	"Create a low 4 second cloud selecting pitch, amp and voice from value arrays."
	"SelectionCloud example1"

	(SelectionCloud  dur: 4  
		pitch: #(32 40 48 50 52 55 57 )
		ampl: #(80 80 120)
		voice: #(1 2 3 4)
		density: 8) eventList "edit" play "inspect"!

exampleRand
	"Edit a selection cloud with random properties."
	"SelectionCloud exampleRand"

	| rand pBase pArray aArray score |
	rand := Random new.
	pBase := 30 + (rand next * 40) rounded.
	pArray := Array new: 2 + ((rand next * 4) rounded).
	1 to: pArray size do: [:ind | pArray at: ind put: (pBase+(rand  next * 12) rounded)].
	pBase := 20 + (rand next * 60) rounded.
	aArray := Array new: 2 + ((rand next * 6) rounded).
	1 to: aArray size do: [:ind | aArray at: ind put: (pBase+(rand  next * (120 - pBase)) rounded)].
	score := (SelectionCloud  dur: (3 + (rand next * 4) rounded)
		pitch: pArray
		ampl: aArray
		voice: (1 to: 8)
		density: (3 + (rand next * 15) rounded)) eventList.
	score edit.
"	score play.
	(Delay forMilliseconds: (score duration + 1000)) wait
"!

randomExample
	"Create a selection cloud with random properties."
	"SelectionCloud randomExample"

	| rand pBase pArray aArray score |
	rand := Random new.
	pBase := 20 + (rand next * 40) rounded.
	pArray := Array new: 2 + ((rand next * 4) rounded).
	1 to: pArray size do: [:ind | pArray at: ind put: (pBase+(rand  next * 12) rounded)].
	pBase := 20 + (rand next * 60) rounded.
	aArray := Array new: 2 + ((rand next * 6) rounded).
	1 to: aArray size do: [:ind | aArray at: ind put: (pBase+(rand  next * (120 - pBase)) rounded)].
	score := (SelectionCloud  dur: (3 + (rand next * 4) rounded)
		pitch: pArray
		ampl: aArray
		voice: (1 to: 8)
		density: (3 + (rand next * 15) rounded)) eventList.
	score inspect.
"	score play.
	(Delay forMilliseconds: (score duration + 1000)) wait
"! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!


Siren.SelectionCloud comment:
'Selection clouds are created with a set of pitch and amplitude values and return eventLists selected from these values.'!

!Siren.SelectionCloud methodsFor: 'playing'!

eventList
	"Make the cloud's events"
	"assume that the receiver's pitch, loudness and durations are actually intervals"

	| pattern rand number length start |
	pattern := EventList new.
	rand := Random new.
	density isEvent
		ifTrue: [^self eventListWithDensityFunction].
	number := duration asSeconds value asFloat * density.
	length := (1000 / density) rounded.
	start := 0.
	number truncated timesRepeat:
		[ pattern add: (MusicEvent 
			dur: (length * 2 "+ (2000 * rand next) rounded")
			pitch: (self pitch value atRandom: rand)
			ampl: (self loudness value atRandom: rand)
			voice: (self voice atRandom: rand))
			at: start.
		start := start + length].
	^pattern!

eventListWithDensityFunction
	"make the cloud's events"
	"assume that the receiver's density is a function and that the voices are a selection set."

	| dur pattern rand dens time playing ends snd |
	pattern := EventList new.
	rand := Random new.
	time := 0.0. 		"msec"
	playing := 0.
	dens := density at: 0.
	ends := SortedCollection new: (density range extent + 1) truncated.
"prime the generators"
	playing := 1.
	ends add: 0.0.							"time at first note end"
	time := 0.0.
	dur := duration asSec value.
"Step through the end times."
	[time < dur] whileTrue:
		[time := ends removeFirst.			"step to next end time"
		playing := playing - 1.
		dens := density at: (time / dur).
		[dens > playing] whileTrue: 
			[snd := self voice atRandom: rand.
			pattern add: (MusicEvent dur: snd duration 
								voice: snd 
								ampl: (1.0 / dens)) at: time.
			ends add: (time + snd duration asSec value).
			playing := playing + 1]].
	^pattern! !



Smalltalk.Siren defineClass: #Chord
	superclass: #{Siren.Cluster}
	indexedType: #none
	private: false
	instanceVariableNames: 'root inversion type arity '
	classInstanceVariableNames: ''
	imports: ''
	category: 'Music-EventGenerators'!

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!


!Siren.Chord class methodsFor: 'instance creation'!

majorTetradOn: tonic inversion: inversion
	"return a three-note major chord on the given tonic in the given inversion"
	"Chord majorTetradOn: 'c3' inversion: 0"

	| me |
	me := self newAnonymous.
	me root: tonic;
		inversion: inversion;
		type: #major;
		arity: 4.
	^me!

majorTriadOn: tonic inversion: inversion
	"return a three-note major chord on the given tonic in the given inversion"
	"Chord majorTriadOn: 'c3' inversion: 0"

	| me |
	me := self newAnonymous.
	me root: tonic;
		inversion: inversion;
		type: #major;
		arity: 3.
	^me!

minorTetradOn: tonic inversion: inversion
	"return a three-note minor chord on the given tonic in the given inversion"
	"Chord minorTetradOn: 'c3' inversion: 0"

	| me |
	me := self newAnonymous.
	me root: tonic;
		inversion: inversion;
		type: #minor;
		arity: 4.
	^me!

minorTriadOn: tonic inversion: inversion
	"return a three-note minor chord on the given tonic in the given inversion"
	"Chord minorTriadOn: 'c3' inversion: 0"

	| me |
	me := self newAnonymous.
	me root: tonic;
		inversion: inversion;
		type: #minor;
		arity: 3.
	^me! !

!Siren.Chord class methodsFor: 'examples'!

example
	"Create and edit some chords."

	"(Chord majorTriadOn: 'c3' inversion: 0) inspect"

	"((Chord majorTetradOn: 'f2' inversion: 2) duration: 1.0) inspect"

	((Chord majorTetradOn: 'g5' inversion: 1) duration: 1.0) edit! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!


Siren.Chord comment:
'Instances of Chord are eventLists that can be created by giving them a root and inversion. They can return eventLists.

Instance variables:
	root <Pitch> the root of the chord
	inversion <Integer> the inversion level (unused at present)
	type <Symbol> #major, #minor, etc.
	arity <Integer> number of notes of the chord'!

!Siren.Chord methodsFor: 'generating events'!

majorTetrad
	"return a three-note major chord on the given tonic in the given inversion"
	"Chord majorTetradOn: 'c3' inversion: 0"

	| me rootNote |
	me := EventList newAnonymous.
	rootNote := me defaultEventClass dur: duration pitch: root ampl: 100.
	inversion = 0 ifTrue:
		[ me add: rootNote at: 0;
			add: (rootNote copy transposeBy: 4) at: 0;
			add: (rootNote copy transposeBy: 7) at: 0;
			add: (rootNote copy transposeBy: 12) at: 0 ].
	inversion = 1 ifTrue:
		[ me add: (rootNote copy transposeBy: 4) at: 0;
			add: (rootNote copy transposeBy: 7) at: 0;
			add: (rootNote copy transposeBy: 12) at: 0;
			add: (rootNote copy transposeBy: 16) at: 0 ].
	inversion = 2 ifTrue:
		[ me add: (rootNote copy transposeBy: 7) at: 0;
			add: (rootNote copy transposeBy: 12) at: 0;
			add: (rootNote copy transposeBy: 16) at: 0;
			add: (rootNote copy transposeBy: 19) at: 0 ].
	^me!

majorTriad
	"return a three-note major chord on the given tonic in the given inversion"
	"Chord majorTriadOn: 'c3' inversion: 0"

	| me rootNote |
	me := EventList newAnonymous.
	rootNote := me defaultEventClass dur: duration pitch: root ampl: 100.
	inversion = 0 ifTrue:
		[ me add: rootNote at: 0;
			add: (rootNote copy transposeBy: 4) at: 0;
			add: (rootNote copy transposeBy: 7) at: 0 ].
	inversion = 1 ifTrue:
		[ me add: (rootNote copy transposeBy: 4) at: 0;
			add: (rootNote copy transposeBy: 7) at: 0;
			add: (rootNote copy transposeBy: 12) at: 0 ].
	inversion = 2 ifTrue:
		[ me add: (rootNote copy transposeBy: 7) at: 0;
			add: (rootNote copy transposeBy: 12) at: 0;
			add: (rootNote copy transposeBy: 16) at: 0 ].
	^me!

minorTetrad
	"return a three-note minor chord on the given tonic in the given inversion"
	"Chord minorTetradOn: 'c3' inversion: 0"

	| me rootNote |
	me := EventList newAnonymous.
	rootNote := me defaultEventClass dur: duration pitch: root ampl: 100.
	inversion = 0 ifTrue:
		[ me add: rootNote at: 0;
			add: (rootNote copy transposeBy: 3) at: 0;
			add: (rootNote copy transposeBy: 7) at: 0;
			add: (rootNote copy transposeBy: 12) at: 0 ].
	inversion = 1 ifTrue:
		[ me add: (rootNote copy transposeBy: 3) at: 0;
			add: (rootNote copy transposeBy: 7) at: 0;
			add: (rootNote copy transposeBy: 12) at: 0;
			add: (rootNote copy transposeBy: 15) at: 0 ].
	inversion = 2 ifTrue:
		[ me add: (rootNote copy transposeBy: 7) at: 0;
			add: (rootNote copy transposeBy: 12) at: 0;
			add: (rootNote copy transposeBy: 15) at: 0;
			add: (rootNote copy transposeBy: 19) at: 0 ].
	^me!

minorTriad
	"return a three-note minor chord on the given tonic in the given inversion"
	"Chord minorTriadOn: 'c3' inversion: 0"

	| me rootNote |
	me := EventList newAnonymous.
	rootNote := me defaultEventClass dur: duration pitch: root ampl: 100.
	inversion = 0 ifTrue:
		[ me add: rootNote at: 0;
			add: (rootNote copy transposeBy: 3) at: 0;
			add: (rootNote copy transposeBy: 7) at: 0 ].
	inversion = 1 ifTrue:
		[ me add: (rootNote copy transposeBy: 3) at: 0;
			add: (rootNote copy transposeBy: 7) at: 0;
			add: (rootNote copy transposeBy: 12) at: 0 ].
	inversion = 2 ifTrue:
		[ me add: (rootNote copy transposeBy: 7) at: 0;
			add: (rootNote copy transposeBy: 12) at: 0;
			add: (rootNote copy transposeBy: 15) at: 0 ].
	^me! !

!Siren.Chord methodsFor: 'accessing'!

arity: aNumber
	"set the number of notes of the receiver chord"

	arity := aNumber!

duration: aDuration
	"set the durations of my notes"
	
	| realDuration |
	aDuration class == Duration 
		ifTrue: [ realDuration := aDuration ]
		ifFalse: [ realDuration := Duration value: aDuration ].
	events do: [ :anAssociation |
		anAssociation value duration: realDuration ].
	duration := realDuration asMS!

eventList
	"Answer the receiver's events"

	type == #major
		ifTrue: [arity = 3
			ifTrue: [^self majorTriad]
			ifFalse: [^self majorTetrad]]
		ifFalse: [arity = 3
			ifTrue: [^self minorTriad]
			ifFalse: [^self minorTetrad]].
	self error: 'Unknown chord type/arity'!

inversion: number
	"set the inversion of the receiver chord"

	inversion := number!

root: tonic
	"set the root of the receiver chord"

	root := tonic!

type: aSymbol
	"set the type symbol of the receiver chord"

	type := aSymbol! !



Smalltalk.Siren defineClass: #DynamicSelectionCloud
	superclass: #{Siren.SelectionCloud}
	indexedType: #none
	private: false
	instanceVariableNames: ''
	classInstanceVariableNames: ''
	imports: ''
	category: 'Music-EventGenerators'!

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!


!Siren.DynamicSelectionCloud class methodsFor: 'examples'!

example1
	"Create a selection cloud that focuses onto a trill."
	"DynamicSelectionCloud example1"

	(DynamicSelectionCloud  dur: 4
		pitch: #( #(36 38 40 43 45) #(53 54) )
		ampl: #(80 80 120)
		voice: #(1 3 5 7)
		density: 16) eventList "edit" play "inspect"!

example2
	"Create a selection cloud that makes a transition from one triad to another"
	"DynamicSelectionCloud example2"

	(DynamicSelectionCloud dur: 4
		pitch: #( #(60 62 64) #(72 74 76) )
		ampl: #(80 80 120)
		voice: #(1 3 5 7)
		density: 12) eventList open "inspect"!

randomExample
	"Answer a dynamic selection cloud with random properties."
	"DynamicSelectionCloud randomExample"

	| rand pBase pArray1 pArray2 aArray1 score |
	rand := Random new.
	pBase := rand nextIntFrom: 42 to: 54.
	pArray1 := Array new: (rand nextIntFrom: 2 to: 4).
	1 to: pArray1 size do: 
			[:ind | pArray1 at: ind put: (rand nextIntFrom: pBase to: pBase + 12)].
	pBase := rand nextIntFrom: 60 to: 72.
	pArray2 := Array new: (rand nextIntFrom: 4 to: 8).
	1 to: pArray2 size do: 
			[:ind | pArray2 at: ind put: (rand nextIntFrom: pBase to: pBase + 12)].
	pBase := rand nextIntFrom: 40 to: 60.
	aArray1 := Array new: (rand nextIntFrom: 2 to: 6).
	1 to: aArray1 size do: 
			[:ind | aArray1 at: ind put: (rand nextIntFrom: pBase to: pBase + 50)].
	Transcript cr; show: 'DynSelCloud: ', pArray1 printString; cr; 
			show: pArray2 printString; cr; cr.
	score := (DynamicSelectionCloud  dur: 8
		pitch: (Array with: pArray1 with: pArray2)
		ampl: aArray1
		voice: (1 to: 8)
		density: (rand nextIntFrom: 5 to: 15)) eventList.
"	score inspect.
"
"	score play.
	(Delay forMilliseconds: (score duration + 1000)) wait
"
	score edit! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!


Siren.DynamicSelectionCloud comment:
'Dynamic selection clouds are described by their beginning and ending pitch and amplitude sets and interpolate between them.'!

!Siren.DynamicSelectionCloud methodsFor: 'playing'!

eventList
	"make the dynamic selection cloud's events"
	"assume that the receiver's pitch, loudness and durations are actually 2-D arrays"

	| pattern rand number length start |
	pattern := EventList new.
	rand := Random new.
	number := duration asSeconds value asFloat * density.
	length := (1000 / density) rounded.
	start := 0.
	1 to: number do:
		[ :counter |
		pattern add: (MusicEvent 
			dur: (length * 2 "+ (1000 * rand next) rounded")
			pitch: ((rand next > (counter / number)) 
					ifTrue: [ (self pitch value at: 1) atRandom: rand  ]
					ifFalse: [ (self pitch value at: 2) atRandom: rand ])
			ampl: (self loudness value atRandom: rand)
			voice: (self voice atRandom: rand))
			at: start.
		start := start + length].
	^pattern! !



Smalltalk.Siren defineClass: #ExtDynamicSelectionCloud
	superclass: #{Siren.DynamicSelectionCloud}
	indexedType: #none
	private: false
	instanceVariableNames: 'list '
	classInstanceVariableNames: ''
	imports: ''
	category: 'Music-EventGenerators'!

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!


!Siren.ExtDynamicSelectionCloud class methodsFor: 'examples'!

chordExample
	"Answer a dynamic selection cloud that plays chords from a scale."
	"ExtDynamicSelectionCloud chordExample"
	"Create cloud from a set like
		(0 -> chord) (1 -> chord) ..."
	
	| score chords list |
	chords := ((NeapolitanMinor root: N do) generateChordsPoly: 5 inOctave: 3) scrambled.
	list :=  OrderedCollection new.
	1 to: 7 do:
		[ :ind |
		ind even ifTrue: [list add: ((ind - 1) * 3 -> ((chords at: ind) collect: [ :no | no + 24]))]
			ifFalse: [list add: ((ind - 1) * 3 -> (chords at: ind))]].
	score := (self dur: 8
		pitch: list
		ampl: 60
		voice: nil
		density: 10) eventList.
	score eventsDo: [ :ev |
		ev inst: '/i1/pn'.
		ev modIndex: 2.0.
		ev ratio: 1.02.
		ev pos: 0.0].
"	score edit"
	score voice: (OSCVoice map: #pMapForCSLSimpleFM).
	score play! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!


!Siren.ExtDynamicSelectionCloud methodsFor: 'playing'!

eventList
	"make the dynamic selection cloud's events"
	"assume that the receiver's 'pitch' is a list of associations like
		(0 -> pitch-set)
		(1 -> pitch-set) ..."

	| pattern rand length start to from howMany pList |
	pattern := EventList new.
	rand := Random new.
	length := (1 / density) asFloat.
	start := 0.
	pList := self pitch value.
	to := pList at: 1.
	2 to: pList size do:
		[ :which | | set1 set2 |
		from := to.
		to := pList at: which.
		set1 := from value.
		set2 := to value.
		howMany := ((to key - from key) * density).
"		Transcript show: start printString, ' -> ', howMany printString, 
						' from ', set1 printString, ' & ', set2 printString; cr.
"		1 to: howMany do:
			[ :count |
			pattern add: (MusicEvent 
				dur: length
				pitch: ((rand next > (count / howMany)) 
					ifTrue: [set1 atRandom: rand]
					ifFalse: [set2 atRandom: rand])
				ampl: self loudness
				voice: self voice)
				at: start.
			start := start + length]].
	^pattern! !

!Siren.ExtDynamicSelectionCloud methodsFor: 'accessing'!

list: aList
	"Set the receiver's list"

	list := aList! !



Smalltalk.Siren defineClass: #Trill
	superclass: #{Siren.Roll}
	indexedType: #none
	private: false
	instanceVariableNames: ''
	classInstanceVariableNames: ''
	imports: ''
	category: 'Music-EventGenerators'!

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!


!Siren.Trill class methodsFor: 'instance creation'!

length: aNumber rhythm: aDuration note: aNote
	"return a new roll of the specified length..."

	^self new length: aNumber rhythm: aDuration note: aNote!

length: aNumber rhythm: aDuration notes: aNote
	"return a new trill of the specified length..."

	^self new length: aNumber rhythm: aDuration note: aNote! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!


Siren.Trill comment:
'A trill is like a roll, except that it can be given an eventList for repetition.'!

!Siren.Trill methodsFor: 'playing'!

eventList
	"return an eventList for me"

	| newList |
	newList := EventList newAnonymous.
	0 to: number do:
		[ :count |
			newList add: (self defaultEventClass 
					dur: noteDuration 
					pitch: (self pitch value at: ((count \\ self pitch value size) + 1)) 
					ampl: self loudness) 
				at: (delta * count) ].
	^newList! !



Smalltalk.Siren defineClass: #Score11
	superclass: #{Siren.EventGenerator}
	indexedType: #none
	private: false
	instanceVariableNames: 'start stop instrument generators postProcessors paramMap '
	classInstanceVariableNames: ''
	imports: ''
	category: 'Music-EventGenerators'!

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!


!Siren.Score11 class methodsFor: 'instance creation'!

instr: iNum from: start to: stop
	"Answer an initialize instance of Score11"

	"TimeSequenceView openOnEventList: ((Siren.Score11 instr: 1 from: 0 to: 10) 
		add: #p3 -> (#rh -> '4//8////4//'); 
		add: #p4 -> (#no -> 'c4/d/e/f/g/a/b/c5'); 
		add: #p5 -> #(1.0 1.0 5.0); 
		add: #p6 -> (#mo -> #(5 1000 2000))) 
	eventList"

	"TimeSequenceView openOnEventList: ((Siren.Score11 instr: 1 from: 0 to: 10) 
		add: #p3 -> (#rh -> '4/8*4/6*3/4/'); 
		add: #p4 -> (#no -> 'c4/d/e/f/g/a/b/c5'); 
		add: #p5 -> #(1.0 1.0 5.0); 
		add: #p6 -> (#mo -> #(5 1000 2000))) 
	eventList"

	^(self new initialize) instrument: iNum; start: start; stop: stop! !

!Siren.Score11 class methodsFor: 'examples'!

booh1
	"Score for the first section of 'Bat out of Hell' (1980-82)"
	"Score11 booh1"
	"100 timesRepeat: [Score11 booh1. (Delay forSeconds: 130) wait ]"

	| s11 score vox |
	s11 := ((Score11 instr: 1 from: 0 to: 120) 				"Score11 instrument block"
														"dur in sec"
		add: #p3 -> (#mx -> '15 .4 .5 , .05 .14 /			
						15 .1 .15 , .5 .4 /
						20 .5 .3 , .1 .13 /
						25 .2 .1 , .6 .6 /
						25 .5 .7 , .1 .06 /
						20 .12 .08 , .5 .5'); 
														"pitch in Hz"
		add: #p4 -> (#mx -> '20 2000 3000 , 2000 2100 /
						20 2050 2050 /
						30 2000 2100 , 2200 1600 /
						20 2400 2500 , 2800 2000 /
						30 2400 2400 , 2200 2100'); 
		add: (#p5 -> 0.1);								"ampl ratio"
		add: #p6 -> (#mx -> '100 1 1 , 1 1 / 20 1 1 , .8 1.2');	"gliss ratio"
		add: #p7 -> #(1.0 -1.0 1.0) ).						"L/R position"

	s11 du: 303.											"duty cycle sets evt dur to 3"
	s11 assign: #p6 to: #gliss:.
	s11 assign: #p7 to: #pos:.

	score := s11 eventList.								"generate the score and take an excerpt"
	score flushVoices.
	score := score excerptFrom: 0 to: 120.				"trim to the time alloted..."
	1 to: score events size do: 							"plug in dur & instruments 1-32"
		[ :ind | | ev |			
		ev := (score events at: ind) event.
		ev inst: ('/i', (ind - 1 \\ 16 + 41) printString, '/pn')].

	vox := OSCVoice default.								"plug in the voice and parameter map"
	vox parameterMap: OSCVoice pMapForCSLFMBell.			
	score voice: vox.	
	InputState default shiftDown ifTrue: [^score inspect].	"inspect"
	score play											"play"!

booh3
	"Score for the first section of 'Bat out of Hell' (1980-82)"
	"Score11 booh3"
	"100 timesRepeat: [Score11 booh1. (Delay forSeconds: 130) wait ]"

	| s11 score vox |
	s11 := ((Score11 instr: 1 from: 0 to: 120) 				"Score11 instrument block"
																		"dur in sec"
		add: #p3 -> (#mx -> '15 .4 .5 , .05 .14 /			
						15 .1 .15 , .5 .4 /
						20 .5 .3 , .1 .13 /
						25 .2 .1 , .6 .6 /
						25 .5 .7 , .1 .06 /
						20 .12 .08 , .5 .5'); 
																		"pitch in Hz"
		add: #p4 -> (#mx -> '20 200 300 , 200 210 /
						20 205 205 /
						30 200 210 , 220 160 /
						20 240 250 , 280 200 /
						30 240 240 , 220 210'); 
		add: (#p5 -> 0.1);												"ampl ratio"
		add: #p6 -> (#mx -> '100 1 1 , 1 1 / 20 1 1 , .8 1.2') mapTo: #gliss:;	"gliss ratio"
		add: #p7 -> #(1.0 -1.0 1.0) mapTo: #pos:;							"L/R position"
		add: #p8 -> #(1.0 6.0 20.0) mapTo: #modInd:).					"modulation index"

	s11 du: 303.											"duty cycle sets evt dur to 3"
	s11 assign: #p6 .
	s11 assign: #p7 to: #pos:.

	score := s11 eventList.								"generate the score and take an excerpt"
	score flushVoices.
	score := score excerptFrom: 0 to: 120.				"trim to the time alloted..."
	1 to: score events size do: 							"plug in dur & instruments 1-32"
		[ :ind | | ev |			
		ev := (score events at: ind) event.
		ev inst: ('/i', (ind - 1 \\ 16 + 41) printString, '/pn')].

	vox := OSCVoice default.								"plug in the voice and parameter map"
	vox parameterMap: OSCVoice pMapForCSLFMBell.			
	score voice: vox.	
	InputState default shiftDown ifTrue: [^score inspect].	"inspect"
	score play											"play"!

chorale1
	"Play the score for a Bach chorale - http://scores.ccarh.org/bach/chorale/chorales.pdf #28"
	"Score11 chorale1"

	| s11 score vox |
	s11 := ((Score11 instr: 1 from: 0 to: 9) 				"Score11 instrument block for 9 beats"
															"dur in beats"
		add: #p3 -> (#rh -> '4/////2//'); 
															"pitch as chords"
		add: #p4 -> (#no -> 'f3:a4:c:f/f4:c5:f:a6/e4:c5:g:g/eb4:c:f:a5/d4:d:f:bb5/c4:g:e5:c/f4:c:f5:a/'); 
		add: #p5 -> #(1.0 0.25 0.3);							"ampl ratio"
		add: #p6 -> 1.0 mapTo: #gliss:;						"gliss ratio"
		add: #p7 -> #(1.0 1.0 -1.0) mapTo: #pos:;				"L/R position"
		add: #p8 -> #(1.0 4.0 8.0) mapTo: #modInd:).			"modulation index"

	s11 tempo: 100.										"speed it up"
	s11 du: 303.											"duty cycle sets evt dur to 3"

	score := s11 eventList.								"generate the score"
	score flushVoices.
	1 to: score events size do: 							"plug in dur & instruments 1-32"
		[ :ind | | ev |			
		ev := (score events at: ind) event.
		ev inst: ('/i', (ind - 1 \\ 16 + 41) printString, '/pn')].
	score events removeLast.							"remove last note"

	vox := OSCVoice default.								"plug in the voice and parameter map"
	vox parameterMap: OSCVoice pMapForCSLFMBell.			
	score voice: vox.	
	InputState default shiftDown ifTrue: [^score inspect].	"inspect"
	score play											"play"!

chorale2
	"Play the score for a Bach chorale - http://scores.ccarh.org/bach/chorale/chorales.pdf #28"
	"Score11 chorale2"

	| s11 score vox |
	s11 := ((Score11 instr: 1 from: 0 to: 9) 				"Score11 instrument block for 9 beats"
														"dur in beats"
		add: #p3 -> (#rh -> '4/////2//'); 
														"pitch as chords"
		add: #p4 -> (#no -> 'f3:a4:c:f/f4:c5:f:a6/e4:c5:g:g/eb4:c:f:a5/d4:d:f:bb5/c4:g:e5:c/f4:c:f5:a/'); 
		add: #p5 -> #(1.0 0.85 0.95);						"ampl ratio"
		add: #p6 -> #(1.0 1.0 -1.0) mapTo: #pos:).			"L/R position"

	s11 tempo: 100.										"speed it up"
	s11 du: 303.											"duty cycle sets evt dur to 3"

	score := s11 eventList.								"generate the score"
	score flushVoices.
	1 to: score events size do: 							"plug in dur & instruments 1-32"
		[ :ind | | ev |			
		ev := (score events at: ind) event.
		ev inst: ('/i', (ind - 1 \\ 16 + 1) printString, '/pn')].
	score events removeLast.							"remove last note"

	vox := OSCVoice default.								"plug in the voice and parameter map"
	vox parameterMap: OSCVoice pMapForCSLString.			
	score voice: vox.	
	InputState default shiftDown ifTrue: [^score inspect].	"inspect"
	score play											"play"!

melody1
	"Play the score for a simple melody by Praetorius (Volta 201 from Terpsichore) on the CSL FM bell."
	"http://conquest.imslp.info/files/imglnks/usimg/f/f1/IMSLP464311-PMLP176492-PraetoriusTerpsichoreCantus.pdf" "p. 99"
	"Score11 melody1"

	| s11 score vox |
	s11 := ((Score11 instr: 1 from: 0 to: 32) 				"Score11 instrument block"
															"dur in sec"
		add: #p3 -> (#rh -> '4///8//4////2//1/
						4///8//4////2//1/'); 
															"pitch in Hz"
		add: #p4 -> (#no -> 'c/d/e/d/e/f/e/d/c/e/f/g/
						c/d/e/d/e/f/e/d/c/e/d/c'); 
		add: #p5 -> #(1.0 0.25 0.35);							"ampl ratio"
		add: #p6 -> 1.0 mapTo: #gliss:;						"gliss ratio"
		add: #p7 -> (#mo -> #(32 1.0 -1.0)) mapTo: #pos:;		"L/R position"
		add: #p8 -> #(1.0 4.0 10.0) mapTo: #modInd:).		"modulation index"

	s11 tempo: 280.										"speed it up"
	s11 du: 5.0.											"duty cycle < 100 scales evt dur by value"

	score := s11 eventList.								"generate the score"
	score flushVoices.
	1 to: score events size do: 							"plug in dur & instruments 1-32"
		[ :ind | | ev |			
		ev := (score events at: ind) event.
		ev inst: ('/i', (ind - 1 \\ 16 + 41) printString, '/pn')].
	score events removeLast.							"remove last note"

	vox := OSCVoice default.								"plug in the voice and parameter map"
	vox parameterMap: OSCVoice pMapForCSLFMBell.			
	score voice: vox.	
	InputState default shiftDown ifTrue: [^score inspect].	"inspect"
	score play											"play"!

melody1b
	"Play the score for a simple melody by Praetorius (Volta 201 from Terpsichore) via MIDI chan 1"
	"http://conquest.imslp.info/files/imglnks/usimg/f/f1/IMSLP464311-PMLP176492-PraetoriusTerpsichoreCantus.pdf  p. 99"
	"Score11 melody1b"

	| s11 score vox |
	s11 := ((Score11 instr: 1 from: 0 to: 32) 				"Score11 instrument block"
															"dur in sec"
		add: #p3 -> (#rh -> '4///8//4////2//1/
						4///8//4////2//1/'); 
															"pitch in Hz"
		add: #p4 -> (#no -> 'c/d/e/d/e/f/e/d/c/e/f/g/
						c/d/e/d/e/f/e/d/c/e/d/c'); 
		add: #p5 -> #(1.0 0.25 0.35);							"ampl ratio"
		add: #p6 -> 1.0 mapTo: #gliss:;						"gliss ratio"
		add: #p7 -> (#mo -> #(32 1.0 -1.0)) mapTo: #pos:;		"L/R position"
		add: #p8 -> #(1.0 4.0 10.0) mapTo: #modInd:).		"modulation index"

	s11 tempo: 280.										"speed it up"
	s11 du: 0.9.											"duty cycle < 100 scales evt dur by value"

	score := s11 eventList.								"generate the score and take an excerpt"
	score flushVoices.
	score events removeLast.							"remove last note (broken)"

	vox := MIDIVoice default.								"plug in the voice"
"	vox channel: 3."
	score voice: vox.	
	InputState default shiftDown ifTrue: [^score inspect].	"inspect"
	score play											"play"!

sleepingSword1
	"Score for the first gestures of 'SleepingSword' (WIP 2020)"
	"Score11 sleepingSword1"

"Block 1: 3 clouds"
	| s11 score1 score2 vox dur1 |
	s11 := ((Score11 instr: 1 from: 0 to: 34) 				"Score11 instrument block"
																		"dur in sec"
		add: #p3 -> (#mx -> '5 0.08 0.08 , 0.1 0.12 / 5 0.1 0.1 , 0.12 0.07 / 2.0 2.0 2.0 / 
						5 0.08 0.08 , 0.1 0.12 / 5 0.1 0.1 , 0.12 0.07 / 2.0 2.0 2.0 / 
						5 0.077 0.077 , 0.1 0.12 / 5 0.1 0.1 , 0.12 0.07 
						'); 
																		"pitch in Hz"
		add: #p4 -> (#mx -> '3 1000 1000 , 960 1000 / 3 920 920 / 4 910 920 , 860 880 / 2 1000 1000 /
						3 1100 1100 , 1000 1070 / 3 930 930 / 4 900 960 , 840 910 / 2 1000 1000 /
						3 1000 1000 , 940 1000 / 3 940 940 / 4 900 940 , 890 960
						'); 
																		"ampl ratio"
		add: #p5 -> (#mx -> '4 0.03 0.05 / 6 0.1 0.1 /	2 0.00001 0.00001 /
						4 0.04 0.05 / 6 0.1 0.15  / 2 0.00001 0.00001 /
						4 0.04 0.04 / 6 0.14 0.15'
						);	
		add: #p6 -> #(1.0 0.8 1.2) mapTo: #gliss:;							"gliss ratio"
		add: #p7 -> (#mx -> '12 -1.0 -0.3 / 
						12 -1.0 -0.1 /
						12 -0.4 0.2' 
						) mapTo: #pos:;									"L/R position"
		add: #p8 -> #(1.0 3.0 4.0) mapTo: #modInd:;						"modulation index"
		add: #p9 -> 1.0 mapTo: #wet: ).									"wet/dry"
	s11 du: 300.5.										"duty cycle sets evt dur to X - 300"

	score1 := s11 eventList.								"generate the score and take an excerpt"
	score1 := score1 excerptFrom: 0 to: 34.				"trim to the time alloted..."
	score1 events removeLast.							"remove last note"
	dur1 := score1 computeDuration.
	score1 flushVoices.									"flush voices and assign sequential instruments 41-57"
	score1 assignInstruments: [ :ind | ('/i', (ind - 1 \\ 16 + 41) printString, '/pn')].

"Block 2: spinning cloud"
	s11 := ((Score11 instr: 1 from: 0 to: 24) 				"Score11 instrument block"
																		"dur in sec"
		add: #p3 -> (#mx -> '5 0.08 0.08 , 0.08 0.09 / 5 0.08 0.08 , 0.06 0.06 / 2.0 2.0 2.0 / 
						2 0.06 0.075 , 0.06 0.06 / 8 0.06 0.06 / 2.0 2.0 2.0'
						); 
																		"pitch in Hz"
		add: #p4 -> (#mx -> '3 900 910 , 930 940 / 7 940 940 / 2 1000 1000 /
						7 940 940 / 3 940 940 , 930 940 / 2 1000 1000'
						); 
																		"ampl ratio"
		add: #p5 -> (#mx -> '6 0.1 0.15 / 4 0.15 0.15 /	2 0.0001 0.0001 /
						10 0.15 0.15  / 2 0.0001 0.0001'
						);	
		add: #p6 -> #(1.0 0.8 1.2) mapTo: #gliss:;							"gliss ratio"
		add: #p7 -> (#mo -> '7 -0.1 0.1 , -0.1 0.1 / 5 -0.1 0.1 , -0.5 0.5 / 
						7 -0.5 0.5 , 0.2 0.2 / 5 0.2 0.2'
						) mapTo: #pos:;									"L/R position"
		add: #p8 -> (#mx -> '7 3.0 4.0 , 3.0 4.0 / 5 3.0 4.0 , 2.0 3.0 / 
						7 2.0 3.0 , 2.0 2.2 / 5 2.0 2.2 , 2.0 2.0'
						) mapTo: #modInd: ).								"modulation index"
	s11 du: 300.5.										"duty cycle sets evt dur to X - 300"

	score2 := s11 eventList.								"generate the score and take an excerpt"
	score2 := score2 excerptFrom: 0 to: 24.				"trim to the time alloted..."
	score2 events removeLast.							"remove last note"
	score1 computeDuration.
	score2 flushVoices.									"flush voices and assign sequential instruments 41-57"
	score2 assignInstruments: [ :ind | ('/i', (ind - 1 \\ 16 + 41) printString, '/pn')].

"Post-processing"
	score1 applyBlock: [ :p | (PentatonicScale root: N re) nearestNoteTo: p asHz value] toProp: #pitch from: 12 to: 22.
	score1 applyBlock: [ :p | (BohlenPierceScale root: N mi) nearestNoteTo: p asHz value] toProp: #pitch from: 24 to: 34.
	score2 applyBlock: [ :p | (PentatonicScale root: N re) nearestNoteTo: p asHz value] toProp: #pitch.

	score1 addAll: score2 at: dur1 + 3.0.					"concatenate event lists"
"	score1 := score2."									"for testing"

"Play or inspect"
	vox := OSCVoice default.								"plug in the voice and parameter map"
	vox parameterMap: OSCVoice pMapForCSLFMBell.			
	score1 voice: vox.	
	InputState default shiftDown ifTrue: [^score1 inspect].	"inspect"
	score1 play											"play"! !

!Siren.Score11 class methodsFor: 'tests'!

test1
	"Open a TSV on a simple Score11 event list"
	"Score11 test1"

	TimeSequenceView openOnEventList: ((Siren.Score11 instr: 1 from: 0 to: 10) 
		add: #p3 -> (#rh -> '4//8//16////32//////'); 
		add: #p4 -> (#no -> 'c4/d/e/f/g/a/b/c5'); 
		add: #p5 -> #(1.0 1.0 5.0); 
		add: #p6 -> (#mo -> '5 1000 2000' )) 
	eventList!

test10
	"Inspect a simple Score11 event list - test rand dev"
	"Score11 test10"

	| s11 sco |
	s11 := ((Siren.Score11 instr: 1 from: 0 to: 10) 
		add: #p3 -> #(1.0  0.2  0.2); 
		add: #p4 -> 440.0;
		add: #p5 -> 0.01).
"	s11 rdev: 0.03.
"	s11 rdev: #(10 0.0 0.1).
	sco := s11 eventList.
	sco scaleDurationsBy: 0.4.
	sco open!

test11: which val: val
	"Inspect a simple Score11 event list - test duty cycle settings"
	"Score11 test11: #scale val: 0.5"
	"Score11 test11: #add val: 0.5"
	"Score11 test11: #sub val: 0.1"
	"Score11 test11: #set val: 1.0"

	| s11 sco |
	s11 := ((Siren.Score11 instr: 1 from: 0 to: 10) 
		add: #p3 -> #(1.0  0.5  0.5); 
		add: #p4 -> #(1.0  220  440);
		add: #p5 -> 0.01).
	which == #scale ifTrue: [s11 du: val].
	which == #add ifTrue: [s11 du: val + 100].
	which == #sub ifTrue: [s11 du: val + 200].
	which == #set ifTrue: [s11 du: val + 300].
	sco := s11 eventList.
	sco open!

test12
	"Inspect a simple Score11 event list - test chords"
	"Score11 test12"

	| s11 |
	s11 := ((Siren.Score11 instr: 1 from: 0 to: 5) 
		add: #p3 -> (#rh -> '8/'); 
		add: #p4 -> (#no -> 'c4:e:g:/d:fs:a/ef:g:bf/')).
	s11 eventList inspect!

test13
	"Inspect a simple Score11 event list - multi-segment sets"
	"Score11 test13"

	| s11 |
	s11 := ((Siren.Score11 instr: 1 from: 0 to: 10) 
		add: #p3 -> (#rh -> '8/'); 
		add: #p4 -> (#se -> '5 c5 e g / 5 d5 fs a4/')).
	s11 eventList inspect!

test14
	"Inspect/play a simple Score11 event list - test fm bell direct/reflected control"
	"Score11 test14"

	| s11 score1 vox |
	s11 := ((Siren.Score11 instr: 1 from: 0 to: 10) 
		add: #p3 -> (#rh -> '16/'); 						"start T"
		add: #p4 -> 440 Hz;
		add: #p5 -> 0.15;
		add: #p6 -> 1.0 mapTo: #gliss: ;
		add: #p7 -> 0.0 mapTo: #pos: ;
		add: #p8 -> 2.0 mapTo: #modInd: ;
		add: #p9 -> (#mo -> '10 0.0 1.0') mapTo: #wet: ).
	s11 du: 300.75.										"duty cycle sets evt dur to X - 300"

	score1 := s11 eventList.								"generate the score and take an excerpt"
	score1 := score1 excerptFrom: 0 to: 10.				"trim to the time alloted..."
	score1 events removeLast.							"remove last note"
	score1 computeDuration.
	score1 flushVoices.									"flush voices and assign sequential instruments 41-57"
	score1 assignInstruments: [ :ind | ('/i', (ind - 1 \\ 16 + 41) printString, '/pn')].

	vox := OSCVoice default.								"plug in the voice and parameter map"
	vox parameterMap: OSCVoice pMapForCSLFMBell.			
	score1 voice: vox.	
	InputState default shiftDown ifTrue: [^score1 inspect].	"inspect"
	score1 play											"play"!

test2
	"Open a TSV on a simple Score11 event list"
	"Score11 test2"

	TimeSequenceView openOnEventList: ((Siren.Score11 instr: 1 from: 0 to: 10) 
		add: #p3 -> (#rh -> '4/8*4/6*3/12*6/4/'); 
		add: #p4 -> (#no -> 'c4/d/e/f/g/a/b/c5'); 
		add: #p5 -> (#mo -> '10 10 100' );
		add: #p6 -> #(1.0 -1.0 1.0)) 
	eventList!

test3
	"Inspect a simple Score11 event list"
	"Score11 test3"

	 | s11 |
	s11 := ((Siren.Score11 instr: 1 from: 0 to: 10) 
		add: #p3 -> (#rh -> '4/8*4/6*3/4/'); 
		add: #p4 -> (#no -> 'c4/d/e/f/g/a/b/c5'); 
		add: #p5 -> (#mo -> '10 10 100' );
		add: #p6 -> #(1.0 -1.0 1.0);
		add: #p7 -> #(0.5 1 2  0.5 100 200);
		add: #p8 -> (#se -> '10 1 3 5 7 9' );
		add: #p9 -> (#mx -> '10 1 100' )
	).
	s11 assign: #p6 to: #position:.
	s11 assign: #p7 to: #attack:.
	s11 eventList inspect!

test4
	"Inspect a simple Score11 event list - test multi-segment moves"
	"Score11 test4"

	 | s11 |
	s11 := ((Siren.Score11 instr: 1 from: 0 to: 10) 
		add: #p3 -> (#rh -> 16); 
		add: #p4 -> (#no -> 'c4/d/e/f/g/a/b/c5' ); 
		add: #p5 -> (#mo -> '7 5 100 / 3 100 5' )
	).
	s11 tempo: #(10 60 120).
	s11 eventList inspect!

test5
	"Inspect a simple Score11 event list - test dotted values"
	"Score11 test5"

	  | s11 |	
	s11 := ((Siren.Score11 instr: 1 from: 0 to: 10) 
		add: #p3 -> (#rh -> '4/4./4../8'); 
		add: #p4 -> (#no -> 'c4/d/e/f/g/a/b/c5'); 
		add: #p5 -> (#mo -> '7 5 100 / 3 100 5' )
	).
	s11 tempo: #(10 60 120).
	s11 eventList inspect!

test6
	"Inspect a simple Score11 event list - test rests"
	"Score11 test6"

	| s11 |
	s11 := ((Siren.Score11 instr: 1 from: 0 to: 10) 
		add: #p3 -> (#rh -> '4/-4/8/-8'); 
		add: #p4 -> (#no -> 'c4/d/e/f/g/a/b/c5'); 
		add: #p5 -> (#mo -> '7 5 100 / 3 100 5' )
	).
	s11 tempo: #(10 60 120).
	s11 eventList inspect!

test7
	"Inspect a simple Score11 event list - test complex movex"
	"Score11 test7"

	| s11 |
	s11 := ((Siren.Score11 instr: 1 from: 0 to: 15) 
		add: #p3 -> (#rh -> '8/'); 
		add: #p4 -> (#mx -> '5 100 120 , 2000 2400 /
						4 2050 2060 /
						6 2000 2100 , 700 1100' )).
	s11 eventList inspect!

test7b
	"Inspect a simple Score11 event list - test complex linear move with const clauses"
	"Score11 test7b"

	| s11 |
	s11 := ((Siren.Score11 instr: 1 from: 0 to: 15) 
		add: #p3 -> (#rh -> '8/'); 
		add: #p4 -> (#mo -> '5 100 120 , 2000 2000 /
						4 2050 2060 / 3 2100 /
						3 2000 2100 , 700 1100' )).
	s11 eventList inspect!

test7c
	"Inspect a simple Score11 event list - test complex movex with const clauses"
	"Score11 test7c"

	| s11 |
	s11 := ((Siren.Score11 instr: 1 from: 0 to: 15) 
		add: #p3 -> (#rh -> '8/'); 
		add: #p4 -> (#mx -> '5 100 120 , 2000 2000 /
						4 2050 2060 / 3 2100 /
						3 2000 2100 , 700 1100' )).
	s11 eventList inspect!

test8
	"Inspect a simple Score11 event list - test complex movex"
	"Score11 test8"

	| s11 |
	s11 := ((Siren.Score11 instr: 1 from: 0 to: 8) 
		add: #p3 -> (#rh -> '32/'); 
		add: #p4 -> (#mx -> '3 140 190 , 400 440 /
						2 440 460 /
						3 400 400 , 150 250' )).
	s11 eventList inspect!

test9: which
	"Inspect a simple Score11 event list - test tempo maps"
	"Score11 test9: #accel"
	"Score11 test9: #decel"
	"Score11 test9: #both"
	"Score11 test9: #complex"

	| s11 sco |
	s11 := ((Siren.Score11 instr: 1 from: 0 to: 10) 
		add: #p3 -> #(1.0  0.15  0.15); 
		add: #p4 -> 440.0;
		add: #p5 -> 0.01).
	which == #accel ifTrue: [s11 tempo: #(10 60 180)].
	which == #decel ifTrue: [s11 tempo: #(10 180 60)].
	which == #both ifTrue: [s11 tempo: #(5 60 180  5 180 60)].
	which == #complex ifTrue: [s11 tempo: #(3 60 180  2 180 60  5 120 40)].
	sco := s11 eventList.
	sco scaleDurationsBy: 0.1.
	sco open! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!


Siren.Score11 comment:
'Score11 is a port of a Score11 instrument; see https://www.esm.rochester.edu/ears/docs/score11/index.html

Instance Variables:
	generators	<Dictionary of (prop-name -> data)>	the parameter blocks of the score11 instrument

Examples:

instrument 1 0 10;	< Instrument 1 starts at time 0 and plays for 10 beats.
	parameter 3 1; 	< Each note lasts 1 beat
end;          			< This finishes the I-block

i1 0 5;
	p3 rh 4/8*6/4;
	p4 no c4/d/e/f/g/a/b/c5;
	p5 1.0 1.0 5.0;    			< 100% of values between 1.0 and 5.0
	p6 mo 5 1000 2000;		< move from 1000 to 2000 in 5 beats
end;

Standard parameter maps -- the SCORE-11 constant parameter meanings are:

      p1 = Instrument number
      p2 = Starting time for this note (in beats) (not normally used)
      p3 = Duration for this note (in beats)
      p4 = Pitch (or frequency)
      p5 = Amplitude value (0 - 32000)

Smalltalk examples

	s11 := (Score11 instr: 1 from: 0 to: 10)
		add: #p3 -> (#rh -> ''4/8*6/4'');
		add: #p4 -> (#no -> ''c4/d/e/f/g/a/b/c5'');
		add: #p5 -> #(1.0 1.0 5.0);
		add: #p6 -> (#mo -> #(5 1000 2000)).
	s11 events

	"TimeSequenceView openOnEventList: ((Siren.Score11 instr: 1 from: 0 to: 10) 
		add: #p3 -> (#rh -> ''4//8////4//''); 
		add: #p4 -> (#no -> ''c4/d/e/f/g/a/b/c5''); 
		add: #p5 -> #(1.0 1.0 5.0); 
		add: #p6 -> (#mo -> #(5 1000 2000))) 
	eventList"

	"TimeSequenceView openOnEventList: ((Siren.Score11 instr: 1 from: 0 to: 10) 
		add: #p3 -> (#rh -> ''4/8*4/6*3/4/''); 
		add: #p4 -> (#no -> ''c4/d/e/f/g/a/b/c5''); 
		add: #p5 -> #(1.0 1.0 5.0); 
		add: #p6 -> (#mo -> #(5 1000 2000))) 
	eventList"

	[ | s11 |
	s11 := ((Siren.Score11 instr: 1 from: 0 to: 10) 
		add: #p3 -> (#rh -> ''4/8*4/6*3/4/''); 
		add: #p4 -> (#no -> ''c4/d/e/f/g/a/b/c5''); 
		add: #p5 -> (#mo -> #(10 10 100));
		add: #p6 -> #(1.0 -1.0 1.0)).
	s11 assign: #p6 to: #position:.
	s11 eventList inspect ]

Keywords requiring a parameter number:
	1. funcs
	2. move
	3. movex
	4. notes
	5. numbers
	6. rhythms
	7. rlist
	8. rnotes
	9. sets
Keywords not using a parameter number:
	1. ampfac
	2. beat
	3. duty_factor
	4. end
	5. instrument (valid as ''i'')
	6. parameter (valid as ''p'')
	7. rdeviation
	8. rrests
	9. rseed
	10. tempo
	11. tfactor
'!

!Siren.Score11 methodsFor: 'initialize-release'!

initialize
	"Initialize an instance with default state."

	generators := Dictionary new.
	paramMap := Dictionary new.
	postProcessors := Dictionary new! !

!Siren.Score11 methodsFor: 'accessing'!

add: instAssoc
	"Add a generator clause to the receiver"

	generators at: instAssoc key put: instAssoc value!

add: instAssoc mapTo: prop
	"Add a generator clause to the receiver"

	generators at: instAssoc key put: instAssoc value.
	self assign: instAssoc key to: prop!

assign: param to: property
	"Add a parameter map clause to the receiver"

	paramMap at: param put: property!

du: dutyCycle
	"Add a duty cycle post-processor to the receiver"

	postProcessors at: #duty:list: put: dutyCycle!

instrument: inst
	instrument := inst!

rdev: skew
	"Set the start-time skew of the receiver"

	postProcessors at: #rdev:list: put: skew!

start: val
	start := val!

stop: val
	stop := val!

tempo: arr
	"Set the tempo curve of the receiver"

	postProcessors at: #tempo:list: put: arr! !

!Siren.Score11 methodsFor: 'playing'!

eventList
	"Answer an eventList for the receiver."

	| eList param keys |
	eList := EventList newNamed: 'Score11-I', instrument printString.	"create new event list"
	keys := generators keys copy.
	param := generators at: #p3.					"P3 is required"
	param ifNil: [self error: 'No duration data?'].
	self writeP3: param into: eList.
	keys remove: #p3.
												"Process optional parameters"
	self populate: #p4 required: false as: #pitch: into: eList.
	keys remove: #p4 ifAbsent: [nil].

	self populate: #p5 required: false as: #loudness: into: eList.
	keys remove: #p5 ifAbsent: [nil].

	keys do: [ :aK |
		(paramMap includesKey: aK)
			ifTrue: [self populate: aK required: false as: (paramMap at: aK) into: eList]
			ifFalse: [self populate: aK required: false as: (aK, ':') asSymbol into: eList]].

	postProcessors keysAndValuesDo:
		[ :key :val |
		self perform: key with: val with: eList].

	^eList! !

!Siren.Score11 methodsFor: 'private-generators'!

populate: param required: isReq as: property into: eList
	"Execute the generator for the given key and property"
	"self populate: #p4 required: false as: #pitch into: eList.
		add: #p4 -> (#no -> 'c4/d/e/f/g/a/b/c5'); 		-- sequential scale
		add: #p5 -> (#mo -> '10 10 100' );			-- linear move
		add: #p5 -> #(1.0 1.0 5.0);					-- rand range
		add: #p7 -> #(0.5 1 2  0.5 100 200);			-- mix of ranges
		add: #p8 -> (#se -> '10 1 3 5 7 9' );			-- set
		add: #p5 -> (#mx -> '5 4 100 / 5 100 5' )		-- multi-stage exponential move
		add: #p5 -> (#mx -> '3 100 100 , 100 96' )		-- multi-stage exponential tendancy mask move
		add: #p4 -> (#nu -> '1./.5*3/.25//-.5/1.5' )		-- numerical sequences
 	 "

	| item key val |
	item := generators at: param ifAbsent: [nil].
	(isReq and: [item isNil])
		ifTrue: [self error: 'No data for ', property, '?'].
	(isReq not and: [item isNil])
		ifTrue: [^self].
	(item isImmediate or: [item respondsToArithmetic]) ifTrue:		"handle consts"
		[^self writeConst: property from: item into: eList].
	item isAssociation ifFalse:			"handle range arrays"
		[^self writeRand: property from: item into: eList].
	key := item key.
	val := item value.
	key == #no ifTrue: [^self writeNotes: property from: val into: eList].
	key == #nu ifTrue: [^self writeNumerical: property from: val into: eList].
	key == #se ifTrue: [^self writeSet: property from: val into: eList].
	key == #mo ifTrue: [^self writeMove: property from: val into: eList].
	key == #mx ifTrue: [^self writeMoveX: property from: val into: eList].
	self error: 'Unknown Score11 term'!

writeConst: property from: val into: eList
	"Parse and process the numerical keyword to generate events"
	"aScore11 add: (#p5 -> 70); "

	| evts |
	evts := eList events.
	evts do:									"event loop"
		[ :eAss | | tN |
		tN := eAss time asSec value.
		(tN >= start and: [tN <= stop]) ifTrue:
			[eAss event perform: property with: val]]!

writeMove0: property from: array into: eList
	"Parse and process the linear move keyword to generate events"
	"aScore11 add: #p5 -> (#mo -> #(10 10 100))"
	"aScore11 add: #p6 -> (#mo -> '100 1 1 , 1 1 / 20 1 1 , .9 1.1'); "

	| evts tOffset |
	evts := eList events.
	tOffset := start.
 	array size \\ 3 = 0 ifFalse:				"use a single range, ignoring the percentage value"
		[self error: 'Wrong array size in parseRanges'].
	1 to: array size by: 3 do:				"loop through the segments"
		[ :ind | | v0 v1 vDiff t0 t1 tDiff segDur |
		segDur := array at: ind.
		v0 := array at: ind + 1.
		v1 := array at: ind + 2.
		vDiff := v1 - v0.
		t0 := tOffset.
		t1 := tOffset + segDur.
		tDiff := t1 - t0.
		evts do:							"event loop"
			[ :eAss | | tn tScale val |
			tn := eAss time asSec value.
			(tn >= tOffset and: [tn <= (tOffset + segDur)]) ifTrue:
				[tScale := (tn - t0) / tDiff.
				val := (v0 + (vDiff * tScale)) asFloat.
				eAss event perform: property with: val]].
		tOffset := tOffset + segDur]!

writeMove: property from: vString into: eList
	"Parse and process the complex linear move keyword to generate events"
	"aScore11 add: #p5 -> (#mo -> '10 10 100')"
	"	add: #p6 -> (#mo -> '100 1 1 , 1 1 / 20 1 1 , .9 1.1'); 
		add: #p4 -> (#mo -> '5 200 100  ,  2000 2100  /
						4 2050 2060  / 3 2080 /
						6 2000 2100  ,  1100 1600' ) "

	| strm evts rnd t0 t1 |
	strm := self cleanStreamFrom: vString.
"	Transcript clear.
	[strm atEnd] whileFalse:						
		[Transcript show:  '_', strm next, '_   '].
	strm := ReadStream on: (tStr tokensBasedOn: $ ).
"	evts := eList events.
	rnd := Random new.
	t0 := start.
	[strm atEnd] whileFalse:								"loop through the segments"
		[ | a0 b0 a1 b1 segDur sep interp const tDiff vDiff0 vDiff1 |
		segDur := strm next asNumber.					"read first 3 vals: dur a0 b0"
		a0 := strm next asNumber.
		b0 := strm next.
		interp := false.
		const := false.
		('/,' includes: b0 first)
			ifTrue: [const := true]						"constant clause"
			ifFalse: [b0 := b0 asNumber.
				(strm atEnd) ifFalse:
					[sep := strm next.					"read comma or slash"
					('/,' includes: sep first) ifFalse: [self error: 'Malformed movex expression'].
					(sep = ',')							"comma means read 2 more tokens"
						ifTrue: [interp := true.
							a1 := strm next asNumber.
							b1 := strm next asNumber.
							(strm atEnd)					"read trailing slash"			
								ifFalse: [sep := strm next.
									((sep = '/') or: [strm atEnd]) ifFalse: [self error: 'Malformed movex expression']]]]].
														"else 3 toks = no interpolation; const range"

		t1 := t0 + segDur.		"compute start/end ratios for expon moving range"
		tDiff := t1 - t0.
		const ifFalse:
			[vDiff0 := (b0 - a0) asFloat].
		interp ifTrue:
			[vDiff0 := (a1 - a0) asFloat.	
			vDiff1 := (b1 - b0) asFloat].
"		interp
			ifTrue:[Transcript cr; show: 'Seg: ', t0 printString, ' - ', t1 printString, ' [', a0 printString, ' - ', b0 printString, '] - [ ', 
						a1 printString, ' - ', b1 printString, '] - ', vDiff0 printString, ' : ', vDiff1 printString; cr]
			ifFalse:[Transcript cr; show: 'Seg: ', t0 printString, ' - ', t1 printString, ' [', a0 printString, ' - ', b0 printString, ']'; cr].
"
		evts do:									"event loop"
			[ :eAss | | tN tScale val v0 v1 |
			tN := eAss time asSec value.
			(tN >= t0 and: [tN <= t1]) ifTrue:
				[tScale := (tN - t0) / tDiff.
				const ifTrue: [val := a0]
					ifFalse: [interp							"false means single range for segment"
						ifFalse: [val := (a0 + (vDiff0 * tScale)) asFloat]
						ifTrue: [		"true means interpolating random ranges"
							v0 := (a0 + (vDiff0 * tScale)) asFloat.
							v1 := (b0 + (vDiff1 * tScale)) asFloat.
							val := rnd nextFrom: (v0 min: v1) to: (v0 max: v1).
"							Transcript show: tN printString, ' -  [', v0 printString, ' - ', v1 printString, '] - ', val printString, ']'; cr" ]].
				eAss event perform: property with: val]].
		t0 := t0 + segDur]!

writeMoveX2: property from: vString into: eList
	"Parse and process the complex exponential move keyword to generate events"
	"aScore11 add: #p6 -> (#mx -> '100 1 1 , 1 1 / 20 1 1 , .9 1.1'); 
		add: #p4 -> (#mx -> '5 200 100  ,  2000 2100  /
						4 2050 2060  /
						6 2000 2100  ,  1100 1600' ) "
	"Toks: _5_   _200_   _100_   _,_   _2000_   _2100_   _/_   _4_   _2050_   _2060_   _/_   _6_   _2000_   _2100_   _,_   _1100_   _1600_   "

	| tStr strm evts rnd t0 t1 const |
	tStr := vString copyWithout: Character cr.
	tStr := tStr copyReplaceAll: '	' with: ' '.
	[(tStr findString: '  ' startingAt: 1) > 0] whileTrue:
		[tStr := tStr copyReplaceAll: '  ' with: ' '].
	strm := ReadStream on: (tStr tokensBasedOn: $ ).			"split on spaces"
"	Transcript clear.
	[strm atEnd] whileFalse:						
		[Transcript show:  '_', strm next, '_   '].
	strm := ReadStream on: (tStr tokensBasedOn: $ ).
"	evts := eList events.
	rnd := Random new.
	t0 := start.
	[strm atEnd] whileFalse:								"loop through the segments"
		[ | a0 b0 a1 b1 segDur sep interp tDiff vDiff0 vDiff1 |
		segDur := strm next asNumber.					"read first 3 vals: dur a0 b0"
		a0 := strm next asNumber.
		b0 := strm next.
		interp := false.
		const := false.
		('/,' includes: b0 first)
			ifTrue: [const := true]						"constant clause"
			ifFalse: [b0 := b0 asNumber.
				(strm atEnd) ifFalse:
				[sep := strm next.						"read comma or slash"
				('/,' includes: sep first) ifFalse: [self error: 'Malformed movex expression'].
				(sep = ',')								"comma means read 2 more tokens"
					ifTrue: [interp := true.
						a1 := strm next asNumber.
						b1 := strm next asNumber.
						(strm atEnd)					"read trailing slash"			
							ifFalse: [sep := strm next.
								((sep = '/') or: [strm atEnd]) ifFalse: [self error: 'Malformed movex expression']]]]].
													"3 toks = no interpolation; const range"

		t1 := t0 + segDur.								"compute start/end ratios for expon moving range"
		tDiff := t1 - t0.
		const ifFalse:
			[vDiff0 := (b0 / a0) asFloat].
		interp ifTrue:
			[vDiff0 := (a1 / a0) asFloat.	
			vDiff1 := (b1 / b0) asFloat].
"		interp
			ifTrue:[Transcript cr; show: 'Seg: ', t0 printString, ' - ', t1 printString, ' [', a0 printString, ' - ', b0 printString, '] - [ ', 
						a1 printString, ' - ', b1 printString, '] - ', vDiff0 printString, ' : ', vDiff1 printString; cr]
			ifFalse:[Transcript cr; show: 'Seg: ', t0 printString, ' - ', t1 printString, ' [', a0 printString, ' - ', b0 printString, ']'; cr].
"
		evts do:										"event loop"
			[ :eAss | | tN tScale val v0 v1 |
			tN := eAss time asSec value.
			(tN >= t0 and: [tN <= t1]) ifTrue:
				[tScale := (tN - t0) / tDiff.
				const ifTrue: [val := a0]
					ifFalse: [interp						"false means single range for segment"
						ifFalse: [val := rnd nextFrom: (a0 min: b0) to: (a0 max: b0)]
						ifTrue: [						"true means interpolating random ranges"
							v0 := a0 asFloat * (vDiff0 raisedTo: tScale).
							v1 := b0 asFloat * (vDiff1 raisedTo: tScale).
							val := rnd nextFrom: (v0 min: v1) to: (v0 max: v1)]].
				eAss event perform: property with: val]].
		t0 := t0 + segDur]!

writeMoveX: property from: array into: eList
	"Parse and process the exponential move keyword to generate events"
	"aScore11 add: #p5 -> (#mx -> #(10 1 100))
		add: #p5 -> (#mx -> #(5 4 100   5 100 5))  ) "

	| evts tOffset |
	array isString ifTrue: [^self writeMoveX2: property from: array into: eList].
										"The rest of this is for backward compatibility; you shouldn't use arrays any more"
	evts := eList events.
	tOffset := start.
	1 to: array size by: 3 do:				"loop through the segments"
		[ :ind | | v0 v1 vDiff t0 t1 tDiff segDur |
		segDur := array at: ind.
		v0 := array at: ind + 1.
		v1 := array at: ind + 2.
		vDiff := v1 / v0.
		t0 := tOffset.
		t1 := tOffset + segDur.
		tDiff := t1 - t0.
		evts do:							"event loop"
			[ :eAss | | tn tScale val |
			tn := eAss time asSec value.
			(tn >= tOffset and: [tn <= (tOffset + segDur)]) ifTrue:
				[tScale := (tn - t0) / tDiff.
				val := v0 * (vDiff raisedTo: tScale) asFloat.
				eAss event perform: property with: val]].
		tOffset := tOffset + segDur]!

writeNotes: property from: vString into: eList
	"Parse and process the sequential keywords to generate events"
	"aScore11 add: #p4 -> (#no -> 'c4/d/e/f/g/a/b/c5'); "
	"aScore11 add: #p4 -> (#no -> 'c4*3/a*5/'); "
	"aScore11 add: #p4 -> (#no -> 'c4:e:g:/d:fs:a/ef:g:bf'); "

	| strm ind evts tStr oct newEvents |
	tStr := vString copyWithout: Character cr.
	tStr := tStr copyWithout: $ .
	tStr := tStr copyWithout: $	.
	strm := ReadStream on: tStr.
	ind := 1.
	evts := eList events.
	oct := '3'.
	newEvents := EventList newAnonymous.
	[ind < eList events size] whileTrue:
		[ | eAss tn val cnt evt num | 
		eAss := evts at: ind.
		evt := eAss event.
		tn := eAss time asSec value.
		(tn >= start and: [tn <= (stop)]) ifTrue:
			[val := strm upTo: $/.					"read to next $/ "

			(val includes: $*)					"handle * expressions"
				ifTrue: [ | str2 | 
					str2 := ReadStream on: val.
					num := (str2 upTo: $*).
					cnt := str2 upToEnd asNumber.
					num last isDigit
						ifTrue: [oct := String with: num last.
							num := num allButLast: 1].
					cnt timesRepeat: 
						[evt perform: property with: (num, oct).
						ind := ind + 1.
						evt := (evts at: ind) event]]

				ifFalse: [(val includes: $:)			"handle : chord expressions"
					ifTrue: [ | str2 firstDone | 
						str2 := ReadStream on: val.
						firstDone := false.
						[str2 atEnd] whileFalse:
							[num := (str2 upTo: $:).
							num last isDigit
							ifTrue: [oct := String with: num last.
								num := num allButLast: 1].
							firstDone
								ifFalse: [evt perform: property with: (num, oct).
									firstDone := true.]
								ifTrue: [ | newEv |
									newEv := evt copy.
									newEv perform: property with: (num, oct).
									newEvents add: eAss start => newEv]]]
												"else just assign property"
						ifFalse: [val last isDigit
							ifTrue: [oct := String with: val last.
								val := val allButLast: 1].
							evt perform: property with: (val, oct)].
												"repeat as necessary"
		strm atEnd ifTrue: [strm := ReadStream on: vString]]].
		ind := ind + 1].
	newEvents isEmpty
		ifFalse: [eList addAll: newEvents].
	^self!

writeNumerical: property from: vString into: eList
	"Parse and process the numerical keyword to generate events"
	"aScore11 add: #p4 -> (#nu -> '1./.5*3/.25//-.5/1.5') "

	| strm ind evts |
	strm := ReadStream on: vString.
	ind := 1.
	evts := eList events.
	[ind < eList events size] whileTrue:
		[ | val cnt evt num | 
		evt := (evts at: ind) event.
		val := strm upTo: $/.					"read to next $/ "
		(val includes: $*)					"handle * expressions"
			ifTrue: [ | str2 | 
				str2 := ReadStream on: val.
				num := (str2 upTo: $*).
				cnt := str2 upToEnd asNumber.
				cnt timesRepeat: 
					[evt perform: property with: num.
					ind := ind + 1.
					evt := (evts at: ind) event]]
			ifFalse: [evt perform: property with: val].
		strm atEnd ifTrue: [strm := ReadStream on: vString].
		ind := ind + 1].
	^self!

writeP3: param into: eList	
	"Parse and process the RH keyword to generate events"
	"aScore11 add: #p3 -> (#rh -> '4/8*4/6*3/4/'); "

	| key val |
	param isAssociation ifFalse:		"handle non-rh arrays - rand sequences"
		[^self writeRandRH: param into: eList].
	key := param key.
	val := param value.
	key == #rh ifTrue: [^self writeP3RH: val into: eList].
	key == #mx ifTrue: [^self writeP3MX: val into: eList].

	self error: 'Unknown Score11 term'!

writeP3MX: vString into: eList
	"Parse and process the complex exponential move keyword to generate events"
	"aScore11 add: #p3 -> (#mx -> '100 1 1 , 1 1 / 20 1 1 , .9 1.1'); "

	| tStr strm rnd t0 t1 |
	tStr := vString copyWithout: Character cr.
	tStr := tStr copyReplaceAll: '	' with: ' '.
	[(tStr findString: '  ' startingAt: 1) > 0] whileTrue:
		[tStr := tStr copyReplaceAll: '  ' with: ' '].
	strm := ReadStream on: (tStr tokensBasedOn: $ ).		"split on spaces"
	rnd := Random new.
	t0 := start.

	[(t0 > stop) or: [strm atEnd]] whileFalse:						"loop through the segments"
		[ | a0 b0 a1 b1 segDur tN sep interp vDiff0 vDiff1 |
		segDur := strm next asNumber.			"read first 3 vals: dur a0 b0"
		a0 := strm next asNumber.
		b0 := strm next asNumber.
		(strm atEnd) ifFalse:
			[sep := strm next.					"read comma or slash"
			('/,' includes: sep first) ifFalse: [self error: 'Malformed movex expression'].
			(sep = ',')							"comma means read 2 more tokens"
				ifTrue: [interp := true.
					a1 := strm next asNumber.
					b1 := strm next asNumber.
					(strm atEnd)					"read trailing slash"			
						ifFalse: [sep := strm next.
							((sep = '/') or: [strm atEnd]) ifFalse: [self error: 'Malformed movex expression']]]
				ifFalse: [interp := false]].			"3 toks = no interpolation; const range"

		t1 := t0.									"compute start/end ratios for expon moving range"
		tN := t0 + segDur.
		vDiff0 := (a1 / a0) asFloat.	
		vDiff1 := (b1 / b0) asFloat.

		[t1 < tN] whileTrue:						"event loop"
			[ | val v0 v1 tScale |
			interp							"false means single rand range for segment"
				ifFalse: [val := rnd nextFrom: (a0 min: b0) to: (a0 max: b0)]
				ifTrue: [tScale := (t1 - t0) / segDur.
					v0 := a0 asFloat * (vDiff0 raisedTo: tScale).
					v1 := b0 asFloat * (vDiff1 raisedTo: tScale).
					val := rnd nextFrom: (v0 min: v1) to: (v0 max: v1)].
			eList add: (MusicEvent dur: val voice: instrument).
			t1 := t1 + val].
		t0 := t0 + segDur]!

writeP3RH: data into: eList	
	"Parse and process the RH keyword to generate events"
	"aScore11 add: #p3 -> (#rh -> '4/8//4//');"
	"aScore11 add: #p3 -> (#rh -> '4/8*4/6*3/4/');"
	"aScore11 add: #p3 -> (#rh -> #(4 8 8 4. 8));"
	"aScore11 add: #p3 -> (#rh -> #(4 8 -8 4 -4));"
	"aScore11 add: #p3 -> (#rh -> 16);"

	| strm num cnt tim val tStr |
	tim := start.
	data respondsToArithmetic ifTrue:			"rh number"
		[num := 4.0 / data.
		[tim > stop] whileFalse:
			[eList add: (MusicEvent dur: num voice: instrument).
			tim := tim + num].
		^self].
	data isString ifFalse:							"rh string"
		[self error: 'Mal-formed duration data?'].
	tStr := data copyWithout: Character cr.
	tStr := tStr copyWithout: $ .
	tStr := tStr copyWithout: $	.
	strm := ReadStream on: tStr.
	cnt := 0.
	[tim > stop] whileFalse:
		[val := strm upTo: $/.						"read to next $/ "
		(val includes: $*)						"handle * expressions"
			ifTrue: [ | str2 | 
				str2 := ReadStream on: val.
				num := 1.0 / (str2 upTo: $*) asNumber.
				cnt := str2 upToEnd asNumber.
				cnt timesRepeat: 
					[eList add: (MusicEvent dur: num voice: instrument).
					tim := tim + num]]	
			ifFalse: [(val includes: $.)				"handle dotted rhythmic values"
				ifTrue: [ | va2 nDots delD |
					va2 := val copyWithout: $. .
					nDots := val size - va2 size.
					num := 4.0 / val asNumber.
					delD := num / 2.0.
					nDots timesRepeat:
						[num := num + delD.
						delD := delD + (delD / 2.0)].
					eList add: (MusicEvent dur: num voice: instrument).
					tim := tim + num.
					strm atEnd ifTrue: [strm := ReadStream on: data]]
				ifFalse: [(val includes: $-)		"handle rests"
					ifTrue: [val isEmpty ifFalse: [num := -4.0 / val asNumber].
						eList add: (RestEvent dur: num).
						tim := tim + num.
						strm atEnd ifTrue: [strm := ReadStream on: data]]
					ifFalse: [val isEmpty ifFalse: [num := 4.0 / val asNumber].
						eList add: (MusicEvent dur: num voice: instrument).
						tim := tim + num.
						strm atEnd ifTrue: [strm := ReadStream on: data]]]]]!

writeRand: property from: array into: eList
	"Parse and process the random keyword to generate events"
	"aScore11 add: #p3 -> #(1.0 1.0 5.0);"
	"aScore11 add: #p3 -> #(0.5 1.0 2.0  0.5 0.25 0.5);"

	| rnd ranges |
 	rnd := Random new.
	array size == 3 ifTrue:			"use a single range, ignoring the percentage value"
		[eList eventsDo:
			[ :evt | 
			evt perform: property with: (rnd nextFrom: (array at: 2) to: (array last))].
		^self].
	ranges := self parseRanges: array.
	eList eventsDo:
		[ :evt | | val rng |
		val := rnd next.				"get a rand 0-1 to select which range we'll use"
		ranges do: [ :ass |
			ass key < val ifTrue: [rng := ass value]].
		evt perform: property with: (rnd nextFrom: rng first to: rng stop)].!

writeRandRH: array into: eList	
	"Parse and process the random RH keyword to generate events"
	"aScore11 add: #p3 -> #(1.0 1.0 5.0);"
	"aScore11 add: #p3 -> #(0.5 1.0 2.0  0.5 0.25 0.5);"

	| tim rnd |
	tim := start.
 	rnd := Random new.
	array size == 3 ifTrue:			"use a single range, ignoring the percentage value"
		[ | rng |
		rng := (array at: 2) to: (array last).
		[tim <= stop] whileTrue:
			[ | dur |
			rng size = 0
				ifTrue: [dur := rng first]
				ifFalse: [dur := rng atRandom: rnd].
			eList add: (MusicEvent dur: dur voice: instrument).
			tim := tim + dur].
		^self].!

writeSequential: property from: vString into: eList
	"Parse and process the sequential keywords to generate events"
	"aScore11 add: #p4 -> (#no -> 'c4/d/e/f/g/a/b/c5'); "

	| strm ind evts tStr |
	tStr := vString copyWithout: Character cr.
	tStr := tStr copyWithout: $ .
	tStr := tStr copyWithout: $	.
	strm := ReadStream on: tStr.
	ind := 1.
	evts := eList events.
	[ind < eList events size] whileTrue:
		[ | eAss tn val cnt evt num | 
		eAss := evts at: ind.
		evt := eAss event.
		tn := eAss time asSec value.
		(tn >= start and: [tn <= (stop)]) ifTrue:
			[val := strm upTo: $/.					"read to next $/ "
			(val includes: $*)					"handle * expressions"
				ifTrue: [ | str2 | 
					str2 := ReadStream on: val.
					num := (str2 upTo: $*).
					cnt := str2 upToEnd asNumber.
					cnt timesRepeat: 
						[evt perform: property with: num.
						ind := ind + 1.
						evt := (evts at: ind) event]]
				ifFalse: [evt perform: property with: val].
		strm atEnd ifTrue: [strm := ReadStream on: vString]].
		ind := ind + 1].
	^self!

writeSet: property from: vString into: eList
	"Parse and process the 'set' keyword to generate events"
	"aScore11 add: #p4 -> (#se -> '20 .1 .2 .3 .4'); "
	"	add: #p8 -> (#se -> '5 c5 e g / 5 d5 fs a4'/);"

	| toks rnd segDur item strm segs t0 |
	strm := self cleanStreamFrom: vString.
	segs := OrderedCollection new.
	toks := OrderedCollection new.
	[strm atEnd] whileFalse:					"collect the segments"			
		[segDur := strm next asNumber.
		item := strm next.
		[(item = '/') or: [strm atEnd]] whileFalse:
			[toks add: item.
			item := strm next].
		segs addLast: segDur -> toks.		"start-time -> data-set"
		toks := OrderedCollection new].	
	rnd := Random new.
	t0 := 0.
	1 to: segs size do:						"step through the segments"
		[ :ind | | tN |
		tN := t0 + (segs at: ind) key.
		toks := (segs at: ind) value.
		eList do: 
			[ :eAss | | evt tX |
			evt := eAss event.
			tX := eAss time asSec value.
			(tX >= t0 and: [tX <= tN]) ifTrue:
				[ | val |
				val := toks atRandom: rnd.
				evt perform: property with: val.
"				Transcript show: tX printString, ' - ', val printString; cr"].
		t0 := tN]]! !

!Siren.Score11 methodsFor: 'private-post-processors'!

duty: dutyCycle list: eList
	"Post-process the event list's durations."
	"000 - 099		multiply dur by dutyCycle
	  100 - 199		add dutyCycle - 100 to dur
	 200 - 299		subtract dutyCycle - 200 from dur
	 300 - 399		set dur to dutyCycle - 300
	 400 - 399		set dur to dutyCycle - 400 cycles (dur = (1/Hz) * (dutycycle - 400)"

	| dec val |
	dec := (dutyCycle / 100) truncated.
	val := dutyCycle \\ 100.
	(dec == 0) ifTrue: 			"000 - 099	multiply dur by dutyCycle"
		[eList scaleDurationsBy: val.
		^self].
	(dec == 1) ifTrue: 			"100 - 199	add dutyCycle - 100 to dur"
		[eList eventsDo: [ :ev | ev duration: (ev duration + (ev duration species value: val))].
		eList recomputeDuration.
		^self].
	(dec == 2) ifTrue: 			"200 - 299	subtract dutyCycle - 200 from dur"
		[eList eventsDo: [ :ev | ev duration: (ev duration - (ev duration species value: val))].
		eList recomputeDuration.
		^self].
	(dec == 3) ifTrue: 			"300 - 399	set dur to dutyCycle - 300"
		[eList eventsDo: [ :ev | ev duration: (ev duration species value: val)].
		eList recomputeDuration.
		^self].
	(dec >= 4) ifTrue: 			"400 - 399	set dur to dutyCycle - 400 cycles (dur = (1/Hz) * (dutycycle - 400)"
		[eList eventsDo: 
			[ :ev |  | frq |
			frq := ev pitch asHz.
			ev duration: ((1.0 / frq) * (dutyCycle - 400) sec)].
		eList recomputeDuration].!

rdev: rData list: eList
	"Post-process the event list's start-times with the random skew."
	"s11 rdev: 0.02."
	"s11 rdev: #(10 0.0 0.1)."

	| rand |
 	rand := Random new.
	rData respondsToArithmetic ifTrue:
		[eList do: 
			[ :evAss | | tX |
			tX := evAss key asSec value.
			tX := tX + ((rand next * 2 - 1.0) * rData).
			evAss start: tX].
		eList recomputeDuration.
		^self].
	rData size \\ 3 = 0 ifTrue:
		[ | dur rn0 rnN vDiff |
		dur := rData at: 1.
		rn0 := rData at: 2.
		rnN := rData at: 3.
		vDiff := rnN - rn0.
		eList events do:
			[ :evAss | | tX tScale val |
			tX := evAss key asSec value.
			tScale := tX / dur.
			val := (rn0 + (vDiff * tScale)) asFloat.
			tX := tX + ((rand next * 2 - 1.0) * val).
			evAss start: tX].
		eList recomputeDuration.
		^self]!

tempo: tData list: eList
	"Post-process the event list's start-times with the tempo curve."
	"s11 tempo: #(10 60 120)."
	"s11 tempo: 120."

	| dur t0 tN |
	tData respondsToArithmetic
		ifTrue: [ | val |
			val := 60.0 / tData.
			eList scaleStartTimesBy: val.
			eList scaleDurationsBy: val.
			eList recomputeDuration.
			^self].
	tData isString ifFalse:
		[tData size  \\ 3 = 0 ifTrue:
			[ | rOff mOff |
			rOff := 0.			"real offset"
			mOff := 0.			"mapped offset"
			1 to: tData size by: 3 do:
				[ :ind | | last |
				dur := tData at: ind.
				t0 := 60.0 / (tData at: ind + 1).
				tN := 60.0 / (tData at: ind + 2).
				last := self tempoFrom: t0 to: tN in: dur list: eList startingAt: rOff mappedTo: mOff.
				rOff := rOff + dur.
				mOff := last].
			eList recomputeDuration.
			^self]]!

tempoFrom: t0 to: tN in: dur list: eList startingAt: eStart mappedTo: mOff
	"Post-process the event list's start-times with the tempo curve."
	"s11 tempo: #(10 60 120)."

	| tDiff prevS prevO eEnd |
"	Transcript cr; show: t0 printString, ' to ', tN printString, ' in ', dur printString, 
			' startingAt ', eStart printString, ' mappedTo ', mOff printString; cr."
	tDiff := tN - t0.
	prevO := eStart.				"original start of previous note"
	prevS := mOff.				"scaled start of previous note"
	eEnd := eStart + dur.
	eList do: 
		[ :evAss | | tX val sca ioi |
		tX := evAss key asSec value.
		(tX >= eStart and: [tX <= eEnd]) ifTrue:
			[ioi := tX - prevO.
			sca := t0 + (tDiff * tX / dur).
			val := prevS + (ioi * sca).
			evAss start: val. 
"			Transcript show: tX printString, ' - ', sca printString, ' - ', val printString; cr."
			prevS := val.
			prevO := tX.
			evAss start: val]].
	^prevS! !

!Siren.Score11 methodsFor: 'private'!

cleanStreamFrom: vString
	"Clean up the string and answer a stream on it - leave spaces."

	| tStr |
	tStr := vString copyWithout: Character cr.
	tStr := tStr copyReplaceAll: '/' with: ' / '.
	tStr := tStr copyReplaceAll: '	' with: ' '.			"tab"
	[(tStr findString: '  ' startingAt: 1) > 0] whileTrue:
		[tStr := tStr copyReplaceAll: '  ' with: ' '].
	(tStr last == $ )
		ifTrue: [tStr := tStr copyFrom: 1 to: tStr size - 1].
	^(ReadStream on: (tStr tokensBasedOn: $ ))!

compactStreamFrom: vString
	"Clean up the string and answer a stream on it."

	| tStr |
	tStr := vString copyWithout: Character cr.
	tStr := tStr copyWithout: $ .
	tStr := tStr copyWithout: $	.
	^(ReadStream on: tStr)!

parseRanges: array
	"Parse  random lists into a list of interval associations"
	"aScore11 add: #p3 -> #(0.5 1.0 2.0  0.5 0.25 0.5);"

	| ranges sum scale |
 	array size \\ 3 = 0 ifFalse:				"use a single range, ignoring the percentage value"
		[self error: 'Wrong array size in parseRanges'].
	ranges := OrderedCollection new.
	sum := 0.0.
	1 to: array size by: 3 do:
		[ :cnt | | rat lo hi |
		rat := array at: cnt.
		lo := array at: cnt + 1.
		hi := array at: cnt + 2.
		ranges addLast: (rat -> (lo to: hi)).
		sum := sum + rat].
	scale := 1.0 / sum.					"scale ranges"
	sum := 0.0. "ranges first key * scale."
	ranges do:
		[ :ass | | rat |
		rat := ass key.
		ass key: sum.
		sum := sum + (rat * scale)].
	^ranges! !



Smalltalk.Siren defineClass: #Arpeggio
	superclass: #{Siren.Chord}
	indexedType: #none
	private: false
	instanceVariableNames: 'delay '
	classInstanceVariableNames: ''
	imports: ''
	category: 'Music-EventGenerators'!

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!


!Siren.Arpeggio class methodsFor: 'instance creation'!

on: aChordOrList delay: aDelay
	"create an Arpeggio on the given chord or event list"

	| me |
	me := self newAnonymous.
	me events: aChordOrList events copy.
	me delay: aDelay.
	^me! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!


Siren.Arpeggio comment:
'Arpeggii can be created on Chords or other event lists and can step through their events (assumed to be simultaneous at the start) with the given delay time.

Instance variables:
	delay <Duration or Number> the delay between the onsets of my events'!

!Siren.Arpeggio methodsFor: 'accessing'!

delay: aValue
	"set the delay between the onset of my notes"

	delay := aValue.
	self setDelays.! !

!Siren.Arpeggio methodsFor: 'playing'!

edit
	"edit me"

"	HauerSteffensView openWith8ButtonsAndHAndVScrollingOn: self"!

eventList
	"return my event list"

	^events!

play
	"don't expand me"

	^self playAt: 0! !

!Siren.Arpeggio methodsFor: 'private'!

setDelays
	"set the start times of my notes"

	| counter |
	counter := 0.
	events do:
		[ :anAss |
		anAss key: (MSecondDuration value: (anAss key value + (counter * delay))).
		counter := counter + 1]! !
