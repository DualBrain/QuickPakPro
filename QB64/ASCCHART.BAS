' ********* ASCCHART.BAS - ASCII pop-up display module

' Copyright (c) 1988 Paul Passarelli
' Copyright (c) 1988 Crescent Software
' Modifications (c) 2022 Cory Smith

DEFINT A-Z

DECLARE SUB ASCIIChart (row, column, height)
DECLARE SUB APrint0 (array$(), start, numElem, firstChar, numChar, colr)
DECLARE SUB Box0 (ulRow, ulCol, lrRow, lrCol, char, colr)
DECLARE SUB ScrnSave0 (ulRow, ulCol, lrRow, lrCol, array%())
DECLARE SUB ScrnRest0 (ulRow, ulCol, lrRow, lrCol, array%())

SUB ASCIIChart (row, column, lines)

  IF lines < 2 THEN lines = 2
  REDIM array((lines + 2) * 12)         ' holds the underlying screen
  boxColor = 78                         ' colors - modify to suit
  textColor = 79

  REDIM array$(0 TO 255)                ' array to hold the displayed text
  h$ = SPACE$(2)                        ' reserve room for Hex stuff
  FOR x = 0 TO 255
    array$(x) = SPACE$(10)
    MID$(array$(x), 1 - (x < 10) - (x < 100)) = STR$(x)
    MID$(array$(x), 6 - (x < 16)) = HEX$(x)
    ' HACK: QB64, need to filter the following as they
    '       cause wierd things to happen when printed 
    '       to the screen.
    SELECT CASE x
      CASE 7 ' BELL
      CASE 8 ' BACKSPACE
      CASE 9 ' HTAB
      CASE 10 ' LF
      CASE 11 ' VTAB
      CASE 12 ' FORM FEED
      CASE 13 ' CR
      CASE 28 ' Not sure why???
      CASE 29 ' Not sure why???
      CASE 30 ' Not sure why???
      CASE 31 ' Not sure why???
      CASE ELSE
        MID$(array$(x), 9) = CHR$(x)
    END SELECT
  NEXT
 
  cursV = CSRLIN: cursH = POS(0)        ' save cursor position
  IF row = -1 THEN row = cursV          ' if either is -1, use the
  IF column = -1 THEN column = cursH    ' current cursor location

  CALL ScrnSave0(row, column, row + lines + 1, column + 11, array())
  CALL Box0(row, column, row + lines + 1, column + 11, 2, boxColor)

  LOCATE row + 1, column + 1
  block = lines                         ' set up to jump into code

  'GOTO ASCIIPaul
  CALL APrint0(array$(), firstL * flag, block, 1, 10, textColor)

  DO
    flag = 1                            ' flag to do wrap
    block = lines                       ' portion to wrap
    LOCATE row + 1, column + 1          ' reset each time a block is split

ASCIIFast:

    k$ = INKEY$
    IF k$ = CHR$(27) THEN               ' Escape
      CALL ScrnRest0(row, column, row + lines + 1, column + 11, array())
      LOCATE cursV, cursH
      ERASE array
      EXIT SUB
    ELSEIF LEN(k$) = 2 THEN
      SELECT CASE ASC(RIGHT$(k$, 1))
        CASE 71                         ' Home
          firstL = 0
        CASE 72                         ' Up Arrow
          firstL = firstL - 1
        CASE 73                         ' PgUp
          firstL = firstL - block
        CASE 79                         ' End
          firstL = 256 - block
        CASE 80                         ' Down Arrow
          firstL = firstL + 1
        CASE 81                         ' PgDn
          firstL = firstL + block
        CASE ELSE
          GOTO ASCIIFast
      END SELECT
    ELSE
      GOTO ASCIIFast                    ' ignore any other keys
    END IF

    IF firstL > 255 THEN
      firstL = firstL - 256             ' wrap down
      flag = 1
    ELSEIF firstL < -block THEN
      firstL = firstL + 256             '  wrap up
      flag = 1
    ELSEIF firstL < 0 THEN              ' wrap to 255
      CALL APrint0(array$(), firstL + 256, -firstL, 1, 10, textColor)
      LOCATE row + 1 + block - (block + firstL), column + 1
      block = block + firstL
      flag = 0
    ELSEIF firstL > 256 - block THEN    ' wrap to zero
      CALL APrint0(array$(), firstL, 256 - firstL, 1, 10, textColor)
      LOCATE row + 1 + (256 - firstL), column + 1
      block = block - (256 - firstL)
      flag = 0
    END IF

    IF flag THEN LOCATE row + 1, column + 1
    IF CSRLIN < row + 1 + lines THEN
      'ASCIIPaul:
      CALL APrint0(array$(), firstL * flag, block, 1, 10, textColor)
    END IF

  LOOP

END SUB