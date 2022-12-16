' ********** SCROLL.BAS - demonstrates the four QuickPak scroll routines

' Copyright (c) 1988 Ethan Winer
' Modifications (c) 2022 Cory Smith

' **************************
' * BOILER PLATE BEGIN
' **************************
$Resize:Stretch
CHDIR _STARTDIR$ ' Moved this line above resize to (hopefully) give more init time to window
IF _DesktopHeight => 2160 THEN mult = 4 ELSE IF _DesktopHeight => 1440 THEN mult = 2 ELSE mult = 1
DO: LOOP UNTIL _SCREENEXISTS ' Not sure if necessary; however, there does seem to be some sort of timing issue around getting hwnd
hwnd = _WindowHandle: x = 100: y = 100: w = 640 * mult: h = 480 * mult ' inlined _WindowHandle (next line) because 1 out of every 4 or 5 executions, would encounter an invalid window handle (1400)
IF INSTR(_OS$, "[WINDOWS]") THEN success = MoveWindow(_WindowHandle, x, y, w, h, 1) ELSE success = -1 ' Now that _WindowHandle is inlined, invalid window handle (1400) issue has yet to be reproduced - will have to continue to test
IF success = 0 THEN PRINT "FAILED TO RESIZE - "; GetLastError; " ("; hwnd; ")": CALL WaitKeyS
_TITLE "SCROLL" 'NOTE: Moving title above resize causes resize to fail (without an error???)
'BUG: It would be nice specify the icon here, but... having to require full path or placing it in the qb64 folder is problematic. 
'NOTE: The above boiler plate must be first in execution (top of file).
'BUG:  Also appears to not work as an $INCLUDE; suggesting something might
'      be wrong with the implementation of $INCLUDE.
' **************************
' * BOILER PLATE END
' **************************

DEFINT A-Z

'$INCLUDE: 'PRO.BI'

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
CALL WaitKeyS

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