' ********** ASSEMBLY.BAS - basis for the ASSEMBLY.ASM example program

' Copyright (c) 1989 Ethan Winer
' Modifications (c) 2023 Cory Smith

#INCLUDE "PRO.BI" ' AMenuT, Box0, ClearScr0, Editor, QPrint0, ReadFileT, ScrnRest0, ScrnSave0, WaitKey
                  ' FCount, Monitor, Peek1, QPStrI, QPTrim

DIM scrnArray(1 TO 2000) As Short       'holds the underlying screen
DIM fileNames(300) AS STRING * 12       'holds the file names read

Dim start As Short, length As Short, hColor As Short, rows As Short, cols As Short, gap As Short
Dim aLen As Short, sCode As Short, first As Short

Var spec = "*.*" + SPACE$(30)              'default values for Editor
aLen = 0
sCode = 0
Var num = 0
Var cap = 0
Var normClr = 112
Var editClr = 112
Var row = 5
Var col = 30

Var scrnColor = 7                                   'assume monchrome
IF Peek1(0, &H463) <> &HB4 THEN scrnColor = 23 'nope, it's color

Var ulRow = 1
Var ulCol = 1
Var lrRow = 25
Var lrCol = 80

ScrnSave0 ulRow, ulCol, lrRow, lrCol, @scrnArray(1)  'save underlying screen
ClearScr0 ulRow, ulCol, lrRow, lrCol, scrnColor     'okay clear it now

LOCATE 5, 1
QPrint0 "Enter a file specification: ", scrnColor   'ask for a file spec
Editor spec, aLen, sCode, num, cap, normClr, editClr, row, col

Var count = FCount(QPTrim(spec))         'trim the spec, count matching files
IF count > 300 THEN                     'too many to read into FileNames()
  PRINT "Too many files, must be three hundred or less - press a key"
  GOTO BadEnd1
ELSEIF count = 0 THEN                   'none, so don't bother to continue
  PRINT "No matching files - press a key"
  GOTO BadEnd1
END IF

ReadFileT QPTrim(spec), @fileNames(1) 'read 'em
Box0 9, 6, 20, 72, 2, scrnColor         'draw a nice box

start = 1                               'assign the parameters for AMenuT
length = 12
hColor = 15
rows = 10
cols = 4
gap = 5
row = 10
col = 8
AMenuT @fileNames(start), start, length, count, sCode, normClr, hColor, rows, cols, gap, row, col

LOCATE 22, 1                                    'locate and print the number
QPrint0 "You picked choice number ", scrnColor  '  of matching file names
LOCATE 22, 26
QPrint0 QPStrI(count), scrnColor
LOCATE 22, 30
QPrint0 fileNames(count), scrnColor             'print the name they picked

BadEnd1:
  WaitKey
  ScrnRest0 ulRow, ulCol, lrRow, lrCol, @scrnArray(1)   'restore the screen
  'END
