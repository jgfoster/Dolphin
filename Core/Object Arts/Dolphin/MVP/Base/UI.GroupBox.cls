﻿"Filed out from Dolphin Smalltalk 7"!

UI.ControlView subclass: #'UI.GroupBox'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #(#{OS.ButtonConstants})
	classInstanceVariableNames: ''
	classConstants: {}!
UI.GroupBox guid: (Core.GUID fromString: '{87b4c727-026e-11d3-9fd7-00a0cc3e4a32}')!
UI.GroupBox comment: 'GroupBox is the <view> implementing the standard Windows group box control. The actual windows class used is BUTTON, but why Microsoft chose this to implement a group box remains a mystery to this day.

GroupBox is named after the Windows control, but it only "groups" the controls it appears to surround visually; i.e. it is not a container view, just a visual decorator.
'!
!UI.GroupBox categoriesForClass!MVP-Resources-Group Box!MVP-Views! !
!UI.GroupBox methodsFor!

defaultExtent
	"Private - Answer the default size of the receiver
	to be used when it is created."

	^##(150 @ 100)!

defaultWindowExStyle
	"Private - Answer the default extended window creation style.
	Implementation Note: We specify WS_EX_TRANSPARENT because
	we turn on WS_CLIPSIBLINGS by default, and in any case, this
	is more correct, so there!! However, this does upset the
	hit-testing."

	^super defaultWindowExStyle bitOr: WS_EX_TRANSPARENT!

defaultWindowStyle
	"Private - Answer a default style to use when creating a group box control."

	^(super defaultWindowStyle maskClear: WS_TABSTOP)	bitOr: BS_GROUPBOX
!

onPositionChanged: aPositionEvent
	"Private - Handle a window position change event (move or resize).
	Implementation Note:  Windows group boxes are partially transparent and do not 
	redraw most of their area, so when they are moved they leave behind traces of their
	former presence. We therefore force the parent to redraw to clear up."

	aPositionEvent isMove ifTrue: [
		self parentView invalidateRect: self rectangle].
	^super onPositionChanged: aPositionEvent! !
!UI.GroupBox categoriesFor: #defaultExtent!constants!private! !
!UI.GroupBox categoriesFor: #defaultWindowExStyle!constants!private! !
!UI.GroupBox categoriesFor: #defaultWindowStyle!constants!private! !
!UI.GroupBox categoriesFor: #onPositionChanged:!event handling!private! !

!UI.GroupBox class methodsFor!

icon
	"Answers an Icon that can be used to represent this class"

	^##(self) defaultIcon!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 4 985166 10 ##(UI.STBViewProxy) ##(UI.GroupBox) 34 14 nil nil 34 2 8 1140850695 65 416 nil 917510 ##(Graphics.Color) #default nil 7 nil nil nil 416 nil 8 1920683440 1310982 ##(Core.MessageSequence) 138 144 34 1 1049350 ##(Core.MessageSend) #createAt:extent: 34 2 655878 ##(Graphics.Point) 6143 21 642 301 201 416 1179910 ##(OS.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 11 0 0 10 0 0 0 149 12 0 0 110 0 0 0] 8 #() 642 193 193 nil 27)!

resource_Static_group_box
	"Answer the literal data from which the 'Static group box' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Static_group_box)
	"

	^#(#'!!STL' 4 985166 10 ##(UI.STBViewProxy) ##(UI.GroupBox) 34 14 nil nil 34 2 8 1140850695 65 416 nil 917510 ##(Graphics.Color) #transparent nil 7 nil nil nil 416 nil 8 1920683440 1310982 ##(Core.MessageSequence) 138 144 34 2 1049350 ##(Core.MessageSend) #createAt:extent: 34 2 655878 ##(Graphics.Point) 6143 21 642 299 201 416 594 #text: 34 1 8 'Text here' 416 1179910 ##(OS.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 11 0 0 10 0 0 0 148 12 0 0 110 0 0 0] 8 #() 642 193 193 nil 27)!

themePartName
	^'BUTTON'!

winClassName
	"Private - Answer the name of the Windows window class to use when realizing the receiver.
	Why Microsoft chose to make the GroupBox a button is a mystery beyond possible
	comprehension"

	^'BUTTON'! !
!UI.GroupBox class categoriesFor: #icon!constants!public! !
!UI.GroupBox class categoriesFor: #resource_Default_view!public!resources-views! !
!UI.GroupBox class categoriesFor: #resource_Static_group_box!public!resources-views! !
!UI.GroupBox class categoriesFor: #themePartName!constants!public!theming! !
!UI.GroupBox class categoriesFor: #winClassName!constants!private! !

