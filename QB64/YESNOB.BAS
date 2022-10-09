' ********** YESNOB.BAS - BASIC yes/no input subprogram

' Copyright (c) 1987 Ethan Winer
' Modified (c) 2022 Cory Smith

DEFINT A-Z

DECLARE SUB CapNum ()
DECLARE SUB QPrint (txt$, colr, page)

'----- entry parameters
'
' yn$ = string to be input or edited (use the name of your choice)
' colr is the combined foreground and background colors that will be used
'
'----- exit parameters
'
' yn$  = final edited amount
' exitCode indicates how editing was terminated -
'   0 = Enter, Tab, Down-Arrow, Right-Arrow past end, or field filled
'   1 = Shift-Tab, Up-Arrow, or Left-Arrow past beginning
'   2 = Escape key pressed
'
'----- local variables
'
' x$ is a string version of the number while it is being input or edited
'
SUB YesNoB (yn$, exitCode, colr) STATIC

  exitCode = 0                               ' initialize flag

  x$ = yn$
  IF x$ = "" THEN x$ = " "
  CALL QPrint(x$, colr, -1)
  LOCATE , , 1

YGetKey:
  CALL CapNum                                ' print Cap/Num if active
  x$ = INKEY$
  IF x$ = "" GOTO YGetKey

  IF UCASE$(x$) = "Y" OR UCASE$(x$) = "N" GOTO YDone

  IF x$ = CHR$(9) OR x$ = CHR$(13) GOTO YD2  ' Tab or Enter
  IF x$ = CHR$(27) THEN                      ' Escape
    exitCode = 2
    GOTO YD2
  END IF

  IF LEN(x$) = 2 THEN                        ' extended key
    x$ = RIGHT$(x$, 1)
    IF x$ = "P" OR x$ = "M" THEN GOTO YD2    ' Down arrow, Right arrow
    IF x$ = "H" OR x$ = "K" OR x$ = CHR$(15) THEN
      exitCode = 1                           ' Up, Left, Shift-Tab
      GOTO YD2
    END IF
  END IF

  GOTO YGetKey
  
YDone:
  IF x$ > "Y" THEN x$ = CHR$(ASC(x$) - 32)   ' capitalize if necessary
  yn$ = x$
  CALL QPrint(yn$, colr, -1)

YD2:
  LOCATE , , 0

END SUB