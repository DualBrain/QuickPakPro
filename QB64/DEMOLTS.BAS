' ********** DEMOLTS.BAS - demo of the Lotus(tm) style menu subprograms

' Copyright (c) 1988 Ethan Winer
' Modifications (c) 2023 Cory Smith

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
_TITLE "DEMOLTS" 'NOTE: Moving title above resize causes resize to fail (without an error???)
'BUG: It would be nice specify the icon here, but... having to require full path or placing it in the qb64 folder is problematic. 
'NOTE: The above boiler plate must be first in execution (top of file).
'BUG:  Also appears to not work as an $INCLUDE; suggesting something might
'      be wrong with the implementation of $INCLUDE.
' **************************
' * BOILER PLATE END
' **************************

DEFINT A-Z

'$INCLUDE: 'PRO.BI'

DECLARE SUB LtsMenu (item$(), choice, colr)
DECLARE SUB Lts2Menu (item$(), prompt$(), choice, colr)
DECLARE SUB QPrint (x$, colr, page)

'----- show how Lts2Menu works

REDIM choice$(10), prompt$(10)
FOR x = 1 TO 10
  READ choice$(x)
  READ prompt$(x)
NEXT

DATA Worksheet
DATA "Global, Insert, Delete, Column, Erase, Titles, Window, Status, Page"
DATA Range
DATA "Format, Label, Erase, Name, Justify, Protect, Input, Value, Transpose"
DATA Copy
DATA "Copy a cell or range of cells"
DATA Move
DATA "Move a cell or range of cells"
DATA File
DATA "Retrieve, Save, Combine, Xtract, Erase, List, Import, Directory"
DATA Print
DATA Output a range to the printer or a print file
DATA Graph
DATA Create a graph
DATA Data
DATA "Fill, Table, Sort, Query, Distribution, Matrix, Regression, Parse"
DATA System
DATA "Invoke the DOS Command Interpreter"
DATA Quit
DATA "End 1-2-3 session (Have you saved your work?)"

CLS
LOCATE 1, 1: CALL QPrint(STRING$(80, CHR$(205)), 3, -1)   ' frame choices - optional
LOCATE 4, 1: CALL QPrint(STRING$(80, CHR$(205)), 3, -1)
LOCATE 20, 1: PRINT "Use the arrow keys or the first letter of a choice."
LOCATE 21, 1: PRINT "Then press Enter to make a selection, or press Escape to cancel."
LOCATE 2, 1: CALL Lts2Menu(choice$(), prompt$(), choice, 15)

CLS
LOCATE 23, 1: PRINT "Choice number"; choice; "was selected";
IF choice = 0 THEN PRINT " - Escape was pressed";
LOCATE 25, 1: PRINT "Press a key to see the next demonstration ";
CALL WaitKeyS

'----- now show the regular Lotus menu

REDIM choice$(200)      ' use 200 to show how LtsMenu ignores the blank ones
FOR x = 1 TO 20         '   at the end of the array
  READ choice$(x)
NEXT

DATA "Choice 1",  "This is Choice 2",  "Ch 3",  "C4",  "And Here's Choice 5"
DATA "Choice 6 is Nice",  "Number 7",  "Here's Choice 8",  "Big Number Nine"
DATA "Choice 10", "Choice 11", "Choice 12", "Choice 13", "Choice 14"
DATA "Choice 15", "Choice 16", "Choice 17", "Choice 18", "Choice 19"
DATA "Choice 20"

CLS
LOCATE 1, 1: QPrint STRING$(80, CHR$(205)), 2, -1     ' frame the choices - optional
LOCATE 3, 1: QPrint STRING$(80, CHR$(205)), 2, -1
LOCATE 20, 1: PRINT "Use the arrow keys or the first letter of a choice."
LOCATE 21, 1: PRINT "Then press Enter to select it, or press Escape to cancel."

LOCATE 2, 1
CALL LtsMenu(choice$(), choice, 10)
CLS
LOCATE 23, 1: PRINT "Choice number"; choice; "was selected";
IF choice = 0 THEN PRINT " - Escape was pressed";

'$INCLUDE: 'LTSMENU.BAS'
'$INCLUDE: 'LTS2MENU.BAS'
'$INCLUDE: 'PRO.BAS'