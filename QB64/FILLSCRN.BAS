' ********** FILLSCRN.BAS

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
_TITLE "FILLSCRN" 'NOTE: Moving title above resize causes resize to fail (without an error???)
'BUG: It would be nice specify the icon here, but... having to require full path or placing it in the qb64 folder is problematic. 
'NOTE: The above boiler plate must be first in execution (top of file).
'BUG:  Also appears to not work as an $INCLUDE; suggesting something might
'      be wrong with the implementation of $INCLUDE.
' **************************
' * BOILER PLATE END
' **************************

DEFINT A-Z

'$INCLUDE: 'PRO.BI'

DECLARE SUB FillScrn (ULRow, ULCol, LRRow, LRCol, Colr, Char, Page)
DECLARE SUB Pause (Ticks)
DECLARE FUNCTION Rand% (Hi, Lo)

CLS
LOCATE 25
PRINT "Press a key to stop the madness";

DO
  ulRow = Rand%(1, 24)                ' pick a random number between 1 and 24
  ulCol = Rand%(1, 80)                ' use 1 to 80 for the columns
  lrRow = Rand%(1, 24)
  lrCol = Rand%(1, 80)
  IF ulCol > lrCol THEN SWAP ulCol, lrCol     ' force ULCol less than LRCol
  IF ulRow > lrRow THEN SWAP ulRow, lrRow     ' ditto for the rows
  colr = Rand%(1, 127)                        ' make a random color
  char = Rand%(1, 254)                        ' and a random character
  page = -1                                   ' use the default page
  FillScrn ulRow, ulCol, lrRow, lrCol, colr, char, page
  Pause 1
LOOP UNTIL LEN(INKEY$)

FUNCTION Rand% (lo, hi) STATIC
  Rand% = RND * (hi - lo) + lo
END FUNCTION

'$INCLUDE: 'PRO.BAS'