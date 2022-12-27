' ******** BCOPYT.BAS - demonstrates copying TYPE elements around in memory

' Copyright (c) 1989 Ethan Winer
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
_TITLE "BCOPYT" 'NOTE: Moving title above resize causes resize to fail (without an error???)
'BUG: It would be nice specify the icon here, but... having to require full path or placing it in the qb64 folder is problematic. 
'NOTE: The above boiler plate must be first in execution (top of file).
'BUG:  Also appears to not work as an $INCLUDE; suggesting something might
'      be wrong with the implementation of $INCLUDE.
' **************************
' * BOILER PLATE END
' **************************

DEFINT A-Z

'$INCLUDE: 'PRO.BI'

DECLARE SUB BCopyT (SEG FromEl AS ANY, SEG ToEl AS ANY, ElSize, NumEls)

TYPE Test
  L AS LONG
END TYPE

CLS

REDIM fromArray(1 TO 20000) AS Test
REDIM destArray(1 TO 20000) AS Test

FOR X = 16301 TO 17000          ' this range proves that BCopyT successfully
  fromArray(X).L = X            '   accommodates a segment division
NEXT

' CALL BCopyT(FromArray(16301), DestArray(16301), -2, 700)
' The above line has been converted to the following three lines. 
DIM src AS _MEM: DIM dest AS _MEM: src = _MEM(fromArray()): dest = _MEM(destArray())
CALL BCopyT(src, 16301, dest, 16301, -2, 700)
_MEMFREE dest: _MEMFREE src

FOR x = 16300 TO 17001          ' ***** elements 16300 and 17001 SHOULD fail
  IF destArray(X).L <> x THEN
    PRINT "DestArray"; x; "="; destArray(x).L
    CALL Chime(9)
  END IF
NEXT

'$INCLUDE: 'PRO.BAS'