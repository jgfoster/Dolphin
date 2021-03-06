﻿"Filed out from Dolphin Smalltalk 7"!

OS.NMGETINFOTIP subclass: #'OS.NMLVGETINFOTIPW'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
		'_OffsetOf_cchTextMax' -> 16r14.
		'_OffsetOf_dwFlags' -> 16rC.
		'_OffsetOf_iItem' -> 16r18.
		'_OffsetOf_iSubItem' -> 16r1C.
		'_OffsetOf_lParam' -> 16r20.
		'_OffsetOf_pszText' -> 16r10
	}!
OS.NMLVGETINFOTIPW guid: (Core.GUID fromString: '{cfd19e11-86a3-4b65-ae78-55b3c8c34b0c}')!
OS.NMLVGETINFOTIPW comment: ''!
!OS.NMLVGETINFOTIPW categoriesForClass!External-Data-Structured-Win32! !
!OS.NMLVGETINFOTIPW methodsFor!

cchTextMax
	"Answer the <Integer> value of the receiver's 'cchTextMax' field."

	^bytes sdwordAtOffset: _OffsetOf_cchTextMax!

dwFlags
	"Answer the <Integer> value of the receiver's 'dwFlags' field."

	^bytes dwordAtOffset: _OffsetOf_dwFlags!

iItem
	"Answer the <Integer> value of the receiver's 'iItem' field."

	^bytes sdwordAtOffset: _OffsetOf_iItem!

iSubItem
	"Answer the <Integer> value of the receiver's 'iSubItem' field."

	^bytes sdwordAtOffset: _OffsetOf_iSubItem!

itemHandle
	"Answer the 'handle' of the receiver's item."

	^self iItem + 1!

pszText
	"Answer the <ExternalAddress> value of the receiver's 'pszText' field."

	^(bytes uintPtrAtOffset: _OffsetOf_pszText) asExternalAddress! !
!OS.NMLVGETINFOTIPW categoriesFor: #cchTextMax!**compiled accessors**!public! !
!OS.NMLVGETINFOTIPW categoriesFor: #dwFlags!**compiled accessors**!public! !
!OS.NMLVGETINFOTIPW categoriesFor: #iItem!**compiled accessors**!public! !
!OS.NMLVGETINFOTIPW categoriesFor: #iSubItem!**compiled accessors**!public! !
!OS.NMLVGETINFOTIPW categoriesFor: #itemHandle!accessing!public! !
!OS.NMLVGETINFOTIPW categoriesFor: #pszText!**compiled accessors**!public! !

!OS.NMLVGETINFOTIPW class methodsFor!

defineFields
	"Define the structure template for Win32 NMLVGETINFOTIPW structure.
	Implementation Note: We define the text field as an address because we
	need to write back to the buffer pointed at by that field rather than overwrite
	it.

		self compileDefinition

		typedef struct tagNMLVGETINFOTIPW
		{
			NMHDR hdr;
			DWORD dwFlags;
			LPWSTR pszText;
			int cchTextMax;
			int iItem;
			int iSubItem;
			LPARAM lParam;
		} NMLVGETINFOTIPW, *LPNMLVGETINFOTIPW;"

	super defineFields.
	self
		defineField: #dwFlags type: DWORDField readOnly;
		defineField: #pszText type: LPVOIDField readOnly;
		defineField: #cchTextMax type: SDWORDField readOnly;
		defineField: #iItem type: SDWORDField readOnly;
		defineField: #iSubItem type: SDWORDField readOnly;
		defineField: #lParam type: INT_PTRField filler!

getFieldNames
	^#(#hwndFrom #idFrom #code #dwFlags #pszText #cchTextMax #iItem #iSubItem)! !
!OS.NMLVGETINFOTIPW class categoriesFor: #defineFields!public!template definition! !
!OS.NMLVGETINFOTIPW class categoriesFor: #getFieldNames!**compiled accessors**!constants!private! !

