TYPE DLog
  DType AS SHORT           ' Type i.e. 0=Plain Text, 1=Button 2=Check Box,
                           '   3=Option Box 4=Text Input Box, 5=List Box
  TextLen AS SHORT         ' Length of text to be entered
  NumFlag AS SHORT         ' Num only flag for MEditor
  Row AS SHORT             ' Starting row
  Col AS SHORT             ' Starting column
END TYPE

TYPE Area                                 ' Type definition for MouseRange
  Y1 AS SHORT
  X1 AS SHORT
  Y2 AS SHORT
  X2 AS SHORT
  RN AS SHORT
END TYPE

CONST CheckS AS STRING = "X"                       ' Character for Check boxes
CONST CancelS AS STRING = "CANCEL"

' Change the constants below for the screen mode that you will be using
CONST VMid = 13                          ' Center of screen for 25 row mode                                                                                         -+               'Center of screen for 50 line mode
CONST HMid = 41                          ' Center of screen for 80 column mode
