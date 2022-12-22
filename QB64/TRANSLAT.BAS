' ********** TRANSLAT.BAS

' Translate will replace the special box characters with normal ASCII
' characters that any printer can use.

' Copyright (c) 1989 Ethan Winer
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
_TITLE "TRANSLAT" 'NOTE: Moving title above resize causes resize to fail (without an error???)
'BUG: It would be nice specify the icon here, but... having to require full path or placing it in the qb64 folder is problematic. 
'NOTE: The above boiler plate must be first in execution (top of file).
'BUG:  Also appears to not work as an $INCLUDE; suggesting something might
'      be wrong with the implementation of $INCLUDE.
' **************************
' * BOILER PLATE END
' **************************

DECLARE SUB Translate (X$)

'$INCLUDE: 'PRO.BI'

CLS

FOR X = 33 TO 254               'create a test string
  t$ = t$ + CHR$(x)
NEXT

LOCATE 5
PRINT t$                        'print the original string
PRINT

Translate t$                    'translate the extended and box characters
LOCATE 15
PRINT t$                        'print the result

LOCATE 23, , 1
PRINT "Press a key: ";          'now show Translate in context
WHILE INKEY$ = "": WEND

CLS

top$ = CHR$(218) + STRING$(58, CHR$(196)) + CHR$(191)
sid$ = CHR$(179) + STRING$(58, " ") + CHR$(179)
bot$ = CHR$(192) + STRING$(58, CHR$(196)) + CHR$(217)

LOCATE 5, 10
PRINT top$
FOR x = 1 TO 5
  LOCATE , 10
  PRINT sid$
NEXT
LOCATE , 10
PRINT bot$

Translate top$
Translate sid$
Translate bot$

LOCATE 15, 10
PRINT top$
FOR x = 1 TO 5
  LOCATE , 10
  PRINT  sid$
NEXT
LOCATE , 10
PRINT bot$

'$INCLUDE: 'PRO.BAS'