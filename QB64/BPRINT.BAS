' ********** BPRINT.BAS - prints BASIC strings through DOS

' Copyright (C) 1988
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
_TITLE "BPRINT" 'NOTE: Moving title above resize causes resize to fail (without an error???)
'BUG: It would be nice specify the icon here, but... having to require full path or placing it in the qb64 folder is problematic. 
'NOTE: The above boiler plate must be first in execution (top of file).
'BUG:  Also appears to not work as an $INCLUDE; suggesting something might
'      be wrong with the implementation of $INCLUDE.
' **************************
' * BOILER PLATE END
' **************************

DEFINT A-Z

'$INCLUDE: 'PRO.BI'

DECLARE SUB BPrint (x$)

DIM fixLen AS STRING * 30

fixLen$ = "This string has a fixed length..."   ' dots show how assigning to a
                                                ' fixed length string truncates
normal$ = "This is a normal BASIC string"
value! = 143.801

CLS
CALL BPrint(fixLen$ + CHR$(13) + CHR$(10))
CALL BPrint(normal$ + CHR$(13) + CHR$(10))
CALL BPrint("This is a number:" + STR$(value!) + CHR$(13) + CHR$(10))
LOCATE 20, 20
CALL BPrint("This shows that BPrint honors the current cursor location")

'$INCLUDE: 'PRO.BAS'