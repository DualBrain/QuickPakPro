' ********** ISortT.Bas - demonstrates the QuickPak indexed TYPE array sort
' Copyright (c) 1988 Crescent Software
' Modifications (c) 2023 Cory Smith

TYPE Struct
  Zip AS INTEGER
  Who AS STRING * 1
  Junk AS STRING * 1
END TYPE

#INCLUDE ONCE "PRO.BI" ' InitInt, ISortT

REM CLEAR , , 2000                           ' the sort routines need the extra stack space
CLS

VAR start = 15                           ' start at element 15 as an example of doing that
VAR size = 500                           ' the size (in elements) of the array
VAR lastEl = start + size - 1            ' calculate the actual number of elements
VAR direction = 0                        ' sort direction - use anything else for descending
VAR sSize = LEN(Struct) ' 4                            ' total size of each TYPE element
VAR mOff = 0                             ' offset into the TYPE for the key element
VAR mSize = -1                           ' size of the key element - coded as follows:
                                         '    -1 = integer
                                         '    -2 = long integer
                                         '    -3 = single precision
                                         '    -4 = double precision
                                         '    +N = TYPE array/fixed-length string of length N

REDIM array(start TO lastEl) AS Struct
REDIM index(start TO lastEl) AS SHORT

DIM x AS SHORT
DIM badSort AS SHORT

PRINT "Creating Data . . ."
FOR x = start TO lastEl
  array(x).Zip = RND(1) * 32000 - RND(1) * 32000
  array(x).Who = CHR$(x MOD 26 + 65)
  'PRINT array(x).Zip, array(x).Who       ' unREM to see the array being created
NEXT

LOCATE 1
PRINT "Sorting . . ."

VAR t = TIMER                            ' time the sort
InitInt @index(start), 0, size
ISortT @array(start), @index(start), size, direction, sSize, mOff, mSize
VAR t1 = TIMER - t

LOCATE 1, 1
PRINT USING "##.## seconds to sort " + STR$(size) + " elements"; t1
PRINT "Press any key to view the sorted data"
WHILE INKEY$ = "": WEND
LOCATE 25
PRINT "Press any key to pause/restart";
VIEW PRINT 2 TO 24                       ' protect the top and bottom lines of the screen

FOR x = start TO lastEl
  PRINT array(index(x) + start).Zip, array(index(x) + start).Who
  IF LEN(INKEY$) THEN
    WHILE INKEY$ = "": WEND
  END IF
NEXT

FOR x = start + 1 TO lastEl              ' this is for testing purposes only
  IF direction = 0 THEN
    IF array(index(x) + start).Zip < array(index(x - 1) + start).Zip THEN badSort = badSort + 1
  ELSE
    IF array(index(x) + start).Zip > array(index(x - 1) + start).Zip THEN badSort = badSort + 1
  END IF
NEXT
PRINT
PRINT badSort; " elements were sorted incorrectly"