' ********** ISortStr.Bas - sorts the lines in a text file using an index
' Copyright (c) 1987 Ethan Winer
' Modifications (c) 2023 Cory Smith

' Unlike conventional sort routines, an indexed sort does not actually
' re-order any of the elements in the array being sorted.  Rather, a
' parallel "index" array is shuffled around such that it serves as a
' table of pointers into the original array.  That is, the first index
' array element ends up holding the element number for the first array's
' element in sorted order and so forth.  You can see this in context
' below where the string array is printed out.
'
' Notice that at some point before the sorting begins, the index array
' must be initialized just to get things started.  For example:
'
'     A(0) = 0
'     A(1) = 1
'     A(2) = 2
'     .
'     .
'     A(n) = n
'
' The supplemental routine InitInt is intended to do this.  Though we
' could have had ISortStr do the initializing automatically, it would
' create a problem when attempting to sort the index array a second
' time, perhaps using a different key string array.  (See the QuickPak
' Pro file KEYSORT.BAS for more information on multiple-key sorts.)
'
' ISortStr assumes internally that you are using the zero element of
' the string array.  This means that the first element in the index
' array MUST be zero.  Further, if the string array is NOT being
' sorted starting with element zero, then the difference must be
' added to the index array when sorting is finished.  Even though it
' would have been slightly simpler in this example to have the sort
' begin with string array element zero, it starts with element one
' just to show the way InitInt and AddInt are used.

#INCLUDE ONCE "PRO.BI" ' AddInt, InitInt, ISortStr, ISortStr2

CLS
REM CLEAR , , 1500    ' ISort needs the extra stack space - this program works
                      ' without the Clear command up to a few hundred elements,
                      ' but you will need it when sorting large arrays.

DIM Array(2000) AS STRING  ' allocate a string array for incoming file
DIM A(2000) AS SHORT       ' you MUST dimension this integer array

DIM F AS STRING
DIM R AS STRING
DIM X AS SHORT
DIM Direction AS SHORT
DIM Sensitive AS SHORT

PRINT "File to load and sort: ";
LINE INPUT F

PRINT "Ascending or Descending (A/D)? ";
DO
  R = UCASE$(INKEY$)
LOOP UNTIL LEN(R)
PRINT R
IF R = "D" THEN Direction = 1

PRINT "Case Sensitive or Insensitive (S/I)? ";
DO
  R = UCASE$(INKEY$)
LOOP UNTIL LEN(R)
PRINT R
IF R = "S" THEN Sensitive = 1

OPEN F FOR INPUT AS #1                   ' open the specified file to sort
  WHILE (NOT EOF(1)) AND (X <= 2000)     ' read until the end of the file or
    X = X + 1                            '   2000 lines, whichever comes first
    LINE INPUT #1, Array(X)
  WEND
CLOSE

VAR Start = 1                            ' specify start of the range to sort
VAR Size = X                             ' and the number of elements to include
	    
REM PLAY "L32O3AF"
PRINT "Press any key to begin sorting ";
LOCATE , , 1
WaitKey                                  ' pause for keypress

PRINT : PRINT
VAR T = TIMER                            ' so we can time the sort

InitInt @A(Start), 0, Size               ' initialize the array (base zero)
IF Sensitive THEN
  ISortStr VARPTR(Array(Start)), @A(Start), Size, Direction
ELSE
  ISortStr2 VARPTR(Array(Start)), @A(Start), Size, Direction
END IF
AddInt @A(Start), 1, Size                ' add one to every element (needed
					                               '  unless starting at element zero)

VAR Y = TIMER - T
PRINT USING "Time: ##.## Seconds"; Y;
PRINT
REM PLAY "AF"

PRINT "Press any key to display sorted array ";
WaitKey

LOCATE 25, 1, 0
PRINT "Press any key to pause";
LOCATE 8, 1

FOR X = 1 TO Size
  PRINT Array(A(X))                      ' here's the indexing part
  IF INKEY$ <> "" THEN
    WaitKey                              ' pause on any keypress
  END IF
NEXT
