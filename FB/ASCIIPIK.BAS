' ********** ASCIIPIK.BAS - demos ASCIIPick
' Copyright (c) 1988 Crescent Software
' Modifications (c) 2023 Cory Smith

#INCLUDE "PRO.BI"

Dim x As Short, normColr As Short, hiColor As Short
Dim exitCode As Short

'CLS
SCREEN 0
InitMouse x
TextCursor 112, 0
ShowCursor

x = 65                  'start by highlighting "A"
normColr = 2            'use a green color
hiColor = 112 + 128     'use flashing inverse for the selected character
LOCATE 2, 3

'----- going in, if ExitCode = -1, then just display the chart and return
MASCIIPick x, normColr, hiColor, exitCode
'----- coming out, ExitCode = 0 if Enter, or 2 if Escape (Escape also ignores)

LOCATE 21, 1
PRINT "You picked character"; x
IF exitCode = 2 THEN PRINT "You pressed Escape";
