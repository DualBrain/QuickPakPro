' ********** SortT.Bas - demonstrates the QuickPak TYPE array sort
' Copyright (c) 1988 Crescent Software
' Modifications (c) 2023 Cory Smith

TYPE Struct FIELD = 1
  Zip AS INTEGER
  Who AS STRING * 1
  Junk AS STRING * 1
END TYPE

#INCLUDE ONCE "PRO.BI" ' SortT

DIM x AS SHORT
DIM badSort AS SHORT

REM CLEAR , , 2000                           ' the sort routines need the extra stack space
CLS

VAR start = 1                            ' start at array element 1
VAR size = 500                           ' the size (in elements) of the array
VAR direction = 0                        ' sort direction - use anything else for descending
VAR sSize = LEN(Struct) ' 4                            ' total size of each TYPE element
VAR mOff = 0                             ' offset into the TYPE for the key element
VAR mSize = -1                           ' size of the key element - coded as follows:
                                         '   -1 = integer
                                         '   -2 = long integer   
                                         '   -3 = single precision
                                         '   -4 = double precision
                                         '   +N = TYPE array/fixed-length string of length N

REDIM array(1 TO size) AS Struct

FOR x = 1 TO size
  array(x).Zip = RND(1) * 32000 - RND(1) * 32000
  array(x).Who = CHR$(x MOD 26 + 65)
  'PRINT array(x).Zip, array(x).Who       ' unREM to see the array being created
NEXT

PRINT "Sorting . . ."

VAR t = TIMER                            ' time the sort
SortT @array(start), size, direction, sSize, mOff, mSize
VAR t1 = TIMER - t

LOCATE 1, 1
PRINT USING "##.## seconds to sort " + STR$(size) + " elements"; t1
PRINT "Press any key to view the sorted data"
WHILE INKEY$ = "": WEND
LOCATE 25
PRINT "Press any key to pause/restart";
VIEW PRINT 2 TO 24                       ' protect the top and bottom lines of the screen

FOR x = 1 TO size
  PRINT array(x).Zip, array(x).Who
  IF LEN(INKEY$) THEN
    WHILE INKEY$ = "": WEND
  END IF
NEXT

FOR x = 2 TO size                        ' this is for testing purposes only
  IF direction = 0 THEN
    IF array(x).Zip < array(x - 1).Zip THEN badSort = badSort + 1
  ELSE
    IF array(X).Zip > array(X - 1).Zip THEN badSort = badSort + 1
  END IF
NEXT
PRINT
PRINT badSort; " elements were sorted incorrectly"