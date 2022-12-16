' ********* SEARCH.BAS - demonstrates searching any type of array FAST!

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
_TITLE "SEARCH" 'NOTE: Moving title above resize causes resize to fail (without an error???)
'BUG: It would be nice specify the icon here, but... having to require full path or placing it in the qb64 folder is problematic. 
'NOTE: The above boiler plate must be first in execution (top of file).
'BUG:  Also appears to not work as an $INCLUDE; suggesting something might
'      be wrong with the implementation of $INCLUDE.
' **************************
' * BOILER PLATE END
' **************************

DEFINT A-Z

'$INCLUDE: 'PRO.BI'

DECLARE SUB Search (SEG StartEl AS ANY, NumEls, Match AS ANY, Found, Direction, MatchCode, VarType)

CLS

REDIM array#(10000)     ' REDIM makes it a $Dynamic (far) array
totalEls = 10001        ' don't forget element zero

match# = 1234           ' value to find
array#(9999) = match#   ' put it near the end of the array
startEl = 10            ' start looking near the beginning of the array
direction = 0           ' 0 means forward, anything else means backward
matchCode = 1           ' 0 = exact, 1 = greater or equal, -1 = less or equal
varType = -4            ' -1 = integer, -2 = long int, -3 = Sgl. Prec., -4 = DP

IF direction = 0 THEN          ' calculate how many elements to search
  numEls = totalEls - startEl  '   based on the direction
ELSE
  numEls = startEl + 1         ' this assumes the array starts at zero
END IF                         '   adjust if you start at 1 (or anything else)

x! = TIMER                     ' to time the search
SearchD array#(), startEl, numEls, match#, found, direction, matchCode, varType
x1! = TIMER

IF found = -1 THEN             ' Search returns -1 if it didn't find a match
  PRINT "Not found"
ELSE
  IF direction = 0 THEN        ' we need to know the direction, since SearchI
    found = startEl + found    '   simply returns how many elements it
  ELSE                         '   examined, not the actual element number
    found = startEl - found    '   it found the Match at.
  END IF
  PRINT "The value"; match#; "was found at element number"; found
END IF

PRINT
PRINT USING "Search took #.## seconds to scan" + STR$(CSNG(numEls) * 8) + " bytes"; x1! - x!

'$INCLUDE: 'PRO.BAS'