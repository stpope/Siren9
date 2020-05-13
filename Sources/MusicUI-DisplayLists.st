

Smalltalk.Siren defineClass: #DisplayItem
	superclass: #{Graphics.DependentPart}
	indexedType: #none
	private: false
	instanceVariableNames: 'offset color '
	classInstanceVariableNames: ''
	imports: ''
	category: 'MusicUI-DisplayLists'!

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!


!Siren.DisplayItem class methodsFor: 'instance creation'!

model: aM offset: aPt
	"Answer an instance of DisplayItem with the given instance variables."

	^self new model: aM; offset: aPt!

offset: aPt
	"Answer an instance of DisplayItem with the given instance variables."

	^self new offset: aPt! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!


Siren.DisplayItem comment:
'Instances of the subclasses of the abstract class DisplayItem are used as the items in display lists. They can generally display themselves on graphics contexts.
These are done this way because I don''t think wrappers are right for use in display lists.

Instance Variables:
	offset		<Point> the object''s offset relative to its container (display list)
	color		<ColorValue> the object''s display color (or nil)

The subclasses add special display-related state and behavior such as an extent point and display method, or a visual item such as a string or image to display.
They generally implement displayOn: aGraphicsContext and bounds accessing methods.

This implementation is MODE 1.1, STEIM, Amsterdam, May/June 1990; updated at the Lagoon in Palo Alto, July, 1991-May, 1992.

The entirety of this software is Copyright (c) 1990, Stephen Travis Pope, Nomad Object Design/Nomad Computer Music Research. 
All Rights Reserved.
'!

!Siren.DisplayItem methodsFor: 'transforming'!

asVisualComponent
	"Answer an encapsulated version of the receiver which understands
	VisualComponent protocol."

	^TranslatingWrapper on: self!

scaleBy: aPoint
	"Translate the receiver's offset by the argument."

	self extent: self extent * aPoint!

scaledBy: aPoint
	"Translate the receiver's offset by the argument."

	^self copy extent: self extent * aPoint!

translateBy: aPoint
	"Translate the receiver's offset by the argument."

	self offset: self offset + aPoint! !

!Siren.DisplayItem methodsFor: 'accessing'!

color
	"Answer the receiver's display color."

	^color!

color: aVal
	"Set the receiver's display color to the argument."

	color := ((aVal isMemberOf: BlockClosure)
		ifTrue: [aVal value]
		ifFalse: [aVal])!

container: aContainer
	"Set the receiver's container to be aContainer."

	container := aContainer.!

extent
	"Answer the extent of the receiver (dummy in this class)."

	^1@1!

extent: aPoint
	"Ignored"!

offset
	"Answer the receiver's offset."

	^offset!

offset: aPoint
	"Set the receiver's offset to the argument."

	offset := aPoint! !

!Siren.DisplayItem methodsFor: 'copying'!

copy
	"Answer a shallow copy of the receiver."

	^self shallowCopy! !

!Siren.DisplayItem methodsFor: 'testing'!

isDisplayItem
	"Answer whether the receiver is a kind of DisplayItem"

	^true! !

!Siren.DisplayItem methodsFor: 'displaying'!

displayOn: aGraphicsContext
	"Display the receiver on the argument."

	self subclassResponsibility!

displayPostScriptOn: aPostScriptContext
	"Display the receiver on the argument in PostScript."

	self subclassResponsibility! !

!Siren.DisplayItem methodsFor: 'bounds accessing'!

computePreferredBounds
	"Answer the receiver's bounds--hack."

	^self bounds!

preferredBounds
	"Answer the receiver's bounds--hack."

	^self bounds!

preferredExtent

	^self preferredBounds extent! !

!Siren.DisplayItem methodsFor: 'initialize-release'!

initialize
	"Initialize the instance variables of the receiver."

	offset := 0@0! !

!Siren.DisplayItem methodsFor: 'printing'!

printCompleteOn: aStream depth: depth
	"Print the receiver in the given Stream."

	aStream cr.
	depth timesRepeat: [aStream tab].
	aStream nextPutAll: '(a ', self class name. 
	model == nil ifFalse: [aStream nextPutAll: ' model: '. model printOn: aStream].
	offset == nil ifFalse: [aStream nextPutAll: ' offset: '. offset printOn: aStream].
	aStream nextPut: $).!

printOn: aStream
	"Print the receiver in the given Stream."

	aStream nextPutAll: '(a ', self class name. 
	model == nil ifFalse: [aStream nextPutAll: ' model: '. model printOn: aStream].
	offset == nil ifFalse: [aStream nextPutAll: ' offset: '. offset printOn: aStream].
	aStream nextPut: $); cr.! !



Smalltalk.Siren defineClass: #DisplayLine
	superclass: #{Siren.DisplayItem}
	indexedType: #none
	private: false
	instanceVariableNames: 'width extent '
	classInstanceVariableNames: ''
	imports: ''
	category: 'MusicUI-DisplayLists'!

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!


!Siren.DisplayLine class methodsFor: 'instance creation'!

from: oPoint to: endPoint
	"Answer an initialized instance."

	^((self new) offset: oPoint) extent: (endPoint - oPoint)!

offset: oPoint extent: ePoint	
	"Answer an initialized instance."

	^((self new) offset: oPoint) extent: ePoint! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!


Siren.DisplayLine comment:
'Instances of DisplayLine are used for visual lines in display lists.

Instance Variables:
	width		<Number> the object''s line width
	extent		<Point> the object''s visual extent'!

!Siren.DisplayLine methodsFor: 'accessing'!

corner: aPoint
	"Set the corner of the receiver (offset + extent)."

	offset == nil
		ifFalse: [extent := aPoint - offset].
"	end := (offset == nil
			ifTrue: [aPoint]
			ifFalse: [start + aPoint])."
	^self!

extent
	"Answer the extent of the receiver."

	^extent!

extent: aPoint
	"Set the extent of the receiver."

	extent := aPoint
"	end := (offset == nil
			ifTrue: [aPoint]
			ifFalse: [start + aPoint])"!

width: aVal
	width := aVal! !

!Siren.DisplayLine methodsFor: 'printing'!

printOn: aStream
	"Print the receiver in the given Stream."

	aStream nextPutAll: ' (a ', self class name. 
	model == nil ifFalse: [aStream nextPutAll: ' model: '. model printOn: aStream].
	offset == nil ifFalse: [aStream nextPutAll: ' offset: '. offset printOn: aStream].
	extent == nil ifFalse: [aStream nextPutAll: ' extent: '. extent printOn: aStream].
"	color == nil ifFalse: [aStream nextPutAll: ' color: '. color printOn: aStream]."
	aStream nextPut: $); cr.! !

!Siren.DisplayLine methodsFor: 'displaying'!

displayOn: aGraphicsContext
	"Display a line between startPoint and endPoint."

"	Transcript show: start printString, '	', end printString; cr."
	color == nil
		ifFalse: [aGraphicsContext paint: color].
	width == nil
		ifFalse: [aGraphicsContext lineWidth: width].
	aGraphicsContext displayLineFrom: offset to: (offset + extent)!

displayPostScriptOn: aPostscriptContext
	"Display the receiver on the argument as a PostScript item."

	aPostscriptContext translate: offset.
	aPostscriptContext rlineto: extent	.
	aPostscriptContext translate: offset negated.! !

!Siren.DisplayLine methodsFor: 'bounds accessing'!

bounds
	"Answer the receiver's bounds." 

	^offset extent: ((extent x max: 1) @ (extent y max: 1))! !



Smalltalk.Siren defineClass: #DisplayRectangle
	superclass: #{Siren.DisplayLine}
	indexedType: #none
	private: false
	instanceVariableNames: 'fill stroke '
	classInstanceVariableNames: ''
	imports: ''
	category: 'MusicUI-DisplayLists'!

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!


!Siren.DisplayRectangle class methodsFor: 'examples'!

rectangleExample
	"Open a display list view with randomly-placed random-color rectangles over the given extent."
	"DisplayRectangle rectangleExample"

	(DisplayList rectanglesX: 600 byY: 600) display! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!


Siren.DisplayRectangle comment:
'Instances of DisplayRectangle can be used to display bordered or filled rectangles in display lists. This is a subclass of DisplayLine for reasons of practicality. a "purist" (e.g., David Liebs), would create an intermediate abstract class (e.g., BoundedDisplayItem) for both DisplayLine and DisplayRectangle.

Instanve Variables:
	fill		<Boolean or nil> whether or not to fill the receiver on display (no by default)'!

!Siren.DisplayRectangle methodsFor: 'displaying'!

displayOn: aGraphicsContext
	"Display a line between startPoint and endPoint."

"	Transcript show: start printString, '	', end printString; cr."
	color == nil
		ifFalse: [aGraphicsContext paint: color].
	(fill == nil or: [fill not])
		ifFalse: [aGraphicsContext displayRectangle: (offset extent: extent)]
		ifTrue: [aGraphicsContext displayRectangularBorder: (offset extent: extent)]!

displayPostScriptOn: aPostscriptContext
	"Display the receiver on the argument as a PostScript item."

	aPostscriptContext translate: offset.
	aPostscriptContext box: extent y width: extent x.
	aPostscriptContext translate: offset negated.! !

!Siren.DisplayRectangle methodsFor: 'accessing'!

fill: aBoolean
	"Set the receiver's filling Boolean."

	fill := aBoolean!

stroke: aNum
	"Set the receiver's stroke line thickness."

	stroke := aNum! !



Smalltalk.Siren defineClass: #DisplayPolyline
	superclass: #{Siren.DisplayRectangle}
	indexedType: #none
	private: false
	instanceVariableNames: 'vertices '
	classInstanceVariableNames: ''
	imports: ''
	category: 'MusicUI-DisplayLists'!

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!


!Siren.DisplayPolyline class methodsFor: 'examples'!

polylineExample
	"Open a display list view with randomly-placed random-color polylines over the given extent."
	"DisplayPolyline polylineExample"

	(DisplayList polylinesX: 600 byY: 600) display! !

!Siren.DisplayPolyline class methodsFor: 'instance creation'!

offset: offPt vertices: arrayOfPoints
	"Answer a new DisplayPolyline with the arguments as its vertices."

	^self basicNew offset: offPt; vertices: arrayOfPoints!

vertices: arrayOfPoints
	"Answer a new DisplayPolyline with the arguments as its vertices."

	^self basicNew vertices: arrayOfPoints! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!


Siren.DisplayPolyline comment:
'A DisplayPolyline is a poly-line-segment display object

Instance Variables:
	vertices	<OrderedCollection of Point>  my point array
'!

!Siren.DisplayPolyline methodsFor: 'transforming'!

scaledBy: aPoint
	"Scale all the receiver's points by the argument; answer a copy."

	|  newPts |
	newPts := vertices collect: [ :pt | (pt * aPoint) truncated].
	^self class offset: offset vertices: newPts! !

!Siren.DisplayPolyline methodsFor: 'accessing'!

bounds
	"Answer the receiver's bounds." 

	| ext |
	ext := 0@0.
	vertices do: [ :pt | ext := ext max: pt].
	^offset extent: ext!

extent
	"Answer the receiver's extent." 

	^self bounds extent!

vertices: pointArray
	"Set the receiver's vertices."

	vertices := pointArray asArray! !

!Siren.DisplayPolyline methodsFor: 'displaying'!

displayOn: aGraphicsContext
	"Stroke the receiver's edges on the supplied GraphicsContext."

	| cachedLW |
	color == nil
		ifTrue: [aGraphicsContext paint: ColorValue black]
		ifFalse: [aGraphicsContext paint: ColorValue black].
	stroke == nil
		ifFalse: [cachedLW := aGraphicsContext lineWidth.
			aGraphicsContext lineWidth: stroke].
	offset == nil
		ifFalse: [aGraphicsContext translateBy: offset].
	(fill == true)
		ifFalse: [aGraphicsContext displayPolyline: vertices at: Point zero]
		ifTrue: [aGraphicsContext displayPolygon: vertices at: Point zero].
	offset == nil
		ifFalse: [aGraphicsContext translateBy: offset negated].
	stroke == nil
		ifFalse: [aGraphicsContext lineWidth: cachedLW].! !



Smalltalk.Siren defineClass: #DisplayList
	superclass: #{Graphics.DependentComposite}
	indexedType: #none
	private: false
	instanceVariableNames: 'offset '
	classInstanceVariableNames: ''
	imports: ''
	category: 'MusicUI-DisplayLists'!

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!


!Siren.DisplayList class methodsFor: 'examples'!

exampleHierarchical
	"Create and answer a large display list with a lines, strings, and visuals."
	"DisplayList exampleHierarchical display"

	| dl1 dl2 dl3 dl4 dl5 dl6 rand size |
	size := 100.
	dl1 := DisplayList new.
	dl2 := DisplayList new.
	dl3 := DisplayList new.
	dl4 := DisplayList new.
	dl5 := DisplayList new.
	dl6 := DisplayList new.
	rand := Random new.
	10 timesRepeat:
		[ | pt |
		pt := (rand next * size) rounded @ ((rand next * size) rounded).
		dl1 add: ((DisplayString string: (pt printString) 
				offset: pt) color: (ColorValue random: rand))].
	10 timesRepeat:
		[ | x y w h |
		x := (rand next * size) rounded.		y := (rand next * size) rounded.
		w := (rand next * size) rounded.		h :=  (rand next * size) rounded.
		dl2 add: ((DisplayRectangle offset: (x@y) extent: (w@h))
				color: (ColorValue random: rand); fill: true)].
	10 timesRepeat:
		[ | x y w h |
		x := (rand next * size) rounded.		y := (rand next * size) rounded.
		w := (rand next * size) rounded.		h :=  (rand next * size) rounded.
		dl3 add: ((DisplayRectangle offset: (x@y) extent: (w@h))
				color: (ColorValue random: rand); fill: true)].
	10 timesRepeat:
		[ | pt |
		pt := (rand next * size) rounded @ ((rand next * size) rounded).
		dl4 add: ((DisplayString string: (pt printString) 
				offset: pt) color: (ColorValue random: rand))].
	dl1 computePreferredBounds.
	dl2 computePreferredBounds.
	dl3 computePreferredBounds.
	dl4 computePreferredBounds.
	dl5 add: dl1;
		add: dl2 at: (250@0);
		add: dl3 at: (0@250); 
		add: dl4 at: (250@250).
	dl5 computePreferredBounds.
	dl6 add: dl5 at: (50@50).
	dl6 computePreferredBounds.
	^dl6!

gridExample
	"Create and answer a large display list with lines and strings."
	"DisplayList gridExample display"
	"DisplayListView example"

	| dList rand ext step |
	ext := 2000.
	step := 50.
	dList := DisplayList new.
	0 to: (ext/step) do:
		[ :i |
		dList add: ((DisplayLine offset: (i*step)@0 extent: 0@ext) color: ColorValue random).
		dList add: ((DisplayLine offset: 0@(i*step) extent: ext@0) color: ColorValue random)].
	rand := Random new.
	1 to: 200 do:
		[ :i | | pt |
		pt := (rand next * ext) rounded @ ((rand next * ext) rounded).
		dList add: ((DisplayString string: (pt printString) offset: pt)color: ColorValue random)].
	^dList!

gridExampleX: x byY: y
	"Create and answer a large display list with lines and strings."
	"(DisplayList gridExampleX: 3000 byY: 500) display"
	"DisplayListView example"

	| dList rand step |
	step := 50.
	dList := DisplayList new.
	0 to: (x/step) do:
		[ :i |
		dList add: (DisplayLine offset: (i*step)@0 extent: 0@y)].
	0 to: (y/step) do:
		[ :i |
		dList add: (DisplayLine offset: 0@(i*step) extent: x@0)].
	rand := Random new.
	1 to: (x * y / 20000) do:
		[ :i | | pt |
		pt := (rand next * x) rounded @ ((rand next * y) rounded).
		dList add: (DisplayString string: (pt printString) offset: pt)].
	^dList!

polylineExample
	"Answer a display list with randomly-placed random-color polylines over the given extent."
	"DisplayList polylineExample"

	(DisplayList polylinesX: 600 byY: 600 items: 100) display!

polylineExampleHuge
	"Answer a display list with randomly-placed random-color polylines over the given (very large) extent."
	"DisplayList polylineExampleHuge"

	(DisplayList polylinesX: 6000 byY: 6000 items: 10000) display!

polylinesX: x byY: y
	"Answer a display list with randomly-placed random-color polylines over the given extent."
	"(DisplayList polylinesX: 600 byY: 600) display"

	| dList rand inset scale x0 y0 size pointArray |
	inset := 16.
	scale := 128.
	dList := DisplayList new.
	rand := Random new.
	x0 := rand nextIntFrom: inset to: x-inset.
	y0 := rand nextIntFrom: inset to: y-inset.
	((x/20) + (y/20)) timesRepeat:
		[size := rand nextIntFrom: 3 to: 7.
		pointArray := Array new: size.
		pointArray at: 1 put: (0@0).
		pointArray at: size put: (0@0).
		x0 := y0 := 0.
		2 to: size-1 do: [ :i |
			x0 := x0 + (rand nextIntFrom: scale negated to: scale).
			y0 := y0 + (rand nextIntFrom: scale negated to: scale).
			pointArray at: i put: (x0 @ y0)].
		dList add: ((DisplayPolyline
				offset: ((rand nextIntFrom: inset to: x-inset)
						@(rand nextIntFrom: inset to: y-inset)))
				color: ColorValue random;
				vertices: pointArray)].
	^dList!

polylinesX: x byY: y items: num
	"Answer a display list with randomly-placed random-color polylines over the given extent."
	"(DisplayList polylinesX: 600 byY: 600 items: 1000) display"

	| dList rand inset scale x0 y0 size pointArray |
	inset := 16.
	scale := 128.
	dList := DisplayList new.
	rand := Random new.
	x0 := rand nextIntFrom: inset to: x-inset.
	y0 := rand nextIntFrom: inset to: y-inset.
	num timesRepeat:
		[size := rand nextIntFrom: 3 to: 7.
		pointArray := Array new: size.
		pointArray at: 1 put: (0@0).
		pointArray at: size put: (0@0).
		x0 := y0 := 0.
		2 to: size-1 do: [ :i |
			x0 := x0 + (rand nextIntFrom: scale negated to: scale).
			y0 := y0 + (rand nextIntFrom: scale negated to: scale).
			pointArray at: i put: (x0 @ y0)].
		dList add: ((DisplayPolyline
				offset: ((rand nextIntFrom: inset to: x-inset)
						@(rand nextIntFrom: inset to: y-inset)))
				color: ColorValue random;
				vertices: pointArray)].
	^dList!

postScriptExample
	"Create and answer a large display list with a lines, strings, and visuals."
	"DisplayList postScriptExample"
	"NOT WORKING"

	| dList psRenderer file |
	dList := (DisplayList stringsX: 600 byY: 900) "DisplayList example2".
	file := 'temp.ps' asFilename writeStream.
	psRenderer := PostScriptPrinter new.
	psRenderer file: file; start: nil.
"	psRenderer scale: 10@10."
	dList displayPostScriptOn: psRenderer.
	psRenderer endNoPrint: nil. 		"this prints it."
"	'temp.ps' asFilename edit."!

randomExample
	"Create and answer a large display list with a lines, strings, and visuals."
	"DisplayList randomExample display"

	| dList rand ext num |
	ext := 3000.
	dList := DisplayList new.
	rand := Random new.
	num := 500.
	num timesRepeat:
		[ | x y w h |					"add rectangles"
		x := (rand next * ext) rounded.
		y := (rand next * ext) rounded.
		w := (rand next * ext/30) rounded.
		h :=  (rand next * ext/30) rounded.
		dList add: ((DisplayRectangle
				offset: (x@y)
				extent: (w@h))
				color: ColorValue random; fill: true)].
	num timesRepeat:
		[ | pt1 pt2 |					"add lines"
		pt1 := (rand next * ext) rounded @ ((rand next * ext) rounded).
		pt2 := (rand next * ext) rounded @ ((rand next * ext) rounded).
		dList add: ((DisplayLine offset: pt2 extent: (pt1 - pt2))
				color: ColorValue random)].
	num timesRepeat:
		[ | pt |						"add strings"
		pt := (rand next * ext) rounded @ ((rand next * ext) rounded).
		dList add: ((DisplayString string: (pt printString) 
				offset: pt) color: ColorValue random)].
	num timesRepeat:
		[ | pt coll |					"add visuals"
		coll := Cursor allInstances.
		pt := (rand next * ext) rounded @ ((rand next * ext) rounded).
		dList add: ((DisplayVisual visual: (coll atRandom asOpaqueImage figure) 
				offset: pt) color: ColorValue random)].
	^dList!

rectangleExample
	"Answer a display list with randomly-placed random-color rectangles over the given extent."
	"DisplayList rectangleExample"

	(DisplayList rectanglesX: 2000 byY: 2000) display!

rectanglesX: x byY: y
	"Answer a display list with randomly-placed random-color rectangles over the given extent."
	"(DisplayList rectanglesX: 600 byY: 600) display"

	| dList rand x0 y0 x1 y1 scale w h |
	dList := DisplayList new.
	rand := Random new.
	scale := 0.
	x0 := x - (scale * 2).
	y0 := y - (scale * 2).
	((x/10) + (y/10)) timesRepeat:
		[x1 := scale + (rand next * x0) rounded.
		y1 := scale + (rand next * y0) rounded.
		w := ((rand next * 0.5 * (x / 20) abs) rounded).
		h :=  ((rand next * 0.5 * (y / 20) abs) rounded).
		dList add: ((DisplayRectangle
				offset: (x1@y1)
				extent: (w@h))
				color: ColorValue random; fill: true)].
	^dList!

stringExample
	"Open a display list view with randomly-placed random-color strings over the given extent."
	"DisplayList stringExample"

	(DisplayList stringsX: 4000 byY: 4000) display!

stringsX: x byY: y
	"Answer a display list with randomly-placed random-color strings over the given extent."
	"(DisplayList stringsX: 600 byY: 600) display"

	| dList rand inset |
	inset := 16.
	dList := DisplayList new.
	rand := Random new.
	((x/5) + (y/5)) timesRepeat:
		[ | pos |
		pos := (rand nextIntFrom: inset to: x - inset) @ (rand nextIntFrom: inset to: y - inset).
		dList add: ((DisplayString
				string: pos printString
				offset: pos)
				color: ColorValue random)].
	^dList!

visualsX: x byY: y
	"Answer a display list with randomly-placed random-color visuals over the given extent."
	"(DisplayList visualsX: 600 byY: 600) display"

	| dList rand inset |
	inset := 16.
	dList := DisplayList new.
	rand := Random new.
	((x/10) + (y/10)) timesRepeat:
		[dList add: ((DisplayVisual
				visual: (rand nextIntFrom: 10 to: 100000) printString asParagraph
				offset: ((rand nextIntFrom: inset to: x-inset)
						@(rand nextIntFrom: inset to: y-inset)))
				color: ColorValue random)].
	^dList! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!


Siren.DisplayList comment:
'Instances of DisplayList are used for representing composed structured graphics. They can be nested (see the class examples) and can display themselves and their components.

Instance Variables:
	offset		<Point> the object''s offset distance relative to its container'!

!Siren.DisplayList methodsFor: 'accessing'!

color
	^ColorValue black!

flatten
	"Answer a copy of the receiver with its hierarchy flattened."

	| new |
	new := DisplayList new.
	components do:
		[ :item |
		item hasItems
			ifTrue: [ | subnew |
				subnew := item flatten components.
				subnew do: [ :subitem |
					new add: (subitem translateBy: item offset)]]
			ifFalse: [new add: item]].
	^new!

itemWithin: dist of: point
	"Answer the list of items whose boundingBoxes are entirely within the given rectangle."

	components do: 
		[ :comp |
		comp hasItems
			ifTrue: [ | item |
				(item := comp itemWithin: dist of: (point - self offset)) == nil
					ifFalse: [^item]]
			ifFalse: [((comp bounds expandedBy: dist) containsPoint: point)
					ifTrue: [^comp]]].
	^nil!

itemsFromX: x1 toX: x2
	"Answer the list of items whose offsets are within the given X range."

	| dList |
	dList := DisplayList new.
	components do: 
		[ :i |
		i hasItems
			ifTrue:
				[ | tList |
				tList := i itemsFromX: x1 + i offset x 
							toX: x2 + i offset x.
				tList isEmpty ifFalse: [dList add: tList at: i offset]]
			ifFalse:
				[(i offset x between: x1 and: x2) ifTrue: [dList add: i]]].
	^dList!

itemsIntersecting: rect
	"Answer the list of items whose boundingBoxes intersect the given rectangle. 
	Clip them to the box's border if necessary."

	| dList dList2 |
	dList := DisplayList new.
	components do: 
		[ :i |
		i hasItems
			ifTrue: [dList2 := i itemsIntersecting: (rect translateBy: self offset).
				dList2 == nil
					ifFalse: [dList add: (dList2 offset: i offset)]]
			ifFalse: [(((i boundingBox) translateBy: self offset) 
								intersects: rect)
					ifTrue: [dList add: (i clipTo: (rect translateBy: ((0@0) - self offset)))]]].
	^(dList components isEmpty)
		ifTrue: [nil]
		ifFalse: [(dList components size = 1)
			ifTrue: [dList components first]
			ifFalse: [dList]]!

itemsWithin: rect
	"Answer the list of items whose boundingBoxes are entirely within the given rectangle."

	| dList movedRect |
	movedRect := rect moveBy: self offset negated.
	dList := DisplayList new.
	components do: 
		[ :comp |
		comp hasItems
			ifTrue: [ | items |
				items := comp itemsWithin: movedRect.
				items == nil ifFalse: [dList add: items]]
			ifFalse: [(movedRect contains: comp bounds) 
					ifTrue: [dList add: comp]]].
	(dList components isEmpty)
		ifTrue: [^nil]
		ifFalse: [(dList components size = 1)
			ifTrue: [ | first |
				first := dList components first.
				first hasItems
					ifTrue: [first container: nil].
				^first copy translateBy: self offset]
			ifFalse: [^dList translateBy: self offset]]!

itemsWithin: dist of: point
	"Answer the list of items whose boundingBoxes are entirely within the given rectangle."

	| dList |
	dList := DisplayList new.
	components do: 
		[ :comp |
		comp hasItems
			ifTrue: [dList add: 
					(comp itemsWithin: dist of: (point - self offset))]
			ifFalse: [((comp bounds expandBy: dist) containsPoint: point)
					ifTrue: [dList add: comp]]].
	^(dList components isEmpty)
		ifTrue: [nil]
		ifFalse: [(dList components size = 1)
			ifTrue: [dList components first]
			ifFalse: [dList]]!

modelsFromX: x1 toX: x2
	"Answer the list of model-space-items whose offsets are within the given X range."

	| dList |
	dList := DisplayList new.
	components do: 
		[ :i |
		((i offset x >= x1) and: [i offset x <= x2])
				ifTrue: [dList add: i]].
	^dList collect: [ :i | i model]!

nodeAt: aPath
	"Answer the element described by the collection of items in the argument."

	| next path2 |
	components isEmpty ifTrue: [^nil].
	next := components
			detect: [ :i | 
					i "component" model == aPath first]
			ifNone: [nil].
	next == nil
		ifFalse: [aPath size = 1
			ifTrue: [^next]
			ifFalse: [path2 := aPath copy.
				path2 removeFirst.
				^next nodeAt: path2]]
		ifTrue: [^nil]!

nodeFor: aModel
	"Answer the element whose model is the argument."

	components isEmpty ifTrue: [^nil].
	^components
			detect: [ :i | 
					i model == aModel]
			ifNone: [nil].!

offset
	"Answer the receiver's offset."

	^offset == nil
		ifTrue: [0@0]
		ifFalse: [offset]!

offset: aPoint
	"Set the receiver's offset."

	offset := aPoint!

wrapperClass
	"Raise an error."

	self error: 'I don''t use Wrappers!!'! !

!Siren.DisplayList methodsFor: 'testing'!

hasItems
	"Answer whether or not the receiver has items or components."

	^true!

isEmpty
	"Amswer whether the receiver has any items."

	^components isEmpty! !

!Siren.DisplayList methodsFor: 'transforming'!

scaledBy: aPoint
	"Scale the receiver's offset by the argument."

	| newMe |
	newMe := self class new.
	self do:
		[ :item |
		newMe add: (item scaledBy: aPoint) at: item offset * aPoint].
	^newMe!

translateBy: aPoint
	"Translate the receiver's offset by the argument."

	self offset: self offset + aPoint! !

!Siren.DisplayList methodsFor: 'displaying'!

display
	"Open a DisplayListView on the receiver."

	self computePreferredBounds.
	^DisplayListSubcanvas openOnList:  self!

displayNonCached
	"Open a DisplayListView on the receiver."

	^DisplayListView openNonCached: self!

displayOn: aGraphicsContext
	"Display each of the receiver's components."

	| clipBox |
	clipBox := aGraphicsContext clippingBounds.
	offset ifNotNil: [aGraphicsContext translateBy: offset].
	components do:
		[ :c | (c intersects: clipBox)
			ifTrue: [c displayOn: aGraphicsContext]].
	offset ifNotNil: [aGraphicsContext translateBy: offset negated].!

displayPostScriptOn: aPostscriptContext
	"Display each of the receiver's components."

	offset == nil
		ifFalse: [aPostscriptContext translate: offset].
	1 to: components size do:
		[ :i | (components at: i) displayPostScriptOn: aPostscriptContext].
	offset == nil
		ifFalse: [aPostscriptContext translateBy: offset negated].! !

!Siren.DisplayList methodsFor: 'bounds accessing'!

bounds
	"Compute the receiver's preferredBounds"

	| preferredBounds |
self halt.
	components isEmpty
		ifTrue: [preferredBounds := (0@0) extent: (0@0)]
		ifFalse: [preferredBounds := components first computePreferredBounds].
	1 to: components size do:
		[:i |
		preferredBounds := preferredBounds merge: (components at: i) computePreferredBounds].
	preferredBounds origin < (0@0)
		ifTrue: [preferredBounds := preferredBounds 
				translatedBy: preferredBounds origin negated].
	offset == nil
		ifTrue: [preferredBounds := preferredBounds expandedBy: (64@64)]
		ifFalse: [preferredBounds := (preferredBounds translatedBy: offset) expandedBy: (64@64)].
	preferredExtent := preferredBounds extent.
	^preferredBounds!

computePreferredBounds
	"Compute the receiver's preferredBounds"

	| preferredBounds |
	components isEmpty
		ifTrue: [preferredBounds := (0@0) extent: (0@0)]
		ifFalse: [preferredBounds := components first computePreferredBounds].
	1 to: components size do:
		[:i |
		preferredBounds := preferredBounds merge: (components at: i) computePreferredBounds].
	preferredBounds origin < (0@0)
		ifTrue: [preferredBounds := preferredBounds 
				translatedBy: preferredBounds origin negated].
	offset == nil
		ifTrue: [preferredBounds := preferredBounds expandedBy: (64@64)]
		ifFalse: [preferredBounds := (preferredBounds translatedBy: offset) expandedBy: (64@64)].
	preferredExtent := preferredBounds extent.
	^preferredBounds!

extent
	"Answer the extent of the receiver."

	^self computePreferredBounds extent!

preferredBounds
	"Compute the receiver's preferredBounds"

	| preferredBounds |
	components isEmpty
		ifTrue: [preferredBounds := (0@0) extent: (0@0)]
		ifFalse: [preferredBounds := components first computePreferredBounds].
	1 to: components size do:
		[:i |
		preferredBounds := preferredBounds merge: (components at: i) computePreferredBounds].
	preferredBounds origin < (0@0)
		ifTrue: [preferredBounds := preferredBounds 
				translatedBy: preferredBounds origin negated].
	offset == nil
		ifTrue: [preferredBounds := preferredBounds expandedBy: (64@64)]
		ifFalse: [preferredBounds := (preferredBounds translatedBy: offset) expandedBy: (64@64)].
	preferredExtent := preferredBounds extent.
	^preferredBounds! !

!Siren.DisplayList methodsFor: 'enumerating'!

do: aBlock
	"Iterate the argument block over the receiver's components."

	components do: aBlock! !

!Siren.DisplayList methodsFor: 'printing'!

printCompleteOn: aStream depth: depth
	"Descend the hierarchy printing on the stream."

	aStream cr.
	depth timesRepeat: [aStream tab].
	aStream nextPutAll: '(a DisplayList '.
	offset == nil
		ifFalse: [aStream nextPutAll: ' offset: ', offset printString].
"	model == nil
		ifFalse: [aStream nextPutAll: ' model: ', model printString]."
	components == nil
		ifFalse: [components do: 
			[ :e | 
			e printCompleteOn: aStream depth: depth + 1]].
	aStream nextPut: $)!

printCompletePostScriptOn: aStream depth: depth
	"Descend the hierarchy printing on the stream."

	aStream cr.
	depth timesRepeat: [aStream tab].
	aStream nextPutAll: '(a DisplayList '.
	offset == nil
		ifFalse: [aStream nextPutAll: ' offset: ', offset printString].
"	model == nil
		ifFalse: [aStream nextPutAll: ' model: ', model printString]."
	components == nil
		ifFalse: [components do: 
			[ :e | 
			e printCompleteOn: aStream depth: depth + 1]].
	aStream nextPut: $)!

printOn: aStream
	"Print the receiver on the argument using the recursive method."

	^InputState default shiftDown 
		ifTrue: [super printOn: aStream]
		ifFalse: [self printCompleteOn: aStream depth: 0]!

printPostScriptOn: aStream
	"Print the receiver on the argument using the recursive method."

	^self printCompletePostScriptOn: aStream depth: 0! !

!Siren.DisplayList methodsFor: 'adding-removing'!

add: aVisualComponent
	"Add the argument to the receiver."

	^self addComponent: aVisualComponent!

add: aVisualComponent at: aPoint
	"Add aVisualComponent to the receiver's components with its offset set to aPoint."

	aVisualComponent offset: aPoint.
	self add: aVisualComponent!

add: anItem atPath: aPath
	"Add the first argument at the node described by the second."

	| node |
	(aPath == nil or: [aPath isEmpty])
		ifTrue: [^self add: anItem].
	node := self nodeAt: aPath.
	node == nil
		ifTrue: [self addComponent: anItem]
		ifFalse: [node addComponent: anItem]!

addAll: aCollection
	"Add the argument to the receiver."

	aCollection do: [ :item | self add: item]!

addComponent: aVisualComponent
	"Add the argument to the receiver."

	components addLast: aVisualComponent.
	aVisualComponent container: self!

addWrapper: aVisualWrapper
	"Raise an error."

	self error: 'I don''t use Wrappers!!'! !



Smalltalk.Siren defineClass: #DisplayVisual
	superclass: #{Siren.DisplayItem}
	indexedType: #none
	private: false
	instanceVariableNames: 'visual '
	classInstanceVariableNames: ''
	imports: '
			MusicConstants
			'
	category: 'MusicUI-DisplayLists'!

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!


!Siren.DisplayVisual class methodsFor: 'instance creation'!

model: aM visual: aV offset: aPt
	"Answer an instance of DisplayItem with the given instance variables."

	^self new model: aM; visual: aV; offset: aPt!

visual: aV
	"Answer an instance of DisplayItem with the given instance variables."

	^(super new initialize) visual: aV!

visual: aV offset: aPt
	"Answer an instance of DisplayItem with the given instance variables."

	^(super new initialize) visual: aV; offset: aPt!

visual: aV origin: aPt
	"Answer an instance of DisplayItem with the given instance variables."

	^(super new initialize) visual: aV; offset: aPt! !

!Siren.DisplayVisual class methodsFor: 'examples'!

convertMusicConstants
	"Convert all the forms to opaque forms"
	"DisplayVisual convertMusicConstants. DisplayVisual displayMusicConstants"

	| all |
	all := DisplayListView constants.
	all keysAndValuesDo: [ :key :group |
		Transcript show: key printString; cr.
		(group isMemberOf: Dictionary)
			ifTrue: [group keysAndValuesDo:
				[ :str :item | | newI |
				(item isKindOf: DisplayVisual)
					ifTrue: [newI := item.
						item visual: (OpaqueImage figure: item visual 
							shape: (item visual convertToCoverageWithOpaquePixel: 1))]
					ifFalse: [(item isMemberOf: Depth1Image)
							ifTrue: [newI := OpaqueImage figure: item 
												shape: (item convertToCoverageWithOpaquePixel: 1)]].
				group at: str put: newI]].
		((group isMemberOf: Array) or: [(group isMemberOf: OrderedCollection)])
			ifTrue: [group do:
					[ :item |
					(item isMemberOf: OpaqueImage)
						ifFalse: [item visual: (OpaqueImage figure: item visual 
								shape: (item visual convertToCoverageWithOpaquePixel: 1))]]]]!

displayMusicConstants
	"Draw a nice table of the hierarchical image dictionary."
	"DisplayVisual displayMusicConstants"

	| win xstep y i ystep comp |
	win := ScheduledWindow model: nil label: 'MusicConstants' 
			minimumSize: 700@750.
	comp := CompositePart new.
	xstep := 64.
	ystep := 48.
	y := 0.
	DisplayListView constants keysAndValuesDo: [ :title :dict |
		i := 0.
		comp add: (DisplayString string: title) at: (xstep@y).
		y := y + (ystep/2).
		dict keysAndValuesDo:
			[ :str :item |
			comp add: (DisplayString string: (str respondsToArithmetic 
					ifTrue: [str printString] ifFalse: [str "clipTo: 6"]))
			 at: ((i*xstep+8)@y).
			comp add: item at: ((i*xstep+8)@(y+(ystep/2))).
			i := i + 1.
			i = 14 ifTrue: [i := 0. y := y + (ystep * 1.5)]].
		y := y + ystep + 24].
	win component: (BoundedWrapper on: comp).
	win open!

storeMusicConstants
	"Write out all the forms to opaque forms"
	"DisplayVisual storeMusicConstants"

	| fil all |
	fil := 'MusicConstants.st' asFilename writeStream.
	all := DisplayListView constants.
	all keysAndValuesDo: [ :key :group |
		Transcript show: key printString; cr.
		(group isMemberOf: Dictionary)
			ifTrue: [fil cr; nextPutAll: 'Siren.DisplayListView constants at: ', key printString,
						 ' put: IdentityDictionary new.'; cr.
					group keysAndValuesDo:
					[ :str :item | 
					fil cr; nextPutAll: '(Siren.DisplayListView constants at: ', key printString, 
						') at: ''', str, ''' asSymbol put: '.
					item storeOn: fil.
					fil nextPut: $!! ]].
		((group isMemberOf: Array) or: [(group isMemberOf: OrderedCollection)])
			ifTrue: [fil cr; nextPutAll: 'Siren.DisplayListView constants at: ', key printString,
						 ' put: OrderedCollection new.'; cr.
				group do:
					[ :item |
					fil cr; nextPutAll: '(Siren.DisplayListView constants at: ', key printString, ') add: '.
					item storeOn: fil.
					fil nextPut: $!! ]]].
	fil close!

visualExample
	"Open a display list view with randomly-placed random-color visuals over the given extent."
	"DisplayVisual visualExample"

	(DisplayList visualsX: 600 byY: 600) display! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!


Siren.DisplayVisual comment:
'Instances of DisplayVisual are used for displaying arbitrary visual objects (e.g., cached images) in display lists.

Instance Variables:
	visual		<VisualComponent> the object''s visual object, typically an image'!

!Siren.DisplayVisual methodsFor: 'accessing'!

bounds
	"Answer the visual's bounds translated by the receiver's translation."

	^offset == nil
		ifTrue: [visual bounds]
		ifFalse: [visual bounds translatedBy: offset]!

visual
	"Answer the receiver's visual."

	^visual!

visual: aVisual
	"Set the receiver's visual."

	visual := aVisual.
"	aVisual palette == nil
		ifTrue: [aVisual palette: MappedPalette colorDefault]
"! !

!Siren.DisplayVisual methodsFor: 'printing'!

printOn: aStream
	"Print the receiver in the given Stream."

	aStream nextPutAll: '(a ', self class name. 
	model == nil ifFalse: [aStream nextPutAll: ' model: '. model printOn: aStream].
	visual == nil ifFalse: [aStream nextPutAll: ' visual: '. visual printOn: aStream].
	offset == nil ifFalse: [aStream nextPutAll: ' offset: '. offset printOn: aStream].
	aStream nextPut: $); cr.!

storeOn: aStream
	"Print the receiver in the given Stream."

	aStream nextPutAll: '('; store: self class. 
	visual == nil ifFalse: [aStream nextPutAll: ' visual: '. visual storeOn: aStream].
	offset == nil ifFalse: [aStream nextPutAll: ' offset: '. offset printOn: aStream].
	aStream nextPut: $)! !

!Siren.DisplayVisual methodsFor: 'displaying'!

displayOn: aGraphicsContext
	"Display the receiver's visual on the given graphics context."

	color == nil
		ifFalse: [aGraphicsContext paint: color].
	aGraphicsContext translateBy: offset.
	visual displayOn: aGraphicsContext.
	aGraphicsContext translateBy: offset negated.!

displayPostScriptOn: aPostscriptContext
	"Display the receiver on the argument as a PostScript item."

	aPostscriptContext translate: offset.
	aPostscriptContext imageWidth: visual width 
			height: visual height 
			bits: visual bits.
	aPostscriptContext translate: offset negated! !



Smalltalk.Siren defineClass: #DisplayString
	superclass: #{Siren.DisplayItem}
	indexedType: #none
	private: false
	instanceVariableNames: 'string font '
	classInstanceVariableNames: ''
	imports: ''
	category: 'MusicUI-DisplayLists'!

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!


!Siren.DisplayString class methodsFor: 'examples'!

stringExample
	"Open a display list view with randomly-placed random-color strings over the given extent."
	"DisplayString stringExample"

	(DisplayList stringsX: 600 byY: 600) display! !

!Siren.DisplayString class methodsFor: 'instance creation'!

new
	"Answer a new initialized instance."

	^super new initialize!

string: aString
	"Answer a new instance with the argument as its string."

	^self new string: aString!

string: aString offset: oPoint
	"Answer a new instance with the arguments as its string and offset point."

	^self new string: aString; offset: oPoint! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!


Siren.DisplayString comment:
'Instances of DisplayString are used for visual text items in display lists.

Instance Variables:
	string		<String or Text> the object''s string/text
	font		<ImplementationFont> the object''s display font'!

!Siren.DisplayString methodsFor: 'accessing'!

bounds
	"Answer a rectangle that circumscribes the receiver."

	^offset extent: self extent!

extent
	"Answer a rectangle that circumscribes the receiver."

	^font == nil
		ifFalse: [((TextMeasurer forFont: font)
				measureString: string
				fromCharacterIndex: 1
				to: string size) @ font height]
		ifTrue: [(string size * 12) @ 12]!

font
	"Answer the receiver's font."

	^font!

font: aFont
	"Set the receiver's font."

	font := aFont!

string
	"Answer the receiver's string."

	^string!

string: aString
	"Set the receiver's string."

	string := aString! !

!Siren.DisplayString methodsFor: 'printing'!

printOn: aStream
	"comment stating purpose of message"

	aStream nextPutAll: ' (a ', self class name, ' offset: '.
	offset printOn: aStream.
	aStream nextPutAll: ' string: '.
	string printOn: aStream.
"	color == nil
		ifFalse: [aStream nextPutAll: ' color: '. color printOn: aStream].
"	aStream nextPut: $); cr.! !

!Siren.DisplayString methodsFor: 'displaying'!

displayOn: aGraphicsContext
	"display the receiver on the argument."

"	Transcript show: (aGraphicsContext translation  + offset) printString; space."
	font == nil
		ifFalse: [aGraphicsContext font: font].
	color == nil
		ifFalse: [aGraphicsContext paint: color].
	aGraphicsContext displayString: string at: (offset + (0@14))!

displayPostScriptOn: aPostscriptContext
	"Display the receiver on the argument as a PostScript item."

	aPostscriptContext translate: offset.
	aPostscriptContext show: string.
	aPostscriptContext translate: offset negated.! !

!Siren.DisplayString methodsFor: 'initialize-release'!

initialize
	"Initialize the instance variables of the receiver."

	super initialize.
	font := Screen default defaultFontPolicy findFont: FontDescription default.! !
