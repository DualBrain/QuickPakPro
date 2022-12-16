' ********** REPLACE.BAS

' replaces all occurences of one string with another without regard
' to capitalization

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
_TITLE "REPLACE" 'NOTE: Moving title above resize causes resize to fail (without an error???)
'BUG: It would be nice specify the icon here, but... having to require full path or placing it in the qb64 folder is problematic. 
'NOTE: The above boiler plate must be first in execution (top of file).
'BUG:  Also appears to not work as an $INCLUDE; suggesting something might
'      be wrong with the implementation of $INCLUDE.
' **************************
' * BOILER PLATE END
' **************************

DEFINT A-Z

'$INCLUDE: 'PRO.BI'

DECLARE SUB ReplaceString2 (text$, old$, new$)
DECLARE SUB ReplaceChar (text$, old$, new$)
DECLARE SUB ReplaceChar2 (text$, old$, new$)

CLS

Work$ = "This is a test of the Replace function in QuickPak Professional."
Old$ = "this"
New$ = "And now this"

PRINT Work$
ReplaceString2 Work$, Old$, New$
PRINT Work$

PRINT
Work$ = "Now let's replace only single characters at assembler speed!"
PRINT Work$
ReplaceChar Work$, "n", "m"
PRINT Work$
PRINT

Work$ = "And finally replace all characters regardless of capitalization."
PRINT Work$
ReplaceChar2 Work$, "a", "e"
PRINT Work$

' Moved ReplaceString ReplaceString2 into PRO.BAS.
'
' SUB ReplaceString (sourceValue$, oldValue$, newValue$) STATIC
'   oldLen = LEN(oldValue$)
'   newLen = LEN(newValue$)
'   pointer = 1
' Again:
'   pointer = QInstr%(pointer, sourceValue$, oldValue$) ' case-sensitive
'   IF pointer THEN
'     sourceValue$ = LEFT$(sourceValue$, pointer - 1) + newValue$ + MID$(sourceValue$, pointer + oldLen)
'     pointer = pointer + newLen
'     GOTO Again
'   END IF
' END SUB

' SUB ReplaceString2 (sourceValue$, oldValue$, newValue$) STATIC
'   oldLen = LEN(oldValue$)
'   newLen = LEN(newValue$)
'   pointer = 1
' Again:
'   pointer = QInstr2%(pointer, sourceValue$, oldValue$) ' case-insensitive
'   IF pointer THEN
'     sourceValue$ = LEFT$(sourceValue$, pointer - 1) + newValue$ + MID$(sourceValue$, pointer + oldLen)
'     pointer = pointer + newLen
'     GOTO Again
'   END IF
' END SUB

'$INCLUDE: 'PRO.BAS'