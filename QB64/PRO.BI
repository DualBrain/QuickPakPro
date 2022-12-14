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
  Year1   AS INTEGER
  Month1  AS INTEGER
  Day1    AS INTEGER
  Hour1   AS INTEGER
  Minute1 AS INTEGER
  Second1 AS INTEGER
  Size1   AS LONG
  Attrib1 AS INTEGER
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

' ********************************************************
' * Win32
' ********************************************************

CONST MAX_PATH = 260
CONST INVALID_HANDLE_VALUE = -1
CONST FILE_ATTRIBUTE_HIDDEN = &H2
CONST FILE_ATTRIBUTE_DIRECTORY = &H10
CONST FILE_ATTRIBUTE_ARCHIVE = &H20
CONST FILE_ATTRIBUTE_DEVICE = &H40
CONST FILE_ATTRIBUTE_NORMAL = &H80
CONST FILE_ATTRIBUTE_COMPRESSED = &H800
CONST FILE_ATTRIBUTE_ENCRYPTED = &H4000

' https://learn.microsoft.com/en-us/windows/win32/debug/system-error-codes--0-499-
CONST ERROR_FILE_NOT_FOUND = &H2
CONST ERROR_PATH_NOT_FOUND = &H3
CONST ERROR_ACCESS_DENIED = &H5

TYPE FileTime
  dwlowdatetime AS _UNSIGNED LONG
  dwhighdatetime AS _UNSIGNED LONG
END TYPE

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

DECLARE DYNAMIC LIBRARY "kernel32"
  FUNCTION FindFirstFile~%& ALIAS FindFirstFileA (BYVAL lpfilename AS _OFFSET, BYVAL lpfindfiledata AS _OFFSET)
  FUNCTION FindNextFile& ALIAS FindNextFileA (BYVAL hfind AS _UNSIGNED _OFFSET, BYVAL lpfindfiledata AS _OFFSET)
  FUNCTION FindClose& (BYVAL hfind AS _UNSIGNED _OFFSET)
  FUNCTION GetLastError& ()
END DECLARE

Declare Dynamic Library "User32"
  FUNCTION SetWindowPos& (ByVal hwnd As Long, Byval hWndInsertAfter As Long, Byval x As Long, Byval y As Long, Byval cx As Long, Byval cy As Long, Byval wFlags As Long)
  FUNCTION MoveWindow& (Byval hwnd AS LONG, Byval x AS LONG, Byval y AS LONG, byval nWidth AS LONG, Byval nHeight AS LONG, byval bRepaint AS LONG)
End Declare
