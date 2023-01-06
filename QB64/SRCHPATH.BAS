' ******** SRCHPATH.BAS

' Copyright (c) 1991 Crescent Software
' Modifications (c) 2022 Cory Smith

' This functions accepts an incoming executable file name, and locates it
' in your system's PATH.  It returns the complete path to the specified file
' name if it is found, otherwise it returns a null string.

DEFINT A-Z

DECLARE FUNCTION ASCII% (work$)
DECLARE FUNCTION Exist% (fileName$)
DECLARE FUNCTION ParseString$ (curPos, work$, delimit$)
DECLARE FUNCTION SearchPath$ (fileName$)

FUNCTION SearchPath$ (fileName$) STATIC

  searchPath$ = ""                     ' assume we won't find it
  path$ = ";" + ENVIRON$("PATH")       ' the leading ";" forces searching to
                                       '   start in the current directory
  dot = INSTR(fileName$, ".")          ' see if they gave an extension
  ext$ = ""                            ' default to none given
  found = 0                            ' assume it won't be found
  curPos = 1                           ' start at the beginning of the path
  
  DO

    thisPath$ = ParseString$(curPos, path$, ";")  ' get the next path name
    temp = ASCII%(RIGHT$(thisPath$, 1))           ' tack on a "\" if needed
    IF temp <> -1 AND temp <> 58 AND temp <> 92 THEN
      thisPath$ = thisPath$ + "\"
    END IF
    thisName$ = thisPath$ + fileName$          ' build a complete name

    IF dot THEN                                ' they gave an extension
      GOSUB DoExist
    ELSE
      ext$ = ".COM"
      GOSUB DoExist
      ext$ = ".EXE"
      GOSUB DoExist
      ext$ = ".BAT"
      GOSUB DoExist
    END IF

  LOOP WHILE curPos < LEN(path$)
  EXIT FUNCTION

DoExist:                                ' a GOSUB to a CALL is low code
  temp$ = thisName$ + ext$              ' build the string to try
  IF Exist%(temp$) THEN                 ' if it's there
    SearchPath$ = temp$                 ' assign the function
    EXIT FUNCTION                       ' and leave
  END IF
  RETURN

END FUNCTION