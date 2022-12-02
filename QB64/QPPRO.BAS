' *********** QPPRO.BAS - added value functionality for QB64
'                         inspired by QuickPak Professional 
'                         for QB45/PDS71/VBDOS10

' Copyright (c) 2022 Cory Smith

' TYPE Area                    ' Type definition for MouseRange
'   ULRow AS INTEGER
'   ULCol AS INTEGER
'   LRRow AS INTEGER
'   LRCol AS INTEGER
'   NumWindow AS INTEGER
' END TYPE

' ****************************************
' Chapter 2 - Array Routines 
' ****************************************

SUB AddInt(Array%(), Start%, Value%, NumEls%)
  ' See ADDINT.ASM
  ERROR 73 ' Feature Unavailable
END SUB

' DeleteStr removes an element from a normal (not fixed-length) 
' string array.
SUB DeleteStr(array$(), element%, numEls%)
  FOR x = element% TO element + numEls% 
    SWAP array$(x), array$(x + 1) 
  NEXT 
  ' array$(element + numEls%) = ""               ' clear the last element.
END SUB

SUB DeleteT(Array(), Element%, ElSize%, NumEls%)
  ERROR 73 ' Feature Unavailable
END SUB

SUB Fill2(Array%(), Start%, Value%, NumEls%)
  ERROR 73 ' Feature Unavailable
END SUB

SUB Fill4(Array!(), Start%, Value!, NumEls%)
  ERROR 73 ' Feature Unavailable
END SUB

SUB Fill8(Array#(), Start%, Value#, NumEls%)
  ERROR 73 ' Feature Unavailable
END SUB

SUB Find(Array$, Start%, NumEls%, SearchValue$)
  ERROR 73 ' Feature Unavailable
END SUB

SUB Find2(Array$, Start%, NumEls%, SearchValue$)
  ERROR 73 ' Feature Unavailable
END SUB

SUB FindB(Array$(), CurEl%, SearchValue$)
  ERROR 73 ' Feature Unavailable
END SUB

SUB FindB2(Array$(), CurEl%, SearchValue$)
  ERROR 73 ' Feature Unavailable
END SUB

SUB FindExact(Array$(), Start%, NumEls%, SearchValue$)
  ERROR 73 ' Feature Unavailable
END SUB

SUB FindT(Array$(), Start%, ElSize%, NumEls%, SearchValue$)
  ERROR 73 ' Feature Unavailable
END SUB

SUB FindT2(Array$(), Start%, ElSize%, NumEls%, SearchValue$)
  ERROR 73 ' Feature Unavailable
END SUB

SUB FindTB(Array$(), Start%, ElSize%, CurEl%, SearchValue$)
  ERROR 73 ' Feature Unavailable
END SUB

SUB FindTB2(Array$(), Start%, ElSize%, CurEl%, SearchValue$)
  ERROR 73 ' Feature Unavailable
END SUB

' FindLast scans a conventional (not fixed-length) string array 
' backwards looking for the last non-blank element. 
FUNCTION FindLast% (array$(), numEls%)
  FOR el = numEls% TO LBOUND(Array$)
    IF array$(el) <> "" THEN
      FindLast% = el
      EXIT FUNCTION
    END IF
  NEXT
  FindLast% = numEls%
END FUNCTION

FUNCTION GetBit%(array$, element%)
  ' NOTE: Not sure if this matches the original QPPro implementation.
  entry% = (element% \ 8) + 1
  bit% = element% MOD 8
  byt% = ASC(MID$(array$, entry%, 1))
  test% = 2 ^ bit%
  IF (byt% AND test%) = test% THEN
    GetBit% = -1
  ELSE 
    GetBit% = 0
  END IF
END FUNCTION

SUB SetBit(array$, element%, value%)
  ' NOTE: Not sure if this matches the original QPPro implementation.
  entry% = (element% \ 8) + 1
  bit% = element% MOD 8
  byt% = ASC(MID$(array$, entry%, 1))
  IF value% THEN
    byt% = byt% XOR (2 ^ bit%)
  ELSE 
    byt% = byt% AND NOT (2 ^ bit%)
  END IF
  MID$(array$, entry%, 1) = CHR$(byt%)
END SUB

FUNCTION IMaxD%(Array#(), Start%, NumEls%)
  ERROR 73 ' Feature Unavailable
END FUNCTION

FUNCTION IMaxI%(Array%(), Start%, NumEls%)
  ERROR 73 ' Feature Unavailable
END FUNCTION

FUNCTION IMaxL%(Array&(), Start%, NumEls%)
  ERROR 73 ' Feature Unavailable
END FUNCTION

FUNCTION IMaxS%(Array!(), Start%, NumEls%)
  ERROR 73 ' Feature Unavailable
END FUNCTION

FUNCTION IMaxC%(Array(), Start%, NumEls%)
  ERROR 73 ' Feature Unavailable
END FUNCTION

FUNCTION IMinD%(Array#(), Start%, NumEls%)
  ERROR 73 ' Feature Unavailable
END FUNCTION

FUNCTION IMinI%(Array%(), Start%, NumEls%)
  ERROR 73 ' Feature Unavailable
END FUNCTION

FUNCTION IMinL%(Array&(), Start%, NumEls%)
  ERROR 73 ' Feature Unavailable
END FUNCTION

FUNCTION IMinS%(Array!(), Start%, NumEls%)
  ERROR 73 ' Feature Unavailable
END FUNCTION

FUNCTION IMinC%(Array(), Start%, NumEls%)
  ERROR 73 ' Feature Unavailable
END FUNCTION

SUB InitInt(Array%(), Start%, Value%, NumEls%)
  ERROR 73 ' Feature Unavailable
END SUB

' InsertStr will insert an element at any point into a conventional (not 
' fixed-length) string array. 
SUB InsertStr(array$(), element%, ins$, numEls%)
  FOR x = (element% + numEls%) TO (element% + 1) STEP -1 
    SWAP array$(x), Array$(x - 1) 
  NEXT 
  SWAP array$(start), ins$ 
END SUB

SUB InsertT(Array(), Element%, ElSize%, NumEls%)
  ERROR 73 ' Feature Unavailable
END SUB

SUB ISortD(Array#(), Start%, Ndx%(), NumEls%, Dir%)
  ERROR 73 ' Feature Unavailable
END SUB

SUB ISortI(Array%(), Start%, Ndx%(), NumEls%, Dir%)
  ERROR 73 ' Feature Unavailable
END SUB

SUB ISortL(Array&(), Start%, Ndx%(), NumEls%, Dir%)
  ERROR 73 ' Feature Unavailable
END SUB

SUB ISortS(Array!(), Start%, Ndx%(), NumEls%, Dir%)
  ERROR 73 ' Feature Unavailable
END SUB

SUB ISortC(Array(), Start%, Ndx%(), NumEls%, Dir%)
  ERROR 73 ' Feature Unavailable
END SUB

SUB ISortStr(Array$(), Start%, Ndx%(), NumEls%, Dir%)
  ERROR 73 ' Feature Unavailable
END SUB

SUB ISortStr2(Array$(), Start%, Ndx%(), NumEls%, Dir%)
  ERROR 73 ' Feature Unavailable
END SUB

SUB ISortStrT(Array$(), Start%, Ndx%(), NumEls%, Dir%, ElSize%, MemberOffset%, MemberSize%)
  ERROR 73 ' Feature Unavailable
END SUB

SUB ISortStrT2(Array(), Start%, Ndx%(), NumEls%, Dir%, ElSize%, MemberOffset%, MemberSize%)
  ERROR 73 ' Feature Unavailable
END SUB

SUB KeySort(Array(), Start%, ElSize%, NumEls%, Table%(,), NumKey%)
  ERROR 73 ' Feature Unavailable
END SUB

FUNCTION MaxD#(Array#(), Start%, NumEls%)
  max# = Array#(Start%)
  FOR x% = Start% + 1 TO NumEls%
    IF Array#(x%) > max# THEN max# = Array#(x%)
  NEXT
  MaxD# = max#
END FUNCTION

FUNCTION MaxI%(Array%(), Start%, NumEls%)
  max% = Array%(Start%)
  FOR x% = Start% + 1 TO NumEls%
    IF Array%(x%) > max% THEN max% = Array%(x%)
  NEXT
  MaxI% = max%
END FUNCTION

FUNCTION MaxL&(Array&(), Start%, NumEls%)
  max& = Array&(Start%)
  FOR x% = Start% + 1 TO NumEls%
    IF Array&(x%) > max& THEN max& = Array&(x%)
  NEXT
  MaxL& = max&
END FUNCTION

FUNCTION MaxS!(Array!(), Start%, NumEls%)
  max! = Array!(Start%)
  FOR x% = Start% + 1 TO NumEls%
    IF Array!(x%) > max! THEN max! = Array!(x%)
  NEXT
  MaxS! = max!
END FUNCTION

FUNCTION MaxC(Array(), Start%, NumEls%)
  ERROR 73 ' Feature Unavailable
END FUNCTION

FUNCTION MinD#(Array#(), Start%, NumEls%)
  min# = Array#(Start%)
  FOR x% = Start% + 1 TO NumEls%
    IF Array#(x%) < min# THEN min# = Array#(x%)
  NEXT
  MinD# = min#
END FUNCTION

FUNCTION MinI%(Array%(), Start%, NumEls%)
  min% = Array%(Start%)
  FOR x% = Start% + 1 TO NumEls%
    IF Array%(x%) < min% THEN min% = Array%(x%)
  NEXT
  MinI% = min%
END FUNCTION

FUNCTION MinL&(Array&(), Start%, NumEls%)
  min& = Array&(Start%)
  FOR x% = Start% + 1 TO NumEls%
    IF Array&(x%) < min& THEN min& = Array&(x%)
  NEXT
  MinL& = min&
END FUNCTION

FUNCTION MinS!(Array!(), Start%, NumEls%)
  min! = Array!(Start%)
  FOR x% = Start% + 1 TO NumEls%
    IF Array!(x%) < min! THEN min! = Array!(x%)
  NEXT
  MinS! = min!
END FUNCTION

FUNCTION MinC(Array(), Start%, NumEls%)
  ERROR 73 ' Feature Unavailable
END FUNCTION

SUB Search(Array(), Start%, NumEls%, Match, Found%, Direction%, MatchCode%, VarType%)
  ERROR 73 ' Feature Unavailable
END SUB

SUB SearchT(Array(), Start%, NumEls%, Match, Found%, Dir%, Code%, StructSize%, MemberOf%, MemberSize%)
  ERROR 73 ' Feature Unavailable
END SUB

SUB SearchT2(Array(), Start%, NumEls%, Match, Found%, Dir%, Code%, StructSize%, MemberOf%, MemberSize%)
  ERROR 73 ' Feature Unavailable
END SUB

SUB SortD(Array#(), Start%, NumEls%, Dir%)
  ERROR 73 ' Feature Unavailable
END SUB

SUB SortI(Array%(), Start%, NumEls%, Dir%)
  ERROR 73 ' Feature Unavailable
END SUB

SUB SortL(Array&(), Start%, NumEls%, Dir%)
  ERROR 73 ' Feature Unavailable
END SUB

SUB SortS(Array!(), Start%, NumEls%, Dir%)
  ERROR 73 ' Feature Unavailable
END SUB

SUB SortC(Array(), Start%, NumEls%, Dir%)
  ERROR 73 ' Feature Unavailable
END SUB

' SortStr will sort (case-sensitive) all or just a portion of a conventional (not 
' fixed-length) string array into either ascending or descending order. 
SUB SortStr(array$(), startElement%, numOfElements%, dir%)
  ' start% is the first element to be included in the sort, 
  ' numEls% is the number of elements to consider, and dir% 
  ' indicates the sort direction. If dir% is set to zero, then the sorting 
  ' will be forward (ascending). Any other value will cause sorting to 
  ' be performed backward (descending). 

  REDIM qStack(500)    ' create stack

  s = 1                ' initialize work variables
  f = startElement
  max = startElement + numOfElements - 1
  l = max

L1:
  temp$ = array$((l + f) \ 2)         ' seek midpoint
  i = f
  j = l

L2:
  IF dir% = 0 THEN
    WHILE array$(i) < temp$: i = i + 1: WEND ' use > for descending
    WHILE array$(j) > temp$: j = j - 1: WEND ' use < for descending
  ELSE
    WHILE array$(i) > temp$: i = i + 1: WEND
    WHILE array$(j) < temp$: j = j - 1: WEND
  END IF
  IF i > j GOTO L3
  IF i < j THEN 
    'PRINT "swap"
    SWAP array$(i), array$(j)
  END IF
  i = i + 1: j = j - 1
  IF i <= j GOTO L2

L3:
  IF i < l THEN
    'PRINT "push"
    qStack(s) = i             ' Push I, L
    qStack(s + 1) = l
    s = s + 2
  END IF

  l = j
  IF f < l GOTO L1
  IF s = 1 GOTO L4
  'PRINT "pop"
  s = s - 2                   ' Pop L, F
  f = qStack(s)
  l = qStack(s + 1)
  GOTO L1

L4:
  ERASE qStack                ' delete the temporary stack array

END SUB

' SortStr2 will sort (case-insensitive) all or just a portion of a conventional (not 
' fixed-length) string array into either ascending or descending order. 
SUB SortStr2(array$(), startElement%, numOfElements%, dir%)

  REDIM qStack(500)     ' create stack

  s = 1                ' initialize work variables
  f = startElement
  l = startElement + numOfElements - 1

L1:
  temp$ = UCASE$(array$((l + f) \ 2))         ' seek midpoint
  i = f
  j = l

L2:
  IF dir% = 0 THEN
    WHILE UCASE$(array$(i)) < temp$: i = i + 1: WEND    ' use > for descending
    WHILE UCASE$(array$(j)) > temp$: j = j - 1: WEND    ' use < for descending
  ELSE
    WHILE UCASE$(array$(i)) > temp$: i = i + 1: WEND    ' use > for descending
    WHILE UCASE$(array$(j)) < temp$: j = j - 1: WEND    ' use < for descending
  END IF
  IF i > j GOTO L3
  IF i < j THEN SWAP array$(i), array$(j)
  i = i + 1: j = j - 1
  IF i <= j GOTO L2

L3:
  IF i < l THEN
    qStack(s) = i             ' Push I, L
    qStack(s + 1) = l
    s = s + 2
  END IF

  l = j
  IF f < l GOTO L1
  IF s = 1 GOTO L4
  s = s - 2                   ' Pop L, F
  f = qStack(s)
  l = qStack(s + 1)
  GOTO L1

L4:
  ERASE qStack                ' delete the temporary stack array

END SUB

SUB SortStrT(Array$, Start%, NumEls%, Dir%, MemberOffset%, MemberSize%)
  ERROR 73 ' Feature Unavailable
END SUB

SUB SortStrT2(Array$, Start%, NumEls%, Dir%, MemberOffset%, MemberSize%)
  ERROR 73 ' Feature Unavailable
END SUB

' ****************************************
' Chapter 3 - DOS Services
' ****************************************

SUB CDir(NewDir$)
  CHDIR NewDir$
END SUB

SUB ClipFile(FileName$, NewLength&)
  ERROR 73 ' Feature Unavailable
END SUB

SUB DiskInfo(Drive$, Byte%, Sectors%, FreeClusters&, TotalClusters&)
  ERROR 73 ' Feature Unavailable
END SUB

FUNCTION DiskRoom&(Drive$)
  ERROR 73 ' Feature Unavailable
END FUNCTION

FUNCTION DiskSize&(Drive$)
  ERROR 73 ' Feature Unavailable
END FUNCTION

FUNCTION DosError%
  'TODO: 
  DosError% = 0 ' No error.
END FUNCTION

FUNCTION DOSVer%
  DOSVer% = 611 ' Fixed as DOS 6.11
END FUNCTION

FUNCTION ErrorMsg$(ErrorNumber%)
  ERROR 73 ' Feature Unavailable
END FUNCTION

FUNCTION ExeName$
  ERROR 73 ' Feature Unavailable
END FUNCTION

FUNCTION Exist%(FileName$)
  Exist% = _FileExists(FileName$)
END FUNCTION

FUNCTION FastLoadInt%(FileName$)
  ERROR 73 ' Feature Unavailable
END FUNCTION

SUB FastLoadStr(Array$())
  ERROR 73 ' Feature Unavailable
END SUB

SUB FastSave(FileName$, Text$())
  ERROR 73 ' Feature Unavailable
END SUB

SUB FClose(Handle%)
  CLOSE #Handle%
END SUB

SUB FCopy(Source$, Dest$, Buffer$, ErrCode%)
  ERROR 73 ' Feature Unavailable
END SUB

SUB FCreate(FileName$)
  ff = FREEFILE
  OPEN FileName$ FOR OUTPUT AS #ff
  CLOSE #ff
END SUB

FUNCTION FEof%(Handle%)
  FEof% = EOF(Handle%)
END FUNCTION

SUB FFlush(Handle%)
  ERROR 73 ' Feature Unavailable
END SUB

SUB FGet(Handle%, Destination$)
  ERROR 73 ' Feature Unavailable
END SUB

SUB FGetA(Handle%, Array(), Element%, NumBytes%)
  ERROR 73 ' Feature Unavailable
END SUB

SUB FGetFH(FileName$, Array(), Start%, ElSize%, NumEls%)
  ERROR 73 ' Feature Unavailable
END SUB

SUB FGetR(Handle%, Destination$, RecNumber&)
  ERROR 73 ' Feature Unavailable
END SUB

SUB FGetRT(Handle%, Destination, RecNumber&, RecSize%)
  ERROR 73 ' Feature Unavailable
END SUB

SUB FGetRTA(Handle%, Destination, RecNumber&, RecSize%)
  ERROR 73 ' Feature Unavailable
END SUB

SUB FGetT(Handle%, Destination, NumBytes%)
  ERROR 73 ' Feature Unavailable
END SUB

FUNCTION FileComp%(File1$, File2$, ErrCode%)
  ERROR 73 ' Feature Unavailable
END FUNCTION

SUB FileCopy(Source$, Dest$, Copied%, ErrCode%)
  ERROR 73 ' Feature Unavailable
END SUB

SUB FileCrypt(FileName$, PassWord$)
  ERROR 73 ' Feature Unavailable
END SUB

SUB FileInfo(FileName$, TypeVar)
  ERROR 73 ' Feature Unavailable
END SUB

' FileSize will quickly return the length of a named file. 
FUNCTION FileSize&(fileName$)

  ' fileName$ is the name of the file, and size is assigned its length in 
  ' bytes. If the file does not exist size is instead assigned a value of -1. 

  result& = 0

  IF NOT _FileExists(fileName$) THEN
    result& = -1
  ELSE

    IF INSTR(_OS$, "[WINDOWS]") THEN
      DIM pattern AS STRING
      DIM fd AS Win32_Find_Data
      DIM hFind AS _UNSIGNED _OFFSET
      DIM junk AS LONG
      pattern = fileName$ + CHR$(0)
      hFind = FindFirstFile(_OFFSET(pattern), _OFFSET(fd))
      IF hFind <> INVALID_HANDLE_VALUE THEN
        result& = fd.nfilesizelow
        junk = FindClose(hFind)
      ELSE
        lastError& = GetLastError
        IF lastError& = ERROR_ACCESS_DENIED THEN
          ERROR 70 ' Permission denied
        ELSE
          ERROR 75 ' Path/File access error
        END IF
      END IF
    ELSE
      ERROR 73 ' Advanced Feature / Feature Unavailable
    END IF

  END IF

  FileSize& = result&

END FUNCTION

SUB FileSort(DataFile$, IndexFile$, First&, Last&, Table%(), RecLength%)
  ERROR 73 ' Feature Unavailable
END SUB

FUNCTION FLInput$(Handle%, Buffer$)
  ERROR 73 ' Feature Unavailable
END FUNCTION

FUNCTION FLoc&(Handle%)
  FLoc& = LOC(Handle%)
END FUNCTION

FUNCTION FLof&(Handle%)
  FLof& = LOF(Handle%)
END FUNCTION

SUB FOpen(FileName$, Handle%)
  ERROR 73 ' Feature Unavailable
END SUB

SUB FOpenS(FileName$, Handle%)
  ERROR 73 ' Feature Unavailable
END SUB

SUB FOpenAll(FileName$, AccessMode%, ShareMode%, Handle%)
  ERROR 73 ' Feature Unavailable
END SUB

FUNCTION FormatDiskette%(DriveNumber%, Capacity%, BufArray%)
  ERROR 73 ' Feature Unavailable
END FUNCTION

SUB FPut(Handle%, Source$)
  ERROR 73 ' Feature Unavailable
END SUB

SUB FPutA(Handle%, Array(), Start%, NumBytes%)
  ERROR 73 ' Feature Unavailable
END SUB

SUB FPutAH(Handle%, Array(), ElSize%, NumEls%)
  ERROR 73 ' Feature Unavailable
END SUB

SUB FPutR(Handle%, Source$, RecNumber&)
  ERROR 73 ' Feature Unavailable
END SUB

SUB FPutRT(Handle%, Source, RecNumber&, RecSize%)
  ERROR 73 ' Feature Unavailable
END SUB

SUB FPutRTA(Handle%, Source, RecNumber&, RecSize%)
  ERROR 73 ' Feature Unavailable
END SUB

SUB FPutT(Handle%, Source, NumBytes%)
  ERROR 73 ' Feature Unavailable
END SUB

SUB FSeek(Handle%, Location&)
  ERROR 73 ' Feature Unavailable
END SUB

SUB FStamp(FileName$, NewTime$, NewDate$)
  ERROR 73 ' Feature Unavailable
END SUB

FUNCTION FullName$(PartName$)
  ERROR 73 ' Feature Unavailable
END FUNCTION

FUNCTION GetAttr%(FileName$)
  ERROR 73 ' Feature Unavailable
END FUNCTION

' GetDir will return the current directory for either a specified drive 
' or the default drive. 
FUNCTION GetDir$(drive$)
 
  ' Parameter may be given as either upper or lower case, and only the first character is considered
  ' Returns the complete directory name, minus the drive letter and colon.

  ' _CWD$ (function) returns the current working directory as a STRING value.
  ' _STARTDIR$ (function) returns the user's program calling path as a STRING.

  ch$ = MID$(_CWD$, 1, 1)
  a% = ASC(UCASE$(ch$))
  SELECT CASE a%
    CASE ASC("A") TO ASC("Z")
      GetDir$ = MID$(_CWD$, 3)
    CASE ELSE
      GetDir$ = _CWD$
  END SELECT

END FUNCTION

FUNCTION GetDisketteType%(DriveNumber%)
  ERROR 73 ' Feature Unavailable
END FUNCTION

' GetDrive returns the current default disk drive. 
FUNCTION GetDrive%
  ' Drive$ is assigned to a value representing an ASCII character that 
  ' holds the current default drive. GetDrive actually returns an integer 
  ' result, which can be easily turned into a string as shown above.

  ' GetDrive returns a value that represents an upper case ASCII drive 
  ' letter. For example, if the current default drive is A, then GetDrive 
  ' will return the value 65. Likewise, if the current drive is C, 
  ' GetDrive would return 67.

  ' _CWD$ (function) returns the current working directory as a STRING value.
  ' _STARTDIR$ (function) returns the user's program calling path as a STRING.

  ch$ = MID$(_CWD$, 1, 1)
  a% = ASC(UCASE$(ch$))
  SELECT CASE a%
    CASE ASC("A") TO ASC("Z")
      GetDrive% = a%
    CASE ELSE
      GetDrive% = 0
  END SELECT

END FUNCTION

FUNCTION GetVol$(Drive$)
  ERROR 73 ' Feature Unavailable
END FUNCTION

FUNCTION GoodDrive%(Drive$)
  ERROR 73 ' Feature Unavailable
END FUNCTION

SUB Handle2Name(Handle%, FilName)
  ERROR 73 ' Feature Unavailable
END SUB

SUB KillDir(DirName$)
  RMDIR DirName$
END SUB

SUB KillFile(FileName$)
  KILL FileName$
END SUB

FUNCTION LastDrive%
  ERROR 73 ' Feature Unavailable
END FUNCTION

' LineCount will quickly count all of the lines of text in a specified file.
FUNCTION LineCount%(fileName$, buffer$)

  ' The main purpose of LineCount is to report the number of lines in a 
  ' text file, in preparation for dimensioning an array to hold them. 
  ' When a program will be reading a text file into an array, knowing 
  ' this ahead of time can be a big help. The only other possibilities 
  ' would be to read through the entire file once just to count the lines, 
  ' or guess at how large to dimension the array to. 

  ' One important caveat you should be aware of when using 
  ' LineCount is that it merely counts the number of CHR$(13) 
  ' carriage returns in the file. Line feeds are not considered at all. 

  ' fileName$ is the name of the file to examine, and may contain an 
  ' optional drive letter or path name. buffer$ is a temporary work area 
  ' needed by LineCount to hold the file, and count receives the 
  ' number of lines of text. 

  ' If there are more than 32767 lines in the file (very unlikely if you 
  ' think about it), LineCount will return a negative number. Simply 
  ' add 65536 to that number to get the actual count. 

  ' If the file doesn't exist or some other error occurs, LineCount will 
  ' instead receive -1. 

  result% = 0

  IF _FileExists(fileName$) THEN
    ff = FREEFILE
    OPEN fileName$ FOR INPUT AS #ff
    DO UNTIL EOF(1)
      LINE INPUT #ff, buffer$
      result% = result% + 1
    LOOP
    CLOSE #ff
  ELSE
    result% = -1
  END IF

  LineCount% = result%

END FUNCTION

FUNCTION LoadExec%(Program$, CmdLine$)
  ERROR 73 ' Feature Unavailable
END FUNCTION

SUB LockFile(Handle%, Offset&, Length&)
  ERROR 73 ' Feature Unavailable
END SUB

SUB MakeDir(DirName$)
  MKDIR DirName$
END SUB

SUB NameDir(OldName$, NewName$)
  NAME OldName$ AS NewName$
END SUB

SUB NameFile(OldName$, NewName$)
  NAME OldName$ AS NewName$
END SUB

FUNCTION NetDrive%(Drive$)
  ERROR 73 ' Feature Unavailable
END FUNCTION

SUB PutVol(Drive$, Label$)
  ERROR 73 ' Feature Unavailable
END SUB

SUB QBLoad(FileName$, Array%(), Element%)
  'DEF SEG = VARSEG(Array(0))
    BLOAD FileName$, VARPTR(Array(LBOUND(Array)))
  'END SEG
END SUB

SUB QBSave(FileName$, Array%(), Element%, NumBytes%)
  ERROR 73 ' Feature Unavailable
END SUB

' DCount reports the number of directories that match a particular specification. 
FUNCTION DCount%(dirSpec$)
  ' dirSpec$ holds a DOS directory name specification, and Count 
  ' receives the number of matching directories.

  result% = 0

  IF INSTR(_OS$, "[WINDOWS]") THEN
    DIM pattern AS STRING
    DIM fd AS Win32_Find_Data
    DIM hFind AS _UNSIGNED _OFFSET
    DIM junk AS LONG
    DIM ffn AS STRING
    DIM p AS INTEGER
    pattern = dirSpec$ + CHR$(0)
    hFind = FindFirstFile(_OFFSET(pattern), _OFFSET(fd))
    IF hFind <> INVALID_HANDLE_VALUE THEN
      DO
        IF (fd.dwfileattributes AND FILE_ATTRIBUTE_DIRECTORY) = FILE_ATTRIBUTE_DIRECTORY THEN
          ffn = fd.cfilename
          p = INSTR(ffn, CHR$(0))
          IF p > 0 THEN ffn = LEFT$(ffn, p - 1)
          IF ffn = "." THEN
          ELSEIF ffn = ".." THEN
          ELSEIF UCASE$(ffn) = "$RECYCLE.BIN" THEN
          ELSEIF INSTR(ffn, "System Volume Information") > 0 THEN
          ELSE
            result% = result% + 1
          END IF
        END IF
      LOOP UNTIL FindNextFile(hFind, _OFFSET(fd)) = 0
      junk = FindClose(hFind)
    ELSE
      lastError& = GetLastError
      IF lastError& = ERROR_ACCESS_DENIED THEN
        ERROR 70 ' Permission denied
      ELSE
        ERROR 75 ' Path/File access error
      END IF
    END IF
  ELSE
    ERROR 73 ' Advanced Feature / Feature Unavailable
  END IF

  DCount% = result%

END FUNCTION

' ReadDir obtains a list of directory names from disk, and loads them 
' into a conventional (not fixed-length) string array in one operation. 
SUB ReadDir(array$())
  ' array$(0) holds the search specification to indicate which directory 
  ' names are to be loaded, and subsequent array elements receive each 
  ' directory name. 

  IF INSTR(_OS$, "[WINDOWS]") THEN
    
    DIM pattern AS STRING
    DIM fd AS Win32_Find_Data
    DIM hFind AS _UNSIGNED _OFFSET
    DIM junk AS LONG
    DIM ffn AS STRING
    DIM p AS INTEGER

    pattern = array$(0) + CHR$(0)
    hFind = FindFirstFile(_OFFSET(pattern), _OFFSET(fd))
    IF hFind <> INVALID_HANDLE_VALUE THEN
      index = 1
      DO
        IF (fd.dwfileattributes AND FILE_ATTRIBUTE_DIRECTORY) = FILE_ATTRIBUTE_DIRECTORY THEN
          ffn = fd.cfilename
          p = INSTR(ffn, CHR$(0))
          IF p > 0 THEN ffn = LEFT$(ffn, p - 1)
          IF ffn = "." THEN
          ELSEIF ffn = ".." THEN
          ELSEIF UCASE$(ffn) = "$RECYCLE.BIN" THEN
          ELSEIF INSTR(ffn, "System Volume Information") > 0 THEN
          ELSE
            array$(index) = ffn
            index = index + 1
          END IF
        END IF
      LOOP UNTIL FindNextFile(hFind, _OFFSET(fd)) = 0
      junk = FindClose(hFind)
    ELSE
      lastError& = GetLastError
      IF lastError& = ERROR_ACCESS_DENIED THEN
        ERROR 70 ' Permission denied
      ELSE
        ERROR 75 ' Path/File access error
      END IF
    END IF
  ELSE
    ERROR 73 ' Advanced Feature / Feature Unavailable
  END IF

END SUB

' FCount will report the number of file names that match a particular specification. 
FUNCTION FCount%(fileSpec$)

  ' fileSpec$ holds a DOS file name or specification, and Count 
  ' receives the number of matching entries. 

  result% = 0

  IF INSTR(_OS$, "[WINDOWS]") THEN
    DIM pattern AS STRING
    DIM fd AS Win32_Find_Data
    DIM hFind AS _UNSIGNED _OFFSET
    DIM junk AS LONG
    pattern = fileSpec$ + CHR$(0)
    hFind = FindFirstFile(_OFFSET(pattern), _OFFSET(fd))
    IF hFind <> INVALID_HANDLE_VALUE THEN
      DO
        IF (fd.dwfileattributes AND FILE_ATTRIBUTE_DIRECTORY) = FILE_ATTRIBUTE_DIRECTORY THEN
        ELSE 
          result% = result% + 1
        END IF
      LOOP UNTIL FindNextFile(hFind, _OFFSET(fd)) = 0
      junk = FindClose(hFind)
    ELSE
      lastError& = GetLastError
      IF lastError& = ERROR_FILE_NOT_FOUND THEN
        ' no files available, result remains 0
      ELSEIF lastError& = ERROR_ACCESS_DENIED THEN
        ERROR 70 ' Permission denied
      ELSE
        PRINT lastError&
        ERROR 75 ' Path/File access error
      END IF
    END IF
  ELSE
    ERROR 73 ' Advanced Feature / Feature Unavailable
  END IF

  FCount% = result%

END FUNCTION

' ReadFile obtains a list of file names from disk, and loads them into 
' a conventional (not fixed-length) string array in one operation. 
SUB ReadFile(array$())

  ' array$(0) holds the search specification to indicate which file names
  ' are to be loaded, and subsequent array elements receive each name.

  IF INSTR(_OS$, "[WINDOWS]") THEN
    
    DIM pattern AS STRING
    DIM fd AS Win32_Find_Data
    DIM hFind AS _UNSIGNED _OFFSET
    DIM junk AS LONG
    DIM ffn AS STRING
    DIM p AS INTEGER

    pattern = array$(0) + CHR$(0)
    hFind = FindFirstFile(_OFFSET(pattern), _OFFSET(fd))
    IF hFind <> INVALID_HANDLE_VALUE THEN
      index = 1
      DO
        IF (fd.dwfileattributes AND FILE_ATTRIBUTE_DIRECTORY) = FILE_ATTRIBUTE_DIRECTORY THEN
        ELSE 
          ffn = fd.cfilename
          p = INSTR(ffn, CHR$(0))
          IF p > 0 THEN ffn = LEFT$(ffn, p - 1)
          array$(index) = ffn
          index = index + 1
        END IF
      LOOP UNTIL FindNextFile(hFind, _OFFSET(fd)) = 0
      junk = FindClose(hFind)
    ELSE
      lastError& = GetLastError
      IF lastError& = ERROR_FILE_NOT_FOUND THEN
        ' no files available, result remains 0
      ELSEIF lastError& = ERROR_ACCESS_DENIED THEN
        ERROR 70 ' Permission denied
      ELSE
        PRINT lastError&
        ERROR 75 ' Path/File access error
      END IF
    END IF
  ELSE
    ERROR 73 ' Advanced Feature / Feature Unavailable
  END IF

END SUB

SUB ReadDirT(Spec$, Array())
  ERROR 73 ' Feature Unavailable
END SUB

SUB ReadFileI(Array$())
  ERROR 73 ' Feature Unavailable
END SUB

SUB ReadFileT(Spec$, Array())
  ERROR 73 ' Feature Unavailable
END SUB

SUB ReadFileX(Spec$, DirSize&, Array())
  ERROR 73 ' Feature Unavailable
END SUB

SUB ReadSect(Drive$, Info$, Sector%)
  ERROR 73 ' Feature Unavailable
END SUB

FUNCTION ReadTest%(Drive$)
  ERROR 73 ' Feature Unavailable
END FUNCTION

FUNCTION Removable%(Drive$)
  ERROR 73 ' Feature Unavailable
END FUNCTION

FUNCTION ScanFile&(FileName$, Text$, Start&)
  ERROR 73 ' Feature Unavailable
END FUNCTION

FUNCTION SearchPath$(FileName$)
  ERROR 73 ' Feature Unavailable
END FUNCTION

SUB SetAttr(FileName$, Attribute%)
  ERROR 73 ' Feature Unavailable
END SUB

SUB SetCmd(NewCommand$)
  ERROR 73 ' Feature Unavailable
END SUB

' SetDrive allows changing the current default drive. 
SUB SetDrive(drive$)
  ' drive$ is either an upper or lower case letter of the drive to be 
  ' made the current default. 
  d$ = UCASE$(LEFT$(drive$, 1))
  IF ASC(d$) >= 65 AND ASC(d$) <= 90 THEN
    CHDIR d$ + ":"
  ELSE
    ERROR 5 ' Illegal Function Call
  END IF
END SUB

' SetError allows a BASIC program to set or clear the DOSError and 
' WhichError functions. 
SUB SetError(errNum%)
  'TODO: Need to figure out how to handle setting of an error
  ' so that, somehow, SYSTEM and/or END can be called
  ' before exiting the application so that the error set
  ' can be exposed to the caller (externally - os level).
END SUB

SUB SetLevel(ErrValue%)
  ERROR 73 ' Feature Unavailable
END SUB

FUNCTION ShareThere%
  ERROR 73 ' Feature Unavailable
END FUNCTION

SUB SplitName(WorkName$, Drive$, Path$, FileName$, Extension$)
  ERROR 73 ' Feature Unavailable
END SUB

FUNCTION Unique$(Path$)
  ERROR 73 ' Feature Unavailable
END FUNCTION

SUB UnLockFile(Handle%, Offset&, Length&)
  ERROR 73 ' Feature Unavailable
END SUB

FUNCTION Valid%(FileName$)
  ERROR 73 ' Feature Unavailable
END FUNCTION

' WhichError reports which error if any occurred during the last call 
' to a QuickPak: Professional DOS routine.
FUNCTION WhichError%
  
  ' WhichError% returns O if there was no error, or an error code if 
  ' there was. 

  ' All of the QuickPak Professional routines assign a value to the 
  ' DOSError and WhichError functions to indicate their success or 
  ' failure. Rather than requiring you to set up a separate error 
  ' handling procedure and use ON ERROR, you can simply query 
  ' these functions after performing any QuickPak Professional DOS 
  ' operation. WhichError is discussed in the section entitled 
  ' "Eliminating ON ERROR". 
  
  ' The table on the following page shows all of the possible DOS 
  ' errors and the corresponding numbers that WhichError returns. 
  
  ' Also see the complimentary function DOSError

  WhichError% = 0 'TODO: Need to implement. 

END FUNCTION

SUB WriteSect(Drive$, Info$, Sector%)
  ERROR 73 ' Feature Unavailable
END SUB

SUB WriteSect2(Drive$, Info$, Sector%)
  ERROR 73 ' Feature Unavailable
END SUB

FUNCTION WriteTest%(Drive$)
  ERROR 73 ' Feature Unavailable
END FUNCTION

' ****************************************
' Chapter 4 - Functions
' ****************************************

FUNCTION Bin2Num%(binary$)
  b$ = RIGHT$("0000000000000000" + binary$, 16)
  result& = VAL(MID$(b$, 16, 1))
  FOR x% = LEN(b$) - 1 TO 2 STEP - 1
    v% = VAL(MID$(b$, x%, 1))
    IF v% > 0 THEN
      v% = 16 - x%
      result& = result& + (2 ^ v%)
    END IF
  NEXT
  'IF INSTR(b$, "0") = 0 THEN
  '  result& = -1
  'ELSE
  IF MID$(b$, 1, 1) = "1" THEN
    result& = -(32768 - result&) 
  END IF
  Bin2Num% = CINT(result&)
END FUNCTION

' Num2Bin will convert a number into an equivalent binary string with 
' a fixed length of 16 digits. 
FUNCTION Num2Bin$(number%)
  n& = number%
  IF n& < O THEN n& = n& + 65536 
  IF n& = 0 THEN
    Num2Bin$ = "0000000000000000"
  ELSEIF n& > 0 THEN
    result$ = ""
    i# = 2 ^ CLNG(LOG(n&) / LOG(2) + 0.1)
    DO WHILE i# >= 1
      c& = FIX(n& / i#)
      result$ = result$ + LTRIM$(STR$(c&))
      n& = n& - i# * c&
      i# = i# / 2
    LOOP
    Num2Bin$ = RIGHT$("0000000000000000" + result$, 16)
  END IF
END FUNCTION

' Num2Bin2 will convert a number into an equivalent binary string with 
' only as many digits as required to represent the number. 
FUNCTION Num2Bin2$(number%)
  n& = number%
  IF n& < O THEN n& = n& + 65536 
  IF n& = 0 THEN
    Num2Bin2$ = "0"
  ELSEIF n& > 0 THEN
    result$ = ""
    i# = 2 ^ CLNG(LOG(n&) / LOG(2) + 0.1)
    DO WHILE i# >= 1
      c& = FIX(n& / i#)
      result$ = result$ + LTRIM$(STR$(c&))
      n& = n& - i# * c&
      i# = i# / 2
    LOOP
    Num2Bin2$ = result$
  END IF
END FUNCTION

FUNCTION QPHex$(Value, NumDigits%)
  ERROR 73 ' Feature Unavailable
END FUNCTION

' ****************************************
' Chapter 5 - Menu/Input Routines
' ****************************************

SUB AMenu(Array$(), Start%, StartItem%, Count%, ScanCode%, NormColor%, HiLiteColor%, NumRows%, NumCols%, Gap%, ULRow%, ULCol%)
  ERROR 73 ' Feature Unavailable
END SUB

SUB AMenuT(Array(), Start%, StartItem%, Length%, Count%, ScanCode%, NormColor%, HiLiteColor%, NumRows%, NumCols%, Gap%, ULRow%, ULCol%)
  ERROR 73 ' Feature Unavailable
END SUB

SUB ASCIIPick(Char%, Color1%, Color2%, ExitCode%)
  ERROR 73 ' Feature Unavailable
END SUB

SUB MASCIIPick(Char%, Color1%, Color2%, ExitCode%)
  ERROR 73 ' Feature Unavailable
END SUB

SUB ColorPick(Colr%, BoxColor%, ExitCode%)
  ERROR 73 ' Feature Unavailable
END SUB

SUB MColorPick(Colr%, BoxColor%, ExitCode%)
  ERROR 73 ' Feature Unavailable
END SUB

SUB DirFile(Array$(), Count%, ScanCode%, MsgColor%, FileColor%, HiLiteColor%, BoxColor%)
  ERROR 73 ' Feature Unavailable
END SUB

SUB Editor(Ed$, ActiveLength%, ScanCode%, NumOnly%, IsCapsOn%, NormalColor%, EditColor%, Row%, Column%)
  ERROR 73 ' Feature Unavailable
END SUB

SUB Lts2Menu(Item$(), PromptParam$(), Choice%, Colr%)
  ERROR 73 ' Feature Unavailable
END SUB

SUB LtsMenu(Item$(), Choice%, Colr%)
  ERROR 73 ' Feature Unavailable
END SUB

' MAMenu is a full-featured multi-column menu routine, which 
' allows selecting items either with the keyboard or a mouse. This is 
' a mouse-aware version of the original AMenu routine, which is 
' described elsewhere.
'SUB MAMenu (Address%, Selection%, Start%, Count%, ExitCode%, FileColr%, HiLiteColr%, Rows%, Columns%, Spacing%, Row%, Column%)
SUB MAMenu(Array$(), First%, Selection%, Start%, Count%, ScanCode%, NormalColor%, Hilight%, NumRows%, NumCols%, Gap%, Row%, Column%)
  ERROR 73 ' Feature Unavailable
END SUB

SUB MAMenuT(Array$(), First%, Selection%, Start%, Length%, Count%, ScanCode%, NormalColor%, Hilight%, NumRows%, NumCols%, Gap%, Row%, Column%)
  ERROR 73 ' Feature Unavailable
END SUB

SUB MaskIn(Mask$, Text$, Mski)
  ERROR 73 ' Feature Unavailable
END SUB

SUB MEditor(Ed$, ActiveLength%, ScanCode%, NumOnly%, IsCapsOn%, NormalColor%, EditColor%, Row%, Column%, CurrentColumn%)
  ERROR 73 ' Feature Unavailable
END SUB

SUB MenuVert(Array$(), NumLines%, ScanCode%, Choice%, NormalColr%, HiLiteColor%, Row%, Column%)
  ERROR 73 ' Feature Unavailable
END SUB

' MGetKey first clears the keyboard buffer of any pending keys, and 
' then waits until either a key or mouse button has been pressed. This 
' is a "mouse-aware" version of the QuickPak Professional WaitKey 
' routine. 
FUNCTION MGetKey%(Row%, Col%)
  ' Scan Code% is returned holding the key or mouse button that was 
  ' pressed, and Row% and Column% indicate the location of the 
  ' mouse cursor at the time the mouse button was pressed. 
  DO
    'TODO: Need to handle mouse click...
    a$ = INKEY$
    IF a$ <> "" THEN
      IF LEN(a$) = 1 THEN
        MGetKey% = ASC(a$)
      ELSE
        MGetKey% = -ASC(RIGHT$(a$, 1))
      END IF
      EXIT DO
    END IF
  LOOP
END FUNCTION

SUB MMenuVert(Array$(), Selection%, Start%, ScanCode%, NormalColr%, Hilight%, NumRows%, Row%, Column%)
  ERROR 73 ' Feature Unavailable
END SUB

SUB PickList(Item$(), Picked%(), NPicked%, Cnf)
  ERROR 73 ' Feature Unavailable
END SUB

SUB Spread(Wks$(), Format$(), ColumnWidths%(), Wide%, Rows%, Action%)
  ERROR 73 ' Feature Unavailable
END SUB

SUB YesNo(YN$, PromptParam$, ScanCode%, NormalColor%, EditColor%, Row%, Column%)
  ERROR 73 ' Feature Unavailable
END SUB

' ****************************************
' Chapter 6 - Keyboard / Mouse Routines
' ****************************************

FUNCTION AltKey%
  ' See ALTKEY.ASM
  LALT& = 100308
  RALT& = 100307
  AltKey% = _KEYDOWN(LALT&) OR _KEYDOWN(RALT&)
END FUNCTION

' ButtonPress will report how many times a specified mouse button 
' was pressed since the last time it was called. It also returns the X/Y 
' coordinates where the mouse cursor was located when that button 
' was last pressed. 
SUB ButtonPress (button%, status%, count%, x%, y%)

  ' NOTE: it appears that button press count is monitored "outside" of
  '       this method; it is reset within this method to 0 (I think?), 
  '       but will need to figure out a way to determine the number of
  '       presses (clicks) some other way.

  ' button% is the button of interest, with a 1 indicating button 1,  
  ' 2 meaning button 2, and 3 for button 3 (if the mouse has a third button). 

  ' status% is the current button status, and has the same meaning as 
  ' the information returned by the GetCursor mouse routine. 

    button1% = _MOUSEBUTTON(1)
    button2% = _MOUSEBUTTON(2)
    button3% = _MOUSEBUTTON(3)
    status% = 0
    IF button% = 1 AND button1% THEN status% = 1
    IF button% = 2 AND button2% THEN status% = status% + 2
    IF button% = 3 AND button3% THEN status% = status% + 4

  ' Count% tells how many times the button has been pressed since 
  ' ButtonPress was last called. X% and Y% hold the mouse cursor 
  ' position at the time the button was pressed. Use the GetCursor 
  ' routine to determine the current mouse cursor location. 

  IF _MOUSEINPUT THEN 
    ' WHILE _MOUSEBUTTON(button%)
    '   IF button% = 1 THEN count1% = count1% + 1
    '   IF button% = 2 THEN count2% = count2% + 1
    '   IF button% = 3 THEN count3% = count3% + 1
    ' WEND
    IF _MOUSEBUTTON(button%) THEN
      IF button% = 1 THEN count1% = count1% + 1
      IF button% = 2 THEN count2% = count2% + 1
      IF button% = 3 THEN count3% = count3% + 1
    END IF
    IF _PIXELSIZE = 0 THEN
      col% = _MOUSEX
      row% = _MOUSEY
      x% = (col% - 1) * 8
      y% = (row% - 1) * 8
    ELSE
      x% = _MOUSEX
      y% = _MOUSEY
    END IF
    lastX% = x%
    lastY% = y%
  ELSE
    x% = lastX%
    y% = lastY%
  END IF
  
  IF button% = 1 THEN count% = count1%: count1% = 0
  IF button% = 2 THEN count% = count2%: count2% = 0
  IF button% = 3 THEN count% = count3%: count3% = 0

END SUB

FUNCTION CapsLock
  ERROR 73 ' Feature Unavailable
END FUNCTION

SUB CapsOff
  ERROR 73 ' Feature Unavailable
ENd SUB

SUB CapsOn
  ERROR 73 ' Feature Unavailable
END SUB

' ClearBuf will quickly clear the keyboard of any key strokes that are 
' currently pending. 
SUB ClearBuf
  'WHILE INKEY$ <> "": WEND 
  _KEYCLEAR
END SUB

FUNCTION CtrlKey%
  ERROR 73 ' Feature Unavailable
END FUNCTION

' GetCursor reports the current location of the mouse cursor, and 
' which mouse buttons are currently depressed. 
SUB GetCursor (x%, y%, button%) STATIC
  ' x% and y% return holding the current mouse cursor coordinates, 
  ' and button% is bit coded to indicate which buttons are currently 
  ' down. 
  IF _MOUSEINPUT THEN
    IF _PIXELSIZE = 0 THEN
      col% = _MOUSEX
      row% = _MOUSEY
      x% = (col% - 1) * 8
      y% = (row% - 1) * 8
    ELSE
      x% = _MOUSEX
      y% = _MOUSEY
    END IF
    button1% = _MOUSEBUTTON(1)
    button2% = _MOUSEBUTTON(2)
    button3% = _MOUSEBUTTON(3)
    button% = 0
    IF button1% THEN button% = 1
    IF button2% THEN button% = button% + 2
    IF button3% THEN button% = button% + 4
    lastX% = x%
    lastY% = y%
    lastButton% = button%
  ELSE
    x% = lastX%
    y% = lastY%
    button% = lastButton%
  END IF
END SUB

SUB GetCursorT(Col%, Row%, Button%)
  ERROR 73 ' Feature Unavailable
END SUB

' GrafCursor greatly simplifies defining the shape of the mouse 
' cursor for use in graphics mode. 
SUB GrafCursor(x%, y%, cursor$)
  ' x% and y% define the cursor "hot spot", and cursor$ is either a 
  ' conventional or fixed-length string that contains the new cursor shape. 

  ' https://learn.microsoft.com/en-us/windows/win32/menurc/using-cursors

  ' NOT IMPLEMENTED

END SUB

SUB HideCursor
  _MOUSEHIDE
END SUB

' InitMouse is used both to determine if a mouse is present in the host 
' PC, and to reset the mouse driver software to its default values. 
SUB InitMouse(there%)
  ' there% receives -1 if a mouse is present, or O if no mouse is installed. 
  there% = -1 ' we are working on modern platforms, of course there is a mouse.
END SUB

FUNCTION InStat%
  ERROR 73 ' Feature Unavailable
END FUNCTION

SUB Keyboard(Row%, Column%, Color1%, Color2%, Mode%)
  ERROR 73 ' Feature Unavailable
END SUB

' KeyDown reports if any keys are currently being pressed. 
FUNCTION KeyDown%

  ' Set to -1 (True) if a key is currently being pressed, or 
  ' 0 if no keys are pressed. 

  bksp% = _KEYDOWN(8)
  tb% = _KEYDOWN(9)
  entr% = _KEYDOWN(13)
  esc% = _KEYDOWN(27) ' ESC

  f1% = _KEYDOWN(15104) ' F1
  f2% = _KEYDOWN(15360) ' F2
  f3% = _KEYDOWN(15616) ' F3
  f4% = _KEYDOWN(15872) ' F4
  f5% = _KEYDOWN(16128) ' F5
  f6% = _KEYDOWN(16384) ' F6
  f7% = _KEYDOWN(16640) ' F7
  f8% = _KEYDOWN(16896) ' F8
  f9% = _KEYDOWN(17152) ' F9
  f10% = _KEYDOWN(17408) ' F10
  f11% = _KEYDOWN(34048) ' F11
  f12% = _KEYDOWN(34304) ' F12
  ins% = _KEYDOWN(20992) ' INS
  hm% = _KEYDOWN(18176) ' HOME
  pgup% = _KEYDOWN(18688) ' PGUP
  del% = _KEYDOWN(21248) ' DEL
  ed% = _KEYDOWN(20224) ' END
  pgdn% = _KEYDOWN(20736) ' PGDN
  up% = _KEYDOWN(18432) ' UP
  dn% = _KEYDOWN(20480) ' DN
  lt% = _KEYDOWN(19200) ' LEFT
  rt% = _KEYDOWN(19712) ' RIGHT
  num% = _KEYDOWN(100300) ' Num Lock
  caps% = _KEYDOWN(100301) ' Caps Lock
  rshift% = _KEYDOWN(100303) ' Right Shift
  lshift% = _KEYDOWN(100304) ' Left Shift
  rctrl% = _KEYDOWN(100305) ' Right Control
  lctrl% = _KEYDOWN(100306) ' Left Control
  ralt% = _KEYDOWN(100307) ' Right Alt
  lalt% = _KEYDOWN(100308) ' Left Alt

  atoz% = 0
  FOR i% = 32 TO 126
    IF _KEYDOWN(i%) THEN atoz% = 1: EXIT FOR
  NEXT

  accum& = bksp% + tb% + entr% + esc%
  accum& = accum& + f1% + f2% + f3% + f4% + f5% + f6% + f7% + f8% + f9% + f10% + f11% + f12%
  accum& = accum& + hm% + pgup% + del% + ed% + pgdn% + up% + dn% + lt% + rt%
  accum& = accum& + num% + caps% + rshift% + lshift% + rctrl% + lctrl% + ralt% + lalt%
  accum& = accum& + atoz%

  IF accum& THEN
    KeyDown% = -1
  ELSE
    KeyDown% = 0
  END IF

END FUNCTION

SUB Motion(Value%)
  ERROR 73 ' Feature Unavailable
END SUB

SUB Mouse(AX%, BX%, CX%, DX%)
  ERROR 73 ' Feature Unavailable
END SUB

' MouseRange will return a range number that tells where the mouse 
' cursor is located, based on an array of screen coordinates. 
SUB MouseRange(array() AS Area, Start%, numEls%, row%, col%, button%, rangeNum%)
  ERROR 73 ' Feature Unavailable
END SUB

FUNCTION MBuffSize%
  ERROR 73 ' Feature Unavailable
END FUNCTION

SUB MGetState(Buffer$)
  ERROR 73 ' Feature Unavailable
END SUB

SUB MSetState(Buffer$)
  ERROR 73 ' Feature Unavailable
END SUB

' MouseTrap will establish the allowable range of movement for the mouse cursor. 
SUB MouseTrap(ulRow%, ulCol%, lrRow%, lrCol%)
  ' https://learn.microsoft.com/en-us/windows/win32/api/winuser/nf-winuser-clipcursor
  ' https://learn.microsoft.com/en-us/windows/win32/api/winuser/nf-winuser-getclipcursor
  ' https://learn.microsoft.com/en-us/windows/win32/menurc/using-cursors
  ERROR 73 ' Feature Unavailable
END SUB

' NumLock will quickly tell if the NumLock key is currently depressed. 
FUNCTION NumLock%
  ' Active receives -1 if the NumLock key is currently down, or O if it is not. 
  NumLock% = _NUMLOCK
END FUNCTION

' NumOff turns off the NumLock key status. 
SUB NumOff
  _NUMLOCK OFF
END SUB

' NumOn turns on the NumLock key status. 
SUB NumOn
  _NUMLOCK ON
END SUB

' PeekBuf provides a handy way to determine what key if any is the 
' next one pending in the keyboard buffer, without actually removing 
' it as INKEY$ does. 
FUNCTION PeekBuf%
  ' Char receives the ASCII value of the pending key if it is a normal 
  ' key, 0 if no keys are pending at all, or a negative value representing 
  ' an extended key's scan code. 
  PeekBuf% = INP(&H60)
END FUNCTION

SUB RptKey(Char%, Count%)
  ERROR 73 ' Feature Unavailable
END SUB

FUNCTION ScrlLock%
  ERROR 73 ' Feature Unavailable
END FUNCTION

SUB SetCursor(X%, Y%)
  ' https://learn.microsoft.com/en-us/windows/win32/menurc/using-cursors
  ERROR 73 ' Feature Unavailable
END SUB

FUNCTION ShiftKey%
  KEY_LSHIFT& = 100304
  KEY_RSHIFT& = 100303
  ShiftKey% = _KEYDOWN(KEY_LSHIFT&) OR _KEYDOWN(KEY_RSHIFT&)
END FUNCTION

SUB ShowCursor
  _MOUSESHOW
END SUB

SUB StuffBuf(X$)
  ERROR 73 ' Feature Unavailable
END SUB

' TextCursor provides an easy way to initialize the mouse cursor in 
' text mode, and define its color. 
SUB TextCursor(FG%, BG%)
  ' NOTE: I'm not sure that this is required (or is even possible)
  '       within the context of QB64 - for now, just stub.
END SUB

' FUNCTION WaitKey%
'   WHILE INKEY$ <> "": WEND ' Clear any pending key strokes.
'   WHILE INKEY$ = "": WEND ' Wait for a key.
'   ' TODO: Return the key value.
' END FUNCTION

' WaitKey first clears the keyboard buffer of any keys that may be 
' pending, and then waits until a key is pressed. 
SUB WaitKey
  WHILE INKEY$ <> "": WEND ' Clear any pending key strokes.
  WHILE INKEY$ = "": WEND ' Wait for a key.
END SUB

FUNCTION WaitScan%
  ERROR 73 ' Feature Unavailable
END FUNCTION

' WaitUp halts a program's execution until no mouse buttons are being depressed. 
SUB WaitUp
  DO
    Call GetCursor(x%, y%, button%)
  LOOP WHILE button%
END SUB

' **************************************
' Chapter 7 - Miscellaneous Routines
' **************************************

FUNCTION AddUSI%(X%, Y%)
  ' See ADDUSI.ASM
  ERROR 73 ' Feature Unavailable
END FUNCTION

SUB BCopy(FromSeg%, FromAddr%, ToSeg%, ToAddr%, NumBytes%, Direction%)
  ERROR 73 ' Feature Unavailable
END SUB

SUB BCopyT(FromEl, ToEl, ElSize%, NumEls%)
  ERROR 73 ' Feature Unavailable
END SUB

SUB BLPrint(LPTNumber%, X$, ErrorCount%)
  ERROR 73 ' Feature Unavailable
END SUB

' Chime provides five different types of beep tones, and five short 
' attention-getting trill sounds.
SUB Chime(number%)

  SELECT CASE number%
    CASE 1: QPSound 100, 5
    CASE 2: QPSound 200, 5
    CASE 3: QPSound 400, 5
    CASE 4: QPSound 800, 5
    CASE 5: QPSound 1600, 5
    CASE 6
      QPSound 659, 1
      QPSound 523, 1
      QPSound 659, 1
      QPSound 523, 1
    CASE 7
      FOR i = 300 TO 750 STEP 50
        QPSound i, 1
      NEXT
    CASE 8
      FOR i = 1000 TO 1700 STEP 100
        QPSound i, 1
      NEXT
    CASE 9
      FOR i = 1 TO 6
        QPSound 200 * i, 1
      NEXT
    CASE 10
      QPSound 220, 1
      QPSound 330, 1
      QPSound 440, 1
      QPSound 660, 1
      QPSound 880, 1
      QPSound 1319, 1
      QPSound 1760, 1
    CASE ELSE
  END SELECT

END SUB

SUB Clock(Row%, Column%, Colr%, Mode%)
  ERROR 73 ' Feature Unavailable
END SUB

SUB Clock24(Row%, Column%, Colr%, Mode%)
  ERROR 73 ' Feature Unavailable
END SUB

FUNCTION Compare%(Seg1%, Adr1%, Seg2%, Adr2%, NumBytes%)
  ERROR 73 ' Feature Unavailable
END FUNCTION

FUNCTION CompareT%(Type1, Type2, NumBytes%)
  ERROR 73 ' Feature Unavailable
END FUNCTION

FUNCTION Date2Day%(D$)
  ERROR 73 ' Feature Unavailable
END FUNCTION

FUNCTION Date2Num%(D$)
  ERROR 73 ' Feature Unavailable
END FUNCTION

FUNCTION DayName$(Day%)
  ERROR 73 ' Feature Unavailable
END FUNCTION

SUB DirTree(Tree$(), FullPath$(), Levels%)
  ERROR 73 ' Feature Unavailable
END SUB

FUNCTION EDate2Num%(Dat$)
  ERROR 73 ' Feature Unavailable
END FUNCTION

SUB Empty(dummy%)
  ERROR 73 ' Feature Unavailable
END SUB

FUNCTION ENum2Date%(Days%)
  ERROR 73 ' Feature Unavailable
END FUNCTION

FUNCTION Evaluate#(Expression$)
  ERROR 73 ' Feature Unavailable
END FUNCTION

SUB Extended
  ERROR 73 ' Feature Unavailable
END SUB

FUNCTION Factorial#(Number%)
  ERROR 73 ' Feature Unavailable
END FUNCTION

SUB FileView(FileName$, Ky%, Action%, FVInfo, Buffer%())
  ERROR 73 ' Feature Unavailable
END SUB

FUNCTION FudgeFactor&
  'TODO: 
  FudgeFactor& = 33814
END FUNCTION

FUNCTION GetCPU%
  ERROR 73 ' Feature Unavailable
END FUNCTION

FUNCTION GetDS%
  ERROR 73 ' Feature Unavailable
END FUNCTION

SUB GetEquip(Floppies%, Parallels%, Serials%)
  ERROR 73 ' Feature Unavailable
END SUB

SUB LockUp
  DO:LOOP
END SUB

FUNCTION MathChip%
  ERROR 73 ' Feature Unavailable
END FUNCTION

' MaxInt compares two integer variables, and returns the value of the 
' higher one. MaxLong is similar, but is intended for use with long 
' integers. 
FUNCTION MaxInt% (Num1%, Num2%)
  IF Num1% > Num2% THEN 
    MaxInt% = Num1% 
  ELSE 
    MaxInt% = Num2% 
  END IF 
END FUNCTION

FUNCTION MaxLong& (Num1&, Num2&)
  IF Num1& > Num2& THEN 
    MaxLong& = Num1& 
  ELSE 
    MaxLong& = Num2& 
  END IF 
END FUNCTION

' MidStrRest is a specialized version of the string manager
' routines StringRest, which are designed to save a MID$ 
' portion of a string array. 
SUB MidStrRest (buffer$, strNumber, storage%())
  ERROR 73 ' Feature Unavailable
END SUB

SUB MidStrSave (array$(), element%, numEls%, FirstChar%, numChars%, storage%())
  ERROR 73 ' Feature Unavailable
END SUB

SUB StringSave (array$(), stringElement%, array%(), integerElement%, numStrings%)
  ERROR 73 ' Feature Unavailable
END SUB

SUB Get1Str(work$, array%(), element%, stringNumber%)
  ERROR 73 ' Feature Unavailable
END SUB

FUNCTION StringSize&(array$(), start%, numStringEls%)
  ERROR 73 ' Feature Unavailable
END FUNCTION


' MinInt compares two integer variables, and returns the value of the 
' smaller one. MinLong is similar, but is intended for use with long 
' integers. 
FUNCTION MinInt% (Num1%, Num2%)
  IF Num1% < Num2% THEN 
    MinInt% = Num1% 
  ELSE 
    MinInt% = Num2% 
  END IF 
END FUNCTION

FUNCTION MinLong& (Num1&, Num2&)
  IF Num1% < Num2& THEN 
    MinLong& = Num1& 
  ELSE 
    MinLong& = Num2& 
  END IF 
END FUNCTION

FUNCTION MonthName$(Month%)
  ERROR 73 ' Feature Unavailable
END FUNCTION

SUB MsgBox(Message$, Wide%, Cfn)
  ERROR 73 ' Feature Unavailable
END SUB

FUNCTION Num2Date$(Day%)
  ERROR 73 ' Feature Unavailable
END FUNCTION

FUNCTION Num2Day%(D%)
  ERROR 73 ' Feature Unavailable
END FUNCTION

FUNCTION Num2Time$(Time&)
  ERROR 73 ' Feature Unavailable
END FUNCTION

' Pause will pause a program's execution for a specified period of 
' time to a resolution as small as 1/18th of a second. 
SUB Pause(ticks%)
  resolution! = 1 / 18.2
  _DELAY ticks% * resolution!
END SUB

' Pause2 will pause a program's execution for a specified number of microseconds. 
SUB Pause2(microseconds%)
  _DELAY microseconds% / 1000000
END SUB

' Pause3 provides a simple method for obtaining delays with a resolution
' of 1 millisecond, without having to reprogram the PC's timer chips
SUB Pause3 (milliseconds%, fudg&)
  ' milliseconds% is the desired number of milliseconds to delay, 
  ' and fudg& was previously obtained using the FudgeFactor function. 
  _DELAY milliseconds% / 1000
END SUB

' PDQTimer is an integer-only TIMER replacement that avoids the 
' inclusion of BASIC's floating point code in your programs. 
FUNCTION PDQTimer&
  ' The documentation sample suggests that the resolution is in 1/10th of a second.
  PDQTimer& = INT(TIMER * 10)
END FUNCTION

FUNCTION Peek1%(segment%, address%)
  SELECT CASE segment%
    CASE 0
      SELECT CASE address%
        CASE &H463 ' Color Monitor?
          ' IF Peek1%(0, &H463) <> &HB4 THEN ColorMon = 1   ' see what monitor is active
        CASE &H417 ' Capslock and Numlock status?
          result% = 0
          IF _CAPSLOCK THEN result% = result% + &H40
          IF _NUMLOCK THEN result% = result% + &H20
          Peek1% = result%
          ' CapStatus = Peek1%(0, &H417) AND &H40        'get BIOS status of Caps Lock
          ' NumStatus = Peek1%(0, &H417) AND &H20        'get BIOS status of Num Lock
          ' &H40 Capslock Active
          ' &H20 Numlock Active
        CASE ELSE
          ERROR 73 ' Feature Unavailable
      END SELECT
    CASE ELSE
      ERROR 73 ' Feature Unavailable
  END SELECT
END FUNCTION

FUNCTION Peek2%(Segment%, Address%)
  ERROR 73 ' Feature Unavailable
END FUNCTION

SUB Poke1(Segment%, Address%, Byte%)
  ERROR 73 ' Feature Unavailable
END SUB

SUB Poke2(Segment%, Address%, Word%)
  ERROR 73 ' Feature Unavailable
END SUB

FUNCTION Power(Y, N)
  Power = x ^ N
END FUNCTION

FUNCTION Power2(N)
  Power2 = 2 ^ N
END FUNCTION

FUNCTION PRNReady%(LPTNumber%)
  ERROR 73 ' Feature Unavailable
END FUNCTION

SUB PSwap
  ERROR 73 ' Feature Unavailable
END SUB

SUB QPCli
  ERROR 73 ' Feature Unavailable
END SUB

SUB QPSti
  ERROR 73 ' Feature Unavailable
END SUB

SUB QPPlay(Tune$)
  ERROR 73 ' Feature Unavailable
END SUB

' QPSound is nearly identical to BASIC's SOUND statement, but provides
' a considerable reduction in the amount of code added to a program. 
SUB QPSound(frequency%, duration%)
  ' The only real difference between QPSound and BASIC's SOUND is 
  ' that the sound is played in the "foreground" only. Where BASIC's 
  ' SOUND returns to your program immediately and continues to play 
  ' the tone in the background, QPSound waits until it has completed 
  ' before returning. QPSound is demonstrated in the QPSOUND.BAS 
  ' example program. 
  SOUND frequency%, duration%
  SOUND 20000, 1
END SUB

FUNCTION QPSegAdr&(Any$)
  ERROR 73 ' Feature Unavailable
END FUNCTION

FUNCTION QPSSeg%(Any$)
  ERROR 73 ' Feature Unavailable
END FUNCTION

FUNCTION QPUSI%(LongInt&)
  ERROR 73 ' Feature Unavailable
END FUNCTION

SUB Reboot
  ERROR 73 ' Feature Unavailable
END SUB

SUB ShiftIL(IntVar%, NumBits%)
  ERROR 73 ' Feature Unavailable
END SUB

SUB ShiftIR(IntVar%, NumBits%)
  ERROR 73 ' Feature Unavailable
END SUB

SUB ShiftLL(IntVar&, NumBits%)
  ERROR 73 ' Feature Unavailable
END SUB

SUB ShiftLR(IntVar&, NumBits%)
  ERROR 73 ' Feature Unavailable
END SUB

FUNCTION Soundex$(Word$)
  ERROR 73 ' Feature Unavailable
END FUNCTION

SUB SysTime(T$)
  ERROR 73 ' Feature Unavailable
END SUB

FUNCTION Time2Num&(T$)
  ERROR 73 ' Feature Unavailable
END FUNCTION

FUNCTION Times2%(Number%)
  ERROR 73 ' Feature Unavailable
END FUNCTION

FUNCTION TrapInt%(Value%, LoLimit%, HiLimit%)
  ERROR 73 ' Feature Unavailable
END FUNCTION

SUB ViewFile(FileName$, Wide%, High%, Colr%, HiBit%, Action%)
  ERROR 73 ' Feature Unavailable
END SUB

SUB VLAdd(Value1#, Value2#, Sum#, ErrFlag%)
  ERROR 73 ' Feature Unavailable
ENd SUB

SUB VLDiv(Dividend#, Divisor#, Quotient#, Remainder#, ErrFlag%)
  ERROR 73 ' Feature Unavailable
END SUB

SUB VLMul(Value1#, Value2#, Product#, ErrFlag%)
  ERROR 73 ' Feature Unavailable
END SUB

SUB VLPack(Number$, Value#, ErrFlag%)
  ERROR 73 ' Feature Unavailable
END SUB

SUB VLSub(Value1#, Value2#, Difference#, ErrFlag%)
  ERROR 73 ' Feature Unavailable
END SUB

SUB VLUnpack(Alias#, Number$, ErrFlag%)
  ERROR 73 ' Feature Unavailable
END SUB

FUNCTION WeekDay%(D$)
  ERROR 73 ' Feature Unavailable
END FUNCTION

SUB WordWrap(Message$, Wide%)
  ERROR 73 ' Feature Unavailable
END SUB

' ****************************************
' Chapter 8 - String Manipulation Routines
' ****************************************

' ASCII obtains the ASCII value for a string exactly as BASIC's ASC 
' function does, but it will not cause an "Illegal Function Call" error 
' if the string is null. 
FUNCTION ASCII% (Char$)
  ' See ASCII.ASM
  ASCII% = ASC(Char$)
END SUB

FUNCTION Blanks%(Work$)
  ERROR 73 ' Feature Unavailable
END FUNCTION

FUNCTION Compact$(Old$)
  ERROR 73 ' Feature Unavailable
END FUNCTION

SUB Encrypt(X$, PassWord$)
  ERROR 73 ' Feature Unavailable
END SUB

SUB Encrypt2(X$, PassWord$)
  ERROR 73 ' Feature Unavailable
END SUB

FUNCTION Far2Str$(Segment%, Address%)
  ERROR 73 ' Feature Unavailable
END FUNCTION

' FUsing accepts an incoming number and image string, and returns 
' it as a formatted string much like BASIC's PRINT USING would. 
FUNCTION FUsing$ (number$, image$)
  
  ' Number is any number whether integer, single, or double precision, 
  ' and Image$ indicates how the result is to be formatted. If the 
  ' number will not fit within the allotted space, the first digit of the 
  ' returned string will be replaced with a percent sign ( % ) . 

  ' It is very important that you not include any blank spaces within the 
  ' image string. For example "##.##" is perfectly legal, while 
  ' "## .##" will not work as expected. 

  ' The table below summarizes FUsing's capabilities: 

  '     # represents each digit position 
  '     . specifies a decimal point 
  '     + causes the sign of the number ( + or -) to be added (the 
  '       sign must be the first character in the field) 
  '    ** replaces leading spaces in the field with asterisks
  '    $$ adds a dollar sign to the left of the number  
  '   **$ combines the effects of ** and $$ 
  '     , specifies that commas are to be added to the formatted string
  
  ' FUsing is demonstrated in the DEMOCM.BAS example program. 
 
  ' Although BASIC accepts multiple commas in the image string, 
  ' FUsing requires only one. If there is a decimal point within the 
  ' string, the comma must be placed just before it. Otherwise, the 
  ' comma must be the last character. 

  result$ = ""

  number# = VAL(number$)
  format$ = image$

  IF INSTR(format$, "#") = 0 THEN using$ = format$ + "#"

  leadingPlus = LEFT$(format$, 1) = "+"
  dollarSign = INSTR(format$, "$") > 0
  doubleDollarSign = INSTR(format$, "$$") > 0
  asteriskFillDollarSign = INSTR(format$, "**$") > 0

  exponential = INSTR(format$, "^^^^") > 0
  trailingMinus = RIGHT$(format$, 1) = "-"
  hundreds = INSTR(format$, ",") > 0
  float = INSTR(format$, ".") > 0
  precision = 0

  IF float THEN
    positionStart = INSTR(format$, ".")
    positionEnd = positionStart + 1
    DO
      SELECT CASE MID$(format$, positionEnd, 1)
        CASE "#": positionEnd = positionEnd + 1
        CASE ELSE
          positionEnd = positionEnd -1
          EXIT DO
      END SELECT
      IF positionEnd > LEN(format$) THEN
        positionEnd = positionEnd - 1
        EXIT DO
      END IF
    LOOP
    precision = positionEnd - positionStart
  END IF

  length = _INSTRREV(format$, "#") - INSTR(format$, "#") + 1
  IF INSTR(format$, ".") > 0 AND INSTR(format$, ".") = INSTR(format$, "#") - 1 THEN
    ' Numeric format stars with a period...
    length = length + 1
  END IF
  IF asteriskFillDollarSign THEN
    length = length + 1
  ELSEIF asteriskFill THEN
    length = length + 2
  END IF
  IF exponential THEN length = length + 4
  IF NOT float THEN number# = CINT(number#)
  sign$ = " "
  IF number# < 0 THEN
    sign$ = "-"
  ELSEIF leadingPlus THEN
    sign$ = "+"
  END IF
  IF dollarSign THEN length = length + 1

  value$ = LTRIM$(STR$(ABS(number#)))

  IF float THEN
    IF INSTR(value$, ".") = 0 THEN ' a whole number, just extend decimal place as desired
      value$ = value$ + "." + STRING$(precision, "0")
    ELSE
      DO
        SELECT CASE LEN(value$) - _INSTRREV(value$, ".") 
          CASE IS > precision
            value$ = LEFT$(value$, LEN(value$) - 1)
          CASE IS < precision
            value$ = value$ + "0"
          CASE ELSE
            EXIT DO
        END SELECT
      LOOP
    END IF
  END IF
  IF hundreds THEN
    index% = INSTR(value$, ".")
    IF index% = 0 THEN index% = LEN(value$) ELSE index% = index% - 1
    DO
      index% = index% - 3
      IF index% < 1 THEN EXIT DO
      IF MID$(value$, index%, 1) <> "," THEN
        value$ = LEFT$(value$, index%) + "," + RIGHT$(value$, LEN(value$) - index%)
        index% = index%
      END IF
    LOOP
  END IF

  IF exponential THEN
    numericOnly$ = MID$(format$, INSTR(format$, "#"), _INSTRREV(format$, "#") - INSTR(format$, "#") + 1)
    CALL ReplaceString (numericOnly$, "#", "0")
    IF INSTR(format$, ".") > 0 AND INSTR(format$, ".") = INSTR(format$, "#") - 1 THEN
      numericOnly$ = "." + numericOnly$
    ELSE
      WHILE MID$(numericOnly$, 2, 1) = "0"
        numericOnly$ = MID$(numericOnly$, 2)
        IF LEN(numericOnly$) = 1 THEN EXIT WHILE
      WEND
    END IF
    value$ = LTRIM$(STR$(number#)) + "E+00"
  END IF

  IF length < LEN(value$) THEN result$ = result$ + "%"

  IF length > LEN(value$) THEN
    IF asteriskFill THEN
      IF sign$ <> " " THEN
        result$ = result$ + STRING$(length - LEN(value$) + 1, "*")
      ELSE
        result$ = result$ + STRING$(length - LEN(value$), "*")
      END IF
    ELSE
      result$ = result$ + STRING$(length - LEN(value$), " ")
    END IF
  END IF
  IF NOT trailingMinus AND sign$ <> " " THEN result$ = result$ + sign$
  IF dollarSign THEN result$ = result$ + "$"
  result$ = result$ + value$
  IF trailingMinus THEN result$ = result$ + sign$

  FUsing$ = result$

END FUNCTION

' InCount will quickly report how many times one string occurs 
' within another, and the case-sensitive search string may contain 
' any number of "?" wild cards. 
FUNCTION InCount%(Source$, SearchValue$)
  result% = 0
  pos1% = 1
  DO
    p% = QInstr%(pos1%, Source$, SearchValue$)
    IF p% > 0 THEN
      result% = result% + 1
      pos1% = p% + LEN(SearchValue$)
    ELSE
      EXIT DO
    END IF
  LOOP
  InCount% = result%
END FUNCTION

' InCount2 will quickly report how many times one string occurs 
' within another, and the case-insensitive search string may contain 
' any number of "?" wild cards. 
FUNCTION InCount2%(Source$, SearchValue$)
  result% = 0
  pos1% = 1
  DO
    p% = QInstr2%(pos1%, Source$, SearchValue$)
    IF p% > 0 THEN
      result% = result% + 1
      pos1% = p% + LEN(SearchValue$)
    ELSE
      EXIT DO
    END IF
  LOOP
  InCount2% = result%
END FUNCTION

FUNCTION InCountTbl%(Source$, Table$)
  ERROR 73 ' Feature Unavailable
END FUNCTION

FUNCTION InstrTbl%(Start%, Source$, Table$)
  ERROR 73 ' Feature Unavailable
END FUNCTION

FUNCTION InstrTbl2%(Start%, Source$, Table$)
  ERROR 73 ' Feature Unavailable
END FUNCTION

FUNCTION InstrTblB%(Start%, Source$, Table$)
  ERROR 73 ' Feature Unavailable
END FUNCTION

FUNCTION InstrTblB2%(Start%, Source$, Table$)
  ERROR 73 ' Feature Unavailable
END FUNCTION

FUNCTION LongestStr%(Array$())
  ERROR 73 ' Feature Unavailable
END FUNCTION

SUB LowASCII(X$)
  ERROR 73 ' Feature Unavailable
END SUB

SUB Lower(value$)
  value$ = LCASE$(value$)
END SUB

SUB LowerTbl(Work$, Table$)
  ERROR 73 ' Feature Unavailable
END SUB

FUNCTION MidChar%(Work$, Position%)
  ERROR 73 ' Feature Unavailable
END SUB

SUB MidCharS(Work$, Postion%, Char%)
  ERROR 73 ' Feature Unavailable
END SUB

FUNCTION NotInstr%(Start%, Searched$, Table$)
  ERROR 73 ' Feature Unavailable
END FUNCTION

FUNCTION Null%(Work$)
  ERROR 73 ' Feature Unavailable
END FUNCTION

FUNCTION ParseString$(CurPos%, Work$, DelimitValue$)
  ERROR 73 ' Feature Unavailable
END FUNCTION

SUB ProperName(Work$)
  ERROR 73 ' Feature Unavailable
END SUB

' QInstr serves the same purpose as BASIC's INSTR function, 
' except it accepts any number of "?" wild cards.
FUNCTION QInstr%(startPosition%, sourceValue$, searchValue$)

  ' Setting position to 0 will return 0; matching QB behavior.
  IF startPosition% = 0 THEN QInstr% = 0: EXIT FUNCTION

  position% = startPosition%
  DO
    segment$ = MID$(sourceValue$, position%, LEN(searchValue$))
    IF LEN(segment$) <> LEN(searchValue$) THEN EXIT DO
    isMatch% = 1
    FOR index = 1 TO LEN(searchValue$)
      character$ = MID$(searchValue$, index, 1)
      IF character$ <> "?" THEN
        IF MID$(segment$, index, 1) <> character$ THEN isMatch% = 0 : EXIT FOR
      END IF
      IF isMatch% THEN QInstr% = position% : EXIT FUNCTION
    NEXT
    position% = position% + 1
  LOOP

  QInstr% = 0

END FUNCTION

' QInstr2 serves the same purpose as BASIC's INSTR function, except 
' it accepts any number of "?" wild cards and it ignores capitalization 
' when examining the strings.
FUNCTION QInstr2%(startPosition%, sourceValue$, searchValue$)

  ' Setting position to 0 will return 0; matching QB behavior.
  IF startPosition% = 0 THEN QInstr2% = 0: EXIT FUNCTION

  position% = startPosition%
  DO
    segment$ = MID$(sourceValue$, position%, LEN(searchValue$))
    IF LEN(segment$) <> LEN(searchValue$) THEN EXIT DO
    isMatch% = 1
    FOR index% = 1 TO LEN(searchValue$)
      character$ = LCASE$(MID$(searchValue$, index%, 1))
      IF character$ <> "?" THEN
        IF LCASE$(MID$(segment$, index%, 1)) <> character$ THEN isMatch% = 0 : EXIT FOR
      END IF
      IF isMatch% THEN QInstr2% = position% : EXIT FUNCTION
    NEXT
    position% = position% + 1
  LOOP

  QInstr2% = 0

END FUNCTION

FUNCTION QInstrB%(StartPos%, Source$, SearchValue$)
  ERROR 73 ' Feature Unavailable
END FUNCTION

FUNCTION QInstrB2%(StartPos%, Source$, SearchValue$)
  ERROR 73 ' Feature Unavailable
END FUNCTION

SUB QInstrH(Segment%, Address%, SearchValue$, NumBytes&)
  ERROR 73 ' Feature Unavailable
END SUB

FUNCTION QPLeft$(text$, numChars%)
  QPLeft$ = LEFT$(text$, numChars%)
END FUNCTION

FUNCTION QPMid$(text$, startChar%, numChars%)
  IF numChars% = -1 THEN
    QPMid$ = MID$(text$, startChar%)
  ELSE
    QPMid$ = MID$(text$, startChar%, numChars%)
  END IF
END FUNCTION

FUNCTION QPRight$(text$, numChars%)
  QPRight$ = RIGHT$(text$, numChars%)
END FUNCTION

' QPLen serves the same purpose as BASIC's LEN function, but it is considerably faster.
FUNCTION QPLen%(text$)
  QPLen% = LEN(text$)
END FUNCTION

FUNCTION QPSadd%(Work$)
  ERROR 73 ' Feature Unavailable
END FUNCTION

FUNCTION QPStrI$(IntVar%)
  ERROR 73 ' Feature Unavailable
END FUNCTION

FUNCTION QPStrL$(LongInt&)
  ERROR 73 ' Feature Unavailable
END FUNCTION

FUNCTION QPTrim$(inputValue$)
  QPTrim$ = QPLTrim$(QPRTrim$(inputValue$))
END FUNCTION

FUNCTION QPLTrim$(inputValue$)
  result$ = inputvalue$
  DO
    IF LEN(result$) = 0 THEN EXIT DO
    ch$ = LEFT$(result$, 1)
    SELECT CASE ch$
      CASE CHR$(0), " " ', CHR$(9), CHR$(13), CHR$(10)
        result$ = RIGHT$(result$, LEN(result$) - 1)
      CASE ELSE: EXIT DO
    END SELECT
  LOOP
  QPLTrim$ = result$
END FUNCTION

FUNCTION QPRTrim$(inputValue$)
  result$ = inputvalue$
  DO
    IF LEN(result$) = 0 THEN EXIT DO
    ch$ = RIGHT$(result$, 1)
    SELECT CASE ch$
      CASE CHR$(0), " " ', CHR$(9), CHR$(13), CHR$(10)
        result$ = LEFT$(result$, LEN(result$) - 1)
      CASE ELSE: EXIT DO
    END SELECT
  LOOP
  QPRTrim$ = result$
END FUNCTION

FUNCTION QPValI% (X$)
  QPValI% = VAL(X$)
END FUNCTION

FUNCTION QPValL&(Work$)
  ERROR 73 ' Feature Unavailable
END FUNCTION

SUB RemCtrl(X$, Replace$)
  ERROR 73 ' Feature Unavailable
END SUB

' ReplaceChar replaces all occurrences of a specified character in a 
' string with a different character.
SUB ReplaceChar(sourceValue$, oldValue$, newValue$)
  oldChar$ = LEFT$(oldValue$, 1)
  newChar$ = LEFT$(newValue$, 1)
  ReplaceString sourceValue$, oldChar$, newChar$
END SUB

' ReplaceChar2 replaces all occurrences of a specified character in a 
' string with a different character while ignoring capitalization. 
SUB ReplaceChar2(sourceValue$, oldValue$, newValue$)
  oldChar$ = LEFT$(oldValue$, 1)
  newChar$ = LEFT$(newValue$, 1)
  ReplaceString2 sourceValue$, oldChar$, newChar$
END SUB

' SUB ReplaceCharT(typeVar as Any, typeLength%, oldChar%, newChar%)
' END SUB

' SUB ReplaceCharT2(typeVar as Any, typeLength%, oldChar%, newChar%)
' END SUB

' ReplaceString replaces all occurrences of a specified string with a 
' different string (case-sensitive). Both the string being searched 
' for and its replacement may be any length.
SUB ReplaceString (sourceValue$, oldValue$, newValue$) STATIC
  oldLen = LEN(oldValue$)
  newLen = LEN(newValue$)
  pointer = 1
Again:
  pointer = QInstr%(pointer, sourceValue$, oldValue$)' case-sensitive
  IF pointer THEN
    sourceValue$ = LEFT$(sourceValue$, pointer - 1) + newValue$ + MID$(sourceValue$, pointer + oldLen)
    pointer = pointer + newLen
    GOTO Again
  END IF
END SUB

' ReplaceString2 replaces all occurrences of a specified string with a 
' different string (case-insensitive). Both the string being searched 
' for and its replacement may be any length.
SUB ReplaceString2 (sourceValue$, oldValue$, newValue$) STATIC
  oldLen = LEN(oldValue$)
  newLen = LEN(newValue$)
  pointer = 1
Again:
  pointer = QInstr2%(pointer, sourceValue$, oldValue$)' case-insensitive
  IF pointer THEN
    sourceValue$ = LEFT$(sourceValue$, pointer - 1) + newValue$ + MID$(sourceValue$, pointer + oldLen)
    pointer = pointer + newLen
    GOTO Again
  END IF
END SUB

SUB ReplaceTbl(Work$, Table$)
  ERROR 73 ' Feature Unavailable
END SUB

SUB Sequence(Work$)
  ERROR 73 ' Feature Unavailable
END SUB

SUB Translate(X$)
  ERROR 73 ' Feature Unavailable
END SUB

SUB Upper(value$)
  value$ = UCASE$(value$)
END SUB

SUB UpperTbl(Work$, Table$)
  ERROR 73 ' Feature Unavailable
END SUB

' ****************************************
' Chapter 9 - Video Routines
' ****************************************

' APrint will quickly print any portion of a conventional (not 
' fixed-length) string array, and contain the display within a specified 
' area of the screen. 
SUB APrint(array$(), first%, numEls%, firstChar%, numChars%, colr%, page%)
  ' NOTE: page% is currently not implemented.
  ' If page% is -1, use current page.
  IF page% > -1 THEN SCREEN , , page%, page%
  row% = CSRLIN
  col% = POS(0)
  FOR element% = first% to first% + numEls% - 1
    value$ = MID$(array$(element%), firstChar%, numChars%)
    QPrintRC value$ + SPACE$(numChars% - LEN(value$)), row%, col%, colr%
    row% = row% + 1
  NEXT
END SUB

' APrint0 will quickly print any portion of a conventional (not 
' fixed-length) string array, and contain the display within a specified 
' area of the screen. 
SUB APrint0(array$(), first%, numEls%, firstChar%, numChars%, colr%)
  CALL APrint(array$(), first%, numEls%, firstChar%, numChars%, colr%, 0)
END SUB

' APrintT will quickly print any portion of a fixed-length string array 
' or the string component of a TYPE array, and contain the display 
' within a specified area of the screen. 
SUB APrintT(array$(), first%, elSize%, numEls%, firstChar%, numChars%, colr%, page%)
  CALL APrint(array$(), first%, numEls%, firstChar%, numChars%, colr%, page%)
END SUB

' APrintT0 will quickly print any portion of a fixed-length string 
' array or the string component of a TYPE array, and contain the 
' display within a specified area of the screen. 
SUB APrintT0(array$(), first%, elSize%, numEls%, firstChar%, numChars%, colr%)
  ERROR 73 ' Feature Unavailable
END SUB

' ArraySize will quickly calculate how many elements are needed in an
' integer array that is intended to hold a portion of the display screen.
FUNCTION ArraySize%(ulRow%, ulCol%, lrRow%, lrCol%)
  ArraySize% = (lrRow% - ulRow% + 1) * (lrCol% - ulCol% + 1)
END FUNCTION

' Box will quickly draw a box frame on the screen. 
SUB Box(ulRow%, ulCol%, lrRow%, lrCol%, char%, colr%, page%)
  ' NOTE: page% isn't currently implemented
  ' If page% = -1 then use current active page.
  SELECT CASE char%
    CASE 1 ' single line all around
      ' first row
      QPrintRC CHR$(218), ulRow%, ulCol%, colr%
      QPrintRC STRING$((lrCol% - ulCol%) - 1, 196), ulRow%, ulCol% + 1, colr%
      QPrintRC CHR$(191), ulRow%, lrCol%, colr%
      ' middle
      FOR r% = ulRow% + 1 TO lrRow% - 1
        QPrintRC CHR$(179), r%, ulCol%, colr%
        QPrintRC CHR$(179), r%, lrCol%, colr%
      NEXT
      ' last row
      QPrintRC CHR$(192), lrRow%, ulCol%, colr%
      QPrintRC STRING$((lrCol% - ulCol%) - 1, 196), lrRow%, ulCol% + 1, colr%
      QPrintRC CHR$(217), lrRow%, lrCol%, colr%
    CASE 2 ' double line all around
      ' first row
      QPrintRC CHR$(201), ulRow%, ulCol%, colr%
      QPrintRC STRING$((lrCol% - ulCol%) - 1, 205), ulRow%, ulCol% + 1, colr%
      QPrintRC CHR$(187), ulRow%, lrCol%, colr%
      ' middle
      FOR r% = ulRow% + 1 TO lrRow% - 1
        QPrintRC CHR$(186), r%, ulCol%, colr%
        QPrintRC CHR$(186), r%, lrCol%, colr%
      NEXT
      ' last row
      QPrintRC CHR$(200), lrRow%, ulCol%, colr%
      QPrintRC STRING$((lrCol% - ulCol%) - 1, 205), lrRow%, ulCol% + 1, colr%
      QPrintRC CHR$(188), lrRow%, lrCol%, colr%
    CASE 3 ' double line horizontally, single line vertically
      ' first row
      QPrintRC CHR$(213), ulRow%, ulCol%, colr%
      QPrintRC STRING$((lrCol% - ulCol%) - 1, 205), ulRow%, ulCol% + 1, colr%
      QPrintRC CHR$(184), ulRow%, lrCol%, colr%
      ' middle
      FOR r% = ulRow% + 1 TO lrRow% - 1
        QPrintRC CHR$(179), r%, ulCol%, colr%
        QPrintRC CHR$(179), r%, lrCol%, colr%
      NEXT
      ' last row
      QPrintRC CHR$(212), lrRow%, ulCol%, colr%
      QPrintRC STRING$((lrCol% - ulCol%) - 1, 205), lrRow%, ulCol% + 1, colr%
      QPrintRC CHR$(190), lrRow%, lrCol%, colr%
    CASE 4 ' single line horizontally, double line vertically
      ' first row
      QPrintRC CHR$(214), ulRow%, ulCol%, colr%
      QPrintRC STRING$((lrCol% - ulCol%) - 1, 196), ulRow%, ulCol% + 1, colr%
      QPrintRC CHR$(183), ulRow%, lrCol%, colr%
      ' middle
      FOR r% = ulRow% + 1 TO lrRow% - 1
        QPrintRC CHR$(186), r%, ulCol%, colr%
        QPrintRC CHR$(186), r%, lrCol%, colr%
      NEXT
      ' last row
      QPrintRC CHR$(211), lrRow%, ulCol%, colr%
      QPrintRC STRING$((lrCol% - ulCol%) - 1, 196), lrRow%, ulCol% + 1, colr%
      QPrintRC CHR$(189), lrRow%, lrCol%, colr%
    CASE ELSE ' ASCII character will be used for entire box
      ' first row
      QPrintRC CHR$(char%), ulRow%, ulCol%, colr%
      QPrintRC STRING$((lrCol% - ulCol%) - 1, char%), ulRow%, ulCol% + 1, colr%
      QPrintRC CHR$(char%), ulRow%, lrCol%, colr%
      ' middle
      FOR r% = ulRow% + 1 TO lrRow% - 1
        QPrintRC CHR$(char%), r%, ulCol%, colr%
        QPrintRC CHR$(char%), r%, lrCol%, colr%
      NEXT
      ' last row
      QPrintRC CHR$(char%), lrRow%, ulCol%, colr%
      QPrintRC STRING$((lrCol% - ulCol%) - 1, char%), lrRow%, ulCol% + 1, colr%
      QPrintRC CHR$(char%), lrRow%, lrCol%, colr%
  END SELECT
END SUB

' Box0 will quickly draw a box frame on the screen.
SUB Box0(ulRow%, ulCol%, lrRow%, lrCol%, char%, colr%)
  CALL Box(ulRow%, ulCol%, lrRow%, lrCol%, char%, colr%, 0)
END SUB

' BPrint will print either a conventional or fixed-length string at the 
' current cursor position through DOS. 
SUB BPrint(X$)
  PRINT X$;
END SUB

' ClearEOL (Clear to End of Line) erases the current screen line 
' starting at the current cursor position. 
SUB ClearEOL(clr%)
  ' colr% specifies the display color. 
  ' If -1 is used for Colr%, the current screen 
  ' colors will be maintained. 
  r% = CSRLIN
  c% = POS(0)
  columns% = _WIDTH
  QPrintRC Space$(columns% - c%), r%, c%, clr% 
END SUB

SUB ClearScr (ulRow%, ulCol%, lrRow%, lrCol%, colr%, page%)
  ' NOTE: page% is currently not implemented.
  ' page% of -1 is "current page"
  FOR r = ulRow% TO lrRow%
    FOR c = ulCol% TO lrCol%
      QPrintRC " ", r, c, colr%
    NEXT
  NEXT
END SUB

SUB ClearScr0 (ulRow%, ulCol%, lrRow%, lrCol%, colr%)
  FOR r = ulRow% TO lrRow%
    FOR c = ulCol% TO lrCol%
      QPrintRC " ", r, c, colr%
    NEXT
  NEXT
END SUB

' FillScrn will fill any rectangular portion of the display screen with 
' the specified character. 
SUB FillScrn(ulRow%, ulCol%, lrRow%, lrCol%, colr%, char%, page%)
  ' NOTE: page% is currently not implemented.
  ' If page% = -1 then current active page is used.
  FOR r% = ulRow% TO lrRow%
    QPrintRC STRING$(lrCol% - ulCol% + 1, char%), r%, ulCol%, colr%
  NEXT
END SUB

' Fil1Scrn0 will fill any rectangular portion of the display screen with 
' the specified character. 
SUB FillScrn0(ulRow%, ulCol%, lrRow%, lrCol%, colr%, char%)
  CALL FillScrn (ulRow%, ulCol%, lrRow%, lrCol%, colr%, char%, 0)
END SUB

' GetVMode will report the current video mode, the currently active 
' display page, the page size, and the number of rows and columns. 
SUB GetVMode (mode%, page%, pageSize%, rows%, columns%)
  'TODO: Need to implement other values.
  columns% = _WIDTH
  rows% = _HEIGHT
END SUB

FUNCTION Monitor%
  ' NOTE: The documentation for QPrintAny() and Monitor% don't appear to align????
  Monitor% = 7 ' VGA adapter with a color monitor.
END FUNCTION

' MPaintBox is similar to PaintBox, except it always turns off the 
' mouse cursor before painting the screen. When it is finished the 
' cursor is turned back on. 
SUB MPaintBox (ulRow%, ulCol%, lrRow%, lrCol%, colr%)
  ' Paint a portion of the screen; leaving text intact (only change color).
  CALL PaintBox0 (ulRow%, ulCol%, lrRow%, lrCol%, colr%)
END SUB

SUB MPRestore(ulRow%, ulCol%, lrRow%, lrCol%, originalWidth%, array%(), start%)
  ERROR 73 ' Feature Unavailable
END SUB

' MQPrint is similar to QPrint, except it always turns off the mouse cursor
' before printing. When it is finished the cursor is turned back on. 
SUB MQPrint (txt$, colr%)
  ofg% = -1: obg% = -1
  IF colr% = -1 THEN
    ' Maintain existing color...
  ELSE
     ofg% = _DEFAULTCOLOR: obg% = _BACKGROUNDCOLOR
     SplitColor colr%, fg%, bg%
     COLOR fg%, bg%
  END IF
  pr% = CSRLIN
  pc% = POS(0)
  PRINT txt$;
  LOCATE pr%, pc%
  IF ofg% <> -1 AND obg% <> -1 THEN
    COLOR ofg%, obg%
  END IF
END SUB

' MScrnRest is similar to ScrnRest, except it always turn off 
' the mouse cursor while it is working. 
SUB MScrnRest (ulRow%, ulCol%, lrRow%, lrCol%, element%())
  ScrnRest0 ulRow%, ulCol%, lrRow%, lrCol%, element%()
END SUB

' MScrnSave is similar to ScrnSave, except it always turn off 
' the mouse cursor while it is working. 
SUB MScrnSave (ulRow%, ulCol%, lrRow%, lrCol%, element%())
  'TODO: Capture the region for restoration later.
  ScrnSave0 ulRow%, ulCol%, lrRow%, lrCol%, element%()
END SUB

FUNCTION OneColor% (fg%, bg%)
  OneColor% = (fg% AND 16) * 8 + ((bg% AND 7) * 16) + (fg% AND 15)
END FUNCTION

' PaintBox will paint any rectangular area of the screen, without 
' disturbing the text that is already present. 
SUB PaintBox (ulRow%, ulCol%, lrRow%, lrCol%, colr%, page%)
  ' NOTE: page% isn't currently used.
  ' If page% = -1 then current active screen should be used.
  FOR r = ulRow% TO lrRow%
    FOR c = ulCol% TO lrCol%
      ch = SCREEN(r, c)
      QPrintRC CHR$(ch), r, c, colr%
    NEXT
  NEXT
END SUB

' PaintBox0 will paint any rectangular area of the screen, without 
' disturbing the text that is already present. 
SUB PaintBox0 (ulRow%, ulCol%, lrRow%, lrCol%, colr%)
  CALL PaintBox (ulRow%, ulCol%, lrRow%, lrCol%, colr%, 0)
END SUB

SUB QPrint (text$, colr%, page%)
  ofg% = -1: obg% = -1
  IF colr% = -1 THEN
    ' Maintain existing color...
  ELSE
    ofg% = _DEFAULTCOLOR: obg% = _BACKGROUNDCOLOR
    SplitColor colr%, fg%, bg%
    COLOR fg%, bg%
  END IF
  pr% = CSRLIN
  pc% = POS(0)
  PRINT text$;
  LOCATE pr%, pc%
  IF ofg% <> -1 AND obg% <> -1 THEN
    COLOR ofg%, obg%
  END IF
END SUB

SUB QPrint0 (text$, colr%)
  ofg% = -1: obg% = -1
  IF colr% = -1 THEN
    ' Maintain existing color...
  ELSE
     ofg% = _DEFAULTCOLOR: obg% = _BACKGROUNDCOLOR
     SplitColor colr%, fg%, bg%
     COLOR fg%, bg%
  END IF
  pr% = CSRLIN
  pc% = POS(0)
  PRINT text$;
  LOCATE pr%, pc%
  IF ofg% <> -1 AND obg% <> -1 THEN
    COLOR ofg%, obg%
  END IF
END SUB

' QPrintAny provides a simple way for a BASIC program to utilize 
' two monitors at the same time. 
SUB QPrintAny (txt$, clr%, monCode%, row%, column%)
  ' NOTE: monCode% is currently not active.
  '       1 - Monochrome monitor at segment &HB000
  '       2 - CGA monitor at segment &HB800
  '       3 - EGA or VGA monitor at segment &HB800
  ofg% = -1: obg% = -1
  IF clr% = -1 THEN
    ' Maintain existing color...
  ELSE
     ofg% = _DEFAULTCOLOR: obg% = _BACKGROUNDCOLOR
     SplitColor clr%, fg%, bg%
     COLOR fg%, bg%
  END IF
  pr% = CSRLIN
  pc% = POS(0)
  LOCATE row%, column%
  PRINT txt$;
  LOCATE pr%, pc%
  IF ofg% <> -1 AND obg% <> -1 THEN
    COLOR ofg%, obg%
  END IF
END SUB

SUB QPrintRC (txt$, r%, c%, clr%)
  ofg% = -1: obg% = -1
  IF clr% = -1 THEN
    ' Maintain existing color...
  ELSE
     ofg% = _DEFAULTCOLOR: obg% = _BACKGROUNDCOLOR
     SplitColor clr%, fg%, bg%
     COLOR fg%, bg%
  END IF
  pr% = CSRLIN
  pc% = POS(0)
  LOCATE r%, c%
  PRINT txt$;
  LOCATE pr%, pc%
  IF ofg% <> -1 AND obg% <> -1 THEN
    COLOR ofg%, obg%
  END IF
END SUB

' ReadScrn will quickly read characters from the display screen, and 
' store them in a specified string variable. 
SUB ReadScrn (row%, column%, x$, page%)
  ' row% and column% tell ReadScrn where on the screen the 
  ' characters are located, x$ receives the screen contents, and page% 
  ' indicates which video page to read. If Page% is set to -1, then 
  ' ReadScrn will read from the currently active screen page. 
  ' The number of characters to be read is specified by the length of X$.
  FOR c% = column% TO column% + LEN(x$) - 1
    MID$(x$, c% - column% + 1, 1) = CHR$(SCREEN(row%, c%))
  NEXT
END SUB

' ReadScrn0 will quickly read characters from the display screen, 
' and store them in a specified string variable. 
SUB ReadScrn0 (row%, column%, x$)
  ' Row% and Column% tell ReadScrn0 where on the screen the 
  ' characters are located, and X$ receives the screen contents. 
  ' The number of characters to read is specified by the length of X$. 
  CALL ReadScrn (row%, column%, x$, 0)
END SUB

' ScrnRest will restore a screen that had previously been saved with 
' ScrnSave or ScrnSave0. 
SUB ScrnRest (ulRow%, ulCol%, lrRow%, lrCol%, element%(), page%)
  ' NOTE: page% is currently not implemented
  rows% = (lrRow% - ulRow%) + 1
  cols% = (lrCol% - ulCol%) + 1
  FOR r% = 0 TO rows% - 1
    FOR c% = 0 TO cols% - 1
      index% = (r% * cols%) + c%
      clr% = element%(index%) AND &H00FF ' split color
      ch% = ((element%(index%) AND &HFF00) \ 256) AND &H00FF ' split character
      QPrintRC CHR$(ch%), ulRow% + r%, ulCol% + c%, clr%
    NEXT
  NEXT
END SUB

' ScrnRest0 will restore a screen that had previously been saved with 
' ScrnSave or ScrnSave0. 
SUB ScrnRest0 (ulRow%, ulCol%, lrRow%, lrCol%, element%())
  ScrnRest ulRow%, ulCol%, lrRow%, lrCol%, element%(), 0
END SUB

' ScrnSave will save all or part of a text screen into an integer array, 
' to allow restoring it again at a later time. 
SUB ScrnSave (ulRow%, ulCol%, lrRow%, lrCol%, element%(), page%)
  ' NOTE: page% is currently not implemented
  rows% = (lrRow% - ulRow%) + 1
  cols% = (lrCol% - ulCol%) + 1
  FOR r% = 0 TO rows% - 1
    FOR c% = 0 TO cols% - 1
      index% = (r% * cols%) + c%
      ch% = SCREEN(ulRow% + r%, ulCol% + c%, 0)
      clr% = SCREEN(ulRow% + r%, ulCol% + c%, 1)
      element%(index%) = (ch% * 256) + clr% ' combine
    NEXT
  NEXT
END SUB

' ScrnSave will save all or part of a text screen into an integer array, 
' to allow restoring it again at a later time. 
SUB ScrnSave0 (ulRow%, ulCol%, lrRow%, lrCol%, element%())
  ScrnSave ulRow%, ulCol%, lrRow%, lrCol%, element%(), 0
END SUB

' ScrollD will scroll any portion of the display screen down a 
' specified number of lines.
SUB ScrollD(ulRow%, ulCol%, lrRow%, lrCol%, lines%, page%)
  
  ' NOTE: page% is currently not implemented.
  ' If page% = -1 then current screen will be scrolled.

  tr% = (lrRow% - ulRow%) + 1
  IF tr% < lines% THEN
    ' If the number of lines to scroll is greater than the area to scroll, just clear.
    CALL ClearScr (ulRow%, ulCol%, lrRow%, lrCol%, -1, page%)
  ELSE
    DIM array%(ArraySize%(ulRow% + lines%, ulCol%, lrRow%, lrCol%))
    CALL ScrnSave (ulRow%, ulCol%, lrRow% - lines%, lrCol%, array%(), page%)
    CALL ScrnRest (ulRow% + lines%, ulCol%, lrRow%, lrCol%, array%(), page%)
    CALL ClearScr (ulRow%, ulCol%, ulRow% + (lines% - 1), lrCol%, -1, page%)
  END IF

END SUB

' ScrollL will scroll any portion of the display screen left a 
' specified number of columns.
SUB ScrollL(ulRow%, ulCol%, lrRow%, lrCol%, columns%, page%)

  ' NOTE: page% is currently not implemented.
  ' If page% = -1 then current screen will be scrolled.

  tc% = (lrCol% - ulCol%) + 1
  IF tc% < columns% THEN
    ' If the number of columns to scroll is greater than the area to scroll, just clear.
    CALL ClearScr (ulRow%, ulCol%, lrRow%, lrCol%, -1, page%)
  ELSE
    DIM array%(ArraySize%(ulRow%, ulCol% + columns%, lrRow%, lrCol%))
    CALL ScrnSave (ulRow%, ulCol% + columns%, lrRow%, lrCol%, array%(), page%)
    CALL ScrnRest (ulRow%, ulCol%, lrRow%, lrCol% - columns%, array%(), page%)
    CALL ClearScr (ulRow%, lrCol% - (columns% - 1), lrRow%, lrCol%, -1, page%)
  END IF

END SUB

' ScrollR will scroll any portion of the display screen right a 
' specified number of columns.
SUB ScrollR(ulRow%, ulCol%, lrRow%, lrCol%, columns%, page%)

  ' NOTE: page% is currently not implemented.
  ' If page% = -1 then current screen will be scrolled.

  tc% = (lrCol% - ulCol%) + 1
  IF tc% < columns% THEN
    ' If the number of columns to scroll is greater than the area to scroll, just clear.
    CALL ClearScr (ulRow%, ulCol%, lrRow%, lrCol%, -1, page%)
  ELSE
    DIM array%(ArraySize%(ulRow%, ulCol%, lrRow%, lrCol% - columns%))
    CALL ScrnSave (ulRow%, ulCol%, lrRow%, lrCol% - columns%, array%(), page%)
    CALL ScrnRest (ulRow%, ulCol% + columns%, lrRow%, lrCol%, array%(), page%)
    CALL ClearScr (ulRow%, ulCol%, lrRow%, ulCol% + (columns% - 1), -1, page%)
  END IF

END SUB

' ScrollU will scroll any portion of the display screen up a 
' specified number of lines.
SUB ScrollU(ulRow%, ulCol%, lrRow%, lrCol%, lines%, page%)

  ' NOTE: page% is currently not implemented.
  ' If page% = -1 then current screen will be scrolled.

  tr% = (lrRow% - ulRow%) + 1
  IF tr% < lines% THEN
    ' If the number of lines to scroll is greater than the area to scroll, just clear.
    CALL ClearScr (ulRow%, ulCol%, lrRow%, lrCol%, -1, page%)
  ELSE
    DIM array%(ArraySize%(ulRow%, ulCol%, lrRow% - lines%, lrCol%))
    CALL ScrnSave (ulRow% + lines%, ulCol%, lrRow%, lrCol%, array%(), page%)
    CALL ScrnRest (ulRow%, ulCol%, lrRow% - lines%, lrCol%, array%(), page%)
    CALL ClearScr (lrRow% - (lines% - 1), ulCol%, lrRow%, lrCol%, -1, page%)
  END IF

END SUB

SUB SplitColor (colr%, fg%, bg%)
  fg% = (colr% AND 128) \ 8 + (colr% AND 15) 
  bg% = (colr% AND 112) \ 16 
END SUB

' Chapter Next

FUNCTION BitShift% (value%, cmd$, bits%)
  mult% = 2
  SELECT CASE bits%
    CASE 1 ' already set
    CASE 2: mult% = 4
    CASE 3: mult% = 8
    CASE 4: mult% = 16
    CASE 5: mult% = 32
    CASE 6: mult% = 64
    CASE 7: mult% = 128
    CASE 8: mult% = 256
    CASE 9: mult% = 512
    CASE 10: mult% = 1024
    CASE 11: mult% = 2048
    CASE 12: mult% = 4096
    CASE 13: mult% = 8192
    CASE 14: mult% = 16384
    CASE 15: mult% = 32768
    CASE 16: mult% = 65536
    CASE ELSE
  END SELECT
  IF cmd$ = "<<" THEN ' "value%" has to be shifted "bits%" bit(s) to the left.
    ' formula: x = x * 2 ^ y
    BitShift% = ((value% * mult%) AND &HFFFF)
  ELSEIF cmd$ = ">>" THEN ' "value%" has to be shifted "bits%" bit(s) to the right.
    ' formula: x = x / 2 ^ y
    BitShift% = value% \ mult%
  END IF
END FUNCTION

' FUNCTION FRE%(value$)
'   RETURN 32768
' END FUNCTION

