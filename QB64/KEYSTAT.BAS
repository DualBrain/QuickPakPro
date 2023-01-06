' ********** KEYSTAT.BAS - demonstrates all of the QuickPak Pro keyboard stuff

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
_TITLE "KEYSTAT" 'NOTE: Moving title above resize causes resize to fail (without an error???)
'BUG: It would be nice specify the icon here, but... having to require full path or placing it in the qb64 folder is problematic. 
'NOTE: The above boiler plate must be first in execution (top of file).
'BUG:  Also appears to not work as an $INCLUDE; suggesting something might
'      be wrong with the implementation of $INCLUDE.
' **************************
' * BOILER PLATE END
' **************************

DEFINT A-Z

'$INCLUDE: 'PRO.BI'

DECLARE FUNCTION CapsLock% ()
DECLARE FUNCTION NumLock% ()
DECLARE FUNCTION ScrlLock% ()
DECLARE FUNCTION ShiftKey% ()
DECLARE FUNCTION CtrlKey% ()
DECLARE FUNCTION AltKey% ()
DECLARE SUB QPrint0 (x$, colr)

CLS
PRINT "Press any of the shift and lock keys, or Escape to end"
LOCATE 25, 1, 0

DO

  LOCATE , 1
  colr = 0
  IF CapsLock THEN colr = 112
  QPrint0 " CAP ", colr

  LOCATE , 10
  colr = 0
  IF NumLock THEN colr = 112
  QPrint0 " NUM ", colr

  LOCATE , 20
  colr = 0
  IF ScrlLock THEN colr = 112
  QPrint0 " SCRL ", colr

  LOCATE , 30
  colr = 0
  IF ShiftKey THEN colr = 112
  QPrint0 " SHIFT ", colr

  LOCATE , 40
  colr = 0
  IF CtrlKey THEN colr = 112
  QPrint0 " CTRL ", colr

  LOCATE , 50
  colr = 0
  IF AltKey THEN colr = 112
  QPrint0 " ALT ", colr

LOOP UNTIL INKEY$ = CHR$(27)

COLOR 7, 0

'$INCLUDE: 'PRO.BAS'