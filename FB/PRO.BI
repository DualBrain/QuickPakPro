Dim Shared Pro_Internal_DosError As Short
Dim Shared Pro_Internal_WhichError As Short

TYPE FInfo 
  Year As Short
  Month As Short
  Day As Short
  Hour As Short
  Minute As Short
  Second As Short
  Size As Long
  Attrib As Short
END TYPE 

' ****************************************
' Chapter 2 - Array Routines 
' ****************************************

DECLARE SUB AddInt(address As Short Ptr, value As Short, numEls As Short)
DECLARE SUB DeleteStr(address As String Ptr, numEls As Short)
DECLARE SUB DeleteT(address As Any Ptr, elSize As Short, numEls As Short)
DECLARE SUB Fill2(address As Short Ptr, value As Short, numEls As Short)
DECLARE SUB Fill4 OVERLOAD (address As Long Ptr, value As Long, numEls As Short)
DECLARE SUB Fill4 OVERLOAD (address As Single Ptr, value As Single, numEls As Short)
DECLARE SUB Fill8(address As Double Ptr, value As Double, numEls As Short)
DECLARE SUB Find(address As String Ptr, Byref numEls As Short, searchValue As String)
DECLARE SUB Find2(address As String Ptr, Byref numEls As Short, searchValue As String)
DECLARE SUB FindB(address As String Ptr, Byref curEl As Short, searchValue As String)
DECLARE SUB FindB2(address As String Ptr, Byref curEl As Short, searchValue As String)
DECLARE SUB FindExact(address As String Ptr, Byref numEls As Short, searchValue As String)
DECLARE SUB FindT(address As Any Ptr, elSize As Short, Byref numEls As Short, searchValue As String)
DECLARE SUB FindT2(address As Any Ptr, elSize As Short, Byref numEls As Short, searchValue As String)
DECLARE SUB FindTB(address As Any Ptr, elSize As Short, Byref curEl As Short, searchValue As String)
DECLARE SUB FindTB2(address As Any Ptr, elSize As Short, Byref curEl As Short, searchValue As String)
DECLARE FUNCTION FindLast (address As String Ptr, numEls As Short) As Short
DECLARE FUNCTION GetBit(array As String, element As Short) As Short
DECLARE FUNCTION IMaxD(address As Double Ptr, numEls As Short) As Short
DECLARE FUNCTION IMaxI(address As Short Ptr, numEls As Short) As Short
DECLARE FUNCTION IMaxL(address As Long Ptr, numEls As Short) As Short
DECLARE FUNCTION IMaxS(address As Single Ptr, numEls As Short) As Short
DECLARE FUNCTION IMaxC(address As Double Ptr, numEls As Short) As Short
DECLARE FUNCTION IMinD(address As Double Ptr, numEls As Short) As Short
DECLARE FUNCTION IMinI(address As Short Ptr, numEls As Short) As Short
DECLARE FUNCTION IMinL(address As Long Ptr, numEls As Short) As Short
DECLARE FUNCTION IMinS(address As Single Ptr, numEls As Short) As Short
DECLARE FUNCTION IMinC(address As Double Ptr, numEls As Short) As Short
DECLARE SUB InitInt(address As Short Ptr, value As Short, numEls As Short)
DECLARE SUB InsertStr(address As String Ptr, value As String, numEls As Short)
DECLARE SUB InsertT(address As Any Ptr, elSize As Short, numEls As Short)
DECLARE SUB ISortD(array As Double Ptr, ndx As Short Ptr, numEls As Short, direction As Short)
DECLARE SUB ISortI(array As Short Ptr, ndx As Short Ptr, numEls As Short, direction As Short)
DECLARE SUB ISortL(array As Long Ptr, ndx As Short Ptr, numEls As Short, direction As Short)
DECLARE SUB ISortS(array As Single Ptr, ndx As Short Ptr, numEls As Short, direction As Short)
DECLARE SUB ISortC(array As Double Ptr, ndx As Short Ptr, numEls As Short, direction As Short)
DECLARE SUB ISortStr(array As String Ptr, ndx As Short Ptr, numEls As Short, direction As Short)
DECLARE SUB ISortStr2(array As String Ptr, ndx As Short Ptr, numEls As Short, direction As Short)
DECLARE SUB ISortT(array As Any Ptr, ndx As Short Ptr, numEls As Short, direction As Short, elSize As Short, memberOffset As Short, memberSize As Short)
DECLARE SUB ISortT2(array As Any Ptr, ndx As Short Ptr, numEls As Short, direction As Short, elSize As Short, memberOffset As Short, memberSize As Short)
DECLARE SUB KeySort(array As Any Ptr, elSize As Short, numEls As Short, table() As Short, numKeys As Short)
DECLARE FUNCTION MaxD(address As Double Ptr, numEls As Short) As Double
DECLARE FUNCTION MaxI(address As Short Ptr, numEls As Short) As Short
DECLARE FUNCTION MaxL(address As Long Ptr, numEls As Short) As Long
DECLARE FUNCTION MaxS(address As Single Ptr, numEls As Short) As Single
DECLARE FUNCTION MaxC(address As Double Ptr, numEls As Short) As Double
DECLARE FUNCTION MinD(address As Double Ptr, numEls As Short) As Double
DECLARE FUNCTION MinI(address As Short Ptr, numEls As Short) As Short
DECLARE FUNCTION MinL(address As Long Ptr, numEls As Short) As Long
DECLARE FUNCTION MinS(address As Single Ptr, numEls As Short) As Single
DECLARE FUNCTION MinC(address As Double Ptr, numEls As Short) As Double
DECLARE SUB Search OVERLOAD (address As Double Ptr, numEls As Short, match As Double, Byref found As Short, direction As Short, matchCode As Short, varType As Short = -4)
DECLARE SUB Search OVERLOAD (address As Short Ptr, numEls As Short, match As Short, Byref found As Short, direction As Short, matchCode As Short, varType As Short = -1)
DECLARE SUB Search OVERLOAD (address As Long Ptr, numEls As Short, match As Long, Byref found As Short, direction As Short, matchCode As Short, varType As Short = -2)
DECLARE SUB Search OVERLOAD (address As Single Ptr, numEls As Short, match As Single, Byref found As Short, direction As Short, matchCode As Short, varType As Short = -3)
DECLARE SUB SearchT OVERLOAD (address As Any Ptr, numEls As Short, match As String, Byref found As Short, direction As Short, code As Short, structSize As Short, memberOff As Short, memberSize As Short)
DECLARE SUB SearchT OVERLOAD (address As Any Ptr, numEls As Short, match As Double, Byref found As Short, direction As Short, code As Short, structSize As Short, memberOff As Short, memberSize As Short)
DECLARE SUB SearchT OVERLOAD (address As Any Ptr, numEls As Short, match As Short, Byref found As Short, direction As Short, code As Short, structSize As Short, memberOff As Short, memberSize As Short)
DECLARE SUB SearchT OVERLOAD (address As Any Ptr, numEls As Short, match As Long, Byref found As Short, direction As Short, code As Short, structSize As Short, memberOff As Short, memberSize As Short)
DECLARE SUB SearchT OVERLOAD (address As Any Ptr, numEls As Short, match As Single, Byref found As Short, direction As Short, code As Short, structSize As Short, memberOff As Short, memberSize As Short)
DECLARE SUB SearchT2 OVERLOAD (address As Any Ptr, numEls As Short, match As String, Byref found As Short, direction As Short, code As Short, structSize As Short, memberOff As Short, memberSize As Short)
DECLARE SUB SearchT2 OVERLOAD (address As Any Ptr, numEls As Short, match As Double, Byref found As Short, direction As Short, code As Short, structSize As Short, memberOff As Short, memberSize As Short)
DECLARE SUB SearchT2 OVERLOAD (address As Any Ptr, numEls As Short, match As Short, Byref found As Short, direction As Short, code As Short, structSize As Short, memberOff As Short, memberSize As Short)
DECLARE SUB SearchT2 OVERLOAD (address As Any Ptr, numEls As Short, match As Long, Byref found As Short, direction As Short, code As Short, structSize As Short, memberOff As Short, memberSize As Short)
DECLARE SUB SearchT2 OVERLOAD (address As Any Ptr, numEls As Short, match As Single, Byref found As Short, direction As Short, code As Short, structSize As Short, memberOff As Short, memberSize As Short)
DECLARE SUB SetBit(Byref array As String, element As Short, value As Short)
DECLARE SUB SortD(address As Double Ptr, numEls As Short, direction As Short)
DECLARE SUB SortI(address As Short Ptr, numEls As Short, direction As Short)
DECLARE SUB SortL(address As Long Ptr, numEls As Short, direction As Short)
DECLARE SUB SortS(address As Single Ptr, numEls As Short, direction As Short)
DECLARE SUB SortC(address As Double Ptr, numEls As Short, direction As Short)
DECLARE SUB SortStr(address As String Ptr, numEls As Short, direction As Short)
DECLARE SUB SortStr2(address As String Ptr, numEls As Short, direction As Short)
DECLARE SUB SortT(address As Any Ptr, numEls As Short, direction As Short, elSize As Short, memberOffset As Short, memberSize As Short)
DECLARE SUB SortT2(address As Any Ptr, numEls As Short, direction As Short, elSize As Short, memberOffset As Short, memberSize As Short)

' ****************************************
' Chapter 3 - DOS Services
' ****************************************

DECLARE SUB CDir(newDir As String)
DECLARE SUB ClipFile(fileName As String, newLength As Long)
DECLARE FUNCTION DCount(dirSpec As String) As Short
DECLARE SUB DiskInfo(drive As String, Byref bytes As Short, Byref sectors As Short, Byref freeClusters As ULong, Byref totalClusters As ULong)
DECLARE FUNCTION DiskRoom(drive As String) As ULong
DECLARE FUNCTION DiskSize(drive As String) As ULong
DECLARE FUNCTION DosError AS Short
DECLARE FUNCTION DOSVer As Short
DECLARE FUNCTION ErrorMsg(errorNumber As Short) As String
DECLARE FUNCTION ExeName As String
DECLARE FUNCTION Exist(fileName As String) AS Short
DECLARE SUB FClose(handle As Short)
DECLARE SUB FCopy(source As String, dest As String, buffer AS String, Byref errCode AS Short)
DECLARE FUNCTION FCount(fileSpec As String) AS Short
DECLARE SUB FCreate(fileName As String)
DECLARE FUNCTION FEof(handle As Short) As Short
DECLARE SUB FFlush(handle As Short)
DECLARE SUB FGet(handle As Short, Byref destination As String)
DECLARE SUB FGetA(handle As Short, array As Any Ptr, numBytes As Short)
DECLARE SUB FGetAH(fileName As String, array As Any Ptr, elSize As Short, numEls As Short)
DECLARE SUB FGetR(handle As Short, Byref destination As String, recNumber As Long)
DECLARE SUB FGetRT(handle As Short, destination As Any Ptr, recNumber As Long, recSize As Short)
DECLARE SUB FGetRTA(handle As Short, destination As Any Ptr, recNumber As Long, recSize As Short)
DECLARE SUB FGetT(handle As Short, destination As Any Ptr, numBytes As Short)
DECLARE FUNCTION FileComp(file1 As String, file2 As String, Byref errCode As Short) As Short
DECLARE SUB FileInfo(fileName As String, Byref tVar As FInfo)
DECLARE FUNCTION FileSize(fileName As String) As Long
DECLARE FUNCTION FLInput(handle As Short, buffer As String) As String
DECLARE FUNCTION FLoc(handle As Short) As Long
DECLARE FUNCTION FLof(handle As Short) As Long
DECLARE SUB FOpen(fileName As String, Byref handle As Short)
DECLARE SUB FOpenS(fileName As String, Byref handle As Short)
DECLARE SUB FOpenAll(fileName As String, accessMode As Short, shareMode As Short, handle As Short)
DECLARE FUNCTION FormatDiskette(driveNumber As Short, capacity As Short, bufArray As Short Ptr) As Short
DECLARE SUB FPut(handle As Short, source As String)
DECLARE SUB FPutA(handle As Short, array As Any Ptr, numBytes As Short)
DECLARE SUB FPutAH(fileName As String, array As Any Ptr, elSize As Short, numEls As Short)
DECLARE SUB FPutR(handle As Short, source As String, recNumber As Long)
DECLARE SUB FPutRT(handle As Short, source As Any Ptr, recNumber As Long, recSize As Short)
DECLARE SUB FPutRTA(handle As Short, source As Any Ptr, recNumber As Long, recSize As Short)
DECLARE SUB FPutT(handle As Short, source As Any Ptr, numBytes As Short)
DECLARE SUB FSeek(handle As Short, location As Long)
DECLARE SUB FStamp(fileName As String, newTime As String, newDate As String)
DECLARE FUNCTION FullName(partName As String) As String
DECLARE FUNCTION GetAttr(fileName As String) As Short
DECLARE FUNCTION GetDir(drive As String) As String
DECLARE FUNCTION GetDisketteType(driveNumber As Short) As Short
DECLARE FUNCTION GetDrive() As Short
DECLARE FUNCTION GetVol(drive As String) As String
DECLARE FUNCTION GoodDrive(drive As String) As Short
DECLARE SUB Handle2Name(handle As String, Byref fileName AS Any Ptr)
DECLARE SUB KillDir(dirName As String)
DECLARE SUB KillFile(fileName As String)
DECLARE FUNCTION LastDrive As Short
DECLARE FUNCTION LineCount(fileName As String, buffer As String) As Short
DECLARE FUNCTION LoadExec(program As String, cmdLine As String) As Short
DECLARE SUB LockFile(handle As Short, offset As Long, length As Long)
DECLARE SUB MakeDir(dirName As String)
DECLARE SUB NameDir(oldName As String, newName As String)
DECLARE SUB NameFile(oldName As String, newName As String)
DECLARE FUNCTION NetDrive(drive As String) As Short
DECLARE SUB PutVol(drive As String, label As String)
DECLARE SUB QBLoad(fileName As String, array As Short Ptr)
DECLARE SUB QBSave(fileName As String, array As Short Ptr, numBytes As Short)
DECLARE SUB ReadDir(array AS String Ptr)
DECLARE SUB ReadDirT(spec As String, array As String Ptr)
DECLARE SUB ReadFile(array As String Ptr)
DECLARE SUB ReadFileI(array As String Ptr)
DECLARE SUB ReadFileT(spec As String, array As Any Ptr)
DECLARE SUB ReadFileX(spec As String, Byref dirSize As Long, array As Any Ptr)
DECLARE SUB ReadSect(drive As String, Byref info As String, sector As Short)
DECLARE FUNCTION ReadTest(drive As String) As Short
DECLARE FUNCTION Removable(drive As String) As Short
DECLARE SUB SetAttr(fileName As String, attribute As Short)
DECLARE SUB SetCmd(newCommand As String)
DECLARE SUB SetDrive(drive As String)
DECLARE SUB SetError(errNum As Short)
DECLARE SUB SetLevel(errValue As Short)
DECLARE FUNCTION ShareThere As Short
DECLARE SUB SplitName (workName As String, Byref drive As String, Byref path As String, Byref fileName As String, Byref ext As String) REM STATIC
DECLARE SUB UnLockFile(handle As Short, offset As Long, length As Long)
DECLARE FUNCTION Valid(fileName As String) As Short
DECLARE FUNCTION WhichError As Short
DECLARE SUB WriteSect(drive As String, Byref info As String, sector As Short)
DECLARE SUB WriteSect2(drive As String, Byref info As String, sector As Short)
DECLARE FUNCTION WriteTest(drive As String) As Short

' ****************************************
' Chapter 4 - Functions
' ****************************************

DECLARE FUNCTION Bin2Num(binary As String) As Short
DECLARE FUNCTION Num2Bin(number As Short) As String
DECLARE FUNCTION Num2Bin2(number As Short) As String
DECLARE FUNCTION QPHex OVERLOAD (value As Short, digits As Short) As String
DECLARE FUNCTION QPHex OVERLOAD (value As Long, digits As Short) As String
DECLARE FUNCTION QPHex OVERLOAD (value As UByte, digits As Short) As String
DECLARE FUNCTION QPHex OVERLOAD (value As UShort, digits As Short) As String
DECLARE FUNCTION QPHex OVERLOAD (value As ULong, digits As Short) As String
DECLARE FUNCTION QPHex OVERLOAD (value As ULongInt, digits As Short) As String
DECLARE FUNCTION QPHex OVERLOAD (value As Const Any Ptr, digits As Short) As String

' ****************************************
' Chapter 5 - Menu/Input Routines
' ****************************************

DECLARE SUB AMenu (address As String Ptr, startItem As Short, Byref count As Short, Byref scanCode As Short, normColor As Short, hiLiteColor As Short, numRows As Short, numCols As Short, gap As Short, ulRow As Short, ulCol As Short)
DECLARE SUB AMenuT(array As Any Ptr, item As Short, length As Short, Byref count As Short, Byref scanCode As Short, normColor As Short, hiLiteColor As Short, numRows As Short, numCols As Short, gap As Short, ulRow As Short, ulCol As Short)
DECLARE SUB ASCIIPick(Byref char As Short, color1 As Short, color2 As Short, Byref exitCode As Short)
DECLARE SUB MASCIIPick(Byref char As Short, color1 As Short, color2 As Short, Byref exitCode As Short)
DECLARE SUB Editor(Byref ed As String, Byref activeLength As Short, Byref scanCode As Short, numOnly As Short, isCapsOn As Short, normalColor As Short, editColor As Short, row As Short, column As Short)
DECLARE FUNCTION MGetKey(Byref row As Short, Byref col As Short) As Short

' ****************************************
' Chapter 6 - Keyboard/Mouse Routines
' ****************************************

DECLARE FUNCTION AltKey As Short
DECLARE FUNCTION CapsLock As Short
DECLARE SUB ClearBuf
DECLARE FUNCTION CtrlKey As Short
DECLARE SUB InitMouse(Byref there As Short)
DECLARE FUNCTION NumLock As Short
DECLARE SUB NumOff
DECLARE SUB NumOn
DECLARE FUNCTION ScrlLock As Short
DECLARE FUNCTION ShiftKey As Short
DECLARE SUB ShowCursor
DECLARE SUB TextCursor(fg As Short, bg As Short)
DECLARE FUNCTION WaitKey AS SHORT

' ****************************************
' Chapter 7 - Miscellaneous Routines
' ****************************************

DECLARE SUB BCopyT(fromEl As Any Ptr, toEl As Any Ptr, elSize As Short, numEls As Short) 
DECLARE SUB Chime(number As Short)
DECLARE FUNCTION Date2Num (dat As String) As Short
DECLARE FUNCTION DayName(d As Short) As String
DECLARE SUB Empty(dummy As Short)
DECLARE FUNCTION Factorial(number As Short) As Double
DECLARE FUNCTION FudgeFactor As Long
DECLARE FUNCTION GetCPU As Short
DECLARE SUB GetEquip(Byref floppies As Short, Byref parallels As Short, Byref serials As Short)
DECLARE SUB LockUp
DECLARE FUNCTION MathChip As Short
DECLARE FUNCTION MaxInt (num1 As Short, num2 As Short) As Short
DECLARE FUNCTION MaxLong (Num1 As Long, Num2 As Long) As Long
DECLARE FUNCTION MinInt (num1 As Short, num2 As Short) As Short
DECLARE FUNCTION MinLong (num1 As Long, num2 As Long) As Long
DECLARE SUB Pause(ticks AS SHORT)
DECLARE FUNCTION Peek1(segment As Short, address As Short) As Short
DECLARE FUNCTION PRNReady(lptNumber As Short) As Short

' ****************************************
' Chapter 8 - String Manipulation Routines
' ****************************************

DECLARE FUNCTION ASCII (ch As String) AS Short
DECLARE FUNCTION FUsing(number As String, image As String) As String
DECLARE FUNCTION InCount(source As String, searchValue As String) As Short
DECLARE FUNCTION QInstr(startPosition As Short, sourceValue As String, searchValue As String) As Short
DECLARE FUNCTION QInstr2(startPosition As Short, sourceValue As String, searchValue As String) As Short
DECLARE FUNCTION QPLeft(text As String, numChars As Short) As String
DECLARE FUNCTION QPMid(text As String, startChar As Short, numChars As Short) As String
DECLARE FUNCTION QPRight(text As String, numChars As Short) As String
DECLARE FUNCTION QPLen(text As String) As Short
DECLARE FUNCTION QPStrI(value As Short) As String
DECLARE FUNCTION QPStrL(value As Long) As String
DECLARE FUNCTION QPTrim(value As String) As String
DECLARE FUNCTION QPLTrim(value As String) As String
DECLARE FUNCTION QPRTrim(value As String) As String
DECLARE FUNCTION QPValI (value As String) As Short
DECLARE SUB ReplaceString (Byref sourceValue As String, oldValue As String, newValue As String)
DECLARE SUB ReplaceString2 (Byref sourceValue As String, oldValue As String, newValue As String)

' ****************************************
' Chapter 9 - Video Routines
' ****************************************

DECLARE SUB APrint(array As String Ptr, numEls As Short, firstChar As Short, numChars As Short, colr As Short, page As Short)
DECLARE SUB APrint0(array As String Ptr, numEls As Short, firstChar As Short, numChars As Short, colr As Short)
DECLARE SUB APrintT(array AS Any Ptr, elSize As Short, numEls As Short, firstChar As Short, numChars As Short, colr As Short, page As Short)
DECLARE SUB APrintT0(array AS Any Ptr, elSize As Short, numEls As Short, firstChar As Short, numChars As Short, colr As Short)
DECLARE FUNCTION ArraySize(ulRow As Short, ulCol As Short, lrRow As Short, lrCol As Short) As Short
DECLARE SUB Box(ulRow As Short, ulCol As Short, lrRow As Short, lrCol As Short, char As Short, colr As Short, page As Short)
DECLARE SUB Box0(ulRow As Short, ulCol As Short, lrRow As Short, lrCol As Short, char As Short, colr As Short)
DECLARE SUB BPrint(text As String)
DECLARE SUB ClearEOL(clr As Short)
DECLARE SUB ClearScr (ulRow As Short, ulCol As Short, lrRow As Short, lrCol As Short, colr As Short, page As Short)
DECLARE SUB ClearScr0 (ulRow As Short, ulCol As Short, lrRow As Short, lrCol As Short, colr As Short)
DECLARE SUB FillScrn(ulRow As Short, ulCol As Short, lrRow As Short, lrCol As Short, colr As Short, char As Short, page As Short)
DECLARE SUB FillScrn0(ulRow As Short, ulCol As Short, lrRow As Short, lrCol As Short, colr As Short, char As Short)
DECLARE SUB GetVMode (Byref mode As Short, Byref page As Short, Byref pageSize As Short, Byref rows As Short, Byref columns As Short)
DECLARE FUNCTION Monitor As Short
DECLARE FUNCTION EGAMem As Short
DECLARE SUB MPaintBox (ulRow As Short, ulCol As Short, lrRow As Short, lrCol As Short, colr As Short)
DECLARE SUB MQPrint (txt As String, colr As Short)
DECLARE SUB MScrnRest (ulRow As Short, ulCol As Short, lrRow As Short, lrCol As Short, scrn As Short Ptr)
DECLARE SUB MScrnSave (ulRow As Short, ulCol As Short, lrRow As Short, lrCol As Short, scrn As Short Ptr)
DECLARE FUNCTION OneColor (fg As Short, bg As Short) As Short
DECLARE SUB PaintBox (ulRow As Short, ulCol As Short, lrRow As Short, lrCol As Short, colr As Short, page As Short)
DECLARE SUB PaintBox0 (ulRow As Short, ulCol As Short, lrRow As Short, lrCol As Short, colr As Short)
DECLARE SUB PUsing (number As String, image As String, color1 As Short, color2 As Short, page As Short, row As Short, column As Short)
DECLARE SUB QPrint (text As String, colr As Short, page As Short)
DECLARE SUB QPrint0 (text As String, colr As Short)
DECLARE SUB QPrintAny (txt As String, clr As Short, monCode As Short, row As Short, column As Short)
DECLARE SUB QPrintRC (txt As String, r As Short, c As Short, clr As Short)
DECLARE SUB ReadScrn (row As Short, column As Short, x As String, page As Short)
DECLARE SUB ReadScrn0 (row As Short, column As Short, x As String)
DECLARE SUB ScrnRest (ulRow As Short, ulCol As Short, lrRow As Short, lrCol As Short, scrn As Short Ptr, page As Short)
DECLARE SUB ScrnRest0 (ulRow As Short, ulCol As Short, lrRow As Short, lrCol As Short, scrn As Short Ptr)
DECLARE SUB ScrnSave (ulRow As Short, ulCol As Short, lrRow As Short, lrCol As Short, scrn As Short Ptr, page As Short)
DECLARE SUB ScrnSave0 (ulRow As Short, ulCol As Short, lrRow As Short, lrCol As Short, scrn AS Short Ptr)
DECLARE SUB ScrollD(ulRow As Short, ulCol As Short, lrRow As Short, lrCol As Short, lines As Short, page As Short)
DECLARE SUB ScrollL(ulRow As Short, ulCol As Short, lrRow As Short, lrCol As Short, columns As Short, page As Short)
DECLARE SUB ScrollR(ulRow As Short, ulCol As Short, lrRow As Short, lrCol As Short, columns As Short, page As Short)
DECLARE SUB ScrollU(ulRow As Short, ulCol As Short, lrRow As Short, lrCol As Short, lines As Short, page As Short)
DECLARE SUB SplitColor (colr As Short, Byref fg As Short, Byref bg As Short)

' ****************************************
' Chapter Next
' ****************************************

DECLARE FUNCTION BitShift (value As Short, cmd As String, bits As Short) As Short
REM DECLARE FUNCTION FRE OVERLOAD (value As String) As Short
DECLARE FUNCTION IsWindows() AS Short

' ****************************************

' CONST BAR_LINE = 1                        ' Line number for the menu bar

'                                           ' Alt Key translation table
' CONST ALT_CHARS$ = "1234567890     QWERTYUIOP    ASDFGHJKL     ZXCVBNM"

' TYPE Area                                 ' Type definition for MouseRange
'   Y1 As Short
'   X1 As Short
'   Y2 As Short
'   X2 As Short
'   RN As Short
' END TYPE

' ' TYPE FLen                                 ' "Hard-coded" TYPE for xxxxT methods.
' '   S AS STRING * 30
' ' END TYPE

' TYPE FInfo
'   Year   As Short
'   Month  As Short
'   Day    As Short
'   Hour   As Short
'   Minute As Short
'   Second As Short
'   Size   AS LONG
'   Attrib As Short
' END TYPE

' TYPE FullInfo 
'   BaseName AS STRING * 8 
'   ExtName AS STRING * 3 
'   FileSize AS LONG 
'   FileDate AS STRING * 8 
'   FileTime AS STRING * 6 
'   Attrib AS STRING * 1 
' END TYPE 

' TYPE NameType 
'   FileName AS STRING* 8 
'   Extension AS STRING* 3 
' END TYPE 

' TYPE FVInfo 
'   Colr As Short
'   ULRow As Short 
'   ULCol As Short 
'   LRRow As Short 
'   LRCol As Short 
'   HorizOffset As Short 
'   LoPtr As Short 
'   FileHandle As Short 
'   EndOfFile As Short 
'   LineNumber AS LONG 
'   TabStop As Short 
'   FileSeek AS LONG 
'   FileOffset AS LONG 
' END TYPE 

' DIM SHARED KeyboardMethodTimerId As Short
' DIM SHARED KeyboardMethodRow As Short
' DIM SHARED KeyboardMethodCol As Short
' DIM SHARED KeyboardMethodColor1 As Short
' DIM SHARED KeyboardMethodColor2 As Short

' DIM SHARED ClockMethodTimerId As Short
' DIM SHARED ClockMethodRow As Short
' DIM SHARED ClockMethodCol As Short
' DIM SHARED ClockMethodColr As Short
' DIM SHARED ClockMethod24 As Short

' DIM SHARED Pro_Internal_DosError As Short
' DIM SHARED Pro_Internal_WhichError As Short

' ' ********************************************************
' ' * Win32
' ' ********************************************************

' Const GENERIC_READ = -&H80000000
' Const GENERIC_WRITE = &H40000000
' Const FILE_SHARE_READ = &H1
' Const FILE_SHARE_WRITE = &H2
' Const OPEN_EXISTING = &H3
' Const INVALID_HANDLE_VALUE = -1

' CONST MAX_PATH = 260
' CONST INVALID_HANDLE_VALUE = -1
' CONST FILE_ATTRIBUTE_HIDDEN = &H2
' CONST FILE_ATTRIBUTE_DIRECTORY = &H10
' CONST FILE_ATTRIBUTE_ARCHIVE = &H20
' CONST FILE_ATTRIBUTE_DEVICE = &H40
' CONST FILE_ATTRIBUTE_NORMAL = &H80
' CONST FILE_ATTRIBUTE_COMPRESSED = &H800
' CONST FILE_ATTRIBUTE_ENCRYPTED = &H4000
' CONST DRIVE_REMOVABLE = 2
' CONST DRIVE_FIXED = 3
' CONST DRIVE_REMOTE = 4
' CONST DRIVE_CDROM = 5
' CONST DRIVE_RAMDISK = 6

' ' https://learn.microsoft.com/en-us/windows/win32/debug/system-error-codes--0-499-
' CONST ERROR_FILE_NOT_FOUND = &H2
' CONST ERROR_PATH_NOT_FOUND = &H3
' CONST ERROR_ACCESS_DENIED = &H5

' Type FILETIME
'   dwLowDateTime As _Unsigned Long
'   dwHighDateTime As _Unsigned Long
' End Type

' Type SYSTEMTIME
'   wYear As _Unsigned Integer
'   wMonth As _Unsigned Integer
'   wDayOfWeek As _Unsigned Integer
'   wDay As _Unsigned Integer
'   wHour As _Unsigned Integer
'   wMinute As _Unsigned Integer
'   wSecond As _Unsigned Integer
'   wMilliseconds As _Unsigned Integer
' End Type

' TYPE Win32_Find_Data
'   dwfileattributes AS _UNSIGNED LONG
'   ftcreationtime AS FileTime
'   ftlastaccesstime AS FileTime
'   ftlastwritetime AS FileTime
'   nfilesizehigh AS _UNSIGNED LONG
'   nfilesizelow AS _UNSIGNED LONG
'   dwreserved0 AS _UNSIGNED LONG
'   dwreserved1 AS _UNSIGNED LONG
'   cfilename AS STRING * MAX_PATH
'   calternatefilename AS STRING * 14
' END TYPE

' TYPE Rectangle
'   left AS LONG
'   top AS LONG
'   right AS LONG
'   bottom AS LONG
' END TYPE

' $IF WIN THEN
'   DECLARE LIBRARY
'     FUNCTION __DEBUG& ALIAS MessageBox (BYVAL ignore&, message$, title$, BYVAL type&)
'   END DECLARE
' $ELSE
'   DECLARE LIBRARY ""
'     FUNCTION __DEBUG& ALIAS MessageBox (BYVAL ignore&, message$, title$, BYVAL type&)
'   END DECLARE
' $END IF

' DECLARE DYNAMIC LIBRARY "kernel32"
'   FUNCTION CreateFileA%& (BYVAL lpFileName AS _OFFSET, BYVAL dwDesiredAccess AS _UNSIGNED LONG, _
'                           BYVAL dwShareMode AS _UNSIGNED LONG, BYVAL lpSecurityAttributes AS _OFFSET, _
'                           BYVAL dwCreationDisposition AS _UNSIGNED LONG, BYVAL dwFlagsAndAttributes AS _UNSIGNED LONG, _
'                           BYVAL hTemplateFile AS _OFFSET)
'   Function CloseHandle& (ByVal hObject As _Offset)
'   Function GetFileTime& (ByVal hFile As _Offset, Byval lpCreationTime As _Offset, Byval lpLastAccessTime As _Offset, Byval lpLastWriteTime As _Offset)
'   Function SetFileTime& (ByVal hFile As _Offset, Byval lpCreationTime As _Offset, Byval lpLastAccessTime As _Offset, Byval lpLastWriteTime As _Offset)
'   Function FileTimeToLocalFileTime& (ByVal lpFileTime As _Offset, Byval lpLocalFileTime As _Offset)
'   Function LocalFileTimeToFileTime& (ByVal lpLocalFileTime As _Offset, Byval lpFileTime As _Offset)
'   Function FileTimeToSystemTime& (ByVal lpFileTime As _Offset, Byval lpSystemTime As _Offset)
'   Function SystemTimeToFileTime& (ByVal lpSystemTime As _Offset, Byval lpFileTime As _Offset)
'   FUNCTION GetFileSizeEx& (BYVAL hFile AS _Offset, lpFileSize AS _Offset)
'   FUNCTION GetDiskFreeSpace& ALIAS GetDiskFreeSpaceA (BYVAL lprootpathname AS _OFFSET, BYVAL lpSectorsPerCluster AS _OFFSET, BYVAL lpBytesPerSector AS _OFFSET, BYVAL lpNumberOfFreeClusters AS _OFFSET, BYVAL lpTotalNumberOfClusters AS _OFFSET)
'   FUNCTION FindFirstFile~%& ALIAS FindFirstFileA (BYVAL lpfilename AS _OFFSET, BYVAL lpfindfiledata AS _OFFSET)
'   FUNCTION FindNextFile& ALIAS FindNextFileA (BYVAL hfind AS _UNSIGNED _OFFSET, BYVAL lpfindfiledata AS _OFFSET)
'   FUNCTION FindClose& (BYVAL hfind AS _UNSIGNED _OFFSET)
'   FUNCTION GetLastError& ()
'   FUNCTION GetLogicalDrives& ()

'   FUNCTION GetShortPathNameA& (lpszLongPath AS STRING, lpszShortPath AS STRING, BYVAL cchBuffer AS LONG)
'   FUNCTION GetLongPathNameA& (lpszLongPath AS STRING, lpszShortPath AS STRING, BYVAL cchBuffer AS LONG)

'   'FUNCTION GetLogicalDriveStrings& (BYVAL nBufferLength AS LONG, lpBuffer AS STRING) ' untested

'   ' NOTES:
'   '   DWORD as a result translate to LONG (&)
'   '   DWORD as a param translate to LONG (&)
'   '   [out] LPWSTR lpBuffer param translate to lpBuffer AS STRING
'   '   [in]  LPCWSTR lpszLongPath param translate to BYVAL lpszLongPath AS STRING

' END DECLARE

' DECLARE LIBRARY
'   FUNCTION GetFileAttributes& (f$)
'   FUNCTION SetFileAttributes& (f$, Byval attrib&)
'   FUNCTION GetDriveTypeA& (nDrive AS STRING)
'   FUNCTION GetLogicalDriveStringsA (BYVAL nBuff AS LONG, lpbuff AS STRING)
' END DECLARE

' DECLARE DYNAMIC LIBRARY "user32"
'   FUNCTION SetWindowPos& (ByVal hwnd As Long, Byval hWndInsertAfter As Long, Byval x As Long, Byval y As Long, Byval cx As Long, Byval cy As Long, Byval wFlags As Long)
'   FUNCTION MoveWindow& (Byval hwnd AS LONG, Byval x AS LONG, Byval y AS LONG, byval nWidth AS LONG, Byval nHeight AS LONG, byval bRepaint AS LONG)
'   FUNCTION ClipCursor%% (Rect AS Rectangle) 'sets mouse box work area on desktop
'   SUB SetCursorPos (BYVAL x AS LONG, BYVAL y AS LONG) 'move cursor position
' END DECLARE
