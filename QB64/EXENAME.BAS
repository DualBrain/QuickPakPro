'********** EXENAME.BAS - gets the full path and name of the current program

' Copyright (c) 1988 Ethan Winer
' Modifications (c) 2022 Cory Smith

' ExeName returns the fully qualified name of the currently executing program.
' If you run this from within the QuickBASIC environment it will of course
' return "QB.EXE" along with the path from which it was loaded.  It is worth
' mentioning that the drive letter and colon are not always included in the
' name ExeName returns.  The only time we've observed this is when the program
' was not in the current directory but was found via the PATH setting, and the
' path did not include a drive letter:
'
'    PATH = C:\DOS;\C:\UTIL
' or
'    PATH = \DOS;\UTIL
'
' In the first example above, the drive letter will be included in the full
' name returned by ExeName.  In the second example it will not.  Understand
' that this applies only to those situations where the program was found via
' the DOS PATH setting.  If the user precedes the file name with an explicit
' path as in \QB4\MYPROG, the drive letter and colon will be present.  Also
' understand that none of this has anything to do with the way ExeName was
' written.  ExeName simply returns the information provided by DOS, and it is
' DOS who forgot to include the drive.
'
' The example below shows how to obtain the drive letter if it is not present.
' This should be done early in the program, before your user has a chance to
' SHELL or change the current drive.

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
_TITLE "EXENAME" 'NOTE: Moving title above resize causes resize to fail (without an error???)
'BUG: It would be nice specify the icon here, but... having to require full path or placing it in the qb64 folder is problematic. 
'NOTE: The above boiler plate must be first in execution (top of file).
'BUG:  Also appears to not work as an $INCLUDE; suggesting something might
'      be wrong with the implementation of $INCLUDE.
' **************************
' * BOILER PLATE END
' **************************

DEFINT A-Z

'$INCLUDE: 'PRO.BI'

DECLARE FUNCTION ExeName$ ()
DECLARE FUNCTION GetDrive% ()

CLS
fName$ = UCASE$(ExeName$)        ' capitalize it if you care
IF LEN(fName$) THEN              ' ExeName$ returns a null if less than DOS 3.0
  PRINT "The full name of the currently executing program is ";
  IF INSTR(fName$, ":") = 0 THEN    ' no drive present, so get default
    PRINT CHR$(GetDrive%); ":";
  END IF
  PRINT fName$
ELSE
  PRINT "This function requires DOS 3.0 or later."
END IF

'$INCLUDE: 'PRO.BAS'