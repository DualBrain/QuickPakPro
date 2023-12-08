' ********** STRREST.BAS - restores a string array from an integer array

' Copyright (c) 1988 Ethan Winer
' Modifications (c) 2023 Cory Smith

#INCLUDE ONCE "PRO.BI" ' FindLastSM, GetNext, NumStrings, SetError, StringRest

SUB StringRestore (stringArray() As String, shortArray() As Short) STATIC

  Dim first As Short, last As Short, loEl As Short, hiEl As short
  Dim numBytes As Long
  Dim strAdr As Any Ptr, lastAdr As Short Ptr
  Dim numStr As Short, x As Short, thisLen As Short

  '----- Calculate the number of string elements in Array$()
  first = LBOUND(stringArray)
  last = UBOUND(stringArray)

  '----- Get the segment, address, and number of active bytes in the array
  loEl = LBOUND(shortArray)
  hiEl = UBOUND(shortArray)
  'StrSeg = VARSEG(Array(LoEl))
  strAdr = VARPTR(shortArray(loEl))

  SetError 0                    'clear the WhichError function
  numBytes = (hiEl - loEl + 1) * 2
  numBytes = FindLastSM(@shortArray(loEl), numBytes)
  'lastAdr = numBytes - VARPTR(shortArray(loEl))
  lastAdr = VARPTR(shortArray(loEl)) + numBytes

  '----- See if the string array has been dimensioned to enough elements
  numStr = NumStrings(@shortArray(loEl), numBytes)
  IF numStr > last - first + 1 THEN
    SetError 100               'not enough, set an error and exit
    EXIT SUB
  END IF

  '----- Make room in each string element.  The GetNext function is
  '      intended to be invoked successively, and it modifies the StrAdr
  '      variable to point to the next string in the integer array for
  '      the next time.  Do NOT use GetNext as part of a QuickBASIC watch
  '      variable/expression.
  FOR x = first TO first + numStr - 1
    thisLen = GetNext(strAdr, lastAdr)
    IF thisLen AND &H8000 THEN EXIT FOR     'GetNext returns -1 if it runs
    stringArray(x) = SPACE$(thisLen)             'out of data, "AND" is a very
  NEXT                                        'fast test for negative values

  '----- Copy the integer array into the string array
  StringRest VARPTR(stringArray(first)), @shortArray(loEl), numStr

END SUB