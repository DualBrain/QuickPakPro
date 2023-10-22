' ********** CALC.BAS - pop-up calculator from BASIC
' Copyright (c) 1988 Don Resnick
' Copyright (c) 1988 Crescent Software
' Modifications (c) 2023 Cory Smith

'----- BASIC subprograms
DECLARE SUB TextEntry (colr As Short, Byref exitCode As Short, number As String, row As Short, col As Short)
DECLARE SUB Calc (ulRow As Short, ulCol As Short, fg As Short, bg As Short)

#INCLUDE "PRO.BI" ' Box, ClearScr, PaintBox, QPrint0, ReadScrn0, ScrnSave0, ScrnRest0, ScrollU, PRNReady, OneColor

SUB Calc_DisplayResult(Byref row As Short, Byref leftCol As Short, Byref firstRow as Short, Byref colr As Short, Byref result As Double, Byref zeroFlag As Short, Byref f7 As Short)

  LOCATE row + 1, leftCol + 3
  IF row + 1 = firstRow THEN                  'don't print = first row
    QPrint0 " ", colr
  ELSE
    QPrint0 "=", colr
  END IF

  LOCATE , POS(0) + 1                         'go to next column
  IF result > 9.99E+10 THEN                  'largest result possible
    'PLAY "L16N40N36"
    QPrint0 "%%%%%%%%%%%%%%", colr
  ELSE
    IF NOT zeroFlag THEN
      PRINT USING "###########.##"; result; 'print result, then paint
    ELSE
      QPrint0 "             �", colr   'display infinity
    END IF
    PaintBox row + 1, leftCol + 2, row + 1, leftCol + 19, colr, -1
  END IF

  IF f7 THEN
    IF row + 1 = firstRow THEN               'don't print = first row
      REM LPRINT TAB(9); "  ";
    ELSE
      REM LPRINT TAB(9); "= ";
    END IF
    IF NOT zeroFlag THEN
      REM LPRINT USING "###########.## *"; result
    ELSE
      REM LPRINT "             �"
    END IF
  END IF

END SUB

SUB Calc_PrintOperator(Byref row As Short, Byref k As String, Byref prompt As String, Byref botmRow As Short, Byref topRow As Short, Byref leftCol As Short, Byref rightCol As Short, Byref newRow As Short, Byref colr As Short, Byref f7 As Short)

  row = row + 2: k = prompt
  IF row > botmRow - 2 THEN                   'scroll if at bottom of window
    ScrollU topRow + 2, leftCol + 1, botmRow - 1, rightCol - 1, 2, -1
    row = botmRow - 2                        'adjust to new row
  END IF

  IF row < botmRow - 2 THEN                   'row for new operator
    newRow = row
  ELSE
    newRow = botmRow - 2
  END IF

  LOCATE newRow, leftCol + 3
  QPrint0 prompt, colr                      'print operator
  REM IF f7 THEN LPRINT TAB(9); prompt;

END SUB

SUB Calc (topRow As Short, leftCol As Short, cf As Short, cb As Short) 'STATIC

  Dim operand As Double
  Dim result As Double
  Dim row As Short, col As Short
  Dim zeroFlag As Short
  Dim k As String, prompt As String, printerStatus As Short
  Dim xCod As Short, f7 As Short
  Dim number As String
  Dim botmRow As Short, rightCol As Short, firstRow As Short, colr As Short, newRow As Short

  Var oldRow = CSRLIN: Var oldCol = POS(0)            'save cursor position
  botmRow = topRow + 17                       'calc bottom row from top row
  rightCol = leftCol + 21                     'ditto for right column
  firstRow = topRow + 2                       'first row for data entry
  colr = OneColor(cf, cb)                    'combine colors into one byte
  
  'CalcWndo() holds the saved screen under the calculator
  DIM calcWndo(((botmRow - topRow + 1) * (rightCol - leftCol + 1)) * 2) As Short
  ScrnSave0 topRow, leftCol, botmRow, rightCol, @calcWndo(0)
  
  ClearScr topRow, leftCol, botmRow, rightCol, colr, -1 'clear window
  Box topRow, leftCol, botmRow, rightCol, 2, colr, -1   'make a box
  
  Var title = CHR$(181) + " Calculator " + CHR$(198)                   'change this if you'd like
  LOCATE topRow, ((rightCol - leftCol + 1) / 2 - LEN(title) / 2) + leftCol
  QPrint0 title, colr

  LOCATE botmRow, leftCol + 2
  QPrint0 CHR$(181) + " F7 for Printer " + CHR$(198), colr
  f7 = 0                                      'F7 flags if also LPRINTing

Init:
  operand = 0: result = 0: row = firstRow

Begin:
  col = leftCol + 5
  LOCATE , , 1
  zeroFlag = 0                                'clear "divide by zero" flag
  
  TextEntry 112, xCod, number, row, col 'use inverse colors

  operand = VAL(number)

  SELECT CASE xCod                            'TextEntry returns XCod
    CASE 7                                    'check if printer is on
      IF f7 = 0 THEN                          '----------------------
        DO
          k = INKEY$
          Var printerStatus = PRNReady(1)
          LOCATE botmRow, leftCol + 2, 0
          QPrint0 CHR$(181) + " Turn printer on " + CHR$(198), colr
          IF k <> "" THEN EXIT DO            'any key to exit loop
        LOOP WHILE printerStatus = 0          'keep checking printer
        IF k = "" THEN
          f7 = 1                              'turn printer flag on
          LOCATE botmRow, leftCol + 2
          QPrint0 STRING$(5, 205) + CHR$(181) + " Print " + CHR$(198) + STRING$(5, 205), colr
        END IF
      ELSE
        f7 = 0                                'turn printer flag off
        LOCATE botmRow, leftCol + 2
        QPrint0 CHR$(181) + " F7 for Printer " + CHR$(198), colr
      END IF
      GOTO Begin

    CASE 27
      GOTO QuitCalc                           'get operator for display

    CASE 1
      prompt = "+"                                'add

    CASE 2
      prompt = "-"                                'subtract

    CASE 3
      prompt = "*"                                'multiply

    CASE 4
      prompt = "/"                                'divide

    CASE 13, 5
      prompt = "="                                'result

    CASE ELSE
  END SELECT

  LOCATE row, leftCol + 5                     'print operand
  PRINT USING "##########.##"; operand;      'then paint in chosen color
  PaintBox row, leftCol + 3, row, leftCol + 19, colr, -1
  REM IF f7 THEN LPRINT TAB(12); USING "##########.##"; operand

  IF row = firstRow THEN                      'must handle first entry
    result = operand: operand = 0        '  differently from rest
    k = prompt: row = firstRow - 1
    'GOSUB DisplayResult
    Calc_DisplayResult row, leftCol, firstRow, colr, result, zeroFlag, f7
    'GOSUB PrintOperator
    Calc_PrintOperator row, k, prompt, botmRow, topRow, leftCol, rightCol, newRow, colr, f7
    GOTO Begin
  END IF

  SELECT CASE k                              'perform calculation
    CASE "+"
      result = result + operand
    CASE "-"
      result = result - operand
    CASE "*"
      result = result * operand
    CASE "/"
      IF operand <> 0 THEN                 'trap "divide by zero"
        result = result / operand         'okay to divide
      ELSE
        result = 0                         'clear the result
        zeroFlag = -1                        'flag it for display routine
      END IF
    CASE "="
      'GOSUB DisplayResult
      Calc_DisplayResult row, leftCol, firstRow, colr, result, zeroFlag, f7
      GOTO StopCalc
    CASE ELSE
  END SELECT

  'GOSUB DisplayResult
  Calc_DisplayResult row, leftCol, firstRow, colr, result, zeroFlag, f7
  IF xCod = 13 OR xCod = 5 GOTO StopCalc
  'GOSUB PrintOperator
  Calc_PrintOperator row, k, prompt, botmRow, topRow, leftCol, rightCol, newRow, colr, f7
  GOTO Begin

' DisplayResult:
'   LOCATE row + 1, leftCol + 3
'   IF row + 1 = firstRow THEN                  'don't print = first row
'     QPrint0 " ", colr
'   ELSE
'     QPrint0 "=", colr
'   END IF

'   LOCATE , POS(0) + 1                         'go to next column
'   IF result > 9.99E+10 THEN                  'largest result possible
'     'PLAY "L16N40N36"
'     QPrint0 "%%%%%%%%%%%%%%", colr
'   ELSE
'     IF NOT zeroFlag THEN
'       PRINT USING "###########.##"; result; 'print result, then paint
'     ELSE
'       QPrint0 "             " + CHR$(236), colr   'display infinity
'     END IF
'     PaintBox row + 1, leftCol + 2, row + 1, leftCol + 19, colr, -1
'   END IF

'   IF f7 THEN
'     IF row + 1 = firstRow THEN               'don't print = first row
'       REM LPRINT TAB(9); "  ";
'     ELSE
'       REM LPRINT TAB(9); "= ";
'     END IF
'     IF NOT zeroFlag THEN
'       REM LPRINT USING "###########.## *"; result
'     ELSE
'       REM LPRINT "             " + CHR$(236)
'     END IF
'   END IF
' RETURN

' PrintOperator:
'   row = row + 2: k = prompt
'   IF row > botmRow - 2 THEN                   'scroll if at bottom of window
'     ScrollU topRow + 2, leftCol + 1, botmRow - 1, rightCol - 1, 2, -1
'     row = botmRow - 2                        'adjust to new row
'   END IF

'   IF row < botmRow - 2 THEN                   'row for new operator
'     newRow = row
'   ELSE
'     newRow = botmRow - 2
'   END IF

'   LOCATE newRow, leftCol + 3
'   QPrint0 prompt, colr                      'print operator
'   REM IF f7 THEN LPRINT TAB(9); prompt;
' RETURN

StopCalc:                                       'end the calculation
  LOCATE botmRow, leftCol + 1, 0              'can either start another
  QPrint0 CHR$(181) + "(A)nother / (Q)uit" + CHR$(198), colr  'or quit out of calculator

  prompt = UCASE$(INKEY$)
  WHILE prompt = ""
    prompt = UCASE$(INKEY$)
    IF prompt = "Q" OR prompt = CHR$(27) THEN
      GOTO QuitCalc
    ELSEIF prompt = "A" THEN
      ClearScr topRow + 1, leftCol + 1, botmRow - 1, rightCol - 1, Colr, -1
      LOCATE botmRow, leftCol + 1
      QPrint0 CHR$(205) + CHR$(181) + " F7 for Printer " + CHR$(198) + CHR$(205), colr
      GOTO Init
    ELSE
      prompt = ""
    END IF
  WEND

QuitCalc:
  ScrnRest0 topRow, leftCol, botmRow, rightCol, @calcWndo(0)
  ERASE calcWndo
  LOCATE oldRow, oldCol               'restore original cursor position

END SUB

SUB TextEntry (colr As Short, Byref exitCode As Short, Byref number As String, row As Short, col As Short) 'STATIC

  Var EXTCHAR = CHR$(255) ' CHR$(0) <--- AGAIN!!!! Why!?!? Just why??

  Dim k As String, w As Short

  Var begCol = Col: Var endCol = begCol + 12
  Var insFlag = 7                                 'use scan lines to flag Insert

  LOCATE row, Col, 0
  QPrint0 SPACE$(13), colr              'print entry window

StartPass:
  number = SPACE$(endCol - begCol + 1)       'read current line directly
  ReadScrn0 row, begCol, number        '  of the screen

CheckLimits:                                    'stay within window
  IF col > endCol THEN col = endCol
  IF col < begCol THEN col = begCol

  LOCATE row, col, 1, insFlag, 7

  DO                                  'get a key press
    k = INKEY$
  LOOP UNTIL LEN(k)

  IF INSTR("+-/*=", k) > 0 THEN      'look for operator
    SELECT CASE k                   'calculator key entries
      CASE "+"
        exitCode = 1
      CASE "-"
        exitCode = 2
      CASE "*"
        exitCode = 3
      CASE "/"
        exitCode = 4
      CASE "="
        exitCode = 5
    END SELECT
    GOTO EndText
  END IF
                                      
  IF k = EXTCHAR + CHR$(65) THEN     'F7 - send to printer
    exitCode = 7
    GOTO EndText
  END IF
                                                                          
  IF k = EXTCHAR + CHR$(79) THEN     'End
    FOR w As Short = LEN(number) TO 1 STEP -1
      IF MID$(number, w, 1) <> " " THEN EXIT FOR
    NEXT
    col = w + begCol
    GOTO StartPass
  END IF

  IF k = EXTCHAR + CHR$(71) THEN     'Home
    col = begCol
    GOTO StartPass
  END IF

  IF k = EXTCHAR + CHR$(82) THEN     'Insert
    IF insFlag = 0 THEN
      insFlag = 7
    ELSE
      insFlag = 0
    END IF
    LOCATE , , , insFlag, 7
  END IF

  IF k = EXTCHAR + CHR$(83) THEN     'Delete
    LOCATE row, col
    QPrint0 RIGHT$(number, endCol - col) + " ", colr
    GOTO StartPass
  END IF
                                      'Arrow keys
  IF k = EXTCHAR + CHR$(77) THEN col = col + 1       'Right
  IF k = EXTCHAR + CHR$(75) THEN col = col - 1       'Left
  
  IF LEN(k) = 2 GOTO CheckLimits

  IF k = CHR$(27) THEN               'Escape
    exitCode = 27
    GOTO EndText
  END IF
              
  IF k = CHR$(13) THEN               'Enter
    exitCode = 13
    GOTO EndText
  END IF

  IF k = CHR$(8) THEN                'Backspace
    IF col = begCol THEN
      GOTO StartPass
    ELSEIF col = endCol THEN
      IF SCREEN(row, col) = 32 THEN col = col - 1
      LOCATE row, col
      QPrint0 " ", colr
      GOTO StartPass
    ELSE
      LOCATE row, col - 1
      QPrint0 " ", colr
      col = col - 1
      GOTO StartPass
    END IF
  END IF

PrintText:
  IF (k < "0" OR k > "9") AND k <> "." GOTO StartPass 'trap non-digits

  LOCATE row, col
  QPrint0 k, colr
  col = col + 1
  IF insFlag = 0 THEN
    IF col <> endCol + 1 THEN
      LOCATE row, col
      QPrint0 MID$(number, col - begCol, endCol - col), colr
    END IF
  END IF
  GOTO StartPass

EndText:
  IF VAL(number) > 1E+10 THEN
    'PLAY "L16N40N36"
    GOTO CheckLimits
  END IF

END SUB