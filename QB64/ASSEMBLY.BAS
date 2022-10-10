'********** Assembly.Bas - basis for the Assembly.Asm example program

'Copyright (c) 1989 Ethan Winer


DEFINT A-Z
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

DIM ScrnArray(1 TO 2000)                'holds the underlying screen
DIM FileNames(300) AS STRING * 12       'holds the file names read

Spec$ = "*.*" + SPACE$(30)              'default values for Editor
ALen = 0
SCode = 0
Num = 0
Cap = 0
NormClr = 112
EditClr = 112
Row = 5
Col = 30

ScrnColor = 7                                   'assume monchrome
IF Peek1%(0, &H463) <> &HB4 THEN ScrnColor = 23 'nope, it's color

ULRow = 1
ULCol = 1
LRRow = 25
LRCol = 80

ScrnSave0 ULRow, ULCol, LRRow, LRCol, ScrnArray(1)  'save underlying screen
ClearScr0 ULRow, ULCol, LRRow, LRCol, ScrnColor     'okay clear it now

LOCATE 5, 1
QPrint0 "Enter a file specification: ", ScrnColor   'ask for a file spec
Editor Spec$, ALen, SCode, Num, Cap, NormClr, EditClr, Row, Col

Count = FCount%(QPTrim$(Spec$))         'trim the spec, count matching files
IF Count > 300 THEN                     'too many to read into FileNames()
   PRINT "Too many files, must be three hundred or less - press a key"
   GOTO BadEnd
ELSEIF Count = 0 THEN                   'none, so don't bother to continue
   PRINT "No matching files - press a key"
   GOTO BadEnd
END IF

ReadFileT QPTrim$(Spec$), VARSEG(FileNames(1)), VARPTR(FileNames(1)) 'read 'em
Box0 9, 6, 20, 72, 2, ScrnColor         'draw a nice box

Start = 1                               'assign the parameters for AMenuT
Length = 12
HColor = 15
Rows = 10
Cols = 4
Gap = 5
Row = 10
Col = 8
AMenuT VARSEG(FileNames(1)), VARPTR(FileNames(1)), Start, Length, Count, SCode, NormClr, HColor, Rows, Cols, Gap, Row, Col

LOCATE 22, 1                                    'locate and print the number
QPrint0 "You picked choice number ", ScrnColor  '  of matching file names
LOCATE 22, 26
QPrint0 QPStrI$(Count), ScrnColor
LOCATE 22, 30
QPrint0 FileNames(Count), ScrnColor             'print the name they picked

BadEnd:
   WaitKey
   ScrnRest0 ULRow, ULCol, LRRow, LRCol, ScrnArray(1)   'restore the screen
   END

