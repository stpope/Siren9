<?xml version="1.0"?>

<st-source>


<methods>
<class-id>UI.BorderDecorationPolicy</class-id> <category>private - regions</category>

<body package="UIBuilder-Support" selector="verticalScrollRegionFor:">verticalScrollRegionFor: aDecorator	"Answer a layout frame for aDecorator's vertical scrollbar."	"Compensate for the overlapping borders of the scroll bar and the data region."	| layout |"	layout := LayoutFrame new		topFraction: 0 offset: (self topOffsetFor: aDecorator);		bottomFraction: 1 offset: (self bottomOffsetFor: aDecorator);		leftFraction: 1 offset: (self rightOffsetFor: aDecorator);		rightFraction: 1 offset: 0."	layout := LayoutFrame new		topFraction: 0 offset: (self topOffsetFor: aDecorator);		bottomFraction: 1 offset: (self bottomOffsetFor: aDecorator);		leftFraction: 0 offset: 0;		rightFraction: 0 offset: (self rightOffsetFor: aDecorator) negated.	aDecorator hasHorizontalScrollbar		ifTrue: [ layout bottomOffset: layout bottomOffset + 1 ].	^layout</body>

<body package="UIBuilder-Support" selector="leftOffsetFor:">leftOffsetFor: aDecorator	"Compute the distance from the left of the container to the left of the 	data area"	^aDecorator hasVerticalScrollbar ifTrue: [(UI.Skins.SkinRegistry current scrollbarArtistForView: nil) width] ifFalse: [0]</body>

<body package="UIBuilder-Support" selector="dataRegionFor:">dataRegionFor: aDecorator	"Answer a layout frame for aDecorator's data area"	| vdelta hdelta b |	b := aDecorator hasBorder.	hdelta := (b and: [aDecorator hasHorizontalScrollbar]) ifTrue: [1] ifFalse: [0].	vdelta := (b and: [aDecorator hasVerticalScrollbar]) ifTrue: [1] ifFalse: [0].	"^LayoutFrame new		leftOffset: (self leftOffsetFor: aDecorator);		rightFraction: 1 offset: (self rightOffsetFor: aDecorator) + vdelta;		bottomFraction: 1 offset: (self bottomOffsetFor: aDecorator) + hdelta;		topOffset: (self topOffsetFor: aDecorator)"				^LayoutFrame new			leftOffset: (self leftOffsetFor: aDecorator);			rightFraction: 1 offset: vdelta;			bottomFraction: 1 offset: (self bottomOffsetFor: aDecorator) + hdelta;			topOffset: (self topOffsetFor: aDecorator)</body>
</methods>

</st-source>
