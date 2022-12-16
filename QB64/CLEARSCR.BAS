' ********** ClEARSCR.BAS - clears a portion of the display screen

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
_TITLE "CLEARSCR" 'NOTE: Moving title above resize causes resize to fail (without an error???)
'BUG: It would be nice specify the icon here, but... having to require full path or placing it in the qb64 folder is problematic. 
'NOTE: The above boiler plate must be first in execution (top of file).
'BUG:  Also appears to not work as an $INCLUDE; suggesting something might
'      be wrong with the implementation of $INCLUDE.
' **************************
' * BOILER PLATE END
' **************************

DEFINT A-Z

'$INCLUDE: 'PRO.BI'

DECLARE SUB ClearScr (ulRow, ulCol, lrRow, lrCol, colr, page)

'WIDTH 80, 43               'for testing
'SCREEN 0, 0, 2, 2

CLS
Colr = 1 * 16               'clear to blue background (underlined if mono)
COLOR 2                     'print test pattern in green

ulRow = 10                  'portion of screen to clear
ulCol = 20
lrRow = 18
lrCol = 60
page = -1                   'do it on the current display page

FOR x = 1 TO 24
  PRINT STRING$(80, x + 96);          'display test pattern
NEXT

LOCATE 25, 1, 1
PRINT "Press a key to see the show";
WHILE INKEY$ = "": WEND

CALL ClearScr(ulRow, ulCol, lrRow, lrCol, colr, page)

'$INCLUDE: 'PRO.BAS'