' ********* DATE2DAY.BAS - finds the day of the week number from a Date String

' Copyright (c) 1987 Donald R. Malin
' Copyright (c) 1987 Crescent Software
' Modifications (c) 2022 Cory Smith

' Caller passes a Date String in the form MMDDYY or MMDDYYYY, and this
' subprogram returns a day of the week number (1-7), where 1 = Sunday.

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
_TITLE "DATE2DAY" 'NOTE: Moving title above resize causes resize to fail (without an error???)
'BUG: It would be nice specify the icon here, but... having to require full path or placing it in the qb64 folder is problematic. 
'NOTE: The above boiler plate must be first in execution (top of file).
'BUG:  Also appears to not work as an $INCLUDE; suggesting something might
'      be wrong with the implementation of $INCLUDE.
' **************************
' * BOILER PLATE END
' **************************

'$INCLUDE: 'PRO.BI'

DECLARE FUNCTION Date2Day% (Dat$)
DECLARE FUNCTION Date2Num% (Dat$)
DECLARE FUNCTION Num2Day% (Days%)

PRINT Num2Date(-29219) ' 01-01-1900
PRINT Num2Date(31368)  ' 11-17-2065
PRINT Date2Num("01-01-1900") ' -29219
PRINT Date2Num("11-17-2065") ' 31368
PRINT Num2Day(-29219) ' ??? -1, should be a 1
PRINT Num2Day(31368) ' 3

PRINT Date2Num("12/05/2022") ' 15680
PRINT Num2Day(15680)

FUNCTION Date2Day% (dat$) STATIC
  Date2Day% = Num2Day%(Date2Num%(dat$))
END FUNCTION

'$INCLUDE: 'PRO.BAS'