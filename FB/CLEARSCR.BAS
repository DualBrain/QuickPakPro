' ********** ClEARSCR.BAS - clears a portion of the display screen

' Copyright (c) 1988 Ethan Winer
' Modifications (c) 2023 Cory Smith

#INCLUDE "PRO.BI" ' ClearScr

'WIDTH 80, 43                    ' for testing
'SCREEN 0, 0, 2, 2

SCREEN 0 'CLS
Var colr = 1 * 16               ' clear to blue background (underlined if mono)
COLOR 2                         ' print test pattern in green

Var ulRow = 10                  ' portion of screen to clear
Var ulCol = 20
Var lrRow = 18
Var lrCol = 60
Var page = -1                   ' do it on the current display page

FOR x As Short = 1 TO 24
  PRINT STRING$(80, x + 96);    ' display test pattern
NEXT

LOCATE 25, 1, 1
PRINT "Press a key to see the show";
WHILE INKEY$ = "": WEND

ClearScr ulRow, ulCol, lrRow, lrCol, colr, page

WaitKey