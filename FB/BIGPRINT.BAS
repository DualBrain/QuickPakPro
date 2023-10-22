' ********** BIGPRINT.BAS - shows how to use APrint to create big letters
' Copyright (c) 1988 Ethan Winer
' Modifications (c) 2023 Cory Smith

#INCLUDE "PRO.BI" ' APrint0

' This is just a silly demo showing how to print big letters.  You could
' easily use Search/Replace to change the block characters used below to
' some of the other available characters such as CHR$(177), 178, or 219.

CLS
DIM title(6) As String           'leave 0 and 6 for the border
FOR x As Short = 1 TO 5
  READ title(x)
NEXT
DATA "      *****  *   *  ***  *****     ***  *****     ****   ***   ****"
DATA "        *    *   *   *   *          *   *         *   *   *   *    "
DATA "        *    *****   *    ***       *    ***      ****    *   * **"
DATA "        *    *   *   *       *      *       *     *   *   *   *   *"
DATA "        *    *   *  ***  *****     ***  *****     ****   ***   ***"
                                     
APrint0 VARPTR(title(0)), 7, 1, 74, 78

WaitKey