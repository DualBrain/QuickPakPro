'******* DEMODIA2.BAS - demonstrates file selection with DIALOG.BAS         6/91

' Copyright (c) 1991 Crescent Software
' Written by Phil Cramer
' Modifications (c) 2022 Cory Smith

DEFINT A-Z

'$INCLUDE: 'QPPRO.BI'

_FULLSCREEN _SQUAREPIXELS

DECLARE SUB Dialog (Choice, Text$(), Response$(), Menu$(), ScrnRow, Style, Clr, Action)

'****************************** IMPORTANT! **********************************
'
' This routine now uses the assembler routine KeyDown to make sure
' that the user has released a terminating key before the Dialog box
' clears itself.  Be sure to see DEMODIAP.BAS for important additional
' information if you are using the QBX editor that comes with BASIC 7.

'*****************************************************************************
'* You may enter a file specification with or without wildcards in this demo.*
'* If wildcards are used, the menu, path and file name will be updated to    *
'* reflect the new file specification. If no wild cards are used and no drive*
'* or path information is given, or a file is selected from the menu, the    *
'* filename will be added to the file spec shown below the "File name" field *
'* when Enter or OK is selected.                                             *
'*****************************************************************************

'---- .ASM Functions
DECLARE FUNCTION Exist% (FileName$)
DECLARE FUNCTION FCount% (FSpec$)
DECLARE FUNCTION GetDir$ (Drive$)
DECLARE FUNCTION GetDrive% ()
DECLARE FUNCTION GoodDrive% (Drive$)
DECLARE FUNCTION QPTrim$ (Work$)
DECLARE FUNCTION DOSError% ()

'---- .ASM Subs
DECLARE SUB DeinstallKeyDown ()
DECLARE SUB CDir (NewDir$)
DECLARE SUB InitMouse (There)
DECLARE SUB SetDrive (Drive$)

COLOR 1, 0
CLS

CALL InitMouse(there)                     ' Initialize the mouse driver
LOCATE 1, 1: PRINT STRING$(2000, 176);    ' Draw an attractive background
fileName$ = "*.*"                         ' Start with all files in default dir
drive$ = CHR$(GetDrive)                   ' Save the current drive
path$ = GetDir$(drive$)                   ' Save the current path

origDrv$ = drive$                         ' Save a copy so we can restore it later
origPath$ = path$                         ' Ditto

fPath$ = drive$ + ":" + path$             ' Build the file spec
count = FCount%(fileName$)                ' See how many files match the spec
IF count = 0 THEN count = 1               ' Make sure to dim at least 1 element
REDIM menu$(count)
FOR i = 1 TO count                        ' Set each element to 12 spaces long
  menu$(i) = SPACE$(12)
NEXT
menu$(0) = fileName$                      ' Place spec in element 0
CALL ReadFile(menu$())                    ' Load the Menu$() with files
CALL SortStr(menu$(), 1, count, 0)

REDIM text$(11)                           ' Set up the Dialog box
REDIM response$(11)
text$(0) = " Load File "                  ' Dialog box Title
text$(1) = "< OK >"                       ' Command button
text$(2) = "< Cancel >"                   ' Ditto
text$(3) = " "                            ' Blank line
text$(4) = "{30} File Name"               ' Text entry field, 30 characters long
text$(5) = "|208| Files"                  ' Menu field, 2 columns, 8 rows
text$(6) = SPACE$(30)                     ' Plain text field, 30 characters long
LSET text$(6) = fPath$                    ' Place the current path in Text$(6)
Text$(7) = " "                            ' Blank line
Text$(8) = " Load file as:            "   ' Left justify Plain text
Text$(9) = "( ) Module"                   ' Option button
Text$(10) = "( ) Include"                 ' Ditto
Text$(11) = "( ) Document"                ' Ditto

response$(4) = fileName$                  ' Place current file name Response$(4)
response$(9) = "*" 'CHR$(7)                    ' Must assign a "dot" to an option field

style = 1                                 ' Single line border
clr = 112                                 ' Black text, white background
action = 1                                ' Start Dialog in Polled Mode

DO
  CALL Dialog(choice, text$(), response$(), menu$(), scrnRow, style, clr, action)

  tSpec$ = QPTrim$(response$(4))          ' Trim off any blanks before we test
                                          ' If they have selected a new menu choice
  IF LEN(response$(5)) AND response$(5) <> lastMenu$ THEN
    LSET response$(4) = response$(5)      ' Place the Menu choice in the File name
    lastMenu$ = response$(5)              '   field and remember which one
    IF action <> 4 THEN action = 2        ' Re-display unless they want to exit
  END IF

  IF action = 4 AND choice <> -1 THEN     ' Enter or < OK >
                                          ' Look for wild cards in the spec
    IF INSTR(tSpec$, "?") OR INSTR(tSpec$, "*") OR LEFT$(tSpec$, 2) = ".." THEN

      driveThere = 0                      ' Reset flags
      pathInfo = 0
      pathFound = 0
      start = 1                           ' Default starting point for PathInfo

      IF tSpec$ = ".." THEN
        tPath$ = tSpec$                   ' Make the path$ ".."
        tileName$ = fileName$             ' Use the last filename
        pathInfo = -1                     ' Set flags
        pathFound = -1
      END IF

      ' ---- Look for drive info
      IF MID$(tSpec$, 2, 1) = ":" THEN    ' See if a drive is in the path
        driveThere = -1
        IF GoodDrive%(LEFT$(tSpec$, 1)) THEN ' If its a valid drive,
          tDrive$ = UCASE$(LEFT$(tSpec$, 1)) '   assign Drive$
          Start = 3                       ' Search for path starting at 3
        ELSE                              ' Bad drive, restore previous
          LSET text$(6) = drive$ + ":" + path$ ' path and file name
          LSET response$(4) = fileName$
          action = 2                      ' Action 2 forces re-display
          GOTO BadSpec                    ' Hopeless, bail out
        END IF
      END IF

      IF NOT driveThere THEN              ' If Spec$ does not include
        tDrive$ = drive$                  '   a drive, use last drive
      END IF

      ' ---- Look for path info
      IF NOT pathFound THEN
        IF INSTR(tSpec$, "\") THEN        ' Contains path information
          pathInfo = -1
          FOR i = LEN(tSpec$) TO 1 STEP -1 ' Find where it ends
            IF MID$(tSpec$, i, 1) = "\" THEN ' and determine path$
              tPath$ = UCASE$(MID$(tSpec$, start, i - start))
              IF tPath$ = "" THEN tPath$ = "\"
              tFileName$ = UCASE$(RIGHT$(tSpec$, LEN(tSpec$) - i))
              EXIT FOR
            END IF
          NEXT
        ELSE                              ' Must just be a file name
          tFileName$ = UCASE$(RIGHT$(tSpec$, LEN(tSpec$) - start + 1))
        END IF
      END IF
      IF NOT pathInfo THEN tPath$ = path$ ' If no path specified then
                                          '   use last path
      ' ---- See if they have made a selection from the menu
      IF response$(5) <> "" THEN          ' If a menu item is active
        LSET response$(4) = response$(5)  '   change the file spec
        tFileName$ = QPTrim$(response$(5))
        IF path$ = "\" THEN path$ = ""
        temp$ = drive$ + ":" + path$ + "\" + tFileName$
        response$(4) = temp$
        EXIT DO                           ' and bail out
      END IF

      CALL SetDrive(tDrive$)
      CALL CDir(tPath$)
      IF DOSError% THEN                   ' Must be a bad path
        LSET response$(4) = fileName$
        action = 2
        BEEP
        GOTO BadSpec
      ELSE
        IF Exist%(tFileName$) THEN
          drive$ = tDrive$
          path$ = GetDir$(drive$)         ' Save the current path
          fileName$ = tFileName$
          LSET response$(4) = fileName$
          LSET text$(6) = drive$ + ":" + path$
          count = FCount%(tFileName$)     ' Load the Menu$()
          IF count = 0 THEN count = 1     '   with files from
          REDIM menu$(count)              '   the new file spec
          FOR i = 1 TO count
            menu$(i) = SPACE$(12)
          NEXT
          menu$(0) = tFileName$
          CALL ReadFile(menu$())
          CALL SortStr(menu$(), 0, count, 0)
          IF count > 1 THEN CALL SortStr(menu$(), 1, count, 0)
          action = 2
        ELSE
          LSET response$(4) = fileName$
          action = 2
        END IF
      END IF
    ELSE

      ' ---- No wildcards, must be complete file spec
      IF INSTR(tSpec$, ":") = 0 THEN      ' if there is no drive info,
        tPath$ = drive$ + ":"             ' use the last drive
      END IF
      IF INSTR(tSpec$, "\") = 0 THEN      ' If there is no path info,
        IF path$ = "\" THEN path$ = ""
        tPath$ = tPath$ + path$ + "\"     ' use the last path
      END IF
      response$(4) = tPath$ + QPTrim$(response$(4)) ' Assign complete path
      EXIT DO                                       ' and bail out
    END IF
  END IF

  response$(5) = ""

BadSpec:
LOOP UNTIL choice = -1

action = 5                                ' Action 5 clears the Dialog box
CALL Dialog(choice, text$(), response$(), menu$(), scrnRow, style, clr, action)

COLOR 15
LOCATE 1, 1: PRINT "You picked: "; response$(4);

IF Exist%(QPTrim$(response$(4))) AND choice <> -1 THEN ' If it's a valid path
  ' Code to load the file goes here
  'SELECT CASE VAL(Response$(8))
  '  CASE 1                                ' Load as Module
  '  CASE 2                                ' Load as Include
  '  CASE 3                                ' Load as Document
  'END SELECT
ELSE                                      ' If the file spec is invalid
  REDIM text$(5)                          '   give them a message
  REDIM response$(0)
  REDIM menu$(0)
  text$(1) = "< OK >"
  text$(2) = "< Help >"
  text$(3) = " "
  text$(4) = "   File not found   "
  text$(5) = " "
  choice = 1
  action = 0
  CALL Dialog(choice, text$(), response$(), menu$(), scrnRow, style, clr, action)
END IF

'CALL DeinstallKeyDown                    ' Remove KeyDown routine
CALL SetDrive(origDrv$)                   ' Restore original drive
CALL CDir(origPath$)                      ' Restore original path

END                                       ' Fini

'$INCLUDE: 'DIALOG.BAS'
'$INCLUDE: 'QPPRO.BAS'