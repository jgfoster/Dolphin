﻿"Filed out from Dolphin Smalltalk 7"!

UI.Tests.MultilineTextEditTest subclass: #'UI.Scintilla.Tests.ScintillaViewTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
UI.Scintilla.Tests.ScintillaViewTest guid: (Core.GUID fromString: '{3c6fbe95-74e0-4325-97e1-82f12133d503}')!
UI.Scintilla.Tests.ScintillaViewTest comment: ''!
!UI.Scintilla.Tests.ScintillaViewTest categoriesForClass!Unclassified! !
!UI.Scintilla.Tests.ScintillaViewTest methodsFor!

classToTest
	^ScintillaView!

initializePresenter
	| margins |
	super initializePresenter.
	margins := presenter view margins.
	margins do: [:each | each width: 0].
	presenter view margins: margins
!

margins
	^0 @ 0!

testFindStringStartingAt
	| found found2 |
	presenter codePage: #utf8.
	self assert: (presenter findString: 'Object' startingAt: 1) equals: 0.
	"This test relies on 'Object' appearing in the text multiple times"
	presenter text: self text.
	found := presenter findString: 'Object' startingAt: 1.
	self assert: found equals: (self text indexOfSubCollection: 'Object').
	self assert: (presenter findString: 'Object' startingAt: found) equals: found.
	self assert: found equals: (self text indexOfSubCollection: 'Object').
	found2 := presenter findString: 'Object' startingAt: found + 1.
	self assert: found2 > found.
	self assert: found2 equals: (self text indexOfSubCollection: 'Object' startingAt: found+1).
	self assert: (presenter findString: 'Wibble' startingAt: 1) equals: 0.
	self assert: (presenter findString: '' startingAt: 1) equals: 0.
	presenter text: 'Hello 🐬 World'.
	found := presenter findString: '🐬' startingAt: 1.
	self assert: found equals: 7.
	found := presenter findString: '🐬' startingAt: 7.
	self assert: found equals: 7.
	found := presenter findString: '🐬' startingAt: 8.
	self assert: found equals: 0.
	found := presenter findString: '🐬' startingAt: 50.
	self assert: found equals: 0!

testLanguages
	| lingos |
	lingos := ScintillaView lexerLanguages.
	lingos do: [:each | each notNil ifTrue: [presenter view lexer: each]]!

testOverrideDefaultKeyBindings
	| bindings code expectedDiffs binding actualBindings |
	bindings := ScintillaView.DefaultKeyBindings copy.
	expectedDiffs := Set new.
	"Remove a key binding"
	code := AcceleratorTable keyCodeFromInvariantString: 'PGDOWN'.
	self assert: (bindings includesKey: code).
	bindings removeKey: code.
	expectedDiffs
		add: (KeyBinding newAcceleratorKey: code message: ScintillaConstants.SCI_NULL).
	"Add a binding"
	code := AcceleratorTable keyCodeFromInvariantString: 'CTRL+J'.
	self deny: (bindings includesKey: code).
	binding := KeyBinding newAcceleratorKey: code
				message: ScintillaConstants.SCI_SELECTIONDUPLICATE.
	bindings at: code put: binding.
	expectedDiffs add: binding.
	"Update a binding"
	code := AcceleratorTable keyCodeFromInvariantString: 'CTRL+D'.
	self assert: (bindings includesKey: code).
	binding := KeyBinding newAcceleratorKey: code message: ScintillaConstants.SCI_PAGEDOWN.
	bindings at: code put: binding.
	expectedDiffs add: binding.

	"When the bindings are set, we should be able to get back matching bindings"
	presenter keyBindings: bindings.
	actualBindings := presenter keyBindings asSet.
	bindings := bindings asSet.
	self assert: (bindings symmetricDifference: actualBindings) asArray equals: #().
	"But only the diffs should be stored"
	self assert: presenter basicKeyBindings asSet equals: expectedDiffs!

testSetGetAnnotations
	| annotations |
	presenter text: self text.
	annotations := OrderedCollection new.
	annotations
		add: (Annotation
					line: 1
					text: 'Wobble'
					style: #Error);
		add: (Annotation
					line: 2
					text: 'Wibble'
					style: #Warning);
		add: (Annotation
					line: 1
					text: 'Blah'
					style: #Notification).
	presenter annotations: annotations.
	self assert: (presenter annotations noDifference: annotations)! !
!UI.Scintilla.Tests.ScintillaViewTest categoriesFor: #classToTest!helpers!private! !
!UI.Scintilla.Tests.ScintillaViewTest categoriesFor: #initializePresenter!public!Running! !
!UI.Scintilla.Tests.ScintillaViewTest categoriesFor: #margins!private!unit tests! !
!UI.Scintilla.Tests.ScintillaViewTest categoriesFor: #testFindStringStartingAt!public!unit tests! !
!UI.Scintilla.Tests.ScintillaViewTest categoriesFor: #testLanguages!public!unit tests! !
!UI.Scintilla.Tests.ScintillaViewTest categoriesFor: #testOverrideDefaultKeyBindings!public!unit tests! !
!UI.Scintilla.Tests.ScintillaViewTest categoriesFor: #testSetGetAnnotations!public!unit tests! !
