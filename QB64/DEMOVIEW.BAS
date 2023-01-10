' ********** DEMOVIEW.BAS - demonstrates ViewFile

' Copyright (c) 1988 Don Malin & Crescent Software
' Modified (c) 2023 Cory Smith

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
_TITLE "DEMOVIEW" 'NOTE: Moving title above resize causes resize to fail (without an error???)
'BUG: It would be nice specify the icon here, but... having to require full path or placing it in the qb64 folder is problematic. 
'NOTE: The above boiler plate must be first in execution (top of file).
'BUG:  Also appears to not work as an $INCLUDE; suggesting something might
'      be wrong with the implementation of $INCLUDE.
' **************************
' * BOILER PLATE END
' **************************

DEFINT A-Z

'$INCLUDE: 'PRO.BI'

DECLARE FUNCTION DosError% ()
DECLARE FUNCTION Null% (work$)
DECLARE FUNCTION WhichError% ()
DECLARE FUNCTION ErrorMsg$ (errNum)
DECLARE SUB ViewFile (fileName$, numChars, rows, colr, hiBit, action)

msg$ = SPACE$(79)                               ' Message string used later

COLOR 2, 0                                      ' Green on Black
CLS
LOCATE 2, 1                                     ' Put dots on screen to show
PRINT STRING$(1840, 254);                       '   the screen being restored
                                                '   after ViewFile finishes.

COLOR 15, 0                                     ' Bright white for messages

                                                ' The view window will contain
rows = 15                                       '   15 rows,
numChars = 70                                   '   70 columns
colr = 31                                       '   and will be bright white
                                                '   on blue background.

DO
  LOCATE 1, 1                                   ' Get the file name
  LINE INPUT "File to display: ", f$
  IF Null%(f$) THEN END
                                                ' Give directions to user
  LSET msg$ = "  Use Arrow keys, PgUp, PgDn, Home, or Ctrl-left keys.  Escape to end."
  LOCATE 25, 1
  PRINT msg$;

  LOCATE 4, 5                                   ' Upper left corner of window
  ViewFile f$, numChars, rows, colr, 0, 0       ' Browse the file

  IF DosError% THEN                             ' Flag if no file or bad drive
    LSET msg$ = ErrorMsg$(WhichError%) + " - press any key to continue."
    LOCATE 25, 1
    PRINT msg$;
    CALL WaitKeyS
    LSET msg$ = ""
    LOCATE 25, 1
    PRINT msg$;
  END IF

LOOP WHILE DosError%                            ' Go back for another file

'$INCLUDE: 'VIEWFILE.BAS'
'$INCLUDE: 'PRO.BAS'