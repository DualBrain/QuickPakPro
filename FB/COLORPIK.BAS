' ******* COLORPIK.BAS - demos the assembler ColorPick and MColorPick routines

' Copyright (c) 1989 Crescent Software
' Modifications (c) 2023 Cory Smith

#INCLUDE "PRO.BI" ' MColorPick

Dim boxColor As Short, colr As Short, exitCode As Short

SCREEN 0 'CLS
boxColor = 113          'the color of the surrounding box
colr = 1                'start by highlighting color 1
LOCATE 2, 20, 0
MColorPick colr, boxColor, exitCode

LOCATE 22, 1
IF exitCode = 0 THEN
  PRINT "You picked color "; colr
ELSE
  PRINT "You pressed Escape"
END IF

WaitKey