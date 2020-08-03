'From VisualWorks® Personal Use Edition, 8.3 of July 28, 2017 on July 23, 2020 at 5:12:52 PM'!


!Core.LimitedPrecisionReal methodsFor: 'private - printing'!

printExponentCharacterIfNeededOn: aStream
	"Floating point numbers other than floats should print their type indicator"

	^self
"	aStream nextPut: self class exponentCharacter"! !