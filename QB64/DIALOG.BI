TYPE DLog
  DType AS INTEGER           ' Type i.e. 0=Plain Text, 1=Button 2=Check Box,
                             '   3=Option Box 4=Text Input Box, 5=List Box
  TextLen AS INTEGER         ' Length of text to be entered
  NumFlag AS INTEGER         ' Num only flag for MEditor
  Row AS INTEGER             ' Starting row
  Col AS INTEGER             ' Starting column
END TYPE

CONST Check$ = "X"                       ' Character for Check boxes
CONST Cancel$ = "CANCEL"

' Change the constants below for the screen mode that you will be using
CONST VMid = 13                          ' Center of screen for 25 row mode                                                                                         -+               'Center of screen for 50 line mode
CONST HMid = 41                          ' Center of screen for 80 column mode
