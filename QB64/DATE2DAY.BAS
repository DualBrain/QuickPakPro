' ********* DATE2DAY.BAS - finds the day of the week number from a Date String

' Copyright (c) 1987 Donald R. Malin
' Copyright (c) 1987 Crescent Software
' Modifications (c) 2022 Cory Smith

' Caller passes a Date String in the form MMDDYY or MMDDYYYY, and this
' subprogram returns a day of the week number (1-7), where 1 = Sunday.

'$INCLUDE: 'PRO.BI'

DECLARE FUNCTION Date2Day% (Dat$)
DECLARE FUNCTION Date2Num% (Dat$)
DECLARE FUNCTION Num2Day% (Days%)

PRINT Num2Date(-29219) ' 01-01-1900
PRINT Num2Date(31368)  ' 11-17-2065
PRINT Date2Num("01-01-1900") ' -29219
PRINT Date2Num("11-17-2065") ' 31368
PRINT Num2Day(-29219) ' ??? -1, should be a 1
PRINT Num2Day(31368) ' 3

PRINT Date2Num("12/05/2022") ' 15680
PRINT Num2Day(15680)

FUNCTION Date2Day% (dat$) STATIC
  Date2Day% = Num2Day%(Date2Num%(dat$))
END FUNCTION

'$INCLUDE: 'PRO.BAS'