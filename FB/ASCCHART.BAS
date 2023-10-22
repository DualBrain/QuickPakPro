' ********* ASCCHART.BAS - ASCII pop-up display module
' Copyright (c) 1988 Paul Passarelli
' Copyright (c) 1988 Crescent Software
' Modifications (c) 2023 Cory Smith

#INCLUDE "PRO.BI" ' APrint0, Box0, ScrnSave0, ScrnRest0

DECLARE SUB ASCIIChart (row As Short, column As Short, lines As Short)

SUB ASCIIChart (row As Short, column As Short, lines As Short)

  Dim firstL As Short, flag As Short

  IF lines < 2 THEN lines = 2
  REDIM scrn((lines + 2) * 12) As Short         'holds the underlying screen
  Var boxColor = 78                     'colors - modify to suit
  Var textColor = 79

  REDIM array(0 TO 255) As String      'array to hold the displayed text
  Var h = SPACE$(2)                     'reserve room for Hex stuff
  FOR x As Short = 0 TO 255
    array(x) = SPACE$(10)
    MID$(array(x), 1 - (x < 10) - (x < 100)) = STR$(x)
    MID$(array(x), 6 - (x < 16)) = HEX$(x)
    SELECT CASE x
      Case 7,8,9,10,13
      CASE ELSE
        MID$(array(x), 9) = CHR$(x)
    END SELECT
  NEXT
 
  Var cursV = CSRLIN: Var cursH = POS(0)        'save cursor position
  IF row = -1 THEN row = cursV          'if either is -1, use the
  IF column = -1 THEN column = cursH    '  current cursor location

  ScrnSave0 row, column, row + lines + 1, column + 11, @scrn(0)
  Box0 row, column, row + lines + 1, column + 11, 2, boxColor

  LOCATE row + 1, column + 1
  Var block = lines                         'set up to jump into code
  'GOTO ASCIIPaul
  APrint0 VARPTR(array(firstL * flag)), block, 1, 10, textColor

DO
  flag = 1                              'flag to do wrap
  block = lines                         'portion to wrap
  LOCATE row + 1, column + 1            'reset each time a block is split

ASCIIFast:
  Var k = INKEY$
  IF k = CHR$(27) THEN                 'Escape
    ScrnRest0 row, column, row + lines + 1, column + 11, @scrn(0)
    LOCATE cursV, cursH
    ERASE scrn
    EXIT SUB
  ELSEIF LEN(k) = 2 THEN
    SELECT CASE ASC(RIGHT$(k, 1))
      CASE 71                           'Home
        firstL = 0
      CASE 72                           'Up Arrow
        firstL = firstL - 1
      CASE 73                           'PgUp
        firstL = firstL - block
      CASE 79                           'End
        firstL = 256 - block
      CASE 80                           'Down Arrow
        firstL = firstL + 1
      CASE 81                           'PgDn
        firstL = firstL + block
      CASE ELSE
        GOTO ASCIIFast
    END SELECT
  ELSE
    GOTO ASCIIFast                      'ignore any other keys
  END IF

  IF firstL > 255 THEN
    firstL = firstL - 256               'wrap down
    flag = 1
  ELSEIF firstL < -block THEN
    firstL = firstL + 256               'wrap up
    flag = 1
  ELSEIF firstL < 0 THEN                'wrap to 255
    APrint0 VARPTR(array(firstL + 256)), -firstL, 1, 10, textColor
    LOCATE row + 1 + block - (block + firstL), column + 1
    block = block + firstL
    flag = 0
  ELSEIF firstL > 256 - block THEN      'wrap to zero
    APrint0 VARPTR(array(firstL)), 256 - firstL, 1, 10, textColor
    LOCATE row + 1 + (256 - firstL), column + 1
    block = block - (256 - firstL)
    flag = 0
  END IF

  IF flag THEN LOCATE row + 1, column + 1
  IF CSRLIN < row + 1 + lines THEN
'ASCIIPaul:
    APrint0 VARPTR(array(firstL * flag)), block, 1, 10, textColor
  END IF

LOOP

END SUB