' ********** WindoMgr.Bas - complete multi-level window manager

' Copyright (c) 1988 Ethan Winer
' Modifications (c) 2023 Cory Smith

#INCLUDE "PRO.BI" ' ArraySize, Box, ClearScr, ScrnSave, ScrnRest

' ********** WindoMgr.Bas - "front end" to simplify accessing multiple windows
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
'
SUB WindowMgr (windowNumber As Short, action As Short, ulRow As Short, ulCol As Short, lrRow As Short, lrCol As Short, colr As Short) STATIC

  STATIC curWindow As Short                               'the last open window
  STATIC init As Short                                    'tells if we've been here yet
  STATIC table() As Short                                 'saves original corners

  Dim w As Short
  Dim size As Short, a1() As Short, a2() As Short, a3() As Short, a4() As Short, a5() As Short, a6() As Short, a7() As Short, a8() As Short, a9() As Short, a10() As Short

  IF init = 0 THEN                           'manager hasn't been used yet
    init = 1                                'now it has
    REDIM table(10, 4)                      'saves corner parameters
  END IF

  w = windowNumber                                  'work with a copy
  IF action = 1 THEN curWindow = curWindow + 1     'open next window

  IF w > curWindow THEN             'they went past the last active window
    curWindow = w                  '  so make the current window last
  ELSEIF w = 0 THEN                  'no window specified, so use
    w = curWindow                  '  the next available window
  END IF
                                                        'in case they weren't
  IF curWindow < 1 OR curWindow > 10 THEN EXIT SUB  '  paying attention
    
  IF action = 1 THEN                         'opening a window

    'calculate the memory needed to save this portion of the screen
    size = ArraySize(ulRow, ulCol, lrRow, lrCol)

    table(w, 1) = ulRow                   'save the corners so
    table(w, 2) = ulCol                   '  we can close the
    table(w, 3) = lrRow                   '  window later, even
    table(w, 4) = lrCol                   '  if the corners are
                                            '  omitted in the call
    IF w = 1 THEN                           'make array to hold the screen
      REDIM a1(size)
    ELSEIF w = 2 THEN
      REDIM a2(size)
    ELSEIF w = 3 THEN
      REDIM a3(size)
    ELSEIF w = 4 THEN
      REDIM a4(size)
    ELSEIF w = 5 THEN
      REDIM a5(size)
    ELSEIF w = 6 THEN
      REDIM a6(size)
    ELSEIF w = 7 THEN
      REDIM a7(size)
    ELSEIF w = 8 THEN
      REDIM a8(size)
    ELSEIF w = 9 THEN
      REDIM a9(size)
    ELSEIF w = 10 THEN
      REDIM a10(size)
    ELSE
      EXIT SUB
    END IF
  END IF
      
  Dim address As Any Ptr

  IF w = 1 THEN
    address = VARPTR(a1(0))
  ELSEIF w = 2 THEN
    address = VARPTR(a2(0))
  ELSEIF w = 3 THEN
    address = VARPTR(a3(0))
  ELSEIF w = 4 THEN
    address = VARPTR(a4(0))
  ELSEIF w = 5 THEN
    address = VARPTR(a5(0))
  ELSEIF w = 6 THEN
    address = VARPTR(a6(0))
  ELSEIF w = 7 THEN
    address = VARPTR(a7(0))
  ELSEIF w = 8 THEN
    address = VARPTR(a8(0))
  ELSEIF w = 9 THEN
    address = VARPTR(a9(0))
  ELSEIF w = 10 THEN
    address = VARPTR(a10(0))
  END IF
      
  IF action = 1 THEN
    ScrnSave ulRow, ulCol, lrRow, lrCol, BYVAL address, -1
    ClearScr ulRow, ulCol, lrRow, lrCol, colr, -1
    IF colr THEN Box ulRow, ulCol, lrRow, lrCol, 2, colr, -1
  ELSE ' change 2 to a 1 for a single line box --^
    IF ulRow = 0 OR ulCol = 0 OR lrRow = 0 OR lrCol = 0 THEN
      ScrnRest table(w, 1), table(w, 2), table(w, 3), table(w, 4), BYVAL address, -1
    ELSE
      ScrnRest ulRow, ulCol, lrRow, lrCol, BYVAL address, -1
    END IF
  END IF
      
  IF action = 0 THEN

    IF w = 1 THEN
      ERASE a1
    ELSEIF w = 2 THEN
      ERASE a2
    ELSEIF w = 3 THEN
      ERASE a3
    ELSEIF w = 4 THEN
      ERASE a4
    ELSEIF w = 5 THEN
      ERASE a5
    ELSEIF w = 6 THEN
      ERASE a6
    ELSEIF w = 7 THEN
      ERASE a7
    ELSEIF w = 8 THEN
      ERASE a8
    ELSEIF w = 9 THEN
      ERASE a9
    ELSEIF w = 10 THEN
      ERASE a10
    END IF

    curWindow = curWindow - 1      'show the prior window as being
                                   '  the active one for next time
  END IF

END SUB

