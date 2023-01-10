' ********** SCANFILE.BAS

' Copyright (c) 1988 Ethan Winer
' Modifications (c) 2023 Cory Smith

DEFINT A-Z

DECLARE SUB FClose (handle)
DECLARE SUB FGet (handle, destination$)
DECLARE SUB FOpen (FileName$, handle)
DECLARE SUB FSeek (handle, location&)
DECLARE FUNCTION DOSError% ()
DECLARE FUNCTION WhichError% ()
DECLARE FUNCTION FLof& (handle)
DECLARE FUNCTION QInstr% (start, source$, search$)
DECLARE FUNCTION QInstr2% (start, source$, search$)
DECLARE FUNCTION ScanFile& (fileName$, text$, start&)

' The offset returned by ScanFile is based at one.  That is, if a match is
' found at the very first byte in the file, Offset& returns 1, not 0.

FUNCTION ScanFile& (fileName$, text$, start&) STATIC

  scanFile& = -1                        ' assume an error
  l = 0                                 ' ditto

  FOpen fileName$, handle               ' open the file for QuickPak Binary
  IF DOSError THEN EXIT FUNCTION        ' something bad must have happened
  length& = FLof(handle)                ' now get the file's length
  IF length& < 1 GOTO ExitFunction      ' can't search a zero-length file
  IF length& < LEN(text$) GOTO ExitFunction    ' text is longer than the file
                                               ' so it can't possibly be there
  bufSiz& = 4096                               ' 4096 evenly holds 8 sectors
  IF bufSiz& > length& THEN bufSiz& = length&  ' don't need more than Length&
  temp$ = SPACE$(bufSiz&)                      ' buffer for portions of file

  IF start& < 1 THEN start& = 1                ' trap illegal start values
  IF start& > length& GOTO ExitFunction        ' can't start past the end!

  lastSeek& = start& - 1                ' start searching where they asked
  baseAddr& = lastSeek&
  bytes = 0

  DO
    baseAddr& = baseAddr& + bytes       ' track the start of each block

    IF length& - lastSeek& >= bufSiz& THEN
      bytes = bufSiz&                   ' at least BufSiz& bytes still to do
    ELSE
      bytes = length& - lastSeek&       ' get just what remains
      temp$ = SPACE$(bytes)             ' FGet below uses LEN(Temp$) to know
    END IF                              '   how many bytes are to be read

    FSeek handle, lastSeek&             ' seek to that part of the file
    FGet handle, temp$                  ' read in a portion

    l = QInstr2%(1, temp$, text$)       ' search this portion of the file
    'l = QInstr%(1, temp$, text$)       ' or use this to honor capitalization

    IF l THEN EXIT DO                   ' we found it!

    IF lastSeek& + bufSiz& < length& THEN ' still more to examine
      baseAddr& = baseAddr& - LEN(text$)  ' back up to avoid missing Text$
                                          '  in case it straddles a boundary
      lastSeek& = baseAddr& + bytes       ' update the seek pointer
    ELSE
      EXIT DO                           ' no more to read, exit loop
    END IF

  LOOP                                  ' go examine some more

ExitFunction:
  FClose handle                         ' close the file

  IF l THEN
    scanFile& = baseAddr& + l           ' assign the function output
  ELSE
    scanFile& = 0                       ' no match was found
  END IF

  temp$ = ""                            ' free up the memory

END FUNCTION