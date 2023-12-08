'$lang: "qb"

DEFINT A-Z

DECLARE FUNCTION TestFunction(value)
DECLARE SUB TestPointer(address AS INTEGER __PTR)
DECLARE SUB TestGosubInMethod()

a = 5
b = 10
PRINT "HELLO WORLD!!!!"
GOSUB TEST
TestGosubInMethod
PRINT a * b
PRINT TestFunction(5)
TestPointer @a
PRINT "DONE"
END

TEST:
  PRINT "IN GOSUB"
RETURN

SUB TestGosubInMethod()
 
  PRINT "1"
  GOSUB Print2
  PRINT "3"
  EXIT SUB

Print2:
  PRINT "2"
  RETURN

END SUB

Option Nogosub

FUNCTION TestFunction(value)
  RETURN value
END FUNCTION

SUB TestPointer(address AS INTEGER __PTR)
  PRINT *address
END SUB