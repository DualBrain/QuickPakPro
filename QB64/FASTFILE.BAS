' ********** FASTFILE.BAS - loads and saves files to and from string arrays

' Copyright (c) 1989 Don Malin
' Modifications (c) 2023 Cory Smith

DEFINT A-Z

DECLARE FUNCTION DOSError% ()
DECLARE FUNCTION FastLoadInt% (fileName$)
DECLARE FUNCTION FindLast% (BYVAL address, numEls)
DECLARE FUNCTION FLof& (handle)
DECLARE FUNCTION NumStrings% (SEG element, numBytes AS ANY)
DECLARE FUNCTION StringSize& (BYVAL address, lines)
DECLARE FUNCTION WhichError% ()

DECLARE SUB FClose (handle)
DECLARE SUB FCreate (fileName$)
DECLARE SUB FGetA (handle, SEG element, numBytes AS ANY)
DECLARE SUB FOpen (fileName$, Handle)
DECLARE SUB FPutA (handle, SEG element, numBytes AS ANY)
DECLARE SUB SetError (errCode)
DECLARE SUB StringRestore (array$(), array())
DECLARE SUB StringSave (BYVAL address, SEG element, numEls)

'REDIM txt(0)            ' establish the array that will hold the retrieved file

'----- Load a file into an integer array and return the number of strings
FUNCTION FastLoadInt% (fileName$) STATIC

  SHARED txt()                                ' this lets us use REDIM
  CALL FOpen(fileName$, handle)               ' open the file
  IF DOSError% THEN EXIT FUNCTION             ' bail out if error
  errCode = 0                                 ' assume no error

  temp& = FLof&(handle)                       ' get the length of the file
'   IF temp& > FRE("") - 1280& THEN             ' is there enough string space?
'     errCode = 14                              ' no, set "Out of String Space"
'     GOTO ExitFn                               '   error number and bail out
'   ELSEIF temp& < 1 THEN                       ' is this a Null file?
  IF temp& < 1 THEN                       ' is this a Null file?
    errCode = 62                              ' yes, set "Input Past End"
    GOTO ExitFn                               '   error and bail out
  END IF                                      '   (this is what BASIC does)

  size = (temp& + 1) \ 2                      ' calc. the number of integer
                                              '   array elements required
'   IF FRE(-1) - 1280& < size * 2& THEN         ' is there enough far memory?
'     errCode = 7                               ' no, set "Out of Memory" error
'     GOTO ExitFn                               ' bail out
'   END IF

  REDIM txt(1 TO size)                        ' create a temporary array
  'CALL FGetA(handle, txt(1), temp&)           ' read the file into the array
  CALL FGetA(handle, txt(), 1, temp&)           ' read the file into the array
  errCode = WhichError%                       ' if an error, remember it
  IF NOT DOSError% THEN                       ' else return number of lines
    'fastLoadInt% = NumStrings%(txt(1), temp&)
    fastLoadInt% = NumStrings%(txt(), 1, temp&)
  END IF

ExitFn:
  CALL FClose(handle)                         ' close the file
  IF NOT DOSError% THEN CALL SetError(errCode)' set (or clear) the error

END FUNCTION

'----- Copy an integer array to a string array
SUB FastLoadStr (text$()) STATIC
  SHARED txt()
  CALL StringRestore(text$(), txt())  ' StringRestore does the real work
  ERASE txt                           ' Clean up far memory
END SUB

'----- Save a string array to disk
SUB FastSave (fileName$, text$()) STATIC
    
   numEls = UBOUND(text$)      ' find number of active elements - these
   loBound = LBOUND(text$)     '   calculations accommodate any option base
   'numEls = FindLast%(VARPTR(text$(numEls)), numEls) - loBound + 1
   numEls = FindLast%(text$(), numEls, numEls) - loBound + 1
   CALL FCreate(fileName$)             ' create the file
   IF DOSError% THEN EXIT SUB          ' exit if error

   '----- See how many bytes will be required in the integer array
   'Bytes& = StringSize&(VARPTR(Text$(LoBound)), NumEls)
   bytes& = StringSize&(text$(), loBound, numEls)
   IF bytes& = 0 THEN EXIT SUB         ' the array is empty, so we're all done
   size = bytes& / 2 + .1              ' force round up

   ' IF FRE(-1) - 1280& < size * 2& THEN ' is there enough far memory?
   '   CALL SetError(7)                  ' no, set "Out of Memory" error
   '   EXIT SUB                          ' bail out
   ' END IF

   CALL FOpen(fileName$, handle)       ' open the file for QuickPak Binary
   IF DOSError% THEN EXIT SUB          ' bail out if an error occured
 
   REDIM txt(1 TO size)                ' make a temporary array
   'CALL StringSave(VARPTR(text$(loBound)), txt(1), numEls)  ' save text to the array
   CALL StringSave(text$(), loBound, txt(), 1, numEls)  ' save text to the array
   'CALL FPutA(handle, txt(1), bytes&)          ' save the Int. array to file
   CALL FPutA(handle, txt(), 1, bytes&)        ' save the Int. array to file
   saveErr = WhichError%                       ' if an error, remember it
   CALL FClose(handle)                         ' close the file
   IF NOT DOSError% THEN CALL SetError(saveErr) ' recreate error if needed
   ERASE txt                                   ' clean up far memory

END SUB