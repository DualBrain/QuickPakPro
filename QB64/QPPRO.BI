CONST BAR_LINE = 1               ' Line number for the menu bar

                                 ' Alt Key translation table
CONST ALT_CHARS$ = "1234567890     QWERTYUIOP    ASDFGHJKL     ZXCVBNM"

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

TYPE Area                    'Type definition for MouseRange
  Y1 AS INTEGER
  X1 AS INTEGER
  Y2 AS INTEGER
  X2 AS INTEGER
  RN AS INTEGER
END TYPE