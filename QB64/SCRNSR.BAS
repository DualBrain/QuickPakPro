' ********** ScrnSR.Bas - demonstration for saving/restoring screen

' Copyright (c) 1987 Ethan Winer
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
_TITLE "SCRNSR" 'NOTE: Moving title above resize causes resize to fail (without an error???)
'BUG: It would be nice specify the icon here, but... having to require full path or placing it in the qb64 folder is problematic. 
'NOTE: The above boiler plate must be first in execution (top of file).
'BUG:  Also appears to not work as an $INCLUDE; suggesting something might
'      be wrong with the implementation of $INCLUDE.
' **************************
' * BOILER PLATE END
' **************************

DEFINT A-Z

'$INCLUDE: 'PRO.BI'

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
CALL WaitKeyS

ScrnSave ulRow, ulCol, lrRow, lrCol, array(), page
CLS
LOCATE 25, 1, 1
PRINT "Do it again: ";
CALL WaitKeyS
CLS
ScrnRest ulRow, ulCol, lrRow, lrCol, array(), page

ScrnRest 1, 1, 6, 21, array(), page
ScrnRest 1, 60, 6, 80, array(), page
ScrnRest 19, 1, 24, 21, array(), page
ScrnRest 19, 60, 24, 80, array(), page

'$INCLUDE: 'PRO.BAS'