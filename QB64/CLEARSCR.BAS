' ********** ClEARSCR.BAS - clears a portion of the display screen

' Copyright (c) 1988 Ethan Winer
' Modifications (c) 2022 Cory Smith

DEFINT A-Z

DECLARE SUB ClearScr (ulRow, ulCol, lrRow, lrCol, colr, page)

'WIDTH 80, 43               'for testing
'SCREEN 0, 0, 2, 2

CLS
Colr = 1 * 16               'clear to blue background (underlined if mono)
COLOR 2                     'print test pattern in green

ulRow = 10                  'portion of screen to clear
ulCol = 20
lrRow = 18
lrCol = 60
page = -1                   'do it on the current display page

FOR x = 1 TO 24
  PRINT STRING$(80, x + 96);          'display test pattern
NEXT

LOCATE 25, 1, 1
PRINT "Press a key to see the show";
WHILE INKEY$ = "": WEND

CALL ClearScr(ulRow, ulCol, lrRow, lrCol, colr, page)

'$INCLUDE: 'QPPRO.BAS'