' *********** TEST.BAS

' Copyright (c) 2022 Cory Smith

DEFINT A-Z

$RESIZE:STRETCH

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

PRINT "ReadFileI";
CALL ReadFileI(elements$())
HandleResult -1

PRINT "ReadFileT";
DIM fls(200) AS FLen
CALL ReadFileT("*.*", fls(), 1)
HandleResult -1

PRINT "ReadFileX";
DIM fi(200) AS FullInfo
CALL ReadFileX("*.*", sz&, fi(), 1)
HandleResult -1

PRINT "ReadSect";
buffer$ = SPACE$(512)
CALL ReadSect("C", buffer$, 1)
HandleResult -1

PRINT "ReadTest";
result = ReadTest("A")
HandleResult -1

PRINT "Removable";
result = Removable("A")
HandleResult -1

PRINT "ScanFile";
result = ScanFile("c:\test.txt", "test", 1)
HandleResult -1

PRINT "SearchPath";
buffer$ = SearchPath("test.txt")
HandleResult -1

PRINT "SetAttr";
CALL SetAttr("test.txt", 0)
HandleResult -1

PRINT "SetCmd";
CALL SetCmd("-t test")
HandleResult -1

PRINT "SetDrive";
CALL SetDrive("A")
HandleResult -1

PRINT "SetError";
CALL SetError(55)
HandleResult -1

PRINT "SetLevel";
CALL SetLevel(1)
HandleResult -1

PRINT "ShareThere";
result = ShareThere
HandleResult -1

PRINT "SplitName";
CALL SplitName(workName$, drive$, path$, fileName$, extension$)
HandleResult -1

PRINT "Unique";
fileName$ = Unique(path$)
HandleResult -1

PRINT "UnLockFile";
CALL UnLockFile(handle, offset&, length&)
HandleResult -1

PRINT "Valid";
result = Valid(fileName$)
HandleResult -1

PRINT "WhichError";
result = WhichError
HandleResult -1

PRINT "WriteSect";
CALL WriteSect("C", buffer$, 1)
HandleResult -1

PRINT "WriteSect2";
CALL WriteSect2("C", buffer$, 1)
HandleResult -1

PRINT "WriteTest";
result = WriteTest("C")
HandleResult -1

PRINT
PRINT "****************************************"
PRINT " Chapter 4 - Functions"
PRINT "****************************************"
PRINT

' SEE: FNOTHER.BAS
' SEE: FNSPREAD.BAS

PRINT "Bin2Num";
binary$ = "00000010"
number = Bin2Num(binary$)
HandleResult number = 3

PRINT "Num2Bin";
binary$ = Num2Bin(3) 
HandleResult binary$ = "00000010"

PRINT "Num2Bin2";
binary$ = Num2Bin2(3) 
HandleResult binary$ = "00000010"

PRINT "QPHex";
hexNumber$ = QPHex(value, numDigits) 
HandleResult hexNumber$ = "5A"

PRINT
PRINT "****************************************"
PRINT " Chapter 5 - Menu/Input Routines"
PRINT "****************************************"
PRINT

' SEE: CAPNUM.BAS
' SEE: DATEIN.BAS
' SEE: DIALOG.BAS
' SEE: LTS2MENU.BAS
' SEE: LTSMENU.BAS
' SEE: MASKIN.BAS
' SEE: NUMIN.BAS
' SEE: PICKLIST.BAS
' SEE: PULLDOWN.BAS
' SEE: PULLDNMS.BAS
' SEE: QEDIT.BAS
' SEE: SCROLLIN.BAS
' SEE: SPREAD.BAS
' SEE: TEXTIN.BAS
' SEE: VERTMENU.BAS
' SEE: VERTMENT.BAS
' SEE: YESNO.BAS

' CALL AMenu(BYVAL VARPTR(Array$(Start%)), Startitem%, Count%, ScanCode%, NormColor%, HiLiteColor%, NumRows%, NumCols%, Gap%, ULRow%, ULCol%) 
' CALL AMenuT{BYVAL VARSEG(Array{Start%)), BYVAL VARPTR(Array(Start%)), Startltem%, Length%,Count%, ScanCode%, NormColor%, HiliteColor%, NumRows%, NumCols%, Gap%, ULRow%, ULCol%) 
' CALL ASCIIPick(Char%, Color!%, Color2%, ExitCode%) 
' CALL MASCIIPick(Char%, Color!%, Color2%, ExitCode%)

PRINT "CapNum";
CALL CapNum 
HandleResult -1

' CALL ColorPick(Colr%, BoxColor%, ExitCode%) 
' CALL MColorPick(Colr%, BoxColor%, ExitCode%)
' CALL Dateln(D$, ExitCode%, Colr%) 
' CALL Dialog(Choice%, Text$(), Resp$(), Menu$(), Row%, Style%, Colr%, Action%) 
' CALL DirFile(BYVAL VARPTR(Array$(1)), Count%, ScanCode%, MsgColor%, FileColor%, HiLiteColor%, BoxColor%) 
' CALL Editor(Ed$, ActiveLength%, ScanCode%, Num0nly%, Caps0n%, Norma1Color%, EditColor%, Row%, Column%) 
' CALL Lts2Menu(Item$(), Prompt$(), Choice%, Colr%) 
' CALL LtsMenu(Item$(), Choice%, Colr%)
' CALL MAMenu(BYVAL VARPTR(Array$(1)), Selection%, Start%, Count%, ScanCode%, Norma1Color%, Hilight%, NumRows%, NumCols%, Gap%, _ Row%, Column%) 
' CALL MAMenuT(BYVAL VARSEG(Array$(1)), BYVAL VARPTR(Array$(1)), Selection%, Start%, Length%, Count%, ScanCode%, NormalColor%, Hilight%, NumRows%, NumCols%, Gap%, Row%, Column%) 
' Call Maskln(Mask$, Text$, Mski) 
' CALL MEditor(Ed$, ActiveLength%, ScanCode%, Num0nly%, Caps0n%, Norma1Color%, EditColor%, Row%, Column%, CurrentColumn%) 
' CALL MenuVert(BYVAL VARPTR(Array$(1)), Numl ines%, ScanCode%, Choice%, Norma1Color%, HiL iteColor%, Row%, Column%) 
' ScanCode = MGetKey%(Row%, Column%) 
' CALL MMenuVert(BYVAL VARPTR(Array$(1)), Selection%, Start%, ScanCode%, NormalColor%, Hilight%, NumRows%, Row%, Column%) 
' CALL Numln(Number#, Max%, Places%, ExitCode%, Colr%)
' CALL PickList (Items$(), Picked%(), NPicked%, Cnf)
' CALL Pu11Down(Choice$(), Status%(), Menu%, Choice%, Ky$, Action%, Cnf) 
' CALL PullDnMS (Choice$(), Stat%(), Menu%, Choice%, Ky$, Action%) 
' CALL QEdit(Array$(), Ky$, Action%, Ed) 
' CALL Scrollln(Edit$, Start%, Wide%, MaxLen%, Filter%, Ky%, EdClr%, Norma1Clr%) 
' CALL Spread(Wks$(), Format$(), ColumnWidths%(), Wide%, Rows%, Action%) 
' CALL Textln(Text$, Max%, Num0nly%, Caps0n%, ExitCode%, Colr%) 
' CALL VertMenu(Item$(), Choice%, MaxLen%,BoxBot%, Ky$, Action%, Cnf)
' CALL YesNo(YN$, Prompt$, ScanCode%, Norma1Color%, EditColor%, Row%, Column%) 
' CALL YesNoB(YN$, ExitCode%, Colr%) 

PRINT
PRINT "****************************************"
PRINT " Chapter 6 - Keyboard/Mouse Routines"
PRINT "****************************************"
PRINT

PRINT "AltKey";
result = AltKey 
HandleResult -1

PRINT "ButtonPress";
CALL ButtonPress(button, status, count, x, y)
HandleResult -1

PRINT "CapsLock";
result = CapsLock 
HandleResult -1

PRINT "CapsOn";
CALL CapsOn
HandleResult -1

PRINT "CapsOff";
CALL CapsOff
HandleResult -1

PRINT "ClearBuf";
CALL ClearBuf
HandleResult -1

PRINT "CtrlKey";
result = CtrlKey 
HandleResult -1

PRINT "GetCursor";
CALL GetCursor(x, y, button) 
HandleResult -1

PRINT "GetCursorT";
CALL GetCursorT(col, row, button) 
HandleResult -1

PRINT "GrafCursor";
CALL GrafCursor(x, y, cursor$)
HandleResult -1

PRINT "HideCursor";
CALL HideCursor
HandleResult -1

PRINT "InitMouse";
CALL InitMouse(there)
HandleResult -1

PRINT "InStat";
result = InStat
HandleResult -1

PRINT "Keyboard";
CALL Keyboard(row, column, color1, color2, mode)
HandleResult -1

PRINT "KeyDown";
result = KeyDown
HandleResult -1

PRINT "Motion";
CALL Motion(value)
HandleResult -1

PRINT "Motion";
CALL Mouse(ax, bx, cx, dx) 
HandleResult -1

PRINT "MouseRange";
DIM mr(1) AS Area
CALL MouseRange(mr(), start, numEls, row, col, button, rangeNum) 
HandleResult -1

PRINT "MouseRange";
CALL MouseTrap(ulRow, ulCol, lrRow, lrCol) 
HandleResult -1

PRINT "NumLock";
result = NumLock
HandleResult -1

PRINT "NumOff";
CALL NumOff
HandleResult -1

PRINT "NumOn";
CALL NumOn
HandleResult -1

PRINT "PeekBuf";
result = PeekBuf
HandleResult -1

PRINT "RptKey";
CALL RptKey(char, count) 
HandleResult -1

PRINT "ScrlLock";
result = ScrlLock
HandleResult -1

PRINT "SetCursor";
CALL SetCursor(x, y) 
HandleResult -1

PRINT "ShiftKey";
result = ShiftKey
HandleResult -1

PRINT "ShowCursor";
CALL ShowCursor 
HandleResult -1

PRINT "StuffBuf";
CALL StuffBuf("A") 
HandleResult -1

PRINT "TextCursor";
CALL TextCursor(fg, bg) 
HandleResult -1

' PRINT "WaitKey";
' result = WaitKey 
' HandleResult -1

PRINT "WaitScan";
result = WaitScan
HandleResult -1

PRINT "WaitUp";
CALL WaitUp
HandleResult -1

PRINT
PRINT "****************************************"
PRINT " Chapter 7 - Miscellaneous Routines"
PRINT "****************************************"
PRINT

' SEE: ASCCHART.BAS
' SEE: CALC.BAS
' SEE: CALENDAR.BAS
' SEE: DATE2DAY.BAS
' SEE: DEMO123.BAS
' SEE: DIRTREE.BAS
' SEE: EVALUATE.BAS
' SEE: GETCMOS.BAS
' SEE: MAKEQLB.BAS
' SEE: MARQUEE.BAS 
' SEE: MSGBOX.BAS
' SEE: QPSOLVER.BAS
' SEE: GET1STR.BAS
' SEE: STRREST.BAS
' SEE: DEMOSTR.BAS
' SEE: VIEWFILE.BAS
' SEE: WORDWRAP.BAS

PRINT "AddUSI";
result = AddUSI(x, y) 
HandleResult -1

' CALL ASCIIChart(ulRow, ulCol, height)

PRINT "BCopy";
CALL BCopy(fromSeg, fromAddr, toSeg, toAddr, numBytes, direction) 
HandleResult -1

'CALL BCopyT(SEG fromEl, SEG toEl, elSize, numEls)

PRINT "BCopy";
CALL BLPrint(lptNumber, x$, errCount)
HandleResult -1

' PRINT "Calc";
' CALL Calc(ulRow, ulCol, fg, bg)  
' HandleResult -1

' ' PRINT "Calendar";
' CALL Calendar(month, day, year, ulRow, ulCol, color1, color2, action)  
' HandleResult -1

PRINT "Chime";
CALL Chime(1) 
HandleResult -1

PRINT "Clock";
CALL Clock(1, 1, 7, 1)
HandleResult -1

PRINT "Clock24";
CALL Clock24(1, 1, 7, 1)
HandleResult -1

PRINT "Compare";
result = Compare (seg1, adr1, seg2, adr2, numBytes) 
HandleResult -1

PRINT "CompareT";
result = CompareT (type1, type2, numBytes) 
HandleResult -1

' PRINT "Date2Day";
' result = Date2Day ("12/11/2022") 
' HandleResult -1

PRINT "Date2Num";
result = Date2Num ("12/11/2022") 
HandleResult -1

PRINT "DayName";
buffer$ = DayName (1) 
HandleResult buffer$ = "Mon"

' CALL DirTree(Tree$(), Ful1Path$(), Levels%)

PRINT "DayName";
result = EDate2Num("12/11/2022")
HandleResult -1

' *** EMS Methods

PRINT "Empty";
CALL Empty(a) 
HandleResult -1

PRINT "ENum2Date";
buffer$ = ENum2Date(0) 
HandleResult -1

' PRINT "Evaluate";
' result = Evaluate("1 + 1") 
' HandleResult result = 2

PRINT "Extended";
CALL Extended 
HandleResult -1

PRINT "Factorial";
result = Factorial#(0) 
HandleResult -1

PRINT "FileView";
DIM fvInfo AS FVInfo
REDIM buf(1 TO 16384) 
CALL FileView(fileName$, ky, action, fvInfo, buf(), 1) 
HandleResult -1

PRINT "FudgeFactor";
result = FudgeFactor&
HandleResult -1

PRINT "GetCPU";
result = GetCPU
HandleResult -1

PRINT "GetDS";
result = GetDS
HandleResult -1

PRINT "GetEquip";
CALL GetEquip(floppies, parallels, serials)
HandleResult -1

' PRINT "LockUp";
' CALL LockUp
' HandleResult -1

' PRINT "Marquee";
' CALL Marquee(x$, row, colr) 
' HandleResult -1

PRINT "MathChip";
result = MathChip
HandleResult -1

PRINT "MaxInt";
result = MaxInt(2, 1)
HandleResult result = 2

PRINT "MaxLong";
result = MaxLong(2, 1)
HandleResult result = 2

PRINT "MinInt";
result = MinInt(2, 1)
HandleResult result = 1

PRINT "MinLong";
result = MinLong(2, 1)
HandleResult result = 1

PRINT "MonthName";
buffer$ = MonthName(1)
HandleResult buffer$ = "Jan"

PRINT "MonthName";
CALL MsgBox(message$, wide, cnf)
HandleResult -1

PRINT "Num2Date";
buffer$ = Num2Date(0)
HandleResult -1

PRINT "Num2Day";
result = Num2Day(0)
HandleResult -1

PRINT "Num2Time";
buffer$ = Num2Time(0)
HandleResult -1

PRINT "Pause";
CALL Pause(36)
HandleResult -1

PRINT "Pause2";
CALL Pause2(200)
HandleResult -1

PRINT "Pause3";
CALL Pause3(2000, fudge&)
HandleResult -1

PRINT "PDQTimer";
result = PDQTimer
HandleResult -1

PRINT "Peek1";
result = Peek1(segment, address) 
HandleResult -1

PRINT "Peek2";
result = Peek2(segment, address) 
HandleResult -1

PRINT "Poke1";
CALL Poke1(segment, address, byte) 
HandleResult -1

PRINT "Poke2";
CALL Poke2(segment, address, byte) 
HandleResult -1

PRINT "Power";
result = Power(y, n) 
HandleResult -1

PRINT "Power2";
result = Power2(n) 
HandleResult -1

PRINT "PRNReady";
result = PRNReady(1) 
HandleResult -1

PRINT "PSwap";
CALL PSwap 
HandleResult -1

PRINT "QPCli";
CALL QPCli
HandleResult -1

PRINT "QPSti";
CALL QPSti
HandleResult -1

PRINT "QPPlay";
CALL QPPlay("C1")
HandleResult -1

PRINT "QPSound";
CALL QPSound(1000, 1)
HandleResult -1

PRINT "QPSSeg";
result = QPSSeg(a$) 
HandleResult -1

PRINT "QPSegAdr";
result = QPSegAdr(a$) 
HandleResult -1

PRINT "QPUSI";
result = QPUSI(0) 
HandleResult -1

PRINT "ReBoot";
CALL ReBoot
HandleResult -1

PRINT "ShiftIL";
CALL ShiftIL(intVar, numBits)
HandleResult -1

PRINT "ShiftIR";
CALL ShiftIR(intVar, numBits)
HandleResult -1

PRINT "ShiftLL";
CALL ShiftLL(longVar&, numBits)
HandleResult -1

PRINT "ShiftLR";
CALL ShiftLR(longVar&, numBits)
HandleResult -1

PRINT "Soundex";
dummy$ = Soundex("test")
HandleResult -1

PRINT "Soundex";
dummy$ = Soundex("test")
HandleResult -1

' String Manager Routines

PRINT "SysTime";
dummy$ = SPACE$(11)
CALL SysTime(dummy$)
HandleResult -1

PRINT "Time2Num";
result = Time2Num("00:00:00")
HandleResult -1

PRINT "Times2";
result = Times2(1)
HandleResult result = 2

PRINT "TrapInt";
result = TrapInt(10, 1, 5) 
HandleResult result = 5

PRINT "ViewFile";
CALL ViewFile(fileName$, wide, high, colr, hiBit, action) 
HandleResult -1

PRINT "VLAdd";
CALL VLAdd(value1#, value2#, sum#, errFlag)
HandleResult -1

PRINT "VLDiv";
CALL VLDiv(dividend#, divisor#, quotient#, remainder#, errFlag)
HandleResult -1

PRINT "VLMul";
CALL VLMul(value1#, value2#, product#, errFlag)
HandleResult -1

PRINT "VLPack";
CALL VLPack(number$, value#, errFlag)
HandleResult -1

PRINT "VLSub";
CALL VLSub(value1#, value2#, difference#, errFlag)
HandleResult -1

PRINT "VLUnpack";
buffer$= SPACE$(20) 
CALL VLUnpack(alias#, buffer$, errFlag%) 
HandleResult -1

PRINT "WeekDay";
result = WeekDay("12/11/2022") 
HandleResult result = 1

' PRINT "WeekDay";
' CALL WordWrap(message$, wide) 
' HandleResult -1

' XMS Manager Routines

PRINT
PRINT "****************************************"
PRINT " Chapter 8 - String Manipulation Routines"
PRINT "****************************************"
PRINT

' SEE: SPELLNUM.BAS

PRINT "ASCII";
result = ASCII("A")
HandleResult result = 65

PRINT "Blanks";
result = Blanks("    ")
HandleResult -1

PRINT "Compact";
buffer$ = Compact("    ")
HandleResult buffer$ = ""

PRINT "Encrypt";
buffer$ = "raw data"
CALL Encrypt(buffer$, "password")
HandleResult buffer$ = ""

PRINT "Encrypt2";
buffer$ = "raw data"
CALL Encrypt2(buffer$, "password")
HandleResult buffer$ = ""

PRINT "Far2Str";
buffer$ = Far2Str(segment, address)
HandleResult buffer$ = ""

PRINT "FUsing";
buffer$ = FUsing$(STR$(number), image$) 
HandleResult buffer$ = ""

PRINT "InCount";
result = InCount(source$, "A") 
HandleResult -1

PRINT "InCount2";
result = InCount2(source$, "a") 
HandleResult -1

PRINT "InCountTbl";
result = InCountTbl(source$, table$) 
HandleResult -1

PRINT "InstrTbl";
result = InstrTbl(start, source$, table$)
HandleResult -1

PRINT "InstrTbl2";
result = InstrTbl2(start, source$, table$)
HandleResult -1

PRINT "InstrTblB";
result = InstrTblB(start, source$, table$)
HandleResult -1

PRINT "InstrTblB2";
result = InstrTblB2(start, source$, table$)
HandleResult -1

PRINT "LongestStr";
result = LongestStr(element$()) 
HandleResult -1

PRINT "LowASCII";
CALL LowASCII("abcd") 
HandleResult -1

PRINT "Lower";
buffer$ = "AbCd"
CALL Lower(buffer$) 
HandleResult buffer$ = "abcd"

PRINT "LowerTbl";
buffer$ = "AbCd"
CALL LowerTbl(buffer$, table$) 
HandleResult buffer$ = "abcd"

PRINT "MidChar";
buffer$ = "AbCd"
result = MidChar(buffer$, 2) 
HandleResult result = 98

PRINT "MidCharS";
buffer$ = "AbCd"
CALL MidCharS(buffer$, 2, result) 
HandleResult result = 98

PRINT "NotInstr";
buffer$ = "AbCd"
table$ = "A"
result = NotInstr(1, buffer$, table$)
HandleResult result = 2

PRINT "Null";
buffer$ = CHR$(0)
result = Null(buffer$)
HandleResult result = -1

PRINT "ParseString";
buffer$ = "a,b,c,d"
position = 1
delimit$ = ","
a$ = ParseString(position, buffer$, delimit$)
HandleResult a$ = "a" AND position = 3

PRINT "ProperName";
buffer$ = "john doe, jr."
CALL ProperName(buffer$) 
HandleResult buffer$ = "John Doe, Jr."

PRINT "QInstr";
buffer$ = "a,b,c,d"
startPos = 1
srch$ = "a"
position = QInstr(startPos, buffer$, srch$)
HandleResult position = 1

PRINT "QInstr2";
buffer$ = "a,b,c,d"
startPos = 1
srch$ = "A"
position = QInstr2(startPos, buffer$, srch$)
HandleResult position = 1

PRINT "QInstrB";
buffer$ = "a,b,c,d"
startPos = 1
srch$ = ","
position = QInstrB(startPos, buffer$, srch$)
HandleResult position = 6

PRINT "QInstrB2";
buffer$ = "a,b,B,d"
startPos = 1
srch$ = "b"
position = QInstrB2(startPos, buffer$, srch$)
HandleResult position = 5

PRINT "QInstrH";
segement = 1
address = 1
srch$ = "b"
numBytes& = 10
CALL QInstrH(segment, address, srch$, numBytes&)
HandleResult segment = 0 AND address = 0

PRINT "QPLeft";
work$ = "a,b,B,d"
numChars = 2
subString$ = QPLeft(work$, numChars)
HandleResult subString$ = "a,"

PRINT "QPMid";
work$ = "a,b,B,d"
numChars = 3
startChar = 3
subString$ = QPMid(work$, startChar, numChars)
HandleResult subString$ = "b,B"

PRINT "QPRight";
work$ = "a,b,B,d"
numChars = 2
subString$ = QPRight(work$, numChars)
HandleResult subString$ = ",d"

PRINT "QPLen";
work$ = "a,b,B,d"
result = QPLen(work$)
HandleResult result = 7

PRINT "QPSadd";
result = QPSadd(work$)
HandleResult result = 0

PRINT "QPStrI";
work$ = QPStrI(5)
HandleResult work$ = "5"

PRINT "QPStrL";
work$ = QPStrL(5)
HandleResult work$ = "5"

PRINT "QPTrim";
work$ = "   a-z   "
subString$ = QPTrim(work$)
HandleResult subString$ = "a-z"

PRINT "QPLTrim";
work$ = "   a-z   "
subString$ = QPLTrim(work$)
HandleResult subString$ = "a-z   "

PRINT "QPRTrim";
work$ = "   a-z   "
subString$ = QPRTrim(work$)
HandleResult subString$ = "   a-z"

PRINT "QPValI";
work$ = "12345"
result = QPValI(work$)
HandleResult result = 12345

PRINT "QPValL";
work$ = "123456789"
r& = QPValL(work$)
HandleResult r& = 123456789

PRINT "RemCtrl";
work$ = CHR$(0) + CHR$(13) + "1234"
CALL RemCtrl(work$, replace$)
HandleResult replace$ = "1234"

PRINT "ReplaceChar";
work$ = "1234"
CALL ReplaceChar(work$, "1", "2")
HandleResult work$ = "2234"

PRINT "ReplaceChar2";
work$ = "a234"
CALL ReplaceChar2(work$, "A", "2")
HandleResult work$ = "2234"

PRINT "ReplaceCharT... skip"
PRINT "ReplaceCharT2... skip"

PRINT "ReplaceString";
work$ = "1234"
CALL ReplaceString(work$, "123", "444")
HandleResult work$ = "4444"

PRINT "ReplaceTbl";
work$ = "1234"
CALL ReplaceTbl(work$, "142434")
HandleResult work$ = "4444"

PRINT "Sequence";
work$ = "1234"
CALL Sequence(work$)
HandleResult work$ = "1235"

' PRINT "SpellNumber";
' work$ = "1"
' english$ = SpellNumber(work$)
' HandleResult english$ = "One"

PRINT "Translate";
work$ = CHR$(196)
CALL Translate(work$)
HandleResult work$ = "-"

PRINT "Upper";
work$ = "a"
CALL Upper(work$)
HandleResult work$ = "A"

PRINT "UpperTbl... skip"

PRINT
PRINT "****************************************"
PRINT " Chapter 9 - Video Routines"
PRINT "****************************************"
PRINT

' SEE: COLORS.BAS

' CALL APrint(BYVAL VARPTR(Array$(First)), NumEls%, FirstChar%, NumChars%, Colr%, Page%) 
' CALL APrint0(BYVAL VARPTR(Array$(First)), NumEls%, FirstChar%, NumChars%, Colr%) 
' CALL APrintT(BYVAL VARSEG(Array$(First)), BYVAL VARPTR(Array$(First)), ElSize%, NumE1s%, FirstChar%, NumChars%, Colr%, Page%) 
' CALL APrintT0(BYVAL VARSEG(Array$(First)), BYVAL VARPTR(Array$(First)), E1Size%, NumEls%, FirstChar%, NumChars%, Colr%) 
' Size = ArraySize%(ULRow%, ULCol%, LRRow%, LRCol%) 
' CALL BlinkOff 
' CALL BlinkOn 
' CALL Box(ULRow%, ULCol%, LRRow%, LRCol%, Char%, Colr%, Page%)
' CALL Box0(ULRow%, ULCol%, LRRow%, LRCol%, Char%, Colr%)
' CALL BPrint(X$) 
' CALL ClearEOL(Colr%)
' CALL ClearScr(ULRow%, ULCo1%, LRRow%, LRCo1%, Colr%, Page%) 
' CALL ClearScr0(ULRow%, ULCol%, LRRow%, LRCol%, Colr%) 
' CALL CsrSize(Top%, Bottom%) 
' CALL EGABLoad(FileName$) 
' CALL EGABSave(FileName$) 
' Memory= EGAMem%
' CALL FillScrn(ULRow%, ULCol%, LRRow%, LRCo1%, Colr%, Char%, Page%) 

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

'$INCLUDE: 'CAPNUM.BAS'
'$INCLUDE: 'CALC.BAS'
'$INCLUDE: 'CALENDAR.BAS'
'$INCLUDE: 'PRO.BAS'