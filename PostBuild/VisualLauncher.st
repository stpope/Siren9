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

<body package="Tools-Misc" selector="classMethodsChanged">classMethodsChanged

<body package="Tools-Misc" selector="instanceMethodsChanged">instanceMethodsChanged
</methods>

<methods>
<class-id>Tools.VisualLauncher class</class-id> <category>interface specs</category>

<body package="Tools-Misc" selector="interfaceSpecFor:">interfaceSpecFor: aSymbol

<body package="Tools-Misc" selector="windowSpec">windowSpec
</methods>

<methods>
<class-id>Tools.VisualLauncher class</class-id> <category>generated resources</category>

<body package="Tools-Misc" selector="allClassesIcon">allClassesIcon

<body package="Tools-Misc" selector="allParcelsIcon">allParcelsIcon

<body package="Tools-Parcel Manager" selector="cardfile">cardfile

<body package="Tools-Misc" selector="dbToolIcon">dbToolIcon

<body package="Tools-Misc" selector="extFinderIcon">extFinderIcon

<body package="Tools-Misc" selector="fileListIcon">fileListIcon

<body package="UIPainter" selector="finderIcon">finderIcon

<body package="Tools-Misc" selector="helpIcon">helpIcon

<body package="Tools-Misc" selector="newCanvasIcon">newCanvasIcon

<body package="Tools-Settings-VW" selector="properties">properties

<body package="Tools-Misc" selector="systemIcon">systemIcon

<body package="Tools-Misc" selector="workspaceIcon">workspaceIcon
</methods>

<methods>
<class-id>Tools.VisualLauncher class</class-id> <category>accessing</category>

<body package="Tools-Misc" selector="checkInstalledComponents">checkInstalledComponents

<body package="Tools-Misc" selector="raiseOrOpen">raiseOrOpen

<body package="Non-Commercialization" selector="title">title
</methods>

<methods>
<class-id>Tools.VisualLauncher class</class-id> <category>private</category>

<body package="Tools-Misc" selector="statusPragmas">statusPragmas
</methods>

<methods>
<class-id>Tools.VisualLauncher class</class-id> <category>interface opening</category>

<body package="Tools-Misc" selector="open">open
</methods>

<methods>
<class-id>Tools.VisualLauncher class</class-id> <category>fileIn/Out</category>

<body package="Tools-Misc" selector="prerequisitesForLoading">prerequisitesForLoading
</methods>

<methods>
<class-id>Tools.VisualLauncher class</class-id> <category>resources</category>

<body package="UIPainter" selector="BWAppFinder24">BWAppFinder24

<body package="UIPainter" selector="CGAppFinder24">CGAppFinder24
</methods>

<!-- -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -   -->


<comment>
<class-id>Tools.VisualLauncher</class-id>
<body>VisualLauncher provides complete and convenient access to the VisualWorks functionality. It enables the user to save the image, change system settings, access Smalltalk programming tools, database application development tools, UIPainter and its auxiliary tools, manage multiple windows and access the VW Online Documentation. ValueHolders for the menuBar and toolBar provide convenient access these items, but either must be augmented as desired by other components using the appropriate menu pragmas.  Some menus allow menu augmentation only in restricted sections.  Restricting menu ranges in this way is limited to the private, exclusive use of VisualWorks core components.
</comment>

<methods>
<class-id>Tools.VisualLauncher</class-id> <category>initialize-release</category>

<body package="Tools-Misc" selector="initialize">initialize

<body package="Tools-Misc" selector="release">release

<body package="Tools-Misc" selector="winNewLauncher">winNewLauncher
</methods>

<methods>
<class-id>Tools.VisualLauncher</class-id> <category>actions</category>

<body package="Tools-Programming" selector="browseAmbiguousReferences">browseAmbiguousReferences

<body package="Store-UI" selector="browseClassDefinitions">browseClassDefinitions

<body package="Tools-Misc" selector="browseGlobal">browseGlobal

<body package="Tools-Misc" selector="browseGlobalName">browseGlobalName

<body package="Tools-Misc" selector="browseImplementorsOf">browseImplementorsOf

<body package="Tools-Misc" selector="browseInspect">browseInspect

<body package="Tools-Misc" selector="browseMethodsWithStringMatches">browseMethodsWithStringMatches

<body package="Store-UI" selector="browseNameSpaceDefinitions">browseNameSpaceDefinitions

<body package="Tools-Misc" selector="browseSendersOf">browseSendersOf

<body package="Tools-Misc" selector="browseSystem">browseSystem

<body package="Tools-Misc" selector="changesFileCondense">changesFileCondense

<body package="Store-UI" selector="checkConsistency">checkConsistency

<body package="Tools-Misc" selector="clearTranscript">clearTranscript

<body package="Tools-Misc" selector="collectAllGarbage">collectAllGarbage

<body package="Tools-Misc" selector="collectGarbage">collectGarbage

<body package="Store-UI" selector="currentPackage">currentPackage

<body package="Tools-Misc" selector="filePermSaveAs">filePermSaveAs

<body package="Tools-Misc" selector="filePermUndoAs">filePermUndoAs

<body package="Tools-Misc" selector="helpAbout">helpAbout

<body package="Tools-Misc" selector="imageSave">imageSave

<body package="Tools-Misc" selector="imageSaveAs">imageSaveAs

<body package="Tools-Misc" selector="inspectProcessor">inspectProcessor

<body package="Tools-Misc" selector="inspectScheduledControllers">inspectScheduledControllers

<body package="Store-UI" selector="openFilteredLoadedItems">openFilteredLoadedItems

<body package="Store-UI" selector="openFilteredPublishedItems">openFilteredPublishedItems

<body package="Store-UI" selector="openFilteredRecentPublishedItems">openFilteredRecentPublishedItems

<body package="Store-UI" selector="openGarbageCollectionDialog">openGarbageCollectionDialog

<body package="Store-UI" selector="openLoadedItems">openLoadedItems

<body package="Store-UI" selector="openPublishedItems">openPublishedItems

<body package="Store-UI" selector="openRecentPublishedItems">openRecentPublishedItems

<body package="Store-UI" selector="openUISettings">openUISettings

<body package="Store-UI" selector="toggleStoreRepositoryConnection">toggleStoreRepositoryConnection

<body package="Tools-Misc" selector="toggleToolbar">toggleToolbar

<body package="Tools-Misc" selector="visualWorksExit">visualWorksExit

<body package="Tools-Misc" selector="visualWorksLauncher">visualWorksLauncher

<body package="Tools-Misc" selector="winCollapseAll">winCollapseAll

<body package="Tools-Misc" selector="winRefreshAll">winRefreshAll

<body package="Tools-Misc" selector="winRestoreAll">winRestoreAll
</methods>

<methods>
<class-id>Tools.VisualLauncher</class-id> <category>changing</category>

<body package="Tools-Misc" selector="changeRequest">changeRequest
</methods>

<methods>
<class-id>Tools.VisualLauncher</class-id> <category>interface opening</category>

<body package="Tools-Misc" selector="postBuildWith:">postBuildWith: aBuilder

<body package="Tools-Misc" selector="postOpenWith:">postOpenWith: aBuilder 
</methods>

<methods>
<class-id>Tools.VisualLauncher</class-id> <category>accessing</category>

<body package="Tools-Misc" selector="textCollector">textCollector

<body package="Tools-Misc" selector="textCollector:">textCollector: aTextCollector

<body package="Tools-Misc" selector="transcriptView">transcriptView
</methods>

<methods>
<class-id>Tools.VisualLauncher</class-id> <category>menus</category>

<body package="Tools-Misc" selector="buildMenuFor:">buildMenuFor: aMenuName

<body package="Tools-Misc" selector="installMenuRangeRestrictions">installMenuRangeRestrictions

<body package="Tools-Misc" selector="launcherMenuBar">launcherMenuBar

<body package="Tools-Misc" selector="launcherToolBar">launcherToolBar

<body package="Tools-Misc" selector="rebuildMenu">rebuildMenu

<body package="Tools-Misc" selector="updateToolbar">updateToolbar
</methods>

<methods>
<class-id>Tools.VisualLauncher</class-id> <category>private</category>

<body package="Tools-Misc" selector="applicationForClassNamed:do:">applicationForClassNamed: aSymbol do: aBlock

<body package="Tools-Misc" selector="closeDialog">closeDialog

<body package="Tools-Misc" selector="enableConnections">enableConnections

<body package="Tools-Misc" selector="inspectDependentsFieldsLabel">inspectDependentsFieldsLabel

<body package="Tools-Misc" selector="inspectUndeclaredLabel">inspectUndeclaredLabel

<body package="Tools-Misc" selector="noticeOfWindowClose:">noticeOfWindowClose: aWindow

<body package="Tools-Misc" selector="openApplicationForClassNamed:">openApplicationForClassNamed: aSymbol

<body package="Tools-Misc" selector="openApplicationForClassNamed:withSelector:">openApplicationForClassNamed: aSymbol withSelector: aSelectorSymbol

<body package="Tools-Misc" selector="toolbarVisible">toolbarVisible

<body package="Tools-Misc" selector="updateStatusBar">updateStatusBar
</methods>

<methods>
<class-id>Tools.VisualLauncher</class-id> <category>menus - file</category>

<body package="Tools-Misc" selector="menuItemExitVisualWorks">menuItemExitVisualWorks

<body package="Tools-Workspace" selector="menuItemFileOpen">menuItemFileOpen

<body package="Tools-Misc" selector="menuItemFilePermSaveImageAs">menuItemFilePermSaveImageAs

<body package="Tools-Misc" selector="menuItemFilePermUndoAs">menuItemFilePermUndoAs

<body package="Headless" selector="menuItemFileSaveHeadlessImageAs">menuItemFileSaveHeadlessImageAs

<body package="Tools-Misc" selector="menuItemFileSaveImage">menuItemFileSaveImage

<body package="Tools-Misc" selector="menuItemFileSaveImageAs">menuItemFileSaveImageAs

<body package="Tools-Settings-VW" selector="menuItemSetVisualWorksHome">menuItemSetVisualWorksHome

<body package="Tools-Misc" selector="topMenuFile">topMenuFile
</methods>

<methods>
<class-id>Tools.VisualLauncher</class-id> <category>menus - help</category>

<body package="Non-Commercialization" selector="aboutVisualWorksLabel">aboutVisualWorksLabel

<body package="Tools-Misc" selector="menuItemAboutVisualWorks">menuItemAboutVisualWorks

<body package="Non-Commercialization" selector="menuItemHelpGettingStartedWorkspace">menuItemHelpGettingStartedWorkspace

<body package="Tools-Workspace" selector="menuItemHelpInstallationWorkspace">menuItemHelpInstallationWorkspace

<body package="Non-Commercialization" selector="menuItemHelpIntroductoryWorkspace">menuItemHelpIntroductoryWorkspace

<body package="Tools-Misc" selector="menuItemHelpLauncher">menuItemHelpLauncher

<body package="Non-Commercialization" selector="menuItemHelpNonCommercialWorkspace">menuItemHelpNonCommercialWorkspace

<body package="Tools-Misc" selector="menuItemHelpObjectReference">menuItemHelpObjectReference

<body package="Tools-Misc" selector="menuItemHelpOpenHelpBrowser">menuItemHelpOpenHelpBrowser

<body package="Tools-Workspace" selector="menuItemHelpSystemWorkspace">menuItemHelpSystemWorkspace

<body package="Tools-Misc" selector="menuItemHelpWelcome">menuItemHelpWelcome

<body package="Tools-Misc" selector="topMenuHelp">topMenuHelp
</methods>

<methods>
<class-id>Tools.VisualLauncher</class-id> <category>menus - browse</category>

<body package="Tools-Programming" selector="browseAmbiguousReferencesLabel">browseAmbiguousReferencesLabel

<body package="Tools-Programming" selector="menuItemBrowseAmbiguousReferences">menuItemBrowseAmbiguousReferences

<body package="Tools-Misc" selector="menuItemBrowseClassVariableNamespace">menuItemBrowseClassVariableNamespace

<body package="Tools-Misc" selector="menuItemBrowseImplementorsOfSelector">menuItemBrowseImplementorsOfSelector

<body package="Tools-Misc" selector="menuItemBrowseInspectDependentsFields">menuItemBrowseInspectDependentsFields

<body package="Tools-Misc" selector="menuItemBrowseInspectProcessor">menuItemBrowseInspectProcessor

<body package="Tools-Misc" selector="menuItemBrowseInspectScheduledControllers">menuItemBrowseInspectScheduledControllers

<body package="Tools-Misc" selector="menuItemBrowseInspectUndeclared">menuItemBrowseInspectUndeclared

<body package="Tools-Misc" selector="menuItemBrowseInspectVariable">menuItemBrowseInspectVariable

<body package="Tools-Misc" selector="menuItemBrowseMethodsWithStringMatches">menuItemBrowseMethodsWithStringMatches

<body package="Tools-Misc" selector="menuItemBrowseReferencesToClassVariableNamespace">menuItemBrowseReferencesToClassVariableNamespace

<body package="Tools-Misc" selector="menuItemBrowseSendersOfSelector">menuItemBrowseSendersOfSelector

<body package="Tools-Misc" selector="menuItemBrowseSystem">menuItemBrowseSystem

<body package="Tools-Misc" selector="submenuBrowseInspect">submenuBrowseInspect

<body package="Tools-Misc" selector="topMenuBrowse">topMenuBrowse
</methods>

<methods>
<class-id>Tools.VisualLauncher</class-id> <category>menus - tools</category>

<body package="Tools-Workspace" selector="menuItemNewWorkspace">menuItemNewWorkspace

<body package="Tools-Changes" selector="menuItemOpenChangeList">menuItemOpenChangeList

<body package="Tools-File Browser" selector="menuItemOpenFileBrowser">menuItemOpenFileBrowser

<body package="Tools-Parcel Manager" selector="menuItemOpenParcelManager">menuItemOpenParcelManager

<body package="Tools-Misc" selector="topMenuTools">topMenuTools
</methods>

<methods>
<class-id>Tools.VisualLauncher</class-id> <category>menus - system</category>

<body package="Tools-Misc" selector="menuItemClearTranscript">menuItemClearTranscript

<body package="Tools-Misc" selector="menuItemCollectAllGarbage">menuItemCollectAllGarbage

<body package="Tools-Misc" selector="menuItemCollectGarbage">menuItemCollectGarbage

<body package="Tools-Misc" selector="menuItemLoadParcelByName">menuItemLoadParcelByName

<body package="Tools-Misc" selector="menuItemUnloadParcelByName">menuItemUnloadParcelByName

<body package="Tools-Settings-VW" selector="menuItemVisualWorksSettings">menuItemVisualWorksSettings

<body package="Tools-Misc" selector="topMenuSystem">topMenuSystem
</methods>

<methods>
<class-id>Tools.VisualLauncher</class-id> <category>events</category>

<body package="Tools-Misc" selector="windowEvent:from:">windowEvent: anEvent from: aWindow
</methods>

<methods>
<class-id>Tools.VisualLauncher</class-id> <category>menus - changes</category>

<body package="Tools-Misc" selector="menuItemChangesFileCondense">menuItemChangesFileCondense

<body package="Tools-Changes" selector="menuItemOpenChangeSets">menuItemOpenChangeSets

<body package="Tools-Changes" selector="menuItemOpenSystemOverrides">menuItemOpenSystemOverrides

<body package="Tools-Misc" selector="submenuSystemChanges">submenuSystemChanges
</methods>

<methods>
<class-id>Tools.VisualLauncher</class-id> <category>toolbar</category>

<body package="Tools-Misc" selector="toolbarItemBrowseClassVariableNamespace">toolbarItemBrowseClassVariableNamespace

<body package="Tools-Misc" selector="toolbarItemBrowseImplementorsOfSelector">toolbarItemBrowseImplementorsOfSelector

<body package="Tools-Misc" selector="toolbarItemBrowseReferencesToClassVariableNamespace">toolbarItemBrowseReferencesToClassVariableNamespace

<body package="Tools-Misc" selector="toolbarItemBrowseSendersOfSelector">toolbarItemBrowseSendersOfSelector

<body package="Tools-Misc" selector="toolbarItemBrowseSystem">toolbarItemBrowseSystem

<body package="UIPainter" selector="toolbarItemNewCanvas">toolbarItemNewCanvas

<body package="Tools-Workspace" selector="toolbarItemNewWorkspace">toolbarItemNewWorkspace

<body package="Tools-File Browser" selector="toolbarItemOpenFileBrowser">toolbarItemOpenFileBrowser

<body package="Tools-Parcel Manager" selector="toolbarItemOpenParcelManager">toolbarItemOpenParcelManager

<body package="Tools-Misc" selector="toolbarItemSaveImage">toolbarItemSaveImage

<body package="Tools-Settings-VW" selector="toolbarItemVisualWorksSettings">toolbarItemVisualWorksSettings
</methods>

<methods>
<class-id>Tools.VisualLauncher</class-id> <category>menus - window</category>

<body package="Tools-Misc" selector="menuItemCollapseAllWindows">menuItemCollapseAllWindows

<body package="Tools-Misc" selector="menuItemDynamicWindowsMenu">menuItemDynamicWindowsMenu

<body package="Tools-Misc" selector="menuItemOpenNewLauncher">menuItemOpenNewLauncher

<body package="Tools-Misc" selector="menuItemRefreshAllWindows">menuItemRefreshAllWindows

<body package="Tools-Misc" selector="menuItemRestoreAllWindows">menuItemRestoreAllWindows

<body package="Tools-Misc" selector="menuItemToggleToolbar">menuItemToggleToolbar

<body package="Tools-Misc" selector="topMenuWindow">topMenuWindow
</methods>

<methods>
<class-id>Tools.VisualLauncher</class-id> <category>menus - window - dynamic</category>

<body package="Tools-Misc" selector="bringToFront:">bringToFront: view 

<body package="Tools-Misc" selector="classNameInitials:">classNameInitials: anObject

<body package="Tools-Misc" selector="currentWindowLabelsAndViews">currentWindowLabelsAndViews

<body package="Tools-Misc" selector="currentWindowMenuGroups">currentWindowMenuGroups

<body package="Tools-Misc" selector="selectAndRaiseViewAmong:">selectAndRaiseViewAmong: labelsAndViews

<body package="Tools-Misc" selector="windowMenuItemFor:at:">windowMenuItemFor: labelViewAssociation at: anInteger

<body package="Tools-Misc" selector="windowMenuItemsFrom:">windowMenuItemsFrom: labelsAndViews
</methods>

<methods>
<class-id>Tools.VisualLauncher</class-id> <category>menus - pdp</category>

<body package="Debugger-Support" selector="menuItemBrowseAllProbedMethods">menuItemBrowseAllProbedMethods

<body package="Debugger-Support" selector="menuItemClearTestExpressionLibrary">menuItemClearTestExpressionLibrary

<body package="Debugger-Support" selector="menuItemClearWatchExpressionLibrary">menuItemClearWatchExpressionLibrary

<body package="Debugger-Support" selector="menuItemInspectDebugVars">menuItemInspectDebugVars

<body package="Debugger-Support" selector="menuItemInspectTestExpressionLibrary">menuItemInspectTestExpressionLibrary

<body package="Debugger-Support" selector="menuItemInspectWatchExpressionLibrary">menuItemInspectWatchExpressionLibrary

<body package="Debugger-Support" selector="menuItemLoadTestExpressionLibrary">menuItemLoadTestExpressionLibrary

<body package="Debugger-Support" selector="menuItemLoadWatchExpressionLibrary">menuItemLoadWatchExpressionLibrary

<body package="Debugger-Process Monitor" selector="menuItemOpenProcessMonitor">menuItemOpenProcessMonitor

<body package="Debugger-Support" selector="menuItemPurgeUnusedVars">menuItemPurgeUnusedVars

<body package="Debugger-Support" selector="menuItemPurgeUnusedWatches">menuItemPurgeUnusedWatches

<body package="Debugger-Support" selector="menuItemReadProbeLibrary">menuItemReadProbeLibrary

<body package="Debugger-Support" selector="menuItemRemoveAllProbes">menuItemRemoveAllProbes

<body package="Debugger-Support" selector="menuItemSaveProbeLibrary">menuItemSaveProbeLibrary

<body package="Debugger-Support" selector="menuItemSaveTestExpressionLibrary">menuItemSaveTestExpressionLibrary

<body package="Debugger-Support" selector="menuItemSaveWatchExpressionLibrary">menuItemSaveWatchExpressionLibrary

<body package="Debugger-Support" selector="menuItemToggleDebugging">menuItemToggleDebugging

<body package="Debugger-Support" selector="submenuProbeLibrary">submenuProbeLibrary

<body package="Debugger-Support" selector="submenuTestLibrary">submenuTestLibrary

<body package="Debugger-Support" selector="submenuWatchLibrary">submenuWatchLibrary

<body package="Debugger-Support" selector="toggleDebuggingLabel">toggleDebuggingLabel

<body package="Debugger-Support" selector="topMenuDebug">topMenuDebug
</methods>

<methods>
<class-id>Tools.VisualLauncher</class-id> <category>menus - uipainter</category>

<body package="UIPainter" selector="menuItemCodingAssistant">menuItemCodingAssistant

<body package="UIPainter" selector="menuItemHotRegionsEditor">menuItemHotRegionsEditor

<body package="UIPainter" selector="menuItemMaskEditor">menuItemMaskEditor

<body package="UIPainter" selector="menuItemMenuEditor">menuItemMenuEditor

<body package="UIPainter" selector="menuItemNewCanvas">menuItemNewCanvas

<body package="UIPainter" selector="menuItemResourceFinder">menuItemResourceFinder

<body package="UIPainter" selector="topMenuUIPainter">topMenuUIPainter
</methods>

<methods>
<class-id>Tools.VisualLauncher</class-id> <category>menus - tools - database</category>

<body package="Database" selector="menuItemOpenAdHocSQLQueryTool">menuItemOpenAdHocSQLQueryTool

<body package="Database" selector="submenuToolsDatabase">submenuToolsDatabase
</methods>

<methods>
<class-id>Tools.VisualLauncher</class-id> <category>menus - store</category>

<body package="Store-UI" selector="areAttached">areAttached

<body package="Store-UI" selector="menuItemBrowseClassDefinitions">menuItemBrowseClassDefinitions

<body package="Store-UI" selector="menuItemBrowseNameSpaceDefinitions">menuItemBrowseNameSpaceDefinitions

<body package="Store-UI" selector="menuItemBrowseSelector">menuItemBrowseSelector

<body package="Store-UI" selector="menuItemBrowseStatic">menuItemBrowseStatic

<body package="Store-UI" selector="menuItemBrowseUnpackaged">menuItemBrowseUnpackaged

<body package="Store-UI" selector="menuItemBundleOwnershipManagement">menuItemBundleOwnershipManagement

<body package="Store-UI" selector="menuItemCheckConsistency">menuItemCheckConsistency

<body package="Store-UI" selector="menuItemCurrentPackage">menuItemCurrentPackage

<body package="Store-UI" selector="menuItemOpenLoadedItems">menuItemOpenLoadedItems

<body package="Store-UI" selector="menuItemOpenNewMergeTool">menuItemOpenNewMergeTool

<body package="Store-UI" selector="menuItemOpenPublishedItems">menuItemOpenPublishedItems

<body package="Store-UI" selector="menuItemOpenRecentPublishedItems">menuItemOpenRecentPublishedItems

<body package="Store-UI" selector="menuItemOpenStoreForGlorpWorkbook">menuItemOpenStoreForGlorpWorkbook

<body package="Store-UI" selector="menuItemOpenUISettings">menuItemOpenUISettings

<body package="Store-UI" selector="menuItemPackageOwnershipManagement">menuItemPackageOwnershipManagement

<body package="Store-UI" selector="menuItemRemoveDatabaseLinks">menuItemRemoveDatabaseLinks

<body package="Store-UI" selector="menuItemRenameBundleInDatabase">menuItemRenameBundleInDatabase

<body package="Store-UI" selector="menuItemRenamePackageInDatabase">menuItemRenamePackageInDatabase

<body package="Store-UI" selector="menuItemSwitchDatabases">menuItemSwitchDatabases

<body package="Store-UI" selector="menuItemToggleStoreRepositoryConnection">menuItemToggleStoreRepositoryConnection

<body package="Store-UI" selector="menuItemUserGroupManagement">menuItemUserGroupManagement

<body package="Store-UI" selector="menuitemOpenGarbageCollectionDialog">menuitemOpenGarbageCollectionDialog

<body package="Store-UI" selector="noItemsOfType:match:">noItemsOfType: aTypeString match: aString

<body package="Store-UI" selector="notAttached">notAttached

<body package="Store-UI" selector="selectNameFrom:chooseTitle:">selectNameFrom: aCollection chooseTitle: aString

<body package="Store-UI" selector="storeRepositoryLabelPart">storeRepositoryLabelPart

<body package="Store-UI" selector="submenuAdministration">submenuAdministration

<body package="Store-UI" selector="submenuBrowseDefinitions">submenuBrowseDefinitions

<body package="Store-UI" selector="toggleStoreConnectionItemLabel">toggleStoreConnectionItemLabel

<body package="Store-UI" selector="topMenuStore">topMenuStore
</methods>

<methods>
<class-id>Tools.VisualLauncher</class-id> <category>status registration</category>

<body package="Store-UI" selector="miniRepositoryManager">miniRepositoryManager

<body package="Store-UI" selector="miniRepositoryManagerGap">miniRepositoryManagerGap
</methods>

<methods>
<class-id>Tools.VisualLauncher</class-id> <category>store menus</category>

<body package="Store-UI" selector="browseSelector">browseSelector

<body package="Store-UI" selector="browseStatic">browseStatic

<body package="Store-UI" selector="browseUnpackaged">browseUnpackaged

<body package="Store-UI" selector="bundleOwnershipManagement">bundleOwnershipManagement

<body package="Store-UI" selector="packageOwnershipManagement">packageOwnershipManagement

<body package="Store-UI" selector="removeDatabaseLinks">removeDatabaseLinks

<body package="Store-UI" selector="renameBundleInDatabase">renameBundleInDatabase

<body package="Store-UI" selector="renamePackageInDatabase">renamePackageInDatabase

<body package="Store-UI" selector="switchDatabases">switchDatabases

<body package="Store-UI" selector="userGroupManagement">userGroupManagement
</methods>

</st-source>