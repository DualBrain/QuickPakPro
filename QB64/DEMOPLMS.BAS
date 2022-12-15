' ********** DEMOPLMS.BAS - pull down menu demonstration program

' by Donald R. Malin
' Copyright (c) 1987-1990 Crescent Software
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
_TITLE "DEMOPULL" 'NOTE: Moving title above resize causes resize to fail (without an error???)
'BUG: It would be nice specify the icon here, but... having to require full path or placing it in the qb64 folder is problematic. 
'NOTE: The above boiler plate must be first in execution (top of file).
'BUG:  Also appears to not work as an $INCLUDE; suggesting something might
'      be wrong with the implementation of $INCLUDE.
' **************************
' * BOILER PLATE END
' **************************

DEFINT A-Z

'$INCLUDE: 'PRO.BI'

DECLARE FUNCTION Monitor% ()
DECLARE FUNCTION PullMenKey% (ky$, menu$(), stat())

DECLARE SUB BarPrint (choice$(), stat%())
DECLARE SUB HideCursor ()
DECLARE SUB InitMouse (there%)
DECLARE SUB MQPrint (txt$, colr%)
DECLARE SUB PullDnMs (menu$(), stat(), menu%, choice%, ky$, action%)
DECLARE SUB SetCursor (row, col)
DECLARE SUB ShowCursor ()
DECLARE SUB TextCursor (fg%, bg%)

CLS

InitMouse there%                        ' Define the Mouse cursor
TextCursor -2, 4                        ' Inverse foreground red background
SetCursor 1, 1                          ' Locate it at upper right of screen
ShowCursor                              ' Turn it on

LOCATE 2
' The following line looks a lot like System 7.
' MQPrint STRING$(23 * 80, CHR$(176)), 7            ' Make a background for the demo
' Switched out instead for a more EDIT.COM look.
MQPrint STRING$(23 * 80, CHR$(32)), OneColor(7, 1)  ' Make a background for the demo
Box0 2, 1, 24, 80, 1, OneColor(7, 1)

LOCATE 25, 1                            ' Print instructions
MQPrint "Hold the [Alt] key down and then press the first letter of the desired menu.    ", OneColor(15, 3) '112
LOCATE 13, 41, 1

' ----- Define the Menu Choices here
REDIM menu$(15, 8)                      ' Allocate space for the Menu Choices
REDIM stat(15, 8)                       ' Define the choice status array

' To set the "Hot Key" character for a menu choice, set the High byte of the
' corresponding element of the "stat()" array to the offset into the string
' of the letter.
'
' Example: Make the "A" hot in "Save As...".
'
'                  0123456789
'   menu$(5, 0) = "Save As..."
'                ┌──────┘
'   stat(5, 0) = 5 * 256 + 1
'                          ^ Optional to make the choice inactive.
'
' If you later want to reset the status (active/inactive) without affecting
' the hot key position in the high byte, use the "SetStatus" sub program as
' follows:
'
' status = LEN(fileName$) = 0          ' Can't save a file until one is loaded
' CALL SetStatus(stat(5, 0), status)   ' If there was no file name, choice 5
'                                      ' of menu 0 will be made inactive.

' ----- Define the menus

menu$(0, 0) = "File"
menu$(1, 0) = "New Program"
menu$(2, 0) = "Open Program..."
menu$(3, 0) = "Merge..."
menu$(4, 0) = "Save"
 stat(4, 0) = 1
menu$(5, 0) = "Save As..."
 stat(5, 0) = 5 * 256
menu$(6, 0) = "Save All"
 stat(6, 0) = 2 * 256
menu$(7, 0) = "-"
menu$(8, 0) = "Create File..."
menu$(9, 0) = "Load File..."
menu$(10, 0) = "Unload File..."
 stat(10, 0) = 1
menu$(11, 0) = "-"
menu$(12, 0) = "Print"
menu$(13, 0) = "DOS Shell"
menu$(14, 0) = "-"
menu$(15, 0) = "Exit"
 stat(15, 0) = 256

menu$(0, 1) = "Edit"
menu$(1, 1) = "Undo   Alt+Backspace"
 stat(1, 1) = 1
menu$(2, 1) = "Cut        Shift+Del"
 stat(2, 1) = 2 * 256 + 1
menu$(3, 1) = "Copy        Ctrl+Ins"
 stat(3, 1) = 1
menu$(4, 1) = "Paste      Shift+Ins"
 stat(4, 1) = 1
menu$(5, 1) = "Clear            Del"
 stat(5, 1) = 2 * 256 + 1
menu$(6, 1) = "-"
menu$(7, 1) = "New SUB..."
 stat(7, 1) = 4 * 256
menu$(8, 1) = "New FUNCTION..."
 stat(8, 1) = 4 * 256

menu$(0, 2) = "View"
menu$(1, 2) = "SUBS...         F2"
menu$(2, 2) = "Next SUB  Shift+F2"
 stat(2, 2) = 1 * 256
menu$(3, 2) = "Split"
 stat(3, 2) = 1 * 256
menu$(4, 2) = "-"
menu$(5, 2) = "Next Statement"
 stat(5, 2) = 1
menu$(6, 2) = "Output Screen   F4"
 stat(6, 2) = 1 * 256
menu$(7, 2) = "-"
menu$(8, 2) = "Included File"
 stat(8, 2) = 1
menu$(9, 2) = "Included Lines"
 stat(9, 2) = 9 * 256

menu$(0, 3) = "Search"
menu$(1, 3) = "Find..."
menu$(2, 3) = "Selected Text     Ctrl+\"
menu$(3, 3) = "Repeat Last Find      F3"
menu$(4, 3) = "Change..."
menu$(5, 3) = "Label"

menu$(0, 4) = "Run"
menu$(1, 4) = "Start     Shift+F5"
menu$(2, 4) = "Restart"
menu$(3, 4) = "Continue        F5"
 stat(3, 4) = 2 * 256
menu$(4, 4) = "Modify COMMAND$..."
 stat(4, 4) = 7 * 256
menu$(5, 4) = "-"
menu$(6, 4) = "Make EXE File..."
 stat(6, 4) = 6 * 256
menu$(7, 4) = "Make Library..."
 stat(7, 4) = 5 * 256
menu$(8, 4) = "-"
menu$(9, 4) = "Set Main Module..."
 stat(9, 4) = 4 * 256

menu$(0, 5) = "Debug"
menu$(1, 5) = "Add Watch..."
menu$(2, 5) = "Instant Watch...   Shift+F9"
menu$(3, 5) = "Watchpoint..."
menu$(4, 5) = "Delete Watch..."
menu$(5, 5) = "Delete All Watch"
 stat(5, 5) = 2 * 256
menu$(6, 5) = "-"
menu$(7, 5) = "Trace On"
menu$(8, 5) = "History On"
menu$(9, 5) = "-"
menu$(10, 5) = "Toggle Breakpoint        F9"
 stat(10, 5) = 7 * 256
menu$(11, 5) = "Clear All BreakPoints"
menu$(12, 5) = "Break on Errors"
 stat(12, 5) = 9 * 256
menu$(13, 5) = "Set Next Statement"
 stat(13, 5) = 1

menu$(0, 6) = "Calls"
menu$(1, 6) = "DEMOPULL.BAS"

menu$(0, 7) = "Options"
menu$(1, 7) = " Display..."
 stat(1, 7) = 1 * 256
menu$(2, 7) = " Set Paths..."
 stat(2, 7) = 5 * 256
menu$(3, 7) = " Right Mouse..."
 stat(3, 7) = 7 * 256
menu$(4, 7) = " Syntax Checking" ' CHR$(7) = BELL
 stat(4, 7) = 1 * 256
menu$(5, 7) = " Full Menus" ' CHR$(7) = BELL
 stat(5, 7) = 1 * 256

menu$(0, 8) = "Help"
stat(0, 8) = 17

BarPrint menu$(), stat()                ' Display the menu bar and build a
                                        ' table of Hot Keys for menu bar.

action = 0                              ' Action 0 (no polling) is the easiest
                                        ' way to use PullDown.

DO

  LOCATE 13, 41, 0

  ky$ = INKEY$                          ' Get a key press from the buffer
                                        ' See if it's a hot-key or mouse
                                        ' pressed on menu bar.
  menu = PullMenKey(ky$, menu$(), stat())
  
  IF menu > -1 THEN                     ' Yes
                                        
    PullDnMs menu$(), stat(), menu, choice, ky$, action

    LOCATE 24, 1
    PRINT "Selection"; Choice; "was made from Menu"; Menu;

    '----- Code to handle the selection would go here
    '----- Example:
    'SELECT CASE menu                  'Branch according to "Menu"
    '   '----- File Menu
    '   CASE 0
    '      SELECT CASE choice          'Branch according to "Choice"
    '         '----- New Program
    '         CASE 1
    '            NewProgram            'Call your "NewProgram" procedure
    '         '----- Open Program
    '         CASE 2
    '            OpenProgram           'Call your "OpenProgram" procedure
    'Etc.

  END IF

  '----- Your code to handle key presses would go here
  '..
  '..

LOOP UNTIL (menu = 0 AND choice = 15) OR ky$ = CHR$(27)

HideCursor                              ' Turn the mouse cursor off

END

'$INCLUDE: 'PULLDNMS.BAS'
'$INCLUDE: 'PRO.BAS'