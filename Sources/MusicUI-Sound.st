

Smalltalk.Siren defineClass: #SoundEditor
	superclass: #{Siren.EditorModel}
	indexedType: #none
	private: false
	instanceVariableNames: 'sound undoSound markers lastSelection changed '
	classInstanceVariableNames: ''
	imports: ''
	category: 'MusicUI-Sound'!

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!


!Siren.SoundEditor class methodsFor: 'instance creation'!

new
	"Answer an initialized instance."

	^super new initialize! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!


Siren.SoundEditor comment:
'A SoundEditor is the editor model for sound views.

Instance Variables:
	copyBuffer <Sound> the selected sound after a copy command
	sound <Sound> the model sound
	markers <OrderedCollection of: Integer> the sample indices of the selected points
	selection1 <Integer> the sample index start of the current selection
	selection2 <Integer> the stop of the selection
	lastSelection <Integer> selection1 or 2, whichever was selected last
	view <Siren.SoundView> my view
	changed <Boolean> whether the sound has been changed
'!

!Siren.SoundEditor methodsFor: 'interaction'!

copy
	"Copy the current selection into the temporary copy buffer."

	| selSnd |
	selSnd := self selectedSound.
	selSnd == nil
		ifFalse: [copyBuffer := selSnd]!

cut
	"Cut out the current selection."

	undoSound := sound.
	sound := sound cutFrom: self selectionStart to: self selectionStop.
	self changed.!

file
	"Save the receiver's sound to a file."

	| name |
	name := Dialog
		request: 'Save copy buffer to:' 
		initialAnswer: sound name.
	name = '' ifTrue: [^nil].
	copyBuffer == nil
		ifTrue: [(SoundFile named: name) saveSound: self selectedSound]
		ifFalse: [(SoundFile named: name) saveSound: copyBuffer].!

newCopy
	"Make a fresh copy of the receiver's model's sound."

	self setModel: sound copy!

play
	"Play the receiver's sound"

	((self selection1 ~~ nil) and: [self selection2 ~~ nil])
		ifTrue: [SoundPort default playSamples: sound samples
				rate: sound rate chans: sound channels 
				from: (sound mapSampleIndex: self selection1) * sound sampleSize - 1
				to: (sound mapSampleIndex: self selection2) * sound sampleSize - 1]
		ifFalse: [changed 
			ifTrue: [SoundPort default playSamples: sound samples
					rate: sound rate chans: sound channels 
					from: 1
					to: sound samples sizeInBytes]
			ifFalse: [sound play]]!

playAll
	"Play the receiver's sound"

	sound play!

playSelection
	"Play the receiver's sound"

	((self selection1 ~~ nil) and: [self selection2 ~~ nil])
		ifTrue: [SoundPort default play: sound from: self selection1 to: self selection2]
		ifFalse: [self playAll]!

spawn
	"Open a soundfile editor."

	SoundView openOn: sound! !

!Siren.SoundEditor methodsFor: 'accessing'!

clearMarkers
	"Flush the selection and markers"

	markers := OrderedCollection new.
	selections := Array new: 2.
	self changed!

list
	^nil!

mark: aSampleNumber
	"Set the receiver's model"

	markers == nil ifTrue: [markers := Dictionary new].
	markers at: aSampleNumber printString asSymbol put: aSampleNumber!

markChanged: aBoolean
	"Set the flag to tell the receiver that the model's been changed."

	changed := aBoolean!

markers
	"Answer the receiver's markers"

	^markers!

markers: aCollection
	"Set the receiver's marker collection."

	markers := aCollection!

selection1
	"Answer the receiver's primary selection."

	selections isEmpty ifTrue: [^nil].
	^selections at: 1!

selection1: anInteger
	"Set the receiver's primary selection."

	selections at: 1 put: anInteger!

selection2
	"Answer the receiver's 2nd-ary selection."

	selections isEmpty ifTrue: [^nil].
	^selections at: 2!

selection2: anInteger
	"Set the receiver's secondary selection."

	selections at: 2 put: anInteger!

selectionStart
	^self selection1 min: self selection2!

selectionStop
	^self selection1 max: self selection2!

setModel: aModel
	"Set the receiver's model."

	self reinitialize.
	super setModel: aModel.
	self changed: #text!

size
	^sound size!

sound
	"Answer the receiver's model"

	^sound!

sound: aSound
	"Set the receiver's model to be the given sound"

	sound == nil ifFalse: [sound release].
"	self reinitialize."
	sound := aSound!

view: aView
	"Set the receiver's view to be the given view"

	view := aView! !

!Siren.SoundEditor methodsFor: 'initialize release'!

initialize
	"Set up the proper default values for the receiver."

	markers := OrderedCollection new.
	selections := Array new: 2.
	changed := false!

reinitialize
	"Set up the proper default values for the receiver."

	markers := OrderedCollection new.
	selections := Array new: 2.
	lastSelection := undoSound := copyBuffer := nil.
	changed := false.
	self changed! !

!Siren.SoundEditor methodsFor: 'selection'!

select: cursorX
	"Take a mouse point and place a marker on the sound sample there."

	|selection |
	selection := (view sampleForX: cursorX).
	view showMarkerAt: cursorX.
"	Transcript show: cursorX printString, ' --> ', selection printString; cr."
	markers add: selection.
	self selection1 == nil
		ifTrue: [selections at: 1 put: selection]
		ifFalse: [selections at: 2 put: selection]!

selectedSound
	"Answer a sound from the receiver view's selection."

	| s |
	((self selection1 == nil) or: [self selection2 == nil])
		ifTrue: [^nil].
	Cursor wait showWhile:
		[s := sound fromSample: self selection1 toSample: self selection2].
	^s!

setSelection: aMarker
	"Set the primary selection to be the given marker."

	lastSelection = self selection2
		ifFalse: [selections at: 2 put: aMarker.
				lastSelection := aMarker]
		ifTrue: [selections at: 1 put: aMarker.
				lastSelection := aMarker].
	((self selection1 == nil) or: [self selection2 == nil])
		ifTrue: [^self].
	self selection1 > self selection2
		ifTrue: [ | temp |
			temp := self selection1.
			selections at: 1 put: self selection2.
			selections at: 2 put: temp].
	view invalidate! !



Smalltalk.Siren defineClass: #SoundFileViewer
	superclass: #{Tools.FileTools.FileInformationViewer}
	indexedType: #none
	private: false
	instanceVariableNames: ''
	classInstanceVariableNames: ''
	imports: ''
	category: 'MusicUI-Sound'!

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!


!Siren.SoundFileViewer class methodsFor: 'accessing'!

isInterestedInFile: aFilename

	('*.aiff' match: aFilename tail) ifTrue: [^true].
	('*.aif' match: aFilename tail) ifTrue: [^true].
	('*.snd' match: aFilename tail) ifTrue: [^true].
	('*.au' match: aFilename tail) ifTrue: [^true].
	('*.wav' match: aFilename tail) ifTrue: [^true].
	^false!

tabLabel

	^(#FileInformation << #labels >> 'Sound File') asString! !

!Siren.SoundFileViewer class methodsFor: 'interface specs'!

windowSpec
	"Tools.UIPainter new openOnClass: self andSelector: #windowSpec"

	<resource: #canvas>
	^#(#{UI.FullSpec} 
		#window: 
		#(#{UI.WindowSpec} 
			#label: 
			#(#{Kernel.UserMessage} 
				#key: #UnlabeledCanvas 
				#defaultString: 'Unlabeled Canvas' 
				#catalogID: #labels ) 
			#bounds: #(#{Graphics.Rectangle} 640 427 1120 731 ) ) 
		#component: 
		#(#{UI.SpecCollection} 
			#collection: #(
				#(#{UI.TextEditorSpec} 
					#layout: #(#{Graphics.LayoutFrame} 0 0 0 0 0 1 -28 1 ) 
					#name: #text 
					#model: #textHolder 
					#isReadOnly: true 
					#tabRequiresControl: true ) 
				#(#{UI.ActionButtonSpec} 
					#layout: #(#{Graphics.LayoutFrame} 2 0 -24 1 -2 0.2 -2 1 ) 
					#name: #ActionButton1 
					#model: #playFile 
					#label: 'Play' 
					#style: #systemDefault 
					#defaultable: true ) 
				#(#{UI.ActionButtonSpec} 
					#layout: #(#{Graphics.LayoutFrame} 2 0.2 -24 1 -2 0.4 -2 1 ) 
					#name: #ActionButton2 
					#model: #editFile 
					#label: 'Edit' 
					#style: #systemDefault 
					#defaultable: true ) 
				#(#{UI.ActionButtonSpec} 
					#layout: #(#{Graphics.LayoutFrame} 2 0.8 -24 1 -2 1 -2 1 ) 
					#name: #ActionButton3 
					#model: #deleteFile 
					#label: 'Delete' 
					#style: #systemDefault 
					#defaultable: true ) 
				#(#{UI.ActionButtonSpec} 
					#layout: #(#{Graphics.LayoutFrame} 2 0.6 -24 1 -2 0.8 -2 1 ) 
					#name: #ActionButton4 
					#model: #makeS7 
					#label: 'make S7' 
					#style: #systemDefault 
					#defaultable: true ) 
				#(#{UI.ActionButtonSpec} 
					#layout: #(#{Graphics.LayoutFrame} 2 0.4 -24 1 -2 0.6 -2 1 ) 
					#name: #ActionButton5 
					#model: #loadFile 
					#label: 'Load' 
					#style: #systemDefault 
					#defaultable: true ) ) ) )! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!


Siren.SoundFileViewer comment:
'this is a plug-in for the FileBrowser for handling sound files'!

!Siren.SoundFileViewer methodsFor: 'actions'!

deleteFile
	"Delete the selected sound file"

	(Dialog confirm: 'Delete file ', self selectedFilename asString, '?') ifFalse: [^self].
	self selectedFilename delete.
	self updateForNoSelection.!

editFile
	"Edit the selected sound file"

	(SampledSound fromFile: self selectedFilename asString) edit!

loadFile
	"Load the selected file into the SirenSession"

	| nam |
	nam := self selectedFilename asString.
	SirenSession sound: nam put: (SampledSound fromFile: nam)!

makeS7
	"Take the selected file anem make an s7 directory for it"

	| selected name base tail dirName directory |
	directory := browser selectedDirectory.
	selected := browser selectedFile.
	selected isNil ifTrue: [^nil].
	name := selected asString.
	base := name asFilename base.
	tail := name asFilename tail.
	dirName := base, 's7'.
	dirName asFilename exists
		ifTrue: [(Dialog confirm: 'File already exists. Should I overwrite it?')
			ifFalse: [^self]]
		ifFalse: [dirName asFilename makeDirectory].
	name asFilename moveTo: (dirName, Filename separatorString, tail).
	Transcript show: 'Created s7 file ', dirName; cr.
	directory refresh.
	browser directoryTreeHolder list refresh: directory.
	browser selectDirectory: dirName asFilename!

playFile
	"Play the selected sound file"

	Sound playFile: self selectedFilename asString! !

!Siren.SoundFileViewer methodsFor: 'accessing'!

printBlurbFor: aFilename on: stream

	| snd |
	snd := SoundFile openFileNamed: aFilename asString.
	self
		print: (#Path << #labels >> 'Path') value: [aFilename asString] on: stream;
		print: (#Size << #labels >> 'Size') value: [aFilename fileSize printString] on: stream;
		print: (#LastModified << #labels >> 'Last modified') 
				value: [self timestampStringAt: #modified in: aFilename dates] on: stream;

		print: (#Created << #labels >> 'Rate') value: [snd rate printString] on: stream;
		print: (#Created << #labels >> 'Duration') 
				value: [(snd size / (snd rate * snd channels)) asFloat printString] on: stream;
		print: (#Created << #labels >> 'Frames') value: [snd size printString] on: stream;
		print: (#Created << #labels >> 'Channels') value: [snd channels printString] on: stream;
		print: (#Created << #labels >> 'Format') value: [snd sampleFormat printString] on: stream! !



Smalltalk.Siren defineClass: #SoundCanvas
	superclass: #{UI.ApplicationModel}
	indexedType: #none
	private: false
	instanceVariableNames: 'vZoom hZoom soundView scroller componentPart '
	classInstanceVariableNames: ''
	imports: ''
	category: 'MusicUI-Sound'!

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!


!Siren.SoundCanvas class methodsFor: 'interface specs'!

windowSpec
	"Tools.UIPainter new openOnClass: self andSelector: #windowSpec"

	<resource: #canvas>
	^#(#{UI.FullSpec} 
		#window: 
		#(#{UI.WindowSpec} 
			#label: 'SoundView' 
			#bounds: #(#{Graphics.Rectangle} 548 59 1107 313 ) ) 
		#component: 
		#(#{UI.SpecCollection} 
			#collection: #(
				#(#{UI.ArbitraryComponentSpec} 
					#layout: #(#{Graphics.LayoutFrame} 16 0 0 0 0 1 -16 1 ) 
					#name: #soundView 
					#flags: 0 
					#component: #createSoundView ) 
				#(#{UI.SliderSpec} 
					#layout: #(#{Graphics.LayoutFrame} 16 0 -16 1 0 1 0 1 ) 
					#name: #hZoom 
					#colors: 
					#(#{UI.LookPreferences} 
						#setBackgroundColor: #(#{Graphics.ColorValue} 5734 5734 5734 ) ) 
					#model: #hZoom 
					#orientation: #horizontal 
					#start: 1 
					#stop: 100 
					#step: 20 ) 
				#(#{UI.SliderSpec} 
					#layout: #(#{Graphics.LayoutFrame} 0 0 0 0 16 0 -16 1 ) 
					#name: #vZoom 
					#colors: 
					#(#{UI.LookPreferences} 
						#setBackgroundColor: #(#{Graphics.ColorValue} 5734 5734 5734 ) ) 
					#model: #vZoom 
					#orientation: #vertical 
					#start: 0.5 
					#stop: 5.0 
					#step: 1 ) 
				#(#{UI.ActionButtonSpec} 
					#layout: #(#{Graphics.LayoutFrame} 0 0 -16 1 16 0 0 1 ) 
					#name: #ActionButton1 
					#colors: 
					#(#{UI.LookPreferences} 
						#setForegroundColor: #(#{Graphics.ColorValue} #black ) 
						#setBackgroundColor: #(#{Graphics.ColorValue} 8191 3072 3072 ) ) 
					#model: #zoomToZero 
					#label: 'z' 
					#defaultable: true ) ) ) )! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!


Siren.SoundCanvas comment:
'A SoundCanvas is used for plugging SoundViews into applications

Instance Variables:
	vZoom	<Integer>  the vertical zoom
	hZoom	<Integer>  horizontal
	soundView	<SoundView>  the sound view
	scroller	<Scroller>  the scroller
	componentPart	<ComponentPart>  my component
'!

!Siren.SoundCanvas methodsFor: 'aspects'!

container: ignored!

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

preferredBounds

	^soundView preferredBounds!

setComponent: aComponent
	"Set the receiver's component part"

	componentPart := aComponent!

vZoom
	"This method was generated by UIDefiner.  Any edits made here
	may be lost whenever methods are automatically defined.  The
	initialization provided below may have been preempted by an
	initialize method."

	^vZoom isNil
		ifTrue:
			[vZoom := 0.5 asValue]
		ifFalse:
			[vZoom]! !

!Siren.SoundCanvas methodsFor: 'initialize'!

createSoundView
	"Create and answer the receiver's sound view"
	"SoundCanvas open"

	soundView := SoundView soundViewOn: SampledSound new.
"	componentPart == nil
		ifTrue: [componentPart := DisplayListView componentOnList: displayList].

"! !

!Siren.SoundCanvas methodsFor: 'actions'!

flushCoordinateCaches

	"ignored"!

zoomToZero

	"This stub method was generated by UIDefiner"

	^self! !



Smalltalk.Siren defineClass: #SoundController
	superclass: #{UI.ControllerWithMenu}
	indexedType: #none
	private: false
	instanceVariableNames: 'selection tracking '
	classInstanceVariableNames: ''
	imports: ''
	category: 'MusicUI-Sound'!

Siren.SoundController comment:
'Instances of SoundController are used with SoundViews and perform horizontal scrolling and menu operations'!

!Siren.SoundController methodsFor: 'menu messages'!

clearMarkers: ignored
	"Flush the selection and markers"

	model clearMarkers!

copy
	"copy the selected sound"

	model copy!

cut
	"cut the selected segment out of the receiver's model sound"

	model cut!

doInspect
	"Inspect the view."

	model inspect!

fadeIn
	"Apply a ramp fade-in envelope to the receiver's sound."

	| time |
	time := Number readFrom: 
		(ReadStream on: 
			(Dialog request: 'Fade-in time' 
					initialAnswer: '0.1')).
	(time between: 0.001 and: 2.0) ifFalse: [^nil].
	Cursor execute showWhile:
		[model sound fadeInOver: time.
		view redraw.
		model markChanged: true]!

fadeOut
	"Apply a ramp fade-out envelope to the receiver's sound."

	| time |
	time := Number readFrom: 
		(ReadStream on: 
			(Dialog request: 'Fade-out time' 
					initialAnswer: '0.1')).
	(time between: 0.001 and: 2.0) ifFalse: [^nil].
	Cursor execute showWhile:
		[model sound fadeOutOver: time.
		view redraw.
		model markChanged: true]!

file: ignored
	"Open the file dialog"

	model file!

inspect: ignored
	"Inspect the view."

	model inspect!

menu

	^Menu
		labelList: #(('play all' 'play selection') (copy cut paste) (accept cancel) (spawn inspect) 
				('vertical scale' 'horizontal scale') ('fade in' 'fade out')(reset))
		values: #(playAll playSelection copy cut paste 
				accept cancel spawn doInspect
				setVscale setHscale 
				fadeIn fadeOut reset)!

newCopy: ignored
	"Make a fresh copy of the receiver's model's sound."

	model newCopy!

paste
	"paste the selected sound into the model at the current selected marker"

	model paste!

play: ignored
	"play the model"

	model play!

playAll
	"play the model"

	model play!

playSelection
	"play the model"

	model playSelection!

reset
	"Clear the model's selections and markers"

	model reinitialize!

save
	"Save a copy of the model to the disk."

	model save!

setHscale
	"set the horizontal scale of the view"

	| newStep |
	newStep := Number readFrom: 
		(ReadStream on: 
			(Dialog request: 'New horizontal scale?' 
					initialAnswer: view step printString)).
	(newStep between: 1 and: 10000) ifFalse: [^nil].
	view step: newStep.
	view redraw!

setVscale
	"set the vertical scale of the view"

	| newScale |
	newScale := Number readFrom: 
		(ReadStream on: 
			(Dialog request: 'New vertical scale?'
					initialAnswer: view scale printString)).
	(newScale between: 1 and: 1000) ifFalse: [^nil].
	view scale: newScale.
	view redraw!

spawn
	"Edit a copy of the model."

	model spawn! !

!Siren.SoundController methodsFor: 'control defaults'!

redButtonActivity
	"set a marker with the red button"

	| pt |
	pt := self sensor cursorPoint.
	self sensor waitNoButton.
	pt y < 16
		ifTrue: [^self selectMarkerAt: pt x].
	model select: pt x!

selectMarkerAt: x
	"Select the marker at the given x value."

	| markers sel |
	markers := model markers.
	sel := markers
		detect: [ :m | ((view xForSample: m) - x) abs <= 8]
		ifNone: [^nil].
	model setSelection: sel! !

!Siren.SoundController methodsFor: 'event driven'!

exitEvent: anEvent 
	"redraw the view to clear the position display."

	super exitEvent: anEvent.
	view invalidate!

mouseMovedEvent: aMouseMovedEvent

	view displayPosition: (self sensor cursorPointFor: aMouseMovedEvent)!

redButtonPressedEvent: event
	"set a marker with the red button"

	| pt |
	pt := event point.
	self sensor waitNoButton.
	pt y < 16
		ifTrue: [^self selectMarkerAt: pt x].
	model select: pt x! !



Smalltalk.Siren defineClass: #SoundView
	superclass: #{Siren.DisplayListView}
	indexedType: #none
	private: false
	instanceVariableNames: ''
	classInstanceVariableNames: ''
	imports: ''
	category: 'MusicUI-Sound'!

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!


!Siren.SoundView class methodsFor: 'examples'!

example1
	"Open a sound view on the example sound file."
	"SoundView example1"

	SoundView openOn: (SampledSound sweepExample)!

example2
	"Open a sound view on the a sound from a file."
	"SoundView example2"

	SoundView openOn: (SampledSound fromFile: 'kombination.snd')!

exampleLong
	"Open a sound view on the a sound from a file."
	"SoundView exampleLong"

	SoundView openOn: (SampledSound fromFile: 'FourMagicSentences.aiff')!

exampleRamp
	"Open a sound view on the a sound with a slow ramp."
	"SoundView exampleRamp"

	SoundView openOn: (SampledSound sawtoothDur: 2.0 rate: 22050 freq: 1 chans: 1)! !

!Siren.SoundView class methodsFor: 'instance creation'!

componentOnSound: aSound
	"Answer a DLView for use as a component."
	"SoundView openOn: (SampledSound fromFile: 'a.snd')"

	| container me wrapper dled |
	container := CompositePart new.
	dled := SoundEditor new sound: aSound.
	me := self on: dled.
	wrapper := LookPreferences edgeDecorator on: me.
	wrapper useHorizontalScrollBar; noMenuBar.
	container add: wrapper in: (0@0 extent: 1.0@1.0).
	^container!

componentOnSoundNoFrills: aSound
	"Answer a DLView for use as a component."
	"SoundCanvas openOn: (SampledSound fromFile: 'a.snd')"

	| container me dled |
	container := CompositePart new.
	dled := SoundEditor new sound: aSound.
	me := self on: dled.
	container add: me in: (0@0 extent: 1.0@1.0).
	^container!

openOn: aSound
	"Take the sound as model and open a SoundView"
	"SoundView openOn: (SampledSound fromFile: 'kombination.snd')"

	| topView topWindow |
	topView := (self soundViewOn: aSound) components first.
	topWindow := (ScheduledWindow model: aSound
			label: ('Sound View on: ', aSound name)
			minimumSize: 500@300)
			maximumSize: 1200@500.
	topWindow component: topView.
	topWindow icon: (Icon constantNamed: #systemBrowser).
	topWindow openWithExtent: topWindow minimumSize!

soundViewOn: aSound
	"Take the sound as model and open a SoundView"
	"SoundView openOn: (SampledSound fromFile: 'kombination.snd')"
	"SoundView openOn: (SampledSound sweepExample)"

	| topView me editor edgeDecorator |
	topView := CompositePart new.
	me := self new initialize.
	editor := SoundEditor new sound: aSound.
	me model: editor.
	editor view: me.
"SoundView"
	edgeDecorator := LookPreferences edgeDecorator on: me.
	edgeDecorator noVerticalScrollBar; useHorizontalScrollBar; noMenuBar.
	topView add: edgeDecorator
			in: (LayoutFrame new leftFraction: 0; topFraction: 0; rightFraction: 1; bottomFraction: 1).
	^topView! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!


Siren.SoundView comment:
'Instances of SoundView are used for displaying samples sound objects in R4.
They can do horizontal scrolling and scaling.

Instance variables:
	step <Number> the step size for displaying--show every n''th sample
	scale <Number> the vertical scale for multiplying the sample''s value
'!

!Siren.SoundView methodsFor: 'accessing'!

bounds: aRectangle
	"Set the receiver's bounds."

	super bounds: aRectangle.
	extent := aRectangle extent.
"	Transcript show: 'SndView size: ', extent printString; cr."
"	self setPixmap."
"	self invalidate"!

markerColor
	"Answer the color for selection markers."

	^ColorValue blue!

preferredBounds
	"Answer the extent of the receiver's display object bounding box."

"	Transcript show: (self model size / self step) printString; cr."
	^self step = 0
		ifTrue: [0@0 extent: (self model size @ 300)]
		ifFalse: [0@0 extent: ((self model size / self step) @ 300)]!

scale
	"Return the vertical scale."

	^ zoom y!

scale: theScale
	"Accept the argument, 'theScale', as the new instance variable 'scale'."

	zoom y: theScale.!

sound
	"Answer the model's sound."

	^model sound!

sound: aSound
	"Set the model's sound."

	model sound: aSound.
	model view: self.
"	step > 0
		ifTrue: [width := (((aSound size / step) truncated) min: 16384) max: 512.
		Transcript show: 'width: ', width printString; cr.
		pixmap := Pixmap extent: (width @ 180)].
	self redraw.
	self changed: #text.
	self changedPreferredBounds: nil."
	self changed!

step
	"Return the horizontal sample-per-pixel scale"

	^ zoom x!

step: theStep
	"Accept the argument, 'theStep', as the new instance variable 'step'."

	zoom x: theStep.!

text
	"Answer the default display text for the receiver's sound."

	| stream snd |
	stream := WriteStream on: (String new: 64).
	snd := self sound.
	stream nextPutAll: 'rate: ', snd rate printString; cr.
	stream nextPutAll: 'fmt: ', snd format; cr.
	snd duration == nil
		ifFalse: [stream nextPutAll: 'dur: ', 
						((self sound duration asSec value printString) clipTo: 4); cr].
	stream nextPutAll: 'samps: ', snd size rounded printString; cr.
	((snd at: #comment) == nil)
		ifFalse: [stream nextPutAll: 'cmnt: ', (snd at: #comment); cr].
	^stream contents!

viewExtent
	"Answer the extent of the receiver's display object bounding box."

	^extent! !

!Siren.SoundView methodsFor: 'controller access'!

defaultControllerClass
	"Answer the default controller class for use with the receiver."

	^SoundController! !

!Siren.SoundView methodsFor: 'private'!

scrollableExtent
	"Answer the extent of the receiver's display object bounding box."

	Transcript show: 'SndView scr extent: ', (self model size / zoom x) printString; cr.
	^(self model size / zoom x) @ 1!

visibleExtent
	"Answer the extent of the receiver's clipping box."

	Transcript show: 'SndView vis extent: ', 
			((self bounds extent truncateTo: scrollOffset grid) max: scrollOffset grid) printString; cr.
	^(self bounds extent truncateTo: scrollOffset grid) max: scrollOffset grid! !

!Siren.SoundView methodsFor: 'displaying'!

displayMarkersOn: aGC
	"Show the selections (up to 2 markers) in the current sound"

	| y1 blok srcX |
	model == nil ifTrue: [^self].
	aGC paint: self markerColor.
	srcX := aGC clippingBounds left.
	y1 := extent y.
	model markers do: [ :sel |
			self showMarkerAt: (self xForSample: sel)].
	blok :=  [ :xVal | xVal ifNotNil: 
					[Cursor caret displayOn: aGC 
							at: (((self xForSample: xVal)- 8 + srcX)@ (y1 - 8))]].
	blok value: model selection1.
	blok value: model selection2.!

displayOn: aGraphicsContext
	"Display the receiver's sound on the argument"

	self displayOnGC: aGraphicsContext.
	self displayMarkersOn: aGraphicsContext
"
	pixmap == nil
		ifFalse: [redrawn == nil
				ifTrue: [self displayOnGC: pixmap graphicsContext].
			pixmap displayOn: aGraphicsContext]
		ifTrue: [self displayOnGC: aGraphicsContext]
"!

displayOnGC: aGC
	"Show the receiver's sound on the GC."

	| sound box centerY scaledScale setPoint value index oldPt ssize offsetIndex scaledStep |
	redrawn := true.
	box := aGC clippingBounds.
	aGC paint: self backgroundColor.
	aGC displayRectangle: box.
	aGC paint: self foregroundColor.
	centerY := extent y asFloat / 2.
	model ifNil: [^self].
	sound := self sound.
	sound ifNil: [^self].
	ssize := sound size.
	scaledScale := (sound class maxSample / zoom y) asInteger.
	scaledStep := zoom x asInteger.
	scaledStep = 0 ifTrue: [scaledStep := sound size asFloat / box width].
"Calculate the left-most sample and position"
	setPoint := box left.
	offsetIndex := setPoint * scaledStep + 1.
	value := (sound sampleAt: (offsetIndex max: 1)) // scaledScale.
	value := ((centerY - value) ) "min: box height - 1) max: 0".
	oldPt := setPoint @ value truncated.
"Loop for the samples in the to-be-displayed region"
	0 to: box width do:
		[ :counter | | pt |
		index := (counter * scaledStep) + offsetIndex.
		index > ssize ifTrue: [^self]. 
		value := (sound sampleAt: index) // scaledScale.
		value := ((centerY - value) ) "min: box height - 1) max: 0".
		pt := (setPoint + counter) @ (value asInteger).
		aGC displayLineFrom: oldPt to: pt.
		oldPt := pt]!

displayPosition: pos
	"Display the mouse pos in the corner of my display"

	| gc srcpos scaledStep value time sound index box |
	gc := self graphicsContext.
	box := gc clippingBounds.
	srcpos := box left + 4@12.
	sound := self sound.
	sound ifNil: [^self].
	scaledStep := zoom x asInteger.
	index := pos x * scaledStep.
	value := sound sampleAt: index.
	time := index asFloat / sound rate.
	gc paint: DisplayListView backgroundColor.
	gc displayRectangle: (srcpos - (0 @ 20) extent: 100@24).
	gc paint: DisplayListView foregroundColor.
	((time printString: 3), '@', value printString) displayOn: gc at: srcpos!

invalidate
	"Redisplay the receiver's sound"

	redrawn := nil.
	self displayOn: self graphicsContext.
	super invalidate!

redraw
	"Redisplay the receiver's sound"

	self invalidate! !

!Siren.SoundView methodsFor: 'selection'!

eraseMarkerAt: xValue
	"take a mouse point and place a marker on the sound sample there"

"	| pGC p1 p2 box x |
	x := xValue.
	pGC := pixmap graphicsContext.
	box := pGC clippingBounds.
	p1 := x @ box top.
	p2 := x @ box bottom.
	pGC displayLineFrom: p1 to: p2.
	pixmap displayOn: self graphicsContext."!

selectBetween: startValue and: stopValue
	"take a mouse region and place a marker on the sound sample there"

	| pGC p1 p2 box |
	(startValue = stopValue) ifTrue: [^self].
	pGC := pixmap graphicsContext.
	pGC paint: ColorValue lightGray.
	box := pGC clippingBounds.
	p1 := startValue @ box top + 4.
	p2 := stopValue @ box bottom - 4.
	pGC displayRectangularBorder: (p1 corner: p2).
	pixmap displayOn: self graphicsContext!

showMarkerAt: xValue
	"take a mouse point and place a marker on the sound sample there"

	| gc p1 p2 box theX |
	theX := self graphicsContext clippingBounds left + xValue.
	gc := self graphicsContext.
	box := gc clippingBounds.
	gc paint: ColorValue blue.
	box := gc clippingBounds.
	p1 := theX @ box top.
	p2 := theX @ box bottom.
	gc displayLineFrom: p1 to: p2! !

!Siren.SoundView methodsFor: 'converting indeces'!

sampleForX: xValue
	"Answer the sample under the point with x = xValue."

	^xValue - self class inset x * zoom x!

xForSample: sample
	"Answer the xValue of the sample with the given index."

	^self step = 0
		ifTrue: [sample + scrollOffset value x]
		ifFalse: [sample / self step + scrollOffset value x]! !

!Siren.SoundView methodsFor: 'initialize-release'!

initialize
	"Set up the proper default values for the receiver."

	super initialize.
	foregroundColor := ColorValue darkGray.
	zoom := 30 @ 100.		"step @ scale"
"	pixmap := Pixmap extent: (3000@400).
	extent := pixmap extent."! !



Smalltalk.Siren defineClass: #SpectrumView
	superclass: #{Siren.SoundView}
	indexedType: #none
	private: false
	instanceVariableNames: 'isColor '
	classInstanceVariableNames: ''
	imports: ''
	category: 'MusicUI-Sound'!

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!


!Siren.SpectrumView class methodsFor: 'instance creation'!

openOn: aSound
	"Open a SpectrumView"

	| topView topWindow |
	topView := (self spectrumViewOn: aSound) components first.
	topWindow := (ScheduledWindow model: aSound
			label: ('Spectrum View on: ', aSound name)
			minimumSize: 800@500).
	topWindow component: topView.
	topWindow icon: (Icon constantNamed: #systemBrowser).
	topWindow openWithExtent: topWindow minimumSize!

spectrumViewOn: aSpectrum
	"Take the given spectrum as model and open a SpectrumView"

	| topView me editor edgeDecorator |
	topView := CompositePart new.
	me := self new initialize.
	editor := SoundEditor new sound: aSpectrum.
	me model: editor.
	me color: true.
	editor view: me.
"SoundView"
	edgeDecorator := LookPreferences edgeDecorator on: me.
	edgeDecorator noVerticalScrollBar; noHorizontalScrollBar; noMenuBar.
	topView add: edgeDecorator
			in: (LayoutFrame new leftFraction: 0; topFraction: 0; rightFraction: 1; bottomFraction: 1).
	^topView! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!


!Siren.SpectrumView methodsFor: 'controller access'!

defaultControllerClass
	"Answer the default controller class for use with the receiver."

	^ControllerWithMenu! !

!Siren.SpectrumView methodsFor: 'accessing'!

color: aBoolean
	"set the color/bw switch"

	isColor := aBoolean! !

!Siren.SpectrumView methodsFor: 'displaying'!

colorForValue: theDatum
	"Answer the color to use for the given data value"

	| compressedDatum |
	compressedDatum :=  theDatum sqrt sqrt.	
	^isColor == true
		ifTrue: [ColorValue hue: (1.0 - compressedDatum) saturation: 1 brightness: 1]
		ifFalse: [ColorValue brightness: (1.0 - (compressedDatum min: 1.0))]!

displayOnGC1: aGC
	"Show the receiver's sound on the GC."
	"Spectrum sweepExample display"

	 Tools.ProfilerCore new
			samplingInterval: 3;
			profile:	[self displayOnGC0: aGC]!

displayOnGC: aGC
	"Show the receiver's sound on the GC."
	"Spectrum sweepExample display"

	| sound box ssize fftLen boxW boxH ext range dscale doffset bottom |
	box := aGC clippingBounds.
	aGC clear.
	aGC paint: DisplayListView foregroundColor.
	model ifNil: [^self].
	sound := self sound.
	sound ifNil: [^self].
	ssize := sound size.
	fftLen := ((sound windowSize / 4) min: box height).
	bottom := box bottom.
	boxW := box width / ssize.		"slice width"
	boxH := box height / fftLen.	"bin height"
	ext := boxW @ boxH.
	range := sound range.
	dscale := (1.0 / range size) * 0.9.			"clip a bit at the top"
	doffset :=  range first.
"Loop for the spectral slices"
	1 to: ssize do:
		[ :counter | | slice |
"Loop for the values within the slice"
		slice := sound data at: counter.
		1 to: fftLen do:
			[ :bin | | datum |
			datum :=  ((slice at: bin) - doffset * dscale).		"sqrt to compress a bit"
			aGC paint: (self colorForValue: datum).
			aGC displayRectangle: (((counter - 1 * boxW) @ (bottom - (bin - 1 * boxH))) extent: ext)]]! !
