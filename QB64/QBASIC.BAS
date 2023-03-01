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

'-------

CONST TRUE = -1, FALSE = NOT TRUE

TYPE VarType
  Name AS STRING * 40
  Type AS _BYTE
  Scope AS STRING * 50
  Protected AS _BYTE
END TYPE

TYPE LevelControlType
  FirstLine AS LONG
  ContinueAt AS LONG
  LastLine AS LONG
  Condition AS _BYTE
  'For DO/LOOP blocks:
  '  0 = no condition; 1 = DO + condition; 2 = LOOP + condition
END TYPE

TYPE ForControlType
  VarName AS STRING
  VarIndex AS LONG
  Initial AS _FLOAT
  Final AS _FLOAT
  TheStep AS _FLOAT
  Level AS LevelControlType
  FirstRun AS _BYTE
END TYPE

CONST varType_FLOAT = 0
CONST varTypeSTRING = 1
CONST varTypeINTEGER = 2
CONST varTypeSINGLE = 3
CONST varTypeDOUBLE = 4
CONST varType_UBYTE = 5
CONST varType_BYTE = 6
CONST varType_UINTEGER = 7
CONST varType_UINTEGER64 = 8
CONST varType_INTEGER64 = 9
CONST varType_ULONG = 10
CONST varTypeLONG = 11

REDIM SHARED vars(0) AS VarType
REDIM SHARED strings(0) AS STRING
REDIM SHARED nums(0) AS _FLOAT
DIM SHARED totalVars AS LONG
DIM SHARED thisScope$
DIM SHARED errorHappened AS _BYTE
DIM SHARED keyhit AS LONG

DIM SHARED varType_DEFAULT AS _BYTE
DIM SHARED currentLine AS LONG
DIM SHARED lineThatErrored AS LONG

'-------

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
  lrRow = 23 ' for QB, use 23
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
  caption$ = "Open Program"
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

  path$ = "C:\bas\"
  fspec$ = path$ + "*.*"

  ' Label
  QPrintRC path$, ulRow + 5, ulCol + 2, bClr
  dial(5).DType = 0 ' Label
  ' Label
  QPrintRCenter "Files", ulRow + 6, ulCol + 2, lrCol - 20, bClr
  ' HListBox
  Box0 ulRow + 7, ulCol + 2, lrRow - 3, lrCol - 20, 1, bClr
  HScrollBarDraw lrRow - 3, ulCol + 3, lrCol - 21, 0, bClr

  count = FCount%(fspec$)         ' first count the number of matching files
  IF count = 0 THEN END          ' spec must have been invalid
  n = count                      ' save the count in N for later
  DIM file$(count)               ' dim a string array to hold the file names
  file$(0) = fspec$               ' put the file spec into element zero

  FOR x = 1 TO count             ' make room for the names
    file$(x) = SPACE$(12)
  NEXT
  CALL ReadFile(file$())         ' get the file names

  startItem = 1
  selection = 1
  scanCode = 9999
  CALL MAMenu (file$(), 1, selection, startItem, count, scanCode, 112, OneColor(7,0), 9, 3, 3, ulRow + 8, ulCol + 3)
  '                                                                ^    ^   ^  ^  ^  ^  ^
  '                                                                |    |   |  |  |  |  |
  '     File Color ------------------------------------------------     |   |  |  |  |  |
  '     HiLite Color ---------------------------------------------------    |  |  |  |  |
  '     Number of Rows in table --------------------------------------------   |  |  |  |
  '     Number of Columns in table --------------------------------------------   |  |  |
  '     Number of spaces between columns -----------------------------------------   |  |
  '     Upper left row of display        --------------------------------------------   |
  '     Upper left column of display     -----------------------------------------------

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

    IF dial(choice).DType <> 10 THEN

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

    END IF

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
        ky = 9998 ' passthrough
        CALL MAMenu (file$(), 1, selection, startItem, count, ky, 112, OneColor(7,0), 9, 3, 3, ulRow + 8, ulCol + 3)
        SELECT CASE scanCode
          CASE -72, -80, -75, -77  ' Up, Down, Left, Right
            'TODO: Update File Name: field with currently selected filename.
            ky = 0
          CASE ELSE
        END SELECT
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

    LOCATE dial(choice).Row, dial(choice).Col

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
  
  REDIM scrn(2000)
  CALL MScrnSave(1, 1, 25, 80, scrn())
  CLS
  program$ = "print " + chr$(34) + "HELLO WORLD!" + chr$(34)
  Runner program$
  CALL WaitKeyS
  CALL MScrnRest(1, 1, 25, 80, scrn())

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

'-----

SUB Runner(content$)

  DIM running AS INTEGER '_BYTE

  DIM i AS LONG
  DIM j AS LONG
  DIM l AS LONG
  DIM continuation$
  DIM Ucontinuation$
  DIM continueAt AS LONG
  DIM loopControl(100) AS LevelControlType
  DIM forControl(100) AS ForControlType
  DIM currentDoLevel AS INTEGER, currentIfLevel AS INTEGER, currentForLevel AS INTEGER
  DIM screenKeyStatus AS _BYTE
  DIM externalLimit AS INTEGER
  DIM Comma1 AS INTEGER
  DIM Comma2 AS INTEGER
  DIM Comma3 AS INTEGER
  REDIM program(0) AS STRING
  program(0) = ""

  IF content$ <> "" THEN
    delim$ = CHR$(10)
    x = Delimit%(content$, delim$) + 1    ' see how many matching 
                                          ' delimiters there are 
    REDIM _PRESERVE program(x) AS STRING  ' +1 is needed to account 
                                          ' for the last item 
    Parse content$, delim$, program() 
  END IF

  InitVar

  thisScope$ = "MAIN MODULE"
  varType_DEFAULT = varTypeSINGLE
  screenKeyStatus = TRUE

  currentLine = 0
  currentDoLevel = 0
  currentIfLevel = 0
  externalLimit = 0
  running = TRUE

  DO

    keyhit = _KEYHIT

    IF (ABS(keyhit) = ASC("C") OR ABS(keyhit) = ASC("c")) AND (_KEYDOWN(100305) OR _KEYDOWN(100306)) THEN
      PRINT "Break."
      IF running THEN running = FALSE
      _KEYCLEAR
    END IF

    IF running THEN
      currentLine = currentLine + 1
      IF currentLine > UBOUND(program) THEN
        running = FALSE
      ELSE
        L1$ = program(currentLine)
      END IF
    END IF

    IF NOT running THEN 
      LOCATE 25, 1: PRINT "Press any key to continue";
      EXIT DO
    END IF

    L1$ = LTRIM$(RTRIM$(L1$))
    L$ = UCASE$(L1$)

    redoThisLine:
    'db_echo "running line" + STR$(currentLine)
    'db_echo ">> " + L1$
    IF isNumber(LEFT$(L$, INSTR(L$, " ") - 1)) THEN
      L$ = MID$(L$, INSTR(L$, " ") + 1)
      L1$ = MID$(L1$, INSTR(L1$, " ") + 1)
      GOTO redoThisLine
    ELSE

      'look for : separators
      IF LEFT$(L$, 3) <> "IF " THEN
        j = Find(1, L$, ":")
        IF j > 0 AND j < LEN(L$) THEN
          continuation$ = _TRIM$(MID$(L1$, j + 1))
          Ucontinuation$ = _TRIM$(MID$(L$, j + 1))
          L1$ = _TRIM$(LEFT$(L1$, j - 1))
          L$ = _TRIM$(LEFT$(L$, j - 1))
          continueAt = _INSTRREV(program(currentLine), continuation$)
        ELSEIF j = LEN(L$) THEN
          IF INSTR(L$, " ") > 0 THEN
            L$ = LEFT$(L$, LEN(L$) - 1)
            L1$ = LEFT$(L1$, LEN(L1$) - 1)
            continuation$ = ""
            Ucontinuation$ = ""
            continueAt = 0
          ELSE
            'likely a label, leave it as is
          END IF
        ELSE
          continuation$ = ""
          Ucontinuation$ = ""
          continueAt = 0
        END IF
      ELSE
        continuation$ = ""
        Ucontinuation$ = ""
        continueAt = 0
      END IF

      IF LEFT$(L$, 6) = "CHDIR " THEN
        CHDIR Parse$(running, MID$(L1$, 7))
      ELSEIF LEFT$(L$, 6) = "MKDIR " THEN
        MKDIR Parse$(running, MID$(L1$, 7))
      ELSEIF LEFT$(L$, 5) = "KILL " THEN
        KILL Parse$(running, MID$(L1$, 6))
      ELSEIF L$ = "CLEAR" THEN
        j = 0
        FOR i = totalVars TO 1 STEP -1
          IF NOT vars(i).protected THEN
            totalVars = totalVars - 1
            vars(i).name = ""
            vars(i).type = 0
            strings(i) = ""
            nums(i) = 0
          END IF
        NEXT
      ELSEIF L$ = "_DISPLAY" THEN
        _DISPLAY
      ELSEIF LEFT$(L$, 6) = "WIDTH " THEN
        DIM p$, p1$, p2$
        p$ = MID$(L$, 7)
        IF INSTR(p$, ",") THEN
          p1$ = LEFT$(p$, INSTR(p$, ",") - 1)
          p2$ = MID$(p$, INSTR(p$, ",") + 1)
          IF LEN(p1$) = 0 THEN
            WIDTH , VAL(Parse$(running, p2$))
          ELSE
            WIDTH VAL(Parse$(running, p1$)), VAL(Parse$(running, p2$))
          END IF
        ELSE
          WIDTH VAL(Parse$(running, p$))
        END IF
      ELSEIF LEFT$(L$, 10) = "RANDOMIZE " THEN
        RANDOMIZE VAL(Parse$(running, MID$(L$, 11)))
      ELSEIF LEFT$(L$, 7) = "_LIMIT " THEN
        externalLimit = VAL(Parse$(running, MID$(L$, 8)))
      ELSEIF LEFT$(L$, 1) = "'" OR LEFT$(L$, 4) = "REM " OR L$ = "'" OR L$ = "REM" OR L$ = "" THEN
        'it's a comment.
      ELSEIF LEFT$(L$, 4) = "KEY " THEN
        IF _TRIM$(MID$(L$, 5)) = "ON" THEN
          KEY ON
          screenKeyStatus = TRUE
        ELSEIF _TRIM$(MID$(L$, 5)) = "OFF" THEN
          KEY OFF
          screenKeyStatus = FALSE
        ELSE
          GOTO syntaxerror
        END IF
      ELSEIF LEFT$(L$, 6) = "COLOR " THEN
        DIM c$, c1$, c2$
        c$ = MID$(L$, 7)
        IF INSTR(c$, ",") THEN
          c1$ = LEFT$(c$, INSTR(c$, ",") - 1)
          c2$ = MID$(c$, INSTR(c$, ",") + 1)
          IF LEN(c1$) > 0 AND LEN(c2$) > 0 THEN
            COLOR VAL(Parse(running, c1$)), VAL(Parse(running, c2$))
          ELSEIF LEN(c1$) > 0 AND LEN(c2$) = 0 THEN
            COLOR VAL(Parse(running, c1$))
          ELSEIF LEN(c1$) = 0 AND LEN(c2$) > 0 THEN
            COLOR , VAL(Parse(running, c2$))
          END IF
        ELSE
          COLOR VAL(Parse(running, c$))
        END IF
      ELSEIF LEFT$(L$, 7) = "_BLINK " THEN
        IF _TRIM$(MID$(L$, 8)) = "ON" THEN
          _BLINK ON
        ELSEIF _TRIM$(MID$(L$, 8)) = "OFF" THEN
          _BLINK OFF
        ELSE
          GOTO syntaxerror
        END IF
      ELSEIF LEFT$(L$, 7) = "LOCATE " THEN
        c$ = MID$(L$, 8)
        IF INSTR(c$, ",") THEN
          c1$ = LEFT$(c$, INSTR(c$, ",") - 1)
          c2$ = MID$(c$, INSTR(c$, ",") + 1)
          IF LEN(c1$) > 0 AND LEN(c2$) > 0 THEN
            LOCATE VAL(Parse$(running, c1$)), VAL(Parse$(running, c2$))
          ELSEIF LEN(c1$) > 0 AND LEN(c2$) = 0 THEN
            LOCATE VAL(Parse$(running, c1$))
          ELSEIF LEN(c1$) = 0 AND LEN(c2$) > 0 THEN
            LOCATE , VAL(Parse$(running, c2$))
          END IF
        ELSE
          LOCATE VAL(Parse$(running, c$))
        END IF
      ELSEIF LEFT$(L$, 6) = "FILES " THEN
        temp$ = Parse$(running, MID$(L1$, 7))
        FILES temp$
      ELSEIF L$ = "FILES" THEN
        FILES
      ELSEIF LEFT$(L$, 9) = "_SNDPLAY " THEN
        _SNDPLAY VAL(Parse$(running, MID$(L$, 10)))
      ELSEIF LEFT$(L$, 8) = "CIRCLE (" THEN
        IF _PIXELSIZE(_DEST) = 0 THEN throwError running, 5: GOTO Parse.Done
        Comma1% = INSTR(L$, ","): Comma2% = INSTR(Comma1% + 1, L$, ","): Comma3% = INSTR(Comma2% + 1, L$, ",")

        DIM XPos1%, YPos1%, X1%, Y1%, Rad%, DrawClr%, EPos%, Elipse!, Arc%
        DIM Comma4%, Comma5%, ArcBeg!, ArcEnd!, d##
        XPos1% = INSTR(L$, " (") + 2
        YPos1% = Comma1% + 1
        X1% = VAL(Parse(running, MID$(L$, XPos1%, Comma1% - XPos1%)))
        Y1% = VAL(Parse(running, MID$(L$, YPos1%, Comma2% - YPos1% - 1)))

        Rad% = VAL(Parse(running, MID$(L$, Comma2% + 1, Comma3% - Comma2% - 1)))

        c$ = LTRIM$(RTRIM$(LEFT$(MID$(L$, Comma3% + 1), 3))) 'Color attribute (variable or constant)
        IF RIGHT$(c$, 1) = "," THEN c$ = LEFT$(c$, LEN(c$) - 1) 'If single-digit attribute

        IF INSTR("0123456789", LEFT$(c$, 1)) > 0 THEN DrawClr% = VAL(c$) ELSE DrawClr% = VAL(Parse(running, c$))

        EPos% = INSTR(L$, ", , , ")

        IF EPos% > 0 THEN
            EPos% = EPos% + 6: Elipse = VAL(Parse$(running, MID$(L$, EPos%)))
        ELSE
            Arc% = INSTR(Comma3% + 1, L$, ",")

            IF Arc% > 0 THEN
                Comma4% = Arc%
                Comma5% = INSTR(Comma4% + 1, L$, ",")

                ArcBeg = VAL(Parse$(running, MID$(L$, Comma4% + 1, Comma5% - Comma4% - 1))) ': PRINT "ArcBeg:"; ArcBeg;   '* * * * Test PRINT
                ArcEnd = VAL(Parse$(running, MID$(L$, Comma5% + 1))) ': PRINT " ArcEnd:"; ArcEnd;

                IF INSTR(Comma5% + 1, L$, ",") > 0 THEN EPos% = INSTR(Comma5% + 1, L$, ",") + 1: Elipse = VAL(Parse$(running, MID$(L$, EPos%)))
            END IF
        END IF

        IF Arc% > 0 AND Elipse = 0 THEN CIRCLE (X1%, Y1%), Rad%, DrawClr%, ArcBeg, ArcEnd: GOTO Circ.Done
        IF Elipse > 0 AND Arc% = 0 THEN CIRCLE (X1%, Y1%), Rad%, DrawClr%, , , Elipse: GOTO Circ.Done
        IF Arc% > 0 AND Elipse > 0 THEN CIRCLE (X1%, Y1%), Rad%, DrawClr%, ArcBeg, ArcEnd, Elipse: GOTO Circ.Done
        CIRCLE (X1%, Y1%), Rad%, DrawClr% 'No arc, no elipse

        Circ.Done: Rad% = 0: Arc% = 0: Elipse = 0: c$ = "": DrawClr% = 0: GOTO Parse.Done
      ELSEIF L$ = "SLEEP" THEN
        SLEEP
      ELSEIF LEFT$(L$, 6) = "SLEEP " THEN
        SLEEP VAL(Parse$(running, MID$(L$, 7)))
      ELSEIF L$ = "PRINT" OR L$ = "?" THEN
        PRINT
      ELSEIF LEFT$(L$, 6) = "PRINT " OR LEFT$(L$, 1) = "?" THEN
        IF LEFT$(L$, 2) = "? " THEN L1$ = "PRINT " + MID$(L1$, 3): L$ = L1$
        IF LEFT$(L$, 1) = "?" THEN L1$ = "PRINT " + MID$(L1$, 2): L$ = L1$
        DIM retainCursor AS _BYTE
        IF RIGHT$(L$, 1) = ";" THEN
          retainCursor = TRUE
          L$ = LEFT$(L$, LEN(L$) - 1)
          L1$ = LEFT$(L1$, LEN(L$))
        ELSE
          retainCursor = FALSE
        END IF
        PRINT Parse(running, MID$(L1$, 7));
        IF NOT retainCursor THEN PRINT
      ELSEIF LEFT$(L$, 7) = "_TITLE " THEN
        temp$ = Parse$(running, MID$(L1$, 8))
        _TITLE temp$
      ELSEIF L$ = "CLS" THEN
        CLS
      ELSEIF L$ = "SYSTEM" THEN
        SYSTEM
      ELSEIF L$ = "STOP" THEN
        running = FALSE
      ELSEIF L$ = "END" THEN
        running = FALSE
      ELSEIF LEFT$(L$, 6) = "INPUT " THEN
        DIM varName$, d$, d%
        varName$ = MID$(L1$, 7)
        varIndex = addVar(varName$, FALSE)
        IF vars(varIndex).type = varTypeSTRING THEN
          INPUT "", d$
          strings(varIndex) = d$
        ELSE
          SELECT CASE vars(varIndex).type
            CASE varTypeINTEGER
              INPUT "", d%
              nums(varIndex) = d%
            CASE ELSE
              INPUT "", d##
              nums(varIndex) = d##
          END SELECT
        END IF
      ELSEIF LEFT$(L$, 4) = "FOR " THEN
        i = Find(1, L$, "=")
        j = Find(i + 1, L$, " TO ")
        l = Find(j + 4, L$, " STEP ")
        IF i = 0 OR j = 0 THEN
          PRINT "Expected FOR variable = lower TO upper on line"; currentLine
          running = FALSE
          GOTO Parse.Done
        ELSE
          currentForLevel = currentForLevel + 1
          IF forControl(currentForLevel).level.firstLine <> currentLine THEN
            forControl(currentForLevel).level.firstLine = currentLine
            forControl(currentForLevel).level.continueAt = continueAt
            forControl(currentForLevel).level.lastLine = 0
            forControl(currentForLevel).varIndex = 0
          END IF
          forControl(currentForLevel).firstRun = TRUE
          forControl(currentForLevel).varName = _TRIM$(MID$(L1$, 5, i - 5))
          forControl(currentForLevel).initial = VAL(Parse$(running, MID$(L1$, i + 1, j - i - 1)))
          IF l THEN
            forControl(currentForLevel).final = VAL(Parse$(running, MID$(L1$, j + 4, l - j - 4)))
            forControl(currentForLevel).theStep = VAL(Parse$(running, MID$(L1$, l + 6)))
          ELSE
            forControl(currentForLevel).final = VAL(Parse$(running, MID$(L1$, j + 4)))
            forControl(currentForLevel).theStep = 1
          END IF
          L1$ = forControl(currentForLevel).varName + "=" + STR$(forControl(currentForLevel).initial) + ": NEXT"
          L$ = UCASE$(L1$)
          GOTO redoThisLine
        END IF
      ELSEIF L$ = "NEXT" THEN
        IF currentForLevel = 0 THEN
          running = FALSE
          PRINT "NEXT without FOR on line"; currentLine
          GOTO Parse.Done
        ELSE
          treatAsNext:
          IF forControl(currentForLevel).varIndex = 0 THEN
              forControl(currentForLevel).varIndex = addVar(forControl(currentForLevel).varName, FALSE) 'acquire var index
          END IF
          varIndex = forControl(currentForLevel).varIndex
          IF forControl(currentForLevel).firstRun THEN
            forControl(currentForLevel).firstRun = FALSE
          ELSE
            forControl(currentForLevel).level.lastLine = currentLine
            IF vars(varIndex).type = varTypeINTEGER THEN
              nums(varIndex) = INT(nums(varIndex) + forControl(currentForLevel).theStep)
            ELSE
              nums(varIndex) = nums(varIndex) + forControl(currentForLevel).theStep
            END IF
          END IF
          IF forControl(currentForLevel).theStep < 0 THEN
            IF nums(varIndex) < forControl(currentForLevel).final THEN
              GOTO treatAsExitFor
            ELSE
              currentLine = forControl(currentForLevel).level.firstLine
              continuation$ = ""
              Ucontinuation$ = ""
              IF forControl(currentForLevel).level.continueAt > 0 THEN
                continuation$ = ""
                Ucontinuation$ = ""
                L1$ = MID$(program(currentLine), forControl(currentForLevel).level.continueAt)
                L$ = UCASE$(L1$)
                GOTO redoThisLine
              END IF
            END IF
          ELSE
            IF nums(varIndex) > forControl(currentForLevel).final THEN
              GOTO treatAsExitFor
            ELSE
              currentLine = forControl(currentForLevel).level.firstLine
              continuation$ = ""
              Ucontinuation$ = ""
              IF forControl(currentForLevel).level.continueAt > 0 THEN
                L1$ = MID$(program(currentLine), forControl(currentForLevel).level.continueAt)
                L$ = UCASE$(L1$)
                GOTO redoThisLine
              END IF
            END IF
          END IF
        END IF
      ELSEIF LEFT$(L$, 5) = "NEXT " THEN
        IF currentForLevel = 0 THEN
          running = FALSE
          PRINT "NEXT without FOR on line"; currentLine
          GOTO Parse.Done
        ELSE
          IF _TRIM$(MID$(L1$, 6)) <> forControl(currentForLevel).varName THEN
            running = FALSE
            PRINT "Incorrect variable after NEXT on line"; currentLine
            GOTO Parse.Done
          ELSE
            GOTO treatAsNext
          END IF
        END IF
      ELSEIF L$ = "EXIT FOR" THEN
        IF currentForLevel = 0 THEN
          running = FALSE
          PRINT "EXIT FOR without FOR on line"; currentLine
          GOTO Parse.Done
        ELSE
          treatAsExitFor:
          IF forControl(currentForLevel).level.lastLine > 0 THEN
            currentLine = forControl(currentForLevel).level.lastLine
            currentForLevel = currentForLevel - 1
          ELSE
            DO
              currentLine = currentLine + 1
              IF currentLine > UBOUND(program) THEN PRINT "FOR without NEXT on line"; forControl(currentForLevel).level.firstLine: running = FALSE: GOTO Parse.Done
              L1$ = program(currentLine)
              L1$ = LTRIM$(RTRIM$(L1$))
              L$ = UCASE$(L1$)
              IF L$ = "NEXT" OR LEFT$(L$, 5) = "NEXT " THEN
                currentForLevel = currentForLevel - 1
                EXIT DO
              END IF
            LOOP
          END IF
        END IF
      ELSEIF L$ = "_CONTINUE" THEN
      ELSEIF L$ = "DO" THEN
        currentDoLevel = currentDoLevel + 1
        IF loopControl(currentDoLevel).firstLine <> currentLine THEN
          loopControl(currentDoLevel).firstLine = currentLine
          loopControl(currentDoLevel).lastLine = 0
          loopControl(currentDoLevel).continueAt = continueAt
        END IF
        loopControl(currentDoLevel).condition = 0
      ELSEIF LEFT$(L$, 9) = "DO UNTIL " THEN
        currentDoLevel = currentDoLevel + 1
        IF loopControl(currentDoLevel).firstLine <> currentLine THEN
          loopControl(currentDoLevel).firstLine = currentLine
          loopControl(currentDoLevel).lastLine = 0
          loopControl(currentDoLevel).continueAt = continueAt
        END IF
        loopControl(currentDoLevel).condition = 1
        IF VAL(Parse$(running, MID$(L$, 10))) <> 0 THEN
          GOTO treatAsExitDo
        END IF
      ELSEIF LEFT$(L$, 9) = "DO WHILE " THEN
        currentDoLevel = currentDoLevel + 1
        IF loopControl(currentDoLevel).firstLine <> currentLine THEN
          loopControl(currentDoLevel).firstLine = currentLine
          loopControl(currentDoLevel).lastLine = 0
          loopControl(currentDoLevel).continueAt = continueAt
        END IF
        loopControl(currentDoLevel).condition = 1
        IF VAL(Parse$(running, MID$(L$, 10))) = 0 THEN
          GOTO treatAsExitDo
        END IF
      ELSEIF LEFT$(L$, 5) = "GOTO " THEN
        DIM theLabel$
        theLabel$ = MID$(L$, 6)
        IF isNumber(theLabel$) THEN theLabel$ = theLabel$ + " " ELSE theLabel$ = theLabel$ + ": "
        'look for label
        FOR i = 1 TO UBOUND(program)
          temp$ = UCASE$(_TRIM$(program(i))) + " "
          IF LEFT$(temp$, INSTR(temp$, " ")) = UCASE$(theLabel$) THEN
            currentLine = i - 1
            GOTO Parse.Done
          END IF
        NEXT
        PRINT "Label not found on line"; currentLine: running = FALSE: GOTO Parse.Done
      ELSEIF L$ = "LOOP" THEN
        treatAsLoop:
        IF currentDoLevel > 0 AND loopControl(currentDoLevel).firstLine > 0 THEN
          currentLine = loopControl(currentDoLevel).firstLine - 1
          currentDoLevel = currentDoLevel - 1
          IF loopControl(currentDoLevel).continueAt > 0 THEN
            L1$ = MID$(program(currentLine), loopControl(currentDoLevel).continueAt)
            L$ = UCASE$(L1$)
            GOTO redoThisLine
          END IF
        ELSE
          IF currentDoLevel = 0 THEN
            'scan backwards until a DO is found
            FOR i = currentLine - 1 TO 1
              IF UCASE$(_TRIM$(program(i))) = "DO" OR LEFT$(UCASE$(_TRIM$(program(i))), 3) = "DO " THEN
                currentDoLevel = currentDoLevel + 1
                loopControl(currentDoLevel).firstLine = i
                loopControl(currentDoLevel).lastLine = currentLine
                GOTO treatAsLoop
              END IF
            NEXT
            IF i = 0 THEN PRINT "LOOP without DO on line"; currentLine: running = FALSE: GOTO Parse.Done
          END IF
        END IF
      ELSEIF LEFT$(L$, 11) = "LOOP UNTIL " THEN
        IF currentDoLevel = 0 THEN PRINT "LOOP without DO on line"; currentLine: running = FALSE: GOTO Parse.Done
        IF loopControl(currentDoLevel).condition = 1 THEN PRINT "LOOP UNTIL/WHILE not allowed in the same block as DO UNTIL/WHILE on line"; currentLine: running = FALSE: GOTO Parse.Done
        loopControl(currentDoLevel).condition = 2
        IF VAL(Parse$(running, MID$(L$, 12))) = 0 THEN
          GOTO treatAsLoop
        ELSE
          currentDoLevel = currentDoLevel - 1
        END IF
      ELSEIF LEFT$(L$, 11) = "LOOP WHILE " THEN
        IF currentDoLevel = 0 THEN PRINT "LOOP without DO on line"; currentLine: running = FALSE: GOTO Parse.Done
        IF loopControl(currentDoLevel).condition = 1 THEN PRINT "LOOP UNTIL/WHILE not allowed in the same block as DO UNTIL/WHILE on line"; currentLine: running = FALSE: GOTO Parse.Done
        IF VAL(Parse$(running, MID$(L$, 12))) <> 0 THEN
          GOTO treatAsLoop
        ELSE
          currentDoLevel = currentDoLevel - 1
        END IF
      ELSEIF L$ = "EXIT DO" THEN
        IF currentDoLevel = 0 THEN
          PRINT "EXIT DO without DO on line"; currentLine: running = FALSE: GOTO Parse.Done
        END IF
        treatAsExitDo:
        IF loopControl(currentDoLevel).lastLine > 0 THEN
          currentLine = loopControl(currentDoLevel).lastLine
          currentDoLevel = currentDoLevel - 1
        ELSE
          DO
            currentLine = currentLine + 1
            IF currentLine > UBOUND(program) THEN PRINT "DO without LOOP on line"; loopControl(currentDoLevel).firstLine: running = FALSE: GOTO Parse.Done
            L1$ = program(currentLine)
            L1$ = LTRIM$(RTRIM$(L1$))
            L$ = UCASE$(L1$)
            IF L$ = "LOOP" OR LEFT$(L$, 11) = "LOOP UNTIL " OR LEFT$(L$, 11) = "LOOP WHILE " THEN
              currentDoLevel = currentDoLevel - 1
              EXIT DO
            END IF
          LOOP
        END IF
      ELSEIF LEFT$(L$, 7) = "SCREEN " THEN
        SCREEN VAL(Parse$(running, MID$(L$, 8)))
      ELSEIF LEFT$(L$, 12) = "_SCREENMOVE " THEN
        c$ = MID$(L$, 13)
        IF INSTR(c$, ",") THEN
          c1$ = LEFT$(c$, INSTR(c$, ",") - 1)
          c2$ = MID$(c$, INSTR(c$, ",") + 1)
          IF LEN(c1$) > 0 AND LEN(c2$) > 0 THEN
            _SCREENMOVE VAL(Parse(running, c1$)), VAL(Parse(running, c2$))
          ELSE
            GOTO syntaxerror
          END IF
        ELSE
          GOTO syntaxerror
        END IF
      ELSEIF L$ = "ELSE" OR LEFT$(L$, 7) = "ELSEIF " THEN
        'skip "ELSE"/"ELSEIF" block (should have already been skipped in the IF evaluation)
        IF LEFT$(L$, 7) = "ELSEIF " AND RIGHT$(L$, 5) <> " THEN" THEN
          PRINT "Expected ELSEIF condition THEN on line"; currentLine
          running = FALSE
          GOTO Parse.Done
        END IF
        temp$ = L$
        IF LEN(L$) > 4 THEN temp$ = "ELSEIF"
        DO
          j = currentLine
          currentLine = currentLine + 1
          IF currentLine > UBOUND(program) AND currentIfLevel > 0 THEN
            PRINT "IF without END IF on line"; currentLine
            running = FALSE
            GOTO Parse.Done
          ELSEIF currentLine > UBOUND(program) THEN
            PRINT "ELSE without IF on line"; j
            running = FALSE
            GOTO Parse.Done
          END IF
          L1$ = program(currentLine)
          L1$ = LTRIM$(RTRIM$(L1$))
          L$ = UCASE$(L1$)
          IF L$ = "END IF" OR L$ = "ENDIF" THEN currentIfLevel = currentIfLevel - 1: EXIT DO
          IF L$ = "ELSE" AND temp$ = "ELSE" THEN
            PRINT "ELSE used more than once on line"; currentLine
            running = FALSE
            GOTO Parse.Done
          END IF
        LOOP
      ELSEIF L$ = "END IF" OR L$ = "ENDIF" THEN
        IF running THEN
          currentIfLevel = currentIfLevel - 1
        ELSE
          PRINT "Not valid in immediate mode."
        END IF
      ELSEIF LEFT$(L$, 3) = "IF " THEN
        IF RIGHT$(L$, 5) = " THEN" THEN
            'IF-THEN-ELSEIF-ELSE-END IF block

            DIM i$

            currentIfLevel = currentIfLevel + 1
            'db_echo "IF block, line" + STR$(currentLine)
            'db_echo "Current IF level:" + STR$(currentIfLevel)

            checkBlockCondition:
            i$ = MID$(L$, 4, LEN(L$) - 8)

            IF VAL(Parse(running, i$)) = 0 THEN 'condition is FALSE
              j = currentIfLevel
              DO
                currentLine = currentLine + 1
                IF currentLine > UBOUND(program) THEN PRINT "IF without END IF on line"; currentLine: running = FALSE: GOTO Parse.Done
                L1$ = program(currentLine)
                L1$ = LTRIM$(RTRIM$(L1$))
                L$ = UCASE$(L1$)
                IF LEFT$(L$, 3) = "IF " AND RIGHT$(L$, 5) = " THEN" THEN
                  'new if level...
                  currentIfLevel = currentIfLevel + 1
                  'db_echo "New IF line:" + STR$(currentLine)
                  'db_echo "New IF level:" + STR$(currentIfLevel)
                  _CONTINUE
                END IF
                IF L$ = "END IF" OR L$ = "ENDIF" THEN
                  IF currentIfLevel = j THEN
                    'db_echo "Proper END IF found:" + STR$(currentLine)
                    EXIT DO
                  ELSE
                    currentIfLevel = currentIfLevel - 1
                    'db_echo "Inner END IF found; level:" + STR$(currentIfLevel)
                  END IF
                END IF
                IF LEFT$(L$, 7) = "ELSEIF " THEN
                  IF RIGHT$(L$, 5) = " THEN" AND currentIfLevel = j THEN
                    'db_echo "ELSEIF found; same level:" + STR$(currentIfLevel)
                    L$ = MID$(L$, 5)
                    L1$ = MID$(L1$, 5)
                    GOTO checkBlockCondition
                  ELSEIF currentIfLevel = j THEN
                    PRINT "Expected ELSEIF condition THEN on line"; currentLine: running = FALSE: GOTO Parse.Done
                  END IF
                END IF
                IF L$ = "ELSE" AND currentIfLevel = j THEN
                  'db_echo "ELSE block found; same level:" + STR$(currentIfLevel)
                  EXIT DO
                END IF
                IF LEFT$(L$, 5) = "ELSE " AND currentIfLevel = j THEN
                  'db_echo "ELSE line found; same level:" + STR$(currentIfLevel)
                  L$ = MID$(L$, 6)
                  L1$ = MID$(L1$, 6)
                  GOTO redoThisLine
                END IF
            LOOP
          END IF
        ELSE
          'single-line IF statement
          'db_echo "Single-line IF, line" + STR$(currentLine)
          j = Find(1, L$, " THEN ")
          IF j = 0 THEN
            PRINT "Expected IF condition THEN statements"
            IF running THEN running = FALSE
            GOTO Parse.Done
          END IF
          i$ = MID$(LEFT$(L1$, j), 3)
          'db_echo "Condition: '" + i$ + "'"
          IF VAL(Parse(running, i$)) <> 0 THEN
            'db_echo "condition passed! ---------------->"
            L$ = MID$(L$, j + 6)
            L1$ = MID$(L1$, j + 6)
            j = Find(1, L$, " ELSE ")
            IF j = 0 THEN j = Find(1, L$, ":ELSE ")
            IF j > 0 THEN
              'remove ELSE part
              L$ = LEFT$(L$, j - 1)
              L1$ = LEFT$(L1$, j - 1)
            END IF
            'db_echo "Redoing line as '" + L$ + "'"
            GOTO redoThisLine
          ELSE
            'db_echo "condition is false! <----------------"
            'look for ELSE
            j = Find(j, L$, " ELSE ")
            IF j = 0 THEN j = Find(1, L$, ":ELSE ")
            IF j THEN
              L$ = MID$(L$, j + 6)
              L1$ = MID$(L1$, j + 6)
              'db_echo "ELSE: Redoing line as '" + L$ + "'"
              GOTO redoThisLine
            END IF
          END IF
        END IF
      ELSEIF INSTR(L$, "=") > 0 THEN
        'Assignment
        varName$ = RTRIM$(LEFT$(L1$, INSTR(L1$, "=") - 1))
        varIndex = addVar(varName$, FALSE) 'either add or acquire existing index
        IF vars(varIndex).protected THEN
          PRINT "Variable is protected";
          IF running THEN
            running = FALSE
            PRINT " on line "; currentLine
          ELSE
            PRINT
          END IF
          GOTO Parse.Done
        END IF
        DIM v$, t$
        IF vars(varIndex).type = varTypeSTRING THEN
          v$ = RTRIM$(LTRIM$(MID$(L1$, INSTR(L1$, "=") + 1)))
          strings(varIndex) = Parse(running, v$)
        ELSE
          v$ = MID$(L1$, INSTR(L1$, "=") + 1)
          t$ = Parse(running, v$)
          IF vars(varIndex).type = varTypeINTEGER THEN
            nums(varIndex) = INT(VAL(t$))
          ELSE
            nums(varIndex) = VAL(t$)
          END IF
        END IF
      ELSE
        'label?
        L$ = L$ + " "
        IF LEN(L$) > 2 AND (RIGHT$(LEFT$(L$, INSTR(L$, " ") - 1), 1) = ":" OR isNumber(RTRIM$(L$))) THEN
          'it's a label
        ELSE
          syntaxerror:
          IF LEN(L$) THEN PRINT "Syntax error";
            IF running THEN
              PRINT " on line"; currentLine
              running = FALSE
            ELSE
              PRINT
            END IF
          END IF
        END IF
      END IF

  Parse.Done:
    IF LEN(Ucontinuation$) THEN L$ = Ucontinuation$: L1$ = continuation$: GOTO redoThisLine
    IF externalLimit > 0 AND running THEN _LIMIT externalLimit
    IF currentIfLevel < 0 THEN currentIfLevel = 0

  LOOP

END SUB

FUNCTION AddVar~& (varName$, protected AS _BYTE)

  DIM found AS LONG

  'check if var exists
  found = searchVar(varName$)

  IF found THEN addVar~& = found: EXIT FUNCTION

  totalVars = totalVars + 1
  IF totalVars > UBOUND(vars) THEN
    REDIM _PRESERVE vars(totalVars + 99) AS vartype
    REDIM _PRESERVE strings(totalVars + 99) AS STRING
    REDIM _PRESERVE nums(totalVars + 99) AS _FLOAT
  END IF

  vars(totalVars).name = varName$

  'type detection -----------------------------------------------------------
  vars(totalVars).type = detectType(varName$)
  '--------------------------------------------------------------------------

  vars(totalVars).protected = protected

  vars(totalVars).scope = thisScope$
  addVar~& = totalVars

END FUNCTION

FUNCTION DetectType%% (__varname$)

  DIM varname$: varname$ = LTRIM$(RTRIM$(__varname$))

  detectType%% = varType_DEFAULT

  IF RIGHT$(varname$, 1) = "$" THEN detectType%% = varTypeSTRING

  IF RIGHT$(varname$, 3) = "~%%" THEN
    detectType%% = varType_UBYTE
  ELSEIF RIGHT$(varname$, 2) = "%%" THEN
    detectType%% = varType_BYTE
  ELSEIF RIGHT$(varname$, 2) = "~%" THEN
    detectType%% = varType_UINTEGER
  ELSEIF RIGHT$(varname$, 1) = "%" THEN
    detectType%% = varTypeINTEGER
  END IF

  IF RIGHT$(varname$, 1) = "!" THEN
    detectType%% = varTypeSINGLE
  ELSEIF RIGHT$(varname$, 2) = "##" THEN
    detectType%% = varType_FLOAT
  ELSEIF RIGHT$(varname$, 1) = "#" THEN
    detectType%% = varTypeDOUBLE
  END IF

  IF RIGHT$(varname$, 3) = "~&&" THEN
    detectType%% = varType_UINTEGER64
  ELSEIF RIGHT$(varname$, 2) = "&&" THEN
    detectType%% = varType_INTEGER64
  ELSEIF RIGHT$(varname$, 2) = "~&" THEN
    detectType%% = varType_ULONG
  ELSEIF RIGHT$(varname$, 1) = "&" THEN
    detectType%% = varTypeLONG
  END IF

END FUNCTION

FUNCTION SearchVar~& (__varName$)
  
  DIM i AS LONG, found AS _BYTE
  DIM varName$

  varName$ = __varName$

  'check if var exists
  FOR i = 1 TO totalVars
    IF LCASE$(LTRIM$(RTRIM$(vars(i).name))) = LCASE$(LTRIM$(RTRIM$(varName$))) THEN
      found = TRUE
      EXIT FOR
    END IF
  NEXT

  IF found THEN searchVar~& = i

END FUNCTION

FUNCTION RemoveQuote$ (__text$)
  DIM text$: text$ = __text$
  IF LEFT$(text$, 1) = CHR$(34) THEN text$ = MID$(text$, 2)
  IF RIGHT$(text$, 1) = CHR$(34) THEN text$ = LEFT$(text$, LEN(text$) - 1)
  RemoveQuote$ = text$
END FUNCTION

FUNCTION GetVal## (__c$, foundAsText AS _BYTE, textReturn$)

  DIM c$, sp AS LONG
  DIM varIndex AS LONG
  DIM temp##, temp$

  c$ = LTRIM$(RTRIM$(__c$))
  foundAsText = FALSE

  IF LEFT$(c$, 1) = CHR$(34) THEN
    'db_echo "literal string"
    foundAsText = TRUE
    textReturn$ = removeQuote$(c$)
    EXIT FUNCTION
  END IF

  sp = INSTR(c$, CHR$(32))
  IF sp THEN
    temp$ = MID$(c$, sp + 1)
    temp## = VAL(temp$)
    c$ = LEFT$(c$, sp - 1)
  END IF

  varIndex = searchVar(c$)
  IF varIndex THEN
    IF vars(varIndex).protected THEN
      'db_echo "returning QB64 function"
      'db_echo "temp## =" + STR$(temp##)
      'db_echo "temp$  =" + CHR$(34) + temp$ + CHR$(34)
      SELECT CASE RTRIM$(vars(varIndex).name)
        CASE "abs": GetVal## = ABS(temp##)
        CASE "asc": GetVal## = ASC(temp$)
        CASE "atn": GetVal## = ATN(temp##)
        CASE "cdbl": GetVal## = CDBL(temp##)
        CASE "chr$": foundAsText = TRUE: textReturn$ = CHR$(temp##)
        CASE "cint": GetVal## = CINT(temp##)
        CASE "clng": GetVal## = CLNG(temp##)
        CASE "command$": foundAsText = TRUE: textReturn$ = COMMAND$(temp##)
        CASE "cos": GetVal## = COS(temp##)
        CASE "csng": GetVal## = CSNG(temp##)
        CASE "csrlin": GetVal## = CSRLIN
        CASE "cvd": GetVal## = CVD(temp$)
        CASE "cvdmbf": GetVal## = CVDMBF(temp$)
        CASE "cvi": GetVal## = CVI(temp$)
        CASE "cvl": GetVal## = CVL(temp$)
        CASE "cvs": GetVal## = CVS(temp$)
        CASE "cvsmbf": GetVal## = CVSMBF(temp$)
        CASE "date$": foundAsText = TRUE: textReturn$ = DATE$
        CASE "environ$": foundAsText = TRUE: textReturn$ = ENVIRON$(temp$)
        CASE "eof": GetVal## = EOF(temp##)
        CASE "erl": GetVal## = lineThatErrored
        CASE "err": GetVal## = ERR
        CASE "exp": GetVal## = EXP(temp##)
        CASE "fix": GetVal## = FIX(temp##)
        CASE "freefile": GetVal## = FREEFILE
        CASE "hex$": foundAsText = TRUE: textReturn$ = HEX$(temp##)
        CASE "inkey$": foundAsText = TRUE: textReturn$ = INKEY$
        CASE "inp": GetVal## = INP(temp##)
        CASE "instr": 'GetVal## = instr
        CASE "int": GetVal## = INT(temp##)
        CASE "lbound": 'GetVal## = lbound
        CASE "lcase$": foundAsText = TRUE: textReturn$ = LCASE$(temp$)
        CASE "left$": 'foundAsText = true: textReturn$ = left$
        CASE "len": GetVal## = LEN(temp$)
        CASE "loc": GetVal## = LOC(temp##)
        CASE "lof": GetVal## = LOF(temp##)
        CASE "log": GetVal## = LOG(temp##)
        CASE "ltrim$": foundAsText = TRUE: textReturn$ = LTRIM$(temp$)
        CASE "mid$": 'foundAsText = true: textReturn$ = mid$
        CASE "mkd$": foundAsText = TRUE: textReturn$ = MKD$(temp##)
        CASE "mkdmbf$": foundAsText = TRUE: textReturn$ = MKDMBF$(temp##)
        CASE "mki$": foundAsText = TRUE: textReturn$ = MKI$(temp##)
        CASE "mkl$": foundAsText = TRUE: textReturn$ = MKL$(temp##)
        CASE "mks$": foundAsText = TRUE: textReturn$ = MKS$(temp##)
        CASE "mksmbf$": foundAsText = TRUE: textReturn$ = MKSMBF$(temp##)
        CASE "oct$": foundAsText = TRUE: textReturn$ = OCT$(temp##)
        CASE "point": 'GetVal## = point
        CASE "pos": GetVal## = POS(temp##)
        CASE "right$": 'foundAsText = true: textReturn$ = right$
        CASE "rnd": GetVal## = RND
        CASE "rtrim$": foundAsText = TRUE: textReturn$ = RTRIM$(temp$)
        CASE "screen": 'GetVal## = screen
        CASE "sgn": GetVal## = SGN(temp##)
        CASE "seek": GetVal## = SEEK(temp##)
        CASE "shell": GetVal## = SHELL(temp$)
        CASE "sin": GetVal## = SIN(temp##)
        CASE "space$": foundAsText = TRUE: textReturn$ = SPACE$(temp##)
        CASE "spc": foundAsText = TRUE: textReturn$ = SPC(temp##)
        CASE "sqr": GetVal## = SQR(temp##)
        CASE "str$": foundAsText = TRUE: textReturn$ = STR$(temp##)
        CASE "string$": 'foundAsText = true: textReturn$ = string$(temp##)
        CASE "tab": foundAsText = TRUE: textReturn$ = TAB(temp##)
        CASE "tan": GetVal## = TAN(temp##)
        CASE "time$": foundAsText = TRUE: textReturn$ = TIME$
        CASE "timer": GetVal## = TIMER
        CASE "ubound": 'GetVal## = ubound
        CASE "ucase$": foundAsText = TRUE: textReturn$ = UCASE$(temp$)
        CASE "val": GetVal## = VAL(temp$)
        CASE "_acceptfiledrop": GetVal## = _ACCEPTFILEDROP
        CASE "_alpha": 'GetVal## = _alpha
        CASE "_alpha32": 'GetVal## = _alpha32
        CASE "_atan2": 'GetVal## = _atan2
        CASE "_autodisplay": GetVal## = _AUTODISPLAY
        CASE "_axis": GetVal## = _AXIS
        CASE "_backgroundcolor": GetVal## = _BACKGROUNDCOLOR
        CASE "_blend": GetVal## = _BLEND
        CASE "_blink": GetVal## = _BLINK
        CASE "_blue": 'GetVal## = _blue
        CASE "_blue32": 'GetVal## = _blue32
        CASE "_button": GetVal## = _BUTTON
        CASE "_buttonchange": GetVal## = _BUTTONCHANGE
        CASE "_clearcolor": GetVal## = _CLEARCOLOR
        CASE "_clipboard$": foundAsText = TRUE: textReturn$ = _CLIPBOARD$
        CASE "_clipboardimage": GetVal## = _CLIPBOARDIMAGE
        CASE "_commandcount": GetVal## = _COMMANDCOUNT
        CASE "_connected": GetVal## = _CONNECTED(temp##)
        CASE "_connectionaddress", "_connectionaddress$": foundAsText = TRUE: textReturn$ = _CONNECTIONADDRESS$(temp##)
        CASE "_console": GetVal## = _CONSOLE
        CASE "_controlchr": GetVal## = _CONTROLCHR
        CASE "_copyimage": GetVal## = _COPYIMAGE(temp##)
        CASE "_cv": 'GetVal## = _cv
        CASE "_cwd$": foundAsText = TRUE: textReturn$ = _CWD$
        CASE "_defaultcolor": GetVal## = _DEFAULTCOLOR
        CASE "_deflate$": foundAsText = TRUE: textReturn$ = _DEFLATE$(temp$)
        CASE "_desktopheight": GetVal## = _DESKTOPHEIGHT
        CASE "_desktopwidth": GetVal## = _DESKTOPWIDTH
        CASE "_dest": GetVal## = _DEST
        CASE "_devices": GetVal## = _DEVICES
        CASE "_device$": foundAsText = TRUE: textReturn$ = _DEVICE$
        CASE "_deviceinput": GetVal## = _DEVICEINPUT
        CASE "_dir$": foundAsText = TRUE: textReturn$ = _DIR$(temp$)
        CASE "_direxists": GetVal## = _DIREXISTS(temp$)
        CASE "_display": GetVal## = _DISPLAY
        CASE "_droppedfile", "_droppedfile$": foundAsText = TRUE: textReturn$ = _DROPPEDFILE$
        CASE "_errorline": GetVal## = lineThatErrored
        CASE "_exit": GetVal## = _EXIT
        CASE "_fileexists": GetVal## = _FILEEXISTS(temp$)
        CASE "_font": GetVal## = _FONT
        CASE "_fontheight": GetVal## = _FONTHEIGHT
        CASE "_fontwidth": GetVal## = _FONTWIDTH
        CASE "_freetimer": GetVal## = _FREETIMER
        CASE "_fullscreen": GetVal## = _FULLSCREEN
        CASE "_green": 'GetVal## = _green
        CASE "_green32": 'GetVal## = _green32
        CASE "_height": GetVal## = _HEIGHT
        CASE "_hypot": 'GetVal## = _hypot
        CASE "_inclerrorfile$": foundAsText = TRUE: textReturn$ = _INCLERRORFILE$
        CASE "_inclerrorline": 'GetVal## = _INCLERRORLINE
        CASE "_inflate$": foundAsText = TRUE: textReturn$ = _INFLATE$(temp$)
        CASE "_instrrev": 'GetVal## = _instrrev
        CASE "_keydown": GetVal## = _KEYDOWN(temp##)
        CASE "_keyhit": GetVal## = keyhit
        CASE "_lastaxis": GetVal## = _LASTAXIS
        CASE "_lastbutton": GetVal## = _LASTBUTTON
        CASE "_lastwheel": GetVal## = _LASTWHEEL
        CASE "_loadfont": 'GetVal## = _loadfont
        CASE "_loadimage": GetVal## = _LOADIMAGE(temp$)
        CASE "_mapunicode": GetVal## = _MAPUNICODE(temp##)
        CASE "_mk$": foundAsText = TRUE ': textReturn$ = _mk$
        CASE "_mousebutton": GetVal## = _MOUSEBUTTON(temp##)
        CASE "_mouseinput": GetVal## = _MOUSEINPUT
        CASE "_mousex": GetVal## = _MOUSEX
        CASE "_mousey": GetVal## = _MOUSEY
        CASE "_mousewheel": GetVal## = _MOUSEWHEEL
        CASE "_newimage": 'GetVal## = _newimage
        CASE "_openclient": GetVal## = _OPENCLIENT(temp$)
        CASE "_openconnection": GetVal## = _OPENCONNECTION(temp##)
        CASE "_openhost": GetVal## = _OPENHOST(temp$)
        CASE "_os$": foundAsText = TRUE: textReturn$ = _OS$
        CASE "_palettecolor": GetVal## = _PALETTECOLOR(temp##)
        CASE "_pi"
          IF temp$ = "" THEN temp## = 1
          GetVal## = _PI(temp##)
        CASE "_pixelsize": GetVal## = _PIXELSIZE
        CASE "_printmode": GetVal## = _PRINTMODE
        CASE "_printwidth": GetVal## = _PRINTWIDTH(temp$)
        CASE "_readbit": 'GetVal## = _readbit
        CASE "_resize": GetVal## = _RESIZE
        CASE "_rgb": 'GetVal## = _rgb
        CASE "_rgb32": 'GetVal## = _rgb32
        CASE "_rgba": 'GetVal## = _rgba
        CASE "_rgba32": 'GetVal## = _rgba32
        CASE "_red":  'GetVal## = _red
        CASE "_red32": 'GetVal## = _red32
        CASE "_resetbit": 'GetVal## = _resetbit
        CASE "_resizeheight": GetVal## = _RESIZEHEIGHT
        CASE "_resizewidth": GetVal## = _RESIZEWIDTH
        CASE "_round": GetVal## = _ROUND(temp##)
        CASE "_scaledheight": GetVal## = _SCALEDHEIGHT
        CASE "_scaledwidth": GetVal## = _SCALEDWIDTH
        CASE "_screenexists": GetVal## = _SCREENEXISTS
        CASE "_screenhide": GetVal## = _SCREENHIDE
        CASE "_screenimage": GetVal## = _SCREENIMAGE
        CASE "_screenx": GetVal## = _SCREENX
        CASE "_screeny": GetVal## = _SCREENY
        CASE "_setbit": 'GetVal## = _setbit
        CASE "_shellhide": GetVal## = _SHELLHIDE(temp$)
        CASE "_shl": 'GetVal## = _shl
        CASE "_shr": 'GetVal## = _shr
        CASE "_smooth": GetVal## = _SMOOTH
        CASE "_sndcopy": GetVal## = _SNDCOPY(temp##)
        CASE "_sndgetpos": GetVal## = _SNDGETPOS(temp##)
        CASE "_sndlen": GetVal## = _SNDLEN(temp##)
        CASE "_sndopen": GetVal## = _SNDOPEN(temp$)
        CASE "_sndopenraw": GetVal## = _SNDOPENRAW
        CASE "_sndpaused": GetVal## = _SNDPAUSED(temp##)
        CASE "_sndplaying": GetVal## = _SNDPLAYING(temp##)
        CASE "_sndrate": GetVal## = _SNDRATE
        CASE "_sndrawlen": GetVal## = _SNDRAWLEN
        CASE "_source": GetVal## = _SOURCE
        CASE "_startdir$": foundAsText = TRUE: textReturn$ = _STARTDIR$
        CASE "_strcmp": 'GetVal## = _strcmp
        CASE "_stricmp": 'GetVal## = _stricmp
        CASE "_title$": foundAsText = TRUE: textReturn$ = _TITLE$
        CASE "_togglebit": 'GetVal## = _togglebit
        CASE "_totaldroppedfiles": GetVal## = _TOTALDROPPEDFILES
        CASE "_trim$": foundAsText = TRUE: textReturn$ = _TRIM$(temp$)
        CASE "_wheel": GetVal## = _WHEEL
        CASE "_width": GetVal## = _WIDTH
        CASE "_windowhandle": GetVal## = _WINDOWHANDLE
        CASE "_windowhasfocus": GetVal## = _WINDOWHASFOCUS
      END SELECT
    ELSEIF vars(varIndex).type = varTypeSTRING THEN
      'db_echo "found in strings()"
      foundAsText = true
      textReturn$ = strings(varIndex)
    ELSE
      GetVal## = nums(varIndex)
      'db_echo "returning nums()"
    END IF
  ELSE
    'db_echo "not found as var"
    IF detectType%%(c$) = varTypeSTRING THEN
      foundAsText = true
      textReturn$ = ""
      'db_echo "returning an empty string"
    ELSE
      IF isNumber(c$) THEN
        GetVal## = VAL(c$)
        'db_echo "returning val()"
      ELSE
        'db_echo "returning 0"
      END IF
    END IF
  END IF

END FUNCTION

FUNCTION Parse$ (running AS INTEGER, __inputExpr AS STRING)

  'Adapted from https://www.codeproject.com/Articles/1205435/Parsing-Mathematical-Expressions-in-VB-NET-Missi
  ' Call this routine to perform the actual mathematic expression parsing
  ' Comments retained from the original code are marked with OC.

  DIM t AS LONG, index AS LONG
  DIM totalStrings AS LONG
  DIM inputExpr AS STRING, temp$
  DIM returnAsText AS _BYTE, textReturn AS STRING
  REDIM oe(0) AS LONG
  REDIM strs(0) AS STRING

  'db_echo "------------------ Parsing: " + __inputExpr

  IF LEFT$(__inputExpr, 1) = CHR$(34) AND INSTR(2, __inputExpr, CHR$(34)) = LEN(__inputExpr) THEN
    'string literal
    Parse$ = removeQuote(__inputExpr)
    EXIT FUNCTION
  END IF

  inputExpr = "(" + __inputExpr + ")"

  t = 1
  'OC: Iterate through the characters of input string starting at the position of final character
  FOR index = LEN(inputExpr) - 1 TO 0 STEP -1
    'OC: For each character perform a check if its value is '('
    IF ASC(inputExpr, index + 1) = 40 OR index = 0 THEN
      DIM sb AS STRING
      sb = ""
      DIM n AS LONG
      'OC: Perform a check if this is the first character in string
      IF index = 0 THEN
        'OC: If so assign n variable to the value of variable index
        n = 1
      ELSE
        'OC: Otherwise assign n variable to the value of variable index + 1
        n = index + 1
      END IF

      DIM exists AS _BYTE
      DO
        exists = FALSE
        DIM bracket AS _BYTE
        bracket = FALSE
        'OC: Perform the iterations stepping forward into each succeeding character
        'OC: starting at the position n = index + 1 until we've found a character equal to ')'
        WHILE n < LEN(inputExpr) AND bracket = FALSE
          'OC: Check if the current character is not ')'.
          IF ASC(inputExpr, n + 1) <> 41 THEN
            'OC: If so, append it to the temporary string buffer
            sb = sb + MID$(inputExpr, n + 1, 1)
            'OC: Otherwise break the loop execution
          ELSE
            bracket = true
          END IF
          'OC: Increment the n loop counter variable by 1
          n = n + 1
        WEND
        DIM r AS LONG
        r = 0
        'OC: Iterate through the array of positions
        WHILE r <= UBOUND(oe) AND exists = FALSE
          'OC: For each element perform a check if its value
          'OC: is equal to the position of the current ')' character
          IF oe(r) = n THEN
            'OC: If so, append the character ')' to the temporary string buffer and break
            'OC: the loop execution assigning the variable exists to the value 'true'
            exists = true
            sb = sb + ") "
          END IF
          r = r + 1
        WEND
        'OC: Repeat the following loop execution until we've found the character ')' at
        'OC: the New position which is not in the array of positions
      LOOP WHILE exists = true
      'OC: If the current character's ')' position has not been previous found,
      'OC: add the value of position to the array
      IF exists = FALSE THEN
        REDIM _PRESERVE oe(UBOUND(oe) + 1)
        oe(t) = n
        t = t + 1
      END IF
      'OC: Add the currently obtained string containing a specific part of the expression to the array
      totalStrings = totalStrings + 1
      REDIM _PRESERVE strs(totalStrings)
      strs(totalStrings) = sb
    END IF
  NEXT
  'OC: Iterate through the array of the expression parts
  FOR index = 1 TO totalStrings
    'OC: Compute the result for the current part of the expression
    DIM Result AS STRING
    errorHappened = FALSE
    Result = STR$(Compute(running, strs(index), returnAsText, textReturn))
    IF errorHappened THEN EXIT FUNCTION
    IF returnAsText THEN Result = " " + textReturn
    'OC: Iterate through all succeeding parts of the expression
    FOR n = index TO totalStrings
      'OC: For each part substitute the substring containing the current part of the expression
      'OC: with its numerical value without parentheses.
      strs(n) = Replace1(strs(n), "(" + strs(index) + ")", Result, 0, 0)
    NEXT
  NEXT
  'OC: Compute the numerical value of the last part (e.g. the numerical resulting value of the entire expression)
  'OC: and return this value at the end of the following routine execution.
  errorHappened = FALSE
  temp$ = STR$(Compute(running, strs(totalStrings), returnAsText, textReturn))
  IF errorHappened THEN EXIT FUNCTION
  IF returnAsText THEN
    Parse$ = textReturn
  ELSE
    Parse$ = temp$
  END IF

END FUNCTION

FUNCTION Compute## (running AS INTEGER, expr AS STRING, foundAsText AS _BYTE, textReturn$)

  DIM i AS LONG, j AS LONG
  DIM l AS LONG, m AS LONG, lastIndex AS LONG
  DIM totalElements AS LONG
  DIM ch AS STRING, hasOperator%%
  DIM quote AS _BYTE
  DIM tempElement AS STRING, op1##, op2##, result##
  DIM txtop1$, txtop2$, txtresult$
  DIM getvalTxtRet1 AS _BYTE, getvalTxtResult1 AS STRING
  DIM getvalTxtRet2 AS _BYTE, getvalTxtResult2 AS STRING

  REDIM element(1000) AS STRING

  STATIC op(9) AS STRING, validOP$

  IF LEN(validOP$) = 0 THEN
    validOP$ = "^*/\+-=><"
    FOR i = 1 TO LEN(validOP$)
      op(i) = MID$(validOP$, i, 1)
    NEXT
  END IF

  'db_echo "* Entering Compute##(): " + expr

  'break down expr into element()
  FOR i = 1 TO LEN(expr)
    ch = MID$(expr, i, 1)
    IF ch = CHR$(34) THEN quote = NOT quote
    IF INSTR(validOP$, ch) THEN
      'this is an operator
      IF quote THEN
        tempElement = tempElement + ch
      ELSE
        IF LEN(tempElement) THEN GOSUB addElement
        tempElement = ch
        GOSUB addElement
        tempElement = ""
      END IF
    ELSE
      tempElement = tempElement + ch
    END IF
  NEXT
  IF LEN(tempElement) THEN GOSUB addElement

  ' IF debugging THEN
  '   DIM el$, tempElCount AS LONG
  '   el$ = ""
  '   tempElCount = 0
  '   FOR l = 1 TO totalElements
  '     IF LEN(_TRIM$(element$(l))) > 0 THEN
  '       tempElCount = tempElCount + 1
  '       el$ = el$ + element(l)
  '     END IF
  '   NEXT
  '   'db_echo "** Total elements:" + STR$(tempElCount) + " **"
  '   'db_echo el$
  '   'db_echo "     ***"
  ' END IF

  FOR i = 1 TO LEN(validOP$)
    FOR j = 1 TO totalElements
      IF element(j) = op(i) THEN
        hasOperator%% = true
        l = 1
        IF j - l > 0 THEN
          DO UNTIL LEN(_TRIM$(element(j - l))) > 0 AND INSTR(validOP$, element(j - l)) = 0
            l = l + 1
            IF j - l < 1 THEN EXIT FUNCTION
          LOOP
        END IF
        IF isNumber(element(j - l)) THEN
          op1## = VAL(element(j - l))
        ELSE
          op1## = GetVal(element(j - l), getvalTxtRet1, getvalTxtResult1)
          IF getvalTxtRet1 THEN txtop1$ = getvalTxtResult1
        END IF
        'db_echo "element(j - l) = " + element(j - l)
        m = 1
        IF j + m <= totalElements THEN
          DO UNTIL LEN(_TRIM$(element(j + m))) > 0 AND INSTR(validOP$, element(j + m)) = 0
            m = m + 1
            IF j + m > totalElements THEN EXIT FUNCTION
          LOOP
        END IF
        IF isNumber(element(j + m)) THEN
          op2## = VAL(element(j + m))
        ELSE
          op2## = GetVal(element(j + m), getvalTxtRet2, getvalTxtResult2)
          IF getvalTxtRet2 THEN txtop2$ = getvalTxtResult2
        END IF
        'db_echo "element(j + m) = " + element(j + m)
        'db_echo "op1=" + STR$(op1##) + "; oper=" + op(i) + "; op2=" + STR$(op2##)
        'db_echo "txtop1=" + txtop1$ + "; oper=" + op(i) + "; txtop2=" + txtop2$
        SELECT CASE op(i)
          CASE "^"
            IF getvalTxtRet1 OR getvalTxtRet2 THEN throwError running, 13: EXIT FUNCTION
            foundAsText = FALSE
            result## = op1## ^ op2##
          CASE "*"
            IF getvalTxtRet1 OR getvalTxtRet2 THEN throwError running, 13: EXIT FUNCTION
            foundAsText = FALSE
            result## = op1## * op2##
          CASE "/"
            IF getvalTxtRet1 OR getvalTxtRet2 THEN throwError running, 13: EXIT FUNCTION
            foundAsText = FALSE
            result## = op1## / op2##
          CASE "\"
            IF getvalTxtRet1 OR getvalTxtRet2 THEN throwError running, 13: EXIT FUNCTION
            foundAsText = FALSE
            result## = op1## \ op2##
          CASE "+"
            IF getvalTxtRet1 AND getvalTxtRet2 THEN
              txtresult$ = txtop1$ + txtop2$
              foundAsText = true
            ELSEIF NOT getvalTxtRet1 AND NOT getvalTxtRet2 THEN
              result## = op1## + op2##
              foundAsText = FALSE
            ELSE
              throwError running, 13: EXIT FUNCTION
            END IF
          CASE "-"
            IF getvalTxtRet1 OR getvalTxtRet2 THEN throwError running, 13: EXIT FUNCTION
            result## = op1## - op2##
            foundAsText = FALSE
          CASE "="
            IF getvalTxtRet1 AND getvalTxtRet2 THEN
              result## = (txtop1$ = txtop2$)
              foundAsText = true
            ELSEIF NOT getvalTxtRet1 AND NOT getvalTxtRet2 THEN
              result## = (op1## = op2##)
              foundAsText = FALSE
            ELSE
              throwError running, 13: EXIT FUNCTION
            END IF
          CASE ">"
            IF getvalTxtRet1 AND getvalTxtRet2 THEN
              result## = (txtop1$ > txtop2$)
              foundAsText = true
            ELSEIF NOT getvalTxtRet1 AND NOT getvalTxtRet2 THEN
              result## = (op1## > op2##)
              foundAsText = FALSE
            ELSE
              throwError running, 13: EXIT FUNCTION
            END IF
          CASE "<"
            IF getvalTxtRet1 AND getvalTxtRet2 THEN
              result## = (txtop1$ < txtop2$)
              foundAsText = true
            ELSEIF NOT getvalTxtRet1 AND NOT getvalTxtRet2 THEN
              result## = (op1## < op2##)
              foundAsText = FALSE
            ELSE
              throwError running, 13: EXIT FUNCTION
            END IF
        END SELECT
        'db_echo "temp result## =" + STR$(result##)
        'db_echo "temp txtresult$ =" + txtresult$
        element(j - l) = ""
        element(j + m) = ""
        IF foundAsText THEN
          element(j) = txtresult$
        ELSE
          element(j) = STR$(result##)
        END IF
        lastIndex = j
        ' IF debugging THEN
        '   el$ = ""
        '   tempElCount = 0
        '   FOR l = 1 TO totalElements
        '     IF LEN(_TRIM$(element$(l))) > 0 THEN
        '       tempElCount = tempElCount + 1
        '       el$ = el$ + element(l)
        '     END IF
        '   NEXT
        '   'db_echo "** Total elements:" + STR$(tempElCount) + " **"
        '   'db_echo el$
        '   'db_echo "     ***"
        ' END IF
      END IF
    NEXT
  NEXT

  IF hasOperator%% = FALSE AND totalElements = 1 THEN
    IF isNumber(element(1)) THEN
      op1## = VAL(element(1))
    ELSE
      op1## = GetVal(element(1), getvalTxtRet1, getvalTxtResult1)
    END IF
    IF getvalTxtRet1 THEN
      foundAsText = true
      textReturn$ = getvalTxtResult1
    ELSE
      foundAsText = FALSE
      Compute## = op1##
    END IF
  ELSE
    IF foundAsText THEN
      textReturn$ = element(lastIndex)
    ELSE
      Compute## = VAL(element(lastIndex))
    END IF
  END IF

  EXIT FUNCTION

addElement:
  totalElements = totalElements + 1
  IF totalElements > UBOUND(element) THEN
    REDIM _PRESERVE element(UBOUND(element) + 1000) AS STRING
  END IF
  element(totalElements) = tempElement
  RETURN

END FUNCTION

FUNCTION Replace1$ (TempText$, SubString$, NewString$, CaseSensitive AS _BYTE, TotalReplacements AS LONG)

  DIM FindSubString AS LONG, Text$

  IF LEN(TempText$) = 0 THEN EXIT SUB

  Text$ = TempText$
  TotalReplacements = 0
  DO
    IF CaseSensitive THEN
      FindSubString = INSTR(FindSubString + 1, Text$, SubString$)
    ELSE
      FindSubString = INSTR(FindSubString + 1, UCASE$(Text$), UCASE$(SubString$))
    END IF
    IF FindSubString = 0 THEN EXIT DO
    IF LEFT$(SubString$, 1) = "\" THEN 'Escape sequence
      'Replace the Substring if it's not preceeded by another backslash
      IF MID$(Text$, FindSubString - 1, 1) <> "\" THEN
        Text$ = LEFT$(Text$, FindSubString - 1) + NewString$ + MID$(Text$, FindSubString + LEN(SubString$))
        TotalReplacements = TotalReplacements + 1
      END IF
    ELSE
      Text$ = LEFT$(Text$, FindSubString - 1) + NewString$ + MID$(Text$, FindSubString + LEN(SubString$))
      TotalReplacements = TotalReplacements + 1
    END IF
  LOOP

  Replace1$ = Text$

END FUNCTION

FUNCTION IsNumber%% (__a$)

  DIM i AS LONG
  DIM a AS _UNSIGNED _BYTE
  DIM D AS LONG, E AS LONG
  DIM dp AS LONG
  DIM a$

  a$ = _TRIM$(__a$)

  IF LEN(a$) = 0 THEN EXIT FUNCTION

  FOR i = 1 TO LEN(a$)
    a = ASC(MID$(a$, i, 1))
    IF a = 45 THEN
        IF (i = 1 AND LEN(a$) > 1) OR (i > 1 AND ((D > 0 AND D = i - 1) OR (E > 0 AND E = i - 1))) THEN _CONTINUE
        EXIT FUNCTION
    END IF
    IF a = 46 THEN
      IF dp = 1 THEN EXIT FUNCTION
      dp = 1
      _CONTINUE
    END IF
    IF a = 100 OR a = 68 THEN 'D
      IF D > 0 OR E > 0 THEN EXIT FUNCTION
      IF i = 1 THEN EXIT FUNCTION
      D = i
      _CONTINUE
    END IF
    IF a = 101 OR a = 69 THEN 'E
      IF D > 0 OR E > 0 THEN EXIT FUNCTION
      IF i = 1 THEN EXIT FUNCTION
      E = i
      _CONTINUE
    END IF
    IF a = 43 THEN '+
      IF (D > 0 AND D = i - 1) OR (E > 0 AND E = i - 1) THEN _CONTINUE
      EXIT FUNCTION
    END IF

    IF a >= 48 AND a <= 57 THEN _CONTINUE
    EXIT FUNCTION
  NEXT
  isNumber%% = true
END FUNCTION

'SUB db_echo (text$)
'  'IF debugging THEN _ECHO text$
'END SUB

SUB ThrowError (running AS INTEGER, code AS INTEGER)
  IF running THEN PRINT "("; _TRIM$(STR$(_ERRORLINE)); ") "
  PRINT "Error #"; code;
  IF running THEN
    PRINT " on line"; currentLine
    lineThatErrored = currentLine
    running = FALSE
  END IF
  errorHappened = true
END SUB

' Like INSTR, but searches for subtext$ only outside quotation marks.
FUNCTION Find& (start AS LONG, text$, subtext$)

  DIM i AS LONG, p AS LONG, quote AS _BYTE, lastQuote AS LONG

  p = start - 1
  DO
    p = INSTR(p + 1, text$, subtext$)
    IF p = 0 THEN EXIT FUNCTION
    quote = FALSE
    IF lastQuote = 0 THEN lastQuote = 1
    FOR i = lastQuote TO p
      IF ASC(text$, i) = 34 THEN lastQuote = i: quote = NOT quote
    NEXT
  LOOP WHILE quote

  Find& = p

END FUNCTION

FUNCTION Delimit% (Work$, Delim$) STATIC
  Counter% = 0
  FOR X% = 1 TO LEN(Delim$)
    Counter% = Counter% + InCount%(Work$, MID$(Delim$, X%, 1))
  NEXT X%
  Delimit% = Counter%
END FUNCTION

SUB Parse (Work$, Delim$, Array$())

  BeginPtr% = 1
  Element% = 1

  FOR EndPtr% = 1 TO LEN(Work$)
    IF INSTR(Delim$, MID$(Work$, EndPtr%, 1)) THEN
      Array$(Element%) = MID$(Work$, BeginPtr%, EndPtr% - BeginPtr%)
      Element% = Element% + 1
      BeginPtr% = EndPtr% + 1
    END IF
  NEXT

  Array$(Element%) = MID$(Work$, BeginPtr%)

END SUB

SUB InitVar()
  found = searchVar("val")
  IF NOT found THEN
    functions$ = "val,int,asc,cos,sin,len,rnd,timer,time$,date$,chr$,inkey$,_width,_height,_mousex,_mousey,_mousebutton,str$,asc,_resize,_resizewidth,_resizeheight,_scaledwidth,_scaledheight,_screenhide,_console,_blink,_fileexists,_direxists,_devices,_device$,_deviceinput,_lastbutton,_lastaxis,_lastwheel,_button,_buttonchange,_axis,_wheel,_screenx,_screeny,_os$,_title$,_mapunicode,_keydown,_keyhit,_windowhandle,_screenimage,_freetimer,_fullscreen,_smooth,_windowhasfocus,_clipboard$,_clipboardimage,_exit,_openhost,_connected,_connectionaddress,_connectionaddress$,_openconnection,_openclient,environ$,_errorline,_inclerrorline,_acceptfiledrop,_totaldroppedfiles,_droppedfile,_droppedfile$,_newimage,_loadimage,_copyimage,_source,_dest,_display,_pixelsize,_clearcolor,_blend,_defaultcolor,_backgroundcolor,_palettecolor,_loadfont,_fontwidth,_fontheight,_font,_printwidth,_printmode,_rgba,_rgba32,_rgb,_rgb32,_red,_red32,_green,_green32,_blue,_blue32,_alpha,_alpha32,_mouseinput,_mousewheel,freefile,shell,_shellhide,command$,_commandcount,_sndrate,_sndopenraw,_sndrawlen,_sndlen,_sndpaused,_sndopen,_sndgetpos,_sndplaying,_sndcopy,seek,loc,eof,lof,screen,point,tab,spc,inp,pos,sgn,lbound,ubound,oct$,hex$,exp,fix,cdbl,csng,_round,cint,clng,csrlin,mki$,mkl$,mks$,mkd$,mksmbf$,mkdmbf$,_mk$,cvsmbf,cvdmbf,cvi,cvl,cvs,cvd,_cv,string$,space$,instr,_instrrev,mid$,sqr,tan,atn,log,abs,erl,err,ucase$,lcase$,left$,right$,ltrim$,rtrim$,_trim$,_cwd$,_startdir$,_dir$,_inclerrorfile$,_atan2,_hypot,_pi,_desktopheight,_desktopwidth,_screenexists,_controlchr,_stricmp,_strcmp,_autodisplay,_shr,_shl,_deflate$,_inflate$,_readbit,_setbit,_resetbit,_togglebit"
    delim$ = ","
    x = Delimit%(functions$, delim$) + 1
    DIM funcs$(x)
    Parse functions$, delim$, funcs$()
    FOR x = LBOUND(funcs$) TO UBOUND(funcs$)
      varIndex = addVar(funcs$(x), TRUE)
    NEXT
  END IF
END SUB