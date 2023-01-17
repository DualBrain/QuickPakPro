' ******** FAPPEND.BAS - shows how to open a QuickPak Binary file for Append

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
_TITLE "FAPPEND" 'NOTE: Moving title above resize causes resize to fail (without an error???)
'BUG: It would be nice specify the icon here, but... having to require full path or placing it in the qb64 folder is problematic. 
'NOTE: The above boiler plate must be first in execution (top of file).
'BUG:  Also appears to not work as an $INCLUDE; suggesting something might
'      be wrong with the implementation of $INCLUDE.
' **************************
' * BOILER PLATE END
' **************************

DEFINT A-Z

'$INCLUDE: 'PRO.BI'

DECLARE SUB FClose (handle)
DECLARE SUB FCreate (fileName$)
DECLARE SUB FGet (handle, destination$)
DECLARE SUB FOpen (fileName$, handle)
DECLARE SUB FPut (handle, source$)
DECLARE SUB FSeek (handle, offset&)
DECLARE SUB KillFile (fileName$)
DECLARE SUB QPrint (work$, colr, page)

DECLARE FUNCTION DOSError% ()
DECLARE FUNCTION FLof& (handle)
DECLARE FUNCTION WhichError% ()
DECLARE FUNCTION ErrorMsg$ (errNumber)

CLS

f$ = "FAppend.Tst"              ' this is the file name we'll use for testing
FCreate f$                      ' create the file
IF DOSError% THEN               ' see if an error occurred creating the file
  PRINT ErrorMsg$(WhichError%)  ' the only likely error is a write-protected
  END                           '   disk, an open drive door, or maybe even a
END IF                          '   full directory

FOpen f$, handle                ' open for QuickPak Professional Binary

FPut handle, "This is the first line of text." + CHR$(13) + CHR$(10)
IF DOSError% THEN               ' the only likely error here would be a
  PRINT ErrorMsg$(WhichError%)  '   full disk
  END
END IF

FClose handle                   ' close the file so we can show how to append

FOpen f$, handle                ' now open it again
FSeek handle, FLof&(handle)     ' seek to the end and write a second line
FPut handle, "This is the second line of text." + CHR$(13) + CHR$(10)

FSeek handle, 0&                ' seek to the beginning of the file
show$ = SPACE$(FLof&(handle))   ' make a string long enough to hold entire file
FGet handle, show$              ' get the file to show it worked
QPrint "{" + show$ + "}", 7, -1 ' use QPrint so CHR$(13) and CHR$(10) will show

FClose handle                   ' close the file
KillFile f$                     ' and erase the clutter

'$INCLUDE: 'PRO.BAS'