' *********** MAINMENU.BAS - scroll bar menu subprogram

' Copyright (c) 1988 Ethan Winer
' Modifications (c) 2022 Cory Smith

DEFINT A-Z

DECLARE SUB QPrint0 (x$, colr)
DECLARE SUB SplitColor (colr, fg, bg)
DECLARE FUNCTION OneColor% (fg, bg)

SUB MainMenu (item$(), choice, colr) STATIC   ' item$() has one dimension
                                              ' choice is the value returned

  CALL SplitColor(colr, fg, bg)               ' break out the menu colors

  '----- determine how many choices to display, and how long the longest one is

  maxNum = UBOUND(item$)                      ' find number of items
  IF maxNum > 9 THEN maxNum = 9               ' only nine items allowed

  WHILE item$(maxNum) = ""                    ' seek last valid item
    maxNum = maxNum - 1
  WEND

  maxLen = 50                                 ' set minimum border width
  FOR x = 1 TO maxNum
    l = LEN(item$(X))
    IF l > 70 THEN l = 70                     ' cut to 70 chars if necessary
    IF l > maxLen THEN maxLen = l             ' find length of longest item
  NEXT

  '----- draw border and display items on the screen

  CLS
    
  top = 11 - maxNum                           ' define top line
  leftMargin = 38 - maxLen / 2                ' define left margin
  rightMargin = leftMargin + maxLen + 6       ' and right margin

  LOCATE top, leftMargin                      ' draw top line
  CALL QPrint0(CHR$(218) + STRING$(5 + maxLen, CHR$(196)) + CHR$(191), colr)

  FOR x = 2 TO 2 + maxNum * 2                         ' draw the sides and
    PRINT
    LOCATE , leftMargin                             ' display the items
    CALL QPrint0(CHR$(179), colr)
    IF X MOD 2 THEN
      LOCATE , POS(0) '+ 1
      CALL QPrint0(STR$((x - 1) / 2) + ") " + LEFT$(item$((X - 1) / 2), 70), colr)
    END IF
    LOCATE , rightMargin
    CALL QPrint0(CHR$(179), colr)
  NEXT

  PRINT
  LOCATE , leftMargin                         ' draw the bottom
  CALL QPrint0(CHR$(192) + STRING$(5 + maxLen, CHR$(196)) + CHR$(217), colr)

  PRINT
  LOCATE , leftMargin + 2
  CALL QPrint0("Please Enter Your Choice: ", Colr)
  LOCATE , leftMargin + 28
  CALL QPrint0(CHR$(22), Colr OR 128)         ' simulate cursor

  '----- make inverse cursor bar over Items

  choice = 1                                  ' select Choice 1 initially

  DO

    GOSUB Display                               ' make inverse bar on item

    DO
      LOCATE 1, 1: CALL QPrint0(DATE$, colr)   ' update the time and date
      LOCATE , 72: CALL QPrint0(TIME$, colr)
      x$ = INKEY$                              ' get a keypress
    LOOP UNTIL LEN(x$)

    IF X$ = CHR$(13) THEN EXIT SUB              ' Enter key

    IF X$ = CHR$(27) THEN                       ' Escape key
      Choice = 0
      EXIT SUB
    END IF

    GOSUB Display                               ' restore old item
    x = VAL(x$)                                 ' set x to new item

    IF x > 0 AND x <= maxNum THEN choice = VAL(x$)  ' numeric key

    IF x$ = CHR$(0) + "H" THEN                      ' Up arrow
      choice = choice - 1
      IF choice < 1 THEN choice = maxNum
    END IF

    IF x$ = CHR$(0) + "P" THEN                      ' Down arrow
      choice = choice + 1
      IF choice > maxNum THEN choice = 1
    END IF

    IF x$ = CHR$(0) + "G" THEN choice = 1           ' Home key

    IF x$ = CHR$(0) + "O" THEN choice = maxNum      ' End key

  LOOP                                                    ' get again

  '----- Mark/Unmark cursor bar Item - depending on current FG and BG colors

Display:
  SWAP fg, bg                                         ' hilight/un-hilight
  LOCATE top + 2 * choice, leftMargin + 1             ' print choice inverse
  CALL QPrint0(STR$(choice) + ") " + LEFT$(item$(choice), 70) + " ", OneColor%(fg, bg))
  RETURN

END SUB

'$INCLUDE: 'QPPRO.BAS'