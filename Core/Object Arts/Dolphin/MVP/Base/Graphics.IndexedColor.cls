﻿"Filed out from Dolphin Smalltalk 7"!

Graphics.Color subclass: #'Graphics.IndexedColor'
	instanceVariableNames: 'index'
	classVariableNames: 'InstancesByIndex InstancesByName Names'
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Graphics.IndexedColor guid: (Core.GUID fromString: '{87b4c53a-026e-11d3-9fd7-00a0cc3e4a32}')!
Graphics.IndexedColor comment: '`IndexedColor` instances represent the 16 standard colours that have been defined in Windows since its inception and that are always available in the standard system palette. There are actually 20 indexed colours, but 4 of these do not necessarily map to a fixed colour name.

As indexed colors are a legacy representation they are now soft-deprecated. They should be avoided in new code and in most circumstances where you might previously have received an `IndexedColor` from a `Color` instance creation method, you will now get an `RGB` instead. IndexedColors are no longer accessible by name through `Color class>>named:`. However, it is expected that `IndexedColor`s will continue to exist in pre-existing view resources and might result from calling certain older APIs.

Historically we have used a logical system to name the indexed colours, which correspond to the following names from the common colour name set:

*IndexedColor	Common Color*
 black		black 
 blue		blue 
 brown		olive 
 cyan		cyan 
 darkBlue		navy 
 darkCyan	teal 
 darkGray	gray 
 darkGreen	commonGreen 
 darkMagenta	purple 
 darkRed		maroon 
 gray		silver 
 green		green 
 magenta		magenta 
 red			red 
 white		white 
 yellow		yellow

In cases where the names are different, the common colours may also contain a slightly different colour with the same name as the Dolphin indexed colour name. An example is #darkCyan, which is a subtly different shade of turquoise to teal.'!
!Graphics.IndexedColor categoriesForClass!Drawing! !
!Graphics.IndexedColor methodsFor!

asCOLORREF
	"Answer the receiver's COLORREF encoding. This is basically an BGR encoding, but the high bits (that would be used for an alpha value in an ARGB) are used for some special values, either
	to indicate indexed colours, or for Color none and Color default."

	^index!

asParameter
	"Answer the receiver such that it can be used for an API call that supports the old Windows indexed colour encoding."

	"It is recommended not to use this conversion, as it will only word with old APIs like GDI. It is better to send one of the more specific encoded value accessors, #argbCode or #rgbCode."

	^index!

asRGB
	"Answer the receiver as an RGB using the default palette."

	^Color fromRgbCode: self rgbCode!

asRGBUsingNoPalette
	Notification deprecated.	"Use #asRGB"
	^self asRGB!

asRGBUsingPalette: aPalette
	"Answer the <RGB> equivalent of the receiver as mapped in the specified Windows palette."

	^Color fromRgbCode: (self rgbCodeFromPalette: aPalette)!

index
	"Answer the receiver's <integer> index. This is one of the special indexed colour constants recognised by older Windows APIs."

	^index!

name
	"Answer the symbolic name of the receiver. This is the name from the original Dolphin set, and does not necessarily correspond directly to the common colour names that are now used. See the class comment for further details."

	^Names at: index!

printOn: aPuttableStream
	"Append, to the <puttableStream>, target, a string whose characters are a the same as those which would result from sending a #printString message to the receiver."

	aPuttableStream
		print: self class;
		space;
		display: self name!

rgbCode
	"Answer the receiver's color value in 24-bit RGB encoding with 8-bits per component in (blue, green, red) order."

	^SystemMetrics current hasGdiPalettes
		ifTrue: [self rgbCodeFromPalette: self defaultPalette]
		ifFalse: [self rgbCodeFromStdPalette]!

rgbCodeFromPalette: aPalette
	"Answer the COLORREF encoded RGB value that the receiver represents in the specified GDI palette."

	| paletteEntry |
	paletteEntry := PALETTEENTRY newBuffer.
	^(GDILibrary default
		getPaletteEntries: aPalette asParameter
		iStartIndex: index
		nEntries: 1
		lppe: paletteEntry) == 0
		ifTrue: [GDILibrary default systemError]
		ifFalse: [paletteEntry rgbCode]!

rgbCodeFromStdPalette
	"Answer the COLORREF encoded RGB value that the receiver represents in a standard palette."

	^##(IdentityDictionary withAll: {16r1000000 -> 16r000000.
				16r1000001 -> 16r000080.
				16r1000002 -> 16r008000.
				16r1000003 -> 16r008080.
				16r1000004 -> 16r800000.
				16r1000005 -> 16r800080.
				16r1000006 -> 16r808000.
				16r1000007 -> 16rC0C0C0.
				16r100000C -> 16r808080.
				16r100000D -> 16r0000FF.
				16r100000E -> 16r00FF00.
				16r100000F -> 16r00FFFF.
				16r1000010 -> 16rFF0000.
				16r1000011 -> 16rFF00FF.
				16r1000012 -> 16rFFFF00.
				16r1000013 -> 16rFFFFFF})
		at: self index!

setIndex: anInteger
	index := anInteger!

shallowCopy
	"The receiver's instances are unique for each named value."

	^self!

stbSaveOn: anSTBOutFiler
	"Output the receiver to anSTBOutFiler."

	"IndexedColors are soft-deprecated - upgrade them to equivalent named colours on save."
	anSTBOutFiler nextPut: self asRGB! !
!Graphics.IndexedColor categoriesFor: #asCOLORREF!accessing!public! !
!Graphics.IndexedColor categoriesFor: #asParameter!converting!public! !
!Graphics.IndexedColor categoriesFor: #asRGB!converting!public!wine fix! !
!Graphics.IndexedColor categoriesFor: #asRGBUsingNoPalette!converting!public! !
!Graphics.IndexedColor categoriesFor: #asRGBUsingPalette:!converting!public! !
!Graphics.IndexedColor categoriesFor: #index!accessing!public! !
!Graphics.IndexedColor categoriesFor: #name!accessing!public! !
!Graphics.IndexedColor categoriesFor: #printOn:!development!printing!public! !
!Graphics.IndexedColor categoriesFor: #rgbCode!converting!public! !
!Graphics.IndexedColor categoriesFor: #rgbCodeFromPalette:!converting!public! !
!Graphics.IndexedColor categoriesFor: #rgbCodeFromStdPalette!converting!public! !
!Graphics.IndexedColor categoriesFor: #setIndex:!accessing!private! !
!Graphics.IndexedColor categoriesFor: #shallowCopy!copying!public! !
!Graphics.IndexedColor categoriesFor: #stbSaveOn:!binary filing!public! !

!Graphics.IndexedColor class methodsFor!

black
	^self named: #black!

initialize
	"Initialise the map of standard colour names to indices. Note that the colour names are not completely consistent with the common colour names used by the Color superclass.
		self initialize.
	"

	| byName byIndex names |
	byName := LookupTable new.
	byIndex := IdentityDictionary new.
	names := IdentityDictionary new.
	#(#black 16r1000000 #darkRed 16r1000001 #darkGreen 16r1000002 #brown 16r1000003 #darkBlue 16r1000004 #darkMagenta 16r1000005 #darkCyan 16r1000006 #gray 16r1000007 #darkGray 16r100000C #red 16r100000D #green 16r100000E #yellow 16r100000F #blue 16r1000010 #magenta 16r1000011 #cyan 16r1000012 #white 16r1000013)
		pairsDo: 
			[:s :i |
			| color |
			color := self basicNew setIndex: i.
			color isImmutable: true.
			byIndex at: i put: color.
			byName at: s put: color.
			names at: i put: s].
	self addClassConstant: 'InstancesByName' value: byName.
	self addClassConstant: 'InstancesByIndex' value: byIndex.
	self addClassConstant: 'Names' value: names!

named: aString
	"Answer the named <IndexedColor>."

	"Note that the indexed colour names are not directly compatible with the common colour names used by the rest of the Color hierarchy, e.g. IndexedColor brown = (Color named: #olive) and IndexedColor darkRed = (Color named: #maroon) .
	The legacy names are retained for some backwards compatibility in existing uses, but it is recommended that IndexedColors be avoided where possible."

	^InstancesByName at: aString!

stbReadFrom: anSTBInFiler format: anSTBClassConversion 
	"Read a sub-instance of the receiver from the binary filer, aSTBInFiler."

	"Implementation Note: Overridden in order to maintain unique instances without using a proxy"

	| answer ref |
	anSTBInFiler version < 3 ifTrue: [anSTBInFiler stream skip: 4].
	"Make a placeholder for the Color"
	ref := anSTBInFiler register: nil.
	answer := self withIndex: anSTBInFiler basicNext.
	anSTBInFiler fixup: ref to: answer.
	^answer!

white
	^self named: #white!

withIndex: anInteger
	"Answer the unique <IndexedColor> whose index is the <integer> argument."

	^InstancesByIndex at: anInteger! !
!Graphics.IndexedColor class categoriesFor: #black!common colors!public! !
!Graphics.IndexedColor class categoriesFor: #initialize!development!initializing!public! !
!Graphics.IndexedColor class categoriesFor: #named:!instance creation!named colors!public! !
!Graphics.IndexedColor class categoriesFor: #stbReadFrom:format:!binary filing!public! !
!Graphics.IndexedColor class categoriesFor: #white!common colors!public! !
!Graphics.IndexedColor class categoriesFor: #withIndex:!instance creation!public! !

