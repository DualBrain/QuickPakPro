' ******** DEMOPICK.BAS - demos PickList

' Copyright (c) 1988 Crescent Software
' written by Don Malin
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
_TITLE "DEMOPICK" 'NOTE: Moving title above resize causes resize to fail (without an error???)
'BUG: It would be nice specify the icon here, but... having to require full path or placing it in the qb64 folder is problematic. 
'NOTE: The above boiler plate must be first in execution (top of file).
'BUG:  Also appears to not work as an $INCLUDE; suggesting something might
'      be wrong with the implementation of $INCLUDE.
' **************************
' * BOILER PLATE END
' **************************

DEFINT A-Z

'$INCLUDE: 'PRO.BI'

DECLARE SUB PickList (Items$(), Picked%(), NPicked%, Cnf AS ANY)
DECLARE SUB ReadFile (BYVAL Address)
DECLARE FUNCTION FCount% (FileSpec$)
DECLARE FUNCTION MinInt% (Var1%, Var2%)
DECLARE FUNCTION Monitor% ()            'Used in SetCnf.Bi

'$INCLUDE: 'DefCnf.BI'
'$INCLUDE: 'SetCnf.BI'


'----- Read a directory of the disk
NFiles = FCount%("*.*")                 ' Find the number of files
REDIM Items$(NFiles)                    ' Dim the "Items$" array
Items$(0) = "*.*"                       ' Put file spec. in element 0
FOR N = 1 TO NFiles                     ' Pad elements to 12 for names
  Items$(N) = SPACE$(15)                '   plus 3 for check marks
NEXT
ReadFile Items$()                       ' Get the file names

'----- Set up the "Picked" array
MaxNum = MinInt%(10, NFiles)            ' Allow 10 items to be picked
REDIM Picked(MaxNum)                    ' Dim the array

'----- Print instructions
CLS
LOCATE , , 0                            ' Turn the cursor off
PRINT "Choose up to"; MaxNum; "files.  Press [Esc] when done."
PRINT

CALL TextCursor(-2, -2)                 ' set mouse colors to inverse
CALL ShowCursor                         ' Turn it on

'----- Let the User pick file names
PickList Items$(), Picked(), NPicked, Cnf
CALL HideCursor                         ' Turn the Mouse cursor off

'----- Show what they picked
LOCATE 3, 1                             ' Print message on line 3
IF NPicked THEN
  PRINT "You picked the following files:"
  FOR N = 1 TO NPicked                  ' Print each file name picked
    LOCATE , 33                         ' Picked% holds the element
    PRINT CHR$(34); Items$(Picked(N)); CHR$(34) ' number in the Items$ array
  NEXT
ELSE
  PRINT "No items selected."
END IF

'$INCLUDE: 'VERTMENU.BAS'
'$INCLUDE: 'PICKLIST.BAS'
'$INCLUDE: 'PRO.BAS'