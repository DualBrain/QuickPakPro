' ************ MIDSTRSR.BAS - demos MidStrSR.Asm

' Copyright (c) 1989 Crescent Software
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
_TITLE "MIDSTRSR" 'NOTE: Moving title above resize causes resize to fail (without an error???)
'BUG: It would be nice specify the icon here, but... having to require full path or placing it in the qb64 folder is problematic. 
'NOTE: The above boiler plate must be first in execution (top of file).
'BUG:  Also appears to not work as an $INCLUDE; suggesting something might
'      be wrong with the implementation of $INCLUDE.
' **************************
' * BOILER PLATE END
' **************************

' MidStrSave and ImStrRest are routines similar to the original StringSave and
' StringRestore, but they are intended for use with a MID$ portion of a string
' array. They are not documented in the QuickPak Professional manual because
' they have no real application outside of the QEdit text editor.  In that
' program we use it to capture and restore text that has been marked in the
' column mode. The text is maintained in a far array (Storage in the examples
' below). We provide this demo merely for your amusement.

DEFINT A-Z

'$INCLUDE: 'PRO.BI'

DECLARE SUB MidStrSave (BYVAL address, numEls, firstChar, numChars, SEG storage)
DECLARE SUB MidStrRest (buffer$, strNumber, SEG storage)

CLS

numEls = 10
firstChar = 19
numChars = 10

DIM t$(numEls)
DIM storage((CLNG(numEls) * numChars) \ 2)

FOR x = 1 TO numEls
  t$(x) = "String" + STR$(x) + " testing number" + STR$(x)
  PRINT t$(x)
NEXT

'MidStrSave VARPTR(t$(1)), numEls, firstChar, numChars, storage(0)
MidStrSave t$(), 1, numEls, firstChar, numChars, storage(), 0
PRINT
buffer$ = SPACE$(numChars)
FOR strNumber = 1 TO 10
  'MidStrRest buffer$, strNumber, storage(0)
  MidStrRest buffer$, strNumber, storage(), 0
  PRINT "{"; buffer$; "}"
NEXT

'$INCLUDE: 'PRO.BAS'