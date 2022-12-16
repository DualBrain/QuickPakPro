' ******** COLORS.BAS - prints a chart of the screen attributes for each color

' Copyright (c) 1988 Ethan Winer
' Modifications (c) 2022 Cory Smith

' This chart provides a quick reference to the various "encoded" colors
' that are used with QPrint, APrint, and the other QuickPak video routines.
' To get a hard copy printout, press Shift-PrtSc once it is on your screen.

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
_TITLE "COLORS" 'NOTE: Moving title above resize causes resize to fail (without an error???)
'BUG: It would be nice specify the icon here, but... having to require full path or placing it in the qb64 folder is problematic. 
'NOTE: The above boiler plate must be first in execution (top of file).
'BUG:  Also appears to not work as an $INCLUDE; suggesting something might
'      be wrong with the implementation of $INCLUDE.
' **************************
' * BOILER PLATE END
' **************************

DEFINT A-Z

'$INCLUDE: 'PRO.BI'

DECLARE FUNCTION OneColor% (FG, BG)
DECLARE FUNCTION Peek1% (Segment, Address)

CLS

IF Peek1%(0, &H463) <> &HB4 THEN ColorMon = 1   ' see what monitor is active
Mask$ = "  ###  "                               ' for Print Using

DIM Colr$(8)                                    ' the color names
FOR X = 0 TO 8
  READ Colr$(X)
NEXT
DATA Black, Blue, Green, Cyan, Red, Magenta, Brown, White, Gray

LOCATE 2, 23
COLOR 9
PRINT "  QuickPak Professional Color Chart  "

FOR BG = 0 TO 7

  LOCATE 5, 15 + BG * 8
  COLOR 7, 0
  PRINT FnPad$(Colr$(BG))

  FOR FG = 0 TO 15

		LOCATE 7 + FG, 1
		COLOR 7, 0
		IF FG <= 8 THEN
			PRINT Colr$(FG);
		ELSE
			PRINT "Bright "; Colr$(FG - 8);
		END IF

	  LOCATE , 15 + BG * 8
	  COLOR FG, BG
  	PRINT USING Mask$; OneColor%(FG, BG)

  NEXT
NEXT

COLOR 7, 0: LOCATE 7, 18: PRINT 0
IF ColorMon THEN COLOR 8
LOCATE 15, 18: PRINT 8

' Originally: DEF FnPad$ (X$) = SPACE$((7 - LEN(X$)) / 2) + X$
FUNCTION FnPad$(X$) ' for centering
  FnPad$ = SPACE$((7 - LEN(X$)) / 2) + X$
END FUNCTION

'$INCLUDE: 'PRO.BAS'