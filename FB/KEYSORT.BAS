' ********** KEYSORT.BAS - tests the assembler multi-key TYPE array sort
' Copyright(c) 1989 Ethan Winer
' Modifications (c) 2023 Cory Smith

' FB Notes:
'  - https://www.freebasic.net/wiki/TutIntroTypeDef
'  - https://freebasic.net/wiki/KeyPgField
'  - https://www.freebasic.net/wiki/DevStructLayout
'  - https://www.freebasic.net/wiki/KeyPgOffsetof

#INCLUDE ONCE "PRO.BI" ' KeySort, Pause, WaitKey

TYPE Test FIELD = 1                                ' define the TYPE structure for use in this demo
  I AS SHORT   ' 2
  L AS LONG    ' 4 
  S AS SINGLE  ' 4
  D AS DOUBLE  ' 8
  X AS STRING * 20 ' + 1 (see FB documentation)
END TYPE

DIM x AS SHORT
DIM y AS SHORT
DIM last AS STRING
DIM lastI AS SHORT

REM CLEAR , , 4000                           ' reserve sufficient stack space for very large arrays
CLS                                      '  (not really needed in this demo of only 200)

VAR numEls = 200                         ' number of elements to create in the test array
LOCATE , , 0                             ' turn off the cursor and display a message
PRINT "Creating"; numEls; "elements - please stand by . . ."

DIM array(1 TO numEls) AS Test           ' dim the array
FOR x = 1 TO numEls                      ' create some random data to sort
  array(x).I = RND(1) * 2 + 1            ' limit the integer range to 1 - 3
  array(x).D = RND(1) * 3200000 - RND(1) * 3200000
  array(x).X = CHR$(RND(1) * 25 + 65) + STRING$(19, ".")
NEXT

VAR numberOfKeys = 3                     ' the total number of sort keys
DIM table(1 TO numberOfKeys, 1 tO 3) AS SHORT ' create a table of sort keys
'
' Table is a 2 dimensional table of sorting information set up as follows:
'
'   Element 1,1 is the offset into the element for the primary key.
'   Element 1,2 is the size/code for the type of data being considered.
'   Element 1,3 is 0 or 1 for ascending or descending respectively.
'
'   Element 2,1 is the offset into the element for the secondary key, and
'   so forth, through the last sort key.
'
'   The size of the table array - that is, UBOUND(Table, 1) - is used by
'   KeySort as it reads this information, so always dimension it to the
'   correct size for the number of sort keys.

FOR x = 1 TO numberOfKeys                ' read the offsets, type codes, and sort directions
  FOR y = 1 TO 3
    READ table(x, y)
  NEXT
NEXT

DATA 18, 20, 0  : ' The primary sort is on the fixed-length string, which
                  ' starts 18 bytes into the structure.  The string length
                  ' is 20, and we want to do an ascending sort.

DATA 0, -1, 1   : ' the second key is on the integer part, the type/length
                  ' code is -1, and this is to be sorted descending

DATA 10, -4, 0  : ' the double is the third key, the type/length code is -4,
                  ' and we want to do an ascending sort


LOCATE 1, 1
PRINT " Sorting...";                            ' show what we're doing
VAR lowest = LBOUND(array, 1)            ' specify sorting the entire array
VAR highest = UBOUND(array, 1)
VAR elSize = LEN(array(lowest))          ' LEN provides the size of each element
numEls = highest - lowest + 1        ' calculate the number of elements

KeySort @array(lowest), elSize, numEls, table(), numberOfKeys

CLS                                      ' print the array to show it worked
PRINT " Element"; TAB(15); "String (ascending)"; TAB(40); "Int (descending)"; TAB(61); "Double (ascending)" ';
PRINT STRING$(79, "=")
LOCATE 24, 1
PRINT STRING$(79, "=");
LOCATE 25, 1
PRINT "Press any key to pause";

VIEW PRINT 3 TO 23                       ' limit printing to lines 3 through 23
LOCATE 3, 1
VAR chgColor = 10                        ' use this color when Key 2 changes
                                         ' to better illustrate the sorting
FOR x = lowest TO highest
  IF array(X).X <> last THEN PRINT       ' add blank line between primary groups
  IF array(X).I <> lastI THEN            ' alternate colors each secondary group
    IF chgColor = 10 THEN
      chgColor = 2
    ELSE
      chgColor = 10
    END IF
    COLOR chgColor
  END IF

  PRINT "  "; x, array(x).X, "    "; array(X).I, "    ";
  PRINT USING "##########.###"; array(x).D

  IF LEN(INKEY$) THEN                    ' pause on any key press
    WaitKey
  END IF

  last = array(x).X                      ' remember the last values so we know when to
  lastI = array(x).I                     ' break a new string group, and change colors
                                         ' at the start of each new integer sub-group
  Pause 2                                ' use a slight delay to slow down the scrolling

NEXT

'****** The following is the original KeySort program as written in BASIC.
'       It is provided here solely for informational purposes, to show how
'       such a program is written.  Understand that in the BASIC version,
'       the data and table arrays had to be SHARED.  Therefore, the assembler
'       version is not only faster than the subprogram shown below, but it is
'       also much more flexible.
'
'SUB KeySort (First, Last)
'First and Last indicate the range of the array being sorted on this pass
'
'   STATIC Level                        'Level tracks the current sort level
'
'   'calculate the number of elements, and sort array based on the current key
'   SortT Array(First), Last - First + 1, Table(Level + 1, 3), _
'         LEN(Array(First)), Table(Level + 1, 1), Table(Level + 1, 2)
'
'   'if there are no more keys to sort, then bail out here
'   IF Level + 1 = UBOUND(Table, 1) THEN EXIT SUB
'
'   'seek duplicate keys in this group to determine the sub-group to sort next
'   Start = First                       'remember where this portion starts
'   Offset = Table(Level + 1, 1)        'get offset into the member just once
'
'   FOR X = First TO Last - 1
'
'       'see if this element and the next one are the same
'       Same = Compare%(VARSEG(Array(X)), AddUSI%(VARPTR(Array(X)), Offset), _
'               VARSEG(Array(X + 1)), AddUSI%(VARPTR(Array(X + 1)), Offset), _
'               Table(Level + 1, 2))
'
'       'Fudge is needed to force a sub-sort in case ALL of the elements in
'       'this block are the same
'       Fudge = 0
'       IF (X = Last - 1) AND Same THEN Fudge = 1
'
'       'if there's a break and > 1 element to do, or Fudge forces a break
'       IF ((NOT Same) AND (X > Start)) OR Fudge THEN
'          Level = Level + 1
'          KeySort Start, X + Fudge     'call KeySort recursively
'          Level = Level - 1
'       END IF
'
'       'there was a break, so start the next portion at the next element
'       IF NOT Same THEN Start = X + 1
'   NEXT
'
'END SUB