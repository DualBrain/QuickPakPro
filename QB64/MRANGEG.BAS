'******** MRANGEG.BAS - tests MouseRangeG or MouseRangeG1 (see note below)

' Modifications (c) 2022 Cory Smith

DEFINT A-Z

'$INCLUDE: 'PRO.BI'

'_FULLSCREEN _SQUAREPIXELS

DECLARE SUB InitMouse (There)
DECLARE SUB MouseRangeG (SEG Element AS ANY, NumEls, Row, Column, Button, Range)
DECLARE SUB MouseRangeG1 (SEG Element AS ANY, NumEls, Row, Column, Button, Range)
DECLARE SUB ShowCursor ()

' TYPE Area
'   Y1 AS INTEGER
'   X1 AS INTEGER
'   Y2 AS INTEGER
'   X2 AS INTEGER
'   RN AS INTEGER
' END TYPE

SCREEN 9
CALL InitMouse(there)
IF NOT There THEN
  SCREEN 0
  PRINT "No mouse installed -- ending."
  END
END IF
CALL ShowCursor
LOCATE 20, 1
PRINT "Press button 1 in a colored box to see the action, press button 2 to end."

REDIM array(1 TO 5) AS Area
array(1).X1 = 0
array(1).Y1 = 0
array(1).X2 = 20
array(1).Y2 = 20
array(1).RN = -1

array(2).X1 = 21
array(2).Y1 = 0
array(2).X2 = 40
array(2).Y2 = 20
array(2).RN = -1

array(3).X1 = 41
array(3).Y1 = 0
array(3).X2 = 60
array(3).Y2 = 20
array(3).RN = -1

array(4).X1 = 61
array(4).Y1 = 0
array(4).X2 = 80
array(4).Y2 = 20
array(4).RN = -1

array(5).X1 = 81
array(5).Y1 = 0
array(5).X2 = 100
array(5).Y2 = 20
array(5).RN = -1

FOR i = 1 TO 5
  LINE (array(i).X1, array(i).Y1)-(array(i).X2, array(i).Y2), i, BF
NEXT

DO
  ' to test the "1" version unREM the line below and REM out the next line
  'CALL MouseRangeG1(array(), 1, 5, r, c, button, rNum)
  CALL MouseRangeG(array(), 1, 5, r, c, button, rNum)
  LOCATE 10, 1
  PRINT r, c, button, rNum
  IF button > 1 THEN END
LOOP

'$INCLUDE: 'PRO.BAS'