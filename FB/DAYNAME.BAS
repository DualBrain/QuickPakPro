' ********** DAYNAME.BAS - shows how DayName works
' Modifications (c) 2023 Cory Smith

#INCLUDE "PRO.BI" ' DayName

SCREEN 0 'CLS
FOR x As Short = 1 TO 7
  PRINT x; " "; DayName(x)
NEXT
WaitKey