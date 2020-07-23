"Filed out from Dolphin Smalltalk 7"!

DolphinTest subclass: #AssociationTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
AssociationTest guid: (GUID fromString: '{c99d4b53-db6c-4b09-9f2a-7a914d14a0d1}')!
AssociationTest comment: ''!
!AssociationTest categoriesForClass!Unclassified! !
!AssociationTest methodsFor!

testIsSelfEvaluating
	| subject |
	subject := #'1' -> 2.
	self assert: subject isSelfEvaluating.
	subject value: subject.
	self deny: subject isSelfEvaluating
	

! !
!AssociationTest categoriesFor: #testIsSelfEvaluating!public! !

