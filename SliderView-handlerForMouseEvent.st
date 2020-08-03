'From VisualWorks® Personal Use Edition, 8.3 of July 28, 2017 on July 15, 2020 at 4:41:49 PM'!


!UI.SliderView methodsFor: 'event driven'!

handlerForMouseEvent: aMouseEvent
	"Added handling for mouse wheel events"
	
	(self isVisible and: [self isEnabled and: [(self containsMouseEvent: aMouseEvent) and: [aMouseEvent wasHandled not]]])
		ifFalse: [^nil].
	aMouseEvent isMouseWheelEvent
		ifTrue: [ | mn mx val del |
			mn := rangeMap  rangeStart.
			mx := rangeMap rangeStop.
			val := model value.
			del := (mx - mn) / 33.0.		"scale for 3% steps"
			aMouseEvent up 
				ifTrue: [val := val + del]
				ifFalse: [val := val - del].
			val := val min: mx.
			val := val max: mn.
			aMouseEvent wasHandled: true.
			model setValue: val.
			self setValueFromModel.
			^nil].
	^(self isVisible and: [self isEnabled or: [aMouseEvent isMotionEvent]])
		ifTrue: [super handlerForMouseEvent: aMouseEvent]
		ifFalse: [nil].! !