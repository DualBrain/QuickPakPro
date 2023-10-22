' ********** MSGBOX.BAS
' Copyright (c) 1988 Crescent Software
' Modifications (c) 2023 Cory Smith

#INCLUDE "PRO.BI" ' MQPrint, MPaintBox, MScrnSave, MScrnRest
#INCLUDE "DefCnf.BI"

DECLARE SUB CSMsgBox (message As String, wdth As Short, cnf AS Config)

SUB CSMsgBox (message As String, wdth As Short, cnf AS Config) STATIC

  Dim nd As Short, botRow As Short, row As Short, colPos As Short, n As Short, boxWdth As Short
  Dim pass As Short, ln As Short, strt As Short, mesLen As Short
  Dim boxS As String, sz As Short

  Redim scrBuf(sz) As Short

  IF LEN(message) THEN
    row = CSRLIN                             'Get the Row Position

    REDIM temp(23) As String                          'Make a temporary array to
                                            '  hold the parsed up lines
    mesLen = LEN(message)                   'Get the total length of the
                                            '  help message

    ln = 0                                   'Line number
    strt = 1                                 'Starting parse position
    '*** Parse the message into lines
    DO
        WHILE MID$(message, Strt, 1) = " "  'Skip over blanks
          Strt = Strt + 1
        WEND
        ND = Strt + Wdth                     'Guess at the end of line
                                            'Loop backwards to find
        WHILE MID$(message, ND, 1) <> " " AND ND <= MesLen AND ND > Strt
            ND = ND - 1                      '  blank space
        WEND

        LN = LN + 1                          'Increment the Line number
                                            'Pull out the new line
        temp(LN) = MID$(message, Strt, ND - Strt)
        Strt = ND + 1                        'Reset starting posit. for
                                            '  next line
    LOOP UNTIL ND >= MesLen                  'Get more unless @ end of mes

    BotRow = Row + LN + 1                    'Find the bottom row #
    IF BotRow > 24 THEN BotRow = 24          'No farther than line 24

    sz = 80 * (BotRow - Row + 2)      'Find the array size to use
    REDIM scrBuf(sz) As Short                  '  for the background screen
    MScrnSave Row, 1, BotRow + 1, 80, @scrBuf(0)

    BoxWdth = Wdth + 4                       'Find the outer box width
    ColPos = 40 - (BoxWdth \ 2)              'Starting posit for centered
                                            '  box
    LOCATE Row, ColPos                       'Print the top of box
    MQPrint CHR$(201) + STRING$(Wdth + 2, CHR$(205)) + CHR$(187), Cnf.MenBox
    boxS = CHR$(186) + SPACE$(Wdth + 2) + CHR$(186)      'Make the box sides

    FOR N = 1 TO LN                          'Print message lines
        LOCATE N + Row, ColPos
        MQPrint boxS, Cnf.MenBox
        LOCATE , ColPos + 2
        MQPrint temp(N), Cnf.ActivCh
    NEXT

    LOCATE N + Row, ColPos                   'Print the bottom of box
    MQPrint CHR$(200) + STRING$(Wdth + 2, CHR$(205)) + CHR$(188), Cnf.MenBox

    MPaintBox Row + 1, ColPos + BoxWdth, N + Row, ColPos + BoxWdth + 1, 8
    MPaintBox N + Row + 1, ColPos + 2, N + Row + 1, ColPos + BoxWdth + 1, 8

    Pass = 1                                 'Set flag say we've been here
    ERASE temp                              'Don't need this anymore

  ELSEIF Pass = 1 THEN                        'If we've been here before,
                                            '  restore the screen
    MScrnRest Row, 1, BotRow + 1, 80, @scrBuf(0)
    ERASE scrBuf                             'Clean up memory
    Pass = 0                                 'Reset flag for next call
  END IF

END SUB