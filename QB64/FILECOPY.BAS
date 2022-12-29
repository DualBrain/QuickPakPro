' ********** FILECOPY.BAS - demonstrates the FileCopy subprogram

' Copyright (c) 1988 Ethan Winer
' Modifications (c) 2022 Cory Smith

DEFINT A-Z

DECLARE SUB FileCopy (source$, dest$, copied, errFlag)
DECLARE SUB FCopy (source$, dest$, buffer$, errCode)
DECLARE SUB ReadFile (BYVAL address)
DECLARE SUB SetError (errCode)
DECLARE FUNCTION FCount% (spec$)
DECLARE FUNCTION DOSError% ()
DECLARE FUNCTION WhichError% ()
DECLARE FUNCTION FullName$ (partName$)

'---- please see DEMOCOPY.BAS for an example of using this routine

SUB FileCopy (source$, dest$, copied, errCode) STATIC

  '----- Source$ may include a drive letter, a path, or wild cards
  '----- Dest$ may be a drive or path name only
  FOR x = LEN(source$) TO 1 STEP -1   'search for a "\" or ":"
    IF MID$(source$, x, 1) = "\" OR MID$(source$, x, 1) = ":" THEN EXIT FOR
  NEXT
  path$ = LEFT$(source$, X)           ' path is anything up to "\"
  IF LEN(path$) AND RIGHT$(path$, 1) <> "\" AND RIGHT$(path$, 1) <> ":" THEN
    path$ = path$ + "\"
  END IF
 
  IF LEN(dest$) AND RIGHT$(dest$, 1) <> "\" AND RIGHT$(dest$, 1) <> ":" THEN
    dest$ = dest$ + "\"
  END IF
  errCode = 1                     ' an error here would be on the source
  count = FCount(source$)         ' count the number of matching files
  IF DOSError% THEN EXIT SUB      ' the door was open or something
  IF count = 0 THEN               ' there were no matching files
    CALL SetError(53)             ' show the caller that no files matched
    EXIT SUB                      ' and say goodbye
  END IF
  REDIM array$(0 TO count)        ' make an array to hold their names
  FOR x = 1 TO count              ' fill with spaces
    array$(x) = SPACE$(12)
  NEXT
  array$(0) = source$             ' put the spec into element zero
  'CALL ReadFile(VARPTR(array$(0)))    ' and use ReadFile to get them
  CALL ReadFile(array$())         ' and use ReadFile to get them
  'IF FRE("") > 4096 THEN
    buffLen = 4096               ' 4096 bytes is sufficient
  'ELSE
  '  buffLen = FRE(0) - 100 - 512     ' take all but a few bytes
  '  buffLen = (buffLen \ 512) * 512  ' round to a multiple of 512 bytes
  'END IF
  buffer$ = SPACE$(buffLen)           ' this will be FCopy's file buffer
  copied = 0                          ' track how many are actually copied
  FOR x = 1 TO count                  ' copy each file
    '-- Prevent copying a file on top of itself
    srcName$ = FullName$(path$ + array$(X))     ' get full path for source
    PRINT srcName$
    IF DOSError% THEN EXIT FOR                  ' exit loop if an error
    destName$ = FullName$(dest$ + array$(X))    ' get full path for dest
    PRINT destName$
    IF DOSError% THEN                           ' if an error occurs
      errCode = 2                               ' set errcode to dest
      EXIT FOR                                  ' and exit loop
    END IF
    IF srcName$ = destName$ THEN                ' if copying onto itself
      CALL SetError(70)                         ' return Permission denied
      EXIT FOR                                  ' and exit loop
    ELSE                                        ' otherwise
      CALL FCopy(srcName$, destName$, buffer$, errCode)  ' copy the file
      IF DOSError% THEN EXIT FOR                ' exit loop if an error
      copied = copied + 1             ' show that another one was copied
    END IF
  NEXT
  buffer$ = ""                        ' free up the memory
  ERASE array$                        '   ditto

END SUB