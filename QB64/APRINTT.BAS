'********** APRINTT.BAS - APrint demo for fixed-length strings

' Copyright (c) 1988 Ethan Winer
' Modifications (c) 2022 Cory Smith

' IMPORTANT NOTE:  To run this program you MUST start QB like this:
'
'    QB APrintT /AH /L Pro   - the /AH is needed because of the Huge array
'
' NOTE: This demo is implemented to prove that APrintT correctly handles
'       elements that cross a segment boundary.

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
_TITLE "APRINTT" 'NOTE: Moving title above resize causes resize to fail (without an error???)
'BUG: It would be nice specify the icon here, but... having to require full path or placing it in the qb64 folder is problematic. 
'NOTE: The above boiler plate must be first in execution (top of file).
'BUG:  Also appears to not work as an $INCLUDE; suggesting something might
'      be wrong with the implementation of $INCLUDE.
' **************************
' * BOILER PLATE END
' **************************

DEFINT A-Z

'$INCLUDE: 'PRO.BI'

' Defining a fixed length string as a TYPE greatly simplifies the call to
' APrintT below.  The alternative method using a fixed-length string array
' is shown in REMarks for comparison.

' TYPE FLen
'   S AS STRING * 30
' END TYPE

DECLARE SUB APrintT (SEG arrayElement AS FLen, elSize, numEls, midStart, numChars, colr, page)
'DECLARE SUB APrintT (BYVAL segment, BYVAL address, elSize, numEls, midStart, numChars, colr, page)

' Converted the following FN to a FUNCTION (see below).
' DEF FnSigned& (x)                       ' for testing only
'   IF x < 0 THEN
'     FnSigned& = x + 65536
'   ELSE
'     FnSigned& = x
'   END IF
' END DEF

REDIM array(3100) AS FLen
'REDIM array(3100) AS STRING * 30

CLS
OPEN "KEYSORT.BAS" FOR INPUT AS #1
FOR x = 2100 TO 2200
  LINE INPUT #1, array(x).S
  'LINE INPUT #1, array$(x)
  IF x >= 2175 AND x < 2195 THEN
    'vv% = VARPTR(array(X).S) 'BUG: <------ fails in QB64.
    vv% = x
    PRINT FnSigned&(vv%); TAB(10); array(X).S
    'PRINT FnSigned&(VARPTR(array$(X))); TAB(10); array$(X)
  END IF
NEXT

LOCATE 1, 45
CALL APrintT(array(), 2175, 30, 20, 1, 30, 7, -1)
'CALL APrintT (VARSEG(array$(2175)), VARPTR(array$(2175)), 30, 20, 1, 30, 7, -1)

FUNCTION FnSigned& (value%)                       ' for testing only
  IF value% < 0 THEN
    FnSigned& = value% + 65536
  ELSE
    FnSigned& = value%
  END IF
END FUNCTION

'$INCLUDE: 'PRO.BAS'