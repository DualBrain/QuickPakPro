' ********** MPREST.BAS - demonstration for MPRest.Asm

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
_TITLE "MPREST" 'NOTE: Moving title above resize causes resize to fail (without an error???)
'BUG: It would be nice specify the icon here, but... having to require full path or placing it in the qb64 folder is problematic. 
'NOTE: The above boiler plate must be first in execution (top of file).
'BUG:  Also appears to not work as an $INCLUDE; suggesting something might
'      be wrong with the implementation of $INCLUDE.
' **************************
' * BOILER PLATE END
' **************************

DEFINT A-Z

'$INCLUDE: 'PRO.BI'

DECLARE SUB MScrnSave (ULRow, ULCol, LRRow, LRCol, SEG Addr)
DECLARE SUB MScrnRest (ULRow, ULCol, LRRow, LRCol, SEG Addr)
DECLARE SUB MPRestore (ULRow, ULCol, LRRow, LRCol, Original, SEG Addr)
DECLARE SUB PaintBox (ulRow%, ulCol%, lrRow%, lrCol%, colr%, page%)

ulRow = 10: ulCol = 1: lrRow = 20: lrCol = 80  ' corners of saved window
page = -1
wide = 80

REDIM array(2000)

WIDTH wide
SCREEN 0, 0, 0, 0
CLS
COLOR 2

FOR x = 1 TO 24
  PRINT STRING$(wide, x + 96);          ' display test pattern
NEXT

' Added the following to verify that the correct portion is 
' being restored using MPRestore; remarked out to retain
' original sample behavior.
'CALL PaintBox (13, 71, 18, 80, 75, -1)
'CALL PaintBox (14, 72, 17, 79, 25, -1)

COLOR 7
LOCATE 25, 1, 1
PRINT "Press a key: ";
WHILE INKEY$ = "": WEND

MScrnSave ulRow, ulCol, lrRow, lrCol, array()
CLS
LOCATE 25, 1, 1
PRINT "Do it again: ";
WHILE INKEY$ = "": WEND
CLS
MScrnRest ulRow, ulCol, lrRow, lrCol, array()
MPRestore 2, 3, 7, 12, 80, array(), 310

'$INCLUDE: 'PRO.BAS'