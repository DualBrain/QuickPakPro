' ********** LOADEXEC.BAS

' Copyright (c) 1991 Ethan Winer
' Modifications (c) 2023 Cory Smith

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
_TITLE "LOADEXEC" 'NOTE: Moving title above resize causes resize to fail (without an error???)
'BUG: It would be nice specify the icon here, but... having to require full path or placing it in the qb64 folder is problematic. 
'NOTE: The above boiler plate must be first in execution (top of file).
'BUG:  Also appears to not work as an $INCLUDE; suggesting something might
'      be wrong with the implementation of $INCLUDE.
' **************************
' * BOILER PLATE END
' **************************

DEFINT A-Z

'$INCLUDE: 'PRO.BI'

DECLARE FUNCTION ErrorMsg$ (ErrCode)
DECLARE FUNCTION LoadExec% (FileName$, Param$)
DECLARE FUNCTION SearchPath$ (FileName$)
DECLARE FUNCTION WhichError% ()

fileName$ = "notepad"                       ' I sure hope you have PKZIP!
param$ = "..\readme.md"                     ' optional param, leave blank if none.
qualified$ = SearchPath$(fileName$)         ' create a fully qualified name

IF qualified$ = "" THEN
  PRINT "Unable to located " + fileName$ + "; quiting.": END
END IF

IF RIGHT$(qualified$, 4) = ".BAT" THEN      ' here's how to handle batch files
  param$ = "/C" + qualified$ + " " + param$ ' /c tells COMMAND.COM to run it
  qualified$ = ENVIRON$("COMSPEC")          ' usually COMSPEC = C:\COMMAND.COM
END IF

exitCode = LoadExec%(qualified$, param$)    ' load and execute the program
PRINT

qpErr = WhichError%                         ' report what happened
IF qpErr THEN
  
  PRINT "Error:"; qpErr; ErrorMsg$(qpErr)   ' an error

ELSEIF exitCode <= 255 THEN                 ' normal termination
  
  PRINT "Normal termination with an exit code of"; exitCode

ELSE                                        ' abnormal termination

  dosCode = exitCode \ 256                  ' isolate DOS's contribution
  exitCode = exitCode AND 255               ' retain the program's part too
  PRINT "DOS intervened"
  SELECT CASE dosCode
    CASE 1
      PRINT "You pressed Ctrl-C or Ctrl-Break to end the program"
    CASE 2
      PRINT "A critical error occurred and you pressed A (Abort)"
    CASE 3
      PRINT "The program ended as a TSR -- reboot now!"
    CASE ELSE
  END SELECT
END IF

'$INCLUDE: 'SRCHPATH.BAS'
'$INCLUDE: 'PRO.BAS'