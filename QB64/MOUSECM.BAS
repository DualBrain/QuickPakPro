' **** MOUSECM.BAS - demonstrates Chris May's mouse routines (8/1/1989)

' Copyright (c) 1989 Chris May
' QuickBasic must be started with the /ah option for this demo
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
_TITLE "MOUSECM" 'NOTE: Moving title above resize causes resize to fail (without an error???)
'BUG: It would be nice specify the icon here, but... having to require full path or placing it in the qb64 folder is problematic. 
'NOTE: The above boiler plate must be first in execution (top of file).
'BUG:  Also appears to not work as an $INCLUDE; suggesting something might
'      be wrong with the implementation of $INCLUDE.
' **************************
' * BOILER PLATE END
' **************************

DEFINT A-Z

'$INCLUDE: 'PRO.BI'

DECLARE SUB MAMenuT (SEG ArrayElement AS FLen, Selection, Start, ElSize, Count, ScanCode, FileColr, HiLiteColr, Rows, Columns, Spacing, Row, Column)
DECLARE SUB MAmenu (BYVAL Address, Selection, Start, Count, ExitCode, FileColr, HiLiteColr, Rows, Columns, Spacing, Row, Column)
DECLARE SUB MEditor (Edit$, Length, ScanCode, NumOnly, CapsOn, NormColor, EditColor, Row, Column, CurCol)
DECLARE SUB MMenuVert (BYVAL Address, Selection, Start, ScanCode, ElemClr, HiLite, NumRow, Row, Column)
DECLARE FUNCTION MGetKey% (Row, Col)
DECLARE FUNCTION WaitKey% ()

CALL InitMouse(there)
CLS
IF NOT There THEN PRINT "Mouse not present but will continue anyway"

' --------------------------------------- MEDITOR
PRINT "MEDITOR DEMO"
edit$ = "Try editing this string         "
num.Only = 0
caps.On = 0
normColor = 7
editColor = 23
row = 10
col = 15
curCol = 10
CALL ShowCursor
MEditor edit$, aLen, scanCode, num.Only, caps.On, normColor, editColor, row, col, curCol
CALL HideCursor
LOCATE 1, 1
PRINT "ScanCode = "; scanCode, "Edit$ = "; edit$
PRINT "Row = "; row, , "Col = "; col
PRINT "Cursor column = "; curCol, "String length = "; aLen
LOCATE 25, 1: PRINT "Press any key to continue";
CALL ShowCursor
press = MGetKey(r, c)
CALL HideCursor

' --------------------------------------- MGETKEY
CLS
PRINT "This is a demo of MGETKEY - Press any mouse button or keyboard key"
CALL ShowCursor
scanCode = MGetKey(row, col)
CALL HideCursor
IF scanCode = 1000 THEN PRINT "Left mouse button was pressed"
IF scanCode = 1001 THEN PRINT "Right mouse button was pressed"
IF scanCode = 1002 THEN PRINT "Middle mouse button was pressed"
PRINT "ScanCode = "; scanCode
PRINT "Row = "; row, "Col = "; col
LOCATE 25, 1: PRINT "Press any key to continue";
CALL ShowCursor
press = MGetKey(r, c)
CALL HideCursor

' --------------------------------------- MAMENU
CLS
n = 450                                  ' number of elements in array
start = 1                                ' element at which to start

REDIM a$(n)

FOR i = 1 TO n
  a$(i) = "Element" + STR$(i)
  a$(i) = a$(i) + SPACE$(13 - LEN(a$(i)))
NEXT i

length = LEN(a$(1))

PRINT "MAMENU DEMO :-  Select a file using the mouse ....."

row = 5                                   ' Upper left row of display
col = 5                                   ' Upper left column of display
selection = 146
start = 125

CALL ShowCursor
MAmenu a$(), 1, selection, start, n, scanCode, 112, 23, 20, 5, 2, row, col
CALL HideCursor
'                                               ^    ^   ^  ^  ^
'                                               |    |   |  |  |
'               File Color ---------------------     |   |  |  |
'               HiLite Color ------------------------    |  |  |
'               Number of Rows in table -----------------   |  |
'               Number of Columns in table -----------------   |
'               Number of spaces between columns --------------

PRINT "Selection = "; selection, "ScanCode = "; scanCode
PRINT "Row = "; row, , "Col = "; col
LOCATE 25, 1: PRINT "Press any key to continue";
CALL ShowCursor
press = MGetKey(r, c)
CALL HideCursor

' --------------------------------------- MAMENUT
CLS
n = 6666                                 ' number of elements in array
start = 1                                ' first element in table
selection = 1                            ' element on which to put cursor

REDIM b(n) AS FLen

PRINT "Assembling a fixed length string array with 6,666 elements, each of"
PRINT "which is 13 bytes long. That's a total of 86,658 bytes!  Please wait..."

FOR i = 1 TO n
  b(i).S = "Element" + STR$(i)
NEXT i

CLS
row = 5
col = 5
PRINT "MAMENUT DEMO :-  Select a file using the mouse ....."
WHILE INKEY$ <> "": WEND
CALL ShowCursor
DIM ttt$(LBOUND(b) TO UBOUND(b))
FOR index% = LBOUND(b) TO UBOUND(b)
   ttt$(index%) = b(index%).S
NEXT
count% = n
'MAMenuT B(), 1, Selection, Start, 13, N, ScanCode, 112, 23, 20, 5, 2, Row, Col
MAMenu ttt$(), 1, selection, start, 13, scanCode, 112, 23, 20, 5, 2, row, col
CALL HideCursor
'                                                   ^   ^   ^  ^  ^
'                                                   |   |   |  |  |
' File Color ---------------------------------------    |   |  |  |
' HiLite Color -----------------------------------------    |  |  |
' Number of Rows in table ----------------------------------   |  |
' Number of Columns in table ----------------------------------   |
' Number of spaces between columns -------------------------------

PRINT "Selection = "; selection, "ScanCode = "; scanCode
PRINT "Row = "; row, , "Col = "; col

LOCATE 25, 1: PRINT "Press any key to continue";
'press = WaitKey
press = MGetKey(r, c)

' --------------------------------------- MMENUV
CLS
PRINT "This demonstrates a vertical menuing program"

row = 7
col = 13
numRow = 15
scanCode = 50
selection = 1
start = 1
normClr = 112
hiLite = 23
CALL ShowCursor
MMenuVert a$(), 1, selection, start, scanCode, normClr, hiLite, numRow, row, col
CALL HideCursor
LOCATE 2, 1
PRINT "ScanCode = "; scanCode
PRINT "Selection = "; selection, "Start = "; start
PRINT "Row = "; row, , "Col = "; col

'$INCLUDE: 'PRO.BAS'