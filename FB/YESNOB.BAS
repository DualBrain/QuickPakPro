' ********** YESNOB.BAS - BASIC yes/no input subprogram

' Copyright (c) 1987 Ethan Winer
' Modifications (c) 2023 Cory Smith

#INCLUDE ONCE "PRO.BI" ' QPrint

DECLARE SUB CapNum () ' CAPNUM.BAS

'----- entry parameters
'
'yn = string to be input or edited (use the name of your choice)
'colr is the combined foreground and background colors that will be used
'
'----- exit parameters
'
'yn  = final edited amount
'exitCode indicates how editing was terminated -
'   0 = Enter, Tab, Down-Arrow, Right-Arrow past end, or field filled
'   1 = Shift-Tab, Up-Arrow, or Left-Arrow past beginning
'   2 = Escape key pressed
'
'----- local variables
'
'result is a string version of the number while it is being input or edited
'
SUB YesNoB (Byref yn As String, Byref exitCode As Short, colr As Short) STATIC

  Dim result As String

  exitCode = 0                                 'initialize flag

  result = yn
  IF result = "" THEN result = " "
  QPrint result, Colr, -1
  LOCATE , , 1

YGetKey:
  CapNum                                  'print Cap/Num if active
  result = INKEY$
  IF result = "" GOTO YGetKey

  IF UCASE$(result) = "Y" OR UCASE$(result) = "N" GOTO YDone

  IF result = CHR$(9) OR result = CHR$(13) GOTO YD2    'Tab or Enter
  IF result = CHR$(27) THEN                        'Escape
    exitCode = 2
    GOTO YD2
  END IF

  IF LEN(result) = 2 THEN                          'extended key
    result = RIGHT$(result, 1)
    IF result = "P" OR result = "M" THEN GOTO YD2     'Down arrow, Right arrow
    IF result = "H" OR result = "K" OR result = CHR$(15) THEN
      exitCode = 1                           'Up, Left, Shift-Tab
      GOTO YD2
    END IF
  END IF

  GOTO YGetKey
  
YDone:
  IF result > "Y" THEN result = CHR$(ASC(result) - 32)     'capitalize if necessary
  yn = result
  QPrint yn, colr, -1

YD2:
  LOCATE , , 0

END SUB