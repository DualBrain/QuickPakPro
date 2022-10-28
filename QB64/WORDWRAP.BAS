' ********* WordWrap.Bas - prints long strings with word wrap

' Copyright (c) 1988 Ethan Winer
' Modifications (c) 2022 Cory Smith

DEFINT A-Z

_FULLSCREEN _SQUAREPIXELS

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