﻿"Filed out from Dolphin Smalltalk 7"!

UI.ControlBarAbstract subclass: #'UI.StatusBar'
	instanceVariableNames: 'parts leftOverSeparator layoutManager'
	classVariableNames: ''
	imports: #(#{OS.StatusBarConstants})
	classInstanceVariableNames: ''
	classConstants: {}!
UI.StatusBar guid: (Core.GUID fromString: '{87b4c72e-026e-11d3-9fd7-00a0cc3e4a32}')!
UI.StatusBar comment: 'StatusBar is a <compositeView> implementing the Windows "Msctls_Statusbar32" common control.

StatusBar holds a list of items, sub-instances of <StatusItem>, matching the order of items in the control. Items may be added and deleted once the view has been created. It also allows a name to be associated with each item. 

Note that, internally, an additional separator is  placed as the first item in the status common control when there are no user parts. This is because the common control does not allow you to remove all the items completely.

Instance Variables:
	parts				<OrderedCollection> of <StatusOwnerDraw> items.
	leftOverSeparator	<StatusOwnerDraw> which is the spare separator item.
	layoutManager		<layoutManager> or nil, for managing the layout of sub-views.

'!
!UI.StatusBar categoriesForClass!MVP-Views! !
!UI.StatusBar methodsFor!

addItem: aStatusBarItem 
	"Append a new <StatusBarItem> to the list of items displayed in the receiver. Answer the new
	item."

	aStatusBarItem parentView: self.
	parts := self contents copyWith: aStatusBarItem.
	self updateItem: aStatusBarItem.
	^aStatusBarItem!

addItem: aStatusBarItem name: aString 
	"Append a new <StatusBarItem> to the list of items displayed in the receiver, associating
	the new item with the specified <String> name. Answer the new item."

	self addItem: aStatusBarItem.
	self name: aStatusBarItem as: aString.
	^aStatusBarItem!

calculateEdgesForWidth: anInteger
	| edges right fixedWidth numResizable widths numParts borders rectBorder share |
	numParts := parts size.
	self assert: [numParts < 256].	"common control limitation"
	numParts < 1
		ifTrue: 
			["Control can't actually contain no parts, so we put a dummy one in."
			^SDWORDArray with: -1].
	numResizable := 0.
	fixedWidth := 0.
	widths := parts collect: 
					[:each |
					| width |
					width := each width.
					width = -1 ifTrue: [numResizable := numResizable + 1] ifFalse: [fixedWidth := fixedWidth + width].
					width].
	borders := self sbGetBorders.
	right := borders at: 2.
	share := numResizable = 0
				ifFalse: [(anInteger - right - fixedWidth - self scrollbarWidth) // numResizable].
	rectBorder := borders at: 3.
	edges := SDWORDArray new: numParts.
	widths keysAndValuesDo: 
			[:i :cx |
			| width |
			width := cx = -1 ifTrue: [share] ifFalse: [cx].
			right := right + width + rectBorder.
			edges at: i put: right].
	"Special case last resizable edge"
	widths last = -1 ifTrue: [edges at: numParts put: -1].
	^edges!

contents
	"Answer a copy of all the accessible parts of the receiver."

	^parts copyWithout: leftOverSeparator!

defaultExtent
	"Private - Answer the default size of the receiver
	to be used when it is created."

	^##(350 @ 20)!

defaultWindowStyle
	"Private - Answer a default base style to use when creating the receiver"

	^super defaultWindowStyle bitOr: ##(SBARS_SIZEGRIP | SBARS_TOOLTIPS)!

getWindowText
	"Private - Answers the text from the receiver. There is a bug in
	the status common control which will fail if the first part has
	SBT_OWNERDRAW set."

	^''!

getWindowTextLength
	"Private - Answers the length of text for the receiver. There is
	a bug in the status common control which will fail if the first part
	has SBT_OWNERDRAW set."

	^0!

hasSizeGrip
	"Answers true if the receiver has a sizeing grip.
	i.e. it has the SBARS_SIZEGRIP style"

	^self baseStyleAllMask: SBARS_SIZEGRIP!

hasSizeGrip: aBoolean 
	"Sets the receiver to have a sizeing grip if aBoolean is true. This is the SBARS_SIZEGRIP
	style."

	" Implementation Note: Help doesn't specify, but recreate is required to add or remove this
	style. Also, on XP turning off the style has no effect if the status bar is created or
	recreated as a child of a window with a resizable frame."

	self 
		baseStyleMask: SBARS_SIZEGRIP
		set: aBoolean
		recreateIfChanged: true!

hasToolTips
	"Answer whether or not the receiver has tool tips (i.e. the SBARS_TOOLTIPS style)."

	^self baseStyleAllMask: SBARS_TOOLTIPS!

hasToolTips: aBoolean 
	"Set whether or not the receiver has tool tips (i.e. the SBARS_TOOLTIPS style)."

	"Implementation Note: Help says recreate needed to add this style."

	self 
		baseStyleMask: SBARS_TOOLTIPS
		set: aBoolean
		recreateIfChanged: true!

indexFromPoint: aPoint 
	"Private - Answer the index of the object in the list under the <Point> argument, or nil if
	none."

	^(1 to: parts size) detect: [:i | (self itemRect: i) containsPoint: aPoint] ifNone: [0]!

indexOfItem: part 
	"Private - Answer the 1-based <integer> index of part."

	^parts identityIndexOf: part!

initialize
	"Private - Initialize the state of the receiver.

	Note that we ensure that an empty separator is included as
	the first part. This is because of an apparent common control bug
	when you remove the last part in a status view, the SB_SETPARTS will
	return an error."

	super initialize.
	(leftOverSeparator := StatusBarNullItem separator: 0) parentView: self.
	parts := {leftOverSeparator}!

itemAtIndex: anIntegerIndex 
	"Answers the status bar item at anIntegerIndex in the receiver"

	^parts at: anIntegerIndex!

itemFromId: dwItemSpec
	"Private - Answers the sub-item of the receiver with the specified <integer> item spec."

	^parts lookup: dwItemSpec + 1!

itemRect: anInteger 
	"Answer the bounding <Rectangle> for the button at the specified 1-based <Integer> index."

	| rect |
	rect := (self sbGetRect: anInteger - 1) asRectangle.
	"There is an apparent bug in the status bar control in that it may report the rectangle of
	the last item wrongly"
	(rect width = 0 and: [self width > 0]) ifTrue: [rect width: self width].
	^rect!

items
	"Private - Answer the receiver's <OrderedCollection> of <StatusItem>s."

	^parts asOrderedCollection!

items: tools 
	"Private - Sets the receiver's collection of <StatusItem>s to those in 
	the <collection>, tools.
	Implementation Note: The items are stored as an <Array> to save space."

	parts := tools asArray.
	self recreate!

layout: aLayoutContext 
	"Private - Recalculate the geometry of the receiver."

	"Implementation Note: After performing the normal layout operation we want to recalculate
	the widths of the automatically resizing items."

	super layout: aLayoutContext.
	self setRightEdges: (aLayoutContext clientRectangleOf: self) width!

layoutManager
	"Answer the layout manager for the receiver"

	^layoutManager!

layoutManager: aLayoutManager 
	"Set the layout manager for the receiver to aLayoutManager"

	layoutManager := aLayoutManager.
	self basicInvalidateLayout!

onDrawItem: drawItemStruct 
	| part |
	part := parts at: drawItemStruct itemID + 1.
	part drawItem: (Canvas withNonOwnedDC: drawItemStruct hDC)
		bounding: drawItemStruct rcItem asRectangle.
	^true!

onViewCreated
	"The receiver window has been created. Copy the info held
	in instance variables across to it."

	super onViewCreated.
	self setControlBackcolor.
	self setRightEdges.
	parts do: 
			[:part | 
			part parentView: self.
			self setText: part]!

rectangleOfItem: aStatusBarItem 
	^self itemRect: (self indexOfItem: aStatusBarItem)!

removeItem: aStatusBarItem 
	"Remove aStatusOwnerDraw from the receivers contents of visible parts.
	Answer aStatusOwnerDraw.

	Note that we always ensure that there is one part, the leftOverSeparator,
	registered with the common control to get around a bug in the control."

	| partIndex |
	partIndex := parts indexOfItem: aStatusBarItem.
	parts size = 1 ifTrue: [self addItem: leftOverSeparator].
	parts remove: aStatusBarItem.
	aStatusBarItem parentView: nil.
	self setRightEdges.
	parts 
		from: partIndex
		to: parts size
		do: [:part | self setText: part].
	^aStatusBarItem!

sbGetBorders
	"Private - Answer a <sequencedReadableCollection> containing:

	 1	width of the horizontal border
	 2	width of the vertical border
	 3	width of the border between rectangles"

	| answer |
	answer := SDWORDArray new: 3.
	self
		sendMessage: SB_GETBORDERS
		wParam: 0
		lpParam: answer.
	^answer!

sbGetRect: anInteger
	| rect |
	rect := RECTL new.
	(self
		sendMessage: SB_GETRECT
		wParam: anInteger
		lpParam: rect) == 0
		ifTrue: 
			["self errorInCommonControlCall"
			].
	^rect!

sbSetTipText: iPart text: lpszToolTip 
	"Private - Send an SB_SETTIPTEXT message to the control to set the tool-tip text
	for the item of the receiver with zero-based <integer> index, iPart, to the <readableString>,
	aString."

	self 
		sendMessage: SB_SETTIPTEXT
		wParam: iPart
		lpParam: lpszToolTip!

scrollbarWidth
	^SystemMetrics current scrollThumbExtent x!

setControlBackcolor: aColor 
	self 
		sendMessage: SB_SETBKCOLOR
		wParam: 0
		lParam: aColor asCOLORREF!

setItem: aStatusBarItem tipText: aString 
	"Private - Set the tool-tip text of the item, aStatusOwnerDraw, to the <readableString, aString."

	self sbSetTipText: (self indexOfItem: aStatusBarItem) - 1 text: aString!

setRightEdges
	"Private - Inform the common control of the right edge for each of the receiver's parts."

	^self setRightEdges: self clientWidth!

setRightEdges: anInteger 
	| edges |
	edges := self calculateEdgesForWidth: anInteger.
	(self 
		sendMessage: SB_SETPARTS
		wParam: edges size
		lpParam: edges) == 0 
		ifTrue: [^self errorInCommonControlCall]!

setText: aStatusBarItem 
	"Private - Set the SB_SETTEXT of the receivers common control for
	aStatusOwnerDraw."

	| index text |
	(index := self indexOfItem: aStatusBarItem) == 0 ifTrue: [^self].
	text := aStatusBarItem getText.
	(self 
		sendMessage: SB_SETTEXT
		wParam: (aStatusBarItem style bitOr: index - 1)
		lParam: text yourAddress) == 0 
		ifTrue: [^self errorInCommonControlCall]!

setWindowText: aString 
	"Private - Sets the text of the receiver. There is a bug in
	the status common control which will fail if the first part has
	SBT_OWNERDRAW set."

	^self!

size
	"Answer the size of the receivers contents."

	^self contents size!

updateItem: aStatusBarItem 
	"Private - Update the controls knowledge of this part."

	self setRightEdges.
	self setText: aStatusBarItem.
	self invalidateRect: (self rectangleOfItem: aStatusBarItem)! !
!UI.StatusBar categoriesFor: #addItem:!adding!items!public! !
!UI.StatusBar categoriesFor: #addItem:name:!adding!items!public! !
!UI.StatusBar categoriesFor: #calculateEdgesForWidth:!geometry!private! !
!UI.StatusBar categoriesFor: #contents!accessing!public! !
!UI.StatusBar categoriesFor: #defaultExtent!constants!private! !
!UI.StatusBar categoriesFor: #defaultWindowStyle!constants!private! !
!UI.StatusBar categoriesFor: #getWindowText!accessing!private!win32 bug fix! !
!UI.StatusBar categoriesFor: #getWindowTextLength!accessing!private!win32 bug fix! !
!UI.StatusBar categoriesFor: #hasSizeGrip!accessing-styles!public! !
!UI.StatusBar categoriesFor: #hasSizeGrip:!accessing-styles!public! !
!UI.StatusBar categoriesFor: #hasToolTips!accessing-styles!public! !
!UI.StatusBar categoriesFor: #hasToolTips:!accessing-styles!public! !
!UI.StatusBar categoriesFor: #indexFromPoint:!accessing!enquiries!private! !
!UI.StatusBar categoriesFor: #indexOfItem:!items!private! !
!UI.StatusBar categoriesFor: #initialize!initializing!private! !
!UI.StatusBar categoriesFor: #itemAtIndex:!items!public! !
!UI.StatusBar categoriesFor: #itemFromId:!accessing!private! !
!UI.StatusBar categoriesFor: #itemRect:!geometry!public! !
!UI.StatusBar categoriesFor: #items!accessing!private! !
!UI.StatusBar categoriesFor: #items:!accessing!private! !
!UI.StatusBar categoriesFor: #layout:!geometry!private! !
!UI.StatusBar categoriesFor: #layoutManager!geometry!public! !
!UI.StatusBar categoriesFor: #layoutManager:!geometry!public! !
!UI.StatusBar categoriesFor: #onDrawItem:!event handling-win32!public! !
!UI.StatusBar categoriesFor: #onViewCreated!event handling!public! !
!UI.StatusBar categoriesFor: #rectangleOfItem:!accessing!private! !
!UI.StatusBar categoriesFor: #removeItem:!items!public!removing! !
!UI.StatusBar categoriesFor: #sbGetBorders!accessing!private! !
!UI.StatusBar categoriesFor: #sbGetRect:!accessing!private! !
!UI.StatusBar categoriesFor: #sbSetTipText:text:!operations!private! !
!UI.StatusBar categoriesFor: #scrollbarWidth!constants!private! !
!UI.StatusBar categoriesFor: #setControlBackcolor:!helpers!private! !
!UI.StatusBar categoriesFor: #setItem:tipText:!operations!private! !
!UI.StatusBar categoriesFor: #setRightEdges!helpers!private! !
!UI.StatusBar categoriesFor: #setRightEdges:!helpers!private! !
!UI.StatusBar categoriesFor: #setText:!accessing!private! !
!UI.StatusBar categoriesFor: #setWindowText:!accessing!private!win32 bug fix! !
!UI.StatusBar categoriesFor: #size!accessing!public! !
!UI.StatusBar categoriesFor: #updateItem:!private!updating! !

!UI.StatusBar class methodsFor!

icon
	"Answers an Icon that can be used to represent this class"

	^##(self) defaultIcon!

resource_Status_bar
	"Answer the literal data from which the 'Status bar' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Status_bar)
	"

	^#(#'!!STL' 4 985166 10 ##(UI.STBViewProxy) ##(UI.StatusBar) 34 18 nil nil 34 2 8 1409288460 1 416 nil 917510 ##(Graphics.Color) #default nil 5 nil 852998 ##(Graphics.Font) nil true 655622 ##(OS.LOGFONT) 8 #[243 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 65 114 105 97 108 0 159 4 0 134 63 1 0 0 204 53 63 1 2 0 20 59 0 0 0 0 247 0 5 86 111 1] 655878 ##(Graphics.Point) 193 193 nil 416 nil 8 1920343920 170 192 8 #() 34 1 1050374 ##(UI.StatusBarItem) 1 -1 416 nil 786950 ##(Core.Message) #displayString 8 #() 722 #iconImageIndex 8 #() nil 1311750 ##(UI.StatusBarNullItem) 513 1 416 nil nil 1310982 ##(Core.MessageSequence) 138 144 34 1 1049350 ##(Core.MessageSend) #createAt:extent: 34 2 594 6143 21 594 701 45 416 1179910 ##(OS.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 11 0 0 10 0 0 0 93 13 0 0 32 0 0 0] 8 #() 594 193 193 nil 27)!

themePartName
	^'STATUS'
!

winClassName
	"Private - Answer the name of the Windows window class to use when realizing the receiver."

	^'msctls_statusbar32'! !
!UI.StatusBar class categoriesFor: #icon!constants!public! !
!UI.StatusBar class categoriesFor: #resource_Status_bar!public!resources-views! !
!UI.StatusBar class categoriesFor: #themePartName!constants!private! !
!UI.StatusBar class categoriesFor: #winClassName!constants!private! !

