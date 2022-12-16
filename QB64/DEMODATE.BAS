' ********** DEMODATE.BAS

' Copyright (c) 1988 Ethan Winer
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
_TITLE "DEMODATE" 'NOTE: Moving title above resize causes resize to fail (without an error???)
'BUG: It would be nice specify the icon here, but... having to require full path or placing it in the qb64 folder is problematic. 
'NOTE: The above boiler plate must be first in execution (top of file).
'BUG:  Also appears to not work as an $INCLUDE; suggesting something might
'      be wrong with the implementation of $INCLUDE.
' **************************
' * BOILER PLATE END
' **************************

DEFINT A-Z

'$INCLUDE: 'PRO.BI'

DECLARE FUNCTION Date2Num% (Dat$)
DECLARE FUNCTION Num2Date$ (Number)
DECLARE FUNCTION Num2Day% (Days)
DECLARE FUNCTION DayName$ (Days)

CLS
INPUT "Enter a date string as MM-DD-YYYY: ", Dat$

'Actually, Date2Num will accept MMDDYY, MMDDYYYY, MM-DD-YY, MM/DD/YYYY,
'and so forth, but we want to show how to validate a date.  To do this,
'there must be some control over the incoming date format.

PRINT
Days = Date2Num%(Dat$)
NewDat$ = Num2Date$(Days)

PRINT "The equivalent QuickPak Date Number is:"; Days
PRINT "                The day of the week is: "; DayName$(Num2Day%(Days))
PRINT "After conversion back to a Date format: "; NewDat$

IF NewDat$ <> Dat$ THEN
  PLAY "L32O3ECEC"
  PRINT
  PRINT NewDat$; " is not the same as the date entered!"
END IF

'$INCLUDE: 'PRO.BAS'