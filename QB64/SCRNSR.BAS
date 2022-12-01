' ********** ScrnSR.Bas - demonstration for saving/restoring screen

' Copyright (c) 1987 Ethan Winer
' Modifications (c) 2022 Cory Smith

DEFINT A-Z

'$INCLUDE: 'QPPRO.BI'

_FULLSCREEN _SQUAREPIXELS

DECLARE FUNCTION ArraySize% (ulRow, ulCol, lrRow, lrCol)
DECLARE SUB Pause (ticks)
DECLARE SUB ScrnSave (ulRow, ulCol, lrRow, lrCol, SEG addr, page)
DECLARE SUB ScrnRest (ulRow, ulCol, lrRow, lrCol, SEG addr, page)

ulRow = 10: ulCol = 30: lrRow = 15: lrCol = 50  ' corners of saved window

DIM array(ArraySize%(ulRow, ulCol, lrRow, lrCol))

' ch% = 255
' clr% = OneColor%(15, 15)
' PRINT ch%, clr%
' ' ' 1 2 3 4  5 6   7   8
' ' ' 2 4 6 8 16 32 64 128 256
' v% = (ch% * 256) + clr% ' combine
' clr% = v% AND &H00FF ' split color
' ch% = ((v% AND &HFF00) \ 256) AND &H00FF ' split character
' PRINT ch%, clr%
' END

CLS
COLOR 2
FOR x = 1 TO 24
  PRINT STRING$(80, x + 96);          ' display test pattern
NEXT

COLOR 7
LOCATE 25, 1, 1
PRINT "Press a key: ";
CALL WaitKey

ScrnSave ulRow, ulCol, lrRow, lrCol, array(), page
CLS
LOCATE 25, 1, 1
PRINT "Do it again: ";
CALL WaitKey
CLS
ScrnRest ulRow, ulCol, lrRow, lrCol, array(), page

ScrnRest 1, 1, 6, 21, array(), page
ScrnRest 1, 60, 6, 80, array(), page
ScrnRest 19, 1, 24, 21, array(), page
ScrnRest 19, 60, 24, 80, array(), page

'$INCLUDE: 'QPPRO.BAS'