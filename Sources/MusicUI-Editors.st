

Smalltalk.Siren defineClass: #TimeSequenceView
	superclass: #{Siren.DisplayListView}
	indexedType: #none
	private: false
	instanceVariableNames: 'clefForm xScaleDefault xScale xColor yColor headColor clefColor itemAccessors '
	classInstanceVariableNames: ''
	imports: ''
	category: 'MusicUI-Editors'!

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!


!Siren.TimeSequenceView class methodsFor: 'examples'!

randomExample
	"Open a sequence view on a random event list."
	"TimeSequenceView randomExample"

	TimeSequenceView openOnEventList: EventList randomExample! !

!Siren.TimeSequenceView class methodsFor: 'constant access'!

defaultCacheExtent
	"Answer the default extent of the receiver's instances' cache."

	^600@200!

inset
	"Answer the default display inset."

	^16@16! !

!Siren.TimeSequenceView class methodsFor: 'instance creation'!

openOnEventList: anEventList
	"Open the receiver on the given event list."
	"TimeSequenceView openOnEventList: EventList randomExample"

	| me dls |
	me := self new initialize model: (EventListEditor new eventList: anEventList).
	me displayList: (me layoutManager displayListFor: me).
	me initializeCache.
	dls := DisplayListSubcanvas new.
	dls setDisplayList: me displayList.
	dls setComponent: me component.
	DisplayListSubcanvas openOn: dls! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!


Siren.TimeSequenceView comment:
'Instances of SequenceView (and its subclasses) are time-line oriented DisplayListViews.
Time may run horizontally (default) or vertically, depending on the layout manager.

Instance Variables:
	clefForm	<Form> the view''s clef form or axes (optional), may be staff or scale/grid/ruler
	xScale	<Number> the time-to-x-coordinate scale
	xColor	<ColorValue> the color of the lines for note duration
	yColor	<ColorValue> the color of the lines for note amplitude
	headColor	<ColorValue> the note head color
	clefColor	<ColorValue> the clef color
	itemAccessors	<Symbol or Dictionary of (Voice -> Symbol)> the item accessor(s) to use to generate the display list items for the notes

This implementation is MODE 1.1, STEIM, Amsterdam, May/June 1990; updated at the Lagoon in Palo Alto, July, 1991-May, 1992.

The entirety of this software is Copyright (c) 1990, Stephen Travis Pope, Nomad Object Design/Nomad Computer Music Research. 
All Rights Reserved.'!

!Siren.TimeSequenceView methodsFor: 'transforming'!

formXFromTime: aTime
	"take a note's time and return a display point x coordinate relative to the form."

	^((aTime - (page x) / xScale) asInteger)!

timeFromX: aNumber
	"Answer an event list time from the argument."

	^(aNumber x - inset x - self bounds width * xScale + page x) max: 0! !

!Siren.TimeSequenceView methodsFor: 'accessing'!

cachedPixmap
	"Answer the receiver's cached pixmap."

	^pixmap!

clefColor
	"Answer the receiver's 'clefColor'."

	^clefColor!

clefColor: anObject
	"Set the receiver's 'clefColor' to be anObject."

	clefColor := anObject!

clefForm
	"Answer the receiver's clef form."

	^clefForm!

clefWidth
	"Answer the receiver's clef form width."

	^clefForm width!

headColor
	"Answer the receiver's 'headColor'."

	^headColor!

headColor: anObject
	"Set the receiver's 'headColor' to be anObject."

	headColor := anObject!

xColor
	"Answer the receiver's 'xColor'."

	^xColor!

xColor: anObject
	"Set the receiver's 'xColor' to be anObject."

	xColor := anObject!

xScale
	"Answer the receiver's 'xScale'."

	^xScale!

xScale: anObject
	"Set the receiver's 'xScale' to be anObject."

	xScale := anObject!

yColor
	"Answer the receiver's 'yColor'."

	^yColor!

yColor: anObject
	"Set the receiver's 'yColor' to be anObject."

	yColor := anObject! !

!Siren.TimeSequenceView methodsFor: 'controller access'!

defaultControllerClass
	"Answer the class of the default controller for the receiver."

	^TimeSequenceController! !

!Siren.TimeSequenceView methodsFor: 'layout manager access'!

generateItemFor: anAss
	"Answer the correct visual item for the given assoc. (sent from layoutManagers)."

	| dItem vox arr |
	arr := MusicConstants at: #NoteIcons.
	vox := anAss value voice.
	vox == nil 
		ifTrue: [vox := 1] 
		ifFalse: [vox isInteger
			ifTrue: [vox := (vox max: 1) min: arr size]
			ifFalse: [vox := vox first asInteger \\ arr size]].	"hack -- take the first letter as the key for note heads"
	dItem := (arr at: (vox )) copy.
	dItem color: (headColor == nil
				ifTrue: [ColorValue white]
				ifFalse: [headColor]).
	dItem model: anAss.
	^dItem!

itemFor: anAss
	"Answer the correct visual item for the given assoc. (sent from layoutManagers)."

	itemAccessors == nil
		ifTrue: [^self generateItemFor: anAss].
	itemAccessors isSymbol
		ifTrue: [^self perform: itemAccessors with: anAss].
	(itemAccessors isMemberOf: BlockClosure)
		ifTrue: [^itemAccessors value: anAss].
	(itemAccessors isMemberOf: Dictionary)
		ifTrue: [^self perform: (itemAccessors at: anAss value voice ifAbsent: [0]) 
						with: anAss].!

layoutManager
	"Answer a default layout manager for the receiver."

	^(TimeSequenceLayoutManager new)
			timeScale: xScale;
			timeOffset: 0! !

!Siren.TimeSequenceView methodsFor: 'displaying'!

displayOn: aGC
	"Display the receiver on the argument."

	aGC paint: self backgroundColor.
	aGC displayRectangle: aGC clippingBounds.
	pixmap == nil
		ifFalse: [(redrawn == true)
			ifFalse: [ | pGC |
				redrawn := true.
				pGC := pixmap graphicsContext.
				self reallyDisplayOn: pGC].
			pixmap displayOn: aGC]
		ifTrue: [self reallyDisplayOn: aGC]!

displayOnImage
	"Display the receiver on its cached form."

	| pGC |
	redrawn := true.
	pGC := pixmap graphicsContext.
	pGC paint: self backgroundColor.
	pGC displayRectangle: pixmap bounds.
	pGC paint: self foregroundColor.
	pGC clippingRectangle: pixmap bounds.
	pGC translateBy: inset.
"	clefForm == nil 
		ifFalse: [clefForm displayOn: pGC.
				pGC translateBy: clefForm width@0].
"	background == nil ifFalse: [background displayOn: pGC].
	displayList displayOn: pGC.
	model selection == nil
		ifFalse: 
			[controller sensor shiftDown ifTrue: [self halt].
			pGC displayRectangularBorder: controller selection bounds].
	pGC translateBy: inset negated!

highlightFrom: pt1 to: pt2
	"Show selection of the range pt1--pt2."

	| gc |
	gc := self graphicsContext.
	gc paint: DisplayList foregroundColor.
	gc displayRectangularBorder: (pt1 corner: pt2)!

highlightTime: value
	"Show selection of the time value value."

"	| x |
	x := (value / xScale - page x - cachedForm offset x 
				+ insetDisplayBox left + self class inset x) min: (insetDisplayBox right).
	(x > (insetDisplayBox right - 64))
		ifTrue: [self scroll: ((insetDisplayBox width - 128) negated@0).
			x := x - (insetDisplayBox width - 128)].
	Display fill: ((x @ insetDisplayBox top)
			extent: (2 @insetDisplayBox height))
		rule: Form reverse
		mask: Form black."!

reallyDisplayOn: gc
	"Display the receiver on its cached form."

	gc paint: self backgroundColor.
	gc displayRectangle: gc clippingBounds.
	gc paint: self foregroundColor.
	gc translateBy: inset.
	clefForm == nil 
		ifFalse: [clefForm displayOn: gc.
				gc translateBy: clefForm width@0].
	background == nil ifFalse: [background displayOn: gc].
	displayList displayOn: gc.
	model selection == nil
		ifFalse: 
			[controller sensor shiftDown ifTrue: [self halt].
			gc displayRectangularBorder: controller selection bounds].
	gc translateBy: inset negated!

zoom: aPoint
	"Set the receiver's 'zoom' to be aPoint."

	xScale := xScaleDefault * aPoint x.
	Cursor wait showWhile:
		[self displayList: (self layoutManager displayListFor: self).
		super zoom: aPoint]! !

!Siren.TimeSequenceView methodsFor: 'initialize-release'!

initialize
	"Initialize the instance variables of the receiver."

	super initialize.
	xScaleDefault := 15.
	xScale := 15.
	page := 0@0! !

!Siren.TimeSequenceView methodsFor: 'updating'!

update: ignored
	"Redraw the display"

	self displayList: (self layoutManager displayListFor: self).
	self topComponent raise.
	self invalidate
"	self displayOn: self graphicsContext"! !



Smalltalk.Siren defineClass: #TimeSequenceController
	superclass: #{Siren.DisplayListController}
	indexedType: #none
	private: false
	instanceVariableNames: ''
	classInstanceVariableNames: ''
	imports: ''
	category: 'MusicUI-Editors'!

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!


!Siren.TimeSequenceController class methodsFor: 'resources'!

defaultEditMenu
	"Tools.MenuEditor new openOnClass: self andSelector: #defaultEditMenu"

	<resource: #menu>
	^#(#{UI.Menu} #(
			#(#{UI.MenuItem} 
				#rawLabel: 'play' 
				#value: #play ) 
			#(#{UI.MenuItem} 
				#rawLabel: 'group' 
				#submenu: #(#{UI.Menu} #(
						#(#{UI.MenuItem} 
							#rawLabel: 'group' 
							#value: #groupItems 
							#shortcutKeyCharacter: $g 
							#shortcutModifiers: 2 ) 
						#(#{UI.MenuItem} 
							#rawLabel: 'ungroup' 
							#value: #ungroupItems 
							#shortcutKeyCharacter: $u 
							#shortcutModifiers: 2 ) 
						#(#{UI.MenuItem} 
							#rawLabel: 'flatten' 
							#value: #flattenItems ) ) #(2 1 ) nil ) ) 
			#(#{UI.MenuItem} 
				#rawLabel: 'edit' 
				#submenu: #(#{UI.Menu} #(
						#(#{UI.MenuItem} 
							#rawLabel: 'copy' 
							#value: #copyItem 
							#shortcutKeyCharacter: $c 
							#shortcutModifiers: 2 ) 
						#(#{UI.MenuItem} 
							#rawLabel: 'cut' 
							#value: #cutItem 
							#shortcutKeyCharacter: $x 
							#shortcutModifiers: 2 ) 
						#(#{UI.MenuItem} 
							#rawLabel: 'paste' 
							#value: #pasteItem 
							#shortcutKeyCharacter: $v 
							#shortcutModifiers: 2 ) 
						#(#{UI.MenuItem} 
							#rawLabel: 'paste from buffer...' 
							#value: #pasteFromBuffer 
							#shortcutKeyCharacter: $V 
							#shortcutModifiers: 2 ) 
						#(#{UI.MenuItem} 
							#rawLabel: 'again' 
							#value: #again 
							#shortcutKeyCharacter: $a 
							#shortcutModifiers: 2 ) 
						#(#{UI.MenuItem} 
							#rawLabel: 'undo' 
							#value: #undo 
							#shortcutKeyCharacter: $z 
							#shortcutModifiers: 2 ) ) #(4 2 ) nil ) ) 
			#(#{UI.MenuItem} 
				#rawLabel: 'inspect' 
				#submenu: #(#{UI.Menu} #(
						#(#{UI.MenuItem} 
							#rawLabel: 'model' 
							#value: #inspectModel 
							#shortcutKeyCharacter: $i 
							#shortcutModifiers: 2 ) 
						#(#{UI.MenuItem} 
							#rawLabel: 'editor' 
							#value: #inspectEditor 
							#shortcutKeyCharacter: $e 
							#shortcutModifiers: 2 ) 
						#(#{UI.MenuItem} 
							#rawLabel: 'display' 
							#value: #inspectDisplayList ) ) #(3 ) nil ) ) 
			#(#{UI.MenuItem} 
				#rawLabel: 'display' 
				#submenu: #(#{UI.Menu} #(
						#(#{UI.MenuItem} 
							#rawLabel: 'redraw' 
							#value: #redrawView ) 
						#(#{UI.MenuItem} 
							#rawLabel: 'zoom to 1:1' 
							#value: #zoomTo1 
							#shortcutKeyCharacter: $1 
							#shortcutModifiers: 2 ) 
						#(#{UI.MenuItem} 
							#rawLabel: 'zoom in to point' 
							#value: #zoomInPoint ) 
						#(#{UI.MenuItem} 
							#rawLabel: 'zoom out from point' 
							#value: #zoomOutPoint ) ) #(4 ) nil ) ) 
			#(#{UI.MenuItem} 
				#rawLabel: 'options...' 
				#value: #optionsDialog ) ) #(6 ) nil ) decodeAsLiteralArray! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!


!Siren.TimeSequenceController methodsFor: 'menu messages'!

doInspect
	"Inspect the editor (if leftShiftDown) or the list."

	self sensor shiftDown
		ifTrue: [model inspect]
		ifFalse: [model eventList inspect]!

group
	"Group the current selection as a separate sub-event list in the model."

	model selection == nil
		ifTrue: [view flash.
			^self].
	model group: model selection.
	model select: nil!

pan
	"Pan the view in x highlighting the time value until mouse press."

	| time0 startTime now |
	self sensor waitNoButton.
	time0 := Time microsecondClock.
	startTime := view offsetX * view xScale.
	now := startTime.
	[self sensor anyButtonPressed or: [now > model list duration value]]
		whileFalse: [now := startTime + Time microsecondClock - time0.
			view highlightTime: now.
"			Transcript show: now printString; cr."
"			(Delay forMilliseconds: 100) wait."
			view highlightTime: now].
	self sensor waitNoButton!

play
	"Play the list."

	model eventList play.
"	MIDIPort allNotesOffIn: (model eventList duration asSec value + 3)"!

readList
	"Copy the model list from the global dictionary."

	| name |
	name := Dialog request: 'EventList name for storing model:'
			initialAnswer: model list name.
	name = '' ifTrue: [^self].
	(SirenSession eventLists includesKey: name)
		ifTrue: [model eventList: (SirenSession eventLists at: name) copy]
		ifFalse: [Transcript cr; show: 'No such event list.'; cr.]!

storeList
	"Copy the model list into the global dictionary."

	| name count |
	name := Dialog request: 'EventList name for storing model:'
			initialAnswer: model list name.
	name = '' ifTrue: [^self].
	(SirenSession eventLists includesKey: name)
		ifTrue: [(Dialog confirm: 'Store over existing event list?')
			ifTrue: [SirenSession eventLists at: name put: model list copy]
			ifFalse: [count := 2.
				[SirenSession eventLists includesKey: (name, '.', count printString)]
					whileTrue: [count := count + 1].
				SirenSession eventLists at: (name, '.', count printString) asSymbol
						put: (SirenSession eventLists at: name).
				SirenSession eventLists at: name put: model list copy]]
		ifFalse: [SirenSession eventLists at: name put: model list copy]! !

!Siren.TimeSequenceController methodsFor: 'selecting'!

selectFromPoint: aPoint toPoint: anotherPoint
	"Hit-detect the model for the given range."

	| collection eList |
	collection := view list itemsFromX: aPoint x toX: anotherPoint x.
	eList := EventList newAnonymous.
	collection do:
		[ :i | 
		i model == nil
			ifFalse: [eList add: i model]].
	model select: eList.
	self select: collection.
	view invalidate! !

!Siren.TimeSequenceController methodsFor: 'initialize-release'!

initializeMenu
	"Set up the receiver's YellowButtonMenu"

	super initializeMenu
"	self menuHolder: (ValueHolder with: (PopUpMenu
			labelList: #(('group' 'inspect') ('play' 'pan') ('redraw') ('store' 'read'))
			values: #(group doInspect play pan redraw storeList readList)))"! !



Smalltalk.Siren defineClass: #EventListTreeItem
	superclass: #{UI.ApplicationModel}
	indexedType: #none
	private: false
	instanceVariableNames: 'lists '
	classInstanceVariableNames: ''
	imports: ''
	category: 'MusicUI-Editors'!

!Siren.EventListTreeItem methodsFor: 'accessing'!

children
	
	^lists!

hasChildren

	^lists notEmpty! !

!Siren.EventListTreeItem methodsFor: 'initialize-release'!

lists: aCollection

	lists := aCollection! !



Smalltalk.Siren defineClass: #EventListEditor
	superclass: #{Siren.DisplayListEditor}
	indexedType: #none
	private: false
	instanceVariableNames: 'eventList ostinato defaultEvent '
	classInstanceVariableNames: ''
	imports: ''
	category: 'MusicUI-Editors'!

Siren.EventListEditor comment:
'Instances of EventListEditor are used as the models of EventListViews.
They hold onto EventLists and send messages to them.

Instance variables:
	list 			<EventList> my EventList (subject)
	ostinato 	<Ostinato> my loop process (if i''m looping)
	selection 	<EventList> The "selected" notes
	ampl 		<Number or Amplitude> My default amplitude
'!

!Siren.EventListEditor methodsFor: 'initialize-release'!

release
	"Release the receiver's list."

	eventList removeDependent: self.
	list removeDependent: self.
	list release! !

!Siren.EventListEditor methodsFor: 'accessing'!

ampl
	"Answer the amplitude of the default event."

	^defaultEvent == nil
		ifTrue: [0]
		ifFalse: [defaultEvent  loudness value]!

ampl: newValue
	"Set the amplitude of the default event."

	defaultEvent == nil
		ifTrue: [^self].
	defaultEvent loudness: newValue asInteger.
	self changed: #ampl!

defaultEvent
	"Answer the receiver's default event."

	^defaultEvent == nil
		ifTrue: [list defaultEventClass new]
		ifFalse: [defaultEvent]!

defaultEvent: anEvent
	"Set the receiver's default event."

	defaultEvent := anEvent!

displayList
	"Answer nil."

	^nil!

eventList
	"Answer the receiver's subject eventList."

	^eventList!

eventList: anEL
	"Set the given EventList as the receiver's model."

	eventList := anEL.
	defaultEvent := eventList defaultEventClass new.
	anEL addDependent: self.
	self changed: #list!

items
	"Answer the subject eventList's events."

	^eventList events! !

!Siren.EventListEditor methodsFor: 'links and groups'!

group: events
	"Group the event list argument within the receiver's list."

	list group: events.
	self changed: #events!

link: anEvent with: anOtherEvent
	"Set up a link between the two events or lists."

	^self!

select: anAorEL
	"Add the given association to the list of selected items."

	| mo |
	anAorEL == nil
		ifTrue: [^selections := nil].
	mo := anAorEL isEvent
		ifTrue: [anAorEL]
		ifFalse: [anAorEL model].
	mo hasItems
		ifTrue: [selections := mo]
		ifFalse: [selections == nil
				ifTrue: [selections := EventList newNamed: EventList nextName ].
			selections add: mo]! !

!Siren.EventListEditor methodsFor: 'list access'!

add: anAss
	"Add the given EventAssociation to the model list."

	list add: anAss.
	self changed: #added.!

doInspect
	"Inspect the receiver's list."

	InputState default shiftDown
		ifTrue: [self inspect]
		ifFalse: [list inspect]!

eraseList
	"Flush the receiver's list."

	list empty.
	self changed: #deleted.!

play
	"Play the receiver's eventList."

"	Sensor leftShiftDown 
		ifTrue: [self startStop]
		ifFalse: [list play]
"
	eventList play!

remove: anEvent
	"Remove the given event from the receiver's list"

"	Transcript show: 'remove: ', anEvent printString; cr."
	list remove: anEvent.
	self changed: #deleted.!

startStop
	"If not playing, create ostinato and start; if playing, stop and release."

	ostinato == nil
		ifTrue: [ostinato := Ostinato onList: list.
				[ostinato play]]
		ifFalse: [ostinato stop.
				ostinato := nil]! !



Smalltalk.Siren defineClass: #PitchTimeController
	superclass: #{Siren.TimeSequenceController}
	indexedType: #none
	private: false
	instanceVariableNames: ''
	classInstanceVariableNames: ''
	imports: ''
	category: 'MusicUI-Editors'!

!Siren.PitchTimeController methodsFor: 'selecting'!

selectFromPoint: aPoint toPoint: anotherPoint
	"Hit-detect the model for the given range."

	| collection eList |
	collection := view list itemsWithin: (aPoint corner: anotherPoint).
	collection == nil ifTrue: [^self].
	eList := EventList newAnonymous.
	collection do:
		[ :i | 
		i model == nil
			ifFalse: [eList add: i model]].
	model select: eList.
	self select: collection.
	view invalidate! !



Smalltalk.Siren defineClass: #PitchTimeView
	superclass: #{Siren.TimeSequenceView}
	indexedType: #none
	private: false
	instanceVariableNames: 'pitchOffset yScale yScaleDefault '
	classInstanceVariableNames: ''
	imports: ''
	category: 'MusicUI-Editors'!

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!


!Siren.PitchTimeView class methodsFor: 'examples'!

randomExample
	"Open a p-t view on a random event list."
	"PitchTimeView randomExample"

	PitchTimeView openOnEventList: EventList randomExample!

randomExampleLong
	"Open a p-t view on a random event list."
	"PitchTimeView randomExampleLong"

	| list |
	list := EventList randomExample: 1024.
	list addAll: (EventList randomExample: 1024).
	PitchTimeView openOnEventList: list! !

!Siren.PitchTimeView class methodsFor: 'instance creation'!

label
	"Answer the view label for the receiver's instances."

	^'Pitch-Time Editor'! !

!Siren.PitchTimeView class methodsFor: 'subview creation'!

addButtonsOn: me for: dled to: container in: rect
	"Add the default button panel to the instance in the given rectangle."

	| x0 y0 x1 y1 |
	x0 := rect left.	x1 := rect right.
	y0 := rect top.	y1 := rect bottom.
	self addButtonOn: me labeled: 'Play'
		doing: [:model :value | dled play] 
		in: (LayoutFrame new leftFraction: 0; topFraction: y0; 
							rightFraction: 0.12;	bottomFraction: y1) 
		to: container.
	self addButtonOn: me labeled: 'File'
		doing: [:model :value | dled doFile] 
		in: (LayoutFrame new leftFraction: 0.12; topFraction: y0; 
							rightFraction: 0.25;	bottomFraction: y1) 
		to: container.
	self addButtonOn: me labeled: 'Edit'
		doing: [:model :value | dled doEdit] 
		in: (LayoutFrame new leftFraction: 0.25;	topFraction: y0; 
							rightFraction: 0.37;	bottomFraction: y1) 
		to: container.
	self addButtonOn: me labeled: 'Inspect'
		doing: [:model :value | dled doInspect] 
		in: (LayoutFrame new leftFraction: 0.37;	topFraction: 0.0; 
							rightFraction: 0.5;	bottomFraction: y1) 
		to: container.
	self addButtonOn: me labeled: 'Display'
		doing: [:model :value | dled doDisplay] 
		in: (LayoutFrame new leftFraction: 0.5;	topFraction: y0; 
							rightFraction: 0.62;	bottomFraction: y1) 
		to: container.
	self addButtonOn: me labeled: 'Zoom'
		doing: [:model :value | dled doZoom] 
		in: (LayoutFrame new leftFraction: 0.62;	topFraction: y0; 
							rightFraction: 0.75;	bottomFraction: y1) 
		to: container.
	self addButtonOn: me labeled: 'View'
		doing: [:model :value | dled doViewEdit] 
		in: (LayoutFrame new leftFraction: 0.75;	topFraction: y0; 
							rightFraction: 0.87;	bottomFraction: y1) 
		to: container.
	self addButtonOn: me labeled: 'Properties'
		doing: [:model :value | dled doPropEdit] 
		in: (LayoutFrame new leftFraction: 0.87;	topFraction: y0; 
							rightFraction: 1.0;	bottomFraction: y1) 
		to: container.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!


Siren.PitchTimeView comment:
'Instances of PitchTimeView (and its subclasses) are time-line oriented DisplayListViews which make the assumption that the y-coordinate is related to pitch.
The relationship may be a function (as in piano-roll and Hauer-Steffens notation), or involve a look-up table (as in CMN).

Instance Variables:
	pitchOffset	<Number> the view''s lowest pitch (normally a key number)'!

!Siren.PitchTimeView methodsFor: 'transforming'!

pitchFromY: aPoint
	"Answer the transformed pitch represented by the y-coordinate of the argument."

	^(aPoint y - self class inset y / yScale + pitchOffset) max: 0! !

!Siren.PitchTimeView methodsFor: 'controller access'!

defaultControllerClass
	"Answer the class of the default controller for the receiver."

	^PitchTimeController! !

!Siren.PitchTimeView methodsFor: 'displaying'!

highlightFrom: pt1 to: pt2
	"Show selection of the range pt1--pt2"

"	pt1 x = pt2 x
		ifTrue: [^self].
	Display border: (pt1 corner: pt2)
		width: 2
		mask: Form gray."!

zoom: aPoint
	"Set the receiver's 'zoom' to be aPoint."

	xScale := xScaleDefault * aPoint x.
	yScale := yScaleDefault * aPoint y.
	Cursor wait showWhile:
		[self displayList: (self layoutManager displayListFor: self).
		super zoom: aPoint]! !

!Siren.PitchTimeView methodsFor: 'layout manager access'!

generateItemFor: anAss
	"Answer the correct visual item for the given assoc. (sent from layoutManagers)."
	"ColorValue constantNames"
	"EventList randomSWSSExample2 edit"

"	^super generateItemFor: anAss.
"
	| yHeight x y list event |
	event := anAss value.
	yHeight := 24.
	event duration == nil
			ifTrue: [x := 250 / xScale]
			ifFalse: [x := event duration asMS value / xScale].
	((event ampl == nil) or: [event ampl value == nil])
		ifFalse: [y := (event ampl asRatio value * yHeight) truncated]
		ifTrue: [y := 0].
	list := (DisplayList new) model: anAss.
	list add: (super generateItemFor: anAss).
	list add: ((DisplayLine new)
				offset: 0@0;
				extent: x@0;
				color: (xColor == nil ifTrue: [ColorValue cyan] ifFalse: [xColor])).
	list add: ((DisplayLine new)
				offset: 0@0;
				extent: 0@y negated;
				color: (yColor == nil ifTrue: [ColorValue red] ifFalse: [yColor])).
	(event at: #envelope) == nil
		ifFalse: [ | fcn points | fcn := event at: #envelope.
				points := fcn data collect: [ :pt | (pt x * x) @ (pt y * y negated)].
				list add: ((DisplayPolyline offset: (1@0) vertices: points) color: ColorValue black)].
	(event at: #position) == nil
		ifFalse: [list add: ((DisplayLine new)
				offset: 2@0;
				extent: 0@((event at: #position) - 0.5 * yHeight);
				color: (yColor == nil ifTrue: [ColorValue green] ifFalse: [yColor]))].
	(event at: #duty) == nil
		ifFalse: [list add: ((DisplayLine new)
				offset: 0@2;
				extent: ((event at: #duty) * x)@0;
				color: (yColor == nil ifTrue: [ColorValue yellow] ifFalse: [yColor]))].
	^list!

itemFor: anAss
	"Answer the correct visual item for the given assoc. (sent from layoutManagers)."
	"ColorValue constantNames "
	"PitchTimeView openOnEventList: (EventList scaleFrom: 48 to: 84 in: 4)"

	| yHeight x y list event it |
	event := anAss value.
	yHeight := 24.
	event duration == nil
			ifTrue: [x := 250 / xScale]
			ifFalse: [x := event duration asMS value / xScale].
	((event ampl == nil) or: [event ampl value == nil])
		ifFalse: [y := (event ampl asRatio value * yHeight) truncated]
		ifTrue: [y := 0].
	list := (DisplayList new) model: anAss.
	it := super itemFor: anAss.
	it == nil ifFalse: [list add: it].
	list add: ((DisplayLine new)
				offset: 0@ -2;
				extent: x@0;
				color: (xColor == nil ifTrue: [ColorValue blue] ifFalse: [xColor])).
	list add: ((DisplayLine new)
				offset: 0@0;
				extent: 0@y negated;
				color: (yColor == nil ifTrue: [ColorValue red] ifFalse: [yColor])).
	(event at: #envelope) == nil
		ifFalse: [ | fcn points | fcn := event at: #envelope.
				points := fcn data collect: [ :pt | (pt x * x) rounded @ (pt y * y negated) rounded].
				list add: ((DisplayPolyline offset: (1@0) vertices: points) color: ColorValue green)].
	(event at: #position) == nil
		ifFalse: [list add: ((DisplayLine new)
				offset: 2@0;
				extent: 0@((event at: #position) - 0.5 * yHeight);
				color: (yColor == nil ifTrue: [ColorValue green] ifFalse: [yColor]))].
	^list!

layoutManager
	"Answer a default layout manager for the receiver."

	^(PitchTimeLayoutManager new)
			timeScale: xScale;
			timeOffset: page x;
			pitchScale: yScale;
			pitchOffset: pitchOffset! !

!Siren.PitchTimeView methodsFor: 'initialize-release'!

initialize
	"Initialize the instance variables of the receiver."

	super initialize.
	xScale := 10.				"approx msec / pixel"
	xScaleDefault := xScale.
	yScale := 8.					"approx pix / quartertone"
	yScaleDefault := yScale.
	pitchOffset := 24! !



Smalltalk.Siren defineClass: #EventListFileViewer
	superclass: #{Siren.SoundFileViewer}
	indexedType: #none
	private: false
	instanceVariableNames: ''
	classInstanceVariableNames: ''
	imports: ''
	category: 'MusicUI-Editors'!

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!


!Siren.EventListFileViewer class methodsFor: 'accessing'!

isInterestedInFile: aFilename

	('*.ev' match: aFilename tail) ifTrue: [^true].
	('*.sm' match: aFilename tail) ifTrue: [^true].
	('*.mid' match: aFilename tail) ifTrue: [^true].
	('*.midi' match: aFilename tail) ifTrue: [^true].
	^false!

tabLabel

	^(#FileInformation << #labels >> 'Score File') asString! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!


!Siren.EventListFileViewer methodsFor: 'actions'!

editFile
	"Edit the selected sound file"

	| score |
	score := EventList fromFile: self selectedFilename asString.
	score ifNotNil: [^score edit].
	Dialog warn: 'Cannot read score from file'!

loadFile
	"Load the selected file into the SirenSession"

	| nam |
	nam := self selectedFilename asString.
	SirenSession eventList: nam put: (EventList fromFile: nam)!

playFile
	"Play the selected sound file"

	(EventList fromFile: self selectedFilename asString) play! !

!Siren.EventListFileViewer methodsFor: 'accessing'!

printBlurbFor: aFilename on: stream

	self
		print: (#Path << #labels >> 'Path') value: [aFilename asString] on: stream;
		print: (#Size << #labels >> 'Size') value: [aFilename fileSize printString] on: stream;
		print: (#LastModified << #labels >> 'Last modified') 
				value: [self timestampStringAt: #modified in: aFilename dates] on: stream! !



Smalltalk.Siren defineClass: #PhraseView
	superclass: #{Siren.TimeSequenceView}
	indexedType: #none
	private: false
	instanceVariableNames: ''
	classInstanceVariableNames: ''
	imports: ''
	category: 'MusicUI-Editors'!

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!


!Siren.PhraseView class methodsFor: 'examples'!

example
	"PhraseView example"
	"NOT WORKING"

	PhraseView openOn:
		((EventListEditor new) eventList: (EventList named: #phrase1) copy)! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!


!Siren.PhraseView methodsFor: 'layout manager access'!

generateItemFor: anAss
	"Answer the correct visual item for the given assoc. (sent from layoutManagers)."

	| ampV |
	ampV := anAss value loudness value * 32.
	^(DisplayList new
		model: anAss;
		add: ((DisplayString new)
			offset: 2@12;
			model: anAss);
		add: ((DisplayLine new)
			offset: (0@(26 - ampV));
			extent: (0@ampV));
		add: ((DisplayLine new)
			offset: 0@26;
			extent: (anAss value duration value / xScale - 4)@0))!

itemFor0: anAss
	"Answer the correct visual item for the given assoc. (sent from layoutManagers)."

	^(DisplayList new
		model: anAss;
		add: ((DisplayItem new)
			offset: 1@0;
			model: anAss;
			visual: (anAss value phoneme asDisplayText form));
		add: ((DisplayLine new)
"			offset: 0@12;
			extent: 0@(anAss value loudness value * 24 negated);
"			offset: 0@18;
			extent: (anAss value loudness value * 32)@0);
		add: ((DisplayLine new)
			offset: 0@14;
			extent: (anAss value duration value / xScale - 4)@0))!

itemFor: anAss
	"Answer the correct visual item for the given assoc. (sent from layoutManagers)."

	| ampV |
	ampV := anAss value loudness value * 32.
	^(DisplayList new
		model: anAss;
		add: ((DisplayString new)
			offset: 2@12;
			model: anAss);
		add: ((DisplayLine new)
			offset: (0@(26 - ampV));
			extent: (0@ampV));
		add: ((DisplayLine new)
			offset: 0@26;
			extent: (anAss value duration value / xScale - 4)@0))! !



Smalltalk.Siren defineClass: #EventListPanel
	superclass: #{UI.ApplicationModel}
	indexedType: #none
	private: false
	instanceVariableNames: 'editorView scoreView textView '
	classInstanceVariableNames: ''
	imports: ''
	category: 'MusicUI-Editors'!

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!


!Siren.EventListPanel class methodsFor: 'interface specs'!

windowSpec
	"Tools.UIPainter new openOnClass: self andSelector: #windowSpec"

	<resource: #canvas>
	^#(#{UI.FullSpec} 
		#window: 
		#(#{UI.WindowSpec} 
			#label: 
			#(#{Kernel.UserMessage} 
				#key: #UnlabeledCanvas 
				#defaultString: 'Event List Panel' 
				#catalogID: #labels ) 
			#bounds: #(#{Graphics.Rectangle} 645 261 1119 889 ) ) 
		#component: 
		#(#{UI.SpecCollection} 
			#collection: #(
				#(#{UI.SubCanvasSpec} 
					#layout: #(#{Graphics.LayoutFrame} 0 0 0 0 0 1 0 0.416666 ) 
					#name: #Dialog 
					#majorKey: #{Siren.EventListDialog} 
					#minorKey: #dialogCanvas 
					#clientKey: #editorView ) 
				#(#{UI.SubCanvasSpec} 
					#layout: #(#{Graphics.LayoutFrame} 0 0 0 0.416666 0 1 0 0.666666 ) 
					#name: #Text 
					#majorKey: #{Siren.EventListText} 
					#minorKey: #textCanvas1 
					#clientKey: #textView ) 
				#(#{UI.SubCanvasSpec} 
					#layout: #(#{Graphics.LayoutFrame} 0 0 0 0.666666 0 1 0 1 ) 
					#name: #Score 
					#majorKey: #{ScoreView} 
					#minorKey: #scoreCanvas1 
					#clientKey: #scoreView ) ) ) )! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!


!Siren.EventListPanel methodsFor: 'accessing'!

editorView
	"This method was generated by UIDefiner.  Any edits made here
	may be lost whenever methods are automatically defined.  The
	initialization provided below may have been preempted by an
	initialize method."

	^editorView isNil
		ifTrue:
			[editorView := Siren.EventListDialog new]
		ifFalse:
			[editorView]!

scoreView
	"This method was generated by UIDefiner.  Any edits made here
	may be lost whenever methods are automatically defined.  The
	initialization provided below may have been preempted by an
	initialize method."

	^scoreView isNil
		ifTrue:
			[scoreView := ScoreView new]
		ifFalse:
			[scoreView]!

textView
	"This method was generated by UIDefiner.  Any edits made here
	may be lost whenever methods are automatically defined.  The
	initialization provided below may have been preempted by an
	initialize method."

	^textView isNil
		ifTrue:
			[textView := Siren.EventListText new]
		ifFalse:
			[textView]! !



Smalltalk.Siren defineClass: #HauerSteffensView
	superclass: #{Siren.PitchTimeView}
	indexedType: #none
	private: false
	instanceVariableNames: ''
	classInstanceVariableNames: ''
	imports: ''
	category: 'MusicUI-Editors'!

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!


!Siren.HauerSteffensView class methodsFor: 'examples'!

randomExample
	"Open a HSView on two merged random event lists."
	"HauerSteffensView randomExample"

	HauerSteffensView openOnEventList:
		((EventList newNamed: #pRand)
				addAll:           (EventList randomExample);
				addAllAtEnd: (EventList randomExample);
				addAllAtEnd: (EventList randomExample);
				addAllAtEnd: (EventList randomExample);
				addAllAtEnd: (EventList randomExample))!

randomSWSSExample
	"Open a HSView on two merged random event lists."
	"HauerSteffensView randomSWSSExample"

	HauerSteffensView openOnEventList:
		((EventList newNamed: #sRand)
			addAll: (EventList randomSWSSExample2);
			addAll: (EventList randomSWSSExample2);
			addAll: (EventList randomSWSSExample2))! !

!Siren.HauerSteffensView class methodsFor: 'constant access'!

defaultCacheExtent
	"Answer the default extent of the receiver's instances' cache."

	^1000@600!

inset
	"Answer the default display inset."

	^16@16! !

!Siren.HauerSteffensView class methodsFor: 'instance creation'!

label
	"Answer the view label for the receiver's instances."

	^'Hauer-Steffens Event List View'! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!


!Siren.HauerSteffensView methodsFor: 'initialize-release'!

initialize
	"Initialize the instance variables of the receiver."

	super initialize.
	self initForm.
	pitchOffset := 30! !

!Siren.HauerSteffensView methodsFor: 'displaying'!

zoom: aPoint
	"Set the receiver's 'zoom' to be aPoint."

	xScale := xScaleDefault * aPoint x.
	yScale := yScaleDefault * aPoint y.
	self initForm.
	super zoom: aPoint! !

!Siren.HauerSteffensView methodsFor: 'private'!

clef: anInteger at: aPoint bottom: aBottom form: cForm
	"Display a C clef for the given octave at the given point."

	(aPoint y + 20) < aBottom ifTrue: 
		[(Text string: ('c', anInteger printString) emphasis: 2) 
				displayOn: cForm at: aPoint + (2 @ -3)]!

drawStaff
	"Display a Hauer-Stephens-type staff onto the given pixmap."

	| box top1 bottom1 left1 right1  left2 right2 aGC cGC aNum count octave |
	box := background bounds.
"	Transcript show: box printString; cr."
	aGC := background graphicsContext.
	aGC paint: self backgroundColor.
	aGC displayRectangle: background bounds.
	aGC paint: (clefColor == nil
				ifTrue: [ColorValue darkGray]
				ifFalse: [clefColor]).
	cGC := clefForm graphicsContext.
	cGC paint: self backgroundColor.
	cGC displayRectangle: clefForm bounds.
	cGC paint: (headColor == nil
				ifTrue: [ColorValue darkGray]
				ifFalse: [headColor]).
	top1 := box top.
	bottom1 := box bottom.
	left1 := box left.
	right1 := box right.
	left2 := clefForm bounds left.
	right2 := clefForm bounds right.
							"count number of octaves"
	octave := 8. "(bottom1 - top1 / (0 + (yScale * 2))) asInteger."
	aNum := top1.
	count := 3.
	[aNum < bottom1] whileTrue: 	"loop from top1 to bottom1 drawing lines"
		[aGC displayLineFrom: left1@aNum to: right1@aNum.
		cGC displayLineFrom: left2@aNum to: right2@aNum.
		count := count + 1.
		count \\ 5 = 1			"skip @ c"
			ifTrue: [(aNum + 20) < bottom1
					ifTrue: [('c', (octave - 2) printString) displayOn: cGC at: (left1@aNum) + (2 @ 12)].
				octave := octave - 1.
				aNum := aNum + yScale].			
		count \\ 5 = 4			"skip @ e"
			ifTrue: [aNum := aNum + yScale].
		aNum := aNum +  (yScale * 2)]!

initForm
	"Copy the default backgroundForm and draw a H-S staff on it."

	background := Pixmap extent: 2000@800.
	background background: self backgroundColor.
	clefForm := Pixmap extent: 32@800.
	clefForm background: self backgroundColor.
	yScale == nil
		ifFalse: [self drawStaff]! !



Smalltalk.Siren defineClass: #EventListTreeEditor
	superclass: #{UI.ApplicationModel}
	indexedType: #none
	private: false
	instanceVariableNames: 'scoreView listTree '
	classInstanceVariableNames: ''
	imports: ''
	category: 'MusicUI-Editors'!

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!


!Siren.EventListTreeEditor class methodsFor: 'resources'!

treeMenu	
	^Menu labelArray: #(copy cut paste again undo)! !

!Siren.EventListTreeEditor class methodsFor: 'interface specs'!

windowSpec
	"Tools.UIPainter new openOnClass: self andSelector: #windowSpec"

	<resource: #canvas>
	^#(#{UI.FullSpec} 
		#window: 
		#(#{UI.WindowSpec} 
			#label: 'Siren EventList Tree' 
			#bounds: #(#{Graphics.Rectangle} 528 71 1119 589 ) ) 
		#component: 
		#(#{UI.SpecCollection} 
			#collection: #(
				#(#{UI.TreeViewSpec} 
					#layout: #(#{Graphics.LayoutFrame} 0 0 0 0 -2 0.5 0 1 ) 
					#name: #treeView 
					#model: #listTree 
					#menu: #treeMenu 
					#useModifierKeys: true 
					#selectionType: #highlight ) 
				#(#{UI.ResizingSplitterSpec} 
					#layout: #(#{Graphics.LayoutFrame} -2 0.5 0 0 2 0.5 0 1 ) 
					#name: #ResizingSplitter1 
					#horizontal: false 
					#minAboveSize: 30 
					#minBelowSize: 30 
					#aboveWidgets: 'treeView' 
					#belowWidgets: 'subcanvas' ) 
				#(#{UI.SubCanvasSpec} 
					#layout: #(#{Graphics.LayoutFrame} 2 0.5 0 0 0 1 0 1 ) 
					#name: #subcanvas 
					#majorKey: #{Siren.DisplayListSubcanvas} 
					#minorKey: #windowSpec 
					#clientKey: #scoreView ) ) ) )! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!


!Siren.EventListTreeEditor methodsFor: 'aspects'!

listTree
	"Answer up the event list dictionary tree"

	^listTree! !

!Siren.EventListTreeEditor methodsFor: 'initialize/release'!

initialize
	"EventListTreeEditor open"

	| model |
	scoreView := Siren.DisplayListSubcanvas new.
	listTree := SelectionInTree new.
	model := TreeModel on: (EventListTreeItem new lists: SirenSession eventLists)
					displayRoot: false
					 childrenWith: [ :ea |  (ea isCollection)
							ifTrue: [ea values] 
							ifFalse: [ea children values]] .
	listTree list: model! !

!Siren.EventListTreeEditor methodsFor: 'accessing'!

scoreView
	"Answer up the score view"

	^scoreView! !



Smalltalk.Siren defineClass: #EventListText
	superclass: #{UI.ApplicationModel}
	indexedType: #none
	private: false
	instanceVariableNames: ''
	classInstanceVariableNames: ''
	imports: ''
	category: 'MusicUI-Editors'!



Smalltalk.Siren defineClass: #ScoreView
	superclass: #{UI.ApplicationModel}
	indexedType: #none
	private: false
	instanceVariableNames: ''
	classInstanceVariableNames: ''
	imports: ''
	category: 'MusicUI-Editors'!



Smalltalk.Siren defineClass: #PositionTimeView
	superclass: #{Siren.PitchTimeView}
	indexedType: #none
	private: false
	instanceVariableNames: ''
	classInstanceVariableNames: ''
	imports: ''
	category: 'MusicUI-Editors'!

!Siren.PositionTimeView methodsFor: 'initialize release'!

initialize
	"Initialize the instance variables of the receiver."

	super initialize.
	xScale := 15.
	yScale := 40.
	pitchOffset := 40! !

!Siren.PositionTimeView methodsFor: 'layout manager access'!

layoutManager
	"Answer a default layout manager for the receiver."

	^(PositionTimeLayoutManager new)
			timeScale: xScale;
			timeOffset: page x;
			pitchScale: yScale;
			pitchOffset: pitchOffset! !



Smalltalk.Siren defineClass: #ClusterEditor
	superclass: #{UI.ApplicationModel}
	indexedType: #none
	private: false
	instanceVariableNames: 'mode scale process events tScale numEvents running defaultVoiceClass players playerStates playerVoices durationList maxPitch minDur minPitch pitchList maxDur minAmpl minVoice maxVoice amplList maxAmpl voiceList tempo volume7 volume9 volume8 volume5 volume3 volume4 volume2 volume10 volume6 volume1 '
	classInstanceVariableNames: ''
	imports: ''
	category: 'MusicUI-Editors'!

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!


!Siren.ClusterEditor class methodsFor: 'interface specs'!

buttonSpec
	"Tools.UIPainter new openOnClass: self andSelector: #buttonSpec"

	<resource: #canvas>
	^#(#{UI.FullSpec} 
		#window: 
		#(#{UI.WindowSpec} 
			#properties: #(#{UI.PropertyListDictionary} #positionAutoSave true #sizeType #specifiedSize #openType #advanced #positionType #lastSavedPosition ) 
			#label: 'Player Control' 
			#min: #(#{Core.Point} 543 337 ) 
			#max: #(#{Core.Point} 543 337 ) 
			#bounds: #(#{Graphics.Rectangle} 863 580 1406 917 ) 
			#colors: 
			#(#{UI.LookPreferences} 
				#setForegroundColor: #(#{Graphics.ColorValue} #black ) 
				#setBackgroundColor: #(#{Graphics.ColorValue} 5938 5054 5057 ) 
				#setSelectionForegroundColor: #(#{Graphics.ColorValue} #black ) 
				#setSelectionBackgroundColor: #(#{Graphics.ColorValue} 6144 6144 5632 ) 
				#setBorderColor: #(#{Graphics.ColorValue} #lightGray ) ) ) 
		#component: 
		#(#{UI.SpecCollection} 
			#collection: #(
				#(#{UI.LabelSpec} 
					#layout: #(#{Graphics.LayoutOrigin} 17.0 0 15 0 ) 
					#name: #Label7 
					#colors: 
					#(#{UI.LookPreferences} 
						#setForegroundColor: #(#{Graphics.ColorValue} 5529 0 33 ) ) 
					#label: 'Strings 1' 
					#style: #large ) 
				#(#{UI.ActionButtonSpec} 
					#layout: #(#{Graphics.LayoutFrame} 77 0 14 0 177 0 35 0 ) 
					#name: #start1 
					#colors: 
					#(#{UI.LookPreferences} 
						#setBackgroundColor: #(#{Graphics.ColorValue} 5119 5119 8191 ) 
						#setSelectionForegroundColor: #(#{Graphics.ColorValue} 7700 7700 7700 ) 
						#setSelectionBackgroundColor: #(#{Graphics.ColorValue} #red ) ) 
					#model: #start1 
					#tabable: false 
					#label: 'Start' 
					#style: #large ) 
				#(#{UI.ActionButtonSpec} 
					#layout: #(#{Graphics.LayoutFrame} 181 0 14 0 281 0 35 0 ) 
					#name: #refresh1 
					#colors: 
					#(#{UI.LookPreferences} 
						#setBackgroundColor: #(#{Graphics.ColorValue} 5119 5119 8191 ) ) 
					#model: #refresh1 
					#tabable: false 
					#label: 'Refresh' 
					#style: #large ) 
				#(#{UI.LabelSpec} 
					#layout: #(#{Graphics.LayoutOrigin} 17.0 0 47 0 ) 
					#name: #Label6 
					#colors: 
					#(#{UI.LookPreferences} 
						#setForegroundColor: #(#{Graphics.ColorValue} 5529 0 33 ) ) 
					#label: 'Strings 2' 
					#style: #large ) 
				#(#{UI.ActionButtonSpec} 
					#layout: #(#{Graphics.LayoutFrame} 77 0 46 0 177 0 67 0 ) 
					#name: #start2 
					#isOpaque: true 
					#colors: 
					#(#{UI.LookPreferences} 
						#setBackgroundColor: #(#{Graphics.ColorValue} 5119 2048 8191 ) ) 
					#model: #start2 
					#tabable: false 
					#label: 'Start' 
					#style: #large ) 
				#(#{UI.ActionButtonSpec} 
					#layout: #(#{Graphics.LayoutFrame} 181 0 46 0 281 0 67 0 ) 
					#name: #refresh2 
					#isOpaque: true 
					#colors: 
					#(#{UI.LookPreferences} 
						#setBackgroundColor: #(#{Graphics.ColorValue} 5119 2048 8191 ) ) 
					#model: #refresh2 
					#tabable: false 
					#label: 'Refresh' 
					#style: #large ) 
				#(#{UI.LabelSpec} 
					#layout: #(#{Graphics.LayoutOrigin} 25.5518 0 80 0 ) 
					#name: #Label5 
					#colors: 
					#(#{UI.LookPreferences} 
						#setForegroundColor: #(#{Graphics.ColorValue} 5529 0 33 ) ) 
					#label: 'Voice 1' 
					#style: #large ) 
				#(#{UI.ActionButtonSpec} 
					#layout: #(#{Graphics.LayoutFrame} 77 0 79 0 177 0 100 0 ) 
					#name: #start3 
					#isOpaque: true 
					#colors: 
					#(#{UI.LookPreferences} 
						#setBackgroundColor: #(#{Graphics.ColorValue} 6440 5302 7585 ) ) 
					#model: #start3 
					#tabable: false 
					#label: 'Start' 
					#style: #large ) 
				#(#{UI.ActionButtonSpec} 
					#layout: #(#{Graphics.LayoutFrame} 181 0 79 0 281 0 100 0 ) 
					#name: #refresh3 
					#isOpaque: true 
					#colors: 
					#(#{UI.LookPreferences} 
						#setBackgroundColor: #(#{Graphics.ColorValue} 6440 5302 7585 ) ) 
					#model: #refresh3 
					#tabable: false 
					#label: 'Refresh' 
					#style: #large ) 
				#(#{UI.LabelSpec} 
					#layout: #(#{Graphics.LayoutOrigin} 29.4619 0 303 0 ) 
					#name: #Label8 
					#colors: 
					#(#{UI.LookPreferences} 
						#setForegroundColor: #(#{Graphics.ColorValue} 5529 0 33 ) ) 
					#label: 'Walk 4' 
					#style: #large ) 
				#(#{UI.ActionButtonSpec} 
					#layout: #(#{Graphics.LayoutFrame} 77 0 302 0 177 0 323 0 ) 
					#name: #start10 
					#isOpaque: true 
					#colors: 
					#(#{UI.LookPreferences} 
						#setBackgroundColor: #(#{Graphics.ColorValue} 7437 7437 0 ) ) 
					#model: #start10 
					#tabable: false 
					#label: 'Start' 
					#style: #large ) 
				#(#{UI.ActionButtonSpec} 
					#layout: #(#{Graphics.LayoutFrame} 181 0 302 0 281 0 323 0 ) 
					#name: #refresh10 
					#isOpaque: true 
					#colors: 
					#(#{UI.LookPreferences} 
						#setBackgroundColor: #(#{Graphics.ColorValue} 7437 7437 0 ) ) 
					#model: #refresh10 
					#tabable: false 
					#label: 'Refresh' 
					#style: #large ) 
				#(#{UI.LabelSpec} 
					#layout: #(#{Graphics.LayoutOrigin} 29.4619 0 271 0 ) 
					#name: #Label9 
					#colors: 
					#(#{UI.LookPreferences} 
						#setForegroundColor: #(#{Graphics.ColorValue} 5529 0 33 ) ) 
					#label: 'Walk 3' 
					#style: #large ) 
				#(#{UI.ActionButtonSpec} 
					#layout: #(#{Graphics.LayoutFrame} 77 0 270 0 177 0 291 0 ) 
					#name: #start9 
					#isOpaque: true 
					#colors: 
					#(#{UI.LookPreferences} 
						#setBackgroundColor: #(#{Graphics.ColorValue} 8191 5631 3072 ) ) 
					#model: #start9 
					#tabable: false 
					#label: 'Start' 
					#style: #large ) 
				#(#{UI.ActionButtonSpec} 
					#layout: #(#{Graphics.LayoutFrame} 181 0 270 0 281 0 291 0 ) 
					#name: #refresh9 
					#isOpaque: true 
					#colors: 
					#(#{UI.LookPreferences} 
						#setBackgroundColor: #(#{Graphics.ColorValue} 8191 5631 3072 ) ) 
					#model: #refresh9 
					#tabable: false 
					#label: 'Refresh' 
					#style: #large ) 
				#(#{UI.LabelSpec} 
					#layout: #(#{Graphics.LayoutOrigin} 29.4619 0 239 0 ) 
					#name: #Label10 
					#colors: 
					#(#{UI.LookPreferences} 
						#setForegroundColor: #(#{Graphics.ColorValue} 5529 0 33 ) ) 
					#label: 'Walk 2' 
					#style: #large ) 
				#(#{UI.ActionButtonSpec} 
					#layout: #(#{Graphics.LayoutFrame} 77 0 238 0 177 0 259 0 ) 
					#name: #start8 
					#isOpaque: true 
					#colors: 
					#(#{UI.LookPreferences} 
						#setBackgroundColor: #(#{Graphics.ColorValue} 8191 1671 1671 ) ) 
					#model: #start8 
					#tabable: false 
					#label: 'Start' 
					#style: #large ) 
				#(#{UI.ActionButtonSpec} 
					#layout: #(#{Graphics.LayoutFrame} 181 0 238 0 281 0 259 0 ) 
					#name: #refresh8 
					#isOpaque: true 
					#colors: 
					#(#{UI.LookPreferences} 
						#setBackgroundColor: #(#{Graphics.ColorValue} 8191 1671 1671 ) ) 
					#model: #refresh8 
					#tabable: false 
					#label: 'Refresh' 
					#style: #large ) 
				#(#{UI.LabelSpec} 
					#layout: #(#{Graphics.LayoutOrigin} 29.4619 0 207 0 ) 
					#name: #Label1 
					#colors: 
					#(#{UI.LookPreferences} 
						#setForegroundColor: #(#{Graphics.ColorValue} 5529 0 33 ) ) 
					#label: 'Walk 1' 
					#style: #large ) 
				#(#{UI.ActionButtonSpec} 
					#layout: #(#{Graphics.LayoutFrame} 77 0 206 0 177 0 227 0 ) 
					#name: #start7 
					#isOpaque: true 
					#colors: 
					#(#{UI.LookPreferences} 
						#setBackgroundColor: #(#{Graphics.ColorValue} 6422 3213 0 ) ) 
					#model: #start7 
					#tabable: false 
					#label: 'Start' 
					#style: #large ) 
				#(#{UI.ActionButtonSpec} 
					#layout: #(#{Graphics.LayoutFrame} 181 0 206 0 281 0 227 0 ) 
					#name: #refresh7 
					#isOpaque: true 
					#colors: 
					#(#{UI.LookPreferences} 
						#setBackgroundColor: #(#{Graphics.ColorValue} 6422 3213 0 ) ) 
					#model: #refresh7 
					#tabable: false 
					#label: 'Refresh' 
					#style: #large ) 
				#(#{UI.LabelSpec} 
					#layout: #(#{Graphics.LayoutOrigin} 20.1104 0 175 0 ) 
					#name: #Label2 
					#colors: 
					#(#{UI.LookPreferences} 
						#setForegroundColor: #(#{Graphics.ColorValue} 5529 0 33 ) ) 
					#label: 'Vector 2' 
					#style: #large ) 
				#(#{UI.ActionButtonSpec} 
					#layout: #(#{Graphics.LayoutFrame} 77 0 174 0 177 0 195 0 ) 
					#name: #start6 
					#isOpaque: true 
					#colors: 
					#(#{UI.LookPreferences} 
						#setBackgroundColor: #(#{Graphics.ColorValue} 7061 0 3532 ) ) 
					#model: #start6 
					#tabable: false 
					#label: 'Start' 
					#style: #large ) 
				#(#{UI.ActionButtonSpec} 
					#layout: #(#{Graphics.LayoutFrame} 181 0 174 0 281 0 195 0 ) 
					#name: #refresh6 
					#isOpaque: true 
					#colors: 
					#(#{UI.LookPreferences} 
						#setBackgroundColor: #(#{Graphics.ColorValue} 7061 0 3532 ) ) 
					#model: #refresh6 
					#tabable: false 
					#label: 'Refresh' 
					#style: #large ) 
				#(#{UI.LabelSpec} 
					#layout: #(#{Graphics.LayoutOrigin} 20.1104 0 143 0 ) 
					#name: #Label3 
					#colors: 
					#(#{UI.LookPreferences} 
						#setForegroundColor: #(#{Graphics.ColorValue} 5529 0 33 ) ) 
					#label: 'Vector 1' 
					#style: #large ) 
				#(#{UI.ActionButtonSpec} 
					#layout: #(#{Graphics.LayoutFrame} 77 0 142 0 177 0 163 0 ) 
					#name: #start5 
					#isOpaque: true 
					#colors: 
					#(#{UI.LookPreferences} 
						#setBackgroundColor: #(#{Graphics.ColorValue} 6684 2921 4798 ) ) 
					#model: #start5 
					#tabable: false 
					#label: 'Start' 
					#style: #large ) 
				#(#{UI.ActionButtonSpec} 
					#layout: #(#{Graphics.LayoutFrame} 181 0 142 0 281 0 163 0 ) 
					#name: #refresh5 
					#isOpaque: true 
					#colors: 
					#(#{UI.LookPreferences} 
						#setBackgroundColor: #(#{Graphics.ColorValue} 6684 2921 4798 ) ) 
					#model: #refresh5 
					#tabable: false 
					#label: 'Refresh' 
					#style: #large ) 
				#(#{UI.LabelSpec} 
					#layout: #(#{Graphics.LayoutOrigin} 25.5518 0 110 0 ) 
					#name: #Label4 
					#colors: 
					#(#{UI.LookPreferences} 
						#setForegroundColor: #(#{Graphics.ColorValue} 5529 0 33 ) ) 
					#label: 'Voice 2' 
					#style: #large ) 
				#(#{UI.ActionButtonSpec} 
					#layout: #(#{Graphics.LayoutFrame} 77 0 109 0 177 0 130 0 ) 
					#name: #start4 
					#isOpaque: true 
					#colors: 
					#(#{UI.LookPreferences} 
						#setBackgroundColor: #(#{Graphics.ColorValue} 6659 946 979 ) ) 
					#model: #start4 
					#tabable: false 
					#label: 'Start' 
					#style: #large ) 
				#(#{UI.ActionButtonSpec} 
					#layout: #(#{Graphics.LayoutFrame} 181 0 109 0 281 0 130 0 ) 
					#name: #refresh4 
					#isOpaque: true 
					#colors: 
					#(#{UI.LookPreferences} 
						#setBackgroundColor: #(#{Graphics.ColorValue} 6659 946 979 ) ) 
					#model: #refresh4 
					#tabable: false 
					#label: 'Refresh' 
					#style: #large ) 
				#(#{UI.SliderSpec} 
					#layout: #(#{Graphics.LayoutFrame} 292 0 19 0 524 0 32 0 ) 
					#name: #Slider1 
					#model: #volume1 
					#orientation: #horizontal 
					#start: 0 
					#stop: 1.5 ) 
				#(#{UI.SliderSpec} 
					#layout: #(#{Graphics.LayoutFrame} 292 0 243 0 524 0 256 0 ) 
					#name: #Slider8 
					#model: #volume8 
					#orientation: #horizontal 
					#start: 0 
					#stop: 1.5 ) 
				#(#{UI.SliderSpec} 
					#layout: #(#{Graphics.LayoutFrame} 292 0 211 0 524 0 224 0 ) 
					#name: #Slider7 
					#model: #volume7 
					#orientation: #horizontal 
					#start: 0 
					#stop: 1.5 ) 
				#(#{UI.SliderSpec} 
					#layout: #(#{Graphics.LayoutFrame} 292 0 179 0 524 0 192 0 ) 
					#name: #Slider6 
					#model: #volume6 
					#orientation: #horizontal 
					#start: 0 
					#stop: 1.5 ) 
				#(#{UI.SliderSpec} 
					#layout: #(#{Graphics.LayoutFrame} 292 0 147 0 524 0 160 0 ) 
					#name: #Slider5 
					#model: #volume5 
					#orientation: #horizontal 
					#start: 0 
					#stop: 1.5 ) 
				#(#{UI.SliderSpec} 
					#layout: #(#{Graphics.LayoutFrame} 292 0 115 0 524 0 128 0 ) 
					#name: #Slider4 
					#model: #volume4 
					#orientation: #horizontal 
					#start: 0 
					#stop: 1.5 ) 
				#(#{UI.SliderSpec} 
					#layout: #(#{Graphics.LayoutFrame} 292 0 83 0 524 0 96 0 ) 
					#name: #Slider3 
					#model: #volume3 
					#orientation: #horizontal 
					#start: 0 
					#stop: 1.5 ) 
				#(#{UI.SliderSpec} 
					#layout: #(#{Graphics.LayoutFrame} 292 0 51 0 524 0 64 0 ) 
					#name: #Slider2 
					#model: #volume2 
					#orientation: #horizontal 
					#start: 0 
					#stop: 1.5 ) 
				#(#{UI.SliderSpec} 
					#layout: #(#{Graphics.LayoutFrame} 292 0 275 0 524 0 288 0 ) 
					#name: #Slider9 
					#model: #volume9 
					#orientation: #horizontal 
					#start: 0 
					#stop: 1.5 ) 
				#(#{UI.SliderSpec} 
					#layout: #(#{Graphics.LayoutFrame} 292 0 307 0 524 0 320 0 ) 
					#name: #Slider10 
					#model: #volume10 
					#orientation: #horizontal 
					#start: 0 
					#stop: 1.5 ) ) ) )!

windowSpec
	"Tools.UIPainter new openOnClass: self andSelector: #windowSpec"

	<resource: #canvas>
	^#(#{UI.FullSpec} 
		#window: 
		#(#{UI.WindowSpec} 
			#properties: #(#{UI.PropertyListDictionary} #sizeAutoSave true #positionAutoSave true #sizeType #lastSavedSize #openType #advanced #positionType #lastSavedPosition ) 
			#label: 'Cluster/Ostinato Editor' 
			#min: #(#{Core.Point} 527 264 ) 
			#max: #(#{Core.Point} 527 264 ) 
			#bounds: #(#{Graphics.Rectangle} 866 582 1393 846 ) 
			#colors: 
			#(#{UI.LookPreferences} 
				#setForegroundColor: #(#{Graphics.ColorValue} #black ) 
				#setBackgroundColor: #(#{Graphics.ColorValue} 4137 5250 6364 ) 
				#setSelectionForegroundColor: #(#{Graphics.ColorValue} #black ) 
				#setSelectionBackgroundColor: #(#{Graphics.ColorValue} 6144 6144 5632 ) 
				#setBorderColor: #(#{Graphics.ColorValue} #lightGray ) ) ) 
		#component: 
		#(#{UI.SpecCollection} 
			#collection: #(
				#(#{UI.MenuButtonSpec} 
					#layout: #(#{Graphics.LayoutFrame} 29 0 53 0 125 0 71 0 ) 
					#name: #voiceMenu 
					#model: #defaultVoiceClass 
					#label: 'MIDI' 
					#menu: #voiceMenu ) 
				#(#{UI.LabelSpec} 
					#layout: #(#{Graphics.LayoutOrigin} 20 0 29 0 ) 
					#name: #Label1 
					#colors: 
					#(#{UI.LookPreferences} 
						#setForegroundColor: #(#{Graphics.ColorValue} 0 4096 8191 ) ) 
					#label: 'Voice' 
					#style: #systemDefault ) 
				#(#{UI.ActionButtonSpec} 
					#layout: #(#{Graphics.LayoutFrame} 28 0 115 0 124 0 133 0 ) 
					#name: #ActionButton1 
					#colors: 
					#(#{UI.LookPreferences} 
						#setBackgroundColor: #(#{Graphics.ColorValue} 6655 8191 5119 ) ) 
					#model: #testMIDI 
					#label: 'Test MIDI I/O' 
					#style: #systemDefault 
					#defaultable: true ) 
				#(#{UI.ActionButtonSpec} 
					#layout: #(#{Graphics.LayoutFrame} 28 0 84 0 124 0 102 0 ) 
					#name: #configMIDI 
					#colors: 
					#(#{UI.LookPreferences} 
						#setBackgroundColor: #(#{Graphics.ColorValue} 8191 6655 5119 ) ) 
					#model: #configureMIDI 
					#label: 'Configure MIDI' 
					#style: #systemDefault 
					#defaultable: true ) 
				#(#{UI.ActionButtonSpec} 
					#layout: #(#{Graphics.LayoutFrame} 28 0 146 0 124 0 164 0 ) 
					#name: #testOSC 
					#colors: 
					#(#{UI.LookPreferences} 
						#setBackgroundColor: #(#{Graphics.ColorValue} 7044 7044 7044 ) ) 
					#model: #testOSCout 
					#label: 'Test OSC' 
					#style: #systemDefault 
					#defaultable: true ) 
				#(#{UI.ActionButtonSpec} 
					#layout: #(#{Graphics.LayoutFrame} 28 0 177 0 124 0 195 0 ) 
					#name: #ActionButton3 
					#colors: 
					#(#{UI.LookPreferences} 
						#setBackgroundColor: #(#{Graphics.ColorValue} 5119 8191 8191 ) ) 
					#model: #stopMIDI 
					#label: 'Stop MIDI' 
					#style: #systemDefault 
					#defaultable: true ) 
				#(#{UI.InputFieldSpec} 
					#layout: #(#{Graphics.LayoutFrame} 200 0 45 0 242 0 69 0 ) 
					#name: #minPitchField 
					#model: #minPitch 
					#style: #systemDefault 
					#type: #number ) 
				#(#{UI.InputFieldSpec} 
					#layout: #(#{Graphics.LayoutFrame} 277 0 45 0 319 0 69 0 ) 
					#name: #maxPitchField 
					#model: #maxPitch 
					#style: #systemDefault 
					#type: #number ) 
				#(#{UI.MenuButtonSpec} 
					#properties: #(#{UI.PropertyListDictionary} #labelFromApplication false ) 
					#layout: #(#{Graphics.LayoutFrame} 171 0 100 0 318 0 121 0 ) 
					#name: #scale 
					#model: #scale 
					#label: 'Pentatonic' 
					#menu: #scaleMenu ) 
				#(#{UI.LabelSpec} 
					#layout: #(#{Graphics.LayoutOrigin} 11 0 3 0 ) 
					#name: #Label7 
					#label: 'Output' 
					#style: #large ) 
				#(#{UI.LabelSpec} 
					#layout: #(#{Graphics.LayoutOrigin} 354 0 121 0 ) 
					#name: #Label2 
					#label: 'Thread' 
					#style: #large ) 
				#(#{UI.LabelSpec} 
					#layout: #(#{Graphics.LayoutOrigin} 142 0 3 0 ) 
					#name: #Label3 
					#label: 'Contents' 
					#style: #large ) 
				#(#{UI.LabelSpec} 
					#layout: #(#{Graphics.LayoutOrigin} 160 0 29 0 ) 
					#name: #Label4 
					#colors: 
					#(#{UI.LookPreferences} 
						#setForegroundColor: #(#{Graphics.ColorValue} 0 4096 8191 ) ) 
					#label: 'Pitches' 
					#style: #systemDefault ) 
				#(#{UI.LabelSpec} 
					#layout: #(#{Graphics.LayoutOrigin} 169 0 49 0 ) 
					#name: #Label5 
					#label: 'Min' 
					#style: #systemDefault ) 
				#(#{UI.LabelSpec} 
					#layout: #(#{Graphics.LayoutOrigin} 249 0 49 0 ) 
					#name: #Label8 
					#label: 'Max' 
					#style: #systemDefault ) 
				#(#{UI.InputFieldSpec} 
					#layout: #(#{Graphics.LayoutFrame} 170 0 71 0 319 0 95 0 ) 
					#name: #pitchLidtField 
					#model: #pitchList 
					#style: #systemDefault 
					#type: #string ) 
				#(#{UI.ActionButtonSpec} 
					#layout: #(#{Graphics.LayoutFrame} 414 0 118 0 516 0 139 0 ) 
					#name: #startButton 
					#colors: 
					#(#{UI.LookPreferences} 
						#setBackgroundColor: #(#{Graphics.ColorValue} 5119 5119 8191 ) ) 
					#model: #startStop 
					#tabable: false 
					#label: 'Start' 
					#style: #large ) 
				#(#{UI.RadioButtonSpec} 
					#layout: #(#{Graphics.LayoutOrigin} 380 0 145 0 ) 
					#name: #clusterButton1 
					#model: #mode 
					#label: 'Cluster' 
					#select: #cluster ) 
				#(#{UI.RadioButtonSpec} 
					#layout: #(#{Graphics.LayoutOrigin} 380 0 168 0 ) 
					#name: #ostButton 
					#model: #mode 
					#label: 'Ostinato' 
					#select: #ostinato ) 
				#(#{UI.LabelSpec} 
					#layout: #(#{Graphics.LayoutOrigin} 155 0 127 0 ) 
					#name: #Label6 
					#colors: 
					#(#{UI.LookPreferences} 
						#setForegroundColor: #(#{Graphics.ColorValue} 0 4096 8191 ) ) 
					#label: 'Durations' 
					#style: #systemDefault ) 
				#(#{UI.LabelSpec} 
					#layout: #(#{Graphics.LayoutOrigin} 164 0 149 0 ) 
					#name: #Label9 
					#label: 'Min' 
					#style: #systemDefault ) 
				#(#{UI.InputFieldSpec} 
					#layout: #(#{Graphics.LayoutFrame} 190 0 146 0 237 0 166 0 ) 
					#name: #minDurField 
					#model: #minDur 
					#style: #systemDefault 
					#type: #number ) 
				#(#{UI.LabelSpec} 
					#layout: #(#{Graphics.LayoutOrigin} 244 0 149 0 ) 
					#name: #Label10 
					#label: 'Max' 
					#style: #systemDefault ) 
				#(#{UI.InputFieldSpec} 
					#layout: #(#{Graphics.LayoutFrame} 271 0 146 0 318 0 165 0 ) 
					#name: #maxDurField 
					#model: #maxDur 
					#style: #systemDefault 
					#type: #number ) 
				#(#{UI.ActionButtonSpec} 
					#layout: #(#{Graphics.LayoutFrame} 219 0 12 0 276 0 33 0 ) 
					#name: #AddButton 
					#colors: 
					#(#{UI.LookPreferences} 
						#setBackgroundColor: #(#{Graphics.ColorValue} 5119 6655 8191 ) ) 
					#model: #addPitch 
					#label: 'Add' 
					#defaultable: true ) 
				#(#{UI.ActionButtonSpec} 
					#layout: #(#{Graphics.LayoutFrame} 275 0 12 0 332 0 33 0 ) 
					#name: #removeButton 
					#colors: 
					#(#{UI.LookPreferences} 
						#setBackgroundColor: #(#{Graphics.ColorValue} 5119 8191 5119 ) ) 
					#model: #removePitch 
					#label: 'Remove' 
					#defaultable: true ) 
				#(#{UI.RadioButtonSpec} 
					#layout: #(#{Graphics.LayoutOrigin} 380 0 189 0 ) 
					#name: #cloudButton 
					#model: #mode 
					#label: 'Cloud' 
					#select: #cloud ) 
				#(#{UI.ActionButtonSpec} 
					#layout: #(#{Graphics.LayoutFrame} 433 0 231 0 490 0 249 0 ) 
					#name: #loadButton 
					#colors: 
					#(#{UI.LookPreferences} 
						#setBackgroundColor: #(#{Graphics.ColorValue} 8191 5119 5119 ) ) 
					#model: #load 
					#label: 'Load' 
					#defaultable: true ) 
				#(#{UI.ActionButtonSpec} 
					#layout: #(#{Graphics.LayoutFrame} 377 0 231 0 434 0 249 0 ) 
					#name: #saveButton 
					#colors: 
					#(#{UI.LookPreferences} 
						#setBackgroundColor: #(#{Graphics.ColorValue} 6655 5119 8191 ) ) 
					#model: #save 
					#label: 'Save' 
					#defaultable: true ) 
				#(#{UI.LabelSpec} 
					#layout: #(#{Graphics.LayoutOrigin} 154 0 191 0 ) 
					#name: #Label11 
					#colors: 
					#(#{UI.LookPreferences} 
						#setForegroundColor: #(#{Graphics.ColorValue} 0 4096 8191 ) ) 
					#label: 'Amplitudes' 
					#style: #systemDefault ) 
				#(#{UI.LabelSpec} 
					#layout: #(#{Graphics.LayoutOrigin} 163 0 213 0 ) 
					#name: #Label12 
					#label: 'Min' 
					#style: #systemDefault ) 
				#(#{UI.InputFieldSpec} 
					#layout: #(#{Graphics.LayoutFrame} 189 0 210 0 236 0 229 0 ) 
					#name: #minAmplField 
					#model: #minAmpl 
					#style: #systemDefault 
					#type: #number ) 
				#(#{UI.LabelSpec} 
					#layout: #(#{Graphics.LayoutOrigin} 243 0 213 0 ) 
					#name: #Label13 
					#label: 'Max' 
					#style: #systemDefault ) 
				#(#{UI.InputFieldSpec} 
					#layout: #(#{Graphics.LayoutFrame} 270 0 210 0 317 0 229 0 ) 
					#name: #maxAmplField 
					#model: #maxAmpl 
					#style: #systemDefault 
					#type: #number ) 
				#(#{UI.LabelSpec} 
					#layout: #(#{Graphics.LayoutOrigin} 355 0 29 0 ) 
					#name: #Label14 
					#colors: 
					#(#{UI.LookPreferences} 
						#setForegroundColor: #(#{Graphics.ColorValue} 0 4096 8191 ) ) 
					#label: 'Voices' 
					#style: #systemDefault ) 
				#(#{UI.LabelSpec} 
					#layout: #(#{Graphics.LayoutOrigin} 364 0 47 0 ) 
					#name: #Label15 
					#label: 'Min' 
					#style: #systemDefault ) 
				#(#{UI.InputFieldSpec} 
					#layout: #(#{Graphics.LayoutFrame} 390 0 43 0 437 0 67 0 ) 
					#name: #minVoiceField 
					#model: #minVoice 
					#style: #systemDefault 
					#type: #number ) 
				#(#{UI.LabelSpec} 
					#layout: #(#{Graphics.LayoutOrigin} 444 0 47 0 ) 
					#name: #Label16 
					#label: 'Max' 
					#style: #systemDefault ) 
				#(#{UI.InputFieldSpec} 
					#layout: #(#{Graphics.LayoutFrame} 471 0 43 0 518 0 67 0 ) 
					#name: #maxVoiceField 
					#model: #maxVoice 
					#style: #systemDefault 
					#type: #number ) 
				#(#{UI.InputFieldSpec} 
					#layout: #(#{Graphics.LayoutFrame} 169 0 166 0 318 0 190 0 ) 
					#name: #durationListField 
					#model: #durationList 
					#style: #systemDefault 
					#type: #string ) 
				#(#{UI.InputFieldSpec} 
					#layout: #(#{Graphics.LayoutFrame} 168 0 230 0 317 0 254 0 ) 
					#name: #amplListField 
					#model: #amplList 
					#style: #systemDefault 
					#type: #string ) 
				#(#{UI.InputFieldSpec} 
					#layout: #(#{Graphics.LayoutFrame} 369 0 68 0 518 0 92 0 ) 
					#name: #voiceListField 
					#model: #voiceList 
					#style: #systemDefault 
					#type: #string ) 
				#(#{UI.ActionButtonSpec} 
					#layout: #(#{Graphics.LayoutFrame} 436 0 13 0 471 0 31 0 ) 
					#name: #ActionButton2 
					#colors: 
					#(#{UI.LookPreferences} 
						#setBackgroundColor: #(#{Graphics.ColorValue} 5119 6655 8191 ) ) 
					#model: #addEvent 
					#label: '+' 
					#defaultable: true ) 
				#(#{UI.ActionButtonSpec} 
					#layout: #(#{Graphics.LayoutFrame} 470 0 13 0 505 0 31 0 ) 
					#name: #ActionButton4 
					#colors: 
					#(#{UI.LookPreferences} 
						#setBackgroundColor: #(#{Graphics.ColorValue} 5119 8191 5119 ) ) 
					#model: #removeEvent 
					#label: '-' 
					#defaultable: true ) 
				#(#{UI.InputFieldSpec} 
					#layout: #(#{Graphics.LayoutFrame} 404 0 12 0 434 0 36 0 ) 
					#name: #numEventsField 
					#model: #numEvents 
					#style: #systemDefault 
					#type: #number ) 
				#(#{UI.SliderSpec} 
					#layout: #(#{Graphics.LayoutFrame} 335 0 82 0 348 0 241 0 ) 
					#name: #tempoSlider 
					#model: #tempo 
					#orientation: #vertical 
					#start: 0.125 
					#stop: 2 ) ) ) )!

windowSpec1
	"Tools.UIPainter new openOnClass: self andSelector: #windowSpec1"

	<resource: #canvas>
	^#(#{UI.FullSpec} 
		#window: 
		#(#{UI.WindowSpec} 
			#properties: #(#{UI.PropertyListDictionary} #positionAutoSave true #sizeType #specifiedSize #openType #advanced #positionType #lastSavedPosition ) 
			#label: 'Cluster/Ostinato Editor' 
			#min: #(#{Core.Point} 572 190 ) 
			#max: #(#{Core.Point} 572 190 ) 
			#bounds: #(#{Graphics.Rectangle} 870 594 1442 774 ) 
			#colors: 
			#(#{UI.LookPreferences} 
				#setForegroundColor: #(#{Graphics.ColorValue} #black ) 
				#setBackgroundColor: #(#{Graphics.ColorValue} 6130 6974 7421 ) 
				#setSelectionForegroundColor: #(#{Graphics.ColorValue} #black ) 
				#setSelectionBackgroundColor: #(#{Graphics.ColorValue} 6144 6144 5632 ) 
				#setBorderColor: #(#{Graphics.ColorValue} #lightGray ) ) ) 
		#component: 
		#(#{UI.SpecCollection} 
			#collection: #(
				#(#{UI.MenuButtonSpec} 
					#layout: #(#{Graphics.LayoutFrame} 29 0 49 0 125 0 70 0 ) 
					#name: #voiceMenu 
					#model: #defaultVoiceClass 
					#label: 'MIDI' 
					#menu: #voiceMenu ) 
				#(#{UI.LabelSpec} 
					#layout: #(#{Graphics.LayoutOrigin} 20 0 33 0 ) 
					#name: #Label1 
					#colors: 
					#(#{UI.LookPreferences} 
						#setForegroundColor: #(#{Graphics.ColorValue} 0 4096 8191 ) ) 
					#label: 'Voice' 
					#style: #systemDefault ) 
				#(#{UI.ActionButtonSpec} 
					#layout: #(#{Graphics.LayoutFrame} 28 0 100 0 124 0 121 0 ) 
					#name: #ActionButton1 
					#colors: 
					#(#{UI.LookPreferences} 
						#setBackgroundColor: #(#{Graphics.ColorValue} 6655 8191 5119 ) ) 
					#model: #testMIDI 
					#label: 'Test MIDI I/O' 
					#style: #systemDefault 
					#defaultable: true ) 
				#(#{UI.ActionButtonSpec} 
					#layout: #(#{Graphics.LayoutFrame} 28 0 74 0 124 0 95 0 ) 
					#name: #configMIDI 
					#colors: 
					#(#{UI.LookPreferences} 
						#setBackgroundColor: #(#{Graphics.ColorValue} 8191 6655 5119 ) ) 
					#model: #configureMIDI 
					#label: 'Configure MIDI' 
					#style: #systemDefault 
					#defaultable: true ) 
				#(#{UI.ActionButtonSpec} 
					#layout: #(#{Graphics.LayoutFrame} 28 0 126 0 124 0 147 0 ) 
					#name: #testOSC 
					#colors: 
					#(#{UI.LookPreferences} 
						#setBackgroundColor: #(#{Graphics.ColorValue} 7044 7044 7044 ) ) 
					#model: #testOSCout 
					#label: 'Test OSC' 
					#style: #systemDefault 
					#defaultable: true ) 
				#(#{UI.ActionButtonSpec} 
					#layout: #(#{Graphics.LayoutFrame} 28 0 151 0 124 0 172 0 ) 
					#name: #ActionButton3 
					#colors: 
					#(#{UI.LookPreferences} 
						#setBackgroundColor: #(#{Graphics.ColorValue} 5119 8191 8191 ) ) 
					#model: #stopMIDI 
					#label: 'Stop MIDI' 
					#style: #systemDefault 
					#defaultable: true ) 
				#(#{UI.InputFieldSpec} 
					#layout: #(#{Graphics.LayoutFrame} 194 0 53 0 236 0 73 0 ) 
					#name: #minPitchField 
					#model: #minPitch 
					#style: #systemDefault 
					#type: #number ) 
				#(#{UI.InputFieldSpec} 
					#layout: #(#{Graphics.LayoutFrame} 271 0 53 0 313 0 73 0 ) 
					#name: #maxPitchField 
					#model: #maxPitch 
					#style: #systemDefault 
					#type: #number ) 
				#(#{UI.MenuButtonSpec} 
					#properties: #(#{UI.PropertyListDictionary} #labelFromApplication false ) 
					#layout: #(#{Graphics.LayoutFrame} 165 0 100 0 312 0 121 0 ) 
					#name: #scaleMenu 
					#model: #scale 
					#label: 'Scale' 
					#menu: #scaleMenu ) 
				#(#{UI.LabelSpec} 
					#layout: #(#{Graphics.LayoutOrigin} 11 0 7 0 ) 
					#name: #Label7 
					#label: 'Output' 
					#style: #large ) 
				#(#{UI.LabelSpec} 
					#layout: #(#{Graphics.LayoutOrigin} 352 0 7 0 ) 
					#name: #Label2 
					#label: 'Thread' 
					#style: #large ) 
				#(#{UI.LabelSpec} 
					#layout: #(#{Graphics.LayoutOrigin} 142 0 7 0 ) 
					#name: #Label3 
					#label: 'Contents' 
					#style: #large ) 
				#(#{UI.LabelSpec} 
					#layout: #(#{Graphics.LayoutOrigin} 154 0 33 0 ) 
					#name: #Label4 
					#colors: 
					#(#{UI.LookPreferences} 
						#setForegroundColor: #(#{Graphics.ColorValue} 0 4096 8191 ) ) 
					#label: 'Pitches' 
					#style: #systemDefault ) 
				#(#{UI.LabelSpec} 
					#layout: #(#{Graphics.LayoutOrigin} 163 0 57 0 ) 
					#name: #Label5 
					#label: 'Min' 
					#style: #systemDefault ) 
				#(#{UI.LabelSpec} 
					#layout: #(#{Graphics.LayoutOrigin} 243 0 57 0 ) 
					#name: #Label8 
					#label: 'Max' 
					#style: #systemDefault ) 
				#(#{UI.InputFieldSpec} 
					#layout: #(#{Graphics.LayoutFrame} 164 0 76 0 313 0 95 0 ) 
					#name: #pitchLidtField 
					#model: #pitchList 
					#style: #systemDefault 
					#type: #string ) 
				#(#{UI.ActionButtonSpec} 
					#layout: #(#{Graphics.LayoutFrame} 416 0 18 0 516 0 39 0 ) 
					#name: #startButton 
					#colors: 
					#(#{UI.LookPreferences} 
						#setBackgroundColor: #(#{Graphics.ColorValue} 5119 5119 8191 ) ) 
					#model: #startStop 
					#tabable: false 
					#label: 'Start' 
					#style: #large ) 
				#(#{UI.RadioButtonSpec} 
					#layout: #(#{Graphics.LayoutOrigin} 380 0 52 0 ) 
					#name: #clusterButton1 
					#model: #mode 
					#label: 'Cluster' 
					#select: #cluster ) 
				#(#{UI.RadioButtonSpec} 
					#layout: #(#{Graphics.LayoutOrigin} 380 0 75 0 ) 
					#name: #ostButton 
					#model: #mode 
					#label: 'Ostinato' 
					#select: #ostinato ) 
				#(#{UI.LabelSpec} 
					#layout: #(#{Graphics.LayoutOrigin} 155 0 129 0 ) 
					#name: #Label6 
					#colors: 
					#(#{UI.LookPreferences} 
						#setForegroundColor: #(#{Graphics.ColorValue} 0 4096 8191 ) ) 
					#label: 'Durations' 
					#style: #systemDefault ) 
				#(#{UI.LabelSpec} 
					#layout: #(#{Graphics.LayoutOrigin} 164 0 153 0 ) 
					#name: #Label9 
					#label: 'Min' 
					#style: #systemDefault ) 
				#(#{UI.InputFieldSpec} 
					#layout: #(#{Graphics.LayoutFrame} 195 0 150 0 237 0 169 0 ) 
					#name: #minDurField 
					#model: #minDur 
					#style: #systemDefault 
					#type: #number ) 
				#(#{UI.LabelSpec} 
					#layout: #(#{Graphics.LayoutOrigin} 244 0 153 0 ) 
					#name: #Label10 
					#label: 'Max' 
					#style: #systemDefault ) 
				#(#{UI.InputFieldSpec} 
					#layout: #(#{Graphics.LayoutFrame} 272 0 150 0 314 0 169 0 ) 
					#name: #maxDurField 
					#model: #maxDur 
					#style: #systemDefault 
					#type: #number ) 
				#(#{UI.ActionButtonSpec} 
					#layout: #(#{Graphics.LayoutFrame} 219 0 18 0 276 0 39 0 ) 
					#name: #AddButton 
					#colors: 
					#(#{UI.LookPreferences} 
						#setBackgroundColor: #(#{Graphics.ColorValue} 5119 6655 8191 ) ) 
					#model: #addPitch 
					#label: 'Add' 
					#defaultable: true ) 
				#(#{UI.ActionButtonSpec} 
					#layout: #(#{Graphics.LayoutFrame} 275 0 18 0 332 0 39 0 ) 
					#name: #removeButton 
					#colors: 
					#(#{UI.LookPreferences} 
						#setBackgroundColor: #(#{Graphics.ColorValue} 5119 8191 5119 ) ) 
					#model: #removePitch 
					#label: 'Remove' 
					#defaultable: true ) 
				#(#{UI.RadioButtonSpec} 
					#layout: #(#{Graphics.LayoutOrigin} 380 0 96 0 ) 
					#name: #cloudButton 
					#model: #mode 
					#label: 'Cloud' 
					#select: #cloud ) 
				#(#{UI.ActionButtonSpec} 
					#layout: #(#{Graphics.LayoutFrame} 455 0 143 0 512 0 164 0 ) 
					#name: #loadButton 
					#colors: 
					#(#{UI.LookPreferences} 
						#setBackgroundColor: #(#{Graphics.ColorValue} 8191 5119 5119 ) ) 
					#model: #load 
					#label: 'Load' 
					#defaultable: true ) 
				#(#{UI.ActionButtonSpec} 
					#layout: #(#{Graphics.LayoutFrame} 399 0 143 0 456 0 164 0 ) 
					#name: #saveButton 
					#colors: 
					#(#{UI.LookPreferences} 
						#setBackgroundColor: #(#{Graphics.ColorValue} 6655 5119 8191 ) ) 
					#model: #save 
					#label: 'Save' 
					#defaultable: true ) ) ) )! !

!Siren.ClusterEditor class methodsFor: 'resources'!

scaleMenu
	"Tools.MenuEditor new openOnClass: self andSelector: #scaleMenu"

	<resource: #menu>
	^#(#{UI.Menu} #(
			#(#{UI.MenuItem} 
				#rawLabel: 'Chromatic' 
				#value: #ChromaticScale ) 
			#(#{UI.MenuItem} 
				#rawLabel: 'Major' 
				#value: #MajorScale ) 
			#(#{UI.MenuItem} 
				#rawLabel: 'Minor' 
				#value: #HarmonicMinorScale ) 
			#(#{UI.MenuItem} 
				#rawLabel: 'Pentatonic' 
				#value: #PentatonicScale ) 
			#(#{UI.MenuItem} 
				#rawLabel: 'Hungarian' 
				#value: #HungarianMinor ) 
			#(#{UI.MenuItem} 
				#rawLabel: 'Blues' 
				#value: #PseudoMinorScale ) 
			#(#{UI.MenuItem} 
				#rawLabel: 'None' 
				#value: #none ) ) #(6 ) nil ) decodeAsLiteralArray! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!


!Siren.ClusterEditor methodsFor: 'initialize-release'!

initialize
	"Set up the default values."
	"Tools.UIPainter new openOnClass: self andSelector: #windowSpec"
	"self open"

	minPitch := 72 asValue.
	maxPitch := 84 asValue.
	minDur := (1/2) asValue.
	maxDur := (1/6) asValue.
	minAmpl := 20 asValue.
	maxAmpl := 34 asValue.
	minVoice := 1 asValue.
	maxVoice := 1 asValue.

	pitchList := '84 85 86 87 88' asValue.
	durationList := '1/1 1/1 1/1 1/2' asValue.
	amplList := '20 20 24 24' asValue.
	voiceList := '4' asValue.

	mode := #cluster asValue.
	scale := #Pentatonic asValue.
	process := nil.
	events := nil.
	numEvents := 8 asValue.
	running := false.
	tempo := 1.0 asValue.
	tScale := 1.0.

	players := Array new: 10 withAll: nil.
	playerStates := Array new: 10 withAll: false.
	playerVoices := Array new: 10 withAll: nil.!

initializeClus
	"Set up the default values."
	"Tools.UIPainter new openOnClass: self andSelector: #windowSpec"
	"self open"

	minPitch := 72 asValue.
	maxPitch := 84 asValue.
	minDur := (1/4) asValue.
	maxDur := (1/16) asValue.
	minAmpl := 24 asValue.
	maxAmpl := 64 asValue.
	minVoice := 1 asValue.
	maxVoice := 1 asValue.

	pitchList := '72 74 77 79 81' asValue.
	durationList := '1/4 1/6 1/6 1/3 1/3' asValue.
	amplList := '34 44 54' asValue.
	voiceList := '1' asValue.

	mode := #cluster asValue.
	scale := #Pentatonic asValue.
	process := nil.
	events := nil.
	numEvents := 5 asValue.
	running := false!

initializePent
	"Set up the default values."
	"Tools.UIPainter new openOnClass: self andSelector: #windowSpec"
	"self open"

	minPitch := 72 asValue.
	maxPitch := 84 asValue.
	minDur := (1/4) asValue.
	maxDur := (1/16) asValue.
	minAmpl := 24 asValue.
	maxAmpl := 64 asValue.
	minVoice := 1 asValue.
	maxVoice := 1 asValue.

	pitchList := '72 74 77 79 81' asValue.
	durationList := '1/4 1/6 1/6 1/3 1/3' asValue.
	amplList := '34 44 54' asValue.
	voiceList := '1' asValue.

	mode := #cluster asValue.
	scale := #Pentatonic asValue.
	process := nil.
	events := nil.
	numEvents := 5 asValue.
	running := false! !

!Siren.ClusterEditor methodsFor: 'interface opening'!

postOpenWith: aBuilder 
	"This message is sent by the builder after it has opened a completed window."
	"ClusterEditor allInstances do: [ :in | in stop]"

	self scale onChangeSend: #newScale to: self.
	self defaultVoiceClass onChangeSend: #chVoiceClass to: self.
	self tempo onChangeSend: #newTempo to: self.

	self volume1 onChangeSend: #newVol1:for: to: self.
	self volume2 onChangeSend: #newVol2:for: to: self.
	self volume3 onChangeSend: #newVol3:for: to: self.
	self volume4 onChangeSend: #newVol4:for: to: self.
	self volume5 onChangeSend: #newVol5:for: to: self.
	self volume6 onChangeSend: #newVol6:for: to: self.
	self volume7 onChangeSend: #newVol7:for: to: self.
	self volume8 onChangeSend: #newVol8:for: to: self.
	self volume9 onChangeSend: #newVol9:for: to: self.
	self volume10 onChangeSend: #newVol10:for: to: self.! !

!Siren.ClusterEditor methodsFor: 'aspects'!

amplList
	"This method was generated by UIDefiner.  Any edits made here
	may be lost whenever methods are automatically defined.  The
	initialization provided below may have been preempted by an
	initialize method."

	^amplList!

defaultVoiceClass
	"This method was generated by UIDefiner.  Any edits made here
	may be lost whenever methods are automatically defined.  The
	initialization provided below may have been preempted by an
	initialize method."

	defaultVoiceClass ifNil: [defaultVoiceClass := SirenSession someInstance defaultVoiceClass value asValue].
	^defaultVoiceClass!

durationList
	"This method was generated by UIDefiner.  Any edits made here
	may be lost whenever methods are automatically defined.  The
	initialization provided below may have been preempted by an
	initialize method."

	^durationList!

maxAmpl
	"This method was generated by UIDefiner.  Any edits made here
	may be lost whenever methods are automatically defined.  The
	initialization provided below may have been preempted by an
	initialize method."

	^maxAmpl!

maxDur
	"This method was generated by UIDefiner.  Any edits made here
	may be lost whenever methods are automatically defined.  The
	initialization provided below may have been preempted by an
	initialize method."

	^maxDur!

maxPitch
	"This method was generated by UIDefiner.  Any edits made here
	may be lost whenever methods are automatically defined.  The
	initialization provided below may have been preempted by an
	initialize method."

	^maxPitch!

maxVoice
	"This method was generated by UIDefiner.  Any edits made here
	may be lost whenever methods are automatically defined.  The
	initialization provided below may have been preempted by an
	initialize method."

	^maxVoice!

minAmpl
	"This method was generated by UIDefiner.  Any edits made here
	may be lost whenever methods are automatically defined.  The
	initialization provided below may have been preempted by an
	initialize method."

	^minAmpl!

minDur
	"This method was generated by UIDefiner.  Any edits made here
	may be lost whenever methods are automatically defined.  The
	initialization provided below may have been preempted by an
	initialize method."

	^minDur!

minPitch
	"This method was generated by UIDefiner.  Any edits made here
	may be lost whenever methods are automatically defined.  The
	initialization provided below may have been preempted by an
	initialize method."

	^minPitch!

minVoice
	"This method was generated by UIDefiner.  Any edits made here
	may be lost whenever methods are automatically defined.  The
	initialization provided below may have been preempted by an
	initialize method."

	^minVoice!

mode
	"This method was generated by UIDefiner.  Any edits made here
	may be lost whenever methods are automatically defined.  The
	initialization provided below may have been preempted by an
	initialize method."

	^mode!

numEvents
	"This method was generated by UIDefiner.  Any edits made here
	may be lost whenever methods are automatically defined.  The
	initialization provided below may have been preempted by an
	initialize method."

	^numEvents!

pitchList
	"This method was generated by UIDefiner.  Any edits made here
	may be lost whenever methods are automatically defined.  The
	initialization provided below may have been preempted by an
	initialize method."

	^pitchList!

scale
	"This method was generated by UIDefiner.  Any edits made here
	may be lost whenever methods are automatically defined.  The
	initialization provided below may have been preempted by an
	initialize method."

	^scale!

scaleMenu
	"Tools.MenuEditor new openOnClass: self andSelector: #scaleMenu"

	^self class scaleMenu!

tempo
	"This method was generated by UIDefiner.  Any edits made here
	may be lost whenever methods are automatically defined.  The
	initialization provided below may have been preempted by an
	initialize method."

	^tempo!

voiceList
	"This method was generated by UIDefiner.  Any edits made here
	may be lost whenever methods are automatically defined.  The
	initialization provided below may have been preempted by an
	initialize method."

	^voiceList!

voiceMenu

	^SirenSession someInstance voiceMenu!

volume1
	"This method was generated by UIDefiner.  Any edits made here
	may be lost whenever methods are automatically defined.  The
	initialization provided below may have been preempted by an
	initialize method."

	^volume1 isNil
		ifTrue:
			[volume1 := 0.6 asValue]
		ifFalse:
			[volume1]!

volume10
	"This method was generated by UIDefiner.  Any edits made here
	may be lost whenever methods are automatically defined.  The
	initialization provided below may have been preempted by an
	initialize method."

	^volume10 isNil
		ifTrue:
			[volume10 := 0.75 asValue]
		ifFalse:
			[volume10]!

volume2
	"This method was generated by UIDefiner.  Any edits made here
	may be lost whenever methods are automatically defined.  The
	initialization provided below may have been preempted by an
	initialize method."

	^volume2 isNil
		ifTrue:
			[volume2 := 0.6 asValue]
		ifFalse:
			[volume2]!

volume3
	"This method was generated by UIDefiner.  Any edits made here
	may be lost whenever methods are automatically defined.  The
	initialization provided below may have been preempted by an
	initialize method."

	^volume3 isNil
		ifTrue:
			[volume3 := 1.0 asValue]
		ifFalse:
			[volume3]!

volume4
	"This method was generated by UIDefiner.  Any edits made here
	may be lost whenever methods are automatically defined.  The
	initialization provided below may have been preempted by an
	initialize method."

	^volume4 isNil
		ifTrue:
			[volume4 := 1.0 asValue]
		ifFalse:
			[volume4]!

volume5
	"This method was generated by UIDefiner.  Any edits made here
	may be lost whenever methods are automatically defined.  The
	initialization provided below may have been preempted by an
	initialize method."

	^volume5 isNil
		ifTrue:
			[volume5 := 0.9 asValue]
		ifFalse:
			[volume5]!

volume6
	"This method was generated by UIDefiner.  Any edits made here
	may be lost whenever methods are automatically defined.  The
	initialization provided below may have been preempted by an
	initialize method."

	^volume6 isNil
		ifTrue:
			[volume6 := 0.9 asValue]
		ifFalse:
			[volume6]!

volume7
	"This method was generated by UIDefiner.  Any edits made here
	may be lost whenever methods are automatically defined.  The
	initialization provided below may have been preempted by an
	initialize method."

	^volume7 isNil
		ifTrue:
			[volume7 := 0.75 asValue]
		ifFalse:
			[volume7]!

volume8
	"This method was generated by UIDefiner.  Any edits made here
	may be lost whenever methods are automatically defined.  The
	initialization provided below may have been preempted by an
	initialize method."

	^volume8 isNil
		ifTrue:
			[volume8 := 0.75 asValue]
		ifFalse:
			[volume8]!

volume9
	"This method was generated by UIDefiner.  Any edits made here
	may be lost whenever methods are automatically defined.  The
	initialization provided below may have been preempted by an
	initialize method."

	^volume9 isNil
		ifTrue:
			[volume9 := 0.75 asValue]
		ifFalse:
			[volume9]! !

!Siren.ClusterEditor methodsFor: 'actions'!

addEvent
	"Add an event to the list"

	| pits durs amps voxs |
	pits := self stringToList: pitchList value.
	durs := self stringToList: durationList value.
	amps := self stringToList: amplList value.
	voxs := self stringToList: voiceList value.

	mode value == #cluster ifTrue:
		[ | evt |
		evt := MusicEvent dur: (durs atRandom)
						pitch: (pits atRandom) 
						ampl: (amps atRandom) 
						voice: (voxs atRandom).
		events add: evt at: 0.
		events computeDuration.
		numEvents value: events size]!

addPitch

	"This stub method was generated by UIDefiner"

	^self halt!

chVoiceClass
	"Respond to a selection in the voice class menu"

	Voice setDefault: self defaultVoiceClass value.
	Transcript show: 'Default IO voice class set to ', self defaultVoiceClass value; cr.
	defaultVoiceClass setValue: SirenSession someInstance defaultVoiceClass.
	self halt.
"	(self builder componentAt: #voiceMenu) widget"!

configureMIDI
	"This stub method was generated by UIDefiner"

	SirenSession someInstance configureMIDI!

generateEvents
	"Create the event list, a cluster, ostinato or cloud"

	| pits durs amps voxs |
	pits := self stringToList: pitchList value.
	durs := self stringToList: durationList value.
	amps := self stringToList: amplList value.
	voxs := self stringToList: voiceList value.

	mode value == #cluster ifTrue:
		[events :=  EventList new.
		0 to: numEvents value - 1 do:
			[ :ind | | evt |
			evt := MusicEvent dur: (durs at: (ind \\ durs size + 1))
						pitch: (pits at: (ind \\ pits size + 1)) 
						ampl: (amps at: (ind \\ amps size + 1)) 
						voice: (voxs at: (ind \\ voxs size + 1)).
			events add: evt at: 0].
		events scaleStartTimesBy: tScale.
		^self].
	mode value == #ostinato ifTrue:
		[ | t1 |
		events :=  EventList new.
		t1 := 0.0.
		0 to: numEvents value - 1 do:
			[ :ind | | evt |
			evt := MusicEvent dur: (durs at: (ind \\ durs size + 1))
						pitch: (pits at: (ind \\ pits size + 1)) 
						ampl: (amps at: (ind \\ amps size + 1)) 
						voice: (voxs at: (ind \\ voxs size + 1)).
			events add: evt at: t1.
			t1 := t1 + evt duration asSec value].
		events scaleStartTimesBy: tScale.
		^self].
	mode value == #cloud ifTrue:
		[ | cl |
		cl := Cloud fromDictionary: ((#duration -> 10000), 
			(#pitch -> (minPitch value to: maxPitch value)),
			(#loudness -> (minAmpl value to: maxAmpl value)), 
			(#voice -> (minVoice value to: maxVoice value))).
		cl density: 2.
		events := cl eventList.
		events scaleStartTimesBy: tScale]!

load

	"This stub method was generated by UIDefiner"

	^self halt!

newScale
	"Accept a new scale/mode selection"

	| mnu |
	Transcript show: 'Select ', scale value; cr.
	mnu := (self builder componentAt: #scale) component component.
	mnu setLabel: scale value.
	mnu model changed.
	scale changed!

newTempo
	"Accept a new tempo selection"

"	| te |
	te := self tempo value.
	Transcript show: 'Te: ', te printString, ' - ', tScale printString, ' - ', (te / tScale) printString; cr.
	events ifNotNil:
		[events scaleStartTimesBy: te / tScale].
"	tScale := self tempo value!

newVoice
	"Accept a new output voice selection"

	self halt.!

newVol10: ignored for: vModel
	"Respond to a change to the volume 10 slider"

	| pv |
	pv := playerVoices at: 10.
	pv ifNil: [^self].
	pv loudness: vModel value!

newVol1: ignored for: vModel
	"Respond to a change to the volume 1 slider"

	| val pv |
	val := vModel value.
	val := val * val.
	pv := playerVoices at: 1.
	pv ifNil: [^self].
	pv loudness: val!

newVol2: ignored for: vModel
	"Respond to a change to the volume 2 slider"

	| val pv |
	val := vModel value.
	val := val * val.
	pv := playerVoices at: 2.
	pv ifNil: [^self].
	pv loudness: val!

newVol3: ignored for: vModel
	"Respond to a change to the volume 3 slider"

	| val pv |
	val := vModel value.
	val := val * val.
	pv := playerVoices at: 3.
	pv ifNil: [^self].
	pv loudness: val!

newVol4: ignored for: vModel
	"Respond to a change to the volume 4 slider"

	| val pv |
	val := vModel value.
	val := val * val.
	pv := playerVoices at: 4.
	pv ifNil: [^self].
	pv loudness: val!

newVol5: ignored for: vModel
	"Respond to a change to the volume 5 slider"

	| val pv |
	val := vModel value.
	val := val * val.
	pv := playerVoices at: 5.
	pv ifNil: [^self].
	pv loudness: val!

newVol6: ignored for: vModel
	"Respond to a change to the volume 6 slider"

	| val pv |
	val := vModel value.
	val := val * val.
	pv := playerVoices at: 6.
	pv ifNil: [^self].
	pv loudness: val!

newVol7: ignored for: vModel
	"Respond to a change to the volume 7 slider"

	| pv |
	pv := playerVoices at: 7.
	pv ifNil: [^self].
	pv loudness: vModel value!

newVol8: ignored for: vModel
	"Respond to a change to the volume 8 slider"

	| pv |
	pv := playerVoices at: 8.
	pv ifNil: [^self].
	pv loudness: vModel value!

newVol9: ignored for: vModel
	"Respond to a change to the volume 9 slider"

	| pv |
	pv := playerVoices at: 9.
	pv ifNil: [^self].
	pv loudness: vModel value!

removeEvent
	"Remove an event from a playing cluster"

	| evs ev |
	numEvents value == 1 ifTrue: [^self].
	evs := events events.
	ev := evs atRandom.
	events remove: ev.
	events computeDuration.
	numEvents value: events size!

removePitch

	"This stub method was generated by UIDefiner"

	^self halt!

save

	"This stub method was generated by UIDefiner"

	^self halt!

startStop
	"start/stop the event-generating process."

	| t0 v0  |
	running ifTrue: [^self stop].
	Transcript show: 'Start'; cr.
	(self builder componentAt: #startButton) component component setLabelString: 'Stop'.
	self generateEvents.
	running := true.
	t0 := Time microsecondClock usec.
	v0 := MIDIVoice default.
	v0 channel: 4.

"Special thread for clusters"
	mode value == #cluster ifTrue:
		[ | durs |
		durs := self stringToList: durationList value.
		process := [[running] whileTrue: 
			[ | t1 ev te |
			te := self tempo value.
			ev := events atRandom copy.
			ev scaleDuration: 2.0 / te.
			ev playOn: v0 at: t0.
			t1 := durs atRandom sec asUsec value * te.
			t0 := t0 + t1.
			(Delay forMicroseconds: t1) wait]] fork.
		Processor yield.  			"give proc a chance to run"
		^self].

	mode value == #cloud ifTrue:
		[events scaleStartTimesBy: self tempo value.
		events scaleDurationsBy: (2.0 / self tempo value).
		events playOn: v0 at: t0.
		(self builder componentAt: #startButton) component component setLabelString: 'Start'.
		^self].

	process := [[running] whileTrue: 
		[ | t1 |
		events copy playOn: v0 at: t0.
		t1 := events duration asUsec value.
		t0 := t0 + t1.
		(Delay forMicroseconds: t1) wait]] fork "At: 5".

	Processor yield!

stop
	"start/stop the event-generating process."

	running := false.
	Transcript show: 'Stop'; cr.
	process
		ifNotNil: [process terminate].
	(self builder componentAt: #startButton)
		ifNotNil: [(self builder componentAt: #startButton) component component setLabelString: 'Start'].
	events := nil.!

stopMIDI
	"Stop all playback"

	ClusterEditor allInstances do: [ :in | in stop].
	SirenSession someInstance stopMIDI!

stringToList: string
	"Parse the given string to a list of numbers"

	| wfs lis |
	wfs := string wordFragments.
	lis := OrderedCollection new.
	wfs do: [ :aWF | | str |
		str := aWF asString.
		(str includes: $/) 
			ifTrue: [lis addLast: ((str copyUpTo: $/) asNumber / (str copyAfter: $/) asNumber)]
			ifFalse: [lis addLast: aWF asString asNumber]].
	^lis!

testMIDI

	"This stub method was generated by UIDefiner"

	SirenSession someInstance testMIDI!

testOSCout

	"This stub method was generated by UIDefiner"

	SirenSession someInstance testOSCout! !

!Siren.ClusterEditor methodsFor: 'players'!

refresh1

	"This stub method was generated by UIDefiner"

	^self!

refresh10

	"This stub method was generated by UIDefiner"

	^self!

refresh2

	"This stub method was generated by UIDefiner"

	^self!

refresh3

	"This stub method was generated by UIDefiner"

	^self!

refresh4

	"This stub method was generated by UIDefiner"

	^self!

refresh5

	"This stub method was generated by UIDefiner"

	^self!

refresh6

	"This stub method was generated by UIDefiner"

	^self!

refresh7

	"This stub method was generated by UIDefiner"

	^self!

refresh8

	"This stub method was generated by UIDefiner"

	^self!

refresh9

	"This stub method was generated by UIDefiner"

	^self!

start1
	"Start player 1 runnning a string thread"
	"ClusterEditor openWithSpec: #buttonSpec"

	self startPlayer: 1 with: [OSCVoice stringExample: 1 to: 2]!

start10

	self startPlayer: 10 with: [MIDIVoice walk: 100 pitch: 72 dur: 0.085 amp: 90 chan: 4]!

start1Old
	"Start player 1 runnning a string thread"
	"ClusterEditor openWithSpec: #buttonSpec"

	(playerStates at: 1)
		ifTrue: [							"if playing, stop"
			(self builder componentAt: #start1) component component setLabelString: 'Start'.
			playerStates at: 1 put: false.
			(players at: 1) terminate.
			players at: 1 put: nil]
		ifFalse: [ | dur |					"if not playing, start"
			(self builder componentAt: #start1) component component setLabelString: 'Stop'.
			playerStates at: 1 put: true.
			dur := OSCVoice stringExample: 1 to: 2.
			players at: 1 put:
				 [[playerStates at: 1] whileTrue:
					[(Delay forSeconds: dur asSec value) wait]] fork]!

start2
	"Start player 2 runnning a string thread"

	self startPlayer: 2 with: [OSCVoice stringExample: 2 to: 3]!

start3
	"Start player 3 runnning a voice sample thread"

	self startPlayer: 3 with: [OSCVoice sndExample3]!

start4
	"Start player 4 runnning a voice sample thread"

	self startPlayer: 4 with: [OSCVoice sndExample3]!

start5
	"Start player 5 runnning a vector cross-synth sample thread"

	self startPlayer: 5 with: [OSCVoice vxFadeExample1: 8]!

start6
	"Start player 6 runnning a vector cross-synth sample thread"

	self startPlayer: 6 with: [OSCVoice vxFadeExample1: 8]!

start7
	"Start player 7 runnning a MIDI random walk thread"

	self startPlayer: 7 with: [MIDIVoice walk: 100 pitch: 108 dur: 0.11 amp: 120 chan: 1]!

start8
	"Start player 8 runnning a MIDI random walk thread"

	self startPlayer: 8 with: [MIDIVoice walk: 100 pitch: 89 dur: 0.115 amp:90 chan: 2]!

start9
	"Start player 9 runnning a MIDI random walk thread"

	self startPlayer: 9 with: [MIDIVoice walk: 100 pitch: 80 dur: 0.09 amp: 70 chan: 3]!

startPlayer: num with: block
	"Start a player runnning a new thread"

	| symb |
	symb := ('start', num printString) asSymbol.
	(playerStates at: num)
		ifTrue: [							"if playing, stop"
			(self builder componentAt: symb) component component setLabelString: 'Start'.
			(self builder componentAt: symb) spec colors setForegroundColor: ColorValue black.
			playerStates at: num put: false.
			(players at: num) terminate.
			players at: num put: nil.
			Transcript show: 'Stopping player ', num printString; cr]

		ifFalse: [ | arr dur |					"if not playing, start"
			(self builder componentAt: symb) component component setLabelString: 'Stop'.
			(self builder componentAt: symb) spec colors setForegroundColor: ColorValue red.
			Transcript show: 'Starting player ', num printString; cr.
			playerStates at: num put: true.
			arr := block value.				"block returns an array with a duration and a voice"
			dur := arr first.
			playerVoices at: num put: arr last.

			players at: num put:
				[ | vol pv |
				[playerStates at: num] whileTrue:
					[(Delay forSeconds: dur asSec value) wait.
					vol := (playerVoices at: num) loudness.
					arr := block value.
					dur := arr first.
					pv := arr last.
					pv loudness: vol.
					playerVoices at: num put: pv]] fork]! !

!Siren.ClusterEditor methodsFor: 'interface closing'!

closeRequest
	"Shut down gracefully"

	running ifTrue: [self stop].
	players do:
		[ :pl |
		pl ifNotNil: [pl terminate]]! !
