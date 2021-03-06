﻿"Filed out from Dolphin Smalltalk 7"!

Core.Tests.DolphinTest subclass: #'OS.COM.Tests.InterfaceTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
OS.COM.Tests.InterfaceTest guid: (Core.GUID fromString: '{3cbd4156-925e-437d-b6b6-e862481e60c6}')!
OS.COM.Tests.InterfaceTest comment: ''!
!OS.COM.Tests.InterfaceTest categoriesForClass!Unclassified! !
!OS.COM.Tests.InterfaceTest methodsFor!

testAllRegistered
	| missing different |
	missing := OrderedCollection new.
	different := OrderedCollection new.
	IUnknown withAllSubclasses do: 
			[:each |
			(Interface classForIID: each iid ifNone: [])
				ifNil: [missing add: each]
				ifNotNil: [:found | found == each ifFalse: [different add: each]]].
	self assert: different asArray equals: #().
	self assert: missing asArray equals: #()!

testGetObject
	| factory font |
	self should: [IUnknown getObject: 'bad'] raise: HRESULTError.
	"clsid monikers are quite interesting, as they allow one to bind to the class"
	factory := IClassFactory getObject: 'clsid:' , IFont clsid asString.
	font := factory createInstance: nil iid: IFont iid.
	font name! !
!OS.COM.Tests.InterfaceTest categoriesFor: #testAllRegistered!public!unit tests! !
!OS.COM.Tests.InterfaceTest categoriesFor: #testGetObject!public!unit tests! !

