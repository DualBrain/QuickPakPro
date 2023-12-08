' ********** FASTFILE.BAS - loads and saves files to and from string arrays

' Copyright (c) 1989 Don Malin
' Modifications (c) 2023 Cory Smith

#INCLUDE ONCE "PRO.BI" ' DOSError, FLof, StringSize, WhichError
                       ' FClose, FCreate, FGetA, FOpen, FPutA, SetError, StringSave

DECLARE SUB StringRestore (stringArray() As String, shortArray() As Short)

REDIM SHARED txt(0) As Short            'establish the array that will hold the retrieved file

'----- Load a file into an integer array and return the number of strings
FUNCTION FastLoadInt (fileName As String) As Short STATIC

  Dim handle As Short
  Dim errCode As Short
  Dim temp As Long, size As Long

  'SHARED txt()                                'this lets us use REDIM
  FOpen fileName, handle               'open the file
  IF DOSError THEN EXIT FUNCTION             'bail out if error
  errCode = 0                                 'assume no error

  temp = FLof(Handle)                       'get the length of the file
  ' IF temp > FRE("") - 1280& THEN             'is there enough string space?
  '   errCode = 14                             'no, set "Out of String Space"
  '   GOTO ExitFn                              '  error number and bail out
  ' ELSEIF Temp < 1 THEN                       'is this a Null file?
  IF temp < 1 THEN                       'is this a Null file?
    errCode = 62                             'yes, set "Input Past End"
    GOTO ExitFn                              '  error and bail out
  END IF                                      '  (this is what BASIC does)

  size = (temp + 1) \ 2                      'calc. the number of integer
                                                '  array elements required
  IF FRE(-1) - 1280& < size * 2& THEN         'is there enough far memory?
    ErrCode = 7                              'no, set "Out of Memory" error
    GOTO ExitFn                              'bail out
  END IF

  REDIM txt(1 TO size)                        'create a temporary array
  FGetA handle, @txt(1), temp           'read the file into the array

  errCode = WhichError                       'if an error, remember it
  IF NOT DOSError THEN                       'else return number of lines
    FastLoadInt = NumStrings(@txt(1), temp)
  END IF

ExitFn:
  FClose handle                         'close the file
  IF NOT DOSError THEN SetError errCode  'set (or clear) the error

END FUNCTION

'----- Copy an integer array to a string array
SUB FastLoadStr (text() As String) STATIC

  'SHARED txt()
  StringRestore text(), txt()  'StringRestore does the real work
  ERASE txt                           'Clean up far memory

END SUB

'----- Save a string array to disk
SUB FastSave (fileName As String, text() As String) STATIC

  Dim numEls As Short, loBound As Short
  Dim bytes As Long, size As Long, handle As Short, saveErr As Short

  numEls = UBOUND(text)      'find number of active elements - these
  loBound = LBOUND(text)     '  calculations accommodate any option base
  numEls = FindLast(VARPTR(text(numEls)), numEls) - loBound + 1
  FCreate fileName             'create the file
  IF DOSError THEN EXIT SUB          'exit if error

  '----- See how many bytes will be required in the integer array
  bytes = StringSize(VARPTR(text(loBound)), numEls)
  IF bytes = 0 THEN EXIT SUB         'the array is empty, so we're all done
  size = bytes / 2 + .1              'force round up

  IF FRE(-1) - 1280& < size * 2& THEN 'is there enough far memory?
    SetError 7                 'no, set "Out of Memory" error
    EXIT SUB                         'bail out
  END IF

  FOpen fileName, handle       'open the file for QuickPak Binary
  IF DOSError THEN EXIT SUB          'bail out if an error occured

  REDIM txt(1 TO size) As Short                        'make a temporary array
  StringSave VARPTR(text(loBound)), @txt(1), numEls  'save text to the array
  FPutA handle, @txt(1), bytes          'save the Int. array to file
  saveErr = WhichError                       'if an error, remember it
  FClose handle                         'close the file
  IF NOT DOSError THEN SetError saveErr   'recreate error if needed
  ERASE txt                                   'clean up far memory

END SUB