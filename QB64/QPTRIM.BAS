' ********* QPTrim.Bas - demonstrates QPLTrim$, QPRTrim$, and QPTrim$

' Copyright (c) 1988 Ethan Winer
' Modifications (c) 2022 Cory Smith

DEFINT A-Z

'$INCLUDE: 'PRO.BI'

'_FULLSCREEN _SQUAREPIXELS

DECLARE FUNCTION QPLTrim$ (x$)
DECLARE FUNCTION QPRTrim$ (x$)
DECLARE FUNCTION QPTrim$ (x$)

CLS

zero$ = STRING$(5, 0)
x$ = zero$ + "    This is a very silly sort of test       " + zero$

PRINT "Original ===> {"; x$; "}"
PRINT "QPLTrim  ===> {"; QPLTrim$(x$); "}"
PRINT "QPRTrim  ===> {"; QPRTrim$(x$); "}"
PRINT "QPTrim   ===> {"; QPTrim$(x$); "}"

'$INCLUDE: 'PRO.BAS'