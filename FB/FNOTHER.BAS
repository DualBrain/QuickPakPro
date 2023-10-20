' ********** FNOther.Bas
' Copyright (c) 1988 Crescent Software
' Functions written by Don Malin, Paul Passarelli, and Ethan Winer
' Modifications (c) 2023 Cory Smith

#INCLUDE ONCE "PRO.BI" ' Bin2Num, InCount, Num2Bin, Num2Bin2 and QPrint0

DECLARE FUNCTION C2F(cTemp As Single) As Single
DECLARE FUNCTION Delimit (work As String, delim As String) As Short
DECLARE FUNCTION Eval (e As String) As Double
DECLARE FUNCTION ExpandTab(x As String, numSpaces As Short) As String
DECLARE FUNCTION F2C(fTemp As Single) As Single
DECLARE FUNCTION LastFirst (x As String) As String
DECLARE FUNCTION LastLast (x As String) As String
DECLARE FUNCTION Pad (x As Single, places As Short) As String
DECLARE SUB Parse (work As String, delim As String, array() As String)
DECLARE FUNCTION ParseStr (x As String) As String
DECLARE FUNCTION Rand (lo As Single, hi As Single) As Single
DECLARE FUNCTION ShrinkTab (x As String, numSpaces As Short) As String
DECLARE FUNCTION ToSigned (x As Long) As Short
DECLARE FUNCTION UnParseStr (x As String) As String
DECLARE FUNCTION ToUnSigned (x As Short) As Long

SUB PMsg ' Was originally a GOSUB/RETURN
  LOCATE 25, 1
  PRINT "Press a key ";
  WaitKey
  CLS
END SUB

'----- expanding and contracting Tabs

CLS
QPrint0 "                   12345678901234567890123456789012345678901234", -1
PRINT

Var test = CHR$(9) + CHR$(9) + "Test" + SPACE$(8) + "One, two, three."
QPrint0 "Before expanding: " + CHR$(34) + test + CHR$(34), 7
PRINT

Var numSpaces = 8                   'set tab stops every eight spaces
test = ExpandTab(test, numSpaces)
QPrint0 " After expanding: " + CHR$(34) + test + CHR$(34), 7
PRINT

test = ShrinkTab(test, numSpaces)
QPrint0 " After shrinking: " + CHR$(34) + test + CHR$(34), 7
PRINT

test = ExpandTab(test, numSpaces)
QPrint0 " After expanding: " + CHR$(34) + test + CHR$(34), 7

PMsg

'----- temperature conversion

Dim temp AS Single
INPUT "Enter a Fahrenheit temperature: ", temp
PRINT
PRINT STR$(temp); "� converted to Centigrade equals "; STR$(F2C(temp)); "�"
PRINT
PRINT STR$(F2C(temp)); "� converted back again equals "; STR$(C2F(F2C(temp))); "�"
PMsg

'----- binary conversion

Dim value AS Short
INPUT "Enter a number between -32768 and 32767: ", value
PRINT
PRINT "Num2Bin$ returns it as: "; Num2Bin(value)
PRINT " and Num2Bin2$ returns: "; Num2Bin2(value)
PRINT "Bin2Num converts it to: "; LTRIM$(STR$(Bin2Num(Num2Bin(value))))
PMsg

'----- Parse PATH into separate components

'Comments below also show how to parse COMMAND$ for one or more switches.
'Delimit% returns the value to which the array must be dimensioned, and
'Parse unpacks the string into the array

Var work = ENVIRON$("PATH")        'use this to parse the current PATH
'work = COMMAND$                    'use this for COMMAND$

Var delim = "+,;_ "                'table of some common delimiters

Var j = Delimit(work, delim) + 1   ' see how many matching delimiters there are
REDIM array(j) As String           ' +1 is needed to account for the last item

Parse work, delim, array()         ' Parse fills the array

PRINT "Your current path is:"
PRINT
PRINT TAB(5); work
PRINT
PRINT
PRINT "Broken out into each directory:"
PRINT
FOR x As Short = 1 TO j
  PRINT TAB(5); "==> "; array(x)
NEXT
END

FUNCTION C2F(degC As Single) As Single 'STATIC
  C2F = degC * 1.8 + 32
END FUNCTION

FUNCTION Delimit (work As String, delim As String) As Short 'STATIC
  Var counter = 0
  FOR x As Short = 1 TO LEN(delim)
    counter = counter + InCount(work, MID$(delim, x, 1))
  NEXT x
  Delimit = counter
END FUNCTION

FUNCTION Eval(e As String) As Double 'STATIC
  Var result = ""
  Var minusOk = 1                'a minus sign is okay only once, and only
                                 '  if it precedes the first numeric character
  Var decOk = 1                  'only the first decimal point is okay
  FOR x As Short = 1 TO LEN(e)
    var y = MID$(e, x, 1)
    IF y = "-" AND minusOk THEN
      result = result + y
      minusOk = 0
    ELSEIF y = "." AND decOk THEN
      result = result + y
      decOk = 0
    ELSEIF y >= "0" AND y <= "9" THEN
      result = result + y
      minusOk = 0
    END IF
  NEXT
  Eval = VAL(result)
END FUNCTION

FUNCTION ExpandTab(value As String, numSpaces As Short) As String 'STATIC
  Var tabs = InCount(value, CHR$(9))         'Find Number of tab Chars.
  IF tabs THEN                               'Are there any?
                                             'make room for new string
    Var work = SPACE$(LEN(value) + 1 + (numSpaces - 1) * tabs)
    LSET work = value + CHR$(0)              'Put existing string in it
                                             '  and a char. 0 for later
    Var where = 1                            'Set search position to 1
    FOR x As Short = 1 TO tabs               'Do each tab
                                             'find the next Tab character
      where = INSTR(where, work, CHR$(9)) + 1
      Var length = where - 2                 'Calc length of left part
                                             'Calc spaces to next tab stop
      Var sp = length + numSpaces - (length MOD numSpaces) - length
                                             'Insert the spaces
      IF where > 1 THEN MID$(work, where - 1) = SPACE$(sp) + MID$(work, where)
    NEXT                                     'Assign the function looking
                                             '  for the char. 0
    ExpandTab = LEFT$(work, INSTR(work, CHR$(0)) - 1)
  ELSE                                       'No tabs.  Just assign the
    ExpandTab = value                        '  function
  END IF
END FUNCTION

FUNCTION F2C (degF As Single) As Single 'STATIC
  F2C = (degF - 32) / 1.8
END FUNCTION

FUNCTION LastFirst (value As String) As String ' STATIC
  Var temp = LTRIM$(RTRIM$(value))           'first strip leading/trailing spaces
  FOR x As Short = LEN(temp) TO 1 STEP -1    'seek separating blank
    IF MID$(temp, x, 1) = " " THEN
      LastFirst = MID$(temp, x + 1) + ", " + LEFT$(temp, x - 1)
      EXIT FUNCTION
    END IF
  NEXT
END FUNCTION

FUNCTION LastLast (value As String) As String ' STATIC
  Var t = LTRIM$(RTRIM$(value))              'strip leading/trailing spaces
  Var x = INSTR(t, ",")                      'seek separating comma
  IF x = LEN(t) OR x <= 1 THEN EXIT FUNCTION 'exit now, avoid crash later
  LastLast = LTRIM$(RTRIM$(MID$(t, x + 1) + " " + LEFT$(t, x - 1)))
END FUNCTION

FUNCTION Pad (x As Single, Places As Short) As String ' STATIC
  Var t = STR$(x)                            'make a string version of the number
  IF LEN(LTRIM$(t)) > places THEN            'if after trimming a possible leading
    Pad = "%" + t                            '  blank it's too long, add a "%"
    EXIT FUNCTION                            '  to show an error and go away
  END IF
  t = MID$(t, 2)                             'discard the leading blank or "-" sign
  Pad = MID$("-", SGN(x) + 2) + STRING$(places - LEN(t) + (SGN(x) = -1), "0") + t
  '            ^add minus if needed       ^create the zeros    ^less one if negative
END FUNCTION

SUB Parse (work As String, delim As String, array() As String)
  Var beginPtr = 1
  Var element = 1
  FOR endPtr As Short = 1 TO LEN(work)
    IF INSTR(delim, MID$(work, endPtr, 1)) THEN
      array(element) = MID$(work, beginPtr, endPtr - beginPtr)
      element = element + 1
      beginPtr = endPtr + 1
    END IF
  NEXT
  array(element) = MID$(work, beginPtr)
END SUB

'This function accepts a string of the form "12, 34, 56" and returns it
'packed as CHR$(12) + CHR$(34) + CHR$(56) -- it is intended for parsing
'printer codes entered by a user.
'
FUNCTION ParseStr (x As String) As String 'STATIC
  Var comma = 0
  Dim code As String
  DO
    code = code + CHR$(VAL(MID$(x, comma + 1)))
    comma = INSTR(comma + 1, x, ",")
  LOOP WHILE comma
  ParseStr = code
  code = ""
END FUNCTION

FUNCTION Rand (lo As Single, hi As Single) As Single 'STATIC
  RANDOMIZE TIMER
  Rand = RND(1) * (hi - lo) + lo
END FUNCTION

FUNCTION ShrinkTab (x As String, numSpaces As Short) As String 'STATIC
  Var work = x
  Var ps = 1
  Var psNew = 1
  DO
    ps = INSTR(ps, work, SPACE$(numSpaces))
    IF ps = 0 THEN EXIT DO
    psNew = INSTR(psNew, work, SPACE$(numSpaces))
    Var tabStop = (((ps - 1) \ numSpaces) * numSpaces) + 8
    work = LEFT$(work, psNew - 1) + CHR$(9) + MID$(work, tabStop + 1)
    ps = tabStop + 1
    psNew = psNew + 1
  LOOP
  ShrinkTab = work                          'assign the expanded string
END FUNCTION

FUNCTION ToSigned (x As Long) As Short 'STATIC
  IF x > 32767 THEN
    ToSigned = X - 65536
  ELSE
    ToSigned = X
  END IF
END FUNCTION

' This function accepts a string of the form CHR$(12) + CHR$(34) + CHR$(56)
' and unpacks it to "12,34,56" - it is intended as a complement to ParseStr$
' and allows printer codes already packed to be unpacked and edited.  The
' comment below shows how to add a space if you'd like to get "12, 34, 56".
'
FUNCTION UnParseStr (value As String) As String ' STATIC
  Dim temp As String
  FOR x As Short = 1 TO LEN(value)
    temp = temp + MID$(STR$(ASC(MID$(value, x, 1))), 2)
    IF x < LEN(value) THEN temp = temp + ","
    '                                use ", " to add a space after commas
  NEXT
  UnParseStr = temp
  temp = ""
END FUNCTION

FUNCTION ToUnSigned (x As Short) As Long 'STATIC
  IF x < 0 THEN
    ToUnSigned = x + 65536
  ELSE
    ToUnSigned = x
  END IF
END FUNCTION