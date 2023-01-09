' ********** DEMOFAST.BAS - loads a file into a string array in one operation

' Copyright (c) 1989 Don Malin
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
_TITLE "DEMOFAST" 'NOTE: Moving title above resize causes resize to fail (without an error???)
'BUG: It would be nice specify the icon here, but... having to require full path or placing it in the qb64 folder is problematic. 
'NOTE: The above boiler plate must be first in execution (top of file).
'BUG:  Also appears to not work as an $INCLUDE; suggesting something might
'      be wrong with the implementation of $INCLUDE.
' **************************
' * BOILER PLATE END
' **************************

DEFINT A-Z

'$INCLUDE: 'PRO.BI'
'$INCLUDE: 'FASTFILE.BI'

DECLARE FUNCTION DOSError% ()
DECLARE FUNCTION ErrorMsg$ (errorNum)
DECLARE FUNCTION FileSize& (fileName$)
DECLARE FUNCTION FastLoadInt% (fileName$)
DECLARE FUNCTION FindLast% (BYVAL address, size)
DECLARE FUNCTION WaitKey% ()
DECLARE FUNCTION WhichError% ()

DECLARE SUB FastLoadStr (text$())
DECLARE SUB FastSave (fileName$, text$())

CLS
INPUT "Enter a file name to load: ", fileName$  ' ask for a file name
bytes& = FileSize&(fileName$)                   ' get its size just for fun

startTime! = TIMER                     ' time how long the load takes
lines = FastLoadInt%(fileName$)        ' load the file, get number of lines

IF DOSError% THEN                      ' if there was an error loading it,
  PRINT ErrorMsg$(WhichError%)         '   print an appropriate message
ELSE
  REDIM text$(1 TO lines)              ' make an array to hold the text
  CALL FastLoadStr(text$())            ' move the text to the array
  endTime! = TIMER - startTime!        ' now we know the elapsed time
  PRINT USING "#.##"; endTime!;        ' show how fast we loaded it
  PRINT " seconds to load"; bytes&; "bytes - press a key to see it"
  dummy = WaitKey%                     ' pause for a key press

  FOR n = 1 TO lines                   ' print the text to prove it worked
    PRINT text$(n)
  NEXT
END IF

PRINT
PRINT "Do you want to create a file and see how fast we can save it (Y/N)? ";
answer = WaitKey%
IF answer = ASC("Y") OR answer = ASC("y") THEN

  PRINT
  LINE INPUT "Enter the name of the file to create: ", fileName$
  REDIM text$(1 TO 1000)               ' make an array of 1000 elements
  FOR x = 1 TO 500                     ' show how to save only the first 500
    text$(x) = "This is test line number" + STR$(x)
  NEXT

  startTime! = TIMER                               ' time how fast it happens
  CALL FastSave(fileName$, text$())                ' save the array
  IF DOSError% THEN PRINT ErrorMsg$(WhichError%)   ' report any errors
  endTime! = TIMER - startTime!
  PRINT USING "#.##"; endTime!;
  PRINT " seconds to save "; fileName$             ' show the elapsed time
  KILL fileName$                                   ' clean up after ourselves

END IF

'$INCLUDE: 'STRREST.BAS'
'$INCLUDE: 'FASTFILE.BAS'
'$INCLUDE: 'PRO.BAS'