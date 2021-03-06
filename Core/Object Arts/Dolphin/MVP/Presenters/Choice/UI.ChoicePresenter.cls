﻿"Filed out from Dolphin Smalltalk 7"!

UI.ValuePresenter subclass: #'UI.ChoicePresenter'
	instanceVariableNames: 'choicesModel nilChoice'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
UI.ChoicePresenter guid: (Core.GUID fromString: '{87b4c6cc-026e-11d3-9fd7-00a0cc3e4a32}')!
UI.ChoicePresenter comment: 'ChoicePresenter is <valuePresenter> which allows a value to be chosen from a list of alternatives. The range of choices may be supplied as any <sequencedCollection> by using the #choices: method once the ChoicePresenter has been instantiated. The initial selection in the visible list will match the initial value in the ChoicePresenter''s <valueModel>. As different selections are made in list they are transferred directly into the associated model.

By default, a ChoicePresenter allows single selection choices to be made. It is also possible, however, to allow multiple selections by attaching an appropriate <listView> supporting the <multipleSelectableItems> protocol. In this case, the value held by the model will be an <Array> of the chosen items.

It is also sometimes useful to specify one of the supplied choices as being able to represent a nil value in the model. This can be done by using the #nilChoice: method. Note that when in multi-select mode, the nilChoice is equivalent to the empty selection.

Examples:

"Single Selection"
model := 2 asValue.
(ChoicePresenter showOn: model) choices: #[0 1 2 3]; nilChoice: 0.
model value "Display it"

"Multiple Selection"
model := (Array with: 2) asValue.
(ChoicePresenter show: ''Multi-selection list box'' on: model) choices: #[0 1 2 3]; nilChoice: (Array with: 0).
model value "Display it"

Instance Variables:
	choicesModel	<listModel> containing the value choices.
	nilChoice		<Object> specifying the object in list that can be used to represent a nil. value.

'!
!UI.ChoicePresenter categoriesForClass!MVP-Presenters!MVP-Resources-Lists! !
!UI.ChoicePresenter methodsFor!

choices: aSequenceableCollection 
	"Sets the choice list to choose from to be aSequenceableCollection"

	| oldSelections |
	oldSelections := self view selections.
	self noEventsDo: 
			[choicesModel list: aSequenceableCollection.
			self updateChoice].
	(self view selections noDifference: oldSelections) ifFalse: [self onChoiceChanged]!

createSchematicWiring
	"Create the trigger wiring for the receiver. At this stage the initialization
	is complete and the view is open"

	super createSchematicWiring.
	self when: #selectionChanged send: #onChoiceChanged to: self!

getValue
	^self isMultiChoice 
		ifTrue: 
			[| choices |
			choices := view selections.
			choices = self nilChoice ifTrue: [#()] ifFalse: [choices]]
		ifFalse: 
			[| choice |
			choice := view selectionOrNil.
			choice = nilChoice ifFalse: [choice]]!

initialize
	"Private - Initialize the receiver"

	super initialize.
	choicesModel := ListModel newEquality!

isMultiChoice
	^self view isMultiSelect!

model: aValueModel 
	"Set the model of the receiver to be aValueModel."

	self noEventsDo: [super model: aValueModel].
	self updateChoice!

nilChoice
	"Answer the default choice, if any."

	^nilChoice ifNil: [self isMultiChoice ifTrue: [#()]]!

nilChoice: anObject 
	"Set the choice that will be used to represent nil in the receiver to be anObject."

	nilChoice := anObject.
	"#1484. Reverted because breaks common usage of setting nil choice before choices."
	"self updateChoice"!

onChoiceChanged
	"Private - Handler for a choice change in the receiver's view"

	self value: self getValue!

onSelectionChanged
	"Private - Handler for a selection change in the receiver's view"

	self view onSelectionChanged!

onSelectionChanging: aSelectionChangingEvent
	"Private - Handler to indicate that the receiver's selection is about to change.
	To prevent the proposed change under certain circumstances a handler
	can set the value of aValueHolder to false."

	self view onSelectionChanging: aSelectionChangingEvent!

onValueChanged
	"The receiver's value has changed. Ensure that we update the list selection to match"

	self updateChoice.
	super onValueChanged
	!

updateChoice
	"Private - The value has been changed in the receiver's model.
	Transfer the value to the list view's selection."

	| choice |
	self isOpen ifFalse: [^self].
	choice := self value.
	self isMultiChoice 
		ifTrue: 
			[self view 
				selections: ((choice isNil or: [choice isEmpty]) ifTrue: [self nilChoice] ifFalse: [choice])
				ifAbsent: []]
		ifFalse: 
			[choice isNil ifTrue: [choice := self nilChoice].
			choice isNil ifTrue: [self view resetSelection] ifFalse: [self view selection: choice ifAbsent: []]]!

view: aView
	"Set the view for the receiver to aView. This should be overidden for composites
	to also connect up any sub-views"

	super view: aView.

	"Transfer the choice selection across to the associated list. Beware though;
	under some circumstances the choices model may not yet have been filled."
	choicesModel notEmpty ifTrue: [
		self updateChoice ]!

viewModel
	"Private - Answer the model that is to be connected to the view. It is actually
	connected to the receiver's choicesModel - not the receiver's value model"

	^choicesModel! !
!UI.ChoicePresenter categoriesFor: #choices:!accessing!public! !
!UI.ChoicePresenter categoriesFor: #createSchematicWiring!initializing!public! !
!UI.ChoicePresenter categoriesFor: #getValue!helpers!private! !
!UI.ChoicePresenter categoriesFor: #initialize!initializing!private! !
!UI.ChoicePresenter categoriesFor: #isMultiChoice!private!testing! !
!UI.ChoicePresenter categoriesFor: #model:!accessing!public! !
!UI.ChoicePresenter categoriesFor: #nilChoice!accessing!public! !
!UI.ChoicePresenter categoriesFor: #nilChoice:!initializing!public! !
!UI.ChoicePresenter categoriesFor: #onChoiceChanged!event handling!private! !
!UI.ChoicePresenter categoriesFor: #onSelectionChanged!event handling!private! !
!UI.ChoicePresenter categoriesFor: #onSelectionChanging:!event handling!private! !
!UI.ChoicePresenter categoriesFor: #onValueChanged!event handling!public! !
!UI.ChoicePresenter categoriesFor: #updateChoice!accessing!private! !
!UI.ChoicePresenter categoriesFor: #view:!accessing!public! !
!UI.ChoicePresenter categoriesFor: #viewModel!accessing!private! !

!UI.ChoicePresenter class methodsFor!

defaultModel
	"Answer a default model to be assigned to the receiver when it
	is initialized."

	^nil asValue comparisonPolicy: SearchPolicy equality!

icon
	"Answers an Icon that can be used to represent this class"

	^##(self) defaultIcon!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 4 985166 10 ##(UI.STBViewProxy) ##(UI.ListBox) 34 17 nil nil 34 2 8 1412497665 1025 416 787270 2 ##(UI.ListModel) 138 144 8 #() nil 1638406 ##(Kernel.IdentitySearchPolicy) 917510 ##(Graphics.Color) #default nil 5 nil nil nil 416 nil 8 1920482304 786950 ##(Core.Message) #displayString 8 #() 8 #() false 1310982 ##(Core.MessageSequence) 138 144 34 2 1049350 ##(Core.MessageSend) #createAt:extent: 34 2 655878 ##(Graphics.Point) 6143 21 802 501 501 416 754 #horizontalExtent: 8 #(0) 416 1179910 ##(OS.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 11 0 0 10 0 0 0 249 12 0 0 4 1 0 0] 8 #() 802 193 193 nil 27)!

resource_Drop_down_list
	"Answer the literal data from which the 'Drop down list' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Drop_down_list)
	"

	^#(#'!!STL' 4 985166 10 ##(UI.STBViewProxy) ##(UI.ComboBox) 34 17 nil nil 34 2 8 1412498947 1025 416 787270 2 ##(UI.ListModel) 138 144 8 #() nil 1638406 ##(Kernel.IdentitySearchPolicy) 917510 ##(Graphics.Color) #default nil 5 nil nil nil 416 nil 8 1920475232 786950 ##(Core.Message) #displayString 8 #() 8 #() 401 1310982 ##(Core.MessageSequence) 138 144 34 1 1049350 ##(Core.MessageSend) #createAt:extent: 34 2 655878 ##(Graphics.Point) 6143 21 802 251 49 416 1179910 ##(OS.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 11 0 0 10 0 0 0 124 12 0 0 34 0 0 0] 8 #() 802 193 193 nil 27)!

resource_Enhanced_list_view
	"Answer the literal data from which the 'Enhanced list view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Enhanced_list_view)
	"

	^#(#'!!STL' 4 985166 10 ##(UI.STBViewProxy) ##(UI.ListView) 34 45 nil nil 34 2 8 1409355853 1025 416 787270 2 ##(UI.ListModel) 138 144 8 #() nil 1638406 ##(Kernel.IdentitySearchPolicy) 917510 ##(Graphics.Color) #default nil 5 nil nil nil 416 nil 8 1920618720 786950 ##(Core.Message) #displayString 8 #() ##(UI.IconicListAbstract) 1639750 1 ##(Graphics.IconImageManager) nil nil nil nil nil nil 138 144 34 1 1117254 5 ##(UI.ListViewColumn) 8 'Column 1' 201 #left 626 #displayString 656 626 #<= 8 #() nil nil 416 nil 1 nil nil #report 8 #() nil 131169 nil 1 nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil 1310982 ##(Core.MessageSequence) 138 144 34 2 1049350 ##(Core.MessageSend) #createAt:extent: 34 2 655878 ##(Graphics.Point) 6143 21 962 491 311 416 914 #text: 34 1 8 'Column 1' 416 1179910 ##(OS.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 11 0 0 10 0 0 0 244 12 0 0 165 0 0 0] 8 #() 962 193 193 nil 35)! !
!UI.ChoicePresenter class categoriesFor: #defaultModel!models!public! !
!UI.ChoicePresenter class categoriesFor: #icon!constants!public! !
!UI.ChoicePresenter class categoriesFor: #resource_Default_view!public!resources-views! !
!UI.ChoicePresenter class categoriesFor: #resource_Drop_down_list!public!resources-views! !
!UI.ChoicePresenter class categoriesFor: #resource_Enhanced_list_view!public!resources-views! !

