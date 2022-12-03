' ********** MARQUEE.BAS

' demonstrates a cute way to display a message while waiting for a key press

' Copyright (c) 1988 Ethan Winer
' Modifications (c) 2022 Cory Smith

DEFINT A-Z

'$INCLUDE: 'PRO.BI'

'_FULLSCREEN _SQUAREPIXELS

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