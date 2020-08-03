<?xml version="1.0"?>

<st-source>
<time-stamp>From VisualWorks® Personal Use Edition, 8.3 of July 28, 2017 on May 20, 2020 at 5:01:44 PM</time-stamp>


<class>
<name>VisualLauncher</name>
<environment>Tools</environment>
<super>UI.ApplicationModel</super>
<private>false</private>
<indexed-type>none</indexed-type>
<inst-vars>menuBar toolBar textCollector transcriptView statusBar </inst-vars>
<class-inst-vars></class-inst-vars>
<imports></imports>
<category>Tools-Misc</category>
<attributes>
<package>Tools-Misc</package>
</attributes>
</class>

<!-- -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -   -->


<methods>
<class-id>Tools.VisualLauncher class</class-id> <category>class initialization</category>

<body package="Tools-Misc" selector="classMethodsChanged">classMethodsChanged	^self instanceMethodsChanged</body>

<body package="Tools-Misc" selector="instanceMethodsChanged">instanceMethodsChanged	"A Menu has changed.  Update all open Launcher menus and toolbars."	Screen default allScheduledControllersDo: [:each | 		(each model isKindOf: self) ifTrue: 			[[each model				installMenuRangeRestrictions;				rebuildMenu;				updateToolbar;				updateStatusBar] uiEventNowFor: each view]]</body>
</methods>

<methods>
<class-id>Tools.VisualLauncher class</class-id> <category>interface specs</category>

<body package="Tools-Misc" selector="interfaceSpecFor:">interfaceSpecFor: aSymbol	| spec |	spec := super interfaceSpecFor: aSymbol.	aSymbol == #windowSpec		ifTrue: [spec window toolBar: #launcherToolBar].	^spec</body>

<body package="Tools-Misc" selector="windowSpec">windowSpec	"Tools.UIPainter new openOnClass: self andSelector: #windowSpec"	&lt;resource: #canvas&gt;	^#(#{UI.FullSpec} 		#window: 		#(#{UI.WindowSpec} 			#properties: #(#{UI.PropertyListDictionary} #labelFromApplication true ) 			#label: 'VisualWorks team' 			#min: #(#{Core.Point} 300 125 ) 			#max: #(#{Core.Point} 0 0 ) 			#bounds: #(#{Graphics.Rectangle} 1029 619 1529 819 ) 			#flags: 4 			#menu: #launcherMenuBar ) 		#component: 		#(#{UI.SpecCollection} 			#collection: #(				#(#{UI.SubCanvasSpec} 					#layout: #(#{Graphics.LayoutFrame} 0 0 0 0 0 1 -25 1 ) 					#name: #transcript 					#flags: 0 					#majorKey: #{VisualTranscript} 					#minorKey: #windowSpec 					#clientKey: #transcriptView ) 				#(#{UI.SubCanvasSpec} 					#layout: #(#{Graphics.LayoutFrame} 0 0 -25 1 0 1 0 1 ) 					#name: #statusBar 					#flags: 0 ) ) ) )</body>
</methods>

<methods>
<class-id>Tools.VisualLauncher class</class-id> <category>generated resources</category>

<body package="Tools-Misc" selector="allClassesIcon">allClassesIcon		^ToolbarIconLibrary visualFor: #classBrowser</body>

<body package="Tools-Misc" selector="allParcelsIcon">allParcelsIcon	^ToolbarIconLibrary visualFor: #parcelBrowser</body>

<body package="Tools-Parcel Manager" selector="cardfile">cardfile	^ToolbarIconLibrary visualFor: #cardfile</body>

<body package="Tools-Misc" selector="dbToolIcon">dbToolIcon	^ToolbarIconLibrary visualFor: #database</body>

<body package="Tools-Misc" selector="extFinderIcon">extFinderIcon	^ToolbarIconLibrary visualFor: #cpokBrowser</body>

<body package="Tools-Misc" selector="fileListIcon">fileListIcon	^ToolbarIconLibrary visualFor: #fileFinder</body>

<body package="UIPainter" selector="finderIcon">finderIcon	^ToolbarIconLibrary visualFor: #resourceFinder</body>

<body package="Tools-Misc" selector="helpIcon">helpIcon	^ToolbarIconLibrary visualFor: #thought</body>

<body package="Tools-Misc" selector="newCanvasIcon">newCanvasIcon	^ToolbarIconLibrary visualFor: #canvas</body>

<body package="Tools-Settings-VW" selector="properties">properties	^ToolbarIconLibrary visualFor: #properties</body>

<body package="Tools-Misc" selector="systemIcon">systemIcon	^ToolbarIconLibrary visualFor: #systemBrowser</body>

<body package="Tools-Misc" selector="workspaceIcon">workspaceIcon	^ToolbarIconLibrary visualFor: #workspace</body>
</methods>

<methods>
<class-id>Tools.VisualLauncher class</class-id> <category>accessing</category>

<body package="Tools-Misc" selector="checkInstalledComponents">checkInstalledComponents	"Get all open Launchers to update their buttons, menus etc so	 that they accurately reflect the current set of loaded components.	 This is usually used on load and unload of any component that is	 accessible via the Launcher."	"VisualLauncher checkInstalledComponents"	ScheduledWindow scheduledControllers do: 		[:each | 		(each model isKindOf: self) ifTrue: [each model enableConnections]]</body>

<body package="Tools-Misc" selector="raiseOrOpen">raiseOrOpen	"This is used by the warp-to-launcher hot key feature	which runs at priority 90. If opening a new launcher,	make sure it runs at a more reasonable one."	self raiseSingleInstance ifNil: 		[[self open] forkAt: Processor userSchedulingPriority]</body>

<body package="Non-Commercialization" selector="title">title	"Return a title for the launcher which includes the image name"	^(#VWLauncherLabelPersonal &lt;&lt; #labels &gt;&gt; 'VisualWorks Personal Use &lt;1s&gt;') expandMacrosWith: ObjectMemory imagePrefix</body>
</methods>

<methods>
<class-id>Tools.VisualLauncher class</class-id> <category>private</category>

<body package="Tools-Misc" selector="statusPragmas">statusPragmas	&lt;pragmas: #instance&gt;	^ToolBarView pragmas</body>
</methods>

<methods>
<class-id>Tools.VisualLauncher class</class-id> <category>interface opening</category>

<body package="Tools-Misc" selector="open">open	^[super open]		on: GetWindowManagerUsagePolicy		do: [:ex | ex resume: MakeNewWindowManagerUsagePolicy new]</body>
</methods>

<methods>
<class-id>Tools.VisualLauncher class</class-id> <category>fileIn/Out</category>

<body package="Tools-Misc" selector="prerequisitesForLoading">prerequisitesForLoading	"List those classes that must be filed or BOSSed into the system before I can be loaded.	 Include ToolbarIconLibrary to help ensure that extensions to the launcher load."	^(super prerequisitesForLoading)		add: ToolbarIconLibrary class;		yourself</body>
</methods>

<methods>
<class-id>Tools.VisualLauncher class</class-id> <category>resources</category>

<body package="UIPainter" selector="BWAppFinder24">BWAppFinder24	"UIMaskEditor new openOnClass: self andSelector: #BWAppFinder24"	&lt;resource: #image&gt;	^CachedImage on: (Image extent: 24@24 depth: 1 bitsPerPixel: 1 palette: CoveragePalette monoMaskPalette usingBits: #[0 0 0 0 127 255 254 0 64 0 2 0 127 255 250 0 127 255 250 0 95 255 250 0 84 0 10 0 74 0 10 0 73 255 106 0 72 137 106 0 72 127 10 0 68 41 106 0 68 31 106 0 68 9 10 0 68 5 106 0 68 3 106 0 68 1 10 0 71 240 138 0 65 254 74 0 64 15 42 0 64 1 242 0 64 0 122 0 127 255 254 0 0 0 0 0 ])</body>

<body package="UIPainter" selector="CGAppFinder24">CGAppFinder24	"UIMaskEditor new openOnClass: self andSelector: #CGAppFinder24"	&lt;resource: #image&gt;	^CachedImage on: (Image extent: 24@24 depth: 3 bitsPerPixel: 4 palette: (MappedPalette withColors: ((Array new: 8) at: 1 put: ColorValue black; at: 2 put: (ColorValue scaledRed: 4369 scaledGreen: 4369 scaledBlue: 4369); at: 3 put: (ColorValue scaledRed: 6553 scaledGreen: 6553 scaledBlue: 6553); at: 4 put: (ColorValue scaledRed: 3822 scaledGreen: 3822 scaledBlue: 3822); at: 5 put: ColorValue white; at: 6 put: ColorValue cyan; at: 7 put: ColorValue yellow; at: 8 put: ColorValue blue; yourself)) usingBits: (ByteArray fromPackedString: 'H"H"H"H"H"H"H"H"H@@@@@@@@@@@@@@BHEIRT%H%IRIRT%TBH@L@@@@@@@@@@@HBH@A7]7]7]7]7]0TBHE@C@@@@@@@@@@HBHB@ Y&amp;Y&amp;Y&amp;Y&amp;Y TBHEHBA&amp;Y&amp;Y&amp;Y&amp;Y HBHBTDHCL3L3M#M TBHEHBP QDMDM#M HBHBTDIB@3L3M&amp;Y TBHEIPP$HDMDM#M HBHBT QBP L3M#M TBHEIPQDIBADM&amp;Y HBHBT IDP$HDM#M TBHEIPH$QBP M#M HBHBT H"QDIBA&amp;Y HBHEIP@@@@P$HFY TBHBT%HQDQ@@P Y HBHEIRT%H%DQ@BA TBHBT%IRURT%DP@EHBHEIRT%H%IRIQD@TBH@@@@@@@@@@@@@@BH"H"H"H"H"H"H"H"'))</body>
</methods>

<!-- -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -   -->


<comment>
<class-id>Tools.VisualLauncher</class-id>
<body>VisualLauncher provides complete and convenient access to the VisualWorks functionality. It enables the user to save the image, change system settings, access Smalltalk programming tools, database application development tools, UIPainter and its auxiliary tools, manage multiple windows and access the VW Online Documentation. ValueHolders for the menuBar and toolBar provide convenient access these items, but either must be augmented as desired by other components using the appropriate menu pragmas.  Some menus allow menu augmentation only in restricted sections.  Restricting menu ranges in this way is limited to the private, exclusive use of VisualWorks core components.VisualLauncher openInstance Variables	menuBar		&lt;ValueHolder&gt; The menu for the main window of VisualWorks launcher.	toolBar		&lt;ValueHolder&gt; The tool bar of buttons.	transcriptView	&lt;VisualTranscript&gt;	The transcript widget to be used.	statusBar		&lt;VisualLauncherStatusBar&gt;</body>
</comment>

<methods>
<class-id>Tools.VisualLauncher</class-id> <category>initialize-release</category>

<body package="Tools-Misc" selector="initialize">initialize	super initialize.	toolBar := nil asValue.	menuBar := nil asValue.	self installMenuRangeRestrictions</body>

<body package="Tools-Misc" selector="release">release	statusBar == nil ifFalse: [statusBar release].	transcriptView == nil ifFalse: [transcriptView release].	super release.</body>

<body package="Tools-Misc" selector="winNewLauncher">winNewLauncher	"Create a new launcher."	self class open.	self closeAndUnschedule.	self release</body>
</methods>

<methods>
<class-id>Tools.VisualLauncher</class-id> <category>actions</category>

<body package="Tools-Programming" selector="browseAmbiguousReferences">browseAmbiguousReferences	| mc calls |	mc := MethodCollector new.	calls := mc methodsSelect: [ :m|		[ m allLiteralsDo: [ :lit|			lit isBindingReference				ifTrue: [ lit bindingOrNil ]				ifFalse: [					(lit isVariableBinding and: [lit isDeferred])						ifTrue: [lit resolveBinding]]].		false]			on: DuplicateBindingsError do: [:ex| ex return: true]].	calls := Cursor execute showWhile: [ calls select ].	DuplicateBindingsError ambiguousReferencesExist: calls size &gt; 0.	^mc		openListBrowserOn: calls		label: (#AmbiguousBindings &lt;&lt; #dialogs &gt;&gt; 'Ambiguous Binding References (accept to discover)')		initialSelection: nil</body>

<body package="Store-UI" selector="browseClassDefinitions">browseClassDefinitions	| name list matches targetName session |	name := Dialog request: (#ClassNameMatching &lt;&lt; #store &gt;&gt; 'Class name matching') asString.	name isEmpty ifTrue: [^self].	session := Store.Glorp.StoreLoginFactory currentStoreSession.	[(Gathering for: name) started.	matches := Store.Glorp.StoreClassDefinition allNamesMatching: name in: session.	(Gathering for: name) finished] withStoreFeedbackOn: self mainWindow.	matches isEmpty ifTrue: 		[^self noItemsOfType: (#ClassName &lt;&lt; #store &gt;&gt; 'Class name') asString match: name].	(targetName := self selectNameFrom: matches chooseTitle: (#ClassName &lt;&lt; #store &gt;&gt; 'Class name') asString) ifNil: [^self].	[(Gathering for: targetName) started.	list := Store.Glorp.StoreClassDefinitionInPackage allVersionsWithName: targetName in: session.	(Gathering for: targetName) finished] withStoreFeedbackOn: self mainWindow.	list isEmpty ifTrue: 		[^Dialog warn: (#_1sHasNotBeenPublished &lt;&lt; #store &gt;&gt; '&lt;1s&gt; has not been published.' expandMacrosWith: targetName)].	Store.Glorp.DefinitionForListTool forClasses: list</body>

<body package="Tools-Misc" selector="browseGlobal">browseGlobal	"Browse references to a global variable (either in Smalltalk or Undeclared).	 Try to track down references that go through the global's name as well as	 direct references via its association."	self applicationForClassNamed: #{SmalltalkWorkbench}		do: [:class| class browseGlobalFrom: builder window]</body>

<body package="Tools-Misc" selector="browseGlobalName">browseGlobalName	"Open a browser on a class, shared variable, or a namespace after	having the user select it in an incremental search dialog"	self applicationForClassNamed: #{SmalltalkWorkbench}		do: [:class| class promptThenBrowseGlobalNameFrom: builder window]</body>

<body package="Tools-Misc" selector="browseImplementorsOf">browseImplementorsOf	self applicationForClassNamed: #{SmalltalkWorkbench}		do: [:class| class promptThenBrowseImplementorsFrom: builder window]</body>

<body package="Tools-Misc" selector="browseInspect">browseInspect	"Inspect a global variable (either in Smalltalk or Undeclared).	 Try to track down references that go through the global's name as well as	 direct references via its association."	self applicationForClassNamed: #{SmalltalkWorkbench}		do: [:workbench| | answer |		answer := workbench pickASomething: (#InspectSharedVariableNamedColon &lt;&lt; #dialogs &gt;&gt; 'Inspect Shared Variable Named:').		answer = '' ifTrue: [^self].		( answer == false or: [answer == nil] )			ifTrue: [ Dialog warn: (#VariableDoesNotExist &lt;&lt; #dialogs &gt;&gt; 'Variable does not exist') ] 			ifFalse:				[answer isBindingReference ifFalse: [answer := answer fullyQualifiedReference].				answer value inspect]]</body>

<body package="Tools-Misc" selector="browseMethodsWithStringMatches">browseMethodsWithStringMatches	self applicationForClassNamed: #{SmalltalkWorkbench}		do: [:class| class promptThenBrowseMethodsWithStringMatching: builder window]</body>

<body package="Store-UI" selector="browseNameSpaceDefinitions">browseNameSpaceDefinitions	| name list session matches targetName |	name := Dialog request: (#NameSpaceNameMatching &lt;&lt; #store &gt;&gt; 'NameSpace name matching') asString.	name isEmpty ifTrue: [^self].	session := Store.Glorp.StoreLoginFactory currentStoreSession.	[(Gathering for: name) started.	matches := Store.Glorp.StoreNameSpace allNamesMatching: name in: session.	(Gathering for: name) finished] withStoreFeedbackOn: self mainWindow.	matches isEmpty ifTrue: 		[^self noItemsOfType: (#NameSpaceName &lt;&lt; #store &gt;&gt; 'NameSpace name') asString match: name].	(targetName := self selectNameFrom: matches chooseTitle: (#NameSpaceName &lt;&lt; #store &gt;&gt; 'NameSpace name') asString) ifNil:		[^self].	[(Gathering for: targetName) started.	list := Store.Glorp.StoreNamespaceInPackage allVersionsWithName: targetName in: session.	(Gathering for: targetName) finished] withStoreFeedbackOn: self mainWindow.	list isEmpty 		ifTrue: 			[^Dialog warn: ((#_1sHasNotBeenPublished &lt;&lt; #store &gt;&gt; '&lt;1s&gt; has not been published.') expandMacrosWith: targetName)].	Store.Glorp.DefinitionForListTool forNameSpaces: list</body>

<body package="Tools-Misc" selector="browseSendersOf">browseSendersOf	self applicationForClassNamed: #{SmalltalkWorkbench}		do: [:class| class promptThenBrowseCallsFrom: builder window]</body>

<body package="Tools-Misc" selector="browseSystem">browseSystem	self openApplicationForClassNamed: #{Refactory.Browser.RefactoringBrowser}</body>

<body package="Tools-Misc" selector="changesFileCondense">changesFileCondense	(Dialog confirm: (#verifyCondense &lt;&lt; #dialogs &gt;&gt; 'Really condense the changes file?')) ifTrue: [		SourceFileManager default condenseChanges]</body>

<body package="Store-UI" selector="checkConsistency">checkConsistency	| strm warning |	strm := WriteStream on: String new.	Cursor wait showWhile: [Registry checkConsistencyOn: strm].	warning := strm contents.	Dialog warn: 			(warning size = 0 				ifTrue: 					[#EverythingChecksOutFine &lt;&lt; #store &gt;&gt; 'Everything checks out fine']				ifFalse: [warning])</body>

<body package="Tools-Misc" selector="clearTranscript">clearTranscript	self textCollector clear</body>

<body package="Tools-Misc" selector="collectAllGarbage">collectAllGarbage	ObjectMemory verboseGlobalCompactingGC</body>

<body package="Tools-Misc" selector="collectGarbage">collectGarbage	ObjectMemory verboseCompactingGC</body>

<body package="Store-UI" selector="currentPackage">currentPackage	| pkg |	pkg := Registry currentPackage.	pkg := PackageChooser 				chooseOrAdd: (#CurrentPackage1s &lt;&lt; #store &gt;&gt; 'Current Package: &lt;1s&gt;' 						expandMacrosWith: pkg name)				withDefault: pkg				onCancelDo: [^self].	Registry currentPackage: pkg</body>

<body package="Tools-Misc" selector="filePermSaveAs">filePermSaveAs	[ObjectMemory permSaveDialogThenQuit: false]		on: SnapshotError		do: [:ex | Dialog warn: ex messageText].	self builder window label: self class title</body>

<body package="Tools-Misc" selector="filePermUndoAs">filePermUndoAs	[ObjectMemory permUndoDialogThenQuit: false]		on: SnapshotError		do: [:ex | Dialog warn: ex messageText].	self builder window label: self class title</body>

<body package="Tools-Misc" selector="helpAbout">helpAbout	"Display the dialog containing the version identification and	 copyright notice."	AboutVisualWorksDialog open</body>

<body package="Tools-Misc" selector="imageSave">imageSave	ObjectMemory imageFilename		canBeWritten ifFalse: [^self imageSaveAs].	[ObjectMemory snapshot]		on: SnapshotError		do: [:ex | Dialog warn: ex messageText].	self builder window label: self class title</body>

<body package="Tools-Misc" selector="imageSaveAs">imageSaveAs	[ObjectMemory saveDialogThenQuit: false]		on: SnapshotError		do: [:ex | Dialog warn: ex messageText].	self builder window label: self class title</body>

<body package="Tools-Misc" selector="inspectProcessor">inspectProcessor	Processor inspect</body>

<body package="Tools-Misc" selector="inspectScheduledControllers">inspectScheduledControllers	ScheduledControllers scheduledControllers inspect</body>

<body package="Store-UI" selector="openFilteredLoadedItems">openFilteredLoadedItems		DbRegistry doIfOnlineImage: [ Store.Glorp.PublishedPundleVersionsTool openOnAllLoadedPundlesWithFilter ]</body>

<body package="Store-UI" selector="openFilteredPublishedItems">openFilteredPublishedItems	DbRegistry doIfOnlineImage: [ Store.Glorp.PublishedPundleVersionsTool openOnAllPublishedPundlesWithFilter ]</body>

<body package="Store-UI" selector="openFilteredRecentPublishedItems">openFilteredRecentPublishedItems	DbRegistry doIfOnlineImage: [ Store.Glorp.PublishedPundleVersionsTool openRecentPublishedItemsWithFilter ]</body>

<body package="Store-UI" selector="openGarbageCollectionDialog">openGarbageCollectionDialog	DbRegistry connectedProfile isNil		ifFalse: [Store.MarkPundlesForDeletionTool open]		ifTrue: 			[Dialog warn: #YouMustBeConnectedForGarbageCollection &lt;&lt; #store						&gt;&gt; 'You must be connected to a repository in order to open the garbage collection tool']</body>

<body package="Store-UI" selector="openLoadedItems">openLoadedItems	DbRegistry doIfOnlineImage: 			[Store.Glorp.PublishedPundleVersionsTool openOnAllLoadedPundlesUnfiltered]</body>

<body package="Store-UI" selector="openPublishedItems">openPublishedItems	DbRegistry doIfOnlineImage: [ Store.Glorp.PublishedPundleVersionsTool openOnAllPublishedPundlesUnfiltered ]</body>

<body package="Store-UI" selector="openRecentPublishedItems">openRecentPublishedItems	DbRegistry doIfOnlineImage: [ Store.Glorp.PublishedPundleVersionsTool openRecentPublishedItemsUnfiltered ]</body>

<body package="Store-UI" selector="openUISettings">openUISettings	SettingsManager 		openOrRaise: VisualWorksSettings 		selectPage: #(#store)</body>

<body package="Store-UI" selector="toggleStoreRepositoryConnection">toggleStoreRepositoryConnection	DbRegistry isConnected		ifTrue: [DbRegistry disconnect]		ifFalse: [DbRegistry restoreConnection]</body>

<body package="Tools-Misc" selector="toggleToolbar">toggleToolbar	builder window toolbarVisible: builder window toolbarVisible not</body>

<body package="Tools-Misc" selector="visualWorksExit">visualWorksExit	ObjectMemory quitDialog</body>

<body package="Tools-Misc" selector="visualWorksLauncher">visualWorksLauncher	 self class open</body>

<body package="Tools-Misc" selector="winCollapseAll">winCollapseAll	"Collapse (minimize) all windows under VisualWorks control except 	for the launcher causing this 	method to execute."	| actController |	actController := self builder window controller.	ScheduledWindow scheduledControllers do: 		[:each | 		[each == actController ifFalse: [each collapse]] 			on: Object errorSignal			do: [:error | error return]]</body>

<body package="Tools-Misc" selector="winRefreshAll">winRefreshAll	"Repaint all of the windows under VisualWorks control."	WindowManager restoreAll</body>

<body package="Tools-Misc" selector="winRestoreAll">winRestoreAll	"Expand (maximize) all of the windows under VisualWorks control."	| win |	win := Window currentWindow.	ScheduledWindow scheduledWindows do:		[:each |		[each isCollapsed ifTrue: [each expand]]			on: Object errorSignal 			do: [:ex | ex return]].	win ifNotNil: #raise.</body>
</methods>

<methods>
<class-id>Tools.VisualLauncher</class-id> <category>changing</category>

<body package="Tools-Misc" selector="changeRequest">changeRequest	"The receiver wants to change; check with all dependents that it is 	OK."	^self myDependents updateRequest and: [self closeDialog]</body>
</methods>

<methods>
<class-id>Tools.VisualLauncher</class-id> <category>interface opening</category>

<body package="Tools-Misc" selector="postBuildWith:">postBuildWith: aBuilder	"Do anything you might want to do prior to the builder constructing a 	canvas."		super postBuildWith: aBuilder.	builder window application: self.	builder window sendWindowEvents: #(#reopen).	self enableConnections</body>

<body package="Tools-Misc" selector="postOpenWith:">postOpenWith: aBuilder 	builder window windowManager activeControllerProcess 		environmentAt: #WindowManagerUsagePolicy		put: MakeNewWindowManagerUsagePolicy new.	self changed: #newInterface.	self transcriptView transcript: self textCollector.	self updateStatusBar</body>
</methods>

<methods>
<class-id>Tools.VisualLauncher</class-id> <category>accessing</category>

<body package="Tools-Misc" selector="textCollector">textCollector	textCollector == nil		ifTrue: [textCollector := Transcript].	^textCollector</body>

<body package="Tools-Misc" selector="textCollector:">textCollector: aTextCollector	textCollector := aTextCollector.	self transcriptView transcript: self textCollector</body>

<body package="Tools-Misc" selector="transcriptView">transcriptView	"This method was generated by UIDefiner.  Any edits made here	may be lost whenever methods are automatically defined.  The	initialization provided below may have been preempted by an	initialize method."	^transcriptView isNil		ifTrue:			[transcriptView := VisualTranscript new]		ifFalse:			[transcriptView]</body>
</methods>

<methods>
<class-id>Tools.VisualLauncher</class-id> <category>menus</category>

<body package="Tools-Misc" selector="buildMenuFor:">buildMenuFor: aMenuName	| menu |	menu := Menu new.	menu augmentFrom: self class to: self class menuName: aMenuName for: self.	^menu</body>

<body package="Tools-Misc" selector="installMenuRangeRestrictions">installMenuRangeRestrictions	| generator |	generator := MenuAutomaticGenerator name: #menuBar definer: self.	generator 		clearRangeRestrictions;		vwRestrictedMenu: #(#menuBar) range: #(70 999);		vwRestrictedMenu: #(#menuBar #file) range: #(40 999);		vwRestrictedMenu: #(#menuBar #browse) range: #(50 999);		vwRestrictedMenu: #(#menuBar #tools) range: #(50 999);		vwRestrictedMenu: #(#menuBar #window) range: #(200);		vwRestrictedMenu: #(#menuBar #help) range: #(50 999).	generator name: #launcherToolBar definer: self.	generator		vwRestrictedMenu: #(#launcherToolBar) range: #(50 999).</body>

<body package="Tools-Misc" selector="launcherMenuBar">launcherMenuBar	self rebuildMenu.	^menuBar</body>

<body package="Tools-Misc" selector="launcherToolBar">launcherToolBar	self updateToolbar.	^toolBar</body>

<body package="Tools-Misc" selector="rebuildMenu">rebuildMenu	"The VisualLauncher menuBar is generated entirely with pragmas."	| menu |	menu := UI.Menu new.	menu		augmentFrom: self class		to: VisualLauncher		menuName: #menuBar		for: self.	(menuBar isKindOf: UI.Menu) ifTrue: [ menuBar := nil asValue ].	menuBar value: menu</body>

<body package="Tools-Misc" selector="updateToolbar">updateToolbar	"The VisualLauncher toolBar is generated entirely with pragmas."	| menu |	menu := UI.Menu new.	menu		augmentFrom: self class		to: VisualLauncher		menuName: #launcherToolBar		for: self.	toolBar value: menu</body>
</methods>

<methods>
<class-id>Tools.VisualLauncher</class-id> <category>private</category>

<body package="Tools-Misc" selector="applicationForClassNamed:do:">applicationForClassNamed: aSymbol do: aBlock	"Evaluate aBlock with the class named aSymbol, if it exists.  If it	 does not exist issue a warning."	| cl |	cl := aSymbol asQualifiedReference valueOrDo:		[^Dialog warn: ((#warnClassNotInSystem &lt;&lt; #dialogs &gt;&gt; 'Class &lt;1s&gt; not in system.')				expandMacrosWith: aSymbol asString)].	^aBlock value: cl</body>

<body package="Tools-Misc" selector="closeDialog">closeDialog	"The Launcher is uncloseable if it is the last open window"	| result labels values |	labels := OrderedCollection new.	values := OrderedCollection new.	ScheduledWindow scheduledControllers size = 1 ifFalse: 		[labels add: (#closeLauncherWindow &lt;&lt; #dialogs &gt;&gt; 'Close this Window').		values add: #close].	labels		add: (#SaveThenExit &lt;&lt; #dialogs &gt;&gt; 'Save then Exit');		add: (#ExitWithoutSaving &lt;&lt; #dialogs &gt;&gt; 'Exit without Saving');		add: (#Cancel &lt;&lt; #dialogs &gt;&gt; 'Cancel').	values addAll: #(#save #exit #cancel).	result := Dialog choose: (#closeOrExit &lt;&lt; #dialogs &gt;&gt; 'Close Window or Exit?')		fromVerticallyAlignedButtonsWithLabels: labels		values: values		default: #cancel		for: builder window.	result == #close ifTrue: [^true].	result == #exit ifTrue: [ObjectMemory warnThenQuit].	result == #save ifTrue: [ObjectMemory snapshotThenQuit].	^false</body>

<body package="Tools-Misc" selector="enableConnections">enableConnections	"Do anything you might want to do to enable or disable external components.	 As a side-effect update the title.  This allows Parcels to change the Launcher's	 title."	self builder window label: self class title</body>

<body package="Tools-Misc" selector="inspectDependentsFieldsLabel">inspectDependentsFieldsLabel	^(#DependentsFields1p &lt;&lt; #dialogs &gt;&gt; 'DependentsFields (&lt;1p&gt;)') 		expandMacrosWith: DependentsFields size</body>

<body package="Tools-Misc" selector="inspectUndeclaredLabel">inspectUndeclaredLabel	^(#Undeclared1p &lt;&lt; #dialogs &gt;&gt; 'Undeclared (&lt;1p&gt;)') 		expandMacrosWith: Undeclared size</body>

<body package="Tools-Misc" selector="noticeOfWindowClose:">noticeOfWindowClose: aWindow	self release.	^super noticeOfWindowClose: aWindow</body>

<body package="Tools-Misc" selector="openApplicationForClassNamed:">openApplicationForClassNamed: aSymbol	self openApplicationForClassNamed: aSymbol withSelector: #open</body>

<body package="Tools-Misc" selector="openApplicationForClassNamed:withSelector:">openApplicationForClassNamed: aSymbol withSelector: aSelectorSymbol	self applicationForClassNamed: aSymbol do: [:class| class perform: aSelectorSymbol]</body>

<body package="Tools-Misc" selector="toolbarVisible">toolbarVisible	^builder window toolbarVisible</body>

<body package="Tools-Misc" selector="updateStatusBar">updateStatusBar	| container |		"Make sure we filter out recievers that aren't really open and capable of doing the update."	(builder isNil or: [self mainWindow isNil or: [self mainWindow isOpen not]]) ifTrue: [^self].		container := (builder componentAt: #statusBar) bottomComponent container.		"If the status bar is already installed, then this clears the container, which is why we have to get it beforehand"	statusBar ifNotNil: #release.	statusBar := ToolBarView new.	statusBar variantName: #statusbar.	statusBar container: container.	container component: statusBar.	statusBar pragmas: self.		(builder componentAt: #transcript) layout bottomOffset: statusBar intrinsicHeight negated.	(builder componentAt: #statusBar) layout topOffset: statusBar intrinsicHeight negated.	(builder componentAt: #statusBar) container invalidateLayout; invalidateNow</body>
</methods>

<methods>
<class-id>Tools.VisualLauncher</class-id> <category>menus - file</category>

<body package="Tools-Misc" selector="menuItemExitVisualWorks">menuItemExitVisualWorks	&lt;vwPrivileged&gt;	&lt;menuItemForCommand: #exitVisualWorks		nameKey: nil		menu: #(#menuBar #file)		position: 1020.1&gt;	self visualWorksExit</body>

<body package="Tools-Workspace" selector="menuItemFileOpen">menuItemFileOpen	&lt;vwPrivileged&gt;	&lt;menuItemForCommand: #openFile		nameKey: nil		menu: #(#menuBar #file)		position: 10.1&gt;	| name ws |	name := (Dialog requestFileName: (#OpenFile &lt;&lt; #dialogs &gt;&gt; 'Open File') default: '*.ws') trimBlanks.	name isEmpty ifFalse:		[ws := Workspace withFile: name.		 ws encodingChannel value: #default.		 ws open]</body>

<body package="Tools-Misc" selector="menuItemFilePermSaveImageAs">menuItemFilePermSaveImageAs	&lt;vwPrivileged&gt;	&lt;menuItemForCommand: #permSaveImageAs		nameKey: nil		menu: #(#menuBar #file)		position: 20.3&gt;	self filePermSaveAs</body>

<body package="Tools-Misc" selector="menuItemFilePermUndoAs">menuItemFilePermUndoAs	&lt;vwPrivileged&gt;	&lt;menuItemForCommand: #permUndoAs		nameKey: nil		menu: #(#menuBar #file)		position: 20.4&gt;	self filePermUndoAs</body>

<body package="Headless" selector="menuItemFileSaveHeadlessImageAs">menuItemFileSaveHeadlessImageAs	&lt;vwPrivileged&gt;	&lt;menuItemForCommand: #saveHeadlessImageAs		nameKey: nil		menu: #(#menuBar #file)		position: 30.1&gt;	| prefix |	prefix := Snapshot new getImagePrefix.	prefix isEmpty ifTrue: [^self].	HeadlessImage current saveHeadless: prefix.</body>

<body package="Tools-Misc" selector="menuItemFileSaveImage">menuItemFileSaveImage	&lt;vwPrivileged&gt;	&lt;menuItemForCommand: #saveImage		icon: #(#{UI.ResourceRetriever} #{Tools.GeneralIcons} #saveSystem )		nameKey: nil		menu: #(#menuBar #file)		position: 20.1&gt;	self imageSave</body>

<body package="Tools-Misc" selector="menuItemFileSaveImageAs">menuItemFileSaveImageAs	&lt;vwPrivileged&gt;	&lt;menuItemForCommand: #saveImageAs		nameKey: nil		menu: #(#menuBar #file)		position: 20.2&gt;	self imageSaveAs</body>

<body package="Tools-Settings-VW" selector="menuItemSetVisualWorksHome">menuItemSetVisualWorksHome	"VisualLauncher someInstance setVisualWorksHome"	&lt;vwPrivileged&gt;	&lt;menuItemForCommand: #setVisualWorksHome		nameKey: nil		menu: #(#menuBar #file)		position: 1000.1&gt;	VisualWorksSettings openManagerPage: #(#system)</body>

<body package="Tools-Misc" selector="topMenuFile">topMenuFile	&lt;vwPrivileged&gt;	&lt;submenu: #(#_File #menus '&amp;File')		nameKey: #file		menu: #(#menuBar)		position: 10.0&gt;	^self</body>
</methods>

<methods>
<class-id>Tools.VisualLauncher</class-id> <category>menus - help</category>

<body package="Non-Commercialization" selector="aboutVisualWorksLabel">aboutVisualWorksLabel	^#aboutVWPU &lt;&lt; #menus &gt;&gt; 'About &amp;VisualWorks Personal Use...'</body>

<body package="Tools-Misc" selector="menuItemAboutVisualWorks">menuItemAboutVisualWorks	"Dynamic menu label allows difference between VisualWorks distributed versions."	&lt;vwPrivileged&gt;	&lt;menuItemForCommand: #aboutVisualWorks		label: #aboutVisualWorksLabel		nameKey: nil		menu: #(#menuBar #help)		position: 1000.1&gt;	self helpAbout</body>

<body package="Non-Commercialization" selector="menuItemHelpGettingStartedWorkspace">menuItemHelpGettingStartedWorkspace	&lt;menuItemForCommand: #openGettingStartedWorkspace		nameKey: nil		menu: #(#menuBar #help)		position: 6.01&gt;		Workspace openGettingStartedWorkspace.</body>

<body package="Tools-Workspace" selector="menuItemHelpInstallationWorkspace">menuItemHelpInstallationWorkspace	&lt;vwPrivileged&gt;	&lt;menuItemForCommand: #openInstallationWorkspace		nameKey: nil		menu: #(#menuBar #help)		position: 20.3&gt;	Workbook systemWorkbook		open;		selectPageLabeled: (#installationWorkspace &lt;&lt; #labels &gt;&gt; 'Installation Workspace')</body>

<body package="Non-Commercialization" selector="menuItemHelpIntroductoryWorkspace">menuItemHelpIntroductoryWorkspace	&lt;menuItemForCommand: #openIntroductoryWorkspace		nameKey: nil		menu: #(#menuBar #help)		position: 6.03&gt;		Workspace openIvanTomekWorkspace.</body>

<body package="Tools-Misc" selector="menuItemHelpLauncher">menuItemHelpLauncher	&lt;vwPrivileged&gt;	&lt;	menuItemForCommand: #helpLauncher	nameKey: nil	menu: #(#menuBar #help)	position: 20.1&gt;	'topic:vw.help.tools.launcher' asURI open</body>

<body package="Non-Commercialization" selector="menuItemHelpNonCommercialWorkspace">menuItemHelpNonCommercialWorkspace	&lt;menuItemForCommand: #openNonCommercialWorkspace		nameKey: nil		menu: #(#menuBar #help)		position: 6.02&gt;		Workspace openNonCommercialWorkspace.</body>

<body package="Tools-Misc" selector="menuItemHelpObjectReference">menuItemHelpObjectReference	&lt;vwPrivileged&gt;	&lt;menuItemForCommand: #objectReferenceHelp		nameKey: nil		menu: #(#menuBar #help)		position: 20.2&gt;	| objectReference text list b table |	objectReference := Dictionary new.	Cursor wait showWhile:		[SystemUtils allClassesDo:			[:class | | comment index str |			str := 'Object Reference:'.			(index := (comment := class comment) indexOfSubCollection: str startingAt: 1) &gt; 0 ifTrue:				[index := index + str size.				[(comment at: index) isSeparator] whileTrue: [index := index + 1].				objectReference at: class fullName put: (comment copyFrom: index to: comment size)]]].	text := '' asValue.	list := SelectionInList new.	list list: (table := objectReference keys asSortedStrings asArray).	list selectionIndexHolder: ((PluggableAdaptor on: 0 asValue)							getBlock: [:m | m value]							putBlock:								[:m :v |								m value: v.								text value: (v = 0											ifTrue: ['']											ifFalse: [objectReference at: (table at: v)])]							updateBlock: [:m :a :p | false ];							yourself).	list selectionIndex: 0.	b := self builderClass new.	b		add: ((WindowSpec label: (#objectReferenceLabel &lt;&lt; #labels &gt;&gt; 'Object Reference')) min:300@350; yourself);		add: (SequenceViewSpec model: list layout: ((LayoutFrame new) rightFraction: 1; bottomFraction: 0.3));		add: (TextEditorSpec model: text layout: ((LayoutFrame new) rightFraction: 1; topFraction: 0.3; bottomFraction: 1)).	b open</body>

<body package="Tools-Misc" selector="menuItemHelpOpenHelpBrowser">menuItemHelpOpenHelpBrowser	&lt;vwPrivileged&gt;	&lt;itemInMenu: #(#launcherToolBar) position: 1020.1&gt;	&lt;itemInMenu: #(#menuBar #help) position: 10.1&gt;	^(MenuItem forCommand: #helpBrowseTopics)		helpText: #ShowOnlineHelp &lt;&lt; #labels &gt;&gt; 'Show online help';		labelImage: GeneralIcons help;		value: ['topic:' asURI open]</body>

<body package="Tools-Workspace" selector="menuItemHelpSystemWorkspace">menuItemHelpSystemWorkspace	&lt;vwPrivileged&gt;	&lt;menuItemForCommand: #openSystemWorkspace		nameKey: nil		menu: #(#menuBar #help)		position: 20.4&gt;	Workbook systemWorkbook		open;		selectPageLabeled: (#systemWorkspace &lt;&lt; #labels &gt;&gt; 'System Workspace')</body>

<body package="Tools-Misc" selector="menuItemHelpWelcome">menuItemHelpWelcome	&lt;vwPrivileged&gt;	&lt;menuItemForCommand: #helpWelcome		nameKey: nil		menu: #(#menuBar #help)		position: 10.2&gt;	ExternalWebBrowser 		open: (LogicalFilename fromComponents: (Array with: '$(VISUALWORKS)' with: 'Welcome.pdf')) asAbsoluteFilename asString</body>

<body package="Tools-Misc" selector="topMenuHelp">topMenuHelp	&lt;vwPrivileged&gt;	&lt;submenu: #(#_Help #menus #'&amp;Help')		nameKey: #help		menu: #(#menuBar)		position: 1020.0&gt;	^self</body>
</methods>

<methods>
<class-id>Tools.VisualLauncher</class-id> <category>menus - browse</category>

<body package="Tools-Programming" selector="browseAmbiguousReferencesLabel">browseAmbiguousReferencesLabel	^(#AmbiguousReferencesExist &lt;&lt; #menus &gt;&gt; '&amp;Ambiguous References&lt;1? (exist):&gt;')		expandMacrosWith: DuplicateBindingsError ambiguousReferencesExist</body>

<body package="Tools-Programming" selector="menuItemBrowseAmbiguousReferences">menuItemBrowseAmbiguousReferences	"Dynamic menu label overrides static label in Command."	&lt;vwPrivileged&gt;	&lt;menuItemForCommand: #browseAmbiguousReferences		label: #browseAmbiguousReferencesLabel		nameKey: nil		menu: #(#menuBar #browse)		position: 25.1&gt;	^self browseAmbiguousReferences</body>

<body package="Tools-Misc" selector="menuItemBrowseClassVariableNamespace">menuItemBrowseClassVariableNamespace	&lt;vwPrivileged&gt;	&lt;menuItemForCommand: #browseClassOrVariableOrNamespace  		label: #(#_ClassVariableNameSpaceDots #menus '&amp;Class/Variable/Name Space...')		icon: #(#{UI.ResourceRetriever} #{Refactory.Browser.BrowserIcons} #findClass )		nameKey: nil		menu: #(#menuBar #browse)		position: 20.1&gt;			self browseGlobalName</body>

<body package="Tools-Misc" selector="menuItemBrowseImplementorsOfSelector">menuItemBrowseImplementorsOfSelector	&lt;vwPrivileged&gt;	&lt;menuItemForCommand: #browseImplementorsOfSelector		label: #(#_ImplementorsOfSelector #menus 'I&amp;mplementors of Selector...')		icon: #(#{UI.ResourceRetriever} #{Refactory.Browser.BrowserIcons} #findMethod )		nameKey: nil		menu: #(#menuBar #browse)		position: 20.3&gt;	self browseImplementorsOf</body>

<body package="Tools-Misc" selector="menuItemBrowseInspectDependentsFields">menuItemBrowseInspectDependentsFields	"Dynamic menu label overrides static label in Command."	&lt;menuItemForCommand: #browseInspectDependentsFields		label: #inspectDependentsFieldsLabel		nameKey: nil		menu: #(#menuBar #browse #inspect)		position: 40.1&gt;	DependentsFields inspect</body>

<body package="Tools-Misc" selector="menuItemBrowseInspectProcessor">menuItemBrowseInspectProcessor	&lt;menuItemForCommand: #inspectProcessor		label: #(#Processor #menus 'Processor')		nameKey: nil		menu: #(#menuBar #browse #inspect)		position: 30.1&gt;	self inspectProcessor</body>

<body package="Tools-Misc" selector="menuItemBrowseInspectScheduledControllers">menuItemBrowseInspectScheduledControllers	&lt;menuItemForCommand: #inspectScheduledControllers		label: #(#ScheduledControllers #menus 'ScheduledControllers')		nameKey: nil		menu: #(#menuBar #browse #inspect)		position: 30.2&gt;	self inspectScheduledControllers</body>

<body package="Tools-Misc" selector="menuItemBrowseInspectUndeclared">menuItemBrowseInspectUndeclared	"Dynamic menu label overrides static label in Command."	&lt;menuItemForCommand: #browseInspectUndeclared		label: #inspectUndeclaredLabel		nameKey: nil		menu: #(#menuBar #browse #inspect)		position: 40.2&gt;	Undeclared inspect</body>

<body package="Tools-Misc" selector="menuItemBrowseInspectVariable">menuItemBrowseInspectVariable	&lt;menuItemForCommand: #inspectVariableByName		label: #(#_Variable #menus '&amp;Variable...')		nameKey: nil		menu: #(#menuBar #browse #inspect)		position: 10.1&gt;	self browseInspect</body>

<body package="Tools-Misc" selector="menuItemBrowseMethodsWithStringMatches">menuItemBrowseMethodsWithStringMatches	&lt;vwPrivileged&gt;	&lt;menuItemForCommand: #browseMethodsMatchingString		label: #(#_MethodsMatchingString #menus '&amp;Methods matching a string...')		nameKey: #browseMethodsMatchingString		menu: #(#menuBar #browse)		position: 20.5&gt;	self browseMethodsWithStringMatches</body>

<body package="Tools-Misc" selector="menuItemBrowseReferencesToClassVariableNamespace">menuItemBrowseReferencesToClassVariableNamespace	&lt;vwPrivileged&gt;	&lt;menuItemForCommand: #browseReferencesToClassOrVariableOrNamespace		label: #(#_ReferencesToVariable #menus 'References to Class/&amp;Variable/Namespace...')		icon: #(#{UI.ResourceRetriever} #{Refactory.Browser.BrowserIcons} #referenceClass )		nameKey: nil		menu: #(#menuBar #browse)		position: 20.2&gt;	self browseGlobal</body>

<body package="Tools-Misc" selector="menuItemBrowseSendersOfSelector">menuItemBrowseSendersOfSelector	&lt;vwPrivileged&gt;	&lt;menuItemForCommand: #browseSendersOfSelector		label: #(#_SendersOfSelector #menus '&amp;Senders of Selector...')		icon: #(#{UI.ResourceRetriever} #{Refactory.Browser.BrowserIcons} #referenceMethod )		nameKey: nil		menu: #(#menuBar #browse)		position: 20.4&gt;	self browseSendersOf</body>

<body package="Tools-Misc" selector="menuItemBrowseSystem">menuItemBrowseSystem	&lt;vwPrivileged&gt;	&lt;menuItemForCommand: #browseSystem  		label: #(#system #menus 'S&amp;ystem')		icon: #(#{UI.ResourceRetriever} #{Refactory.Browser.BrowserIcons} #browseSystem )		nameKey: nil		menu: #(#menuBar #browse)		position: 10.1&gt;			self browseSystem</body>

<body package="Tools-Misc" selector="submenuBrowseInspect">submenuBrowseInspect	&lt;vwPrivileged&gt;	&lt;submenu: #(#_Inspect #menus '&amp;Inspect')		nameKey: #inspect		menu: #(#menuBar #browse)		position: 40.0&gt;	^self</body>

<body package="Tools-Misc" selector="topMenuBrowse">topMenuBrowse	&lt;vwPrivileged&gt;	&lt;submenu: #(#_Browse #menus '&amp;Browse')		nameKey: #browse		menu: #(#menuBar)		position: 30.0&gt;	^self</body>
</methods>

<methods>
<class-id>Tools.VisualLauncher</class-id> <category>menus - tools</category>

<body package="Tools-Workspace" selector="menuItemNewWorkspace">menuItemNewWorkspace	&lt;vwPrivileged&gt;	&lt;menuItemForCommand: #openNewWorkspace		label: #(#_Workspace #menus '&amp;Workspace')		icon: #(#{UI.ResourceRetriever} #{WorkspaceIcons} #workspace)		nameKey: nil		menu: #(#menuBar #tools)		position: 10.1&gt;		self openApplicationForClassNamed: #Workbook</body>

<body package="Tools-Changes" selector="menuItemOpenChangeList">menuItemOpenChangeList	&lt;vwPrivileged&gt;	&lt;menuItemForCommand: #openChangeList		icon: nil		nameKey: nil		menu: #(#menuBar #tools)		position: 10.5&gt;	self openApplicationForClassNamed: #{ChangeList}</body>

<body package="Tools-File Browser" selector="menuItemOpenFileBrowser">menuItemOpenFileBrowser	&lt;vwPrivileged&gt;	&lt;menuItemForCommand: #openFileBrowser		icon: #(#{UI.ResourceRetriever} #{Tools.GeneralIcons} #fileBrowser )		nameKey: nil		menu: #(#menuBar #tools)		position: 10.2&gt;	self openApplicationForClassNamed: #{Tools.FileTools.FileBrowser}</body>

<body package="Tools-Parcel Manager" selector="menuItemOpenParcelManager">menuItemOpenParcelManager	&lt;vwPrivileged&gt;	&lt;menuItemForCommand: #openParcelManager		icon: #(#{UI.ResourceRetriever} #{Tools.GeneralIcons} #parcelManager )		nameKey: nil		menu: #(#menuBar #tools)		position: 10.3&gt;	self openApplicationForClassNamed: #{ParcelManager}</body>

<body package="Tools-Misc" selector="topMenuTools">topMenuTools	&lt;vwPrivileged&gt;	&lt;submenu: #(#_Tools #menus #'&amp;Tools')		nameKey: #tools		menu: #(#menuBar)		position: 60.0&gt;	^self</body>
</methods>

<methods>
<class-id>Tools.VisualLauncher</class-id> <category>menus - system</category>

<body package="Tools-Misc" selector="menuItemClearTranscript">menuItemClearTranscript	&lt;vwPrivileged&gt;	&lt;menuItemForCommand: #clearTranscript		nameKey: nil		menu: #(#menuBar #system)		position: 40.1&gt;	self clearTranscript</body>

<body package="Tools-Misc" selector="menuItemCollectAllGarbage">menuItemCollectAllGarbage	&lt;vwPrivileged&gt;	&lt;menuItemForCommand: #collectAllGarbage		nameKey: nil		menu: #(#menuBar #system)		position: 30.2&gt;	self collectAllGarbage</body>

<body package="Tools-Misc" selector="menuItemCollectGarbage">menuItemCollectGarbage	&lt;vwPrivileged&gt;	&lt;menuItemForCommand: #collectGarbage		nameKey: nil		menu: #(#menuBar #system)		position: 30.1&gt;	self collectGarbage</body>

<body package="Tools-Misc" selector="menuItemLoadParcelByName">menuItemLoadParcelByName	&lt;menuItemForCommand: #loadParcelByName 		nameKey: nil		menu: #(#menuBar #system)		position: 10.1&gt;	Parcel findAndLoadParcels.</body>

<body package="Tools-Misc" selector="menuItemUnloadParcelByName">menuItemUnloadParcelByName	&lt;menuItemForCommand: #unloadParcelByName		nameKey: nil		menu: #(#menuBar #system)		position: 10.2&gt;	Parcel unloadParcelByNameFor: builder window</body>

<body package="Tools-Settings-VW" selector="menuItemVisualWorksSettings">menuItemVisualWorksSettings	&lt;vwPrivileged&gt;	&lt;menuItemForCommand: #vwOpenSettings		icon: #(#{UI.ResourceRetriever} #{Tools.GeneralIcons} #settings )		nameKey: nil		menu: #(#menuBar #system)		position: 1000.1&gt;	SettingsManager openOrRaise: VisualWorksSettings</body>

<body package="Tools-Misc" selector="topMenuSystem">topMenuSystem	&lt;vwPrivileged&gt;	&lt;submenu: #(#_System #menus '&amp;System')		nameKey: #system		menu: #(#menuBar)		position: 20.0&gt;	^self</body>
</methods>

<methods>
<class-id>Tools.VisualLauncher</class-id> <category>events</category>

<body package="Tools-Misc" selector="windowEvent:from:">windowEvent: anEvent from: aWindow	super windowEvent: anEvent from: aWindow.	anEvent key == #reopen ifTrue: [self enableConnections]</body>
</methods>

<methods>
<class-id>Tools.VisualLauncher</class-id> <category>menus - changes</category>

<body package="Tools-Misc" selector="menuItemChangesFileCondense">menuItemChangesFileCondense	&lt;menuItemForCommand: #condenseChanges		nameKey: nil		menu: #(#menuBar #system #changes)		position: 10.2&gt;	self changesFileCondense</body>

<body package="Tools-Changes" selector="menuItemOpenChangeSets">menuItemOpenChangeSets	&lt;menuItemForCommand: #openChangeSetManager		nameKey: nil		menu: #(#menuBar #system #changes)		position: 10.1&gt;	self openApplicationForClassNamed: #{ChangeSetManager}</body>

<body package="Tools-Changes" selector="menuItemOpenSystemOverrides">menuItemOpenSystemOverrides	&lt;menuItemForCommand: #openSystemOverrideList		nameKey: nil		menu: #(#menuBar #system #changes)		position: 40.1&gt;	OverrideList new openOn: Override overrideList</body>

<body package="Tools-Misc" selector="submenuSystemChanges">submenuSystemChanges	&lt;submenu: #(#Changes #menus 'Changes')		nameKey: #changes		menu: #(#menuBar #system)		position: 20.1&gt;	^self</body>
</methods>

<methods>
<class-id>Tools.VisualLauncher</class-id> <category>toolbar</category>

<body package="Tools-Misc" selector="toolbarItemBrowseClassVariableNamespace">toolbarItemBrowseClassVariableNamespace	&lt;vwPrivileged&gt;	&lt;menuItemForCommand: #browseClassOrVariableOrNamespace  		icon: #(#{UI.ResourceRetriever} #{Refactory.Browser.BrowserIcons} #findClass )		nameKey: nil		menu: #(#launcherToolBar)		position: 20.2		helpText: #(#BrowseClassVariableNamespaceDots #menus 'Browse Class/Variable/Namespace...')&gt;			self browseGlobalName</body>

<body package="Tools-Misc" selector="toolbarItemBrowseImplementorsOfSelector">toolbarItemBrowseImplementorsOfSelector	&lt;vwPrivileged&gt;	&lt;menuItemForCommand: #browseImplementorsOfSelector		icon: #(#{UI.ResourceRetriever} #{Refactory.Browser.BrowserIcons} #findMethod )		nameKey: nil		menu: #(#launcherToolBar)		position: 20.4		helpText: #(#BrowseImplementorsDots #menus 'Browse Implementors of Selector...')&gt;	self browseImplementorsOf</body>

<body package="Tools-Misc" selector="toolbarItemBrowseReferencesToClassVariableNamespace">toolbarItemBrowseReferencesToClassVariableNamespace	&lt;vwPrivileged&gt;	&lt;menuItemForCommand: #browseReferencesToClassOrVariableOrNamespace		icon: #(#{UI.ResourceRetriever} #{Refactory.Browser.BrowserIcons} #referenceClass )		nameKey: nil		menu: #(#launcherToolBar)		position: 20.3		helpText: #(#ReferencesToClassVariableNamespaceDots #menus 'References to Class/Variable/Namespace...')&gt;	self browseGlobal</body>

<body package="Tools-Misc" selector="toolbarItemBrowseSendersOfSelector">toolbarItemBrowseSendersOfSelector	&lt;vwPrivileged&gt;	&lt;menuItemForCommand: #browseSendersOfSelector		icon: #(#{UI.ResourceRetriever} #{Refactory.Browser.BrowserIcons} #referenceMethod )		nameKey: nil		menu: #(#launcherToolBar)		position: 20.5		helpText: #(#BrowseSendersOfSelectorDots #menus 'Browse Senders of Selector...')&gt;	self browseSendersOf</body>

<body package="Tools-Misc" selector="toolbarItemBrowseSystem">toolbarItemBrowseSystem	&lt;vwPrivileged&gt;	&lt;menuItemForCommand: #browseSystem  		icon: #(#{UI.ResourceRetriever} #{Refactory.Browser.BrowserIcons} #browseSystem )		nameKey: nil		menu: #(#launcherToolBar)		position: 20.1		helpText: #(#OpenASystemBrowser #menus 'Open a System Browser')&gt;			self browseSystem</body>

<body package="UIPainter" selector="toolbarItemNewCanvas">toolbarItemNewCanvas	&lt;vwPrivileged&gt;	&lt;menuItemForCommand: #uipainterOpenNewCanvas		icon: #(#{UI.ResourceRetriever} #{UIPainterIcons} #uiPainter)		nameKey: nil		menu: #(#launcherToolBar)		position: 30.1		helpText: #(#EditANewCanvas #UIPainter 'Edit a New Canvas')&gt;	self applicationForClassNamed: #{UIPainter} do: [ :class | class new openNewWindowCanvas ]</body>

<body package="Tools-Workspace" selector="toolbarItemNewWorkspace">toolbarItemNewWorkspace	&lt;vwPrivileged&gt;	&lt;menuItemForCommand: #openNewWorkspace		icon: #(#{UI.ResourceRetriever} #{WorkspaceIcons} #workspace)		nameKey: nil		menu: #(#launcherToolBar)		position: 1000.99		helpText: #(#OpenANewWorkspace #labels 'Open a new workspace')&gt;		self openApplicationForClassNamed: #Workbook</body>

<body package="Tools-File Browser" selector="toolbarItemOpenFileBrowser">toolbarItemOpenFileBrowser	&lt;vwPrivileged&gt;	&lt;menuItemForCommand: #openFileBrowser		icon: #(#{UI.ResourceRetriever} #{Tools.GeneralIcons} #fileBrowser )		nameKey: nil		menu: #(#launcherToolBar)		position: 1000.1		helpText: #(#OpenAFileBrowser #menus 'Open a File Browser')&gt;	self openApplicationForClassNamed: #{Tools.FileTools.FileBrowser}</body>

<body package="Tools-Parcel Manager" selector="toolbarItemOpenParcelManager">toolbarItemOpenParcelManager	&lt;vwPrivileged&gt;	&lt;menuItemForCommand: #openParcelManager		icon: #(#{UI.ResourceRetriever} #{Tools.GeneralIcons} #parcelManager )		nameKey: nil		menu: #(#launcherToolBar)		position: 10.3		helpText: #(#OpenAParcelManager #menus 'Open a Parcel Manager')&gt;	self openApplicationForClassNamed: #{ParcelManager}</body>

<body package="Tools-Misc" selector="toolbarItemSaveImage">toolbarItemSaveImage	&lt;vwPrivileged&gt;	&lt;menuItemForCommand: #saveImage		icon: #(#{UI.ResourceRetriever} #{Tools.GeneralIcons} #saveSystem )		nameKey: nil		menu: #(#launcherToolBar)		position: 10.1		helpText: #(#SaveTheVisualWorksImage #menus 'Save the VisualWorks Image')&gt;	self imageSave</body>

<body package="Tools-Settings-VW" selector="toolbarItemVisualWorksSettings">toolbarItemVisualWorksSettings	&lt;vwPrivileged&gt;	&lt;menuItemForCommand: #vwOpenSettings		icon: #(#{UI.ResourceRetriever} #{Tools.GeneralIcons} #settings )		nameKey: nil		menu: #(#launcherToolBar)		position: 10.2		helpText: #(#EditTheSystemOptions #menus 'Edit the system options')&gt;	SettingsManager openOrRaise: VisualWorksSettings</body>
</methods>

<methods>
<class-id>Tools.VisualLauncher</class-id> <category>menus - window</category>

<body package="Tools-Misc" selector="menuItemCollapseAllWindows">menuItemCollapseAllWindows	&lt;vwPrivileged&gt;	&lt;menuItemForCommand: #collapseAllWindows		nameKey: nil		enablement: nil		indication: nil		menu: #(#window)		position: 20.2&gt;	self winCollapseAll</body>

<body package="Tools-Misc" selector="menuItemDynamicWindowsMenu">menuItemDynamicWindowsMenu	"This method must answer the dynamic menu insertion items expected by pragma processing."	&lt;vwPrivileged&gt;	&lt;dynamicItemsInMenu: #(#window) position: 100.0&gt;	^self currentWindowMenuGroups</body>

<body package="Tools-Misc" selector="menuItemOpenNewLauncher">menuItemOpenNewLauncher	&lt;vwPrivileged&gt;	&lt;menuItemForCommand: #openNewLauncher		nameKey: nil		enablement: nil		indication: nil		menu: #(#window)		position: 30.1&gt;	self winNewLauncher</body>

<body package="Tools-Misc" selector="menuItemRefreshAllWindows">menuItemRefreshAllWindows	&lt;vwPrivileged&gt;	&lt;menuItemForCommand: #refreshAllWindows		nameKey: nil		enablement: nil		indication: nil		menu: #(#window)		position: 20.1&gt;	self winRefreshAll</body>

<body package="Tools-Misc" selector="menuItemRestoreAllWindows">menuItemRestoreAllWindows	&lt;vwPrivileged&gt;	&lt;menuItemForCommand: #restoreAllWindows		nameKey: nil		enablement: nil		indication: nil		menu: #(#window)		position: 20.3&gt;	self winRestoreAll</body>

<body package="Tools-Misc" selector="menuItemToggleToolbar">menuItemToggleToolbar	&lt;vwPrivileged&gt;	&lt;menuItemForCommand: #toggleToolbar		nameKey: nil		enablement: nil		indication: #toolbarVisible		menu: #(#window)		position: 10.1&gt;	self toggleToolbar</body>

<body package="Tools-Misc" selector="topMenuWindow">topMenuWindow	"This method must answer the dynamic computed submenu as expected by pragma processing.  Performing this method will be encapsulated in a block for re-computation.	 This submenu includes dynamic menu insertion items.  Because this computation is configured as a block, the submenu cannot be augmented from a higher level in the menu structure.  If you need to augment this submenu (or one of its submenus) start at the #window menu level to describe the menu path."	&lt;vwPrivileged&gt;	&lt;computedSubmenu: #(#_Window #menus '&amp;Window') 		nameKey: #window 		menu: #(#menuBar) 		position: 1010.0&gt;	^self buildMenuFor: #window</body>
</methods>

<methods>
<class-id>Tools.VisualLauncher</class-id> <category>menus - window - dynamic</category>

<body package="Tools-Misc" selector="bringToFront:">bringToFront: view 	view isCollapsed ifTrue: [view expand].	^view raise</body>

<body package="Tools-Misc" selector="classNameInitials:">classNameInitials: anObject	^anObject class name select: [:each | each isUppercase]</body>

<body package="Tools-Misc" selector="currentWindowLabelsAndViews">currentWindowLabelsAndViews	^(ScheduledWindow currentWindowLabelsAndViews reject: [:ea| ea value model isKindOf: self class]) asArray</body>

<body package="Tools-Misc" selector="currentWindowMenuGroups">currentWindowMenuGroups	"Create group of items for all VisualWorks windows, plus optional group if we have more than nine windows open.	 The window selected by the user will be expanded, if necessary, and brought to front."	| windowMenuItems labelsAndViews |	windowMenuItems := OrderedCollection new.	labelsAndViews := self currentWindowLabelsAndViews.	windowMenuItems add: (self windowMenuItemsFrom: labelsAndViews).	labelsAndViews size &gt; 9 ifTrue: [		windowMenuItems add: (Array with: 				((MenuItem labeled: (#_0MoreWindows &lt;&lt; #dialogs &gt;&gt; '&amp;0. More Windows...')) 					value: [self selectAndRaiseViewAmong: labelsAndViews])) ].	^windowMenuItems</body>

<body package="Tools-Misc" selector="selectAndRaiseViewAmong:">selectAndRaiseViewAmong: labelsAndViews	| choice |	choice := Dialog		choose: (#SwitchToWindowC &lt;&lt; #dialogs &gt;&gt; 'Switch to window:')		fromList: (labelsAndViews collect: [:each | each key])		values: (labelsAndViews collect: [:each | each value])		lines: 20		cancel: [^self].	self bringToFront: choice</body>

<body package="Tools-Misc" selector="windowMenuItemFor:at:">windowMenuItemFor: labelViewAssociation at: anInteger	| assoc label |	assoc := labelViewAssociation.	label := '&amp;&lt;1p&gt;. [&lt;2s&gt;] &lt;3s&gt;'		expandMacrosWith: anInteger		with: (self classNameInitials: labelViewAssociation value model)		with: labelViewAssociation key.	^(MenuItem labeled: (label contractTo: 70))		value: [self bringToFront: assoc value]</body>

<body package="Tools-Misc" selector="windowMenuItemsFrom:">windowMenuItemsFrom: labelsAndViews 	| items new |	items := labelsAndViews size &gt; 9		ifTrue: [ labelsAndViews copyFrom: 1 to: 9 ]		ifFalse: [ labelsAndViews ].	new := OrderedCollection new.	items keysAndValuesDo: [ :index :each |		new add: (self windowMenuItemFor: each at: index) ].	^new</body>
</methods>

<methods>
<class-id>Tools.VisualLauncher</class-id> <category>menus - pdp</category>

<body package="Debugger-Support" selector="menuItemBrowseAllProbedMethods">menuItemBrowseAllProbedMethods	&lt;menuItemForCommand: #browseProbedMethods		icon: nil		nameKey: nil		menu: #(#menuBar #probes)		position: 30.1&gt;	PDPManager browseAllProbedMethods</body>

<body package="Debugger-Support" selector="menuItemClearTestExpressionLibrary">menuItemClearTestExpressionLibrary	&lt;menuItemForCommand: #clearTestExpressionLibrary		icon: nil		nameKey: nil		menu: #(#menuBar #probes #testLibrary)		position: 20.2&gt;	ProbeTestExpressionEditor clearLibrary</body>

<body package="Debugger-Support" selector="menuItemClearWatchExpressionLibrary">menuItemClearWatchExpressionLibrary	&lt;menuItemForCommand: #clearWatchExpressionLibrary		icon: nil		nameKey: nil		menu: #(#menuBar #probes #watchLibrary)		position: 20.2&gt;	ProbeActionExpressionEditor clearLibrary</body>

<body package="Debugger-Support" selector="menuItemInspectDebugVars">menuItemInspectDebugVars	&lt;menuItemForCommand: #inspectDebugVariables		icon: nil		nameKey: nil		menu: #(#menuBar #probes)		position: 30.2&gt;	PDPManager debugVariables inspect</body>

<body package="Debugger-Support" selector="menuItemInspectTestExpressionLibrary">menuItemInspectTestExpressionLibrary	&lt;menuItemForCommand: #inspectTestExpressionLibrary		icon: nil		nameKey: nil		menu: #(#menuBar #probes #testLibrary)		position: 20.1&gt;	ProbeTestExpressionEditor inspectLibrary</body>

<body package="Debugger-Support" selector="menuItemInspectWatchExpressionLibrary">menuItemInspectWatchExpressionLibrary	&lt;menuItemForCommand: #inspectWatchExpressionLibrary		icon: nil		nameKey: nil		menu: #(#menuBar #probes #watchLibrary)		position: 20.1&gt;	ProbeActionExpressionEditor inspectLibrary</body>

<body package="Debugger-Support" selector="menuItemLoadTestExpressionLibrary">menuItemLoadTestExpressionLibrary	&lt;menuItemForCommand: #loadTestExpressionLibrary		icon: nil		nameKey: nil		menu: #(#menuBar #probes #testLibrary)		position: 10.1&gt;	ProbeTestExpressionEditor readLibrary</body>

<body package="Debugger-Support" selector="menuItemLoadWatchExpressionLibrary">menuItemLoadWatchExpressionLibrary	&lt;menuItemForCommand: #loadWatchExpressionLibrary		icon: nil		nameKey: nil		menu: #(#menuBar #probes #watchLibrary)		position: 10.1&gt;	ProbeActionExpressionEditor readLibrary</body>

<body package="Debugger-Process Monitor" selector="menuItemOpenProcessMonitor">menuItemOpenProcessMonitor	&lt;menuItemForCommand: #openProcessMonitor		icon: nil		nameKey: nil		menu: #(#menuBar #probes)		position: 100&gt;	ProcessMonitorService open</body>

<body package="Debugger-Support" selector="menuItemPurgeUnusedVars">menuItemPurgeUnusedVars	&lt;menuItemForCommand: #removeUnusedDebugVariables		icon: nil		nameKey: nil		menu: #(#menuBar #probes)		position: 20.3&gt;	(Dialog confirm: (#PurgeUnusedDebugVariables &lt;&lt; #pdp &gt;&gt; 'Purge unused debug variables?'))			ifTrue: [PDPManager purgeUnusedDebugVariables]</body>

<body package="Debugger-Support" selector="menuItemPurgeUnusedWatches">menuItemPurgeUnusedWatches	&lt;menuItemForCommand: #removeUnusedWatchWindows		icon: nil		nameKey: nil		menu: #(#menuBar #probes)		position: 20.2&gt;	(Dialog confirm: (#PurgeUnusedWatches &lt;&lt; #pdp &gt;&gt; 'Purge unused watches?'))			ifTrue: [PDPManager purgeUnusedWatchWindows]</body>

<body package="Debugger-Support" selector="menuItemReadProbeLibrary">menuItemReadProbeLibrary	&lt;menuItemForCommand: #loadProbeLibrary		icon: nil		nameKey: nil		menu: #(#menuBar #probes #probeLibrary)		position: 10.1&gt;	ProbedCompiledMethod readProbesFromFile</body>

<body package="Debugger-Support" selector="menuItemRemoveAllProbes">menuItemRemoveAllProbes	&lt;menuItemForCommand: #removeAllProbes		icon: nil		nameKey: nil		menu: #(#menuBar #probes)		position: 20.1&gt;	(Dialog confirm: (#RemoveAllProbesFromSystem &lt;&lt; #pdp &gt;&gt; 'Remove all probes from system?'))		ifTrue: [ProbedCompiledMethod revertAllProbedMethodsInSystem]</body>

<body package="Debugger-Support" selector="menuItemSaveProbeLibrary">menuItemSaveProbeLibrary	&lt;menuItemForCommand: #saveProbeLibrary		icon: nil		nameKey: nil		menu: #(#menuBar #probes #probeLibrary)		position: 10.2&gt;	ProbedCompiledMethod saveProbesToFile</body>

<body package="Debugger-Support" selector="menuItemSaveTestExpressionLibrary">menuItemSaveTestExpressionLibrary	&lt;menuItemForCommand: #saveTestExpressionLibrary		icon: nil		nameKey: nil		menu: #(#menuBar #probes #testLibrary)		position: 10.2&gt;	ProbeTestExpressionEditor saveLibrary</body>

<body package="Debugger-Support" selector="menuItemSaveWatchExpressionLibrary">menuItemSaveWatchExpressionLibrary	&lt;menuItemForCommand: #saveWatchExpressionLibrary		icon: nil		nameKey: nil		menu: #(#menuBar #probes #watchLibrary)		position: 10.2&gt;	ProbeActionExpressionEditor saveLibrary</body>

<body package="Debugger-Support" selector="menuItemToggleDebugging">menuItemToggleDebugging	"Dynamic menu label overrides static label in Command."	&lt;menuItemForCommand: #toggleDebugging		label: #toggleDebuggingLabel		nameKey: nil		menu: #(#menuBar #probes)		position: 10.1&gt;	PDPManager toggleDebugging.	#{Refactory.Browser.SourceCodeEditor} ifDefinedDo: [:sceClass |		sceClass allGeneralInstancesDo: [:sce | sce redecorateProbes]]</body>

<body package="Debugger-Support" selector="submenuProbeLibrary">submenuProbeLibrary	&lt;submenu: #(#Probe_Library #pdp 'Probe &amp;Library')		nameKey: #probeLibrary		menu: #(#menuBar #probes)		position: 50.1&gt;	^self</body>

<body package="Debugger-Support" selector="submenuTestLibrary">submenuTestLibrary	&lt;submenu: #(#_TestLibrary #pdp '&amp;Test Library')		nameKey: #testLibrary		menu: #(#menuBar #probes)		position: 50.3&gt;	^self</body>

<body package="Debugger-Support" selector="submenuWatchLibrary">submenuWatchLibrary	&lt;submenu: #(#_WatchLibrary #pdp '&amp;Watch Library')		nameKey: #watchLibrary		menu: #(#menuBar #probes)		position: 50.2&gt;	^self</body>

<body package="Debugger-Support" selector="toggleDebuggingLabel">toggleDebuggingLabel	^PDPManager getEnableProbeDebuggingLabel</body>

<body package="Debugger-Support" selector="topMenuDebug">topMenuDebug	&lt;vwPrivileged&gt;	&lt;submenu: #(#_Debug #menus '&amp;Debug')		nameKey: #probes		menu: #(#menuBar)		position: 40.0&gt;	^self</body>
</methods>

<methods>
<class-id>Tools.VisualLauncher</class-id> <category>menus - uipainter</category>

<body package="UIPainter" selector="menuItemCodingAssistant">menuItemCodingAssistant	&lt;menuItemForCommand: #uipainterOpenCodingAssistant		nameKey: nil		menu: #(#menuBar #painter)		position: 30.2&gt;	self openApplicationForClassNamed: #{CodingAssistant} withSelector: #open</body>

<body package="UIPainter" selector="menuItemHotRegionsEditor">menuItemHotRegionsEditor	&lt;menuItemForCommand: #uipainterOpenHotRegionsEditor		nameKey: nil		menu: #(#menuBar #painter)		position: 20.3&gt;	self applicationForClassNamed: #{UIHotRegionEditor} do: [:class| class open]</body>

<body package="UIPainter" selector="menuItemMaskEditor">menuItemMaskEditor	&lt;menuItemForCommand: #uipainterOpenImageEditor		nameKey: nil		menu: #(#menuBar #painter)		position: 20.2&gt;	self openApplicationForClassNamed: #{UIMaskEditor}</body>

<body package="UIPainter" selector="menuItemMenuEditor">menuItemMenuEditor	&lt;menuItemForCommand: #uipainterOpenMenuEditor		nameKey: nil		menu: #(#menuBar #painter)		position: 20.1&gt;	self openApplicationForClassNamed: #{MenuEditor}</body>

<body package="UIPainter" selector="menuItemNewCanvas">menuItemNewCanvas	&lt;menuItemForCommand: #uipainterOpenNewCanvas		icon: #(#{UI.ResourceRetriever} #{UIPainterIcons} #uiPainter)		nameKey: nil		menu: #(#menuBar #painter)		position: 10.1&gt;	self applicationForClassNamed: #{UIPainter} do: [ :class | class new openNewWindowCanvas ]</body>

<body package="UIPainter" selector="menuItemResourceFinder">menuItemResourceFinder	&lt;menuItemForCommand: #uipainterOpenResourceFinder		nameKey: nil		menu: #(#menuBar #painter)		position: 30.1&gt;	self openApplicationForClassNamed: #{UIFinderVW2}</body>

<body package="UIPainter" selector="topMenuUIPainter">topMenuUIPainter	&lt;submenu: #(#painterSubmenu #UIPainter '&amp;Painter')		nameKey: #painter		menu: #(#menuBar)		position: 100.1&gt;	^self</body>
</methods>

<methods>
<class-id>Tools.VisualLauncher</class-id> <category>menus - tools - database</category>

<body package="Database" selector="menuItemOpenAdHocSQLQueryTool">menuItemOpenAdHocSQLQueryTool	&lt;menuItemForCommand: #openAdHocSQLQueryTool		nameKey: nil		menu: #(#menuBar #tools #database)		position: 10.1&gt;	self openApplicationForClassNamed: #{AdHocQueryTool}</body>

<body package="Database" selector="submenuToolsDatabase">submenuToolsDatabase	&lt;vwPrivileged&gt;	&lt;submenu: #(#_Database #menus '&amp;Database') 		nameKey: #database 		menu: #(#menuBar #tools) 		position: 30.2&gt;	^self</body>
</methods>

<methods>
<class-id>Tools.VisualLauncher</class-id> <category>menus - store</category>

<body package="Store-UI" selector="areAttached">areAttached	^DbRegistry isConnected</body>

<body package="Store-UI" selector="menuItemBrowseClassDefinitions">menuItemBrowseClassDefinitions	&lt;menuItemForCommand: #storeBrowseClassByName		icon: nil 		nameKey: #browseClassDefinitions 		enablement: #areAttached 		indication: nil 		menu: #(#menuBar #store #browseDefinitions) 		position: 90.04&gt;	^self browseClassDefinitions</body>

<body package="Store-UI" selector="menuItemBrowseNameSpaceDefinitions">menuItemBrowseNameSpaceDefinitions	&lt;menuItemForCommand: #storeBrowseNamespaceByName		icon: nil		nameKey: #browseNameSpaceDefinitions		enablement: #areAttached		indication: nil		menu: #(#menuBar #store #browseDefinitions)		position: 90.10&gt;	^self browseNameSpaceDefinitions</body>

<body package="Store-UI" selector="menuItemBrowseSelector">menuItemBrowseSelector	&lt;menuItemForCommand: #storeBrowseSelectorByName		icon: nil		nameKey: #browseSelector		enablement: #areAttached		indication: nil		menu: #(#menuBar #store #browseDefinitions)		position: 90.06&gt;	^self browseSelector</body>

<body package="Store-UI" selector="menuItemBrowseStatic">menuItemBrowseStatic	&lt;menuItemForCommand: #storeBrowseSharedVariableByName		icon: nil		nameKey: #browseStatic		enablement: #areAttached		indication: nil		menu: #(#menuBar #store #browseDefinitions)		position: 90.08&gt;	^self browseStatic</body>

<body package="Store-UI" selector="menuItemBrowseUnpackaged">menuItemBrowseUnpackaged	&lt;menuItemForCommand: #storeBrowseUnpackaged		icon: nil		nameKey: nil		menu: #(#menuBar #store)		position: 20.07&gt;	^self browseUnpackaged</body>

<body package="Store-UI" selector="menuItemBundleOwnershipManagement">menuItemBundleOwnershipManagement	&lt;menuItemForCommand: #storeManageBundleOwnership		icon: nil		nameKey: #bundleOwnershipManagement		enablement: #areAttached		indication: nil		menu: #(#menuBar #store #administration)		position: 90.04&gt;	^self bundleOwnershipManagement</body>

<body package="Store-UI" selector="menuItemCheckConsistency">menuItemCheckConsistency	&lt;menuItemForCommand: #storeCheckConsistency		icon: nil		nameKey: nil		menu: #(#menuBar #store)		position: 90.99&gt;	^self checkConsistency</body>

<body package="Store-UI" selector="menuItemCurrentPackage">menuItemCurrentPackage	&lt;menuItemForCommand: #storeSetCurrentPackage		icon: nil 		nameKey: #currentPackage		menu: #(#menuBar #store)		position: 50.05&gt;	^self currentPackage</body>

<body package="Store-UI" selector="menuItemOpenLoadedItems">menuItemOpenLoadedItems	&lt;menuItemForCommand: #storeOpenLoadedItems		icon: nil		nameKey: nil		enablement: #areAttached		indication: nil		menu: #(#menuBar #store)		position: 20.01&gt;	^self openLoadedItems</body>

<body package="Store-UI" selector="menuItemOpenNewMergeTool">menuItemOpenNewMergeTool	&lt;menuItemForCommand: #storeOpenMergeTool		nameKey: nil		enablement: #areAttached		indication: nil		menu: #(#menuBar #store )		position: 20.17&gt;	Store.Glorp.MergeTool open.</body>

<body package="Store-UI" selector="menuItemOpenPublishedItems">menuItemOpenPublishedItems	&lt;menuItemForCommand: #storeOpenPublishedItems		icon: nil		nameKey: nil		enablement: #areAttached		indication: nil		menu: #(#menuBar #store)		position: 20.02&gt;	^self openPublishedItems</body>

<body package="Store-UI" selector="menuItemOpenRecentPublishedItems">menuItemOpenRecentPublishedItems	&lt;menuItemForCommand: #storeOpenRecentlyPublishedItems		icon: nil		nameKey: nil		enablement: #areAttached		indication: nil		menu: #(#menuBar #store)		position: 20.05&gt;	^self openRecentPublishedItems</body>

<body package="Store-UI" selector="menuItemOpenStoreForGlorpWorkbook">menuItemOpenStoreForGlorpWorkbook	&lt;menuItemForCommand: #storeOpenWorkbook		nameKey: nil		menu: #(#menuBar #store)		position: 21.5&gt;	Glorp.UI.StoreWorkbook openRequestingDatabase.</body>

<body package="Store-UI" selector="menuItemOpenUISettings">menuItemOpenUISettings	&lt;menuItemForCommand: #storeOpenSettings		icon: nil		nameKey: nil		menu: #(#menuBar #store)		position: 50.01&gt;	SettingsManager 		openOrRaise: VisualWorksSettings 		selectPage: #(#store)</body>

<body package="Store-UI" selector="menuItemPackageOwnershipManagement">menuItemPackageOwnershipManagement	&lt;menuItemForCommand: #storeManagePackageOwnership		icon: nil		nameKey: #packageOwnershipManagement		enablement: #areAttached		indication: nil		menu: #(#menuBar #store #administration)		position: 90.05&gt;	^self packageOwnershipManagement</body>

<body package="Store-UI" selector="menuItemRemoveDatabaseLinks">menuItemRemoveDatabaseLinks	&lt;menuItemForCommand: #storeRemoveDatabaseLinks		icon: nil		nameKey: nil		menu: #(#menuBar #store)		position: 90.10&gt;	^self removeDatabaseLinks</body>

<body package="Store-UI" selector="menuItemRenameBundleInDatabase">menuItemRenameBundleInDatabase	&lt;menuItemForCommand: #storeRenameBundleInDatabase		icon: nil		nameKey: #renameBundle		enablement: #areAttached		indication: nil		menu: #(#menuBar #store #administration)		position: 90.10&gt;	^self renameBundleInDatabase</body>

<body package="Store-UI" selector="menuItemRenamePackageInDatabase">menuItemRenamePackageInDatabase	&lt;menuItemForCommand: #storeRenamePackageInDatabase		icon: nil		nameKey: #renamePackage		enablement: #areAttached		indication: nil		menu: #(#menuBar #store #administration)		position: 90.11&gt;	^self renamePackageInDatabase</body>

<body package="Store-UI" selector="menuItemSwitchDatabases">menuItemSwitchDatabases	&lt;menuItemForCommand: #storeSwitchDatabases		icon: nil		nameKey: nil		enablement: #areAttached		indication: nil		menu: #(#menuBar #store)		position: 90.08&gt;	self switchDatabases</body>

<body package="Store-UI" selector="menuItemToggleStoreRepositoryConnection">menuItemToggleStoreRepositoryConnection	"Dynamic menu label overrides static label in Command."	&lt;menuItemForCommand: #storeToggleConnection		label: #toggleStoreConnectionItemLabel		nameKey: nil		menu: #(#menuBar #store)		position: 10.5&gt;	self toggleStoreRepositoryConnection</body>

<body package="Store-UI" selector="menuItemUserGroupManagement">menuItemUserGroupManagement	&lt;menuItemForCommand: #storeManageUsersAndGroups		icon: nil		nameKey: #userGroupManagement		enablement: #areAttached		indication: nil		menu: #(#menuBar #store #administration)		position: 90.03&gt;	self userGroupManagement</body>

<body package="Store-UI" selector="menuitemOpenGarbageCollectionDialog">menuitemOpenGarbageCollectionDialog	&lt;menuItemForCommand: #storeCollectGarbage		icon: nil		nameKey: nil		enablement: #areAttached		indication: nil		menu: #(#menuBar #store #administration)		position: 90.99&gt;	^self openGarbageCollectionDialog</body>

<body package="Store-UI" selector="noItemsOfType:match:">noItemsOfType: aTypeString match: aString		Dialog warn: (#No1sMatching2s &lt;&lt; #store &gt;&gt; 'No &lt;1s&gt; matching &lt;2s&gt;' expandMacrosWith: aTypeString with: aString)</body>

<body package="Store-UI" selector="notAttached">notAttached	^self areAttached not</body>

<body package="Store-UI" selector="selectNameFrom:chooseTitle:">selectNameFrom: aCollection chooseTitle: aString		^Dialog		choose: (#ChooseA1s &lt;&lt; #store &gt;&gt; 'Choose a &lt;1s&gt;' expandMacrosWith: aString)		fromList: aCollection		values: aCollection		lines: 12		cancel: nil.</body>

<body package="Store-UI" selector="storeRepositoryLabelPart">storeRepositoryLabelPart	| profileName |	profileName := (#Repository &lt;&lt; #store &gt;&gt; 'Repository') asString.	DbRegistry connectedProfile ifNotNil: 		[:profile | 		profile name ifNotNil: 			[:name | profileName := name]].	^profileName</body>

<body package="Store-UI" selector="submenuAdministration">submenuAdministration	&lt;submenu: #(#_Administration #store '&amp;Administration')		nameKey: #administration		menu: #(#menuBar #store)		position: 90.01&gt;</body>

<body package="Store-UI" selector="submenuBrowseDefinitions">submenuBrowseDefinitions	&lt;submenu: #(#Browse_Definitions #store 'Browse &amp;Definitions')		nameKey: #browseDefinitions		menu: #(#menuBar #store)		position: 20.09&gt;</body>

<body package="Store-UI" selector="toggleStoreConnectionItemLabel">toggleStoreConnectionItemLabel	^DbRegistry isConnected 		ifTrue: 			[#DisconnectFrom1s &lt;&lt; #store &gt;&gt; 'Disconnect from &lt;1s&gt;' expandMacrosWith: self storeRepositoryLabelPart]		ifFalse: 			[(#ConnectToRepository &lt;&lt; #store &gt;&gt; 'Connect to Repository...') asString]</body>

<body package="Store-UI" selector="topMenuStore">topMenuStore	&lt;vwPrivileged&gt;	&lt;submenu: #(#St_ore #menus 'St&amp;ore')		nameKey: #store		menu: #(#menuBar)		position: 50.0&gt;	^self</body>
</methods>

<methods>
<class-id>Tools.VisualLauncher</class-id> <category>status registration</category>

<body package="Store-UI" selector="miniRepositoryManager">miniRepositoryManager	&lt;tool: 20.1 width: #intrinsic&gt;	^SubCanvasView		client: Store.MiniRepositoryManager new		spec: Store.MiniRepositoryManager windowSpec</body>

<body package="Store-UI" selector="miniRepositoryManagerGap">miniRepositoryManagerGap	&lt;toolgap: 20 width: #fill&gt;</body>
</methods>

<methods>
<class-id>Tools.VisualLauncher</class-id> <category>store menus</category>

<body package="Store-UI" selector="browseSelector">browseSelector	| name list classes className session matches targetName |	name := Dialog request: (#SelectorNameMatching &lt;&lt; #store &gt;&gt; 'Selector name matching') asString.	name isEmpty ifTrue: [^self].	session := Store.Glorp.StoreLoginFactory currentStoreSession.	[(Gathering for: name) started.	matches := Store.Glorp.StoreMethod allNamesMatching: name in: session.	(Gathering for: name) finished] withStoreFeedbackOn: self mainWindow.	matches isEmpty ifTrue: 		[^self noItemsOfType: (#SelectorName &lt;&lt; #store &gt;&gt; 'Selector name') asString match: name].	(targetName := self selectNameFrom: matches chooseTitle: (#SelectorName &lt;&lt; #store &gt;&gt; 'Selector name') asString) ifNil: [^self].	[(Gathering for: targetName) started.	list := Store.Glorp.StoreMethodInPackage allVersionsWithName: targetName in: session.	classes := list collect: [:each | each classNameWithMeta asSymbol].	classes := classes asSet asSortedCollection asOrderedCollection.	(Gathering for: targetName) finished] withStoreFeedbackOn: self mainWindow.	className := classes size == 1		ifTrue: [classes first]		ifFalse: 			[Dialog 				choose: ((#_1sInWhichClassDots &lt;&lt; #store &gt;&gt; '#&lt;1s&gt; in which class...') expandMacrosWith: targetName)				fromList: classes 				values: classes				lines: 10 				cancel: [^nil]				for: self mainWindow].	[(Gathering for: className) started.	list := Store.Glorp.StoreMethodInPackage allVersionsWithName: targetName inClass: className in: session.	(Gathering for: className) finished] withStoreFeedbackOn: self mainWindow.	Store.Glorp.DefinitionForListTool forMethods: list.</body>

<body package="Store-UI" selector="browseStatic">browseStatic	| name list owners owner session matches targetName typeString |	name  := Dialog request: (#SharedVariableNameMatching &lt;&lt; #store &gt;&gt; 'Shared Variable name matching') asString.	name isEmpty ifTrue: [ ^self ].	session := Store.Glorp.StoreLoginFactory currentStoreSession.	[(Gathering for: name) started.	matches := Store.Glorp.StoreSharedVariable allNamesMatching: name in: session.	(Gathering for: name) finished] withStoreFeedbackOn: self mainWindow.	typeString := (#SharedVariableName &lt;&lt; #store &gt;&gt; 'Shared Variable name') asString.	matches isEmpty ifTrue: 		[^self noItemsOfType: typeString match: name].	(targetName := self selectNameFrom: matches chooseTitle: typeString) ifNil: [^self].	[(Gathering for: targetName) started.	list := Store.Glorp.StoreSharedVariableInPackage allVersionsWithName: targetName in: session.	owners := list collect: [:each | each absoluteOwnerName asSymbol].	owners := owners asSet asSortedCollection asOrderedCollection.	(Gathering for: targetName) finished] withStoreFeedbackOn: self mainWindow.	owner := owners size == 1		ifTrue: [owners first]		ifFalse: 			[Dialog 				choose: ((#_1sInWhichClassOrNameSpaceDots &lt;&lt; #store &gt;&gt; '#&lt;1s&gt; in which Class or NameSpace...')  expandMacrosWith: name )				fromList: owners 				values: owners				lines: 10 				cancel: [^nil]				for: self mainWindow ].	[(Gathering for: owner) started.	list := Store.Glorp.StoreSharedVariableInPackage allVersionsWithName: targetName inOwner: owner in: session.	(Gathering for: owner) finished] withStoreFeedbackOn: self mainWindow.	Store.Glorp.DefinitionForListTool forSharedVariables: list.</body>

<body package="Store-UI" selector="browseUnpackaged">browseUnpackaged	PundleAccess moveUnpackagedToNullPackage.	Refactory.Browser.RefactoringBrowser openOnEnvironment:  (Refactory.Browser.PundleEnvironment new pundles: (List with: Registry nullPackage))</body>

<body package="Store-UI" selector="bundleOwnershipManagement">bundleOwnershipManagement	DbRegistry 		doIfImageAdministrator: [Store.BundlePrivilegeGraph open]		label: (#manageBundleOwnership &lt;&lt; #store &gt;&gt; 'manage bundle ownership') asString</body>

<body package="Store-UI" selector="packageOwnershipManagement">packageOwnershipManagement	DbRegistry 		doIfImageAdministrator: [Store.PrivilegeGraph open]		label: (#manageOwnership &lt;&lt; #store &gt;&gt; 'manage ownership') asString</body>

<body package="Store-UI" selector="removeDatabaseLinks">removeDatabaseLinks	Registry removeDatabaseLinks.</body>

<body package="Store-UI" selector="renameBundleInDatabase">renameBundleInDatabase	DbRegistry 		doIfImageAdministrator: 			[(Dialog confirm: (#RenamingABundleInTNttttttttContinue &lt;&lt; #store &gt;&gt; 'Renaming a bundle in the database will require all existing images to rename to match.&lt;nttttttt&gt;Continue?') expandMacros) ifFalse: [^self].			Store.Glorp.StoreBundle rename]		label: (#renameBundles &lt;&lt; #store &gt;&gt; 'rename bundles') asString</body>

<body package="Store-UI" selector="renamePackageInDatabase">renamePackageInDatabase	DbRegistry 		doIfImageAdministrator: 			[(Dialog confirm: (#RenamingAPackageInNttttttttContinue &lt;&lt; #store &gt;&gt; 'Renaming a package in the database will require all existing images to rename to match.&lt;nttttttt&gt;Continue?') expandMacros) ifFalse: [^self].			Store.Glorp.StorePackage rename]		label: (#renamePackages &lt;&lt; #store &gt;&gt; 'rename packages') asString</body>

<body package="Store-UI" selector="switchDatabases">switchDatabases	Registry switchDatabases.</body>

<body package="Store-UI" selector="userGroupManagement">userGroupManagement	DbRegistry 		doIfImageAdministrator: [Store.GroupGraph open]		label: (#manageUserGroups &lt;&lt; #store &gt;&gt; 'manage user/groups') asString</body>
</methods>

</st-source>
