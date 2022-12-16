'********** MONITOR.BAS - determines the currently active monitor

' Copyright (c) 1989 Crescent Software
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
_TITLE "MONITOR" 'NOTE: Moving title above resize causes resize to fail (without an error???)
'BUG: It would be nice specify the icon here, but... having to require full path or placing it in the qb64 folder is problematic. 
'NOTE: The above boiler plate must be first in execution (top of file).
'BUG:  Also appears to not work as an $INCLUDE; suggesting something might
'      be wrong with the implementation of $INCLUDE.
' **************************
' * BOILER PLATE END
' **************************

DEFINT A-Z

'$INCLUDE: 'PRO.BI'

DECLARE FUNCTION Monitor% ()
DECLARE FUNCTION EGAMem% ()

CLS

m = Monitor%            ' get the monitor type
memory = EGAMem% * 64   ' if it's an EGA, get its memory

PRINT memory

SELECT CASE m

  CASE 1: PRINT "It is a plain old monochrome adapter"
  CASE 2: PRINT "It is a Hercules card"
  CASE 3: PRINT "It is a plain old CGA adapter"

  CASE 4 
    PRINT "It is an EGA card with a monochrome monitor,"
    PRINT "And it has"; memory; "K of memory on board"

  CASE 5
    PRINT "It is an EGA card with a color monitor,"
    PRINT "And it has"; memory; "K of memory on board"

  CASE 6: PRINT "It is a VGA adapter with a monochrome monitor"
  CASE 7: PRINT "It is a VGA adapter with a color monitor"
  CASE 8: PRINT "It is an MCGA adapter with a monochrome monitor"
  CASE 9: PRINT "It is an MCGA adapter with a color monitor"

  CASE 10
    PRINT "It is an EGA emulating a CGA, capable of SCREEN 8,"
    PRINT "And it has"; memory; "K of memory on board"

  CASE 11: PRINT "It is an 8514/A adapter"

  CASE ELSE
    PRINT "I give up -- what the heck kind of video adapter is it?"

END SELECT

'$INCLUDE: 'PRO.BAS'