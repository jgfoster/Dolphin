﻿"Filed out from Dolphin Smalltalk 7"!

UI.Scintilla.QueryableAttribute subclass: #'UI.Scintilla.Margin'
	instanceVariableNames: 'width type isSensitive mask cursorType backcolor'
	classVariableNames: 'CursorTypes'
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
		'MarginTypes' -> #(#symbol #lineNumber #symbolBackground #symbolForeground #text #rightJustifiedText #color)
	}!
UI.Scintilla.Margin guid: (Core.GUID fromString: '{fd6f73fe-70d8-4e4a-8332-ec147e5ba899}')!
UI.Scintilla.Margin comment: '`ScintillaMargin` instances represent the ''margin'' attributes of a `ScintillaView`.

There may be multiple margins to the left of the text display, plus a gap either side of the text. Each margin can be set to display either "marker" symbols, line numbers or text, as specified by the `#style` aspect. The markers that can be displayed in each margin are set with `#mask` aspect. Any markers not associated with a visible margin will be displayed as changes in background colour in the text. A width in pixels can be set for each margin using the `#width` aspect. Margins with a zero width are ignored completely. The `#isSensitive` aspect controls whether a mouse click in a margin triggers a `#marginClicked` event or selects the corresponding line of text.

## Margin Styles
The margin `#style` can be one of the following:
  `#symbol`			The margin displays marker symbols
  `#lineNumber`		The margin displays line numbers
  `#symbolBackground`	As `#symbol`, but also colours the background of the margin in the default style background colour. This markes the margin area appear to be part of the text area.
  `#symbolForeground`	As `#symbol` but colours the background in the default style foreground colour.
  `#text`				The margin displays the text set for the line, if any. *N.B. Text margins are not currently modelled in the ScintillaView abstraction as a high level concept*
  `#rightJustifiedText`	As `#text` but the text is displayed right justified
  `#color`				As `#symbol`, but also colours the background of the margin to a colour configured as the `backcolor` of the margin.

## Instance Variables:
  `width`		`<integer>`. Pixel width of the margin (0 if invisible)
  `type`		`<integer>`. Type code (numbers, symbols, or numbers and symbols) fromm the `SC_MARGIN_XXX` enumeration.
  `isSensitive`	`<boolean>`. Whether responds to mouse clicks by sending SCN_MARGINCLICK notifications.
  `mask`		`<integer>` flags controlling which markers can be displayed. See #mask for further details.
  `cursorType`
  `backcolor`	`Color` for margins styles that use it.

## Class Variables:
  `CursorTypes`		`LookupTable`
  `MarginTypes`		`Array`





'!
!UI.Scintilla.Margin categoriesForClass!MVP-Views-Support! !
!UI.Scintilla.Margin methodsFor!

backcolor
	"Answer the background colour used to draw the margin to the <Color> argument. Can be nil, indicatoring that the colour is unspecified, in which case Scintilla's default margin colour (black) is used, but only when the margin has the #color type."

	^backcolor!

backcolor: aColorOrNil
	"Set the background <Color> for the margin, which is used to paint the background of the margin when it has the #color type. If the argument is nil, then the control's default margin background colour will be used (black).
	although typically this value should only be nil when the margin is not using the #color type."

	self basicBackcolor: aColorOrNil.
	self updateViewProperty: #backcolor!

basicBackcolor: aColorOrNil
	backcolor := aColorOrNil!

basicCursorType
	"Private - The Scintilla cursor type to be used in the margin, or nil if the default reverse
	arrow is to be used."

	^cursorType!

basicCursorType: anIntegerOrNil 
	"Private - The Scintilla cursor type to be used in the margin."

	cursorType := anIntegerOrNil!

basicIsSensitive
	^isSensitive!

basicIsSensitive: anIntegerOrNil
	isSensitive := anIntegerOrNil!

basicType
	"Private - The Scintilla margin type. From the Scintilla documentation: 'You can use the
	predefined constants SC_MARGIN_SYMBOL (0) and SC_MARGIN_NUMBER (1) to set a margin as either
	a line number or a symbol margin. A margin with application defined text may use
	SC_MARGIN_TEXT (4) or SC_MARGIN_RTEXT (5) to right justify the text. By convention, margin 0
	is used for line numbers and the next two are used for symbols. You can also use the
	constants SC_MARGIN_BACK (2), SC_MARGIN_FORE (3), and SC_MARGIN_COLOUR (6) for symbol
	margins that set their background colour to match the STYLE_DEFAULT background and
	foreground colours or a specified colour.'"

	^type!

basicType: anIntegerOrNil 
	type := anIntegerOrNil!

basicWidth
	^width!

basicWidth: anIntegerOrNil
	width := anIntegerOrNil!

cursorType
	"The symbolic name of the Scintilla cursor type."

	^self basicCursorType ifNotNil: [:t | CursorTypes at: t]!

cursorType: aSymbol
	"Set the margin's cursor to be that named."

	self basicCursorType: (aSymbol isNil
				ifFalse: [CursorTypes keyAtValue: aSymbol ifAbsent: [self error: 'Invalid cursor type' , aSymbol]]).
	self updateViewProperty: #cursorType!

isFolders
	^mask allMask: SC_MASK_FOLDERS!

isFolders: aBoolean 
	self mask: (self mask mask: SC_MASK_FOLDERS set: aBoolean)!

isSensitive
	"Answer whether this margin is sensitive to mouse clicks."

	^(self basicIsSensitive ?? 0) asBoolean!

isSensitive: aBooleanOrNil
	self basicIsSensitive: (aBooleanOrNil ?? false ifTrue: [1]).
	self updateViewProperty: #isSensitive!

mask
	"Answe the <integer> mask which controls which shapes will be visible in the margin.

	From the Scintilla documentation:

	'The mask is a 32-bit value. Each bit corresponds to one of 32 logical symbols that can be
	displayed in a margin that is enabled for symbols. There is a useful constant,
	SC_MASK_FOLDERS (0xFE000000 or -33554432), that is a mask for the 7 logical symbols used to
	denote folding. You can assign a wide range of symbols and colours to each of the 32 logical
	symbols, see Markers for more information. If (mask & SC_MASK_FOLDERS)==0, the margin
	background colour is controlled by style 33 (STYLE_LINENUMBER).

	... If a line has an associated marker that does not appear in the mask of any margin with a
	non-zero width, the marker changes the background colour of the line. For example, suppose
	you decide to use logical marker 10 to mark lines with a syntax error and you want to show
	such lines by changing the background colour. The mask for this marker is 1 shifted left 10
	times (1<<10) which is 0x400. If you make sure that no symbol margin includes 0x400 in its
	mask, any line with the marker gets the background colour changed.

	To set a non-folding margin 1 use SCI_SETMARGINMASKN(1, ~SC_MASK_FOLDERS); to set a folding
	margin 2 use SCI_SETMARGINMASKN(2, SC_MASK_FOLDERS). This is the default set by Scintilla.
	~SC_MASK_FOLDERS is 0x1FFFFFF in hexadecimal or 33554431 decimal. Of course, you may need to
	display all 32 symbols in a margin, in which case use SCI_SETMARGINMASKN(margin, -1).'"

	^mask!

mask: anInteger
	mask := anInteger.
	self updateViewProperty: #mask!

type
	"The symbolic name of the Scintilla margin type, defaulting to #symbol."

	^self basicType
		ifNil: [#symbol]
		ifNotNil: [:t | MarginTypes at: t + 1]!

type: aSymbol
	"Set the margin type by name."

	self basicType: (aSymbol ifNotNil: [(MarginTypes keyAtValue: aSymbol) - 1]).
	self updateViewProperty: #type!

width
	"Answer the <integer> pixel width of this margin."

	^self basicWidth ?? 0!

width: anInteger
	"Answer the <integer> pixel width of this margin. Set to zero to make the margin invisible."

	self basicWidth: (anInteger ifNotNil: [anInteger]).
	self updateViewProperty: #width! !
!UI.Scintilla.Margin categoriesFor: #backcolor!accessing!public! !
!UI.Scintilla.Margin categoriesFor: #backcolor:!accessing!public! !
!UI.Scintilla.Margin categoriesFor: #basicBackcolor:!accessing!private! !
!UI.Scintilla.Margin categoriesFor: #basicCursorType!accessing!private! !
!UI.Scintilla.Margin categoriesFor: #basicCursorType:!accessing!private! !
!UI.Scintilla.Margin categoriesFor: #basicIsSensitive!accessing!private! !
!UI.Scintilla.Margin categoriesFor: #basicIsSensitive:!accessing!private! !
!UI.Scintilla.Margin categoriesFor: #basicType!accessing!private! !
!UI.Scintilla.Margin categoriesFor: #basicType:!accessing!private! !
!UI.Scintilla.Margin categoriesFor: #basicWidth!accessing!private! !
!UI.Scintilla.Margin categoriesFor: #basicWidth:!accessing!private! !
!UI.Scintilla.Margin categoriesFor: #cursorType!accessing!public! !
!UI.Scintilla.Margin categoriesFor: #cursorType:!accessing!public! !
!UI.Scintilla.Margin categoriesFor: #isFolders!accessing!public! !
!UI.Scintilla.Margin categoriesFor: #isFolders:!accessing!public! !
!UI.Scintilla.Margin categoriesFor: #isSensitive!public!testing! !
!UI.Scintilla.Margin categoriesFor: #isSensitive:!accessing!public! !
!UI.Scintilla.Margin categoriesFor: #mask!accessing!public! !
!UI.Scintilla.Margin categoriesFor: #mask:!accessing!public! !
!UI.Scintilla.Margin categoriesFor: #type!accessing!public! !
!UI.Scintilla.Margin categoriesFor: #type:!accessing!public! !
!UI.Scintilla.Margin categoriesFor: #width!accessing!public! !
!UI.Scintilla.Margin categoriesFor: #width:!accessing!public! !

!UI.Scintilla.Margin class methodsFor!

buildPropertyMap
	^IdentityDictionary new
		at: #isSensitive
			put: (PropertyDescriptor
					getSelector: #basicIsSensitive
					defaultValue: 0
					setMessage: SCI_SETMARGINSENSITIVEN
					setSelector: #basicIsSensitive:
					getMessage: SCI_GETMARGINSENSITIVEN);
		at: #mask
			put: (PropertyDescriptor
					getSelector: #mask
					defaultValue: 0
					setMessage: SCI_SETMARGINMASKN
					setSelector: #mask:
					getMessage: SCI_GETMARGINMASKN);
		at: #type
			put: (PropertyDescriptor
					getSelector: #basicType
					defaultValue: SC_MARGIN_SYMBOL
					setMessage: SCI_SETMARGINTYPEN
					setSelector: #basicType:
					getMessage: SCI_GETMARGINTYPEN);
		at: #width
			put: (PropertyDescriptor
					getSelector: #basicWidth
					defaultValue: nil
					setMessage: SCI_SETMARGINWIDTHN
					setSelector: #basicWidth:
					getMessage: SCI_GETMARGINWIDTHN);
		at: #cursorType
			put: (PropertyDescriptor
					getSelector: #basicCursorType
					defaultValue: SC_CURSORREVERSEARROW
					setMessage: SCI_SETMARGINCURSORN
					setSelector: #basicCursorType:
					getMessage: SCI_GETMARGINCURSORN);
		at: #backcolor
			put: (ColorPropertyDescriptor
					getSelector: #backcolor
					defaultValue: Color black
					setMessage: SCI_SETMARGINBACKN
					setSelector: #basicBackcolor:
					getMessage: SCI_GETMARGINBACKN);
		shrink;
		yourself!

initialize
	"
		self initialize
	"

	propertyMap := self buildPropertyMap
				isImmutable: true;
				yourself.
	self addClassConstant: 'MarginTypes'
		value: #(#symbol #lineNumber #symbolBackground #symbolForeground #text #rightJustifiedText #color).
	self addClassConstant: 'CursorTypes'
		value: (LookupTable new
				at: SC_CURSORARROW put: #arrow;
				at: SC_CURSORREVERSEARROW put: #reverseArrow;
				at: SC_CURSORWAIT put: #wait;
				at: SC_CURSORNORMAL put: #normal;
				shrink;
				isImmutable: true;
				yourself)!

stbConvertFrom: anSTBClassFormat
	^
	[:vars |
	| instance |
	instance := self new.
	vars keysAndValuesDo: [:eachKey :eachValue | instance instVarAt: eachKey put: eachValue].
	instance backcolor
		ifNotNil: [:int | instance basicBackcolor: (int isZero ifFalse: [Color fromCOLORREF: int])].
	instance]!

stbVersion
	^3! !
!UI.Scintilla.Margin class categoriesFor: #buildPropertyMap!constants!must not strip!private! !
!UI.Scintilla.Margin class categoriesFor: #initialize!development!initializing!public! !
!UI.Scintilla.Margin class categoriesFor: #stbConvertFrom:!binary filing!private! !
!UI.Scintilla.Margin class categoriesFor: #stbVersion!binary filing!public! !

