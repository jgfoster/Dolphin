"Filed out from Dolphin Smalltalk 7"!

Core.Object subclass: #'UI.Scintilla.PropertyDescriptor'
	instanceVariableNames: 'getSelector defaultValue setMessage setSelector getMessage'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
UI.Scintilla.PropertyDescriptor guid: (Core.GUID fromString: '{49848e62-c4d7-4cba-b9f5-71b0bf864a2a}')!
UI.Scintilla.PropertyDescriptor comment: '`ScintillaPropertyDescriptor`s provide metadata for individually settable scalar properties of a `ScintillaView`, e.g. the background colour of a marker.

## Instance Variables:
  `getSelector`		`Symbol`. Accessor message to send to object that represents the composite Scintilla attribute in order to retrieve the property value to send to the control.
  `defaultValue`	`<Object>`. Default value of the Scintilla property as initialized by the control.
  `setMessage`		`<integer>` id of the message to send to the control to set the property value, e.g. SCI_SETMARKERSETBACK
  `setSelector`		`Symbol`. Mutator message to send to object that represents the composite Scintilla attribute in order to set a property value retrieved from the control.
  `setMessage`		`<iInteger>` id of the message to send to the control to get the property value, e.g. SCI_GETMARKERSETBACK


'!
!UI.Scintilla.PropertyDescriptor categoriesForClass!Kernel-Objects! !
!UI.Scintilla.PropertyDescriptor methodsFor!

getAttribute: aScintillaAttribute ofView: aScintillaView
	| value |
	value := self
				valueFromLResult: (aScintillaView sendMessage: getMessage wParam: aScintillaAttribute basicId).
	^aScintillaAttribute perform: setSelector with: ((self isDefaultValue: value) ifFalse: [value])!

getAttributeValue: aScintillaAttribute
	^aScintillaAttribute perform: getSelector!

getSelector: aSymbol defaultValue: anObject setMessage: anInteger
	getSelector := aSymbol.
	defaultValue := anObject.
	setMessage := anInteger.
	^self!

isDefaultValue: anObject
	^anObject = defaultValue!

lParamFromAttributeValue: value
	^value asUIntPtr!

setAttribute: aScintillaAttribute ofView: aScintillaView initializing: aBoolean
	"Initialize the property described by the receiver of the attribute, aScintillaAttribute, of the control, aScintillaView, but only if it specified as a non-default value."

	| value |
	value := self getAttributeValue: aScintillaAttribute.
	aBoolean
		ifTrue: [(value isNil or: [self isDefaultValue: value]) ifTrue: [^self]]
		ifFalse: [value isNil ifTrue: [value := defaultValue]].
	aScintillaView
		sendMessage: setMessage
		wParam: aScintillaAttribute basicId
		lParam: (self lParamFromAttributeValue: value)!

setSelector: aSymbol getMessage: anInteger
	setSelector := aSymbol.
	getMessage := anInteger.
	^self!

valueFromLResult: anObject 
	^anObject! !
!UI.Scintilla.PropertyDescriptor categoriesFor: #getAttribute:ofView:!operations!private! !
!UI.Scintilla.PropertyDescriptor categoriesFor: #getAttributeValue:!operations!private! !
!UI.Scintilla.PropertyDescriptor categoriesFor: #getSelector:defaultValue:setMessage:!initializing!private! !
!UI.Scintilla.PropertyDescriptor categoriesFor: #isDefaultValue:!operations!private! !
!UI.Scintilla.PropertyDescriptor categoriesFor: #lParamFromAttributeValue:!helpers!private! !
!UI.Scintilla.PropertyDescriptor categoriesFor: #setAttribute:ofView:initializing:!helpers!private! !
!UI.Scintilla.PropertyDescriptor categoriesFor: #setSelector:getMessage:!initializing!private! !
!UI.Scintilla.PropertyDescriptor categoriesFor: #valueFromLResult:!helpers!private! !

!UI.Scintilla.PropertyDescriptor class methodsFor!

getSelector: aSymbol defaultValue: anObject setMessage: anInteger
	^self new
		getSelector: aSymbol
		defaultValue: anObject
		setMessage: anInteger!

getSelector: getSymbol defaultValue: anObject setMessage: setInteger setSelector: setSymbol getMessage: getInteger
	^(self
		getSelector: getSymbol
		defaultValue: anObject
		setMessage: setInteger) setSelector: setSymbol getMessage: getInteger!

icon
	^ScintillaView icon! !
!UI.Scintilla.PropertyDescriptor class categoriesFor: #getSelector:defaultValue:setMessage:!instance creation!public! !
!UI.Scintilla.PropertyDescriptor class categoriesFor: #getSelector:defaultValue:setMessage:setSelector:getMessage:!instance creation!public! !
!UI.Scintilla.PropertyDescriptor class categoriesFor: #icon!constants!development!public! !

