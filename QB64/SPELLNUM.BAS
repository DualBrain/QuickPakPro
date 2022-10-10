' ********** SPELLNUM.BAS - Creates a spelled out version of a number

' Copyright (c) 1989 Don Malin
' Copyright (c) 1989 Crescent Software
' Modifications (c) 2022 Cory Smith

DEFINT A-Z

' ----- Look up tables for number words

CONST SPELLNUM_NUMS$ = "123456789"
CONST SPELLNUM_NAMES$ = "One  Two  ThreeFour Five Six  SevenEightNine Ten"
CONST SPELLNUM_TEENS$ = "Eleven    Twelve    Thirteen  Fourteen  Fifteen   Sixteen   Seventeen Eighteen  Nineteen"
CONST SPELLNUM_TENS$ = "Ten     Twenty  Thirty  Forty   Fifty   Sixty   Seventy Eighty  Ninety"
CONST SPELLNUM_POWERS$ = "Thousand Million  Billion  Trillion"

DECLARE FUNCTION FUsing$ (number$, mask$)
DECLARE FUNCTION SpellNumber$ (number$)

' --- Remove the following example code before adding this to your own program.

CLS                                             ' Clear the screen

mask$ = "###############.##"                    ' Make a mask for "FUsing$"

INPUT "Enter amount for check: ", amount#       ' Get a number from user
num$ = FUsing$(STR$(amount#), mask$)            ' Format the number into a $
PRINT SpellNumber$(num$);                       ' Print the whole number part

PRINT " Dollar";                                ' Let's do dollars and cents
IF INT(VAL(num$)) <> 1 THEN PRINT "s";          ' Anything but "One" is plural
PRINT " and "; MID$(num$, INSTR(num$, ".") + 1); " Cents"  ' Do cents part

' Returns a spelled out version of a number
FUNCTION SpellNumber$ (strNum$) STATIC

  SpellNumber$ = ""                           ' Clear the function
  num$ = LTRIM$(RTRIM$(strNum$))              ' Trim off any spaces

  x = INSTR(num$, ".")                        ' Trim off any decimal places
  IF x THEN num$ = LEFT$(num$, x - 1)
    
  length = LEN(num$)                          ' Get the length
  IF length > 15 THEN EXIT FUNCTION           ' Exit if bigger than trillions

  FOR n = length TO 1 STEP -1                 ' Step backwards through number

    x = INSTR(SPELLNUM_NUMS$, MID$(num$, n, 1)) - 1  ' Look up the digit in table

    SELECT CASE (length - n) MOD 3            ' Branch according to digit position

      CASE 0 '----- Ones digit
        IF n < length THEN                    ' If not on last digit, look for non 0 digit
          FOR temp = n TO n - 2 STEP -1    
            IF temp > 0 THEN                  ' If not past end of number
              word$ = MID$(num$, temp, 1)
              IF word$ <> "0" AND word$ <> "-" THEN ' If this is a non 0 digit, put power word in sentence
                temp = ((length - n) \ 3 - 1) * 9 + 1
                word$ = RTRIM$(MID$(SPELLNUM_POWERS$, temp, 9))
                sentence$ = word$ + " " + sentence$
                EXIT FOR                      ' Bail out of search loop
              END IF
            END IF
          NEXT
        END IF
        IF x > -1 THEN                        ' If digit found, get the word
          word$ = MID$(SPELLNUM_NAMES$, x * 5 + 1, 5)
          IF n > 1 THEN                       ' If left digit is one, use "Teen" table
            IF MID$(num$, n - 1, 1) = "1" THEN
              word$ = MID$(SPELLNUM_TEENS$, x * 10 + 1, 10)
              n = n - 1                       ' Skip the Tens digit
            END IF
          END IF
        END IF
         
      CASE 1 ' ----- Tens digit
        IF x > -1 THEN                        ' Find word in "Tens" table
          word$ = MID$(SPELLNUM_TENS$, x * 8 + 1, 8)
        END IF
          
      CASE 2 ' ----- Hundreds digit
        IF x > -1 THEN                        ' Find word in number table
          word$ = MID$(SPELLNUM_NAMES$, x * 5 + 1, 5)
          word$ = RTRIM$(word$) + " Hundred"  ' Add the word "Hundred"
        END IF

    END SELECT

    IF n = 1 AND x = -1 THEN                  ' Look for a minus sign at
      IF MID$(num$, n, 1) = "-" THEN          ' digit one
        word$ = "Negative"                    ' Add it to sentence
        x = 0
      END IF
    END IF
                                              ' If digit is non zero, add
                                              ' the word to the sentence
    IF x > -1 THEN sentence$ = RTRIM$(word$) + " " + sentence$

  NEXT

  SpellNumber$ = RTRIM$(sentence$)            ' Assign the function

  num$ = ""                                   ' Clean up work strings
  word$ = ""
  sentence$ = ""

END FUNCTION

'$INCLUDE: 'QPPRO.BAS'