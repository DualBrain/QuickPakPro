' ********** GETCOLOR.BAS - set of color functions

' Copyright (c) 1988 Ethan Winer
' Modifications (c) 2022 Cory Smith

DEFINT A-Z

'$INCLUDE: 'PRO.BI'

'_FULLSCREEN _SQUAREPIXELS

DECLARE SUB GetColor (fg, bg)           ' gets BASIC's current colors
DECLARE SUB SplitColor (xColor, fg, bg) ' .ASM - splits a color into FG and BG
DECLARE FUNCTION OneColor% (fg, bg)     ' .ASM - combines FG/BG into one color

CLS

INPUT "Enter a foreground color value (0 to 31): ", fg
INPUT "Enter a background color value (0 to 7) : ", bg
COLOR fg, bg

PRINT : PRINT "BASIC's current color settings are: ";
GetColor fg, bg
PRINT fg; "and"; bg

PRINT "That combines to the single byte value of"; OneColor%(fg, bg)
PRINT "Broken back out results in";
SplitColor OneColor%(fg, bg), newFG, newBG
PRINT newFG; "and"; newBG

COLOR 7, 0      ' restore defaults before ending

' This function obtains BASIC's current colors by first saving the
' character and color in the upper left corner of the screen.  Next,
' a blank space is printed there, and SCREEN is used to see what color
' was used.  Finally, the original screen contents are restored.
'
SUB GetColor (fg%, bg%) STATIC

  v% = CSRLIN                         ' save the current cursor location
  h% = POS(0)
  
  saveChar% = SCREEN(1, 1)            ' save the current character
  saveColor% = SCREEN(1, 1, 1)        ' and its color
  SplitColor saveColor%, saveFG%, saveBG%

  LOCATE 1, 1                         ' print with BASIC's current color
  PRINT " "; CHR$(29);                ' back up the cursor to 1,1
  curColor% = SCREEN(1, 1, 1)         ' read the current color
  COLOR saveFG%, saveBG%              ' restore the original color at 1,1
  PRINT CHR$(saveChar%);              ' and the character

  LOCATE v%, h%                       ' put the cursor back where it was
  SplitColor curColor%, fg%, bg%      ' split the color into separate FG & BG
  COLOR fg%, bg%                      ' restore BASIC's current value for it

END SUB

'$INCLUDE: 'PRO.BAS'