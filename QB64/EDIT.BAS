' ********** EDIT.BAS - a clone of EDIT.EXE from MS-DOS

' Copyright (c) 2022 Cory Smith

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
_TITLE "EDIT.EXE" 'NOTE: Moving title above resize causes resize to fail (without an error???)
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
'$INCLUDE: 'QEDITYPE.BI'
'$INCLUDE: 'DIALOG.BI'

DIM SHARED edState AS EditInfo

edState.AColor = 23      ' white on blue
edState.Wrap = 0         ' word wrap at column 65 (use 0 for to disable word wrap)
edState.Frame = 0        ' frame code (1 = show ruler line & scroll bars, 0 = don't)
edState.Rows = 21        ' number of text lines to display on the screen (3 - 25)
edState.Wide = 78        ' width of the active screen (10 - 80)
edState.HTab = 2         ' set tab stops to 4 spaces

REDIM SHARED array$(32767)               ' holds the main editor string array
DIM SHARED qeditAction AS INTEGER

CONST FALSE = 0
CONST TRUE = NOT FALSE

CLS

InitMouse there                         ' Define the Mouse cursor
TextCursor -2, 4                        ' Inverse foreground red background
SetCursor 1, 1                          ' Locate it at upper right of screen
ShowCursor                              ' Turn it on

'PRINT OneColor(0, 1): END

LOCATE 2: MQPrint STRING$(23 * 80, CHR$(32)), OneColor(7, 1)  ' Make a background for the demo
Box0 2, 1, 24, 80, 1, OneColor(7, 1)

QPrintRC " Untitled ", 2, 35, OneColor(1, 7)

CALL UpdateStatus ("*", 0, 0)

QPrintRC CHR$(179), 24, 1, OneColor(7, 1)
QPrintRC CHR$(27), 24, 2, OneColor(0, 7)
FOR c = 3 TO 78
  QPrintRC CHR$(177), 24, c, OneColor(0, 7)
NEXT
QPrintRC CHR$(26), 24, 79, OneColor(0, 7)
QPrintRC CHR$(179), 24, 80, OneColor(7, 1)
QPrintRC CHR$(24), 3, 80, OneColor(0, 7)
FOR r = 4 TO 22
  QPrintRC CHR$(177), r, 80, OneColor(0, 7)
NEXT
QPrintRC CHR$(25), 23, 80, OneColor(0, 7)

LOCATE 13, 41, 1

' ----- Main Menu

REDIM menu$(15, 4)                      ' Allocate space for the Menu Choices
REDIM stat(15, 4)                       ' Define the choice status array
REDIM msg$(15, 4)                       ' The help message for each menu item
REDIM help$(15, 4)                      ' The detailed help (F1) for each menu item

prefix$ = "F1=Help " + CHR$(179) + " "

menu$(0, 0) = "File"
menu$(1, 0) = "New" : msg$(1, 0) = prefix$ + "Removes currently loaded file from memory"
menu$(2, 0) = "Open...": msg$(2, 0) = prefix$ + "Loads new file into memory"
menu$(3, 0) = "Save" : msg$(3, 0) = prefix$ + "Saves current file"
 stat(3, 0) = 1
menu$(4, 0) = "Save As..." : msg$(4, 0) = prefix$ + "Saves current file with specified name"
 stat(4, 0) = 5 * 256
menu$(5, 0) = "-"
menu$(6, 0) = "Print" : msg$(6, 0) = prefix$ + "Prints specified text"
menu$(7, 0) = "-"
menu$(8, 0) = "Exit" : msg$(8, 0) = prefix$ + "Exits editor and returns to DOS"
 stat(8, 0) = 256

menu$(0, 1) = "Edit"
menu$(1, 1) = "Cut        Shift+Del" : msg$(1, 1) = prefix$ + "Deletes selected text and copies it to buffer"
 stat(1, 1) = 2 * 256 + 1
menu$(2, 1) = "Copy        Ctrl+Ins" : msg$(2, 1) = prefix$ + "Copies selected text to buffer"
 stat(2, 1) = 1
menu$(3, 1) = "Paste      Shift+Ins" : msg$(3, 1) = prefix$ + "Inserts buffer contents at current location"
 stat(3, 1) = 1
menu$(4, 1) = "Clear            Del" : msg$(4, 1) = prefix$ + "Deletes selected text without copying it to buffer"
 stat(4, 1) = 2 * 256 + 1

menu$(0, 2) = "Search"
menu$(1, 2) = "Find..." : msg$(1, 2) = prefix$ + "Finds specified text"
menu$(2, 2) = "Repeat Last Find      F3" : msg$(2, 2) = prefix$ + "Finds the next occurence of text specified in previous search"
menu$(3, 2) = "Change..." : msg$(3, 2) = prefix$ + "Finds and changes specified text"

menu$(0, 3) = "Options"
menu$(1, 3) = "Display..." : msg$(1, 3) = prefix$ + "Changes display attributes"
menu$(2, 3) = "Help Paths..." : msg$(2, 3) = prefix$ + "Sets search path for Help files"

menu$(0, 4) = "Help"
 'stat(0, 4) = 42 ' this will "push over" (pad) the Help menu as desired,
                  ' however, the actual pull down menu logic doesn't handle
                  ' being "past" the right side of the screen (crashes).
menu$(1, 4) = "Getting Started...": msg$(1, 4) = prefix$ + "Displays information on loading and using the MS-DOS Editor"
menu$(2, 4) = "Keyboard": msg$(2, 4) = prefix$ + "Displays navigation and editing keystrokes"
menu$(3, 4) = "-"
menu$(4, 4) = "About...": msg$(4, 4) = prefix$ + "Displays product version and copyright information"

CALL BarPrint (menu$(), stat())         ' Display the menu bar and build a
                                        ' table of Hot Keys for menu bar.

action = 0                              ' Action 0 (no polling) is the easiest
                                        ' way to use PullDown.

' TODO: The Help menu should be on the right side of the line
' TODO: Need to add support for pressing F1 on a menu item to see specific associated help.

' TODO: The following should only happen first time launching.
'CALL WelcomeAction

qeditAction = 1

LOCATE 3, 2, 0

DO

  '----- call QEdit in polled mode
  CALL QEdit(array$(), ky$, qeditAction, edState)

  menu = PullMenKey(ky$, menu$(), stat())
  
  IF menu > -1 THEN                     ' Yes

    ' using menu in "polling mode"
    menuAction = 1
    DO                                        
      CALL PullDnMs (menu$(), stat(), menu, choice, ky$, menuAction)
      SELECT CASE menu
        CASE 0, 1, 2, 3, 4
          CALL UpdateStatus(msg$(choice, menu), edState.CurLine, edState.CurCol)
        CASE ELSE
      END SELECT
      SELECT CASE ky$
        CASE ELSE
      END SELECT
    LOOP UNTIL menuAction = 4
    CALL PullDnMs (menu$(), stat(), menuAction, choice, ky$, 5) ' Reset menu

    ky$ = ""

    IF menuAction = 4 THEN
      SELECT CASE menu
        CASE 0 ' File
          SELECT CASE choice
            CASE 1: CALL NewAction
            CASE 2: CALL OpenAction
            CASE 3: CALL SaveAction
            CASE 4: CALL SaveAsAction
            CASE 6: CALL PrintAction
            CASE 8: IF ExitAction THEN EXIT DO
            CASE ELSE
          END SELECT
        CASE 1 ' Edit
          SELECT case choice
            CASE 1: CALL CutAction
            CASE 2: CALL CopyAction
            CASE 3: CALL PasteAction
            CASE 4: CALL ClearAction
          END SELECT
        CASE 2 ' Search
          SELECT case choice
            CASE 1: CALL FindAction
            CASE 2: CALL RepeatLastFindAction
            CASE 3: CALL ChangeAction
          END SELECT
        CASE 3 ' Options
          SELECT case choice
            CASE 1: CALL DisplayAction
            CASE 2: CALL HelpPathsAction
          END SELECT
        CASE 4 ' Help
          SELECT case choice
            CASE 1: CALL HelpGettingStartedAction
            CASE 2: CALL HelpKeyboardAction
            CASE 4: CALL HelpAboutAction
          END SELECT
        CASE ELSE
      END SELECT
    END IF

    CALL UpdateStatus("", edState.CurLine, edState.CurCol)

  END IF

  loc$ = FUsing$(STR$(edState.CurLine), "#####") + ":" + FUsing$(STR$(edState.CurCol), "###")
  CALL ReplaceString (loc$, " ", "0")
  IF prevLoc$ <> loc$ THEN
    QPrintRC loc$, 25, 71, OneColor(0, 3) ' update cursor position.
    prevLoc$ = loc$
  END IF

LOOP

'----- call QEdit again with an Action flag of 5 to restore the screen
CALL QEdit(array$(), ky$, 5, edState)

HideCursor                              ' Turn the mouse cursor off

SYSTEM 'END

'$INCLUDE: 'PULLDNMS.BAS'
'$INCLUDE: 'DIALOG.BAS'
'$INCLUDE: 'QEDIT.BAS'
'$INCLUDE: 'PRO.BAS'

' ******************************************************************************
' * Internal Methods
' ******************************************************************************

' MsgBox (prompt, [buttons,] [title,] [helpfile, context])
SUB VbMsgBox(prompt$, buttons, title$) ', helpFile$, context)

  ' prompt$
  '   - the message in the dialog box. If the prompt$ consists of more 
  '     than one line, you can separate the lines using a carriage return 
  '     character (CHR$(13)), or linefeed character (Chr$(10)), or carriage
  '     return - linefeed character combination (Chr$(13) & Chr$(10)) 
  '     between each line.
  ' buttons
  '   - the number and type of buttons to display, the icon style to use, 
  '     the identity of the default button, and the modality of the message 
  '     box. Defaults to 0.
  ' title$
  '   - optional title bar of the dialog box.
  ' helpFile$
  '   - optional help file to use to provide context sensitive help for the dialog 
  '     box. If provided, context is also required.
  ' context
  '   - optional help context number assigned to the appropriate help topic by the 
  '     help author.

  'TODO: Handle buttons value.

  ' vbOKOnly = 0
  ' vbOKCancel = 1
  ' vbAbortRetryIgnore = 2
  ' vbYesNoCancel = 3
  ' vbYesNo = 4
  ' vbRetryCancel = 5
  ' vbCritical = 16
  ' vbQuestion = 32
  ' vbExclamation = 48
  ' vbInformation = 64
  ' vbDefaultButton1 = 0
  ' vbDefaultButton2 = 256
  ' vbDefaultButton3 = 512
  ' vbDefaultButton4 = 768
  ' vbApplicationModal = 0
  ' vbSystemModal = 4096
  ' vbMsgBoxHelpButton = 16384
  ' vbMsgBoxSetForeground = 65536
  ' vbMsgBoxRight = 524288
  ' vbMsgBoxRtlReading = 1048576

  REDIM menu$(0)
  REDIM text$(4)
  REDIM response$(0)
  text$(0) = title$
  text$(1) = "< OK >"
  text$(2) = " "
  text$(3) = prompt$
  text$(4) = " "
  action = 0: scrnRow = 0: choice = 1: clr = 112: style = 11

  CALL Dialog(choice, text$(), response$(), menu$(), scrnRow, style, clr, action)

END SUB

SUB UpdateStatus(text$, r, c) STATIC
  IF text$ <> value$ OR text$ = "*" THEN
    IF text$ = "" OR text$ = "*" THEN value$ = "MS-DOS Editor  <F1=Help> Press ALT to activate menus" ELSE value$ = text$
    QPrintRC SPACE$(80), 25, 1, OneColor(15, 3) ' clear the background
    IF LEN(value$) > 61 THEN
      QPrintRC LEFT$(value$, 78), 25, 2, OneColor(15, 3)
    ELSE
      QPrintRC LEFT$(value$, 61) + SPACE$(61 - LEN(value$)), 25, 2, OneColor(15, 3)
      QPrintRC CHR$(179), 25, 63, OneColor(0, 3)  ' draw the black separator
      loc$ = FUsing$(STR$(edState.CurLine), "#####") + ":" + FUsing$(STR$(edState.CurCol), "###")
      CALL ReplaceString (loc$, " ", "0")
      QPrintRC loc$, 25, 71, OneColor(0, 3) ' update cursor position.
    END IF
  END IF
END SUB

' ******************************************************************************
' * ACTIONS
' ******************************************************************************

SUB NewAction

  modified = -1

  IF modified THEN

    REDIM menu$(0)
    REDIM text$(7)
    REDIM response$(0)
    text$(1) = "< Yes >"
    text$(2) = "< No >"
    text$(3) = "< Cancel >"
    text$(4) = "< Help >"
    text$(5) = " "
    text$(6) = "Loaded file is not saved. Save it now?"
    text$(7) = " "
    scrnRow = -1: choice = 1: clr = 112: style = 11

    LOCATE 10                   'Top of Dialog box is at line 5
    CALL Dialog(choice, text$(), response$(), menu$(), scrnRow, style, clr, action)

    SELECT CASE choice
      CASE 1: ' Yes
      CASE 2: ' No
      CASE 3: ' Cancel
        EXIT FUNCTION
      CASE 4: ' Help
        EXIT FUNCTION
    END SELECT
  
  END IF

  FOR i = LBOUND(array$) TO UBOUND(array$): array$(i) = "": NEXT
  edState.CurLine = 1
  edState.CurCol = 1
  qeditAction = 2

END SUB

SUB OpenAction

  CALL VbMsgBox("Not implemented.", 0, "")
  EXIT SUB

  'NOTE: Current Dialog implementation (from old QPP) is not able to 
  '      handle the design requirements/layout for the Open dialog in
  '      the original MS-DOS EDIT program.
  'TODO: Need to implement the Open dialog.

  spec$ = "*.*"                  ' Read some files names for the first demo
  count = FCount%(spec$)         ' Count the files

  IF count = 0 THEN count = 1    ' In case there are no matching files
  REDIM menu$(count)             ' Make an array to hold them
  FOR i = 1 TO count             ' Allocate space for each name
    menu$(i) = SPACE$(12)
  NEXT

  menu$(0) = spec$               ' Read the names
  'CALL ReadFile(BYVAL VARPTR(menu$(0)))
  CALL ReadFile(menu$())

  REDIM text$(7)
  REDIM response$(7)
  text$(0) = " Open "            ' Dialog Box title (if any) goes in element 0
  text$(1) = "< OK >"            ' Command buttons MUST start at element 1 and
  text$(2) = "< Cancel >"        '   MUST be contiguous. You may have as many
  text$(3) = "< Help >"          '   buttons as will fit on the screen or as few
                                 '   as one
  text$(4) = "{25} File Name:"   ' The {} indicate a text input box. The number
                                 '   within the brackets indicate the max length of
                                 '   text to be entered. Adding 100 to this number
                                 '   will force numbers only to be entered
  text$(5) = "|305| Files"       ' The || indicate a list box. The right two
                                 '   digits between these two characters indicate
                                 '   the number of menu lines to display, however,
                                 '   this number may be overridden if the Dialog
                                 '   box-8 height is geater. To display multiple
                                 '   columns, add the number of columns * 100.
  'text$(6) = "|105| Dirs/Drives"
  text$(6) = "C:\"
  text$(7) = " "                 ' Blank line
  response$(4) = spec$           ' Make "File Name: text box display Spec$
  response$(6) = text$(6)
  temp$ = response$(4)           ' Keep a copy of Spec$ for later
  style = 11                     ' Single line all around with a drop shadow
  clr = 112                      ' Black text on white background
  scrnRow = 0                    ' Center the Dialog box vertically
  action = 0                     ' Not re-entrant
  choice = 1                     ' Must initialize Choice to 1

  CALL Dialog(choice, text$(), response$(), menu$(), scrnRow, style, clr, action)

END SUB

SUB SaveAction

  IF filename$ = "" THEN
    CALL SaveAsAction
  ELSE
    ' Save and update status
  END IF

END SUB

SUB SaveAsAction

  'NOTE: Current Dialog implementation (from old QPP) is not able to 
  '      handle the design requirements/layout for the Save dialog in
  '      the original MS-DOS EDIT program.
  'TODO: Need to implement the Save dialog.

  '      Changes needed:
  '      
  '      - The "File Name:" label needs to be on the same line as the field.
  '      - The current path location needs to be left justified.
  '      - The Dirs/Drives label and list needs to be below the label.
  '      - Need to implement scrollbar functionality on the list.

  spec$ = "*.*"                  ' Read some directory names
  count = DCount%(spec$)         ' Count the directories

  IF count = 0 THEN count = 1    ' In case there are no matching directories
  REDIM menu$(count)             ' Make an array to hold them
  FOR i = 1 TO count             ' Allocate space for each name
    menu$(i) = SPACE$(12)
  NEXT

  menu$(0) = spec$               ' Read the names
  menu$(1) = spec$               ' Read the names
  CALL ReadDir(menu$(), 1)
  menu$(1) = "..          "

  REDIM text$(6)
  REDIM response$(6)
  'TODO: Need to handle whether to show " Save " or " Save As " depending on current state.
  text$(0) = " Save "            ' Dialog Box title (if any) goes in element 0
  text$(1) = "< OK >"            ' Command buttons MUST start at element 1 and
  text$(2) = "< Cancel >"        '   MUST be contiguous. You may have as many
  text$(3) = "< Help >"          '   buttons as will fit on the screen or as few
                                 '   as one
  text$(4) = "{25} File Name:"   ' The {} indicate a text input box. The number
                                 '   within the brackets indicate the max length of
                                 '   text to be entered. Adding 100 to this number
                                 '   will force numbers only to be entered
  text$(5) = _CWD$
  text$(6) = "|107| Dirs/Drives" ' The || indicate a list box. The right two
                                 '   digits between these two characters indicate
                                 '   the number of menu lines to display, however,
                                 '   this number may be overridden if the Dialog
                                 '   box-8 height is geater. To display multiple
                                 '   columns, add the number of columns * 100.
  response$(4) = ""              ' Make "File Name: text box display spec$
  response$(5) = text$(5)
  temp$ = response$(5)           ' Keep a copy of spec$ for later
  style = 11                     ' Single line all around with a drop shadow
  clr = 112                      ' Black text on white background
  scrnRow = 0                    ' Center the Dialog box vertically
  action = 0                     ' Not re-entrant
  choice = 1                     ' Must initialize Choice to 1

  CALL Dialog(choice, text$(), response$(), menu$(), scrnRow, style, clr, action)

END SUB

SUB PrintAction

  REDIM menu$(0)
  REDIM text$(8)
  REDIM response$(8)
  text$(0) = " Print "
  text$(1) = "< OK >"
  text$(2) = "< Cancel >"
  text$(3) = "< Help >"
  text$(4) = " "
  text$(5) = "( ) Selected Text Only"
  text$(6) = "( ) Complete Document"
  text$(7) = " "
  text$(8) = " "
  response$(6) = CHR$(7)
  scrnRow = 0
  clr = 112
  style = 11
  choice = 1

  CALL Dialog(choice, text$(), response$(), menu$(), scrnRow, style, clr, action)

END SUB

FUNCTION ExitAction ()

  modified = 0

  IF modified THEN

    REDIM menu$(0)
    REDIM text$(7)
    REDIM response$(0)
    text$(1) = "< Yes >"
    text$(2) = "< No >"
    text$(3) = "< Cancel >"
    text$(4) = "< Help >"
    text$(5) = " "
    text$(6) = "Loaded file is not saved. Save it now?"
    text$(7) = " "
    scrnRow = -1: choice = 1: clr = 112: style = 11

    LOCATE 10                   'Top of Dialog box is at line 5
    CALL Dialog(choice, text$(), response$(), menu$(), scrnRow, style, clr, action)

    SELECT CASE choice
      CASE 1: ExitAction = TRUE ' Yes
      CASE 2: ExitAction = TRUE ' No
      CASE 3: ' Cancel
      CASE 4: ' Help
    END SELECT
  
  ELSE
    ExitAction = TRUE
  END IF
 
END FUNCTION

SUB CutAction
  CALL VbMsgBox("Not implemented.", 0, "")
END SUB
            
SUB CopyAction
  CALL VbMsgBox("Not implemented.", 0, "")
END SUB

SUB PasteAction
  CALL VbMsgBox("Not implemented.", 0, "")
END SUB
       
SUB ClearAction
  CALL VbMsgBox("Not implemented.", 0, "")
END SUB

SUB FindAction

  REDIM menu$(0)
  REDIM text$(9)
  REDIM response$(9)
  text$(0) = " Find "
  text$(1) = "< OK >"
  text$(2) = "< Cancel >"
  text$(3) = "< Help >"
  text$(4) = "{51} Find What:"
  text$(5) = " "
  text$(6) = " "
  text$(7) = "[ ] Match Upper/Lowercase"
  text$(8) = "[ ] Whole Word"
  text$(9) = " "
  response$(7) = ""
  response$(8) = ""
  scrnRow = 0
  clr = 112
  style = 11
  choice = 1

  CALL Dialog(choice, text$(), response$(), menu$(), scrnRow, style, clr, action)

END SUB

SUB RepeatLastFindAction
  CALL VbMsgBox("Not implemented.", 0, "")
END SUB

SUB ChangeAction

  REDIM menu$(0)
  REDIM text$(10)
  REDIM response$(10)
  text$(0) = " Change "
  text$(1) = "< Find And Verify >"
  text$(2) = "< Change All >"
  text$(3) = "< Cancel >"
  text$(4) = "< Help >"
  text$(5) = "{51} Find What:"
  text$(6) = "{51} Change To:"
  text$(7) = " "
  text$(8) = "[ ] Match Upper/Lowercase"
  text$(9) = "[ ] Whole Word"
  text$(10) = " "
  response$(8) = ""
  response$(9) = ""
  scrnRow = 0
  clr = 112
  style = 11
  choice = 1

  CALL Dialog(choice, text$(), response$(), menu$(), scrnRow, style, clr, action)

END SUB

SUB DisplayAction
  CALL VbMsgBox("Not implemented.", 0, "")
END SUB
            
SUB HelpPathsAction

  REDIM menu$(0)
  REDIM text$(5)
  REDIM response$(5)
  text$(0) = " Help Path "
  text$(1) = "< OK >"
  text$(2) = "< Cancel >"
  text$(3) = "< Help >"
  text$(4) = " "
  text$(5) = "{51} Location (path) of EDIT.HLP file:"
  scrnRow = 0
  clr = 112
  style = 11
  choice = 1

  CALL Dialog(choice, text$(), response$(), menu$(), scrnRow, style, clr, action)

END SUB

SUB HelpGettingStartedAction
  CALL VbMsgBox("Not implemented.", 0, "")
END SUB

SUB HelpKeyboardAction
  CALL VbMsgBox("Not implemented.", 0, "")
END SUB

SUB HelpAboutAction

  REDIM menu$(0)
  REDIM text$(6)
  REDIM response$(0)
  text$(1) = "< OK >"
  text$(2) = " "
  text$(3) = "MS-DOS Editor"
  text$(4) = "Version 1.0"
  text$(5) = "Copyright (C) Microsoft Corporation, 1987-1991."
  text$(6) = " "
  scrnRow = -1: choice = 1: clr = 112: style = 11

  LOCATE 9
  CALL Dialog(choice, text$(), response$(), menu$(), scrnRow, style, clr, action)

END SUB

SUB WelcomeAction

  Box0 7, 14, 17, 66, 1, OneColor(0, 7)
  QPrintRC "                                                   ", 8, 15, OneColor(0, 7)
  QPrintRC "            Welcome to the MS-DOS Editor           ", 9, 15, OneColor(0, 7)
  QPrintRC "                                                   ", 10, 15, OneColor(0, 7)
  QPrintRC "  Copyright (C) Microsoft Corporation, 1987-1991.  ", 11, 15, OneColor(0, 7)
  QPrintRC "                All rights reserved.               ", 12, 15, OneColor(0, 7)
  QPrintRC "                                                   ", 13, 15, OneColor(0, 7)
  QPrintRC "     < Press Enter to see the Survival Guide >     ", 14, 15, OneColor(0, 7)
  QPrintRC CHR$(195) + STRING$(51, 196) + CHR$(180), 15, 14, OneColor(0, 7)
  QPrintRC "      < Press ESC to clear this dialog box >       ", 16, 15, OneColor(0, 7)
  DO
    ky$ = INKEY$
    IF ky$ = CHR$(27) THEN EXIT DO
  LOOP
  ClearScr0 7, 14, 17, 66, OneColor(0, 1)

END SUB