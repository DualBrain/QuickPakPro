' ********** DemoMgr.Bas - demo for the QuickPak Professional window manager

' Copyright (c) 1988 Ethan Winer
' Modifications (c) 2023 Cory Smith

#INCLUDE "PRO.BI" ' APrint0

DECLARE SUB WindowMgr (windowNumber As Short, action As Short, ulRow As Short, ulCol As Short, lrRow As Short, lrCol As Short, colr As Short)

Dim x As Short

DIM test1(24) As String                              'make some test array data
FOR x = 1 TO 24
  test1(X) = STRING$(80, "0")
NEXT

DIM test2(8) As String
FOR x = 1 TO 8
  test2(x) = STRING$(30, "1")
NEXT

DIM test3(6) As String
FOR x = 1 TO 6
  test3(X) = STRING$(60, "2")
NEXT

DIM test4(2) As String
FOR x = 1 TO 2
  test4(X) = STRING$(15, "3")
NEXT

SCREEN 0 'CLS                                         'display a test pattern
APrint0 @test1(1), 24, 1, 80, 7
LOCATE 25, 1, 1
PRINT "Press a key to access window #1 ";
WHILE INKEY$ = "": WEND

WindowMgr 0, 1, 3, 3, 12, 34, 65            'open next available window
LOCATE 25, 1
PRINT "Press a key to display some stuff ";
WHILE INKEY$ = "": WEND

LOCATE 4, 4                                 'fill window with some text
APrint0 VARPTR(test2(1)), 8, 1, 30, 2
LOCATE 25, 1
PRINT "Press another key to access window #2 ";
WHILE INKEY$ = "": WEND

WindowMgr 0, 1, 7, 5, 14, 66, 89            'open next available window
LOCATE 25, 1
PRINT "Press another key to display some stuff ";
WHILE INKEY$ = "": WEND

LOCATE 8, 6                                 'display some more test text
APrint0 VARPTR(test3(1)), 6, 1, 60, 9
LOCATE 25, 1
PRINT "Press yet another key to access window #3 ";
WHILE INKEY$ = "": WEND

WindowMgr 0, 1, 9, 9, 12, 25, 79            'and so on
LOCATE 25, 1
PRINT "Press yet another key to display some stuff ";
WHILE INKEY$ = "": WEND

LOCATE 10, 10
APrint0 VARPTR(test4(1)), 2, 1, 15, 2
LOCATE 25, 1
PRINT "As you continue to press a key, each window will be closed ";
WHILE INKEY$ = "": WEND

WindowMgr 0, 0, 0, 0, 0, 0, 0               'close all windows
WHILE INKEY$ = "": WEND                     '(easy enough, right?)
WindowMgr 0, 0, 0, 0, 0, 0, 0
WHILE INKEY$ = "": WEND
WindowMgr 0, 0, 0, 0, 0, 0, 0

WaitKey