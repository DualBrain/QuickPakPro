' ********** DATEIN.BAS - date input routine

' Copyright (c) 1987 Ethan Winer
' Modifications (c) 2022 Cory Smith

DEFINT A-Z

DECLARE SUB CapNum ()
DECLARE SUB QPrint (txt$, colr, page)

'----- entry parameters
'
' dt$ = date to be input or edited (use the name of your choice)
' colr is the combined foreground and background colors that will be used
'
'----- exit parameters
'
' dt$ = final edited date
' exitCode indicates how editing was terminated -
'   0 = Enter, Tab, Down-Arrow, Right-Arrow past end, or field filled
'   1 = Shift-Tab, Up-Arrow, or Left-Arrow past beginning
'   2 = Esc key pressed
'
'----- local variables
'
' x$ is the date being edited
' curPo holds current cursor position relative to the beginning of the line
' place indicates where to put the cursor if the entered date is invalid
' a$ is a temporary scratch variable
'
SUB DateIn (dt$, exitCode, colr) STATIC

  x$ = dt$                             ' assign temporary work string

DInitialize:
  exitCode = 0
  curPo = 1
  IF x$ = "  /  /  " THEN BEEP: x$ = SPACE$(6)
  IF x$ = "" THEN x$ = SPACE$(6)       ' new string - fill with blanks
  IF LEN(x$) <> 6 THEN EXIT SUB        ' invalid date
  x$ = LEFT$(x$, 2) + "/" + MID$(x$, 3, 2) + "/" + RIGHT$(x$, 2)
  CALL QPrint(x$, colr, -1)            ' print the date
  LOCATE , , 1                         ' turn on the cursor

DGetKey:
  CALL CapNum                          ' display Cap/Num if active
  IF curPo = 9 GOTO DEnter             ' the cursor is past the end, all done
  a$ = INKEY$
  IF a$ = "" GOTO DGetKey
  IF LEN(a$) = 1 GOTO DRegularKey
  a$ = RIGHT$(a$, 1)                   ' it was an extended key, get the code
  ON INSTR(CHR$(15) + ".HKMP", a$) GOTO DShiftTab, DClear, DUp, DLeft, DRight, DDown
  GOTO DGetKey                         ' none of the above, get again

DShiftTab:                             ' put your own Shift-Tab handler here
                                       ' if you'd like

DUp:
  exitCode = 1                         ' user wants to go back a field
  GOTO DEnter                          ' handle as if it were the Enter key

DClear:
  x$ = ""                              ' Alt-C, clear the date
  LOCATE , POS(0) - (curPo - 1)        ' put the cursor at beginning of field
  GOTO DInitialize                     ' and do it all over again

DLeft:
  IF curPo = 1 GOTO DShiftTab          ' cursor is on the first character,
                                       ' handle as if it were a Shift-Tab
  curPo = curPo - 1                    ' update curPo
  LOCATE , POS(0) - 1                  ' back the cursor up one
  IF curPo = 3 OR curPo = 6 THEN
    curPo = curPo - 1
    LOCATE , POS(0) - 1
  END IF
  GOTO DGetKey

DRight:
  IF curPo = 8 GOTO DEnter             ' cursor is past the end, exit
  curPo = curPo + 1                    ' update curPo
  LOCATE , POS(0) + 1                  ' advance the cursor
  IF curPo = 3 OR curPo = 6 THEN       ' one more if we're crossing a slash
    curPo = curPo + 1
    LOCATE , POS(0) + 1
  END IF
  GOTO DGetKey

DDown:
  GOTO DEnter                          ' treat a down arrow as Enter

DRegularKey:
  IF a$ < " " THEN                     ' a control key
    ON INSTR(CHR$(8) + CHR$(9) + CHR$(13) + CHR$(27), a$) GOTO DBackSpace, DTabKey, DEnter, DEscape
    GOTO DGetKey                       ' none of the above
  END IF
  ' ignore if not a valid digit
  IF a$ <> " " AND (a$ < "0" OR a$ > "9") GOTO DGetKey
  CALL QPrint(a$, colr, -1)            ' print the digit
  LOCATE , POS(0) + 1                  ' advance the cursor
  MID$(x$, curPo, 1) = a$              ' assign it to the string
  curPo = curPo + 1                    ' show the cursor advancing one digit
  IF curPo = 3 OR curPo = 6 THEN
    curPo = curPo + 1
    LOCATE , POS(0) + 1
  END IF
  GOTO DGetKey
  
DBackSpace:
  GOTO DLeft                           ' handle as a Left-Arrow

DTabKey:                               ' add your own Tab handler if needed

DEnter: 
  GOTO DCheckMonth

DEscape:
  exitCode = 2
  GOTO DEnter
       
DCheckMonth:
  IF x$ = "  /  /  " GOTO DDone        ' blank is okay
  ' if month is valid, keep checking
  IF LEFT$(x$, 2) > "00" AND LEFT$(x$, 2) < "13" GOTO DCheckDay
  place = 1
  GOTO DBadDate                        ' error, show where to place the cursor

DCheckDay:
  ' if day is valid, keep checking.
  IF MID$(x$, 4, 2) > "00" AND MID$(x$, 4, 2) < "32" GOTO DCheckYear
                                       ' You could get fancy here for February
  place = 4: GOTO DBadDate             ' error, show where to place the cursor

DCheckYear:
  'IF RIGHT$(x$, 2) = "00" GOTO DDone   ' year is valid, all done
  'place = 7                            ' error, show where to place the cursor
  'GOTO DBadDate
  GOTO DDone            ' REMmed and added 11-28-95

DBadDate:
  LOCATE , POS(0) - (curPo - 1)        ' first move the cursor to the beginning
  PRINT STRING$(place - 1, 28);        ' now move the cursor to the bad place
  curPo = place                        ' show the cursor as being there
  PLAY "L16O3EC"                       ' sound the chime
  exitCode = 0                         ' reset exitCode
  GOTO DGetKey

DDone:
  dt$ = LEFT$(x$, 2) + MID$(x$, 4, 2) + RIGHT$(x$, 2)
  COLOR 7, 0                           ' restore the color
  LOCATE , , 0

END SUB