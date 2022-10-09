' ********** TEXTIN.BAS - text input subprogram

' Copyright (c) 1987 - 1990 Ethan Winer
' Modifications (c) 2022 Cory Smith

DEFINT a-Z

DECLARE FUNCTION Peek1% (segment, address)
DECLARE FUNCTION QPTrim$ (txt$)
DECLARE SUB CapNum ()
DECLARE SUB QPrint (txt$, colr, page)

'----- entry parameters
'
' t$  = string to be input or edited (use the name of your choice)
' max = maximum number of characters allowed
' colr is the combined foreground and background colors that will be used
' isCapsOn = force automatic conversion to upper case if 1
' numOnly = allow only numeric input if 1
'
'----- exit parameters
'
' t$ = final edited string (whatever name was passed as input to the function)
' exitCode indicates how editing was terminated -
'   0 = Enter, Tab, Down-Arrow, Right-Arrow past end, or field filled
'   1 = Shift-Tab, Up-Arrow, or Left-Arrow past beginning
'   2 = Esc key pressed
'
'----- local variables
'
' x$ is a copy of the string while being input or edited
' insert holds status of insert mode
' curPo holds current cursor position relative to the beginning of the line
' length keeps track of the current length of the string
' clr = 1 if the monitor is a color monitor, for setting cursor size
' a and a$ are temporary scratch variables
'
SUB TextIn (t$, max, numOnly, isCapsOn, exitCode, colr) STATIC

TInitialize:
  clr = 0                                      ' determine monitor type
  IF Peek1%(0, &H463) <> &HB4 THEN clr = 1
  x$ = t$                                      ' work on a copy of the string
' x$ = QPTrim$(t$)                             ' use this if the incoming string is fixed-length

TC:
  exitCode = 0: insrt = 0: curPo = 1           ' initialize flags
  length = LEN(x$)
  IF length > max THEN EXIT SUB                ' already to big to edit
  x$ = x$ + SPACE$(max - length)               ' pad with trailing spaces
  CALL QPrint(x$, colr, -1)
  LOCATE , , 1                                 ' turn on the cursor
  GOSUB TInsertOff                     ' set cursor size according to display
  
TGetKey:
  CALL CapNum                          ' display Cap/Num if active
  ' disallow insert if cursor past end
  IF curPo > length AND insrt <> 0 THEN GOSUB TInsertOff
  IF curPo > max GOTO TEnter           ' field is filled, handle as Enter key
  a$ = INKEY$
  IF a$ = "" GOTO TGetKey
  IF LEN(a$) = 1 GOTO TRegularKey
  a$ = RIGHT$(a$, 1)                   ' it was an extended key, get the code
  ON INSTR(CHR$(15) + ".GHKMOPRSstu" + CHR$(19), a$) GOTO TShiftTab, TClear, THome, TUp, TLeft, TRight, TEndKey, TDown, TIns, TDel, TCtrlLeft, TCtrlRight, TCtrlEnd, TRestore
  GOTO TGetKey                         ' none of the above, get again
  

TShiftTab:
  exitCode = 1                         ' user wants to go back a field
  GOTO TEnter                          ' handle as if it were the Enter key

TClear:
  x$ = ""                              ' Alt-C, erase the current string
  GOSUB TInsertOff                     ' clear insert mode and restore cursor
  LOCATE , POS(0) - (curPo - 1)
  GOTO TC                              ' and start all over again

THome:
  LOCATE , POS(0) - (curPo - 1)        ' put cursor at beginning of line
  curPo = 1                            ' show cursor as being on 1st character
  GOTO TGetKey
     
TUp:
  exitCode = 1                         ' user wants to go back a field
  GOTO TEnter                          ' handle as if it were the Enter key

TLeft:
  IF curPo = 1 GOTO TShiftTab          ' cursor is on the first character,
                                       ' handle as if it were a Shift-Tab
  curPo = curPo - 1                    ' update curPo
  LOCATE , POS(0) - 1                  ' back up the cursor
  GOTO TGetKey
     
TRight:
  curPo = curPo + 1                    ' update curPo
  LOCATE , POS(0) + 1                  ' advance the cursor on the screen
  GOTO TGetKey

TEndKey:
  LOCATE , POS(0) + (length - curPo) + 1 ' put cursor at the end of the line
  curPo = length + 1                   ' update curPo
  GOTO TGetKey
  
TDown:
  GOTO TEnter

TIns:
  IF insrt THEN                        ' insert is already on, turn it off
    GOSUB TInsertOff
    GOTO TGetKey
  END IF
  IF curPo > length GOTO TGetKey       ' ignore Ins if cursor is past the end
  IF length = max GOTO TGetKey         ' also ignore if field is full
  insrt = 1                            ' set the insert flag
  IF clr THEN                          ' set cursor size according to display
    LOCATE , , , 0, 7
  ELSE
    LOCATE , , , 0, 13
  END IF
  GOTO TGetKey
     
TDel:
  IF curPo > length GOTO TGetKey       ' ignore Del if cursor is past end
  ' slide all characters left one position, add a trailing space and re-print
  MID$(x$, curPo) = MID$(x$, curPo + 1) + " "
  CALL QPrint(MID$(x$, curPo), colr, -1)
  length = length - 1                  ' show string as one character shorter
  GOTO TGetKey
  
TCtrlLeft:
  IF curPo = 1 GOTO TGetKey            ' at the beginning, ignore
  a = curPo                            ' save cursor position
  ' we're within a word, find beginning
  IF MID$(x$, curPo - 1, 1) <> " " GOTO TSeekLeft2

TSeekLeft1:
  IF curPo = 1 GOTO TCtrlLeftExit      ' at the beginning, give up
  IF MID$(x$, curPo - 1, 1) = " " THEN
    curPo = curPo - 1
    GOTO TSeekLeft1                    ' seek previous non-blank character
  END IF

TSeekLeft2:
  IF curPo = 1 GOTO TCtrlLeftExit      ' at the beginning, give up
  IF MID$(x$, curPo - 1, 1) <> " " THEN
    curPo = curPo - 1
    GOTO TSeekLeft2                    ' seek character preceeded by a blank
  END IF

TCtrlLeftExit:
  LOCATE , POS(0) - (a - curPo)        ' position the cursor
  GOTO TGetKey

TCtrlRight:
  a = curPo                            ' save cursor position

TSeekRight1:
  IF a > length GOTO TGetKey           ' at the end, give up
  IF MID$(x$, a, 1) <> " " THEN
    a = a + 1                          ' consider next character
    GOTO TSeekRight1                   ' seek next blank space
  END IF

TSeekRight2:
  IF a > length GOTO TGetKey           ' at the end, give up
  IF MID$(x$, a, 1) = " " THEN
    a = a + 1                          ' consider next character
    GOTO TSeekRight2                   ' seek next non-blank character
  END IF
  LOCATE , POS(0) + (a - curPo)        ' position the cursor
  curPo = a                            ' show cursor as being on the next word
  GOTO TGetKey                         ' get another keypress

TCtrlEnd:
  IF curPo > length GOTO TGetKey       ' cursor is past the end, ignore
  CALL QPrint(SPACE$(length - curPo + 1), colr, -1)' blank from cursor to the end
  MID$(x$, curPo) = SPACE$(length - curPo + 1)     ' clear that part of the string
  length = curPo - 1                   ' show the length being at the cursor
  GOTO TGetKey                         ' get another keypress

TRestore:
  LOCATE , POS(0) - (curPo - 1)        ' locate cursor at beginning of line,
  GOTO TInitialize                     ' and start all over again

TRegularKey:
  IF a$ < " " THEN                     ' a control key
    ON INSTR(CHR$(8) + CHR$(9) + CHR$(13) + CHR$(27), a$) GOTO TBackspace, TTabKey, TEnter, TEscape
    GOTO TGetKey                       ' none of the above
  END IF
  IF isCapsOn THEN                     ' convert to upper case if requested
    IF a$ >= "a" AND a$ <= "z" THEN a$ = CHR$(ASC(a$) AND 95)
  END IF
  IF numOnly THEN                      ' disallow non-numeric if requested
    IF a$ < "0" OR a$ > "9" THEN
      PLAY "L16O3EC"
      GOTO TGetKey
    END IF
  END IF
  CALL QPrint(a$, colr, -1)            ' print character
  LOCATE , POS(0) + 1
  curPo = curPo + 1                    ' show cursor being ahead
  IF insrt GOTO THandleInsert
  MID$(x$, curPo - 1, 1) = a$          ' assign the character
  ' cursor is past end, increase length
  IF curPo > length + 1 THEN length = curPo - 1
  ' field complete, handle as Enter key
  IF length = max AND curPo > length GOTO TEnter
  GOTO TGetKey
  
THandleInsert:
  length = length + 1                  ' show string being 1 character longer
  Temp$ = MID$(x$, curPo - 1)          ' using Temp$ avoids a BASIC 7 bug
  MID$(x$, curPo) = Temp$              ' move characters one position ahead
  MID$(x$, curPo - 1, 1) = a$          ' assign the current character
  CALL QPrint(MID$(x$, curPo, length - curPo + 1), colr, -1)  ' re-print x$
  IF length = max GOTO TEnter          ' field complete, handle as Enter key
  GOTO TGetKey

TBackspace:
  IF curPo = 1 GOTO TGetKey            ' can't back up any more, ignore
  curPo = curPo - 1                    ' show cursor being 1 character before
  LOCATE , POS(0) - 1                  ' back up the cursor
  GOTO TDel                            ' handle as if it were the Delete key

TTabKey:                               ' reserved for your Tab routine if you
                                       ' want to handle it differently

TEnter:
  GOSUB TInsertOff                     ' clear insert, restore cursor size
  x$ = LEFT$(x$, length)               ' retain only the current length
  t$ = x$                              ' assign the string
  LOCATE , , 0                         ' turn off the cursor
  EXIT SUB

TEscape:
  exitCode = 2                         ' show that the user pressed Escape
  GOTO TEnter                          ' handle as if it were the Enter Key

TInsertOff:
  ' clear Insert mode and restore cursor, depending on monitor type
  insrt = 0
  IF clr THEN
    LOCATE , , , 6, 7
  ELSE
    LOCATE , , , 12, 13
  END IF
  RETURN

END SUB