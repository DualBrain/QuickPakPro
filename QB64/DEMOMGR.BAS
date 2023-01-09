' ********** DEMOMGR.BAS - demo for the QuickPak Professional window manager

' Copyright (c) 1988 Ethan Winer
' Modifications (c) 2023 Cory Smith

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
_TITLE "DEMOMGR" 'NOTE: Moving title above resize causes resize to fail (without an error???)
'BUG: It would be nice specify the icon here, but... having to require full path or placing it in the qb64 folder is problematic. 
'NOTE: The above boiler plate must be first in execution (top of file).
'BUG:  Also appears to not work as an $INCLUDE; suggesting something might
'      be wrong with the implementation of $INCLUDE.
' **************************
' * BOILER PLATE END
' **************************

DEFINT A-Z

'$INCLUDE: 'PRO.BI'

DECLARE SUB APrint0 (BYVAL address, numEls, startCol, numChars, colr)
DECLARE SUB WindowMgr (windowNumber, action, ulRow, ulCol, lrRow, lrCol, colr)

DIM test1$(24)                              ' make some test array data
FOR x = 1 TO 24
  test1$(x) = STRING$(80, "0")
NEXT

DIM test2$(8)
FOR x = 1 TO 8
  test2$(x) = STRING$(30, "1")
NEXT

DIM test3$(6)
FOR x = 1 TO 6
  test3$(x) = STRING$(60, "2")
NEXT

DIM test4$(2)
FOR x = 1 TO 2
  test4$(x) = STRING$(15, "3")
NEXT

CLS                                         'display a test pattern
'APrint0 VARPTR(test1$(1)), 24, 1, 80, 7
APrint0 test1$(), 1, 24, 1, 80, 7
LOCATE 25, 1, 1
PRINT "Press a key to access window #1 ";
WHILE INKEY$ = "": WEND

WindowMgr 0, 1, 3, 3, 12, 34, 65            'open next available window
LOCATE 25, 1
PRINT "Press a key to display some stuff ";
WHILE INKEY$ = "": WEND

LOCATE 4, 4                                 'fill window with some text
'APrint0 VARPTR(test2$(1)), 8, 1, 30, 2
APrint0 test2$(), 1, 8, 1, 30, 2
LOCATE 25, 1
PRINT "Press another key to access window #2 ";
WHILE INKEY$ = "": WEND

WindowMgr 0, 1, 7, 5, 14, 66, 89            'open next available window
LOCATE 25, 1
PRINT "Press another key to display some stuff ";
WHILE INKEY$ = "": WEND

LOCATE 8, 6                                 'display some more test text
'APrint0 VARPTR(test3$(1)), 6, 1, 60, 9
APrint0 test3$(), 1, 6, 1, 60, 9
LOCATE 25, 1
PRINT "Press yet another key to access window #3 ";
WHILE INKEY$ = "": WEND

WindowMgr 0, 1, 9, 9, 12, 25, 79            'and so on
LOCATE 25, 1
PRINT "Press yet another key to display some stuff ";
WHILE INKEY$ = "": WEND

LOCATE 10, 10
'APrint0 VARPTR(test4$(1)), 2, 1, 15, 2
APrint0 test4$(), 1, 2, 1, 15, 2
LOCATE 25, 1
PRINT "As you continue to press a key, each window will be closed ";
WHILE INKEY$ = "": WEND

WindowMgr 0, 0, 0, 0, 0, 0, 0               ' close all windows
WHILE INKEY$ = "": WEND                     ' (easy enough, right?)
WindowMgr 0, 0, 0, 0, 0, 0, 0
WHILE INKEY$ = "": WEND
WindowMgr 0, 0, 0, 0, 0, 0, 0

'$INCLUDE: 'WINDOMGR.BAS'
'$INCLUDE: 'PRO.BAS'