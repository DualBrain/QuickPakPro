'********** APRINTT.BAS - APrint demo for fixed-length strings

' Copyright (c) 1988 Ethan Winer
' Modifications (c) 2022 Cory Smith

' IMPORTANT NOTE:  To run this program you MUST start QB like this:
'
'    QB APrintT /AH /L Pro   - the /AH is needed because of the Huge array
'
' NOTE: This demo is implemented to prove that APrintT correctly handles
'       elements that cross a segment boundary.

DEFINT A-Z

_TITLE "APRINTT"

'$INCLUDE: 'PRO.BI'

'_FULLSCREEN _SQUAREPIXELS

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