' ********** PULLDOWN.BAS - Pulldown menu subprogram with mouse support

' Copyright (c) 1988 Don Malin & Crescent Software
' Modifications (c) 2022 Cory Smith

DEFINT A-Z

DECLARE SUB BarPrint (choice$(), barColor)
DECLARE SUB ButtonPress (button, status, count, x, y)
DECLARE SUB GetCursor (x, y, button)
DECLARE SUB GetVMode (mode, page, pageSize, rows, columns)
DECLARE SUB HideCursor ()
'DECLARE SUB Mouse (a, b, c, d)
DECLARE SUB MouseTrap (ulRow, ulCol, lrRow, lrCol)
DECLARE SUB MQPrint (x$, colr)
DECLARE SUB MPaintBox (ulRow, ulCol, lrRow, lrCol, colr)
DECLARE SUB MScrnSave (ulRow, ulCol, lrRow, lrCol, SEG address)
DECLARE SUB MScrnRest (ulRow, ulCol, lrRow, lrCol, SEG address)
DECLARE SUB QPrintAny (x$, clr, monCode, row, col)
DECLARE SUB ShowCursor ()

DECLARE FUNCTION ASCII% (text$)
DECLARE FUNCTION AltKey% ()
DECLARE FUNCTION DOSVer% ()
DECLARE FUNCTION QPLen% (text$)

'$INCLUDE: 'DefCnf.Bi'

CONST BAR_LINE = 1               'Line number for the menu bar

                                'Alt Key translation table
CONST ALT_CHARS$ = "1234567890     QWERTYUIOP    ASDFGHJKL     ZXCVBNM"

' ******************** Display the Menu Bar *****************************
' Note: This is separate so the Main Program can display the Menu Bar
'       before it makes any calls to the PullMen Sub Program.
' ***********************************************************************
SUB BarPrint (choice$(), barClr) STATIC

  row = CSRLIN                        ' Save the Current Cursor Position
  col = POS(0)
  menuBar$ = SPACE$(80)               ' Allocate Menu Bar String
  length = 2
  FOR c = 0 TO UBOUND(choice$, 2)     ' Compose the Menu Bar
    MID$(menuBar$, length) = choice$(0, C)
    length = length + QPLen(choice$(0, C)) + 2
  NEXT
  LOCATE BAR_LINE, 1
  CALL MQPrint(menuBar$, barClr)      ' Print Menu Bar
  LOCATE row, col                     ' Relocate the Cursor

  menuBar$ = ""

END SUB

' ****************************************************************************
'     File Name: PULLDOWN.BAS
'   Description: Pull Down Menu Sub Program
'            by: Don Malin, (c) Crescent Software 1988
' modifications: Cory Smith, (c) 2022
'
' Parameters:
'
'   Choice$() -
'     The "Choice$" Array holds the Menu Choices.
'     Choice$(0, Menus) hold the Bar Titles.
'     Choice$(Choices, Menu) hold the Window Choices.
'     A "-" value for a choice indicates a dividing line across the menu.
'
'   Stat() -
'     This is an integer array parallel to the Choice$ array.
'     Any value in an element indicates that the choice is inactive
'     (Non-Selectable).
'
'   Menu -
'     Current Menu Number.  A non-zero value on entry will cause that menu
'     to be displayed.
'
'   Choice -
'     Current Menu Choice.  A non-zero value on entry will cause that
'     choice to be displayed.
'
'   Ky$ -
'     This string will contain the character or key code that was used to
'     exit the routine.
'
'   Action -
'     Action is a flag which can be used to control the routine in a
'     multi tasking (polled) mode.  The Action commands are as follows:
'
'       0 - PullDown will take control until an active choice is selected
'           or the [Esc] key is pressed.  (Single Tasking Mode)
'       1 - Used on initial entry for multi-tasking mode.  Only saves the
'           background screen, displays the Menu bar and the current menu.
'           Sets the Action variable to 3 for successive calls.
'       2 - Redisplay the current menu.  Reset Action to 3
'       3 - On entry means just check the keyboard and handle keys used by
'           the routine and exit back to the caller.  On exit means nothing
'           was selected.
'       4 - User made a selection from an active choice or pressed the
'           Escape key so you should check the Menu and Choice variables.
'       5 - Restore the screen, erase the screen buffer used by the routine.
'
' Note: Requires a structure named - "Cnf" defined as "Config".  The
'       structure definition is in the $INCLUDE file "DEFCNF.BAS".
'
' External Routines: MScrnSave, MScrnRest, BarPrint, MPaintBox, MQPrint,
'                    GetCursor
'
' ****************************************************************************
'
SUB PullDown (choice$(), stat(), menu, choice, ky$, action, cnf AS Config) STATIC

    LOCATE , , 0

    IF action = 4 THEN action = 1       ' See if they forgot to reinit Action
    IF action < 3 THEN                  ' Redisplaying?
       IF action < 2 THEN               ' Redisplaying whole menu?

          lastMenu = UBOUND(choice$, 2) ' Find Last Bar Menu Choice
                                        ' Find screen rows to save
          botRow = UBOUND(choice$, 1) + BAR_LINE + 2
          lastChoice = 0
          size = 80 * (botRow - BAR_LINE + 1) ' Find memory to allocate

          REDIM scrBuf(size)            'Alocate screen memory
          REDIM barLin(80)
                                        'Save the Bar Line
          MScrnSave BAR_LINE, 1, BAR_LINE, 80, barLin()
                                        'Display the Menu Bar on top line
          CALL BarPrint(choice$(), cnf.PulBar)  'Print the Bar Choices

          GetVMode 0, 0, 0, scRows, 0
          MouseTrap 1, 1, scRows, 80
          nPixLines = 8
          IF scRows > 43 AND DOSVer% = 1000 THEN nPixLines = 7
          wdth = 0
       END IF

       hiBar = cnf.PulBar \ 16 + 8 + 16 * cnf.PulBar MOD 16

       GOSUB PullDisplay                'Display the Menu box
       
       IF action THEN action = 3        'Reset the Action flag to idle state

       prevChoice = choice
       prevMenu = menu

       GOSUB PullHilite

    END IF

    IF choice <> prevChoice THEN GOSUB PullHilite

    IF menu <> prevMenu THEN GOSUB PullDisplay
    
    ' If Action flag=5, Restore the screen
    IF action = 5 AND UBOUND(scrBuf) > 1 THEN
       MScrnRest BAR_LINE, 1, BAR_LINE, 80, barLin()
       IF wdth THEN
          MScrnRest BAR_LINE + 1, startCol, lastChoice + BAR_LINE + 3, enBar + 3, scrBuf()
       END IF
       ERASE scrBuf, barLin             'Clean up memory
       EXIT SUB                         'Bail out
    END IF

    DO
                                        'If we have a Window, Hilight Choice
       altDown = AltKey                 'Get typed characters
       IF altDown THEN wasDown = -1

       ky$ = INKEY$
       IF altDown = 0 AND wasDown AND altPressed THEN
          ky$ = CHR$(13)
          wasDown = 0
          altPressed = 0
       END IF

       'MMMMMMMMMMMMMMMM Start of Mouse Handling Code MMMMMMMMMMMMMMMMMMM
       'MM   If you hate rodents, exterminate the code from here to    MM
       'MM   the next set of "MMM" comments.                           MM
       'MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
       IF cnf.Mouse THEN
          ButtonPress 1, down, presses, x, y
          IF presses = 0 THEN GetCursor x, y, button
          mRow = (y \ nPixLines) + 1
          mCol = (x \ 8) + 1
          IF (mRow <> lMRow OR mCol <> lMCol OR presses) AND down = 1 THEN
             
             IF mRow - BAR_LINE - 1 <= lastChoice AND mRow - BAR_LINE - 1 > 0 AND mCol > startCol AND mCol < enBar THEN
                choice = mRow - BAR_LINE - 1
                IF Choice$(choice, menu) = "-" OR Stat(choice, menu) <> 0 THEN
                   choice = prevChoice
                ELSE
                   wasPressed = -1
                END IF
             ELSEIF mRow = BAR_LINE THEN
                tstCol = 1
                lstMen = UBOUND(choice$, 2)
                FOR n = 0 TO lstMen
                    IF mCol >= tstCol AND mCol <= tstCol + QPLen(choice$(0, n)) + 1 THEN EXIT FOR
                    tstCol = tstCol + QPLen(choice$(0, n)) + 2
                NEXT
                IF n <= lstMen THEN menu = n
                choice = 0
                IF menu <> prevMenu THEN
                   GOSUB PullDisplay
                   choice = 0
                   prevChoice = 0
                END IF
                wasPressed = -1
             ELSE
                choice = 0
                wasPressed = -1
             END IF
             GOSUB PullHilite
          ELSEIF button AND 2 THEN
             ky$ = CHR$(27)
             DO
                GetCursor x, y, button
             LOOP WHILE button AND 2
          END IF

          IF down = 0 AND wasPressed THEN
             wasPressed = 0
             IF mRow - BAR_LINE - 1 <= lastChoice AND mRow - BAR_LINE - 1 > 0 AND mCol > startCol AND mCol < enBar THEN
                IF choice THEN ky$ = CHR$(13)
             ELSEIF mRow = BAR_LINE THEN
                IF wdth = 0 OR active = 0 THEN
                   ky$ = CHR$(13)
                ELSE
                   choice = 1
                   DO WHILE choice$(choice, menu) = "-" OR stat(choice, menu)
                      choice = choice + 1
                   LOOP
                   GOSUB PullHilite
                END IF
             ELSE
                ky$ = CHR$(27)
             END IF
          END IF
          
          lMRow = mRow
          lMCol = mCol
       END IF
       'MMMMMMMMMMMMMMMMMMM End of mouse handling code MMMMMMMMMMMMMMMMMMMMMM

       IF altDown AND QPLen(ky$) = 2 THEN
          temp = ASCII(RIGHT$(ky$, 1))
          IF temp >= 120 THEN temp = temp - 119
          ky$ = MID$(ALT_CHARS$, temp, 1)
       END IF

       IF QPLen(ky$) = 1 THEN             'Non extended Keys
          
          IF ky$ = CHR$(13) OR ky$ = CHR$(27) THEN
             IF action = 0 THEN
                MScrnRest BAR_LINE, 1, BAR_LINE, 80, barLin()
                IF wdth THEN
                   MScrnRest BAR_LINE + 1, startCol, lastChoice + BAR_LINE + 3, enBar + 3, scrBuf()
                END IF
                ERASE scrBuf, barLin    'Clean up memory
             END IF
             IF action THEN action = 4
             EXIT SUB

          ELSEIF wdth AND active AND ky$ <> "-" THEN
             ky$ = UCASE$(k$)          'Make Key Uppercase
             pass = 0                   'See if User pressed a Choice Letter
             oldChoice = choice         'Save Current Choice setting
             
             DO                         'Check remaining choices
                IF choice < lastChoice THEN
                   choice = choice + 1
                ELSE
                   choice = 1
                END IF
               
                WHILE (stat(choice, menu) OR ky$ <> LEFT$(choice$(choice, menu), 1)) AND choice < lastChoice
                    choice = choice + 1
                WEND
                                        'If we reached the end without finding
                IF choice >= lastChoice AND (ky$ <> LEFT$(choice$(choice, menu), 1) OR stat(choice, menu)) THEN
                   IF pass = 0 THEN
                      pass = 1
                   ELSE
                      choice = oldChoice
                      EXIT DO
                   END IF
                ELSE
                   IF altDown THEN altPressed = -1
                   EXIT DO
                END IF
             LOOP
             GOSUB PullHilite
          END IF

       ELSEIF QPLen(ky$) THEN           'Handle Extended Key Codes
                                        
          SELECT CASE ASCII(RIGHT$(ky$, 1))
             CASE 72                    'Check for Up Arrow Key
                IF wdth AND active THEN
                   DO
                      choice = choice - 1
                      IF choice < 1 THEN choice = lastChoice
                   LOOP WHILE choice$(choice, menu) = "-" OR stat(choice, menu)
                END IF

             CASE 80                    'Check for Down Arrow Key
                IF wdth AND active THEN
                   DO
                      choice = choice + 1
                      IF choice > lastChoice THEN choice = 1
                   LOOP WHILE choice$(choice, menu) = "-" OR stat(choice, menu)
                END IF

             CASE 71                    'Check for Home Key
                IF wdth AND active THEN
                   choice = 1
                   DO WHILE choice$(choice, menu) = "-" OR stat(choice, menu)
                      choice = choice + 1
                   LOOP
                END IF

             CASE 79                    'Check for End Key
                IF wdth AND active THEN
                   choice = lastChoice
                   DO WHILE choice$(choice, menu) = "-" OR stat(choice, menu)
                      choice = choice - 1
                   LOOP
                END IF

             CASE 75                    'Check for Left Arrow Key
                IF menu = 0 THEN        'If on Far Left Bar Choice, go to
                   menu = lastMenu      '  Far Right Choice
                ELSE
                   menu = menu - 1      'Otherwise Decrement Bar Choice
                END IF
                choice = 0
                prevChoice = 0
                GOSUB PullDisplay       'Display the New Choice Window

             CASE 77                    'Check for Right Arrow Key
                IF menu = lastMenu THEN 'If on Far Right Bar Choice, go to
                   menu = 0             '  Far Left Choice
                ELSE
                   menu = menu + 1    'Otherwise Increment Bar Choice
                END IF
                choice = 0
                prevChoice = 0
                GOSUB PullDisplay       'Display the New Choice Window

             CASE ELSE
          END SELECT

          GOSUB PullHilite

       END IF

       prevChoice = choice
       prevMenu = menu

    LOOP WHILE action = 0
    
    EXIT SUB

PullHilite:
  IF wdth AND active THEN
    IF prevChoice > 0 THEN CALL MPaintBox(prevChoice + BAR_LINE + 1, startCol + 1, prevChoice + BAR_LINE + 1, enBar, cnf.ActivCh)
    IF choice > 0 THEN CALL MPaintBox(choice + BAR_LINE + 1, startCol + 1, choice + BAR_LINE + 1, enBar, cnf.HiLite)
  END IF
  LOCATE choice + BAR_LINE + 1, startCol + 1
  RETURN

PullDisplay:                                 'Restore the screen
  IF menu <> prevMenu OR action < 2 THEN
    IF wdth THEN
      MScrnRest BAR_LINE + 1, startCol, lastChoice + BAR_LINE + 3, enBar + 3, scrBuf()
    END IF
                                        'Re-paint the Menu bar
    IF startCol THEN CALL MPaintBox(BAR_LINE, startCol, BAR_LINE, enCol, cnf.PulBar)
  END IF
  prevMenu = menu                     'Save the menu nunber
  
  startCol = 1                        'Find the column positions to start
  FOR c = 0 TO menu - 1               '  and end the hilight on Bar Menu
    startCol = startCol + QPLen(choice$(0, c)) + 2
  NEXT
  enCol = startCol + QPLen(choice$(0, menu)) + 1
                                        'Hilight the Bar Menu Choice
  CALL MPaintBox(BAR_LINE, startCol, BAR_LINE, enCol, hiBar)

  wdth = 0                            'Find the Width and # of Choices of
  arrayEnd = UBOUND(choice$, 1)       '  the new menu
  active = 0

  IF choice AND (stat(choice, menu) OR choice$(choice, menu) = "-") THEN choice = 0
  FOR c = 1 TO arrayEnd
    chLen = QPLen(choice$(c, menu))
    IF chLen = 0 THEN EXIT FOR
    IF chLen > wdth THEN wdth = chLen
    IF stat(c, menu) = 0 AND choice$(c, menu) <> "-" THEN
      active = -1
      IF choice = 0 THEN
        choice = c
        prevChoice = c
      END IF
    END IF
  NEXT
  lastChoice = c - 1

  IF startCol + wdth + 3 >= 80 THEN   'If the Right Side of the window is
    startCol = 80 - wdth - 3         '  off the screen, adjust the Left
  END IF                              '  Side of the window

  enBar = startCol + wdth + 2         'Set the Right Side of the Window

  IF wdth THEN                        'If there are window choices, print them
    IF action <> 2 THEN
      MScrnSave BAR_LINE + 1, startCol, lastChoice + BAR_LINE + 3, enBar + 3, scrBuf()
    END IF
    HideCursor

    'QPrintAny CHR$(213) + STRING$(wdth + 2, CHR$(205)) + CHR$(184), cnf.MenBox, -cnf.MonTyp, BAR_LINE + 1, startCol
    QPrintAny CHR$(218) + STRING$(wdth + 2, CHR$(196)) + CHR$(191), cnf.MenBox, -cnf.MonTyp, BAR_LINE + 1, startCol

    temp$ = SPACE$(wdth)
    FOR c = 1 TO lastChoice
      IF choice$(C, Menu) = "-" THEN
        QPrintAny CHR$(195) + STRING$(wdth + 2, CHR$(196)) + CHR$(180), cnf.MenBox, -cnf.MonTyp, C + BAR_LINE + 1, startCol
      ELSE
        QPrintAny CHR$(179) + " ", cnf.MenBox, -cnf.MonTyp, c + BAR_LINE + 1, startCol
        QPrintAny " " + CHR$(179), cnf.MenBox, -cnf.MonTyp, c + BAR_LINE + 1, startCol + wdth + 2
        LSET temp$ = choice$(c, menu)
        IF stat(c, menu) THEN
          temp = cnf.InActCh
        ELSE
          temp = cnf.ActivCh
        END IF
        QPrintAny temp$, temp, -cnf.MonTyp, c + BAR_LINE + 1, startCol + 2
      END IF
    NEXT

    QPrintAny CHR$(192) + STRING$(wdth + 2, CHR$(196)) + CHR$(217), cnf.MenBox, -cnf.MonTyp, c + BAR_LINE + 1, startCol
    ShowCursor

    IF enBar + 2 < 80 THEN
      CALL MPaintBox(BAR_LINE + 2, enBar + 2, c + BAR_LINE + 2, enBar + 3, 8)
    END IF

    CALL MPaintBox(c + BAR_LINE + 2, startCol + 2, c + BAR_LINE + 2, enBar + 1, 8)
  
  END IF
  RETURN

END SUB

SUB PullMenKey (ky$, choice$(), menu, init) STATIC

  IF init THEN
    lstMen = UBOUND(choice$, 2)
    hotKeys$ = STRING$(lstMen + 1, 0)
    FOR n = 0 TO lstMen
      fstChr$ = UCASE$(LEFT$(LTRIM$(choice$(0, n)), 1))
      IF QPLen(fstChr$) THEN
        hotKey = INSTR(ALT_CHARS$, fstChr$)
        IF hotKey <= 15 THEN
          hotKey = 119 + hotKey
          IF hotKey = 119 THEN hotKey = 0
        END IF
        MID$(hotKeys$, n + 1) = CHR$(hotKey)
      END IF
    NEXT
    init = 0
  END IF

  IF QPLen(ky$) = 2 THEN
    menu = INSTR(hotKeys$, RIGHT$(ky$, 1)) - 1
  ELSE
    menu = -1
  END IF

  GetCursor x, y, button
  IF button THEN
    mRow = (y \ 8) + 1
    IF mRow = BAR_LINE THEN
      mCol = (x \ 8) + 1
      lCol = 1
      FOR n = 0 TO lstMen
        IF mCol >= lCol AND mCol <= lCol + QPLen(choice$(0, n)) + 1 THEN EXIT FOR
        lCol = lCol + QPLen(choice$(0, n)) + 2
      NEXT
      IF n <= lstMen THEN menu = n
    END IF
  END IF

END SUB