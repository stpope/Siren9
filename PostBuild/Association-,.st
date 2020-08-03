'From VisualWorks® Personal Use Edition, 8.3 of July 28, 2017 on May 16, 2020 at 4:19:27 AM'!


!Core.Association methodsFor: 'copying'!

, anAssociation

 	"Answer a Dictionary with of the receiver and the argument as its elements."
	"(#a -> 1), (#b -> 2)"
	| dict |	dict := Dictionary new.
	dict add: self.
	dict add: anAssociation.	^dict! !