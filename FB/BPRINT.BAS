' ********** BPRINT.BAS - prints BASIC strings through DOS

' Copyright (C) 1988
' Modifications (c) 2023 Cory Smith

#INCLUDE "PRO.BI" ' BPrint

Dim normal As String
Dim fixLen As String * 30
Dim value As Single

fixLen = "This string has a fixed length..."   'dots show how assigning to a
                                                'fixed length string truncates
normal = "This is a normal BASIC string"
value = 143.801

SCREEN 0 'CLS
BPrint fixLen + CHR$(13) + CHR$(10)
BPrint normal + CHR$(13) + CHR$(10)
BPrint "This is a number: " + STR$(value) + CHR$(13) + CHR$(10)
LOCATE 20, 20
BPrint "This shows that BPrint honors the current cursor location"

WaitKey