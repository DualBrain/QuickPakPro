' ********** SORTSTR.BAS - loads a text file and sorts the lines

' Copyright (c) 1987 Ethan Winer
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
_TITLE "SORTSTR" 'NOTE: Moving title above resize causes resize to fail (without an error???)
'BUG: It would be nice specify the icon here, but... having to require full path or placing it in the qb64 folder is problematic. 
'NOTE: The above boiler plate must be first in execution (top of file).
'BUG:  Also appears to not work as an $INCLUDE; suggesting something might
'      be wrong with the implementation of $INCLUDE.
' **************************
' * BOILER PLATE END
' **************************

DEFINT A-Z

'$INCLUDE: 'PRO.BI'

DECLARE SUB SortStr (address$(), start, size, direction)
DECLARE SUB SortStr2 (address$(), start, size, direction)
DECLARE FUNCTION LineCount% (fileName$, buffer$)
DECLARE FUNCTION FileSize& (fileName$)

CLS

LOCATE , , 1
PRINT "File to load and sort: ";                ' ask for a file to sort
LINE INPUT fileName$
IF FileSize&(fileName$) > 32768 THEN            ' modified from (FRE("") - 2000) to 32768
  PRINT "Not enough memory to load this file"
  END
END IF

CLS

PRINT "Ascending or Descending? (A/D) ";

DO
  s$ = UCASE$(INKEY$)
LOOP UNTIL s$ = "A" OR s$ = "D"
IF s$ = "A" THEN
   dir = 0
ELSE
   dir = 1
END IF

CLS

PRINT "Case Sensitive or Insensitive? (S/I) ";

DO
  c$ = UCASE$(INKEY$)
LOOP UNTIL c$ = "S" OR c$ = "I"
IF c$ = "S" THEN
  c = 1
ELSE
  c = 0
END IF

lines = LineCount%(fileName$, SPACE$(4096))     ' count the number of lines
DIM a$(lines)                                   ' make an array to hold it

OPEN fileName$ FOR INPUT AS #1                  ' read the file into an array
lines = 0
WHILE NOT EOF(1)
  lines = lines + 1
  LINE INPUT #1, a$(lines)
WEND
CLOSE

start = 1                                       ' specify sorting the whole array
size = lines
PLAY "L32O3AF"

CLS

PRINT "Press any key to begin sorting ";

WHILE INKEY$ = "": WEND                         ' pause for keypress
PRINT "sorting..."
x! = TIMER                                      ' so we can time the sort

IF c THEN
  SortStr a$(), start, size, dir                ' sort ascending
ELSE
  SortStr2 a$(), start, size, dir               ' sort descending
END IF

CLS

PRINT USING "Time: ##.## Seconds"; TIMER - X!;
PLAY "AF"

PRINT " - press any key to display sorted array ";
WHILE INKEY$ = "": WEND

LOCATE 25, 1, 0
PRINT "Press any key to pause";
LOCATE 3, 1

FOR x = 1 TO size
  PRINT LEFT$(a$(x), 79)         ' in case the lines are very long
  IF INKEY$ <> "" THEN
    WHILE INKEY$ = "": WEND      ' pause on keypress
  END IF
NEXT

'$INCLUDE: 'PRO.BAS'