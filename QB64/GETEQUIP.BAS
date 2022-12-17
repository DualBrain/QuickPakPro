'********** GETEQUIP.BAS - use GetEquip to report one the installed equipment

' Copyright (c) 1989 Ethan Winer
' Modifications (c) 2022 Cory Smith

' **************************
' * BOILER PLATE BEGIN
' **************************
$Resize:Stretch
CHDIR _STARTDIR$ ' Moved this line above resize to (hopefully) give more init time to window
IF _DesktopHeight => 2160 THEN mult = 4 ELSE IF _DesktopHeight => 1440 THEN mult = 2 ELSE mult = 1
DO: LOOP UNTIL _SCREENEXISTS ' Not sure if necessary; however, there does seem to be some sort of timing issue around getting hwnd
hwnd = _WindowHandle: x = 100: y = 100: w = 640 * mult: h = 480 * mult ' inlined _WindowHandle (next line) because 1 out of every 4 or 5 executions, would encounter an invalid window handle (1400)
IF INSTR(_OS$, "[WINDOWS]") THEN success = MoveWindow(_WindowHandle, x, y, w, h, 1) ELSE success = -1 ' Now that _WindowHandle is inlined, invalid window handle (1400) issue has yet to be reproduced - will have to continue to test
IF success = 0 THEN PRINT "FAILED TO RESIZE - "; GetLastError; " ("; hwnd; ")": CALL WaitKeyS
_TITLE "GETEQUIP" 'NOTE: Moving title above resize causes resize to fail (without an error???)
'BUG: It would be nice specify the icon here, but... having to require full path or placing it in the qb64 folder is problematic. 
'NOTE: The above boiler plate must be first in execution (top of file).
'BUG:  Also appears to not work as an $INCLUDE; suggesting something might
'      be wrong with the implementation of $INCLUDE.
' **************************
' * BOILER PLATE END
' **************************

DEFINT A-Z

'$INCLUDE: 'PRO.BI'

DECLARE FUNCTION GetCPU% ()
DECLARE FUNCTION MathChip% ()

'DEF FnTrim$ (X) = LTRIM$(STR$(X))       'strips that damn leading blank

' DEF FnPlural$ (Number, Message$)        'this avoids dumb messages such as
'     IF Number = 1 THEN                  '  "1 floppy drive(s)"
'        FnPlural$ = STR$(Number) + " " + Message$
'     ELSE
'        FnPlural$ = STR$(Number) + " " + Message$ + "s"
'     END IF
' END DEF

PRINT : PRINT
CALL GetEquip(floppies, parallels, serials)

PRINT "This PC has";
PRINT FnPlural$(floppies, "floppy disk drive"); ",";
PRINT FnPlural$(parallels, "parallel printer"); ", and";
PRINT FnPlural$(serials, "serial port"); "."
PRINT
PRINT "The installed CPU is an 80"; FnTrim$(GetCPU%);

IF GetCPU% = 486 THEN
  IF MathChip% THEN
    PRINT "DX"
  ELSE
    PRINT "SX"
  END IF
ELSE
  IF MathChip% THEN
    PRINT
    PRINT "A math coprocessor is also installed."
  END IF
END IF

FUNCTION FnTrim$ (x%) 
  FnTrim$ = LTRIM$(STR$(x%))       ' strips that damn leading blank
END FUNCTION

FUNCTION FnPlural$ (number%, message$)        ' this avoids dumb messages such as
  IF number% = 1 THEN                    '   "1 floppy drive(s)"
    FnPlural$ = STR$(number%) + " " + message$
  ELSE
    FnPlural$ = STR$(number%) + " " + message$ + "s"
  END IF
END FUNCTION

'$INCLUDE: 'PRO.BAS'