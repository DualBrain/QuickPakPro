' ******** SCROLLIN.BAS - scrollable input line editor subroutine

' Copyright (c) 1991 Crescent Software
' Written by Phil Cramer
' Modifications (c) 2022 Cory Smith

DEFINT A-Z

DECLARE SUB QPRintRC (txt$, row, col, clr)
DECLARE SUB GetCursorT (row, col, button)
DECLARE SUB WaitUp ()
DECLARE SUB HideCursor ()
DECLARE SUB ShowCursor ()

DECLARE FUNCTION PDQTimer& ()
DECLARE FUNCTION QInstr2% (startPos, filter$, ky$)
DECLARE SUB Upper (txt$)

CONST FILTER1$ = "1234567890- "         ' Mask for Integers ONLY
CONST FILTER2$ = "1234567890.^ed+-/ "   ' Mask for Single/Double precision ONLY
CONST FILTER3$ = ""                     ' User definable Mask

'┌───────────────────────────────────────────────────────────────────────────┐
'│  ScrollIn arguments:                                                      │
'│                                                                           │
'│  edit$   The string to be edited. May be any length                       │
'│                                                                           │
'│  start   On entry Start is the first character to be displayed in the edit│
'│          window. On exit, Start holds the column where the cursor was last│
'│                                                                           │
'│  wide    The width of the edit window                                     │
'│                                                                           │
'│  maxLen  The maximum allowable length of Edit$. If MaxLen = Wide then no  │
'│          scrolling will occur                                             │
'│                                                                           │
'│  filter  Determines the type of text to be entered and may be set to the  │
'│          any of the following numbers:                                    │
'│                                                                           │
'│            0  All regular keys will be accepted                           │
'│            1  Integers characters only                                    │
'│            2  Integer, Single or Double precision characters only         │
'│            3  User defined                                                │
'│            4  Converts all letters to upper case                          │
'│                                                                           │
'│  ky      On entry Ky is the column at which to place the cursor. On exit  │
'│          Ky returns the key used to Exit ScrollIn.BAS                     │ 
'│                                                                           │
'│  edClr   The color to use while editing  (See COLORS.BAS)                 │
'│                                                                           │
'│  normClr The color to use when editing is complete  (See COLORS.BAS)      │
'│                                                                           │
'└───────────────────────────────────────────────────────────────────────────┘
'
SUB ScrollIn (edit$, start, wide, maxLen, filter, ky, edClr, normClr) STATIC

  insertOn = 0
  row = CSRLIN                            ' Get the Edit row
  col = POS(0)                            ' Get the Edit Column
  oS = Col                                ' Calculate the offset from Column 1
  lCol = Col                              ' Left side of window
  rCol = LCol + Wide - 1                  ' Right side of window

  ed$ = SPACE$(maxLen)                    ' Dim the string
  LSET ed$ = edit$                        ' Place the Edit$ in the Field
  clr = edClr                             ' Start with Edit Color
  GOSUB PrintIt                           ' Print The string

  LOCATE , , 1, 6, 7                      ' Turn on the cursor
  col = col + ky - 1                      ' Find the cursor column

  ' start + col - oS = The current character position in the string

  DO

    ky$ = INKEY$                          ' Get the KeyPress

    SELECT CASE LEN(ky$)
      CASE 0
        ky = 0
      CASE 1                              ' Regular key
        ky = ASC(ky$)
      CASE 2
        ky = -ASC(RIGHT$(ky$, 1))         ' Extended key, convert to negative
      CASE ELSE
    END SELECT

    ' MMMMMMMMMMMMMMMMMMMMMM Start of Mouse Code MMMMMMMMMMMMMMMMMMMMMMMM
    ' M   If you do not require a mouse, eliminate the code from here   M
    ' M   to the next block of 'MMMMMM statements                       M
    ' MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM

    CALL GetCursorT(mCol, mRow, button)

    IF button = 1 THEN                        ' If they left clicked
                                              ' If we clicked on the field,
                                              ' find new cursor position
      IF mRow = row AND mCol >= lCol AND mCol <= rCol THEN

        HideCursor                            ' Turn Mouse cursor Off

        col = mCol
                                                
        IF NOT pressed THEN                   ' Set the timer if first time
          t& = PDQTimer&
        ELSE
          IF PDQTimer& - t& > 2 THEN time = -1 ' Wait 2 ticks before we scroll
        END IF
          
        IF mCol = rCol AND time THEN          ' If we're holding down the
          col = col + 1                       ' mouse button on the far
          x = 1                               ' right column, scroll right
        END IF

        IF mCol = lCol AND time THEN          ' If we're holding down the
          col = col - 1                       ' mouse button on the far
          x = 1                               ' left button, scroll left
        END IF

        pressed = -1                          ' Set the Button pressed flag

      ELSE                                    ' They pressed outside the window
        CALL WaitUp                           ' Wait til they release the key
        mPressed = -1                         ' Set flag
        ky = 13                               ' Make like Enter pressed
      END IF

    ELSE
      oressed = 0                             ' Reset Flags
      time = 0
      ShowCursor                              ' Turn Mouse Cursor On
    END IF

    ' MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
    ' M                        End of Mouse Code                       M
    ' MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM

    SELECT CASE ky
      CASE 0

      ' ---- BackSpace
      CASE 8
        IF start + col - oS > 1 THEN
          IF insertOn THEN
            MID$(ed$, start + col - oS - 1) = MID$(ed$, start + col - oS) + " "
          ELSE
            MID$(ed$, start + col - oS + (start <> 0), 1) = " "
          END IF
          col = col - 1
          GOSUB PrintIt
          x = 1
        END IF

      ' ----Tab                        ' Move forward 8 spaces at a time
      CASE 9
        col = col + 8
        x = 8

      ' ----Escape
      CASE 27
        clr = NormClr
        LSET ed$ = edit$              ' Return un-edited string
        GOSUB PrintIt
        ed$ = ""                      ' Clear the copy
        EXIT SUB                      ' Outta' here

      ' ----Shift Tab                  ' Move backward 8 spaces at a time
      CASE -15
        col = col - 8
        x = 8

      ' ----Alt R
      CASE -19                        ' Restore original field
        LSET ed$ = edit$
        GOSUB PrintIt

      ' ----Alt C                     ' Clear the field
      CASE -46
        ed$ = SPACE$(maxLen)
        GOSUB PrintIt

      ' ---- Left Arrow
      CASE -75
        col = col - 1
        x = 1

      ' ----Right Arrow
      CASE -77
        col = col + 1
        x = 1

      ' ----Home
      CASE -71
        start = 1
        col = -1
        x = 1

      ' ----  Up, PgUp, Down, PgDown, Enter
      CASE -72, -73, -80, -81, 13
        clr = normClr
        edit$ = ed$
        GOSUB PrintIt
        ed$ = ""
        IF mPressed THEN ky = 1000    ' Return code for mouse click
        start = col - oS + 1          ' Return the current cursor column
        EXIT SUB

      ' ----End
      CASE -79
        FOR i = maxLen TO 1 STEP -1   ' Find last character in the string
          IF MID$(ed$, i, 1) <> " " THEN
            start = i - wide
            EXIT FOR
          END IF
        NEXT
        IF i > wide THEN              ' Not found in the current window
          col = rCol + 1              ' Scroll right
          x = 1
        ELSE                          ' Found in the current window
          start = 1
          col = i + oS
        END IF

      ' ----Ins                       ' Toggle Insert Status
      CASE -82
        insertOn = NOT insertOn
        IF insertOn THEN
          LOCATE , , , 0, 7           ' Insert OFF, use small cursor
        ELSE
          LOCATE , , , 6, 7
        END IF                        ' Insert ON use full cursor

      ' ----Delete                    ' Remove a character
      CASE -83
        MID$(ed$, start + col - oS) = MID$(ed$, start + col - oS + 1) + " "
        GOSUB PrintIt

      ' ----Control Right             ' Move wide spaces -1 to the right
      CASE -116
        col = col + wide - 1
        x = wide - 1

      ' ----Control Left              ' Move wide spaces +1 to the left
      CASE -115
        col = col - wide + 1
        x = wide + 1

      ' ----All normal keys           ' Handle regular keys
      CASE 32 TO 255
        found = -1
        SELECT CASE filter
          CASE 1                      ' Integers Only
            IF QInstr2%(1, FILTER1$, ky$) = 0 THEN found = 0
          CASE 2                      ' Single/Double precision Numbers only
            IF QInstr2%(1, FILTER2$, ky$) = 0 THEN found = 0
          CASE 3                      ' User defined
            IF QInstr2%(1, FILTER3$, ky$) = 0 THEN found = 0
          CASE 4
            CALL Upper(ky$)
          CASE ELSE
        END SELECT
        IF found THEN                 ' If its an acceptable key
          IF insertOn THEN
            MID$(ed$, start + col - oS) = ky$ + MID$(ed$, start + col - oS)
            col = col + 1
            GOSUB PrintIt
          ELSE
            MID$(ed$, start + col - oS, 1) = ky$
            GOSUB PrintIt
            col = col + 1
          END IF
        END IF
        x = 1

      CASE ELSE
    END SELECT

    IF col > rCol THEN               ' Make sure we stay within the field
      col = rCol
      start = start + x
      GOSUB PrintIt
    ELSEIF col < lCol THEN
      col = lCol
      start = start - x
      GOSUB PrintIt
    END IF

    LOCATE row, col                   ' Locate the Cursor

  LOOP

PrintIt:
  IF maxLen - start + 1 < wide THEN start = maxLen - wide + 1 ' Make sure
  IF start < 1 THEN start = 1                                 ' we stay in range
  HideCursor
  QPRintRC MID$(ed$, start, wide), row, lCol, clr             ' Print the string
  ShowCursor
  RETURN

END SUB