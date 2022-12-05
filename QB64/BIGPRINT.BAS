' ********** BIGPRINT.BAS - shows how to use APrint to create big letters

' Copyright (c) 1988 Ethan Winer
' Modifications (c) 2022 Cory Smith


' This is just a silly demo showing how to print big letters.  You could
' easily use Search/Replace to change the block characters used below to
' some of the other available characters such as CHR$(177), 178, or 219.

DEFINT A-Z

_TITLE "BIGPRINT"

'$INCLUDE: 'PRO.BI'

'_FULLSCREEN _SQUAREPIXELS

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