'From VisualWorks® Personal Use Edition, 8.3 of July 28, 2017 on May 20, 2020 at 3:18:50 PM'!


!Tools.VisualLauncher methodsFor: 'actions'!

doTestMessage
	"Perform the user's selected test message; edit the message if shift-down."

	<menuItem: #(#fileBrowser #menus 'File Browser' )
		icon: #doTestIcon
		nameKey: #doTest
		menu: #(#launcherToolBar)
		position: 90.01
		helpText: #(#OpenAFileBrowser #menus 'Perform (or edit) the test message')>

	| sel |
	doItMenu ifNil: [doItMenu := Menu labelArray: #(#flush 'add item') values: #(#flushDoItMenu addToDoItMenu)].
	sel := doItMenu startUp.
	(sel == 0)
		ifTrue: [^self].
	(sel == #flushDoItMenu)
		ifTrue: [doItMenu := Menu labelArray: #(#flush 'add item') values: #(#flushDoItMenu addToDoItMenu).
			^self].
	(sel == #addToDoItMenu)
		ifTrue: [ | answer |
			answer := Dialog
				request: 'What''s the test message'
				initialAnswer: 'Transcript cr; show:100 factorial printString; cr'
				onCancel: ['']
				windowLabel: 'Test Message Dialog'
				for: Dialog defaultParentWindow.
			answer isEmpty ifTrue: [^self].
			doItMenu addItem: ((MenuItem labeled: answer) value: answer asSymbol) atPosition: doItMenu menuItems size.
			^self].
	self builder window controller sensor shiftDown
		ifTrue: [doItMenu removeItem: (doItMenu menuItemLabeled: sel).
			^self].
	Compiler new
		evaluate: sel asSymbol
		in: nil
		allowReceiver: false
		receiver: nil
		environment: Smalltalk
		notifying: nil
		ifFail: [^self]! !