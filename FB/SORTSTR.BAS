' ********** SortStr.Bas - loads a text file and sorts the lines
' Copyright (c) 1987 Ethan Winer
' Modifications (c) 2023 Cory Smith

#INCLUDE ONCE "PRO.BI" ' SortStr, SortStr2, LineCount, FileSize*

DIM fileName AS STRING
DIM q AS STRING
DIM direction AS SHORT
DIM c AS SHORT
DIM lines AS SHORT

CLS
LOCATE , , 1
PRINT "File to load and sort: ";                'ask for a file to sort
LINE INPUT fileName
REM IF FileSize(fileName) > (FRE("") - 2000) THEN
REM   PRINT "Not enough memory to load this file"
REM   END
REM END IF

CLS
PRINT "Ascending or Descending? (A/D) ";

DO
  q = UCASE$(INKEY$)
LOOP UNTIL q = "A" OR q = "D"
IF q = "A" THEN
  direction = 0
ELSE
  direction = 1
END IF

CLS
PRINT "Case Sensitive or Insensitive? (S/I) ";

DO
  q = UCASE$(INKEY$)
LOOP UNTIL q = "S" OR q = "I"
IF q = "S" THEN
  c = 1
ELSE
  c = 0
END IF

lines = LineCount(fileName, SPACE$(4096))       'count the number of lines
DIM a(lines) AS STRING                          'make an array to hold it

OPEN fileName FOR INPUT AS #1                  'read the file into an array
lines = 0
WHILE NOT EOF(1)
  lines = lines + 1
  LINE INPUT #1, a(lines)
WEND
CLOSE

VAR start = 1                       'specify sorting the whole array
VAR size = lines
REM PLAY "L32O3AF"

CLS
PRINT "Press any key to begin sorting ";

WHILE INKEY$ = "": WEND                 'pause for keypress
VAR t = TIMER                              'so we can time the sort

IF c THEN
  SortStr VARPTR(a(start)), size, direction         'sort ascending
ELSE
  SortStr2 VARPTR(a(start)), size, direction        'sort descending
END IF

CLS
PRINT USING "Time: ##.## Seconds"; TIMER - t;
REM PLAY "AF"

PRINT " - press any key to display sorted array ";
WHILE INKEY$ = "": WEND

LOCATE 25, 1, 0
PRINT "Press any key to pause";
LOCATE 3, 1

FOR x AS SHORT = 1 TO Size
  PRINT LEFT$(a(x), 79)          'in case the lines are very long
  IF INKEY$ <> "" THEN
    WHILE INKEY$ = "": WEND      'pause on keypress
  END IF
NEXT