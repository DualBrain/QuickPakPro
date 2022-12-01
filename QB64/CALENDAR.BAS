' ********** CALENDAR.BAS - pop-up calendar

' Copyright (c) 1988 by Harald Zoschke
' Copyright (c) 1988 by Crescent Software
' Modifications (c) 2022 Cory Smith

' Displaying and removing the calendar is accomplished by the same call,
' the only difference is the contents of the switch variable Action
' (Action = 1 to show calendar, Action = 0 to remove it).
'
' QuickPak assembly routines used: ScrnRest0, ScrnSave0, QPrint0
'
' Important variables:
'
' mnth -   month (1 ... 12)
' yr  -   4 places (YYYY)
' dy   - the day to be highlighted
' ulRow, ulCol - upper left corner of calendar
' action - indicates whether to show or clear the display: -1=Show, 0=Clear
' color1 - color to use for the calendar border frame
' color2 - color to use for the day names and numbers

DEFINT A-Z

DECLARE SUB ScrnSave0 (ULRow, ULCol, LRRow, LRCol, SEG Address)
DECLARE SUB ScrnRest0 (ULRow, ULCol, LRRow, LRCol, SEG Address)
DECLARE SUB QPrint0 (X$, Colr)

' QPCName.List:
'   DATA January, February, March, April, May, June
'   DATA July, August, September, October, November, December

' Calendar subroutine by Harald Zoschke
' Copyright (c) 1988 Crescent Software
' Modifications (c) 2022 Cory Smith
SUB Calendar (iMonth, iDay, iYear, ulRow, ulCol, colr1, colr2, action) STATIC

mnth = iMonth: dy = iDay: yr = iYear            'preserve incoming variables

ulRow1 = ulRow: lrRow = ulRow + 11                      'frame parameters
ulCol1 = ulCol: lrCol = ulCol + 23
v = CSRLIN: h = POS(0)                                  'save the cursor

IF action THEN
  REDIM a(288)                                         'holds the screen
  CALL ScrnSave0(ulRow1, ulCol1, lrRow, lrCol, a())   'save screen
ELSE
  CALL ScrnRest0(ulRow1, ulCol1, lrRow, lrCol, a())   'restore old screen
  ERASE a
  GOTO QPCDone
END IF

GOSUB QPCFrame          'draw frame
GOSUB QPCCalendar       'calculate and display calendar
GOTO QPCDone            'all done

QPCCalendar: 
  GOSUB QPCMonth.Name
  GOSUB QPCCalc
  Mon.First! = NextMon.First!
  LOCATE ULRow1 + 1, ULCol1 + 3, 0
  CALL QPrint0(" " + LEFT$(Moname$ + SPACE$(10), 10) + STR$(Yr) + SPACE$(4), Colr2)
  ULRow1 = ULRow1 + 3
  LOCATE ULRow1, ULCol1 + 1
  CALL QPrint0(" Su Mo Tu We Th Fr Sa", Colr2)  'Germany: " Mo Di Mi Do Fr Sa So"

  DayOfWeek = NextMon.First! - INT(NextMon.First! / 7) * 7 + 1 'Germany: w/o +1
  ULRow1 = ULRow1 + 2
  LOCATE ULRow1, ULCol1 + 1
  IF DayOfWeek <> 7 THEN
    CALL QPrint0(SPACE$(DayOfWeek * 3), Colr1) 'Germany: * 4
    LOCATE , POS(0) + DayOfWeek * 3
  END IF
  Mnth = Mnth - INT(Mnth / 12.1) * 12 + 1
  IF Mnth = 1 THEN Yr = Yr + 1
  GOSUB QPCCalc

  OldColor = (Colr2 AND 112) / 16 + (Colr2 AND 15) * 16 AND 127
  FOR X = 1 TO NextMon.First! - Mon.First!
    CALL QPrint0(" ", Colr2)
    LOCATE , POS(0) + 1
    IF X = Dy THEN
      SWAP Colr2, OldColor           'the day to highlight
    END IF
    CALL QPrint0(RIGHT$(" " + STR$(X), 2), Colr2)
    IF X = Dy THEN SWAP Colr2, OldColor
    LOCATE , POS(0) + 2
    DayOfWeek = DayOfWeek + 1
    IF INT(DayOfWeek / 7) = DayOfWeek / 7 THEN    'new line for next week
      ULRow1 = ULRow1 + 1
      LOCATE ULRow1, ULCol1 + 1
    END IF
  NEXT
  RETURN

QPCCalc:                      'calculate calendar
  Temp1 = Mnth + 13
  Temp2 = Yr - 1
  IF Mnth > 2 THEN
    Temp1 = Mnth + 1
    Temp2 = Yr
  END IF
  NextMon.First! = INT(365.25 * Temp2) - 693975 + INT(30.6 * Temp1)
  RETURN

QPCMonth.Name:
  'RESTORE QPCName.List
  'FOR M = 1 TO Mnth
  '  READ Moname$
  'NEXT M
  SELECT CASE Mnth
    CASE 1: Moname$ = "January"
    CASE 2: Moname$ = "February"
    CASE 3: Moname$ = "March"
    CASE 4: Moname$ = "April"
    CASE 5: Moname$ = "May"
    CASE 6: Moname$ = "June"
    CASE 7: Moname$ = "July"
    CASE 8: Moname$ = "August"
    CASE 9: Moname$ = "September"
    CASE 10: Moname$ = "October"
    CASE 11: Moname$ = "November"
    CASE 12: Moname$ = "December"
    CASE ELSE: Moname$ = ""
  END SELECT
  RETURN

QPCFrame:
  LOCATE ULRow1, ULCol1
  CALL QPrint0(CHR$(201) + STRING$(22, CHR$(205)) + CHR$(187), Colr1)
  LOCATE ULRow1 + 1
  CALL QPrint0(CHR$(186) + STRING$(22, " ") + CHR$(186), Colr1)
  LOCATE ULRow1 + 2
  CALL QPrint0(CHR$(204) + STRING$(22, CHR$(205)) + CHR$(185), Colr1)
  LOCATE ULRow1 + 3
  CALL QPrint0(CHR$(186) + STRING$(22, " ") + CHR$(186), Colr1)
  LOCATE ULRow1 + 4
  CALL QPrint0(CHR$(204) + STRING$(22, CHR$(205)) + CHR$(185), Colr1)
  FOR X = ULRow1 + 5 TO ULRow1 + 10
    LOCATE X
    CALL QPrint0(CHR$(186) + SPACE$(22) + CHR$(186), Colr1)
  NEXT
  LOCATE ULRow1 + 11
  CALL QPrint0(CHR$(200) + STRING$(22, CHR$(205)) + CHR$(188), Colr1)
  RETURN

QPCDone:
  LOCATE V, H, 0               'Alte Werte for Screen-Restore wiederhFirst.

END SUB