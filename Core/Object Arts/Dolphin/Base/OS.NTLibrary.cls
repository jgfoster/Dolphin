﻿"Filed out from Dolphin Smalltalk 7"!

External.PermanentLibrary subclass: #'OS.NTLibrary'
	instanceVariableNames: ''
	classVariableNames: 'IsWine'
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
OS.NTLibrary guid: (Core.GUID fromString: '{8293e458-7d81-4aba-97a5-c1001c4b2153}')!
OS.NTLibrary comment: 'NtDllLibrary is the <ExternalLibrary> class to represent the dynamic link library, ''ntdll.dll''.It was generated generated from type information in the ''Win32 API'' library. It contains methods for each of the functions defined by the corresponding module in that type library.

The type library contains the following helpstring For this Module
	"Windows NT Runtime Library"

Warning: This comment was automatically generated from the Module''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.
'!
!OS.NTLibrary categoriesForClass!External-Libraries! !
!OS.NTLibrary methodsFor!

ntQueryTimerResolution: pulMinimumResolution maximum: pulMaximumResolution actual: pulActualResolution
	<stdcall: sdword NtQueryTimerResolution lpvoid lpvoid lpvoid>
	^self invalidCall: _failureCode!

rtlNtStatusToDosError: anInteger
	<stdcall: dword RtlNtStatusToDosError ntstatus>
	^self invalidCall: _failureCode!

setTimerResolution: anInteger set: aBoolean actualResolution: actualResolution
	"NTSYSAPI
		NTSTATUS
		NTAPI
		NtSetTimerResolution(
			IN ULONG RequestedResolution,
			IN BOOLEAN Set,
			OUT PULONG ActualResolution"

	<stdcall: dword NtSetTimerResolution dword bool dword*>
	^self invalidCall: _failureCode!

wineGetVersion
	"static const char * (CDECL *pwine_get_version)(void);"

	<stdcall: lpstr wine_get_version>
	^nil	"instead of reporting an error"! !
!OS.NTLibrary categoriesFor: #ntQueryTimerResolution:maximum:actual:!public! !
!OS.NTLibrary categoriesFor: #rtlNtStatusToDosError:!public!win32 functions-error handling! !
!OS.NTLibrary categoriesFor: #setTimerResolution:set:actualResolution:!accessing!public! !
!OS.NTLibrary categoriesFor: #wineGetVersion!public! !

!OS.NTLibrary class methodsFor!

fileName
	"Answer the host system file name for the external library the 
	receiver represents."

	^'ntdll'!

isWine
	"
	NTLibrary isWine.
"

	^IsWine!

openDefault
	| lib |
	lib := super openDefault.
	IsWine := lib wineGetVersion notNil.
	^lib! !
!OS.NTLibrary class categoriesFor: #fileName!**auto generated**!constants!public! !
!OS.NTLibrary class categoriesFor: #isWine!public!testing! !
!OS.NTLibrary class categoriesFor: #openDefault!instance creation!private!realizing/unrealizing! !

