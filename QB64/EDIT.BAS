' ********** EDIT.BAS - a clone of EDIT.COM from MS-DOS

' Copyright (c) 2022 Cory Smith

DEFINT A-Z

'$INCLUDE: 'QPPRO.BI'

_TITLE "EDIT.EXE"

CONST FALSE = 0
CONST TRUE = NOT FALSE

'_FULLSCREEN _SQUAREPIXELS

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
' TODO: Need to update the status bar with the help message as the items are highlighted.

' TODO: Need to add support for pressing F1 on a menu item to see specific associated help.

' TODO: Need to add support for editing...

' TODO: Need to update line/col (lower right) during cursor movement on the edit canvas.

' TODO: The following should only happen first time launching.
'CALL ShowWelcomeAction

dr = 1
dc = 1

DO

  LOCATE 13, 41, 0

  ky$ = INKEY$                          ' Get a key press from the buffer
                                        ' See if it's a hot-key or mouse
                                        ' pressed on menu bar.
  menu = PullMenKey(ky$, menu$(), stat())
  
  IF menu > -1 THEN                     ' Yes

    ' using menu in "polling mode"
    action = 1
    DO                                        
      CALL PullDnMs (menu$(), stat(), menu, choice, ky$, action)
      SELECT CASE menu
        CASE 0, 1, 2, 3, 4
          'LOCATE 23, 2: PRINT "action="; action; ", menu="; menu; ", choice="; choice
          CALL UpdateStatus(msg$(choice, menu), dr, dc)
        CASE ELSE
      END SELECT
      SELECT CASE ky$
        CASE ELSE
          
      END SELECT
    LOOP UNTIL action = 4
    CALL PullDnMs (menu$(), stat(), menu, choice, ky$, 5) ' Reset menu

    IF action = 4 THEN
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
        CASE 2 ' Search
        CASE 3 ' Options
        CASE 4 ' Help
          SELECT case choice
            CASE 1
            CASE 2
            CASE 4: CALL ShowAboutAction
          END SELECT
        CASE ELSE
      END SELECT
    END IF

    CALL UpdateStatus("", dr, dc)

  END IF

LOOP

HideCursor                              ' Turn the mouse cursor off

SYSTEM 'END

'$INCLUDE: 'PULLDNMS.BAS'
'$INCLUDE: 'QPPRO.BAS'

SUB UpdateStatus(text$, r, c) STATIC
  IF text$ <> value$ OR text$ = "*" THEN
    IF text$ = "" OR text$ = "*" THEN value$ = "MS-DOS Editor  <F1=Help> Press ALT to activate menus" ELSE value$ = text$
    QPrintRC SPACE$(80), 25, 1, OneColor(15, 3) ' clear the background
    IF LEN(value$) > 61 THEN
      QPrintRC LEFT$(value$, 78), 25, 2, OneColor(15, 3)
    ELSE
      QPrintRC LEFT$(value$, 61) + SPACE$(61 - LEN(value$)), 25, 2, OneColor(15, 3)
      QPrintRC CHR$(179), 25, 63, OneColor(0, 3)  ' draw the black separator
      QPrintRC STRING$(5 - LEN(_TRIM$(STR$(r))), 48) + _TRIM$(STR$(r)) + ":" + STRING$(3 - LEN(_TRIM$(STR$(c))), 48) + _TRIM$(STR$(c)), 25, 71, OneColor(0, 3) ' update cursor position.
    END IF
  END IF
END SUB

SUB NewAction
END SUB

SUB OpenAction
END SUB

SUB SaveAction
END SUB

SUB SaveAsAction
END SUB

SUB PrintAction
END SUB

FUNCTION ExitAction ()
  ExitAction = TRUE
END FUNCTION

SUB ShowWelcomeAction

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

SUB ShowAboutAction

  r = 9
  c = 14
  h = 8

  Box0 r, c, r + h, 66, 1, OneColor(0, 7)

  QPrintRC "                                                   ", r + 1, 15, OneColor(0, 7)
  QPrintRC "                    MS-DOS Editor                  ", r + 2, 15, OneColor(0, 7)
  QPrintRC "                     Version 1.0                   ", r + 3, 15, OneColor(0, 7)
  QPrintRC "  Copyright (C) Microsoft Corporation, 1987-1991.  ", r + 4, 15, OneColor(0, 7)
  QPrintRC "                                                   ", r + 5, 15, OneColor(0, 7)

  QPrintRC CHR$(195) + STRING$(51, 196) + CHR$(180), r + 6, 14, OneColor(0, 7)
  QPrintRC "                       < OK >                      ", r + 7, 15, OneColor(0, 7)

  DO
    ky$ = INKEY$
    IF ky$ = CHR$(27) THEN EXIT DO
  LOOP
  ClearScr0 r, c, r + h, 66, OneColor(0, 1)

END SUB