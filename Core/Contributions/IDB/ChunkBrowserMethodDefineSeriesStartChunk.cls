﻿"Filed out from Dolphin Smalltalk 7"!

ChunkBrowserSeriesStartChunk subclass: #ChunkBrowserMethodDefineSeriesStartChunk
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
ChunkBrowserMethodDefineSeriesStartChunk guid: (Core.GUID fromString: '{d788a393-1fe6-4b1b-ae26-cfbac04db82a}')!
ChunkBrowserMethodDefineSeriesStartChunk comment: 'See [DolphinImageFolder]/Idb/Documentation for details

(C) 2006 Ian Bartholomew
ian@idb.me.uk
Public Domain Freeware'!
!ChunkBrowserMethodDefineSeriesStartChunk categoriesForClass!IDB Goodies! !
!ChunkBrowserMethodDefineSeriesStartChunk methodsFor!

seriesClass
	^ChunkBrowserMethodDefineChunk! !
!ChunkBrowserMethodDefineSeriesStartChunk categoriesFor: #seriesClass!constants!public! !

!ChunkBrowserMethodDefineSeriesStartChunk class methodsFor!

isChunkClassFor: aString
	"'Abc methodsFor' or 'Abc class methodsFor'"

	| firstSpaceIndex |
	^(firstSpaceIndex := aString indexOf: $\x20) == 0
		ifTrue: [false]
		ifFalse: 
			[(aString indexOfSubCollection: ' methodsFor') = firstSpaceIndex
				or: [(aString indexOfSubCollection: ' class methodsFor') = firstSpaceIndex]]! !
!ChunkBrowserMethodDefineSeriesStartChunk class categoriesFor: #isChunkClassFor:!public!testing! !

