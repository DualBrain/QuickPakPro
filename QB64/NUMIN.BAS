' ********** NUMIN.BAS - numeric input routine

' Copyright (c) 1987 Ethan Winer
' Modifications (c) 2022 Cory Smith

DEFINT A-Z

DECLARE SUB CapNum ()
DECLARE FUNCTION FUsing$ (number$, mask$)
DECLARE SUB QPrint (txt$, colr, page)

'----- entry parameters
'
' n# = amount to be input or edited (use the name of your choice)
'
' max = maximum number of digits to the left of the decimal point
' places = maximum number of digits to the right of the decimal point
' colr is the combined foreground and background colors that will be used
'
'----- exit parameters
'
' n# = final edited amount
' exitCode indicates how editing was terminated -
'   0 = Enter, Tab, Down-Arrow, Right-Arrow past end, or field filled
'   1 = Shift-Tab, Up-Arrow, or Left-Arrow past beginning
'   2 = Escape key pressed
'
'----- local variables
'
' x$ is a string version of the number while it is being input or edited
' insert indicates that insert mode is active
' curPo holds current cursor position relative to the beginning of the line
' a and a$ are temporary scratch variables
'
SUB NumIn (n#, max, places, exitCode, colr) STATIC

NInitialize:

  IF max = 0 THEN max = 1                      ' leave room for minus sign

  x$ = STRING$(max, "#")                       ' build a formatting string
  IF places THEN x$ = x$ + "." + STRING$(places, "#")
  x$ = FUsing$(STR$(n#), x$)                   ' let FUsing do the real work
  zero = INSTR(x$, "0")                        ' did FUsing leave a leading 0?
  IF LEFT$(LTRIM$(x$), 1) = "0" THEN MID$(x$, zero, 1) = " "  ' yes, delete it

  exitCode = 0: insrt = 1: curPo = max         ' initialize local variables
  aLength = LEN(STR$(FIX(n#)))                 ' active length of leading part

  IF ABS(n#) >= 1# THEN                        ' insert only if no leading #'s
    insrt = 0                                  ' and position cursor over
    curPo = max - aLength + 2                  ' first digit
  END IF

  CALL QPrint(x$, colr, -1)                    ' print it
  LOCATE , POS(0) + max - aLength + 1, 1       ' locate and turn on the cursor

NGetKey:
  CALL CapNum                                  ' print Cap/Num if active
  IF curPo > LEN(x$) GOTO NEnter               ' field full, handle as Enter
  IF MID$(x$, curPo, 1) = "." THEN             ' cursor is on the point, skip
    LOCATE , POS(0) + 1
    curPo = curPo + 1
  END IF

  a$ = INKEY$
  IF a$ = "" GOTO NGetKey
  IF LEN(a$) = 1 GOTO NRegularKey

  a$ = RIGHT$(a$, 1)                            ' extended key, get the code
  ON INSTR(CHR$(15) + ".HKMPS", a$) GOTO NShiftTab, NClear, NUp, NLeft, NRight, NDown, NDel
  GOTO NGetKey                                  ' none of the above, ignore

NShiftTab:                                      ' this space is provided to put
                                                ' your own handler for the

NUp:                                           ' Shift-Tab key if you want
  exitCode = 1                                 ' user wants to go back a field
  GOTO NEnter                                  ' handle as if it were Enter

NClear:
  LOCATE , POS(0) - (curPo - 1)                ' position cursor at beginning
  n# = 0#                                      ' clear the field
  GOTO NInitialize

NLeft:
  insrt = 0                                    ' cancel insert mode
  IF MID$(x$, curPo, 1) = " " GOTO NGetKey     ' allow only one leading space
  IF MID$(x$, curPo, 1) = "-" GOTO NGetKey     ' disallow digits ahead of "-"

  IF curPo > 1 THEN
    curPo = curPo - 1
    LOCATE , POS(0) - 1                        ' back up the cursor
  END IF

  IF curPo = max + 1 THEN                      ' one more to skip the point
    curPo = curPo - 1
    LOCATE , POS(0) - 1
  END IF

  GOTO NGetKey

NRight:
  insrt = 0                                    ' cancel insert mode
  curPo = curPo + 1
  LOCATE , POS(0) + 1                          ' advance the cursor
  GOTO NGetKey

NDown:
  GOTO NEnter                                  ' handle as Enter

NDel:
  GOTO NSB2                                    ' handle as a space

NRegularKey:
  IF a$ < " " THEN                            ' a control key
    ON INSTR(CHR$(8) + CHR$(9) + CHR$(13) + CHR$(27), a$) GOTO NBackSpace, NTabKey, NEnter, NEscape
    GOTO NGetKey                              ' none of the above, get again
  END IF

  IF a$ = "-" THEN
    IF curPo = 1 GOTO NNumericOkay
    IF INSTR(x$, "-") GOTO NGetKey            ' disallow if already a minus
    IF MID$(x$, curPo - 1, 1) <> " " GOTO NGetKey
    GOTO NNumericOkay
  END IF

  IF a$ = "." THEN
    IF places = 0 GOTO NGetKey                ' disallow if no decimals
    IF insrt = 0 GOTO NGetKey                 ' disallow unless new entry
    LOCATE , POS(0) + 2                       ' advance the cursor by two
    curPo = curPo + 2
    insrt = 0                                 ' clear the insert flag
    GOTO NGetKey                              ' get another keypress
  END IF

NSpaceBar:
  IF a$ = " " THEN
    
    insrt = 0

NSB2:
    IF curPo = 1 GOTO NSpaceOkay              ' okay if in first position

    ' disallow if not first digit
    IF MID$(x$, curPo - 1, 1) <> " " GOTO NGetKey

NSpaceOkay:
    MID$(x$, curPo, 1) = " "                  ' assign a space to the string
    CALL QPrint(" ", colr, -1)                ' print a space
    LOCATE , POS(0) + 1                       ' advance the cursor
    curPo = curPo + 1                         ' update Curpo
    GOTO NGetKey

  END IF

  IF a$ < "0" OR a$ > "9" GOTO NGetKey        ' invalid character

NNumericOkay:
  CALL QPrint(a$, colr, -1)                   ' print the digit
  IF insrt GOTO NHandleInsert                 ' special treatment for insert
  MID$(x$, curPo, 1) = a$                     ' assign new digit
  curPo = curPo + 1                           ' show the cursor being forward
  LOCATE , POS(0) + 1
  GOTO NGetKey

NHandleInsert:
  LOCATE , POS(0) - curPo + 1                 ' back the cursor to beginning

  FOR a = 1 TO max - 1                        ' slide all characters left one
    MID$(x$, a, 1) = MID$(x$, a + 1, 1)
    QPrint MID$(x$, a, 1), colr, -1           ' and reprint them in new place
    LOCATE , POS(0) + 1
  NEXT
 
  MID$(x$, curPo, 1) = a$                      ' assign the digit
  CALL QPrint(a$, colr, -1)
  IF ASC(x$) = 32 GOTO NGetKey                 ' field not full, get another
  GOTO NRight                                  ' field full, do a cursor right

NBackSpace:
  GOTO NLeft                                   ' handle as Left-Arrow key

NEscape:
  exitCode = 2

NTabKey:                                       ' you may handle Tab separately
                                               ' if you'd like
NEnter:
  n# = VAL(x$)                                 ' assign returned amount
  LOCATE , , 0                                 ' turn off the cursor

END SUB