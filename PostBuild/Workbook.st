'From VisualWorks® Personal Use Edition, 8.3 of July 28, 2017 on May 16, 2020 at 4:53:41 AM'!


Smalltalk.Tools defineClass: #Workbook
	superclass: #{Tools.AbstractWorkspace}
	indexedType: #none
	private: false
	instanceVariableNames: 'pageHolder lastInstalledPage '
	classInstanceVariableNames: ''
	imports: ''
	category: 'Tools-Workspace'!

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!


!Tools.Workbook class methodsFor: 'examples'!

example1
	"Here is how to open a workbook with pages containing text."
	"self example1"

	| book |
	book := Workbook new.
	book 
		replaceAllTextPagesWith: "also get rid of the default 'Page 1'"
			(WorkspacePage 
				labeled: 'example1' 
				with: (self class compiledMethodAt: #example1) getSource);
		addAndSelectPage: "now add more pages"
			(WorkspacePage
				labeled: 'example2'
				with: (self class compiledMethodAt: #example2) getSource).
	book open!

example2
	"Here is how to open a workbook with pages containing text from files."
	"self example2"

	| book |
	book := Workbook new.
	book replaceAllTextPagesWith:
		(WorkspacePage filename: 'visual.cha' asFilename).
	book open!

example3
	"Here is how to open a workbook with pages containing text."
	"self example3"

	| book |
	book := Workbook new.
	book loadFromURL: 'http://www.create.ucsb.edu/Siren/Siren7.5_Workbook.bos'.
	book open! !

!Tools.Workbook class methodsFor: 'instance creation'!

on: aValueModel
	"Create a new workbook with a single text page
	that has aString as the label and aValueModel as the contents holder."

	| book |
	book := self new.
	book replaceAllTextPagesWith: (WorkspacePage on: aValueModel).
	^book!

on: aValueModel labeled: aString
	"Create a new workbook with a single text page
	that has aString as the label and aValueModel as the contents holder."

	| book |
	book := self new.
	book replaceAllTextPagesWith:
		(WorkspacePage labeled: aString on: aValueModel).
	^book!

with: aText
	"Create a new workbook with a single text page
	that has aString as the label and aText as the contents."

	| book |
	book := self new.
	book replaceAllTextPagesWith: (WorkspacePage with: aText).
	^book!

with: aText labeled: aString
	"Create a new workbook with a single text page
	that has aString as the label and aText as the contents."

	| book |
	book := self new.
	book replaceAllTextPagesWith: 
		(WorkspacePage labeled: aString with: aText).
	^book!

withFile: aFilenameOrString ifAbsent: aBlock
	"Create a new workbook with text from the specified file.
	If the file does not exist, create a workbook anyway with a
	page associated with that non-existent file, and with the result
	of evaluating aBlock (expected to be a String or a Text) as
	the initial contents."

	| book page |
	book := self new.
	page := [WorkspacePage filename: aFilenameOrString]
		on: OsError
		do: [:ex | ex return:
			(WorkspacePage 
				filename: aFilenameOrString 
				contents: aBlock value)].
	book replaceAllTextPagesWith: page.
	^book! !

!Tools.Workbook class methodsFor: 'system workbooks'!

openIntroductionWorkbook
	"Open a workbook with various getting started and introductions pages."
	"self openIntroductionWorkbook"

	| book |
	book := self new.
	book
		replaceAllTextPagesWith: WorkspacePage gettingStarted;
		addPage: WorkspacePage overview;
		addPage: WorkspacePage features;
		addPage: WorkspacePage introduction;
		open.
	book builder window label: 'Welcome to VisualWorks'!

openSystemWorkbook

	^self systemWorkbook open!

systemWorkbook

	^Workbook new
		replaceAllTextPagesWith: WorkspacePage installationWorkspacePage;
		addPage: WorkspacePage systemWorkspacePage;
		yourself! !

!Tools.Workbook class methodsFor: 'interface specs'!

windowSpec
	"Tools.UIPainter new openOnClass: self andSelector: #windowSpec"

	<resource: #canvas>
	^#(#{UI.FullSpec} 
		#window: 
		#(#{UI.WindowSpec} 
			#label: 
			#(#{Kernel.UserMessage} 
				#key: #Workspace 
				#defaultString: 'Workspace' 
				#catalogID: #labels ) 
			#min: #(#{Core.Point} 250 100 ) 
			#max: #(#{Core.Point} 0 0 ) 
			#bounds: #(#{Graphics.Rectangle} 474 368 1024 768 ) 
			#flags: 4 
			#menu: #menuBarHolder 
			#toolBar: #toolBar ) 
		#component: 
		#(#{UI.SpecCollection} 
			#collection: #(
				#(#{UI.TabControlSpec} 
					#layout: #(#{Graphics.LayoutFrame} 0 0 0 0 0 1 -25 1 ) 
					#name: #pages 
					#model: #pageHolder 
					#tabable: true 
					#labels: #() ) 
				#(#{UI.InputFieldSpec} 
					#layout: #(#{Graphics.LayoutFrame} 0 0 -24 1 -41 1 0 1 )
					#name: #pageExplanation 
					#model: #pageExplanationHolder 
					#tabable: false 
					#helpText: #(#{Kernel.UserMessage} #key: #ExplainCurrentPage #defaultString: 'Explanation of the current page' #catalogID: #labels) 
					#isReadOnly: true ) 
				#(#{UI.InputFieldSpec} 
					#layout: #(#{Graphics.LayoutFrame} -40 1 -24 1 0 1 0 1 ) 
					#name: #importSummary 
					#model: #importSummaryHolder 
					#tabable: false 
					#helpText: #(#{Kernel.UserMessage} #key: #NamespacesImportedHere #defaultString: 'Namespaces imported by this workspace' #catalogID: #labels) 
					#isReadOnly: true ) ) ) )! !

!Tools.Workbook class methodsFor: 'resources'!

editMenu
	"Tools.MenuEditor new openOnClass: self andSelector: #editMenu"

	<resource: #menu>
	^#(#{UI.Menu} #(
			#(#{UI.MenuItem} 
				#commandID: #find 
				#nameKey: #editFind 
				#value: #find ) 
			#(#{UI.MenuItem} 
				#commandID: #replace 
				#nameKey: #editReplace 
				#value: #replace ) 
			#(#{UI.MenuItem} 
				#commandID: #findNext 
				#value: #findNext 
				#enablementSelector: #isFindOpen ) 
			#(#{UI.MenuItem} 
				#commandID: #findPrevious 
				#value: #findPrevious 
				#enablementSelector: #isFindOpen ) 
			#(#{UI.MenuItem} 
				#commandID: #undo 
				#value: #undo 
				#enablementSelector: #canUndo ) 
			#(#{UI.MenuItem} 
				#commandID: #redo 
				#value: #redo 
				#enablementSelector: #canRedo ) 
			#(#{UI.MenuItem} 
				#rawLabel: 
				#(#{Kernel.UserMessage} 
					#key: #_Encoding 
					#defaultString: '&Encoding' 
					#catalogID: #menus ) 
				#nameKey: #editEncoding ) 
			#(#{UI.MenuItem} 
				#rawLabel: 
				#(#{Kernel.UserMessage} 
					#key: #_FileItIn 
					#defaultString: '&File it In' 
					#catalogID: #menus ) 
				#value: #smalltalkFileItIn ) 
			#(#{UI.MenuItem} 
				#rawLabel: 
				#(#{Kernel.UserMessage} 
					#key: #_NamespacesDot 
					#defaultString: '&Namespaces...' 
					#catalogID: #menus ) 
				#value: #editImports ) 
			#(#{UI.MenuItem} 
				#rawLabel: 
				#(#{Kernel.UserMessage} 
					#key: #Boss_InDot 
					#defaultString: 'Boss &In...' 
					#catalogID: #menus ) 
				#value: #bossIn 
				#enablementSelector: #canBOSSObjects ) 
			#(#{UI.MenuItem} 
				#rawLabel: 
				#(#{Kernel.UserMessage} 
					#key: #Boss_OutDot 
					#defaultString: 'Boss &Out...' 
					#catalogID: #menus ) 
				#value: #bossOut 
				#enablementSelector: #canBOSSObjects ) ) #(4 2 3 2 ) nil ) decodeAsLiteralArray!

menuBar
	"Tools.MenuEditor new openOnClass: self andSelector: #menuBar"

	<resource: #menu>
	^#(#{UI.Menu} #(
			#(#{UI.MenuItem} 
				#rawLabel: 
				#(#{Kernel.UserMessage} 
					#key: #_Page 
					#defaultString: '&Page' 
					#catalogID: #menus ) 
				#nameKey: #pageMenu 
				#submenu: #(#{UI.Menu} #(
						#(#{UI.MenuItem} 
							#commandID: #new 
							#rawLabel: 
							#(#{Kernel.UserMessage} 
								#key: #_New 
								#defaultString: '&New' 
								#catalogID: #menus ) 
							#nameKey: #fileNew 
							#value: #fileNew 
							#labelImage: #(#{UI.ResourceRetriever} #{WorkspaceIcons} #workspaceNew ) ) 
						#(#{UI.MenuItem} 
							#commandID: #open 
							#rawLabel: 
							#(#{Kernel.UserMessage} 
								#key: #_OpenDot 
								#defaultString: '&Open...' 
								#catalogID: #menus ) 
							#nameKey: #fileOpen 
							#value: #fileOpen 
							#labelImage: #(#{UI.ResourceRetriever} #{WorkspaceIcons} #workspaceOpen ) ) 
						#(#{UI.MenuItem} 
							#commandID: #save 
							#rawLabel: 
							#(#{Kernel.UserMessage} 
								#key: #_Save 
								#defaultString: '&Save' 
								#catalogID: #menus ) 
							#nameKey: #fileSave 
							#value: #fileSave 
							#enablementSelector: #isAtTextPage 
							#labelImage: #(#{UI.ResourceRetriever} #{WorkspaceIcons} #workspaceSave ) ) 
						#(#{UI.MenuItem} 
							#commandID: #saveAs 
							#rawLabel: 
							#(#{Kernel.UserMessage} 
								#key: #Save_AsDot 
								#defaultString: 'Save &As...' 
								#catalogID: #menus ) 
							#nameKey: #fileSaveAs 
							#value: #fileSaveAs 
							#enablementSelector: #isAtTextPage ) 
						#(#{UI.MenuItem} 
							#rawLabel: 
							#(#{Kernel.UserMessage} 
								#key: #_RenameDot 
								#defaultString: '&Rename...' 
								#catalogID: #menus ) 
							#nameKey: #pageRename 
							#value: #pageRename 
							#enablementSelector: #canRenamePage ) 
						#(#{UI.MenuItem} 
							#rawLabel: 
							#(#{Kernel.UserMessage} 
								#key: #_TearOff 
								#defaultString: '&Tear Off' 
								#catalogID: #menus ) 
							#nameKey: #pageTearOff 
							#value: #pageTearOff 
							#enablementSelector: #isAtTextPage ) 
						#(#{UI.MenuItem} 
							#rawLabel: 
							#(#{Kernel.UserMessage} 
								#key: #Re_move 
								#defaultString: 'Re&move' 
								#catalogID: #menus ) 
							#nameKey: #pageClose 
							#value: #pageClose 
							#enablementSelector: #canClosePage ) ) #(1 3 3 ) nil ) ) 
			#(#{UI.MenuItem} 
				#rawLabel: 
				#(#{Kernel.UserMessage} 
					#key: #_Edit 
					#defaultString: '&Edit' 
					#catalogID: #menus ) 
				#nameKey: #editMenu ) 
			#(#{UI.MenuItem} 
				#rawLabel: 
				#(#{Kernel.UserMessage} 
					#key: #_Options 
					#defaultString: '&Options' 
					#catalogID: #menus ) 
				#nameKey: #optionsMenu 
				#submenu: #(#{UI.Menu} #(
						#(#{UI.MenuItem} 
							#rawLabel: 
							#(#{Kernel.UserMessage} 
								#key: #_Toolbar 
								#defaultString: '&Toolbar' 
								#catalogID: #menus ) 
							#nameKey: #toolbar 
							#value: #toggleToolbar 
							#indication: true ) 
						#(#{UI.MenuItem} 
							#rawLabel: 
							#(#{Kernel.UserMessage} 
								#key: #_StatusBar 
								#defaultString: '&Status Bar' 
								#catalogID: #menus ) 
							#nameKey: #toggleStatusBar 
							#value: #toggleStatusBar ) 
						#(#{UI.MenuItem} 
							#rawLabel: 'Style as Smalltalk' 
							#value: #styleAsSmalltalk 
							#indication: false 
							#indicationSelector: #isStyledAsSmalltalk ) ) #(2 1 ) nil ) ) ) #(3 ) nil ) decodeAsLiteralArray!

toolBar
	"Tools.MenuEditor new openOnClass: self andSelector: #toolBar"

	<resource: #menu>
	^#(#{UI.Menu} #(
			#(#{UI.MenuItem} 
				#rawLabel: 
				#(#{Kernel.UserMessage} 
					#key: #New 
					#defaultString: 'New' 
					#catalogID: #menus ) 
				#value: #fileNew 
				#labelImage: #(#{UI.ResourceRetriever} #{WorkspaceIcons} #workspaceNew ) 
				#helpText: 
				#(#{Kernel.UserMessage} 
					#key: #New 
					#defaultString: 'New' 
					#catalogID: #menus ) ) 
			#(#{UI.MenuItem} 
				#rawLabel: 
				#(#{Kernel.UserMessage} 
					#key: #Open 
					#defaultString: 'Open' 
					#catalogID: #menus ) 
				#value: #fileOpen 
				#labelImage: #(#{UI.ResourceRetriever} #{WorkspaceIcons} #workspaceOpen ) 
				#helpText: 
				#(#{Kernel.UserMessage} 
					#key: #Open 
					#defaultString: 'Open' 
					#catalogID: #menus ) ) 
			#(#{UI.MenuItem} 
				#rawLabel: 
				#(#{Kernel.UserMessage} 
					#key: #Save 
					#defaultString: 'Save' 
					#catalogID: #menus ) 
				#nameKey: #fileSave 
				#value: #fileSave 
				#labelImage: #(#{UI.ResourceRetriever} #{WorkspaceIcons} #workspaceSave ) 
				#helpText: 
				#(#{Kernel.UserMessage} 
					#key: #Save 
					#defaultString: 'Save' 
					#catalogID: #menus ) ) 
			#(#{UI.MenuItem} 
				#rawLabel: 
				#(#{Kernel.UserMessage} 
					#key: #Cut 
					#defaultString: 'Cut' 
					#catalogID: #menus ) 
				#nameKey: #cut 
				#value: #cut 
				#labelImage: #(#{UI.ResourceRetriever} #{Tools.GeneralIcons} #editCut ) 
				#helpText: 
				#(#{Kernel.UserMessage} 
					#key: #Cut 
					#defaultString: 'Cut' 
					#catalogID: #menus ) ) 
			#(#{UI.MenuItem} 
				#rawLabel: 
				#(#{Kernel.UserMessage} 
					#key: #Copy 
					#defaultString: 'Copy' 
					#catalogID: #menus ) 
				#nameKey: #copy 
				#value: #copySelection 
				#labelImage: #(#{UI.ResourceRetriever} #{Tools.GeneralIcons} #editCopy ) 
				#helpText: 
				#(#{Kernel.UserMessage} 
					#key: #Copy 
					#defaultString: 'Copy' 
					#catalogID: #menus ) ) 
			#(#{UI.MenuItem} 
				#rawLabel: 
				#(#{Kernel.UserMessage} 
					#key: #Paste 
					#defaultString: 'Paste' 
					#catalogID: #menus ) 
				#nameKey: #paste 
				#value: #paste 
				#labelImage: #(#{UI.ResourceRetriever} #{Tools.GeneralIcons} #editPaste ) 
				#helpText: 
				#(#{Kernel.UserMessage} 
					#key: #Paste 
					#defaultString: 'Paste' 
					#catalogID: #menus ) ) 
			#(#{UI.MenuItem} 
				#rawLabel: 
				#(#{Kernel.UserMessage} 
					#key: #DoIt 
					#defaultString: 'Do it' 
					#catalogID: #menus ) 
				#value: #smalltalkDoIt 
				#labelImage: #(#{UI.ResourceRetriever} #{Tools.GeneralIcons} #doIt ) 
				#helpText: 
				#(#{Kernel.UserMessage} 
					#key: #DoIt 
					#defaultString: 'Do it' 
					#catalogID: #menus ) ) 
			#(#{UI.MenuItem} 
				#rawLabel: 
				#(#{Kernel.UserMessage} 
					#key: #PrintIt 
					#defaultString: 'Print it' 
					#catalogID: #menus ) 
				#value: #smalltalkPrintIt 
				#labelImage: #(#{UI.ResourceRetriever} #{Tools.GeneralIcons} #printIt ) 
				#helpText: 
				#(#{Kernel.UserMessage} 
					#key: #PrintIt 
					#defaultString: 'Print it' 
					#catalogID: #menus ) ) 
			#(#{UI.MenuItem} 
				#rawLabel: 
				#(#{Kernel.UserMessage} 
					#key: #InspectIt 
					#defaultString: 'Inspect it' 
					#catalogID: #menus ) 
				#value: #smalltalkInspectIt 
				#labelImage: #(#{UI.ResourceRetriever} #{Tools.GeneralIcons} #inspectIt ) 
				#helpText: 
				#(#{Kernel.UserMessage} 
					#key: #InspectIt 
					#defaultString: 'Inspect it' 
					#catalogID: #menus ) ) 
			#(#{UI.MenuItem} 
				#rawLabel: 
				#(#{Kernel.UserMessage} 
					#key: #DebugIt 
					#defaultString: 'Debug it' 
					#catalogID: #menus ) 
				#value: #smalltalkDebugIt 
				#labelImage: #(#{UI.ResourceRetriever} #{Tools.GeneralIcons} #debugIt ) 
				#helpText: 
				#(#{Kernel.UserMessage} 
					#key: #DebugIt 
					#defaultString: 'Debug it' 
					#catalogID: #menus ) ) ) #(3 3 4 ) nil ) decodeAsLiteralArray! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!


Tools.Workbook comment:
'This is the new-style (as of 5i.4) workspace.  It consists of a number of text pages selected using a tab control, as well as a separate page for workspace local variables.

Instance Variables:

	pageHolder	<SelectionInList>	Pages currently contained by this workspace. Pages are instances of either WorkspacePage (text pages) or WorkspaceInspectorPage (variable page). A workbook contains one or more text pages followed by one variable page.
	lastInstalledPage	<WorkspacePage | WorkspaceInspectorPage>	The current page of the workspace. Preserved so the action triggered on a page change can refer to the previous page.'!

!Tools.Workbook methodsFor: 'actions'!

bossOutAll
	"Boss out the page list"

	| nameString boss stream coll |
	nameString := Dialog 
		requestFileNameWithMessage: (#BOSSOutToC << #dialogs >> 'BOSS Out To:') 
		default: 'Workbook.bos'
		version: #new
		ifFail: ['']
		for: nil.
	nameString isEmpty ifTrue: [^self].
	stream := nameString asFilename writeStream.
	coll := self pages collection.
	coll := coll copyFrom: 1 to: coll size - 1.
	[boss := #{BinaryObjectStorage} value onNew: stream.
		boss nextPut: coll] 
			ensure: [stream close]!

fileNew

	self addAndSelectPage: (WorkspacePage labeled: self pickUniquePageLabel)!

fileOpen

	| nameString |
	nameString := Dialog requestFileName: (#OpenFileNamedColon << #dialogs >> 'Open file named: ') default: '*.ws'.
	nameString isEmpty ifTrue: [^self].
	self addAndSelectPage: (WorkspacePage filename: nameString asFilename)!

htmlOutAll
	"Create a directory and save all the receiver's pages there as HTML files."

	| nam folder toc list |
	nam := Dialog 
		requestNewFileName: 'Save the workbook to directory' 
		default: 'Workbook'.
	nam isEmpty ifTrue: [^self].
	folder := Filename named: nam.
	folder exists
		ifTrue: [folder isDirectory
			ifFalse: [Dialog warn: 'File exists and is not a directory.'.
				^self]]
		ifFalse: [folder makeDirectory].
	toc := (folder asString, Filename separator asString, 'index.html') asFilename writeStream.
	list := (folder asString, Filename separator asString, 'contents.txt') asFilename writeStream.
	list nextPutAll: 'cat index.html '.
	self writeHTMLHeaderTo: toc.
	1 to: self pages size - 1 do:
		[ :index | | pa ti fn text |
		pa := self pages at: index.
"		Transcript show: 'Save: ', pa label; cr."
		ti := pa label copyReplaceAll: ' ' with: '_'.
		fn := folder asString, Filename separator asString, ti, '.html'.
		text := pa getText.
		Smalltalk.Heeg.HtmlWriter write: text into: fn.
		toc nextPutAll: ('<LI><A HREF="./', ti, '.html">', pa label, '</a>'); cr.
		list nextPutAll: ti, '.html '].
	self writeHTMLTrailerTo: toc.
	toc close.
	list nextPutAll: '>> Workbook.html'; cr.
	list close!

loadAll
	"Open a directory and read a set of pages from."

	| nam fil toc |
	nam := Dialog 
		requestFileName: 'Load a workbook from a file or directory' 
		default: 'Workbook.bos'.
	nam isEmpty ifTrue: [^self].
	fil := Filename named: nam.
	fil exists
		ifFalse: [Dialog warn: 'File/fil does not exist.'. ^self].
"if it's a file -- try BOSS"
	fil isDirectory
		ifFalse: [^self loadFromBoss: fil].
"Otherwise, assume it's a workbok folder"
	toc := (fil asString, Filename separator asString, 'TableOfContents.txt') asFilename readStream.
	[toc atEnd] whileFalse:
		[ | lin fnam pg |
		lin := toc upTo: Character cr.
		('*.ws' match: lin)
			ifTrue: [fnam := lin copyFrom: 1 to: lin size - 3]
			ifFalse: [fnam := lin].
		fnam := fnam copyReplaceAll: '_' with: ' '.
		pg := WorkspacePage labeled:  fnam.
		self addAndSelectPage: pg.
		pg contents: (fil asString, Filename separator asString, lin) asFilename contentsOfEntireFile].
	toc close.!

loadFromBoss: nameString
	"Load the outline from a BOSS file"

	| boss stream list vars |
	stream := nameString asFilename readStream.
	list := self pageHolder list.
	list removeFirst.			"remove the default page 1"
	vars := list removeFirst.	"hold onto the variables page"
	[ | arr |
		boss := #{BinaryObjectStorage} value onOldNoScan: stream.
		arr := boss next.
		arr do: [ :item | | pg |
		pg := WorkspacePage labeled:  item first.
		self addAndSelectPage: pg.
		pg contents: item last]]
			ensure: [stream close].
	list addLast: vars.
	self selectPageNumber: 1!

loadFromURL: nameString
	"Load the outline from a BOSS file taken from the given URL"
	"(ListWorkBook new 
			loadFromURL: 'http://www.create.ucsb.edu/Siren/Siren7.5_Workbook.bos') open "

	| nam stream ostrm |
	nam := 'wb_tmp.bos'.
	stream := (Net.HttpClient get: nameString) contents readStream binary.
	stream reset.
	ostrm := nam asFilename writeStream binary.
	[stream atEnd] whileFalse: [ostrm nextPut: stream next asInteger].
	ostrm close.
	self loadFromBoss: nam.
	nam asFilename delete.
	self selectPageNumber: 1!

pageClose

	self canClosePage ifFalse: [self error: (#errCannotCloseThisPage << #dialogs >> 'cannot close this page')].
	self currentTextPage changeRequest ifFalse: [^self].
	self removePage: self currentTextPage!

pageRename

	| newLabel current |
	self canRenamePage ifFalse: [self error: (#errCannotRenameThisPage << #dialogs >> 'cannot rename this page')].
	current := self currentPage.
	newLabel := Dialog 
		request: (#RenameThisPageAsColon << #dialogs >> 'Rename this page as:') 
		initialAnswer: current label.
	newLabel isEmpty ifTrue: [^self].
	current label: newLabel.
	self pages changed: #at: with: self pageHolder selectionIndex!

pageTearOff
	"Remove the current text page from the workbook and open it
	as a separate workspace (not a workbook). If this was the last text
	page, close the current workbook. The new window should have
	reasonable size and position--that is same size as the original workbook
	and either same or cascaded position, depending on whether the
	workbook stays or goes. With the MPUI introduction, if the original window
	is closed, it should be done *after* opening the new one."

	| thisPage workspace bounds wasLastPage |
	bounds := self builder window displayBox.
	thisPage := self currentTextPage.
	thisPage deactivate.
	workspace := Workspace new textPage: thisPage.
	locals keysAndValuesDo:
		[:key :value | workspace addLocal: key value: value].
	wasLastPage := self textPageCount <= 1.
	wasLastPage ifFalse:
		[self removePage: thisPage.
		bounds := Screen default makeRectangleVisible:
			(bounds copy moveBy: 20@20)].
	workspace 
		allButOpenInterface: #windowSpec;
		finallyOpenIn: bounds withType: #normal.
	wasLastPage ifTrue:
		[self builder window controller closeAndUnschedule]!

saveAll
	"Create a directory and save all the receiver's pages there."

	| sel nam folder toc |
	sel := (Menu labelArray: #('save as BOSS file' 'save as HTML pages' 'save as text files')) startUp.
	(sel = 0) ifTrue: [^self].
	(sel = 1) ifTrue: [^self bossOutAll].
	(sel = 2) ifTrue: [^self htmlOutAll].
	nam := Dialog 
		requestNewFileName: 'Save the workbook to directory' 
		default: 'Workbook'.
	nam isEmpty ifTrue: [^self].
	folder := Filename named: nam.
	folder exists
		ifTrue: [folder isDirectory
			ifFalse: [Dialog warn: 'File exists and is not a directory.'.
				^self]]
		ifFalse: [folder makeDirectory].
	toc := (folder asString, Filename separator asString, 'TableOfContents.txt') 
			asFilename writeStream.
	self pages do:
		[ :pa | | fn |
"		Transcript show: 'Save: ', pa label; cr."
		(pa respondsTo: #setFilename:)
			ifTrue: [ fn := pa label copyReplaceAll: ' ' with: '_'.
				pa setFilename: (folder asString, Filename separator asString, 
							fn, '.ws') asFilename.
			self selectPage: pa.
			pa acceptText.
			toc nextPutAll: (fn, '.ws'); cr]].
	toc close.! !

!Tools.Workbook methodsFor: 'private-pages'!

currentPage

	^lastInstalledPage!

currentTextPage

	self isAtTextPage ifFalse: [self error: (#errNotAtTextPage << #dialogs >> 'not at text page')].
	^self currentPage!

installPage: aWorkspacePage

	lastInstalledPage := aWorkspacePage.
	aWorkspacePage builder: nil.
	self tabControl
		client: aWorkspacePage
		spec: #windowSpec
		builder: builder newSubBuilder.
	self updatePage.
	aWorkspacePage refresh!

isAtTextPage
	"Text pages are all pages except the last."

	^self pageHolder selectionIndex < self pageHolder list size!

textPageCount
	"One of the pages is the Variables page; all others are text."

	^self pages size - 1! !

!Tools.Workbook methodsFor: 'private'!

buildMenuBar

	| menu |
	menu := super buildMenuBar.
	(menu atNameKey: #editMenu) submenu: [self editMenu].
	^menu!

editMenu

	| menu contextMenu |
	menu := self class editMenu.
	(menu atNameKey: #editEncoding) submenu: [self buildEncodingSubmenu].
	self isAtTextPage ifFalse: [^menu].
	self currentPage ifNil: [^menu].
	self currentPage documentWidget ifNil: [^menu].
	contextMenu := self currentPage documentMenu value copy.
	contextMenu augmentFrom: self class to: AbstractWorkspace menuName: #editMenu for: self.
	contextMenu menuItems do: 
			[:each |
			each actionPerformer: [self currentPage documentWidget].
			each value: 
					[self currentPage documentWidget handleEvent: (CommandEvent menuItem: each)]].
	(contextMenu menuItemForCommandID: #selectAll)
		ifNotNil: [:menuItem | menuItem visible: [true]].
	^menu copy
		addPart: contextMenu;
		yourself!

hibernate

	self pageHolder selectionIndex: 0!

pickUniquePageLabel

	| labels suffix label |
	labels := self pages collect: [:each | each displayString].
	suffix := 1.
	[label := ((#Page1s << #dialogs >> 'Page <1s>')
			expandMacrosWith: suffix printString).
	labels includes: label] 
		whileTrue: [suffix := suffix + 1].
	^label!

suggestSaving: pageCollection

	| messageStream wordsOnThisLine |
	messageStream := (String new: 100) writeStream.
	wordsOnThisLine := 1.
	messageStream nextPutAll: (#SomePagesNeedSaved << #dialogs >> 'The following pages have unsaved changes:') asString; cr.
	pageCollection 
		do: [:each | 
			wordsOnThisLine > 5 ifTrue:
				[messageStream cr.
				wordsOnThisLine := 0].
			wordsOnThisLine := wordsOnThisLine + 1.
			messageStream 
				nextPut: $"; 
				nextPutAll: each displayString;
				nextPut: $"]
		separatedBy: [messageStream nextPutAll: ', '].
	messageStream nextPutAll: '.'; cr; nextPutAll: (#SaveChangesBeforeClosing << #dialogs >> 'Save changes before closing the window?') asString.
	^Dialog 
		choose: messageStream contents
		labels: (Array with: (#Yes << #dialogs >> 'Yes') with: (#No << #dialogs >> 'No') with: (#Cancel << #dialogs >> 'Cancel'))
		values: #(yes no cancel)
		default: #yes!

tabControl

	^(builder componentAt: #pages) widget!

updatePage: aPage
	"Page-related things such as labels may have changed for the current page."

	| pages reselect dummy |
	reselect := self currentPage == aPage.
	pages := self pages.
	pages replaceAll: aPage with: (dummy := WorkspacePage new).
	pages replaceAll: dummy with: aPage.
	reselect ifTrue: [self pageHolder selection: aPage].
	self updatePage!

writeHTMLHeaderTo: strm

	strm nextPutAll: '<HTML>
<HEAD>
<TITLE>The Siren Workbook</TITLE>
</HEAD>
<BODY BGCOLOR="#ffffcc">
<H2>The Siren Workbook</H2>
<H3>Outline</H3>
<UL>
'!

writeHTMLTrailerTo: strm

	strm nextPutAll: '</UL>
<P>
<A HREF="http://FASTLabInc.com/Siren">Go to the Siren Home Page</A>
<P>
<HR>
<P>
</BODY>
</HTML>
'! !

!Tools.Workbook methodsFor: 'initialize-release'!

initialize

	super initialize.
	self pageHolder
		list: (List 
			with: ((WorkspacePage labeled: (#Page1 << #dialogs >> 'Page 1')) workspace: self)
			with: (WorkspaceInspectorPage withInspectorOn: locals))!

postBuildWith: aBuilder

	| offset |
	
	super postBuildWith: aBuilder.

	"- 1 to make the borders collapse"
	offset := self statusBarHeight - 1.
	
	(builder componentAt: #pages) component layout bottomOffset: [
		statusBarVisible ifTrue: [ offset negated ] ifFalse: [ 0 ].
	].

	"Because of the way layout works, the status items are fixed height, relative to the bottom offset."
	(builder componentAt: #pageExplanation) component layout topOffset: [
		statusBarVisible ifTrue: [ offset negated ] ifFalse: [ 0 ].
	].
	(builder componentAt: #pageExplanation) component layout bottomOffset: [
		statusBarVisible ifTrue: [ 0 ] ifFalse: [ offset ].
	].
	(builder componentAt: #importSummary) component layout topOffset: [
		statusBarVisible ifTrue: [ offset negated ] ifFalse: [ 0 ].
	].
	(builder componentAt: #importSummary) component layout bottomOffset: [
		statusBarVisible ifTrue: [ 0 ] ifFalse: [ offset ].
	].

	self pageHolder selectionIndexHolder onChangeSend: #pageChanged to: self!

postOpenWith: aBuilder

	super postOpenWith: aBuilder.
	self pageHolder selection: self pageHolder list first! !

!Tools.Workbook methodsFor: 'aspects'!

pageHolder
	"This method was generated by UIDefiner.  Any edits made here
	may be lost whenever methods are automatically defined.  The
	initialization provided below may have been preempted by an
	initialize method."

	^pageHolder isNil
		ifTrue:
			[pageHolder := SelectionInList new]
		ifFalse:
			[pageHolder]! !

!Tools.Workbook methodsFor: 'accessing'!

addAndSelectPage: aWorkspacePage

	self addPage: aWorkspacePage.
	self pageHolder selection: aWorkspacePage!

addPage: aWorkspacePage
	"The Variables page always remains the last, so any new page
	always ends up being one before the last."

	| otherPage |
	otherPage := self currentPage.
	aWorkspacePage workspace: self.
	otherPage isNil
		ifTrue: [self pages addLast: aWorkspacePage]
		ifFalse: [self pages add: aWorkspacePage after: otherPage]!

changeRequest

	| unsaved choice |
	unsaved := self pages reject: [:some | some isAccepted].
	unsaved isEmpty ifTrue: [^true].
	choice := self suggestSaving: unsaved.
	choice = #no ifTrue: [^true].
	choice = #cancel ifTrue: [^false].
	"The choice is #yes, i.e. save all"
	unsaved do: [:each | each saveIntoFile ifFalse: [^false]].
	^true!

pageChanged

	| selection |
	selection := self pageHolder selection.
	lastInstalledPage notNil ifTrue:
		[lastInstalledPage deactivate.
		lastInstalledPage := nil].
	selection isNil ifTrue: [^self].
	self installPage: selection!

pages

	^self pageHolder list!

removePage: aWorkspacePage

	self pages remove: aWorkspacePage!

replaceAllTextPagesWith: aPage

	| inspectorPage removed |
	inspectorPage := self pages last.
	aPage workspace: self.
	removed := self pages removeAllSuchThat: [:page | page ~~ inspectorPage].
	removed do: [:each | each release].
	self pages addFirst: aPage!

selectPage: pa

	self pageHolder selection: pa!

selectPageLabeled: userMessageOrString

	self pageHolder selection: 
		(self pages 
			detect: [:aPage | aPage label asString = userMessageOrString asString]
			ifNone: [^self])!

selectPageNumber: index

	self pageHolder selectionIndex: index! !

!Tools.Workbook methodsFor: 'private-testing'!

canClosePage

	^self isAtTextPage and: [self textPageCount > 1]!

canRedo

	^self isAtTextPage and: [self currentPage canRedo]!

canRenamePage

	^self isAtTextPage!

canUndo

	^self isAtTextPage and: [self currentPage canUndo]!

isFindOpen

	^self isAtTextPage and: [self currentPage isFindOpen]! !

!Tools.Workbook methodsFor: 'privileged'!

statusBarHeight

	^(builder componentAt: #pageExplanation) intrinsicHeight! !