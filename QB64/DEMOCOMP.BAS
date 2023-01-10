' ********** DEMOCOMP.BAS - shows FileComp in action

' Copyright (c) 1989 Ethan Winer
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
_TITLE "DEMOCOMP" 'NOTE: Moving title above resize causes resize to fail (without an error???)
'BUG: It would be nice specify the icon here, but... having to require full path or placing it in the qb64 folder is problematic. 
'NOTE: The above boiler plate must be first in execution (top of file).
'BUG:  Also appears to not work as an $INCLUDE; suggesting something might
'      be wrong with the implementation of $INCLUDE.
' **************************
' * BOILER PLATE END
' **************************

DEFINT A-Z

'$INCLUDE: 'PRO.BI'

DECLARE FUNCTION FileComp (file1$, file2$, errCode)

DECLARE FUNCTION DOSError ()
DECLARE FUNCTION WhichError ()
DECLARE FUNCTION ErrorMsg$ (errNum)

CLS

LINE INPUT "Enter the name of the  first file: ", file1$
LINE INPUT "Enter the name of the second file: ", file2$
PRINT

IF FileComp(file1$, file2$, errCode) THEN
  PRINT "The files are the same"
  END
END IF

IF DOSError THEN                       ' a DOS error occurred
  PRINT ErrorMsg$(WhichError);         ' print an appropriate message
  PRINT " error reading file ";
  IF errCode = 1 THEN                   ' and show if the error was
    PRINT file1$                        ' on the first file
  ELSE
    PRINT file2$                        ' or the second file
  END IF
ELSE                                    ' no error, they're just different
  PRINT "The files are different";
END IF

'$INCLUDE: 'FILECOMP.BAS'
'$INCLUDE: 'PRO.BAS'