' ********** QINSTR.BAS - tests QInstr.Asm

' Copyright (c) 1988 Ethan Winer
' Modifications (c) 2020 Cory Smith

DEFINT A-Z

DECLARE FUNCTION QInstr% (start, source$, searchValue$)

CLS

start = 7
source$ = "This is a test of the QInstr routine"
searchValue$ = "I???"

position = QInstr%(start, source$, searchValue$)

PRINT source$
IF position THEN
  PRINT TAB(position); searchValue$
  PRINT TAB(position); MID$(STR$(position), 2)
ELSE
  PRINT "Not Found"
END IF

'$INCLUDE: 'QPPRO.BAS'