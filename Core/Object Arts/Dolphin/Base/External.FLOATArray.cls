﻿"Filed out from Dolphin Smalltalk 7"!

External.ExternalArray subclass: #'External.FLOATArray'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
External.FLOATArray guid: (Core.GUID fromString: '{87b4c5a3-026e-11d3-9fd7-00a0cc3e4a32}')!
External.FLOATArray comment: 'Specialized <ExternalArray> to represent contiguous single-dimensioned arrays of single-precision (32-bit) floating point numbers.'!
!External.FLOATArray categoriesForClass!External-Data-Structured! !
!External.FLOATArray methodsFor!

uncheckedAt: anInteger 
	"Private - Answer a <Float> representing the 32-bit single-precision 
	IEEE float at the specified <integer> index in the receiver. No bounds 
	checks are performed on the subscript."

	^bytes floatAtOffset: (anInteger - 1) * VMConstants.FloatSize!

uncheckedAt: anInteger put: aFloat 
	"Private - Replace the single-precision floating point value at the specified index in the receiver
	with the Float argument."

	^bytes floatAtOffset: (anInteger - 1) * VMConstants.FloatSize put: aFloat! !
!External.FLOATArray categoriesFor: #uncheckedAt:!accessing!private! !
!External.FLOATArray categoriesFor: #uncheckedAt:put:!accessing!private! !

!External.FLOATArray class methodsFor!

elementClass
	"Answer the class of <ExternalStructure> used to represent elements of the receiver."

	^FLOAT! !
!External.FLOATArray class categoriesFor: #elementClass!constants!public! !

