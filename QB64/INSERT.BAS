' ********** INSERT.BAS - inserts a string into an array

' Copyright (c) 1988 Ethan Winer
' Modifications (c) 2022 Cory Smith

' rough timing on an 8MHz AT: 0.06 seconds to insert/delete 3000 elements

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
_TITLE "INSERT" 'NOTE: Moving title above resize causes resize to fail (without an error???)
'BUG: It would be nice specify the icon here, but... having to require full path or placing it in the qb64 folder is problematic. 
'NOTE: The above boiler plate must be first in execution (top of file).
'BUG:  Also appears to not work as an $INCLUDE; suggesting something might
'      be wrong with the implementation of $INCLUDE.
' **************************
' * BOILER PLATE END
' **************************

DEFINT A-Z

'$INCLUDE: 'PRO.BI'

DECLARE SUB InsertStr (BYVAL address, inserted$, size)
DECLARE SUB DeleteStr (BYVAL address, size)

CLS
PRINT TAB(15); "Before:"; TAB(50); "After:"

REDIM array$(10)
FOR x = 0 TO 10
  array$(x) = "Element Number" + STR$(x)
  LOCATE x + 3, 10
  PRINT array$(x)
NEXT
PRINT

Inserted$ = "This is inserted"
PRINT "Inserted$ = "; CHR$(34); inserted$; CHR$(34)

'----- Inserted$ goes in Array$(3), do seven elements (4 through 10 inclusive)

'InsertStr VARPTR(array$(3)), inserted$, 7
InsertStr array$(), 3, inserted$, 7

FOR x = 0 TO 10
  LOCATE x + 3, 45
  PRINT array$(x)
NEXT

PRINT
LOCATE , 45, 1
PRINT "Inserted$ = "; CHR$(34); inserted$; CHR$(34)
'PRINT
'PRINT "This proves we didn't corrupt BASIC's string heap:  ";
'PRINT "Free memory ="; FRE("")
LOCATE 25, 1
PRINT "Press a key to see the Delete demo: ";
CALL WaitKeyS

CLS
PRINT TAB(15); "Before:"; TAB(50); "After:"

REDIM array$(10)
FOR x = 0 TO 10
  array$(x) = "Element Number" + STR$(x)
  LOCATE x + 3, 10
  PRINT array$(x)
NEXT
PRINT

'----- we'll delete Array$(3), adjust seven elements (4 through 10 inclusive)

'DeleteStr VARPTR(array$(3)), 7
DeleteStr array$(), 3, 7

FOR x = 0 TO 10
  LOCATE x + 3, 45
  PRINT array$(x)
NEXT

' PRINT
' PRINT
' PRINT
' PRINT "This proves we didn't corrupt BASIC's string heap:  ";
' PRINT "Free memory ="; FRE("")

'$INCLUDE: 'PRO.BAS'