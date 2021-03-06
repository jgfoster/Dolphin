﻿"Filed out from Dolphin Smalltalk 7"!

External.UINT_PTR subclass: #'External.INT_PTR'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
External.INT_PTR guid: (Core.GUID fromString: '{7454f675-5169-482b-9a37-5fe37154d567}')!
External.INT_PTR comment: ''!
!External.INT_PTR categoriesForClass!External-Data-Structured! !
!External.INT_PTR methodsFor!

isSigned
	"Answer whether the receiver holds a signed 2's complement binary value, as opposed to an unsigned binary value."

	^true!

unsignedValue: anUnsigned 
	"Set the receiver's value field to the value of the unsigned positive
	integer, anUnsigned."

	bytes uintPtrAtOffset: 0 put: anUnsigned!

value
	"Answer the <Integer> value of the receiver's 'value' field."

	^bytes intPtrAtOffset: _OffsetOf_value!

value: anInteger
	"Set the receiver's 'value' field to the value of the argument, anInteger"

	bytes intPtrAtOffset: _OffsetOf_value put: anInteger! !
!External.INT_PTR categoriesFor: #isSigned!public!testing! !
!External.INT_PTR categoriesFor: #unsignedValue:!accessing!public! !
!External.INT_PTR categoriesFor: #value!**compiled accessors**!public! !
!External.INT_PTR categoriesFor: #value:!**compiled accessors**!public! !

!External.INT_PTR class methodsFor!

defineFields
	"Define the fields of the ExternalInteger 'structure'. ExternalInteger subclasses
	have a single value."

	self defineField: #value type: INT_PTRField new beOverride! !
!External.INT_PTR class categoriesFor: #defineFields!public!template definition! !

