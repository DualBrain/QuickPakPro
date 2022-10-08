' ********** GASGAUGE.BAS - subprogram displays a percent status indicator

' Copyright (c) 1992 Ethan Winer
' Modifications (c) 2022 Cory Smith

DEFINT A-Z

DECLARE SUB GasGauge (min, max, value, wide, colr)

SUB GasGauge (min, max, value, wide, colr) STATIC

  row = CSRLIN                          'retrieve the current cursor location
  column = POS(0)                       'and draw a box there
  newWide = wide - 2                    'exclude the border dimensions
  CALL Box0(row, column, row + 4, column + wide + 1, 1, colr)
 
  row = row + 1                         'bump the row and column, because
  column = column + 1                   ' we're printing at the next ones
  IF LEN(padder$) <> wide THEN padder$ = SPACE$(wide) 'holds title, bars, legends
  part! = (value - min + 1) / (max - min + 1)   'percent divided by 100
  LSET padder$ = STR$(INT(part! * 100)) + " percent completed:"
  CALL QPrintRC(padder$, row, column, colr)
 
  row = row + 1                         'the gauge itself is on the next line
  numBlocks = wide * part!              'calculate the number of solid blocks
  numShades = wide - numBlocks          'and then the number of shaded blocks
  LSET padder$ = STRING$(numBlocks, 219) + STRING$(numShades, 176)
  CALL QPrintRC(padder$, row, column, colr)

  ' This next block of code prints the lower and upper limits beneath the
  ' progress bar at each end. If you prefer to remove this code you should
  ' also change the call to Box0 above to use Row + 3 instead of Row + 4.
  row = row + 1
  LSET padder$ = LTRIM$(STR$(min))
  max$ = LTRIM$(STR$(max))
  maxLen = LEN(max$)
  MID$(padder$, wide - maxLen + 1) = max$
  CALL QPrintRC(padder$, row, column, colr)

END SUB