'******* COLORPIK.BAS - demos the assembler ColorPick and MColorPick routines

' Copyright (c) 1989 Crescent Software
' Modifications (c) 2022 Cory Smith

DEFINT A-Z

'$INCLUDE: 'PRO.BI'

'_FULLSCREEN _SQUAREPIXELS

CLS
boxColor = 113          ' the color of the surrounding box
colr = 1                ' start by highlighting color 1
LOCATE 2, 20, 0
CALL MColorPick(colr, boxColor, exitCode)

LOCATE 22, 1
IF exitCode = 0 THEN
  PRINT "You picked color"; colr
ELSE
  PRINT "You pressed Escape"
END IF

'$INCLUDE: 'PRO.BAS'