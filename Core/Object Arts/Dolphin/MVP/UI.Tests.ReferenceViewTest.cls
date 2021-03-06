﻿"Filed out from Dolphin Smalltalk 7"!

UI.Tests.PresenterTest subclass: #'UI.Tests.ReferenceViewTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
UI.Tests.ReferenceViewTest guid: (Core.GUID fromString: '{a38c1b83-5cc7-4717-8bc4-29b681abe8f9}')!
UI.Tests.ReferenceViewTest isNonInstantiable: true!
UI.Tests.ReferenceViewTest comment: ''!
!UI.Tests.ReferenceViewTest categoriesForClass!Unclassified! !
!UI.Tests.ReferenceViewTest methodsFor!

classToTest
	^self subclassResponsibility!

initializePresenter
	presenter := ReferenceView
				resourceIdentifier: (ResourceIdentifier class: Presenter name: 'OK Cancel button block').
	presenter showShell!

testRecreate
	"Test that recreate does not create an orphaned child (#1667), and that it preserves
	settings that were not present originally."

	self assert: presenter subViews size equals: 1.
	self deny: presenter referee hasBorder.
	presenter subViews first hasBorder: true.
	presenter recreate.
	self assert: presenter subViews size equals: 1.
	self assert: presenter referee hasBorder! !
!UI.Tests.ReferenceViewTest categoriesFor: #classToTest!helpers!private! !
!UI.Tests.ReferenceViewTest categoriesFor: #initializePresenter!public!Running! !
!UI.Tests.ReferenceViewTest categoriesFor: #testRecreate!public!unit tests! !

