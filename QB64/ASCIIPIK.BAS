' ********** ASCIIPIK.BAS - demos ASCIIPick

' Copyright (c) 1988 Crescent Software
' Modifications (c) 2022 Cory Smith

DEFINT A-Z

'$INCLUDE: 'PRO.BI'

'_FULLSCREEN _SQUAREPIXELS

CLS
CALL InitMouse(x)
CALL TextCursor(112, 0)
CALL ShowCursor

x = 65                  ' start by highlighting "A"
normColr = 2            ' use a green color
hiColor = 112 + 128     ' use flashing inverse for the selected character
LOCATE 2, 3

' ----- going in, if exitCode = -1, then just display the chart and return
CALL MASCIIPick(x, normColr, hiColor, exitCode)
' ----- coming out, exitCode = 0 if Enter, or 2 if Escape (Escape also ignores)

LOCATE 21, 1
PRINT "You picked character"; x
IF exitCode = 2 THEN PRINT "You pressed Escape";

'$INCLUDE: 'PRO.BAS'