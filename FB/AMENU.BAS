' **** AMENU.BAS - demonstrates AMenu                        (4/1/1989)
' Copyright (c) 1989 Chris May
' Modifications (c) 2022 Cory Smith

#INCLUDE "PRO.BI"
     
Dim N As Integer = 450                     'number of elements in array
Dim Start As Integer = 31                  'element at which to start

REDIM A(N) As String

CLS

FOR I As Integer = 1 TO N
  A(I) = "Element" + STR$(I)
  A(I) = A(I) + SPACE$(13 - LEN(A(I)))
 NEXT

PRINT "You are welcome to scan all 450 elements ....."
Dim Count As Integer = N
Dim ScanCode As Integer
AMenu VARPTR(A(1)), Start, Count, ScanCode, 112, 23, 20, 5, 2, 5, 5
'                                            ^    ^   ^  ^  ^  ^  ^
'                                            |    |   |  |  |  |  |
'  File Color -------------------------------     |   |  |  |  |  |
'  HiLite Color ----------------------------------    |  |  |  |  |
'  Number of Rows in table ---------------------------   |  |  |  |
'  Number of Columns in table ---------------------------   |  |  |
'  Number of spaces between columns ------------------------   |  |
'  Upper left row of display        ---------------------------   |
'  Upper left column of display     ------------------------------

LOCATE 1, 1
IF ScanCode > 0 THEN PRINT "Control Key #"; ScanCode; "was pressed";
IF ScanCode < 0 THEN PRINT "Keyboard Scan Code #"; -ScanCode; "was pressed";
PRINT SPACE$(50)
PRINT "This demonstrates re-entry into the program    "
PRINT "We will change  "; A(Count); " to  ";
A(Count) = "Done" + STR$(Count)
A(Count) = A(Count) + SPACE$(13 - LEN(A(Count)))
PRINT A(Count)
LOCATE 25, 1: PRINT "Press any key to continue";
WHILE INKEY$ = "": WEND
ScanCode = 3
Count = N
AMenu VARPTR(A(1)), Start, Count, ScanCode, 112, 23, 20, 5, 2, 5, 5

CLS
PRINT "Now we will demonstrate starting from any point within the array"
PRINT "Lets say   Element 345"
LOCATE 25, 1: PRINT "Press any key to continue";
WHILE INKEY$ = "": WEND
Start = 345
Count = N
AMenu VARPTR(A(1)), Start, Count, ScanCode, 112, 23, 20, 5, 2, 5, 5
