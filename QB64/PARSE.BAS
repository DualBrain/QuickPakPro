' ********* PARSE.BAS - parses elements from a delimited string

' Copyright (c) 1988 Paul Passarelli
' Copyright (c) Crescent Software
' Modifications (c) 2022 Cory Smith

'Like the other QuickPak Professional functions, Delimit% and the Parse
'subprogram are intended to be copied into your own programs.  This is
'a demo of parsing the PATH into a series of individual strings.  Comments
'below also show how to parse COMMAND$ for one or more switches.

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
_TITLE "PARSE" 'NOTE: Moving title above resize causes resize to fail (without an error???)
'BUG: It would be nice specify the icon here, but... having to require full path or placing it in the qb64 folder is problematic. 
'NOTE: The above boiler plate must be first in execution (top of file).
'BUG:  Also appears to not work as an $INCLUDE; suggesting something might
'      be wrong with the implementation of $INCLUDE.
' **************************
' * BOILER PLATE END
' **************************

DEFINT A-Z

'$INCLUDE: 'PRO.BI'

DECLARE FUNCTION Delimit% (work$, delim$)
DECLARE FUNCTION InCount% (source$, search$)
DECLARE SUB Parse (work$, delim$, array$())

' Delimit% returns the value to which the array must be dimensioned
' and Parse unpacks the string into the array

CLS

work$ = ENVIRON$("PATH")        ' use this to parse the current PATH
'work$ = COMMAND$               ' use this for COMMAND$

delim$ = "+-/,;_ "              ' some common delimiters

j = Delimit%(work$, delim$) + 1 ' first find how big an array we need
REDIM array$(j)                 ' +1 is needed to account for the last item

Parse work$, delim$, array$()   ' do it to it

PRINT work$
PRINT

FOR x = 1 TO j
  PRINT "==>" + array$(x) + "<=="
NEXT

FUNCTION Delimit% (work$, delim$)

  FOR x% = 1 TO LEN(delim$)
    counter% = counter% + InCount%(work$, MID$(delim$, x%, 1))
  NEXT x%

  Delimit% = counter%

END FUNCTION

SUB Parse (work$, delim$, array$())

  beginPtr% = 1
  element% = 1

  FOR endPtr% = 1 TO LEN(work$)
    IF INSTR(delim$, MID$(work$, endPtr%, 1)) THEN
      array$(element%) = MID$(work$, beginPtr%, endPtr% - beginPtr%)
      element% = element% + 1
      beginPtr% = endPtr% + 1
    END IF
  NEXT

  array$(element%) = MID$(work$, beginPtr%)

END SUB

'$INCLUDE: 'PRO.BAS'