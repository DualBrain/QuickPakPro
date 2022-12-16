' ********** MARQUEE.BAS

' demonstrates a cute way to display a message while waiting for a key press

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
_TITLE "MARQUEE" 'NOTE: Moving title above resize causes resize to fail (without an error???)
'BUG: It would be nice specify the icon here, but... having to require full path or placing it in the qb64 folder is problematic. 
'NOTE: The above boiler plate must be first in execution (top of file).
'BUG:  Also appears to not work as an $INCLUDE; suggesting something might
'      be wrong with the implementation of $INCLUDE.
' **************************
' * BOILER PLATE END
' **************************

DEFINT A-Z

'$INCLUDE: 'PRO.BI'

DECLARE SUB Marquee (message$, row, colr)
DECLARE SUB Pause (ticks)
DECLARE SUB QPrint (txt$, colr, page)

CLS

message$ = "This is a scrolling message . . . "

PRINT "Press a key when you feel like it"
PRINT

DO
  x$ = INKEY$
  marquee message$, 24, 112    ' do it on row 24 in black on white
LOOP UNTIL LEN(x$)
  
PRINT "You pressed "; CHR$(34); x$; CHR$(34)

SUB Marquee (x$, row%, colr%) STATIC

  STATIC p%                   ' remembers the current position between calls

  h% = POS(0)                 ' save the current cursor position
  v% = CSRLIN
  l% = LEN(x$)                ' we need to know the length

  p% = p% + 1                 ' advance to the next character
  IF p% > l% THEN p% = 1      ' wrap around at the end

  LOCATE row%, 40 - l% \ 2
  QPrint RIGHT$(x$, l% - p% + 1) + LEFT$(x$, p% - 1), colr%, -1

  Pause (2)                   ' pause a bit to slow down the scrolling

  LOCATE v%, h%               ' restore the cursor position

END SUB

'$INCLUDE: 'PRO.BAS'