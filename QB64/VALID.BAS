' ********** VALID.BAS - brute force test to see if a file/path name is valid

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
_TITLE "VALID" 'NOTE: Moving title above resize causes resize to fail (without an error???)
'BUG: It would be nice specify the icon here, but... having to require full path or placing it in the qb64 folder is problematic. 
'NOTE: The above boiler plate must be first in execution (top of file).
'BUG:  Also appears to not work as an $INCLUDE; suggesting something might
'      be wrong with the implementation of $INCLUDE.
' **************************
' * BOILER PLATE END
' **************************

' IMPORTANT NOTE: Valid does NOT tell if the file or path actually exists.
' It simply verifies that the name COULD be valid.

DEFINT A-Z

'$INCLUDE: 'PRO.BI'

DECLARE FUNCTION Valid% (fSpec$)

CLS

More:

INPUT "Enter a file name: ", fileName$  ' ask for a file name

fileName$ = LTRIM$(RTRIM$(fileName$))   ' trim leading/trailing blanks
                                        '   which Valid considers illegal
IF fileName$ = "" THEN END

PRINT UCASE$(fileName$);

IF Valid(fileName$) THEN
  PRINT " is a good name."
ELSE
  PRINT " is not valid"
END IF

PRINT

GOTO More

'$INCLUDE: 'PRO.BAS'