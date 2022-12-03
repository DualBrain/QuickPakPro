' ********** QINSTR.BAS - tests QInstr.Asm

' Copyright (c) 1988 Ethan Winer
' Modifications (c) 2022 Cory Smith

DEFINT A-Z

'$INCLUDE: 'PRO.BI'

'_FULLSCREEN _SQUAREPIXELS

DECLARE FUNCTION QInstr% (start, source$, pattern$)

CLS

start = 7
source$ = "This is a test of the QInstr routine"
pattern$ = "I???"

position = QInstr%(start, source$, pattern$)

PRINT source$
IF position THEN
  PRINT TAB(position); pattern$
  PRINT TAB(position); MID$(STR$(position), 2)
ELSE
  PRINT "Not Found"
END IF

'$INCLUDE: 'PRO.BAS'