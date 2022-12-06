' ********** DAYNAME.BAS - shows how DayName works

' Modifications (c) 2022 Cory Smith

DEFINT A-Z

_TITLE "DAYNAME"

'$INCLUDE: 'PRO.BI'

_FULLSCREEN _SQUAREPIXELS

DECLARE FUNCTION DayName$ (x%)

CLS
FOR x = 1 TO 7
  PRINT x; DayName$(x)
NEXT

'$INCLUDE: 'PRO.BAS'