' ********** SCROLL.BAS - demonstrates the four QuickPak scroll routines

' Copyright (c) 1988 Ethan Winer
' Modifications (c) 2022 Cory Smith

DEFINT A-Z

'$INCLUDE: 'PRO.BI'

'_FULLSCREEN _SQUAREPIXELS

DECLARE SUB ScrollU (ulRow, ulCol, lrRow, lrCol, lines, page)
DECLARE SUB ScrollD (ulRow, ulCol, lrRow, lrCol, lines, page)
DECLARE SUB ScrollL (ulRow, ulCol, lrRow, lrCol, lines, page)
DECLARE SUB ScrollR (ulRow, ulCol, lrRow, lrCol, lines, page)

wide = 80
high = 25
lines = 4
page = -1

ulRow = 7
ulCol = wide \ 8
lrRow = 16
lrCol = wide - wide \ 8

CLS
COLOR 7, 4
FOR x = 1 TO high - 3
  PRINT STRING$(wide, x + 32);        'display test pattern
NEXT

PRINT
PRINT
COLOR 2, 0
PRINT "Scroll Up or Down? ";
LOCATE , , 1

DO
  x$ = INKEY$
LOOP UNTIL LEN(x$)

'Box0 ulRow, ulCol, lrRow, lrCol, 33, OneColor(7,0)
IF UCASE$(x$) = "U" THEN
  ScrollU ulRow, ulCol, lrRow, lrCol, lines, page
ELSE
  ScrollD ulRow, ulCol, lrRow, lrCol, lines, page
END IF

LOCATE , 1
PRINT "Press any key to continue ";
CALL WaitKey

COLOR 7
CLS
COLOR , 4
test$ = SPACE$(wide)

FOR x = 1 TO wide
  MID$(test$, x, 1) = CHR$(x + 32)
NEXT
FOR x = 1 TO high - 3
  PRINT test$;
NEXT

PRINT
PRINT
COLOR 2, 0
PRINT "Scroll Left or Right? ";

DO
  x$ = INKEY$
LOOP UNTIL LEN(x$)

IF UCASE$(x$) = "L" THEN
  ScrollL ulRow, ulCol, lrRow, lrCol, lines, page
ELSE
  ScrollR ulRow, ulCol, lrRow, lrCol, lines, page
END IF

'$INCLUDE: 'PRO.BAS'