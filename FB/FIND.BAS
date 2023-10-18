' ********** Find.Bas - demonstrates searching an entire array for a sub-string
' Copyright (c) 1988 Ethan Winer
' Modifications (c) 2023 Cory Smith

' There are four versions of Find to locate a string or sub-string in an array.
' This demo shows only the case-insensitive versions.
'
'   Find searches forward and is case-sensitive
'   Find2 also searches forward, but ignores capitalization
'   FindB searches backwards and honors capitalization
'   FindB2 searches backwards and ignores capitalization
'
' Notes:
'
'   Because FindB and FindB2 know which element they are starting with, they
'   are able to return the element number at which the match was found.  But
'   Find and Find2 can't know how large the array is, so thet are set up
'   to instead return the number of elements that were searched.  All four
'   routines use -1 to indicate that a match was not found, however Find and
'   Find2 will report 0 if the match was made on the element they started
'   searching with.  If you start on, say, element 10 and Find (or Find2)
'   found a match at element 12, they would return 2 meaning two elements
'   BEYOND the current one were examined.  The examples below show all of
'   this in context.

#INCLUDE ONCE "PRO.BI" ' Find2, FindB2

VAR size = 10
DIM array(size) AS STRING
DIM x AS SHORT
DIM query AS STRING
DIM fDir AS STRING
DIM q AS STRING
DIM start AS SHORT
DIM elements AS SHORT

FOR x = 0 TO size
  READ array(x)
NEXT

DATA "Smith, Harold"
DATA "Rogers, Maude"
DATA "Smith, Arthur"
DATA "Jacki Pagliari"
DATA "Rogers, Carl J."
DATA "Rubin, Fenster"
DATA "Smythson, Wendy"
DATA "Plant, Gail H."
DATA "Smith Barney & Co."
DATA "Ericson, Sven"
DATA "Babbage, Charles"

CLS
LINE INPUT "Enter a string to search for (hint - try sm?th): "; query
PRINT "Search forward or backward (F/B)? ";

DO
  fDir = UCASE$(INKEY$)
LOOP UNTIL fDir = "F" OR fDir = "B"

PRINT fDir
PRINT

IF fDir = "F" THEN

'*************** Search forward

  start = 0                          ' start searching at the first element
  elements = size                    ' search the entire array

Forward:
  Find2 VARPTR(array(start)), elements, query
						  
  ' first see if it was there - Find returns -1 if it isn't found
  IF elements = -1 THEN
    PRINT "Not Found"
    END
  END IF

  start = start + elements               ' calculate the element number it was found at
				                             ' Elements returns with how far it searched,
				                             '  not an actual element number

  PRINT start; TAB(7); array(start)      ' print the matching element
  IF start = size THEN END               ' it was found at the last element -
					                          '  don't ask if they want to continue
  PRINT
  PRINT "Continue searching? (Y/N) ";

  DO
    q = UCASE$(INKEY$)
  LOOP UNTIL q = "Y" OR q = "N"

  PRINT q
  PRINT
  IF q <> "Y" THEN END

  elements = size - start - 1            ' consider only the remaining part of the array
  start = start + 1                      ' continue from the next element
  IF elements <= size GOTO Forward       ' continue search only if there's more

ELSE

  '************** Search backwards

  elements = size                        ' search entire array starting at the beginning

Backward:
  FindB2 VARPTR(array(elements)), elements, query

  IF elements = -1 THEN                  ' Find returns -1 if it isn't found
    PRINT "Not Found"
    END
  END IF

  PRINT elements; TAB(7); array(elements)
  IF elements = 0 THEN END               ' it was at the first element - don't ask
				                             '  if they want to continue

  PRINT "Continue searching? (Y/N) ";

  DO
    q = UCASE$(INKEY$)
  LOOP UNTIL q = "Y" OR q = "N"

  PRINT q
  PRINT
  IF q <> "Y" THEN END

  elements = elements - 1                ' continue with the previous element
  GOTO Backward

END IF