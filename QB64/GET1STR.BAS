' ********** GET1STR.BAS - retrieves a single string from an integer array

' Copyright (c) 1988 Ethan Winer
' Modifications (c) 2022 Cory Smith

DEFINT A-Z

DECLARE SUB Get1Str (work$, SEG element, strNumber)
DECLARE FUNCTION FindLastSM& (SEG element, numBytes AS ANY)
DECLARE FUNCTION Get1String$ (array%(), strNumber)
DECLARE FUNCTION StrLength% (SEG element, numBytes AS ANY, strNumber)

FUNCTION Get1String$ (array(), strNumber) STATIC

  ub = UBOUND(array)                              ' find the array bounds
  lb = LBOUND(array)
  numBytes& = (ub - lb + 1) * 2                   ' total bytes in Array
  numBytes& = FindLastSM&(array(lb), numBytes&)   ' ignore extra elements

  work$ = SPACE$(StrLength%(Array(lb), numBytes&, strNumber))
  CALL Get1Str(work$, array(lb), strNumber)       ' copy the string to Work$
  Get1String$ = work$                             ' assign the function

  work$ = ""                                      ' free up the memory

END FUNCTION