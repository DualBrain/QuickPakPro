' *********** TEST.BAS

' Copyright (c) 2022 Cory Smith

DEFINT A-Z

_TITLE "TEST"

'$INCLUDE: 'PRO.BI'
'$INCLUDE: 'DECLARE.BAS'

CLS

COMMON e$

ON ERROR GOTO ErrorHandler

DIM numbers(10)
DIM numSgl(10) AS SINGLE
DIM numDbl(10) AS DOUBLE
FOR x = 0 TO 10
  numbers(x) = x
  numSgl(x) = x
  numDbl(x) = x
NEXT

DIM element$(10)
DIM fixed(10) AS FLen
FOR x = 0 TO 10
  element$(x) = "Element" + STR$(x)
  fixed(x).S = "Element" + STR$(x)
NEXT

bits$ = ""

PRINT "****************************************"
PRINT " Chapter 2 - Array Routines"
PRINT "****************************************"
PRINT

PRINT "AddInt"; 
CALL AddInt(numbers(), 0, value, 11)
HandleResult value = 55

PRINT "DeleteStr"; 
el = 5: numEls = UBOUND(element$) - el
CALL DeleteStr(element$(), el, numEls)
HandleResult element$(10) = "Element 5"

PRINT "DeleteT"; 
CALL DeleteT(fixed(), el%, 30, numEls)
HandleResult QPTrim$(fixed(10).S) = "Element 5"

PRINT "DimBits... Skipped"
'CALL DimBits(bits$, 100)
'HandleResult 1 = 0

PRINT "Fill2"; 
CALL Fill2(numbers(), 0, 0, 10)
HandleResult numbers(5) = 0

PRINT "Fill4"; 
CALL Fill4(numSgl(), 0, 0, 10)
HandleResult numSgl(5) = 0

PRINT "Fill8"; 
CALL Fill8(numDbl(), 0, 0, 10)
HandleResult numDbl(5) = 0

PRINT "Find"; 
numEls = 5
CALL Find(element$(), 0, numEls, "5")
HandleResult numEls = 5

PRINT "Find2"; 
numEls = 5
CALL Find2(element$(), 0, numEls, "5")
HandleResult numEls = 5

PRINT "FindB"; 
numEls = 5
CALL Find2(element$(), 0, numEls, "5")
HandleResult numEls = 5

PRINT "FindB2"; 
numEls = 5
CALL Find2(element$(), 0, numEls, "5")
HandleResult numEls = 5

PRINT "FindExact"; 
numEls = 5
CALL FindExact(element$(), 0, numEls, "5")
HandleResult numEls = 5

PRINT "FindT"; 
numEls = 5
CALL FindT(fixed(), 0, 30, numEls, "5")
HandleResult numEls = 5

PRINT "FindT2"; 
numEls = 5
CALL FindT2(fixed(), 0, 30, numEls, "5")
HandleResult numEls = 5

PRINT "FindTB"; 
numEls = 5
CALL FindTB(fixed(), 0, 30, numEls, "5")
HandleResult numEls = 5

PRINT "FindTB2"; 
numEls = 5
CALL FindTB2(fixed(), 0, 30, numEls, "5")
HandleResult numEls = 5

PRINT "FindLast"; 
last = FindLast(element$(), numEls)
HandleResult last = 5

PRINT "GetBit"; 
bit = GetBit(bits$, 1)
HandleResult bit = 1

END

ErrorHandler:
  IF ERR = 73 THEN
    e$ = "NOT IMPLEMENTED"
  ELSE
    e$ = "ERROR:" + STR$(ERR) ' + " LINE:" + STR$(_ERRORLINE) + "."
  END IF
  RESUME NEXT

SUB HandleResult(success)
  SHARED e$
  IF success THEN 
    PRINT ""
  ELSE 
    PRINT "... ";
    IF e$ <> "" THEN
      IF e$ = "NOT IMPLEMENTED" THEN
        COLOR 8, 0: PRINT e$: COLOR 7, 0
      ELSE
        COLOR 12, 0: PRINT e$: COLOR 7, 0
      END IF
    ELSE
      COLOR 15, 0: PRINT "FAILED": COLOR 7, 0
    END IF
  END IF
  e$ = ""
END SUB

'$INCLUDE: 'PRO.BAS'