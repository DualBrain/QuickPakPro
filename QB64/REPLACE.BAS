' ********** REPLACE.BAS

' replaces all occurences of one string with another without regard
' to capitalization

' Copyright (c) 1988 Ethan Winer
' Modifications (c) 2022 Cory Smith

DEFINT A-Z

'$INCLUDE: 'PRO.BI'

'_FULLSCREEN _SQUAREPIXELS

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