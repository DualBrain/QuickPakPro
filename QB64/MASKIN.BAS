' ********** MASKIN.BAS - Masked input routine

' Copyright (c) 1990 Crescent Software
' written by Jay Munro
' Modifications (c) 2023 Cory Smith
'
' 04/25/1992 - added foreign language support �

DEFINT A-Z

DECLARE SUB MaskIn (Mask$, Text$, MSKI AS ANY)
DECLARE FUNCTION QPMid$ (X$, Y, Z)
DECLARE FUNCTION QPRight$ (X$, X)
DECLARE FUNCTION ASCII% (X$)
DECLARE FUNCTION IsLower% (X)
DECLARE FUNCTION IsUpper% (X)
DECLARE FUNCTION IsMath% (X)
DECLARE FUNCTION IsNumber% (X)
DECLARE FUNCTION IsPunct% (X)

' Parameters are passed to routine through the MaskParms type array
'   Ky is the ASCII value of the last key pressed
'   Action is:
'        0 to work non polling, <ENTER> or <ESC> terminates
'        1 initializes and checks for a keystroke
'        2 initializes without waiting for keystroke
'        3 skips initialization and just gets input
'
'        Actions 1 & 2 are changed to action 3 on exit from MaskIn
'
'   MColr is the color of to use for the message portion of the mask string
'   FColr is the color of the field where input is received

FUNCTION IsLower% (x)
  ' ---------- true if X = lower case or space
  IsLower% = (x > 96 AND x < 123 OR x = 32) OR INSTR("������������������������", CHR$(x))
END FUNCTION

FUNCTION IsMath% (x)
  ' -------- true if X = + , - .
  IsMath% = (x > 42 AND x < 47)
END FUNCTION

FUNCTION IsNumber% (x)
  ' -------- true if X = numbers 0123456789
  IsNumber% = (x > 47 AND x < 58)
END FUNCTION

FUNCTION IsPunct% (x)
  ' -------- true if X = !"#$%'()*+,-./:;<=>?[\]^_`{|}~
  IsPunct% = (x > 32 AND x < 48) OR (x > 57 AND x < 80) OR (x > 90 AND x < 97) OR (x > 122 AND x < 127 OR INSTR("������", CHR$(x)))
END FUNCTION

FUNCTION IsUpper% (x)
  ' -------- true if X = Caps or space
  IsUpper% = (x > 64 AND x < 91 OR x = 32 OR INSTR("������", CHR$(x)))
END FUNCTION

' MaskIn subroutine
'
' The mask string is examined a character at a time. If the ASCII value
' of the current character is < 32 then input is polled.  If the value is
' greater than 32, it is assumed to be part of the message, is printed, and
' the cursor is moved to the next character for testing.  The variable
' LocDir (Locate Direction) is set to either -1 or 1 and is added to the
' current column for locating at the next character.  Backspace and right
' arrow will set it to -1 for backward movement, all other character set
' it to 1 for forward movement.
'
' The maximum length of the mask string is 80 characters when located at the
' start of the line, but will be less when started in from column 1.
'
' The Text$ variable must be set to the maximum characters expected from
' Mask$'s input fields, or it will truncate input.  For example, if Mask$
' contains a field of 25 characters, Text$ must be set to 25 characters.
'
'
SUB MaskIn (mask$, text$, mski AS MaskParms) STATIC

  table$ = "����������"                 '   european characters used in Upper/lower table
  IF MSKI.Action < 3 THEN                       '   initialize everything
    LOCATE , , 0
    maxLen = LEN(mask$)                 ' get Len of Mask$
    tCol = POS(0)                       ' save current cursor location
    tRow = CSRLIN
    IF maxLen + tCol > 80 THEN EXIT SUB ' keep it fitting on one line
    curCol = 1                          ' initializes current column
    tempCol = curCol                    '   temp position
    locDir = curCol                     '   direction for locates
    FOR x = 1 TO maxLen                 ' print field loop
      IF ASCII%(QPMid$(mask$, x, 1)) < 32 THEN  ' check mask character
                                        ' print character from incoming field
        CALL QPrintRC(QPMid$(text$, tempCol, 1), tRow, tCol + x - 1, MSKI.FColr)
        tempCol = tempCol + 1           '   point to next character
      ELSE                              '   print mask character
        CALL QPrintRC(QPMid$(mask$, x, 1), tRow, tCol + x - 1, MSKI.MColr)
      END IF
    NEXT x
    MSKI.Ky = 0                         ' initialize keypress variable
    IF MSKI.Action = 2 THEN             ' if action 2 then just get out without
      MSKI.Action = 3                   '   bothering for a keypress
      EXIT SUB
    END IF
    IF MSKI.Action > 0 THEN MSKI.Action = 3  ' set action to stay in loop
  END IF

  ' -------- MaskIn 'engine'
  DO                                    ' do/loop for Action flag = 0
    DO                                  ' do/loop for key input
      mskChar = ASCII%(QPMid$(mask$, curCol, 1))  ' get a char from Mask$
      IF mskChar < 32 THEN              ' check mask character--input needed?
        LOCATE , , 1                    '   yes, turn on cursor
        DO                              '   do loop for inkey$
          a$ = INKEY$                   '   assign incoming character to A$
          length = LEN(a$)              '   get length of character
        LOOP UNTIL length OR MSKI.Action '   loop until a character is hit or in polled mode

        IF length THEN                  '   if character is received
          IF length = 2 THEN            '   check if it's an extended character
            MSKI.Ky = -ASCII%(QPRight$(a$, 1)) '   make it negative ASCII value
          ELSE                          '   otherwise just get ASCII value
            MSKI.Ky = ASCII%(a$)
          END IF
        ELSE
          EXIT DO                       '   no character, bag out
        END IF

        IF MSKI.Ky < 0 THEN             ' check for extended key
          SELECT CASE MSKI.Ky           '   See what it is
            CASE -83                    ' delete key
              CALL QPrintRC(" ", tRow, tCol + curCol - 1, -1) '   print a space
            CASE -75                    ' left arrow
              locDir = -1               '   point direction backwards
              GOSUB CurPosition         '   and move cursor back one space
            CASE -77                    ' right arrow
              locDir = 1                '   point direction forwards
              GOSUB CurPosition         '   and move cursor forward one space
            CASE -72, -80, -15          ' up,down, shift tab
              GOSUB GetTxt              '   load up string and exit
              EXIT DO
            CASE ELSE
          END SELECT

        ELSEIF MSKI.Ky > 0 THEN         ' if any other character pressed
          SELECT CASE MSKI.Ky           '
            CASE 27                     ' escape pressed
              EXIT SUB                  '   exit with MSKI.Ky = 27
            CASE 9, 13                  ' carriage return
              GOSUB GetTxt              ' get text and exit
              EXIT DO
            CASE 8                      ' back space
              locDir = -1               ' point backwards
              temp = curCol             ' assign a temporary cursor column
              DO
                temp = temp + locDir    ' subtract one from CurCol
                IF temp > 1 AND temp < maxLen THEN   ' if temp is within string area
                  IF ASCII%(QPMid$(mask$, temp, 1)) < 32 THEN ' then check for mask char
                    GOSUB CurPosition                         '   update cursor if it is
                    CALL QPrintRC(" ", tRow, tCol + curCol - 1, -1) '   print a space
                    EXIT DO                                   '   exit
                  ELSE                                        ' assign temp to CurCol
                    curCol = temp                             ' to skip over non-input characters
                  END IF
                ELSE                                          ' CurCol is outside string
                  EXIT DO                                     '   don't move any more
                END IF
              LOOP
            CASE ELSE
              locDir = 1                                     ' point forward
              IF mskChar THEN                                '
                DO UNTIL flag

' -------- if accepting upper and lower, don't force anything
                  IF (mskChar AND 3) = 3 THEN   ' allow upper and lower case?
                    IF IsLower%(MSKI.Ky) OR IsUpper%(MSKI.Ky) THEN
                      flag = -1
                      EXIT DO
                    END IF
                  END IF

' -------- if uppercase only, force uppercase on lowercase letters
                  IF mskChar AND 1 THEN         ' allow upper case?
                    IF IsLower%(MSKI.Ky) OR IsUpper%(MSKI.Ky) THEN
                      CALL Upper(a$)
                    
                      CALL UpperTbl(a$, table$)
                      flag = -1
                      EXIT DO
                    END IF
                  END IF

' -------- if lowercase only, force lowercase on uppercase letters
                  IF mskChar AND 2 THEN         ' allow lower case only?
                    IF IsLower%(MSKI.Ky) OR IsUpper%(MSKI.Ky) THEN
                      CALL Lower(a$)

                      CALL LowerTbl(a$, table$)
                      flag = -1
                      EXIT DO
                    END IF
                  END IF

' -------- check individual flags
                  IF flag THEN EXIT DO
                  IF mskChar AND 4 THEN flag = IsNumber%(MSKI.Ky)' allow numbers?
                  IF flag THEN EXIT DO
                  IF mskChar AND 8 THEN flag = IsMath%(MSKI.Ky)  ' allow periods, commas - + ?
                  IF flag THEN EXIT DO
                  IF mskChar AND 16 THEN flag = IsPunct%(MSKI.Ky)' allow full punctuation?
                  EXIT DO
                LOOP

' -------- if we got a valid character, show it, otherwise beep!
                IF flag THEN
                  flag = 0
                  GOSUB PrintChar
                ELSE
                  'BEEP                   'uREM this to actually BEEP
                END IF
              ELSE
                LOCATE , , 0                      ' turn cursor off to skip over mask
                GOSUB CurPosition                 ' move the cursor
              END IF
          END SELECT
        END IF
      ELSE
        LOCATE , , 0                      ' turn cursor off to skip over mask
        GOSUB CurPosition                 ' move the cursor
      END IF
    LOOP
  LOOP UNTIL MSKI.Action OR MSKI.Ky <> 13 OR MSKI.Ky <> 27 OR MSKI.Ky < 0

  EXIT SUB

' -------- entry point to print and move cursor
PrintChar:                                ' print a character
  CALL QPrintRC(a$, tRow, tCol + curCol - 1, -1)

' -------- entry point to just move cursor
CurPosition:
  curCol = curCol + locDir                ' update current cursor position
  DO
    IF curCol > maxLen THEN               ' right arrowed too far
      curCol = maxLen                     '   leave cursor at end
      EXIT DO
    ELSEIF curCol < 1 THEN                ' left arrowed to far
      curCol = 1                          '   leave cursor at beginning
      locDir = 1
      EXIT DO
    END IF
    LOCATE , tCol + curCol - 1            ' relocate the cursor
    EXIT DO
  LOOP

  RETURN

' -------- return typed info by reading characters from screen

GetTxt:
  y = 1
  tLen = LEN(text$)
  x$ = " "
  FOR x = 1 TO maxLen
    IF ASCII%(QPMid$(mask$, x, 1)) < 32 THEN
      CALL ReadScrn0(tRow, tCol + x - 1, x$)
      IF y <= tLen THEN
        MID$(text$, y, 1) = x$
        y = y + 1
      ELSE
        EXIT FOR
      END IF
    END IF
  NEXT x
  RETURN

END SUB