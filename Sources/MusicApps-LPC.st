

Smalltalk.Siren defineClass: #LPCView
	superclass: #{Siren.DisplayListView}
	indexedType: #none
	private: false
	instanceVariableNames: 'winSize editor '
	classInstanceVariableNames: ''
	imports: ''
	category: 'MusicApps-LPC'!

Siren.LPCView comment:
'An LPCView displays the pitch estimates of LPC sound analysis files.

Instance Variables:
	winSize <Point>  the window extent
	editor <Siren.LPCEditor>  my editor (host)
'!

!Siren.LPCView methodsFor: 'accessing'!

editor: ed
	editor := ed! !

!Siren.LPCView methodsFor: 'display'!

displayOn: aGraphicsContext
	"Show the receiver's pitch function and smoothed versions."
	"LPCEditor openOn: LPCSound someInstance"

	| data smoothed smoothed2 |
	winSize := aGraphicsContext clippingBounds extent.
	displayList := DisplayList new.
	data := Array new: model frames size.
	smoothed := Array new: model frames size.
	smoothed2 := Array new: model frames size.

				"draw raw data in gray"
	editor showPitch value ifTrue: 
		[1 to: model frames size do:
			[ :i | data at: i put: ((model frames at: i) pitch value)].
		self draw: data into: displayList color: ColorValue gray scale: 2 dots: true].

				"running avg data in blue"
	editor showRunning value ifTrue: 
		[model smoothRunning: data into: smoothed.
		self draw: smoothed into: displayList color: ColorValue blue scale: 2 dots: true].

				"avg smoothed data in red"
	editor showSmoothed value ifTrue: 
		[model smoothAvg: data into: smoothed.
		self draw: smoothed into: displayList color: ColorValue red scale: 2 dots: true].

	editor showSmoothed2 value ifTrue: 
		[model smoothAvg: data into: smoothed.
		model smoothAvg: smoothed into: smoothed2.
		self draw: smoothed2 into: displayList color: ColorValue green scale: 2 dots: true].

	editor showRMS value ifTrue: 
		[1 to: model frames size do:
			[ :i | data at: i put: ((model frames at: i) rmsO)].
		self draw: data into: displayList color: ColorValue yellow scale: 0.01 dots: false].

	editor showResid value ifTrue: 
		[1 to: model frames size do:
			[ :i | data at: i put: ((model frames at: i) rmsR)].
		self draw: data into: displayList color: ColorValue orange scale: 0.5 dots: false.
		1 to: model frames size do:
			[ :i | data at: i put: ((model frames at: i) err)].
		self draw: data into: displayList color: ColorValue cyan scale: 500 dots: false].

				"show the display list"
	displayList displayOn: aGraphicsContext!

draw: data into: list color: co scale: yScale dots: showD
	"Answer a display list with the receiver's pitch function."
	"LPCEditor openOn: LPCSound someInstance."

	| pointArray boxArray xScale numFr x y w |
	inset := 2.
	w := 4.		"point w/h"
	numFr := data size.
	xScale := winSize x - (2 * inset) / numFr.
	pointArray := Array new: numFr.
	boxArray := Array new: numFr.
	1 to: numFr do:
		[ :i |
		x := inset + (i * xScale).
		y := winSize y - (yScale * (data at: i)).
		pointArray at: i put: (x @ y).
		showD ifTrue: [boxArray at: i 
					put: ((DisplayRectangle offset: ((x-2)@(y-2)) extent: (w@w)) 
							color: ColorValue black)]].
	list add: ((DisplayPolyline
			offset: 0@0)
			color: co;
			stroke: 2;
			vertices: pointArray).
	showD ifTrue: [list addAll: boxArray]! !



Smalltalk.Siren defineClass: #LPCFrame
	superclass: #{Siren.MusicEvent}
	indexedType: #none
	private: false
	instanceVariableNames: 'srate npoles rmsO rmsR err coefficients '
	classInstanceVariableNames: ''
	imports: ''
	category: 'MusicApps-LPC'!

Siren.LPCFrame comment:
'An LPCFrame represents a single frame of an LPC file.

Instance Variables:
	srate	<Number>  the sound''s sample rate
	npoles	<Number>  the number of poles
	rmsO	<Number>  the original RMS
	rmsR	<Number>  the residual RMS
	err	<Number>  the error value
	coefficients	 <Array of Number>  the raw reflection coefficients
'!

!Siren.LPCFrame methodsFor: 'accessing'!

coefficients

	^coefficients!

coefficients: aValue

	coefficients := aValue!

err

	^err!

err: aValue

	err := aValue!

npoles

	^npoles!

npoles: aValue

	npoles := aValue!

pitch

	^pitch!

pitch: aValue

	pitch := aValue!

rmsO

	^rmsO!

rmsO: aValue

	rmsO := aValue!

rmsR

	^rmsR!

rmsR: aValue

	rmsR := aValue!

srate

	^srate!

srate: aValue

	srate := aValue! !

!Siren.LPCFrame methodsFor: 'printing'!

printOn: aStream 
	"Format and print the receiver on the argument."

	aStream nextPutAll: ' LPC Frame ', (rmsR printString: 3), '  	', (rmsO printString: 3), '  	', 
			(err printString: 4), '  	', (pitch printString: 4); cr! !



Smalltalk.Siren defineClass: #LPCEditor
	superclass: #{UI.ApplicationModel}
	indexedType: #none
	private: false
	instanceVariableNames: 'sound showSmoothed2 showResid showRMS showSmoothed showRunning showPitch '
	classInstanceVariableNames: ''
	imports: ''
	category: 'MusicApps-LPC'!

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!


!Siren.LPCEditor class methodsFor: 'interface specs'!

windowSpec
	"Tools.UIPainter new openOnClass: self andSelector: #windowSpec"

	<resource: #canvas>
	^#(#{UI.FullSpec} 
		#window: 
		#(#{UI.WindowSpec} 
			#label: 'LPC Pitch Data' 
			#bounds: #(#{Graphics.Rectangle} 640 328 1222 854 ) ) 
		#component: 
		#(#{UI.SpecCollection} 
			#collection: #(
				#(#{UI.ArbitraryComponentSpec} 
					#layout: #(#{Graphics.LayoutFrame} 4 0 48 0 -4 1 -4 1 ) 
					#name: #View1 
					#component: #theLPCView ) 
				#(#{UI.ActionButtonSpec} 
					#layout: #(#{Graphics.Rectangle} 16 4 90 44 ) 
					#name: #ActionButton1 
					#model: #redraw 
					#label: 'Redraw' 
					#defaultable: true ) 
				#(#{UI.ActionButtonSpec} 
					#layout: #(#{Graphics.LayoutFrame} -100 1 4 0 -8 1 44 0 ) 
					#name: #ActionButton2 
					#model: #closeWindow 
					#label: 'Close' 
					#defaultable: true ) 
				#(#{UI.CheckBoxSpec} 
					#layout: #(#{Core.Point} 100 4 ) 
					#name: #CheckBox1 
					#model: #showRMS 
					#label: 'RMS' ) 
				#(#{UI.CheckBoxSpec} 
					#layout: #(#{Core.Point} 100 24 ) 
					#name: #CheckBox2 
					#model: #showResid 
					#label: 'Resid' ) 
				#(#{UI.CheckBoxSpec} 
					#layout: #(#{Core.Point} 170 4 ) 
					#name: #CheckBox3 
					#model: #showPitch 
					#label: 'Pitch' ) 
				#(#{UI.CheckBoxSpec} 
					#layout: #(#{Core.Point} 170 24 ) 
					#name: #CheckBox4 
					#model: #showRunning 
					#label: 'Running' ) 
				#(#{UI.CheckBoxSpec} 
					#layout: #(#{Core.Point} 240 4 ) 
					#name: #CheckBox5 
					#model: #showSmoothed 
					#label: 'Smoothed' ) 
				#(#{UI.CheckBoxSpec} 
					#layout: #(#{Core.Point} 240 24 ) 
					#name: #CheckBox6 
					#model: #showSmoothed2 
					#label: 'Smoothed 2' ) 
				#(#{UI.ActionButtonSpec} 
					#layout: #(#{Graphics.Rectangle} 340 2 440 22 ) 
					#name: #ActionButton3 
					#model: #overwritePitch 
					#label: 'Smooth' 
					#defaultable: true ) 
				#(#{UI.ActionButtonSpec} 
					#layout: #(#{Graphics.Rectangle} 340 26 440 46 ) 
					#name: #ActionButton4 
					#model: #save 
					#label: 'Save' 
					#defaultable: true ) ) ) )! !

!Siren.LPCEditor class methodsFor: 'interface opening'!

openOn: snd
	"LPCEditor openOn: LPCSound someInstance."

	| inst |
	inst := self new.
	inst sound: snd.
	self openOn: inst withSpec: #windowSpec! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!


Siren.LPCEditor comment:
'LPCEditor is the app model for the simple LPC data editor.
Instance Variables:
	sound	<LPCSound>  the model
	showSmoothed2	<Boolean>  whether to display the smoothed-twice pitch data
	showResid	<Boolean>  whether to display the residual data
	showRMS	<Boolean>  whether to display the RMS data
	showSmoothed	<Boolean>  whether to display the smoothed pitch data
	showRunning	<Boolean>  whether to display the running-average pitch data
	showPitch	<Boolean>  whether to display the raw pitch data
'!

!Siren.LPCEditor methodsFor: 'aspects'!

showPitch
	"This method was generated by UIDefiner.  Any edits made here
	may be lost whenever methods are automatically defined.  The
	initialization provided below may have been preempted by an
	initialize method."

	^showPitch isNil
		ifTrue:
			[showPitch := true asValue]
		ifFalse:
			[showPitch]!

showRMS
	"This method was generated by UIDefiner.  Any edits made here
	may be lost whenever methods are automatically defined.  The
	initialization provided below may have been preempted by an
	initialize method."

	^showRMS isNil
		ifTrue:
			[showRMS := true asValue]
		ifFalse:
			[showRMS]!

showResid
	"This method was generated by UIDefiner.  Any edits made here
	may be lost whenever methods are automatically defined.  The
	initialization provided below may have been preempted by an
	initialize method."

	^showResid isNil
		ifTrue:
			[showResid := true asValue]
		ifFalse:
			[showResid]!

showRunning
	"This method was generated by UIDefiner.  Any edits made here
	may be lost whenever methods are automatically defined.  The
	initialization provided below may have been preempted by an
	initialize method."

	^showRunning isNil
		ifTrue:
			[showRunning := true asValue]
		ifFalse:
			[showRunning]!

showSmoothed
	"This method was generated by UIDefiner.  Any edits made here
	may be lost whenever methods are automatically defined.  The
	initialization provided below may have been preempted by an
	initialize method."

	^showSmoothed isNil
		ifTrue:
			[showSmoothed := true asValue]
		ifFalse:
			[showSmoothed]!

showSmoothed2
	"This method was generated by UIDefiner.  Any edits made here
	may be lost whenever methods are automatically defined.  The
	initialization provided below may have been preempted by an
	initialize method."

	^showSmoothed2 isNil
		ifTrue:
			[showSmoothed2 := true asValue]
		ifFalse:
			[showSmoothed2]! !

!Siren.LPCEditor methodsFor: 'actions'!

closeWindow
	"close view"

	^self closeRequest!

overwritePitch
	"Store the smoothed pitch into the model sound"

	| which sel |
	which := (Menu labelArray: #(running smooth1 smooth2)) startUp.
	which == 0 ifTrue: [^self].
	sel := #(running smooth1 smooth2) at: which.
	sound writePitch: sel.
	self redraw!

redraw
	"Redisplay"

	builder namedComponents do: [:t1 | t1 invalidate].!

save
	"Store the model data to a new file."

	sound storeFile! !

!Siren.LPCEditor methodsFor: 'interface opening'!

postBuildWith: aBuilder

	super postBuildWith: aBuilder.
	(aBuilder componentAt: #View1) widget model: sound		"and plug it in"!

sound: aSound

	sound := aSound!

theLPCView
	^LPCView new editor: self! !



Smalltalk.Siren defineClass: #LPCSound
	superclass: #{Siren.MusicEvent}
	indexedType: #none
	private: false
	instanceVariableNames: 'filename filesize srate frate npoles nframes frames pchMax pchMin pitchRange rmsRange residRange '
	classInstanceVariableNames: ''
	imports: ''
	category: 'MusicApps-LPC'!

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!


!Siren.LPCSound class methodsFor: 'instance creation'!

fromFile: filename
	"Read in an lpc sound from the given Csound format file."
	"LPCSound fromFile: '1.2a1.2.lpc'  "
	"LPCEditor openOn: LPCSound someInstance"
	"LPCEditor openOn: (LPCSound fromFile: '1.2a1.2.lpc')"
	"LPCSound instanceCount"
	"LPCSound allInstances"

"	#define LP_MAGIC    999
	#define LP_MAGIC2   2399                   /* pole file type */
	#define LPBUFSIZ    4096           /* in lpanal */
	#define MAXWINDIN   1000           /* for 10ms hops at 50 KC */
	#define MAXPOLES    50
	#define NDATA       4   /* number of data values stored with frame */

	typedef struct {
	        long    headersize, lpmagic, npoles, nvals;
	        MYFLT   framrate, srate, duration;
	        char    text[4];
	} LPHEADER;

      coef[0] = (MYFLT)rms2;		// resid rms
      coef[1] = (MYFLT)rms1;		// orig rms	
      coef[2] = (MYFLT)errn;		// err val
      if (lpc.doPitch)					// pitch
        coef[3] = getpch(csound, sigbuf);
"
	| rec inst hdrsiz magic npoles nvals frate srate dur cnt data fram |
	inst := self new.
	data := UninterpretedBytes from: (SirenUtility findFile: filename) asFilename contentsOfEntireFile.
	hdrsiz := inst long: 1 from: data.
	magic := inst long: 2 from: data.
	npoles := inst long: 3 from: data.
	nvals := inst long: 4 from: data.
	frate := inst float: 5 from: data.
	srate := inst float: 6 from: data.
	dur := inst float: 7 from: data.
"end of header"
	(hdrsiz = 28) ifFalse: [self error: 'bad file header size'].
	(magic = 2399) ifFalse: [self error: 'bad file magic number'].
	inst filename: filename.
	inst filesize: data sizeInBytes.
	inst npoles: npoles.
	inst srate: srate.
	inst frate: frate.
	inst nframes: nvals.
	inst duration: dur.
	inst frames: (OrderedCollection new: nvals).
	cnt := 8.
	[1 to: nvals do:			" main read loop"
		[ :i |
		fram := LPCFrame new.
		fram rmsR: (inst float: cnt from: data).
		fram rmsO: (inst float: cnt + 1 from: data).
		fram err: (inst float: cnt + 2 from: data).
		fram pitch: (inst float: cnt + 3 from: data).
		rec := Array new: npoles * 2.
		cnt := cnt + 3.
		1 to: npoles * 2 do:
			[ :j | rec at: j put: (inst float: cnt + j from: data)].
		fram coefficients: rec.
		inst addFrame: fram.
		cnt := cnt + (npoles * 2) + 1]]
			on: Error
			do: [ :ignored | ].
	inst gatherStatistics.
	^inst! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!


Siren.LPCSound comment:
'An LPCSound represents LPC data read in from a Csound LPC file.

Instance Variables:
	filename	<String>  my source file name
	filesize	<Number>  the raw file size
	srate	<Number>  the sound''s sample rate
	frate	<Number>  the frame rate
	npoles	<Number>  the # of poles
	nframes	<Number>  the # of frames
	frames	<OrderedCollection of LPCFrame>  the frame data
	pchMax	<Number>  max est. pitch
	pchMin	<Number>  min est. pitch
	pitchRange	<Interval>  est. pitch range
	rmsRange	<Number>  RMS amplitude range
	residRange	<Number>  error residual range
'!

!Siren.LPCSound methodsFor: 'smoothing'!

smooth: data into: res
	"filter the data"
	"LPCEditor openOn: LPCSound someInstance"

	| prev next this runningAvg thresh |
	thresh := 0.3.
	prev := data first pitch.							"prime the stored val;ues"
	this := (data at: 2) pitch.
	next := (data at: 3) pitch.
	res at: 1 put: prev.
	runningAvg := prev.
	2 to: data size - 1 do:							"loop through the frames"
		[ :i | | d1 d2 d3 |
		d1 := (this - prev) abs / pchMax.			"get the scaled differences"
		d2 := (next - this) abs / pchMax.
		d3 := (next - prev) abs / pchMax.			"avg of prev/next"

		Transcript show: d1 printString, ' - ', d2 printString, ' - ', d3 printString; tab.

		((d1 < thresh) | (d2 < thresh))				"if this val is close to prev or to next"
			ifTrue: [res at: i put: this.
				Transcript tab; show: 'C1: ', runningAvg printString; cr.
				runningAvg := (runningAvg + this) / 2.0]
			ifFalse: [(d3 < thresh)					"else if prev close to next, but not to this"
				ifTrue: [res at: i put: ((prev * next) / 2.0).
					Transcript tab; show: 'C2: ', runningAvg printString; cr.
					runningAvg := (runningAvg + (res at: i)) / 2.0]
				ifFalse: [Transcript tab; show: 'C3: ', runningAvg printString; cr.
					res at: i put: runningAvg]]	.	 "if we're lost"
		prev := this.
		this := next.
		next := (data at: i + 1) pitch].
	res at: nframes put: next!

smoothAvg: data into: res
	"filter the data"
	"LPCEditor openOn: LPCSound someInstance"

	| prev next this |
	prev := data first pitch value.							"prime the stored val;ues"
	this := (data at: 2) pitch value.
	next := (data at: 3) pitch value.
	res at: 1 put: prev.
	2 to: data size - 1 do:							"loop through the frames"
		[ :i | 
		res at: i put: (prev + this + next) / 3.0.		 "avg of 3 values"
		prev := this.
		this := next.
		next := (data at: i + 1) pitch value].
	res at: data size put: next!

smoothPitch
	"filter the data"
	"LPCEditor openOn: LPCSound someInstance"

	| data smoothed smoothed2 |
	data := Array new: frames size.
	smoothed := Array new: frames size.
	smoothed2 := Array new: frames size.
	1 to: frames size do:
		[ :i | data at: i put: ((frames at: i) pitch value)].
	self smoothAvg: data into: smoothed.
	self smoothAvg: smoothed into: smoothed2.
	1 to: frames size do:
		[ :i | (frames at: i) pitch: (smoothed2 at: i)].!

smoothRunning: data into: res
	"filter the data"
	"LPCEditor openOn: LPCSound someInstance"

	| prev next this runningAvg thresh verbose |
	verbose := false.
	thresh := 0.3.
	prev := data first pitch value.							"prime the stored values"
	this := (data at: 2) pitch value.
	next := (data at: 3) pitch value.
	res at: 1 put: prev.
	runningAvg := prev.
	2 to: data size - 1 do:									"loop through the frames"
		[ :i | | d1 d2 d3 |
		d1 := (this - prev) abs / pitchRange stop.			"get the scaled differences"
		d2 := (next - this) abs / pitchRange stop.
		d3 := (next - prev) abs / pitchRange stop.			"avg of prev/next"

		verbose ifTrue: [Transcript show: d1 printString, ' - ', d2 printString, ' - ', d3 printString; tab].

		((d1 < thresh) | (d2 < thresh))				"if this val is close to prev or to next"
			ifTrue: [res at: i put: this.
				verbose ifTrue: [Transcript tab; show: 'C1: ', runningAvg printString; cr].
				runningAvg := (runningAvg + this) / 2.0]
			ifFalse: [(d3 < thresh)					"else if prev close to next, but not to this"
				ifTrue: [res at: i put: ((prev * next) / 2.0).
					verbose ifTrue: [Transcript tab; show: 'C2: ', runningAvg printString; cr].
					runningAvg := (runningAvg + (res at: i)) / 2.0]
				ifFalse: [verbose ifTrue: [Transcript tab; show: 'C3: ', runningAvg printString; cr].
					res at: i put: runningAvg]]	.	 "if we're lost"
		prev := this.
		this := next.
		next := (data at: i + 1) pitch value].
	res at: data size put: next!

writePitch: howSmooth
	"Replace the pitch values in the receiver's frames with a smoothed version selected by the argument."

	| data smoothed smoothed2 |
	data := Array new: frames size.
	smoothed := Array new: frames size.
	smoothed2 := Array new: frames size.
	1 to: frames size do:
			[ :i | data at: i put: ((frames at: i) pitch value)].
	howSmooth == #running ifTrue: [self smoothRunning: data into: smoothed].
	howSmooth == #smooth1 ifTrue: [self smoothAvg: data into: smoothed].
	howSmooth == #smooth2 ifTrue: [self smoothAvg: data into: smoothed2.
		self smoothAvg: smoothed2 into: smoothed].
	1 to: frames size do:
			[ :i | ((frames at: i) pitch: (smoothed at: i))].! !

!Siren.LPCSound methodsFor: 'accessing'!

addFrame: frame

	frames addLast: frame!

filename

	^filename!

filename: aValue

	filename := aValue!

filesize

	^filesize!

filesize: aValue

	filesize := aValue!

float: ind from: data 
	"Answer the swapped float from the data at the index."

	| index |
	index := ind - 1 * 4 + 1.
	UninterpretedBytes isBigEndian
		ifFalse: [data swapLongAt: index].
	^data floatAt: index!

floatAt: ind put: value in: data 
	"Store the swapped float into the data at the index."

	| index |
	index := ind - 1 * 4 + 1.
	data floatAt: index put: value.
	UninterpretedBytes isBigEndian
		ifFalse: [data swapLongAt: index]!

frameAt: ind put: frame

	frames at: ind put: frame!

frames

	^frames!

frames: aValue

	frames := aValue!

frate

	^frate!

frate: aValue

	frate := aValue!

long: ind from: data 
	"Answer the swapped long int from the data at the index."

	| index |
	index := ind - 1 * 4 + 1.
	UninterpretedBytes isBigEndian
		ifFalse: [data swapLongAt: index]. 
	^data longAt: index!

longAt: ind put: value in: data 
	"Store the swapped long int into the data at the index."

	| index |
	index := ind - 1 * 4 + 1.
	data longAt: index put: value.
	UninterpretedBytes isBigEndian
		ifFalse: [data swapLongAt: index]!

nframes

	^nframes!

nframes: aValue

	nframes := aValue!

npoles

	^npoles!

npoles: aValue

	npoles := aValue!

srate

	^srate!

srate: aValue

	srate := aValue! !

!Siren.LPCSound methodsFor: 'printing'!

printOn: aStream 
	"Format and print the receiver on the argument."

	aStream nextPutAll: ' LPC Sound ', duration printString, ' ', frames size printString, ' frames '; cr!

storeFile
	"Store the receiver as a Csound format LPC file."
	"LPCSound fromFile: '/Volumes/Content/Sound/3-IKnowGod/LPC/1.2a1.2.lpc'  "
	"LPCSound someInstance storefile"

	| strm newname |
	newname := Dialog request: 'Store LPC data to file' initialAnswer: filename.
	newname isEmpty ifTrue: [^self].
	strm := newname asFilename writeStream binary.
	self storeOn: strm.
	strm close.!

storeOn: aStream 
	"Store the receiver on the argument as a Csound format LPC file."
	"LPCSound fromFile: '/Volumes/Content/Sound/3-IKnowGod/LPC/1.2a1.2.lpc'  "
	"LPCEditor open"

	| cnt data fram |
	data := UninterpretedBytes new: filesize.
	self longAt: 1 put: 28 in: data.			"header size"
	self longAt: 2 put: 2399 in: data.		"magic #"
	self longAt: 3 put: npoles in: data.
	self longAt: 4 put: nframes in: data.
	self floatAt: 5 put: frate in: data.
	self floatAt: 6 put: srate in: data.
	self floatAt: 7 put: duration value in: data.
	cnt := 8.
	[1 to: frames size do:			" main write loop"
		[ :i |
		fram := frames at: i.
		self floatAt: cnt      put: fram rmsR in: data.
		self floatAt: cnt + 1 put: fram rmsO in: data.
		self floatAt: cnt + 2 put: fram err in: data.
		self floatAt: cnt + 3 put: fram pitch in: data.
		cnt := cnt + 3.
		1 to: npoles * 2 do:
			[ :j | self floatAt: cnt + j put: (fram coefficients at: j) in: data].
		cnt := cnt + (npoles * 2) + 1]] 
			on: Error
			do: [ :ignored | ].
	aStream nextPutAll: data asByteArray! !

!Siren.LPCSound methodsFor: 'statistics'!

gatherStatistics
	"Compute the max and min-non-0 pitch values for later."

	| val pMax pMin rMax rMin reMax reMin |
	pMax := frames first pitch.
	pMin := frames first pitch.
	rMax := frames first pitch.
	rMin := frames first pitch.
	reMax := frames first pitch.
	reMin := frames first pitch.
	2 to: frames size do:			" main read loop"
		[ :i |
		val := (frames at: i) pitch.
		(val > pMax) ifTrue: [pMax := val].
		((val < pMin) & (val > 0.0)) ifTrue: [pMin := val].
		val := (frames at: i) rmsO.
		(val > rMax) ifTrue: [rMax := val].
		(val < rMin) ifTrue: [rMin := val].
		val := (frames at: i) rmsR.
		(val > reMax) ifTrue: [reMax := val].
		(val < reMin) ifTrue: [reMin := val]].
	pitchRange := pMin to: pMax.
	rmsRange := rMin to: rMax.
	residRange := reMin to: reMax.! !
