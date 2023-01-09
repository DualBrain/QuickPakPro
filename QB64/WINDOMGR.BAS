' ********** WINDOMGR.BAS - complete multi-level window manager

' Copyright (c) 1988 Ethan Winer
' Modifications (c) 2023 Cory Smith

DEFINT A-Z

DECLARE FUNCTION ArraySize% (ulRow, ulCol, lrRow, lrCol)
DECLARE SUB Box (ulRow, ulCol, lrRow, lrCol, boxStyle, colr, page)
DECLARE SUB ClearScr (ulRow, ulCol, lrRow, lrCol, colr, page)

'DECLARE SUB ScrnSave (ulRow, ulCol, lrRow, lrCol, BYVAL segment, BYVAL address, page)
'DECLARE SUB ScrnRest (ulRow, ulCol, lrRow, lrCol, BYVAL segment, BYVAL address, page)
'
' These DECLARE statements are REM'd out because some of the other QuickPak
' Professional subprograms use ScrnSave and ScrnRest with the alternate SEG
' Element syntax.  Attempting to use both in the same program confuses the QB
' environment.  If you receive an "Argument count mismatch" error on ScrnSave
' or ScrnRest in another program, you will have to REM out the DECLARE
' statements there as well, and add the CALL keyword.  This is not a problem
' once programs have been compiled, because each module is truly separate.

' ********** WINDOMGR.BAS - "front end" to simplify accessing multiple windows
'
' Copyright (c) 1987 Ethan Winer
' Modifications (c) 2023 Cory Smith
'
' WindowNumber% can range from 1 to 10, but 0 means open/close next/prior
' Action% is 1 to open a window, 0 to close it
' ULRow%, ULCol%, etc. define the window boundaries
' Colr% is the color for the box border, if the color is zero no box is drawn
'
' If any corner parameters are zero when closing, the original corners are
' used, so you don't have to keep specifying the same parameters each time.
'
SUB WindowMgr (windowNumber%, action%, ulRow%, ulCol%, lrRow%, lrCol%, colr%) STATIC

  STATIC curWindow%                             ' the last open window
  STATIC init%                                  ' tells if we've been here yet
  STATIC table%()                               ' saves original corners

  ' Added the following line as it appears that QB64 doesn't 
  ' *STATIC* local arrays in the same way as QB45.
  STATIC a1%(), a2%(), a3%(), a4%(), a5%(), a6%(), a7%(), a8%(), a9%(), a10%()

  IF init% = 0 THEN                             ' manager hasn't been used yet
    init% = 1                                   ' now it has
    REDIM table%(10, 4)                         ' saves corner parameters
  END IF

  w% = WindowNumber%                                  ' work with a copy
  IF action% = 1 THEN curWindow% = curWindow% + 1     ' open next window

  IF w% > curWindow% THEN             ' they went past the last active window
    curWindow% = w%                   '   so make the current window last
  ELSEIF w% = 0 THEN                  ' no window specified, so use
    w% = curWindow%                   '   the next available window
  END IF
                                                        ' in case they weren't
  IF curWindow% < 1 OR curWindow% > 10 THEN EXIT SUB    '   paying attention
      
  IF action% = 1 THEN                        ' opening a window

    ' calculate the memory needed to save this portion of the screen
    size% = ArraySize%(ulRow%, ulCol%, lrRow%, lrCol%)

    table%(w%, 1) = ulRow%                   ' save the corners so
    table%(w%, 2) = ulCol%                   '   we can close the
    table%(w%, 3) = lrRow%                   '   window later, even
    table%(w%, 4) = lrCol%                   '   if the corners are
                                             '   omitted in the call
    SELECT CASE w%                           ' make array to hold the screen
      CASE 1: REDIM a1%(size%)
      CASE 2: REDIM a2%(size%)
      CASE 3: REDIM a3%(size%)
      CASE 4: REDIM a4%(size%)
      CASE 5: REDIM a5%(size%)
      CASE 6: REDIM a6%(size%)
      CASE 7: REDIM a7%(size%)
      CASE 8: REDIM a8%(size%)
      CASE 9: REDIM a9%(size%)
      CASE 10: REDIM a10%(size%)
      CASE ELSE: EXIT SUB
    END SELECT

  END IF

  ' SELECT CASE w%
  '   CASE 1: segment% = VARSEG(a1%(0)): address% = VARPTR(a1%(0))
  '   CASE 2: segment% = VARSEG(a2%(0)): address% = VARPTR(a2%(0))
  '   CASE 3: segment% = VARSEG(a3%(0)): address% = VARPTR(a3%(0))
  '   CASE 4: segment% = VARSEG(a4%(0)): address% = VARPTR(a4%(0))
  '   CASE 5: segment% = VARSEG(a5%(0)): address% = VARPTR(a5%(0))
  '   CASE 6: segment% = VARSEG(a6%(0)): address% = VARPTR(a6%(0))
  '   CASE 7: segment% = VARSEG(a7%(0)): address% = VARPTR(a7%(0))
  '   CASE 8: segment% = VARSEG(a8%(0)): address% = VARPTR(a8%(0))
  '   CASE 9: segment% = VARSEG(a9%(0)): address% = VARPTR(a9%(0))
  '   CASE 10: segment% = VARSEG(a10%(0)): address% = VARPTR(a10%(0))
  '   CASE ELSE
  ' END SELECT
      
  IF action% = 1 THEN
    ' CALL ScrnSave(ulRow%, ulCol%, lrRow%, lrCol%, BYVAL segment%, BYVAL address%, -1)
    SELECT CASE w%
      CASE 1: CALL ScrnSave(ulRow%, ulCol%, lrRow%, lrCol%, a1%(), -1)
      CASE 2: CALL ScrnSave(ulRow%, ulCol%, lrRow%, lrCol%, a2%(), -1)
      CASE 3: CALL ScrnSave(ulRow%, ulCol%, lrRow%, lrCol%, a3%(), -1)
      CASE 4: CALL ScrnSave(ulRow%, ulCol%, lrRow%, lrCol%, a4%(), -1)
      CASE 5: CALL ScrnSave(ulRow%, ulCol%, lrRow%, lrCol%, a5%(), -1)
      CASE 6: CALL ScrnSave(ulRow%, ulCol%, lrRow%, lrCol%, a6%(), -1)
      CASE 7: CALL ScrnSave(ulRow%, ulCol%, lrRow%, lrCol%, a7%(), -1)
      CASE 8: CALL ScrnSave(ulRow%, ulCol%, lrRow%, lrCol%, a8%(), -1)
      CASE 9: CALL ScrnSave(ulRow%, ulCol%, lrRow%, lrCol%, a9%(), -1)
      CASE 10: CALL ScrnSave(ulRow%, ulCol%, lrRow%, lrCol%, a10%(), -1)
      CASE ELSE
    END SELECT
    ClearScr ulRow%, ulCol%, lrRow%, lrCol%, colr%, -1
    IF colr% THEN Box ulRow%, ulCol%, lrRow%, lrCol%, 2, colr%, -1
  ELSE ' change this 2 to a 1 for a single line box --^
    IF ulRow% = 0 OR ulCol% = 0 OR lrRow% = 0 OR lrCol% = 0 THEN
      'CALL ScrnRest(table%(w%, 1), table%(w%, 2), table%(w%, 3), table%(w%, 4), BYVAL segment%, BYVAL address%, -1)
      SELECT CASE w%
        CASE 1: CALL ScrnRest(table%(w%, 1), table%(w%, 2), table%(w%, 3), table%(w%, 4), a1%(), -1)
        CASE 2: CALL ScrnRest(table%(w%, 1), table%(w%, 2), table%(w%, 3), table%(w%, 4), a2%(), -1)
        CASE 3: CALL ScrnRest(table%(w%, 1), table%(w%, 2), table%(w%, 3), table%(w%, 4), a3%(), -1)
        CASE 4: CALL ScrnRest(table%(w%, 1), table%(w%, 2), table%(w%, 3), table%(w%, 4), a4%(), -1)
        CASE 5: CALL ScrnRest(table%(w%, 1), table%(w%, 2), table%(w%, 3), table%(w%, 4), a5%(), -1)
        CASE 6: CALL ScrnRest(table%(w%, 1), table%(w%, 2), table%(w%, 3), table%(w%, 4), a6%(), -1)
        CASE 7: CALL ScrnRest(table%(w%, 1), table%(w%, 2), table%(w%, 3), table%(w%, 4), a7%(), -1)
        CASE 8: CALL ScrnRest(table%(w%, 1), table%(w%, 2), table%(w%, 3), table%(w%, 4), a8%(), -1)
        CASE 9: CALL ScrnRest(table%(w%, 1), table%(w%, 2), table%(w%, 3), table%(w%, 4), a9%(), -1)
        CASE 10: CALL ScrnRest(table%(w%, 1), table%(w%, 2), table%(w%, 3), table%(w%, 4), a10%(), -1)
        CASE ELSE
      END SELECT
    ELSE
      'CALL ScrnRest(ulRow%, ulCol%, lrRow%, lrCol%, BYVAL segment%, BYVAL address%, -1)
      SELECT CASE w%
        CASE 1: CALL ScrnRest(ulRow%, ulCol%, lrRow%, lrCol%, a1%(), -1)
        CASE 2: CALL ScrnRest(ulRow%, ulCol%, lrRow%, lrCol%, a2%(), -1)
        CASE 3: CALL ScrnRest(ulRow%, ulCol%, lrRow%, lrCol%, a3%(), -1)
        CASE 4: CALL ScrnRest(ulRow%, ulCol%, lrRow%, lrCol%, a4%(), -1)
        CASE 5: CALL ScrnRest(ulRow%, ulCol%, lrRow%, lrCol%, a5%(), -1)
        CASE 6: CALL ScrnRest(ulRow%, ulCol%, lrRow%, lrCol%, a6%(), -1)
        CASE 7: CALL ScrnRest(ulRow%, ulCol%, lrRow%, lrCol%, a7%(), -1)
        CASE 8: CALL ScrnRest(ulRow%, ulCol%, lrRow%, lrCol%, a8%(), -1)
        CASE 9: CALL ScrnRest(ulRow%, ulCol%, lrRow%, lrCol%, a9%(), -1)
        CASE 10: CALL ScrnRest(ulRow%, ulCol%, lrRow%, lrCol%, a10%(), -1)
        CASE ELSE
      END SELECT
    END IF
  END IF
      
  IF action% = 0 THEN

    SELECT CASE w%
      CASE 1: ERASE a1%
      CASE 2: ERASE a2%
      CASE 3: ERASE a3%
      CASE 4: ERASE a4%
      CASE 5: ERASE a5%
      CASE 6: ERASE a6%
      CASE 7: ERASE a7%
      CASE 8: ERASE a8%
      CASE 9: ERASE a9%
      CASE 10: ERASE a10%
      CASE ELSE
    END SELECT

    curWindow% = curWindow% - 1      ' show the prior window as being
                                     '   the active one for next time
  END IF

END SUB