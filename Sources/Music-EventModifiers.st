

Smalltalk.Siren defineClass: #EventModifier
	superclass: #{Core.Object}
	indexedType: #none
	private: false
	instanceVariableNames: 'selector function scale start stop index '
	classInstanceVariableNames: ''
	imports: ''
	category: 'Music-EventModifiers'!

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!


!Siren.EventModifier class methodsFor: 'instance creation'!

function: aFunction
	"Create a new modifier and initialize it"

	^self new function: aFunction!

new
	"Create a new modifier and initialize it"

	^ super new initialize.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!


Siren.EventModifier comment:
'EventModifier is the abstract superclass of the classes whose instances operate on event lists. There are operations that can be done eagerly (at definition time) or lazily (at run time)
Instance Variables:
	selector	<Symbol>  What aspect of the event list do I modify
	function	<Function>  What function do I aply to the aspect
	scale	<Number>  Do I apply a scalar scale?
	start	<Number>  When do I start in the event list?
	stop	<Number>  When do I stop in the event list?
	index	<Number>  Used internally to count through events
'!

!Siren.EventModifier methodsFor: 'application'!

applyTo: evtList

	evtList applyFunction: function to: selector startingAt: 0!

valueIn: evtList at: time

	^function at: (time / evtList dur)! !

!Siren.EventModifier methodsFor: 'accessing'!

function
	"Answer the receiver's 'function'."

	^function!

function: anObject
	"Set the receiver's instance variable 'function' to be anObject."

	function := anObject!

index
	"Answer the receiver's 'index'."

	^index!

index: anObject
	"Set the receiver's instance variable 'index' to be anObject."

	index := anObject!

scale
	"Answer the receiver's 'scale'."

	^scale!

scale: anObject
	"Set the receiver's instance variable 'scale' to be anObject."

	scale := anObject!

selector
	"Answer the receiver's 'selector'."

	^selector!

selector: anObject
	"Set the receiver's instance variable 'selector' to be anObject."

	selector := anObject!

start
	"Answer the receiver's 'start'."

	^start!

start: anObject
	"Set the receiver's instance variable 'start' to be anObject."

	start := anObject!

stop
	"Answer the receiver's 'stop'."

	^stop!

stop: anObject
	"Set the receiver's instance variable 'stop' to be anObject."

	stop := anObject! !



Smalltalk.Siren defineClass: #Swell
	superclass: #{Siren.EventModifier}
	indexedType: #none
	private: false
	instanceVariableNames: ''
	classInstanceVariableNames: ''
	imports: ''
	category: 'Music-EventModifiers'!

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!


!Siren.Swell class methodsFor: 'as yet unclassified'!

example
	"Swell example"

	| roll decresc |
	roll := ((Roll length: 2 rhythm: 100 note: 60) ampl: 80) eventList.	"100 msec = 10/sec"
	decresc := Swell new function: (LinearFunction from: #((0 1) (1 0.5))); scale: 60.
	decresc applyTo: roll.
	roll play! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!


Siren.Swell comment:
'A swell applies a fnuction to the amplitudes of events in an event list.'!

!Siren.Swell methodsFor: 'initialize-release'!

initialize
	selector := #loudness! !



Smalltalk.Siren defineClass: #Rubato
	superclass: #{Siren.EventModifier}
	indexedType: #none
	private: false
	instanceVariableNames: ''
	classInstanceVariableNames: ''
	imports: ''
	category: 'Music-EventModifiers'!

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!


!Siren.Rubato class methodsFor: 'examples'!

example
	"Rubato example"

	| roll rub |
	roll := ((Roll length: 2 rhythm: 100 note: 60) ampl: 80) eventList.	"100 msec = 10/sec"
"	rub := Rubato new function: (LinearFunction from: #((0 1) (0.5 0.8) (1 1.2))); scale: 10. "
	rub := Rubato new function: (LinearFunction from: #((0 1) (1 1.5))); scale: 10.
	rub applyTo: roll.
	roll play! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!


Siren.Rubato comment:
'Rubato allows you to apply a function of time to the start times of events.'!

!Siren.Rubato methodsFor: 'initialize-release'!

initialize
	selector := #tempo! !
