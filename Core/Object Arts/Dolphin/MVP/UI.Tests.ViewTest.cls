"Filed out from Dolphin Smalltalk 7"!

Core.Tests.DolphinTest subclass: #'UI.Tests.ViewTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
UI.Tests.ViewTest guid: (Core.GUID fromString: '{cf223394-a19e-45f9-a270-551c288901ef}')!
UI.Tests.ViewTest comment: ''!
!UI.Tests.ViewTest categoriesForClass!Unclassified! !
!UI.Tests.ViewTest methodsFor!

testRecreateMaintainsModelConnection
	| t |
	t := TextPresenter show.
	t model value: 'aaa'.
	self assert: t view value equals: 'aaa'.
	t view hasBorder: true.
	t model value: 'bbb'.
	"If this fails, then the view did not receive a #valueChanged event from the model"
	self assert: t view value equals: 'bbb'.
	t topShell exit! !
!UI.Tests.ViewTest categoriesFor: #testRecreateMaintainsModelConnection!public!unit tests! !

