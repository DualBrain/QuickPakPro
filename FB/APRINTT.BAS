' ********** APRINTT.BAS - APrint demo for fixed-length strings
' Copyright (c) 1988 Ethan Winer
' Modifications (c) 2023 Cory Smith

' Defining a fixed length string as a TYPE greatly simplifies the call to
' APrintT below.  The alternative method using a fixed-length string array
' is shown in REMarks for comparison.

TYPE FLen
  S AS STRING * 30
END TYPE

#INCLUDE "PRO.BI" ' APrintT

FUNCTION FnSigned(x As Short) As Long                       'for testing only
  IF x < 0 THEN
    FnSigned = x + 65536
  ELSE
    FnSigned = x
  END IF
END FUNCTION

REDIM array(3100) AS FLen
'REDIM array(3100) AS STRING * 30

CLS
OPEN "KeySort.Bas" FOR INPUT AS #1
FOR x As Short = 2100 TO 2200
  LINE INPUT #1, array(x).S
  'LINE INPUT #1, array(x)
  IF x >= 2175 AND x < 2195 THEN
    PRINT FnSigned(Clng(@array(x).S)); TAB(10); array(x).S
    'PRINT FnSigned(VARPTR(array(x))); TAB(10); array(x)
  END IF
NEXT

LOCATE 1, 45
Var elSize = LEN(FLen) ' 30
APrintT @Array(2175), elSize, 20, 1, 30, 7, -1
'APrintT VARPTR(array(2175), 30, 20, 1, 30, 7, -1