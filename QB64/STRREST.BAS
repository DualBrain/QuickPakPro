' ********** STRREST.BAS - restores a string array from an integer array

' Copyright (c) 1988 Ethan Winer
' Modifications (c) 2022 Cory Smith

DEFINT A-Z

DECLARE FUNCTION FindLastSM& (SEG element, numBytes AS ANY)
DECLARE FUNCTION GetNext% (strSeg, strAdr, lastAdr AS ANY)
DECLARE FUNCTION NumStrings% (SEG element, numBytes AS ANY)
DECLARE SUB SetError (errNum)
DECLARE SUB StringRest (BYVAL address, SEG element, numEls)

SUB StringRestore (array$(), array()) STATIC

  '----- Calculate the number of string elements in Array$()
  first = LBOUND(array$)
  last = UBOUND(array$)

  '----- Get the segment, address, and number of active bytes in the array
  loEl = LBOUND(array)
  hiEl = UBOUND(array)
  strSeg = VARSEG(array(loEl))
  strAdr = VARPTR(array(loEl))

  CALL SetError(0)                    ' clear the WhichError function
  numBytes& = (hiEl - loEl + 1) * 2&
  numBytes& = FindLastSM&(Array(loEl), numBytes&)
  lastAdr& = numBytes& - VARPTR(Array(loEl))

  '----- See if the string array has been dimensioned to enough elements
  numStr = NumStrings%(array(loEl), numBytes&)
  IF numStr > last - first + 1 THEN
    CALL SetError(100)                ' not enough, set an error and exit
    EXIT SUB
  END IF

  '----- Make room in each string element.  The GetNext function is
  '      intended to be invoked successively, and it modifies the StrAdr
  '      variable to point to the next string in the integer array for
  '      the next time.  Do NOT use GetNext as part of a QuickBASIC watch
  '      variable/expression.
  FOR x = first TO first + numStr - 1
    thisLen = GetNext%(strSeg, strAdr, lastAdr&)
    IF thisLen AND &H8000 THEN EXIT FOR       ' GetNext returns -1 if it runs
    array$(x) = SPACE$(thisLen)               ' out of data, "AND" is a very
  NEXT                                        ' fast test for negative values

  '----- Copy the integer array into the string array
  CALL StringRest(VARPTR(array$(first)), array(loEl), numStr)

END SUB