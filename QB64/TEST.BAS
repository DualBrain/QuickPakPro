' *********** TEST.BAS

' Copyright (c) 2022 Cory Smith

DEFINT A-Z

_TITLE "TEST"

'_FULLSCREEN _SQUAREPIXELS

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

PRINT
PRINT "****************************************"
PRINT " Chapter 3 - DOS Services"
PRINT "****************************************"
PRINT

PRINT "CDir"; 
CALL CDir("C:\")
HandleResult 1 = 1

PRINT "ClipFile"; 
CALL ClipFile("c:\test.txt", 100)
HandleResult 1 = 1

PRINT "DCount"; 
c = DCount("c:*.*")
HandleResult c = 3

PRINT "DiskInfo"; 
CALL DiskInfo("c:", bytes, sectors, freeClusters, totalClusters)
HandleResult bytes = 3

PRINT "DiskRoom"; 
room = DiskRoom("c:")
HandleResult room = 3

PRINT "DiskSize"; 
size = DiskSize("c:")
HandleResult size = 3

PRINT "DOSError"; 
result = DOSError
HandleResult result = 0

PRINT "DOSVer"; 
ver = DOSVer
HandleResult ver = 3

PRINT "ErrorMsg"; 
message$ = ErrorMsg(errorNumber)
HandleResult message$ = ""

PRINT "ExeName"; 
name$ = ExeName
HandleResult name$ = ""

PRINT "Exist"; 
there = Exist("c:\test.txt")
HandleResult there

' PRINT "FastLoad"; 
' lines = FastLoadInt("c:\test.txt")
' REDIM array$(1 TO lines)
' CALL FastLoadStr(array$())
' HandleResult array$(0) = ""

PRINT "FastSave"; 
CALL FastSave("c:\test.txt", array$())
HandleResult -1

PRINT "FClose";
CALL FClose(handle)
HandleResult -1

PRINT "FCopy";
buffer$ = SPACE$(4096)
CALL FCopy("c:\test.txt", "c:\copy.txt", buffer$, errCode)
HandleResult errCode = 0

PRINT "FCount";
c = FCount("c:\*.bas")
HandleResult c = 0

PRINT "FCreate";
CALL FCreate("c:\test.tmp")
HandleResult -1

PRINT "FEof";
result = FEof(handle)
HandleResult result

PRINT "FFlush";
CALL FFlush(handle)
HandleResult -1

PRINT "FGet";
buffer$ = " "
CALL FGet(handle, buffer$)
HandleResult buffer$ <> " "

PRINT "FGetA";
CALL FGetA(handle, array$(), el, numBytes)
HandleResult array$(0) = ""

PRINT "FGetAH";
CALL FGetAH("c:\test.txt", array$(), el, elSize, numEls)
HandleResult array$(0) = ""

PRINT "FGetR";
CALL FGetR(handle, buffer$, recNumber)
HandleResult buffer$ <> ""

PRINT "FGetRT";
DIM dest AS FLen
CALL FGetRT(handle, dest, recNumber, recSize)
HandleResult dest.S <> ""

PRINT "FGetRTA";
CALL FGetRTA(handle, dest, recNumber, recSize)
HandleResult dest.S <> ""

PRINT "FGetT";
CALL FGetT(handle, dest, numBytes)
HandleResult dest.S <> ""

PRINT "FileComp";
result = FileComp("c:\test.txt", "c:\test.tmp", errCode)
HandleResult errCode = 0

PRINT "FileCopy";
CALL FileCopy("c:\test.txt", "c:\test.tmp", copied, errCode)
HandleResult errCode = 0

PRINT "FileCrypt";
pw$ = "password"
CALL FileCrypt("c:\test.txt", pw$)
HandleResult -1

PRINT "FileInfo";
Dim tVar AS FInfo
CALL FileInfo("c:\test.txt", tVar)
HandleResult -1

PRINT "FileSize";
size = FileSize("c:\test.txt")
HandleResult size = 0

PRINT "FileSort";
CALL FileSort("c:\test.txt", "c:\text.idx", 1, 10, tbl(), recLength)
HandleResult -1

PRINT "FLInput";
value$ = FLInput(handle, buffer$)
HandleResult value$ <> ""

PRINT "FLoc";
result = FLoc(handle)
HandleResult result <> 0

PRINT "FLof";
result = FLof(handle)
HandleResult result <> 0

PRINT "FOpen";
CALL FOpen("c:\text.txt", handle)
HandleResult handle <> -1

PRINT "FOpenS";
CALL FOpenS("c:\text.tmp", handle)
HandleResult handle <> -1

PRINT "FOpenAll";
CALL FOpenAll("c:\text.all", 2, 4, handle)
HandleResult handle <> -1

PRINT "FormatDiskette";
DIM bufArray%(1 TO 2340)
result = FormatDiskette(0, 1440, bufArray%())
HandleResult result <> 0

PRINT "FPut";
buffer$ = SPACE$(512)
CALL FPut(handle, buffer$)
HandleResult -1

PRINT "FPutA";
CALL FPutA(handle, bufArray%(), 1, 55)
HandleResult -1

PRINT "FPutAH";
CALL FPutAH(handle, bufArray%(), 1, 2, 55)
HandleResult -1

PRINT "FPutR";
CALL FPutR(handle, buffer$, 1)
HandleResult -1

PRINT "FPutRT";
CALL FPutRT(handle, fixed(0), 1, 30)
HandleResult -1

PRINT "FPutRTA";
CALL FPutRTA(handle, fixed(0), 1, 30)
HandleResult -1

PRINT "FPutT";
CALL FPutT(handle, fixed(0), 30)
HandleResult -1

PRINT "FSeek";
CALL FSeek(handle, 0)
HandleResult -1

PRINT "FStamp";
CALL FStamp("c:\test.txt", "05:05", "05/02/88")
HandleResult -1

PRINT "FullName$";
value$ = FullName("..\test.txt")
HandleResult -1

PRINT "GetAttr";
result = GetAttr("c:\test.txt")
HandleResult result <> 0

PRINT "GetDir$";
directory$ = GetDir("c")
HandleResult directory$ <> ""

PRINT "GetDisketteType";
result = GetDisketType(0)
HandleResult result <> 0

PRINT "GetDrive";
result = GetDrive
HandleResult result <> 0

PRINT "GetVol$";
volume$ = GetVol$("c")
HandleResult volume$ <> ""

PRINT "GoodDrive";
result = GoodDrive("z")
HandleResult result <> 0

PRINT "Handle2Name";
DIM fname AS NameType
CALL Handle2Name(handle, fname)
HandleResult fname.Filename <> ""

PRINT "KillDir";
CALL KillDir("c:\blah")
HandleResult -1

PRINT "KillFile";
CALL KillFile("c:\blahblah.txt")
HandleResult -1

PRINT "LastDrive";
result = LastDrive
HandleResult result <> 0

PRINT "LineCount";
buffer$ = SPACE$(4096)
c = LineCount("c:\test.txt", buffer$)
HandleResult c <> 0

PRINT "LoadExec";
cmdLine$ = ""
exitCode = LoadExec("test.exe", cmdLine$)
HandleResult exitCode <> 0

PRINT "LockFile";
CALL LockFile(handle, 1, -1)
HandleResult -1

PRINT "MakeDir";
CALL MakeDir("c:\blah")
HandleResult -1

PRINT "NameDir";
CALL NameDir("c:\blah", "c:\blah1")
HandleResult -1

PRINT "NameFile";
CALL NameFile("c:\test.txt", "c:\test1.txt")
HandleResult -1

PRINT "NetDrive";
remote = NetDrive("n")
HandleResult -1

PRINT "PutVol";
CALL PutVol("d", "TestLabel")
HandleResult -1

PRINT "QBLoad";
CALL QBLoad("c:\test.txt", numbers(), el)
HandleResult -1

PRINT "QBSave";
CALL QBSave("c:\test.txt", numbers(), el, 10)
HandleResult -1

PRINT "ReadDir";
CALL ReadDir(elements$())
HandleResult -1

' PRINT "ReadDirT";
' DIM dirs(500) AS FLen
' CALL ReadDirT("*.*", dirs(), 1)
' HandleResult -1

PRINT "ReadFile";
CALL ReadFile(elements$())
HandleResult -1

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
  IF success AND e$ = "" THEN 
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