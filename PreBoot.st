Float addClassVariable: 'DefaultDecimalExponents' value: (-3 to: 6)!
ParseErrorCodes addClassConstant: 'CWarnMutableIgnored' value: 16r3FA!
#(#thousandSeparator #thousandSeparator:) do: [:each | NUMBERFMTW removeSelector: each]!
