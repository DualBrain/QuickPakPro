' ********* READFILE.BAS - demos reading a list of file names and sorting them

' Copyright (c) 1989 Ethan Winer
' Modifications (c) 2022 Cory Smith

DEFINT A-Z

'$INCLUDE: 'QPPRO.BI'

_FULLSCREEN _SQUAREPIXELS

DECLARE SUB ReadFile (array$())
DECLARE SUB SortStr (array$(), start, numEls, direction)
DECLARE FUNCTION FCount% (fileSpec$)

CLS

INPUT "Enter a file spec, or press Enter for *.* : ", spec$
IF spec$ = "" THEN spec$ = "*.*"

numFiles = FCount%(spec$)               ' see how many files there are
IF numFiles = 0 THEN                    ' none, end
  PRINT "No matching files found"
  END
END IF

DIM array$(numFiles)                    ' make an array to hold the names
FOR x = 1 TO numFiles                   ' fill each element with 12 spaces
  array$(x) = SPACE$(12)
NEXT
array$(0) = spec$                       ' put the search spec into Array$(0)

ReadFile array$()                       ' read the names into Array$()
SortStr array$(), 1, numFiles, 0        ' sort the array, 0 means "ascending"

FOR x = 1 TO numFiles
  PRINT array$(x)
NEXT

'$INCLUDE: 'QPPRO.BAS'