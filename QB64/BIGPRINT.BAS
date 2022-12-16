' ********** BIGPRINT.BAS - shows how to use APrint to create big letters

' Copyright (c) 1988 Ethan Winer
' Modifications (c) 2022 Cory Smith


' This is just a silly demo showing how to print big letters.  You could
' easily use Search/Replace to change the block characters used below to
' some of the other available characters such as CHR$(177), 178, or 219.

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
_TITLE "BIGPRINT" 'NOTE: Moving title above resize causes resize to fail (without an error???)
'BUG: It would be nice specify the icon here, but... having to require full path or placing it in the qb64 folder is problematic. 
'NOTE: The above boiler plate must be first in execution (top of file).
'BUG:  Also appears to not work as an $INCLUDE; suggesting something might
'      be wrong with the implementation of $INCLUDE.
' **************************
' * BOILER PLATE END
' **************************

DEFINT A-Z

'$INCLUDE: 'PRO.BI'

DECLARE SUB APrint0 (BYVAL Address, NumEls, StartChar, NumChars, Colr)

CLS
DIM title$(6)           'leave 0 and 6 for the border
FOR x = 1 TO 5
  READ title$(x)
  CALL ReplaceChar(title$(x), "*", CHR$(176))
NEXT
DATA "      *****  *   *  ***  *****     ***  *****     ****   ***   ****"
DATA "        *    *   *   *   *          *   *         *   *   *   *    "
DATA "        *    *****   *    ***       *    ***      ****    *   * **"
DATA "        *    *   *   *       *      *       *     *   *   *   *   *"
DATA "        *    *   *  ***  *****     ***  *****     ****   ***   ***"
                                     
CALL APrint0(title$(), 0, 7, 1, 74, 78)

'$INCLUDE: 'PRO.BAS'