' ********** INSERTT.BAS - demos InsertT and DeleteT

' Copyright (c) 1988 Ethan Winer
' Modifications (c) 2022 Cory Smith

' This demo requires starting QuickBASIC 4.0 with the /AH option

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
_TITLE "INSERTT" 'NOTE: Moving title above resize causes resize to fail (without an error???)
'BUG: It would be nice specify the icon here, but... having to require full path or placing it in the qb64 folder is problematic. 
'NOTE: The above boiler plate must be first in execution (top of file).
'BUG:  Also appears to not work as an $INCLUDE; suggesting something might
'      be wrong with the implementation of $INCLUDE.
' **************************
' * BOILER PLATE END
' **************************

DEFINT A-Z

'$INCLUDE: 'PRO.BI'

TYPE FLen
  Member AS SINGLE     'or INTEGER or LONG or STRING * n or whatever
END TYPE

DECLARE SUB InsertT (SEG element AS FLen, elSize, numEls)
DECLARE SUB DeleteT (SEG element AS FLen, elSize, numEls)

CLS

aSize = 5000
startEl = 3

' ElSize can also use a code for the type of array being operated on:
'
'  -1 = integer
'  -2 = single precision } <--- these two are interchangeable, and it
'  -3 = long integer     } <--- doesn't matter which you use
'  -4 = double precision
'  +N = TYPE array or fixed-length string with a variable size of N

elSize = -2
DIM array(aSize) AS FLen
numEls = UBOUND(array, 1) - startEl     ' insert/delete to the end of the array

FOR x = 0 TO aSize
  array(x).Member = x         ' use STR$(x) for fixed-length strings
NEXT

PRINT TAB(5); "Original"; TAB(30); "After Inserting"; TAB(60); "After Deleting"
PRINT
FOR x = 1 TO 10
  PRINT TAB(5); x; array(x).Member
NEXT
PRINT
FOR x = 4991 TO 5000
  PRINT TAB(5); x; array(x).Member
NEXT

'InsertT array(startEl), elSize, numEls  ' unREM one of these if you'd like
DIM block AS _MEM: block = _MEM(array(startEl))
InsertT block, elSize, numEls  ' unREM one of these if you'd like
_MEMFREE block

LOCATE 3
FOR x = 1 TO 10
  LOCATE , 30
  PRINT x; array(x).Member
NEXT
PRINT
FOR x = 4991 TO 5000
  LOCATE , 30
  PRINT x; array(x).Member
NEXT

'DeleteT array(startEl), elSize, numEls
block = _MEM(array(startEl))
DeleteT block, elSize, numEls
_MEMFREE block

LOCATE 3
FOR x = 1 TO 10
  LOCATE , 60
  PRINT x; array(x).Member
NEXT
PRINT
FOR x = 4991 TO 5000
  LOCATE , 60
  PRINT x; array(x).Member
NEXT

'$INCLUDE: 'PRO.BAS'