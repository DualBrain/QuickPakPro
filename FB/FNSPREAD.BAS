' ********* FNSPREAD.BAS
' Copyright (c) 1988 Crescent Software
' Lotus "@" functions by Bill Eppler, Ed Ernst, and Ethan Winer
' Modifications (c) 2023 Cory Smith

' This file contains a complete set of scientific, financial, and other
' general purpose functions.  Because many of them are "one-liners" or
' at least fairly short, they have all been gathered into a single file.

'----- Assembler function helpers

'DECLARE FUNCTION ASCII% (X$)                    'asm - used by ROUND
'DECLARE FUNCTION FUsing$ (Number$, Mask$)       'asm - used by ROUND
'DECLARE FUNCTION MaxD (SEG Element, NumEls)   'asm - used by MAX
'DECLARE FUNCTION MinD (SEG Element, NumEls)   'asm - used by MIN
#INCLUDE ONCE "PRO.BI" ' ASCII, FUsing, MaxD, MinD

'----- BASIC Financial and scientific functions

DECLARE FUNCTION QPACOS (X As Double) As Double
DECLARE FUNCTION QPASIN (X As Double) As Double
DECLARE FUNCTION QPATAN2 (X As Double, Y As Double) As Double
DECLARE FUNCTION QPAVG (array() As Double) As Double
DECLARE FUNCTION QPCINT (Pv As Double, Intr As Double, Term As Short) As Double
DECLARE FUNCTION QPCOUNT (array() As Double) As Short
DECLARE FUNCTION QPCTERM (Pv As Double, Fv As Double, Intr As Double) As Double
DECLARE FUNCTION QPDDB (Cost As Double, Sal As Double, Life As Short, Per As Short, M As Single) As Double
DECLARE FUNCTION QPFV (Pmt As Double, Intr As Double, Term As Short) As Double
DECLARE FUNCTION QPFVD (Pmt As Double, Intr As Double, Term As Short) As Double
DECLARE FUNCTION QPFVN (Fv As Double, Pmt As Double, Intr As Double) As Double
DECLARE FUNCTION QPFVND (Fv As Double, Pmt As Double, Intr As Double) As Double
DECLARE FUNCTION QPFVP (Fv As Double, Intr As Double, Term As Short) As Double
DECLARE FUNCTION QPFVPD (Fv As Double, Intr As Double, Term As Short) As Double
DECLARE FUNCTION QPIRR (Intr As Double, array() As Double) As Double
DECLARE FUNCTION QPLOG10 (X As Double) As Double
DECLARE FUNCTION QPMAX (array() As Double) As Double
DECLARE FUNCTION QPMIN (array() As Double) As Double
DECLARE FUNCTION QPNPV (Intr As Double, array() As Double) As Double
DECLARE FUNCTION QPPMT (Pv As Double, Intr As Double, Term As Short, Bal As Double) As Double
DECLARE FUNCTION QPPMTD (Pv As Double, Intr As Double, Term As Short, Bal As Double) As Double
DECLARE FUNCTION QPPV (Pmt As Double, Intr As Double, Term As Short, Bal As Double) As Double
DECLARE FUNCTION QPPVD (Pmt As Double, Intr As Double, Term As Short, Bal As Double) As Double
DECLARE FUNCTION QPPVN (Pmt As Double, Intr As Double, Pv As Double, Bal As Double) As Double
DECLARE FUNCTION QPPVND (Pmt As Double, Intr As Double, Pv As Double, Bal As Double) As Double
DECLARE FUNCTION QPRATE (Pv As Double, Fv As Double, Term As Short) As Double
DECLARE FUNCTION QPROUND (Number As Double, Places As Short) As String
DECLARE FUNCTION QPSLN (Cost As Double, Sal As Double, Life As Short) As Double
DECLARE FUNCTION QPSTD (array() As Double) As Double
DECLARE FUNCTION QPSUM (array() As Double) As Double
DECLARE FUNCTION QPSYD (Cost As Double, Sal As Double, Life As Short, Per As Short) As Double
DECLARE FUNCTION QPVAR (array() As Double) As Double

'==== Demonstration for determining mortgage/car payments

Dim temp As String

CLS
INPUT "Enter the value of the loan: ", temp
Var pv = VAL(temp)

INPUT "Enter the annual interest rate (if 8% enter .08): ", temp
Var intr = VAL(temp) / 12 '/12 because these function expect monthly interest

INPUT "Enter the number of months: ", temp
Var term = VAL(temp)

Dim bal As Double

INPUT "Enter the balloon amount (or press Enter if none): ", bal

PRINT "Your monthly payment is"; QPPMT(pv, intr, term, bal)

END

'---------- MATHEMATICAL FUNCTIONS AND QUICKPAK PROFESSIONAL EQUIVALENTS

'@ACOS(x)       Arc cosine of x (rad.)  -1 <= x <= +1
'   QPACOS#(x#) = pi / 2 - ATN(x# / SQR(1 - x# * x#))   ABS(x#) <> 1
'   QPACOS#(x#) = 1                                     x = 1
'   QPACOS#(x#) = pi                                    otherwise


'@ASIN(x)       Arc sine of x (rad.)  -1 <= x <= +1
'   QPASIN#(x#) = ATN(x# / SQR(1 - x# * x#))            ABS(x#) <> 1
'   QPASIN#(x#) = SGN(x#) * pi / 2                      otherwise


'@ATAN2(x,y)    4-quadrant arc tangent of y/x (rad.)
'   QPATAN2#(x#, y#) = SGN(y#) * pi / 2                 x = 0
'   QPATAN2#(x#, y#) = ATN(y# / x#)                     x > 0
'   QPATAN2#(x#, y#) = pi + ATN(y# / x#)                x < 0 & y >= 0
'   QPATAN2#(x#, y#) = -pi + ATN(y# / x#)               x < 0 & y <= 0


'@INT(x)        Integer part of x (-*- note Lotus' incorrect terminology)
'   use BASIC's FIX(x) to get the equivalent of what Lotus 123 does


'@LN(x)         Log of x base e
'   use BASIC's LOG(x)


'@LOG(x)        Log of x base 10
'   QPLOG10#(x#) = LOG(x#) / LOG(10)


'@PI            Value of pi
'   use the constant PI# = 3.14159265358979323846#
'or
'   use PI# = 4# * ATN(1#) to compute it


'@RAND          Random number 0-1
'   use BASIC's RND        (See RANDOMIZE function in QB manual)
'                          (also see QuickPak Rand function in FNOTHER.BAS)


'@ROUND(x,n)    x rounded to n decimal places
'   QPROUND$(Number#, Places%)



'----- FINANCIAL FUNCTIONS AND QUICKPAK PROFESSIONAL EQUIVALENTS

'Many of the Lotus financial functions involve annuities.  An annuity is
'simply a series of equal payments made at regular intervals of time.  It
'is a compound interest situation with regular payments.  When the payments
'are made at the beginning of the payment period, the annuity is called an
'"annuity due".  When payment is due at the end of the payment period it is
'an "ordinary annuity".

'where

        'fv#   = future value
        'pv#   = present value
        'pmt#  = payment per period
        'I!    = interest rate PER PERIOD in percent
        'intr# = I/100 (I)
        'term% = number of periods
        'prin# = principal (same as pv#)
        'bal#  = balloon payment (may be 0)


'NOTE: Several of the functions we have provided are not available even in
'      Lotus 123, and are identified below with a leading "*".
    

'A sinking fund annuity is most easily described as a savings fund designed
'to accumulate a predetermined amount of money on a specified date.

'@FV(pmt#, intr#, term%)      Future value of ordinary annuity (sinking fund)
'   QPFV#(pmt#, intr#, term%) = pmt# * ((1 + intr#)^ term% - 1) / intr#

'*@FVN(fv#, pmt#, intr#)      Term (number of payments) of a sinking fund
'   QPFVN#(fv#, pmt#, intr#) = LOG(fv# * intr# / pmt# + 1) / LOG(1 + intr#)

'*@FVP(fv#, intr#, term%)     Payment amount of a sinking fund
'   QPFVP#(fv#, intr#, term%) = fv# * intr# / ((1 + intr#)^ term% - 1)



'An example annuity due (future value) is the future value of a savings
'account with equal deposits made at the beginning of each period.

'*@FVD(pmt#, intr#, term%)    Future value of annuity due
'   QPFVD#(pmt#, intr#, term%) = _
'          pmt# * (1 + intr#) * ((1+ intr#)^ term% - 1) / intr#

'*@FVND(fv#, pmt#, intr#)     Term (number of payments) of an annuity due / FV
'   QPFVND#(fv#, pmt#, intr#) = _
'           LOG(fv# * intr# / pmt# + 1 + intr#) / LOG(1 + intr#) - 1

'*@FVPD(fv#, intr#, term%)    Payment amount of an annuity due/FV
'   QPFVPD#(fv#, intr#, term#) = _
'           fv# / ((1 + intr#) / intr# * (1 + intr#)^ term% - 1)



'When a sum of money is to be repaid with interest in fixed payments for a
'specified number of periods (such as with a home mortgage), it is called
'an ordinary annuity.  A balloon payment may be associated with this type
'of annuity.
'
'@PMT(pv#, intr#, term%)      Loan payment (ordinary annuity)
'   QPPMT#(pv#, intr#, term%, bal#) = _
'         (pv# - bal# * (1+intr#)^ -term%) / ((1 - (1+intr#)^ -term%) / intr#)

'@PV(pmt#, intr#, term%)      Present value of an ordinary annuity
'   QPPV#(pmt#, intr#, term%, bal#) = _
'         pmt# * (1 - (1 + intr#)^ -term%) / intr# + bal# * (1 + intr#)^ -term%

'*@PVN(pmt#, intr#, pv#)      Term (number of payments) of an ordinary annuity
'   QPPVN#(pmt#, intr#, pv#, bal#) = _
'          LOG((pmt# - intr# * bal#) / (pmt# - intr# * pv#)) / LOG(1 + intr#)



'In order to find the present value of a lease which will involve fixed
'payments at the beginning of each payment period, use these annuity due
'relationships.

'*@PMTD(pv#, int# ,term%)     Lease payment (annuity due)
'   QPPMTD#(pv#, intr#, term%, bal#) = _
'          (pv# - bal# * (1 + intr#)^ -term%) / (1 + intr#) / _
'          ((1 - (1 + intr#)^ -term%) / intr#)

'*@PVD(pmt#, intr#, term%)    Present value of annuity due
'   QPPVD#(pmt#, intr#, term%, bal#) = _
'          pmt# * (1+intr#) * (1-(1+intr#)^ -term%) / _
'          intr# + bal# * (1+intr#)^ -term%

'*@PVND(pmt#, intr#, pv#)     Term (number of payments) of an annuity due
'   QPPVND#(pmt#, intr#, pv#, bal#) = _
'           LOG((pmt# * (1 + intr#) / intr# - bal#) / _
'           (pmt# * (1 + intr#) / intr# - pv#)) / LOG(1 + intr#)



'In order to find the future value of a savings account drawing compound
'interest, use the FCINT function
'
'*@CINT(pv#, intr#, term%)    Compounded interest
'   QPCINT#(pv#, intr#, term%) = pv# * (1 + intr#)^ term%



'To determine the number of compounding periods it will take an
'investment to grow to a pre-determined value, use the FCTERM function
'
'@CTERM(intr#, fv#, pv#)      Compounded term of investment
'                             Note: Interest Rate (intr#) must be in decimal
'                                   form.  For example, the monthly rate of
'                                   10% per year is (10/100)/12 or .008333
'
'   QPCTERM#(pv#, fv#, intr#) = LOG(fv# / pv#) / LOG(1 + intr#)



'The periodic interest rate required for an investment to grow to a pre-
'determined value in a specified time is:

'@RATE(fv#, pv#, term%)       Rate of investment
'   QPRATE#(pv#, fv#, term%) = (fv# / pv#)^ 1 / term% - 1



'The IRS allows depreciation of various assets using some of the methods
'listed below (depending on the type and life of the asset).

'@DDB(cost#, salvage#, life%, period%)
'Double declining balance depreciation for the year, with 1<=year<=life
'   QPDDB#(cost#, sal#, life%, per%, m!) = _
'          m! * cost# / life%^ per% * (life% - 2)^ (per% - 1)
'
'   where "m" is the depreciation multiplier ie.
'          m = 2   - Double Declining Balance
'          m = 1.5 - 150% Declining Balance
'          m = 1   - Simple Declining Balance
'
'Adjustments are made to the formula to insure that the total depreciation
'does not exceed total cost less salvage value.

'@SLN(cost#, salvage#, life%) Straight-line depreciation for one period
'   QPSLN#(cost#, sal#, life%) = (cost# - sal#) / life%

'@SYD(cost#, salvage#, life%, period%)
'Sum-of-years'-digits depreciation for the year, with 1<=year<=life
'   QPSYD#(cost#, sal#, life%, per%) = _
'         (cost# - sal#) * (life% - per% + 1) / (life% * (life% + 1) / 2)



'@IRR(guess#, range#()) Internal rate of return.  This function is seeded
'                       by giving it an initial IRR rate (guess).  The
'                       algorithm first brackets the correct IRR and then
'                       converges on the final IRR by a halving method.
'                       Convergence ends when a given degree of accuracy
'                       is reached.
'
'   QPIRR#(intr#,Array#())



'@NPV(intr#, range#())  Net present value of future cash flows.  If the
'                       initial flow is NOT an outflow, enter zero as the
'                       first value in Array#().  This will give the PV of
'                       the dollar flow.
'
'   QPNPV#(intr#,Array#())



'----- STATISTICAL FUNCTIONS AND QUICKPAK PROFESSIONAL EQUIVALENTS

'@AVG(list)             Average of values in list
'   QPAVG#(Array#()) = QPSUM#(Array#()) / QPCOUNT%(Array#())

'@COUNT(list)           Number of entries
'   QPCOUNT%(Array#()) = UBOUND(Array#, 1) - LBOUND(Array#, 1) + 1

'@MAX(list)             Maximum value in list
'   QPMAX#(Array#())

'@MIN(list)             Minimum value in list
'   QPMIN#(Array#())

'@STD(list)             Population standard deviation of items in list
'   QPSTD#(Array#())

'@SUM(list)             Sum of the values in list
'   QPSUM#(Array#())

'@VAR(list)             Population variance of values in list
'   QPVAR#(Array#())

FUNCTION QPACOS (x As Double) As Double 'STATIC
  IF ABS(x) <> 1# THEN
    QPACOS = 1.570796326794897# - ATN(x / SQR(1# - x * x))
  ELSEIF x = 1# THEN
    QPACOS = 0#
  ELSE
    QPACOS = 3.141592653589793#
  END IF
END FUNCTION

FUNCTION QPASIN (x As Double) As Double 'STATIC
  IF ABS(x) <> 1# THEN
    QPASIN = ATN(x / SQR(1# - x * x))
  ELSE
    QPASIN = SGN(x) * 1.570796326794897#
  END IF
END FUNCTION

FUNCTION QPATAN2 (x As Double, y As Double) As Double 'STATIC
  IF x = 0# THEN
    QPATAN2 = SGN(y) * 1.570796326794897#
  ELSEIF x > 0# THEN
    QPATAN2 = ATN(y / x)
  ELSEIF y >= 0# THEN
    QPATAN2 = 3.141592653589793# + ATN(y / x)
  ELSE
    QPATAN2 = -3.141592653589793# + ATN(y / x)
  END IF
END FUNCTION

'External functions required:  QPSUM#()
'                              QPCOUNT%()
'
FUNCTION QPAVG (array() As Double) As Double 'STATIC
  QPAVG = QPSUM(array()) / QPCOUNT(array())
END FUNCTION

FUNCTION QPCINT (pv As Double, intr As Double, term As Short) As Double 'STATIC
  QPCINT = pv * (1# + intr) ^ term
END FUNCTION

FUNCTION QPCOUNT (array() As Double) As Short 'STATIC
  QPCOUNT = UBOUND(array, 1) - LBOUND(array, 1) + 1
END FUNCTION

FUNCTION QPCTERM (pv As Double, fv As Double, intr As Double) As Double 'STATIC
  QPCTERM = LOG(fv / pv) / LOG(1# + intr)
END FUNCTION

FUNCTION QPDDB (cost As Double, sal As Double, life As Short, per As Short, m As Single) As Double 'STATIC
  Dim depper As Double
  FOR a As Short = 1 TO per
    depper = cost * m / life
    cost = cost - depper
    IF depper > 0# AND cost < sal THEN
      depper = depper - sal + cost
      cost = 0#
    END IF
  NEXT
  QPDDB = depper
  ' equivalent: QPDDB = m * cost / life ^ per * (life - 2) ^ (per - 1)
END FUNCTION

FUNCTION QPFV (pmt As Double, intr As Double, term As Short) As Double 'STATIC
  QPFV = pmt * ((1# + intr) ^ term - 1) / intr
END FUNCTION

FUNCTION QPFVD (pmt As Double, intr As Double, term As Short) As Double 'STATIC
  QPFVD = pmt * (1# + intr) * ((1# + intr) ^ term - 1) / intr
END FUNCTION

FUNCTION QPFVN (fv As Double, pmt As Double, intr As Double) As Double 'STATIC
  QPFVN = LOG((fv * intr) / pmt + 1#) / LOG(1# + intr)
END FUNCTION

FUNCTION QPFVND (fv As Double, pmt As Double, intr As Double) As Double 'STATIC
  QPFVND = LOG(fv * intr / pmt / (1# + intr) + 1#) / LOG(1# + intr)
END FUNCTION

FUNCTION QPFVP (fv As Double, intr As Double, term As Short) As Double 'STATIC
  QPFVP = fv * intr / ((1# + intr) ^ term - 1)
END FUNCTION

FUNCTION QPFVPD (fv As Double, intr As Double, term As Short) As Double 'STATIC
  QPFVPD = fv * intr / (1# + intr) / ((1# + intr) ^ term - 1#)
END FUNCTION

SUB IRRCalcB(Byref temp As Double, Byref inv1 As Double, hi As Short, array() As Double, rateX As Double)
  temp = inv1                       'initialize with investment
  FOR x As Short = 2 TO hi                   'discount future dollar stream
    temp = temp + (array(x) / (1# + rateX / 100#) ^ (x - 1))
  NEXT
END SUB                                  'return with NPV at RateX#

FUNCTION IRRCalcA(Byref temp As Double, Byref inv1 As Double, hi As Short, array() As Double, Byref rateX As Double) As Short
  IF ABS(rateX) < .0000005# THEN     'check for zero (or equivalent)
    rateX = 0#
    IRRCalcA = -1
  ELSE
    IRRCalcB temp, inv1, hi, array(), rateX
    IRRCalcA = 0
  END IF
END FUNCTION

FUNCTION QPIRR (intr As Double, array() As Double) As Double 'STATIC

  Var hi = UBOUND(array, 1)
  Var lo = LBOUND(array, 1)

  Var inv1 = ABS(array(1)) * -1         'assure that 1st number is neg

  Var rate0 = intr
'         ********   Bracket IRR   ********
  Var rate1 = rate0
  Dim rate2 As Double
 
  Var rateX = rate1
  Var cx = 0: Var cz = 0
  Var e1 = 0: Var e2 = 0                    'bracket control variables

Bracket:      
  Var temp = inv1                       'initialize
  'GOSUB IRRCalcB                      'Calc & return NPV (Temp#)
  IRRCalcB temp, inv1, hi, array(), rateX

  cx = cx + 1
  IF cx = 1 THEN
    Var NPV0 = temp                    'NPV of 1st trial
    IF ABS(NPV0) < .01# GOTO EndIRRFnc
  END IF

'----- additional NPV trials to bracket correct IRR
  
  IF temp > 0 THEN
    rate1 = rateX
    e1 = 1
    IF e1 + e2 = 3 GOTO ConvergeA
    rateX = rateX * 1.05#
    GOTO Bracket
  ELSE
    rate2 = rateX
    e2 = 2
    IF e1 + e2 = 3 GOTO ConvergeA
    rateX = rateX * .95#
    GOTO Bracket
  END IF

'      ********   Converge on IRR to given accuracy   ********
ConvergeA:                              'resolve to .0001 percent error
                                        '  by halving method
  cz = 0
  rateX = (rate1 + rate2) / 2

ConvergeB:
  cz = cz + 1               'count iterations (optional if you care)
  'GOSUB IRRCalcA
  IF IRRCalcA(temp, inv1, hi, array(), rateX) THEN
    GOTO EndIRRFnc
  END IF    

  IF ABS((rate1 - rate2) / rate1) < .0001# GOTO EndIRRFnc

  IF temp > 0 THEN
    rate1 = rateX
    rateX = (rateX + rate2) / 2#
    GOTO ConvergeB
  ELSE
    rate2 = rateX
    rateX = (rateX + rate1) / 2#
    GOTO ConvergeB
  END IF

' IRRCalcA:
'   IF ABS(rateX) < .0000005# THEN     'check for zero (or equivalent)
'     rateX = 0#
'     GOTO EndIRRFnc
'   END IF

' IRRCalcB:
'   temp# = inv1                       'initialize with investment
'   FOR x As Short = 2 TO hi                   'discount future dollar stream
'     temp = temp + (array(x) / (1# + rateX / 100#) ^ (x - 1))
'   NEXT
' RETURN                                  'return with NPV at RateX#

EndIRRFnc:
  QPIRR = rateX
  'PRINT "IRR Iterations:"; cz        'unREM to see this

END FUNCTION

FUNCTION QPLOG10 (x As Double) As Double 'STATIC
  QPLOG10 = LOG(x) / LOG(10#)
END FUNCTION

FUNCTION QPMAX (array() As Double) As Double 'STATIC
  Var lo = LBOUND(array, 1)             'get the lowest subscript
  Var hi = UBOUND(array, 1)             'and the highest
  QPMAX = MaxD(@array(lo), hi - lo + 1)  'use the .asm version here
END FUNCTION

FUNCTION QPMIN (array() As Double) As Double 'STATIC
  Var lo = LBOUND(array, 1)             'get the range of subscripts
  Var hi = UBOUND(array, 1)             'and the highest
  QPMIN = MinD(@array(lo), hi - lo + 1)    'use the .asm version here
END FUNCTION

FUNCTION QPNPV (intr As Double, array() As Double) As Double 'STATIC
  Var hi = UBOUND(array, 1)
  Var lo = LBOUND(array, 1)
  Var temp = ABS(array(1)) * (-1)             'assure that 1st number is neg
  FOR x As Short = 2 TO hi                         'discount future dollar stream
    temp = temp + (array(x) / (1# + intr / 100#) ^ (x - 1))
  NEXT x
  QPNPV = temp                            'set returned value
END FUNCTION

FUNCTION QPPMT (pv As Double, intr As Double, term As Short, bal As Double) As Double 'STATIC
  Var temp = (1# + intr) ^ -term
  QPPMT = (pv - bal * temp) / ((1# - temp) / intr)
END FUNCTION

FUNCTION QPPMTD (pv As Double, intr As Double, term As Short, bal As Double) As Double 'STATIC
  Var temp = (1# + intr) ^ -term
  QPPMTD = (pv - bal * temp) / ((1# + intr) * (1# - temp) / intr)
END FUNCTION

FUNCTION QPPV (pmt As Double, intr As Double, term As Short, bal As Double) As Double 'STATIC
  Var temp = (1# + intr) ^ -term
  QPPV = pmt * (1# - temp) / intr + bal * temp
END FUNCTION

FUNCTION QPPVD (pmt As Double, intr As Double, term As short, bal As Double) As Double 'STATIC
  Var temp = (1# + intr) ^ -term
  QPPVD = pmt * (1# + intr) * (1# - temp) / intr + bal * temp
END FUNCTION

FUNCTION QPPVN (pmt As Double, intr As Double, pv As Double, bal As Double) As Double 'STATIC
  QPPVN = LOG((pmt - intr * bal) / (pmt - intr * pv)) / LOG(1# + intr)
END FUNCTION

FUNCTION QPPVND (pmt As Double, intr As Double, pv As Double, bal As Double) As Double 'STATIC
  Var temp = pmt * (1# + intr) / intr
  QPPVND = LOG((temp - bal) / (temp - pv)) / LOG(1# + intr)
END FUNCTION

FUNCTION QPRATE (pv As Double, fv As Double, term As Short) As Double 'STATIC
  QPRATE = (fv / pv) ^ (1 / term) - 1
END FUNCTION

'********** QPROUND
'
'This function accepts a double precision value and a number of decimal
'places to round it to, and returns the answer in a string.  The number
'must be processed as a string because many double precision values can
'not be represented accurately any other way.  To prove this, enter the
'following line into the QuickBASIC 4 editor and watch what happens:
'
'    X# = .0691#
'
'
FUNCTION QPROUND (amount As Double, places As Short) As String 'STATIC

'External routines required:  ASCII%
'                             FUsing

  Var amountS = STR$(amount)                     'first convert into a string
   
  '10-15-91: The four lines below that are now comments have been replaced
  'with the three lines that follow.  This makes QPROUND$ nearly 7 times
  'faster.  Thanks to Peter Alachi for this improvement!

  'Lead% = 1                          'allow one leading digit
  'DO WHILE ABS(Amount#) + .000001# >= 10# ^ Lead%
  '   Lead% = Lead% + 1               'the .000001# avoids a QB bug w/80x87
  'LOOP                            

  Var lead = INSTR(LTRIM$(amountS), ".")  'get the number of leading digits
  IF lead > 1 THEN lead = lead - 1
  IF lead = 0 THEN lead = LEN(LTRIM$(amountS))

  Var dec = MID$(".", ABS(places = 0) + 1)      'make a "." if needed
  Var plus = MID$("+", SGN(amount) + 2)         'make a "+" if needed
  Var mask = plus + STRING$(lead + 1, "#") + dec + STRING$(places, "#") '+1
  mask = FUsing(amountS, mask)             'let Chris do the dirty work

  IF ASCII(mask) = 48 THEN                  'if there's a leading zero
    mask = MID$(mask, 2)                   'strip it
  END IF

  QPROUND = LTRIM$(mask)                    'assign the function

END FUNCTION

FUNCTION QPSLN (cost As Double, sal As Double, life As Short) As Double 'STATIC
  QPSLN = (cost - sal) / life
END FUNCTION

'External functions required:  QPVAR#()
'                              QPSUM#() used by QPVAR#()
'
FUNCTION QPSTD (array() As Double) As Double 'STATIC
  QPSTD = SQR(QPVAR(array()))
END FUNCTION

FUNCTION QPSUM (array() As Double) As Double 'STATIC
  Var lo = LBOUND(array, 1)
  Var hi = UBOUND(array, 1)
  Var s = 0#
  FOR x As Short = lo TO hi
    s = s + array(x)
  NEXT
  QPSUM = s
END FUNCTION

FUNCTION QPSYD (cost As Double, sal As Double, life As Short, per As Short) As Double 'STATIC
  QPSYD = (cost - sal) * (life - per + 1) / (life * (life + 1) / 2#)
END FUNCTION

'External functions required:  QPSUM#()
'
FUNCTION QPVAR (array() As Double) As Double 'STATIC
  Var hi = UBOUND(array, 1)
  Var lo = LBOUND(array, 1)
  Var numItems = hi - lo + 1
  Var average = QPSUM(array()) / numItems
  Var s = 0#
  FOR x As Short = lo TO hi
    Var temp = (array(x) - average) ^ 2#   'individual deviations squared
    s = s + temp
  NEXT
  QPVAR = s / numItems
END FUNCTION