'********** SHIFT.BAS -  demos the various QuickPak bit shifting commands

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
_TITLE "SHIFT" 'NOTE: Moving title above resize causes resize to fail (without an error???)
'BUG: It would be nice specify the icon here, but... having to require full path or placing it in the qb64 folder is problematic. 
'NOTE: The above boiler plate must be first in execution (top of file).
'BUG:  Also appears to not work as an $INCLUDE; suggesting something might
'      be wrong with the implementation of $INCLUDE.
' **************************
' * BOILER PLATE END
' **************************

DEFINT A-Z

'$INCLUDE: 'PRO.BI'

DECLARE FUNCTION Int2Bin$ (number)      'converts an int to a Binary string
DECLARE FUNCTION Long2Bin$ (number&)    'converts a long to a Binary string
DECLARE SUB ShiftIL (value, numBits)    'shifts an integer NumBits left
DECLARE SUB ShiftIR (value, numBits)    'shifts an integer NumBits right
DECLARE SUB ShiftLL (value&, numBits)   'shifts a long integer NumBits left
DECLARE SUB ShiftLR (value&, numBits)   'shifts a long integer NumBits right

CLS

INPUT "Enter a number ", x$
IF x$ = "" THEN END
INPUT "How many bits? ", numBits
PRINT

longInt& = VAL(x$)
IF longInt& < 32768 AND longInt& > -32769 THEN
  temp = longInt&
  PRINT "Before shifting: "; Int2Bin$(temp)
  ShiftIL temp, numBits
  PRINT "   Shifted left: "; Int2Bin$(temp)
  PRINT
  temp = longInt&
  PRINT "Before shifting: "; Int2Bin$(temp)
  ShiftIR temp, numBits
  PRINT "  Shifted right: "; Int2Bin$(temp)
ELSE
  temp& = longInt&
  PRINT "Before shifting: "; Long2Bin$(temp&)
  ShiftLL temp&, numBits
  PRINT "   Shifted left: "; Long2Bin$(temp&)
  PRINT
  temp& = longInt&
  PRINT "Before shifting: "; Long2Bin$(temp&)
  ShiftLR temp&, numBits
  PRINT "  Shifted right: "; Long2Bin$(temp&)
END IF

FUNCTION Int2Bin$ (number%)     ' converts an integer to a Binary string
  binary$ = STRING$(16, "0")
  FOR x% = 1 TO 16
    IF number% AND 2 ^ (x% - 1) THEN MID$(binary$, 17 - x%) = "1"
  NEXT
  Int2Bin$ = binary$
END FUNCTION

FUNCTION Long2Bin$ (number&)      ' converts a long integer to a Binary string
  binary$ = STRING$(32, "0")
  FOR x% = 1 TO 31
    IF number& AND CSNG(2! ^ (CSNG(x%) - 1)) THEN
      MID$(binary$, 33 - x%) = "1"
    END IF
  NEXT
  IF number& < 0 THEN MID$(binary$, 1, 1) = "1"
  Long2Bin$ = binary$
END FUNCTION

'$INCLUDE: 'PRO.BAS'