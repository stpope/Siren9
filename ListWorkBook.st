'From VisualWorks® Personal Use Edition, 8.3 of July 28, 2017 on May 16, 2020 at 4:53:48 AM'!


Smalltalk.Tools defineClass: #ListWorkBook
	superclass: #{Tools.Workbook}
	indexedType: #none
	private: false
	instanceVariableNames: 'textView '
	classInstanceVariableNames: ''
	imports: ''
	category: 'Tools-Workspace'!

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!


!Tools.ListWorkBook class methodsFor: 'interface specs'!

listMenu
	"MenuEditor new openOnClass: self andSelector: #listMenu"

	<resource: #menu>
	^#(#{UI.Menu} #(
			#(#{UI.MenuItem} 
				#rawLabel: '&Page' 
				#nameKey: #fileMenu 
				#submenu: #(#{UI.Menu} #(
						#(#{UI.MenuItem} 
							#rawLabel: '&New' 
							#nameKey: #fileNew 
							#value: #fileNew 
							#shortcutKeyCharacter: $N 
							#shortcutModifiers: 2 
							#labelImage: #(#{UI.ResourceRetriever} #{ToolbarIconLibrary} #fileNew ) ) 
						#(#{UI.MenuItem} 
							#rawLabel: '&Open...' 
							#nameKey: #fileOpen 
							#value: #fileOpen 
							#shortcutKeyCharacter: $O 
							#shortcutModifiers: 2 
							#labelImage: #(#{UI.ResourceRetriever} #{ToolbarIconLibrary} #fileOpen ) ) 
						#(#{UI.MenuItem} 
							#rawLabel: '&Save' 
							#nameKey: #fileSave 
							#value: #fileSave 
							#enablementSelector: #isAtTextPage 
							#shortcutKeyCharacter: $S 
							#shortcutModifiers: 2 
							#labelImage: #(#{UI.ResourceRetriever} #{ToolbarIconLibrary} #fileSave ) ) 
						#(#{UI.MenuItem} 
							#rawLabel: 'Save &As...' 
							#nameKey: #fileSaveAs 
							#value: #fileSaveAs 
							#enablementSelector: #isAtTextPage ) 
						#(#{UI.MenuItem} 
							#rawLabel: 'Load All...' 
							#nameKey: #loadAll 
							#value: #loadAll ) 
						#(#{UI.MenuItem} 
							#rawLabel: 'Save All...' 
							#nameKey: #saveAll 
							#value: #saveAll ) 
						#(#{UI.MenuItem} 
							#rawLabel: '&Rename...' 
							#nameKey: #pageRename 
							#value: #pageRename 
							#enablementSelector: #canRenamePage ) 
						#(#{UI.MenuItem} 
							#rawLabel: '&Tear Off' 
							#nameKey: #pageTearOff 
							#value: #pageTearOff 
							#enablementSelector: #isAtTextPage ) 
						#(#{UI.MenuItem} 
							#rawLabel: 'Re&move' 
							#nameKey: #pageClose 
							#value: #pageClose 
							#enablementSelector: #canClosePage ) ) #(1 5 3 ) nil ) ) 
			#(#{UI.MenuItem} 
				#rawLabel: '&Edit' 
				#nameKey: #editMenu 
				#submenu: #(#{UI.Menu} #(
						#(#{UI.MenuItem} 
							#rawLabel: '&Undo' 
							#nameKey: #editUndo 
							#value: #undo 
							#enablementSelector: #canUndo 
							#shortcutKeyCharacter: $Z 
							#shortcutModifiers: 2 ) 
						#(#{UI.MenuItem} 
							#rawLabel: 'Cu&t' 
							#nameKey: #editCut 
							#value: #cut 
							#enablementSelector: #isAtTextPage 
							#shortcutKeyCharacter: $X 
							#shortcutModifiers: 2 
							#labelImage: #(#{UI.ResourceRetriever} #{ToolbarIconLibrary} #cut ) ) 
						#(#{UI.MenuItem} 
							#rawLabel: '&Copy' 
							#nameKey: #editCopy 
							#value: #copySelection 
							#shortcutKeyCharacter: $C 
							#shortcutModifiers: 2 
							#labelImage: #(#{UI.ResourceRetriever} #{ToolbarIconLibrary} #copy ) ) 
						#(#{UI.MenuItem} 
							#rawLabel: '&Paste' 
							#nameKey: #editPaste 
							#value: #paste 
							#shortcutKeyCharacter: $V 
							#shortcutModifiers: 2 
							#labelImage: #(#{UI.ResourceRetriever} #{ToolbarIconLibrary} #paste ) ) 
						#(#{UI.MenuItem} 
							#rawLabel: 'Select &All' 
							#nameKey: #editSelectAll 
							#value: #selectAll 
							#shortcutKeyCharacter: $A 
							#shortcutModifiers: 2 ) 
						#(#{UI.MenuItem} 
							#rawLabel: '&Encoding' 
							#nameKey: #editEncoding ) ) #(1 3 1 1 ) nil ) ) 
			#(#{UI.MenuItem} 
				#rawLabel: '&Smalltalk' 
				#nameKey: #smalltalkSubmenu 
				#submenu: #(#{UI.Menu} #(
						#(#{UI.MenuItem} 
							#rawLabel: '&Do it' 
							#value: #smalltalkDoIt 
							#shortcutKeyCharacter: $D 
							#shortcutModifiers: 2 
							#labelImage: #(#{UI.ResourceRetriever} #{ToolbarIconLibrary} #doIt ) ) 
						#(#{UI.MenuItem} 
							#rawLabel: '&Print it' 
							#value: #smalltalkPrintIt 
							#shortcutKeyCharacter: $P 
							#shortcutModifiers: 2 
							#labelImage: #(#{UI.ResourceRetriever} #{ToolbarIconLibrary} #printIt ) ) 
						#(#{UI.MenuItem} 
							#rawLabel: '&Inspect it' 
							#value: #smalltalkInspectIt 
							#shortcutKeyCharacter: $I 
							#shortcutModifiers: 2 
							#labelImage: #(#{UI.ResourceRetriever} #{ToolbarIconLibrary} #inspectIt ) ) 
						#(#{UI.MenuItem} 
							#rawLabel: 'De&bug it' 
							#value: #smalltalkDebugIt 
							#shortcutKeyCharacter: $B 
							#shortcutModifiers: 2 
							#labelImage: #(#{UI.ResourceRetriever} #{ToolbarIconLibrary} #debugIt ) ) 
						#(#{UI.MenuItem} 
							#rawLabel: '&File it In' 
							#value: #smalltalkFileItIn ) 
						#(#{UI.MenuItem} 
							#rawLabel: '&Namespaces...' 
							#value: #editImports 
							#labelImage: #(#{UI.ResourceRetriever} #{ToolbarIconLibrary} #namespaces ) ) ) #(4 1 1 ) nil ) ) ) #(3 ) nil ) decodeAsLiteralArray!

menuBar
	"MenuEditor new openOnClass: self andSelector: #menuBar"

	<resource: #menu>
	^#(#{UI.Menu} #(
			#(#{UI.MenuItem} 
				#rawLabel: '&Page' 
				#nameKey: #fileMenu 
				#submenu: #(#{UI.Menu} #(
						#(#{UI.MenuItem} 
							#rawLabel: '&New' 
							#nameKey: #fileNew 
							#value: #fileNew 
							#shortcutKeyCharacter: $N 
							#shortcutModifiers: 2 
							#labelImage: #(#{UI.ResourceRetriever} #{ToolbarIconLibrary} #fileNew ) ) 
						#(#{UI.MenuItem} 
							#rawLabel: '&Open...' 
							#nameKey: #fileOpen 
							#value: #fileOpen 
							#shortcutKeyCharacter: $O 
							#shortcutModifiers: 2 
							#labelImage: #(#{UI.ResourceRetriever} #{ToolbarIconLibrary} #fileOpen ) ) 
						#(#{UI.MenuItem} 
							#rawLabel: '&Save' 
							#nameKey: #fileSave 
							#value: #fileSave 
							#enablementSelector: #isAtTextPage 
							#shortcutKeyCharacter: $S 
							#shortcutModifiers: 2 
							#labelImage: #(#{UI.ResourceRetriever} #{ToolbarIconLibrary} #fileSave ) ) 
						#(#{UI.MenuItem} 
							#rawLabel: 'Save &As...' 
							#nameKey: #fileSaveAs 
							#value: #fileSaveAs 
							#enablementSelector: #isAtTextPage ) 
						#(#{UI.MenuItem} 
							#rawLabel: 'Load All...' 
							#nameKey: #loadAll 
							#value: #loadAll ) 
						#(#{UI.MenuItem} 
							#rawLabel: 'Save All...' 
							#nameKey: #saveAll 
							#value: #saveAll ) 
						#(#{UI.MenuItem} 
							#rawLabel: '&Rename...' 
							#nameKey: #pageRename 
							#value: #pageRename 
							#enablementSelector: #canRenamePage ) 
						#(#{UI.MenuItem} 
							#rawLabel: '&Tear Off' 
							#nameKey: #pageTearOff 
							#value: #pageTearOff 
							#enablementSelector: #isAtTextPage ) 
						#(#{UI.MenuItem} 
							#rawLabel: 'Re&move' 
							#nameKey: #pageClose 
							#value: #pageClose 
							#enablementSelector: #canClosePage ) ) #(1 5 3 ) nil ) ) 
			#(#{UI.MenuItem} 
				#rawLabel: '&Edit' 
				#nameKey: #editMenu 
				#submenu: #(#{UI.Menu} #(
						#(#{UI.MenuItem} 
							#rawLabel: '&Undo' 
							#nameKey: #editUndo 
							#value: #undo 
							#enablementSelector: #canUndo 
							#shortcutKeyCharacter: $Z 
							#shortcutModifiers: 2 ) 
						#(#{UI.MenuItem} 
							#rawLabel: 'Cu&t' 
							#nameKey: #editCut 
							#value: #cut 
							#enablementSelector: #isAtTextPage 
							#shortcutKeyCharacter: $X 
							#shortcutModifiers: 2 
							#labelImage: #(#{UI.ResourceRetriever} #{ToolbarIconLibrary} #cut ) ) 
						#(#{UI.MenuItem} 
							#rawLabel: '&Copy' 
							#nameKey: #editCopy 
							#value: #copySelection 
							#shortcutKeyCharacter: $C 
							#shortcutModifiers: 2 
							#labelImage: #(#{UI.ResourceRetriever} #{ToolbarIconLibrary} #copy ) ) 
						#(#{UI.MenuItem} 
							#rawLabel: '&Paste' 
							#nameKey: #editPaste 
							#value: #paste 
							#shortcutKeyCharacter: $V 
							#shortcutModifiers: 2 
							#labelImage: #(#{UI.ResourceRetriever} #{ToolbarIconLibrary} #paste ) ) 
						#(#{UI.MenuItem} 
							#rawLabel: 'Select &All' 
							#nameKey: #editSelectAll 
							#value: #selectAll 
							#shortcutKeyCharacter: $A 
							#shortcutModifiers: 2 ) 
						#(#{UI.MenuItem} 
							#rawLabel: '&Encoding' 
							#nameKey: #editEncoding ) ) #(1 3 1 1 ) nil ) ) 
			#(#{UI.MenuItem} 
				#rawLabel: '&Smalltalk' 
				#nameKey: #smalltalkSubmenu 
				#submenu: #(#{UI.Menu} #(
						#(#{UI.MenuItem} 
							#rawLabel: '&Do it' 
							#value: #smalltalkDoIt 
							#shortcutKeyCharacter: $D 
							#shortcutModifiers: 2 
							#labelImage: #(#{UI.ResourceRetriever} #{ToolbarIconLibrary} #doIt ) ) 
						#(#{UI.MenuItem} 
							#rawLabel: '&Print it' 
							#value: #smalltalkPrintIt 
							#shortcutKeyCharacter: $P 
							#shortcutModifiers: 2 
							#labelImage: #(#{UI.ResourceRetriever} #{ToolbarIconLibrary} #printIt ) ) 
						#(#{UI.MenuItem} 
							#rawLabel: '&Inspect it' 
							#value: #smalltalkInspectIt 
							#shortcutKeyCharacter: $I 
							#shortcutModifiers: 2 
							#labelImage: #(#{UI.ResourceRetriever} #{ToolbarIconLibrary} #inspectIt ) ) 
						#(#{UI.MenuItem} 
							#rawLabel: 'De&bug it' 
							#value: #smalltalkDebugIt 
							#shortcutKeyCharacter: $B 
							#shortcutModifiers: 2 
							#labelImage: #(#{UI.ResourceRetriever} #{ToolbarIconLibrary} #debugIt ) ) 
						#(#{UI.MenuItem} 
							#rawLabel: '&File it In' 
							#value: #smalltalkFileItIn ) 
						#(#{UI.MenuItem} 
							#rawLabel: '&Namespaces...' 
							#value: #editImports 
							#labelImage: #(#{UI.ResourceRetriever} #{ToolbarIconLibrary} #namespaces ) ) ) #(4 1 1 ) nil ) ) ) #(3 ) nil ) decodeAsLiteralArray!

topicMenu
	"MenuEditor new openOnClass: self andSelector: #menuBar"

	<resource: #menu>
	^#(#{UI.Menu} #(
			#(#{UI.MenuItem} 
				#rawLabel: '&Page' 
				#nameKey: #fileMenu 
				#submenu: #(#{UI.Menu} #(
						#(#{UI.MenuItem} 
							#rawLabel: '&New' 
							#nameKey: #fileNew 
							#value: #fileNew 
							#shortcutKeyCharacter: $N 
							#shortcutModifiers: 2 
							#labelImage: #(#{UI.ResourceRetriever} #{ToolbarIconLibrary} #fileNew ) ) 
						#(#{UI.MenuItem} 
							#rawLabel: '&Open...' 
							#nameKey: #fileOpen 
							#value: #fileOpen 
							#shortcutKeyCharacter: $O 
							#shortcutModifiers: 2 
							#labelImage: #(#{UI.ResourceRetriever} #{ToolbarIconLibrary} #fileOpen ) ) 
						#(#{UI.MenuItem} 
							#rawLabel: '&Save' 
							#nameKey: #fileSave 
							#value: #fileSave 
							#enablementSelector: #isAtTextPage 
							#shortcutKeyCharacter: $S 
							#shortcutModifiers: 2 
							#labelImage: #(#{UI.ResourceRetriever} #{ToolbarIconLibrary} #fileSave ) ) 
						#(#{UI.MenuItem} 
							#rawLabel: 'Save &As...' 
							#nameKey: #fileSaveAs 
							#value: #fileSaveAs 
							#enablementSelector: #isAtTextPage ) 
						#(#{UI.MenuItem} 
							#rawLabel: 'Load All...' 
							#nameKey: #loadAll 
							#value: #loadAll ) 
						#(#{UI.MenuItem} 
							#rawLabel: 'Save All...' 
							#nameKey: #saveAll 
							#value: #saveAll ) 
						#(#{UI.MenuItem} 
							#rawLabel: '&Rename...' 
							#nameKey: #pageRename 
							#value: #pageRename 
							#enablementSelector: #canRenamePage ) 
						#(#{UI.MenuItem} 
							#rawLabel: '&Tear Off' 
							#nameKey: #pageTearOff 
							#value: #pageTearOff 
							#enablementSelector: #isAtTextPage ) 
						#(#{UI.MenuItem} 
							#rawLabel: 'Re&move' 
							#nameKey: #pageClose 
							#value: #pageClose 
							#enablementSelector: #canClosePage ) ) #(1 5 3 ) nil ) ) 
			#(#{UI.MenuItem} 
				#rawLabel: '&Edit' 
				#nameKey: #editMenu 
				#submenu: #(#{UI.Menu} #(
						#(#{UI.MenuItem} 
							#rawLabel: '&Undo' 
							#nameKey: #editUndo 
							#value: #undo 
							#enablementSelector: #canUndo 
							#shortcutKeyCharacter: $Z 
							#shortcutModifiers: 2 ) 
						#(#{UI.MenuItem} 
							#rawLabel: 'Cu&t' 
							#nameKey: #editCut 
							#value: #cut 
							#enablementSelector: #isAtTextPage 
							#shortcutKeyCharacter: $X 
							#shortcutModifiers: 2 
							#labelImage: #(#{UI.ResourceRetriever} #{ToolbarIconLibrary} #cut ) ) 
						#(#{UI.MenuItem} 
							#rawLabel: '&Copy' 
							#nameKey: #editCopy 
							#value: #copySelection 
							#shortcutKeyCharacter: $C 
							#shortcutModifiers: 2 
							#labelImage: #(#{UI.ResourceRetriever} #{ToolbarIconLibrary} #copy ) ) 
						#(#{UI.MenuItem} 
							#rawLabel: '&Paste' 
							#nameKey: #editPaste 
							#value: #paste 
							#shortcutKeyCharacter: $V 
							#shortcutModifiers: 2 
							#labelImage: #(#{UI.ResourceRetriever} #{ToolbarIconLibrary} #paste ) ) 
						#(#{UI.MenuItem} 
							#rawLabel: 'Select &All' 
							#nameKey: #editSelectAll 
							#value: #selectAll 
							#shortcutKeyCharacter: $A 
							#shortcutModifiers: 2 ) 
						#(#{UI.MenuItem} 
							#rawLabel: '&Encoding' 
							#nameKey: #editEncoding ) ) #(1 3 1 1 ) nil ) ) 
			#(#{UI.MenuItem} 
				#rawLabel: '&Smalltalk' 
				#nameKey: #smalltalkSubmenu 
				#submenu: #(#{UI.Menu} #(
						#(#{UI.MenuItem} 
							#rawLabel: '&Do it' 
							#value: #smalltalkDoIt 
							#shortcutKeyCharacter: $D 
							#shortcutModifiers: 2 
							#labelImage: #(#{UI.ResourceRetriever} #{ToolbarIconLibrary} #doIt ) ) 
						#(#{UI.MenuItem} 
							#rawLabel: '&Print it' 
							#value: #smalltalkPrintIt 
							#shortcutKeyCharacter: $P 
							#shortcutModifiers: 2 
							#labelImage: #(#{UI.ResourceRetriever} #{ToolbarIconLibrary} #printIt ) ) 
						#(#{UI.MenuItem} 
							#rawLabel: '&Inspect it' 
							#value: #smalltalkInspectIt 
							#shortcutKeyCharacter: $I 
							#shortcutModifiers: 2 
							#labelImage: #(#{UI.ResourceRetriever} #{ToolbarIconLibrary} #inspectIt ) ) 
						#(#{UI.MenuItem} 
							#rawLabel: 'De&bug it' 
							#value: #smalltalkDebugIt 
							#shortcutKeyCharacter: $B 
							#shortcutModifiers: 2 
							#labelImage: #(#{UI.ResourceRetriever} #{ToolbarIconLibrary} #debugIt ) ) 
						#(#{UI.MenuItem} 
							#rawLabel: '&File it In' 
							#value: #smalltalkFileItIn ) 
						#(#{UI.MenuItem} 
							#rawLabel: '&Namespaces...' 
							#value: #editImports 
							#labelImage: #(#{UI.ResourceRetriever} #{ToolbarIconLibrary} #namespaces ) ) ) #(4 1 1 ) nil ) ) ) #(3 ) nil ) decodeAsLiteralArray!

windowSpec
	"UIPainter new openOnClass: self andSelector: #windowSpec"

	<resource: #canvas>
	^#(#{UI.FullSpec} 
		#window: 
		#(#{UI.WindowSpec} 
			#label: 'Workspace Outline' 
			#min: #(#{Core.Point} 128 156 ) 
			#max: #(#{Core.Point} 1600 1600 ) 
			#bounds: #(#{Graphics.Rectangle} 636 281 1099 790 ) ) 
		#component: 
		#(#{UI.SpecCollection} 
			#collection: #(
				#(#{UI.SequenceViewSpec} 
					#layout: #(#{Graphics.LayoutFrame} 0 0 0 0 0 1 -4 0.333333 ) 
					#name: #pageList 
					#model: #pageList 
					#menu: #listMenu 
					#useModifierKeys: true 
					#selectionType: #highlight ) 
				#(#{UI.SubCanvasSpec} 
					#layout: #(#{Graphics.LayoutFrame} 0 0 0 0.333333 0 1 0 1 ) 
					#name: #textView 
					#flags: 0 
					#clientKey: #textView ) 
				#(#{UI.ResizingSplitterSpec} 
					#layout: #(#{Graphics.LayoutFrame} 0 0 -4 0.333333 0 1 0 0.333333 ) 
					#name: #ResizingSplitter1 
					#flags: 8 
					#horizontal: true 
					#minAboveSize: 30 
					#minBelowSize: 30 
					#aboveWidgets: 'pageList' 
					#belowWidgets: 'textView' ) ) ) )! !

!Tools.ListWorkBook class methodsFor: 'utilities'!

catAllToWebPage
	"Take the directory of single web pages produced by the HTML output and concatenate them all onto 1 large web page (for printing)."
	"ListWorkBook catAllToWebPage"

	| dir in out toc hr string stream |
	dir := './Siren7.5/Workbook/'.
	toc := (dir, 'contents.txt') asFilename readStream.
	out := (dir, 'Siren7.5_Workbook.html') asFilename writeStream.
	in := (dir, 'index.html') asFilename.
	hr := '
<br><HR><br><br>
'.
	string := in contentsOfEntireFile.
	string := string copyReplaceAll: '"./' with: '"#'.
	string := string copyReplaceAll: '.html"'with: '"'.
	out nextPutAll: string.
	[toc atEnd] whileFalse:
		[ | fil |
		fil := toc upTo: Character cr.
		stream := (dir, fil, '.html') asFilename readStream.
		Transcript show: 'Processing ', (dir, fil, '.html'); cr.
		stream upToAll: '<!!-- START -->'.
		out nextPutAll: hr.
		out nextPutAll: '<A NAME="', fil, '">'; cr.
		out nextPutAll: (stream upToAll: '<!!-- END -->').
		stream close.
		].
	out nextPutAll: hr.
	out nextPutAll: '</BODY></HTML>
'.
	toc close.
	out close.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!


!Tools.ListWorkBook methodsFor: 'aspects'!

pageChanged

	| selection |
	selection := self pageHolder selection.
	lastInstalledPage notNil ifTrue:
		[lastInstalledPage deactivate.
		lastInstalledPage := nil].
	selection isNil ifTrue: [textView value: String new. ^self].
	self installPage: selection!

pageList
	"This method was generated by UIDefiner.  Any edits made here
	may be lost whenever methods are automatically defined.  The
	initialization provided below may have been preempted by an
	initialize method."

	^self pageHolder!

tabControl

	^(builder componentAt: #textView) widget!

textView

	^textView isNil
		ifTrue:
			[textView := String new asValue]
		ifFalse:
			[textView]! !

!Tools.ListWorkBook methodsFor: 'interface closing'!

requestForWindowClose
	"The ApplicationWindow's controller is checking to see if the 
	application is in a state such that it can be closed."

	(Dialog confirm: 'Are you certain you want to close this workbook?')
		ifFalse: [self open].
	^super requestForWindowClose! !

!Tools.ListWorkBook methodsFor: 'initialize-release'!

postBuildWith: aBuilder
	self pageHolder selectionIndexHolder
		onChangeSend: #pageChanged to: self! !