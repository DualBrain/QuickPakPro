' ********* COMPARE.BAS - tests the assembly language Compare routines

' Modifications (c) 2022 Cory Smith

' This chart provides a quick reference to the various "encoded" colors
' that are used with QPrint, APrint, and the other QuickPak video routines.
' To get a hard copy printout, press Shift-PrtSc once it is on your screen.

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
_TITLE "COMPARE" 'NOTE: Moving title above resize causes resize to fail (without an error???)
'BUG: It would be nice specify the icon here, but... having to require full path or placing it in the qb64 folder is problematic. 
'NOTE: The above boiler plate must be first in execution (top of file).
'BUG:  Also appears to not work as an $INCLUDE; suggesting something might
'      be wrong with the implementation of $INCLUDE.
' **************************
' * BOILER PLATE END
' **************************

DEFINT A-Z

'$INCLUDE: 'PRO.BI'

DECLARE FUNCTION Compare% (seg1, adr1, seg2, adr2, numBytes)
DECLARE FUNCTION CompareT% (SEG type1 AS ANY, SEG type2 AS ANY, numBytes)

TYPE Test
  S AS SINGLE
  T AS STRING * 20
END TYPE

CLS

x# = 1.23456789012345#
y# = x# - .000000001#   'rem out the " - .000000001#" to make them the same
varType = -4            'code for double precision (same code as in Sorts)

PRINT "Comparing the two double precision values ... ";
DIM v1 AS _MEM: DIM v2 AS _MEM: v1 = _MEM(x#): v2 = _MEM(y#)
IF Compare%(v1, v2, varType) THEN
'IF Compare%(VARSEG(x#), VARPTR(x#), VARSEG(y#), VARPTR(y#), varType) THEN
  PRINT "They are the same!"
ELSE
  PRINT "Sorry, they're different"
END IF
_MEMFREE v1: _MEMFREE v2

DIM type1 AS Test
DIM type2 AS Test

type1.S = 3.4
type1.T = "Hi Mom"
type2.S = 3.4           'change one of these to test
type2.T = "Hi Mom"

PRINT
PRINT "Comparing the two TYPE variables ... ";
DIM t1 AS _MEM: DIM t2 AS _MEM: t1 = _MEM(type1): t2 = _MEM(type2)
IF CompareT%(t1, t2, LEN(type1)) THEN
'IF CompareT%(type1, type2, LEN(type1)) THEN
  PRINT "They are the same!"
ELSE
  PRINT "Sorry, they're different"
END IF
_MEMFREE t1: _MEMFREE t2

'$INCLUDE: 'PRO.BAS'