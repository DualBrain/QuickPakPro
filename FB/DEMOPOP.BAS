' ********** DemoPop.Bas - demo of the QuickPak Professional pop-up subprograms
' Copyright (c) 1988 Crescent Software
' Modifications (c) 2023 Cory Smith

#INCLUDE "PRO.BI" ' Monitor
#INCLUDE "DefCnf.BI" 'defines the TYPE variable for MsgBox

DECLARE SUB ASCIIChart (row As Short, column As Short, lines As Short)
DECLARE SUB Calc (ulRow As Short, ulCol As Short, fg As Short, bg As Short)
DECLARE SUB Calendar (mnth As Short, dy As Short, yr As Short, ulRow As Short, ulCol As Short, colr1 As Short, colr2 As Short, action As Short)
DECLARE SUB CSMsgBox (message As String, wdth As Short, cnf As Config)

#INCLUDE "SetCnf.BI" 'queries the system info for MsgBox

'create a background pattern to show how pop-ups save the underlying screen
SCREEN 0
'CLS
LOCATE , , 0
COLOR 2
PRINT STRING$(22 * 80, 254)
COLOR 14

'----- ASCII Chart

Var row = 3: Var column = 10: Var height = 16
LOCATE 23, 1: PRINT "Use:      PgUp  PgDn  Home  End - Esc when finished "
ASCIIChart row, column, height
LOCATE 23, 1: PRINT TAB(54);

'----- Calculator

Dim fg As Short, bg As Short
row = 2: column = 50
SELECT CASE monitor            'see what type of monitor is present
  CASE 3, 5, 7, 9, 10, 12      'CGA, EGA, VGA color
    fg = 11
    bg = 1
  CASE ELSE                    'monochrome
    fg = 15
    bg = 0
END SELECT

REM NumOn              'turn on the NumLock key
Calc row, column, fg, bg
REM NumOff

'----- Calendar

Var colr1 = 2: Var colr2 = 15   'b/w calendar colors (try 66 and 77 for CGA/EGA)
Var ulRow = 3: Var ulCol = 14   'upper left corner of calendar

Var mnth = VAL(LEFT$(DATE$, 2))     'take today's date from DOS
Var yr = VAL(RIGHT$(DATE$, 4))
Var dy = VAL(MID$(DATE$, 4, 2))

Var action = 1                      'display the calendar
Calendar mnth, dy, yr, ulRow, ulCol, colr1, colr2, action
WaitKey

action = 0                      'remove the calendar
Calendar mnth, dy, yr, ulRow, ulCol, colr1, colr2, action

'----- MsgBox - word wraps a message

RESTORE Message_Data
Dim message As String
FOR x As Short = 1 TO 8          'create a long message to show how MsgBox centers
  Dim l As String
  READ l             '  and word-wraps it within the window
  message = message + l
NEXT

Message_Data:
  DATA "This subprogram displays a message that is contained in a single long "
  DATA "string.  The first time it is called the underlying screen is saved, "
  DATA "and then the message is word-wrapped and displayed correctly centered.  "
  DATA "To clear the message and restore the underlying screen, simply call it "
  DATA "again.  No additional passed parameters are required, because it keeps "
  DATA "track of how many times it has been called internally.  MsgBox is "
  DATA "ideal for situations where you have a long message to be displayed, "
  DATA "but don't want to bother having to deal with how it will be formatted."

Var wdth = 54                'a box 54 characters wide will be centered on screen
LOCATE 3                 'the top of the box goes on line 3
CSMsgBox message, wdth, cnf
WaitKey
CSMsgBox "", 0, cnf 'the parameters used the second time don't matter
                          ' as long as the message string is null

WaitKey