﻿"Filed out from Dolphin Smalltalk 7"!

UI.ControlView subclass: #'UI.ControlBarAbstract'
	instanceVariableNames: 'names'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
UI.ControlBarAbstract guid: (Core.GUID fromString: '{87b4c726-026e-11d3-9fd7-00a0cc3e4a32}')!
UI.ControlBarAbstract isNonInstantiable: true!
UI.ControlBarAbstract comment: 'ControlBarAbstract is an abstract <compositeView> whose subclasses implement the standard Windows status bar and toolbar controls. It is necessary for control bars to support <compositeView> so that they are able to host additional sub-views under the management of a layout manager.

Instance Variables:
	names	<IdentityDictionary> mapping sub-views to their names.

'!
!UI.ControlBarAbstract categoriesForClass!MVP-Resources-Tool/Status bars!MVP-Views! !
!UI.ControlBarAbstract methodsFor!

actualInsets: aLayoutContext 
	"Private - Answer a Rectangle whose edges specify the actual inset (in pixels) by which the
	sub views are positioned away from the bordered of the receiver."

	^self insets!

actualPreferredExtent: aLayoutContext 
	"Private - Answer the preferred extent of the receiver given the suggested extent specifed
	by the <Point> argument. A preferred extent can be forced by setting the #preferredExtent
	aspect otherwise we see if one can be offered by any installed layout manager, and failing
	that try calculating an extent."

	^self preferredExtent 
		ifNil: 
			[self layoutManager 
				ifNotNil: [:manager | manager preferredLayoutExtentOf: self context: aLayoutContext]
				ifNil: [self calculateExtent: aLayoutContext]]!

addSubView: aView name: aNameString
	"Adds aView to the receiver's collection of managed sub-views and
	gives it aNameString. Answers aView"

	self name: (self addSubView: aView) as: aNameString.
	^aView
!

arrangementOf: aView
	"Answer the arrangement parameter for aView in the receiver's 
	layout manager. If no parameter has been explicitly set, or if the
	receiver has no layout manager then answer nil"

	self layoutManager notNil ifTrue: [
		^self layoutManager arrangementOf: aView ].
	^nil!

arrangementOf: aView put: anObject 
	"Set the arrangement parameter for aView in the receiver  
	layout manager to be anObject. If the parent has no layout manager 
	then a walkback will result"

	self layoutManager ifNotNil: 
			[:manager | 
			manager arrangementOf: aView put: anObject.
			self invalidateLayout]!

canAcceptSubViews
	"Answer true if the receiver can accept aView sub viewss"

	^true!

defaultBackcolor
	"Private - Answer the default colour for the receiver's background"

	^Color face3d!

defaultExtentOf: arg1
	"This is an auto-generated target implementation for the protocol <compositeView>
	and remains to be correctly implemented."

	^Error notYetImplemented!

defaultWindowExStyle
	"Private - Answer the default extended window creation style."

	^super defaultWindowExStyle bitOr: WS_EX_CONTROLPARENT!

defaultWindowStyle
	"Private - Answer a default base style to use when creating the receiver."

	"Implementation Note: We suppress the control bar's inclination to cling to its parent since
	we can achieve this readily with LayoutManagers."

	^(super defaultWindowStyle maskClear: WS_TABSTOP) bitOr: ##(CCS_NORESIZE | CCS_NOPARENTALIGN)!

errorDuplicateName: aString
	"Report that aString is already in use"

	^self error: 'duplicate name: ', aString
!

hasDivider
	"Answers whether the receiver has a divider at its top edge (this is the
	CCS_NODIVIDER style)."

	^(self baseStyleAllMask: CCS_NODIVIDER) not!

hasDivider: aBoolean 
	"Set whether the receiver has a divider at its top edge (this is the
	CCS_NODIVIDER style)."

	^(self 
		baseStyleMask: CCS_NODIVIDER
		set: aBoolean not
		recreateIfChanged: false) ifTrue: [self frameChanged]!

indexFromPoint: aPoint 
	"Private - Answer the index of the item in the list under the <Point> argument, or nil if
	none."

	^self subclassResponsibility!

initialize
	"Private - Initialize the state of the receiver."

	super initialize.
	backcolor := Color default!

insets
	^Rectangle new!

isVertical
	"Answer whether the receiver has a vertical orientation."

	^self baseStyleAllMask: CCS_VERT!

isVertical: aBoolean 
	"Set whether or not the receiver a vertical orientation
	(i.e. with the buttons/tabs at the right of left hand sides
	instead of along the top or bottom)."

	(self 
		baseStyleMask: CCS_VERT
		set: aBoolean
		recreateIfChanged: false	"Modifiable after creation") ifTrue: [self invalidateLayout; invalidate]!

layout: aLayoutContext 
	"Private - Recalculate the geometry of the receiver."

	self layoutManager ifNotNil: [:manager | manager layoutContainer: self context: aLayoutContext].!

layoutManager: aLayoutManager
	"Set the layout manager for the receiver to aLayoutManager"

	^self subclassResponsibility
!

name: aView as: aNameStringOrNil
	"Sets the name of aView within the receiver to be aNameStringOrNil"

	"Redirect name request to the immediate parent of aView
	if we are not that parent"

	aView parentView == self ifFalse: [^aView parentView name: aView as: aNameStringOrNil].

	"Check that aView is one of our managed sub-views"
	"self assert: [ self managedSubViews  includes: aView ]."
	names isNil
		ifTrue: 
			[(aNameStringOrNil isNil or: [aNameStringOrNil isEmpty])
				ifFalse: [(names := IdentityDictionary new) at: aView put: aNameStringOrNil]]
		ifFalse: 
			[| exists |
			(aNameStringOrNil isNil or: [aNameStringOrNil isEmpty])
				ifTrue: 
					["Request to remove name for aView"
					^names removeKey: aView ifAbsent: []].

			"Otherwise name is specified so check that it is unique"
			exists := names keyAtEqualValue: aNameStringOrNil ifAbsent: [].
			(exists isNil or: [exists == self])
				ifTrue: [names at: aView put: aNameStringOrNil]
				ifFalse: [self errorDuplicateName: aNameStringOrNil]]!

nameOf: aView
	"Answer the name of aView within the receiver or nil
	if it has not been assigned a name"

	"Redirect request to the immediate parent of aView
	if we are not that parent"

	aView parentView == self ifFalse: [^aView parentView nameOf: aView].
	^names isNil ifFalse: [names lookup: aView]!

nmClick: pNMHDR
	"Default handler for a NM_CLICK notification message, pass 
	on to the clicked item, or answer nil to accept default processing."

	| struct |
	struct := NMMOUSE fromAddress: pNMHDR.
	^(self itemFromId: struct dwItemSpec) ifNotNil: [:item | item onClick: struct position]!

nmDblClk: pNMHDR
	"Default handler for a NM_DBLCLK notification message.
	Pass on to the clicked item, or answer nil to accept default processing.
	Note that this is never actually received for Toolbars."

	| struct |
	struct := NMMOUSE fromAddress: pNMHDR.
	^(self itemFromId: struct dwItemSpec) ifNotNil: [:item | item onDoubleClick: struct position]!

nmRClick: pNMHDR
	"Default handler for a NM_RCLICK notification message.
	Pass on to the clicked item, or answer nil to accept default processing."

	| struct |
	struct := NMMOUSE fromAddress: pNMHDR.
	^(self itemFromId: struct dwItemSpec) ifNotNil: [:item | item onRightClick: struct position]!

onSubViewAdded: aView
	"Received when aView has been added to the receiver.
	Can be overridden by subclasses to perform necessary housekeeping regarding the
	new contents of the receiver"

	super onSubViewAdded: aView.
	self invalidateLayout

	!

onZOrderChanged
	"Received when the Zorder of the subviews within the receiver has been
	directly changed. Can be overridden by subclasses to perform necessary 
	housekeeping regarding the new Zorder."

	self invalidateLayout.
	super onZOrderChanged!

removeSubView: aView
	"Removes aView as a managed subview of the receiver. 
	If aView is indeed a subview of the receiver then it is destroyed. If not,
	it continues to live."

	super removeSubView: aView.
	self hasLayoutManager
		ifTrue: [self layoutManager removeSubView: aView].
	names isNil ifFalse: [names removeKey: aView ifAbsent: []].
	^aView!

validateSubViewLayouts: anExternalHandle 
	"Private - Validate the layout of the visible sub-views of the receiver."

	self managedSubViewsDo: [:each | each validateLayout: anExternalHandle]!

validateUserInterface
	"Validates the user interface for the receiver. Usually performed at idle time
	when the  UI has been flagged as being invalid"

	self subViewsDo: [:each | each presenter validateUserInterface].
	super validateUserInterface.!

viewNamed: aString ifNone: aBlock 
	"Answer the sub-view within the receiver's hierarchy with aString as its
	name. Evaluates aBlock if no matching named view exists."

	names isNil 
		ifFalse: [names keysAndValuesDo: [:eachKey :eachValue | aString = eachValue ifTrue: [^eachKey]]].
	self managedSubViewsDo: 
			[:each | 
			| found |
			found := each viewNamed: aString ifNone: [].
			found notNil ifTrue: [^found]].
	^aBlock value! !
!UI.ControlBarAbstract categoriesFor: #actualInsets:!accessing!private! !
!UI.ControlBarAbstract categoriesFor: #actualPreferredExtent:!private! !
!UI.ControlBarAbstract categoriesFor: #addSubView:name:!public!sub views! !
!UI.ControlBarAbstract categoriesFor: #arrangementOf:!accessing!public! !
!UI.ControlBarAbstract categoriesFor: #arrangementOf:put:!accessing!public! !
!UI.ControlBarAbstract categoriesFor: #canAcceptSubViews!hierarchy!public!sub views!testing! !
!UI.ControlBarAbstract categoriesFor: #defaultBackcolor!colors!constants!private! !
!UI.ControlBarAbstract categoriesFor: #defaultExtentOf:!public! !
!UI.ControlBarAbstract categoriesFor: #defaultWindowExStyle!constants!private! !
!UI.ControlBarAbstract categoriesFor: #defaultWindowStyle!constants!private! !
!UI.ControlBarAbstract categoriesFor: #errorDuplicateName:!exceptions!public! !
!UI.ControlBarAbstract categoriesFor: #hasDivider!accessing-styles!public! !
!UI.ControlBarAbstract categoriesFor: #hasDivider:!accessing-styles!public! !
!UI.ControlBarAbstract categoriesFor: #indexFromPoint:!enquiries!private! !
!UI.ControlBarAbstract categoriesFor: #initialize!initializing!private! !
!UI.ControlBarAbstract categoriesFor: #insets!accessing!private! !
!UI.ControlBarAbstract categoriesFor: #isVertical!accessing-styles!public! !
!UI.ControlBarAbstract categoriesFor: #isVertical:!accessing-styles!public! !
!UI.ControlBarAbstract categoriesFor: #layout:!geometry!private! !
!UI.ControlBarAbstract categoriesFor: #layoutManager:!geometry!public! !
!UI.ControlBarAbstract categoriesFor: #name:as:!public!subpresenters! !
!UI.ControlBarAbstract categoriesFor: #nameOf:!public!subpresenters! !
!UI.ControlBarAbstract categoriesFor: #nmClick:!event handling-win32!public! !
!UI.ControlBarAbstract categoriesFor: #nmDblClk:!event handling-win32!public! !
!UI.ControlBarAbstract categoriesFor: #nmRClick:!event handling-win32!public! !
!UI.ControlBarAbstract categoriesFor: #onSubViewAdded:!event handling!public! !
!UI.ControlBarAbstract categoriesFor: #onZOrderChanged!event handling!public! !
!UI.ControlBarAbstract categoriesFor: #removeSubView:!hierarchy!public!sub views! !
!UI.ControlBarAbstract categoriesFor: #validateSubViewLayouts:!geometry!private! !
!UI.ControlBarAbstract categoriesFor: #validateUserInterface!operations!public! !
!UI.ControlBarAbstract categoriesFor: #viewNamed:ifNone:!public!sub views! !

UI.ControlBarAbstract methodProtocol: #compositeView attributes: #(#readOnly) selectors: #(#addSubView: #allParents #allSubViews #arrangement #arrangement: #backcolor #backcolor: #canAcceptSubViews #canvas #clientExtent #clientHeight #clientRectangle #clientWidth #close #contextMenu #contextMenu: #cursor #cursorPosition #destroy #disable #disableRedraw #enable #enableRedraw #ensureLayoutValid #ensureRectangleVisible: #ensureSubView:rectangleVisible: #ensureSubViewVisible: #ensureVisible #extent #extent: #firstSubView #font #font: #forecolor #forecolor: #hasBorder #hasBorder: #hasClientEdge #hasClientEdge: #hasFocus #hasLayoutManager #hasStaticEdge #hasStaticEdge: #hasVisibleStyle #hasVisibleStyle: #height #height: #hide #invalidate #invalidateCalculatedExtent #invalidateLayout #invalidateRect: #invalidateRect:erase: #invalidateRgn: #invalidateUserInterface #isEnabled: #isGroupStop #isGroupStop: #isLayoutValid #isManaged #isManaged: #isTabStop #isTabStop: #isTopView #isTransparent #isTransparent: #isWindowVisible #layout #layoutExtent: #layoutManager #layoutManager: #managedSubViews #mapPoint:to: #mapRectangle:to: #model #model: #name #name: #nameOf: #needsValidateLayout #nextSiblingView #nonClientCanvas #onAboutToCreate #onBegin:drag: #onCommand: #onCreated: #onDestroyed #onEraseRequired: #onHScroll: #onModelChanged #onPaintRequired: #onSubViewAdded: #onSubViewRemoved: #onViewCreated #onVScroll: #onZOrderChanged #parentView #placement #placement: #plainText #position #position: #preferredExtent #preferredExtent: #presenter #presenter: #presenterConnectionPoint #preTranslateKeyboardInput: #preTranslateMessage: #preTranslateMouseInput: #previousSiblingView #queryContextMenu #recreate #rectangle #rectangle: #refreshContents #removeSubView: #resolution #screenRectangle #screenRectangle: #scrollBy:clip: #scrollBy:scroll:clip: #setCapture #styles #subViewFromPoint: #subViewFromPoint:flags: #subViews #tabFirst #tabNext #text #text: #topView #update #updateModel #usePreferredExtent #usePreferredExtent: #validate #validateLayout #validateRect: #validateUserInterface #viewNamed: #viewNamed:ifNone: #width #width: #withAllParents #withAllSubViews #x #x: #y #y: #zOrderAfter: #zOrderAfter:withFlags: #zOrderBottom #zOrderTop)!

!UI.ControlBarAbstract class methodsFor!

icon
	"Answers an Icon that can be used to represent this class"

	^Icon fromId: 'Toolbar.ico'!

stbConvertFromVersion12: anArray 
	"Private - Perform an STB conversion from a version 12 <View> to version 13."

	| creationStyle |
	creationStyle := anArray at: 3.
	creationStyle at: 1 put: ((creationStyle at: 1) bitOr: CCS_NOPARENTALIGN).
	^super stbConvertFromVersion12: anArray! !
!UI.ControlBarAbstract class categoriesFor: #icon!constants!public! !
!UI.ControlBarAbstract class categoriesFor: #stbConvertFromVersion12:!binary filing!private! !

