'********** IMinMax.Bas - tests the IMin and IMax functions
' Copyright (c) 1988 Ethan Winer
' Modifications (c) 2023 Cory Smith

#INCLUDE ONCE "PRO.BI" ' IMaxI, IMinI, IMaxL, IMinL, IMaxS, IMinS, IMaxD, IMinD

CLS
VAR numEls = 10000
REDIM array(1 TO numEls) AS DOUBLE

array(3) = 17
array(101) = 9000987.45321#
array(100) = 9000987.452099999#
array(numEls) = -12049875643.0876#

VAR t = TIMER
VAR x = IMaxD(@array(1), numEls)
VAR t1 = TIMER

'----- IMaxD returns how many elements it searched, so we need the fudge
'      below if the array doesn't start at element zero
x = x + LBOUND(array, 1)

PRINT "The largest value is in element"; x; "="; Array(x)
PRINT USING "It took #.### seconds to scan 80,000 bytes"; t1 - t
