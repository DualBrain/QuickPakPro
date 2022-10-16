' ********** SORTSTR.BAS - loads a text file and sorts the lines

' Copyright (c) 1987 Ethan Winer
' Modifications (c) 2022 Cory Smith

'$INCLUDE: 'QPPRO.BI'

DEFINT A-Z

DECLARE SUB SortStr (address$(), start, size, direction)
DECLARE SUB SortStr2 (address$(), start, size, direction)
DECLARE FUNCTION LineCount% (fileName$, buffer$)
DECLARE FUNCTION FileSize& (fileName$)

CLS

LOCATE , , 1
PRINT "File to load and sort: ";                'ask for a file to sort
LINE INPUT fileName$
IF FileSize&(fileName$) > (FRE("") - 2000) THEN
  PRINT "Not enough memory to load this file"
  END
END IF

CLS

PRINT "Ascending or Descending? (A/D) ";

DO
  s$ = UCASE$(INKEY$)
LOOP UNTIL x$ = "A" OR x$ = "D"
IF x$ = "A" THEN
   dir = 0
ELSE
   dir = 1
END IF

CLS

PRINT "Case Sensitive or Insensitive? (S/I) ";

DO
  x$ = UCASE$(INKEY$)
LOOP UNTIL x$ = "S" OR x$ = "I"
IF x$ = "S" THEN
  c = 1
ELSE
  c = 0
END IF

lines = LineCount%(fileName$, SPACE$(4096))     'count the number of lines
DIM a$(lines)                                   'make an array to hold it

OPEN fileName$ FOR INPUT AS #1                  'read the file into an array
lines = 0
WHILE NOT EOF(1)
  lines = lines + 1
  LINE INPUT #1, a$(lines)
WEND
CLOSE

start = 1                       'specify sorting the whole array
size = lines
PLAY "L32O3AF"

CLS

PRINT "Press any key to begin sorting ";

WHILE INKEY$ = "": WEND                 'pause for keypress
x! = TIMER                              'so we can time the sort

IF c THEN
  SortStr a$, start, size, dir         'sort ascending
ELSE
  SortStr2 a$, start, size, dir        'sort descending
END IF

CLS

PRINT USING "Time: ##.## Seconds"; TIMER - X!;
PLAY "AF"

PRINT " - press any key to display sorted array ";
WHILE INKEY$ = "": WEND

LOCATE 25, 1, 0
PRINT "Press any key to pause";
LOCATE 3, 1

FOR x = 1 TO size
  PRINT LEFT$(a$(x), 79)          'in case the lines are very long
  IF INKEY$ <> "" THEN
    WHILE INKEY$ = "": WEND      'pause on keypress
  END IF
NEXT

'$INCLUDE: 'QPPRO.BAS'