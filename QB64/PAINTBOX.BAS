' ********** PAINTBOX.BAS - allows painting screen colors without reprinting

' Copyright (c) 1987 Ethan Winer
' Modifications (c) 2022 Cory Smith

DEFINT A-Z

'$INCLUDE: 'QPPRO.BI'

_FULLSCREEN _SQUAREPIXELS

DECLARE SUB PaintBox (ulRow, ulCol, lrRow, lrCol, colr, page)

' Removed and replaced with the OneColor function.
'DEF FnColors (FG, BG) = (FG AND 16) * 8 + (BG * 16) + (FG AND 15)

CLS

COLOR 7, 0              ' color to use for printing test pattern
colr = OneColor(9, 4)   ' color to use for PaintBox

ulRow = 7: ulCol = 20
lrRow = 16: lrCol = 60
page = -1

FOR x = 1 TO 22
  PRINT STRING$(80, "X");    ' display test pattern
NEXT

PRINT
PRINT "Press a key ";
LOCATE , , 1
WHILE INKEY$ = "": WEND

PaintBox ulRow, ulCol, lrRow, lrCol, colr, page

'$INCLUDE: 'QPPRO.BAS'