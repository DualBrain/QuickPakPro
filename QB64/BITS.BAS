' ********** BITS.BAS - allows creating and manipulating "bit" arrays

' Copyright (c) 1988 Ethan Winer
' Modifications (c) 2022 Cory Smith

' **************************
' * BOILER PLATE BEGIN
' **************************
$Resize:Stretch
CHDIR _STARTDIR$ ' Moved this line above resize to (hopefully) give more init time to window
IF _DesktopHeight => 2160 THEN mult = 4 ELSE IF _DesktopHeight => 1440 THEN mult = 2 ELSE mult = 1
DO: LOOP UNTIL _SCREENEXISTS ' Not sure if necessary; however, there does seem to be some sort of timing issue around getting hwnd
hwnd = _WindowHandle: x = 100: y = 100: w = 640 * mult: h = 480 * mult ' inlined _WindowHandle (next line) because 1 out of every 4 or 5 executions, would encounter an invalid window handle (1400)
IF INSTR(_OS$, "[WINDOWS]") THEN success = MoveWindow(_WindowHandle, x, y, w, h, 1) ELSE success = -1 ' Now that _WindowHandle is inlined, invalid window handle (1400) issue has yet to be reproduced - will have to continue to test
IF success = 0 THEN PRINT "FAILED TO RESIZE - "; GetLastError; " ("; hwnd; ")": CALL WaitKeyS
_TITLE "BITS" 'NOTE: Moving title above resize causes resize to fail (without an error???)
'BUG: It would be nice specify the icon here, but... having to require full path or placing it in the qb64 folder is problematic. 
'NOTE: The above boiler plate must be first in execution (top of file).
'BUG:  Also appears to not work as an $INCLUDE; suggesting something might
'      be wrong with the implementation of $INCLUDE.
' **************************
' * BOILER PLATE END
' **************************

DEFINT A-Z

'$INCLUDE: 'PRO.BI'

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