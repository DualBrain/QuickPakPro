' ********** DEMOMAIN.BAS - main menu subprogram demonstration

' Copyright (c) 1987 Ethan Winer
' Modifications (c) 2022 Cory Smith

DEFINT A-Z

'$INCLUDE: 'PRO.BI'

'_FULLSCREEN _SQUAREPIXELS

DECLARE SUB MainMenu (item$(), choice, colr)

CLS

DIM choice$(8)                          ' dimension the choices array

FOR x = 1 TO 8                          ' assign each item to be displayed
  READ choice$(x)
NEXT
DATA "Enter Sales Data"
DATA "Enter Region Data"
DATA "Enter Data by Category"
DATA "Print All Reports by City"
DATA "Print All Reports by State"
DATA "Print All Reports by Sales Category"
DATA "Crash the System"
DATA "Return to Main Menu"

LOCATE , , 0                            ' turn off the cursor please!
colr = 7                                ' combined foreground/background color
CALL MainMenu(choice$(), choice, colr)

LOCATE 24, 1: PRINT "Item Number"; choice; "Was Selected";
IF choice = 0 THEN PRINT " - Escape was pressed";

'$INCLUDE: 'MAINMENU.BAS'