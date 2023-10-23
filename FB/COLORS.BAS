' ******** COLORS.BAS - prints a chart of the screen attributes for each color

' Copyright (c) 1988 Ethan Winer
' Modifications (c) 2023 Cory Smith

#INCLUDE "PRO.BI" ' OneColor, Peek1

' This chart provides a quick reference to the various "encoded" colors
' that are used with QPrint, APrint, and the other QuickPak video routines.
' To get a hard copy printout, press Shift-PrtSc once it is on your screen.

Dim colorMon As Short

FUNCTION FnPad (x As String) As String
  FnPad = SPACE$((7 - LEN(x)) / 2) + x   ' for centering
END FUNCTION

SCREEN 0 'CLS
IF Peek1(0, &H463) <> &HB4 THEN colorMon = 1          ' see what monitor is active
REM DEF FnPad$ (X$) = SPACE$((7 - LEN(X$)) / 2) + X$  ' for centering
Var mask = "  ###  "                                  ' for Print Using

DIM colr(8) As String                    ' the color names
FOR x As Short = 0 TO 8
    READ colr(x)
NEXT
DATA "Black", "Blue", "Green", "Cyan", "Red", "Magenta", "Brown", "White", "Gray"

LOCATE 2, 23
COLOR 9
PRINT "  Crescent Software Color Chart  "

FOR bg As Short = 0 TO 7

  LOCATE 5, 15 + bg * 8
  COLOR 7, 0
  PRINT FnPad(colr(bg))

  FOR fg As Short = 0 TO 15
    LOCATE 7 + fg, 1
	  COLOR 7, 0
  	IF fg <= 8 THEN
	    PRINT colr(fg);
	  ELSE
	    PRINT "Bright "; colr(fg - 8);
	  END IF

    LOCATE , 15 + bg * 8
    COLOR fg, bg
    PRINT USING mask; OneColor(fg, bg)

  NEXT
NEXT

COLOR 7, 0: LOCATE 7, 18: PRINT 0
IF colorMon THEN COLOR 8
LOCATE 15, 18: PRINT 8

WaitKey