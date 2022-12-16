' ********** ASSEMBLY.BAS - basis for the ASSEMBLY.ASM example program

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
_TITLE "ASSEMBLY" 'NOTE: Moving title above resize causes resize to fail (without an error???)
'BUG: It would be nice specify the icon here, but... having to require full path or placing it in the qb64 folder is problematic. 
'NOTE: The above boiler plate must be first in execution (top of file).
'BUG:  Also appears to not work as an $INCLUDE; suggesting something might
'      be wrong with the implementation of $INCLUDE.
' **************************
' * BOILER PLATE END
' **************************

DEFINT A-Z

'$INCLUDE: 'PRO.BI'

DECLARE SUB AMenuT (BYVAL Segment, BYVAL Address, Start, StrLength, Count, ScanCode, ElementColor, HiLiteColor, Rows, Columns, Spacing, Row, Column)
DECLARE SUB Box0 (ULRow, ULCol, LRRow, LRCol, Char, Colr)
DECLARE SUB ClearScr0 (ULRow, ULCol, LRRow, LRCol, Colr)
DECLARE SUB Editor (Ed$, ALen, ScanCode, NumOnly, CapsOn, NormClr, EditClr, Row, Column)
DECLARE SUB QPrint0 (X$, Colr)
DECLARE SUB ReadFileT (FSpec$, BYVAL Segment, BYVAL Address)
DECLARE SUB ScrnRest0 (ULRow, ULCol, LRRow, LRCol, SEG Element)
DECLARE SUB ScrnSave0 (ULRow, ULCol, LRRow, LRCol, SEG Element)
DECLARE SUB WaitKey ()

DECLARE FUNCTION FCount% (FSpec$)
DECLARE FUNCTION Monitor% ()
DECLARE FUNCTION Peek1% (Segment, Address)
DECLARE FUNCTION QPStrI$ (Value%)
DECLARE FUNCTION QPTrim$ (Work$)

DIM scrnArray(1 TO 2000)                'holds the underlying screen
DIM fileNames(300) AS STRING * 12       'holds the file names read

spec$ = "*.*" + SPACE$(30)              'default values for Editor
aLen = 0
sCode = 0
num = 0
cap = 0
normClr = 112
editClr = 112
row = 5
col = 30

scrnColor = 7                                   'assume monchrome
IF Peek1%(0, &H463) <> &HB4 THEN scrnColor = 23 'nope, it's color

ulRow = 1
ulCol = 1
lrRow = 25
lrCol = 80

ScrnSave0 ulRow, ulCol, lrRow, lrCol, scrnArray()  'save underlying screen
ClearScr0 ulRow, ulCol, lrRow, lrCol, scrnColor     'okay clear it now

LOCATE 5, 1
QPrint0 "Enter a file specification: ", scrnColor   'ask for a file spec
Editor spec$, aLen, sCode, num, cap, normClr, editClr, row, col

count = FCount%(QPTrim$(spec$))         'trim the spec, count matching files
IF count > 300 THEN                     'too many to read into FileNames()
  PRINT "Too many files, must be three hundred or less - press a key"
  GOTO BadEnd
ELSEIF count = 0 THEN                   'none, so don't bother to continue
  PRINT "No matching files - press a key"
  GOTO BadEnd
END IF

ReadFileT QPTrim$(spec$), fileNames(), 1 'read 'em
Box0 9, 6, 20, 72, 2, scrnColor         'draw a nice box

start = 1                               'assign the parameters for AMenuT
length = 12
hColor = 15
rows = 10
cols = 4
gap = 5
row = 10
col = 8
AMenuT fileNames(), first, start, length, count, sCode, normClr, hColor, rows, cols, gap, row, col

LOCATE 22, 1                                    'locate and print the number
QPrint0 "You picked choice number ", scrnColor  '  of matching file names
LOCATE 22, 26
QPrint0 QPStrI$(count), scrnColor
LOCATE 22, 30
QPrint0 FileNames(count), scrnColor             'print the name they picked

BadEnd:
  k = WaitKey
  ScrnRest0 ulRow, ulCol, lrRow, lrCol, scrnArray()   'restore the screen
  END

'$INCLUDE: 'PRO.BAS'