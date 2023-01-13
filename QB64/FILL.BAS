' ********** FILL.BAS - demonstrates quickly filling numeric arrays

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
_TITLE "FILL" 'NOTE: Moving title above resize causes resize to fail (without an error???)
'BUG: It would be nice specify the icon here, but... having to require full path or placing it in the qb64 folder is problematic. 
'NOTE: The above boiler plate must be first in execution (top of file).
'BUG:  Also appears to not work as an $INCLUDE; suggesting something might
'      be wrong with the implementation of $INCLUDE.
' **************************
' * BOILER PLATE END
' **************************

'$INCLUDE: 'PRO.BI'

DECLARE SUB Fill2 (SEG arrayEl%, value%, size%)
DECLARE SUB Fill4 (SEG arrayEl!, value!, size%)
DECLARE SUB Fill8 (SEG arrayEl#, value#, size%)
DECLARE SUB AddInt (SEG arrayEl%, value%, size%)

REDIM array%(5000), array!(5000), array#(5000)

value% = 14
value! = 14.987
value# = 14.98723568#
size% = 5000                            ' number of bytes to fill

Fill2 array%(), 1, value%, size%          ' fill each array
Fill4 array!(), 1, value!, size%
Fill8 array#(), 1, value#, size%
   
CLS                                     'show that we got all of 'em
PRINT "             Element:        #1            #2500         #5000"
PRINT TAB(30); STRING$(40, 95)
PRINT
PRINT "Filled Integer Array:", array%(1), array%(2500), array%(5000)

PRINT
PRINT "Filled Single Precision:", array!(1), array!(2500), array!(5000)

PRINT
PRINT "Filled Double Precision:", array#(1), array#(2500), array#(5000)

PRINT
PRINT
PRINT "Here are elements 97 through 101:"
PRINT

size% = 2
value% = -87                            ' now let's do just a portion
value! = -87.904
value# = -.0007654#

Fill2 array%(), 99, value%, size%
Fill4 array!(), 99, value!, size%
Fill8 array#(), 99, value#, size%

PRINT array%(97), array%(98), array%(99), array%(100), array%(101)
PRINT array!(97), array!(98), array!(99), array!(100), array!(101)
PRINT array#(97), array#(98), array#(99), array#(100), array#(101)

value% = 2
size% = 5000

PRINT
PRINT
PRINT "Here's the integer array after adding"; value%; CHR$(29); ":"
PRINT
CALL AddInt(array%(), 1, value%, size%)
FOR x% = 97 TO 101
  PRINT array%(x%),
NEXT
PRINT
PRINT "(You can easily subtract from the array by using a negative number.)"

'$INCLUDE: 'PRO.BAS'