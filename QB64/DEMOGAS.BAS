' ********** DEMOGAS.BAS - shows GasGauge in use

' Copyright (c) 1992 Ethan Winer
' Modifications (c) 2022 Cory Smith

DEFINT A-Z

'$INCLUDE: 'PRO.BI'

'_FULLSCREEN _SQUAREPIXELS

DECLARE SUB GasGauge (min, max, value, wide, colr)

CLS                             ' start with a clean slate
wide = 70                       ' specify the gauge width including the border
min = 1: max = 100              ' the upper/lower bounds, ANY integers okay
colr = 79                       ' the color
LOCATE 18, 5, 0                 ' the upper left corner of the gauge display

FOR x = min TO max
  'LOCATE 1, 1: PRINT X: LOCATE 18, 5, 0
  CALL GasGauge(min, max, x, wide, colr)
  CALL Pause(1)                 ' pause so we can see it work
NEXT

'$INCLUDE: 'GASGAUGE.BAS'
'$INCLUDE: 'PRO.BAS'