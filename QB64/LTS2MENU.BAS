' ********* LTS2MENU.BAS - a Lotus(tm) style menu with prompt information

' Copyright (c) 1988 Ethan Winer
' Modifications (c) 2023 Cory Smith

DEFINT A-Z

DECLARE SUB ClearEOL (colr)
DECLARE FUNCTION OneColor% (fg, bg)
DECLARE SUB QPrint (x$, colr, page)
DECLARE SUB SplitColor (both, fg, bg)
DECLARE SUB ScrnSave0 (tRow, lCol, bRow, rCol, SEG address)
DECLARE SUB ScrnRest0 (tRow, lCol, bRow, rCol, SEG address)

SUB Lts2Menu (item$(), prompt$(), choice, colr)

  ' Item$() and Prompt$() have one dimension
  ' Choice is the value returned, or zero if Escape is pressed
  ' Colr is the packed color to use for the display
  '
  ' NOTE: The foreground and background portions of Colr are reversed for
  '       the highlighted item.  Also, a new color is derived from Colr
  '       for the prompt message - change this to suit by searching for
  '       the string "prompt color".
  '
  ' NOTE: A comment near the end shows how to modify this menu to exit
  '       when a letter key is pressed, without also needing to press Enter.
  '       If you do this, each item should start with a unique first letter.
  '       Search for the string "having" to find where.

  LOCATE , , 0                        ' turn off the cursor
  CALL SplitColor(colr, fg, bg)       ' split color into FG and BG

  REDIM scrBuf(0 TO 159)
  tRow = CSRLIN
  'CALL ScrnSave0(tRow, 1, tRow + 1, 80, scrBuf(0))
  CALL ScrnSave0(tRow, 1, tRow + 1, 80, scrBuf())
  CALL ClearEOL(7)                    ' clear any old prompt information

  '-- determine how many choices there are

  numItems = UBOUND(item$)      ' get the number of items passed

  WHILE item$(numItems) = ""    ' seek the last non-blank item
    numItems = numItems - 1
  WEND

  REDIM break(numItems + 1)   ' remembers which items start on a new screen
  break(numItems + 1) = -2    ' mark one past the end as a flag
  col = 1                     ' tracks the accumulated line width and columns
  page = 1                    ' tracks which item begins a new screen page
  
  '-- Build a table of starting columns and page breaks for each item.
  '   For each item that begins a new page, use a negative version of the
  '   page number as a flag.  we don't need the starting column for those
  '   anyway, because the first item on each pagwe always is in column 1.
  '   For all other items, the equivalent Break() element will hold the
  '   column in which this item is located.

  FOR x = 1 TO numItems
    break(x) = col           ' assume we're not starting a new screen page
    IF x = 1 THEN break(x) = -1
    col = col + LEN(item$(x)) + 2 ' add two for a small border
    IF col > 80 THEN
      page = page + 1        ' we advanced to the next page
      break(X) = -page       ' this item starts a page, remember which one
      col = LEN(item$(x)) + 3
    END IF
  NEXT
  
  '-- print a page-full of items

  choice = 1                  ' start with item 1 the first time

QPPrintLt2:
  x = choice                  ' assume we'll start at the current item
  WHILE break(x) > 0          ' seek the first item on this page
    x = x - 1
  WEND

  DO                          ' print until the negative Break() flag
    c = colr                  ' assume the item being printed is NOT current
    IF x = choice THEN        ' we were wrong, reverse the FG and BG colors
      c = OneColor%(bg, fg AND 7)
      LOCATE CSRLIN + 1, 1    ' go down a line and to the first column
      CALL ClearEOL(7)        ' clear any old prompt information
      ' you may adjust the prompt color by changing the line below
      CALL QPrint(" " + prompt$(x) + " ", ((NOT colr) AND 7) OR 2, -1)
      LOCATE CSRLIN - 1       ' return to the line above
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

  DO
    x$ = INKEY$
  LOOP UNTIL LEN(x$)

  IF LEN(x$) = 2 THEN         ' extended key
    SELECT CASE ASC(RIGHT$(x$, 1))
      CASE 71                 ' Home Key
        Choice = 1            ' set to the first item in the list
        ClearFlag = 1         ' flag to clear old items

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

      CASE ELSE
    END SELECT

  ELSE
    SELECT CASE X$
      CASE CHR$(13)           ' Enter Key
        GOTO QPExitLt2        ' exit with the current choice

      CASE CHR$(27)           ' Escape Key
        choice = 0            '   set the choice to zero as an Escape flag
        GOTO QPExitLt2

      CASE ELSE               ' they must be typing a choice's first letter
        x = choice            ' scan through each item looking for a match
        DO                    ' starting at the item after the current one
          IF x = numItems THEN x = 0  ' wrap past the last one
          x = x + 1                   ' consider the next item

          IF ASC(UCASE$(item$(x))) = ASC(UCASE$(x$)) THEN
            choice = x               ' we found one, save where
            clearFlag = 1            ' set flag to clear old stuff
            EXIT DO                  '   and stop searching
            ' change the EXIT DO above to GOTO QPExitLt2 to exit without
            '   having to press Enter
          END IF
          IF x = choice THEN EXIT DO  ' we already went around once
        LOOP
    END SELECT
  END IF

  GOTO QPPrintLt2

QPExitLt2:
  'CALL ScrnRest0(tRow, 1, tRow + 1, 80, scrBuf(0))
  CALL ScrnRest0(tRow, 1, tRow + 1, 80, scrBuf())
  ERASE break, scrBuf

END SUB