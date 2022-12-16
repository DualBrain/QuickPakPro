' ********** APRINT.BAS - quick prints a "Mid" portion of an entire array

' Copyright (c) 1987 Ethan Winer
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
_TITLE "APRINT" 'NOTE: Moving title above resize causes resize to fail (without an error???)
'BUG: It would be nice specify the icon here, but... having to require full path or placing it in the qb64 folder is problematic. 
'NOTE: The above boiler plate must be first in execution (top of file).
'BUG:  Also appears to not work as an $INCLUDE; suggesting something might
'      be wrong with the implementation of $INCLUDE.
' **************************
' * BOILER PLATE END
' **************************

DEFINT A-Z

'$INCLUDE: 'PRO.BI'

DECLARE SUB APrint (array$(), first, numEls, firstChar, numChars, colr, page)
DECLARE SUB Box (ulRow, ulCol, lrRow, lrCol, style, colr, page)
DECLARE SUB QPrint (txt$, colr, page)

pages = 7   ' use 3 or 7 to establish the vertical resolution of the demo
wide = 80   ' set to 40 or 80

start = 1: midFirst = 1     ' start with first character in first element

' init screens to different colors to test the default color ability
' of APrint and Box - the Page parameters can also be hard-coded.

IF pages = 7 THEN   ' if we're allowing 7 pages, then do 25 lines
  scrSize = 25
  numEls = 22
ELSE                ' otherwise use the 43 line mode (EGA only)
  scrSize = 43
  numEls = 40
END IF

IF wide = 40 THEN   ' if we're working in 40 columns, use 38 characters
   numChars = 38
ELSE                ' otherwise use 80 characters
   numChars = 78
END IF

WIDTH wide, scrSize
FOR x = pages TO 0 STEP -1
  SCREEN 0, 0, x, x
  READ fg, bg
  COLOR fg, bg
  CLS
  Box 1, 1, numEls + 2, numChars + 2, 3, fg + 1 + fg + 1 * 4, -1
NEXT
DATA 15,4,  1,0,  12,5,  2,8,  11,2,  9,0,  13,4,  14,1

DIM array$(2000)
OPEN "APRINT.BAS" FOR INPUT AS #1
WHILE NOT EOF(1)
  count = count + 1
  LINE INPUT #1, array$(count)
WEND
CLOSE

NewPage:
  SCREEN , , page, page
  p$ = "Page" + STR$(page) + ": Use arrows, "
  p$ = P$ + CHR$(34) + "P" + CHR$(34) + ", or Esc to exit"
  LOCATE numEls + 3, 1
  QPrint p$, -1, -1

Doit:
  LOCATE 2, 2: clr = 7
  APrint array$(), start, numEls, midFirst, numChars, -1, -1

GetK:

  DO
    x$ = INKEY$
  LOOP UNTIL LEN(X$)

  IF x$ = CHR$(27) THEN END                   ' Escape

  IF x$ = CHR$(0) + CHR$(80) THEN
    IF start + numEls - 1 > count GOTO GetK   ' Down arrow
    start = start + 1
    GOTO Doit
  ELSEIF x$ = CHR$(0) + CHR$(72) THEN         ' Up arrow
    IF start < 2 GOTO GetK
    start = start - 1
    GOTO Doit
  ELSEIF x$ = CHR$(0) + CHR$(75) THEN         ' Left arrow
    IF midFirst < 2 GOTO GetK
    midFirst = midFirst - 1
    GOTO Doit
  ELSEIF x$ = CHR$(0) + CHR$(77) THEN         ' Right Arrow
    midFirst = midFirst + 1
    GOTO Doit
  ELSEIF x$ = CHR$(0) + CHR$(71) THEN         ' Home key
    start = 1
    midFirst = 1
    GOTO Doit
  ELSEIF UCASE$(x$) = "P" THEN                ' new Page
    page = page + 1
    IF page > pages THEN page = 0
    GOTO NewPage
  END IF

  GOTO GetK

'$INCLUDE: 'PRO.BAS'