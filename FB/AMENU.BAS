' **** AMENU.BAS - demonstrates AMenu                        (4/1/1989)
' Copyright (c) 1989 Chris May
' Modifications (c) 2022 Cory Smith

#INCLUDE "PRO.BI"
     
Var n = 450                     'number of elements in array
Var start = 31                  'element at which to start

REDIM a(n) As String

CLS

FOR i As Short = 1 TO n
  a(i) = "Element" + STR$(i)
  a(i) = a(i) + SPACE$(13 - LEN(a(i)))
 NEXT

PRINT "You are welcome to scan all 450 elements ....."
Dim count As Short = n
Dim scanCode As Short
AMenu VARPTR(a(1)), start, count, scanCode, 112, 23, 20, 5, 2, 5, 5
'                                            ^    ^   ^  ^  ^  ^  ^
'                                            |    |   |  |  |  |  |
'  File Color -------------------------------     |   |  |  |  |  |
'  HiLite Color ----------------------------------    |  |  |  |  |
'  Number of Rows in table ---------------------------   |  |  |  |
'  Number of Columns in table ---------------------------   |  |  |
'  Number of spaces between columns ------------------------   |  |
'  Upper left row of display        ---------------------------   |
'  Upper left column of display     ------------------------------

WaitKey

LOCATE 1, 1
IF scanCode > 0 THEN PRINT "Control Key #"; scanCode; "was pressed";
IF scanCode < 0 THEN PRINT "Keyboard Scan Code #"; -scanCode; "was pressed";
PRINT SPACE$(50)
PRINT "This demonstrates re-entry into the program    "
PRINT "We will change  "; a(count); " to  ";
a(count) = "Done" + STR$(count)
a(count) = a(count) + SPACE$(13 - LEN(a(count)))
PRINT a(count)
LOCATE 25, 1: PRINT "Press any key to continue";
WHILE INKEY$ = "": WEND
scanCode = 3
count = n
AMenu VARPTR(a(1)), start, count, scanCode, 112, 23, 20, 5, 2, 5, 5

CLS
PRINT "Now we will demonstrate starting from any point within the array"
PRINT "Lets say   Element 345"
LOCATE 25, 1: PRINT "Press any key to continue";
WHILE INKEY$ = "": WEND
start = 345
count = n
AMenu VARPTR(a(1)), start, count, scanCode, 112, 23, 20, 5, 2, 5, 5
