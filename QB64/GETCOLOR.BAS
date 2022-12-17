' ********** GETCOLOR.BAS - set of color functions

' Copyright (c) 1988 Ethan Winer
' Modifications (c) 2022 Cory Smith

' **************************
' * BOILER PLATE BEGIN
' **************************
$Resize:Stretch
CHDIR _STARTDIR$ ' Moved this line above resize to (hopefully) give more init time to window
IF _DesktopHeight => 2160 THEN mult = 4 ELSE IF _DesktopHeight => 1440 THEN mult = 2 ELSE mult = 1
DO: LOOP UNTIL _SCREENEXISTS ' Not sure if necessary; however, there does seem to be some sort of timing issue around getting hwnd
hwnd = _WindowHandle: x = 100: y = 100: w = 640 * mult: h = 480 * mult ' inlined _WindowHandle (next line) because 1 out of every 4 or 5 executions, would encounter an invalid window handle (1400)
IF INSTR(_OS$, "[WINDOWS]") THEN success = MoveWindow(_WindowHandle, x, y, w, h, 1) ELSE success = -1 ' Now that _WindowHandle is inlined, invalid window handle (1400) issue has yet to be reproduced - will have to continue to test
IF success = 0 THEN PRINT "FAILED TO RESIZE - "; GetLastError; " ("; hwnd; ")": CALL WaitKeyS
_TITLE "GETCOLOR" 'NOTE: Moving title above resize causes resize to fail (without an error???)
'BUG: It would be nice specify the icon here, but... having to require full path or placing it in the qb64 folder is problematic. 
'NOTE: The above boiler plate must be first in execution (top of file).
'BUG:  Also appears to not work as an $INCLUDE; suggesting something might
'      be wrong with the implementation of $INCLUDE.
' **************************
' * BOILER PLATE END
' **************************

DEFINT A-Z

'$INCLUDE: 'PRO.BI'

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