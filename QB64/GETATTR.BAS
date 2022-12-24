' ********** GETATTR.BAS - gets a file's attributes

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
_TITLE "GETATTR" 'NOTE: Moving title above resize causes resize to fail (without an error???)
'BUG: It would be nice specify the icon here, but... having to require full path or placing it in the qb64 folder is problematic. 
'NOTE: The above boiler plate must be first in execution (top of file).
'BUG:  Also appears to not work as an $INCLUDE; suggesting something might
'      be wrong with the implementation of $INCLUDE.
' **************************
' * BOILER PLATE END
' **************************

DEFINT A-Z

'$INCLUDE: 'PRO.BI'

DECLARE FUNCTION GetAttr% (fileName$)

CLS

LINE INPUT "File Spec: "; f$

attr = GetAttr%(f$)             'get the attribute

PRINT
IF attr = -1 THEN
  PRINT "Sorry, that file doesn't exist."
ELSE
  PRINT "Attribute = ";
  IF attr = 0 THEN PRINT "None"
  IF attr AND 1 THEN PRINT "Read-Only ";
  IF attr AND 2 THEN PRINT "Hidden ";
  IF attr AND 4 THEN PRINT "System ";
  IF attr AND 16 THEN PRINT "Subdirectory ";
  IF attr AND 32 THEN PRINT "Archive ";
  IF attr AND 64 THEN PRINT "Device ";
  IF attr AND 128 THEN PRINT "Normal ";
  IF attr AND 256 THEN PRINT "Temporary ";
  IF attr AND 512 THEN PRINT "Sparse File ";
  IF attr AND 1024 THEN PRINT "Reparse Point ";
  IF attr AND 2048 THEN PRINT "Compressed ";
  IF attr AND 4096 THEN PRINT "Offline ";
  IF attr AND 8192 THEN PRINT "Not Content Indexed ";
  IF attr AND 16384 THEN PRINT "Encrypted ";
  IF attr AND 32768 THEN PRINT "Integrity Stream ";
  IF attr AND 65536 THEN PRINT "Virtual ";
  IF attr AND 131072 THEN PRINT "No Scrub Data ";
  IF attr AND 262144 THEN PRINT "Recall on Open ";
  IF attr AND 524288 THEN PRINT "Pinned ";
  IF attr AND 1048576 THEN PRINT "Unpinned ";
  IF attr AND 4194304 THEN PRINT "Recall on Data Access ";
END IF

'$INCLUDE: 'PRO.BAS'