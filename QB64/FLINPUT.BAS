' *********** FLINPUT.BAS - QuickPak Professional LINE INPUT style file input

' Copyright (c) 1989 Ethan Winer
' Modified (c) 2023 Cory Smith

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
_TITLE "FLINPUT" 'NOTE: Moving title above resize causes resize to fail (without an error???)
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
DECLARE SUB FOpen (fileName$, handle)

DECLARE FUNCTION DOSError% ()
DECLARE FUNCTION ErrorMsg$ (errNumber)
DECLARE FUNCTION FLInput$ (handle, buffer$)
DECLARE FUNCTION WhichError% ()

bufSize = 82                            ' enough to read up to 80 chars + CRLF
buffer$ = SPACE$(bufSize)               '   (or use whatever is appropriate)

CLS
LINE INPUT "Enter the name of a file to read: ", fileName$

FOpen fileName$, handle                 ' open for QuickPak Professional Binary
IF DOSError% THEN                       ' see if there was an error
  PRINT ErrorMsg$(WhichError%)          ' show what happened
  END                                   ' and then end
END IF

DO                                      ' the main file read loop
  temp$ = FLInput$(handle, buffer$)     ' get a line of input
  WHILE WhichError% = 83                ' a "Buffer too small" error means
    temp$ = temp$ + FLInput$(handle, buffer$)      ' we have to go back
  WEND                                             ' and get some more
  IF DOSError% THEN EXIT DO             ' exit if error (probably end of file)
  PRINT temp$                           ' otherwise, print it
LOOP

IF WhichError% <> 62 THEN               ' report anything but the expected
  PRINT                                 '   "End of file" error
  PRINT "Error: "; ErrorMsg$(WhichError%)
END IF

FClose handle                           ' always remember to close the file

'$INCLUDE: 'PRO.BAS'