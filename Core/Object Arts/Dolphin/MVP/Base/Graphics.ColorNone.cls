﻿"Filed out from Dolphin Smalltalk 7"!

Graphics.ColorRef subclass: #'Graphics.ColorNone'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Graphics.ColorNone guid: (Core.GUID fromString: '{21257bc4-33c5-4684-b606-e387fcfbede6}')!
Graphics.ColorNone comment: '`ColorNone` is the special `ColorRef` which represents a completely transparent colour. It is used to specify that something should be drawn transparently, or that the background should not be filled.

`ColorNone`s singleton instance is accessed using the expression `Color transparent`.

The superclass `code` instance variable has the value `Win32Constants.CLR_NONE`.'!
!Graphics.ColorNone categoriesForClass!Unclassified! !
!Graphics.ColorNone methodsFor!

alpha
	"Answer the receiver's alpha component (a SmallInteger in the range 0..255). This specifies
	the opacity of the colour, with 0 being completely transparent and 255 completely opaque."

	^0!

alphaMask
	"Private - Answer the receiver's alpha bits as they would compose into an ARGB."

	^0!

argbCode
	"Answer the receiver's colour value in 32-bit ARGB encoding with 8-bits per component in alpha, red, green, blue order.
	Note that we choose to represent Color none/transparent as transparent white."

	^16rFFFFFF!

brush
	"Answer a Brush configured for solid painting of the receiver's color."

	^StockBrush fromId: Win32Constants.NULL_BRUSH!

hls
	"Answer the hue, luminance, and saturation values that correspond to the receiver."

	"Color none is a completely transparent Color white."

	^#(0.0 1.0 0.0)!

hslSaturation
	"Answer a <Number> in the range [0, 1] representing the HSL saturation of the receiver."

	"Color none is a completely transparent Color white."

	^0.0!

hsv
	"Answer a three-element <Array> containing the hue, saturation and brightness values that describe the receiver in the HSV colour system."

	"Color none is a represented as a completely transparent white."

	^#(0.0 0.0 1.0)!

hsvSaturation
	"Answer a <Number> in the range [0,1] representing the HSV saturation of the receiver."

	"Color none is a completely transparent Color white."

	^0.0!

hue
	"Answer a <Number> in the range [0,360] representing the receiver's hue in the HSV or HLS color models."

	^0.0!

isNone
	"Answer whether the receiver is the special <Color> representing no colour."

	^true!

luminance
	"Behaves as Color white for this purpose, but with zero alpha."

	^1.0!

name
	"Answer the symbolic name of the colour, or nil if it does not have a name (or known name)."

	^#transparent!

normalizedAlpha
	^0!

pen
	"Answer a <Pen> configured for painting solid 1-pixel wide lines of the receiver's color."

	^self penClass none!

rgbCode
	"Answer the receiver's colour value in 32-bit RGB encoding with 8-bits per component in alpha, red, green, blue order.
	Alpha transparency is lost."

	^16rFFFFFF!

shallowCopy
	"The receiver has a singleton instance."

	^self! !
!Graphics.ColorNone categoriesFor: #alpha!accessing!public! !
!Graphics.ColorNone categoriesFor: #alphaMask!accessing!private! !
!Graphics.ColorNone categoriesFor: #argbCode!accessing!public! !
!Graphics.ColorNone categoriesFor: #brush!converting!public! !
!Graphics.ColorNone categoriesFor: #hls!converting!public! !
!Graphics.ColorNone categoriesFor: #hslSaturation!accessing!public! !
!Graphics.ColorNone categoriesFor: #hsv!converting!public! !
!Graphics.ColorNone categoriesFor: #hsvSaturation!accessing!public! !
!Graphics.ColorNone categoriesFor: #hue!public! !
!Graphics.ColorNone categoriesFor: #isNone!public!testing! !
!Graphics.ColorNone categoriesFor: #luminance!public! !
!Graphics.ColorNone categoriesFor: #name!accessing!public! !
!Graphics.ColorNone categoriesFor: #normalizedAlpha!public! !
!Graphics.ColorNone categoriesFor: #pen!converting!public! !
!Graphics.ColorNone categoriesFor: #rgbCode!accessing!public! !
!Graphics.ColorNone categoriesFor: #shallowCopy!copying!public! !

