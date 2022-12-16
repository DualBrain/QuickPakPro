' ************ DEMOCM.BAS - demonstrates Chris May's assembler routines

' Copyright (c) 1989 Chris May
' Copyright (c) 1989 Crescent Software
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
_TITLE "DEMOCM" 'NOTE: Moving title above resize causes resize to fail (without an error???)
'BUG: It would be nice specify the icon here, but... having to require full path or placing it in the qb64 folder is problematic. 
'NOTE: The above boiler plate must be first in execution (top of file).
'BUG:  Also appears to not work as an $INCLUDE; suggesting something might
'      be wrong with the implementation of $INCLUDE.
' **************************
' * BOILER PLATE END
' **************************

DEFINT A-Z

'$INCLUDE: 'PRO.BI'

DECLARE FUNCTION FCount% (FSpec$)
DECLARE FUNCTION FUsing$ (Number$, Image$)
DECLARE SUB AMenu (BYVAL Address, Start, Count, ScanCode, FileColr, HiLiteColr, Rows, Columns, Spacing, Row, Column)
DECLARE SUB Box (ULRow, ULCol, LRRow, LRCol, Style, BoxColor, Page)
DECLARE SUB DirFile (BYVAL Address, Count, ScanCode, MessageColor, FileColor, HiLite, BoxColor)
DECLARE SUB Editor (Edit$, Length, ScanCode, NumOnly, IsCapsOn, NormColor, EditColor, Row, Column)
DECLARE SUB MenuVert (BYVAL Address, NLines, ScanCode, Choice, NormClr, HiLite, Row, Column)
DECLARE SUB ReadFile (BYVAL Address)
DECLARE SUB PUsing (Number$, Image$, Color1, Color2, Page, Row, Column)
DECLARE SUB YesNo (YN$, Prompt$, ScanCode, NormalColr, EditColr, Row, Column)

CLS

' --- first do an exploding box

LOCATE 25, 1, 1
PRINT "Press a key ";
WHILE INKEY$ = "": WEND
boxColor = 9

FOR row = 1 TO 11
  CALL Box(12 - row, 39 - row * 3, 12 + row, 41 + row * 3, row, boxColor, -1)
  PLAY "MFT255P32"            ' VERY short delay
NEXT

' --- now let's look at Chris' editor

max = 35                ' the maximum number of characters to accept
numOnly = 0             ' allow both letters and numbers
isCapsOn = 0            ' don't automatically capitalize letters
editColor = 112         ' use color 112 (black on white) while editing
normColor = 7           ' restore the field to color 7 when done

fSpec$ = "D:*.*"                                ' initial string for editing
fSpec$ = fSpec$ + SPACE$(max - LEN(fSpec$))     ' pad with spaces to the
						                                    ' desired length
LOCATE 25, 1, 0
PRINT "Now enter a file spec: "; '
CALL Editor(fSpec$, length, scanCode, numOnly, isCapsOn, normColor, editColor, 25, 24)
fSpec$ = LEFT$(fSpec$, length)  ' keep only as much as Editor says was entered

'--- take the file spec that was entered, and read all matching file names

count = FCount%(fSpec$)         ' first count the number of matching files
IF count = 0 THEN END           ' spec must have been invalid
n = count                       ' save the count in N for later
DIM array$(count)               ' dim a string array to hold the file names
array$(0) = fSpec$              ' put the file spec into element zero

FOR x = 1 TO count              ' make room for the names
  array$(x) = SPACE$(12)
NEXT
CALL ReadFile(array$())         ' get the file names

' --- show how to select file names using the DirFile menu routine
  
messageColor = 9                ' DirFile's message color
fileColor = 112                 ' color for showing the files
hiLite = 23                     ' the highlighted file's color
boxColor = 118                  ' the color to use for the surrounding box

CLS                             ' clear the screen of any previous messages
CALL DirFile(array$(), 1, count, scanCode, messageColor, fileColor, hiLite, boxColor)

SELECT CASE scanCode            ' see how DirFile was exited
  CASE 13                       ' Enter was pressed
    PRINT "File #"; count; "was selected: "; array$(count)
  CASE 27                       ' Escape was pressed
    PRINT "Escape was pressed"
  CASE ELSE
    IF scanCode > 0 THEN        ' a normal key was pressed
      PRINT "Control Key #"; scanCode; "was pressed"
    ELSE                        ' an extended key was pressed
	   PRINT "Keyboard Scan Code #"; -scanCode; "was pressed"
  END IF                        ' "-" flips ScanCode to positive value
END SELECT

' --- now show how AMenu works

PRINT
PRINT "Press any key to see AMenu at work"
WHILE INKEY$ = "": WEND

count = n       ' reset Count to the number of files read earlier
		            ' (DirFile returns the selected item number in Count)
CLS             ' start this demo with a clean slate
PRINT "Number of rows and columns in table is limited only by screen size"
CALL AMenu(array$(), 1, 1, count, scanCode, 112, 23, 10, 3, 2, 7, 15)
'                                            ^    ^   ^  ^  ^  ^   ^
'                                            |    |   |  |  |  |   |
'              File color -------------------     |   |  |  |  |   |
'              Hilight color ---------------------    |  |  |  |   |
'              Number of rows in table ---------------   |  |  |   |
'              Number of columns in table ---------------   |  |   |
'              Number of spaces between columns ------------   |   |
'              Upper left row of display        ---------------    |
'              Upper left column of display     -------------------

LOCATE 2, 1
SELECT CASE scanCode                    ' see how AMenu was exited
  CASE 13                               ' Enter was pressed
    PRINT "File #"; count; "was selected: "; array$(count)
  CASE 27                               ' Escape was pressed
    PRINT "Escape was pressed"
  CASE ELSE
    IF scanCode > 0 THEN                ' a normal key was pressed
  	   PRINT "Control Key #"; scanCode; "was pressed"
    ELSE                                ' an extended key was pressed
	   PRINT "Keyboard Scan Code #"; -scanCode; "was pressed"
    END IF                              ' "-" flips ScanCode to positive value
END SELECT
LOCATE 25, 1: PRINT "Press any key";
WHILE INKEY$ = "": WEND

' --- now show how to use AMenu for "tagging" multiple items

CLS
PRINT "This demonstrates a file tagging technique using AMenu"
PRINT "Press Enter to toggle item tagging, Escape when done"

FOR i = 1 TO n                          ' add two leading blanks to each string
  array$(i) = "  " + array$(i)          ' to make room for a "check mark"
NEXT
count = n                               ' reset Count to the number of files

DO                                      ' loop until they press Escape

  CALL AMenu(array$(), 1, 1, count, scanCode, 112, 23, 15, 3, 4, 7, 15)
  SELECT CASE scanCode                  ' see what key they pressed
    CASE 13, 32                         ' Enter or Space, toggle the item
	   IF LEFT$(array$(count), 1) = " " THEN  ' it's not marked, mark it
	     MID$(array$(count), 1, 1) = CHR$(251) ' <---- use any marker you want
	   ELSE
	     MID$(array$(count), 1, 1) = " " ' unmark the item
	   END IF
    CASE ELSE
  END SELECT

  IF scanCode <> 27 THEN scanCode = 3   ' We must set ScanCode to 3 to tell
                                        '   AMenu that we are re-entering it,
                                        '   and not to start at item one.
LOOP UNTIL scanCode = 27

' --- show how MenuVert works

CLS
PRINT "This demonstrates a vertical menuing program"
row = 7                         ' where to display the menu's upper left corner
column = 13
scanCode = N                    ' on entry, set ScanCode to the number of items
numLines = 15                   ' how high to make the visible portion
choice = 1                      ' start by highlighting choice number 1
normClr = 112                   ' the menu window color
hiLite = 23                     ' the color to use for highlighting

CALL MenuVert(array$(), 1, numLines, scanCode, choice, normClr, hiLite, row, column)
LOCATE 2, 1
PRINT "ScanCode = "; scanCode
PRINT "Choice   = "; choice

LOCATE 25, 1: PRINT "Press any key";
WHILE INKEY$ = "": WEND
CLS

' --- now show PUsing and FUsing in operation

INPUT "Now enter a number: ", x#
image$ = "This is how PUsing formats a number: $$######,.### - nice, right?"
CALL PUsing(STR$(x#), image$, 9, 113, -1, 3, 1)

image$ = "$$######,.###"
x$ = FUsing$(STR$(x#), image$)
LOCATE 7, 1                             ' compare FUsing, STR$, and PRINT USING
PRINT "And here's the same thing done by FUsing: "; x$
PRINT "And here's BASIC STR$(): "; STR$(x#)
PRINT USING "Here's BASIC Print Using: $$######,.###"; x#
WHILE INKEY$ = "": WEND

' --- finally, show how YesNo is used

CLS
msg$ = "Do you want to see another demo? (Yes/No) "
yn$ = "N"
CALL YesNo(yn$, msg$, scanCode, 7, 112, 1, 1)
LOCATE 5, 1

IF yn$ = "Y" THEN
  PRINT "That was a demo of YesNo!"
ELSEIF yn$ = "N" THEN
  PRINT "Well you just did anyway -- that was a demo of YesNo!"
END IF

IF scanCode > 0 THEN PRINT "Control Key #"; scanCode; "was pressed"
IF scanCode < 0 THEN PRINT "Keyboard Scan Code #"; -scanCode; "was pressed"
PRINT
PRINT "YN$ = "; yn$

'$INCLUDE: 'PRO.BAS'