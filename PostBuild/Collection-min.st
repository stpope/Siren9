'From VisualWorks® Personal Use Edition, 8.3 of July 28, 2017 on May 20, 2020 at 12:11:44 PM'!


!Core.Collection methodsFor: 'enumerating'!

min
	"Answer the minimum element"

	| min |
	min := 1e6.
	self do: [ :item | (item < min) ifTrue: [min :=  item]].
	^min! !