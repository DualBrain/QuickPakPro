' ********** DEMOEDIT.BAS

' Copyright (c) 1988 Don Malin
' Copyright (c) 1988 Crescent Software
' Modifications (c) 2022 Cory Smith

' **************************
' * BOILER PLATE BEGIN
' **************************
$Resize:Stretch
CHDIR _STARTDIR$ ' Moved this line above resize to (hopefully) give more init time to window
IF _DesktopHeight => 2160 THEN mult = 4 ELSE IF _DesktopHeight => 1440 THEN mult = 2 ELSE mult = 1
DO: LOOP UNTIL _SCREENEXISTS ' Not sure if necessary; however, there does seem to be some sort of timing issue around getting hwnd
hwnd = _WindowHandle: x = 100: y = 100: w = 640 * mult: h = 480 * mult ' inlined _WindowHandle (next line) because 1 out of every 4 or 5 executions, would encounter an invalid window handle (1400)
IF INSTR(_OS$, "[WINDOWS]") THEN success = MoveWindow(_WindowHandle, x, y, w, h, 1) ELSE success = -1 ' Now that _WindowHandle is inlined, invalid window handle (1400) issue has yet to be reproduced - will have to continue to test
IF success = 0 THEN PRINT "FAILED TO RESIZE - "; GetLastError; " ("; hwnd; ")": CALL WaitKeyS
_TITLE "DEMOEDIT" 'NOTE: Moving title above resize causes resize to fail (without an error???)
'BUG: It would be nice specify the icon here, but... having to require full path or placing it in the qb64 folder is problematic. 
'NOTE: The above boiler plate must be first in execution (top of file).
'BUG:  Also appears to not work as an $INCLUDE; suggesting something might
'      be wrong with the implementation of $INCLUDE.
' **************************
' * BOILER PLATE END
' **************************

DEFINT A-Z

'$INCLUDE: 'PRO.BI'
'$INCLUDE: 'QEDIT.BI'

DECLARE SUB ClearEOL (colr%)    ' for the demo only
DECLARE FUNCTION Monitor% ()    ' determines monitor type

'----- this file contains a TYPE variable for several of QEdit's parameters
'$INCLUDE: 'QEDITYPE.BI'

DIM ed AS EditInfo              ' create the editor's data structure

DECLARE SUB QEdit (array$(), ky$, action, ed AS EditInfo)

' Note: The Action" parameter can be used to operate the editor in a polled mode.
'       The "Action" values and corresponding meanings are as follows:
'
'       Action = 0:  Use the editor in a non-polled mode.  The editor will
'                    take control and return only when the user presses the
'                    Escape key.  The screen will be saved and restored.
' 
'       Action = 1:  Initialize the editor for polled mode.  The screen
'                    will be saved, the edit window will be drawn, and the
'                    text will be displayed.  Control will be returned to the
'                    caller without checking the keyboard.  The Action flag
'                    will be reset to 3 automatically (see below).
' 
'       Action = 2:  Redisplays the edit window and text without saving the
'                    screen.  Control is returned to the caller without
'                    checking the keyboard.  As above, the Action parameter
'                    will be reset to 3.  Note: If you change a window size
'                    or location parameter, use this code to force a redisplay
'                    to the new size.
' 
'                    Note that if word wrap is on, Actions 0, 1 and 2 will
'                    cause the text to be wrapped to the value of "Ed.Wrap".
' 
'       Action = 3:  This is the idle state of the editor.  Each time the
'                    editor is called with this value, it will check the
'                    keyboard and perform tasks dictated by a key press.
'                    Control will then be returned to the caller.
' 
'                    While the editor is being polled, the caller can examine
'                    the "Ky$" parameter to determine which if any keys were
'                    pressed.  The members of the "Ed" structure can also be
'                    examined and changed.  Note that if the caller does
'                    change these, the editor should next be called with an
'                    Action of 2 to redisplay the edit window.
'
'       Action = 5:  Restores the screen that was saved with Action = 1.
' 
'----------------------------------------------------------------------------

  F2$ = CHR$(0) + CHR$(60)        ' extended code for the F2 function key
                                  ' (used in this demo to change margins)
                                   
  REDIM array$(500)               ' holds the main editor string array
  FOR x = 1 TO 117                ' read some sample text into our array
    READ array$(x)
    CALL ReplaceString(array$(x), "<p>", CHR$(20))    
  NEXT

  COLOR 6, 0                      ' fill the screen with a pattern to
  CLS                             '   show how QEdit saves the screen
  PRINT STRING$(2000, CHR$(254));

  COLOR 15, 0                     ' print instructions on bottom of screen
  LOCATE 25, 1
  PRINT " ESC - Quit    F1 - Help    F2 - Change Margin"; TAB(79);

  ' ----- fill in editing parameters
  SELECT CASE Monitor%            ' determine the monitor type
    CASE 3, 5, 7, 9, 10, 12       ' CGA, EGA, VGA monitors
      ed.AColor = 23              ' white on blue
    CASE ELSE                     ' all other monitors
     ed.AColor = 7                ' white on black
  END SELECT

  ed.Wrap = 60   ' word wrap at column 65 (use 0 for to disable word wrap)
  ed.Frame = -1  ' frame code (1 = show ruler line & scroll bars, 0 = don't)
  ed.Rows = 14   ' number of text lines to display on the screen (3 - 25)
  ed.Wide = 70   ' width of the active screen (10 - 80)
  ed.HTab = 4    ' set tab stops to 4 spaces

  LOCATE 5, 5    ' locate the upper left corner of the edit window frame

  CALL InitMouse(mouseThere)
  CALL TextCursor(-2, -2)        ' define the Mouse cursor
  CALL ShowCursor                ' turn it on

  action = 1                     ' Action 1 to save underlying screen and
                                 '   display text, operate in polled mode
  '----- main loop for editing
  DO
    '----- call QEdit in polled mode
    CALL QEdit(array$(), ky$, action, ed)
    '----- F2 function key pressed? - change margin
    IF ky$ = F2$ THEN GOSUB ChangeMargin
  LOOP UNTIL ky$ = CHR$(27)      ' keep calling QEdit until Esc is pressed

  '----- call QEdit again with an Action flag of 5 to restore the screen
  CALL QEdit(array$(), ky$, 5, ed)
  CALL HideCursor                ' turn the mouse cursor off

  END

'----- subroutine to change the right margin
ChangeMargin:
  DO
    IF ed.Wrap THEN                           ' is Word Wrap on?
      LOCATE 25, 1, 0                         ' print instructions
      PRINT "LEFT or RIGHT arrow keys change margin.  ENTER to set.  ESC to enter manually.";
      DO                                      ' wait for a key press
        x$ = INKEY$
      LOOP UNTIL LEN(x$)
      IF x$ = CHR$(27) THEN                   ' Escape key pressed?
        LOCATE 25, 1
        CALL ClearEOL(-1)                     ' erase bottom line
        INPUT ; "Enter new right margin: "; ed.Wrap
        action = 2                            ' set Action flag to re-display
      ELSEIF x$ = CHR$(0) + CHR$(75) THEN     ' Left-Arrow key pressed?
        ed.Wrap = ed.Wrap - 1                 ' decrement right margin
        action = 2                            ' set Action flag to re-display
                                              ' call QEdit to re-display
        CALL QEdit(array$(), ky$, action, ed)
      ELSEIF x$ = CHR$(0) + CHR$(77) THEN     ' right arrow key pressed?
        ed.Wrap = ed.Wrap + 1                 ' increment right margin
        action = 2                            ' set Action flag to re-display
                                              ' call QEdit to re-display
        CALL QEdit(array$(), ky$, action, ed)
      END IF
    ELSE                                      ' word wrap was off
      LOCATE 25, 1
      CALL ClearEOL(-1)                       ' erase bottom line
      INPUT ; "Enter new right margin: "; ed.Wrap
      action = 2                              ' set Action flag to re-display
      x$ = CHR$(27)                           ' set X$ to Escape so we fall
    END IF                                    '   out of the loop below
  LOOP UNTIL x$ = CHR$(13) OR x$ = CHR$(27)   ' wait for Enter or Escape
  LOCATE 25, 1                                ' re-print instructions
  PRINT " ESC - Quit    F1 - Help    F2 - Change Margin"; TAB(79);
  RETURN

DATA "                       QEdit Instructions"
DATA ""
DATA "All of the standard editing keys are supported.  For example,"
DATA "Home and End move to the beginning and end of the line, the"
DATA "PgUp and PgDn keys scroll the screen by pages, and Ctrl-PgUp"
DATA "and Ctrl-PgDn move to the first and last lines respectively."
DATA "The cursor may also be moved to the top or bottom of the edit"
DATA "window with the Ctrl-Home and Ctrl-End keys.<p>"
DATA ""
DATA "Similar to the QuickBASIC editor, QEdit uses the Ctrl-Left"
DATA "and Ctrl-Right arrow keys to move the cursor by words, and"
DATA "blocks are marked with any of the Shift-Cursor keys.  Notice"
DATA "that blocks may also be marked using a combination of the"
DATA "Shift AND Ctrl arrows to jump by whole words.  Beyond the"
DATA "usual block operations, however, QEdit also supports block"
DATA "operations on COLUMNS.<p>"
DATA "<p>"
DATA "To mark a block in sentence mode, place the cursor at the"
DATA "beginning of the block and press the Shift-Right arrow key."
DATA "The marked block will be highlighted as the cursor travels"
DATA "over the text.  Alternately, entire lines may be marked by"
DATA "placing the cursor at the desired starting point and pressing"
DATA "the Shift-Down arrow key.<p>"
DATA "<p>"
DATA "To mark a column, place the cursor at the upper left corner"
DATA "of the block and press the Shift-Right arrow key until the"
DATA "highlight extends to the desired right edge.  Then, press"
DATA "Shift-Down until the bottom of the block has been reached.<p>"
DATA ""
DATA "Regardless of which marking mode is used, the block will be"
DATA "captured as soon as any non-marking key has been pressed.  If"
DATA "either Del or Shift-Del is pressed, the block will first be"
DATA "captured and then deleted.  To paste the block from the"
DATA "buffer into the text at the current cursor location, simply"
DATA "press Shift-Ins."
DATA ""
DATA "All of the code to process block operations is placed in a"
DATA "single section of the QEdit subprogram.  This way you can"
DATA "easily remove or REMark out those lines, to reduce the size"
DATA "of your program if that feature is not needed."
DATA ""
DATA "The call for QEdit is fairly simple to set up, as illustrated"
DATA "in the DEMOEDIT.BAS demonstration program.  Your program will"
DATA "need to dimension a conventional (not fixed-length) string"
DATA "array to hold the lines of text.  The size to which the"
DATA "string array is dimensioned dictates the maximum number of"
DATA "lines that may be entered."
DATA ""
DATA "If you intend to present a blank screen to your user, then no"
DATA "additional steps are needed to prepare the array.  If you"
DATA "already have text that is to be edited, it may be placed in"
DATA "the array before QEdit is called.  The text may also be sent"
DATA "to QEdit as a single long line in the lowest array element."
DATA "In that case, it will be wrapped automatically before being"
DATA "presented for editing."
DATA ""
DATA "If you do pre-load the array with individual lines of text,"
DATA "an extra blank space should be present at the end of each"
DATA "line.  When QEdit wraps words to the next or previous line,"
DATA "the space is needed to prevent the end of one word from"
DATA "running into the beginning of another.  Comments in the QEDIT"
DATA "source code show how to insure that every line has at least"
DATA "one trailing space."
DATA ""
DATA "Like most of the other QuickPak Professional routines, the"
DATA "current cursor location indicates where to position the upper"
DATA "left corner of the editing window.  Six additional parameters"
DATA "are then used to indicate the width and height of the window,"
DATA "the right margin, the window color and border style, and edit"
DATA "action.  Let's take a closer look at each of these in turn."
DATA ""
DATA "The width and height parameters (Wide and Rows in the demo)"
DATA "tell QEdit the size of the editing window.  The width can"
DATA "range up to 80 if no border is specified, or 78 if a border"
DATA "is used.  The height may range up to 25 lines on a normal CGA"
DATA "or monochrome display.  If an EGA or VGA adapter is present"
DATA "and WIDTH is used to set more screen lines before QEdit is"
DATA "called, then the window may occupy up to 43 or 50 lines"
DATA "respectively."
DATA ""
DATA "The right margin (Wrap in the demo) indicates at what column"
DATA "word wrapping is to occur.  This is independent of the"
DATA "rightmost visible column, and may be set to nearly any value."
DATA "If the right margin extends beyond the right edge of the"
DATA "screen, QEdit will scroll the text to accommodate it.  Word"
DATA "wrap may also be disabled entirely by setting Wrap to zero."
DATA ""
DATA "    The window color follows the same convention as the other"
DATA "QuickPak routines, in that both the foreground and background"
DATA "colors are packed into a single value."
DATA ""
DATA "    The pop-up help screen is set to bright white on a red"
DATA "background, and this may be changed only by modifying the"
DATA "QEDIT.BAS source code.  Search for the remark HELP COLOR to"
DATA "see where this is set.  The position of the help screen is"
DATA "also fixed, near the upper right corner of the display.  The"
DATA "LOCATE just above the help color is easy to spot, and may be"
DATA "changed as well."
DATA ""
DATA "    Notice that the QEdit help text is stored outside of BASIC's"
DATA "normal string space, to leave your program as much string"
DATA "memory as possible.  The technique used to accomplish this is"
DATA "described in detail in the Appendix of this manual."
DATA ""
DATA "    The border style (Frame in the demo) indicates whether or not"
DATA "to draw a border around the editing window, and if so what"
DATA "style to use.  QEdit uses the QuickPak Box routine to draw"
DATA "the border, so the same codes are used here.  That is, a 1"
DATA "means to draw a single line box, a 2 means double, and so"
DATA "forth.  If the border is set to zero, no frame will be drawn."
DATA ""
DATA "    The final parameter is an action flag, which allows you to"
DATA "call QEdit more than once, without having to re-display the"
DATA "screen.  Similar to the action flag used by PullDown and"
DATA "VertMenu, a value of zero means to enter the editor and wait"
DATA "there until Escape is pressed.  Likewise, setting Action to 5"
DATA "clears the window and restores the original screen contents."

'$INCLUDE: 'QEDIT.BAS'
' '$INCLUDE: 'QEDIT7.BAS'
' '$INCLUDE: 'QEDITS.BAS'
'$INCLUDE: 'PRO.BAS'