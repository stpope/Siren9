'From VisualWorks® Personal Use Edition, 8.3 of July 28, 2017 on May 9, 2020 at 10:44:32 AM'!


!UI.WidgetPolicy class methodsFor: 'private-initializing'!

initializeDefaultGenericColors
	"	WidgetPolicy initialize.
		WidgetPolicy subclasses do: [ :class | class initialize].
		Screen default flushPaintPreferencesCache.
		ScheduledControllers restore "

	| background |
	background := ((ColorValue lightYellow blendWith: ColorValue white) 
				blendWith: ColorValue white) "blendWith: ColorValue veryLightGray".
	self allPreferencesDo: [ :preferences | 
		preferences
			matchAt: SymbolicPaint border put: ColorValue lightGray;
			matchAt: SymbolicPaint foreground put: ColorValue black;
			matchAt: SymbolicPaint background put: background;
			matchAt: SymbolicPaint selectionForeground put: ColorValue black;
			matchAt: SymbolicPaint selectionBackground put: (background blendWith: ColorValue gray);
			matchAt: SymbolicPaint inactiveBackground put: ColorValue white;
			matchAt: SymbolicPaint inactiveForeground put: ColorValue gray;
			matchAt: SymbolicPaint inactiveSelectionBackground put: ColorValue lightGray;
			matchAt: SymbolicPaint hilite put: preferences backgroundColor asHiliteColor;
			matchAt: SymbolicPaint shadow put: preferences backgroundColor asShadowColor;
			matchAt: SymbolicPaint separator put: ColorValue gray;
			matchAt: SymbolicPaint traversalHilite put: ColorValue gray
	].
	self defaultGrayWidgetColors
		matchAt: SymbolicPaint selectionBackground put: ColorValue lightGray.
	self defaultMonochromeWidgetColors
		matchAt: SymbolicPaint selectionForeground put: ColorValue white;
		matchAt: SymbolicPaint selectionBackground put: ColorValue black! !

WidgetPolicy initialize.
	WidgetPolicy subclasses do: [ :class | class initialize].
	Screen default flushPaintPreferencesCache.
	ScheduledControllers restore!