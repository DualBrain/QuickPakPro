'********* DATA.BAS - shows how to access string and numeric data in CS

'Copyright (c) 1988 Ethan Winer


'THIS PROGRAM CANNOT WORK IN THE QBX (BASIC 7) ENVIRONMENT.

DEFINT A-Z

'The special demonstration functions below all begin with "QP" to avoid
'a possible conflict with function or variable names in your programs.

DECLARE FUNCTION QPGetAdr1% ()  'gets the address for String1
DECLARE FUNCTION QPGetAdr2% ()  'gets the address for String2
DECLARE FUNCTION QPGetAdrI% ()  'gets the address for the integer array data
DECLARE FUNCTION QPGetLen1% ()  'gets the length for String1
DECLARE FUNCTION QPGetLen2% ()  'gets the length for String2
DECLARE FUNCTION QPGetLenI% ()  'gets the number of int array elements needed
DECLARE FUNCTION QPGetCS% ()    'gets the code segment for this data

DECLARE FUNCTION GetDS% ()      'gets QB's data segment for strings
DECLARE SUB BCopy (FromSeg, FromAddr, ToSeg, ToAddr, NumBytes, Direction)

CLS
ISize = QPGetLenI%
REDIM IArray(ISize)
CALL BCopy(QPGetCS%, QPGetAdrI%, VARSEG(IArray(1)), VARPTR(IArray(1)), ISize * 2, 0)
' OUTPUTS: 
'   1             12
'   2             103
'   3             32445
'   4            -8
'   5             17
'   6             567
'   7            -900
FOR X = 1 TO ISize
  PRINT X, IArray(X)
NEXT

PRINT
Size1 = QPGetLen1%
Normal1$ = SPACE$(Size1)
CALL BCopy(QPGetCS%, QPGetAdr1%, GetDS%, SADD(Normal1$), Size1, 0)
PRINT Normal1$ 'OUTPUTS: This is the first of two strings that are being stored within the Code Segment.

PRINT
Size2 = QPGetLen2%
Normal2$ = SPACE$(Size2)
CALL BCopy(QPGetCS%, QPGetAdr2%, GetDS%, SADD(Normal2$), Size2, 0)
PRINT Normal2$ 'OUTPUTS: This is the secon string we have store.

