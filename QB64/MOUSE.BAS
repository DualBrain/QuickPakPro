' ********** MOUSE.BAS - demonstrates the QuickPak Professional Mouse routines

' Copyright (c) 1988 Ethan Winer, with thanks to Harald Zoschke
' Modifications (c) 2022 Cory Smith

' IMPORTANT NOTE:  Before any of the QuickPak Professional mouse routines
' will operate, you MUST first call InitMouse, as shown in this example.

DEFINT A-Z

DECLARE SUB Bin2Hex (binary$, hexNum)
DECLARE FUNCTION Monitor%
DECLARE FUNCTION Peek1% (segment, address)
DECLARE SUB Prompt (message$)
DECLARE SUB WaitButton ()
DECLARE SUB ButtonPress (button, status, count, x, y)

IF Peek1%(0, &H463) <> &HB4 THEN      ' it's color
  Colr = -1                           ' set the color flag for later
  SELECT CASE Monitor%                ' see what screen mode to use
    CASE 2: SCREEN 3                  ' Hercules
    CASE 3, 8, 9, 10: SCREEN 2        ' CGA
    CASE 5: SCREEN 9                  ' EGA
    CASE 7, 12: SCREEN 12             ' VGA
    CASE ELSE
  END SELECT
END IF

CLS

CALL InitMouse(there)                 ' initialize and see if mouse installed

IF NOT there THEN
  SCREEN 0
  PRINT "No mouse is installed"
  END
END IF

DIM choice$(5)                          ' display some choices on the screen,
LOCATE 1, 1                             ' so we'll have something to point at
FOR x = 1 TO 5
  READ choice$(x)
  PRINT choice$(x);
  LOCATE , x * 12
NEXT
DATA "Choice 1", "Choice 2", "Choice 3", "Choice 4", "Choice 5"

IF colr THEN                            ' if color monitor, load custom cursor
  arrow$ = STRING$(64, 255)            ' a distinctive arrow proves it works
  FOR x = 33 TO 64 STEP 2
    READ x$
    CALL Bin2Hex(x$, h)
    MID$(arrow$, x) = CHR$(h AND 255)        ' isolate the lo-byte
    h& = h AND &HFF00                        ' ditto for the hi-byte
    IF h& < 0 THEN h& = h& + 65536           ' some numbers may be negative
    h& = h& / 256                            ' shift bits right 8 places
    MID$(arrow$, x + 1) = CHR$(h&)
  NEXT
  DATA "1000000000000000"  : ' using the block of code above, it is
  DATA "1110000000000000"  : ' easy to define a custom cursor
  DATA "1111100000000000"  : ' shape using binary data strings
  DATA "1111111000000000"  : ' just like these
  DATA "1101100000000000"
  DATA "0000110000000000"
  DATA "0000011000000000"
  DATA "0000001100000000"
  DATA "0000000110000000"
  DATA "0000000011000000"
  DATA "0000000001100000"
  DATA "0000000000110000"
  DATA "0000000000011000"
  DATA "0000000000001100"
  DATA "0000000000000110"
  DATA "0000000000000011"
  CALL GrafCursor(0, 0, arrow$)        ' hot spot is at 0,0 (the arrow's tip)
ELSE
  CALL TextCursor(-2, -2)              ' initiate inverting text cursor
END IF

CALL ShowCursor
CALL Prompt("Point the cursor at a choice, and press either button")

button = 0
WHILE button = 0                        ' wait for a button press
   CALL GetCursor(x, y, button)
WEND
IF button AND 4 THEN button = 3         ' for three-button mice (mouses?)

CALL Prompt("You pressed button" + STR$(button) + " and the cursor was at location" + STR$(x) + "," + STR$(y) + " - press a button")
CALL WaitButton

' ----- set hour glass shape
IF colr THEN                            ' now use the hourglass shape
  arrow$ = STRING$(64, 255)
  FOR x = 33 TO 64 STEP 2
    READ x$
    CALL Bin2Hex(x$, h)
    MID$(arrow$, x) = CHR$(h AND 255)        ' isolate the lo-byte
    h& = h AND &HFF00                        ' ditto for the hi-byte
    IF h& < 0 THEN h& = h& + 65536           ' some numbers may be negative
    h& = h& / 256                            ' shift bits right 8 places
    MID$(arrow$, x + 1) = CHR$(h&)
  NEXT
  DATA "0011111111111100"
  DATA "0001111111111000"
  DATA "0000111111110000"
  DATA "0000011111100000"
  DATA "0000001111000000"
  DATA "0000000110000000"
  DATA "0000000110000000"
  DATA "0000000110000000"
  DATA "0000001111000000"
  DATA "0000011111100000"
  DATA "0000111111110000"
  DATA "0001111111111000"
  DATA "0011111111111100"
  DATA "0000000000000000"
  DATA "0000000000000000"
  DATA "0000000000000000"
  CALL GrafCursor(0, 0, arrow$)
END IF

CALL Prompt("Move the mouse around, observe its sensitivity, then press a button")
CALL Motion(1)                          ' make the mouse VERY sensitive
CALL SetCursor(100, 100)                ' make sure it's not out in left field
CALL WaitButton                         ' BASIC routine pauses for button press

CALL Prompt("Now see how sensitive the mouse is, then press a button")
CALL Motion(100)
CALL SetCursor(100, 100)
CALL WaitButton

CLS

button = 1
CALL ButtonPress(button, 0, count, 0, 0)
PRINT "During this demo you pressed button One"; count;
PRINT "time";
IF count = 0 OR count > 1 THEN PRINT "s";  ' this is getting rather
						                         ' picky, wouldn't you say?
PRINT ", and button Two";
CALL ButtonPress(2, 0, count, 0, 0)
PRINT count; "time";
IF count = 0 OR count > 1 THEN PRINT "s";
PRINT "."

CALL WaitKey            ' pause for a key press
SCREEN 0                ' reset the screen to text mode

SUB Bin2Hex (binary$, hexNum) STATIC    ' converts binary strings to hex and
  hex& = 0                              ' simplifies defining mouse cursor
  count = 0
  FOR x = LEN(binary$) TO 1 STEP -1
 	 IF MID$(binary$, x, 1) = "1" THEN hex& = hex& + 2 ^ count
	 count = count + 1
  NEXT
  IF hex& > 32767 THEN hex& = hex& - 65536
  hexNum = hex&
END SUB

SUB Prompt (message$) STATIC          ' display a prompt message
  v = CSRLIN                          ' remember the current cursor position
  h = POS(0)
  LOCATE 25, 1
  PRINT LEFT$(message$, 79); TAB(80);
  LOCATE v, h                         ' restore the cursor position
END SUB

SUB WaitButton STATIC
  x! = TIMER                          ' pause a bit to give 'em a chance to
  WHILE x! + .2 > TIMER               ' release the button
  WEND
  button = 0
  WHILE button = 0
    CALL GetCursor(x, y, button)
  WEND
END SUB

'$INCLUDE: 'QPPRO.BAS'