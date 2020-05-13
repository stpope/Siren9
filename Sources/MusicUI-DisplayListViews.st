

Smalltalk.Siren defineClass: #DisplayListTracker
	superclass: #{UI.SelectionTracker}
	indexedType: #none
	private: false
	instanceVariableNames: 'inside '
	classInstanceVariableNames: ''
	imports: ''
	category: 'MusicUI-DisplayListViews'!

Siren.DisplayListTracker comment:
'A DisplayListTracker is a controller for mouse tracking in DLViews

Instance Variables:
	inside	<Boolean>  is the mouse in my view?
'!

!Siren.DisplayListTracker methodsFor: 'private'!

trackSelectionFor: aPoint 
	| isInside |
	isInside := self viewHasPoint: aPoint.
	(inside == false)
		ifFalse: [isInside
				ifFalse: 
					[controller mouseExitedAt: aPoint.
					inside := false]]
		ifTrue: [isInside
				ifTrue: 
					[controller mouseEnteredAt: aPoint.
					inside := true]].
	controller mouseMovedTo: aPoint! !

!Siren.DisplayListTracker methodsFor: 'events'!

mouseMovedEvent: aMouseMovedEvent


	controller mouseMovedEvent: aMouseMovedEvent.
	^nil!

redButtonPressedEvent: aMouseButtonEvent 

	aMouseButtonEvent isBlue ifTrue: [self halt].
	controller redButtonPressedAt: (self cursorPointFor: aMouseButtonEvent).
"	self trackSelectionFor: (self cursorPointFor: aMouseButtonEvent).
"	aMouseButtonEvent initiator grabMouseEventFor: self.
	^nil! !



Smalltalk.Siren defineClass: #DisplayListView
	superclass: #{UI.AutoScrollingView}
	indexedType: #none
	private: false
	instanceVariableNames: 'displayList pixmap background page zoom grid extent inset backgroundColor foregroundColor redrawn cache '
	classInstanceVariableNames: ''
	imports: ''
	category: 'MusicUI-DisplayListViews'!

Siren.DisplayListView defineSharedVariable: #MusicConstants
	private: false
	constant: false
	category: 'class var accessing'
	initializer: 'IdentityDictionary new'!

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!


!Siren.DisplayListView class methodsFor: 'examples'!

classListExample
	"DisplayListView classListExample"

	IndentedListLayoutManager listExample display!

classTreeExample
	"DisplayListView classTreeExample"

	(IndentedTreeLayoutManager listExample) display!

colorClassListExample
	"DisplayListView colorClassListExample"

	IndentedListLayoutManager colorListExample!

exampleHierarchical
	"DisplayListView exampleHierarchical"

	DisplayList exampleHierarchical display! !

!Siren.DisplayListView class methodsFor: 'constant access'!

backgroundColor
	"Answer the default background color for display list views."
	"ColorValue constantNames #(#black #blue #brown #chartreuse #cyan #darkCyan #darkGray #darkGreen #darkMagenta #darkRed #olive #gray #green #lightYellow #lightGray #magenta #navy #orange #orchid #paleGreen #pink #purple #red #royalBlue #salmon #lightCyan #springGreen #veryDarkGray #veryLightGray #white #yellow )"

"	^LookPreferences defaultForWindows backgroundColor
"	^ColorValue lightYellow blendWith: ColorValue white!

constants

	^MusicConstants!

constants: aDictionary

	MusicConstants := aDictionary!

defaultCacheExtent
	"Answer the default extent of the receiver's instances' cache."

	^600@600!

foregroundColor
	"Answer the default foreground color for display list views."

	^LookPreferences defaultForWindows foregroundColor!

inset
	"Answer the default display inset."

	^8@8! !

!Siren.DisplayListView class methodsFor: 'class initialization'!

initialize
	"Init the class"
	"DisplayListView initialize"

	MusicConstants := IdentityDictionary new! !

!Siren.DisplayListView class methodsFor: 'instance creation'!

componentOnList: dlist
	"Answer a DLView for use as a component."
	"IndentedListLayoutManager listExample display"

	| container me wrapper dled |
	container := CompositePart new.
	dled := DisplayListEditor on: dlist.
	me := self on: dled.
	wrapper := LookPreferences edgeDecorator on: me.
	wrapper useHorizontalScrollBar; noMenuBar.
	container add: wrapper in: (0@0 extent: 1.0@1.0).
	^container!

componentOnList: dlist withGrid: gPoint inColor: gColor
	"Answer a DLView for use as a component."

	| container me wrapper dled |
	container := CompositePart new.
	dled := DisplayListEditor on: dlist.
	gPoint == nil
		ifFalse: [me := self new initialize: dlist withGrid: gPoint color: gColor]
		ifTrue: [me := self new initialize].
	me displayList: dled list.
	me model: dled.
	wrapper := LookPreferences edgeDecorator on: me.
	wrapper useHorizontalScrollBar; noMenuBar.
	container add: wrapper
			borderedIn: (0@0.1 extent: 1.0@0.9).
	^container!

on: anEditor

	| me |
	me := self new.
	me displayList: anEditor list.
	me model: anEditor.
	anEditor view: me.
	^me!

open4SquareOn: aDisplayList
	"Open the receiver on the given display list."
	"DisplayListView open4SquareOn: (DisplayList rectanglesX: 2000 byY: 2000)"

	| dls |
	dls := DisplayListSubcanvas new.
	dls setDisplayList: aDisplayList.
	dls setComponent: (self componentOnList: aDisplayList).
	DisplayListSubcanvas openOn: dls withSpec: #windowSpec4Square!

openOn: aDisplayList
	"Open the receiver on the given display list."
	"DisplayListView openOn: (DisplayList rectanglesX: 2000 byY: 2000)"

	| dls |
	dls := DisplayListSubcanvas new.
	dls setDisplayList: aDisplayList.
	dls setComponent: (self componentOnList: aDisplayList).
	DisplayListSubcanvas openOn: dls! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!


Siren.DisplayListView comment:
'DisplayListViews can display and scroll structured graphics display lists generated by various models or layout managers.
Using their page offset, they can scroll over very large display lists.
They can have colored or gridded background pixmaps and can scroll/page on demand; they display their lists on their graphics contexts.

Subclasses generally override the displayOn: or displayOnImage methods, and add initialization or transformation methods.

Instance Variables
	displayList	<DisplayList> the view''s display list
	pixmap	 <Pixmap or nil> the view''s cached display pixel map (optional)
	background <Pixmap or nil> the view''s background form (e.g., gridding)
	zoom <Point or nil> the display list''s zoom-in factor or nil
	pageOffset	 <Point> the offset in "pages" used for very large display lists
	backgroundColor <ColorValue> graphics background color
	foregroundColor <ColorValue> graphics display color
	redrawn <nil or not> set to nil to re-draw cache
	cache <boolean> should I cache a Pixmap of redisply n the fly?

See the class examples for numerous ways of using display list views.

The subclasses add knowledge of smart display list generation, background pixmap generation (e.g., gridding), display of item or x/y-range selection, x- or y-scaling or step/grid, property->color mapping, "clef forms" or other special pixmaps, multiple-model viewing, etc.
'!

!Siren.DisplayListView methodsFor: 'private'!

scrollableExtent
	"Answer the extent of the receiver's display object bounding box."

	^zoom == nil
		ifTrue: [super scrollableExtent]
		ifFalse: [super scrollableExtent * zoom]!

setModel: aModel

	super setModel: aModel.
	container ifNotNil: [self invalidate]!

visibleExtent
	"Answer the extent of the receiver's clipping box."

	^zoom == nil
		ifTrue: [super visibleExtent]
		ifFalse: [super visibleExtent * zoom]! !

!Siren.DisplayListView methodsFor: 'controller access'!

defaultControllerClass

	^DisplayListController!

transformPoint: aPoint
	"zoom, scroll, and page the given point, used for hit-detection."

	^zoom == nil
		ifTrue: [aPoint "- scrollOffset value - (16@16)"]
		ifFalse: [aPoint "- scrollOffset value" / zoom]! !

!Siren.DisplayListView methodsFor: 'accessing'!

background: anObject
	"Set the receiver's 'background' to be anObject."

	background := anObject!

backgroundColor
	"Answer the receiver's backgroundColor or the default."

	^backgroundColor == nil
		ifTrue: [self class backgroundColor]
		ifFalse: [backgroundColor]!

bounds: aRectangle
	"Set the receiver's bounds (and page offset)."

	super bounds: aRectangle.
	page := 0@0.
	extent := aRectangle extent!

cache: aBoolean
	"Set the receiver's 'cache' to be aBoolean."
self halt.
	cache := aBoolean!

displayList
	"Answer the receiver's display list."

	^displayList!

displayList: anObject
	"Set the receiver's 'displayList' to be anObject."

	displayList := anObject.
	cache ifTrue: [self initializeCache]
		ifFalse: [pixmap := nil]!

foregroundColor
	"Answer the receiver's foregroundColor or the default."

	^foregroundColor == nil
		ifTrue: [self class foregroundColor]
		ifFalse: [foregroundColor]!

inset: aPoint
	"Set the receiver's inset to aPoint (pixels)."

	inset := aPoint!

list
	"Answer the receiver's display list."

	^displayList!

pageOffset
	"Answer the receiver's 'pageOffset'."

	^page!

pageOffset: anObject
	"Set the receiver's 'pageOffset' to be anObject."

	page := anObject!

pixmap: aPMorNil
	"Set (or destroy) the receiver's cached pixmap."

	pixmap := aPMorNil!

preferredBounds
	"Answer the displayList's bounds."

	| rect |
	displayList == nil
		ifTrue: [^super preferredBounds].
	rect := displayList computePreferredBounds.
	^zoom == nil
		ifTrue: [(rect origin) extent: (rect extent + (inset * 2))]
		ifFalse: [((rect origin) extent: (rect extent + (inset * 2))) scaledBy: zoom]!

zoom: aPoint
	"Set the receiver's 'zoom' to be aPoint."

	zoom := aPoint.
	(zoom == (1@1))
		ifTrue: [zoom := nil].
	self invalidate! !

!Siren.DisplayListView methodsFor: 'displaying'!

displayOn: aGraphicsContext
	"Display the receiver on the given GC, translating it as appropriate."

	cache ifFalse: [aGraphicsContext paint: backgroundColor.
				aGraphicsContext displayRectangle: aGraphicsContext clippingBounds].

	aGraphicsContext translateBy: inset.

	pixmap == nil
		ifTrue: [zoom == nil
			ifTrue: [self displayList displayOn: aGraphicsContext]
			ifFalse: [(displayList scaledBy: zoom) displayOn: aGraphicsContext]]

		ifFalse: [redrawn == nil ifTrue: [self displayOnImage].
				pixmap displayOn: aGraphicsContext].

	((model notNil) and: [model selection notNil])
		ifTrue: [self displaySelectionOn: aGraphicsContext].

	aGraphicsContext translateBy: inset negated!

displaySelectionOn: aGC
	"Display the model's selection using some form of highlighting."

	| sel bound bRect wRect |
	sel := model selection.
	sel == nil ifTrue: [^self].
	bRect := (-3@ -3) extent: (6@6).
	wRect := (-2@ -2) extent: (4@4).
	bound := sel bounds.
	#(topLeft topRight bottomRight bottomLeft) do:
		[ :cor | | pt |
		pt := bound perform: cor.
		aGC paint: ColorValue black.
		aGC displayRectangle: bRect at: pt.
		aGC paint: ColorValue white.
		aGC displayRectangle: wRect at: pt]!

invalidate

	redrawn := nil.
	super invalidate! !

!Siren.DisplayListView methodsFor: 'initialize-release'!

component
	"Answer a DLView for use as a component."
	"IndentedListLayoutManager listExample display"

	| part wrapper |
	part := CompositePart new.
	wrapper := LookPreferences edgeDecorator on: self.
	wrapper useHorizontalScrollBar; noMenuBar.
	part add: wrapper in: (0@0 extent: 1.0@1.0).
	^part!

initialize
	"Initialize the receiver's instance variables--the default is not to cache."

	super initialize.
"	page := 0@0. -- unused"
	zoom := 1@1.
	backgroundColor := self class backgroundColor.
	redrawn := false.
	inset := self class inset.
	extent := 1@1.
"	InputState default shiftDown
		ifFalse: [cache := true]
		ifTrue: [cache := false]
"	cache := false!

initializeCache
	"Initialize the receiver's instance variables for cacheing the pixmap during display."

	| ext |
	cache := true.
	ext := displayList extent truncated.
	ext x: (ext x min: 2048).
	ext y: (ext y min: 2048).
	pixmap := Pixmap extent: ext	 "self class defaultCacheExtent".
	pixmap background: self backgroundColor.
	page := 0@0!

initializeWithGrid: gPoint color: gColor
	"Initialize the receiver's instance variables--the default is to cache."

	| cacheE bGC |
	self initialize.
	self initializeCache.
	cacheE := self class defaultCacheExtent.
	background := Pixmap extent: cacheE.
	bGC := background graphicsContext.
	bGC paint: DisplayListView backgroundColor.
	bGC displayRectangle: background bounds.
	bGC paint: gColor.
	0 to: cacheE x by: gPoint x do:
		[ :x |
		bGC displayLineFrom: (x@0) to: (x @ cacheE y)].
	0 to: cacheE y by: gPoint y do:
		[ :y |
		bGC displayLineFrom: (0@y) to: (cacheE x @ y)].!

release
	"Remove the receiver as a dependent of its model."

	model release.
	model removeDependent: self.
	model := nil.
	super release! !



Smalltalk.Siren defineClass: #DisplayListEditor
	superclass: #{Siren.EditorModel}
	indexedType: #none
	private: false
	instanceVariableNames: 'list '
	classInstanceVariableNames: ''
	imports: ''
	category: 'MusicUI-DisplayListViews'!

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!


!Siren.DisplayListEditor class methodsFor: 'instance creation'!

on: model
	^self new list: model! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!


Siren.DisplayListEditor comment:
'An instance of DisplayListEditor is used as the intermediary model for viewing lists.
It handles selection and operation on the list.
It adds itself as a dependent of the list and echoes its change messages (i.e., the update: message says self changed).

Instance Variable:
	list			<DisplayList> the ''subject'' list model
	selection		<DisplayItem orDisplayLIst> the current selection or nil
'!

!Siren.DisplayListEditor methodsFor: 'editing'!

doDisplay
	"inspect button"

	self changed!

doEdit
	"edit button"

	self doInspect!

doFile
	"file i/o button"

	Transcript show: 'No File.'; cr.!

doInspect
	"Inspect the editor (if shiftDown) or the model."

	InputState default shiftDown
		ifTrue: [self inspect]
		ifFalse: [list inspect]!

doZoom
	"zoom button"! !

!Siren.DisplayListEditor methodsFor: 'accessing'!

displayList
	"Answer the receiver's list."

	^list!

list
	"Answer the receiver's list."

	^list!

list: aList
	"Set the receiver's list, removing the dependency to the former list if necessary."

	list == nil
		ifFalse: [list removeDependent: self].
	list := aList.
	list addDependent: self!

moveSelectionTo: newPoint
	"Move the editor's selection to the new point in the list."

	| oldOff |
	selections hasItems
		ifFalse: [oldOff := selections offset.
			selections offset: newPoint.
			self changed": #position with: (oldOff corner: newPoint)"]
		ifTrue: [selections components do: [ : i | list remove: i].
			selections offset: newPoint.
			list add: selections.
			self changed]! !

!Siren.DisplayListEditor methodsFor: 'updating'!

update: anAspect with: anArg from: aModel
	"Echo the model's changes, assuming a view is a dependent of the receiver."

	self changed: anAspect with: anArg! !

!Siren.DisplayListEditor methodsFor: 'initialize-release'!

release
	"Remove the dependency to the list."

	list removeDependent: self.
	list release! !



Smalltalk.Siren defineClass: #DisplayListController
	superclass: #{UI.ControllerWithMenu}
	indexedType: #none
	private: false
	instanceVariableNames: 'selOffset '
	classInstanceVariableNames: ''
	imports: ''
	category: 'MusicUI-DisplayListViews'!

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!


!Siren.DisplayListController class methodsFor: 'resources'!

defaultEditMenu
	"MenuEditor new openOnClass: self andSelector: #defaultEditMenu"

	<resource: #menu>
	^#(#{UI.Menu} #(
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
				#value: #optionsDialog ) ) #(5 ) nil ) decodeAsLiteralArray! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!


Siren.DisplayListController comment:
'Instances of DisplayListController (or its subclasses) are used by DisplayListViews (or subclass instances) for menu management and selection.

By default, a simple YellowButton menu allows for group/inspect/redraw/zoom.
The RedButton is used for display item selection (by pointing or boxing-in).
LeftShift extends the selection, and dragging a selection moves it.

Instance Variables:
	selection		<DisplayList> the object''s selected items'!

!Siren.DisplayListController methodsFor: 'control defaults'!

blueButtonActivity
	"Drag scroll amplified by 2@2 with the blue button."

	| pt1 pt2 |
	pt1 := InputSensor cursorPoint.
	[self sensor anyButtonPressed] whileTrue:
		[pt2 := InputSensor cursorPoint.
		(pt2 = pt1) 
			ifFalse: [view scroll: (pt2 - pt1) * 2.
"				Transcript show: (pt2 - pt1) printString; cr."
				pt1 := pt2]]!

redButtonActivity
	"Hit-detect items from the display list or drag a selection."

	| pt1 pt2 selRect | self halt.
	model == nil ifTrue: [^nil].
	((model selection == nil) or: [InputState default shiftDown])
		ifTrue: [pt1 := InputSensor cursorPoint.
			self selectRangeWhile: [self sensor anyButtonPressed].
			pt2 := InputSensor cursorPoint.
"			Transcript show: 'Select: ', pt1 printString, ' to ', pt2 printString; cr."
			self selectFromPoint: pt1 - view pageOffset - view inset
					toPoint: pt2 - view pageOffset - view class inset]
		ifFalse: [selRect := model selection bounds.
			pt1 := InputSensor cursorPoint - view pageOffset.
			(selRect containsPoint: pt1 r)	"if you click off the selection, clear it"
				ifFalse: [model select: nil.
					Transcript show: 'clear'; cr.
					self sensor waitNoButton]
											"if you click near the selection, drag it"
				ifTrue: [self dragSelectionWhile: [self sensor anyButtonPressed].
					model moveSelectionTo: InputSensor cursorPoint]]!

redButtonPressedAt: pt
	"Handle the red mouse click"

	| item |
self halt.
	item := self selectAtPoint: pt.!

yellowButtonActivity0
	"Drag scroll amplified by 2@2 with the blue button."

	| pt1 pt2 |
	pt1 := self sensor cursorPoint.
	[self sensor anyButtonPressed] whileTrue:
		[pt2 := InputSensor cursorPoint.
		(pt2 = pt1) 
			ifFalse: [view scrollBy: (pt2 - pt1) * 2.
"				Transcript show: (pt2 - pt1) printString; cr."
				pt1 := InputSensor cursorPoint]]! !

!Siren.DisplayListController methodsFor: 'accessing'!

selection
	"Answer the receiver's 'selection'."

	^model selection!

selection: anObject
	"Set the receiver's instance variable 'selection' to be anObject."

	model select: anObject!

selectionTracker
	^DisplayListTracker on: self! !

!Siren.DisplayListController methodsFor: 'selecting'!

selectAtPoint: aPoint
	"Hit-detect the model for the given pt."

	| item transPt |
	transPt := view transformPoint: aPoint.
	item := view list itemWithin: 8 of: transPt.
"	Transcript show: aPoint printString, '(', transPt rounded printString, ') -- sel: ', item printString; cr.
"	model select: item.
	item == nil
		ifTrue: [selOffset := nil]
		ifFalse: [selOffset := aPoint - item bounds origin].
	^item!

selectFromPoint: aPoint toPoint: anotherPoint
	"Hit-detect the model for the given range."

	| item |
	(aPoint dist: anotherPoint) < 8
		ifTrue: [item := view list itemWithin: 24 of: aPoint.
			Transcript show: 'Select ', item printString; cr.
			item == nil
				ifTrue: [model select: item]
				ifFalse: [model select: item]]
		ifFalse: [model select:
				(view list itemsWithin: 
						(aPoint corner: anotherPoint))]!

selectRangeWhile: durationBlock
	"Hit-detect items from the display list or drag a selection as long as the block is true."

	| pt1 pt2 gc color1 color2 |
	gc := view graphicsContext.
	color1 := LookPreferences defaultForWindows backgroundColor.
	color2 := LookPreferences defaultForWindows foregroundColor.
	pt1 := InputSensor cursorPoint.
	pt2 := pt1 + (4@4).
	InputSensor cursorPoint: pt2.
	durationBlock whileTrue:
		[gc paint: color1.
		gc displayRectangularBorder: (pt1 corner: pt2).
		pt2 := InputSensor cursorPoint.
		gc paint: color2.
		gc displayRectangularBorder: (pt1 corner: pt2)]! !

!Siren.DisplayListController methodsFor: 'menu messages'!

again
	"Repeat the last operation"!

copyItem
	"Copy the selection."

	model copyBuffer: model selection copy.!

cutItem
	"Cut the selection."

	| sel |
	sel := model selection.
	model copyBuffer: sel.
	model list remove: sel.
	model select: nil.
	model changed!

doInspect
	"Inspect the view (if leftShiftDown) or the model."

	InputState default shiftDown
		ifTrue: [self inspect]
		ifFalse: [model inspect]!

flattenItems
	"Flatten the hierarchy of the selection."!

groupItems
	"Group the selection."

	self halt!

inspectDisplayList
	"Inspect the display list."

	view displayList inspect!

inspectEditor
	"Inspect the display list editor."

	model inspect!

inspectModel
	"Inspect the model."

	model list inspect!

optionsDialog
	"Run the options dialog box."!

pasteFromBuffer
	"Paste the selection."!

pasteItem
	"Paste the selection."

	model list add: model copyBuffer.
	model changed!

redraw
	"Redraw the view and clear the selection."

	view invalidate.
	model == nil
		ifFalse: [model select: nil]!

redrawView
	"redraw the display list."

	view invalidate!

undo
	"Un-do the last operation"!

ungroupItems
	"Un-group the selection."!

zoom
	"Prompt the user for a scale point, zoom the view's scale, and redraw."

self halt.
"	| pt prompt |
	prompt := (view xScale == nil)
		ifTrue: ['1@1']
		ifFalse: [(view xScale @ view yScale) printString].
	pt := DialogView request: 'zoom to scale:'
			initialAnswer: prompt.
	pt = '' ifFalse: [pt := Compiler evaluate: pt.
			pt class == Point
				ifTrue: [view xScale: pt x; yScale: pt y; redraw]]
"!

zoomInPoint
	"Zoom the view's scale, and redraw."

	view xScale: 1.0; yScale: 1.0; redraw!

zoomOutPoint
	"Zoom the view's scale, and redraw."

	view xScale: 1.0; yScale: 1.0; redraw!

zoomTo1
	"Zoom the view's scale, and redraw."

	view zoom: (1.0 @ 1.0)! !

!Siren.DisplayListController methodsFor: 'initialize-release'!

initializeMenu
	"Set up the receiver's YellowButtonMenu"

"	| menu |
	menu := Menu new.
	menu addItem:  ((MenuItem labeled: 'group') value: #group).
	menu addItem:  ((MenuItem labeled: 'inspect') value: #inspectModel).
	menu addItem:  ((MenuItem labeled: 'redraw') value: #redraw).
	menu addItem:  ((MenuItem labeled: 'zoom') value: #zoom).
	menuHolder := menu asValue
"
	self menuHolder: self class defaultEditMenu asValue! !

!Siren.DisplayListController methodsFor: 'events'!

dragSelection: anEvent
	"Dragging is event oriented."

	model moveSelectionTo: (self sensor mousePointForEvent: anEvent) - selOffset!

mouseMovedEvent: anEvent
	"Mouse dragging"

	anEvent redButtonPressed ifFalse: [^self].
	model selection == nil
		ifTrue: [self selectEvent: anEvent]
		ifFalse: [self dragSelection: anEvent]!

redButtonPressedEvent: event 

	self selectEvent: event.!

redButtonReleasedEvent: event 

	selOffset := nil!

selectEvent: anEvent
	| point |
	point := self sensor mousePointForEvent: anEvent.
	self selectAtPoint: point! !



Smalltalk.Siren defineClass: #DisplayListSubcanvas
	superclass: #{UI.ApplicationModel}
	indexedType: #none
	private: false
	instanceVariableNames: 'displayList componentPart displayListView scroller vZoom hZoom '
	classInstanceVariableNames: ''
	imports: ''
	category: 'MusicUI-DisplayListViews'!

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!


!Siren.DisplayListSubcanvas class methodsFor: 'interface specs'!

windowSpec
	"Answer the user's favorite window layout"

	^self windowSpecLeftBottom!

windowSpec4Square
	"UIPainter new openOnClass: self andSelector: #windowSpec4Square"

	<resource: #canvas>
	^#(#{UI.FullSpec} 
		#window: 
		#(#{UI.WindowSpec} 
			#label: 'Display List View' 
			#bounds: #(#{Graphics.Rectangle} 640 236 1031 679 ) ) 
		#component: 
		#(#{UI.SpecCollection} 
			#collection: #(
				#(#{UI.ArbitraryComponentSpec} 
					#layout: #(#{Graphics.LayoutFrame} 0 0 16 0 -16 1 0 1 ) 
					#name: #displayListView 
					#flags: 0 
					#component: #createDisplayListView ) 
				#(#{UI.SliderSpec} 
					#layout: #(#{Graphics.LayoutFrame} 16 0 0 0 -16 1 16 0 ) 
					#name: #hZoom 
					#colors: 
					#(#{UI.LookPreferences} 
						#setBackgroundColor: #(#{Graphics.ColorValue} 3026 3026 6051 ) ) 
					#model: #hZoom 
					#callbacksSpec: 
					#(#{UI.UIEventCallbackSubSpec} 
						#valueChangeSelector: #zoomChanged ) 
					#orientation: #horizontal 
					#start: 0.25 
					#stop: 4 ) 
				#(#{UI.SliderSpec} 
					#layout: #(#{Graphics.LayoutFrame} -16 1 16 0 0 1 -16 1 ) 
					#name: #vZoom 
					#colors: 
					#(#{UI.LookPreferences} 
						#setBackgroundColor: #(#{Graphics.ColorValue} 3026 3026 6051 ) ) 
					#model: #vZoom 
					#callbacksSpec: 
					#(#{UI.UIEventCallbackSubSpec} 
						#valueChangeSelector: #zoomChanged ) 
					#orientation: #vertical 
					#start: 0.25 
					#stop: 4 ) 
				#(#{UI.ActionButtonSpec} 
					#layout: #(#{Graphics.Rectangle} 0 0 16 16 ) 
					#name: #zoomTo1 
					#colors: 
					#(#{UI.LookPreferences} 
						#setBackgroundColor: #(#{Graphics.ColorValue} 8117 8117 5073 ) ) 
					#model: #zoomTo1 
					#tabable: false 
					#label: 'z' 
					#style: #pixelSmall ) 
				#(#{UI.ActionButtonSpec} 
					#layout: #(#{Graphics.LayoutFrame} 0 0 -16 1 16 0 0 1 ) 
					#name: #prevPage 
					#colors: 
					#(#{UI.LookPreferences} 
						#setBackgroundColor: #(#{Graphics.ColorValue} 4248 4248 6789 ) ) 
					#model: #prevPage 
					#label: '-' 
					#defaultable: true ) 
				#(#{UI.ActionButtonSpec} 
					#layout: #(#{Graphics.LayoutFrame} -16 1 -16 1 0 1 0 1 ) 
					#name: #nextPage 
					#colors: 
					#(#{UI.LookPreferences} 
						#setBackgroundColor: #(#{Graphics.ColorValue} 6789 2557 2557 ) ) 
					#model: #nextPage 
					#label: ' ' 
					#defaultable: true ) 
				#(#{UI.ActionButtonSpec} 
					#layout: #(#{Graphics.LayoutFrame} -16 1 0 0 0 1 16 0 ) 
					#name: #zoomToLast 
					#colors: 
					#(#{UI.LookPreferences} 
						#setBackgroundColor: #(#{Graphics.ColorValue} 8191 5631 3072 ) ) 
					#model: #zoomToLast 
					#label: '0' 
					#defaultable: true ) ) ) )!

windowSpecLeftBottom
	"Tools.UIPainter new openOnClass: self andSelector: #windowSpecLeftBottom"

	<resource: #canvas>
	^#(#{UI.FullSpec} 
		#window: 
		#(#{UI.WindowSpec} 
			#label: 'Display List View' 
			#min: #(#{Core.Point} 200 200 ) 
			#max: #(#{Core.Point} 0 0 ) 
			#bounds: #(#{Graphics.Rectangle} 1084 499 1984 949 ) ) 
		#component: 
		#(#{UI.SpecCollection} 
			#collection: #(
				#(#{UI.ArbitraryComponentSpec} 
					#layout: #(#{Graphics.LayoutFrame} 16 0 0 0 0 1 -16 1 ) 
					#name: #displayListView 
					#flags: 0 
					#component: #createDisplayListView ) 
				#(#{UI.SliderSpec} 
					#layout: #(#{Graphics.LayoutFrame} 16 0 -16 1 -16 1 0 1 ) 
					#name: #hZoom 
					#colors: 
					#(#{UI.LookPreferences} 
						#setBackgroundColor: #(#{Graphics.ColorValue} 5734 5734 5734 ) ) 
					#model: #hZoom 
					#callbacksSpec: 
					#(#{UI.UIEventCallbackSubSpec} 
						#valueChangeSelector: #zoomChanged ) 
					#orientation: #horizontal 
					#start: 0.25 
					#stop: 4 ) 
				#(#{UI.SliderSpec} 
					#layout: #(#{Graphics.LayoutFrame} 0 0 16 0 16 0 -16 1 ) 
					#name: #vZoom 
					#colors: 
					#(#{UI.LookPreferences} 
						#setBackgroundColor: #(#{Graphics.ColorValue} 5734 5734 5734 ) ) 
					#model: #vZoom 
					#callbacksSpec: 
					#(#{UI.UIEventCallbackSubSpec} 
						#valueChangeSelector: #zoomChanged ) 
					#orientation: #vertical 
					#start: 0.25 
					#stop: 4 ) 
				#(#{UI.ActionButtonSpec} 
					#layout: #(#{Graphics.LayoutFrame} 0 0 0 0 16 0 16 0 ) 
					#name: #zoomTo1 
					#colors: 
					#(#{UI.LookPreferences} 
						#setBackgroundColor: #(#{Graphics.ColorValue} 8117 8117 5073 ) ) 
					#model: #zoomTo1 
					#tabable: false 
					#label: 'z' 
					#style: #pixelSmall ) 
				#(#{UI.ActionButtonSpec} 
					#layout: #(#{Graphics.LayoutFrame} 0 0 -16 1 16 0 0 1 ) 
					#name: #prevPage 
					#colors: 
					#(#{UI.LookPreferences} 
						#setBackgroundColor: #(#{Graphics.ColorValue} 4248 4248 6789 ) ) 
					#model: #prevPage 
					#label: '-' 
					#defaultable: true ) 
				#(#{UI.ActionButtonSpec} 
					#layout: #(#{Graphics.LayoutFrame} -16 1 -16 1 0 1 0 1 ) 
					#name: #nextPage 
					#colors: 
					#(#{UI.LookPreferences} 
						#setBackgroundColor: #(#{Graphics.ColorValue} 6789 2557 2557 ) ) 
					#model: #nextPage 
					#label: ' ' 
					#defaultable: true ) ) ) )! !

!Siren.DisplayListSubcanvas class methodsFor: 'instance creation'!

onList: aDisplayList

	| me |
	me := self new.
	me setDisplayList: aDisplayList.
	me open!

openOnList: aDisplayList
	"DisplayListSubcanvas openOnList: (DisplayList rectanglesX: 6000 byY: 6000)"
	"DisplayListSubcanvas openOnList: (DisplayList polylinesX: 2000 byY: 2000)"

	| me |
	me := self new.
	me setDisplayList: aDisplayList.
	self openOn: me! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!


Siren.DisplayListSubcanvas comment:
'A DisplayListSubcanvas is used to plug a display list view into an aplpication.

Instance Variables:
	displayList	<?type?>  comment
	componentPart	<CompositePart>  my app. pane
	displayListView <Siren.DisplayListView>  my view (does all the work)
	scroller	<?type?>  my scroller (container)
	vZoom	<Number>  vertical zoom factor
	hZoom	<Number>  horiz. zoom factor
'!

!Siren.DisplayListSubcanvas methodsFor: 'aspects'!

createDisplayListView
	"Create and answer the receiver's display list view"
	"DisplayListSubcanvas open"

	displayList == nil
		ifTrue: [displayList := DisplayList stringsX: 2000 byY: 2000].
	componentPart == nil
		ifTrue: [componentPart := DisplayListView componentOnList: displayList].
	displayListView := componentPart components first component component.		"KLUDJ"
	scroller := displayListView container.
	^componentPart!

hZoom
	"This method was generated by UIDefiner.  Any edits made here
	may be lost whenever methods are automatically defined.  The
	initialization provided below may have been preempted by an
	initialize method."

	^hZoom isNil
		ifTrue:
			[hZoom := 1 asValue]
		ifFalse:
			[hZoom]!

setComponent: aComponent
	"Set the receiver's component part"

	componentPart := aComponent!

setDisplayList: aDisplayList
	"Set the receiver's display list"

	displayList := aDisplayList!

vZoom
	"This method was generated by UIDefiner.  Any edits made here
	may be lost whenever methods are automatically defined.  The
	initialization provided below may have been preempted by an
	initialize method."

	^vZoom isNil
		ifTrue:
			[vZoom := 1 asValue]
		ifFalse:
			[vZoom]! !

!Siren.DisplayListSubcanvas methodsFor: 'actions'!

nextPage

	"This stub method was generated by UIDefiner"

	^self!

prevPage

	"This stub method was generated by UIDefiner"

	^self!

zoomChanged
	"Sent when the users moves the zoom sliders."

	displayListView zoom: (hZoom value @ vZoom value).
	scroller changed!

zoomTo1
	"Sent when the users presses the zoom-to-1 button."

	hZoom value: 1.
	vZoom value: 1.
	self zoomChanged!

zoomToLast

	"This stub method was generated by UIDefiner"

	^self! !

#{Siren.DisplayListView.MusicConstants} initialize!

#{Siren.DisplayListView} initialize!
