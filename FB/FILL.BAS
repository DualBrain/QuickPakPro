' ********** Fill.Bas - demonstrates quickly filling numeric arrays
' Copyright (c) 1988 Ethan Winer
' Modifications (c) 2023 Cory Smith

#INCLUDE ONCE "PRO.BI" ' Fill2, Fill4, Fill8, AddInt

REDIM array2(5000) AS SHORT, array4(5000) AS SINGLE, array8(5000) AS DOUBLE

VAR value2 = 14
VAR value4 = 14.987
VAR value8 = 14.98723568#
VAR size = 5000                          ' number of bytes to fill

Fill2 @array2(1), value2, size            ' fill each array
Fill4 @array4(1), value4, size
Fill8 @array8(1), value8, size
   
CLS                                      ' show that we got all of 'em
PRINT "             Element:        #1            #2500         #5000"
PRINT TAB(30); STRING$(40, 95)
PRINT
PRINT "Filled Integer Array:", array2(1), array2(2500), array2(5000)

PRINT
PRINT "Filled Single Precision:", array4(1), array4(2500), array4(5000)

PRINT
PRINT "Filled Double Precision:", array8(1), array8(2500), array8(5000)

PRINT
PRINT
PRINT "Here are elements 97 through 101:"
PRINT

size = 2
value2 = -87                             ' now let's do just a portion
value4 = -87.904
value8 = -.0007654#

Fill2 @array2(99), value2, size
Fill4 @array4(99), value4, size
Fill8 @array8(99), value8, size

PRINT array2(97), array2(98), array2(99), array2(100), array2(101)
PRINT array4(97), array4(98), array4(99), array4(100), array4(101)
PRINT array8(97), array8(98), array8(99), array8(100), array8(101)

value2 = 2
size = 5000

PRINT
PRINT
PRINT "Here's the integer array after adding"; value2; CHR$(29); ":"
PRINT
AddInt @array2(1), value2, size
FOR x AS SHORT = 97 TO 101
    PRINT Array2(x),
NEXT
PRINT
PRINT "(You can easily subtract from the array by using a negative number.)"
