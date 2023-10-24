' ********* DATE2DAY.BAS - finds the day of the week number from a Date String

' Copyright (c) 1987 Donald R. Malin
' Copyright (c) 1987 Crescent Software
' Modifications (c) 2023 Cory Smith

#INCLUDE "PRO.BI" ' Date2Num, Num2Day

' Caller passes a Date String in the form MMDDYY or MMDDYYYY, and this
' subprogram returns a day of the week number (1-7), where 1 = Sunday.

DECLARE FUNCTION Date2Day (dat As String) As Short

' PRINT Date2Day("10242023")
' WaitKey

FUNCTION Date2Day (dat As String) As Short STATIC
  Date2Day = Num2Day(Date2Num(dat))
END FUNCTION