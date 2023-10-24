' ********** DATEIN.BAS - date input routine

' Copyright (c) 1987 Ethan Winer
' Modifications (c) 2023 Cory Smith

#INCLUDE "PRO.BI" ' QPrint

DECLARE SUB CapNum
DECLARE SUB DateIn (Byref dt As String, Byref exitCode As Short, colr As Short)

' Dim dt As String
' Dim exitCode As Short
' DateIn dt, exitCode, OneColor(1, 5)
' PRINT: PRINT dt, exitCode
' WaitKey

' ----- entry parameters
'
' Dt$ = date to be input or edited (use the name of your choice)
' Colr is the combined foreground and background colors that will be used
'
' ----- exit parameters
'
' Dt$ = final edited date
' ExitCode indicates how editing was terminated -
'   0 = Enter, Tab, Down-Arrow, Right-Arrow past end, or field filled
'   1 = Shift-Tab, Up-Arrow, or Left-Arrow past beginning
'   2 = Esc key pressed
'
' ----- local variables
'
' X$ is the date being edited
' Curpo holds current cursor position relative to the beginning of the line
' Place indicates where to put the cursor if the entered date is invalid
' A$ is a temporary scratch variable
'
SUB DateIn (Byref dt As String, Byref exitCode As Short, colr As Short) STATIC

  Dim result As String, curPo As Short, k As String, place As Short

  result = dt                             ' assign temporary work string

DInitialize:

  exitCode = 0
  curpo = 1

  IF result = "" THEN result = SPACE$(6)       'new string - fill with blanks
  IF LEN(result) <> 6 THEN EXIT SUB        'invalid date

  result = LEFT$(result, 2) + "/" + MID$(result, 3, 2) + "/" + RIGHT$(result, 2)
  QPrint result, Colr, -1            'print the date
  LOCATE , , 1                         'turn on the cursor

DGetKey:
  CapNum                          'display Cap/Num if active
  IF curPo = 9 GOTO DEnter             'the cursor is past the end, all done

  k = INKEY$
  IF k = "" GOTO DGetKey
  IF LEN(k) = 1 GOTO DRegularKey

  k = RIGHT$(k, 1)                   'it was an extended key, get the code
  ON INSTR(CHR$(15) + ".HKMP", k) GOTO DShiftTab, DClear, DUp, DLeft, DRight, DDown
  GOTO DGetKey                         'none of the above, get again

DShiftTab:                              'put your own Shift-Tab handler here
                                        '  if you'd like
DUp:
  exitCode = 1                         'user wants to go back a field
  GOTO DEnter                          'handle as if it were the Enter key

DClear:
  result = ""                              'Alt-C, clear the date
  LOCATE , POS(0) - (curPo - 1)        'put the cursor at beginning of field
  GOTO DInitialize                     'and do it all over again

DLeft:
  IF curPo = 1 GOTO DShiftTab          'cursor is on the first character,
                                        'handle as if it were a Shift-Tab
  curPo = curPo - 1                    'update Curpo
  LOCATE , POS(0) - 1                  'back the cursor up one

  IF curPo = 3 OR curPo = 6 THEN
    curPo = curPo - 1
    LOCATE , POS(0) - 1
  END IF

  GOTO DGetKey

DRight:
  IF curPo = 8 GOTO DEnter             'cursor is past the end, exit

  curPo = curPo + 1                    'update Curpo
  LOCATE , POS(0) + 1                  'advance the cursor

  IF curPo = 3 OR curPo = 6 THEN       'one more if we're crossing a slash
    curPo = curPo + 1
    LOCATE , POS(0) + 1
  END IF

  GOTO DGetKey

DDown:
  GOTO DEnter                          'treat a down arrow as Enter

DRegularKey:
  IF k < " " THEN                     'a control key
    ON INSTR(CHR$(8) + CHR$(9) + CHR$(13) + CHR$(27), k) GOTO DBackSpace, DTabKey, DEnter, DEscape
    GOTO DGetKey                      'none of the above
  END IF
  
  'ignore if not a valid digit
  IF k <> " " AND (k < "0" OR k > "9") GOTO DGetKey

  QPrint k, Colr, -1            'print the digit
  LOCATE , POS(0) + 1                  'advance the cursor
  MID$(result, curPo, 1) = k              'assign it to the string

  curPo = curPo + 1                    'show the cursor advancing one digit
  IF curPo = 3 OR curPo = 6 THEN
    curPo = curPo + 1
    LOCATE , POS(0) + 1
  END IF

  GOTO DGetKey
  
DBackSpace:
  GOTO DLeft                           'handle as a Left-Arrow

DTabKey:                                'add your own Tab handler if needed

DEnter: 
  GOTO DCheckMonth

DEscape:
  exitCode = 2
  GOTO DEnter
       
DCheckMonth:
  IF result = "  /  /  " GOTO DDone        'blank is okay

  'if month is valid, keep checking
  IF LEFT$(result, 2) > "00" AND LEFT$(result, 2) < "13" GOTO DCheckDay

  place = 1
  GOTO DBadDate                        'error, show where to place the cursor

DCheckDay:
  'if day is valid, keep checking.
  IF MID$(result, 4, 2) > "00" AND MID$(result, 4, 2) < "32" GOTO DCheckYear
                                       'You could get fancy here for February
  place = 4: GOTO DBadDate             'error, show where to place the cursor

DCheckYear:
  'IF RIGHT$(result, 2) = "00" GOTO DDone   'year is valid, all done
  'place = 7                            'error, show where to place the cursor
  'GOTO DBadDate
  GOTO DDone            'REMmed and added 11-28-95

DBadDate:
  LOCATE , POS(0) - (curPo - 1)        'first move the cursor to the beginning
  PRINT STRING$(place - 1, 28);        'now move the cursor to the bad place
  curPo = place                        'show the cursor as being there

  REM PLAY "L16O3EC"                       'sound the chime
  exitCode = 0                         'reset ExitCode
  GOTO DGetKey

DDone:
  dt = LEFT$(result, 2) + MID$(result, 4, 2) + RIGHT$(result, 2)
  COLOR 7, 0                           'restore the color
  LOCATE , , 0

END SUB