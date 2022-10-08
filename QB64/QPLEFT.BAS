' ********* QPLEFT.BAS - demonstrates QPLeft$, QPRight$, and QPMid$

' Copyright (c) 1988 Ethan Winer
' Modifications (c) Cory Smith

DEFINT A-Z

DECLARE FUNCTION QPMid$ (text$, midArg%, numChars%)
DECLARE FUNCTION QPLeft$ (text$, leftArg%)
DECLARE FUNCTION QPRight$ (text$, rightArg%)

CLS

text$ = "This is a very silly sort of test"
Arg = 2

PRINT "{"; text$; "}"
PRINT "{"; QPLeft$(text$, arg); "}"
PRINT "{"; QPRight$(text$, arg); "}"
PRINT "{"; QPMid$(text$, arg, -1); "}"     'a negative value means take all of
                                           'the characters through the end

'$INCLUDE: 'QPPRO.BAS'
