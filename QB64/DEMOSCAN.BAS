' ********** DEMOSCAN.BAS - demos the BASIC ScanFile function

' This example shows how to use the QuickPak Pro Binary file routines to
' search a file for any string or substring.

' Copyright (c) 1988 Ethan Winer
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
_TITLE "DEMOSCAN" 'NOTE: Moving title above resize causes resize to fail (without an error???)
'BUG: It would be nice specify the icon here, but... having to require full path or placing it in the qb64 folder is problematic. 
'NOTE: The above boiler plate must be first in execution (top of file).
'BUG:  Also appears to not work as an $INCLUDE; suggesting something might
'      be wrong with the implementation of $INCLUDE.
' **************************
' * BOILER PLATE END
' **************************

DEFINT A-Z

'$INCLUDE: 'PRO.BI'

DECLARE FUNCTION DOSError% ()
DECLARE FUNCTION WhichError% ()
DECLARE FUNCTION ErrorMsg$ (errNum)
DECLARE FUNCTION ScanFile& (fileName$, searchText$, start&)

' The offset returned by ScanFile is based at one.  That is, if a match is
' found at the very first byte in the file, Offset& returns 1, not 0.

CLS
LINE INPUT "Program to search: ", fileName$
LINE INPUT "     Text to find: ", searchText$

offset& = 0                 ' start searching at the beginning of the file

DO

  start& = offset& + 1      ' this allows continuing the search

  offset& = ScanFile&(fileName$, searchText$, start&)  ' search the file
  IF DOSError% THEN
    PRINT "Error"; WhichError%; "occurred - "; ErrorMsg$(WhichError%)
    END
  END IF

  PRINT

  IF offset& < 1 THEN             ' ScanFile& returns 0 for "not found", and -1
    PRINT "Text not found"        '   if you start past the end of the file or
    END                           '   the search string is longer than the file.
  ELSE
    PRINT "Found at"; offset&     ' anything else is where the text was found
  END IF

  PRINT "Keep searching (Y/N)? ";
  DO
    x$ = UCASE$(INKEY$)
  LOOP UNTIL LEN(x$)

LOOP WHILE x$ = "Y"

'$INCLUDE: 'SCANFILE.BAS'
'$INCLUDE: 'PRO.BAS'