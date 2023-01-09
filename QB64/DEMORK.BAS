' DEMORK.BAS - demonstrates hardware interrupt handling from within QuickBASIC

' written by Robert J. Karp
' Modifications (c) 2023 Cory Smith

'NOTE: Contrary to the printed manual, you can safely run this demo and also
'use the Clock and Clock24 routines safely in the BASIC editing environment.

'NOTE: QB64 appears to not honor ON TIMER during LINE INPUT (and possibly other methods)
'      So the Keyboard and Clock/24 methods will work as long as they are utilized in
'      a looping style environment. Not sure if there is another way to handle mimicking
'      the concept of "interrupts" - other than maybe through threads, but how to do that
'      in QB64 is a whole other set of questions.

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
_TITLE "DEMORK" 'NOTE: Moving title above resize causes resize to fail (without an error???)
'BUG: It would be nice specify the icon here, but... having to require full path or placing it in the qb64 folder is problematic. 
'NOTE: The above boiler plate must be first in execution (top of file).
'BUG:  Also appears to not work as an $INCLUDE; suggesting something might
'      be wrong with the implementation of $INCLUDE.
' **************************
' * BOILER PLATE END
' **************************

DEFINT A-Z

'$INCLUDE: 'PRO.BI'

DECLARE SUB Clock (row, column, colr, install)
DECLARE SUB Keyboard (row, column, color1, color2, install)
DECLARE SUB Dec2Bin (row, column)

' A binary conversion routine is the medium for showing this technique.

binary$ = "The binary value of ##### is ################."
number! = -1
COLOR 7, 0: WIDTH 80: CLS

'If you are using both routines, always install Keyboard first, then Clock.

Keyboard 25, 61, 7, 112, 1      ' row, col, off color, on color, install
Clock 1, 7, 7, 1                ' row, col, display color, install
Dec2Bin 1, 1                    ' the vehicle for this demo

CLS

number! = -1
Keyboard 1, 1, 7, 112, 1        ' calling a second time sets new loc and color
Clock 1, 70, 15, 1
Dec2Bin 1, 64

Clock 1, 1, 0, 0                ' uninstall in the reverse order
Keyboard 1, 1, 0, 0, 0

CLS

SUB Dec2Bin (row, column) STATIC

  SHARED binary$, number!

  LOCATE row, column
  PRINT "Time: "
  PRINT
  PRINT "DECIMAL TO BINARY CONVERSION"
  PRINT
  PRINT "Enter a number from 1 to 65535 or 0 to end: "

  WHILE number! <> 0
    LOCATE 5, 45
    PRINT SPACE$(35)
    LOCATE 5, 45
    LINE INPUT "", number$
    IF VAL(number$) >= 0 AND VAL(number$) < 65536 THEN
      number! = INT(VAL(number$))
      temp! = number!
      FOR i = 15 TO 0 STEP -1
        IF temp! < 2 ^ i THEN
          MID$(binary$, (45 - i)) = "0"
        ELSE
          MID$(binary$, (45 - i)) = "1"
          temp! = temp! - 2 ^ i
        END IF
      NEXT
      LOCATE 7, 1
      PRINT USING binary$; number!
    END IF
  WEND

END SUB

'$INCLUDE: 'PRO.BAS'