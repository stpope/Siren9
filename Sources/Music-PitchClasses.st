

Smalltalk.Siren defineClass: #PitchClass
	superclass: #{Core.Object}
	indexedType: #none
	private: false
	instanceVariableNames: ''
	classInstanceVariableNames: ''
	imports: ''
	category: 'Music-PitchClasses'!

Siren.PitchClass defineSharedVariable: #English
	private: false
	constant: false
	category: 'As yet unclassified'
	initializer: nil!

Siren.PitchClass defineSharedVariable: #A
	private: false
	constant: false
	category: 'As yet unclassified'
	initializer: nil!

Siren.PitchClass defineSharedVariable: #B
	private: false
	constant: false
	category: 'As yet unclassified'
	initializer: nil!

Siren.PitchClass defineSharedVariable: #C
	private: false
	constant: false
	category: 'As yet unclassified'
	initializer: nil!

Siren.PitchClass defineSharedVariable: #D
	private: false
	constant: false
	category: 'As yet unclassified'
	initializer: nil!

Siren.PitchClass defineSharedVariable: #E
	private: false
	constant: false
	category: 'As yet unclassified'
	initializer: nil!

Siren.PitchClass defineSharedVariable: #F
	private: false
	constant: false
	category: 'As yet unclassified'
	initializer: nil!

Siren.PitchClass defineSharedVariable: #G
	private: false
	constant: false
	category: 'As yet unclassified'
	initializer: nil!

Siren.PitchClass defineSharedVariable: #AllNatural
	private: false
	constant: false
	category: 'As yet unclassified'
	initializer: nil!

Siren.PitchClass defineSharedVariable: #AllNotes
	private: false
	constant: false
	category: 'As yet unclassified'
	initializer: nil!

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!


!Siren.PitchClass class methodsFor: 'ordering'!

flatOrdering
	^#(#B #E #A #D #G #C #F ) collect: [:n | self perform: n]!

nFirstFlats: n 
	"PitchClass nFirstFlats: 3"

	^(1 to: n)
		collect: [:i | (self flatOrdering at: i) flat]!

nFirstSharps: n 
	"PitchClass nFirstSharps: 3"

	^(1 to: n)
		collect: [:i | (self sharpOrdering at: i) sharp]!

sharpOrdering
	^#(#F #C #G #D #A #E #B ) collect: [:n | self perform: n]! !

!Siren.PitchClass class methodsFor: 'vocal ranges'!

altoRange



	"retourne la collection des notes de l'alto"







	^self from: (N sol octave: 3)



		to: (N re octave: 5)!

altoRangeInScale: aScale



	"PitchClass sopranoRangeInScale: (N do sharp minorScale)"







	^aScale diatonicNotesFrom: (N sol octave: 3)



		to: (N re octave: 5)!

baseRange



	"retourne la collection des notes de la basse"







	^self from: (N sol octave: 2)



		to: (N re octave: 4)!

baseRangeInScale: aScale



	"PitchClass sopranoRangeInScale: (N do sharp minorScale)"







	^aScale diatonicNotesFrom: (N sol octave: 2)



		to: (N re octave: 4)!

sopranoRange



	"retourne la collection des notes du soprano"







	^self from: (N re octave: 4)



		to: (N do octave: 6)!

sopranoRangeInScale: aScale



	"PitchClass sopranoRangeInScale: (N do sharp minorScale)"







	^aScale diatonicNotesFrom: (N re octave: 4)



		to: (N do octave: 6)!

tenorRange



	"retourne la collection des notes du tenor"







	^self from: (N re octave: 3)



		to: (N la octave: 4)!

tenorRangeInScale: aScale



	"PitchClass sopranoRangeInScale: (N do sharp minorScale)"







	^aScale diatonicNotesFrom: (N re octave: 3)



		to: (N la octave: 4)! !

!Siren.PitchClass class methodsFor: 'initialization'!

englishOrFrench
	English := Dialog confirm: 'English (Yes) or French (No)'!

initialize
	"There are 35 pitch classes. That's too much for Squeak, so the method was split into two methods"
	"PitchClass initialize"

	| la si do re mi fa sol lad sid dod red mid fad sold lab sib dob reb mib fab solb ladd sidd dodd redd midd fadd soldd |
	la := (PitchClassNatural new) semiToneCount: 10; name: #A.
	si := (PitchClassNatural new) semiToneCount: 12; name: #B.
	do := (PitchClassNatural new) semiToneCount: 1; name: #C.
	re := (PitchClassNatural new) semiToneCount: 3; name: #D.
	mi := (PitchClassNatural new) semiToneCount: 5; name: #E.
	fa := (PitchClassNatural new) semiToneCount: 6; name: #F.
	sol := (PitchClassNatural new) semiToneCount: 8; name: #G.
	lad := PitchClassSharp new natural: la.
	sid := PitchClassSharp new natural: si.
	dod := PitchClassSharp new natural: do.
	red := PitchClassSharp new natural: re.
	mid := PitchClassSharp new natural: mi.
	fad := PitchClassSharp new natural: fa.
	sold := PitchClassSharp new natural: sol.
	lab := PitchClassFlat new natural: la.
	sib := PitchClassFlat new natural: si.
	dob := PitchClassFlat new natural: do.
	reb := PitchClassFlat new natural: re.
	mib := PitchClassFlat new natural: mi.
	fab := PitchClassFlat new natural: fa.
	solb := PitchClassFlat new natural: sol.
	ladd := PitchClassDoubleSharp new natural: la.
	sidd := PitchClassDoubleSharp new natural: si.
	dodd := PitchClassDoubleSharp new natural: do.
	redd := PitchClassDoubleSharp new natural: re.
	midd := PitchClassDoubleSharp new natural: mi.
	fadd := PitchClassDoubleSharp new natural: fa.
	soldd := PitchClassDoubleSharp new natural: sol.
	la following: si; preceding: sol; sharp: lad; flat: lab.
	si following: do; preceding: la; sharp: sid; flat: sib.
	do following: re; preceding: si; sharp: dod; flat: dob.
	re following: mi; preceding: do; sharp: red; flat: reb.
	mi following: fa; preceding: re; sharp: mid; flat: mib.
	fa following: sol; preceding: mi; sharp: fad; flat: fab.
	sol following: la; preceding: fa; sharp: sold; flat: solb.
	lad sharp: ladd.
	sid sharp: sidd.
	dod sharp: dodd.
	red sharp: redd.
	mid sharp: midd.
	fad sharp: fadd.
	sold sharp: soldd.
	A := la. B := si. C := do. D := re. E := mi. F := fa. G := sol.
	self initializeDoubleFlat.
	AllNotes := OrderedCollection new.
	AllNotes add: do; add: re; add: mi; add: fa; add: sol; add: la; add: si; add: dod; add: red; add: mid; add: fad; add: sold; add: lad; add: sid; add: dob; add: reb; add: mib; add: fab; add: solb; add: lab; add: sib; add: dodd; add: redd; add: midd; add: fadd; add: soldd; add: ladd; add: sidd.
	self initializeFrenchNames.
	English := true.
	self initializeAllNaturalNotes;  initializeGlobals!

initializeAllNaturalNotes
	AllNatural := #(#C #D #E #F #G #A #B ) collect: [:n | self perform: n]!

initializeClass
	"There are 35 pitch classes. That's too much for Squeak, so the method was split into two methods"
	"PitchClass initializeClass"

	| la si do re mi fa sol lad sid dod red mid fad sold lab sib dob reb mib fab solb ladd sidd dodd redd midd fadd soldd |
	la := (PitchClassNatural new) semiToneCount: 10; name: #A.
	si := (PitchClassNatural new) semiToneCount: 12; name: #B.
	do := (PitchClassNatural new) semiToneCount: 1; name: #C.
	re := (PitchClassNatural new) semiToneCount: 3; name: #D.
	mi := (PitchClassNatural new) semiToneCount: 5; name: #E.
	fa := (PitchClassNatural new) semiToneCount: 6; name: #F.
	sol := (PitchClassNatural new) semiToneCount: 8; name: #G.
	lad := PitchClassSharp new natural: la.
	sid := PitchClassSharp new natural: si.
	dod := PitchClassSharp new natural: do.
	red := PitchClassSharp new natural: re.
	mid := PitchClassSharp new natural: mi.
	fad := PitchClassSharp new natural: fa.
	sold := PitchClassSharp new natural: sol.
	lab := PitchClassFlat new natural: la.
	sib := PitchClassFlat new natural: si.
	dob := PitchClassFlat new natural: do.
	reb := PitchClassFlat new natural: re.
	mib := PitchClassFlat new natural: mi.
	fab := PitchClassFlat new natural: fa.
	solb := PitchClassFlat new natural: sol.
	ladd := PitchClassDoubleSharp new natural: la.
	sidd := PitchClassDoubleSharp new natural: si.
	dodd := PitchClassDoubleSharp new natural: do.
	redd := PitchClassDoubleSharp new natural: re.
	midd := PitchClassDoubleSharp new natural: mi.
	fadd := PitchClassDoubleSharp new natural: fa.
	soldd := PitchClassDoubleSharp new natural: sol.
	la following: si; preceding: sol; sharp: lad; flat: lab.
	si following: do; preceding: la; sharp: sid; flat: sib.
	do following: re; preceding: si; sharp: dod; flat: dob.
	re following: mi; preceding: do; sharp: red; flat: reb.
	mi following: fa; preceding: re; sharp: mid; flat: mib.
	fa following: sol; preceding: mi; sharp: fad; flat: fab.
	sol following: la; preceding: fa; sharp: sold; flat: solb.
	lad sharp: ladd.
	sid sharp: sidd.
	dod sharp: dodd.
	red sharp: redd.
	mid sharp: midd.
	fad sharp: fadd.
	sold sharp: soldd.
	A := la. B := si. C := do. D := re. E := mi. F := fa. G := sol.
	self initializeDoubleFlat.
	AllNotes := OrderedCollection new.
	AllNotes add: do; add: re; add: mi; add: fa; add: sol; add: la; add: si; add: dod; add: red; add: mid; add: fad; add: sold; add: lad; add: sid; add: dob; add: reb; add: mib; add: fab; add: solb; add: lab; add: sib; add: dodd; add: redd; add: midd; add: fadd; add: soldd; add: ladd; add: sidd.
	self initializeFrenchNames.
	English := true.
	self initializeAllNaturalNotes;  initializeGlobals!

initializeDoubleFlat
	| labb sibb dobb rebb mibb fabb solbb |
	labb := PitchClassDoubleFlat new natural: A.
	sibb := PitchClassDoubleFlat new natural: B.
	dobb := PitchClassDoubleFlat new natural: C.
	rebb := PitchClassDoubleFlat new natural: D.
	mibb := PitchClassDoubleFlat new natural: E.
	fabb := PitchClassDoubleFlat new natural: F.
	solbb := PitchClassDoubleFlat new natural: G.
	A flat flat: labb.
	B flat flat: sibb.
	C flat flat: dobb.
	D flat flat: rebb.
	E flat flat: mibb.
	F flat flat: fabb.
	G flat flat: solbb!

initializeFrenchNames
	C nom: #Do.
	D nom: #Re.
	E nom: #Mi.
	F nom: #Fa.
	G nom: #Sol.
	A nom: #La.
	B nom: #Si!

initializeGlobals

	Smalltalk at: #N put: self. "for short-cuts"
	Smalltalk at: #PitchClassDo put: C. "for short-cuts"! !

!Siren.PitchClass class methodsFor: 'examples'!

chordExamples
"N C sharp chordFromString: '' ->  [C# ]

(N C sharp chordFromString: 'min 7 dim5') notes -> OrderedCollection (C# E G B )
"!

closestEnharmonic
"
N D sharp closestEnharmonic Eb
N E flat closestEnharmonic D#

N B sharp closestEnharmonic C 
N C flat closestEnharmonic D#

N D sharp sharp closestEnharmonic  E
N E flat flat closestEnharmonic  D
------
(N D sharp @ 2)  closestEnharmonic Eb2 
(N E flat @ 2) closestEnharmonic D#2

(N B sharp @ 2) closestEnharmonic C3
(N C flat @ 3) closestEnharmonic B2
"!

majorScaleExample
"PitchClass B majorScale notes- >  #(B C# D# E F# G# A# )"!

melodicMinorScaleExample
	^PitchClass D flat melodicMinorScale!

minorScaleExample
	^PitchClass C sharp minorScale!

pitchInTessituraExamples

"
	N C pitchInTessitura: QTessitura high ->  C5
	N A pitchInTessitura: QTessitura high -> A4	
	N G pitchInTessitura: QTessitura high ->  G4
	N F pitchInTessitura: QTessitura high ->  F5

	N A pitchInTessitura: QTessitura low ->  A2	"!

sharpflatAlgebraExample
	"
	sharp and flat's algebra
	N C sharp ->Do# 
	N C sharp sharp ->Do## 
	N C sharp sharp sharp ->error 
	N C flat sharp -> Do
	N re sharp sharp natural -> re

	Intervals computation :
	N C diminishedFifth -> Solb
	N C augmentedFourth -> Fa#
	N C diminishedThirteenth -> Lab 
	N C flat minorSeventh -> Sibb 
	N C majorThird majorThird -> Sol#
	
	Notes equivalence : pitchEgal methode
	N C sharp pitchEqual: N re flat -> true
	N C augmentedFourth pitchEqual: N C diminishedFifth -> true
	N C diminishedFifth pitchEqual: N F minorSecond -> true
	"! !

!Siren.PitchClass class methodsFor: 'global access'!

A
	^A!

B
	^B!

C
	^C!

D
	^D!

E
	^E!

F
	^F!

G
	^G!

allNotesButDoubles
	^self naturalNotes, self sharpNotes, self flatNotes!

allPlausibleRootNotes
	^(self naturalNotes, self sharpNotes, self flatNotes) asOrderedCollection remove: (self B sharp); remove: (self E sharp); remove: (self C flat); remove: (self F flat); yourself!

allPlausibleRootsForMajorScales
	"self allPlausibleRootsForMajorScales"
	| col |
	col := OrderedCollection new.
	col add: self C; 
		add: self D flat; 
		add: self D;
		add: self E flat; 
		add: self E; 
		add: self F;
		add: self F sharp; 
		add: self G; 
		add: self A flat;
		add: self A; 
		add: self B flat; 
		add: self B.
	^col!

allPlausibleRootsForMinorScales
	"self allPlausibleRootsForMinorScales"
	| col |
	col := OrderedCollection new.
	col add: self C; 
		add: self C sharp; 
		add: self D;
		add: self D sharp; 
		add: self E; 
		add: self F;
		add: self F sharp; 
		add: self G; 
		add: self G sharp;
		add: self A; 
		add: self B flat; 
		add: self B.
	^col!

do
	^C!

fa
	^F!

flatNotes
	^self naturalNotes collect: [:n | n flat]!

fromSemiTones: n 
	"arbitrary method, used for transposing pitch classes (a strange notion...)"

	| delta |
	delta := n \\ 12.
	delta = 1 ifTrue: [^N C].
	delta = 2 ifTrue: [^N C sharp].
	delta = 3 ifTrue: [^N D].
	delta = 4 ifTrue: [^N D sharp].
	delta = 5 ifTrue: [^N E].
	delta = 6 ifTrue: [^N F].
	delta = 7 ifTrue: [^N F sharp].
	delta = 8 ifTrue: [^N G].
	delta = 9 ifTrue: [^N G sharp].
	delta = 10 ifTrue: [^N A].
	delta = 11 ifTrue: [^N A sharp].
	delta = 0 ifTrue: [^N B]!

la
	^A!

mi
	^E!

naturalNotes
	^AllNatural!

noteNamed: c 
	"takes the case of flat into account. Sharps are naturally parsed out 
	from the note name by the smalltalk parser.
	Since the algorithm proceeds from the left, it accepts any number of sharps and 	flats (using the common algebra) :
	N noteNamed: 'C#b#b#b#' ->  C# "

	|  note |
	(c size > 1 and: [c last = $b])
		ifTrue: 
			[note := self noteNamed: (c copyFrom: 1 to: c size - 1).
			^note flat].
	(c size > 1 and: [c last = $#])
		ifTrue: 
			[note := self noteNamed: (c copyFrom: 1 to: c size - 1).
			^note sharp].
	^self naturalNotes detect: [:n | n nameIs: c asSymbol]
		ifNone: [^self error: 'unknown note name : ', c]!

re
	^D!

sharpNotes
	^self naturalNotes collect: [:n | n sharp]!

si
	^B!

sol
	^G! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!


Siren.PitchClass comment:
'Instances of (subclasses of) this class represent pitch-classes.

A pitch class is an octave-independent note. There are 35 (sub) instances of this class. Octave-dependent notes are represented by instances of class OctaveDependentNote.

Ideally PitchClass should be a metaclass, so that its instances be classes, and octave-dependent notes could then be instances of pitchClasses

Unfortunately this is not possible straight-forwadly in Smalltalk, so we use aggregation instead to represent octave-dependent notes'!

!Siren.PitchClass methodsFor: 'public intervals'!

alterate: note toReach: i 
	self subclassResponsibility!

alterateBelow: note toReach: i 
	self subclassResponsibility!

augmentedEleventh
	^MusicalInterval augmentedEleventh topIfBottomIs: self!

augmentedFifth
	^MusicalInterval augmentedFifth topIfBottomIs: self!

augmentedFourth
	^MusicalInterval augmentedFourth topIfBottomIs: self!

augmentedNinth
	^MusicalInterval augmentedNinth topIfBottomIs: self!

augmentedSecond
	^MusicalInterval augmentedSecond topIfBottomIs: self!

augmentedUnison
	^MusicalInterval augmentedUnison topIfBottomIs: self!

diminishedFifth
	^MusicalInterval diminishedFifth topIfBottomIs: self!

diminishedNinth
	^MusicalInterval diminishedNinth topIfBottomIs: self!

diminishedSecond
	^MusicalInterval minorSecond topIfBottomIs: self!

diminishedSeventh
	^MusicalInterval diminishedSeventh topIfBottomIs: self!

diminishedThirteenth
	^MusicalInterval diminishedThirteenth topIfBottomIs: self!

eleventh
	^MusicalInterval eleventh topIfBottomIs: self!

fifth
	^MusicalInterval fifth topIfBottomIs: self!

flatFifth
	^MusicalInterval flatFifth topIfBottomIs: self!

flatNinth
	^MusicalInterval flatNinth topIfBottomIs: self!

flatThirteenth
	^MusicalInterval flatThirteenth topIfBottomIs: self!

fourth
	^MusicalInterval fourth topIfBottomIs: self!

majorNinth
	^MusicalInterval majorNinth topIfBottomIs: self!

majorSecond
	^MusicalInterval majorSecond topIfBottomIs: self!

majorSeventh
	^MusicalInterval majorSeventh topIfBottomIs: self!

majorSixth
	^MusicalInterval majorSixth topIfBottomIs: self!

majorThird
	^MusicalInterval majorThird topIfBottomIs: self!

majorThirteenth
	^MusicalInterval majorThirteenth topIfBottomIs: self!

minorNinth
	^MusicalInterval minorNinth topIfBottomIs: self!

minorSecond
	^MusicalInterval minorSecond topIfBottomIs: self!

minorSeventh
	^MusicalInterval minorSeventh topIfBottomIs: self!

minorSixth
	^MusicalInterval minorSixth topIfBottomIs: self!

minorThird
	^MusicalInterval minorThird topIfBottomIs: self!

minorThirteenth
	^MusicalInterval minorThirteenth topIfBottomIs: self!

ninth
	^MusicalInterval ninth topIfBottomIs: self!

octave
	^self!

perfectEleventh
	^MusicalInterval perfectEleventh topIfBottomIs: self!

perfectFifth
	^MusicalInterval perfectFifth topIfBottomIs: self!

perfectFourth
	^MusicalInterval perfectFourth topIfBottomIs: self!

second
	^MusicalInterval second topIfBottomIs: self!

seventh
	^MusicalInterval seventh topIfBottomIs: self!

sixth
	^MusicalInterval sixth topIfBottomIs: self!

thirteenth
	^MusicalInterval thirteenth topIfBottomIs: self!

unison
	^self! !

!Siren.PitchClass methodsFor: 'private intervals'!

descendingNumberOfSemiTonesBetween: aNote 
	"Important method in the theory. It is a 3-stage computation of the interval between 2 notes"

	^self semiTonesToNatural + 
	(self natural semiTonesWithNaturalNoteBelow:  aNote natural) - 
	aNote semiTonesToNatural!

descendingSemiTonesToNatural
	^self semiTonesToNatural negated!

intervalBetween: aNote 
	"returns the interval between the two notes"

	|  b b2 type |
	type := 1.
	b := self natural.
	b2 := aNote natural.
	[b2 = b] whileFalse: 
			[b := b following.
			type := type + 1].
	^MusicalInterval type: type semiTones: (self numberOfSemiTonesBetween: aNote)!

intervalTypeBetween: aNote 
	"returns the interval between the two notes"
	| b b2 type |
	type := 1.
	b := self natural.
	b2 := aNote natural.
	[b2 = b]
		whileFalse: 
			[b := b following.
			type := type + 1].
	^ type!

nthFollowing: i
	"returns the i th natural note following self"

	| nth |
	nth := self.
	i timesRepeat: [nth := nth following].
	^nth!

nthPreceding: i
	"returns the i th natural note preceding self"

	| nth |
	nth := self.
	i timesRepeat: [nth := nth preceding].
	^nth!

numberOfSemiTonesBetween: aNote 
	"Important method in the theory. It is a 3-stage computation of the interval between 2 notes"

	^self semiTonesToNatural + 
	(self natural semiTonesWithNaturalNote:  aNote natural) - 
	aNote semiTonesToNatural!

semiToneCount
	^self subclassResponsibility!

smallestIntervalBetween: aNote 
	"returns the descending interval between the two notes"
	self semiToneCount <= aNote semiToneCount
		ifTrue: [^self intervalBetween: aNote]
		ifFalse: [^self descendingIntervalBetween: aNote]! !

!Siren.PitchClass methodsFor: 'scales'!

chromaticScale
	^ChromaticScale root: self!

harmonicMinorScale
	^HarmonicMinorScale root: self!

majorScale
	^MajorScale root: self!

melodicMinorScale
	^MelodicMinorScale root: self!

minorScale
	^self harmonicMinorScale!

pseudoMinorScale
	^PseudoMinorScale root: self! !

!Siren.PitchClass methodsFor: 'saving'!

representBinaryOn: s 
	"to ensure uniqueness, pitch classes save themselves as messages sent 
	to the appropriate class, so that no duplicate are created"

	^self subclassResponsibility! !

!Siren.PitchClass methodsFor: 'mutations'!

@ o 
	(o isKindOf: Integer)
		ifFalse: [^super @ o].
	^self octave: o!

chordFromString: st 
	^self chordFromTokens: (Scanner new scanTokens: st)!

inTessitura: qualTessitura
	"N C pitchInTessitura: QTessitura high"
	| tv octs |
	tv := qualTessitura typicalValue.
	octs := self downAndUpOctaves: tv.
	(tv isNearerTo: (octs at: 1) than: (octs at: 2))
		ifTrue: [^octs at: 1]
		ifFalse: [^octs at: 2].!

octave: o
	^OctaveDependentNote octave: o pc: self! !

!Siren.PitchClass methodsFor: 'printing'!

printOn: s 
	self subclassResponsibility!

storeOn: s 
	"N C storeString"

	s nextPutAll: 'N ' , self name! !

!Siren.PitchClass methodsFor: 'chord creation'!

chordFromTokens: st 
	^(PitchClassChord new) root: self; structure: st!

majorTriad
	^PitchClassChord root: self structure: ''!

minorTriad
	^PitchClassChord root: self structure: #(#min )! !

!Siren.PitchClass methodsFor: 'making octave-dep notes'!

downAndUpOctaves: odNote
	"returns two octave dependent notes of self who are repectively
	lower and higher than the given odNote"
	| col n |
	col := OrderedCollection new.
	n := self octave: odNote oct.
	(n > odNote)
		ifTrue: [col add: (self octave: odNote oct - 1).
			     col add: n]
		ifFalse:  [ col add: n.
			        col add:  (self octave: odNote oct + 1) ].
	^col!

pitchBetween: n1 and: n2
	"return, if it exists, a pitch (octave dependent note) between the two given notes"
	| candidate |
	candidate := (self downAndUpOctaves: n1) at: 2.
	candidate <= n2
		ifTrue: [^candidate]
		ifFalse: [^nil].!

the: nb octavesBeginningFrom: initialOctave 
	"N D the: 3 octavesBeginningFrom: 0"

	| col |
	col := OrderedCollection new.
	initialOctave to: initialOctave + nb - 1 do: [:o | col add: (self octave: o)].
	^col! !

!Siren.PitchClass methodsFor: 'testing'!

isDoubleFlat
	^false!

isDoubleSharp
	^false!

isFlat
	^false!

isNatural
	^true!

isSharp
	^false!

pitchEqual: aNote 
	^(self semiToneCount - aNote semiToneCount) \\ 12 = 0! !

!Siren.PitchClass methodsFor: 'access'!

doubleFlat
	^self flat flat!

doubleSharp
	^self sharp sharp!

natural
	self subclassResponsibility!

pitchClass
	^self! !

!Siren.PitchClass methodsFor: 'constraining'!

intervalTypeModuloOctaveBetween: n 



	^(self intervalTypeBetween: n) - 1 \\ 7+ 1! !

!Siren.PitchClass methodsFor: 'Paleo'!

copy
	self shouldNotImplement!

nameInScale: aScale
	^ aScale allNotes detect: [:n | self pitchEqual: n] ifNone: [self error: 'Should not reach here. Unknown note ' , self printString]! !

!Siren.PitchClass methodsFor: 'transpose'!

transposeOf: anInterval 
	"three cases: integer (+/-), method name (= ascending interval), or interval 
	object"

	anInterval isInteger ifTrue: [^(ChromaticInterval semiTones: anInterval)
			from: self].
	anInterval isSymbol ifTrue: [^self perform: anInterval].
	(anInterval isKindOf: MusicalInterval) ifTrue: [^anInterval topIfBottomIs: self].
	^self error: 'type d''intervalle indefini'! !



Smalltalk.Siren defineClass: #PitchClassAltered
	superclass: #{Siren.PitchClass}
	indexedType: #none
	private: false
	instanceVariableNames: 'natural '
	classInstanceVariableNames: ''
	imports: ''
	category: 'Music-PitchClasses'!

!Siren.PitchClassAltered methodsFor: 'accessing'!

following
	^natural following!

name
	"yields a symbol"

	^self printString asSymbol!

natural
	^natural!

natural: value
	natural := value!

nom
	"yields a symbol"

	^self printString asSymbol!

preceding
	^natural preceding! !

!Siren.PitchClassAltered methodsFor: 'testing'!

isNatural
	^false! !



Smalltalk.Siren defineClass: #PitchClassDoubleFlat
	superclass: #{Siren.PitchClassAltered}
	indexedType: #none
	private: false
	instanceVariableNames: ''
	classInstanceVariableNames: ''
	imports: ''
	category: 'Music-PitchClasses'!

!Siren.PitchClassDoubleFlat methodsFor: 'testing'!

isDoubleFlat
	^true! !

!Siren.PitchClassDoubleFlat methodsFor: 'printing'!

printOn: s 
	natural printOn: s.
	s nextPutAll: 'bb'!

storeOn: s 
	"N C flat flat storeString"

	s nextPutAll: 'N ' , self natural name, ' flat flat'! !

!Siren.PitchClassDoubleFlat methodsFor: 'saving'!

representBinaryOn: s
	^MessageSend receiver: natural selector:  #doubleFlat! !

!Siren.PitchClassDoubleFlat methodsFor: 'intervals'!

alterate: note toReach: i 
	| n |
	n := natural alterate: note toReach: i.
	^n flat flat!

alterateBelow: note toReach: i 
	| n |
	n := natural alterateBelow: note toReach: i.
	^n flat flat!

closestEnharmonic

	^self alterate: self preceding toReach: 0.!

semiTonesToNatural
	^2! !

!Siren.PitchClassDoubleFlat methodsFor: 'access'!

flat
	"Sorry, I have to do that (Cf. Bluesette) otherwise I can't 
	compute possibleTonalities properly ..."

	^nil!

semiToneCount
	^natural semiToneCount - 2!

sharp
	"Methode flat is not defined. 
	Exemple C flat diminishedSeventh.."

	^natural flat! !



Smalltalk.Siren defineClass: #PitchClassSharp
	superclass: #{Siren.PitchClassAltered}
	indexedType: #none
	private: false
	instanceVariableNames: 'sharp '
	classInstanceVariableNames: ''
	imports: ''
	category: 'Music-PitchClasses'!

!Siren.PitchClassSharp methodsFor: 'accessing'!

flat
	^natural!

semiToneCount
	^natural semiToneCount + 1!

sharp
	^sharp!

sharp: value
	sharp := value! !

!Siren.PitchClassSharp methodsFor: 'testing'!

isSharp
	^true! !

!Siren.PitchClassSharp methodsFor: 'printing'!

printOn: s 
	natural printOn: s.
	s nextPut: $#!

storeOn: s 
	"N C sharp storeString"

	s nextPutAll: 'N ' , self natural name , ' sharp '! !

!Siren.PitchClassSharp methodsFor: 'saving'!

representBinaryOn: s
	^MessageSend receiver: natural selector:  #sharp! !

!Siren.PitchClassSharp methodsFor: 'intervals'!

alterate: note toReach: i 
	| n |
	n := natural alterate: note toReach: i.
	^n sharp!

alterateBelow: note toReach: i 
	| n |
	n := natural alterateBelow: note toReach: i.
	^n sharp!

closestEnharmonic

	^self alterate: self following toReach: 0.!

semiTonesToNatural
	^-1! !



Smalltalk.Siren defineClass: #MusicalInterval
	superclass: #{Core.Object}
	indexedType: #none
	private: false
	instanceVariableNames: 'type semiTones '
	classInstanceVariableNames: ''
	imports: ''
	category: 'Music-PitchClasses'!

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!


!Siren.MusicalInterval class methodsFor: 'examples'!

allPrintableIntervals
	"MusicalInterval allPrintableIntervals"

	| m |
	m := MusicalInterval class organization listAtCategoryNamed: 'all-printable' asSymbol.
	^m collect: [:met | MusicalInterval perform: met]!

example
	"
	MusicalInterval majorThird inverse
	
	MusicalInterval perfectFourth topIfBottomIs: N C sharp -> Fa#
	MusicalInterval perfectFourth bottomIfTopIs: N F sharp ->  Do#

	N do intervalBetween: N re -> Major second 
	N do flat intervalBetween: N sol -> Augmented fifth	
	N do flat intervalBetween: N do sharp ->  superAugmented unisson
	N do flat intervalBetween: N do sharp sharp ->  non printable interval
	(N do flat intervalBetween: N do sharp sharp) asChromaticInterval -> Chromatic 3
	(N do intervalBetween: N sol) = (N re intervalBetween: N la) -> true
	(N do intervalBetween: N fa sharp) = (N do intervalBetween: N sol flat)  -> false
	MusicalInterval allIntervalsType: 3 ->  #(Major third Minor third )
	MusicalInterval allIntervalsType: 2 ->
	#(Augmented second Diminished second Major second Minor second )
	MusicalInterval allIntervalsType: 1 -> #(Augmented unisson Diminished unisson superAugmented unisson superDiminished unisson  unisson )
	"!

exampleTranspositions
	"three ways of of transposing pitch classes and od notes"
"(N re  flat) transposeOf: 3 E
(N re  flat) transposeOf: -3 A#
(N re  flat) transposeOf: #fourth Gb
(N re  flat) transposeOf: (MusicalDescendingInterval augmentedOctave)  Dbb
(N re  flat) transposeOf: (MusicalInterval fourth)   Gb


(N re  flat @2) transposeOf: 3 E2
(N re  flat @2) transposeOf: -3 A#1
(N re  flat @2) transposeOf: #fourth Gb2
(N re  flat @2) transposeOf: (MusicalDescendingInterval augmentedOctave)  Dbb1
(N re  flat @2) transposeOf: (MusicalInterval fourth)  Gb2
"! !

!Siren.MusicalInterval class methodsFor: 'constants nick-names'!

aug11
	^self augmentedEleventh!

aug4
	^self augmentedFourth!

aug5
	^self augmentedFifth!

aug9
	"15 semitones"

	^self augmentedNinth!

dim13
	^self diminishedThirteenth!

dim5
	"6 semitones"

	^self diminishedFifth!

dim7
	"9  semitones"

	^self diminishedSeventh!

dim9

	^self diminishedNinth!

eleventh
	^self type: 11 semiTones: 17!

fifth
	^self perfectFifth!

flatFifth
	^self diminishedFifth!

flatNinth
	"1 octave + 1  semitones"

	^self diminishedNinth!

flatThirteenth
	^self diminishedThirteenth!

fourth
	^self perfectFourth!

ninth
	^self majorNinth!

second
	"2 semitones"

	^self majorSecond!

seventh
	^self minorSeventh!

sixth
	^self majorSixth!

thirteenth
	^self majorThirteenth! !

!Siren.MusicalInterval class methodsFor: 'creation'!

allIntervalsType: t
	"MusicalInterval allIntervalsType: 2"

	^MusicalInterval allPrintableIntervals select: [:i | i type = t]!

type: aType semiTones: d 
	^(self new) type: aType; semiTones: d! !

!Siren.MusicalInterval class methodsFor: 'all-printable'!

augmentedEleventh
	^self type: 11 semiTones: 18!

augmentedFifth
	"8 semitones"

	^self type: 5 semiTones: 8!

augmentedFourth
	"6 semitones"

	^self type: 4 semiTones: 6!

augmentedNinth
	"15  semitones"

	^self type: 9 semiTones: 15!

augmentedOctave
	"3 semitones"

	^self type: 8 semiTones: 13!

augmentedSecond
	"3 semitones"

	^self type: 2 semiTones: 3!

augmentedTenth
	"17 semitones"

	^self type: 10 semiTones: 17!

augmentedTwelvth
	"20 semitones"

	^self type: 12 semiTones: 20!

augmentedUnison
	^self type: 1 semiTones: 1!

diminishedFifth
	"6 semitones"

	^self type: 5 semiTones: 6!

diminishedFourth
	"5 semitones"

	^self type: 4 semiTones: 4!

diminishedNinth
	"1 octave + 1  semitones"

	^self type: 9 semiTones: 13!

diminishedOctave
	"11 semitones"

	^self type: 8 semiTones: 11!

diminishedSecond
	"0 semitones"

	^self type: 2 semiTones: 0!

diminishedSeventh
	"9  semitones"

	^self type: 7 semiTones: 9!

diminishedTenth
	"15 semitones"

	^self type: 10 semiTones: 15!

diminishedThirteenth
	^self type: 13 semiTones: 20!

diminishedTwelvth
	"18 semitones"

	^self type: 12 semiTones: 18!

diminishedUnison
	"MusicalInterval diminishedUnison topIfBottomIs: N C"

	^self type: 1 semiTones: -1!

majorNinth
	"14 semitones"

	^self type: 9 semiTones: 14!

majorSecond
	"2 semitones"

	^self type: 2 semiTones: 2!

majorSeventh
	"11  semitones"
	^self type: 7 semiTones: 11!

majorSixth
	"9  semitones"

	^self type: 6 semiTones: 9!

majorTenth
	"14 semitones"

	^self type: 10 semiTones: 16!

majorThird
	"4 semitones"

	^self type: 3 semiTones: 4!

majorThirteenth
	^self type: 13 semiTones: 21!

majorTwelvth
	"19 semitones"

	^self type: 12 semiTones: 19!

minorNinth
	"1 octave + 1  semitones"

	^self type: 9 semiTones: 13!

minorSecond
	"1 semitone"

	^self type: 2 semiTones: 1!

minorSeventh
	"10  semitones"

	^self type: 7 semiTones: 10!

minorSixth
	"8 semitones"

	^self type: 6 semiTones: 8!

minorThird
	"3 semitones"

	^self type: 3 semiTones: 3!

minorThirteenth
	^self type: 13 semiTones: 20!

octave
	^self type: 8 semiTones: 12!

perfectEleventh
	"5 semitones"

	^self type: 11 semiTones: 17!

perfectFifth
	"7 semitones"

	^self type: 5 semiTones: 7!

perfectFourth
	"5 semitones"

	^self type: 4 semiTones: 5!

superAugmentedUnison
	"MusicalInterval superAugmentedUnison topIfBottomIs: N C"

	^self type: 1 semiTones: 2!

superDiminishedUnison
	"MusicalInterval superDiminishedUnison topIfBottomIs: N C"

	^self type: 1 semiTones: -2!

unison
	^self type: 1 semiTones: 0! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!


Siren.MusicalInterval comment:
'MusicalInterval commentStamp: ''<historical>'' prior: 0!!
Intervalle represente un intervalle entre deux notes.
type represente l''ecart entre les deux notes extremites. Cet ecart ne tient compte
que des notes naturelles. Par exemple, les tierces (majeures ou mineures) ont comme type 3,
les quarte 4 etc.
demisTons est le nombre de demis tons entre les deux notes. Par exemple une tierce
majeure a comme type 3 et demisTons = 4.
'!

!Siren.MusicalInterval methodsFor: 'arithmetics'!

+ anInterval 
	"(MusicalInterval majorSecond) + (MusicalInterval perfectFifth)"

	| note1 note2 |
	note1 := self topIfBottomIs: PitchClassDo.
	note2 := anInterval topIfBottomIs: note1.
	^PitchClass do intervalBetween: note2! !

!Siren.MusicalInterval methodsFor: 'comparing'!

< anInterval
	^semiTones < anInterval semiTones!

<= anInterval
	^semiTones <= anInterval semiTones!

= anInterval 
	^type = anInterval type and: [semiTones = anInterval semiTones]!

> anInterval
	^semiTones > anInterval semiTones!

>= anInterval
	^semiTones >= anInterval semiTones!

hasSameDirectionAs: anInterval
	^(self isAscending and: [anInterval isAscending])
		or: [self isDescending and: [anInterval isDescending]]! !

!Siren.MusicalInterval methodsFor: 'testing'!

isA: anInterval
	^self = (MusicalInterval perform: anInterval).!

isAscending
	^true!

isDescending
	^false! !

!Siren.MusicalInterval methodsFor: 'automatic access'!

orientedSemiTones
	^semiTones!

semiTones
	^semiTones!

semiTones: aValue
	semiTones := aValue!

type
   ^type!

type: aValue
   type := aValue! !

!Siren.MusicalInterval methodsFor: 'printing'!

isPrintable
	Object notFoundSignal handle: [:ex | ^false]
		do: 
			[self printPrintableOn: (WriteStream on: '').
			^true]!

printOn: s 
	Object notFoundSignal handle: [:ex | s nextPutAll: 'non printable interval']
		do: [self printPrintableOn: s]!

printPrintableOn: s 
	"Watch out : all Intervals cant print themselves.
	You can convert a musicalInterval into a ChromaticInterval.
	E.g. : Interval between Cbb and C ## (super super augmented 
	unison!!!!).
	There are here 40 printable intervals. Cf. method MusicalInterval allPrintableIntervals
(put in protocol constants)"

	type = 1 ifTrue: [s nextPutAll: (#(#superDiminished #Diminished '' #Augmented #superAugmented ) at: semiTones + 3)].
	type = 2 ifTrue: [s nextPutAll: (#(#Diminished #Minor #Major #Augmented ) at: semiTones + 1)].
	type = 3 ifTrue: [s nextPutAll: (#(#Minor #Major ) at: semiTones - 2)].
	type = 4 ifTrue: [s nextPutAll: (#(#Diminished #Perfect #Augmented ) at: semiTones - 3)].
	type = 5 ifTrue: [s nextPutAll: (#(#Diminished #Perfect #Augmented ) at: semiTones - 5)].
	type = 6 ifTrue: [s nextPutAll: (#(#Minor #Major #Augmented ) at: semiTones - 7)].
	type = 7 ifTrue: [s nextPutAll: (#(#Diminished #Minor #Major ) at: semiTones - 8)].
	type = 8 ifTrue: [s nextPutAll: (#(#Diminished '' #Augmented ) at: semiTones - 10)].
	type = 9 ifTrue: [s nextPutAll: (#(#Diminished '' #Augmented ) at: semiTones - 12)].
	type = 10 ifTrue: [s nextPutAll: (#(#Diminished '' #Augmented ) at: semiTones - 14)].
	type = 11 ifTrue: [s nextPutAll: (#(#Diminished '' #Augmented ) at: semiTones - 15)].
	type = 12 ifTrue: [s nextPutAll: (#(#Diminished '' #Augmented ) at: semiTones - 17)].
	type = 13 ifTrue: [s nextPutAll: (#(#Diminished '' #Augmented ) at: semiTones - 19)].
	s nextPutAll: ' '.
	s nextPutAll: (#(#unisson #second #third #fourth #fifth #sixth #seventh #octave #ninth #tenth #eleventh #twelvth #thirteenth ) at: type)!

storeOn: s
	s nextPutAll: '(', self class name asString.
	s nextPutAll: ' type: ', type printString, ' semiTones: ', semiTones printString, ')'.! !

!Siren.MusicalInterval methodsFor: 'computing notes'!

topIfBottomIs: aNote 
	"yields the note making the interval self with aNote"
	"two cases :
	- aNote is a pitch-class, in which case, no interval is 
	greater than an octave
	- aNote is anOctave-DependentNote, in which case octaves
	should be counted"

	"we want 1 -1, 2-2, 7-7, 8-1, 9-2, etc ..."
	(aNote isKindOf: PitchClass)
		ifTrue: [^aNote alterate: (aNote nthFollowing: type - 1 \\ 7)
				toReach: semiTones \\ 12].
	^aNote alterate: (aNote nthFollowing: type - 1)
		toReach: semiTones! !

!Siren.MusicalInterval methodsFor: 'mutations'!

asChromaticInterval
	^ChromaticInterval semiTones: semiTones!

ascending
	^self!

descending
	^MusicalDescendingInterval type: type semiTones: semiTones! !



Smalltalk.Siren defineClass: #MusicalDescendingInterval
	superclass: #{Siren.MusicalInterval}
	indexedType: #none
	private: false
	instanceVariableNames: ''
	classInstanceVariableNames: ''
	imports: ''
	category: 'Music-PitchClasses'!

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!


!Siren.MusicalDescendingInterval class methodsFor: 'examples'!

example

"(N C octave: 3) intervalBetween: (N D octave: 2) descending Minor seventh
(N B flat octave: 3) intervalBetween: (N B flat flat octave: 2) descending augmented octave"! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!


Siren.MusicalDescendingInterval comment:
'La theorie des intervalles "descendants" n''est pas tres claire:
Que voudrait dire DescendingInterval topIfBottomIs: N C ?
(quelle difference avec ascending ?).
Introduit juste pour les besoins de la cause, mais un peu incoherent.
Herite tout de MusicalInterval, et donc se comporte presque pareil.
Utilisee uniquement en creation dans la methode intervalBetween: de OctaveDependentNote.
Il faudrait d''ailleurs modifier aussi la methode similaire de PitchClass'!

!Siren.MusicalDescendingInterval methodsFor: 'computing notes'!

bottomIfTopIs: aNote 
	"yields the note for which I am the interval self"
self halt.
	^super topIfBottomIs: aNote!

topIfBottomIs: aNote 
	"yields the note for which I am the interval self"

	^super bottomIfTopIs: aNote! !

!Siren.MusicalDescendingInterval methodsFor: 'testing'!

isAscending
	^false!

isDescending
	^true! !

!Siren.MusicalDescendingInterval methodsFor: 'mutations'!

ascending
	^MusicalInterval type: type semiTones: semiTones!

descending
	^self! !



Smalltalk.Siren defineClass: #Analysis
	superclass: #{UI.Model}
	indexedType: #none
	private: false
	instanceVariableNames: 'scale degree '
	classInstanceVariableNames: ''
	imports: ''
	category: 'Music-PitchClasses'!

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!


!Siren.Analysis class methodsFor: 'examples'!

examples

"	(FPChord newFromString: 'B min ') analyseIn: (N C majorScale) 
		->  {VII de C MajorScale}

	(FPChord newFromString: 'C min dim5') possibleTonalitiesInScaleClass:  MajorScale
		-> AnalysisList ({VII of Db MajorScale} )

	(FPChord newFromString: 'C') possibleTonalitiesInScaleClass:  MajorScale
		-> AnalysisList ({I de C MajorScale} {IV de G MajorScale} {V de F MajorScale}
"! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!


!Siren.Analysis methodsFor: 'automatic access'!

degree

   ^degree!

degree: x 

	degree := x!

scale

   ^scale!

scale: x

   scale := x! !

!Siren.Analysis methodsFor: 'printing'!

printOn: s

	s nextPutAll: '{',self romanDegree,' of ',scale printString,'}'!

romanDegree

	^#(I II III IV V VI VII) at: degree! !



Smalltalk.Siren defineClass: #PitchClassNatural
	superclass: #{Siren.PitchClass}
	indexedType: #none
	private: false
	instanceVariableNames: 'semiToneCount nom name following preceding sharp flat '
	classInstanceVariableNames: ''
	imports: ''
	category: 'Music-PitchClasses'!

!Siren.PitchClassNatural methodsFor: 'accessing'!

flat
	^flat!

flat: value
	flat := value!

name
	^name!

name: x 
	name := x!

natural
	^self!

nom
	^nom!

nom: value
	nom := value!

sharp
	^sharp!

sharp: value
	sharp := value! !

!Siren.PitchClassNatural methodsFor: 'printing'!

nameIs: aSymbol 
	name = aSymbol ifTrue: [^true].
	^nom = aSymbol!

printOn: s 
	s nextPutAll: (English
			ifTrue: [name]
			ifFalse: [nom])! !

!Siren.PitchClassNatural methodsFor: 'saving'!

representBinaryOn: s
	^MessageSend receiver: self class selector:  name! !

!Siren.PitchClassNatural methodsFor: 'intervals'!

alterate: note toReach: i
	"Join semitons to note in order to obtain the required number of semitones with self" 

	| delta |
	delta := (self  semiTonesWithNaturalNote: note) - i.
	delta := ((delta + 6) \\ 12) -6.
	delta = 0 ifTrue: [^note].
	delta = 1 ifTrue: [^note flat].
	delta = -1 ifTrue: [^note sharp].
	delta = 2 ifTrue: [^note flat flat].
	delta = -2 ifTrue: [^note sharp sharp].
	delta = 3 ifTrue: [^note flat flat flat].	"to deal with cases like N B flat flat augmentedOctave"
	delta = -3 ifTrue: [^note sharp sharp sharp].
	^self error: 'illegal interval !!'!

alterateBelow: note toReach: i
	"Join semitons to note in order to obtain the required number of semitones with self" 

	| delta |
	delta := (self  semiTonesWithNaturalNoteBelow: note) - i.
	delta := ((delta + 6) \\ 12) -6.
	delta = 0 ifTrue: [^note].
	delta = -1 ifTrue: [^note flat].
	delta = 1 ifTrue: [^note sharp].
	delta = -2 ifTrue: [^note flat flat].
	delta = 2 ifTrue: [^note sharp sharp].
	delta = -3 ifTrue: [^note flat flat flat].	"to deal with cases like N B flat flat augmentedOctave"
	delta = 3 ifTrue: [^note sharp sharp sharp].
	^self error: 'illegal interval !!'!

closestEnharmonic
	^self!

semiTonesToNatural
	^0!

semiTonesWithNaturalNote: aNote 
	"number of semitones between self and aNote"

	| r |
	r := aNote semiToneCount - semiToneCount.
	"^r + 6 \\ 12 - 6"
	^r \\ 12!

semiTonesWithNaturalNoteBelow: aNote 
	"number of semitones between aNote and self"

	| r |
	r :=  semiToneCount - aNote semiToneCount .
	"^r + 6 \\ 12 - 6"
	^r \\ 12! !

!Siren.PitchClassNatural methodsFor: 'private-accessing'!

following
	^following!

following: value
	following := value!

preceding
	^preceding!

preceding: value
	preceding := value!

semiToneCount
	^semiToneCount!

semiToneCount: s
	semiToneCount := s! !



Smalltalk.Siren defineClass: #DiatonicInterval
	superclass: #{Siren.MusicalInterval}
	indexedType: #none
	private: false
	instanceVariableNames: 'ascending '
	classInstanceVariableNames: ''
	imports: ''
	category: 'Music-PitchClasses'!

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!


!Siren.DiatonicInterval class methodsFor: 'creation'!

ascending
	^DiatonicInterval new ascending: true!

descending
	^DiatonicInterval new ascending: false!

new
	^super new initialize! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!


!Siren.DiatonicInterval methodsFor: 'computing notes'!

bottomIfTopIs: aNote 
	"yields the note making the interval self with aNote"

	^ascending
		ifTrue: [aNote preceding]
		ifFalse: [aNote following]!

topIfBottomIs: aNote 
	"yields the note making the interval self with aNote"

	^ascending ifFalse: [aNote preceding]
		ifTrue: [aNote following]! !

!Siren.DiatonicInterval methodsFor: 'initialize'!

initialize
	ascending := true! !

!Siren.DiatonicInterval methodsFor: 'printing'!

printOn: s 
	s nextPutAll: 'Diatonic interval '! !

!Siren.DiatonicInterval methodsFor: 'private'!

ascending: t 
	ascending := t! !



Smalltalk.Siren defineClass: #PitchClassChord
	superclass: #{Core.Object}
	indexedType: #none
	private: false
	instanceVariableNames: 'root structure notes possibleTonalities '
	classInstanceVariableNames: ''
	imports: ''
	category: 'Music-PitchClasses'!

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!


!Siren.PitchClassChord class methodsFor: 'examples'!

allChordsFromListOfNotes: aList 
	"self allChordsFromListOfNotes: (Array with: N do with: N mi with: N sol)
 #(Do  Mi #min #no5 #no11 #no9 #no7 #dim13  Sol #sus4 #no5 #sixth  )
	self allChordsFromListOfNotes: (Array with: N do with: N mi with: N sol with: N si)"

	"tries in all possible inversion, assuming that the root is actually present"
	^aList collect: [:n | self new fromNotes: aList root: n]!

commonTonalities

"
(PitchClassChord new fromString: 'C maj7') 
	possibleTonalities AnalysisList ({I of C MajorScale} {IV of G MajorScale} {VI of E HarmonicMinorScale} )

(PitchClassChord new fromString: 'F maj7')
	possibleTonalities AnalysisList ({I of F MajorScale} {IV of C MajorScale} {VI of A HarmonicMinorScale} )

(PitchClassChord new fromString: 'E min 7')
	possibleTonalities  AnalysisList ({II of D MajorScale} {III of C MajorScale} {VI of G MajorScale} {IV of B HarmonicMinorScale} {II of D MelodicMinorScale} )
----
(PitchClassChord new fromString: 'C maj7') 
	tonalitesCommunesAvec: (PitchClassChord new fromString: 'F maj7')
	et: (PitchClassChord new fromString: 'E min 7') Set (C MajorScale )

"!

exampleShort
	"'C min 7 dim5' asChord. 
	('C min 7 dim5 9' asChordOct: 4) notes
		OrderedCollection (C4 Eb4 Gb4 Bb4 D5 )"!

examples
"
(PitchClassChord new fromString: 'Re maj7') notes OrderedCollection (Re Fa# La Do# )
(PitchClassChord new fromString: 'Re# maj7') notes  OrderedCollection (Re# Fa## La# Do## )
(PitchClassChord new fromString: 'C') notes    OrderedCollection (Do Mi Sol )
(PitchClassChord new fromString: 'D min 7 dim5') notes OrderedCollection (Re Fa Lab Do )
(PitchClassChord new fromString: 'C aug9') notes   OrderedCollection (Do Mi Sol Sib Re# )
(PitchClassChord new fromString: 'C aug9 dim5') notes OrderedCollection (Do Mi Solb Sib Re# )   
(PitchClassChord new fromString: 'C 13') notes OrderedCollection (Do Mi Sol Sib Re Fa La )
(PitchClassChord new fromString: 'C 13 aug9') notes OrderedCollection (Do Mi Sol Sib Re# Fa La )
(PitchClassChord new fromString: 'C 13 aug9 no7') notes OrderedCollection (Do Mi Sol Re# Fa La )
(PitchClassChord new fromString: 'C halfDim7') notes  OrderedCollection (Do Mib Solb Sib )

'F min 7' asChord notes > OrderedCollection (F Ab C Eb ) 	
'F min7' asChord notes  > OrderedCollection (F A C )		
'F m 7' asChord notes  > OrderedCollection (F A C Eb )		
'Fm 7' asChord notes > error	
'F maj 7' asChord notes > error	
'F m7' asChord notes  > OrderedCollection (F A C )		
'F maj 7' asChord notes > OrderedCollection (F A C Eb )		
'F maj7' asChord notes > OrderedCollection (F A C E )		
'F halfDim7' asChord notes  > OrderedCollection (F Ab Cb Eb ) 	
'F min dim5 7' asChord notes  OrderedCollection (F Ab Cb Eb )
'F min b5 7' asChord notes OrderedCollection (F Ab Cb Eb )
'F dim7' asChord notes OrderedCollection (F A C Ebb )

PitchClassChord new fromNotes: (Array with: N do with: N mi with: N sol)  Do
PitchClassChord new fromNotes: (Array with: N do with: N mi with: N sol sharp) Do #aug5 
PitchClassChord new fromNotes: (Array with: N do with: N fa with: N sol )   	 Do #sus4
PitchClassChord new fromNotes: (Array with: N do with: N mi with: N sol with: N la)  Do #sixth  
PitchClassChord new fromNotes: (Array with: N do with: N mi with: N la)  Do #no5 #sixth 
PitchClassChord new fromNotes: (Array with: N do with: N la)  Do #no3 #no5 #sixth 
PitchClassChord new fromNotes: (Array with: N do with: N mi with: N sol sharp with: N si)  Do #aug5 #maj7 
PitchClassChord new fromNotes: (Array with: N do with: N mi with: N sol flat with: N si flat) Do #dim5 7
PitchClassChord new fromNotes: (Array with: N do with: N mi flat with: N sol flat with: N si flat)   Do #halfDim7
PitchClassChord new fromNotes: (Array with: N do with: N mi flat with: N sol flat with: N si flat flat)  Do #dim7 

PitchClassChord new fromNotes: (Array with: N do with: N mi flat) Do #min #no5 
PitchClassChord new fromNotes: (Array with: N do with: N mi with: N fa  with: N fa sharp )  Do #no5 #no9 #no7 11 #aug11 
PitchClassChord new fromNotes: (Array with: N do with: N sol flat with: N sol sharp) Do #no3 #dim5 #aug5

A chord of A. holdsworth
PitchClassChord new fromNotes: (Array with: N re sharp with: N fa sharp sharp  with: N la with: N do sharp sharp)   Re# #dim5 #maj7 


(PitchClassChord new fromString: 'C min') standardPossibleTonalities OrderedCollection ({II de Sib MajorScale} {III de Lab MajorScale} {VI de Mib MajorScale} {I de Do HarmonicMinorScale} {IV de Sol HarmonicMinorScale} {I de Do MelodicMinorScale} {II de Sib MelodicMinorScale} )

(PitchClassChord new fromString: 'Do') possibleTonalities
 ListeDAnalyses ({V de Fa HungarianMinor} {VI de Mi HungarianMinor} {I de Do MajorScale} {IV de Sol MajorScale} {V de Fa MajorScale} {I de Do DoubleHarmonic} {II de Si DoubleHarmonic} {IV de Sol MelodicMinorScale} {V de Fa MelodicMinorScale} {IV de Sol Oriental} {IV de Sol NeapolitanMajor} {V de Fa HarmonicMinorScale} {VI de Mi HarmonicMinorScale} {II de Si NeapolitanMinor} {VI de Mi NeapolitanMinor} )

(PitchClassChord new fromString: 'D min ') possibleTonalities
ListeDAnalyses ({I de Re HungarianMinor} {VII de Mib HungarianMinor} {II de Do MajorScale} {III de Sib MajorScale} {VI de Fa MajorScale} {III de Sib DoubleHarmonic} {IV de La DoubleHarmonic} {I de Re MelodicMinorScale} {II de Do MelodicMinorScale} {I de Re NeapolitanMajor} {I de Re HarmonicMinorScale} {IV de La HarmonicMinorScale} {I de Re NeapolitanMinor} {IV de La NeapolitanMinor} )
"!

holdsworth
	^PitchClassChord new fromNotes: (Array
			with: N re sharp
			with: N fa sharp sharp
			with: N la
			with: N do sharp sharp)!

reallyAllChordsFromListOfNotes: aList 
	"self reallyAllChordsFromListOfNotes: (Array with: N do with: N mi with: N sol)
 OrderedCollection ([La #noRoot #min 7 ] [Si #noRoot #sus4 #no5 #no7 #dim9 #dim13 ] [Do ] [Re #noRoot #sus4 #no5 7 9 ] [Mi #min #no5 #no11 #no9 #no7 #dim13 ] [Fa #noRoot #no3 #maj7 9 ] [Sol #sus4 #no5 #sixth ] [La# #noRoot #no3 #dim5 ] [Do# #noRoot #min #dim5 ] [Re# #noRoot #no3 #no5 #dim9 ] [Fa# #noRoot #no3 #dim5 7 #dim9 ] [Sol# #noRoot #no3 #no5 #no11 #no9 #no7 #dim13 ] [Lab #noRoot #aug5 #maj7 ] [Sib #noRoot #no3 #no5 #no7 9 #aug11 #sixth ] [Reb #noRoot #no3 #no5 #maj7 #aug9 #aug11 ] [Mib #noRoot #no5 #sixth ] [Solb #noRoot #no3 #no5 #no9 #no7 #aug11 ] )
"

	"tries in all possible inversion, assuming that the root is actually present"
	^PitchClass allPlausibleRootNotes collect: [:n | self new fromNotes: aList root: n]! !

!Siren.PitchClassChord class methodsFor: 'creation'!

new
	^super new initialize!

newFromNotes: l 
	"computes the name from the list of notes, according to our syntax"

	^self new fromNotes: l!

newFromNotesNames: aStringOfNoteNames 
	"computes the name from the list of notes, according to our syntax
	PitchClassChord newFromNotesNames: 'A C# E G'  [La 7 ] "

	| l notes lastNote aNote |
	l := Scanner new scanTokens: aStringOfNoteNames.
	notes := OrderedCollection new.
	l do: [:x | x = '#' asSymbol
			ifTrue: 
				[lastNote := notes last.
				notes removeLast; addLast: lastNote sharp]
			ifFalse: [x = 'b' asSymbol
					ifTrue: 
						[lastNote := notes last.
						notes removeLast; addLast: lastNote flat]
					ifFalse: 
						[aNote := PitchClass noteNamed: x.
						notes addLast: aNote]]].
	^self new fromNotes: notes!

newFromString: l 
	"computes the list of notes fom the name acording to our syntax"

	^self new fromString: l!

root: r structure: s
	^self new root: r; structure: s! !

!Siren.PitchClassChord class methodsFor: 'editing'!

openEditor
	ChordNameEditor open! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!


!Siren.PitchClassChord methodsFor: 'automatic access'!

root
   ^root!

root: aValue
  	 root := aValue.
	self resetNotes!

rootPitchClass
	^root pitchClass!

structure
   ^structure!

structure: aValue
	structure := aValue.
	self resetNotes! !

!Siren.PitchClassChord methodsFor: 'mutations'!

@ o 
	o isInteger ifFalse: [^super @ o].
	^self octave: o!

asPlayableObject
	^(self octave: self defaultOctave) asPlayableObject!

defaultOctave
	^2!

fondamental
	| t n |
	t := self root octave: 3.
	n := self notes collect: [:nn | nn octave: 4].
	n addFirst: t.
	^(OctaveDependentChord root: t notes: n)!

inTessitura: qt
	^ OctaveDependentChord root: (root inTessitura: qt)!

lapse: l
	^(self octave: self defaultOctave) lapse: l!

octave: n 
	^(OctaveDependentChord new) structure: structure copy; root: (root octave: n)!

startBeat: s duration: d
	"a default octave is used"
	^(self octave: self defaultOctave) startBeat: s duration: d!

startTime: s duration: d
	^(self octave: self defaultOctave) startBeat: s duration: d! !

!Siren.PitchClassChord methodsFor: 'printing'!

name
	"produces a printable name (without the sharps before symbols)"

	| s |
	s := WriteStream on: ''.
	root printOn: s.
	s nextPutAll: ' '.
	structure
		do: 
			[:x | 
			(x isKindOf: Integer)
				ifTrue: [s nextPutAll: x printString]
				ifFalse: [s nextPutAll: x].
			s nextPutAll: ' '].
	^s contents!

notesString
	| s |
	s := ''.
	self notes do: [:n | s := s , n printString , ' '].
	^s!

printOn: s  
	s nextPutAll: '['.
	(root isKindOf: PitchClass)
		ifTrue: [root printOn: s]
		ifFalse: [root pitchClass printOn: s].
	s nextPutAll: ' '.
	structure  do: 

	[:x | 
		(x isKindOf: SmallInteger)
			ifTrue: [x  printOn: s]
			ifFalse: [s nextPutAll: x asString].
		s nextPutAll: ' '].
	s nextPutAll: ']'.!

quotedPrintOn: s
	"as printOn but without the brackets [] and with quotes"
	s nextPut: $'.
	(root isKindOf: PitchClass) 
		ifTrue: [root printOn: s]
		ifFalse: [root pitchClass printOn: s].
	s nextPutAll: ' '.
	structure  do: 
	[:x | 
		(x isKindOf: SmallInteger)
			ifTrue: [x  printOn: s]
			ifFalse: [s nextPutAll: x asString].
		s nextPutAll: ' '].
	s nextPut: $'.!

storeOn: s
	"returns a String representation of the receiver from which the receiver
	can be reconstructed"
	s nextPut: $(.
	self quotedPrintOn: s.
	s nextPutAll: ' asChord)'.!

structureString
	| s |
	s := WriteStream on: ''.
	structure  do: 
	[:x | 
		(x isKindOf: SmallInteger)
			ifTrue: [x  printOn: s]
			ifFalse: [s nextPutAll: x asString].
		s nextPutAll: ' '].
	^s contents! !

!Siren.PitchClassChord methodsFor: 'accessing by  intervals'!

theFifth

	self  hasNoFifth
		ifTrue: [^nil].
	self hasADiminishedFifth
		ifTrue: [^root diminishedFifth].
	self hasAnAugmentedFifth
		ifTrue: [^root augmentedFifth].
	^root fifth.!

theFourth
	
	^ root fourth.!

theOctave
	
	^ root octave.!

theSeventh
	self hasNoSeventh ifTrue: [^nil].
	self hasAMajorSeventh ifTrue: [^root majorSeventh].
	self hasADiminishedSeventh ifTrue: [^root diminishedSeventh].
	self hasAMinorSeventh ifTrue: [^root minorSeventh].
	^nil!

theThird
	
	self isSuspended
		ifTrue: [^nil].
	self isMinor
		ifTrue: [^root  minorThird].
	^ root majorThird.!

theTonic
	^root unison! !

!Siren.PitchClassChord methodsFor: 'creation'!

format
	"format the structure. Assumes root is not nil"

	structure := self structureFromNotes: self notes root: root!

fromNotes: l 
	"assumes the first note is the root"

	^self fromNotes: l root: l first!

fromNotes: aList root: r
	"l isa list of pitch-classes.
	This method computes the correct (and canonical) name for the chord"

	| l |
	root := r. 
	l := aList  asOrderedCollection.
	notes := l copy.
	structure := OrderedCollection new.
	
	(l includes: r) ifTrue: [l remove: r] ifFalse: [structure add: #noRoot].

	(self notes: l contains: #(majorThird minorThird fourth)) ifFalse: [structure add: #no3].
	(((self notes: l contains: #(majorThird minorThird)) not) and: [l includes: r fourth]) ifTrue: [structure add: #sus4. l remove: r fourth].
	(l includes: root majorThird) ifTrue: [l remove: root majorThird].
	(l includes: root minorThird) ifTrue: [structure add: #min. l remove: root minorThird].
	(self notes: l contains: #(fifth augmentedFifth diminishedFifth)) ifFalse: [structure add: #no5].		
	(l includes: root diminishedFifth) ifTrue: [structure add: #dim5. l remove: root diminishedFifth].
	(l includes: root augmentedFifth) ifTrue: [structure add: #aug5. l remove: root augmentedFifth].
	(l includes: root perfectFifth) ifTrue: [ l remove: root perfectFifth].

	((l includes: root minorSeventh) and: [(structure includes: #dim5) and: [structure includes: #min]])
			ifTrue: [structure add: #halfDim7; remove: #dim5; remove: #min. l remove: root minorSeventh].
	(l includes: root minorSeventh) ifTrue: [structure add: 7. l remove: root minorSeventh].
	(l includes: root majorSeventh) ifTrue: [structure add: #maj7. l remove: root majorSeventh].
	((l includes: root diminishedSeventh) and: [(structure includes: #dim5) and: [structure includes: #min]])
			ifTrue: [structure add: #dim7; remove: #dim5; remove: #min. l remove: root diminishedSeventh].

	((structure includes: #no7) not and: [((self notes: l contains: #(ninth augmentedNinth diminishedNinth)) and: [(self notes: notes contains: #(minorSeventh majorSeventh diminishedSeventh)) not])]) ifTrue: [structure add: #no7].
	(l includes: root ninth) ifTrue: [structure add: 9. l remove: root ninth].
	(l includes: root diminishedNinth) ifTrue: [structure add: #dim9. l remove: root diminishedNinth].
	(l includes: root augmentedNinth) ifTrue: [structure add: #aug9. l remove: root augmentedNinth].

	((structure includes: #no9) not and:
		[((self notes: l contains: #(eleventh augmentedEleventh)) and:
			[(self notes: notes contains: #(ninth augmentedNinth diminishedNinth)) not])])
	ifTrue: [structure add: #no9].
	((structure includes: #no7) not and: [((self notes: l contains: #(eleventh augmentedEleventh)) and: [(self notes: notes contains: #(minorSeventh majorSeventh diminishedSeventh)) not])]) ifTrue: [structure add: #no7].
	(l includes: root eleventh) ifTrue: [structure add: 11. l remove: root eleventh]. 
	(l includes: root augmentedEleventh) ifTrue: [structure add: #aug11. l remove: root augmentedEleventh]. 

	((self notes: l contains: #(thirteenth)) and:
		[(self notes: notes contains: #(minorSeventh majorSeventh)) not]) ifTrue: [structure add: #sixth. l remove: r thirteenth].
	((structure includes: #no11) not and:
		[((self notes: l contains: #(thirteenth diminishedThirteenth)) and:
			[(self notes: notes contains: #(eleventh augmentedEleventh)) not])]) ifTrue: [structure add: #no11].
	((structure includes: #no9) not and: [((self notes: l contains: #(thirteenth diminishedThirteenth)) and: [(self notes: notes contains: #(ninth augmentedNinth diminishedNinth)) not])]) ifTrue: [structure add: #no9].
	((structure includes: #no7) not and: [((self notes: l contains: #(thirteenth  diminishedThirteenth)) and: [(self notes: notes contains: #(minorSeventh majorSeventh diminishedSeventh)) not])]) ifTrue: [structure add: #no7].
	(l includes: root thirteenth) ifTrue: [structure add: 13. l remove: root thirteenth].
	(l includes: root diminishedThirteenth) ifTrue: [structure add: #dim13. l remove: root diminishedThirteenth].!

fromString: l
	"l is a list whose first element is a note and the rest a structure, in our
	standardized chord syntax"
	
	| secondElement |
	structure := (Scanner new scanTokens: l) asOrderedCollection.
	root := PitchClass noteNamed: structure first.
	structure removeFirst.

"the following is done twice to take double sharp and double flats into acount
although those should not be allowed to form chords"

	2 timesRepeat: [
	structure isEmpty ifFalse:
		[secondElement:= structure first.
		(secondElement = '#' asSymbol)
			ifTrue: [root := root sharp. structure removeFirst].
		(secondElement = #b) ifTrue: [root:= root flat. structure removeFirst]]].
	self format!

structureFromNotes: aList root: r
	"l isa list of pitch-classes.
	This method computes the correct (and canonical) name for the chord"

	| l struct |
	l := aList  asOrderedCollection.
	struct := OrderedCollection new. 
	(l includes: r) ifTrue: [l remove: r] ifFalse: [struct add: #noRoot].

	(self notes: l contains: #(majorThird minorThird fourth)) ifFalse: [struct add: #no3].
	(((self notes: l contains: #(majorThird minorThird)) not) and: [l includes: r fourth]) ifTrue: [struct add: #sus4. l remove: r fourth].
	(l includes: root majorThird) ifTrue: [l remove: root majorThird].
	(l includes: root minorThird) ifTrue: [struct add: #min. l remove: root minorThird].
	(self notes: l contains: #(fifth augmentedFifth diminishedFifth)) ifFalse: [struct add: #no5].		
	(l includes: root diminishedFifth) ifTrue: [struct add: #dim5. l remove: root diminishedFifth].
	(l includes: root augmentedFifth) ifTrue: [struct add: #aug5. l remove: root augmentedFifth].
	(l includes: root perfectFifth) ifTrue: [ l remove: root perfectFifth].

	((l includes: root minorSeventh) and: [(struct includes: #dim5) and: [struct includes: #min]])
			ifTrue: [struct add: #halfDim7; remove: #dim5; remove: #min. l remove: root minorSeventh].
	(l includes: root minorSeventh) ifTrue: [struct add: 7. l remove: root minorSeventh].
	(l includes: root majorSeventh) ifTrue: [struct add: #maj7. l remove: root majorSeventh].
	((l includes: root diminishedSeventh) and: [(struct includes: #dim5) and: [struct includes: #min]])
			ifTrue: [struct add: #dim7; remove: #dim5; remove: #min. l remove: root diminishedSeventh].
	(l includes: root diminishedSeventh)
			ifTrue: [struct add: #dim7. l remove: root diminishedSeventh].

	((struct includes: #no7) not and: [((self notes: l contains: #(ninth augmentedNinth diminishedNinth)) and: [(self notes: notes contains: #(minorSeventh majorSeventh diminishedSeventh)) not])]) ifTrue: [struct add: #no7].
	(l includes: root ninth) ifTrue: [struct add: 9. l remove: root ninth].
	(l includes: root diminishedNinth) ifTrue: [struct add: #dim9. l remove: root diminishedNinth].
	(l includes: root augmentedNinth) ifTrue: [struct add: #aug9. l remove: root augmentedNinth].

	((struct includes: #no9) not and:
		[((self notes: l contains: #(eleventh augmentedEleventh)) and:
			[(self notes: notes contains: #(ninth augmentedNinth diminishedNinth)) not])])
	ifTrue: [struct add: #no9].
	((struct includes: #no7) not and: [((self notes: l contains: #(eleventh augmentedEleventh)) and: [(self notes: notes contains: #(minorSeventh majorSeventh diminishedSeventh)) not])]) ifTrue: [struct add: #no7].
	(l includes: root eleventh) ifTrue: [struct add: 11. l remove: root eleventh]. 
	(l includes: root augmentedEleventh) ifTrue: [struct add: #aug11. l remove: root augmentedEleventh]. 

	((self notes: l contains: #(thirteenth)) and:
		[(self notes: notes contains: #(minorSeventh majorSeventh)) not]) ifTrue: [struct add: #sixth. l remove: r thirteenth].
	((struct includes: #no11) not and:
		[((self notes: l contains: #(thirteenth diminishedThirteenth)) and:
			[(self notes: notes contains: #(eleventh augmentedEleventh)) not])]) ifTrue: [struct add: #no11].
	((struct includes: #no9) not and: [((self notes: l contains: #(thirteenth diminishedThirteenth)) and: [(self notes: notes contains: #(ninth augmentedNinth diminishedNinth)) not])]) ifTrue: [struct add: #no9].
	((struct includes: #no7) not and: [((self notes: l contains: #(thirteenth  diminishedThirteenth)) and: [(self notes: notes contains: #(minorSeventh majorSeventh diminishedSeventh)) not])]) ifTrue: [struct add: #no7].
	(l includes: root thirteenth) ifTrue: [struct add: 13. l remove: root thirteenth].
	(l includes: root diminishedThirteenth) ifTrue: [struct add: #dim13. l remove: root diminishedThirteenth].
	^struct! !

!Siren.PitchClassChord methodsFor: 'FP'!

natural
	^root natural! !

!Siren.PitchClassChord methodsFor: 'initializations'!

initAnalyse 
	possibleTonalities:= OrderedCollection new.
	notes := OrderedCollection new.
	self changed: #analyse; changed: #analysesPossibles!

initialize
	notes := OrderedCollection new.
	structure := ''.
	possibleTonalities := AnalysisList new.!

resetNotes
	"reset notes to an empty collection when an important change occurred"
	(notes isEmpty  or: [notes == nil])
		ifFalse: [notes := OrderedCollection new].
	(possibleTonalities isEmpty  or: [possibleTonalities == nil])
		ifFalse: [possibleTonalities := AnalysisList new]! !

!Siren.PitchClassChord methodsFor: 'accessing'!

possibleScales
	^self possibleTonalities collect: [:a | a scale]!

possibleTonalities 

	possibleTonalities isEmpty ifTrue: [self computePossibleTonalities].
	^possibleTonalities! !

!Siren.PitchClassChord methodsFor: 'compute possible tonalities'!

= c 
	^root = c root and: [structure = c structure]!

analyseIn: aScale
	"en majeure, mineure harm et min mel"

	| analysis |
	analysis := Siren.Analysis new degree: (aScale degreDeAccord: self ).
	analysis scale: aScale.
	^analysis!

computePossibleTonalities
	"self allInstancesDo: [:x| x computePossibleTonalities]"


	possibleTonalities := AnalysisList new.
	"Scale allSubclasses do:"
	Scale standardScales do:
		[:aScaleClass | possibleTonalities addAll: (self possibleTonalitiesInScaleClass: aScaleClass)].

	self changed: #analysesPossibles!

matchWith: c 
	"((Chord new fromString: 'D  min 7') computeAllNotes) format 
	matchAvec: ((N re majorScale genereAccordsPoly: 4) at: 3)."

	^structure = c structure!

possibleTonalitiesInScaleClass: s 
	"possible tonalities in scale class s. 
	(PitchClassChord newFromString: 'C  ') possibleTonalitiesInScaleClass:  MajorScale  AnalysisList ({I de C MajorScale} {IV de G MajorScale} {V de F MajorScale} )
	
	There is a problem here, related to invalid scales. If you ask for 
	instance the possible  tonalities of 'C# min', it will try to say that V of G# major is a 
	possible tonality. But the creation of G# major raises an error since it 
	is an invalid scale. For the moment I leave it as is because	I would 
	like to have a model of reasoning in an object-oriented setting first"

	| scale ana res c |
	"self format."
	res := Siren.AnalysisList new.
	scale := s root: PitchClass do.
	scale notes do: 
			[:n | 
			c := PitchClassChord root: n structure: structure copy.
			(c allNotesInScale: scale) ifTrue: 
					[ana := Siren.Analysis new degree: (scale degreeOfNote: n).
					ana scale: (s root: (self root pitchClass transposeOf: (n intervalBetween: PitchClass do))).
					res add: ana]].
	^res!

standardPossibleTonalities
	"possible tonalities in scale class major, minorMel and minorHarm 
	(Chord new fromString: 'C min') standardPossibleTonalities 
	ListeDAnalyses ({II de Sib MajorScale} {III de Lab MajorScale} {VI de 
	Mib MajorScale} {I de Do HarmonicMinorScale} {IV de Sol 
	HarmonicMinorScale} {I de Do MelodicMinorScale} {II de Sib 
	MelodicMinorScale} )"

	| res |
	res := OrderedCollection new.
	Scale standardScales do: [:s | res addAll: (self possibleTonalitiesInScaleClass: s)].
	^res!

tonalitesCommunesAvec: unAccord 
	"(FPChord newFromString: 'C min') tonalitesCommunesAvec: (FPChord 
	newFromString: 'D b ') "

	^self possibleTonalities tonalitesCommunesAvec: unAccord possibleTonalities!

tonalitesCommunesAvec: unAccord et: autreAccord
	"(FPChord newFromString: 'C min') tonalitesCommunesAvec: (FPChord 
	newFromString: 'D b ') "

	^self possibleTonalities tonalitesCommunesAvec: unAccord possibleTonalities 
						   et: autreAccord possibleTonalities! !

!Siren.PitchClassChord methodsFor: 'notes computation'!

computeAllNotes
	"computes the list of notes from the structure. The job is the opposite 
	of what is written is method fromListOfNotes. 
	Assumes root is not nil. 
	| c | 
	c := FPChord newFromString: 'A halfDim7'. 
	c computeAllNotes. 
	c notes"

	| structCopy |
	notes := OrderedCollection new.
	structCopy := structure copy.
	self computeRoot; computeThird; computeFifth; computeSixth; computeSeventh; computeNinth; computeEleventh; computeThirteenth	"; computeDiminished".
	structure isEmpty ifFalse: [^self error: 'bad structure : ', structure printString].
	structure := structCopy!

computeDiminished
	(structure includes: #dim7)
		ifTrue: 
			[notes := OrderedCollection
						with: root
						with: root minorThird
						with: root diminishedFifth
						with: root diminishedSeventh.
			structure remove: #dim7].
	(structure includes: #halfDim7)
		ifTrue: 
			[notes := OrderedCollection
						with: root
						with: root minorThird
						with: root diminishedFifth
						with: root minorSeventh.
			structure remove: #halfDim7]!

computeEleventh
	(structure includes: #no11)
		ifTrue: 
			[structure remove: #no11.
			^nil].
	(structure includes: 11)
		ifTrue: 
			[structure remove: 11.
			^notes add: root eleventh].
	(structure includes: #aug11)
		ifTrue: 
			[structure remove: #aug11.
			^notes add: root augmentedEleventh].
	(self structureHasEitherOf: #(13 #dim13 ))
		ifTrue: [^notes add: root eleventh]!

computeFifth
	((structure includes: #dim7)
		or: [structure includes: #halfDim7]) ifTrue: [^notes add: root diminishedFifth].
	(structure includes: #no5) ifTrue: [structure remove: #no5. ^nil].
	(structure includes: #dim5) ifTrue: [structure remove: #dim5. ^notes add: root diminishedFifth].
	(structure includes: #b5) ifTrue: [structure remove: #b5. ^notes add: root diminishedFifth].
	(structure includes: #aug5) ifTrue: [structure remove: #aug5. ^notes add: root augmentedFifth].
	notes add: root perfectFifth!

computeNinth

	(structure includes: #no9) ifTrue: [structure remove: #no9. ^nil].
	(structure includes: 9) ifTrue: [structure remove: 9. ^notes add: root ninth].
	(structure includes: #aug9) ifTrue: [structure remove: #aug9. ^notes add: root augmentedNinth].
	(structure includes: #dim9) ifTrue: [structure remove: #dim9. ^notes add: root diminishedNinth].
	(structure includes: #b9) ifTrue: [structure remove: #b9. ^notes add: root diminishedNinth].

	(self structureHasEitherOf: #(11 aug11 13 dim13))
		ifTrue: [notes add: root majorNinth]!

computeRoot
	(structure includes: #noRoot)
		ifTrue: [structure remove: #noRoot]
		ifFalse: [notes add: root]!

computeSeventh
	(structure includes: #dim7) ifTrue: [structure remove: #dim7. ^notes add: root diminishedSeventh].
	(structure includes: #halfDim7) ifTrue: [structure remove: #halfDim7. ^notes add: root minorSeventh].
	(structure includes: #no7) ifTrue: [structure remove: #no7. ^nil].
	(structure includes: 7) ifTrue: [structure remove: 7. ^notes add: root minorSeventh].
	(structure includes: #maj7) ifTrue: [structure remove: #maj7. ^notes add: root majorSeventh].

	
	(self structureHasEitherOf: #(9 dim9 aug9 11 aug11 13 dim13))
		ifTrue: [notes add: root minorSeventh]!

computeSixth
	(structure includes: 6)
		ifTrue: [structure remove: 6. ^notes add: root sixth].
	(structure includes: #sixth)
		ifTrue: [structure remove: #sixth. ^notes add: root sixth]!

computeThird
	((structure includes: #dim7)
		or: [structure includes: #halfDim7]) ifTrue: [^notes add: root minorThird].
	(structure includes: #no3) ifTrue: [structure remove: #no3. ^nil].
	(structure includes: #sus4) ifTrue: [structure remove: #sus4. ^notes add: root fourth].
	(structure includes: #min) ifTrue: [structure remove: #min. ^notes add: root minorThird].
	(structure includes: #m) ifTrue: [structure remove: #m. ^notes add: root minorThird].
	notes add: root majorThird!

computeThirteenth

	(structure includes: 13) ifTrue: [structure remove: 13. ^notes add: root thirteenth].
	(structure includes: #dim13) ifTrue: [structure remove: #dim13. ^notes add: root diminishedThirteenth].
	(structure includes: #b13) ifTrue: [structure remove: #b13. ^notes add: root diminishedThirteenth].
	(structure includes: #no13)
		ifTrue: 	[structure remove: #no13.	^nil].!

notes
	notes isEmpty ifTrue: [self computeAllNotes].
	^notes!

notesWithinOctave
	"accordingly, return the notes as in the case of a four note chord
	with no higher dissonances"

	| col |
	col := OrderedCollection  with: self theTonic
							with: self theThird
							with: self theFifth
							with: self theSeventh.
	^col select: [:each | (each == nil) not].! !

!Siren.PitchClassChord methodsFor: 'note testing'!

allNotesInScale: aScale  
	"The previous version couldnt deal with situations like
	  (FPChord newFromString: 'C  7 aug9')  possibleTonalitiesInScaleClass:  MajorScale"

	self notesWithinOctave do: [:n | (aScale notes includes: n)
			ifFalse: [^false]].
	^true!

chordNotesAmong: list
	"select among given notes those that are chord notes"
	^list select: [:each |
		self containsNote: each]!

containsNote: n
	^(self notes detect: [:each | each pitchClass pitchEqual: n pitchClass]
			ifNone: [nil]) notNil!

nextIn: aCS
	^aCS chordAfter: self!

nonChordNotesAmong: list
	"select among given notes those that are chord notes"

	^list select: [:each |
		(self containsNote: each) not]!

notes: aListOfNotes contains: anArrayOfIntervals 
	anArrayOfIntervals do: [:i | (aListOfNotes includes: (root perform: i))
			ifTrue: [^true]].
	^false! !

!Siren.PitchClassChord methodsFor: 'private-pact'!

bestTonalityInIsolatedCase
	"answer the most plausible tonality when the chor is isolated.
	Later, I will rewrite it to bypass possibleTonalities for sake of efficience"

	| list  candidate |
	list := self possibleTonalities.
	candidate := list first.
	self isDominant
		ifTrue: [^list detect: [:each | each degree = 5] ifNone: [candidate]].
	"the minor scale whose first degree is equal to root is preferred"
	self isMinor
		ifTrue: [^list detect: [:each | each scale isMinor and: [each degree = 1]] 
				     ifNone: [list detect: [:each | each scale isMinor]
						    ifNone: [candidate]]].
	"root is the first degree"
	^list detect: [:each | each degree = 1] ifNone: [candidate].! !

!Siren.PitchClassChord methodsFor: 'testing ok'!

commonTonalitiesWith: aChord
	^self possibleTonalities tonalitesCommunesAvec: aChord possibleTonalities!

hasA: anInterval 
	"(FPChord newFromString: 'C min 7') hasA: #majorThird"

	^self notes includes: (self root perform: anInterval)!

hasADiminishedFifth
	^(((structure includes: #halfDim7) 
		or: [structure includes: #dim7])
		or: [structure includes: #dim5])!

hasADiminishedSeventh
	^structure includes: #dim7!

hasAMajorSeventh
	^(structure includes: #maj7)!

hasAMinorSeventh
	^self structureHasEitherOf: #(7 #halfDim7 )!

hasAnAugmentedFifth
	^structure includes: #aug5!

hasNoFifth
	^structure includes: #no5!

hasNoSeventh
	^(structure includes: #no7)!

isAlterate
	^(self isDominant 
		and: [self hasNoFifth])
		and: [self structureHasEitherOf: #(dim9 13)].!

isDiminished
	^(structure includes: #dim7)!

isDominant
	^self isMajor
		and: [self hasAMinorSeventh].!

isHalfDiminished
	^structure includes: #halfDim7!

isMajor
	^self isMinor not!

isMinor
	^self structureHasEitherOf: #( min  halfDim7 dim7)!

isSuspended
	^(structure includes: #sus4)!

structureHasEitherOf: aList 
	^(aList detect: [:x | structure includes: x]
		ifNone: [ nil]) notNil!

structureHasNeitherOf: aList 
	^(aList detect: [:x | structure includes: x]
		ifNone: [^true]) notNil! !

!Siren.PitchClassChord methodsFor: 'transposing'!

beTransposedBy: int 
	| no |
	no := self notes.
	root := root transposeOf: int.
	notes := no collect: [:n | n transposeOf: int]!

transposeOf: interval 
	^self class root: (root transposeOf: interval)
		structure: structure! !

!Siren.PitchClassChord methodsFor: 'other computations'!

intervalBetweenRoots: aChord
	"remark: not that this method answers the interval between 
	the root *pitch classes*!!!!"
	"('G min 7' asChordOct: 2) intervalBetweenRoots:  ('F maj7' asChordOct: 2)"

	^self root pitchClass intervalBetween: aChord root pitchClass! !

!Siren.PitchClassChord methodsFor: 'tessitura'!

rootInTessitura: qt
	^root inTessitura: qt! !



Smalltalk.Siren defineClass: #Triad
	superclass: #{Siren.PitchClassChord}
	indexedType: #none
	private: false
	instanceVariableNames: 'type '
	classInstanceVariableNames: ''
	imports: ''
	category: 'Music-PitchClasses'!

!Siren.Triad methodsFor: 'type'!

type
	^type!

type: t 
	type := t! !

!Siren.Triad methodsFor: 'notes'!

notes: x 
	notes := x! !



Smalltalk.Siren defineClass: #PitchClassDoubleSharp
	superclass: #{Siren.PitchClassAltered}
	indexedType: #none
	private: false
	instanceVariableNames: ''
	classInstanceVariableNames: ''
	imports: ''
	category: 'Music-PitchClasses'!

!Siren.PitchClassDoubleSharp methodsFor: 'testing'!

isDoubleSharp
	^true! !

!Siren.PitchClassDoubleSharp methodsFor: 'printing'!

printOn: s 
	natural printOn: s.
	s nextPutAll: '##'!

storeOn: s 
	"N C sharp sharp storeString"

	s nextPutAll: 'N ' , self natural name , ' sharp sharp'! !

!Siren.PitchClassDoubleSharp methodsFor: 'saving'!

representBinaryOn: s
	^MessageSend receiver: natural selector:  #doubleSharp! !

!Siren.PitchClassDoubleSharp methodsFor: 'intervals'!

alterate: note toReach: i 
	| n |
	n := natural alterate: note toReach: i.
	^n sharp sharp!

alterateBelow: note toReach: i 
	| n |
	n := natural alterateBelow: note toReach: i.
	^n sharp sharp!

closestEnharmonic
	^self alterate: self following toReach: 0.!

semiTonesToNatural
	^-2! !

!Siren.PitchClassDoubleSharp methodsFor: 'access'!

flat
	"la methode diese n'est pas definie et provoque donc une erreur"

	^natural sharp!

semiToneCount
	^natural semiToneCount + 2!

sharp
	"Sorry, I have to do that (Cf. Bluesette) otherwise I can't 
	compute possibleTonalities properly ..."

	^nil! !



Smalltalk.Siren defineClass: #Signature
	superclass: #{Core.Object}
	indexedType: #none
	private: false
	instanceVariableNames: 'sharps flats '
	classInstanceVariableNames: ''
	imports: ''
	category: 'Music-PitchClasses'!

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!


!Siren.Signature class methodsFor: 'creation'!

choseSignature
	"Signature choseSignature"

	| choice s |
	s := Signature new.
	choice := Dialog 

		choose: 'Choose a signature' 

		fromList: #('no sharp/falt [C Major]' '1 sharp [G Major]' '2 sharps [D Major]' '3 sharps [A Major]' '4 sharps [E Major]' '5 sharps [B Major]' '6 sharps [F# Major]' '7 sharps [C# Major]' '1 flat [F Major]' '2 flats [Bb Major]' '3 flats [Eb Major]' '4 flats [Ab Major]' '5 flats [Dd Major]' '6 flats [Gg Major]' '7 flats [Cb Major]' ) 

		values: (1 to: 15)

		lines: 15

		cancel: [nil] .

	choice == nil ifTrue: [^s].
	choice < 9
		ifTrue: [s nbSharps: choice - 1]
		ifFalse: [s nbFlats: choice - 8].
	^s!

fromTonality: aScale 
	"Signature fromTonality: N E flat majorScale"

	^self new sharps: aScale sharpNotesInSignature flats: aScale flatNotesInSignature!

new
^super new initialize!

sharps: s flats: f
	^self new sharps: s flats: f! !

!Siren.Signature class methodsFor: 'examples'!

example
	^Signature choseSignature!

example2
	"Signature new tonality -> C MajorScale
	(Signature new nbSharps: 4) tonality -> E MajorScale	 
	(Signature new nbFlats: 3) tonality -> Eb MajorScale"!

example3
"	Signature fromTonality: N D majorScale
	Signature fromTonality: N E flat majorScale"!

example4
	"Signatures may be created for illegal scales. However, method 
	tonality yields an error for these scales: 
	
	Signature fromTonality: N D minorScale -> 1 sharps; 1 flats 
	Signature sharps: (Array with: N F sharp) flats: (Array with: (N E flat)) -> 1 sharps; 1 flats
	(Signature fromTonality: N D minorScale) tonality -> error"! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!


Siren.Signature comment:
'Notion of signature is related to the notion of "legal" scales, i.e.
scales having only sharps OR flats in their signature.
So method tonality here works only for legal scales.
It should possible to compute the tonality for arbitrary scales though,
but I am not sure how'!

!Siren.Signature methodsFor: 'tonality'!

tonality
	(sharps isEmpty not and: [flats isEmpty not])
		ifTrue: [^self error: 'tonality is difficult to compute'].
	(sharps isEmpty and: [flats isEmpty])
		ifTrue: [^N C majorScale].
	flats isEmpty ifTrue: [^self sharpsInRightOrder
			ifTrue: [sharps last natural following majorScale]
			ifFalse: [self error: 'tonality is difficult to compute']].
	sharps isEmpty ifTrue: [^self flatsInRightOrder
			ifTrue: [flats size = 1
					ifTrue: [^N F majorScale]
					ifFalse: [(flats at: flats size - 1) majorScale]]
			ifFalse: [self error: 'tonality is difficult to compute']]! !

!Siren.Signature methodsFor: 'printing'!

printOn: s
	s nextPutAll: sharps size printString,' sharps; ',flats size printString,' flats'!

storeOn: s 
	self isLegal ifTrue: [^s nextPutAll: 'Signature fromTonality: ' , self tonality root storeString , ' majorScale'].
	s nextPutAll: 'Signature sharps: ' , sharps storeString , ' flats: ' , flats storeString! !

!Siren.Signature methodsFor: 'testing'!

flatsInRightOrder
	| allFlats |
	allFlats := PitchClass flatOrdering.
	1 to: flats size do: [:i | (flats at: i) natural = (allFlats at: i) natural ifFalse: [^false]].
	^true!

isEmpty
	^sharps isEmpty and: [flats isEmpty]!

isLegal
	^self flatsInRightOrder and: [self sharpsInRightOrder]!

sharpsInRightOrder
	| allSharps |
	allSharps := PitchClass sharpOrdering.
	1 to: sharps size do: [:i | (sharps at: i) natural = (allSharps at: i) natural ifFalse: [^false]].
	^true! !

!Siren.Signature methodsFor: 'access'!

alterate: aNaturalNote
	sharps do: [:s | s natural = aNaturalNote pitchClass ifTrue: [^aNaturalNote sharp]].
	flats do: [:s | s natural = aNaturalNote pitchClass ifTrue: [^aNaturalNote flat]].
	^aNaturalNote!

flats
	^flats!

initialize
	sharps := OrderedCollection new.
	flats := OrderedCollection new!

nbFlats: n
	sharps := OrderedCollection new.
	flats := PitchClass nFirstFlats: n.!

nbSharps: n 
	flats := OrderedCollection new.
	sharps := PitchClass nFirstSharps: n!

reOrderSharpsAndFlats
	"attempts to reorder flats and sharps according to the natural order as found in 
	PitchClass"

	| allFlats allSharps |
	allFlats := PitchClass flatOrdering.
	allSharps := PitchClass sharpOrdering.
	flats := (flats asSortedCollection: [:a :b | (allFlats indexOf: a natural)
					<= (allFlats indexOf: b natural)]) asOrderedCollection.
	sharps := (sharps asSortedCollection: [:a :b | (allSharps indexOf: a natural)
					<= (allSharps indexOf: b natural)]) asOrderedCollection!

sharps
	^sharps!

sharps: s flats: f 
	"attempts to reorder flats and sharps according to the natural order as found in 
	PitchClass"

	sharps := s.
	flats := f.
	self reOrderSharpsAndFlats! !



Smalltalk.Siren defineClass: #OctaveDependentNote
	superclass: #{Core.Object}
	indexedType: #none
	private: false
	instanceVariableNames: 'oct pc midiPitch natural '
	classInstanceVariableNames: ''
	imports: ''
	category: 'Music-PitchClasses'!

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!


!Siren.OctaveDependentNote class methodsFor: 'examples'!

examples
"(N do octave: 3) minorThird sharp sharp E#3

(N C octave: 3) semiTonesWith: (N la  octave: 4) 21

(#(do re mi fa sol la si ) collect: [:x | (N perform: x) octave: 3])
	collect: [:y | y - #octave]

(N B octave: 3) intervalBetween: (N B flat octave: 4)
(N B octave: 3) intervalBetween: (N B flat octave: 2)

(N C octave: 3) intervalBetween: (N C octave: 2)    descending  octave
(N C octave: 2) intervalBetween: (N C octave: 3)   octave
 "! !

!Siren.OctaveDependentNote class methodsFor: 'vocal ranges'!

altoRange
	"retourne la collection des notes de l'alto"

	^self from: (N sol octave: 3)
		to: (N re octave: 5)!

altoRangeInScale: aScale
	"OctaveDependentNote sopranoRangeInScale: (N do sharp minorScale)"

	^aScale diatonicNotesFrom: (N sol octave: 3)
		to: (N re octave: 5)!

baseRange
	"retourne la collection des notes de la basse"

	^self from: (N sol octave: 2)
		to: (N re octave: 4)!

baseRangeInScale: aScale
	"OctaveDependentNote sopranoRangeInScale: (N do sharp minorScale)"

	^aScale diatonicNotesFrom: (N sol octave: 2)
		to: (N re octave: 4)!

sopranoRange
	"retourne la collection des notes du soprano"

	^self from: (N re octave: 4)
		to: (N do octave: 6)!

sopranoRangeInScale: aScale
	"OctaveDependentNote sopranoRangeInScale: (N do sharp minorScale)"

	^aScale diatonicNotesFrom: (N re octave: 4)
		to: (N do octave: 6)!

tenorRange
	"retourne la collection des notes du tenor"

	^self from: (N re octave: 3)
		to: (N la octave: 4)!

tenorRangeInScale: aScale
	"OctaveDependentNote sopranoRangeInScale: (N do sharp minorScale)"

	^aScale diatonicNotesFrom: (N re octave: 3)
		to: (N la octave: 4)! !

!Siren.OctaveDependentNote class methodsFor: 'creation'!

from: aNote to: n2 
	| r b |
	r := OrderedCollection new.
	b := aNote.
	r add: b.
	[b following >= n2]
		whileFalse: 
			[b := b following.
			r add: b].
	^r!

fromMidiPitch: n 
	"yields the note that has n as midiPitch. Only natural and sharp 
	notes are created as there is no possible way of knowing the 
	intention"
	"C3 is 60.
	C0 is 24
	C-2 is 0"
"OctaveDependentNote fromMidiPitch: 24"

	| o delta  |
	o := (n  quo: 12) - 2.  
	delta := (n + 1  \\ 12).
	delta = 1 ifTrue: [^(N C  octave: o)].
	delta = 2 ifTrue: [^(N C sharp octave: o)].
	delta = 3 ifTrue: [^(N D octave: o)].
	delta = 4 ifTrue: [^(N D sharp octave: o)].
	delta = 5 ifTrue: [^(N E octave: o)].
	delta = 6 ifTrue: [^(N F octave: o)].
	delta = 7 ifTrue: [^(N F sharp octave: o)].
	delta = 8 ifTrue: [^(N G octave: o)].
	delta = 9 ifTrue: [^(N G sharp octave: o)].
	delta = 10 ifTrue: [^(N A octave: o)].
	delta = 11 ifTrue: [^(N A sharp octave: o)].
	delta = 0 ifTrue: [^(N B octave: o)]!

named: s 
	"self named: 'Re#2'"

	| o |
	o := s last.
	^(PitchClass noteNamed: (s copyFrom: 1 to: s size - 1))
		octave: o asInteger - 48!

octave: o pc: pc
	^self new oct: o; pitchClass: pc! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!


Siren.OctaveDependentNote comment:
'Instances of this class represent octave dependent notes.
	pc : the pitch class of the note (takes enharmonic spelling into account)
	octave: integer from 0 to .., represent the octave. 
Middle C is therefore represented by 
	pc : C
	octave: 4
Defines methods to compute intervals, midiPitches, and lots
of thing that PitchClass implements too.
So why not make this class and PitchClass have
a common superclass, to factor out common computations ?
Ontological questions :
	how to compute an interval between two octave-dependent notes,
since their ambitus may be arbitrarily large (no question of computing 25th intervals).
So intervals should be reduced to thirteenth, i.e. :
	octaves should be taken into account only in a 0/1 manner'!

!Siren.OctaveDependentNote methodsFor: 'alterations'!

flat
	^pc flat octave: oct!

isDoubleFlat
	^pc isDoubleFlat!

isDoubleSharp
	^pc isDoubleSharp!

isFlat
	^pc isFlat!

isNatural
	^pc isNatural!

isSharp
	^pc isSharp!

natural
	natural == nil ifTrue: [natural := pc natural octave: oct].
	^natural!

sharp
	^pc sharp octave: oct! !

!Siren.OctaveDependentNote methodsFor: 'leading'!

isLeadingToneTo: n
	| int |
	int := (self intervalBetween: n).
	^int type = 2 
		or: [int semiTones = 1]!

lowerLeadingToneInScale: s
	^s noteBefore: self!

upperLeadingToneInScale: s
	^s noteAfter: self! !

!Siren.OctaveDependentNote methodsFor: 'public intervals'!

alterate: note toReach: i 
	"Join semitons to note in order to obtain the required number of 
	semitones with self. 
	Redefined here because interval computation must take octave 
	into account ..."

	| delta |
	delta := (self semiTonesWith: note) - i.
	delta = 0 ifTrue: [^note].
	delta = 1 ifTrue: [^note flat].
	delta = -1 ifTrue: [^note sharp].
	delta = 2 ifTrue: [^note flat flat].
	delta = -2 ifTrue: [^note sharp sharp].
	delta = 3 ifTrue: [^note flat flat flat].	"to deal with cases like N B flat flat augmentedOctave"
	delta = -3 ifTrue: [^note sharp sharp sharp].
	^self error: 'illegal interval !!'!

alterateBelow: note toReach: i 
	"Join semitons to note in order to obtain the required number of 
	semitones with self. 
	Redefined here because interval computation must take octave 
	into account ..."

	| delta |
	delta := (note semiTonesWith: self) - i.
	delta = 0 ifTrue: [^note].
	delta = 1 ifTrue: [^note sharp].
	delta = -1 ifTrue: [^note flat].
	delta = 2 ifTrue: [^note sharp sharp ].
	delta = -2 ifTrue: [^note flat flat].
	delta = 3 ifTrue: [^note flat flat flat].	"to deal with cases like N B flat flat augmentedOctave"
	delta = -3 ifTrue: [^note sharp sharp sharp].
	^self error: 'illegal interval !!'!

augmentedEleventh
	^MusicalInterval augmentedEleventh topIfBottomIs: self!

augmentedFifth
	^MusicalInterval augmentedFifth topIfBottomIs: self!

augmentedFourth
	^MusicalInterval augmentedFourth topIfBottomIs: self!

augmentedNinth
	^MusicalInterval augmentedNinth topIfBottomIs: self!

augmentedOctave
	^MusicalInterval augmentedOctave topIfBottomIs: self!

augmentedSecond
	^MusicalInterval augmentedSecond topIfBottomIs: self!

diminishedFifth
	^MusicalInterval diminishedFifth topIfBottomIs: self!

diminishedNinth
	^MusicalInterval diminishedNinth topIfBottomIs: self!

diminishedOctave
	^MusicalInterval diminishedOctave topIfBottomIs: self!

diminishedSeventh
	^MusicalInterval diminishedSeventh topIfBottomIs: self!

diminishedThirteenth
	^MusicalInterval diminishedThirteenth topIfBottomIs: self!

eleventh
	^MusicalInterval eleventh topIfBottomIs: self!

fifth
	^MusicalInterval fifth topIfBottomIs: self!

flatFifth
	^MusicalInterval flatFifth topIfBottomIs: self!

flatNinth
	^MusicalInterval flatNinth topIfBottomIs: self!

flatThirteenth
	^MusicalInterval flatThirteenth topIfBottomIs: self!

fourth
	^MusicalInterval fourth topIfBottomIs: self!

majorNinth
	^MusicalInterval majorNinth topIfBottomIs: self!

majorSecond
	^MusicalInterval majorSecond topIfBottomIs: self!

majorSeventh
	^MusicalInterval majorSeventh topIfBottomIs: self!

majorSixth
	^MusicalInterval majorSixth topIfBottomIs: self!

majorThird
	^MusicalInterval majorThird topIfBottomIs: self!

majorThirteenth
	^MusicalInterval majorThirteenth topIfBottomIs: self!

minorNinth
	^MusicalInterval minorNinth topIfBottomIs: self!

minorSecond
	^MusicalInterval minorSecond topIfBottomIs: self!

minorSeventh
	^MusicalInterval minorSeventh topIfBottomIs: self!

minorSixth
	^MusicalInterval minorSixth topIfBottomIs: self!

minorThird
	^MusicalInterval minorThird topIfBottomIs: self!

minorThirteenth
	^MusicalInterval minorThirteenth topIfBottomIs: self!

ninth
	^MusicalInterval ninth topIfBottomIs: self!

octave
	^MusicalInterval octave topIfBottomIs: self!

perfectEleventh
	^MusicalInterval perfectEleventh topIfBottomIs: self!

perfectFifth
	^MusicalInterval perfectFifth topIfBottomIs: self!

perfectFourth
	^MusicalInterval perfectFourth topIfBottomIs: self!

second
	^MusicalInterval second topIfBottomIs: self!

seventh
	^MusicalInterval seventh topIfBottomIs: self!

sixth
	^MusicalInterval sixth topIfBottomIs: self!

thirteenth
	^MusicalInterval thirteenth topIfBottomIs: self!

unison
	^self! !

!Siren.OctaveDependentNote methodsFor: 'mutations'!

duration: d
	^MusicEvent dur: d pitch: self! !

!Siren.OctaveDependentNote methodsFor: 'printing'!

printOn: s 
	pc printOn: s.
	s nextPutAll: oct printString.!

storeOn: s 
	"(N C sharp sharp octave: 3) storeString = '(N C sharp sharp @ 3)'"

	s nextPut: $(.
	s nextPutAll: pc storeString.
	s nextPutAll: ' @ ' , oct printString.
	s nextPut: $)! !

!Siren.OctaveDependentNote methodsFor: 'private-pacts'!

respectsBassTessitura
	^true
	"self >= BassPlayer minPitch
		and: [self <= BassPlayer maxPitch]"! !

!Siren.OctaveDependentNote methodsFor: 'access'!

oct
	^oct!

oct: o 
	oct := o.
	midiPitch := nil.
	natural := nil!

octave: o
	self oct: o.!

pitchClass
	^pc!

pitchClass: aPc 
	pc := aPc.
	midiPitch := nil.
	natural := nil! !

!Siren.OctaveDependentNote methodsFor: 'mutations more'!

dottedEighth
	^self lapse: Lapse dottedEighth!

dottedFull
	^self lapse: Lapse dottedFull!

dottedHalf
	^self lapse: Lapse dottedHalf!

dottedQuarter
	^self lapse: Lapse dottedQuarter!

eighth
	^self lapse: Lapse eighth!

eighthInTriplet
	^self lapse: Lapse eighthInTriplet!

full
	^self lapse: Lapse full!

half
	^self lapse: Lapse half!

quarter
	^self lapse: Lapse quarter!

quarterInTriplet
	^self lapse: Lapse quarterInTriplet!

sixteenth
	^self lapse: Lapse sixteenth! !

!Siren.OctaveDependentNote methodsFor: 'comparing'!

< aNote
	^self midiPitch < aNote midiPitch!

<= aNote
	^self midiPitch <= aNote midiPitch!

= x 

	^(pc == x pitchClass) and: [oct == x oct]!

> aNote
	^self midiPitch > aNote midiPitch!

>= aNote
	^self midiPitch >= aNote midiPitch!

hash
	^super hash * oct!

isNearerTo: n1 than: n2

	^(self semiTonesWith: n1) abs < (self semiTonesWith: n2) abs!

isbetween: n1 and: n2
	^n1 < self and: [self < n2]!

midiPitchEquals: aNote
	^self midiPitch = aNote midiPitch!

pitchEqual: aNote 
	^self midiPitchEquals: aNote!

theNearestPitch: list
	"(N A flat @ 2) theNearestPitch: (Array with:  (N C  @ 2) with: (N C @ 3))"
	| nearest |
	nearest := list at: 1.
	2 to: list size do: 
		[:i |
		(self isNearerTo: (list at: i) than: nearest)
			ifTrue: [nearest :=  (list at: i)]].
	^nearest! !

!Siren.OctaveDependentNote methodsFor: 'intervals'!

closestEnharmonic

	| new |
	new :=  self pitchClass enharmonic octave: oct.
	new midiPitch = self midiPitch
		ifTrue: [^new].
	new midiPitch < self midiPitch
		ifTrue: [^new octave: oct + 1].
	new midiPitch > self midiPitch
		ifTrue: [^new octave: oct - 1].!

diatonicStepsTo: aNote 
	"returns the number of diatonic steps to aNote"
	"(N B octave: 3) diatonicStepsTo: (N C octave: 4)"

	| all |
	all := PitchClass naturalNotes.
	^((aNote oct - oct) * 7) + ((all indexOf: aNote pitchClass natural) - (all indexOf: pc natural))!

following
	"the next diatonic note of self's natural note"
	"(N C octave: 2) following"
	| nat |
	nat := self natural.
	^ nat pitchClass following octave: (nat pitchClass = N si
			ifTrue: [oct + 1]
			ifFalse: [oct])!

newdiatonicStepsTo: aNote 
	"returns the number of diatonic steps to aNote"
	"(N B octave: 3) diatonicStepsTo: (N C octave: 4)"

	| all |
	all := PitchClass naturalNotes.
	^((aNote oct - oct) * 7) + ((all indexOf: aNote pitchClass natural) - (all indexOf: pc natural))!

nthFollowing: i 
	"yields the nth diatonic note following self. 
	Takes octave shifts into account"

	| nth |
	(i < 0) ifTrue: [^self nthPreceding: i negated].
	nth := self.
	i timesRepeat: [nth := nth following].
	^nth!

nthPreceding: i 
	"yields the nth diatonic note preceding self. 
	Takes octave shifts into account"

	| nth |
	(i < 0) ifTrue: [^self nthFollowing: i negated].
	nth := self.
	i timesRepeat: [nth := nth preceding].
	^nth!

oldEquals: x 
	"important pour l'integrite des operations sur les melodies"

	^self == x!

olddiatonicStepsTo: aNote 
	"returns the number of diatonic steps to aNote"
	"(N C octave: 4) diatonicStepsTo: (N D octave: 2)"

	| b b2 n |
	n := 0.
	b := self natural.
	b2 := aNote natural. self halt.
	b <= b2
		ifTrue: 
			[[b2 <= b]
				whileFalse: 
					[b := b following.
					n := n + 1].
			^n].
	b >= b2
		ifTrue: 
			[[b2 >= b]
				whileFalse: 
					[b := b preceding.
					n := n - 1].
			^n]!

preceding
	"the next diatonic note of self's natural note"
	"(N C sharp octave: 3) preceding"
	| nat |
	nat := self natural.
	^nat pitchClass preceding octave: (nat pitchClass == PitchClassDo
			ifTrue: [oct - 1]
			ifFalse: [oct])!

semiToneCount
	"related to OctaveDependentNote fromMidiPitch"

	^pc semiToneCount + (oct + 2 * 12) - 1!

semiTonesWith: aNote
	^aNote semiToneCount - self semiToneCount! !

!Siren.OctaveDependentNote methodsFor: 'interval testing'!

intervalBetween: aNote 
	"returns the interval between the two octaveDependentNotes. 
		Assume that aNote is really a OctaveDependentNote"

	| type |

	type := self intervalTypeBetween: aNote.
	(self natural < aNote natural
		or: [self natural = aNote natural 
			and: [self <= aNote]])
		ifTrue: [^MusicalInterval type: type semiTones: (self semiTonesWith: aNote)].
	(self natural > aNote natural
		or: [self natural = aNote natural 
			and: [self > aNote]])
		ifTrue: [^MusicalDescendingInterval type: type semiTones: (aNote semiTonesWith: self)].
	^self error: 'it doesnt work'.!

intervalTypeBetween: aNote 
	"returns the type of the interval between the two notes modulo one 
	octave
	(N C octave: 6) intervalTypeBetween: (N re octave: 3)	"

	| b b2 type |
	type := 1.
	b := self natural.
	b2 := aNote natural.
	b <= b2
		ifTrue: 
			["ascending interval"
			[b2 midiPitchEquals: b]
			whileFalse: 
				[b := b following.
				type := type + 1]]
		ifFalse: 
			["descending interval"
			[b2 midiPitchEquals: b]
			whileFalse: 
				[b := b preceding.
				type := type + 1]].
	^type!

isLessThanA: interval from: od
	" ascending or descending direction"
	| int |
	interval isSymbol
		ifTrue: [int := MusicalInterval perform: interval]
		ifFalse: [int := interval].
	^(self intervalBetween: od)  < int!

realIntervalTypeBetween: aNote 
	"returns the type of the interval between the two notes	
	(N C octave: 6) realIntervalTypeBetween: (N C octave: 3) "

	| b b2 type temp |
	type := 1.
	b := self natural.
	b2 := aNote natural.
	b > b2
		ifTrue: 
			[temp := b2.
			b2 := b.
			b := temp].
	[b2 oct = b oct and: [b2 pitchClass = b pitchClass]]
		whileFalse: 
			[b := b following.
			type := type + 1].
	^type!

testIntervalsFrom: pitch1 to: pitch2
	"(N C sharp @ 3) testIntervalsFrom: (N A @ 1) to: (N A @ 4)"
	| odn ena |
	pitch1 midiPitch to: pitch2 midiPitch do: [:mp |
		odn := OctaveDependentNote fromMidiPitch: mp.
		Transcript show: self printString, ' intervalBetween: ', odn printString, ' = ' ,
					(self intervalBetween: odn) printString; cr.
		ena := odn closestEnharmonic.
		ena = odn
			ifFalse: [Transcript show: self printString, ' intervalBetween: ', ena printString, ' = ' ,
					(self intervalBetween: ena) printString; cr]]! !

!Siren.OctaveDependentNote methodsFor: 'constraining'!

intervalTypeModuloOctaveBetween: n 



	^(self intervalTypeBetween: n) - 1 \\ 7+ 1! !

!Siren.OctaveDependentNote methodsFor: 'modifying'!

inTessitura: qualTessitura
	"modify octave according to the given tessitura"

	self oct: (pc inTessitura: qualTessitura) oct! !

!Siren.OctaveDependentNote methodsFor: 'transpose'!

beDownAnOctave
	^self octave: oct - 1!

beTransposedBy: i 
	| n |
	n := self transposeOf: i.
	oct := n oct.
	pc := n pitchClass.
	midiPitch := n midiPitch.
	natural := nil!

beTransposedOneStepDown
	"used by the score editor as diatonic step!!"

	| n |
	n := self preceding.
	oct := n oct.
	pc := n pitchClass.
	midiPitch := nil.
	natural := nil!

beTransposedOneStepUp
	"used by the score editor as diatonic step!!"

	| n |
	n := self following.
	oct := n oct.
	pc := n pitchClass.
	midiPitch := nil.
	natural := nil!

beUpAnOctave
	^self octave: oct + 1!

downAnOctave
	^OctaveDependentNote octave: oct - 1 pc: pc!

setPitchTo: aPitch 
	oct := aPitch oct.
	pc := aPitch pitchClass.
	midiPitch := aPitch midiPitch.
	natural := nil!

switchTo: aNote 
	pc := aNote pitchClass.
	oct := aNote oct.
	midiPitch := aNote midiPitch.
	natural := nil!

transposeOf: anInterval 
	"three cases: integer (+/-), method name (= ascending interval), or interval 
	object"

	anInterval isInteger ifTrue: [^(ChromaticInterval semiTones: anInterval)
			from: self].
	anInterval isSymbol ifTrue: [^self perform: anInterval].
	(anInterval isKindOf: MusicalInterval) ifTrue: [^anInterval topIfBottomIs: self].
	^self error: 'type d''intervalle indefini'!

upAnOctave
	^OctaveDependentNote octave: oct + 1 pc: pc! !

!Siren.OctaveDependentNote methodsFor: 'accessing delegation'!

downAndUpOctaves: odNote
	^pc downAndUpOctaves: odNote! !



Smalltalk.Siren defineClass: #ChromaticInterval
	superclass: #{Siren.MusicalInterval}
	indexedType: #none
	private: false
	instanceVariableNames: ''
	classInstanceVariableNames: ''
	imports: ''
	category: 'Music-PitchClasses'!

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!


!Siren.ChromaticInterval class methodsFor: 'creation'!

semiTones: x 
	"anInterval without type, only chromatic"

	^self type: -1 semiTones: x! !

!Siren.ChromaticInterval class methodsFor: 'examples'!

examples
"(N C octave: 3) transposeBySemiTones: 4  ->  E3"! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!


Siren.ChromaticInterval comment:
'ChromaticInterval commentStamp: ''<historical>'' prior: 0!!
used to produce intervals with no names, measured only in terms
of a number of semie tones (for non-tonal music)'!

!Siren.ChromaticInterval methodsFor: 'printing'!

printOn: s 
	s nextPutAll: 'Chromatic ' , semiTones printString! !



Smalltalk.Siren defineClass: #ChordNameEditor
	superclass: #{UI.ApplicationModel}
	indexedType: #none
	private: false
	instanceVariableNames: 'pitchClass pitchClassIndex structure seventh eleventh root ninth fifth third thirteenth noteNames '
	classInstanceVariableNames: ''
	imports: ''
	category: 'Music-PitchClasses'!

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!


!Siren.ChordNameEditor class methodsFor: 'interface specs'!

windowSpec
	"UIPainter new openOnClass: self andSelector: #windowSpec"
 
	^#(#FullSpec #window: #(#WindowSpec #label: 'Chord Name Editor' #min: #(#Point 20 20 ) #bounds: #(#Rectangle 87 495 481 870 ) #flags: 8 ) #component: #(#SpecCollection #collection: #(#(#SliderSpec #layout: #(#LayoutFrame 0 0.0297297 0 0.041791 0 0.118919 0 0.701493 ) #model: #pitchClassIndex #orientation: #vertical #start: 1 #stop: 21 #step: 1 ) #(#InputFieldSpec #layout: #(#LayoutFrame 0 0.164865 0 0.0507463 0 0.297297 0 0.134328 ) #model: #pitchClass ) #(#InputFieldSpec #layout: #(#LayoutFrame 0 0.159459 0 0.758209 0 0.678378 0 0.826866 ) #model: #structure ) #(#ActionButtonSpec #layout: #(#LayoutFrame 0 0.202703 0 0.185075 0 0.454054 0 0.277612 ) #model: #doMin7 #label: 'min 7' #defaultable: true ) #(#ActionButtonSpec #layout: #(#LayoutFrame 0 0.202703 0 0.295522 0 0.454054 0 0.385075 ) #model: #doMaj7 #label: 'maj 7' #defaultable: true ) #(#ActionButtonSpec #layout: #(#LayoutFrame 0 0.202703 0 0.414925 0 0.454054 0 0.504478 ) #model: #doHalfDim7 #label: 'half dim 7' #defaultable: true ) #(#ActionButtonSpec #layout: #(#LayoutFrame 0 0.202703 0 0.537313 0 0.454054 0 0.626866 ) #model: #doMaj #label: 'maj' #defaultable: true ) #(#InputFieldSpec #layout: #(#LayoutFrame 0 0.162162 0 0.844776 0 0.694595 0 0.913433 ) #model: #noteNames #isReadOnly: true ) #(#LabelSpec #layout: #(#LayoutOrigin 0 0.0216216 0 0.752239 ) #label: 'Name' ) #(#LabelSpec #layout: #(#LayoutOrigin 0 0.0189189 0 0.862687 ) #label: 'Notes' ) #(#RadioButtonSpec #layout: #(#LayoutOrigin 0 0.472973 0 0.0686567 ) #model: #root #label: 'Root' #select: #root ) #(#RadioButtonSpec #layout: #(#LayoutOrigin 0 0.591892 0 0.0686567 ) #model: #root #label: 'No Root' #select: #noRoot ) #(#RadioButtonSpec #layout: #(#LayoutOrigin 0 0.472973 0 0.158209 ) #model: #third #label: 'minor' #select: #min ) #(#RadioButtonSpec #layout: #(#LayoutOrigin 0 0.591892 0 0.158209 ) #model: #third #label: 'major' #select: #major ) #(#RadioButtonSpec #layout: #(#LayoutOrigin 0 0.705405 0 0.158209 ) #model: #third #label: 'no 3' #select: #no3 ) #(#RadioButtonSpec #layout: #(#LayoutOrigin 0 0.472973 0 0.238806 ) #model: #fifth #label: 'perfect' #select: #perfectFifth ) #(#RadioButtonSpec #layout: #(#LayoutOrigin 0 0.602703 0 0.238806 ) #model: #fifth #label: 'dim 5' #select: #dim5 ) #(#RadioButtonSpec #layout: #(#LayoutOrigin 0 0.708108 0 0.238806 ) #model: #fifth #label: 'aug 5' #select: #aug5 ) #(#RadioButtonSpec #layout: #(#LayoutOrigin 0 0.821622 0 0.238806 ) #model: #fifth #label: 'no 5' #select: #no5 ) #(#RadioButtonSpec #layout: #(#LayoutOrigin 0 0.472973 0 0.319403 ) #model: #seventh #label: 'min 7' #select: 7 ) #(#RadioButtonSpec #layout: #(#LayoutOrigin 0 0.594595 0 0.319403 ) #model: #seventh #label: 'major 7' #select: #maj7 ) #(#RadioButtonSpec #layout: #(#LayoutOrigin 0 0.735135 0 0.322388 ) #model: #seventh #label: 'dim 7' #select: #dim7 ) #(#RadioButtonSpec #layout: #(#LayoutOrigin 0 0.843243 0 0.322388 ) #model: #seventh #label: 'no 7' #select: #no7 ) #(#RadioButtonSpec #layout: #(#LayoutOrigin 0 0.472973 0 0.402985 ) #model: #ninth #label: 'perfect 9' #select: 9 ) #(#RadioButtonSpec #layout: #(#LayoutOrigin 0 0.624324 0 0.402985 ) #model: #ninth #label: 'dim 9' #select: #dim9 ) #(#RadioButtonSpec #layout: #(#LayoutOrigin 0 0.72973 0 0.40597 ) #model: #ninth #label: 'aug 9' #select: #aug9 ) #(#RadioButtonSpec #layout: #(#LayoutOrigin 0 0.843243 0 0.40597 ) #model: #ninth #label: 'no 9' #select: #no9 ) #(#RadioButtonSpec #layout: #(#LayoutOrigin 0 0.472973 0 0.486567 ) #model: #eleventh #label: 'perfect 11' #select: 11 ) #(#RadioButtonSpec #layout: #(#LayoutOrigin 0 0.651351 0 0.486567 ) #model: #eleventh #label: 'aug 11' #select: #aug11 ) #(#RadioButtonSpec #layout: #(#LayoutOrigin 0 0.843243 0 0.489552 ) #model: #eleventh #label: 'no 11' #select: #no11 ) #(#RadioButtonSpec #layout: #(#LayoutOrigin 0 0.472973 0 0.567164 ) #model: #thirteenth #label: 'perfect 13' #select: 13 ) #(#RadioButtonSpec #layout: #(#LayoutOrigin 0 0.651351 0 0.567164 ) #model: #thirteenth #label: 'dim 13' #select: #dim13 ) #(#RadioButtonSpec #layout: #(#LayoutOrigin 0 0.843243 0 0.570149 ) #model: #thirteenth #label: 'no 13' #select: #no13 ) ) ) )! !

!Siren.ChordNameEditor class methodsFor: 'resources'!

eleventhMenu
	"UIMenuEditor new openOnClass: self andSelector: #eleventhMenu"

	^#(#PopUpMenu #('perfect' 'aug' 'no eleventh' ) #() #(#'11' #aug11 #no11 ) ) decodeAsLiteralArray!

fifthMenu
	"UIMenuEditor new openOnClass: self andSelector: #fifthMenu"

	^#(#PopUpMenu #('perfect' 'dim fifth' 'aug fifth' 'no fifth' ) #() #(#perfectFifth #dim5 #aug5 #no5 ) ) decodeAsLiteralArray!

ninthMenu
	"UIMenuEditor new openOnClass: self andSelector: #ninthMenu"

	^#(#PopUpMenu #('dim' 'perfect' 'aug' 'no ninth' ) #() #(#dim9 #'9' #aug9 #no9 ) ) decodeAsLiteralArray!

rootMenu
	"UIMenuEditor new openOnClass: self andSelector: #rootMenu"

	^#(#PopUpMenu #('root' 'no root' ) #() #(#root #noRoot ) ) decodeAsLiteralArray!

seventhMenu
	"UIMenuEditor new openOnClass: self andSelector: #seventhMenu"

	^#(#PopUpMenu #('minor' 'major' 'dim' 'no seventh' ) #() #(#'7' #maj7 #dim7 #no7 ) ) decodeAsLiteralArray!

thirdMenu
	"UIMenuEditor new openOnClass: self andSelector: #thirdMenu"

	^#(#PopUpMenu #('minor' 'major' 'no third' ) #() #(#min #major #no3 ) ) decodeAsLiteralArray!

thirteenthMenu
	"UIMenuEditor new openOnClass: self andSelector: #thirteenthMenu"

	^#(#PopUpMenu #('dim' 'perfect' 'no thirteenth' ) #() #(#dim13 #'13' #no13 ) ) decodeAsLiteralArray! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!


!Siren.ChordNameEditor methodsFor: 'actions'!

doHalfDim7
	root value: #root.
	third value: #min.
	fifth value: #dim5.
	seventh value: 7. 
	ninth value: #no9.
	eleventh value: #no11.
	thirteenth value: #no13!

doMaj
	root value: #root.
	third value: #major.
	fifth value: #perfectFifth.
	seventh value: #no7.
	ninth value: #no9.
	eleventh value: #no11.
	thirteenth value: #no13!

doMaj7
	root value: #root.
	third value: #major.
	fifth value: #perfectFifth.
	seventh value: #maj7.
	ninth value: #no9.
	eleventh value: #no11.
	thirteenth value: #no13!

doMin7
	root value: #root.
	third value: #min.
	fifth value: #perfectFifth.
	seventh value: 7.
	ninth value: #no9.
	eleventh value: #no11.
	thirteenth value: #no13! !

!Siren.ChordNameEditor methodsFor: 'change'!

pitchClassIndexChanged
	pitchClass value: (PitchClass allNotesButDoubles at: pitchClassIndex value) printString.
	self structureChanged!

structureChanged
	| struct pc | 
	struct := WriteStream on: ''. 
	root value = #noRoot ifTrue: [struct nextPutAll: 'noRoot '].
	third value = #major ifFalse: [struct nextPutAll: third value; space].
	fifth value = #perfectFifth ifFalse: [struct nextPutAll: fifth value; space].
	struct nextPutAll: (seventh value = 7 ifTrue: ['7'] ifFalse: [seventh value]); space.
	struct nextPutAll: (ninth value = 9 ifTrue: ['9'] ifFalse: [ninth value]); space.
	struct nextPutAll: (eleventh value = 11 ifTrue: ['11'] ifFalse: [eleventh value]); space.
	struct nextPutAll: (thirteenth value = 13 ifTrue: ['13'] ifFalse: [thirteenth value]); space.
	pc := PitchClassChord newFromString: pitchClass value,' ',struct contents.

	structure value: pitchClass value, ' ',pc structureString.
	noteNames value: pc notesString.! !

!Siren.ChordNameEditor methodsFor: 'initialize'!

initialize
	super initialize.
	pitchClassIndex := 1 asValue.
	pitchClassIndex onChangeSend: #pitchClassIndexChanged to: self.
	pitchClass := 'A' asValue.
	noteNames := '' asValue.
	root:= #root asValue.
	root onChangeSend: #structureChanged to: self. 
	third := #major asValue.
	third onChangeSend: #structureChanged to: self.
	fifth := #perfectFifth asValue.
	fifth onChangeSend: #structureChanged to: self.
	seventh:= #no7 asValue.
	seventh onChangeSend: #structureChanged to: self.
	ninth := #no9 asValue.
	ninth onChangeSend: #structureChanged to: self.
	eleventh := #no11 asValue.
	eleventh onChangeSend: #structureChanged to: self.
	thirteenth := #no13 asValue.
	thirteenth onChangeSend: #structureChanged to: self.! !

!Siren.ChordNameEditor methodsFor: 'aspects'!

chord
	^PitchClassChord newFromString: structure value!

eleventh
	"This method was generated by UIDefiner. The initialization provided 
	below may have been preempted by an initialize method."
 
	^eleventh isNil ifTrue: [eleventh := nil asValue] ifFalse: [eleventh]!

fifth
	"This method was generated by UIDefiner. The initialization provided 
	below may have been preempted by an initialize method."

	^fifth isNil ifTrue: [fifth := nil asValue] ifFalse: [fifth]!

ninth
	"This method was generated by UIDefiner. The initialization provided 
	below may have been preempted by an initialize method."

	^ninth isNil ifTrue: [ninth := nil asValue] ifFalse: [ninth]!

noteNames
	"This method was generated by UIDefiner. The initialization provided 
	below may have been preempted by an initialize method."

	^noteNames isNil ifTrue: [noteNames := String new asValue] ifFalse: [noteNames]!

pitchClass
	"This method was generated by UIDefiner. The initialization provided 
	below may have been preempted by an initialize method."

	^pitchClass isNil ifTrue: [pitchClass := String new asValue] ifFalse: [pitchClass]!

pitchClassIndex
	"This method was generated by UIDefiner. The initialization provided 
	below may have been preempted by an initialize method."

	^pitchClassIndex isNil ifTrue: [pitchClassIndex := 1 asValue] ifFalse: [pitchClassIndex]!

root
	"This method was generated by UIDefiner. The initialization provided 
	below may have been preempted by an initialize method."

	^root isNil ifTrue: [root := nil asValue] ifFalse: [root]!

seventh
	"This method was generated by UIDefiner. The initialization provided 
	below may have been preempted by an initialize method."

	^seventh isNil ifTrue: [seventh := nil asValue] ifFalse: [seventh]!

structure
	"This method was generated by UIDefiner. The initialization provided 
	below may have been preempted by an initialize method."

	^structure isNil ifTrue: [structure := String new asValue] ifFalse: [structure]!

third
	"This method was generated by UIDefiner. The initialization provided 
	below may have been preempted by an initialize method."

	^third isNil ifTrue: [third := nil asValue] ifFalse: [third]!

thirteenth
	"This method was generated by UIDefiner. The initialization provided 
	below may have been preempted by an initialize method."

	^thirteenth isNil ifTrue: [thirteenth := nil asValue] ifFalse: [thirteenth]! !



Smalltalk.Siren defineClass: #Lapse
	superclass: #{Siren.MusicalInterval}
	indexedType: #none
	private: false
	instanceVariableNames: ''
	classInstanceVariableNames: ''
	imports: ''
	category: 'Music-PitchClasses'!



Smalltalk.Siren defineClass: #OctaveDependentChord
	superclass: #{Siren.PitchClassChord}
	indexedType: #none
	private: false
	instanceVariableNames: 'notesByInterval '
	classInstanceVariableNames: ''
	imports: ''
	category: 'Music-PitchClasses'!

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!


!Siren.OctaveDependentChord class methodsFor: 'examples'!

example
	^N C majorTriad fondamental!

example1
	"self example1"
	^(PitchClassChord newFromString: 'A  maj7') octave: 3!

example2
	^N C majorTriad fondamental! !

!Siren.OctaveDependentChord class methodsFor: 'cation'!

newWithValues: anArray 
	^self new newWithValues: anArray!

readFromFile
	| n |
	n := Dialog request: 'name of the file' initialAnswer: 'cc.chord'.
	n isEmpty ifTrue: [^nil].
	^self readFromFile: n!

readFromFile: fileName 
	| bos x |
	bos := BinaryObjectStorage onOld: (Filename named: fileName) readStream.
	[x := bos next]
		valueNowOrOnUnwindDo: [bos close].
	^x!

root: r notes: n 
	^(self new) root: r; notes: n! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!


Siren.OctaveDependentChord comment:
'notesBytInterval provides a fast access to the chord notes
by the names of their intervals with the root. The calculation 
is done once forever.  On the contrary,  for FPChord the
calculation is done all the times a note is required since 
its rarely required.
Note that for all request (e.g. theFifth) the copy of the note is 
answer). it is necessary in order to avoid some confusions. For instance,
the pitches (ODNotes) of  an simple arpeggio on a chord ch may be 
obtained by: 
	o := OredredCollection new.
	o add: ch theTonic; add: ch theThird; ch theFifth; theTonic.
the first and last must be different objects in the case we will assign 
them todifferents PlayableNotes.'!

!Siren.OctaveDependentChord methodsFor: 'mutations'!

asMelody
	^self asPlayableObject asMelody!

asPlayableObject
	^"PlayableChord new chord:" self!

lapse: l
	^self "(PlayableChord new chord: self) lapse: l"!

startBeat: s duration: d
	^self "(PlayableChord new chord: self) startBeat: s; duration: d"!

startTime: s duration: d
	^self "(PlayableChord new chord: self) startTime: s; duration: d"! !

!Siren.OctaveDependentChord methodsFor: 'transposing'!

beTransposedOneStepDown
	root beTransposedOneStepDown.
	self resetNotes!

beTransposedOneStepUp
	root beTransposedOneStepUp.
	self resetNotes! !

!Siren.OctaveDependentChord methodsFor: 'accessing'!

addNote: c 
	notes add: c!

notes: value
	notes := value!

removeNote: c 
	notes remove: c! !

!Siren.OctaveDependentChord methodsFor: 'notes by  intervals'!

computeNotesByInterval
	"only for triad notes"
	notesByInterval := Dictionary new.
	notesByInterval at: #theTonic put: self reallyTheTonic.
	notesByInterval at: #theThird put: self  reallyTheThird.
	notesByInterval at: #theFifth put: self reallyTheFifth.
	notesByInterval at: #theOctave put: self reallyTheOctave.
	notesByInterval at: #theLowThird put: self reallyTheLowThird.
	notesByInterval at: #theLowFifth put: self reallyTheLowFifth.
	notesByInterval at: #theLowOctave put: self reallyTheLowOctave.!

notesByInterval
	notesByInterval isEmpty ifTrue: [self computeNotesByInterval].
	^notesByInterval!

reallyTheFifth
	^super theFifth!

reallyTheLowFifth
	self  hasNoFifth
		ifTrue: [^nil].
	self hasADiminishedFifth
		ifTrue: [^root transposeOf: MusicalDescendingInterval augmentedFourth].
	self hasAnAugmentedFifth
		ifTrue: [^root transposeOf: MusicalDescendingInterval diminishedFourth].
	^root transposeOf: MusicalDescendingInterval fourth.!

reallyTheLowOctave

	^root transposeOf: MusicalDescendingInterval octave.!

reallyTheLowThird
	"attention: do not cofound with 'root downThird  interval"
	self isSuspended
		ifTrue: [^root transposeOf: MusicalDescendingInterval fifth]. 
	self isMinor
		ifTrue: [^root  transposeOf: MusicalDescendingInterval majorSixth].
	^ root transposeOf: MusicalDescendingInterval minorSixth.!

reallyTheOctave
	^super theOctave!

reallyTheThird
	^super theThird!

reallyTheTonic
	^super theTonic!

theFifth
	^(self notesByInterval at: #theFifth) copy!

theLowFifth
	^(self notesByInterval at: #theLowFifth) copy!

theLowOctave
	^(self notesByInterval at: #theLowOctave) copy!

theLowThird
	^(self notesByInterval at: #theLowThird) copy!

theOctave
	^(self notesByInterval at: #theOctave) copy!

theThird
	^(self notesByInterval at: #theThird) copy!

theTonic
	^(self notesByInterval at: #theTonic) copy! !

!Siren.OctaveDependentChord methodsFor: 'saving'!

save
	| bos fileName |
	fileName := Dialog request: 'file name' initialAnswer: 'cc.chord'.
	fileName isEmpty ifTrue: [^nil].
	bos := BinaryObjectStorage onNew: (Filename named: fileName) writeStream.
	[bos nextPut: self]
		valueNowOrOnUnwindDo: [bos close]!

storeOn: s
	s nextPut: $(.
	self quotedPrintOn: s.
	s nextPutAll: ' asChordOct: '.
	root oct printOn: s.
	s nextPut: $).! !

!Siren.OctaveDependentChord methodsFor: 'initialize'!

initialize
	super  initialize.
	notesByInterval := Dictionary new.!

resetNotes
	"extend super class method for notesByIntevals"
	super resetNotes.
	(notesByInterval isEmpty or: [notesByInterval == nil])
		ifFalse: [notesByInterval := Dictionary new]! !

!Siren.OctaveDependentChord methodsFor: 'copy'!

copy
	| new |
	new := self shallowCopy.
	new root: root copy; structure: structure copy.
	^new! !

!Siren.OctaveDependentChord methodsFor: 'As yet unclassified'!

theLowSeventh
	"WARN: the calculatin of the seven is done in every request"

	self  hasNoSeventh
		ifTrue: [^nil].
	self hasMajorSeventh
		ifTrue: [^root - #minorSecond].
	self hasADiminishedSeventh 
		ifTrue: [^root - #minorThird].
	^root - #majorSecond! !

!Siren.OctaveDependentChord methodsFor: 'alteration'!

octave: o
	root oct: o.
	self resetNotes!

octaveFromNote: n 
	"set octave from new root or chord note"
	| int |
	int :=  n pitchClass intervalBetween: root pitchClass.
	int type = 1 	"n is the  root in a probably different octave"
		ifTrue: [self octave: n oct].
	"n is another chord note"
	(self containsNote: n) 
		ifFalse: [^self error: 'the given note is not note a chord note'].
	self octave: (n - int) oct! !

!Siren.OctaveDependentChord methodsFor: 'private-pact'!

closestDownTriadNoteTo: n
	"((FPChord newFromString: 'C  maj7') @ 3) closestTriadNoteTo: N B flat @ 2"
	| l best smallestInt testInt |
	l := self downTriadNotes.
	best := l detect: [:nt | nt  respectsBassTessitura] ifNone: [nil].
	best == nil ifTrue: [^nil].
	smallestInt := n intervalBetween: best.
	1 to: l size do: 
		[:i | 
		testInt := n intervalBetween: (l at: i).
		(testInt < smallestInt and: [(l at: i) respectsBassTessitura])
			ifTrue:
			 [best := l at: i.
			  smallestInt := testInt]].
	^best!

closestTriadNoteTo: n
	"((FPChord newFromString: 'C  maj7') @ 3) closestTriadNoteTo: N B flat @ 2"
	| l best smallestInt testInt |
	l := self upAndDownTriadNotes.
	best := l detect: [:nt | nt  respectsBassTessitura] ifNone: [nil].
	best == nil ifTrue: [^nil].
	smallestInt := n intervalBetween: best.
	1 to: l size do: 
		[:i | 
		testInt := n intervalBetween: (l at: i).
		(testInt < smallestInt and: [(l at: i) respectsBassTessitura])
			ifTrue:
			 [best := l at: i.
			  smallestInt := testInt]].
	^best!

closestUpTriadNoteTo: n
	"((PitchClassChord newFromString: 'C  maj7') @ 3) closestTriadNoteTo: N B flat @ 2"
	| l best smallestInt testInt |
	l := self upTriadNotes.
	best := l detect: [:nt | nt  respectsBassTessitura] ifNone: [nil].
	best == nil ifTrue: [^nil].
	smallestInt := n intervalBetween: best.
	1 to: l size do: 
		[:i | 
		testInt := n intervalBetween: (l at: i).
		(testInt < smallestInt and: [(l at: i) respectsBassTessitura])
			ifTrue:
			 [best := l at: i.
			  smallestInt := testInt]].
	^best!

containsLegalNote: n 
	n respectsBassTessitura
		ifFalse: [^false].
	^(self upTriadNotes detect: [:each | each pitchClass = n pitchClass]
					   ifNone: [nil]) notNil!

downTriadNotes
	"return all triad notes within 2 octaves in a particular order"

	| o |
	o := OrderedCollection new.
	o add: self theLowOctave.
	o add: self theLowFifth.
	o  add: self theLowThird.
	o add: self theTonic.
	^o!

triadDownNoteLeadingTo: n
	"for the conflicting cases uses the priority given by  the ordering
	of upAndDownTriadNotes "
	^self downTriadNotes 
		detect: [:each | 
				(each isLeadingToneTo: n)
				and: [each respectsBassTessitura]]
		ifNone: [nil]!

triadNoteLeadingTo: n
	"for the conflicting cases uses two priority criteria: the proximity and 
	the ordering given by triadNotesLeadingTo: "
	"('A  maj7' asChordOct: 3) triadNoteLeadingTo: N D  @ 4"

	| list |
	list := self triadNotesLeadingTo: n.
	list isEmpty ifTrue: [^nil].
	list size = 1 ifTrue: [^list first].
	(n isNearerTo: (list at: 2) than: list first)
		ifTrue: [^(list at: 2)]
		ifFalse: [^list first].!

triadNotesLeadingTo: n
	"answer the chord 'triad' notes  (extend to 7?) within an octave, 
	 that are leading notes to the given note n"
	"('A  maj7' asChordOct: 3) triadNotesLeadingTo: N D @ 4"
	^self upAndDownTriadNotes select: 
		[:each |
		(each isLeadingToneTo: n) 
			and: [each respectsBassTessitura]].!

triadUpNoteLeadingTo: n
	"for the conflicting cases uses the priority given by  the ordering
	of upAndDownTriadNotes "
	^self upTriadNotes 
		detect: [:each | 
				(each isLeadingToneTo: n)
				and: [each respectsBassTessitura]]
		ifNone: [nil]!

upAndDownTriadNotes
	"return all triad notes within 2 octaves in a particular order"
	| o |
	o := OrderedCollection new.
	o add: self theOctave.
	o  add: self theFifth.
	o  add: self theThird.
	o  add: self theTonic.
	o add: self theLowOctave.
	o add: self theLowFifth.
	o  add: self theLowThird.
	^o!

upTriadNotes
	"return all triad notes within 2 octaves in a particular order"
	| o |
	o := OrderedCollection new.
	o add: self theOctave.
	o  add: self theFifth.
	o  add: self theThird.
	o  add: self theTonic.
	^o! !

!Siren.OctaveDependentChord methodsFor: 'FP'!

allPitchClasses
	^notes collect: [:n | n pitchClass]! !



Smalltalk.Siren defineClass: #PitchClassFlat
	superclass: #{Siren.PitchClassAltered}
	indexedType: #none
	private: false
	instanceVariableNames: 'flat '
	classInstanceVariableNames: ''
	imports: ''
	category: 'Music-PitchClasses'!

!Siren.PitchClassFlat methodsFor: 'accessing'!

flat
	^flat!

flat: value
	flat := value!

semiToneCount
	^natural semiToneCount - 1!

sharp
	^natural! !

!Siren.PitchClassFlat methodsFor: 'testing'!

isFlat
	^true! !

!Siren.PitchClassFlat methodsFor: 'printing'!

printOn: s 
	natural printOn: s.
	s nextPut: $b!

storeOn: s 
	"N C flat storeString"

	s nextPutAll: 'N ' , self natural name , ' flat'! !

!Siren.PitchClassFlat methodsFor: 'saving'!

representBinaryOn: s 
	^MessageSend receiver: natural selector: #flat! !

!Siren.PitchClassFlat methodsFor: 'intervals'!

alterate: note toReach: i 
	| n |
	n := natural alterate: note toReach: i.
	^n flat!

alterateBelow: note toReach: i 
	| n |
	n := natural alterateBelow: note toReach: i.
	^n flat!

closestEnharmonic
	^self alterate: self preceding toReach: 0.!

semiTonesToNatural
	^1! !



Smalltalk.Siren defineClass: #AnalysisList
	superclass: #{UI.Model}
	indexedType: #none
	private: false
	instanceVariableNames: ''
	classInstanceVariableNames: ''
	imports: ''
	category: 'Music-PitchClasses'!

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!


!Siren.AnalysisList class methodsFor: 'examples'!

examples

"	(FPChord newFromString: 'C  ') possibleTonalitiesInScaleClass:  MajorScale 

	AnalysisList ({I de C MajorScale} {IV de G MajorScale} {V de F MajorScale} )
"! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!


!Siren.AnalysisList methodsFor: 'testing'!

tonalitesCommunesAvec: l 

	| o |

	o := Set new.
	self do: [:a | l do: [:al | al scale = a scale ifTrue: [o add: a scale]]]. 

	^o!

tonalitesCommunesAvec: l1 et: l2 

	| o |

	o := Set new.
	self do: [:a | (l1 detect: [:al1 | al1 scale = a scale]

			ifNone: [nil]) notNil ifTrue: [(l2 detect: [:al2 | al2 scale = a scale]

				ifNone: [nil]) notNil ifTrue: [o add: a scale]]].
	^o! !



Smalltalk.Siren defineClass: #ListOfNotes
	superclass: #{Core.OrderedCollection}
	indexedType: #objects
	private: false
	instanceVariableNames: ''
	classInstanceVariableNames: ''
	imports: ''
	category: 'Music-PitchClasses'!

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!


!Siren.ListOfNotes class methodsFor: 'creation'!

from: aList

	^ self withAll: aList! !

!Siren.ListOfNotes class methodsFor: 'examples'!

example

	"(ListOfNotes from: (Array with: (N C octave: 2) with: (N D octave: 3) with: (N D octave: 4)))

barycenter -> C#3"! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!


!Siren.ListOfNotes methodsFor: 'recognition'!

asTriad

	"recognizes the list as a triad, if possible. relies en enharmonic spelling"

	"detecte la quinte puis la tonique puis la tierce"



	| pc   allInt fifth root third triade |

	self size < 3 ifTrue: [^nil].
	pc := self collect: [:n | n pitchClass].
	fifth := pc detect: [:p| 

		allInt := (1 to: pc size) collect: [:i | (pc at: i) intervalBetween: p].
		fifth := allInt detect: [:int| int = MusicalInterval perfectFifth] ifNone: [nil].
		fifth notNil]

			 ifNone: [nil].
	fifth isNil ifTrue: [^nil].
	root := fifth perfectFourth.
	third := pc detect: [:p | p natural == root majorThird natural] ifNone: [^nil].
	triade := Array with: root with: third with: fifth.
	pc do: [:p| (triade includes: p) ifFalse: [^nil]].
	^Triad new root: root; notes: self; type: (((root intervalBetween: third) = MusicalInterval majorThird) ifTrue: [#major] ifFalse: [#minor])! !

!Siren.ListOfNotes methodsFor: 'queries'!

barycenter

	| x |

	self isEmpty ifTrue: [^nil].
	x := 0.
	self do: [:n | x := x + n midiPitch].
	^OctaveDependentNote fromMidiPitch: (x // self size) "rounded"!

highest

	| highest |

	self isEmpty ifTrue: [^nil].
	highest := self first.
	self do: [:n | n midiPitch > highest midiPitch ifTrue: [highest := n]].
	^highest!

lowest

	| lowest |

	self isEmpty ifTrue: [^nil].
	lowest := self first.
	self do: [:n | n midiPitch < lowest midiPitch ifTrue: [lowest := n]].
	^lowest! !

!Siren.ListOfNotes methodsFor: 'ciphering'!

cipherIn: aScale 

	"works only for triads for the time being. Uses the French notation"

	"(ListOfNotes from: (Array with: (N G @ 2) with: (N C @ 3) with: (N E @ 4)))

	cipherIn: nil"

	|  lowest degres   |

	lowest := self lowest.
	degres := self collect: [:x| lowest intervalTypeBetween: x].
	"third := (l detect: [:x| (lowest intervalTypeBetween: x) = 3].
	fourth := 

	fifth := 

	sixth := "

	^degres! !

!Siren.ListOfNotes methodsFor: 'accessing'!

identityIndexOf: x 
	"yields the index found with a == test instead of the usual ="

	^self identityIndexOf: x ifAbsent: [0]!

nextIdentityIndexOf: anElement from: startIndex to: stopIndex 
	"Answer the next index of anElement within the receiver between startIndex 
	and stopIndex. 
	If the receiver does not contain anElement, answer nil"

	startIndex to: stopIndex do: [:i | (self at: i)
			== anElement ifTrue: [^i]].
	^nil! !

#{Siren.PitchClass} initialize!
