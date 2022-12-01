' ********** DEMOPOP.BAS - demo of the QuickPak Professional pop-up subprograms

' Copyright (c) 1988 Crescent Software
' Modifications (c) 2022 Cory Smith

DEFINT A-Z

'$INCLUDE: 'QPPRO.BI'

_FULLSCREEN _SQUAREPIXELS

DECLARE SUB ASCIIChart (row, column, lines)
DECLARE SUB Calc (ulRow, ulCol, fg, bg)
DECLARE SUB Calendar (mnth, dy, yr, ulRow, ulCol, colr1, colr2, action)
'DECLARE SUB CSMsgBox (message$, wdth, cnf AS ANY)
DECLARE FUNCTION Monitor% ()

'$INCLUDE: 'DefCnf.BI'          ' defines the TYPE variable for MsgBox
'$INCLUDE: 'SetCnf.BI'          ' queries the system info for MsgBox

' create a background pattern to show how pop-ups save the underlying screen
CLS
LOCATE , , 0
COLOR 2
PRINT STRING$(22 * 80, 254)
COLOR 14

'----- ASCII Chart

row = 3: column = 10: height = 16
LOCATE 23, 1: PRINT "Use:  " + CHR$(24) + "  " + CHR$(25) + "  PgUp  PgDn  Home  End - Esc when finished "
CALL ASCIIChart(row, column, height)
LOCATE 23, 1: PRINT TAB(54);

' ----- Calculator

row = 2: column = 50
SELECT CASE Monitor%           ' see what type of monitor is present
  CASE 3, 5, 7, 9, 10, 12      ' CGA, EGA, VGA color
    fg = 11
    bg = 1
  CASE ELSE                    ' monochrome
    fg = 15
    bg = 0
END SELECT

CALL NumOn                     ' turn on the NumLock key
CALL Calc(row, column, fg, bg)
CALL NumOff

' ----- Calendar

colr1 = 2: colr2 = 15   'b/w calendar colors (try 66 and 77 for CGA/EGA)
ulRow = 3: ulCol = 14   'upper left corner of calendar

mnth = VAL(LEFT$(DATE$, 2))     'take today's date from DOS
yr = VAL(RIGHT$(DATE$, 4))
dy = VAL(MID$(DATE$, 4, 2))

action = 1                      'display the calendar
CALL Calendar(mnth, dy, yr, ulRow, ulCol, colr1, colr2, action)
CALL WaitKey

action = 0                      'remove the calendar
CALL Calendar(mnth, dy, yr, ulRow, ulCol, colr1, colr2, action)

'----- MsgBox - word wraps a message

FOR x = 1 TO 8          'create a long message to show how MsgBox centers
    READ L$             '  and word-wraps it within the window
    message$ = message$ + L$
NEXT
DATA "This subprogram displays a message that is contained in a single long "
DATA "string.  The first time it is called the underlying screen is saved, "
DATA "and then the message is word-wrapped and displayed correctly centered.  "
DATA "To clear the message and restore the underlying screen, simply call it "
DATA "again.  No additional passed parameters are required, because it keeps "
DATA "track of how many times it has been called internally.  MsgBox is "
DATA "ideal for situations where you have a long message to be displayed, "
DATA "but don't want to bother having to deal with how it will be formatted."

wdth = 54                'a box 54 characters wide will be centered on screen
LOCATE 3                 'the top of the box goes on line 3
'CALL CSMsgBox(message$, wdth, cnf)
CALL WaitKey
'CALL CSMsgBox("", 0, cnf) 'the parameters used the second time don't matter
                          ' as long as the message string is null

'$INCLUDE: 'ASCCHART.BAS'
'$INCLUDE: 'CALC.BAS'
'$INCLUDE: 'CALENDAR.BAS'
'$NOCLUDE: 'MSGBOX.BAS'
'$INCLUDE: 'QPPRO.BAS'