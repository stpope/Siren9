'From VisualWorks® Personal Use Edition, 8.3 of July 28, 2017 on May 20, 2020 at 12:11:35 PM'!


!Core.Collection methodsFor: 'enumerating'!

max
	"Answer the maximum element"

	| max |
	max := -1e6.
	self do: [ :item | (item > max) ifTrue: [max :=  item]].
	^max! !