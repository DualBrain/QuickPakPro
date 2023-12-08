' ********** DEMOFAST.BAS - loads a file into a string array in one operation

' Copyright (c) 1989 Don Malin
' Modifications (c) 2023 Cory Smith

#INCLUDE ONCE "PRO.BI" ' DOSError, ErrorMsg, FileSize, FindLast, WaitKey, WhichError

DECLARE FUNCTION FastLoadInt (fileName As String) As Short
DECLARE SUB FastLoadStr (text() As String)
DECLARE SUB FastSave (fileName As String, text() As String)

Dim fileName As String, bytes As Long, startTime As Single, lines As Short, endTime As Single
Dim dummy As Short, n As Short, answer As Short, x As Short

CLS
INPUT "Enter a file name to load: ", fileName  'ask for a file name
bytes = FileSize(fileName)                   'get its size just for fun

startTime = TIMER                      'time how long the load takes
lines = FastLoadInt(fileName)         'load the file, get number of lines

IF DOSError THEN                       'if there was an error loading it,
  PRINT ErrorMsg(WhichError)         '  print an appropriate message
ELSE

  REDIM text(1 TO lines) As String              'make an array to hold the text
  FastLoadStr text()            'move the text to the array
  endTime = TIMER - startTime        'now we know the elapsed time
  PRINT USING "#.##"; endTime;        'show how fast we loaded it
  PRINT " seconds to load "; bytes; " bytes - press a key to see it"
  dummy = WaitKey                     'pause for a key press

  FOR n = 1 TO lines                   'print the text to prove it worked
    PRINT text(n)
  NEXT

END IF

PRINT
PRINT "Do you want to create a file and see how fast we can save it (Y/N)? ";
answer = WaitKey
IF answer = ASC("Y") OR answer = ASC("y") THEN

  PRINT
  LINE INPUT "Enter the name of the file to create: ", fileName
  REDIM text(1 TO 1000) As String               'make an array of 1000 elements
  FOR x = 1 TO 500                     'show how to save only the first 500
    text(x) = "This is test line number" + STR$(x)
  NEXT

  startTime = TIMER                               'time how fast it happens
  FastSave fileName, text()                'save the array
  IF DOSError THEN PRINT ErrorMsg(WhichError)   'report any errors
  endTime = TIMER - startTime
  PRINT USING "#.##"; endTime;
  PRINT " seconds to save "; fileName             'show the elapsed time
  KILL fileName                                   'clean up after ourselves

END IF