' ***** MRANGE.BAS - demo for MouseRange assembler routine
'
' written by Jay Munro
' Copyright (c) 1989 Crescent Software
' Modifications (c) 2022 Cory Smith

DEFINT A-Z

'$INCLUDE: 'PRO.BI'

'_FULLSCREEN _SQUAREPIXELS

DECLARE FUNCTION Peek1% (segment, offset)   ' to check monitor type

CLS
CALL Initmouse(there)                   ' mouse initializing stuff
IF NOT there THEN                       ' no mouse installed
  BEEP                                  ' let them know                      
  PRINT "No mouse is installed, ending."
  END
END IF

fg = 0                                  ' initialize mouse cursor colors
bg = 7                                  ' these are for monochrome monitors

IF Peek1%(0, &H463) <> &HB4 THEN        ' if a color monitor, then set colors
  fg = -2                               ' for reverse of color cursor is over
  bg = -2
END IF

CALL TextCursor(FG, BG)                 ' set up our text cursor
COLOR 0, 7                              ' color for status box

REDIM mCoord(1 TO 8) AS Area

LOCATE 1, 20                               ' print the status box
PRINT "M-Row", "M-Col", "Button", "Box";   ' print the return parameters
LOCATE 25, 2
PRINT "Press button 1 in a colored box to see the action, press button 2 to end.";

FOR x = 1 TO 8                          ' get some data into it
  READ mCoord(x).Y1                     ' upper corners
  READ mCoord(x).X1
  READ mCoord(x).Y2                     ' lower corners
  READ mCoord(x).X2
  READ mCoord(x).RN                     ' area number
  ' === if there's a color display use PaintBox to color the boxes
  IF FG THEN CALL MPaintbox(mCoord(x).Y1, mCoord(x).X1, mCoord(x).Y2, mCoord(x).X2, 16 * x)
  CALL Box0(mCoord(x).Y1, mCoord(x).X1, mCoord(x).Y2, mCoord(x).X2, 1, -1)
  LOCATE mCoord(x).Y1, mCoord(x).X1, 0
  PRINT mCoord(x).RN;                   ' print the box number
  CALL Pause(3)                         ' pause for effect. . .
NEXT x
   
CALL ShowCursor

' === loop here until button 2 is pressed
WHILE button < 2
  CALL MouseRange(mCoord(), 1, 8, retRow, retCol, button, range)
  LOCATE 2, 20
  PRINT retRow, retCol, button, range;
WEND

' === if we got a valid range number then do some theatrics                          
IF range THEN
  CALL HideCursor                       ' hide cursor for this print
  CALL Box0(mCoord(range).Y1, mCoord(range).X1, mCoord(range).Y2, mCoord(range).X2, 1, 15 OR 128)
  LOCATE 24, 45
  PRINT "You Picked box number"; range;
  CALL ShowCursor                       ' restore cursor
END IF
COLOR 7, 0
CALL HideCursor
END

' =============================== Range Data areas ===========================
'     Y1   X1   Y2   X2  RN
DATA  1,   1,  10,  10,  1
DATA  4,   3,  17,  27,  2
DATA  5,  40,  18,  72,  3
DATA 15,  20,  22,  64,  4
DATA 19,  30,  24,  40,  5
DATA 13,  50,  20,  60,  6
DATA  7,  15,   9,  50,  7
DATA 10,  55,  15,  63,  8

'$INCLUDE: 'PRO.BAS'