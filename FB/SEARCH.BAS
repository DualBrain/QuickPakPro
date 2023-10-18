' ********* Search.Bas - demonstrates searching any type of array FAST!
' Copyright (c) 1988 Ethan Winer
' Modifications (c) 2023 Cory Smith

#INCLUDE ONCE "PRO.BI" ' Search

DIM found AS SHORT
DIM numEls AS SHORT

CLS
REDIM Array(10000) AS DOUBLE
VAR totalEls = 10001                     ' don't forget element zero

DIM match AS DOUBLE = 1234               ' value to find
array(9999) = match                      ' put it near the end of the array
VAR startEl = 10                         ' start looking near the beginning of the array
VAR direction = 0                        ' 0 means forward, anything else means backward
VAR matchCode = 1                        ' 0 = exact, 1 = greater or equal, -1 = less or equal
VAR varType = -4                         ' -1 = integer, -2 = long int, -3 = Sgl. Prec., -4 = DP

IF direction = 0 THEN                    ' calculate how many elements to search
  numEls = totalEls - startEl            '  based on the direction
ELSE
  numEls = startEl + 1                   ' this assumes the array starts at zero
END IF                                   '  adjust if you start at 1 (or anything else)

VAR x = TIMER                            ' to time the search
Search @array(startEl), numEls, match, found, direction, matchCode, varType
VAR x1 = TIMER

IF found = -1 THEN                       ' Search returns -1 if it didn't find a match
  PRINT "Not found"
ELSE
  IF direction = 0 THEN                  ' we need to know the direction, since SearchI
    found = startEl + found              '  simply returns how many elements it
  ELSE                                   '  examined, not the actual element number
    found = startEl - found              '  it found the Match at.
  END IF
  PRINT "The value"; match; " was found at element number"; found
END IF

PRINT
PRINT USING "Search took #.## seconds to scan " + STR$(CSNG(numEls) * 8) + " bytes"; x1 - x