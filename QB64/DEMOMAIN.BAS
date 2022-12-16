' ********** DEMOMAIN.BAS - main menu subprogram demonstration

' Copyright (c) 1987 Ethan Winer
' Modifications (c) 2022 Cory Smith

' **************************
' * BOILER PLATE BEGIN
' **************************
$Resize:Stretch
CHDIR _STARTDIR$ ' Moved this line above resize to (hopefully) give more init time to window
IF _DesktopHeight => 2160 THEN mult = 4 ELSE IF _DesktopHeight => 1440 THEN mult = 2 ELSE mult = 1
DO: LOOP UNTIL _SCREENEXISTS ' Not sure if necessary; however, there does seem to be some sort of timing issue around getting hwnd
hwnd = _WindowHandle: x = 100: y = 100: w = 640 * mult: h = 480 * mult ' inlined _WindowHandle (next line) because 1 out of every 4 or 5 executions, would encounter an invalid window handle (1400)
IF INSTR(_OS$, "[WINDOWS]") THEN success = MoveWindow(_WindowHandle, x, y, w, h, 1) ELSE success = -1 ' Now that _WindowHandle is inlined, invalid window handle (1400) issue has yet to be reproduced - will have to continue to test
IF success = 0 THEN PRINT "FAILED TO RESIZE - "; GetLastError; " ("; hwnd; ")": CALL WaitKeyS
_TITLE "DEMOMAIN" 'NOTE: Moving title above resize causes resize to fail (without an error???)
'BUG: It would be nice specify the icon here, but... having to require full path or placing it in the qb64 folder is problematic. 
'NOTE: The above boiler plate must be first in execution (top of file).
'BUG:  Also appears to not work as an $INCLUDE; suggesting something might
'      be wrong with the implementation of $INCLUDE.
' **************************
' * BOILER PLATE END
' **************************

DEFINT A-Z

'$INCLUDE: 'PRO.BI'

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
'$INCLUDE: 'PRO.BAS'