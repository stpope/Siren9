

Smalltalk.Siren defineClass: #LayoutManager
	superclass: #{Core.Object}
	indexedType: #none
	private: false
	instanceVariableNames: 'view orientation itemAccessor '
	classInstanceVariableNames: ''
	imports: ''
	category: 'MusicUI-Layout'!

Siren.LayoutManager comment:
'Instances of the LayoutManager classes are used to generate display lists given random data structures and possibly hints in terms of structure accessors.
This is David''s miraculous idea and the heart of the Navigator architecture.

Instance Variables:
	view		<DisplayListView> the view--May provide the displayItems
	orientation	<Symbol or nil> my ''base'' symbol (e.g., #top)
	itemAccessor	<StructureAccessor> my referencing protocol translator

Look for class references to the LayoutManager classes (mostly from DisplayListView classes), for lots of examples of the use of LayoutManagers.

This implementation is Topaz 0, STEIM, Amsterdam, May/June 1990.

The entirety of this software is Copyright (c) 1990, Stephen Travis Pope, Nomad Object Design/Nomad Computer Music Research. 
All Rights Reserved.'!

!Siren.LayoutManager methodsFor: 'generating'!

addItem: anAss atNode: aPath in: aDisplayList
	"Add the given item to the display list."

	^self subclassResponsibility!

generateDisplayList
	"Generate and answer the receiver's display list."

	| list |
	list := DisplayList new.
	view model items do:
		[ :e |
		 self addItem: e atNode: (OrderedCollection new) in: list].
	list computePreferredBounds.
	^list! !

!Siren.LayoutManager methodsFor: 'accessing'!

displayList
	"Answer the receiver's display list (generated)."

	^self generateDisplayList!

displayListFor: aView
	"Answer the receiver's display list (generated)."

	view := aView.
	^self generateDisplayList!

orientation: aSymbol
	"Set the receiver's orientation."

	orientation := aSymbol!

view: aView
	"Set the receiver's view."

	view := aView! !



Smalltalk.Siren defineClass: #TimeSequenceLayoutManager
	superclass: #{Siren.LayoutManager}
	indexedType: #none
	private: false
	instanceVariableNames: 'timeScale timeOffset '
	classInstanceVariableNames: ''
	imports: ''
	category: 'MusicUI-Layout'!

Siren.TimeSequenceLayoutManager comment:
'Instances of the SequenceLayoutManager classes are used to generate display lists with "x = time" from event lists.

Instance Variables:
	timeScale		<Integer> the msec./pixel scale
	timeOffset		<Integer> the start of the layout in msec.
'!

!Siren.TimeSequenceLayoutManager methodsFor: 'generating'!

addItem: anAss atNode: aPath in: aDisplayList 
	"Add the given item to the display list."

	| path2 anE displayPoint item |
	anE := anAss value.
	anE hasItems
		ifTrue: [^anE do:  
			[ :i | 
			path2 := aPath copy.
			path2 addLast: anE.
			self addItem: anAss key + i key => i value
					atNode: path2
					in: aDisplayList]].
	displayPoint := self displayPointFor: anAss.
	item := view itemFor: anAss.
	item offset: displayPoint.
	aDisplayList add: item atPath: aPath!

displayPointFor: anAss 
	"Answer the display point for the argument."

	| dPoint |
	dPoint := (anAss key asMS value - timeOffset / timeScale) asInteger.
	(orientation == nil or: [orientation == #left])
		ifTrue: [dPoint := dPoint @ 0]
		ifFalse: [orientation == #top
			ifTrue: [dPoint := 0 @ dPoint]].
	^dPoint! !

!Siren.TimeSequenceLayoutManager methodsFor: 'accessing'!

timeOffset: aNumber
	"Set the receiver's time offset."

	timeOffset := aNumber!

timeScale: aNumber
	"Set the receiver's time scale."

	timeScale := aNumber! !



Smalltalk.Siren defineClass: #PitchTimeLayoutManager
	superclass: #{Siren.TimeSequenceLayoutManager}
	indexedType: #none
	private: false
	instanceVariableNames: 'pitchScale pitchOffset '
	classInstanceVariableNames: ''
	imports: ''
	category: 'MusicUI-Layout'!

Siren.PitchTimeLayoutManager comment:
'Instances of the PitchTimeLayoutManager classes are used to generate display lists with "x = time" and "y = pitch" from event lists.
The default layout is linear pitch-to-y, like piano-roll or Hauer-Steffens notation.

Instance Variables:
	pitchScale		<Integer> the key#/pixel scale
	pitchOffset		<Integer> the bottom of the layout as a key#
'!

!Siren.PitchTimeLayoutManager methodsFor: 'generating'!

displayPointFor: anAss
	"Answer the display point for the argument."

	| pch |
	pch := anAss event pitch.
	pch ifNil: [^((anAss key asMS value - timeOffset / timeScale) asInteger)
		@ (60*pitchScale)].
	^((anAss key asMS value - timeOffset / timeScale) asInteger)
		@ ((60*pitchScale) 
			- ((pch asMIDI value - pitchOffset) * pitchScale))! !

!Siren.PitchTimeLayoutManager methodsFor: 'accessing'!

pitchOffset: aNumber
	"Set the receiver's pitch offset."

	pitchOffset := aNumber!

pitchScale: aNumber
	"Set the receiver's pitch scale."

	pitchScale := aNumber! !



Smalltalk.Siren defineClass: #HierarchyLayoutManager
	superclass: #{Siren.LayoutManager}
	indexedType: #none
	private: false
	instanceVariableNames: 'length xStep yStep treeAccessor '
	classInstanceVariableNames: ''
	imports: ''
	category: 'MusicUI-Layout'!

Siren.HierarchyLayoutManager comment:
'Instances of the HierarchyLayoutManager classes are used to generate display lists from tree-like data and tree accessors.

Instance Variables:
	length		<Integer or Point> temp. depth used in layout
	xStep		<Integer> step size for x
	yStep		<Integer> step size for x
	treeAccessor	<TreeAccessor> the TreeAccessor used to access the model
'!

!Siren.HierarchyLayoutManager methodsFor: 'generating'!

addItem1: aModelNode atNode: aPath in: aDisplayList
	"Add the given item to the display list."

	| wrapper displayPoint item path2 displayList2 |
	displayPoint := self displayPositionFor: aPath.
	length := length + 1.
	item := treeAccessor itemFor: aModelNode.
	wrapper := TranslatingWrapper on: item at: displayPoint.
	(treeAccessor isTerminal: aModelNode)
		ifFalse: [displayList2 := DisplayList new.
			displayList2 model: aModelNode.
			(treeAccessor childrenOf: aModelNode) do: [ :i | 
				path2 := aPath copy.
				path2 addLast: aModelNode.
				self addItem: i
					atNode: path2
					in: displayList2].
			displayList2 add: wrapper.
			aDisplayList add: displayList2 atPath: aPath]
		ifTrue: [aDisplayList add: item atPath: aPath]!

addItem: aModelNode atNode: aPath in: aDisplayList
	"Add the given item to the display list."

	| displayPoint item path2 displayList2 |
	displayPoint := self displayPositionFor: aPath.
	length := length + 1.
	item := treeAccessor itemFor: aModelNode.
	item offset: displayPoint.
	(treeAccessor isTerminal: aModelNode)
		ifFalse: [displayList2 := DisplayList new.
			displayList2 model: aModelNode.
			(treeAccessor childrenOf: aModelNode) do: 
				[ :i | 
				path2 := aPath copy.
				path2 addLast: aModelNode.
				self addItem: i
					atNode: path2
					in: displayList2].
			displayList2 add: item"; offset: displayPoint".
			aDisplayList add: displayList2 atPath: aPath]
		ifTrue: [aDisplayList add: item atPath: aPath]!

displayPositionFor: aPath
	"Answer the display position of the element at the given path."

	^self subclassResponsibility!

generateDisplayList
	"Generate and answer the receiver's display list."

	| list |
	list := DisplayList new.
	self addItem: treeAccessor subject
			atNode: (OrderedCollection new)
			in: list.
	list computePreferredBounds.
	^list! !

!Siren.HierarchyLayoutManager methodsFor: 'accessing'!

accessor: aTA
	"Set the receiver's tree accessor to the argument."

	treeAccessor := aTA!

xStep: aNumber
	"Set the receiver's x step size to the argument."

	xStep := aNumber!

yStep: aNumber
	"Set the receiver's y step size to the argument."

	yStep := aNumber! !



Smalltalk.Siren defineClass: #IndentedListLayoutManager
	superclass: #{Siren.HierarchyLayoutManager}
	indexedType: #none
	private: false
	instanceVariableNames: ''
	classInstanceVariableNames: ''
	imports: ''
	category: 'MusicUI-Layout'!

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!


!Siren.IndentedListLayoutManager class methodsFor: 'examples'!

colorListExample
	"IndentedListLayoutManager colorListExample"

	| acc me |
	acc := STreeAccessor subject: MusicMagnitude
			terminalQuery: [ :c | c subclasses size = 0]
			childAccessor: #sortedSubclasses
			itemGenerator: [ :c | (DisplayString new)
									model: c;
									string: c name;
									color: [c color]].
	me := (self new) accessor: acc; xStep: 16; yStep: 16.
	^me displayList display!

listExample
	"IndentedListLayoutManager listExample display"
	"DisplayListView classListExample"

	| acc me |
	acc := STreeAccessor subject: Magnitude
			terminalQuery: [ :c | c subclasses size = 0]
			childAccessor: #sortedSubclasses
			itemGenerator: [ :c | (DisplayString new)
									model: c;
									string: c name;
									color: ColorValue darkGray].
	me := (self new) accessor: acc; xStep: 16; yStep: 16.
	^me displayList! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!


Siren.IndentedListLayoutManager comment:
'Instances of IndentedListLayoutManager are used to generate display lists which mirror the hierarchy of their models (accessed using a TreeAccessor) in the indentation of a list-like outline.'!

!Siren.IndentedListLayoutManager methodsFor: 'generating'!

displayPositionFor1: aPath
	"Answer the display position of the element at the given path."

	| pt |
	length == nil ifTrue: [length := 0].
	pt := (orientation == #left or: [orientation == nil])
		ifFalse: [(length * xStep) @ (aPath size * yStep)]
		ifTrue: [(aPath size * xStep) @ (length * yStep)].
	Transcript show: aPath printString, ' ', pt printString; cr.
	^pt!

displayPositionFor: aPath
	"Answer the display position of the element at the given path."

	length == nil ifTrue: [length := 0].
	^(orientation == #left or: [orientation == nil])
		ifFalse: [(length * xStep) @ (aPath size * yStep)]
		ifTrue: [(aPath size * xStep) @ (length * yStep)]! !



Smalltalk.Siren defineClass: #IndentedTreeLayoutManager
	superclass: #{Siren.IndentedListLayoutManager}
	indexedType: #none
	private: false
	instanceVariableNames: 'list '
	classInstanceVariableNames: ''
	imports: ''
	category: 'MusicUI-Layout'!

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!


!Siren.IndentedTreeLayoutManager class methodsFor: 'examples'!

listExample
	"IndentedTreeLayoutManager listExample display"
	"DisplayListView classTreeExample"

	| acc me |
	acc := STreeAccessor subject: "View" Magnitude
			terminalQuery: [ :c | c subclasses size = 0]
			childAccessor: #sortedSubclasses
			itemGenerator: [ :c | (DisplayString new)
							model: c; 
							string: c name; 
							color: ColorValue black].
	me := (self new) accessor: acc; xStep: 4; yStep: 12.
	^me displayList! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!


Siren.IndentedTreeLayoutManager comment:
'Instances of IndentedTreeLayoutManager are used to generate display lists which mirror the hierarchy of their models (accessed using a TreeAccessor) in the indentation of a list-like tree.'!

!Siren.IndentedTreeLayoutManager methodsFor: 'generating'!

addItem: aModelNode atNode: aPath under: parentPoint in: aDisplayList
	"Add the given item to the display list."

	|  displayPoint item path2 displayList2 |
	displayPoint := (self displayPositionFor: aPath) + (parentPoint x@0).
	length := length + 1.
	item := treeAccessor itemFor: aModelNode.
	item offset: displayPoint.
	(treeAccessor isTerminal: aModelNode)
		ifFalse: [displayList2 := DisplayList new.
			displayList2 model: aModelNode.
			(treeAccessor childrenOf: aModelNode) do: [ :i | 
				path2 := aPath copy.
				path2 addLast: aModelNode.
				self addItem: i
					atNode: path2
					under: item bounds rightCenter
					in: displayList2].
			displayList2 add: item.
			aDisplayList add: displayList2 atPath: aPath.
			parentPoint = (0@0)
				ifFalse: [aDisplayList add:
						((DisplayLine new)
							offset: item bounds leftCenter + (-2@4);
							corner: parentPoint + (2@4); color: ColorValue black)
					atPath: aPath]]
				ifTrue: [aDisplayList add: item atPath: aPath.
					aDisplayList add:
							((DisplayLine new)
								offset: item bounds leftCenter + (-2@4);
								corner: parentPoint + (2@4); color: ColorValue black)
						atPath: aPath]!

generateDisplayList
	"Generate and answer the receiver's display list."

	list := DisplayList new.
	self addItem: treeAccessor subject
			atNode: (OrderedCollection new)
			under: 0@0
			in: list.
	^list! !



Smalltalk.Siren defineClass: #PositionTimeLayoutManager
	superclass: #{Siren.PitchTimeLayoutManager}
	indexedType: #none
	private: false
	instanceVariableNames: ''
	classInstanceVariableNames: ''
	imports: ''
	category: 'MusicUI-Layout'!

Siren.PositionTimeLayoutManager comment:
'Instances of PositionTimeLayoutManager are used to generate display lists with "x = time" and "y = position" from event lists.
'!

!Siren.PositionTimeLayoutManager methodsFor: 'generating'!

displayPointFor: anAss
	"Answer the display point for the argument."

	^((anAss key asMS value - timeOffset / timeScale) asInteger)
		@ ((anAss event position - pitchOffset) * pitchScale)! !



Smalltalk.Siren defineClass: #StructureAccessor
	superclass: #{Core.Object}
	indexedType: #none
	private: false
	instanceVariableNames: 'subject itemGenerator '
	classInstanceVariableNames: ''
	imports: ''
	category: 'MusicUI-Layout'!

Siren.StructureAccessor comment:
'Instances of StructureAccessor and its subclasses are ''protocol convertors'' which provide predictable interfaces (e.g., tree-speak), for diverse data structures.
The basic display item generating protocol is: 
	(aStructureAccessor itemFor: aModelNode).

InstanceVariableNames:
	subject			<Object> the model or victim
	itemGenerator   	<Symbol or Block> the DisplayItem generator
						Model items are passed to it (if it''s a Block),
						or have to perform: it (if it''s a Symbol).

'!

!Siren.StructureAccessor methodsFor: 'item accessing'!

itemFor: aModel
	"Answer a display item for the argument"

	(itemGenerator isMemberOf: Symbol)
		ifTrue: [^aModel perform: itemGenerator].
	(itemGenerator isMemberOf: BlockClosure)
		ifTrue: [^itemGenerator value: aModel].
	self error: 'Unknown item generator type.'! !

!Siren.StructureAccessor methodsFor: 'accessing'!

itemGenerator
	"Answer the iG of the receiver."

	^itemGenerator!

itemGenerator: anObject
	"Set the iG of the receiver."

	itemGenerator := anObject!

subject
	"Answer the subject of the receiver."

	^subject!

subject: anObject
	"Set the subject of the receiver."

	subject := anObject! !



Smalltalk.Siren defineClass: #STreeAccessor
	superclass: #{Siren.StructureAccessor}
	indexedType: #none
	private: false
	instanceVariableNames: 'terminalQuery childAccessor '
	classInstanceVariableNames: ''
	imports: ''
	category: 'MusicUI-Layout'!

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!


!Siren.STreeAccessor class methodsFor: 'instance creation'!

subject: aS terminalQuery: aTQ childAccessor: aCA itemGenerator: anIG
	"Answer an initialized instance."

	^(self new) subject: aS;
			terminalQuery: aTQ;
			childAccessor: aCA;
			itemGenerator: anIG! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!


Siren.STreeAccessor comment:
'Instances of STreeAccessor tree-navigation interfaces to diverse data structures.
The basic display tree walking protocol is: 
	(aSTreeAccessor childrenOf: aModelNode); and
	(aSTreeAccessor isTerminal: aModelNode).

InstanceVariableNames:
	terminalQuery	<Symbol or Block> the isLeaf or hasChildrenNot query
	childAccessor		<Symbol or Block> accessor to get a node''s children
						Model items are passed to these (if they''re Blocks),
						or have to perform: them (if they''re Symbols).

'!

!Siren.STreeAccessor methodsFor: 'accessing'!

childAccessor: anObject
	"Set the cA of the receiver."

	childAccessor := anObject!

terminalQuery: anObject
	"Set the tQ of the receiver."

	terminalQuery := anObject!

treeAccessor
	"Answer the receiver."

	^self! !

!Siren.STreeAccessor methodsFor: 'tree accessing'!

childrenOf: aNode
	"Answer the children of the argument by using the child accessor."

	(childAccessor isSymbol)
		ifTrue: [^aNode perform: childAccessor].
	(childAccessor isMemberOf: BlockClosure)
		ifTrue: [^childAccessor value: aNode].
	self error: 'Unknown child accessor type.'!

isTerminal: aNode
	"Answer whether the argument is terminal by using the terminal query."

	(terminalQuery isSymbol)
		ifTrue: [^aNode perform: terminalQuery].
	(terminalQuery isMemberOf: BlockClosure)
		ifTrue: [^terminalQuery value: aNode].
	self error: 'Unknown terminal query type.'!

leavesOf: aRoot
	"Answer the leaves of the argument by using the child accessor."

	| kids leaves |
	leaves := OrderedCollection new.
	(childAccessor isSymbol)
		ifTrue: [kids := aRoot perform: childAccessor]
		ifFalse: [(childAccessor isMemberOf: BlockClosure)
			ifTrue: [kids := childAccessor value: aRoot]
			ifFalse: [self error: 'Unknown child accessor type.']].
	kids isEmpty
		ifFalse: [kids do:
			[ :aChild |
			(self isTerminal: aChild)
				ifTrue: [leaves add: aChild]
				ifFalse: [leaves addAll: (self leavesOf: aChild)]]].
	^leaves! !
