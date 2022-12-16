' ********** QSORT.BAS - sort routine algorithm demonstration

' Copyright (c) 1988 Ethan Winer, with special thanks to Eric Klien
' Modifications (c) 2022 Cory Smith

' This program illustrates the algorithm used by the QuickPak Professional
' assembler string sorts, and is provided solely for its educational value.
' Though it is set up to sort a single precision numeric array, it would
' be simple to modify for use with any variable type.  The demo illustrates
' how the sorting can be limited to only a portion of an array.

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
_TITLE "QSORT" 'NOTE: Moving title above resize causes resize to fail (without an error???)
'BUG: It would be nice specify the icon here, but... having to require full path or placing it in the qb64 folder is problematic. 
'NOTE: The above boiler plate must be first in execution (top of file).
'BUG:  Also appears to not work as an $INCLUDE; suggesting something might
'      be wrong with the implementation of $INCLUDE.
' **************************
' * BOILER PLATE END
' **************************

DEFINT A-Z

'$INCLUDE: 'PRO.BI'

DECLARE SUB QSort (array!(), startEl, numEls)

CLS

RANDOMIZE TIMER         ' this generates a fresh series of numbers each time

arrayLo = 1             ' set the array bounds
arrayHi = 20

DIM array!(arrayLo TO arrayHi)
FOR x = arrayLo TO arrayHi      ' make up some test numbers
  array!(x) = RND(1) * 999 + 1
NEXT

firstEl = 10                    ' sort only this portion of the array
numEls = 6                      ' the actual number of elements to be sorted

FOR x = arrayLo TO arrayHi      ' first print them before sorting
  IF x >= firstEl AND x <= firstEl + numEls - 1 THEN PRINT "==>";
  PRINT TAB(5); USING "###.##"; array!(x)
NEXT

CALL QSort(array!(), firstEl, numEls)

LOCATE 1
FOR x = arrayLo TO arrayHi      ' now print them after sorting
  LOCATE , 20
  IF x >= firstEl AND x <= firstEl + numEls - 1 THEN PRINT "==>";
  LOCATE , 25
  PRINT USING "###.##"; array!(x)
NEXT

SUB QSort (array!(), startElement, numOfElements) STATIC

  REDIM qStack(50)     ' create Stack (use 500 when sorting large arrays)

  s = 1                ' initialize work variables
  f = startElement
  l = startElement + numOfElements - 1

L1:
  temp! = array!((l + f) \ 2)         ' seek midpoint
  i = f
  j = l

L2:
  WHILE array!(i) < temp!: i = i + 1: WEND    ' use > for descending
  WHILE array!(j) > temp!: j = j - 1: WEND    ' use < for descending
  IF i > j GOTO L3
  IF i < j THEN SWAP array!(i), array!(j)
  i = i + 1: j = j - 1
  IF i <= j GOTO L2

L3:
  IF i < l THEN
    qStack(s) = i             ' Push I, L
    qStack(s + 1) = l
    s = s + 2
  END IF

  l = j
  IF f < l GOTO L1
  IF s = 1 GOTO L4
  s = s - 2                   ' Pop L, F
  f = qStack(s)
  l = qStack(s + 1)
  GOTO L1

L4:
  ERASE qStack                ' delete the temporary stack array

END SUB

'$INCLUDE: 'PRO.BAS'