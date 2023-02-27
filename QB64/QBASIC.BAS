' ********** QBASIC.BAS - a clone of MS-DOS 5.0 QBASIC.EXE

' Copyright (c) 2023 Cory Smith

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
_TITLE "QBASIC.EXE" 'NOTE: Moving title above resize causes resize to fail (without an error???)
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
edState.Rows = 18        ' number of text lines to display on the screen (3 - 25)
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

' "Paint" the screen background blue.
LOCATE 2: MQPrint STRING$(23 * 80, CHR$(32)), OneColor(7, 1)

'TODO: Need to figure out how to handle the 4 different
'      'windows' (Help, Main, Split and Immediate).
'      Each window is *resizable* in that the title bar
'      between each can be moved. Additionally, the ESC key
'      when focused in help will close the Help window and 
'      restore the window sizes to what they were previously.
'      The "up arrow" is a "maximize" window toggle.
'      F6 will change focus between visible windows and will
'      cycle through currently active "maximize" windows.
'      Main is the only window that can't be closed (hidden).
'
' windowHelpVisible = 1
' windowHelpSpan = 20
' windowMainVisible = 1
' windowMainSpan = 20
' windowSplitVisible = 0
' windowImmediateVisible = 1
' windowImmediateSpan = 3 ' title line plus content.
' activeWindow = 2

' IF windowHelpVisible THEN
'   ' Draw a box.
'   Box0 2, 1, 2 + windowHelpSpan, 80, 1, OneColor(7, 0)
'   QPrintRC " Help ", 2, 37, OneColor(7, 0)
' ELSE
'   ' Draw a box.
'   Box0 2, 1, 2 + windowMainSpan, 80, 1, OneColor(7, 1)
'   'TODO: Need to utilize "center".
'   ' The title of the document.
'   QPrintRC " Untitled ", 2, 35, OneColor(1, 7)
' END IF

Box0 2, 1, 25, 80, 1, OneColor(7, 1)
'TODO: Need to utilize "center".
' The title of the document.
QPrintRC " Untitled ", 2, 35, OneColor(1, 7)

' Draw the status bar.
CALL UpdateStatus ("*", 0, 0)

' Upper right window (document) control.
QPrintRC CHR$(180) + CHR$(24) + CHR$(195), 2, 76, OneColor(7, 1)
QPrintRC CHR$(24), 2, 77, OneColor(1, 7)

' Splitter for the "Immediate" window.
splitter = 22
QPrintRC CHR$(195), splitter, 1, OneColor(7, 1)
QPrintRC STRING$(78, 196), splitter, 2, OneColor(7, 1)
QPrintRC " Immediate ", splitter, 35, OneColor(7, 1)
QPrintRC CHR$(180), splitter, 80, OneColor(7, 1)

' Draw the horizontal scroll bar.
br = splitter - 1 '24
QPrintRC CHR$(179), br, 1, OneColor(7, 1)
QPrintRC CHR$(27), br, 2, OneColor(0, 7)
FOR c = 3 TO 78
  QPrintRC CHR$(177), br, c, OneColor(0, 7)
NEXT
QPrintRC CHR$(26), br, 79, OneColor(0, 7)
QPrintRC CHR$(32), br, 3, OneColor(0, 0) ' current position

' Draw the vertical scroll bar.
QPrintRC CHR$(179), br, 80, OneColor(7, 1)
QPrintRC CHR$(24), 3, 80, OneColor(0, 7)
FOR r = 4 TO br-2 '22
  QPrintRC CHR$(177), r, 80, OneColor(0, 7)
NEXT
QPrintRC CHR$(25), br-1, 80, OneColor(0, 7)
QPrintRC CHR$(32), 4, 80, OneColor(0, 0) ' current position

'LOCATE 13, 41, 1

' ----- Main Menu

REDIM menu$(15, 7)                      ' Allocate space for the Menu Choices
REDIM stat(15, 7)                       ' Define the choice status array
REDIM msg$(15, 7)                       ' The help message for each menu item
REDIM help$(15, 7)                      ' The detailed help (F1) for each menu item

prefix$ = "F1=Help " + CHR$(179) + " "

menu$(0, 0) = "File"
menu$(1, 0) = "New" : msg$(1, 0) = prefix$ + "Removes currently loaded file from memory"
menu$(2, 0) = "Open...": msg$(2, 0) = prefix$ + "Loads new file into memory"
menu$(3, 0) = "Save" : msg$(3, 0) = prefix$ + "Saves current file"
' stat(3, 0) = 1
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
menu$(5, 1) = "-"
menu$(6, 1) = "New SUB..." : msg$(6, 1) = prefix$ + "Opens a window for a new subprogram"
 stat(6, 1) = 4 * 256
menu$(7, 1) = "New FUNCTION...": msg$(7, 1) = prefix$ + "Opens a window for a new FUNCTION procedure"
 stat(7, 1) = 4 * 256

menu$(0, 2) = "View"
menu$(1, 2) = "SUBs...               F2" : msg$(1, 2) = prefix$ + "Displays a loaded SUB or FUNCTION"
menu$(2, 2) = "Split" : msg$(2, 2) = prefix$ + "Divides screen into two View windows"
 stat(2, 2) = 1 * 256
menu$(3, 2) = "Output Screen         F4" : msg$(3, 2) = prefix$ + "Displays output screen"

menu$(0, 3) = "Search"
menu$(1, 3) = "Find..." : msg$(1, 3) = prefix$ + "Finds specified text"
menu$(2, 3) = "Repeat Last Find      F3" : msg$(2, 3) = prefix$ + "Finds the next occurence of text specified in previous search"
menu$(3, 3) = "Change..." : msg$(3, 3) = prefix$ + "Finds and changes specified text"

menu$(0, 4) = "Run"
menu$(1, 4) = "Start           Shift+F5" : msg$(1, 4) = prefix$ + "Runs current program"
menu$(2, 4) = "Restart" : msg$(2, 4) = prefix$ + "Clears variables in preparation for restarting single stepping"
menu$(3, 4) = "Continue              F5" : msg$(3, 4) = prefix$ + "Continues execution after a break"

menu$(0, 5) = "Debug"
menu$(1, 5) = "Step                  F8" : msg$(1, 5) = prefix$ + "Executes next program statement"
menu$(2, 5) = "Procedure Step       F10" : msg$(2, 5) = prefix$ + "Executes next program statement, tracing over procedure calls"
menu$(3, 5) = "-"
menu$(4, 5) = "Trace On" : msg$(4, 5) = prefix$ + "Highlights statement currently executing"
menu$(5, 5) = "-"
menu$(6, 5) = "Toggle Breakpoint     F9" : msg$(6, 5) = prefix$ + "Sets/clears breakpoint at cursor location"
 stat(6, 5) = 7 * 256
menu$(7, 5) = "Clear All Breakpoints" : msg$(7, 5) = prefix$ + "Removes all breakpoints"
menu$(8, 5) = "Set Next Statement" : msg$(8, 5) = prefix$ + "Makes the statement at the cursor the next statement to execute"
 stat(8, 5) = 4 * 256 + 1

menu$(0, 6) = "Options"
menu$(1, 6) = "Display..." : msg$(1, 6) = prefix$ + "Changes display attributes"
menu$(2, 6) = "Help Path..." : msg$(2, 6) = prefix$ + "Sets search path for Help files"
 stat(2, 6) = 5 * 256
menu$(3, 6) = "Syntax Checking" : msg$(3, 6) = prefix$ + "Turns editor's syntax checking on or off."

menu$(0, 7) = "Help"
 stat(0, 7) = 24  ' this will "push over" (pad) the Help menu as desired,
                  ' however, the actual pull down menu logic doesn't handle
                  ' being "past" the right side of the screen (crashes).
menu$(1, 7) = "Index": msg$(1, 7) = prefix$ + "Displays help index"
menu$(2, 7) = "Contents": msg$(2, 7) = prefix$ + "Displays help table of contents"
menu$(3, 7) = "Topic:                F1": msg$(3, 7) = prefix$ + "Displays information about the Basic keyword the cursor is on"
 stat(3, 7) = 1
menu$(4, 7) = "Using Help      Shift+F1": msg$(4, 7) = prefix$ + "Displays information about how to use online Help"
menu$(5, 7) = "-"
menu$(6, 7) = "About...": msg$(6, 7) = prefix$ + "Displays product version and copyright information"

CALL BarPrint (menu$(), stat())         ' Display the menu bar and build a
                                        ' table of Hot Keys for menu bar.

action = 0                              ' Action 0 (no polling) is the easiest
                                        ' way to use PullDown.

' TODO: The Help menu should be on the right side of the line
' TODO: Need to add support for pressing F1 on a menu item to see specific associated help.

LOCATE 3, 2, 0

' TODO: The following should only happen first time launching.
CALL WelcomeAction
CALL UpdateStatus("<Shift+F1=Help> <F6=Window> <F2=Subs> <F5=Run> <F8=Step>", edState.CurLine, edState.CurCol)

qeditAction = 1

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
        CASE 0, 1, 2, 3, 4, 5, 6, 7
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
          SELECT CASE choice
            CASE 1: CALL CutAction
            CASE 2: CALL CopyAction
            CASE 3: CALL PasteAction
            CASE 4: CALL ClearAction
            CASE 6: CALL NewSubAction
            CASE 7: CALL NewFunctionAction
          END SELECT
        CASE 2 ' View
          SELECT CASE choice
            CASE 1: CALL ViewSubsAction
            CASE 2: CALL ViewSplitAction
            CASE 3: CALL ViewOutputScreenAction
          END SELECT
        CASE 3 ' Search
          SELECT case choice
            CASE 1: CALL FindAction
            CASE 2: CALL RepeatLastFindAction
            CASE 3: CALL ChangeAction
          END SELECT
        CASE 4 ' Run
          SELECT CASE choice
            CASE 1: CALL StartAction
            CASE 2: CALL RestartAction
            CASE 3: CALL ContinueAction
          END SELECT
        CASE 5 ' Debug
          SELECT CASE choice
            CASE 1: CALL StepAction
            CASE 2: CALL ProcedureStepAction
            CASE 4: CALL ToggleTraceAction
            CASE 6: CALL ToggleBreakpointAction
            CASE 7: CALL ClearAllBreakpointsAction
            CASE 8: CALL SetNextStatementAction
          END SELECT
        CASE 6 ' Options
          SELECT case choice
            CASE 1: CALL DisplayAction
            CASE 2: CALL HelpPathAction
            CASE 3: CALL ToggleSyntaxCheckingAction
          END SELECT
        CASE 7 ' Help
          SELECT case choice
            CASE 1: CALL HelpIndexAction
            CASE 2: CALL HelpContentsAction
            CASE 3: CALL HelpTopicAction
            CASE 4: CALL HelpUsingHelpAction
            CASE 6: CALL HelpAboutAction
          END SELECT
        CASE ELSE
      END SELECT
    END IF

    'CALL UpdateStatus("", edState.CurLine, edState.CurCol)
    CALL UpdateStatus("<Shift+F1=Help> <F6=Window> <F2=Subs> <F5=Run> <F8=Step>", edState.CurLine, edState.CurCol)

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

  ulRow = 3
  ulCol = 7
  lrRow = 22 ' for QB, use 23
  lrCol = 73
  bClr = OneColor(0, 7)

  upperBound = 7
  numButtons = 3

  ' ----Hilite color will be Bright White unless foreground color is Bright White
  fFg = 15
  CALL SplitColor(bClr, fg, bg)
  IF fg = 15 THEN fFg = 0                 ' If foreground color is Bright White, make hilite Black
  hiLite = OneColor%(fFg, bg)
  hiClr = hiLite

  REDIM dial(6) AS DLog
  REDIM mouseBox(6) AS Area ' buttons

  ' Save
  sz = ArraySize(ulRow, ulCol, lrRow + 1, lrCol + 2)
  REDIM scrn(sz)
  CALL MScrnSave(ulRow, ulCol, lrRow + 1, lrCol + 2, scrn())

  '***** Form *****

  ' - Background
  CALL ClearScr0(ulRow, ulCol, lrRow, lrCol, bClr)
  ' - Border
  Box0 ulRow, ulCol, lrRow, lrCol, 1, bClr
  ' - Button Splitter
  QPrintRC CHR$(195) + STRING$((lrCol - ulCol) - 1, 196) + CHR$(180), lrRow - 2, ulCol, bClr
  ' - Drop shadow
  CALL PaintBox0(lrRow + 1, ulCol + 3, lrRow + 1, lrCol + 1, 8)
  CALL PaintBox0(ulRow + 1, lrCol + 1, lrRow + 1, lrCol + 2, 8)
  ' - Caption
  caption$ = "Open" ' For QB, use "Open Program"
  QPrintRCenter " " + caption$ + " ", 3, ulCol, lrCol, bClr

  '***** Filename *****

  ' Label
  QPrintRC "File Name:", ulRow + 2, ulCol + 2, bClr
  ' TextBox
  Box0 ulRow + 1, ulCol + 13, ulRow + 3, lrCol - 2, 1, bClr
  dial(4).DType = 4 ' Text
  dial(4).NumFlag = 0 ' Alpha/Numeric
  mouseBox(4).Y1 = ulRow + 2
  mouseBox(4).Y2 = mouseBox(4).Y1
  mouseBox(4).X1 = ulCol + 14
  mouseBox(4).X2 = lrCol - 3
  mouseBox(4).RN = 4
  dial(4).Row = mouseBox(4).Y1
  dial(4).Col = mouseBox(4).X1

  '***** Files (HListBox) *****

  ' Label
  QPrintRC "C:\", ulRow + 5, ulCol + 2, bClr
  dial(5).DType = 0 ' Label
  ' Label
  QPrintRCenter "Files", ulRow + 6, ulCol + 2, lrCol - 20, bClr
  ' HListBox
  Box0 ulRow + 7, ulCol + 2, lrRow - 3, lrCol - 20, 1, bClr
  HScrollBarDraw lrRow - 3, ulCol + 3, lrCol - 21, 0, bClr
  dial(5).DType = 10 ' File
  mouseBox(5).Y1 = ulRow + 8
  mouseBox(5).Y2 = lrRow - 4
  mouseBox(5).X1 = ulCol + 3
  mouseBox(5).X2 = lrCol - 21
  mouseBox(5).RN = 5
  dial(5).Row = mouseBox(5).Y1
  dial(5).Col = mouseBox(5).X1

  '***** Folders (VListBox) *****

  ' Label
  QPrintRCenter "Dirs/Drives", ulRow + 6, lrCol - 17, lrCol - 2, bClr
  ' VListBox
  Box0 ulRow + 7, lrCol - 17, lrRow - 3, lrCol - 2, 1, bClr
  ' VScrollBar
  VScrollBarDraw ulRow + 8, lrRow - 4, lrCol - 2, 0, bClr
  dial(6).DType = 11 ' Folder
  mouseBox(6).Y1 = ulRow + 8
  mouseBox(6).Y2 = lrRow - 4
  mouseBox(6).X1 = lrCol - 16
  mouseBox(6).X2 = lrCol - 3
  mouseBox(6).RN = 7
  dial(6).Row = mouseBox(6).Y1
  dial(6).Col = mouseBox(6).X1

  '***** Buttons *****

  ButtonDraw "OK", lrRow - 1, 16, bClr
  dial(1).DType = 1 ' Button
  mouseBox(1).Y1 = lrRow - 1
  mouseBox(1).Y2 = mouseBox(1).X1
  mouseBox(1).X1 = 16
  mouseBox(1).X2 = mouseBox(1).X1 + 2 + 3
  mouseBox(1).RN = 1
  dial(1).Row = mouseBox(1).Y1
  dial(1).Col = mouseBox(1).X1 + 2
  ButtonDraw "Cancel", lrRow - 1, 35, bClr
  dial(2).DType = 1 ' Button
  mouseBox(2).Y1 = lrRow - 1
  mouseBox(2).Y2 = mouseBox(2).X1
  mouseBox(2).X1 = 35
  mouseBox(2).X2 = mouseBox(1).X1 + 6 + 3
  mouseBox(2).RN = 2
  dial(2).Row = mouseBox(2).Y1
  dial(2).Col = mouseBox(2).X1 + 2
  ButtonDraw "Help", lrRow - 1, 55, bClr
  dial(3).DType = 1 ' Button
  mouseBox(3).Y1 = lrRow - 1
  mouseBox(3).Y2 = mouseBox(3).X1
  mouseBox(3).X1 = 55
  mouseBox(3).X2 = mouseBox(1).X1 + 4 + 3
  mouseBox(3).RN = 3
  dial(3).Row = mouseBox(3).Y1
  dial(3).Col = mouseBox(3).X1 + 2

  choice = 1
  LOCATE dial(choice).Row, dial(choice).Col, 1
  
  DO
    DO
      ky$ = INKEY$
      IF LEN(ky$) THEN mFlag = 0
      CALL MouseRange(mouseBox(), 1, numChoices, mRow, mCol, mButton, rangeNum)
      IF mButton > 0 AND rangeNum THEN    ' If mouse down and its in a valid range
        IF rangeNum <> el THEN            ' If we havent already turned off hilite,
          hiLite = bClr                   '   turn off old HiLite
          GOSUB HiLite
        END IF
        el = rangeNum
        IF el <= numButtons THEN          ' If we've clicked on a button
          choice = el                     '   choice = button selected
          buttonDown = -1                 ' Remember that mouse button was pressed
          CALL PaintBox0(lrRow - 1, mouseBox(choice).X1 + 1, lrRow - 1, MouseBox(choice).X2 - 1, 15)
        END IF
        mFlag = -1                        ' Set Mouse flag
        choice = rangeNum
        ky$ = CHR$(154)                   ' Dummy key to exit INKEY$ loop
      END IF
      ' If we've clicked on a button, wait until mouse button is up
      IF rangeNum <= numButtons AND mButton = 0 AND buttonDown THEN
        buttonDown = 0
        CALL PaintBox0(lrRow - 1, MouseBox(choice).X1 + 1, lrRow - 1, MouseBox(choice).X2 - 1, bClr)
        EXIT SUB 'GOTO Done                         ' Exit Dialog box
      END IF
    LOOP UNTIL LEN(ky$) OR pressed
    
    IF NOT pressed THEN                   ' If a keystroke and not a mouse click
      IF LEN(ky$) < 2 THEN
        ky = ASC(ky$)
      ELSE
        ky = -ASC(RIGHT$(ky$, 1))
      END IF
    END IF

    'TODO: Need to decide how I want to handle "sub components".

    SELECT CASE dial(choice).DType
      CASE 0 ' Label
        ' What can be done with a label; well, nothing.
      CASE 1 ' Button
      CASE 2 ' 
      CASE 3 ' 
      CASE 4 ' TextBox
      CASE 5 ' 
      CASE 10 ' File ListBox
      CASE 11 ' Folder ListBox
      CASE ELSE
    END SELECT

    SELECT CASE ky
      CASE 9 ' Tab
        IF choice <= numButtons THEN hiLite = bClr: GOSUB HiLite
        choice = choice + 1
        IF choice > UBOUND(dial) THEN choice = 1
      CASE -15 ' Shift Tab      
        IF choice <= numButtons THEN hiLite = bClr: GOSUB HiLite
        choice = choice - 1
        IF choice < 1 THEN choice = UBOUND(dial)
      CASE -72, -77                       ' Up, Right arrows
        IF dial(choice).DType = 3 AND found THEN ' If we're on an Option button
          LOCATE dial(choice).Row, dial(choice).Col
          response$(choice) = ""
          CALL QPrint0(" ", bClr)         ' Clear the last Dot
          choice = choice - 1
          IF choice <= lastXBox - numXBoxes THEN choice = lastXBox
          dotEl = choice                      ' Remember where the new Dot is
          LOCATE dial(choice).Row, dial(choice).Col
          CALL QPrint0(dot$, bClr)        ' Print the new Dot
          response$(choice) = dot$
          found = 0
        END IF
      CASE -75, -80                       ' Left, Down arrows
        IF dial(choice).DType = 3 AND found THEN ' If we're on an Option button
          LOCATE dial(choice).Row, dial(choice).Col
          response$(choice) = ""
          CALL QPrint0(" ", bClr)         ' Clear the last Dot
          choice = choice + 1
          IF choice > lastXBox THEN choice = lastXBox - numXBoxes + 1
          dotEl = choice                      ' Remember where the new Dot is
          LOCATE dial(choice).Row, dial(choice).Col
          CALL QPrint0(dot$, bClr)        ' Print the new Dot
          response$(choice) = dot$
          found = 0
        END IF
      CASE 32 ' SpaceBar
        IF dial(choice).DType = 2 THEN              ' If we're in a check box
          LOCATE dial(choice).Row, dial(choice).Col
          IF response$(choice) <> check$ THEN       ' If its not checked,
            CALL QPrint0(check$, bClr)              '   check it
            Response$(choice) = check$
          ELSE                                      ' If its checked,
            CALL QPrint0(" ", bClr)                 '   clear it
            response$(choice) = ""
          END IF
        ELSE
          EXIT DO 'GOTO Done
        END IF
      CASE 27                             ' Escape
        EXIT DO 'GOTO Escape
      CASE 13                             ' Enter
        EXIT DO 'GOTO Done
      CASE ELSE
    END SELECT

    LOCATE dial(el).Row, dial(el).Col

  LOOP

  ' Restore
  CALL MScrnRest(ulRow, ulCol, lrRow + 1, lrCol + 2, scrn())

  EXIT SUB

HiLite:                                   ' Hilites the currently active button
  CALL PaintBox0(lrRow - 1, mouseBox(choice).X1, lrRow - 1, mouseBox(choice).X1, hiLite)
  CALL PaintBox0(lrRow - 1, mouseBox(choice).X2, lrRow - 1, mouseBox(choice).X2, hiLite)
RETURN

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

SUB QPrintRCenter (text$, row, col1, col2, clr)
  c = col1 + ((col2 - col1) \ 2) - (LEN(text$) \ 2)
  CALL QPrintRC(text$, row, c, clr)
END SUB

SUB HScrollBarDraw (row, col1, col2, pct, clr)
  QPrintRC CHR$(27) + STRING$((col2 - col1) - 1, 177) + CHR$(26), row, col1, clr
  QPrintRC CHR$(219), row, col1 + 1, clr ' Current position
END SUB

SUB VScrollBarDraw (row1, row2, col, pct, clr)
  QPrintRC CHR$(24), row1, col, clr
  FOR r = row1 + 1 TO row2 - 1
    QPrintRC CHR$(177), r, col, clr
  NEXT
  QPrintRC CHR$(25), row2, col, clr
  QPrintRC CHR$(219), row1 + 1, col, clr ' Current position
END SUB

SUB ButtonDraw (caption$, row, col, clr)
  ' TODO: Need to determine if printing in regular color or white?
  QPrintRC "< " + SPACE$(LEN(caption$)) + " >", row, col, clr
  QPrintRC caption$, row, col + 2, clr
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
  CALL VbMsgBox("'Cut' Not implemented.", 0, "")
END SUB
            
SUB CopyAction
  CALL VbMsgBox("'Copy' Not implemented.", 0, "")
END SUB

SUB PasteAction
  CALL VbMsgBox("'Paste' Not implemented.", 0, "")
END SUB
       
SUB ClearAction
  CALL VbMsgBox("'Clear' Not implemented.", 0, "")
END SUB

SUB NewSubAction
  CALL VbMsgBox("'New SUB' Not implemented.", 0, "")
END SUB

SUB NewFunctionAction
  CALL VbMsgBox("'New FUNCTION' Not implemented.", 0, "")
END SUB

SUB ViewSubsAction
  CALL VbMsgBox("'View->SUBs...' Not implemented.", 0, "")
END SUB

SUB ViewSplitAction
  CALL VbMsgBox("'View->Split' Not implemented.", 0, "")
END SUB

SUB ViewOutputScreenAction
  CALL VbMsgBox("'View->Output Screen' Not implemented.", 0, "")
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
  CALL VbMsgBox("'Repeat Last Find' Not implemented.", 0, "")
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

SUB StartAction
  CALL VbMsgBox("'Run->Start' Not implemented.", 0, "")
END SUB

SUB RestartAction
  CALL VbMsgBox("'Run->Restart' Not implemented.", 0, "")
END SUB

SUB ContinueAction
  CALL VbMsgBox("'Run->Continue' Not implemented.", 0, "")
END SUB

SUB StepAction
  CALL VbMsgBox("'Debug->Step' Not implemented.", 0, "")
END SUB

SUB ProcedureStepAction
  CALL VbMsgBox("'Debug->Procedure Step' Not implemented.", 0, "")
END SUB

SUB ToggleTraceAction
  CALL VbMsgBox("'Debug->Trace On' Not implemented.", 0, "")
END SUB

SUB ToggleBreakpointAction
  CALL VbMsgBox("'Debug->Toggle Breakpoint' Not implemented.", 0, "")
END SUB

SUB ClearAllBreakpointsAction
  CALL VbMsgBox("'Debug->Clear All Breakpoints' Not implemented.", 0, "")
END SUB

SUB SetNextStatementAction
  CALL VbMsgBox("'Debug->Set Next Statement' Not implemented.", 0, "")
END SUB

SUB DisplayAction
  CALL VbMsgBox("'Options->Display...' Not implemented.", 0, "")
END SUB
            
SUB HelpPathAction

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

SUB ToggleSyntaxCheckingAction
  CALL VbMsgBox("'Options->Syntax Checking' Not implemented.", 0, "")
END SUB

SUB HelpIndexAction
  CALL VbMsgBox("'Help->Index' Not implemented.", 0, "")
END SUB

SUB HelpContentsAction
  CALL VbMsgBox("'Help->Contents' Not implemented.", 0, "")
END SUB

SUB HelpTopicAction
  CALL VbMsgBox("'Help->Topic' Not implemented.", 0, "")
END SUB

SUB HelpUsingHelpAction
  CALL VbMsgBox("'Help->Using Help' Not implemented.", 0, "")
END SUB

SUB HelpAboutAction

  CALL UpdateStatus("F1=Help   Enter=Execute   Esc=Cancel   Tab=Next Field   Arrow=Next Item", edState.CurLine, edState.CurCol)

  REDIM menu$(0)
  REDIM text$(6)
  REDIM response$(0)
  text$(1) = "< OK >"
  text$(2) = " "
  text$(3) = "MS-DOS QBasic"
  text$(4) = "Version 1.0"
  text$(5) = "Copyright (C) Microsoft Corporation, 1987-1991."
  text$(6) = " "
  scrnRow = -1: choice = 1: clr = 112: style = 11

  LOCATE 9
  CALL Dialog(choice, text$(), response$(), menu$(), scrnRow, style, clr, action)

END SUB

SUB WelcomeAction

  REDIM scrn(2000)
  CALL MScrnSave(1, 1, 25, 80, scrn())

  CALL UpdateStatus("F1=Help   Enter=Execute   Esc=Cancel   Tab=Next Field   Arrow=Next Item", edState.CurLine, edState.CurCol)

  Box0 7, 14, 17, 66, 1, OneColor(0, 7)
  QPrintRC "                                                   ", 8, 15, OneColor(0, 7)
  QPrintRC "            Welcome to the MS-DOS QBasic           ", 9, 15, OneColor(0, 7)
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
  CALL MScrnRest(1, 1, 25, 80, scrn())

END SUB