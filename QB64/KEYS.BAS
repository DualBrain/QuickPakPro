' ******** KEYS.BAS

' Copyright (c) 2022 Cory Smith

'$INCLUDE: 'QPPRO.BI'

DEFINT A-Z

CLS

PRINT "Press a key..."

ClearBuf

DO
  p1 = PEEK(&H41a)
  p2 = PEEK(&H41b)
  p3 = PEEK(&H41c)
  p4 = PEEK(&H41d)
  IF p1 + p2 + p3 + p4 THEN
    LOCATE 1, 1: PRINT PEEK(&H41a)
    LOCATE 2, 1: PRINT PEEK(&H41b)
    LOCATE 3, 1: PRINT PEEK(&H41c)
    LOCATE 4, 1: PRINT PEEK(&H41d)
  END IF
  ' IF KeyDown% THEN
  '   p& = PeekBuf
  '   IF p& THEN PRINT p&; TIMER
  '   x& = _KEYHIT
  '   IF x& THEN PRINT x&
  ' END IF
LOOP

'$INCLUDE: 'QPPRO.BAS'
