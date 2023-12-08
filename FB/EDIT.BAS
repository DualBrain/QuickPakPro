' ********** EDIT.BAS - a clone of MS-DOS 5.0 EDIT.EXE

' Copyright (c) 2023 Cory Smith

#INCLUDE ONCE "PRO.BI"
#INCLUDE ONCE "QEDIT.BI"
#INCLUDE ONCE "QEDITYPE.BI"
#INCLUDE ONCE "DIALOG.BI"

SUB SetCursor (v1 AS SHORT, v2 AS SHORT)
END SUB
SUB BarPrint (menuS() AS STRING, stat() AS SHORT)
END SUB
' SUB QEdit (arrayS() AS STRING, kyS AS String, qeditAction AS SHORT, edState AS EditInfo)
' END SUB
SUB PullDnMs (menuS() AS STRING, stat() AS SHORT, menuAction AS SHORT, choice AS SHORT, kyS AS STRING, v1 AS SHORT)
END SUB
FUNCTION PullMenKey (keyS AS STRING, menuS() AS STRING, stat() AS SHORT) AS SHORT
  RETURN 0
END FUNCTION
SUB MouseRange (mouseBox() AS Area, v1 AS SHORT, numChoices AS SHORT, mRow AS SHORT, mCol AS SHORT, mButton AS SHORT, rangeNum AS SHORT)
END SUB

DECLARE SUB Dialog (choice1 AS SHORT, textS() AS STRING, responseS() AS STRING, menuS() AS STRING, scrnRow AS SHORT, style AS SHORT, bClr AS SHORT, action AS SHORT)
DECLARE SUB QEdit (arrayS() AS STRING, kyS AS String, qeditAction AS SHORT, edState AS EditInfo)

DECLARE SUB UpdateStatus(textS AS STRING, r AS SHORT, c AS SHORT)
DECLARE SUB NewAction()
DECLARE SUB OpenAction()
DECLARE SUB SaveAction()
DECLARE SUB SaveAsAction()
DECLARE SUB PrintAction()
DECLARE FUNCTION ExitAction() AS SHORT
DECLARE SUB CutAction()
DECLARE SUB CopyAction()
DECLARE SUB PasteAction()
DECLARE SUB ClearAction()
DECLARE SUB FindAction()
DECLARE SUB RepeatLastFindAction()
DECLARE SUB ChangeAction()
DECLARE SUB DisplayAction()
DECLARE SUB HelpPathsAction()
DECLARE SUB HelpGettingStartedAction()
DECLARE SUB HelpKeyboardAction()
DECLARE SUB HelpAboutAction()
DECLARE SUB QPrintRCenter (textS AS STRING, row AS SHORT, col1 AS SHORT, col2 AS SHORT, clr AS SHORT)
DECLARE SUB HScrollBarDraw (row AS SHORT, col1 AS SHORT, col2 AS SHORT, pct AS SHORT, clr AS SHORT)
DECLARE SUB VScrollBarDraw (row1 AS SHORT, row2 AS SHORT, col AS SHORT, pct AS SHORT, clr AS SHORT)
DECLARE SUB ButtonDraw (captionS AS STRING, row AS SHORT, col AS SHORT, clr AS SHORT)

DIM SHARED edState AS EditInfo

edState.AColor = 23      ' white on blue
edState.Wrap = 0         ' word wrap at column 65 (use 0 for to disable word wrap)
edState.Frame = 0        ' frame code (1 = show ruler line & scroll bars, 0 = don't)
edState.Rows = 21        ' number of text lines to display on the screen (3 - 25)
edState.Wide = 78        ' width of the active screen (10 - 80)
edState.HTab = 2         ' set tab stops to 4 spaces

REDIM SHARED arrayS(32767) AS String               ' holds the main editor string array
DIM SHARED qeditAction AS SHORT
DIM SHARED filenameS AS STRING

'CONST FALSE = 0
'CONST TRUE = NOT FALSE

DIM there AS SHORT
DIM r AS SHORT
DIM c AS SHORT
DIM action AS SHORT
DIM prefixS AS STRING
DIM kyS AS STRING
DIM menu AS SHORT
DIM menuAction AS SHORT
DIM choice AS SHORT
DIM locS AS STRING
DIM prevLocS AS STRING

CLS

InitMouse there                         ' Define the Mouse cursor
TextCursor -2, 4                        ' Inverse foreground red background
SetCursor 1, 1                          ' Locate it at upper right of screen
ShowCursor                              ' Turn it on

'PRINT OneColor(0, 1): END

LOCATE 2: MQPrint STRING$(23 * 80, CHR$(32)), OneColor(7, 1)  ' Make a background for the demo
Box0 2, 1, 24, 80, 1, OneColor(7, 1)

QPrintRC " Untitled ", 2, 35, OneColor(1, 7)

UpdateStatus "*", 0, 0

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

DIM menuS(15, 4) AS STRING
DIM stat(15, 4) AS SHORT
DIM msgS(15, 4) AS STRING
DIM helpS(15, 4) AS STRING

' REDIM menu(15, 4)                      ' Allocate space for the Menu Choices
' REDIM stat(15, 4)                       ' Define the choice status array
' REDIM msg(15, 4)                       ' The help message for each menu item
' REDIM help(15, 4)                      ' The detailed help (F1) for each menu item

prefixS = "F1=Help " + CHR$(179) + " "

menuS(0, 0) = "File"
menuS(1, 0) = "New" : msgS(1, 0) = prefixS + "Removes currently loaded file from memory"
menuS(2, 0) = "Open...": msgS(2, 0) = prefixS + "Loads new file into memory"
menuS(3, 0) = "Save" : msgS(3, 0) = prefixS + "Saves current file"
 stat(3, 0) = 1
menuS(4, 0) = "Save As..." : msgS(4, 0) = prefixS + "Saves current file with specified name"
 stat(4, 0) = 5 * 256
menuS(5, 0) = "-"
menuS(6, 0) = "Print" : msgS(6, 0) = prefixS + "Prints specified text"
menuS(7, 0) = "-"
menuS(8, 0) = "Exit" : msgS(8, 0) = prefixS + "Exits editor and returns to DOS"
 stat(8, 0) = 256

menuS(0, 1) = "Edit"
menuS(1, 1) = "Cut        Shift+Del" : msgS(1, 1) = prefixS + "Deletes selected text and copies it to buffer"
 stat(1, 1) = 2 * 256 + 1
menuS(2, 1) = "Copy        Ctrl+Ins" : msgS(2, 1) = prefixS + "Copies selected text to buffer"
 stat(2, 1) = 1
menuS(3, 1) = "Paste      Shift+Ins" : msgS(3, 1) = prefixS + "Inserts buffer contents at current location"
 stat(3, 1) = 1
menuS(4, 1) = "Clear            Del" : msgS(4, 1) = prefixS + "Deletes selected text without copying it to buffer"
 stat(4, 1) = 2 * 256 + 1

menuS(0, 2) = "Search"
menuS(1, 2) = "Find..." : msgS(1, 2) = prefixS + "Finds specified text"
menuS(2, 2) = "Repeat Last Find      F3" : msgS(2, 2) = prefixS + "Finds the next occurence of text specified in previous search"
menuS(3, 2) = "Change..." : msgS(3, 2) = prefixS + "Finds and changes specified text"

menuS(0, 3) = "Options"
menuS(1, 3) = "Display..." : msgS(1, 3) = prefixS + "Changes display attributes"
menuS(2, 3) = "Help Paths..." : msgS(2, 3) = prefixS + "Sets search path for Help files"

menuS(0, 4) = "Help"
 'stat(0, 4) = 42 ' this will "push over" (pad) the Help menu as desired,
                  ' however, the actual pull down menu logic doesn't handle
                  ' being "past" the right side of the screen (crashes).
menuS(1, 4) = "Getting Started...": msgS(1, 4) = prefixS + "Displays information on loading and using the MS-DOS Editor"
menuS(2, 4) = "Keyboard": msgS(2, 4) = prefixS + "Displays navigation and editing keystrokes"
menuS(3, 4) = "-"
menuS(4, 4) = "About...": msgS(4, 4) = prefixS + "Displays product version and copyright information"

BarPrint menuS(), stat()                 ' Display the menu bar and build a
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
  QEdit arrayS(), kyS, qeditAction, edState

  menu = PullMenKey(kyS, menuS(), stat())
  
  IF menu > -1 THEN                     ' Yes

    ' using menu in "polling mode"
    menuAction = 1
    DO                                        
      PullDnMs menuS(), stat(), menu, choice, kyS, menuAction
      SELECT CASE menu
        CASE 0, 1, 2, 3, 4
          UpdateStatus msgS(choice, menu), edState.CurLine, edState.CurCol
        CASE ELSE
      END SELECT
      SELECT CASE kyS
        CASE ELSE
      END SELECT
    LOOP UNTIL menuAction = 4
    PullDnMs menuS(), stat(), menuAction, choice, kyS, 5 ' Reset menu

    kyS = ""

    IF menuAction = 4 THEN
      SELECT CASE menu
        CASE 0 ' File
          SELECT CASE choice
            CASE 1: NewAction
            CASE 2: OpenAction
            CASE 3: SaveAction
            CASE 4: SaveAsAction
            CASE 6: PrintAction
            CASE 8: IF ExitAction THEN EXIT DO
            CASE ELSE
          END SELECT
        CASE 1 ' Edit
          SELECT case choice
            CASE 1: CutAction
            CASE 2: CopyAction
            CASE 3: PasteAction
            CASE 4: ClearAction
          END SELECT
        CASE 2 ' Search
          SELECT case choice
            CASE 1: FindAction
            CASE 2: RepeatLastFindAction
            CASE 3: ChangeAction
          END SELECT
        CASE 3 ' Options
          SELECT case choice
            CASE 1: DisplayAction
            CASE 2: HelpPathsAction
          END SELECT
        CASE 4 ' Help
          SELECT case choice
            CASE 1: HelpGettingStartedAction
            CASE 2: HelpKeyboardAction
            CASE 4: HelpAboutAction
          END SELECT
        CASE ELSE
      END SELECT
    END IF

    UpdateStatus "", edState.CurLine, edState.CurCol

  END IF

  locS = FUsing(STR$(edState.CurLine), "#####") + ":" + FUsing(STR$(edState.CurCol), "###")
  ReplaceString locS, " ", "0"
  IF prevLocS <> locS THEN
    QPrintRC locS, 25, 71, OneColor(0, 3) ' update cursor position.
    prevLocS = locS
  END IF

LOOP

'----- call QEdit again with an Action flag of 5 to restore the screen
QEdit arrayS(), kyS, 5, edState

HideCursor                              ' Turn the mouse cursor off

SYSTEM 'END

' ******************************************************************************
' * Internal Methods
' ******************************************************************************

' MsgBox (prompt, [buttons,] [title,] [helpfile, context])
SUB VbMsgBox(promptS AS STRING, buttons AS SHORT, titleS AS STRING) ', helpFileS, context)

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

  DIM action AS SHORT, scrnRow AS SHORT, choice AS SHORT, clr AS SHORT, style AS SHORT

  REDIM menuS(0) AS STRING
  REDIM textS(4) AS STRING
  REDIM responseS(0) AS STRING
  textS(0) = titleS
  textS(1) = "< OK >"
  textS(2) = " "
  textS(3) = promptS
  textS(4) = " "
  action = 0: scrnRow = 0: choice = 1: clr = 112: style = 11

  Dialog choice, textS(), responseS(), menuS(), scrnRow, style, clr, action

END SUB

SUB UpdateStatus(textS AS STRING, r AS SHORT, c AS SHORT) STATIC
  DIM valueS AS STRING, locS AS STRING
  IF textS <> valueS OR textS = "*" THEN
    IF textS = "" OR textS = "*" THEN valueS = "MS-DOS Editor  <F1=Help> Press ALT to activate menus" ELSE valueS = textS
    QPrintRC SPACE$(80), 25, 1, OneColor(15, 3) ' clear the background
    IF LEN(valueS) > 61 THEN
      QPrintRC LEFT$(valueS, 78), 25, 2, OneColor(15, 3)
    ELSE
      QPrintRC LEFT$(valueS, 61) + SPACE$(61 - LEN(valueS)), 25, 2, OneColor(15, 3)
      QPrintRC CHR$(179), 25, 63, OneColor(0, 3)  ' draw the black separator
      locS = FUsing(STR$(edState.CurLine), "#####") + ":" + FUsing(STR$(edState.CurCol), "###")
      ReplaceString locS, " ", "0"
      QPrintRC locS, 25, 71, OneColor(0, 3) ' update cursor position.
    END IF
  END IF
END SUB

' ******************************************************************************
' * ACTIONS
' ******************************************************************************

SUB NewAction

  DIM action AS SHORT, scrnRow AS SHORT, choice AS SHORT, clr AS SHORT, style AS SHORT

  DIM i AS SHORT
  VAR modified = -1

  IF modified THEN

    REDIM menuS(0) AS STRING
    REDIM textS(7) AS STRING
    REDIM responseS(0) AS STRING
    textS(1) = "< Yes >"
    textS(2) = "< No >"
    textS(3) = "< Cancel >"
    textS(4) = "< Help >"
    textS(5) = " "
    textS(6) = "Loaded file is not saved. Save it now?"
    textS(7) = " "
    scrnRow = -1: choice = 1: clr = 112: style = 11

    LOCATE 10                   'Top of Dialog box is at line 5
    Dialog choice, textS(), responseS(), menuS(), scrnRow, style, clr, action

    SELECT CASE choice
      CASE 1: ' Yes
      CASE 2: ' No
      CASE 3: ' Cancel
        EXIT SUB
      CASE 4: ' Help
        EXIT SUB
    END SELECT
  
  END IF

  FOR i = LBOUND(arrayS) TO UBOUND(arrayS): arrayS(i) = "": NEXT
  edState.CurLine = 1
  edState.CurCol = 1
  qeditAction = 2

END SUB

SUB OpenAction_HiLite(lrRow AS SHORT, mouseBox() AS Area, choice AS SHORT, hiLite AS SHORT)
  PaintBox0 lrRow - 1, mouseBox(choice).X1, lrRow - 1, mouseBox(choice).X1, hiLite
  PaintBox0 lrRow - 1, mouseBox(choice).X2, lrRow - 1, mouseBox(choice).X2, hiLite
END SUB

SUB OpenAction

  VAR ulRow = 3
  VAR ulCol = 7
  VAR lrRow = 22 ' for QB, use 23
  VAR lrCol = 73
  VAR bClr = OneColor(0, 7)

  VAR upperBound = 7
  VAR numButtons = 3

  ' ----Hilite color will be Bright White unless foreground color is Bright White
  VAR fFg = 15
  DIM fg AS SHORT, bg AS SHORT
  SplitColor bClr, fg, bg
  IF fg = 15 THEN fFg = 0                 ' If foreground color is Bright White, make hilite Black
  VAR hiLite = OneColor(fFg, bg)
  VAR hiClr = hiLite

  REDIM dial(6) AS DLog
  REDIM mouseBox(6) AS Area ' buttons

  REDIM textS(7) AS STRING
  REDIM responseS(7) AS STRING

  ' Save
  VAR sz = ArraySize(ulRow, ulCol, lrRow + 1, lrCol + 2)
  REDIM scrn(sz) AS SHORT
  MScrnSave ulRow, ulCol, lrRow + 1, lrCol + 2, @scrn(0)

  '***** Form *****

  ' - Background
  ClearScr0 ulRow, ulCol, lrRow, lrCol, bClr
  ' - Border
  Box0 ulRow, ulCol, lrRow, lrCol, 1, bClr
  ' - Button Splitter
  QPrintRC CHR$(195) + STRING$((lrCol - ulCol) - 1, 196) + CHR$(180), lrRow - 2, ulCol, bClr
  ' - Drop shadow
  PaintBox0 lrRow + 1, ulCol + 3, lrRow + 1, lrCol + 1, 8
  PaintBox0 ulRow + 1, lrCol + 1, lrRow + 1, lrCol + 2, 8
  ' - Caption
  VAR captionS = "Open" ' For QB, use "Open Program"
  QPrintRCenter " " + captionS + " ", 3, ulCol, lrCol, bClr

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

  VAR choice = 1
  LOCATE dial(choice).Row, dial(choice).Col, 1
  
  DIM kyS AS STRING, mFlag AS SHORT, numChoices AS SHORT, mButton AS SHORT
  DIM rangeNum AS SHORT, mRow AS SHORT, mCol AS SHORT, el AS SHORT
  DIM buttonDown AS SHORT, pressed AS SHORT, ky AS SHORT, found AS SHORT
  DIM lastXBox AS SHORT, dotEl AS SHORT, dotS AS STRING, numXBoxes AS SHORT
  DIM specS AS STRING, count AS SHORT, i AS SHORT, tempS AS STRING
  DIM style AS SHORT, clr AS SHORT, scrnRow AS SHORT
  DIM action AS SHORT

  DO
    DO
      kyS = INKEY$
      IF LEN(kyS) THEN mFlag = 0
      MouseRange mouseBox(), 1, numChoices, mRow, mCol, mButton, rangeNum
      IF mButton > 0 AND rangeNum THEN    ' If mouse down and its in a valid range
        IF rangeNum <> el THEN            ' If we havent already turned off hilite,
          hiLite = bClr                   '   turn off old HiLite
          REM GOSUB HiLite
          OpenAction_HiLite lrRow, mouseBox(), choice, hiLite
        END IF
        el = rangeNum
        IF el <= numButtons THEN          ' If we've clicked on a button
          choice = el                     '   choice = button selected
          buttonDown = -1                 ' Remember that mouse button was pressed
          PaintBox0 lrRow - 1, mouseBox(choice).X1 + 1, lrRow - 1, MouseBox(choice).X2 - 1, 15
        END IF
        mFlag = -1                        ' Set Mouse flag
        choice = rangeNum
        kyS = CHR$(154)                   ' Dummy key to exit INKEY$ loop
      END IF
      ' If we've clicked on a button, wait until mouse button is up
      IF rangeNum <= numButtons AND mButton = 0 AND buttonDown THEN
        buttonDown = 0
        PaintBox0 lrRow - 1, MouseBox(choice).X1 + 1, lrRow - 1, MouseBox(choice).X2 - 1, bClr
        EXIT SUB 'GOTO Done                         ' Exit Dialog box
      END IF
    LOOP UNTIL LEN(kyS) OR pressed
    
    IF NOT pressed THEN                   ' If a keystroke and not a mouse click
      IF LEN(kyS) < 2 THEN
        ky = ASC(kyS)
      ELSE
        ky = -ASC(RIGHT$(kyS, 1))
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
        IF choice <= numButtons THEN 
          hiLite = bClr
          REM GOSUB HiLite
          OpenAction_HiLite lrRow, mouseBox(), choice, hiLite
        END IF
        choice = choice + 1
        IF choice > UBOUND(dial) THEN choice = 1
      CASE -15 ' Shift Tab      
        IF choice <= numButtons THEN
          hiLite = bClr
          REM GOSUB HiLite
          OpenAction_HiLite lrRow, mouseBox(), choice, hiLite
        END IF
        choice = choice - 1
        IF choice < 1 THEN choice = UBOUND(dial)
      CASE -72, -77                       ' Up, Right arrows
        IF dial(choice).DType = 3 AND found THEN ' If we're on an Option button
          LOCATE dial(choice).Row, dial(choice).Col
          responseS(choice) = ""
          QPrint0 " ", bClr         ' Clear the last Dot
          choice = choice - 1
          IF choice <= lastXBox - numXBoxes THEN choice = lastXBox
          dotEl = choice                      ' Remember where the new Dot is
          LOCATE dial(choice).Row, dial(choice).Col
          QPrint0 dotS, bClr        ' Print the new Dot
          responseS(choice) = dotS
          found = 0
        END IF
      CASE -75, -80                       ' Left, Down arrows
        IF dial(choice).DType = 3 AND found THEN ' If we're on an Option button
          LOCATE dial(choice).Row, dial(choice).Col
          responseS(choice) = ""
          QPrint0 " ", bClr         ' Clear the last Dot
          choice = choice + 1
          IF choice > lastXBox THEN choice = lastXBox - numXBoxes + 1
          dotEl = choice                      ' Remember where the new Dot is
          LOCATE dial(choice).Row, dial(choice).Col
          QPrint0 dotS, bClr        ' Print the new Dot
          responseS(choice) = dotS
          found = 0
        END IF
      CASE 32 ' SpaceBar
        IF dial(choice).DType = 2 THEN              ' If we're in a check box
          LOCATE dial(choice).Row, dial(choice).Col
          IF responseS(choice) <> checkS THEN       ' If its not checked,
            QPrint0 checkS, bClr              '   check it
            responseS(choice) = checkS
          ELSE                                      ' If its checked,
            QPrint0 " ", bClr                 '   clear it
            responseS(choice) = ""
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
  MScrnRest ulRow, ulCol, lrRow + 1, lrCol + 2, @scrn(0)

  EXIT SUB

' HiLite:                                   ' Hilites the currently active button
'   PaintBox0 lrRow - 1, mouseBox(choice).X1, lrRow - 1, mouseBox(choice).X1, hiLite
'   PaintBox0 lrRow - 1, mouseBox(choice).X2, lrRow - 1, mouseBox(choice).X2, hiLite
' RETURN

  'NOTE: Current Dialog implementation (from old QPP) is not able to 
  '      handle the design requirements/layout for the Open dialog in
  '      the original MS-DOS EDIT program.
  'TODO: Need to implement the Open dialog.

  specS = "*.*"                  ' Read some files names for the first demo
  count = FCount(specS)         ' Count the files

  IF count = 0 THEN count = 1    ' In case there are no matching files
  REDIM menuS(count) AS STRING   ' Make an array to hold them
  FOR i = 1 TO count             ' Allocate space for each name
    menuS(i) = SPACE$(12)
  NEXT

  menuS(0) = specS               ' Read the names
  'CALL ReadFile(BYVAL VARPTR(menu$(0)))
  ReadFile @menuS(0)

  REDIM textS(7)
  REDIM responseS(7)
  textS(0) = " Open "            ' Dialog Box title (if any) goes in element 0
  textS(1) = "< OK >"            ' Command buttons MUST start at element 1 and
  textS(2) = "< Cancel >"        '   MUST be contiguous. You may have as many
  textS(3) = "< Help >"          '   buttons as will fit on the screen or as few
                                 '   as one
  textS(4) = "{25} File Name:"   ' The {} indicate a text input box. The number
                                 '   within the brackets indicate the max length of
                                 '   text to be entered. Adding 100 to this number
                                 '   will force numbers only to be entered
  textS(5) = "|305| Files"       ' The || indicate a list box. The right two
                                 '   digits between these two characters indicate
                                 '   the number of menu lines to display, however,
                                 '   this number may be overridden if the Dialog
                                 '   box-8 height is geater. To display multiple
                                 '   columns, add the number of columns * 100.
  'textS(6) = "|105| Dirs/Drives"
  textS(6) = "C:\"
  textS(7) = " "                 ' Blank line
  responseS(4) = specS           ' Make "File Name: text box display Spec$
  responseS(6) = textS(6)
  tempS = responseS(4)           ' Keep a copy of Spec$ for later
  style = 11                     ' Single line all around with a drop shadow
  clr = 112                      ' Black text on white background
  scrnRow = 0                    ' Center the Dialog box vertically
  action = 0                     ' Not re-entrant
  choice = 1                     ' Must initialize Choice to 1

  Dialog choice, textS(), responseS(), menuS(), scrnRow, style, clr, action

END SUB

SUB QPrintRCenter (textS AS STRING, row AS SHORT, col1 AS SHORT, col2 AS SHORT, clr AS SHORT)
  VAR c = col1 + ((col2 - col1) \ 2) - (LEN(textS) \ 2)
  QPrintRC textS, row, c, clr
END SUB

SUB HScrollBarDraw (row AS SHORT, col1 AS SHORT, col2 AS SHORT, pct AS SHORT, clr AS SHORT)
  QPrintRC CHR$(27) + STRING$((col2 - col1) - 1, 177) + CHR$(26), row, col1, clr
  QPrintRC CHR$(219), row, col1 + 1, clr ' Current position
END SUB

SUB VScrollBarDraw (row1 AS SHORT, row2 AS SHORT, col AS SHORT, pct AS SHORT, clr AS SHORT)
  DIM r AS SHORT
  QPrintRC CHR$(24), row1, col, clr
  FOR r = row1 + 1 TO row2 - 1
    QPrintRC CHR$(177), r, col, clr
  NEXT
  QPrintRC CHR$(25), row2, col, clr
  QPrintRC CHR$(219), row1 + 1, col, clr ' Current position
END SUB

SUB ButtonDraw (captionS AS STRING, row AS SHORT, col AS SHORT, clr AS SHORT)
  ' TODO: Need to determine if printing in regular color or white?
  QPrintRC "< " + SPACE$(LEN(captionS)) + " >", row, col, clr
  QPrintRC captionS, row, col + 2, clr
END SUB

SUB SaveAction

  IF filenameS = "" THEN
    SaveAsAction
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

  VAR specS = "*.*"                  ' Read some directory names
  VAR count = DCount(specS)         ' Count the directories

  DIM i AS SHORT, tempS AS STRING
  DIM style AS SHORT, clr AS SHORT, scrnRow AS SHORT, action AS SHORT, choice AS SHORT

  IF count = 0 THEN count = 1    ' In case there are no matching directories
  REDIM menuS(count) AS STRING   ' Make an array to hold them
  FOR i = 1 TO count             ' Allocate space for each name
    menuS(i) = SPACE$(12)
  NEXT

  menuS(0) = specS               ' Read the names
  menuS(1) = specS               ' Read the names
  ReadDir @menuS(1)
  menuS(1) = "..          "

  REDIM textS(6) AS STRING
  REDIM responseS(6) AS STRING
  'TODO: Need to handle whether to show " Save " or " Save As " depending on current state.
  textS(0) = " Save "            ' Dialog Box title (if any) goes in element 0
  textS(1) = "< OK >"            ' Command buttons MUST start at element 1 and
  textS(2) = "< Cancel >"        '   MUST be contiguous. You may have as many
  textS(3) = "< Help >"          '   buttons as will fit on the screen or as few
                                 '   as one
  textS(4) = "{25} File Name:"   ' The {} indicate a text input box. The number
                                 '   within the brackets indicate the max length of
                                 '   text to be entered. Adding 100 to this number
                                 '   will force numbers only to be entered
  textS(5) = CurDir
  textS(6) = "|107| Dirs/Drives" ' The || indicate a list box. The right two
                                 '   digits between these two characters indicate
                                 '   the number of menu lines to display, however,
                                 '   this number may be overridden if the Dialog
                                 '   box-8 height is geater. To display multiple
                                 '   columns, add the number of columns * 100.
  responseS(4) = ""              ' Make "File Name: text box display spec$
  responseS(5) = textS(5)
  tempS = responseS(5)           ' Keep a copy of spec$ for later
  style = 11                     ' Single line all around with a drop shadow
  clr = 112                      ' Black text on white background
  scrnRow = 0                    ' Center the Dialog box vertically
  action = 0                     ' Not re-entrant
  choice = 1                     ' Must initialize Choice to 1

  Dialog choice, textS(), responseS(), menuS(), scrnRow, style, clr, action

END SUB

SUB PrintAction

  DIM style AS SHORT, clr AS SHORT, scrnRow AS SHORT, action AS SHORT, choice AS SHORT

  REDIM menuS(0) AS STRING
  REDIM textS(8) AS STRING
  REDIM responseS(8) AS STRING
  textS(0) = " Print "
  textS(1) = "< OK >"
  textS(2) = "< Cancel >"
  textS(3) = "< Help >"
  textS(4) = " "
  textS(5) = "( ) Selected Text Only"
  textS(6) = "( ) Complete Document"
  textS(7) = " "
  textS(8) = " "
  responseS(6) = CHR$(7)
  scrnRow = 0
  clr = 112
  style = 11
  choice = 1

  Dialog choice, textS(), responseS(), menuS(), scrnRow, style, clr, action

END SUB

FUNCTION ExitAction () AS SHORT

  DIM style AS SHORT, clr AS SHORT, scrnRow AS SHORT, action AS SHORT, choice AS SHORT

  VAR modified = 0

  IF modified THEN

    REDIM menuS(0) AS STRING
    REDIM textS(7) AS STRING
    REDIM responseS(0) AS STRING
    textS(1) = "< Yes >"
    textS(2) = "< No >"
    textS(3) = "< Cancel >"
    textS(4) = "< Help >"
    textS(5) = " "
    textS(6) = "Loaded file is not saved. Save it now?"
    textS(7) = " "
    scrnRow = -1: choice = 1: clr = 112: style = 11

    LOCATE 10                   'Top of Dialog box is at line 5
    Dialog choice, textS(), responseS(), menuS(), scrnRow, style, clr, action

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
  VbMsgBox "Not implemented.", 0, ""
END SUB
            
SUB CopyAction
  VbMsgBox "Not implemented.", 0, ""
END SUB

SUB PasteAction
  VbMsgBox "Not implemented.", 0, ""
END SUB
       
SUB ClearAction
  VbMsgBox "Not implemented.", 0, ""
END SUB

SUB FindAction

  DIM style AS SHORT, clr AS SHORT, scrnRow AS SHORT, action AS SHORT, choice AS SHORT

  REDIM menuS(0) AS STRING
  REDIM textS(9) AS STRING
  REDIM responseS(9) AS STRING
  textS(0) = " Find "
  textS(1) = "< OK >"
  textS(2) = "< Cancel >"
  textS(3) = "< Help >"
  textS(4) = "{51} Find What:"
  textS(5) = " "
  textS(6) = " "
  textS(7) = "[ ] Match Upper/Lowercase"
  textS(8) = "[ ] Whole Word"
  textS(9) = " "
  responseS(7) = ""
  responseS(8) = ""
  scrnRow = 0
  clr = 112
  style = 11
  choice = 1

  Dialog choice, textS(), responseS(), menuS(), scrnRow, style, clr, action

END SUB

SUB RepeatLastFindAction
  VbMsgBox "Not implemented.", 0, ""
END SUB

SUB ChangeAction

  DIM style AS SHORT, clr AS SHORT, scrnRow AS SHORT, action AS SHORT, choice AS SHORT

  REDIM menuS(0) AS STRING
  REDIM textS(10) AS STRING
  REDIM responseS(10) AS STRING
  textS(0) = " Change "
  textS(1) = "< Find And Verify >"
  textS(2) = "< Change All >"
  textS(3) = "< Cancel >"
  textS(4) = "< Help >"
  textS(5) = "{51} Find What:"
  textS(6) = "{51} Change To:"
  textS(7) = " "
  textS(8) = "[ ] Match Upper/Lowercase"
  textS(9) = "[ ] Whole Word"
  textS(10) = " "
  responseS(8) = ""
  responseS(9) = ""
  scrnRow = 0
  clr = 112
  style = 11
  choice = 1

  Dialog choice, textS(), responseS(), menuS(), scrnRow, style, clr, action

END SUB

SUB DisplayAction
  VbMsgBox "Not implemented.", 0, ""
END SUB
            
SUB HelpPathsAction

  DIM style AS SHORT, clr AS SHORT, scrnRow AS SHORT, action AS SHORT, choice AS SHORT

  REDIM menuS(0) AS STRING
  REDIM textS(5) AS STRING
  REDIM responseS(5) AS STRING
  textS(0) = " Help Path "
  textS(1) = "< OK >"
  textS(2) = "< Cancel >"
  textS(3) = "< Help >"
  textS(4) = " "
  textS(5) = "{51} Location (path) of EDIT.HLP file:"
  scrnRow = 0
  clr = 112
  style = 11
  choice = 1

  Dialog choice, textS(), responseS(), menuS(), scrnRow, style, clr, action

END SUB

SUB HelpGettingStartedAction
  VbMsgBox "Not implemented.", 0, ""
END SUB

SUB HelpKeyboardAction
  VbMsgBox "Not implemented.", 0, ""
END SUB

SUB HelpAboutAction

  DIM style AS SHORT, clr AS SHORT, scrnRow AS SHORT, action AS SHORT, choice AS SHORT

  REDIM menuS(0) AS STRING
  REDIM textS(6) AS STRING
  REDIM responseS(0) AS STRING
  textS(1) = "< OK >"
  textS(2) = " "
  textS(3) = "MS-DOS Editor"
  textS(4) = "Version 1.0"
  textS(5) = "Copyright (C) Microsoft Corporation, 1987-1991."
  textS(6) = " "
  scrnRow = -1: choice = 1: clr = 112: style = 11

  LOCATE 9
  Dialog choice, textS(), responseS(), menuS(), scrnRow, style, clr, action

END SUB

SUB WelcomeAction

  DIM kyS AS STRING

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
    kyS = INKEY$
    IF kyS = CHR$(27) THEN EXIT DO
  LOOP
  ClearScr0 7, 14, 17, 66, OneColor(0, 1)

END SUB