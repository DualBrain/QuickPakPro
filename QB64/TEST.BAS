' *********** TEST.BAS

' Copyright (c) 2022 Cory Smith

DEFINT A-Z

_TITLE "TEST"

_FULLSCREEN _SQUAREPIXELS

'$INCLUDE: 'PRO.BI'
'$INCLUDE: 'DECLARE.BAS'

CLS

COMMON e$

ON ERROR GOTO ErrorHandler

DIM numbers(10)
DIM numLng(10) AS LONG
DIM numSng(10) AS SINGLE
DIM numDbl(10) AS DOUBLE
FOR x = 0 TO 10
  numbers(x) = x
  numSng(x) = x
  numDbl(x) = x
  numLng(x) = x
NEXT

DIM idx(10) AS INTEGER
DIM tbl(1 TO 2, 1 TO 3) AS INTEGER 

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
CALL Fill4(numSng(), 0, 0, 10)
HandleResult numSng(5) = 0

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

PRINT "IMaxD"; 
el = IMaxD(numDbl(), 0, UBOUND(numDbl))
HandleResult el = 10

PRINT "IMaxI"; 
el = IMaxI(numbers(), 0, UBOUND(numbers))
HandleResult el = 10

PRINT "IMaxL"; 
el = IMaxL(numLng(), 0, UBOUND(numLng))
HandleResult el = 10

PRINT "IMaxS"; 
el = IMaxS(numSng(), 0, UBOUND(numSng))
HandleResult el = 10

PRINT "IMaxC"; 
el = IMaxC(numSng(), 0, UBOUND(numSng))
HandleResult el = 10

PRINT "IMaxD"; 
el = IMaxD(numDbl(), 0, UBOUND(numDbl))
HandleResult el = 10

PRINT "IMinI"; 
el = IMinI(numbers(), 0, UBOUND(numbers))
HandleResult el = 10

PRINT "IMinL"; 
el = IMinL(numLng(), 0, UBOUND(numLng))
HandleResult el = 10

PRINT "IMinS"; 
el = IMinS(numSng(), 0, UBOUND(numSng))
HandleResult el = 10

PRINT "IMinC"; 
el = IMinC(numSng(), 0, UBOUND(numSng))
HandleResult el = 10

PRINT "InitInt"; 
start = 0
value = 0
numEls = UBOUND(numbers)
CALL Initint(numbers(), start, value, numEls)
HandleResult numbers(5) = 5

PRINT "InsertStr"; 
el = 5
numEls = UBOUND(numbers)
CALL InsertStr(elements$(), el, "Inserted", numEls) 
HandleResult elements$(5) = "Inserted"

PRINT "InsertT";
el = 5
numEls = UBOUND(fixed)
CALL InsertT(fixed(), el, 30, numEls) 
HandleResult fixed(5).S = SPACE$(30)

PRINT "ISortD"; 
el = 0
numEls = UBOUND(numDbl)
dir = 0
CALL ISortD(numDbl(), el, idx(), numEls, dir) 
HandleResult idx(10) = 10

PRINT "ISortI"; 
el = 0
numEls = UBOUND(numbers)
dir = 0
CALL ISortI(numbers(), el, idx(), numEls, dir) 
HandleResult idx(10) = 10

PRINT "ISortL"; 
el = 0
numEls = UBOUND(numLng)
dir = 0
CALL ISortL(numLng(), el, idx(), numEls, dir) 
HandleResult idx(10) = 10

PRINT "ISortS"; 
el = 0
numEls = UBOUND(numSng)
dir = 0
CALL ISortS(numSng(), el, idx(), numEls, dir) 
HandleResult idx(10) = 10

PRINT "ISortC"; 
el = 0
numEls = UBOUND(numSng)
dir = 0
CALL ISortC(numSng(), el, idx(), numEls, dir) 
HandleResult idx(10) = 10

PRINT "ISortStr"; 
el = 0
numEls = UBOUND(elements$)
dir = 0
CALL ISortStr(elements$(), el, ndx(), numEls, dir) 
HandleResult idx(10) = 10

PRINT "ISortStr2"; 
el = 0
numEls = UBOUND(elements$)
dir = 0
CALL ISortStr2(elements$(), el, ndx(), numEls, dir) 
HandleResult idx(10) = 10

PRINT "ISortT"; 
el = 0
numEls = UBOUND(fixed)
dir = 0
CALL ISortT(fixed(), el, ndx(), numEls, dir, 30, memberOffset, memberSize) 
HandleResult idx(10) = 10

PRINT "ISortT2"; 
el = 0
numEls = UBOUND(fixed)
dir = 0
CALL ISortT2(fixed(), el, ndx(), numEls, dir, 30, memberOffset, memberSize) 
HandleResult idx(10) = 10

PRINT "KeySort"; 
el = 0
numEls = UBOUND(fixed)
numKeys = 1
CALL KeySort(fixed(), el, 30, numEls, tbl(), numKeys) 
HandleResult tbl(1, 1) = 10

PRINT "MaxD"; 
max = MaxD(numDbl(), 0, UBOUND(numDbl))
HandleResult max = 10

PRINT "MaxI"; 
max = MaxI(numbers(), 0, UBOUND(numbers))
HandleResult max = 10

PRINT "MaxL"; 
max = MaxL(numLng(), 0, UBOUND(numLng))
HandleResult max = 10

PRINT "MaxS"; 
max = MaxS(numSng(), 0, UBOUND(numSng))
HandleResult max = 10

PRINT "MaxC"; 
max = MaxC(numSng(), 0, UBOUND(numSng))
HandleResult max = 10

PRINT "MinD"; 
min = MinD(numDbl(), 0, UBOUND(numDbl))
HandleResult min = 10

PRINT "MinI"; 
min = MinI(numbers(), 0, UBOUND(numbers))
HandleResult min = 10

PRINT "MinL"; 
min = MinL(numLng(), 0, UBOUND(numLng))
HandleResult min = 10

PRINT "MinS"; 
min = MinS(numSng(), 0, UBOUND(numSng))
HandleResult min = 10

PRINT "MinC"; 
min = MinC(numSng(), 0, UBOUND(numSng))
HandleResult min = 0

PRINT "Search"; 
el = 0
numEls = UBOUND(numbers)
match = 5
found = -1
dir = 0
matchCode = 0
varType = 0
CALL Search(numbers(), el, numEls, match, found, dir, matchCode, varType) 
HandleResult found = 0

PRINT "SearchT"; 
el = 0
numEls = UBOUND(fixed)
match = 5
found = -1
dir = 0
matchCode = 0
CALL SearchT(fixed(), el, numE1s%, match, found, dir, matchCode, structSize, memberOff, memberSize) 
HandleResult found = 0

PRINT "SearchT2"; 
el = 0
numEls = UBOUND(fixed)
match = 5
found = -1
dir = 0
matchCode = 0
CALL SearchT2(fixed(), el, numE1s%, match, found, dir, matchCode, structSize, memberOff, memberSize) 
HandleResult found = 0

PRINT "SetBit"; 
CALL SetBit(bits$, 1, 1)
HandleResult bit = 1

PRINT "SortD"; 
numEls = UBOUND(numDbl)
CALL SortD(numDbl(), 0, numEls, dir)
HandleResult numDbl(5) = 5

PRINT "SortI"; 
numEls = UBOUND(numbers)
CALL SortI(numbers(), 0, numEls, dir)
HandleResult numbers(5) = 5

PRINT "SortL"; 
numEls = UBOUND(numLng)
CALL SortL(numLng(), 0, numEls, dir)
HandleResult numLng(5) = 5

PRINT "SortS"; 
numEls = UBOUND(numSng)
CALL SortS(numSng(), 0, numEls, dir)
HandleResult numSng(5) = 5

PRINT "SortC"; 
numEls = UBOUND(numSng)
CALL SortC(numSng(), 0, numEls, dir)
HandleResult numSng(5) = 5

PRINT "SortStr"; 
numEls = UBOUND(elements$)
CALL SortStr(elements$(), 0, numEls, dir)
HandleResult elements$(5) = "Element 5"

PRINT "SortStr2"; 
numEls = UBOUND(elements$)
CALL SortStr2(elements$(), 0, numEls, dir)
HandleResult elements$(5) = "Element 5"

PRINT "SortT"; 
numEls = UBOUND(fixed)
CALL SortT(fixed(), 0, numEls, dir, 30, memberOffset, memberSize)
HandleResult fixed(5).S = "Element 5"

PRINT "SortT2"; 
numEls = UBOUND(fixed)
CALL SortT2(fixed(), 0, numEls, dir, 30, memberOffset, memberSize)
HandleResult fixed(5).S = "Element 5"

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