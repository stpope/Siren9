

Smalltalk.Siren defineClass: #Scale
	superclass: #{Core.Object}
	indexedType: #none
	private: false
	instanceVariableNames: 'root notes '
	classInstanceVariableNames: ''
	imports: ''
	category: 'Music-PitchScales'!

Siren.Scale defineSharedVariable: #AllNotes
	private: false
	constant: false
	category: 'As yet unclassified'
	initializer: nil!

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!


!Siren.Scale class methodsFor: 'examples'!

example
"
	N la flat majorScale notes ->  #(Lab Sib Do Reb Mib Fa Sol )
	N do harmonicMinorScale notes ->  #(Do Re Mib Fa Sol Lab Si )
	
	N re majorScale numberOfSharps -> 2

	N do majorScale generateChordsPoly: 4 ->
OrderedCollection ([Do #maj7 ] [Re #min 7 ] [Mi #min 7 ] [Fa #maj7 ] [Sol 7 ] [La #min 7 ] [Si #halfDim7 ] ) 

	N do majorScale generateChordsPoly: 6
-> OrderedCollection (Do #maj7 9 11  Re #min 7 9 11  Mi #min 7 #dim9 11  Fa #maj7 9 #aug11  Sol 7 9 11  La #min 7 9 11  Si #min #dim5 7 #dim9 11  )

	N do majorScale generateChordsPoly: 7
-> OrderedCollection (Do #maj7 9 11 13  Re #min 7 9 11 13  Mi #min 7 #dim9 11 #dim13  Fa #maj7 9 #aug11 13  Sol 7 9 11 13  La #min 7 9 11 #dim13  Si #min #dim5 7 #dim9 11 #dim13  )

N re  HarmonicMinorScale generateChordsPoly: 3

	N do majorScale degreDeAccord: (FPChord new fromString: 'Fa min 7')
-> 4
"! !

!Siren.Scale class methodsFor: 'Paleo class initialize'!

initialize
	AllNotes := Dictionary new! !

!Siren.Scale class methodsFor: 'creation'!

askScale
	"self askScale"

	| scales scaleType pitch |
	scales := Scale subclasses asArray.
	scaleType := (Menu labelArray: (scales collect: [:s | s printString])) startUp.
	scaleType = 0 ifTrue: [^nil].
	pitch := N noteNamed: (Dialog request: 'note' initialAnswer: 'Do').
	^(scales at: scaleType)
		root: pitch!

root: aNote 
	| g |
	g := self new.
	g root: aNote; computeNotes.
	"g isValid ifFalse: [self warn: 'invalid scale']."
	^g!

standardScales
	^Array
		with: MajorScale
		with: HarmonicMinorScale
		with: MelodicMinorScale!

warn: s 
	Transcript show: s; cr! !

!Siren.Scale class methodsFor: 'interval list'!

intervalList
	^self subclassResponsibility! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!


!Siren.Scale methodsFor: 'degres'!

degreDeAccord: unAccord
	^(root intervalBetween: unAccord root) type!

degreeOfNote: aNote 
	^(root intervalBetween: aNote) type! !

!Siren.Scale methodsFor: 'accessing'!

allNotes
	^ AllNotes at: self ifAbsent: [AllNotes at: self put: (self class allIntervals collect: [:s | root perform: s])]!

noteAfter: aNote
	"aNote can be a pitchClass, a pitch (ODNote) or even a PlayableNote.
	coputation takes into accont circularity and is approximative  wrt aNote
	alterations"
	"N B majorScale noteAfter: ( N B flat  @ 3)"
	| targetIndex answer |
	targetIndex := notes indexOf: (self closestPitchClassTo: aNote pitchClass).
	targetIndex = notes size
		ifTrue: [answer := notes first]
		ifFalse: [answer := notes at: targetIndex + 1].
	(aNote isKindOf: PitchClass) 
		ifTrue: [^answer].
	"octave computation"
	(aNote pitchClass natural pitchEqual: N B)	
		ifTrue: [^answer octave: aNote oct +1]
		ifFalse: [^answer octave: aNote oct]!

noteBefore: aNote
	"aNote can be a pitchClass, a pitch (ODNote) or even a PlayableNote.
	coputation takes into accont circularity and is approximative  wrt aNote
	alterations"
	"N C majorScale noteBefore: ( N C  @ 3)"
	| targetIndex answer |
	targetIndex := notes indexOf: (self closestPitchClassTo: aNote pitchClass).
	targetIndex = 1
		ifTrue: [answer := notes last]
		ifFalse: [answer := notes at: targetIndex - 1].
	(aNote isKindOf: PitchClass) 
		ifTrue: [^answer].
	"octave computation"
	(aNote pitchClass natural pitchEqual: N C)	
		ifTrue: [^answer octave: aNote oct - 1]
		ifFalse: [^answer octave: aNote oct]!

notes
	^notes!

root
	^root!

root: value
	root := value! !

!Siren.Scale methodsFor: 'testing'!

= g  
	^root = g root and: [self class == g class]!

containsAllOfTheseNotes: listOfNotes
	listOfNotes do: 
		[:each | 
		(self containsNote: each) 
			ifFalse: [^false]].
	^true!

containsNote: n
	^(self notes detect: [:each | each pitchClass = n pitchClass]
			ifNone: [nil]) notNil!

isMajor
	| tonic int |
	tonic := notes first.
	notes do: 
			[:each | 
			int := tonic intervalBetween: each.
			int type = 3
				ifTrue: [^int isA: #majorThird]].
	^false!

isMinor
	| tonic int |
	tonic := notes first.
	notes do: 
			[:each | 
			int := tonic intervalBetween: each.
			int type = 3
				ifTrue: [^int isA: #minorThird]].
	^false!

isValid
	^(notes detect: [:n | (n isKindOf: PitchClassDoubleSharp)
			or: [n isKindOf: PitchClassDoubleFlat]]
		ifNone: [nil]) == nil! !

!Siren.Scale methodsFor: 'comparing'!

hash

	^root hash + self class hash! !

!Siren.Scale methodsFor: 'scale tone chords'!

arpeggioFrom: startNote poly: n interval: int 
	"yields n notes from startNote by intervals of int"

	| arp x |
	arp := OrderedCollection with: startNote.
	x := startNote.
	(1 to: n - 1)
		do: [:i | arp add: (x := self following: x by: int)].
	^arp!

chordFromNotes: l
	^PitchClassChord newFromNotes: l!

following: noteDepart by: x 
	"rend la x ieme note a partir de noteDepart dans mes notes"

	| i |
	i := self indexDe: noteDepart.
	^notes at: (((x + i - 2) \\ 7) + 1)!

generateChordsPoly: n 
	"generate the list of 7 scale tone chords from my notes with polyphony n"

	| o startNote theNotes |
	o := Array new: 7.
	startNote := self root.
	(1 to: 7)
		do: 
			[:i | 
			theNotes := self arpeggioFrom: startNote poly: n interval: 3.
			startNote := self following: startNote by: 2.
			o at: i put: (self chordFromNotes: theNotes copy)].
	^o!

generateChordsPoly: n inOctave: oct
	"generate the list of 7 scale tone chords from my notes with polyphony n"
	"(HungarianMinor root: N do) generateChordsPoly: 5 inOctave: 3"

	| o p startNote theNotes |
	o := Array new: 7.
	startNote := self root.
	(1 to: 7) do: 
		[ :i | 
		theNotes := self arpeggioFrom: startNote poly: n interval: 3.
		startNote := self following: startNote by: 2.
		o at: i put: (self chordFromNotes: theNotes copy)].
	p := Array new: 7.
	(1 to: 7) do: 
		[ :i | 
		p at: i put: ((o at: i) notes collect: [ :each | (each octave: oct) semiToneCount])].
	^p!

indexDe: uneNote 
	^notes indexOf: uneNote!

scaleToneTriads
	"N C majorScale scaleToneTriads 
	(NeapolitanMinor root: N D ) scaleToneTriads"

	^self generateChordsPoly: 3! !

!Siren.Scale methodsFor: 'octave-dependent notes'!

asPitchesInOctave: o
	^self notes collect: [ :n| (n octave: o) semiToneCount]!

ascendingFromOctave: o 
	"first note is in octave o. others follow (and may shift octave!!)"

	| oc |
	oc := o.
	^self notes
		collect: 
			[:n | 
			n natural = PitchClass C ifTrue: [oc := oc + 1].
			n octave: oc]!

closestPitchClassTo: aPc 
	self notes do: [:pc | pc natural == aPc natural ifTrue: [^pc]].
	self error: 'impossible'!

decendingFromOctave: o 
	"first note is in octave o. others follow (and may shift octave!!)"

	| oc |
	oc := o.
	^self reverseNotes
		collect: 
			[:n | 
			n natural = PitchClass B ifTrue: [oc := oc - 1].
			n octave: oc]!

diatonicNotesFrom: dep to: arr 
	"assumes a and b belong to the scale.
	N re  minorScale diatonicNotesFrom: (N do sharp  octave: 3) to: (N re octave: 4)"

	|  currentNote currentPc currentOctave res a b pc |

	dep <= arr ifTrue: [a:= dep. b := arr] ifFalse: [a:= arr. b := dep].
	pc := self closestPitchClassTo: a pitchClass.
	currentNote := pc octave: a oct.
	currentPc := self notes indexOf: pc.
	currentOctave := a oct.
	res := OrderedCollection new.
	[currentNote <= b] whileTrue: 
			[res add: currentNote.
			currentNote pitchClass natural == N si
				ifTrue: [currentOctave := currentOctave + 1].
			currentPc = 7 ifTrue: [currentPc := 1] ifFalse: [currentPc := currentPc + 1].
			currentNote := (notes at: currentPc) octave: currentOctave].
	^res!

octave: o
	^self notes collect: [:n| n octave: o]! !

!Siren.Scale methodsFor: 'computing notes'!

computeNotes
	"intervalList depends on the type of the scale. It is redefined in each 
	subclass of Scale"

	notes := self class intervalList collect: [:s | root perform: s]!

intervalList
	"yields the list of interval. Redefined in subclasses"

	^self class intervalList!

leadingNote
	"N la minorScale leadingNote"

	^self notes last!

reverseNotes
	"first is root, others following descending order"

	^(notes copyFrom: 2 to: notes size) asOrderedCollection reverse
			addFirst: notes first; yourself!

tonic
	"N re minorScale tonic"

	^self notes first! !

!Siren.Scale methodsFor: 'querying'!

flatNotesInSignature
	"Warning: doubles sharps are not sharps!!"

	^(notes select: [:n | n isFlat])!

numberOfFlats
	"Attention les doubles bemols ne sont pas des bemols!!"

	^(notes select: [:n | n isFlat]) size!

numberOfSharps
	"Attention les doubles dieses ne sont pas des dieses!!"

	^(notes select: [:n | n isSharp]) size!

sharpNotesInSignature
	"Warning: doubles sharps are not sharps!!"

	^(notes select: [:n | n isSharp])! !

!Siren.Scale methodsFor: 'printing'!

printOn: s 
	| str |
	str := root printString , (self isMajor ifTrue: ['M'] ifFalse: ['m']).
	str size = 2 ifTrue: [str := str , ' '].
	s nextPutAll: str!

storeOn: s
	s nextPutAll: '(', self class name asString.
	s nextPutAll: ' root: ', root storeString.
	s nextPut: $).! !

!Siren.Scale methodsFor: 'Paleo'!

costForPitch: n
	self subclassResponsibility!

enharmonicScale
	^ self subclassResponsibility!

pitchClassFor: p
	"N C majorScale pitchClassFor: N A"
	| count |
	count := root numberOfSemiTonesBetween: p.
	count = 0 ifTrue: [^ root].
	^ self allNotes at: (1 + (count \\ 12))! !

!Siren.Scale methodsFor: 'transpose'!

transposeOf: anInterval 
	^self class root: (root transposeOf: anInterval)! !



Smalltalk.Siren defineClass: #NeapolitanMinor
	superclass: #{Siren.Scale}
	indexedType: #none
	private: false
	instanceVariableNames: ''
	classInstanceVariableNames: ''
	imports: ''
	category: 'Music-PitchScales'!

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!


!Siren.NeapolitanMinor class methodsFor: 'interval list'!

intervalList
	"tire de McLaughlin et le Mahavishnu Orchestra"

	^#(#unison #minorSecond #minorThird #perfectFourth #perfectFifth #minorSixth #majorSeventh )! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!


Siren.NeapolitanMinor comment:
'<historical>'!



Smalltalk.Siren defineClass: #ChromaticScale
	superclass: #{Siren.Scale}
	indexedType: #none
	private: false
	instanceVariableNames: ''
	classInstanceVariableNames: ''
	imports: ''
	category: 'Music-PitchScales'!

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!


!Siren.ChromaticScale class methodsFor: 'interval list'!

intervalList

	^#(#unison #augmentedUnison #majorSecond #minorThird #majorThird #perfectFourth #augmentedFourth #perfectFifth #minorSixth #majorSixth #minorSeventh #majorSeventh )! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!




Smalltalk.Siren defineClass: #NeapolitanMajor
	superclass: #{Siren.Scale}
	indexedType: #none
	private: false
	instanceVariableNames: ''
	classInstanceVariableNames: ''
	imports: ''
	category: 'Music-PitchScales'!

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!


!Siren.NeapolitanMajor class methodsFor: 'interval list'!

intervalList
	"tire de McLaughlin et le Mahavishnu Orchestra"

	^#(#unison #minorSecond #minorThird #perfectFourth #perfectFifth #majorSixth #majorSeventh )! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!




Smalltalk.Siren defineClass: #PseudoMinorScale
	superclass: #{Siren.Scale}
	indexedType: #none
	private: false
	instanceVariableNames: ''
	classInstanceVariableNames: ''
	imports: ''
	category: 'Music-PitchScales'!

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!


!Siren.PseudoMinorScale class methodsFor: 'interval list'!

intervalList
	^#(#unison #second #minorThird #perfectFourth #perfectFifth #majorSixth #majorSeventh )! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!




Smalltalk.Siren defineClass: #MajorScale
	superclass: #{Siren.Scale}
	indexedType: #none
	private: false
	instanceVariableNames: ''
	classInstanceVariableNames: ''
	imports: ''
	category: 'Music-PitchScales'!

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!


!Siren.MajorScale class methodsFor: 'interval list'!

allIntervals
	^#(#unison #augmentedUnison #second #augmentedSecond #majorThird #perfectFourth augmentedFourth #perfectFifth #augmentedFifth #majorSixth #minorSeventh #majorSeventh )!

intervalList
	^#(#unison #second #majorThird #perfectFourth #perfectFifth #majorSixth #majorSeventh )! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!


!Siren.MajorScale methodsFor: 'Paleo'!

costForPitch: n
	(notes includes: n) ifTrue: [ ^ 0].
	(self allNotes includes: n) ifTrue: [^ 1].
	^ 2!

enharmonicScale
	root = N C sharp ifTrue: [^ N D flat majorScale].
	root = N D sharp ifTrue: [^ N E flat majorScale].
	root = N F sharp ifTrue: [^ N G flat majorScale].
	root = N G sharp ifTrue: [^ N A flat majorScale].
	root = N A sharp ifTrue: [^ N B flat majorScale].
	root = N D flat ifTrue: [^ N C sharp majorScale].
	root = N E flat ifTrue: [^ N D sharp majorScale].
	root = N G flat ifTrue: [^ N F sharp majorScale].
	root = N A flat ifTrue: [^ N G sharp majorScale].
	root = N B flat ifTrue: [^ N A sharp majorScale].
	^ nil! !



Smalltalk.Siren defineClass: #DoubleHarmonic
	superclass: #{Siren.Scale}
	indexedType: #none
	private: false
	instanceVariableNames: ''
	classInstanceVariableNames: ''
	imports: ''
	category: 'Music-PitchScales'!

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!


!Siren.DoubleHarmonic class methodsFor: 'interval list'!

intervalList
	"tire de McLaughlin et le Mahavishnu Orchestra"

	^#(#unison #minorSecond #majorThird #perfectFourth #perfectFifth #minorSixth #majorSeventh )! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!




Smalltalk.Siren defineClass: #HarmonicMinorScale
	superclass: #{Siren.Scale}
	indexedType: #none
	private: false
	instanceVariableNames: ''
	classInstanceVariableNames: ''
	imports: ''
	category: 'Music-PitchScales'!

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!


!Siren.HarmonicMinorScale class methodsFor: 'interval list'!

allIntervals
	^#(#unison #diminishedSecond #second #minorThird #majorThird #perfectFourth augmentedFourth #perfectFifth #minorSixth #majorSixth #minorSeventh #majorSeventh )!

intervalList
	^#(#unison #second #minorThird #perfectFourth #perfectFifth #minorSixth #majorSeventh )! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!


!Siren.HarmonicMinorScale methodsFor: 'Paleo'!

costForPitch: n
	(notes includes: n) ifTrue: [ ^ 0].
	root majorSeventh = n ifTrue: [^ 0].
	root majorSixth = n ifTrue: [^ 0].
	(self allNotes includes: n) ifTrue: [^ 1].
	^ 2!

enharmonicScale
	root = N C sharp ifTrue: [^ N D flat harmonicMinorScale].
	root = N D sharp ifTrue: [^ N E flat harmonicMinorScale].
	root = N F sharp ifTrue: [^ N G flat harmonicMinorScale].
	root = N G sharp ifTrue: [^ N A flat harmonicMinorScale].
	root = N A sharp ifTrue: [^ N B flat harmonicMinorScale].
	root = N D flat ifTrue: [^ N C sharp harmonicMinorScale].
	root = N E flat ifTrue: [^ N D sharp harmonicMinorScale].
	root = N G flat ifTrue: [^ N F sharp harmonicMinorScale].
	root = N A flat ifTrue: [^ N G sharp harmonicMinorScale].
	root = N B flat ifTrue: [^ N A sharp harmonicMinorScale].
	^ nil! !



Smalltalk.Siren defineClass: #MelodicMinorScale
	superclass: #{Siren.Scale}
	indexedType: #none
	private: false
	instanceVariableNames: ''
	classInstanceVariableNames: ''
	imports: ''
	category: 'Music-PitchScales'!

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!


!Siren.MelodicMinorScale class methodsFor: 'interval list'!

allIntervals
	^#(#unison #diminishedSecond #second #minorThird #majorThird #perfectFourth augmentedFourth #perfectFifth #minorSixth #majorSixth #minorSeventh #majorSeventh )!

intervalList
	^#(#unison #second #minorThird #perfectFourth #perfectFifth #majorSixth #majorSeventh )! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!


!Siren.MelodicMinorScale methodsFor: 'Paleo'!

costForPitch: n
	(notes includes: n) ifTrue: [ ^ 0].
	root majorSeventh = n ifTrue: [^ 0].
	root majorSixth = n ifTrue: [^ 0].
	(self allNotes includes: n) ifTrue: [^ 1].
	^ 2!

enharmonicScale
	root = N C sharp ifTrue: [^ N D flat melodicMinorScale].
	root = N D sharp ifTrue: [^ N E flat melodicMinorScale].
	root = N F sharp ifTrue: [^ N G flat melodicMinorScale].
	root = N G sharp ifTrue: [^ N A flat melodicMinorScale].
	root = N A sharp ifTrue: [^ N B flat melodicMinorScale].
	root = N D flat ifTrue: [^ N C sharp melodicMinorScale].
	root = N E flat ifTrue: [^ N D sharp melodicMinorScale].
	root = N G flat ifTrue: [^ N F sharp melodicMinorScale].
	root = N A flat ifTrue: [^ N G sharp melodicMinorScale].
	root = N B flat ifTrue: [^ N A sharp melodicMinorScale].
	^ nil! !



Smalltalk.Siren defineClass: #HungarianMinor
	superclass: #{Siren.Scale}
	indexedType: #none
	private: false
	instanceVariableNames: ''
	classInstanceVariableNames: ''
	imports: ''
	category: 'Music-PitchScales'!

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!


!Siren.HungarianMinor class methodsFor: 'interval list'!

intervalList
	"tire de McLaughlin et le Mahavischnu Orchestra"

	^#(#unison #second #minorThird #augmentedFourth #perfectFifth #minorSixth #majorSeventh )! !

!Siren.HungarianMinor class methodsFor: 'examples'!

exemple	
"
	(HungarianMinor root: N do) notes ->   #(Do Re Mib Fa# Sol Lab Si )

	(HungarianMinor root: N do) generateChordsPoly: 4
->  OrderedCollection (Do #min #maj7  Re #dim5 7  Mib #aug5 #maj7  Fa# #dim5 #dim7  Sol #maj7  Lab #maj7  Si #min #dim7  )

	(FPChord newFromString: 'D min ') possibleTonalitiesInScaleClass: self ->
ListeDAnalyses ({I de Re HungarianMinor} {VII de Mib HungarianMinor} )

"! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!




Smalltalk.Siren defineClass: #Oriental
	superclass: #{Siren.Scale}
	indexedType: #none
	private: false
	instanceVariableNames: ''
	classInstanceVariableNames: ''
	imports: ''
	category: 'Music-PitchScales'!

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!


!Siren.Oriental class methodsFor: 'interval list'!

intervalList
	"tire de McLaughlin et le Mahavishnu Orchestra"

	^#(#unison #minorSecond #minorThird #perfectFourth #diminishedFifth #majorSixth #majorSeventh )! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!


#{Siren.Scale} initialize!
