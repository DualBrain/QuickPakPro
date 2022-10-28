' ********** GETDIR.BAS - retrieves the current drive/directory

' Copyright (c) 1988 Ethan Winer
' Modified (c) 2022 Cory Smith

DEFINT A-Z

'$INCLUDE: 'QPPRO.BI'

_FULLSCREEN _SQUAREPIXELS

DECLARE FUNCTION GetDir$ (drive$)
DECLARE FUNCTION GetDrive%

CLS

PRINT "Which drive (press ENTER for default drive): ";
LOCATE , , 1

DO
  drive$ = INKEY$
LOOP UNTIL LEN(drive$)
IF drive$ = CHR$(13) THEN drive$ = ""    ' null means use default drive

PRINT : PRINT
PRINT "The current directory is ";

IF LEN(drive$) THEN
  PRINT UCASE$(drive$);        ' drive was specified, print it
ELSE
  PRINT CHR$(GetDrive%);       ' print the current drive as part of the path
END IF

PRINT ":"; GetDir$(drive$)

'$INCLUDE: 'QPPRO.BAS'