' ******** BCOPYT.BAS - demonstrates copying TYPE elements around in memory

' Copyright (c) 1989 Ethan Winer
' Modifications (c) 2023 Cory Smith

#INCLUDE "PRO.BI" ' BCopyT

TYPE Test
  L AS LONG
END TYPE

SCREEN 0
CLS

REDIM fromArray(1 TO 20000) AS Test
REDIM destArray(1 TO 20000) AS Test

FOR x As Short = 16301 TO 17000          ' this range proves that BCopyT successfully
  fromArray(x).L = x                     '   accommodates a segment division
NEXT

Var sz = LEN(Test) ' -2
BCopyT @fromArray(16301), @destArray(16301), sz, 700

FOR x As Short = 16300 TO 17001          ' ***** elements 16300 and 17001 SHOULD fail
  IF destArray(x).L <> x THEN
    PRINT "DestArray"; x; "="; destArray(x).L
    Chime 9
  END IF
NEXT

WaitKey