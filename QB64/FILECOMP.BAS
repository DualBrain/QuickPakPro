' ********* FILECOMP.BAS - compares two files

' Copyright (c) 1989 Ethan Winer
' Modifications (c) 2023 Cory Smith

DEFINT A-Z

DECLARE SUB FClose (handle)
DECLARE SUB FGetA (handle, SEG element AS ANY, numBytes)
DECLARE SUB FOpen (fileName$, handle)
DECLARE SUB SetError (errNum)

DECLARE FUNCTION CompareT% (SEG type1 AS ANY, SEG type2 AS ANY, numBytes)
DECLARE FUNCTION DOSError% ()
DECLARE FUNCTION FileComp% (file1$, file2$, errCode)
DECLARE FUNCTION FLof& (handle)
DECLARE FUNCTION WhichError% ()

TYPE FComp
  Info AS STRING * 4096
END TYPE

FUNCTION FileComp% (file1$, file2$, errCode)

  errCode = 0                         ' assume no errors for now
  CALL FOpen(file1$, handle1)         ' open the first file
  IF DOSError THEN                    ' if there was an error ...
    errCode = 1                       ' show that it happened on file one
    EXIT FUNCTION                     ' and exit
  END IF

  CALL FOpen(file2$, handle2)         ' open the second file
  IF DOSError% THEN                   ' if there was an error ...
    errCode = 2                       ' show that it happened on file two
    oldError = WhichError%            ' remember the error that just happened
    CALL FClose(handle1)              ' close the first file that's now open
    CALL SetError(oldError)           ' a successful FClose cancels DOSError,
    EXIT FUNCTION                     '   so set it again, and get out
  END IF

  fileSiz& = FLof&(handle1)           ' see how big the first file is
  IF fileSiz& = FLof&(handle2) THEN   ' they're the same size, continue
    fileComp% = -1                    ' assume they're the same
    bytesLeft& = fileSiz&             ' track how many bytes remain
    REDIM array(1 TO 2) AS FComp      ' make a far array to hold the files

    DO                                ' this is the main compare loop
      IF bytesLeft& <= 4096 THEN      ' if there's less than 4096 bytes left
        blockSize = bytesLeft&        ' read only what remains
      ELSE
        blockSize = 4096              ' otherwise, read a full 4096 bytes
      END IF

      'CALL FGetA(handle1, array(1), blockSize) ' get from the first file
      DIM block AS _MEM: block = _MEM(array(1)): CALL FGetA(handle1, block, blockSize): _MEMFREE block ' get from the first file
      IF DOSError% THEN                         ' an error occurred
        errCode = 1                             ' on the first file
        EXIT DO                                 ' get out
      END IF
      
      'CALL FGetA(handle2, array(2), blockSize)  ' get from the second file
      block = _MEM(array(2)): CALL FGetA(handle2, block, blockSize): _MEMFREE block  ' get from the second file
      IF DOSError% THEN                         ' an error occurred
        errCode = 2                             ' on the second file
        EXIT DO                                 ' get out
      END IF

      bytesLeft& = bytesLeft& - blockSize       ' show we did this many bytes

      'IF NOT CompareT%(array(1), array(2), blockSize) THEN   ' not the same
      DIM block1 AS _MEM: block1 = _MEM(array(1))
      DIM block2 AS _MEM: block2 = _MEM(array(2))
      result = CompareT%(block1, block2, blockSize)
      _MEMFREE block2: _MEMFREE block1
      IF NOT result THEN   ' not the same
        fileComp% = 0                 ' show that the compare failed
        EXIT DO                       ' and exit the loop
      END IF

    LOOP WHILE bytesLeft&             ' loop until the files have been fully examined
    ERASE array                       ' free up the memory
  ELSE                                ' the files are different sizes, so
    fileComp% = 0                     ' show that the compare failed
  END IF

  CALL FClose(handle1)                ' close both files
  CALL FClose(handle2)

END FUNCTION