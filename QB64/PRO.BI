CONST BAR_LINE = 1                        ' Line number for the menu bar

                                          ' Alt Key translation table
CONST ALT_CHARS$ = "1234567890     QWERTYUIOP    ASDFGHJKL     ZXCVBNM"

TYPE Area                                 ' Type definition for MouseRange
  Y1 AS INTEGER
  X1 AS INTEGER
  Y2 AS INTEGER
  X2 AS INTEGER
  RN AS INTEGER
END TYPE

TYPE FLen                                 ' "Hard-coded" TYPE for xxxxT methods.
  S AS STRING * 30
END TYPE

TYPE FInfo
  Year   AS INTEGER
  Month  AS INTEGER
  Day    AS INTEGER
  Hour   AS INTEGER
  Minute AS INTEGER
  Second AS INTEGER
  Size   AS LONG
  Attrib AS INTEGER
END TYPE

TYPE FullInfo 
  BaseName AS STRING * 8 
  ExtName AS STRING * 3 
  FileSize AS LONG 
  FileDate AS STRING * 8 
  FileTime AS STRING * 6 
  Attrib AS STRING * 1 
END TYPE 

TYPE NameType 
  FileName AS STRING* 8 
  Extension AS STRING* 3 
END TYPE 

TYPE FVInfo 
  Colr AS INTEGER
  ULRow AS INTEGER 
  ULCol AS INTEGER 
  LRRow AS INTEGER 
  LRCol AS INTEGER 
  HorizOffset AS INTEGER 
  LoPtr AS INTEGER 
  FileHandle AS INTEGER 
  EndOfFile AS INTEGER 
  LineNumber AS LONG 
  TabStop AS INTEGER 
  FileSeek AS LONG 
  FileOffset AS LONG 
END TYPE 

DIM SHARED KeyboardMethodTimerId AS INTEGER
DIM SHARED KeyboardMethodRow AS INTEGER
DIM SHARED KeyboardMethodCol AS INTEGER
DIM SHARED KeyboardMethodColor1 AS INTEGER
DIM SHARED KeyboardMethodColor2 AS INTEGER

DIM SHARED ClockMethodTimerId AS INTEGER
DIM SHARED ClockMethodRow AS INTEGER
DIM SHARED ClockMethodCol AS INTEGER
DIM SHARED ClockMethodColr AS INTEGER
DIM SHARED ClockMethod24 AS INTEGER

DIM SHARED Pro_Internal_DosError AS INTEGER
DIM SHARED Pro_Internal_WhichError AS INTEGER

' ********************************************************
' * Win32
' ********************************************************

Const GENERIC_READ = -&H80000000
Const GENERIC_WRITE = &H40000000
Const FILE_SHARE_READ = &H1
Const FILE_SHARE_WRITE = &H2
Const OPEN_EXISTING = &H3
Const INVALID_HANDLE_VALUE = -1

CONST MAX_PATH = 260
CONST INVALID_HANDLE_VALUE = -1
CONST FILE_ATTRIBUTE_HIDDEN = &H2
CONST FILE_ATTRIBUTE_DIRECTORY = &H10
CONST FILE_ATTRIBUTE_ARCHIVE = &H20
CONST FILE_ATTRIBUTE_DEVICE = &H40
CONST FILE_ATTRIBUTE_NORMAL = &H80
CONST FILE_ATTRIBUTE_COMPRESSED = &H800
CONST FILE_ATTRIBUTE_ENCRYPTED = &H4000
CONST DRIVE_REMOVABLE = 2
CONST DRIVE_FIXED = 3
CONST DRIVE_REMOTE = 4
CONST DRIVE_CDROM = 5
CONST DRIVE_RAMDISK = 6

' https://learn.microsoft.com/en-us/windows/win32/debug/system-error-codes--0-499-
CONST ERROR_FILE_NOT_FOUND = &H2
CONST ERROR_PATH_NOT_FOUND = &H3
CONST ERROR_ACCESS_DENIED = &H5

Type FILETIME
  dwLowDateTime As _Unsigned Long
  dwHighDateTime As _Unsigned Long
End Type

Type SYSTEMTIME
  wYear As _Unsigned Integer
  wMonth As _Unsigned Integer
  wDayOfWeek As _Unsigned Integer
  wDay As _Unsigned Integer
  wHour As _Unsigned Integer
  wMinute As _Unsigned Integer
  wSecond As _Unsigned Integer
  wMilliseconds As _Unsigned Integer
End Type

TYPE Win32_Find_Data
  dwfileattributes AS _UNSIGNED LONG
  ftcreationtime AS FileTime
  ftlastaccesstime AS FileTime
  ftlastwritetime AS FileTime
  nfilesizehigh AS _UNSIGNED LONG
  nfilesizelow AS _UNSIGNED LONG
  dwreserved0 AS _UNSIGNED LONG
  dwreserved1 AS _UNSIGNED LONG
  cfilename AS STRING * MAX_PATH
  calternatefilename AS STRING * 14
END TYPE

TYPE Rectangle
  left AS LONG
  top AS LONG
  right AS LONG
  bottom AS LONG
END TYPE

DECLARE DYNAMIC LIBRARY "kernel32"
  FUNCTION CreateFileA%& (BYVAL lpFileName AS _OFFSET, BYVAL dwDesiredAccess AS _UNSIGNED LONG, _
                          BYVAL dwShareMode AS _UNSIGNED LONG, BYVAL lpSecurityAttributes AS _OFFSET, _
                          BYVAL dwCreationDisposition AS _UNSIGNED LONG, BYVAL dwFlagsAndAttributes AS _UNSIGNED LONG, _
                          BYVAL hTemplateFile AS _OFFSET)
  Function CloseHandle& (ByVal hObject As _Offset)
  Function GetFileTime& (ByVal hFile As _Offset, Byval lpCreationTime As _Offset, Byval lpLastAccessTime As _Offset, Byval lpLastWriteTime As _Offset)
  Function SetFileTime& (ByVal hFile As _Offset, Byval lpCreationTime As _Offset, Byval lpLastAccessTime As _Offset, Byval lpLastWriteTime As _Offset)
  Function FileTimeToLocalFileTime& (ByVal lpFileTime As _Offset, Byval lpLocalFileTime As _Offset)
  Function LocalFileTimeToFileTime& (ByVal lpLocalFileTime As _Offset, Byval lpFileTime As _Offset)
  Function FileTimeToSystemTime& (ByVal lpFileTime As _Offset, Byval lpSystemTime As _Offset)
  Function SystemTimeToFileTime& (ByVal lpSystemTime As _Offset, Byval lpFileTime As _Offset)
  FUNCTION GetFileSizeEx& (BYVAL hFile AS _Offset, lpFileSize AS _Offset)
  FUNCTION GetDiskFreeSpace& ALIAS GetDiskFreeSpaceA (BYVAL lprootpathname AS _OFFSET, BYVAL lpSectorsPerCluster AS _OFFSET, BYVAL lpBytesPerSector AS _OFFSET, BYVAL lpNumberOfFreeClusters AS _OFFSET, BYVAL lpTotalNumberOfClusters AS _OFFSET)
  FUNCTION FindFirstFile~%& ALIAS FindFirstFileA (BYVAL lpfilename AS _OFFSET, BYVAL lpfindfiledata AS _OFFSET)
  FUNCTION FindNextFile& ALIAS FindNextFileA (BYVAL hfind AS _UNSIGNED _OFFSET, BYVAL lpfindfiledata AS _OFFSET)
  FUNCTION FindClose& (BYVAL hfind AS _UNSIGNED _OFFSET)
  FUNCTION GetLastError& ()
  FUNCTION GetLogicalDrives& ()

  FUNCTION GetShortPathNameW& (lpszLongPath AS STRING, lpszShortPath AS STRING, BYVAL cchBuffer AS LONG)

  'FUNCTION GetLogicalDriveStrings& (BYVAL nBufferLength AS LONG, lpBuffer AS STRING) ' untested

  ' NOTES:
  '   DWORD as a result translate to LONG (&)
  '   DWORD as a param translate to LONG (&)
  '   [out] LPWSTR lpBuffer param translate to lpBuffer AS STRING
  '   [in]  LPCWSTR lpszLongPath param translate to BYVAL lpszLongPath AS STRING

END DECLARE

DECLARE LIBRARY
  FUNCTION GetFileAttributes& (f$)
  FUNCTION SetFileAttributes& (f$, Byval attrib&)
  FUNCTION GetDriveTypeA& (nDrive AS STRING)
  FUNCTION GetLogicalDriveStringsA (BYVAL nBuff AS LONG, lpbuff AS STRING)
END DECLARE

DECLARE DYNAMIC LIBRARY "user32"
  FUNCTION SetWindowPos& (ByVal hwnd As Long, Byval hWndInsertAfter As Long, Byval x As Long, Byval y As Long, Byval cx As Long, Byval cy As Long, Byval wFlags As Long)
  FUNCTION MoveWindow& (Byval hwnd AS LONG, Byval x AS LONG, Byval y AS LONG, byval nWidth AS LONG, Byval nHeight AS LONG, byval bRepaint AS LONG)
  FUNCTION ClipCursor%% (Rect AS Rectangle) 'sets mouse box work area on desktop
  SUB SetCursorPos (BYVAL x AS LONG, BYVAL y AS LONG) 'move cursor position
END DECLARE
