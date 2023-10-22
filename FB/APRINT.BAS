' ********** APRINT.BAS - quick prints a "Mid" portion of an entire array
' Copyright (c) 1987 Ethan Winer
' Modifications (c) 2023 Cory Smith

#INCLUDE "PRO.BI" ' APrint, Box, QPrint

Var EXTCHAR = CHR$(255) ' CHR$(0) <--- Why? Just why??

Var page = 0
Var pages = 7   'use 3 or 7 to establish the vertical resolution of the demo
Var wide = 80   'set to 40 or 80

Var start = 1: Var midFirst = 1     'start with first character in first element

'init screens to different colors to test the default color ability
'of APrint and Box - the Page parameters can also be hard-coded.

Dim scrSize As Short, numEls As Short, numChars As Short
Dim fg As Short, bg As Short

IF pages = 7 THEN   'if we're allowing 7 pages, then do 25 lines
  scrSize = 25
  numEls = 22
ELSE                'otherwise use the 43 line mode (EGA only)
  scrSize = 43
  numEls = 40
END IF

IF wide = 40 THEN   'if we're working in 40 columns, use 38 characters
  numChars = 38
ELSE                'otherwise use 80 characters
  numChars = 78
END IF

'SCREEN 0, , pages
WIDTH wide, scrSize
FOR x As Short = pages TO 0 STEP -1
  'SCREEN 0, 0, X, X
  SCREEN X, X
  READ fg, bg
  COLOR fg, bg
  CLS
  Box 1, 1, numEls + 2, numChars + 2, 3, fg + 1 + bg + 1 * 4, -1
NEXT
DATA 15,4,  1,0,  12,5,  2,8,  11,2,  9,0,  13,4,  14,1

DIM array(2000) As String, count As Short
OPEN "APrint.Bas" FOR INPUT AS #1
WHILE NOT EOF(1)
  count = count + 1
  LINE INPUT #1, array(count)
WEND
CLOSE

NewPage:
  'SCREEN , , page, page
  SCREEN , page, page
  Var p = "Page " + STR$(page) + ": Use arrows, "
  p = p + CHR$(34) + "P" + CHR$(34) + ", or Esc to exit"
  LOCATE numEls + 3, 1
  QPrint p, -1, -1

Doit:
  LOCATE 2, 2: 'clr = 7
  APrint VARPTR(array(start)), numEls, midFirst, numChars, -1, -1

GetK:
  Dim key As String
  DO
    key = INKEY$
  LOOP UNTIL LEN(key)

  IF key = CHR$(27) THEN END                   'Escape

  IF key = EXTCHAR + CHR$(80) THEN
    IF start + numEls - 1 > count GOTO GetK  'Down arrow
    start = start + 1
    GOTO Doit
  ELSEIF key = EXTCHAR + CHR$(72) THEN         'Up arrow
    IF start < 2 GOTO GetK
    start = start - 1
    GOTO Doit
  ELSEIF key = EXTCHAR + CHR$(75) THEN         'Left arrow
    IF midFirst < 2 GOTO GetK
    midFirst = midFirst - 1
    GOTO Doit
  ELSEIF key = EXTCHAR + CHR$(77) THEN         'Right Arrow
    midFirst = midFirst + 1
    GOTO Doit
  ELSEIF key = EXTCHAR + CHR$(71) THEN         'Home key
    start = 1
    midFirst = 1
    GOTO Doit
  ELSEIF UCASE$(key) = "P" THEN                'new Page
    page = page + 1
    IF page > pages THEN page = 0
    GOTO NewPage
  END IF

  GOTO GetK