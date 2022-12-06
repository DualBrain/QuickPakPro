' ********** BITS.BAS - allows creating and manipulating "bit" arrays

' Copyright (c) 1988 Ethan Winer
' Modifications (c) 2022 Cory Smith

DEFINT A-Z

_TITLE "BITS"

'$INCLUDE: 'PRO.BI'

'_FULLSCREEN _SQUAREPIXELS

DECLARE SUB DimBits (Array$, Size)              ' dims a bit array
DECLARE SUB SetBit (Array$, BitNumber, Bit)     ' assigns to the bit array
DECLARE FUNCTION GetBit% (Array$, BitNumber)    ' returns elements from array

CLS
element = 195                    ' the element number to test
numEls = 5000                    ' use 5000 array elements
CALL DimBits(array$, numEls)     ' dim the array

FOR x = 0 TO numEls              ' show that it worked
  IF GetBit%(array$, x) THEN
    PRINT "Element"; x; "is set" ' should NOT be set right after DIMming
  END IF
NEXT

SetBit array$, element, 1       ' assign element = On
PRINT "Setting bit number"; element; "to On"

FOR x = 0 TO numEls             ' examine all of the elements to prove it works
  IF GetBit%(array$, x) THEN    ' should show only element number Element
    PRINT "Element"; x; "is set"
  END IF
NEXT

SUB DimBits (array$, size%)
  array$ = STRING$(size% \ 8 + 1, 0)        ' each character holds 8 bits
END SUB

'$INCLUDE: 'PRO.BAS'