' ****************************************
' Chapter 2 - Array Routines 
' ****************************************

DECLARE SUB AddInt(address As Short Ptr, value As Short, numEls As Short)
DECLARE SUB DeleteStr(address As String Ptr, numEls As Short)
DECLARE SUB DeleteT(address As Any Ptr, elSize As Short, numEls As Short)
DECLARE SUB Fill2(address As Short Ptr, value As Short, numEls As Short)
DECLARE SUB Fill4(address As Long Ptr, value As Long, numEls As Short)
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

' ****************************************

DECLARE SUB SetBit(Byref array As String, element As Short, value As Short)

DECLARE SUB QPrint (text As String, colr As Short, page As Short)
'DECLARE FUNCTION QBColor (colr As Short) As ULong
DECLARE SUB QPrint0 (text As String, colr As Short)
DECLARE SUB QPrintRC (txt As String, r As Short, c As Short, clr As Short)
DECLARE SUB SplitColor (colr As Short, Byref fg As Short, Byref bg As Short)
DECLARE FUNCTION OneColor (fg As Short, bg As Short) As Short

DECLARE SUB ReplaceString (Byref sourceValue As String, oldValue As String, newValue As String)
DECLARE SUB ReplaceString2 (Byref sourceValue As String, oldValue As String, newValue As String)
DECLARE FUNCTION QInstr(startPosition As Short, sourceValue As String, searchValue As String) As Short
DECLARE FUNCTION QInstr2(startPosition As Short, sourceValue As String, searchValue As String) As Short

DECLARE SUB AMenu (address As String Ptr, start As Short, count As Short, scanCode As Short, fileColr As Short, hiLiteColr As Short, rows As Short, columns As Short, spacing As Short, row As Short, column As Short)

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
