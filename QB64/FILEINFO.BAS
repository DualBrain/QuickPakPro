' ********** FILEINFO.BAS - retrieves information about a file or directory

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
_TITLE "FILEINFO" 'NOTE: Moving title above resize causes resize to fail (without an error???)
'BUG: It would be nice specify the icon here, but... having to require full path or placing it in the qb64 folder is problematic. 
'NOTE: The above boiler plate must be first in execution (top of file).
'BUG:  Also appears to not work as an $INCLUDE; suggesting something might
'      be wrong with the implementation of $INCLUDE.
' **************************
' * BOILER PLATE END
' **************************

DEFINT A-Z

'$INCLUDE: 'PRO.BI'

DECLARE FUNCTION DOSError% ()                   ' to trap possible DOS errors

' Moved/converted below.
'DEF FnP$ (x) = RIGHT$("0" + LTRIM$(STR$(x)), 2) ' adds a leading zero if needed

' The syntax example given in the owner's manual uses an array to receive
' the information that FileInfo returns.  However, we believe that using a
' TYPE variable as shown below is much simpler, and will make your programs
' easier to read and maintain.  As it works out, FileInfo works just as well
' using either method, so use whichever you prefer.

' TYPE FInfo
'    Year   AS INTEGER
'    Month  AS INTEGER
'    Day    AS INTEGER
'    Hour   AS INTEGER
'    Minute AS INTEGER
'    Second AS INTEGER
'    Size   AS LONG
'    Attrib AS INTEGER
' END TYPE
DIM info AS FInfo               'Info will receive the returned information

CLS
LINE INPUT "File Name to get info about: "; fileName$
CALL FileInfo(fileName$, info)

IF DOSError% THEN
  PRINT "File "; fileName$; " was not found."
  END
END IF

PRINT
PRINT "Date      = ";
PRINT FnP$(info.Month); "/"; FnP$(info.Day); "/"; FnP$(info.Year)

PRINT "Time      = ";
PRINT FnP$(info.Hour); ":"; FnP$(info.Minute); ":"; FnP$(info.Second)

PRINT "File Size ="; info.Size

PRINT "Attribute = ";
IF info.Attrib AND 1 THEN PRINT "Read-Only ";
IF info.Attrib AND 2 THEN PRINT "Hidden ";
IF info.Attrib AND 4 THEN PRINT "System ";
IF info.Attrib AND 16 THEN PRINT "Subdirectory ";
IF info.Attrib AND 32 THEN PRINT "Archive";

FUNCTION FnP$ (x) 
  FnP$ = RIGHT$("0" + LTRIM$(STR$(x)), 2) ' adds a leading zero if needed
END FUNCTION

'$INCLUDE: 'PRO.BAS'