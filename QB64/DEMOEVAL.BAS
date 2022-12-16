' ********** DEMOEVAL.BAS - evaluates an equation to a double precision value

' Copyright (c) 1988 Crescent Software, Inc.
' Written by Paul Passarelli
' Revised 06/28/90
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
_TITLE "DEMOEVAL" 'NOTE: Moving title above resize causes resize to fail (without an error???)
'BUG: It would be nice specify the icon here, but... having to require full path or placing it in the qb64 folder is problematic. 
'NOTE: The above boiler plate must be first in execution (top of file).
'BUG:  Also appears to not work as an $INCLUDE; suggesting something might
'      be wrong with the implementation of $INCLUDE.
' **************************
' * BOILER PLATE END
' **************************

DEFINT A-Z

'$INCLUDE: 'PRO.BI'

DECLARE FUNCTION Evaluate# (equation$)

' NOTE: This routine understands the constant "e", therefore for exponential
'       notation be sure to use a capital "E" or "D".

LOCATE , , 1
CONST numSamples = 20
DIM sample$(numSamples)

DO

  CLS

  RESTORE
  FOR x = 1 TO numSamples
    READ sample$(x)
    '----- we can't read quotes, so here's sample expression #12:
    IF x = 12 THEN sample$(x) = CHR$(34) + "sample 1" + CHR$(34) + " = " + CHR$(34) + "SAMPLE 1" + CHR$(34)
    PRINT x; TAB(5); sample$(x)
  NEXT

  PRINT
  LINE INPUT "Which expression, or press Enter to type one: ", x$
  IF x$ = "" THEN
    LINE INPUT "Enter the expression: ", x$
  ELSE
    x$ = sample$(VAL(x$))
  END IF
  PRINT "That evaluates to: "; Evaluate#(x$);  ' here's how you invoke it

  IF x$ = sample$(14) THEN PRINT "00"

  IF LEFT$(x$, 1) = "%" THEN                   ' see if there was an error
    BEEP
    PRINT "Error in formula or overflow"
  END IF

  PRINT TAB(60); "Do again? (Y/N) ";
  x$ = INPUT$(1)
  
  IF UCASE$(x$) = "N" THEN END

LOOP

'---- sample expressions for testing

DATA "(2 / 2.3E2) * 2E3 * 0"
DATA "-(1+SQR(((2*3+45-41)+(5+(3*5)))*((2*3)+(800+60+4-800-60-5)))^2)"
DATA "(2 + 3)!"
DATA "170! - 169!-168!-167!"
DATA "e ^ LOG(4 * ATN(1))"
DATA "(1890 - 1890)!"
DATA "1+(1-3)^2+2+2"
DATA "(((((((-5))-3)))))"
DATA "sqr(sqr64*sqr64)*sqr(sqr64*sqr64)"
DATA "(3 * 4^2 + 1) / 7"
DATA "-1 + 2 * 3 / 4^5"
DATA ""                              : ' this is assigned above
DATA "(2^2)^8"
DATA "SIN-.2048686209027326 00"
DATA "SQR(((100) ^ 2 + (-110) ^ 2 + (95) ^ 2 + (95) ^ 2) / 4)"
DATA "5000*(7/13200)^2"
DATA "68+160*.5*22E-6*25^2*60"
DATA "(-1)*(-2)*(-3)*+4"
DATA "(-3)*(-2)*(-1)"
DATA "(5 = 1 OR 10 < 1 OR 10 = 10) AND (-1 = NOT 0)"

'$INCLUDE: 'EVALUATE.BAS'
'$INCLUDE: 'PRO.BAS'