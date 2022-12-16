' ********* WordWrap.Bas - prints long strings with word wrap

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
_TITLE "WORDWRAP" 'NOTE: Moving title above resize causes resize to fail (without an error???)
'BUG: It would be nice specify the icon here, but... having to require full path or placing it in the qb64 folder is problematic. 
'NOTE: The above boiler plate must be first in execution (top of file).
'BUG:  Also appears to not work as an $INCLUDE; suggesting something might
'      be wrong with the implementation of $INCLUDE.
' **************************
' * BOILER PLATE END
' **************************

DEFINT A-Z

'$INCLUDE: 'PRO.BI'

DECLARE SUB WordWrap (x$, wide)

CLS

a$ = "This is the theme to Garry's show, the opening theme to Garry's show.  "
b$ = "Garry called me up and asked if I would write his theme song.  "
c$ = "I'm almost halfway finished, how do you like it so far.  "
d$ = "How do you like the theme to Garry's show?  "
e$ = "This is the theme to Garry's show, the opening theme to Garry's show.  "
f$ = "This is the music that you hear as you watch the credits.  "
g$ = "We're almost to the part where I start to whistle.  "
h$ = "Then we'll watch It's Garry Shandling's show. "

w$ = a$ + b$ + c$ + d$ + e$ + f$ + g$ + h$
PRINT w$
PRINT
wide = 60                     ' the maximum width of the display
WordWrap w$, wide

SUB WordWrap (x$, wide%)

  length% = LEN(x$)           ' remember the length
  pointer% = 1                ' start at the beginning of the string

  ' scan a block of eighty characters backwards, looking for a blank
  ' stop at the first blank, or if we reached the end of the string
  DO
      FOR x% = pointer% + wide% TO pointer% STEP -1
         IF MID$(x$, x%, 1) = " " OR x% = length% + 1 THEN
            PRINT MID$(x$, pointer%, x% - pointer%);
            pointer% = x% + 1
            WHILE MID$(x$, pointer%, 1) = " "
               Pointer% = pointer% + 1    ' swallow extra blanks to the next word
            WEND
            IF POS(0) > 1 THEN PRINT      ' if the cursor didn't wrap next line
            EXIT FOR                      ' done with this block
         END IF
      NEXT
  LOOP WHILE pointer% < length%           ' loop until done

END SUB

'$INCLUDE: 'PRO.BAS'