' ********** CALENDAR.BAS - pop-up calendar
' Copyright (c) 1988 by Harald Zoschke
' Copyright (c) 1988 by Crescent Software
' Modifications (c) 2023 Cory Smith

' Displaying and removing the calendar is accomplished by the same call,
' the only difference is the contents of the switch variable Action
' (Action = 1 to show calendar, Action = 0 to remove it).
'
' QuickPak assembly routines used: ScrnRest0, ScrnSave0, QPrint0
'
' Important variables:
'
' Mnth -   month (1 ... 12)
' Yr  -   4 places (YYYY)
' Dy   - the day to be highlighted
' ULRow, ULCol - upper left corner of calendar
' Action - indicates whether to show or clear the display: -1=Show, 0=Clear
' Color1 - color to use for the calendar border frame
' Color2 - color to use for the day names and numbers

#INCLUDE "PRO.BI" ' ScrnSave0, ScrnRest0, QPrint0

QPCName_List:
   DATA "January", "February", "March", "April", "May", "June"
   DATA "July", "August", "September", "October", "November", "December"

SUB Calendar_QPCCalc (Byref temp1 As Short, Byref temp2 As Short, yr As Short, mnth As Short, Byref nextMon_First As Single)
  temp1 = mnth + 13
  temp2 = yr - 1
  IF mnth > 2 THEN
    temp1 = mnth + 1
    temp2 = yr
  END IF
  nextMon_First = INT(365.25 * temp2) - 693975 + INT(30.6 * temp1)
END SUB

' Calendar subroutine by Harald Zoschke
' Copyright (c) 1988 Crescent Software
' Modifications (c) 2023 Cory Smith
'
SUB Calendar (iMonth As Short, iDay As Short, iYear As Short, ulRow As Short, ulCol As Short, colr1 As Short, colr2 As Short, action As Short) STATIC

  Dim moname As String, temp1 As Short, temp2 As Short
  Dim nextMon_First As Single, mon_First As Single
  Dim dayOfWeek As Short, oldColor As Short
  Dim mnth As Short, dy As Short, yr As Short
  Dim ulRow1 As Short, lrRow As Short, ulCol1 As Short, lrCol As Short
  Dim v As Short, h As Short

  mnth = iMonth: dy = iDay: yr = iYear            'preserve incoming variables

  ulRow1 = ulRow: lrRow = ulRow + 11                      'frame parameters
  ulCol1 = ulCol: lrCol = ulCol + 23
  v = CSRLIN: h = POS(0)                                  'save the cursor

  REDIM a(288) As short                                      'holds the screen 

  IF Action THEN
    ScrnSave0 ulRow1, ulCol1, lrRow, lrCol, @a(0)   'save screen
  ELSE
    ScrnRest0 ulRow1, ulCol1, lrRow, lrCol, @a(0)   'restore old screen
    ERASE a
    GOTO QPCDone
  END IF

  'draw frame

  LOCATE ulRow1, ULCol1
  QPrint0 CHR$(201) + STRING$(22, CHR$(205)) + CHR$(187), colr1
  LOCATE ulRow1 + 1
  QPrint0 CHR$(186) + STRING$(22, " ") + CHR$(186), colr1
  LOCATE ulRow1 + 2
  QPrint0 CHR$(204) + STRING$(22, CHR$(205)) + CHR$(185), colr1
  LOCATE ulRow1 + 3
  QPrint0 CHR$(186) + STRING$(22, " ") + CHR$(186), colr1
  LOCATE ulRow1 + 4
  QPrint0 CHR$(204) + STRING$(22, CHR$(205)) + CHR$(185), colr1
  FOR x As Short = ulRow1 + 5 TO ulRow1 + 10
    LOCATE x
    QPrint0 CHR$(186) + SPACE$(22) + CHR$(186), colr1
  NEXT
  LOCATE ulRow1 + 11
  QPrint0 CHR$(200) + STRING$(22, CHR$(205)) + CHR$(188), colr1

  'calculate and display calendar

  RESTORE QPCName_List
  FOR m As Short = 1 TO mnth
    READ moname
  NEXT m

  'GOSUB QPCCalc
  Calendar_QPCCalc temp1, temp2, yr, mnth, NextMon_First
  Mon_First = NextMon_First
  LOCATE ulRow1 + 1, ulCol1 + 3, 0
  QPrint0 " " + LEFT$(moname + SPACE$(10), 10) + STR$(yr) + SPACE$(4), colr2
  ulRow1 = ulRow1 + 3
  LOCATE ulRow1, ulCol1 + 1
  QPrint0 " Su Mo Tu We Th Fr Sa", colr2  'Germany: " Mo Di Mi Do Fr Sa So"

  dayOfWeek = NextMon_First - INT(NextMon_First / 7) * 7 + 1 'Germany: w/o +1
  ulRow1 = ulRow1 + 2
  LOCATE ulRow1, ulCol1 + 1
  IF dayOfWeek <> 7 THEN
    QPrint0 SPACE$(dayOfWeek * 3), colr1 'Germany: * 4
    LOCATE , POS(0) + dayOfWeek * 3
  END IF
  mnth = mnth - INT(mnth / 12.1) * 12 + 1
  IF mnth = 1 THEN yr = yr + 1

  'GOSUB QPCCalc
  Calendar_QPCCalc temp1, temp2, yr, mnth, NextMon_First

  oldColor = (colr2 AND 112) / 16 + (colr2 AND 15) * 16 AND 127
  FOR x As Short = 1 TO NextMon_First - Mon_First
    QPrint0 " ", colr2
    LOCATE , POS(0) + 1
    IF x = dy THEN
      SWAP colr2, oldColor           'the day to highlight
    END IF
    QPrint0 RIGHT$(" " + STR$(x), 2), colr2
    IF x = dy THEN SWAP colr2, oldColor
    LOCATE , POS(0) + 2
    dayOfWeek = dayOfWeek + 1
    IF INT(dayOfWeek / 7) = dayOfWeek / 7 THEN    'new line for next week
      ulRow1 = ulRow1 + 1
      LOCATE ulRow1, ulCol1 + 1
    END IF
  NEXT

  GOTO QPCDone            'all done

QPCDone:
  LOCATE v, h, 0               'Alte Werte f�r Screen-Restore wiederhFirst.

END SUB