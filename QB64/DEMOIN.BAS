' ********** DEMOIN.BAS - shows all of the input routines in context

' Copyright (c) 1988 Ethan Winer
' Modified (c) 2022 Cory Smith

DEFINT A-Z  ' use integers throughout - faster and requires less variable space

'$INCLUDE: 'PRO.BI'

'_FULLSCREEN _SQUAREPIXELS

'BASIC subprograms demonstrated
DECLARE SUB CapNum ()
DECLARE SUB DateIn (dt$, exitCode, colr)
DECLARE SUB NumIn (n#, max, places, exitCode, colr)
DECLARE SUB TextIn (t$, max, numOnly, isCapsOn, exitCode, colr)
DECLARE SUB YesNoB (yn$, exitCode, colr)

DECLARE SUB ClearEOL (colr)
DECLARE FUNCTION FUsing$ (number$, mask$)
DECLARE FUNCTION OneColor% (fg, bg)
DECLARE FUNCTION Peek1% (segment, address)
DECLARE SUB QPrint (txt$, colr, page)

' determine if the monitor is mono or color
'
IF Peek1%(0, &H463) = &HB4 THEN      ' mono monitor
  fg = 0
  bg = 7
ELSE                                 ' color
  fg = 7
  bg = 1
END IF

colr = OneColor%(fg, bg)             ' pack FG and BG into a single byte

GOSUB InitializeTest                 ' set up a few of the fields
GOSUB DisplayScreen                  ' display the entry screen

GetName:
  LOCATE 5, 6                          ' location of beginning of field
  isCapsOn = 0: numOnly = 0: max = 32  ' specify field parameters
  CALL TextIn(nam$, max, numOnly, isCapsOn, xCode, colr) ' get input
  IF xCode = 1 GOTO GetName            ' can't back up any more, stay here
  IF xCode = 2 GOTO Done               ' all done entering data
       
GetAddress:
   LOCATE 7, 6
   CALL TextIn(address$, max, numOnly, isCapsOn, xCode, colr)
   IF xCode = 1 GOTO GetName           ' go back to the name field
   IF xCode = 2 GOTO Done
          
GetCity:
   LOCATE 9, 6
   max = 20                             ' use a length of twenty here
   CALL TextIn(city$, max, numOnly, isCapsOn, xCode, colr)
   IF xCode = 1 GOTO GetAddress
   IF xCode = 2 GOTO Done

GetState:
   LOCATE 9, 36
   isCapsOn = 1: numOnly = 0: max = 2     ' force caps, use length of two for zip
   CALL TextIn(state$, max, numOnly, isCapsOn, xCode, colr)
   IF LEN(state$) THEN
      IF LEN(state$) <> 2 THEN            ' state must be 2 letters or nothing
         PLAY "L16O3EC"
         GOTO GetState
      END IF
   END IF
   isCapsOn = 0                           ' reset this for the other fields
   IF xCode = 1 GOTO GetCity
   IF xCode = 2 GOTO Done
        
GetZip:
   LOCATE 9, 44
   isCapsOn = 0: numOnly = 1: max = 5   ' numeric only, please
   CALL TextIn(zip$, max, numOnly, isCapsOn, xCode, colr)
   IF LEN(zip$) THEN
      IF LEN(zip$) < 5 THEN             ' zip MUST be five digits or nothing
         PLAY "L16O3EC"
         GOTO GetZip
      END IF
   END IF
   IF xCode = 1 GOTO GetState
   IF xCode = 2 GOTO Done

GetPhone:
   LOCATE 11, 7
   numOnly = 0: max = 14
   CALL TextIn(phone$, max, numOnly, isCapsOn, xCode, colr)
   IF xCode = 1 GOTO GetZip
   IF xCode = 2 GOTO Done

GetSS:
   LOCATE 13, 6
   numOnly = 1: max = 9
   CALL TextIn(ss$, max, numOnly, isCapsOn, xCode, colr)
   IF xCode = 1 GOTO GetPhone
   IF xCode = 2 GOTO Done

GetBalDue:
   LOCATE 13, 52
   max = 8: places = 2
   CALL NumIn(balDue#, max, places, xCode, colr)
   IF xCode = 1 GOTO GetSS
   IF xCode = 2 GOTO Done
         
GetDtPaid:
   LOCATE 15, 54
   CALL DateIn(dtPaid$, xCode, colr)
   IF xCode = 1 GOTO GetBalDue
   IF xCode = 2 GOTO Done
  
GetMemo:
   LOCATE 19, 6
   isCapsOn = 0: numOnly = 0: max = 74
   CALL TextIn(memo$, max, numOnly, isCapsOn, xCode, colr)
   IF xCode = 1 GOTO GetDtPaid

Done:
   LOCATE 23, 1
   PRINT "Is this okay? (Yes/No) ";

   x$ = ""
   CALL YesNoB(x$, xCode, colr)
   LOCATE , 1
   ClearEOL 7
   IF xCode = 1 GOTO GetMemo
   IF x$ = "N" GOTO GetName
   IF x$ <> "Y" GOTO Done               ' insist on either Y or N or up-arrow

   LOCATE , 1
   PRINT "Thank You"
   END

InitializeTest:                         ' initialize some of the screen data
  nam$ = "Ralph Montenegro"
  address$ = "14 Vander Avenue"
  city$ = "North Hollywood"
  state$ = "CA"
  RETURN

DisplayScreen:                          ' display screen w/any existing values
  CLS
  PRINT TAB(26);
  QPrint "QuickPak Input Routine Demo", 15, -1
  PRINT
  QPrint STRING$(80, CHR$(205)), 15, -1
  LOCATE 5, 1:  QPrint "Name", 15, -1
  LOCATE , 6:   QPrint FnExt$(nam$, 32), colr, -1
  LOCATE 7, 1:  QPrint "Addr ", 15, -1
  LOCATE , 6:   QPrint FnExt$(address$, 32), Colr, -1
  LOCATE 9, 1:  QPrint "City ", 15, -1
  LOCATE , 6:   QPrint FnExt$(city$, 20), colr, -1
  LOCATE 9, 30: QPrint "State ", 15, -1
  LOCATE , 36:  QPrint FnExt$(state$, 2), colr, -1
  LOCATE 9, 40: QPrint "Zip ", 15, -1
  LOCATE , 44:  QPrint FnExt$(zip$, 5), colr, -1
  LOCATE 11, 1: QPrint "Phone ", 15, -1
  LOCATE , 7:   QPrint FnExt$(phone$, 14), colr, -1
  LOCATE 13, 1: QPrint "SS # ", 15, -1
  LOCATE , 6:   QPrint FnExt$(ss$, 9), colr, -1
  LOCATE 13, 44:QPrint "Amt Due ", 15, -1
  LOCATE , 52:  QPrint FUsing$(STR$(amtDue#), "########.##"), colr, -1
  LOCATE 15, 44:QPrint "Date Paid ", 15, -1
  LOCATE , 54:  QPrint FnSlash$(dtPaid$), colr, -1
  LOCATE 19, 1: QPrint "Memo ", 15, -1
  LOCATE , 6:   QPrint FnExt$(memo$, 74), colr, -1
  RETURN

FUNCTION FnExt$ (x$, length%) ' for display only
  FnExt$ = x$ + SPACE$(length% - LEN(x$))
END FUNCTION

FUNCTION FnSlash$ (d$) ' add slashes to date for display
  IF d$ = "" THEN d$ = SPACE$(6)
  d$ = LEFT$(d$, 2) + "/" + MID$(d$, 3, 2) + "/" + RIGHT$(d$, 2)
  FnSlash$ = d$
END FUNCTION

'$INCLUDE: 'NUMIN.BAS'
'$INCLUDE: 'TEXTIN.BAS'
'$INCLUDE: 'DATEIN.BAS'
'$INCLUDE: 'CAPNUM.BAS'
'$INCLUDE: 'YESNOB.BAS'
'$INCLUDE: 'PRO.BAS'