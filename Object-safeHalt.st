'From VisualWorks® Personal Use Edition, 8.3 of July 28, 2017 on July 15, 2020 at 12:44:55 PM'!


!Core.Object methodsFor: 'error handling'!

safeHalt
	"This is a simple message to use for inserting breakpoints during debugging.
	The debugger is opened by raising a signal. This gives a chance to restore
	invariants related to multiple processes."

	InputState default shiftDown ifTrue: [self halt]! !