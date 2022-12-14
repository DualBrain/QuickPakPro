' ********* DEMOSCRL.BAS - demonstrates the ScrollIn scrollable input routine

' Copyright (c) 1991 Crescent Software
' Written by Phil Cramer
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
_TITLE "DEMOSCRL" 'NOTE: Moving title above resize causes resize to fail (without an error???)
'BUG: It would be nice specify the icon here, but... having to require full path or placing it in the qb64 folder is problematic. 
'NOTE: The above boiler plate must be first in execution (top of file).
'BUG:  Also appears to not work as an $INCLUDE; suggesting something might
'      be wrong with the implementation of $INCLUDE.
' **************************
' * BOILER PLATE END
' **************************

DEFINT A-Z

'$INCLUDE: 'PRO.BI'

DECLARE SUB ScrollIn (eit$, start, wide, maxLen, filter, ky, edClr, clr)
DECLARE SUB QPrint0 (txt$, clr)
DECLARE SUB InitMouse (there)
DECLARE SUB HideCursor ()
DECLARE SUB ShowCursor ()

CLS

CALL InitMouse(there)                           ' Initialize the Mouse driver

CALL ShowCursor                                 ' Turn on the Mouse cursor

LOCATE 2, 2: QPrint0 "Scrollable Text:", 15     ' Display some stuff
LOCATE 3, 2: QPrint0 "Non-Scrollable Text:", 15
LOCATE 4, 2: QPrint0 "Integers ONLY:", 15
LOCATE 5, 2: QPrint0 "Single/Double ONLY:", 15
LOCATE 6, 2: QPrint0 "Caps or Nums ONLY:", 15

                                                ' First edit string
edit$ = "This Demo shows ScrollIn in operation. If the MaxLen argument is greater than the Wide argument, the edit field may be scrolled left or right using any of the standard editing keys. "
edit$ = Edit$ + "The left and right arrow keys move the cursor right or left one character. Tab moves the cursor ahead 8 characters at a time, while Shift + Tab moves the cursor backwards 8 "
edit$ = Edit$ + "characters. Ctrl-Right or Ctrl-Left move the cursor Wide spaces -1 left or right. Home locates the cursor at the first character in the edit string. "
edit$ = Edit$ + "End will find and locate the cursor at the last non-space character in the string. ScrollIn may be exited by pressing Enter, PgUp, PgDn, Up arrow, or the Down Arrow. "
edit$ = Edit$ + "Pressing Escape will exit ScrollIn, and return the original unedited string. Pressing Alt-C clears the field while Alt-R restores the original contents."

edClr = 31                        ' While editing, white text/blue background
clr = 10                          ' Done editing, green text, black background

start = 1                         ' Start at first character in the edit string
wide = 50                         ' Make the edit window 50 spaces wide
maxLen = 900                      ' Maximum allowable length of the string
filter = 0                        ' Accept all keys
LOCATE 2, 23                      ' Locate the edit field
ky = 6                            ' Start editing at the sixth column

CALL ScrollIn(edit$, start, wide, maxLen, filter, ky, edClr, clr)

start = 1
wide = 50                         ' MaxLen = Wide, Do not scroll window
maxLen = 50
filter = 0

LOCATE 3, 23                      ' position the left edge of the field
ky = 1

CALL ScrollIn(edit$, start, wide, maxLen, filter, ky, edClr, clr)

start = 1
wide = 8
maxLen = 8
filter = 1                        ' Filter = 1, Accept integer characters only
LOCATE 4, 23
ky = 1                            ' start editing at the first character

edit$ = "125"
CALL ScrollIn(edit$, start, wide, maxLen, filter, ky, edClr, clr)

start = 1
wide = 12
maxLen = 12
filter = 2                        ' Filter = 2, Accept single/double prec. only
LOCATE 5, 23
ky = 1

edit$ = "3.37E+38"
CALL ScrollIn(edit$, start, wide, maxLen, filter, ky, edClr, clr)

start = 1
wide = 50
maxLen = 100
filter = 4                        ' Filter = 4, Capitalize all letters
LOCATE 6, 23
ky = 1

edit$ = "CAPS OR NUMBERS PLEASE"
CALL ScrollIn(edit$, start, wide, maxLen, filter, ky, edClr, clr)

CALL HideCursor

'$INCLUDE: 'SCROLLIN.BAS'
'$INCLUDE: 'PRO.BAS'