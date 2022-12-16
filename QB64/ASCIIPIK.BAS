' ********** ASCIIPIK.BAS - demos ASCIIPick

' Copyright (c) 1988 Crescent Software
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
_TITLE "ASCIIPIK" 'NOTE: Moving title above resize causes resize to fail (without an error???)
'BUG: It would be nice specify the icon here, but... having to require full path or placing it in the qb64 folder is problematic. 
'NOTE: The above boiler plate must be first in execution (top of file).
'BUG:  Also appears to not work as an $INCLUDE; suggesting something might
'      be wrong with the implementation of $INCLUDE.
' **************************
' * BOILER PLATE END
' **************************

DEFINT A-Z

'BUG: QB64 requires a full path, relative path doesn't work???
'BUG: Shouldn't all meta-commands work with an apostrophe?
'$EXEICON = 'c:\github\quickpakpro\icon.ico'

'$INCLUDE: 'PRO.BI'

CLS
CALL InitMouse(x)
CALL TextCursor(112, 0)
CALL ShowCursor

x = 65                  ' start by highlighting "A"
normColr = 2            ' use a green color
hiColor = 112 + 128     ' use flashing inverse for the selected character
LOCATE 2, 3

' ----- going in, if exitCode = -1, then just display the chart and return
CALL MASCIIPick(x, normColr, hiColor, exitCode)
' ----- coming out, exitCode = 0 if Enter, or 2 if Escape (Escape also ignores)

LOCATE 21, 1
PRINT "You picked character"; x
IF exitCode = 2 THEN PRINT "You pressed Escape";

'$INCLUDE: 'PRO.BAS'