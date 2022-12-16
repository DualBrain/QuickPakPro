'********** MINMAX.BAS - tests the Min and Max functions

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
_TITLE "MINMAX" 'NOTE: Moving title above resize causes resize to fail (without an error???)
'BUG: It would be nice specify the icon here, but... having to require full path or placing it in the qb64 folder is problematic. 
'NOTE: The above boiler plate must be first in execution (top of file).
'BUG:  Also appears to not work as an $INCLUDE; suggesting something might
'      be wrong with the implementation of $INCLUDE.
' **************************
' * BOILER PLATE END
' **************************

DEFINT A-Z

'$INCLUDE: 'PRO.BI'

DECLARE FUNCTION MaxI% (SEG Element%, NumEls)
DECLARE FUNCTION MinI% (SEG Element%, NumEls)
DECLARE FUNCTION MaxL& (SEG Element&, NumEls)
DECLARE FUNCTION MinL& (SEG Element&, NumEls)
DECLARE FUNCTION MaxS! (SEG Element!, NumEls)
DECLARE FUNCTION MinS! (SEG Element!, NumEls)
DECLARE FUNCTION MaxD# (SEG Element#, NumEls)
DECLARE FUNCTION MinD# (SEG Element#, NumEls)

CLS

REDIM array#(1 TO 10000) ' you must start QuickBASIC with /AH to run this demo

array#(3) = 17                          ' assign some test values
array#(101) = 9000987.45321#
array#(100) = 9000987.452099999#
array#(10000) = -12049875643.0876#

t! = TIMER                              ' time how fast MinD is
smallest# = MinD#(array#(), 1, 10000)
t1! = TIMER

PRINT "The smallest value is "; smallest#
PRINT USING "##.### seconds to scan 80,000 bytes"; t1! - t!

'$INCLUDE: 'PRO.BAS'