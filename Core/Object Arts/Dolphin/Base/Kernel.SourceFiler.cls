﻿"Filed out from Dolphin Smalltalk 7"!

Core.Object subclass: #'Kernel.SourceFiler'
	instanceVariableNames: 'stream evaluationContext flags'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
		'SourceOnlyMask' -> 16r1
	}!
Kernel.SourceFiler guid: (Core.GUID fromString: '{847f25f1-cd60-490c-817f-3f0f2cefd567}')!
Kernel.SourceFiler isNonInstantiable: true!
Kernel.SourceFiler comment: ''!
!Kernel.SourceFiler categoriesForClass!Development!System-Support! !
!Kernel.SourceFiler methodsFor!

atEnd
	"Answer whether the receiver is at the end of its source stream."

	^stream atEnd!

close
	"Close the source stream"

	stream close.
	stream := nil!

cr
	"Emit a line-delimiter to the source stream"

	stream cr!

emitFooterForMethodsOf: aClass 
	"Private - Ends the method definition chunks for aClass onto
	the source stream."

	^self subclassResponsibility!

emitGUIDOfClass: aClass 
	"Private - Emit a GUID definition chunk for the <Class>, aClass, to the source stream."

	^self subclassResponsibility!

emitHeaderForMethodsOf: aClass 
	"Private - Emits a category header for the class, aClass, to the source stream."

	^self subclassResponsibility!

evaluationContext
	^evaluationContext!

evaluationContext: anObject
	evaluationContext := anObject!

fileIn
	"File in the expressions/definitions from receiver's source stream, which is
	expected to be in the receiver's format. Any methods that fail to compile are stubbed 
	with instances of <CompileFailedMethod> and errors are logged to the Transcript."

	^self subclassResponsibility!

flush
	"Flush the source stream."

	stream flush!

getSourceFromDescriptor: sourceDescriptor
	"Answer the <readableString> source corresponding to the specified <integer> 
	descriptor, sourceDescriptor, from the receiver's source stream."

	^self subclassResponsibility!

isSourceOnly
	^flags anyMask: SourceOnlyMask!

isSourceOnly: aBoolean
	flags := flags mask: SourceOnlyMask set: aBoolean!

setStream: aPuttableStream
	stream := aPuttableStream.
	flags := 0!

setToEnd
	"Seek to the end of the source stream."

	stream setToEnd!

sourcePositionFromDescriptor: sourceObject
	"Private - Answer the offset from the start of the source file at which the chunk containing
	the source code whose location is described by, sourceDescriptor, can be found.
	If sourceObject is not an Integer, then an error will result."

	^sourceObject bitShift: -4!

storeSource: aString for: aSourceObject
	"Private - Store the <readableString>, aString, as the source text for the <sourceObject>,
	aSourceObject, updating its source descriptor."

	^self subclassResponsibility!

storeSourceString: aString forMethod: aCompiledMethod 
	"Save the <readableString>, aString, as the source text for the 
	<CompiledMethod>, aCompiledMethod, to the receiver's source stream
	encoding the position and index into the methods source descriptor so that 
	the source may be retrieved later."

	^self subclassResponsibility!

stream
	"Private - Answer the value of the receiver's ''stream'' instance variable."

	^stream! !
!Kernel.SourceFiler categoriesFor: #atEnd!public!testing! !
!Kernel.SourceFiler categoriesFor: #close!operations!public! !
!Kernel.SourceFiler categoriesFor: #cr!accessing!public! !
!Kernel.SourceFiler categoriesFor: #emitFooterForMethodsOf:!private!source filing! !
!Kernel.SourceFiler categoriesFor: #emitGUIDOfClass:!private!source filing! !
!Kernel.SourceFiler categoriesFor: #emitHeaderForMethodsOf:!private!source filing! !
!Kernel.SourceFiler categoriesFor: #evaluationContext!accessing!public! !
!Kernel.SourceFiler categoriesFor: #evaluationContext:!accessing!public! !
!Kernel.SourceFiler categoriesFor: #fileIn!public!source filing! !
!Kernel.SourceFiler categoriesFor: #flush!operations!public! !
!Kernel.SourceFiler categoriesFor: #getSourceFromDescriptor:!public!source filing! !
!Kernel.SourceFiler categoriesFor: #isSourceOnly!accessing!public! !
!Kernel.SourceFiler categoriesFor: #isSourceOnly:!accessing!public! !
!Kernel.SourceFiler categoriesFor: #setStream:!initializing!private! !
!Kernel.SourceFiler categoriesFor: #setToEnd!positioning!public! !
!Kernel.SourceFiler categoriesFor: #sourcePositionFromDescriptor:!private!source filing! !
!Kernel.SourceFiler categoriesFor: #storeSource:for:!private!source filing! !
!Kernel.SourceFiler categoriesFor: #storeSourceString:forMethod:!public!source filing! !
!Kernel.SourceFiler categoriesFor: #stream!accessing!private! !

!Kernel.SourceFiler class methodsFor!

on: aWriteStream 
	"Answer a new instance of the receiver for filing out source code onto the 
	<puttableStream> argument."

	^(self new)
		setStream: aWriteStream;
		yourself! !
!Kernel.SourceFiler class categoriesFor: #on:!instance creation!public! !

