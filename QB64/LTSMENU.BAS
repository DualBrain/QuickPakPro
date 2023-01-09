' ********* LTSMENU.BAS - a single-line Lotus(tm) style menu

' Copyright (c) 1988 Ethan Winer
' Modifications (c) 2023 Cory Smith

DEFINT A-Z

DECLARE SUB ClearEOL (colr)
DECLARE FUNCTION FindLast% (BYVAL address, numEls)
DECLARE FUNCTION OneColor% (fg, bg)
DECLARE SUB QPrint (x$, colr, page)
DECLARE SUB SplitColor (both, fg, bg)
DECLARE SUB ScrnSave0 (tRow, lCol, bRow, rCol, SEG address)
DECLARE SUB ScrnRest0 (tRow, lCol, bRow, rCol, SEG address)

SUB LtsMenu (item$(), choice, colr)

  ' Item$() has one dimension
  ' Choice is the value returned, or zero if Escape is pressed
  ' Colr is the packed color to use for the display
  '
  ' NOTE: A comment near the end shows how to modify this menu to exit
  '       when a letter key is pressed, without also needing to press Enter.
  '       If you do this, each item should start with a unique first letter.
  '       Search for the string "having" to find the line to change.

  LOCATE , , 0                        'turn off the cursor
  CALL SplitColor(colr, fg, bg)       'split color into FG and BG

  REDIM scrBuf(0 TO 159)
  tRow = CSRLIN
  'CALL ScrnSave0(tRow, 1, tRow, 80, scrBuf(0))
  CALL ScrnSave0(tRow, 1, tRow, 80, scrBuf())

  '-- determine how many choices there are

  numItems = UBOUND(item$)    'get the number of items passed
  'numItems = FindLast%(VARPTR(item$(numItems)), numItems)
  numItems = FindLast%(item$(), numItems, numItems)

  REDIM break(numItems + 1)   'remembers which items start on a new screen
  break(numItems + 1) = -2    'mark one past the end as a flag
  col = 1                     'tracks the accumulated line width and columns
  page = 1                    'tracks which item begins a new screen page

  '-- Build a table of starting columns and page breaks for each item.
  '   For each item that begins a new page, use a negative version of the
  '   page number as a flag.  We don't need the starting column for those
  '   anyway, because the first item on each page always is in column 1.
  '   For all other items, the equivalent Break() element will hold the
  '   column in which this item is located.

  FOR x = 1 TO numItems
    break(x) = col            ' assume we're not starting a new screen page
    IF x = 1 THEN break(x) = -1
    col = col + LEN(item$(x)) + 2 ' add two for a small border
    IF col > 80 THEN
      page = page + 1         ' we advanced to the next page
      break(x) = -page        ' this item starts a page, remember which one
      col = LEN(item$(x)) + 3
    END IF
  NEXT

  '-- print a page-full of items

  choice = 1                  ' start with item 1 the first time

QPPrintLts:
  x = choice                  ' assume we'll start at the current item

  WHILE break(x) > 0          ' seek the first item on this page
    x = x - 1
  WEND

  DO                          ' print until the negative Break() flag
    c = colr                  ' assume the item being printed is NOT current
    IF x = choice THEN        ' we were wrong, reverse the FG and BG colors
      c = OneColor%(bg, fg AND 7)
    END IF

    IF break(x) < 0 THEN      ' if it's the first item on this page
      LOCATE , 1              ' locate to the first column
      IF clearFlag THEN       ' if we just crossed a page boundary
        CALL ClearEOL(colr)   '   clear any old items that may still show
        clearFlag = 0
      END IF
    ELSE                      ' otherwise
      LOCATE , break(x)       '   locate to the correct column
    END IF

    CALL QPrint(" " + item$(x) + " ", c, -1)
    x = x + 1                 ' advance to the next item
  LOOP UNTIL break(x) < -1

'   LOCATE , , 1                        ' this code leaves the cursor
'   IF break(choice) < 0 THEN           '   on, which then tracks the
'     LOCATE , 1                        '   highlight bar
'   ELSE
'     LOCATE , break(choice)
'   END IF

  DO
    x$ = INKEY$
  LOOP UNTIL LEN(x$)

  IF LEN(x$) = 2 THEN         ' extended key
    SELECT CASE ASC(RIGHT$(x$, 1))
      CASE 71                 ' Home Key
        choice = 1            ' set to the first item in the list
        clearFlag = 1         ' flag to clear old items

      CASE 75                 ' Left Arrow
        IF choice > 1 THEN
          choice = choice - 1
          IF break(choice) < 0 THEN clearFlag = 1
        ELSE
          choice = numItems
          clearFlag = 1
        END IF

      CASE 77                 ' Right Arrow
        IF choice < numItems THEN
          choice = choice + 1
          IF break(choice) < 0 THEN clearFlag = 1
        ELSE
          choice = 1
          clearFlag = 1
        END IF

      CASE 79                 ' End Key
        choice = numItems
        clearFlag = 1

      CASE ELSE               ' ignore anything else
    END SELECT

  ELSE                        ' normal (not extended) key
    SELECT CASE x$
      CASE CHR$(13)           ' Enter Key
        GOTO QPExitLts        ' exit with the current choice

      CASE CHR$(27)           ' Escape Key
        choice = 0            ' set the choice to zero as an Escape flag
        GOTO QPExitLts

      CASE ELSE               ' they must be typing a choice's first letter
        x = choice            ' scan through each item looking for a match
        DO                    ' starting at the item after the current one
          IF x = numItems THEN x = 0      ' wrap past the last one
          x = x + 1                       ' consider the next item

          IF ASC(UCASE$(item$(x))) = ASC(UCASE$(x$)) THEN
            choice = x                   ' we found one, save where
            clearFlag = 1                ' set flag to clear old stuff
            EXIT DO                      '   and stop searching
            ' change the EXIT DO above to GOTO QPExitLts if you want to
            '   exit without having to press Enter
          END IF
          IF x = choice THEN EXIT DO     ' we already came around once
        LOOP
    END SELECT
  END IF

  GOTO QPPrintLts

QPExitLts:
  'ScrnRest0 tRow, 1, tRow, 80, scrBuf(0)
  ScrnRest0 tRow, 1, tRow, 80, scrBuf()
  ERASE break, scrBuf

END SUB