

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



Smalltalk.Siren defineClass: #EventListText
	superclass: #{UI.ApplicationModel}
	indexedType: #none
	private: false
	instanceVariableNames: ''
	classInstanceVariableNames: ''
	imports: ''
	category: 'MusicUI-Editors'!



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



Smalltalk.Siren defineClass: #ScoreView
	superclass: #{UI.ApplicationModel}
	indexedType: #none
	private: false
	instanceVariableNames: ''
	classInstanceVariableNames: ''
	imports: ''
	category: 'MusicUI-Editors'!



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
