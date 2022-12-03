' ********** DIALOG.BAS - complete dialog box subprogram

' Copyright (c) 1990 Crescent Software
' written by Phil Cramer
' Modifications (c) 2022 Cory Smith

DEFINT A-Z

'----BASIC Subs
DECLARE FUNCTION LongestStr1% (Text$(), NumButtons, ItemNum)

'---- Assembler Subs
DECLARE SUB Box0 (ULRow, ULCol, LRRow, LRCol, Char, Colr)
DECLARE SUB ClearScr0 (ULRow, ULCol, LRRow, LRCol, Colr)
DECLARE SUB InitMouse (There)
DECLARE SUB MScrnSave (ULRow, ULCol, LRRow, LRCol, SEG Element)
DECLARE SUB MAMenu (BYVAL Address, Selection, Start, Count, ExitCode, FileColr, HiLiteColr, Rows, Columns, Spacing, Row, Column)
DECLARE SUB MEditor (Ed$, ActiveLength, ScanCode, NumOnly, CapsOn, NormalClr, EditClr, Row, Column, CurrentColumn)
DECLARE SUB MouseRange (SEG Element AS ANY, NumEls, Row, Column, Button, Range)
DECLARE SUB MScrnRest (ULRow, ULCol, LRRow, LRCol, SEG Element)
DECLARE SUB PaintBox0 (ULRow, ULCol, LRRow, LRCol, Colr)
DECLARE SUB QPrint0 (X$, Colr)
DECLARE SUB ShowCursor ()
DECLARE SUB SplitColor (Colr, FG, BG)
DECLARE SUB StuffBuf (Char$)
DECLARE SUB InstallKeyDown ()

'---- ASM functions
DECLARE FUNCTION ArraySize% (ULRow, ULCol, LRRow, LRCol)
DECLARE FUNCTION OneColor% (FG, BG)
DECLARE FUNCTION KeyDown% ()

TYPE DLog
  DType AS INTEGER           ' Type i.e. 0=Plain Text, 1=Button 2=Check Box,
                             '   3=Option Box 4=Text Input Box, 5=List Box
  TextLen AS INTEGER         ' Length of text to be entered
  NumFlag AS INTEGER         ' Num only flag for MEditor
  Row AS INTEGER             ' Starting row
  Col AS INTEGER             ' Starting column
END TYPE

CONST Check$ = "X"                       ' Character for Check boxes
CONST Cancel$ = "CANCEL"

' Change the constants below for the screen mode that you will be using
CONST VMid = 13                          ' Center of screen for 25 row mode                                                                                         -+               'Center of screen for 50 line mode
CONST HMid = 41                          ' Center of screen for 80 column mode

SUB Dialog (choice1, text$(), response$(), menu$(), scrnRow, style, bClr, action) STATIC
                        '^
                        ' ---- Insert a "1" for TextCopy [change to Text1$()]

  '****************************************************************************
  '* Note: Dialog internally modifies the Text$() array. Depending on how you
  '*       set up your program, this may or may not be a problem. If you do not
  '*       want the array modified, search for "TextCopy" and do as comments
  '*       indicate. This will cause Dialog to work on a copy of the Text$()
  '*       array instead of the actual Text$() array.                       
  '****************************************************************************

  'TYPE DLog                    'Type for Dialog Box data
  '  DType AS INTEGER           'Type i.e. 0=Plain Text, 1=Button 2=Check Box,
  '                             ' 3=Option Box 4=Text Input Box, 5=List Box
  '  TextLen AS INTEGER         'Length of text to be entered
  '  NumFlag AS INTEGER         'Num only flag for MEditor
  '  Row AS INTEGER             'Starting row
  '  Col AS INTEGER             'Starting column
  'END TYPE

  'CALL InstallKeyDown                     ' Install routine to check for keys held down

  choice = choice1
  IF action = 5 AND choice = -1 THEN GOTO Escape
  IF action = 5 THEN GOTO Done
  IF action = 4 THEN action = 3
  IF action = 3 GOTO KeyLoop
  IF action = 2 THEN
    temp$ = INKEY$
    GOTO DispResponse
  END IF
  IF action = 1 THEN action = 3

  menuCount = UBOUND(menu$, 1)
  menuCols = 1                            ' Default number of menu columns
  mCount = UBOUND(menu$, 1)
  startItem = 1                           ' Place item one at top of menu
  dot$ = CHR$(7)                          ' Ascii character for option buttons

  ' ----Hilite color will be Bright White unless foreground color is Bright White
  fFg = 15
  CALL SplitColor(bClr, fg, bg)
  IF fg = 15 THEN fFg = 0                 ' If foreground color is Bright White, make hilite Black
  hiLite = OneColor%(fFg, bg)
  hiClr = hiLite
  
  ' ----These variables need to be re-initialized each time Dialog is called
  numXBoxes = 0                           ' Number of Option buttons
  lastXBox = 0                            ' Re-init LastXBox
  numChoices = 0                          ' Number of selectable choices
  numButtons = 0                          ' Number of buttons on bottom row
  button$ = ""
  bWidth = 0
  bHite = 0
  menuHite = 0
  menuWidth = 0
  mOS = 0
  tLen = 0
  itemNum = 0
  buttonsOnly = 0
  choice1 = 0
  found = 0

  choice = 1                              ' Choice keeps track of which button is active
  windowNum = 1                           ' First mouse range window
  upperBound = UBOUND(text$, 1)           ' TextCopy--Change Text$ to Text1$
  upBound = UBOUND(response$, 1)
  selection = 1                           ' Menu will start on item 1

  '*** Un-Rem for TextCopy ***
  'REDIM Text$(UpperBound)                 ' Make a copy of the Text$() Array
  'FOR i = 1 TO UpperBound                 '   since it gets modified
  '  Text$(i) = Text1$(i)
  'NEXT

  REDIM dial(upperBound) AS DLog
  REDIM tResponse$(upBound)               ' Keep an un-edited version
  FOR i = 1 TO upBound                    '   of the Response$()
    tResponse$(i) = response$(i)          '   in case of Cancel/Esc
  NEXT

  bHite = 4                               ' Minimum box height
  FOR i = 1 TO upperBound
    temp = ASC(text$(i))
    SELECT CASE temp
      CASE 60                             ' ** "<" Command button
        numChoices = numChoices + 1
        numButtons = numButtons + 1
        dial(i).DType = 1                 ' Type identifier
      CASE 91                             ' ** "[" Check Box
        bHite = bHite + 1                 ' Inc overall box height
        numChoices = numChoices + 1       ' inc number of choices
        dial(i).DType = 2                 ' Type identifier
      CASE 40                             ' ** "(" Option Button
        bHite = bHite + 1                 ' Inc overall box height
        numChoices = numChoices + 1       ' Inc number of choices
        dial(i).DType = 3                 ' Type identifier
        lastXBox = i
        numXBoxes = numXBoxes + 1         ' Keep track of num Option buttons
      CASE 124                            ' ** "|" Menu
        menuWidth = LEN(menu$(1))
        numChoices = numChoices + 1
        dial(i).DType = 5
        menuRows = INSTR(2, text$(i), "|")
        itemNum = i
        mOS = 4
        SELECT CASE menuRows              ' Check for Menu Height
          CASE 3                          ' Single digit
            menuHite = VAL(MID$(text$(i), 2, 1)) + 8
            text$(i) = RIGHT$(text$(i), LEN(text$(i)) - 3)
          CASE 4                          ' Two digits
            menuHite = VAL(MID$(text$(i), 2, 2)) + 8
            text$(i) = RIGHT$(text$(i), LEN(text$(i)) - 4)
          CASE 5                          ' Three digits
            menuHite = VAL(MID$(text$(i), 3, 2)) + 8
            menuCols = VAL(MID$(text$(i), 2, 1))
            menuWidth = menuWidth * menuCols + (menuCols - 1) * 2
            text$(i) = RIGHT$(text$(i), LEN(text$(i)) - 5)
          CASE ELSE
        END SELECT
      CASE 123                            ' ** "{" Text input box
        bHite = bHite + 4                 '   takes up 4 screen rows
        numChoices = numChoices + 1       ' Inc number of choices
        dial(i).DType = 4                 ' Type identifier
        numEnd = INSTR(text$(i), "}")
        SELECT CASE numEnd                                  ' Check for input length
          CASE 3                                            ' Single digit
            dial(i).TextLen = VAL(MID$(text$(i), 2, 1))
            text$(i) = RIGHT$(text$(i), LEN(text$(i)) - 3)
            dial(i).NumFlag = 0                             ' Set Num only flag for Editor OFF
          CASE 4                                            ' Two digits
            dial(i).TextLen = VAL(MID$(text$(i), 2, 2))
            text$(i) = RIGHT$(text$(i), LEN(text$(i)) - 4)
            dial(i).NumFlag = 0                             ' Set Num only flag for Editor OFF
          CASE 5                                            ' Three digits
            dial(i).TextLen = VAL(MID$(text$(i), 3, 2))
            text$(i) = RIGHT$(text$(i), LEN(text$(i)) - 5)
            dial(i).NumFlag = 1                             ' Set Num only flag for Editor ON
          CASE ELSE
        END SELECT
        ' Trim the passed string if its longer than edit length
        IF LEN(response$(i)) > dial(i).TextLen THEN response$(i) = LEFT$(response$(i), dial(i).TextLen)
        ' Left justify Response$ in edit field for later
        response$(i) = response$(i) + SPACE$(dial(i).TextLen - LEN(response$(i)))
        IF dial(i).TextLen + 4 > bWidth THEN bWidth = Dial(i).TextLen + 4
      CASE ELSE                           ' Plain string
        dial(i).DType = 0                 ' Type identifier
        bHite = bHite + 1
        IF text$(i) = " " THEN text$(i) = ""
    END SELECT
  NEXT

  IF menuHite > bHite THEN bHite = menuHite
  IF bHite < 9 AND itemNum THEN bHite = 9 ' Minimum Height for Menu is 2
  lS = LongestStr1(text$(), numButtons, itemNum) ' Compare longest string from
  IF lS + 6 > bWidth THEN bWidth = lS + 6 ' text array with Title + 6
  FOR i = 1 TO numButtons
    tLen = tLen + LEN(text$(i)) + 2       ' Buttons will always have at
  NEXT                                    '   least 2 spaces between them

  IF itemNum = upperBound AND numButtons + 1 = upperBound THEN bWidth = bWidth - 6
  bWidth = bWidth + menuWidth + mOS

  IF tLen > bWidth THEN bWidth = tLen     ' Compare to total button width

  IF scrnRow THEN
    ulRow = CSRLIN                        ' Locate corners of box
  ELSE
    ulRow = vMid - (bHite \ 2)
  END IF

  ulCol = hMid - (bWidth \ 2)
  lrRow = bHite + ulRow - 1
  lrCol = bWidth + ulCol - 1

  tLen = 0
  FOR i = 1 TO numButtons                 ' Find spacing for buttons
    tLen = LEN(text$(i)) + tLen           ' Accumulate string length
  NEXT
  avgSpc = (lrCol - ulCol + 1 - tLen) \ (numButtons + 1)
  IF numButtons = 1 THEN oS = 1

  REDIM mouseBox(numChoices) AS Area

  FOR i = 1 TO numButtons                 ' Make button string
    button$ = button$ + STRING$(avgSpc, CHR$(32)) + text$(i)
    mouseBox(i).Y1 = lrRow - 1            ' Define mouse windows for buttons
    mouseBox(i).Y2 = mouseBox(i).Y1
    mouseBox(i).X1 = ulCol + LEN(button$) - (LEN(text$(i)) - 1 + oS)
    mouseBox(i).X2 = mouseBox(i).X1 + (LEN(text$(i)) - 1)
    mouseBox(i).RN = i
    dial(i).Row = mouseBox(i).Y1          ' Define row
    dial(i).Col = mouseBox(i).X1 + 2      ' Define column
    windowNum = windowNum + 1
  NEXT

  sz = ArraySize(ulRow, ulCol, lrRow + 1, lrCol + 2)
  REDIM Scrn(sz) ' The above line used to be "inline", but compile was failing - thus moved above.
  CALL MScrnSave(ulRow, ulCol, lrRow + 1, lrCol + 2, Scrn())
                      
  ' Draw the basic dialog box

  CALL ClearScr0(ulRow, ulCol, lrRow, lrCol, bClr)
  IF style > 4 THEN      'Paint drop shadow
    CALL PaintBox0(lrRow + 1, ulCol + 3, lrRow + 1, lrCol + 1, 8)
    CALL PaintBox0(ulRow + 1, lrCol + 1, lrRow + 1, lrCol + 2, 8)
  END IF

  style = style MOD 10
  CALL Box0(ulRow, ulCol, lrRow, lrCol, style, bClr)  ' Draw the box
  tLen = LEN(text$(0))
  LOCATE ulRow, hMid - (tLen \ 2)
  CALL QPrint0(text$(0), bClr)           ' Print the box title if there is one

  SELECT CASE style                      ' Determine appropriate line types for divider
    CASE 1: l = 195: r = 180: char = 196 ' horizontal line
    CASE 2: l = 204: r = 185: char = 205 ' double horizontal line
    CASE 3: l = 198: r = 181: char = 205 ' double horizontal line
    CASE 4: l = 199: r = 182: char = 196 ' single horizontl line
  END SELECT

  ' Draw divider between button line and the rest of the Dialog box
  divider$ = CHR$(l) + STRING$(lrCol - ulCol - 1, char) + CHR$(r)
  LOCATE lrRow - 2, ulCol
  CALL QPrint0(divider$, bClr)

  IF oS THEN button$ = RIGHT$(button$, (LEN(button$) - 1))
  LOCATE lrRow - 1, ulCol + 1
  CALL QPrint0(button$, bClr)

  rowPtr = 1
  FOR i = (numButtons + 1) TO upperBound
    SELECT CASE dial(i).DType                'Display based on type
      CASE 0            'Plain text
        rowPtr = rowPtr + 1
      CASE 2, 3         'Check box
        LOCATE ulRow + rowPtr, ulCol + 3
        CALL QPrint0(text$(i), bClr)
        mouseBox(windowNum).Y1 = ulRow + rowPtr    'Define mouse window
        mouseBox(windowNum).Y2 = mouseBox(windowNum).Y1
        mouseBox(windowNum).X1 = ulCol + 4
        mouseBox(windowNum).X2 = mouseBox(windowNum).X1 + LEN(text$(i)) - 2
        mouseBox(windowNum).RN = i
        dial(i).Row = mouseBox(windowNum).Y1         'Define row
        dial(i).Col = mouseBox(windowNum).X1         'Define column
        windowNum = windowNum + 1
        rowPtr = rowPtr + 1
      CASE 4            'Text in
        mW = (menuWidth + mOS) \ 2
        LOCATE ulRow + rowPtr, hMid - mW - 1 - (dial(i).TextLen \ 2)
        CALL QPrint0(text$(i), bClr)
        CALL Box0(ulRow + rowPtr + 1, hMid - mW - 1 - (dial(i).TextLen \ 2), ulRow + rowPtr + 3, hMid - mW - (dial(i).TextLen \ 2) + dial(i).TextLen, 1, bClr)
        mouseBox(windowNum).Y1 = ulRow + 2 + rowPtr
        mouseBox(windowNum).Y2 = mouseBox(windowNum).Y1
        mouseBox(windowNum).X1 = hMid - (dial(i).TextLen \ 2) - ((menuWidth + mOS) \ 2)
        mouseBox(windowNum).X2 = mouseBox(windowNum).X1 + dial(i).TextLen - 1
        mouseBox(windowNum).RN = i
        dial(i).Row = mouseBox(windowNum).Y1
        dial(i).Col = mouseBox(windowNum).X1
        windowNum = windowNum + 1
        rowPtr = rowPtr + 4
      CASE 5            'Menu
        dial(i).Row = ulRow + 4
        dial(i).Col = lrCol - menuWidth - 1
        LOCATE dial(i).Row - 2, dial(i).Col - 1
        CALL QPrint0(text$(i), BClr)
        CALL Box0(dial(i).Row - 1, dial(i).Col - 1, lrRow - 3, dial(i).Col + menuWidth, 1, bClr)
        mouseBox(windowNum).Y1 = dial(i).Row
        mouseBox(windowNum).Y2 = dial(i).Row + bHite - 9
        mouseBox(windowNum).X1 = dial(i).Col
        mouseBox(windowNum).X2 = dial(i).Col + menuWidth - 1 ' MouseBox(WindowNum).ULCol + Dial(i).TextLen - 1
        mouseBox(windowNum).RN = i
        windowNum = windowNum + 1
      CASE ELSE
    END SELECT
  NEXT

DispResponse:
  rowPtr = 1

  LOCATE , , 0
  FOR i = numButtons TO upperBound
    SELECT CASE dial(i).DType             ' Display Response$()
      CASE 0                              ' Plain text
        LOCATE ulRow + rowPtr, hMid - (LEN(text$(i)) \ 2) - ((menuWidth + mOS) \ 2)
        CALL QPrint0(text$(i), bClr)
        rowPtr = rowPtr + 1
      CASE 2, 3                           ' Check box
        IF LEN(response$(i)) THEN
          LOCATE ulRow + rowPtr, ulCol + 4
          CALL QPrint0(response$(i), bClr)
          IF response$(i) = dot$ THEN dotEl = i
        END IF
        rowPtr = rowPtr + 1
      CASE 4                              ' Text in
        LOCATE ulRow + 2 + rowPtr, hMid - (dial(i).TextLen \ 2) - ((menuWidth + mOS) \ 2)
        CALL QPrint0(response$(i), bClr)
        rowPtr = rowPtr + 4
      CASE 5                              ' Menu
        'CALL StuffBuf(CHR$(13))
        menuScanCode = 9999               'TODO: For testing purposes.
        hClr = bClr
        IF action = 2 THEN
          hClr = 15
          IF selection > UBOUND(menu$, 1) THEN selection = 1
          IF startItem > UBOUND(menu$, 1) THEN startItem = 1
        END IF
        CALL MAMenu(menu$(), 1, selection, startItem, UBOUND(menu$, 1), menuScanCode, bClr, hClr, bHite - 8, menuCols, 2, dial(itemNum).row, dial(itemNum).col)
        mCount = UBOUND(menu$, 1)
        response$(i) = ""                 ' Clear last choice
      CASE ELSE
    END SELECT
  NEXT
  LOCATE , , 1

  IF action <> 2 THEN
    lCount = numButtons
    IF numChoices > numButtons THEN       ' If we have more choices than buttons
      DO                                  ' Find and locate the cursor at the
        lCount = lCount + 1               '   first editable field
      LOOP UNTIL dial(lCount).DType
      LOCATE dial(lCount).Row, dial(lCount).Col, 1, 0, 7
      el = lCount
    ELSE                                  ' Else locate cursor at first button
      buttonsOnly = -1
      el = 1
    END IF
    ' If we only have button choices, locate cursor on first button
    IF ButtonsOnly THEN LOCATE Dial(1).Row, Dial(1).Col, 1, 0, 7
    CALL StuffBuf(CHR$(245))              ' Fall through loop first time
  ELSE                                    ' If were re-displaying, locate cursor in previous field
    IF LEN(temp$) THEN
      CALL StuffBuf(temp$)
    ELSE
      CALL StuffBuf(CHR$(245))            ' Fall through loop
    END IF
    action = 3
    LOCATE dial(el).Row, dial(el).Col
  END IF

  GOSUB HiLite                            ' HiLite Button 1 (Usually < OK >)
  CALL ShowCursor                         ' Turn on mouse cursor
  curCol = dial(el).Col

KeyLoop:
  DO
    DO
      ky$ = INKEY$
      IF LEN(ky$) THEN mFlag = 0
      'mButton = 0   EW: no longer needed
      CALL MouseRange(mouseBox(), 1, numChoices, mRow, mCol, mButton, rangeNum)
      IF mButton > 0 AND rangeNum THEN    ' If mouse down and its in a valid range
        IF rangeNum <> el THEN            ' If we havent already turned off hilite,
          hiLite = bClr                   '   turn off old HiLite
          GOSUB HiLite
        END IF
        el = rangeNum
        IF el <= numButtons THEN          ' If we've clicked on a button
          choice = el                     '   choice = button selected
          buttonDown = -1                 ' Remember that mouse button was pressed
          CALL PaintBox0(lrRow - 1, mouseBox(choice).X1 + 1, lrRow - 1, MouseBox(choice).X2 - 1, 15)
        END IF
        mFlag = -1                        ' Set Mouse flag
        choice = rangeNum
        Ky$ = CHR$(154)                   ' Dummy key to exit INKEY$ loop
      END IF
      ' If we've clicked on a button, wait 'till mouse button is up
      IF rangeNum <= numButtons AND mButton = 0 AND buttonDown THEN
        buttonDown = 0
        CALL PaintBox0(lrRow - 1, MouseBox(choice).X1 + 1, lrRow - 1, MouseBox(choice).X2 - 1, bClr)
        GOTO Done                         ' Exit Dialog box
      END IF
    LOOP UNTIL LEN(Ky$) OR Pressed
    
    IF NOT pressed THEN                   ' If a keystroke and not a mouse click
      IF LEN(ky$) < 2 THEN
        ky = ASC(ky$)
      ELSE
        ky = -ASC(RIGHT$(ky$, 1))
      END IF
    END IF

Again:
    SELECT CASE Ky
      CASE 9                              ' Tab
Again1:
        IF el <= numButtons THEN
          hiLite = bClr
          GOSUB HiLite
        END IF
        el = el + 1                       ' Inc Text$() element subscript
        choice = choice + 1               ' Keep track of which button is active
        IF el > upperBound OR numChoices = numButtons AND choice > numButtons THEN
          el = 1
          choice = 1
        END IF
      CASE -15                            ' Shift Tab
Again2:
        el = el - 1                       ' Dec Text$() element subscript
        IF el <= numButtons THEN
          hiLite = bClr
          GOSUB HiLite
        END IF
        IF el <= numButtons THEN
          choice = el                     ' Keep track of which button is active
        END IF
        IF el < 1 THEN
          el = upperBound
          choice = 1
        END IF
      CASE -72, -77                       ' Up, Right arrows
        IF dial(el).DType = 3 AND found THEN ' If we're on an Option button
          LOCATE dial(el).Row, dial(el).Col
          response$(el) = ""
          CALL QPrint0(" ", bClr)         ' Clear the last Dot
          el = el - 1
          IF el <= lastXBox - numXBoxes THEN el = lastXBox
          dotEl = el                      ' Remember where the new Dot is
          LOCATE dial(el).Row, dial(el).Col
          CALL QPrint0(dot$, bClr)        ' Print the new Dot
          response$(el) = dot$
          found = 0
        END IF
      CASE -75, -80                       ' Left, Down arrows
        IF dial(El).DType = 3 AND found THEN ' If we're on an Option button
          LOCATE dial(el).Row, dial(el).Col
          response$(el) = ""
          CALL QPrint0(" ", bClr)         ' Clear the last Dot
          el = el + 1
          IF el > lastXBox THEN el = lastXBox - numXBoxes + 1
          dotEl = el                      ' Remember where the new Dot is
          LOCATE dial(el).Row, dial(el).Col
          CALL QPrint0(dot$, bClr)        ' Print the new Dot
          response$(el) = dot$
          found = 0
        END IF
      CASE 32                             ' SpaceBar
        IF dial(el).DType = 2 THEN        ' If we're in a check box
          LOCATE dial(el).Row, dial(el).Col
          CALL HideCursor
          IF response$(el) <> check$ THEN ' If its not checked,
            CALL QPrint0(check$, bClr)    '   check it
            Response$(el) = check$
          ELSE                            ' If its checked,
            CALL QPrint0(" ", bClr)       '   clear it
            response$(el) = ""
          END IF
          CALL ShowCursor
        ELSE
          GOTO Done
        END IF
      CASE 27                             ' Escape
        GOTO Escape
      CASE 13                             ' Enter
        GOTO Done
      CASE ELSE                           ' Ignore all other keys
    END SELECT
    
    IF dial(el).DType <> 3 THEN found = 0 ' If were not on an Option button
                                          '   reset Found
    IF el > numButtons THEN choice = 1    ' If we're off the button line, make
                                          '   make Button #1, < OK > the default
    hiLite = hiClr
    GOSUB HiLite

    IF dial(el).DType = 3 AND NOT mFlag THEN ' Option button
      IF found = 0 THEN                   ' If its the first time we've entered an
        el = dotEl                        '   Option button field, locate cursor at dot
        found = -1
        LOCATE dial(el).Row, dial(el).Col, 1, 0, 7
                                          ' If we're already in an XBox field, find the next
      ELSEIF ky = 9 THEN                  '   non-XBox field, and locate the cursor (FORWARD)
        found = 0
        el = lastXBox
        GOTO Again1
                                          ' If we're already in an XBox field, find the next
      ELSEIF ky = -15 THEN                '   non-XBox field, and locate the cursor (BACKWARD)
        found = 0
        el = lastXBox - numXBoxes + 1
        GOTO Again2
      END IF
    ELSEIF dial(el).DType = 3 AND mFlag THEN ' If we've clicked on an Option
      CALL HideCursor                        '   button
      LOCATE dial(dotEl).Row, dial(dotEl).Col
      CALL QPrint0(" ", bClr)
      Response$(dotEl) = ""
      LOCATE dial(el).Row, dial(el).Col
      CALL QPrint0(dot$, bClr)
      Response$(el) = dot$
      CALL ShowCursor
      dotEl = el
      found = -1
    ELSEIF dial(el).DType = 0 THEN        ' Skip plain text lines
      IF ky = 9 THEN
        GOTO Again1
      ELSEIF ky = -15 THEN
        GOTO Again2
      END IF
    ELSEIF dial(el).DType = 2 THEN        ' If we've clicked on a Checkbox
      LOCATE dial(el).Row, dial(el).Col
      IF mButton THEN pressed = -1
      IF mButton = 0 AND pressed THEN
        pressed = 0
        CALL HideCursor
        IF response$(el) <> check$ THEN
          CALL QPrint0(check$, bClr)
          response$(el) = check$
        ELSE
          CALL QPrint0(" ", bClr)
          response$(el) = ""
        END IF
        CALL ShowCursor
      END IF
    ELSEIF dial(el).DType = 4 THEN        ' Text in box
      curCol = dial(el).Col
TextIn:
      edLen = dial(el).TextLen
      mERow = dial(el).Row
      mECol = dial(el).Col
      CALL MEditor(response$(el), edLen, scanCode, dial(el).NumFlag, 0, bClr, bClr, mERow, mECol, curCol)
      CALL MouseRange(mouseBox(), 1, numChoices, mRow, mCol, mButton, rangeNum)
      IF scanCode = 13 THEN               ' ENTER
        GOTO Done
      ELSEIF scanCode = 27 THEN           ' Escape
        GOTO Escape
                                          ' Escape keys supported by MEditor, but not Dialog
      ELSEIF scanCode > -132 AND scanCode < -58 OR scanCode > 31 AND scanCode < 127 OR scanCode = 8 THEN ' Extended key
        scanCode = 1
        GOTO TextIn
      ELSEIF scanCode = 1001 OR scanCode = 1002 THEN ' Middle or Right
        scanCode = 1                      ' mouse button
        GOTO TextIn
      ELSEIF scanCode = 1000 THEN         ' Left mouse button pressed outside MEditor
        IF rangeNum THEN                  ' If clicked in a valid Dialog range        '
          el = rangeNum                   '   set element to appropriate field
          IF el <= numButtons THEN
            hiLite = bClr                 ' turn off old HiLite
            GOSUB HiLite
            choice = el
            choice1 = choice
            buttonDown = -1
          END IF
          IF action = 3 THEN EXIT SUB
        ELSEIF NOT rangeNum THEN          ' If not clicked in a valid range
          scanCode = 1                    '   reset ScanCode
          GOTO TextIn                     '   go back to TextIn
        END IF
        LOCATE dial(el).Row, dial(el).Col, 1, 0, 7
        mFlag = -1
        ky = 0
        GOTO Again
      ELSEIF scanCode = -15 THEN
        mFlag = 0
        CALL StuffBuf(CHR$(0) + CHR$(15))
      ELSE
        mFlag = 0
        CALL StuffBuf(CHR$(9))
      END IF
    ELSEIF dial(el).DType = 5 THEN        ' Menu
Menu:
      LOCATE dial(el).Row, dial(el).Col
      menuScanCode = mSCode
      mRow = dial(itemNum).Row
      mCol = dial(itemNum).Col
      LOCATE , , 0  'EW: 12-24-95 turn off cursor for AMenu scrolling menus
      CALL MAMenu(menu$(), 1, selection, startItem, mCount, menuScanCode, bClr, 15, bHite - 8, menuCols, 2, mRow, mCol)
      CALL MouseRange(mouseBox(), 1, numChoices, mRow, mCol, mButton, rangeNum)
      response$(el) = menu$(selection)
      LOCATE , , 1   'EW: 12-24-95
      IF menuScanCode = 13 THEN           ' ENTER
        GOTO Done
      ELSEIF menuScanCode = 1003 THEN     ' Double click
        choice = 101
        choice1 = choice
        GOTO Done
      ELSEIF menuScanCode = 27 THEN       ' ESCAPE
        GOTO Escape
                                          ' Escape keys supported by MEditor, but not Dialog
      ELSEIF menuScanCode > -132 AND menuScanCode < -58 OR menuScanCode > 31 AND menuScanCode < 127 OR menuScanCode = 8 THEN ' Extended key
        mSCode = 3
        GOTO Menu
      ELSEIF menuScanCode = 1001 OR menuScanCode = 1002 THEN ' Middle or Right
        mSCode = 3                                           '   mouse button
        GOTO Menu
      ELSEIF menuScanCode = 1000 THEN     ' Left mouse button pressed outside MAMenu
        IF rangeNum THEN                  ' If clicked in a valid Dialog range        '
          el = rangeNum                   '   set element to appropriate field
          IF el <= numButtons THEN
            hiLite = bClr                 ' turn off old HiLite
            GOSUB HiLite
            choice = el
            choice1 = choice
            buttonDown = -1
          END IF
          IF action = 3 THEN EXIT SUB
        ELSEIF NOT rangeNum THEN          ' If not clicked in a valid range
          menuScanCode = 1                '   reset ScanCode
          GOTO Menu                       '   go back to MAMenu
        END IF
        LOCATE dial(el).Row, dial(el).Col, 1, 0, 7
        mFlag = -1
        ky = 0
        GOTO Again
      ELSEIF menuScanCode = -15 THEN
        mSCode = 3
        CALL StuffBuf(CHR$(0) + CHR$(15))
      ELSE
        mSCode = 3
        CALL StuffBuf(CHR$(9))
      END IF
    END IF

    IF dial(el).DType = 1 THEN
      LOCATE dial(el).Row, dial(el).Col, 1, 0, 7 ' Locate cursor at current button
    END IF                                       '   if were on a button

    choice1 = choice
    IF action = 3 THEN EXIT SUB

  LOOP

'-----Various GOSUBs

HiLite:                                   ' Hilites the currently active button
  CALL PaintBox0(lrRow - 1, mouseBox(choice).X1, lrRow - 1, mouseBox(choice).X1, hiLite)
  CALL PaintBox0(lrRow - 1, mouseBox(choice).X2, lrRow - 1, mouseBox(choice).X2, hiLite)
RETURN

Done:
  choice1 = choice
  IF INSTR(UCASE$(text$(choice MOD 100)), cancel$) THEN
    GOTO Escape
  END IF
  IF action = 0 OR action = 5 THEN
    firstXBox = (lastXBox + 1) - numXBoxes
    dot = dotEl - (firstXBox - 1)
    FOR i = firstXBox TO lastXBox         ' Return which option button is active
      response$(i) = STR$(dot)            '   in all option button elements, so
    NEXT                                  '   the programmer need only check one XBox
    DO
    LOOP WHILE KeyDown
    CALL HideCursor
    CALL MScrnRest(ulRow, ulCol, lrRow + 1, lrCol + 2, scrn())
    ERASE tResponse$ ',text$    'Un-rem for TextCopy
    action = 0
  ELSE
    action = 4
  END IF
  EXIT SUB

Escape:
  choice = -1
  choice1 = choice
  IF action = 0 OR action = 5 THEN
    IF numChoices > numButtons THEN
      FOR i = 1 TO upBound
        response$(i) = tResponse$(i)
      NEXT
    END IF
    DO
    LOOP WHILE KeyDown
    CALL HideCursor
    CALL MScrnRest(ulRow, ulCol, lrRow + 1, lrCol + 2, scrn())
    ERASE tResponse$', text$    'Un-REM for TextCopy
    action = 0
  ELSE
    action = 4
  END IF

END SUB

FUNCTION LongestStr1% (text$(), numButtons%, itemNum%)
  result% = 0
  FOR i% = numButtons% + 1 TO UBOUND(text$, 1)
    IF i% = itemNum% THEN GOTO ContinueFor
    IF LEN(text$(i%)) > result% THEN
      result% = LEN(text$(i%))
    END IF
ContinueFor:
  NEXT
  LongestStr1% = result%
END FUNCTION