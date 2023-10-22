DIM cnf AS Config

InitMouse cnf.Mouse

cnf.MonTyp = Monitor

Var clrDisp = cnf.MonTyp = 3 OR (cnf.MonTyp >= 5 AND cnf.MonTyp <= 9) OR cnf.MonTyp = 11
IF INSTR(COMMAND$, "/B") THEN clrDisp = 0

IF clrDisp THEN
  cnf.PulBar = 48
  cnf.MenBox = 49
  cnf.ActivCh = 48
  cnf.InActCh = 52
  cnf.HiLite = 31
  cnf.InActHiLt = 64
  cnf.NonMen = 30
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