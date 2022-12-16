' ********* READFILE.BAS - demos reading a list of file names and sorting them

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
_TITLE "READFILE" 'NOTE: Moving title above resize causes resize to fail (without an error???)
'BUG: It would be nice specify the icon here, but... having to require full path or placing it in the qb64 folder is problematic. 
'NOTE: The above boiler plate must be first in execution (top of file).
'BUG:  Also appears to not work as an $INCLUDE; suggesting something might
'      be wrong with the implementation of $INCLUDE.
' **************************
' * BOILER PLATE END
' **************************

DEFINT A-Z

'$INCLUDE: 'PRO.BI'

DECLARE SUB ReadFile (array$())
DECLARE SUB SortStr (array$(), start, numEls, direction)
DECLARE FUNCTION FCount% (fileSpec$)

CLS

INPUT "Enter a file spec, or press Enter for *.* : ", spec$
IF spec$ = "" THEN spec$ = "*.*"

numFiles = FCount%(spec$)               ' see how many files there are
IF numFiles = 0 THEN                    ' none, end
  PRINT "No matching files found"
  END
END IF

DIM array$(numFiles)                    ' make an array to hold the names
FOR x = 1 TO numFiles                   ' fill each element with 12 spaces
  array$(x) = SPACE$(12)
NEXT
array$(0) = spec$                       ' put the search spec into Array$(0)

ReadFile array$()                       ' read the names into Array$()
SortStr array$(), 1, numFiles, 0        ' sort the array, 0 means "ascending"

FOR x = 1 TO numFiles
  PRINT array$(x)
NEXT

'$INCLUDE: 'PRO.BAS'