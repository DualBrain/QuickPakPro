' ********** DemoPull.Bas - pull down menu demonstration program

' Copyright (c) 1987 Donald R. Malin
' Copyright (c) 1987 Crescent Software
' Modifications (c) 2022 Cory Smith

DEFINT A-Z

DECLARE SUB BarPrint (choice$(), barColor)
DECLARE FUNCTION Monitor% ()
DECLARE SUB PullDown (choice$(), stat(), menu, choice, ky$, action, cnf AS ANY)
DECLARE SUB QPrint0 (x$, colr)
DECLARE SUB ShowCursor ()
DECLARE SUB HideCursor ()

' The first $Include file contains a structure definition for menu and
' screen colors.  The second $Include determines the type of monitor you
' are using and assigns appropriate colors.

'$NOCLUDE: 'DefCnf.BI'
'$INCLUDE: 'SetCnf.BI'

CLS

QPrint0 STRING$(24 * 80, CHR$(250)), 23       ' make a background for the demo
QPrintRC STRING$(80, CHR$(250)), 25, 1, 23

'----- Define the Menu Choices here

REDIM stat(16, 8)                       ' define the choice status array
stat(12, 1) = 1                         ' this is how you'd deactivate an item
					                              ' in this case, item 12 in menu 1

REDIM choice$(16, 8)                    ' Allocate space for the Menu Choices
FOR c = 0 TO 16                         ' read the Menu Choices into the Array
  FOR m = 1 TO 8
  	READ choice$(c, m)              		' read the list of choices
  NEXT
NEXT

DATA "File",            "Edit",                 "View",               "Search",                   "Run",                "Debug",                   "Calls",        "F1=Help"
DATA "New Program",     "Undo   Alt+Backspace", "SUBS...         F2", "Find...",                  "Start     Shift+F5", "Add Watch...",            "DEMOPULL.BAS", ""
DATA "Open Program...", "Cut        Shift+Del", "Next SUB  Shift+F2", "Selected Text     Ctrl+\", "Restart",            "Watchpoint...",           "",             ""
DATA "Merge...",        "Copy        Ctrl+Ins", "Split",              "Repeat Last Find      F3", "Continue        F5", "Delete Watch...",         "",             ""
DATA "Save",            "Paste      Shift+Ins", "-",                  "Change...",                "Modify COMMAND$...", "Delete All Watch",        "",             ""
DATA "Save As...",      "-",                    "Next Statement",     "Label",                    "-",                  "-",                       "",             ""
DATA "Save All",        "New SUB...",           "Output Screen   F4", "",                         "Make EXE File...",   "Trace On",                "",             ""
DATA "-",               "New FUNCTION...",      "-",                  "",                         "Make Library...",    "History On",              "",             ""
DATA "Create File...",  "-",                    "Include File",       "",                         "",                   "-",                       "",             ""
DATA "Load File...",    "{chk} Syntax Checking","Included Lines",     "",                         "",                   "Toggle Breakpoint    F9", "",             ""
DATA "Unload File...",  "",                     "-",                  "",                         "",                   "Clear All BreakPoints",   "",             ""
DATA "-",               "",                     "Options...",         "",                         "",                   "Set Next Statement",      "",             ""
DATA "Print",           "",                     "",                   "",                         "",                   "",                        "",             ""
DATA "-",               "",                     "",                   "",                         "",                   "",                        "",             ""
DATA "DOS Shell",       "",                     "",                   "",                         "",                   "",                        "",             ""
DATA "-",               "",                     "",                   "",                         "",                   "",                        "",             ""
DATA "Exit",            "",                     "",                   "",                         "",                   "",                        "",             ""

' The following line is to work around special characters now being unicode.
choice$(9, 2) = CHR$(251) + " Syntax Checking"

choice$(0, 0) = CHR$(240)       ' This is the old Microsoft Help Icon.  There are no
																' choices for this selection.  This is to illustrate
																' that you may include a choice that has no menu,
																' when there are no further options.

action = 0                ' Action 0 is the easiest way to use PullDown
menu = 1                  ' start PullDown by displaying Menu 1
choice = 1                ' start with Choice #1 highlighted

ShowCursor
CALL PullDown(choice$(), stat(), menu, choice, ky$, action, cnf)
HideCursor

LOCATE 24, 1
PRINT "Selection"; choice; "was made from Menu"; menu;
IF ky$ = CHR$(27) THEN PRINT "- Escape was pressed";

'$INCLUDE: 'PULLDOWN.BAS'
'$INCLUDE: 'QPPRO.BAS'