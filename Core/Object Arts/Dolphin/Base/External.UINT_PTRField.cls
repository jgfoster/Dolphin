﻿"Filed out from Dolphin Smalltalk 7"!

External.ScalarField subclass: #'External.UINT_PTRField'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
External.UINT_PTRField guid: (Core.GUID fromString: '{19012b00-96f4-4181-a7e1-0a85a4268d7b}')!
External.UINT_PTRField comment: '<UINT_PTRField> is a <ScalarField> class to represent <ExternalStructure> fields that are unsigned integers the same size as a pointer on the host machine architecture. Currently these are always 32-bit as Dolphin is a 32-bit process.'!
!External.UINT_PTRField categoriesForClass!External-Data-Types! !
!External.UINT_PTRField methodsFor!

accessorMessage
	"Private - Answer the receiver's 'accessorStem'."

	^#uintPtrAtOffset:put:!

readFrom: anExternalStructure
	"Private - Answer an <integer> with the same value as the unsigned pointer-sized field at
	the receiver's offset in the <ExternalStructure> argument."

	^anExternalStructure bytes uintPtrAtOffset: offset!

writeInto: anExternalStructure value: anInteger
	"Private - Write the pointer-sized unsigned <integer> value, anInteger, into the
	<ExternalStructure, anExternalStructure, at the receiver's offset ."

	^anExternalStructure bytes uintPtrAtOffset: offset put: anInteger! !
!External.UINT_PTRField categoriesFor: #accessorMessage!automatic generation!private! !
!External.UINT_PTRField categoriesFor: #readFrom:!indirect accessing!private! !
!External.UINT_PTRField categoriesFor: #writeInto:value:!indirect accessing!private! !

!External.UINT_PTRField class methodsFor!

byteSize
	"Private - Answer the size of the field type the receiver represents in bytes.
	This size will vary between 32 and 64-bit machines."

	^VMConstants.IntPtrSize! !
!External.UINT_PTRField class categoriesFor: #byteSize!constants!private! !

