' ********* Wipes.Bas - demonstrates various text screen wipes and fades

' by Don Malin
' Copyright (c) 1988 Crescent Software
' Modifications (c) 2023 Cory Smith

#INCLUDE "PRO.BI" ' MakeMono, MPRestore, MQPrint, MScrnSave, Pause, Pause3, 
                  ' ScrollD, ScrollL, ScrollR, ScrollU
                  ' FudgeFactor, MaxInt, MinInt, Peek1, TrapInt

'----- BASIC subprograms
DECLARE SUB CloseCurtain (orig() As Short, el As Short)
DECLARE SUB Dissolve (scr() As Short, el As Short)
DECLARE SUB Dissolve2 (ulRow As Short, ulCol As Short, lrRow As Short, lrCol As Short, scr() As Short, el As Short)
DECLARE SUB ExplodBox (ulRow As Short, ulCol As Short, lrRow As Short, lrCol As Short, scr() As Short, el As Short)
DECLARE SUB HorBlinds (scr() As Short, el As Short)
DECLARE SUB OpenCurtain (orig() As Short, oe As Short, newScr() As Short, ne As Short)
DECLARE SUB PauseKey (scr() As Short)
DECLARE SUB PushDown (scr() As Short, el As Short)
DECLARE SUB PushL2R (scr() As Short, el As Short)
DECLARE SUB PushR2L (scr() As Short, el As Short)
DECLARE SUB PushUp (scr() As Short, el As Short)
DECLARE SUB Puzzle (scr() As Short, el As Short)
DECLARE SUB Radar (scr() As Short, el As Short)
DECLARE SUB RoleAway (orig() As Short, oe As Short, newScr() As Short, ne As Short)
DECLARE SUB VertBlinds (scr() As Short, el As Short)
DECLARE SUB WindowClean (scr() As Short, el As Short)
DECLARE SUB WipeL2R (scr() As Short, el As Short)

DIM SHARED fudge As Long                       'so all the subprograms can use it

SCREEN 0 ' Force FB to reset the Windows Console window.
LOCATE ,, 0 ' Hide "text cursor".

'---- If you add these subprograms to your main program, remove the following:

REDIM dos(2000) As Short
MScrnSave 1, 1, 25, 80, @dos(0)

REDIM sc1(2000) As Short
' NOTE: FB's BLOAD doesn't appear to work here (locks up)...
'DEF SEG = VARSEG(sc1(0))
'BLOAD "CSDEMO.SCR", @sc1(0)      'Load the File into a Buffer
' NOTE: So using an alternate load routine.
BLOADA "CSDEMO.SCR", @sc1(0)

REDIM sc2(2000) As Short
'DEF SEG = VARSEG(sc2(0))
'BLOAD "ABOUT.SCR", @sc2(0)       'Load the File into a Buffer
BLOADA "ABOUT.SCR", @sc2(0)

IF Peek1(0, &H463) = &HB4 THEN         'if we're running on a mono monitor
  MakeMono @sc1(0), 2000                'strip the screen colors
  MakeMono @sc2(0), 2000
END IF

REDIM curt(2000) As Short
Dim curtS As String, n As Short, row As Short

DO

  curtS = SPACE$(80)
  FOR N = 1 TO 76 STEP 5
    MID$(curtS, n) = CHR$(176) + CHR$(177) + CHR$(178) + CHR$(177) + CHR$(176)
  NEXT
  FOR row = 1 TO 25
    LOCATE row, 1
    MQPrint curtS, 7
    Pause 1
  NEXT
  MScrnSave 1, 1, 25, 80, @curt(0)

  Pause 3

  OpenCurtain curt(), 0, sc1(), 0
  PauseKey dos()

  ExplodBox 1, 1, 25, 80, sc2(), 0
  PauseKey dos()

  PushL2R sc1(), 0
  PauseKey dos()

  Dissolve sc2(), 0
  'Dissolve2 1, 1, 25, 80, sc2(), 0
  PauseKey dos()

  RoleAway sc2(), 0, sc1(), 0
  PauseKey dos()

  Radar sc2(), 0
  PauseKey dos()

  PushR2L sc1(), 0
  PauseKey dos()

  vertBlinds sc2(), 0
  PauseKey dos()

  PushUp sc1(), 0
  PauseKey dos()

  WindowClean sc2(), 0
  PauseKey dos()

  WipeL2R sc1(), 0
  PauseKey dos()

  HorBlinds sc2(), 0
  PauseKey dos()

  Puzzle sc1(), 0
  PauseKey dos()

  CloseCurtain curt(), 0
  Pause 3
  OpenCurtain curt(), 0, dos(), 0

LOOP WHILE INKEY$ = ""

'---- If you add these subprograms to your main program remove the above code.

SUB CloseCurtain (orig() As Short, el As Short) STATIC

  Dim r As Short

  IF fudge = 0 THEN fudge = FudgeFactor    'do this once only

  FOR l As Short = 1 TO 39
    MPRestore 1, 1, 25, l, 80, @orig(40 - l + el)
    r = 81 - l
    MPRestore 1, r, 25, 80, 80, @orig(40 + el)
    Pause3 l, fudge
  NEXT

  MPRestore 1, 1, 25, 80, 80, @orig(el)

END SUB

SUB Dissolve (scr() As Short, el As Short) STATIC

  Dim lastLine As Short, r As Short, c As Short

  lastLine = UBOUND(scr) \ 80

  FOR co As Short = 3 TO 0 STEP -1
    FOR row As Short = 1 TO LastLine STEP 4
      FOR ro As Short = 3 TO 0 STEP -1
        r = row + ro
        IF r <= lastLine THEN
          FOR col As Short = 1 TO 77 STEP 4
            c = col + co + ro
            IF c > 80 THEN c = c - 80
            MPRestore r, c, r, c, 80, @scr((r - 1) * 80 + c - 1 + el)
          NEXT
        END IF
      NEXT
    NEXT
  NEXT

END SUB

SUB Dissolve2 (ulRow As Short, ulCol As Short, lrRow As Short, lrCol As Short, scr() As Short, el As Short) STATIC

  Dim lineSize As Short, numEls As Short, first As Short
  Dim element As Short, r As Short, c As Short

  lineSize = lrCol - ulCol + 1
  numEls = lineSize * (lrRow - ulRow + 1)
  first = 1
  REDIM scrBuf(1 TO numEls) As Short
  InitInt @scrBuf(first), 1, numEls
  RANDOMIZE TIMER

  FOR n As Short = numEls TO 1 STEP -1
    element = INT(RND * n) + first
    r = scrBuf(element) \ lineSize + ulRow
    c = scrBuf(element) MOD lineSize + ulCol - 1
    IF c < ulCol THEN r = r - 1: c = lrCol
    MPRestore r, c, r, c, 80, @scr((r - 1) * 80 + c - 1 + el)
    SWAP scrBuf(first), scrBuf(element)
    first = first + 1
  NEXT

END SUB

SUB ExplodBox (ulRow As Short, ulCol As Short, brRow As Short, brCol As Short, scr() As Short, el As Short) STATIC

  Dim midRow As Short, midCol As Short
  Dim mSec As Short
  Dim row As Short, bRow As Short, bCol As Short

  IF fudge = 0 THEN fudge = FudgeFactor

  midRow = (ulRow + brRow) \ 2
  midCol = (ulCol + brCol) \ 2

  mSec = MinInt(90 \ midRow, 360 \ midCol)

  FOR col As Short = midCol TO ulCol STEP -2
    row = MaxInt((midRow * col) \ midCol, 1)

    bRow = row + (midRow - row) * 2
    bCol = col + (midCol - col) * 2

    MPRestore row, col, bRow, bCol, 80, @scr((row - 1) * 80 + col - 1 + el)
    Pause3 mSec, fudge
  NEXT

  MPRestore ulRow, ulCol, brRow, brCol, 80, @scr((ulRow - 1) * 80 + ulCol - 1 + el)

END SUB

SUB HorBlinds (scr() As Short, el As Short) STATIC

  FOR n As Short = 0 TO 4
    FOR row As Short = 1 TO 21 STEP 5
      MPRestore row, 1, row + n, 80, 80, @scr((row - 1) * 80 + el)
    NEXT
    Pause 2
  NEXT

END SUB

SUB OpenCurtain (orig() As Short, oe As Short, newScr() As Short, ne As Short) STATIC

  Dim lastLine As Short, r As Short

  IF fudge = 0 THEN fudge = FudgeFactor    'do this once only
  lastLine = UBOUND(orig) \ 80

  FOR l As Short = 40 TO 2 STEP -1
    Pause3 l, fudge
    MPRestore 1, 1, lastLine, l - 1, 80, @orig(41 - l + oe)
    r = 81 - L
    MPRestore 1, r + 1, lastLine, 80, 80, @orig(40 + oe)
    MPRestore 1, l, lastLine, r, 80, @newScr(l - 1 + ne)
  NEXT

  MPRestore 1, 1, lastLine, 80, 80, @newScr(ne)

END SUB

SUB PauseKey (scr() As Short) STATIC

  Dim t As Single

  t = TIMER + 1
  DO
    IF LEN(INKEY$) THEN
      CloseCurtain scr(), 0
      END
    END IF
  LOOP UNTIL TIMER > t

END SUB

SUB PushDown (scr() As Short, el As Short) STATIC

  Dim lastLine As Short, row As Short

  lastLine = UBOUND(scr) \ 80

  FOR row = 1 TO lastLine - 1
    ScrollD row, 1, lastLine, 80, 1, 0
    MPRestore 1, 1, row, 80, 80, @scr((lastLine - row) * 80 + el)
    Pause 1
  NEXT

  MPRestore 1, 1, row, 80, 80, @scr((lastLine - row) * 80 + el)

END SUB

SUB PushL2R (scr() As Short, el As Short) STATIC

  Dim lastLine As Short

  lastLine = UBOUND(scr) \ 80

  FOR col As Short = 2 TO 80 STEP 2
    ScrollR 1, col - 1, lastLine, 80, 1, 0
    MPRestore 1, 1, lastLine, col, 80, @scr(81 - col - 1 + el)
  NEXT

END SUB

SUB PushR2L (scr() As Short, el As Short) STATIC

  Dim lastLine As Short

  lastLine = UBOUND(scr) \ 80

  FOR col As Short = 77 TO 1 STEP -2
    ScrollL 1, 1, lastLine, col + 2, 1, 0
    MPRestore 1, col, lastLine, 80, 80, @scr(el)
  NEXT
 
END SUB

SUB PushUp (scr() As Short, el As Short) STATIC

  Dim lastLine As Short, row As Short

  lastLine = UBOUND(scr) \ 80

  FOR row = lastLine TO 2 STEP -1
    ScrollU 1, 1, row, 80, 1, 0
    MPRestore row, 1, lastLine, 80, 80, @scr(el)
    Pause 1
  NEXT

  MPRestore row, 1, lastLine, 80, 80, @scr(el)

END SUB

SUB Puzzle (scr() As Short, el As Short) STATIC

  Dim pRows As Short, pCols As Short, rows As Short, cols As Short
  Dim size As Short, piece As Short, pieces As Short, n As Short
  Dim row As Short, col As Short
  Dim dr As Short, dc As Short, ro As Short, co As Short
  Dim rad As Single, slope As Single, ang As Single
  Dim m As Single, r As Single, c As Single
  Dim r2 As Short, c2 As Short

  RANDOMIZE TIMER
  REDIM scrBuf(2001) As Short

  pRows = 5
  pCols = 10
  rows = 25 \ pRows
  cols = 80 \ pCols

  size = pRows * pCols
  pieces = (2000 \ size)
  REDIM table(pieces) As Short

  FOR n = 1 TO pieces
    DO
      piece = INT(pieces * RND + 1)

      IF NOT table(piece) THEN
        table(piece) = -1
        row = ((piece - 1) \ cols) * pRows + 1
        col = ((piece - 1) MOD cols) * pCols + 1

        ' MovePiece - The following has "something wrong with it"
        '             the animation is garbled/turning into garbage
        '             need to dig in deeper - for now have switched
        '             to the alternate "non-shooting" version (see below)

        ' MScrnSave 1, 1, 25, 80, @scrBuf(1)

        ' dr = 25 - row
        ' dc = 80 - col
        ' ro = 0
        ' co = ro

        ' rad = SQR(dc ^ 2 + dr ^ 2)
        ' slope = dc / dr
        ' ang = ATN(slope)

        ' FOR m = rad TO 0 STEP -3

        '   r = m * COS(ang) + row
        '   c = m * SIN(ang) + col

        '   r2 = MinInt(25, r + pRows - 1)
        '   c2 = MinInt(80, c + pCols - 1)

        '   MPRestore r, c, r2, c2, 80, @scr((row - 1) * 80 + col - 1 + el)

        '   IF ro > r2 THEN MPRestore r2 + 1, c, ro, co, 80, @scrBuf((r2) * 80 + c)
        '   IF co > c2 THEN MPRestore r, c2 + 1, ro, co, 80, @scrBuf((r - 1) * 80 + c2 + 1)

        '   ro = r2
        '   co = c2

        ' NEXT

        ' r2 = row + pRows - 1
        ' c2 = col + pCols - 1

        ' MPRestore row, col, r2, c2, 80, @scr((row - 1) * 80 + col - 1 + el)

        ' IF ro > r2 THEN MPRestore r2 + 1, col, ro, co, 80, @scrBuf((r2) * 80 + col)
        ' IF co > c2 THEN MPRestore row, c2 + 1, ro, co, 80, @scrBuf((row - 1) * 80 + c2 + 1)

        ' *****  Replace the above with the following line to eliminate
        ' ***** the shooting boxes.
        MPRestore row, col, row + pRows - 1, col + pCols - 1, 80, @scr((row - 1) * 80 + col - 1 + el)

        EXIT DO
      END IF
    LOOP
  NEXT

  ERASE scrBuf

END SUB

SUB Radar (scr() As Short, el As Short) STATIC

  Dim e As Short, row As Short, col As Short, r As Short
  Dim slope As Single, sCol As Short

  e = -1 + el

  FOR col = 40 TO 80 STEP 8
    slope = (col - 40) / 12
    FOR row = 1 TO 12
      sCol = INT((13 - row) * slope) + 40
      MPRestore row, 40, row, sCol, 80, @scr((row - 1) * 80 + 40 + e)
    NEXT
  NEXT

  FOR row = 2 TO 12 STEP 1
    slope = 40 / (13 - row)
    FOR r = row TO 12
      sCol = INT((13 - r) * slope) + 40
      IF sCol > 80 THEN sCol = 80
      MPRestore 1, 40, r, sCol, 80, @scr(40 + e) 'scr((r - 1) * 80 + 40+e)
    NEXT
  NEXT

  FOR row = 13 TO 25 STEP 1
    slope = 40 / (row - 12)
    FOR r = 13 TO row
      sCol = INT((r - 12) * slope) + 40
      IF sCol > 80 THEN sCol = 80
      MPRestore r, sCol, r, 80, 80, @scr(((r - 1) * 80) + sCol + e)
    NEXT
  NEXT

  FOR col = 73 TO 1 STEP -8
    slope = (col - 39) / 13
    FOR row = 13 TO 25
      sCol = INT((row - 12) * slope) + 39
      MPRestore row, sCol, row, 80, 80, @scr((row - 1) * 80 + sCol + e)
    NEXT
  NEXT

  FOR row= 24 TO 13 STEP -1
    slope = 39 / (row - 12)
    FOR r = 13 TO row
      sCol = 39 - INT((r - 12) * slope)
      IF sCol < 1 THEN sCol = 1
      MPRestore r, sCol, r, 39, 80, @scr((r - 1) * 80 + sCol + e)
    NEXT
  NEXT

  FOR row = 12 TO 1 STEP -1
    slope = 39 / (row - 13)
    FOR r = 12 TO row STEP -1
      sCol = 39 - INT((r - 13) * slope)
      IF sCol < 1 THEN sCol = 1
      MPRestore r, 1, r, sCol, 80, @scr((r - 1) * 80 + 1 + e)
    NEXT
  NEXT

  FOR col = 8 TO 40 STEP 8
    slope = (39 - col) / 12
    FOR row = 1 TO 12
      sCol = 39 - INT((13 - row) * slope)
      MPRestore row, 1, row, sCol, 80, @scr((row - 1) * 80 + 1 + e)
    NEXT
  NEXT

END SUB

SUB RoleAway (orig() As Short, oe As Short, newScr() As Short, ne As Short) STATIC

  Dim wide As Short

  IF fudge = 0 THEN fudge = FudgeFactor

  FOR c As Short = 79 TO 1 STEP -1
    wide = TrapInt(80 - c + 1, 1, 10)
    MPRestore 1, c, 25, c, 80, @orig(c + oe)

    Pause3 9, fudge

    IF c > 2 THEN ScrollL 1, MaxInt(1, c - wide), 25, c, 2, 0
    MPRestore 1, c, 25, c + 1, 80, @newScr(c - 1 + ne)
  NEXT

END SUB

SUB VertBlinds (scr() As Short, el As Short) STATIC

  Dim lastLine As Short

  lastLine = UBOUND(scr) \ 80

  FOR n As Short = 0 TO 9
    FOR col As Short = 1 TO 71 STEP 10
      MPRestore 1, col, lastLine, col + n, 80, @scr(col - 1 + el)
    NEXT
    Pause 1
  NEXT

END SUB

SUB WindowClean (scr() As Short, el As Short) STATIC

  Dim rad As Single, da As Short, lRad As Short, radRow As Single
  Dim row As Single, col As Single
  Dim row2 As Single, col2 As Single
  Dim theta As Single
 
  da = 21
  lRad = 3
  DO

    FOR ad As Short = 0 TO 360 STEP da

      theta = ad * (3.14156 / 180)

      rad = (11 / 360) * ad + lRad
      radRow = rad * .3125

      row = radRow * COS(theta) + 10
      col = rad * SIN(theta) + 39

      row2 = row + 4
      col2 = col + 10

      row = MinInt(MaxInt(row, 1), 25)
      col = MinInt(MaxInt(col, 1), 80)
      row2 = MinInt(MaxInt(row2, 1), 25)
      col2 = MinInt(MaxInt(col2, 1), 80)

      MPRestore row, col, row2, col2, 80, @scr((row - 1) * 80 + col - 1 + el)

    NEXT

    lRad = rad
    da = da - 4

  LOOP UNTIL rad >= 50

END SUB

SUB WipeL2R (scr() As Short, el As Short) STATIC

  Dim lastLine As Short

  IF fudge = 0 THEN fudge = FudgeFactor    ' do this once only
  lastLine = UBOUND(scr) \ 80

  FOR col As Short = 2 TO 80 STEP 2
    MPRestore 1, 1, lastLine, col, 80, @scr(80 - col + el)
    Pause3 10, fudge
  NEXT

END SUB