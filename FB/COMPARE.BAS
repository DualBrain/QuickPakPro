'********* COMPARE.BAS - tests the assembly language Compare routines
' Modifications (c) 2023 Cory Smith

#INCLUDE "PRO.BI" ' Compare, CompareT

TYPE Test FIELD = 1
  S AS SINGLE
  T AS STRING * 20
END TYPE

Dim x As Double, y As Double, varType As Short

SCREEN 0 'CLS
x = 1.23456789012345#
y = x - .000000001#   'rem out the " - .000000001#" to make them the same
varType = -4            'code for double precision (same code as in Sorts)

PRINT "Comparing the two double precision values ... ";
IF Compare(@x, @y, varType) THEN
  PRINT "They are the same!"
ELSE
  PRINT "Sorry, they're different"
END IF

DIM type1 AS Test
DIM type2 AS Test

type1.S = 3.4
type1.T = "Hi Mom"
type2.S = 3.4           'change one of these to test
type2.T = "Hi Mom"

PRINT
PRINT "Comparing the two TYPE variables ... ";
IF CompareT(@type1, @type2, LEN(@type1)) THEN
  PRINT "They are the same!"
ELSE
  PRINT "Sorry, they're different"
END IF

WaitKey