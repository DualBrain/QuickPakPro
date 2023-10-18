' ********** BITS.BAS - allows creating and manipulating "bit" arrays
' Copyright (c) 1988 Ethan Winer
' Modifications (c) 2023 Cory Smith

#INCLUDE ONCE "PRO.BI" ' SetBit, GetBit

DECLARE SUB DimBits (BYREF value AS STRING, size AS SHORT)

CLS

VAR element = 195                       ' the element number to test
VAR numEls = 5000                       ' use 5000 array elements
DIM array AS STRING
DIM x AS SHORT

DimBits array, numEls                   ' dim the array

FOR x = 0 TO numEls                     ' show that it worked
  IF GetBit(array, X) THEN
    PRINT "Element"; x; "is set"        ' should NOT be set right after DIMming
  END IF
NEXT

SetBit array, element, 1                ' assign element = On
PRINT "Setting bit number"; element; " to On"

FOR x = 0 TO numEls                     ' examine all of the elements to prove it works
  IF GetBit(array, X) THEN              ' should show only element number Element
    PRINT "Element"; x; " is set"
  END IF
NEXT

SUB DimBits (BYREF value AS STRING, size AS SHORT)
  value = STRING$(size \ 8 + 1, 0)  ' each character holds 8 bits
END SUB