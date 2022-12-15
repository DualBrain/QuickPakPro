DIM cnf AS Config

CALL InitMouse(cnf.Mouse)

cnf.MonTyp = Monitor

clrDisp% = cnf.MonTyp = 3 OR (cnf.MonTyp >= 5 AND cnf.MonTyp <= 9) OR cnf.MonTyp = 11
IF INSTR(COMMAND$, "/B") THEN clrDisp% = 0

IF clrDisp% THEN
  IF 0 THEN
    cnf.PulBar = 112 ' Black on White
    cnf.MenBox = 112 ' Black on White
    cnf.ActivCh = 112 ' Black on White
    cnf.InActCh = 116 ' Red on White
    cnf.HiLite = 7 ' White on Black
    cnf.InActHiLt = 64 ' Black on Red
    cnf.NonMen = 14 ' Yellow on Black
  ELSE
    cnf.PulBar = 48 ' Black on Cyan
    cnf.MenBox = 49 ' Blue on Cyan
    cnf.ActivCh = 48 ' Black on Cyan
    cnf.InActCh = 52 ' Red on Cyan
    cnf.HiLite = 31 ' Bright White on Blue
    cnf.InActHiLt = 64 ' Black on Red
    cnf.NonMen = 30 ' Yellow on Blue
  END IF
ELSE
  cnf.PulBar = 112
  cnf.MenBox = 112
  cnf.ActivCh = 112
  cnf.InActCh = 112
  cnf.HiLite = 15
  cnf.InActHiLt = 80
  cnf.NonMen = 7
END IF

IF cnf.MonTyp >= 3 AND cnf.MonTyp <= 5 THEN
  cnf.CurSize = 7
ELSE
  cnf.CurSize = 12
END IF
