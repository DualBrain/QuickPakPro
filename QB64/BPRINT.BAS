' ********** BPRINT.BAS - prints BASIC strings through DOS

' Copyright (C) 1988
' Modifications (c) 2022 Cory Smith

DEFINT A-Z

'$INCLUDE: 'PRO.BI'

'_FULLSCREEN _SQUAREPIXELS

DECLARE SUB BPrint (x$)

DIM fixLen AS STRING * 30

fixLen$ = "This string has a fixed length..."   ' dots show how assigning to a
                                                ' fixed length string truncates
normal$ = "This is a normal BASIC string"
value! = 143.801

CLS
CALL BPrint(fixLen$ + CHR$(13) + CHR$(10))
CALL BPrint(normal$ + CHR$(13) + CHR$(10))
CALL BPrint("This is a number:" + STR$(value!) + CHR$(13) + CHR$(10))
LOCATE 20, 20
CALL BPrint("This shows that BPrint honors the current cursor location")

'$INCLUDE: 'PRO.BAS'