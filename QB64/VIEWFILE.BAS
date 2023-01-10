' ********** VIEWFILE.BAS - View (browse) the contents of a file.
' Copyright (c) 1988 Don Malin & Crescent Software
' Modified (c) 2023 Cory Smith

' 08-03-1990 Fixed search problem when file was smaller than the window.

DEFINT A-Z

'*** ASM routines used by ViewFile

DECLARE SUB APrint0 (BYVAL address, numEls, startChar, numChars, colr)
DECLARE SUB Box0 (ulRow%, ulCol%, lrRow%, lrCol%, char%, colr%)
DECLARE SUB ClearScr0 (ulRow, ulCol, lrRow, lrCol, colr)
DECLARE SUB Editor (ed$, aLen%, scanCode%, numOnly%, capsOn%, normClr%, editClr%, row%, column%)
DECLARE SUB FClose (handle)
DECLARE SUB FOpen (fileName$, handle)
DECLARE SUB FSeek (handle, offset&)
DECLARE SUB LowASCII (text$)
DECLARE SUB MQPrint (label$, clr)
DECLARE SUB RemCtrl (text$, replace$)
DECLARE SUB MPaintBox (ulRow%, ulCol%, lrRow%, lrCol%, colr%)
DECLARE SUB MScrnSave (ulRow, ulCol, lrRow, lrCol, SEG address)
DECLARE SUB MScrnRest (ulRow, ulCol, lrRow, lrCol, SEG address)
DECLARE SUB DeleteStr (BYVAL address, numEls)
DECLARE SUB InsertStr (BYVAL address, inserted$, numEls)
DECLARE SUB SetError (errCode%)
DECLARE SUB SpecChars (text$, hiBit)
DECLARE FUNCTION ArraySize% (ulRow, ulCol, lrRow, lrCol)
DECLARE FUNCTION DosError% ()
DECLARE FUNCTION ExpandTab$ (text$, numSpaces)
DECLARE FUNCTION FEof% (handle)
DECLARE FUNCTION FLInput$ (handle, buffer$)
DECLARE FUNCTION FLof& (handle)
DECLARE FUNCTION InCount% (lookIn$, char$)
DECLARE FUNCTION MaxInt% (var1%, var2%)
DECLARE FUNCTION OneColor% (bg, fg)
DECLARE FUNCTION QPLen% (work$)
DECLARE FUNCTION WhichError% ()

'----- Expand CHR$(9) TAB characters to the appropriate number of spaces
FUNCTION ExpandTab$ (x$, numSpaces) STATIC

  count = InCount(x$, CHR$(9))          ' find number of Tab characters
  IF count THEN                         ' are there any?
                                        ' make room for new string
    work$ = SPACE$(QPLen%(x$) + 1 + (numSpaces - 1) * count)

    LSET work$ = x$ + CHR$(0)           ' put existing string in it
                                        '   and a char. 0 for later
    where = 1                           ' set search position to 1

    FOR x = 1 TO count                  ' do each tab
                                        ' find the next Tab character
      where = INSTR(where, work$, CHR$(9)) + 1

      length = where - 2                ' calc length of left part
                                        ' calc spaces to next tab stop
      sp = length + numSpaces - (length MOD numSpaces) - length
                                        ' insert the spaces
      IF where > 1 THEN MID$(work$, where - 1) = SPACE$(sp) + MID$(work$, where)
    NEXT                                ' assign the function looking
                                        '   for the char. 0
    ExpandTab$ = LEFT$(work$, INSTR(work$, CHR$(0)) - 1)
  ELSE                                  ' no tabs, just assign the
    ExpandTab$ = x$                     '   function
  END IF

END FUNCTION

SUB SpecChars (text$, hiBit) STATIC

  IF QPLen%(text$) THEN
    text$ = ExpandTab$(text$, 8)
    IF hiBit THEN
      lowASCII text$                ' clear the hi-bit
      RemCtrl text$, ""             ' replace Ctrl characters with spaces
    END IF
  END IF

END SUB

'****************************************************************************
'         Title: ViewFile
'            by: Don Malin  5/04/1988
' modifications: Cory Smith 1/06/2023
'
' Purpose: Displays a files contents in a window which can be scrolled up,
'          down, left or right.  The underlying screen is saved on entry and
'          restored again on exit.
'
' Syntax: Call ViewFile(arg1$, arg2%, arg3%, arg4%, arg5%, arg6%)
'
' Inputs: arg1$ - Name of the file to view conforming to DOS conventions
'         arg2% - Number of file characters to display horizontally (<= 78)
'         arg3% - Number of file lines (rows) to display vertically
'         arg4% - Color attribute number for window - coded as for QPrint
'         arg5% - Flag to strip hi-bit and Ctrl chars from WordStar type files
'         arg6% - Action Flag:
'                 Action = 0 - save screen, browse file, clean up upon Escape
'                 Action = 1 - as above, but leave file open/set Action = 3
'                 Action = 3 - re-enter program from Action = 1 earlier
'                 Action = 5 - close file, restore underlying screen upon Esc.
'
'  Notes: The maximum number of lines that can be read is 16,384 which is
'         the size of the array used to keep track of line positions in the
'         file.  This program is intended for use with standard text files.
'****************************************************************************
SUB ViewFile (fileName$, numChars, rows, clr, hiBit, action) STATIC

  IF action < 2 THEN
    IF MID$(fileName$, 2, 1) = ":" THEN      ' See if there's a drive letter
      drive$ = LEFT$(fileName$, 1)
    ELSE
      drive$ = ""
    END IF
      
    midFirst = 1                             ' Start printing at Col 1
    oldBar = 0                               ' Init scroll bar history buf
    oldVrtPtr = 0
    doneWithTable = 0
  
    buf$ = SPACE$(82)                        ' assume 80 characters + CRLF
    REDIM array$(rows)                       ' Display array for APrint

    maxLines = 16383
    REDIM ptrs&(1 TO maxLines)               ' Holds byte position pointers
                                             '   for each line of file

    ulRow = CSRLIN                           ' Save current cursor line
    ulCol = POS(0)                           '   and column positions
    LOCATE , , 0                             ' Turn cursor off

    CALL SplitColor(clr, fg, bg)             ' Split color into Fg & Bg
    invClr = OneColor%(bg, fg)               ' Calc inverse color number

    '----- Save the screen
                                             ' Make array for screen contents
    scrnSize = 1 + ArraySize%(ulRow, ulCol, ulRow + rows + 1, ulCol + numChars + 1)
    REDIM scrBuf(scrnSize)
                                             ' Save underlying screen
    MScrnSave ulRow, ulCol, ulRow + rows + 1, ulCol + numChars + 1, scrBuf()

    '----- Print the window box
    ClearScr0 ulRow, ulCol, ulRow + rows + 1, ulCol + numChars + 1, clr

    fileName$ = UCASE$(LTRIM$(RTRIM$(fileName$))) ' Trim and Cap file name
    top$ = "�" + STRING$(numChars, "�") + "�"   ' Make top line of window
    IF QPLen%(top$) > QPLen%(fileName$) + 6 THEN
      MID$(top$, (QPLen%(top$) - QPLen%(fileName$) - 4) \ 2) = "[ " + fileName$ + " ]"
    END IF
    IF LEN(top$) > LEN(fileName$) + 17 THEN
      MID$(top$, 3) = "[F3-Search]"
    END IF

  END IF

  IF action = 5 THEN
                                             ' Restore the screen
    MScrnRest ulRow, ulCol, ulRow + rows + 1, ulCol + numChars + 1, scrBuf()
    ERASE ptrs&, array$, scrBuf              ' Clean up memory
    top$ = "": inserted$ = ""
    FClose handle                            ' Close the file
    EXIT SUB                                 ' Bail out
  END IF
              
  IF action < 3 THEN
    MQPrint top$, clr                        ' Print the top line
    FOR n = 1 TO rows                        ' Print the window sides
      LOCATE n + ulRow, ulCol: MQPrint "�", clr
      LOCATE , ulCol + numChars + 1
      IF rows > 2 THEN
        IF n = 1 THEN                     ' If there is enough room for
          MQPrint CHR$(24), invClr        '   a scroll bar, print one on
        ELSEIF n = rows THEN              '   the right side of window
          MQPrint CHR$(25), invClr
        ELSEIF n = 2 THEN
          MQPrint CHR$(4), invClr
        ELSE
          MQPrint CHR$(177), invClr
        END IF
      ELSE                                 ' Window too small for scroll
        MQPrint "�", clr                  '   bar, print double line
      END IF
    NEXT

    botRow = n + ulRow                       ' Save the bottom row #
    LOCATE botRow, ulCol                     ' Print horizontal scroll bar
    MQPrint "�" + CHR$(27) + CHR$(4) + STRING$(numChars - 3, CHR$(177)) + CHR$(26) + "�", clr
    CALL PaintBox0(botRow, ulCol + 1, botRow, ulCol + numChars, invClr)

    oClr = clr
  END IF

  IF action < 2 THEN
    '----- Open the file
    FOpen fileName$, handle                  ' Open file for QP Binary
    IF DosError% THEN EXIT SUB               ' exit if error

    maxLen = 0                               ' Keeps record of longest line
    count = 1                                ' Pointer into the byte pointer
                                             '   array
    ptrs&(count) = 1                         ' Init first element of array

    '----- Read the first screen of data
    DO UNTIL DosError% OR count > rows      ' Read a screen full of file
      lToDo = count                         ' specify the line to read
      GOSUB GetLine                         ' and go get a line
                                            ' Save the byte count for line
      ptrs&(count + 1) = Ptrs&(count) + QPLen%(array$(count)) + 2
      SpecChars array$(count), hiBit
                                            ' See if its longer than MaxLen
      IF QPLen%(array$(count)) > maxLen THEN maxLen = QPLen%(array$(count))
      count = count + 1
    LOOP
    lastLine = count

    fLen& = FLof&(handle)                    ' Save the length of the file
  END IF

  IF action THEN action = 3
      
  '----- Main processing loop
  DO
    LOCATE ulRow + 1, ulCol + 1             ' Print the display array
    'APrint0 VARPTR(array$(1)), rows, midFirst, numChars, clr
    APrint0 array$(), 1, rows, midFirst, numChars, clr

    clr = oClr

    DO                                      ' Wait for keyboard input
      IF NOT doneWithTable THEN
        GOSUB ReadPointer
      END IF

      x$ = INKEY$
    LOOP WHILE QPLen%(x$) < 2 AND x$ <> CHR$(27)
                                              
    SELECT CASE ASC(RIGHT$(x$, 1))              ' Process keys
                                              
      '----- Down arrow key
      CASE 80                                   ' If not at end of file
        IF NOT FEof%(handle) AND count < maxLines THEN
          'DeleteStr VARPTR(array$(1)), rows - 1 ' Shift array up
          DeleteStr array$(), 1, rows - 1 ' Shift array up
          FSeek handle, ptrs&(count) - 1        ' Seek to beginning of
                                                '   next line
          lastLine = MaxInt(lastLine, count)
          lToDo = rows
          GOSUB GetLine
                                                ' Save pointer into file
          ptrs&(count + 1) = ptrs&(count) + QPLen%(array$(rows)) + 2
          SpecChars array$(rows), hiBit
                                                ' Compare length to MaxLen
          IF QPLen%(array$(rows)) > maxLen THEN maxLen = QPLen%(array$(rows))
          count = count + 1
        END IF

      '----- Page Down key
      CASE 81
        IF NOT FEof%(handle) THEN         ' If not already at end of file
          GOSUB DoPage
        END IF

      '----- Up arrow key
      CASE 72
        IF count - rows > 1 THEN                ' If not already at top, back
          count = count - 1                     '   up pointer to previous line
          FSeek handle, ptrs&(count - rows) - 1 ' Seek to previous line
          inserted$ = FLInput$(handle, buf$)
          WHILE WhichError% = 83
            ' IF FRE("") < 2048 THEN
            '   SetError (14)
            '   EXIT SUB
            ' END IF
            inserted$ = inserted$ + FLInput$(handle, buf$)
          WEND

          SpecChars inserted$, hiBit
                                    ' Compare length to MaxLen
          IF QPLen%(inserted$) > maxLen THEN maxLen = QPLen%(inserted$)
                                    ' Insert line into display array
          'InsertStr VARPTR(array$(1)), inserted$, rows - 1
          InsertStr array$(), 1, inserted$, rows - 1
        END IF
                                      
      '----- Page Up key
      CASE 73
        count = count - rows              ' Back up counter a page
        IF count - rows < 1 THEN count = rows + 1 ' Check for past line 1
        FSeek handle, ptrs&(count - rows) - 1 ' Seek to start of page
        FOR n = 1 TO rows                     ' Read a screen full
          IF FEof%(handle) THEN EXIT FOR
          lToDo = n
          GOSUB GetLine
          SpecChars array$(n), hiBit
          IF QPLen%(array$(n)) > maxLen THEN maxLen = QPLen%(array$(n))
        NEXT

      '----- Left arrow
      CASE 75
        IF midFirst > 1 THEN               ' If not at first column,
          midFirst = midFirst - 1          '   back up column pointer
        END IF

      '----- Right Arrow
      CASE 77
        IF midFirst <= maxLen THEN         ' If not at end of longest
          midFirst = midFirst + 1          '    line, increment column
        END IF

      '----- Home key
      CASE 71
        count = rows + 1                   ' Backup cntr to end of window
        FSeek handle, ptrs&(count - rows) - 1 ' Seek to first line
        FOR n = 1 TO rows                  ' Read a screen full
          IF FEof%(handle) THEN EXIT FOR
          lToDo = n
          GOSUB GetLine
          SpecChars array$(n), hiBit
        NEXT
        midFirst = 1                       ' Set column position to 1

      '----- End Key
      CASE 79
        DO WHILE NOT doneWithTable
          GOSUB ReadPointer
        LOOP

        count = MaxInt(lastLine - rows, 1)  ' backup and re-read so
        FOR n = 1 TO rows                   '   screen ends on last line
          FSeek handle, ptrs&(count) - 1
          lToDo = n
          GOSUB GetLine
          SpecChars array$(n), hiBit
          count = count + 1
        NEXT

      '----- Ctrl-left key
      CASE 115
        midFirst = 1

      '----- F3 Search for text
      CASE 61
        REDIM f3Scr(7 * 80)
        MScrnSave 4, 1, 9, 80, f3Scr()
        ClearScr0 4, 10, 8, 70, 112
        Box0 4, 10, 8, 70, 2, 112
        MPaintBox 5, 71, 8, 72, 8
        MPaintBox 9, 12, 9, 72, 8
        Box0 5, 31, 7, 69, 1, 112
        LOCATE 6, 11
        MQPrint " Enter Search Text: ", 112
        answer$ = SPACE$(37)
        LSET answer$ = srch$
                                          ' Call Edit Routine
        DO
          Editor answer$, aLen, exitCode%, 0, 0, 112, 112, 6, 32
        LOOP UNTIL exitCode = 13 OR exitCode = 27
        MScrnRest 4, 1, 9, 80, f3Scr()
        ERASE f3Scr

        IF exitCode = 13 AND aLen THEN

          IF LEFT$(answer$, aLen) <> srch$ OR oldCount <> count THEN
            srch$ = UCASE$(LEFT$(answer$, aLen))
            sCount = MaxInt(count - rows, 1)
            found = 0
            pass = 0
            inst = 0
          END IF
          answer$ = ""

          origin = sCount

          DO
            IF inst = 0 THEN
              IF doneWithTable OR sCount < lastLine THEN
                FSeek handle, ptrs&(sCount) - 1
                work$ = FLInput$(handle, buf$)
                WHILE WhichError% = 83
                  ' IF FRE("") < 2048 THEN
                  '   SetError 14
                  '   EXIT SUB
                  ' END IF
                  work$ = work$ + FLInput$(handle, buf$)  ' get more
                WEND
              ELSE
                GOSUB ReadPointer
                work$ = temp$
              END IF
            END IF

            work$ = UCASE$(work$)
            SpecChars work$, hiBit

            inst = INSTR(inst + 1, work$, srch$)

            IF inst = 0 THEN
              sCount = sCount + 1
              IF doneWithTable AND sCount > lastLine THEN
                pass = 1
                sCount = 1
              END IF
            END IF
          LOOP UNTIL (pass = 1 AND sCount > origin AND found = 0) OR inst

          IF inst THEN
            found = inst <> 0

            IF sCount > count - 1 OR sCount < count - rows THEN
              IF FEof(handle) THEN
                count = sCount + 1
              ELSE
                count = sCount - 1
                IF count < 1 THEN count = 1
              END IF

              GOSUB DoPage
            END IF
              
            IF count < rows THEN
              rW = sCount
            ELSE
              rW = rows - (count - sCount - 1)
            END IF
            IF inst <= midFirst THEN midFirst = 1
            col = inst - midFirst + 1

            IF col > numChars - LEN(srch$) THEN
              midFirst = col - (numChars \ 2)
              col = col - midFirst + 1
            END IF

            LOCATE ulRow + 1, ulCol + 1
            'APrint0 VARPTR(array$(1)), rows, midFirst, numChars, clr
            APrint0 array$(), 1, rows, midFirst, numChars, clr

            clr = -1
          
            MPaintBox rW + ulRow, col + ulCol, rW + ulRow, col + ulCol + LEN(srch$) - 1, 112
            oldCount = count
          ELSE
            REDIM f3Scr(5 * 80)
            MScrnSave 4, 1, 7, 80, f3Scr()
            ClearScr0 4, 30, 6, 49, 112
            Box0 4, 30, 6, 49, 2, 112
            LOCATE 5, 32
            MQPrint "Match not found!", 112
            MPaintBox 5, 50, 6, 51, 8
            MPaintBox 7, 32, 7, 51, 8
            k$ = INPUT$(1)
            MScrnRest 4, 1, 7, 80, f3Scr()
            ERASE f3Scr
          END IF
        END IF

      CASE ELSE
    END SELECT
    GOSUB ScrlBar                             ' Update the scroll bars

  LOOP UNTIL x$ = CHR$(27)                    ' Go back for more unless Esc
                                              '   pressed

  IF Action = 0 THEN
                                              ' Restore the screen
    MScrnRest ulRow, ulCol, ulRow + rows + 1, ulCol + numChars + 1, scrBuf()
    ERASE ptrs&, array$, scrBuf               ' Clean up memory
    top$ = "": inserted$ = "": buf$ = ""
    FClose handle                             ' Close the file
  END IF

  EXIT SUB                                    ' Bail out

ScrlBar: '----- Update the scroll bars
  IF midFirst <> oldMid THEN                  ' If column position changed
    IF midFirst < maxLen THEN                 '   and not off right edge
                                              ' Calc. Horizontal position %
      horPtr = midFirst * (numChars - 2) \ maxLen

      LOCATE botRow, ulCol + oldHorPtr + 2    ' Erase old pointer
      MQPrint CHR$(177), invClr
      LOCATE , ulCol + horPtr + 2             ' Print the new pointer
      MQPrint CHR$(4), invClr
      oldHorPtr = horPtr                      ' Save pointer for next pass
    END IF
    oldMid = midFirst                         ' Save column position for next
  END IF
                                              
  IF count > rows THEN                        ' Calc the Vertical position %
    vrtPtr = (count - rows) * (rows - 2&) \ lastLine

    IF vrtPtr <> oldVrtPtr AND doneWithTable THEN ' If pointer has changed,
                                              '   Erase old pointer
      LOCATE ulRow + oldVrtPtr + 2, ulCol + numChars + 1
      MQPrint CHR$(177), invClr
      LOCATE ulRow + vrtPtr + 2               ' Print the new pointer
      MQPrint CHR$(4), invClr
      oldVrtPtr = vrtPtr                      ' Save old pointer for later
    END IF
  END IF
  RETURN

GetLine:
  array$(lToDo) = ""
  DO
    ' IF FRE("") < 2048 THEN
    '   SetError (14)
    '   EXIT SUB
    ' END IF
    array$(lToDo) = array$(lToDo) + FLInput$(handle, buf$)  ' get more
  LOOP WHILE WhichError% = 83
  lastLine = MaxInt(lastLine, lToDo)
  RETURN
            
ReadPointer:
  IF NOT FEof%(handle) AND lastLine < maxLines THEN
    FSeek handle, ptrs&(lastLine) - 1
    temp$ = ""
    DO
      ' IF FRE("") < 2048 THEN
      '   SetError (14)
      '   EXIT SUB
      ' END IF
      temp$ = temp$ + FLInput$(handle, buf$)    ' get more
    LOOP WHILE WhichError% = 83                 ' if "Buffer too small" error
    
    ptrs&(lastLine + 1) = ptrs&(lastLine) + QPLen%(temp$) + 2
                                              ' Compare length to MaxLen
    SpecChars temp$, hiBit
    IF QPLen%(temp$) > maxLen THEN maxLen = QPLen%(temp$)
    lastLine = lastLine + 1

  ELSE
    doneWithTable = -1
    FSeek handle, ptrs&(count)
  END IF
  RETURN

DoPage:
  FOR n = 1 TO rows              ' Read the next page
                                 ' Check for end of file
    IF NOT FEof%(handle) AND count < maxLines THEN
      FSeek handle, ptrs&(count) - 1 ' Seek to next line
      lToDo = n
      GOSUB GetLine               ' Read a line
                                  ' Save pointers into file
      ptrs&(count + 1) = ptrs&(count) + QPLen%(array$(n)) + 2
      SpecChars array$(n), hiBit
                                  ' Compare length to MaxLen
      IF QPLen%(array$(n)) > maxLen THEN maxLen = QPLen%(array$(n))
      count = count + 1
    END IF
  NEXT

  IF FEof%(handle) OR count >= maxLines THEN  ' If we reached end of file,
    count = count - rows        '   backup and re-read so
    FOR n = 1 TO rows           '   screen ends on last line
      FSeek handle, ptrs&(count) - 1
      lToDo = n
      GOSUB GetLine
      ptrs&(count + 1) = ptrs&(count) + QPLen%(array$(n)) + 2
      SpecChars array$(n), hiBit
      count = count + 1
    NEXT
  END IF
  RETURN
     
END SUB