' ********** UNIQUE.BAS - provides a unique file name

' Copyright (c) 1989 Ethan Winer
' Modifications (c) 2022 Cory Smith

' NOTE: Although the manual shows no arguments to the Unique$ function, we
' have added the capability to specify a path name as an argument.  This lets
' you create a unique file name, and also be sure a file with that name does
' not exist in any given directory.

DEFINT A-Z

DECLARE FUNCTION Exist% (FileName$)
'DECLARE FUNCTION Peek2% (Segment, Address)
DECLARE FUNCTION Unique$ (Path$)

' CLS
' PRINT Unique$("\Pro")

FUNCTION Unique$ (path$)
    IF LEN(path$) AND RIGHT$(path$, 1) <> "\" THEN path$ = path$ + "\"
    seed& = TIMER 'ABS(Peek2%(0, &H46C))               ' use the TIMER as a seed
    DO
       tempName$ = path$ + MID$(STR$(seed&), 2) ' make a string out of it
       seed& = seed& + 1                        ' increment for next time
    LOOP UNTIL NOT Exist%(tempName$)            ' loop and try another name
                                                '   if this one already exists
    Unique$ = tempName$                         ' this is the function output
END FUNCTION