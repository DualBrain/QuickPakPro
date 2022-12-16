' **** AMENU.BAS - demonstrates AMenu (4/1/1989)

' Copyright (c) 1989 Chris May
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
_TITLE "AMENU" 'NOTE: Moving title above resize causes resize to fail (without an error???)
'BUG: It would be nice specify the icon here, but... having to require full path or placing it in the qb64 folder is problematic. 
'NOTE: The above boiler plate must be first in execution (top of file).
'BUG:  Also appears to not work as an $INCLUDE; suggesting something might
'      be wrong with the implementation of $INCLUDE.
' **************************
' * BOILER PLATE END
' **************************

DEFINT A-Z

'$INCLUDE: 'PRO.BI'

DECLARE SUB AMenu (array$(), start, startItem, count, scanCode, fileColr, hiLiteColr, rows, columns, spacing, row, column)
       
n = 450                     ' number of elements in array
startItem = 31              ' element at which to start

REDIM a$(n)

CLS

FOR i = 1 TO n
  a$(i) = "Element" + STR$(i)
  a$(i) = a$(i) + SPACE$(13 - LEN(a$(i)))
NEXT i

PRINT "You are welcome to scan all 450 elements ....."
count = n
CALL AMenu (a$(), 1, startItem, count, scanCode, 112, 23, 20, 5, 2, 5, 5)
'                                                 ^    ^   ^  ^  ^  ^  ^
'                                                 |    |   |  |  |  |  |
'  File Color ------------------------------------     |   |  |  |  |  |
'  HiLite Color ---------------------------------------    |  |  |  |  |
'  Number of Rows in table --------------------------------   |  |  |  |
'  Number of Columns in table --------------------------------   |  |  |
'  Number of spaces between columns -----------------------------   |  |
'  Upper left row of display        --------------------------------   |
'  Upper left column of display     -----------------------------------

LOCATE 1, 1
IF scanCode > 0 THEN PRINT "Control Key #"; scanCode; "was pressed";
IF scanCode < 0 THEN PRINT "Keyboard Scan Code #"; -scanCode; "was pressed";
PRINT SPACE$(50)
PRINT "This demonstrates re-entry into the program    "
PRINT "We will change  "; a$(count); " to  ";
a$(count) = "Done" + STR$(count)
a$(count) = a$(count) + SPACE$(13 - LEN(a$(count)))
PRINT a$(count)
LOCATE 25, 1: PRINT "Press any key to continue";
WHILE INKEY$ = "": WEND
scanCode = 3
count = N
CALL AMenu (a$(), 1, startItem, count, scanCode, 112, 23, 20, 5, 2, 5, 5)

CLS
PRINT "Now we will demonstrate starting from any point within the array"
PRINT "Lets say   Element 345"
LOCATE 25, 1: PRINT "Press any key to continue";
WHILE INKEY$ = "": WEND
startItem = 345
count = n
CALL AMenu (a$(), 1, startItem, count, scanCode, 112, 23, 20, 5, 2, 5, 5)

'$INCLUDE: 'PRO.BAS'