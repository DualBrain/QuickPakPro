' *********** PRO.BAS - added value functionality for QB64
'                       inspired by QuickPak Professional 
'                       for QB45/PDS71/VBDOS10

' Copyright (c) 2022 Cory Smith

DEFINT A-Z

' ****************************************
' Chapter 2 - Array Routines 
' ****************************************

' AddInt adds a constant value to all of the elements in 
' a specified portion of an integer array.
SUB AddInt(array(), start, value, numEls)
  IF start = 0 THEN EXIT SUB
  FOR x = start TO start + numEls - 1
    array(x) = array(x) + value
  NEXT
END SUB

' DeleteStr removes an element from a normal (not 
' fixed-length) string array.
SUB DeleteStr(elements$(), element, numEls)
  e = element + numEls
  IF e => UBOUND(elements$) THEN e = UBOUND(elements$) - 1
  FOR x = element TO e
    SWAP elements$(x), elements$(x + 1) 
  NEXT 
END SUB

' DeleteT removes an element from a fixed-length string, numeric, or 
' user-defined TYPE array. 
SUB DeleteT(array() AS FLen, element, elSize, numEls)
  'NOTE: elSize is currently ignored since we are working directly with an included type.
  e = element + numEls
  IF e => UBOUND(array) THEN e = UBOUND(array) - 1
  FOR x = element TO e
    SWAP array(x), array(x + 1) 
  NEXT 
END SUB

' Fill2 will quickly assign all of the elements in a specified portion of 
' an integer array to any value. 
SUB Fill2(array(), start, value, numEls)
  FOR x = start TO start + numEls - 1
    array(x) = value
  NEXT
END SUB

' Fill4 will quickly assign all of the elements in a specified portion of 
' an single array to any value. 
SUB Fill4(array!(), start, value!, numEls)
  FOR x = start TO start + numEls - 1
    array!(x) = value!
  NEXT
END SUB

' Fill8 will quickly assign all of the elements in a specified portion of 
' an double array to any value. 
SUB Fill8(array#(), start, value#, numEls)
  FOR x = start TO start + numEls - 1
    array#(x) = value#
  NEXT
END SUB

SUB Find(array$(), start, numEls, searchValue$)
  c = 0
  FOR x = start TO start + numEls - 1
    IF QInstr(1, array$(x), searchValue$) THEN
      numEls = c: EXIT FUNCTION
    END IF
    c = c + 1
  NEXT
  numEls = -1
END SUB

SUB Find2(array$(), start, numEls, searchValue$)
  c = 0
  FOR x = start TO start + numEls - 1
    IF QInstr2(1, array$(x), searchValue$) THEN
      numEls = c: EXIT FUNCTION
    END IF
    c = c + 1
  NEXT
  numEls = -1
END SUB

SUB FindB(array$(), start, curEl, searchValue$)
  max = start
  min = start - curEl + 1
  FOR x = max TO min STEP -1
    IF QInstr(1, array$(x), searchValue$) THEN
      curEl = x: EXIT FUNCTION
    END IF
  NEXT
  curEl = -1
END SUB

SUB FindB2(array$(), start, curEl, searchValue$)
  max = start
  min = start - curEl + 1
  FOR x = max TO min STEP -1
    IF QInstr2(1, array$(x), searchValue$) THEN
      curEl = x: EXIT FUNCTION
    END IF
  NEXT
  curEl = -1
END SUB

SUB FindExact(array$(), start, numEls, searchValue$)
  c = 0
  FOR x = start TO start + numEls - 1
    IF INSTR(1, array$(x), searchValue$) THEN
      numEls = c: EXIT FUNCTION
    END IF
    c = c + 1
  NEXT
  numEls = -1
END SUB

SUB FindT(array() AS FLen, Start, ElSize, NumEls, SearchValue$)
  NumEls = -1
  ERROR 73 ' Feature Unavailable
END SUB

SUB FindT2(Array() AS FLen, Start, ElSize, NumEls, SearchValue$)
  NumEls = -1
  ERROR 73 ' Feature Unavailable
END SUB

SUB FindTB(Array() AS FLen, Start, ElSize, CurEl, SearchValue$)
  CurEl = -1
  ERROR 73 ' Feature Unavailable
END SUB

SUB FindTB2(Array() AS FLen, Start, ElSize, CurEl, SearchValue$)
  CurEl = -1
  ERROR 73 ' Feature Unavailable
END SUB

' FindLast scans a conventional (not fixed-length) string array 
' backwards looking for the last non-blank element. 
FUNCTION FindLast (array$(), last, size)
  FOR x = last TO last - size + 1 STEP - 1
    IF array$(x) <> "" THEN
      FindLast = x: EXIT FUNCTION
    END IF
  NEXT
  FindLast = -1
END FUNCTION

FUNCTION GetBit(array$, element)
  ' NOTE: Not sure if this matches the original QPPro implementation.
  entry = (element \ 8) + 1
  bit = element MOD 8
  byt = ASC(MID$(array$, entry, 1))
  test = 2 ^ bit
  IF (byt AND test) = test THEN
    GetBit = -1
  ELSE 
    GetBit = 0
  END IF
END FUNCTION

SUB SetBit(array$, element, value)
  ' NOTE: Not sure if this matches the original QPPro implementation.
  entry = (element \ 8) + 1
  bit = element MOD 8
  byt = ASC(MID$(array$, entry, 1))
  IF value THEN
    byt = byt XOR (2 ^ bit)
  ELSE 
    byt = byt AND NOT (2 ^ bit)
  END IF
  MID$(array$, entry, 1) = CHR$(byt)
END SUB

FUNCTION IMaxD(array#(), start, numEls)
  max# = array#(start): entry = start
  FOR x = start + 1 TO start + numEls - 1
    IF array#(x) > max# THEN max# = array#(x): entry = x
  NEXT
  IMaxD = entry - start
END FUNCTION

FUNCTION IMaxI(array(), start, numEls)
  max = array(start): entry = start
  FOR x = start + 1 TO start + numEls - 1
    IF array(x) > max THEN max = array(x): entry = x
  NEXT
  IMaxI = entry - start
END FUNCTION

FUNCTION IMaxL(array&(), start, numEls)
  max& = array&(start): entry = start
  FOR x = start + 1 TO start + numEls - 1
    IF array&(x) > max& THEN max& = array&(x): entry = x
  NEXT
  IMaxL = entry - start
END FUNCTION

FUNCTION IMaxS(array!(), start, numEls)
  max! = array!(start): entry = start
  FOR x = start + 1 TO start + numEls - 1
    IF array!(x) > max! THEN max! = array!(x): entry = x
  NEXT
  IMaxS = entry - start
END FUNCTION

FUNCTION IMaxC(array!(), start, numEls)
  max! = array!(start): entry = start
  FOR x = start + 1 TO start + numEls - 1
    IF array!(x) > max! THEN max! = array!(x): entry = x
  NEXT
  IMaxC = entry - start
END FUNCTION

FUNCTION IMinD(array#(), start, numEls)
  min# = array#(start): entry = start
  FOR x = start + 1 TO start + numEls - 1
    IF array#(x) < min# THEN min# = array#(x): entry = x
  NEXT
  IMinD = entry - start
END FUNCTION

FUNCTION IMinI(array(), start, numEls)
  min = array(start): entry = start
  FOR x = start + 1 TO start + numEls - 1
    IF array(x) < min THEN min = array(x): entry = x
  NEXT
  IMinI = entry - start
END FUNCTION

FUNCTION IMinL(array&(), start, numEls)
  min& = array&(start): entry = start
  FOR x = start + 1 TO start + numEls - 1
    IF array&(x) < min& THEN min& = array&(x): entry = x
  NEXT
  IMinL = entry - start
END FUNCTION

FUNCTION IMinS(array!(), start, numEls)
  min! = array!(start): entry = start
  FOR x = start + 1 TO start + numEls - 1
    IF array!(x) < min! THEN min! = array!(x): entry = x
  NEXT
  IMinS = entry - start
END FUNCTION

FUNCTION IMinC(array!(), start, numEls)
  min! = array!(start): entry = start
  FOR x = start + 1 TO start + numEls - 1
    IF array!(x) < min! THEN min! = array!(x): entry = x
  NEXT
  IMinC = entry - start
END FUNCTION

SUB InitInt(array(), start, value, numEls)
  v = value
  FOR x = start TO start + numEls - 1
    array(x) = v: v = v + 1
  NEXT
END SUB

' InsertStr will insert an element at any point into a conventional (not 
' fixed-length) string array. 
SUB InsertStr(array$(), startElement, insertValue$, numEls)
  FOR x = startElement + numEls - 1 TO startElement + 1 STEP -1 
    SWAP array$(x), array$(x - 1) 
  NEXT 
  SWAP array$(startElement), insertValue$ 
END SUB

SUB InsertT(array() AS FLen, startElement, elSize, numEls)
  FOR x = startElement + numEls - 1 TO startElement + 1 STEP -1
    array(x) = array(x - 1)
  NEXT
END SUB

SUB ISortD(array#(), start, ndx(), numEls, dir)
  
  ' Determine range of elements

  min = start
  max = start + numEls - 1

  ' Initialize the ndx() array
  FOR i = min TO max
    ndx(i) = i
  NEXT

  ' Sort the ndx using array# values

  FOR i = min TO max
    FOR j = min TO max - i 
      IF dir THEN ' descending
        IF array#(ndx(j)) < array#(ndx(j + 1)) THEN 
          SWAP ndx(j), ndx(j + 1) 
        END IF
      ELSE ' ascending
        IF array#(ndx(j)) > array#(ndx(j + 1)) THEN 
          SWAP ndx(j), ndx(j + 1) 
        END IF
      END IF
    NEXT
  NEXT

END SUB

SUB ISortI(array(), start, ndx(), numEls, dir)

  ' Determine range of elements

  min = start
  max = start + numEls - 1

  ' Initialize the ndx() array
  FOR i = min TO max
    ndx(i) = i
  NEXT

  ' Sort the ndx using array values

  FOR i = min TO max
    FOR j = min TO max - i 
      IF dir THEN ' descending
        IF array(ndx(j)) < array(ndx(j + 1)) THEN 
          SWAP ndx(j), ndx(j + 1) 
        END IF
      ELSE ' ascending
        IF array(ndx(j)) > array(ndx(j + 1)) THEN 
          SWAP ndx(j), ndx(j + 1) 
        END IF
      END IF
    NEXT
  NEXT

END SUB

SUB ISortL(array&(), start, ndx(), numEls, dir)

  ' Determine range of elements

  min = start
  max = start + numEls - 1

  ' Initialize the ndx() array
  FOR i = min TO max
    ndx(i) = i
  NEXT

  ' Sort the ndx using array& values

  FOR i = min TO max
    FOR j = min TO max - i 
      IF dir THEN ' descending
        IF array&(ndx(j)) < array&(ndx(j + 1)) THEN 
          SWAP ndx(j), ndx(j + 1) 
        END IF
      ELSE ' ascending
        IF array&(ndx(j)) > array&(ndx(j + 1)) THEN 
          SWAP ndx(j), ndx(j + 1) 
        END IF
      END IF
    NEXT
  NEXT

END SUB

SUB ISortS(array!(), start, ndx(), numEls, dir)

  ' Determine range of elements

  min = start
  max = start + numEls - 1

  ' Initialize the ndx() array
  FOR i = min TO max
    ndx(i) = i
  NEXT

  ' Sort the ndx using array! values

  FOR i = min TO max
    FOR j = min TO max - i 
      IF dir THEN ' descending
        IF array!(ndx(j)) < array!(ndx(j + 1)) THEN 
          SWAP ndx(j), ndx(j + 1) 
        END IF
      ELSE ' ascending
        IF array!(ndx(j)) > array!(ndx(j + 1)) THEN 
          SWAP ndx(j), ndx(j + 1) 
        END IF
      END IF
    NEXT
  NEXT

END SUB

SUB ISortC(array!(), start, ndx(), numEls, dir)

  ' Determine range of elements

  min = start
  max = start + numEls - 1

  ' Initialize the ndx() array
  FOR i = min TO max
    ndx(i) = i
  NEXT

  ' Sort the ndx using array! values

  FOR i = min TO max
    FOR j = min TO max - i 
      IF dir THEN ' descending
        IF array!(ndx(j)) < array!(ndx(j + 1)) THEN 
          SWAP ndx(j), ndx(j + 1) 
        END IF
      ELSE ' ascending
        IF array!(ndx(j)) > array!(ndx(j + 1)) THEN 
          SWAP ndx(j), ndx(j + 1) 
        END IF
      END IF
    NEXT
  NEXT

END SUB

SUB ISortStr(array$(), start, ndx(), numEls, dir)

  ' Determine range of elements

  min = start
  max = start + numEls - 1

  ' Initialize the ndx() array
  FOR i = min TO max
    ndx(i) = i
  NEXT

  ' Sort the ndx using array! values

  FOR i = min TO max
    FOR j = min TO max - i 
      IF dir THEN ' descending
        IF array$(ndx(j)) < array$(ndx(j + 1)) THEN 
          SWAP ndx(j), ndx(j + 1) 
        END IF
      ELSE ' ascending
        IF array$(ndx(j)) > array$(ndx(j + 1)) THEN 
          SWAP ndx(j), ndx(j + 1) 
        END IF
      END IF
    NEXT
  NEXT

END SUB

SUB ISortStr2(Array$(), Start, Ndx(), NumEls, Dir)

  ' Determine range of elements

  min = start
  max = start + numEls - 1

  ' Initialize the ndx() array
  FOR i = min TO max
    ndx(i) = i
  NEXT

  ' Sort the ndx using array! values

  FOR i = min TO max
    FOR j = min TO max - i 
      IF dir THEN ' descending
        IF LCASE$(array$(ndx(j))) < LCASE$(array$(ndx(j + 1))) THEN 
          SWAP ndx(j), ndx(j + 1) 
        END IF
      ELSE ' ascending
        IF LCASE$(array$(ndx(j))) > LCASE$(array$(ndx(j + 1))) THEN 
          SWAP ndx(j), ndx(j + 1) 
        END IF
      END IF
    NEXT
  NEXT

END SUB

SUB ISortT(Array() AS FLen, Start, Ndx(), NumEls, Dir, ElSize, MemberOffset, MemberSize)
  ERROR 73 ' Feature Unavailable
END SUB

SUB ISortT2(Array() AS FLen, Start, Ndx(), NumEls, Dir, ElSize, MemberOffset, MemberSize)
  ERROR 73 ' Feature Unavailable
END SUB

SUB KeySort(Array() AS FLen, Start, ElSize, NumEls, Table(,), NumKey)
  ERROR 73 ' Feature Unavailable
END SUB

FUNCTION MaxD#(array#(), start, numEls)
  max# = array#(start)
  FOR x = start + 1 TO numEls
    IF array#(x) > max# THEN max# = array#(x)
  NEXT
  MaxD# = max#
END FUNCTION

FUNCTION MaxI(array(), start, numEls)
  max = array(start)
  FOR x = start + 1 TO numEls
    IF array(x) > max THEN max = array(x)
  NEXT
  MaxI = max
END FUNCTION

FUNCTION MaxL&(array&(), start, numEls)
  max& = array&(start)
  FOR x = start + 1 TO numEls
    IF array&(x) > max& THEN max& = array&(x)
  NEXT
  MaxL& = max&
END FUNCTION

FUNCTION MaxS!(array!(), start, numEls)
  max! = array!(start)
  FOR x = start + 1 TO numEls
    IF array!(x) > max! THEN max! = array!(x)
  NEXT
  MaxS! = max!
END FUNCTION

FUNCTION MaxC!(array!(), start, numEls)
  max! = array!(start)
  FOR x = start + 1 TO numEls
    IF array!(x) > max! THEN max! = array!(x)
  NEXT
  MaxC! = max!
END FUNCTION

FUNCTION MinD#(array#(), start, numEls)
  min# = array#(start)
  FOR x = start + 1 TO numEls
    IF array#(x) < min# THEN min# = array#(x)
  NEXT
  MinD# = min#
END FUNCTION

FUNCTION MinI(array(), start, numEls)
  min = array(start)
  FOR x = start + 1 TO numEls
    IF array(x) < min THEN min = array(x)
  NEXT
  MinI = min
END FUNCTION

FUNCTION MinL&(array&(), start, numEls)
  min& = array&(start)
  FOR x = start + 1 TO numEls
    IF array&(x) < min& THEN min& = array&(x)
  NEXT
  MinL& = min&
END FUNCTION

FUNCTION MinS!(array!(), start, numEls)
  min! = array!(start)
  FOR x = start + 1 TO numEls
    IF array!(x) < min! THEN min! = array!(x)
  NEXT
  MinS! = min!
END FUNCTION

FUNCTION MinC!(array!(), start, numEls)
  min! = array!(Start)
  FOR x = start + 1 TO numEls
    IF array!(x) < min! THEN min! = array!(x)
  NEXT
  MinC! = min!
END FUNCTION

SUB SearchD(array#(), start, numEls, match, found, direction, matchCode, varType)

  c = 0

  min = start
  max = start + numEls - 1
  IF NOT direction THEN inc = 1 ELSE inc = -1: SWAP min, max

  SELECT CASE matchCode
    CASE 0 ' find an exact match only
      FOR i = min TO max STEP inc
        c = c + 1
        IF array#(i) = match THEN found = c: EXIT SUB
      NEXT
    CASE 1 ' match if the element is greater or equal
      FOR i = min TO max STEP inc
        c = c + 1
        IF array#(i) => match THEN found = c: EXIT SUB
      NEXT
    CASE -1 ' match if the element is less or equal 
      FOR i = min TO max STEP inc
        c = c + 1
        IF array#(i) =< match THEN found = c: EXIT SUB
      NEXT
    CASE ELSE
      found = 0
  END SELECT

END SUB

SUB Search(array(), start, numEls, match, found, direction, matchCode, varType)

  c = 0

  min = start
  max = start + numEls - 1
  IF NOT direction THEN inc = 1 ELSE inc = -1: SWAP min, max

  SELECT CASE matchCode
    CASE 0 ' find an exact match only
      FOR i = min TO max STEP inc
        c = c + 1
        IF array(i) = match THEN found = c: EXIT SUB
      NEXT
    CASE 1 ' match if the element is greater or equal
      FOR i = min TO max STEP inc
        c = c + 1
        IF array(i) => match THEN found = c: EXIT SUB
      NEXT
    CASE -1 ' match if the element is less or equal 
      FOR i = min TO max STEP inc
        c = c + 1
        IF array(i) =< match THEN found = c: EXIT SUB
      NEXT
    CASE ELSE
      found = 0
  END SELECT

END SUB

SUB SearchT(Array() AS FLen, Start, NumEls, Match, Found, Dir, Code, StructSize, MemberOf, MemberSize)
  ERROR 73 ' Feature Unavailable
END SUB

SUB SearchT2(Array() AS FLen, Start, NumEls, Match, Found, Dir, Code, StructSize, MemberOf, MemberSize)
  ERROR 73 ' Feature Unavailable
END SUB

SUB SortD(array#(), start, numEls, dir)

  min = start
  max = start + numEls - 1

  FOR i = min TO max
    FOR j = min TO max - i 
      IF dir THEN ' descending
        IF array#(j) < array#(j + 1) THEN 
          SWAP array#(j), array#(j + 1) 
        END IF
      ELSE ' ascending
        IF array#(j) > array#(j + 1) THEN 
          SWAP array#(j), array#(j + 1) 
        END IF
      END IF
    NEXT
  NEXT

END SUB

SUB SortI(array(), start, numEls, dir)

  min = start
  max = start + numEls - 1

  FOR i = min TO max
    FOR j = min TO max - i 
      IF dir THEN ' descending
        IF array(j) < array(j + 1) THEN 
          SWAP array(j), array(j + 1) 
        END IF
      ELSE ' ascending
        IF array(j) > array(j + 1) THEN 
          SWAP array(j), array(j + 1) 
        END IF
      END IF
    NEXT
  NEXT

END SUB

SUB SortL(array&(), start, numEls, dir)

  min = start
  max = start + numEls - 1

  FOR i = min TO max
    FOR j = min TO max - i 
      IF dir THEN ' descending
        IF array&(j) < array&(j + 1) THEN 
          SWAP array&(j), array&(j + 1) 
        END IF
      ELSE ' ascending
        IF array&(j) > array&(j + 1) THEN 
          SWAP array&(j), array&(j + 1) 
        END IF
      END IF
    NEXT
  NEXT

END SUB

SUB SortS(array!(), start, numEls, dir)

  min = start
  max = start + numEls - 1

  FOR i = min TO max
    FOR j = min TO max - i 
      IF dir THEN ' descending
        IF array!(j) < array!(j + 1) THEN 
          SWAP array!(j), array!(j + 1) 
        END IF
      ELSE ' ascending
        IF array!(j) > array!(j + 1) THEN 
          SWAP array!(j), array!(j + 1) 
        END IF
      END IF
    NEXT
  NEXT

END SUB

SUB SortC(array!(), start, numEls, dir)

  min = start
  max = start + numEls - 1

  FOR i = min TO max
    FOR j = min TO max - i 
      IF dir THEN ' descending
        IF array!(j) < array!(j + 1) THEN 
          SWAP array!(j), array!(j + 1) 
        END IF
      ELSE ' ascending
        IF array!(j) > array!(j + 1) THEN 
          SWAP array!(j), array!(j + 1) 
        END IF
      END IF
    NEXT
  NEXT

END SUB

' SortStr will sort (case-sensitive) all or just a portion of a conventional (not 
' fixed-length) string array into either ascending or descending order. 
SUB SortStr(array$(), startElement, numOfElements, dir)
  ' start is the first element to be included in the sort, 
  ' numEls is the number of elements to consider, and dir 
  ' indicates the sort direction. If dir is set to zero, then the sorting 
  ' will be forward (ascending). Any other value will cause sorting to 
  ' be performed backward (descending). 

  REDIM qStack(500)    ' create stack

  s = 1                ' initialize work variables
  f = startElement
  max = startElement + numOfElements - 1
  l = max

L1:
  temp$ = array$((l + f) \ 2)         ' seek midpoint
  i = f
  j = l

L2:
  IF dir = 0 THEN
    WHILE array$(i) < temp$: i = i + 1: WEND ' use > for descending
    WHILE array$(j) > temp$: j = j - 1: WEND ' use < for descending
  ELSE
    WHILE array$(i) > temp$: i = i + 1: WEND
    WHILE array$(j) < temp$: j = j - 1: WEND
  END IF
  IF i > j GOTO L3
  IF i < j THEN 
    'PRINT "swap"
    SWAP array$(i), array$(j)
  END IF
  i = i + 1: j = j - 1
  IF i <= j GOTO L2

L3:
  IF i < l THEN
    'PRINT "push"
    qStack(s) = i             ' Push I, L
    qStack(s + 1) = l
    s = s + 2
  END IF

  l = j
  IF f < l GOTO L1
  IF s = 1 GOTO L4
  'PRINT "pop"
  s = s - 2                   ' Pop L, F
  f = qStack(s)
  l = qStack(s + 1)
  GOTO L1

L4:
  ERASE qStack                ' delete the temporary stack array

END SUB

' SortStr2 will sort (case-insensitive) all or just a portion of a conventional (not 
' fixed-length) string array into either ascending or descending order. 
SUB SortStr2(array$(), startElement, numOfElements, dir)

  REDIM qStack(500)     ' create stack

  s = 1                ' initialize work variables
  f = startElement
  l = startElement + numOfElements - 1

L1:
  temp$ = UCASE$(array$((l + f) \ 2))         ' seek midpoint
  i = f
  j = l

L2:
  IF dir = 0 THEN
    WHILE UCASE$(array$(i)) < temp$: i = i + 1: WEND    ' use > for descending
    WHILE UCASE$(array$(j)) > temp$: j = j - 1: WEND    ' use < for descending
  ELSE
    WHILE UCASE$(array$(i)) > temp$: i = i + 1: WEND    ' use > for descending
    WHILE UCASE$(array$(j)) < temp$: j = j - 1: WEND    ' use < for descending
  END IF
  IF i > j GOTO L3
  IF i < j THEN SWAP array$(i), array$(j)
  i = i + 1: j = j - 1
  IF i <= j GOTO L2

L3:
  IF i < l THEN
    qStack(s) = i             ' Push I, L
    qStack(s + 1) = l
    s = s + 2
  END IF

  l = j
  IF f < l GOTO L1
  IF s = 1 GOTO L4
  s = s - 2                   ' Pop L, F
  f = qStack(s)
  l = qStack(s + 1)
  GOTO L1

L4:
  ERASE qStack                ' delete the temporary stack array

END SUB

SUB SortT(Array() AS FLen, Start, NumEls, Dir, ElSize, MemberOffset, MemberSize)
  ERROR 73 ' Feature Unavailable
END SUB

SUB SortT2(Array() AS FLen, Start, NumEls, Dir, ElSize, MemberOffset, MemberSize)
  ERROR 73 ' Feature Unavailable
END SUB

' ****************************************
' Chapter 3 - DOS Services
' ****************************************

SUB CDir(NewDir$)
  CHDIR NewDir$
END SUB

SUB ClipFile(FileName$, NewLength&)
  ERROR 73 ' Feature Unavailable
END SUB

' Disklnfo calls on DOS to examine a disk, and reports its 
' sector and cluster makeup. 
SUB DiskInfo(drive$, bytes, sectors, freeClusters&, totalClusters&)
 ' Drive$ contains the letter of the drive to examine, and Bytes% returns 
 ' how many bytes each sector holds. Sectors% contains the number of sectors 
 ' in each disk cluster, FreeClusters& tells how many of them are available, 
 ' and Total Clusters& indicates the total disk capacity. 
  path$ = drive$
  IF INSTR(_OS$, "[WINDOWS]") THEN
    IF LEN(path$) = 1 THEN path$ = path$ + ":\"
    result& = GetDiskFreeSpace(_OFFSET(path$), _OFFSET(bytes), _OFFSET(sectors), _OFFSET(freeClusters&), _OFFSET(totalClusters&))
    IF result& = 0 THEN ' Failed
      bytes = 0
      sectors = 0
      freeClusters& = 0
      totalClusters& = 0
      'TODO: Need to set DOSError.

      ' A note regarding how to calculate the total free bytes...
      ' freeBytes& = sectors * bytes * freeClusters&

    ELSE 
      'NOTE: Appears to not be working due to (guessing)
      '      lack of "very large" drive support in GetDiskFreeSpaceA;
      '      may have to switch to use GetDiskFreeSpaceExA possibly
      '      combined with GetDiskFreeSpaceA???
    END IF
  ELSE
    ERROR 73 ' Feature Unavailable
  END IF
END SUB

' DiskRoom returns the number of bytes that are 
' currently available on a specified disk drive. 
FUNCTION DiskRoom&(Drive$)
  ' Drive$ contains either an upper or lower case letter for the disk 
  ' drive being examined, or is null to indicate the default drive. Room 
  ' is assigned the number of available bytes. 
  ERROR 73 ' Feature Unavailable
END FUNCTION

' DiskSize returns the total capacity in bytes of a specified disk drive. 
FUNCTION DiskSize&(Drive$)
  ' Drive$ contains an upper or lower case letter for the disk drive 
  ' being examined, or is null to indicate the default drive. Size is 
  ' assigned the total number of bytes the disk can hold.
  ERROR 73 ' Feature Unavailable
END FUNCTION

' DOSError reports if an error occurred during the last call to a 
' QuickPak Professional DOS routine.
FUNCTION DosError
  ' DOSError% returns O if there was no error, or -1 if there was. 
  DosError = 0 ' No error.
END FUNCTION

' DOSVer returns the version of DOS that is presently 
' running on the host PC. 
FUNCTION DOSVer
  DOSVer = 611 ' Fixed as DOS 6.11
END FUNCTION

' ErrorMsg returns an appropriate message given 
' any of the BASIC error numbers for a DOS service. 
FUNCTION ErrorMsg$(ErrorNumber)
  SELECT CASE ErrorNumber
    CASE 1: ErrorMsg$ = "NEXT without FOR"
    CASE 2: ErrorMsg$ = "Syntax error"
    CASE 3: ErrorMsg$ = "RETURN without GOSUB"
    CASE 4: ErrorMsg$ = "Out of DATA"
    CASE 5: ErrorMsg$ = "Illegal function call"
    CASE 6: ErrorMsg$ = "Overflow"
    CASE 7: ErrorMsg$ = "Out of memory"
    CASE 8: ErrorMsg$ = "Label not defined"
    CASE 9: ErrorMsg$ = "Subscript out of range"
    CASE 10: ErrorMsg$ = "Duplicate definition"
    CASE 11: ErrorMsg$ = "Division by zero"
    CASE 12: ErrorMsg$ = "Illegal in direct mode"
    CASE 13: ErrorMsg$ = "Type mismatch"
    CASE 14: ErrorMsg$ = "Out of string space"
    CASE 16: ErrorMsg$ = "String formula too complex"
    CASE 17: ErrorMsg$ = "Cannot continue"
    CASE 18: ErrorMsg$ = "Function not defined"
    CASE 19: ErrorMsg$ = "No RESUME"
    CASE 20: ErrorMsg$ = "RESUME without error"
    CASE 24: ErrorMsg$ = "Device timeout"
    CASE 25: ErrorMsg$ = "Device fault"
    CASE 26: ErrorMsg$ = "FOR without NEXT"
    CASE 27: ErrorMsg$ = "Out of paper"
    CASE 29: ErrorMsg$ = "WHILE without WEND"
    CASE 30: ErrorMsg$ = "WEND without WHILE"
    CASE 33: ErrorMsg$ = "Duplicate label"
    CASE 35: ErrorMsg$ = "Subprogram not defined"
    CASE 37: ErrorMsg$ = "Argument-count mismatch"
    CASE 38: ErrorMsg$ = "Array not defined"
    CASE 40: ErrorMsg$ = "Variable required"
    CASE 50: ErrorMsg$ = "FIELD overflow"
    CASE 51: ErrorMsg$ = "Internal error"
    CASE 52: ErrorMsg$ = "Bad file name or number"
    CASE 53: ErrorMsg$ = "File not found"
    CASE 54: ErrorMsg$ = "Bad file mode"
    CASE 55: ErrorMsg$ = "File already open"
    CASE 56: ErrorMsg$ = "FIELD statement active"
    CASE 57: ErrorMsg$ = "Device I/O error"
    CASE 58: ErrorMsg$ = "File already exists"
    CASE 59: ErrorMsg$ = "Bad record length"
    CASE 61: ErrorMsg$ = "Disk full"
    CASE 62: ErrorMsg$ = "Input past end of file"
    CASE 63: ErrorMsg$ = "Bad record number"
    CASE 64: ErrorMsg$ = "Bad file name"
    CASE 67: ErrorMsg$ = "Too many files"
    CASE 68: ErrorMsg$ = "Device unavailable"
    CASE 69: ErrorMsg$ = "Communication-buffer overflow"
    CASE 70: ErrorMsg$ = "Permission denied"
    CASE 71: ErrorMsg$ = "Disk not ready"
    CASE 72: ErrorMsg$ = "Disk-media error"
    CASE 73: ErrorMsg$ = "Feature unavailable"
    CASE 74: ErrorMsg$ = "Rename across disks"
    CASE 75: ErrorMsg$ = "Path/File access error"
    CASE 76: ErrorMsg$ = "Path not found"
    CASE ELSE
       ErrorMsg$ = "Unknown"
  END SELECT
END FUNCTION

' ExeName returns the full name of the currently executing program, 
' including the drive, path, and file name. ExeName requires DOS 
' 3.0 or higher, and returns a null string when run under DOS 2. 
FUNCTION ExeName$
  ' NOTE: Considered UCASE$, but an existing sample suggests that this shouldn't be done here.
  ExeName$ = COMMAND$(0)
END FUNCTION

' Exist will quickly determine the presence of a file. 
FUNCTION Exist(fileName$)
  ' FileName$ is the file or file specification whose presence is being 
  ' determined, and There is assigned either to -1 if the file exists, or 0 
  ' if it does not. 
  ' The FileName$ parameter may optionally contain a drive letter, a 
  ' directory path, and either of the DOS wild cards. For example, 
  ' "B:\STUFF\*.BAS" would tell if any BASIC program files are 
  ' present on drive B in the \STUFF directory.
  IF INSTR(fileName$, "*") > 0 OR INSTR(fileName$, "?") > 0 THEN
    Exist = FCount(fileName$) > 0
  ELSE
    Exist = _FileExists(fileName$)
  END IF
END FUNCTION

' FastLoadInt returns the number of lines
' needed (array size) in order to prepare
' the string array needed by FastLoadStr.
FUNCTION FastLoadInt(FileName$)
  ERROR 73 ' Feature Unavailable
END FUNCTION

' FastLoadStr allows your programs to load 
' an entire text file to a conventional 
' (not fixed-length) string array very quickly. 
SUB FastLoadStr(array$())
  ERROR 73 ' Feature Unavailable
END SUB

' FastSave allows your programs save an entire 
' text file from a conventional (not fixed-length) 
' string array very quickly. 
SUB FastSave(FileName$, Text$())
  ERROR 73 ' Feature Unavailable
END SUB

' FClose will close a file that had been previously opened with the 
' QuickPak Professional FOpen command. 
SUB FClose(Handle)
  CLOSE #Handle
END SUB

' FCopy will copy a file from within a BASIC program without 
' requiring the use of SHELL. 
SUB FCopy(source$, dest$, buffer$, errCode)

  ' TODO: Consider if there is a way to leverage LOF/EOF and buffer$
  ' NOTE: This is currently (most likely) very "slow" given it is 
  '       working one byte at a time - see the TODO: above.

  errCode = 0

  IF Exist(source$) THEN

    ' TODO: Check destination folder exists.
    ' TODO: Protect against trying to overwrite (same source and dest path).

    DIM value AS _BYTE

    CALL FOpen(source$, src)
    CALL FOpen(dest$, dest)

    DO
      GET #src, , value
      IF FEof(src) THEN EXIT DO
      PUT #dest, , value
    LOOP

    CALL FClose(dest): CALL FClose(source)

  ELSE
    errCode = 2 ' problem with the source file
  END IF

END SUB

' FCreate is used to create a file in preparation for writing to it with 
' the QuickPak Professional file handling routines. 
SUB FCreate(FileName$)
  ff = FREEFILE
  OPEN FileName$ FOR OUTPUT AS #ff
  CLOSE #ff
END SUB

' FEof will report if the current DOS Seek location is at the end of 
' the specified file. 
FUNCTION FEof(handle)
  FEof = EOF(handle)
END FUNCTION

' FFlush will flush a file's data buffers to disk without requiring the 
' file to be closed. 
SUB FFlush(Handle)
  ERROR 73 ' Feature Unavailable
END SUB

' FGet reads data from a disk file in a manner similar to BASIC's 
' binary GET command, but it returns an error code rather than 
' requiring the use of ON ERROR. 
SUB FGet(Handle, Destination$)
  ERROR 73 ' Feature Unavailable
END SUB

' FGetA is similar to the QuickPak Professional FGetT routine, 
' however it accepts a segmented address thus allowing an entire 
' array to be loaded in one operation. FGetA will load up to 64k 
' bytes at a time. 
SUB FGetA(Handle, Array$(), Element, NumBytes)
  ERROR 73 ' Feature Unavailable
END SUB

SUB FGetAH(FileName$, Array$(), Start, ElSize, NumEls)
  ERROR 73 ' Feature Unavailable
END SUB

SUB FGetR(Handle, Destination$, RecNumber&)
  ERROR 73 ' Feature Unavailable
END SUB

SUB FGetRT(Handle, Destination AS FLen, RecNumber&, RecSize)
  ERROR 73 ' Feature Unavailable
END SUB

SUB FGetRTA(Handle, Destination AS FLen, RecNumber&, RecSize)
  ERROR 73 ' Feature Unavailable
END SUB

SUB FGetT(Handle, Destination AS FLen, NumBytes)
  ERROR 73 ' Feature Unavailable
END SUB

' FileComp will report if any two disk files are the same. 
FUNCTION FileComp(file1$, file2$, errCode)

  ' File1$ and File2$ are the two files being compared, and Same 
  ' receives either -1 if they are the same, or O if they are not. 
  '
  ' If a DOS error occurs (file not found, drive door open, etc.), then 
  ' ErrCode% will tell which file the error relates to. An ErrCode% of 
  ' 1 means the problem was with File1$, and 2 means it was with File2$.
  '
  ' Besides returning a true or false condition based on a comparison of 
  ' the two files, FileComp also uses the DOSError and WhichError 
  ' services to report disk errors. This is illustrated in the 
  ' DEMOCOMP .BAS example program.

  IF NOT Exist(file1$) THEN errCode = 1: EXIT FUNCTION
  IF NOT Exist(file2$) THEN errCode = 2: EXIT FUNCTION
  
  s1& = FileSize&(file1$)
  s2& = FileSize&(file2$)

  IF s1& <> s2& THEN FileComp = 0: EXIT FUNCTION

  result = 1 ' assume files match

  DIM value1 AS _BYTE
  DIM value2 AS _BYTE

  CALL FOpen(file1$, f1)
  CALL FOpen(file2$, f2)

  DO
    GET #f1, , value1
    GET #f2, , value2
    IF value1 <> value2 THEN result = 0: EXIT DO ' unless they don't
  LOOP UNTIL FEof(f1)

  CALL FClose(f2): CALL FClose(f1)

  FileComp = result

END FUNCTION

SUB FileCrypt(FileName$, PassWord$)
  ERROR 73 ' Feature Unavailable
END SUB

SUB FileInfo(fileName$, tVar AS FInfo)

  f$ = fileName$

  IF RIGHT$(f$, 1) <> CHR$(0) THEN f$ = f$ + CHR$(0)

  DIM createDate AS FILETIME
  DIM modifyDate AS FILETIME
  DIM accessDate AS FILETIME
  DIM systime1 AS SYSTEMTIME
  DIM fileHandle AS _OFFSET

  fileHandle = CreateFileA%&(_OFFSET(f$), GENERIC_READ, FILE_SHARE_READ OR FILE_SHARE_WRITE, 0, OPEN_EXISTING, 0, 0)
  IF fileHandle <> INVALID_HANDLE_VALUE THEN
    IF GetFileTime&(fileHandle, _OFFSET(createDate), _OFFSET(modifyDate), _OFFSET(accessDate)) THEN
      'PRINT HEX$(createDate.dwLowDateTime) + HEX$(createDate.dwHighDateTime)
      'PRINT HEX$(modifyDate.dwLowDateTime) + HEX$(modifyDate.dwHighDateTime)
      'PRINT HEX$(accessDate.dwLowDateTime) + HEX$(accessDate.dwHighDateTime)
      IF FileTimeToSystemTime&(_OFFSET(createDate), _OFFSET(systime1)) THEN
        tVar.Year = systime1.wYear
        tVar.Month = systime1.wMonth
        tVar.Day = systime1.wDay
        tVar.Hour = systime1.wHour
        tVar.Minute = systime1.wMinute
        tVar.Second = systime1.wSecond
      ELSE
        'PRINT "FileTimeToSystemTime failed. Error: 0x" + LCASE$(HEX$(GetLastError&))
      END IF
    ELSE
      'PRINT "GetFileTime failed. Error: 0x" + LCASE$(HEX$(GetLastError&))
    END IF
    IF CloseHandle&(fileHandle) = 0 THEN
      'PRINT "CloseHandle failed. Error: 0x" + LCASE$(HEX$(GetLastError&))
    END IF
  ELSE
    'PRINT "CreateFileA failed. Error: 0x" + LCASE$(HEX$(GetLastError&))
  END IF

  tVar.Size = FileSize(fileName$)
  tVar.Attrib = GetFileAttributes(f$)

END SUB

' FileSize will quickly return the length of a named file. 
FUNCTION FileSize&(fileName$)

  ' fileName$ is the name of the file, and size is assigned its length in 
  ' bytes. If the file does not exist size is instead assigned a value of -1. 

  result& = 0

  IF NOT _FileExists(fileName$) THEN
    result& = -1
  ELSE

    IF INSTR(_OS$, "[WINDOWS]") THEN
      DIM pattern AS STRING
      DIM fd AS Win32_Find_Data
      DIM hFind AS _UNSIGNED _OFFSET
      DIM junk AS LONG
      pattern = fileName$ + CHR$(0)
      hFind = FindFirstFile(_OFFSET(pattern), _OFFSET(fd))
      IF hFind <> INVALID_HANDLE_VALUE THEN
        result& = fd.nfilesizelow
        junk = FindClose(hFind)
      ELSE
        lastError& = GetLastError
        IF lastError& = ERROR_ACCESS_DENIED THEN
          ERROR 70 ' Permission denied
        ELSE
          ERROR 75 ' Path/File access error
        END IF
      END IF
    ELSE
      ERROR 73 ' Advanced Feature / Feature Unavailable
    END IF

  END IF

  FileSize& = result&

END FUNCTION

SUB FileSort(DataFile$, IndexFile$, First&, Last&, Table(), RecLength)
  ERROR 73 ' Feature Unavailable
END SUB

FUNCTION FLInput$(Handle, Buffer$)
  ERROR 73 ' Feature Unavailable
END FUNCTION

FUNCTION FLoc&(Handle)
  FLoc& = LOC(Handle)
END FUNCTION

FUNCTION FLof&(Handle)
  FLof& = LOF(Handle)
END FUNCTION

SUB FOpen(fileName$, handle)
  handle = FREEFILE
  OPEN fileName$ FOR BINARY AS #handle
END SUB

SUB FOpenS(FileName$, Handle)
  ERROR 73 ' Feature Unavailable
END SUB

SUB FOpenAll(FileName$, AccessMode, ShareMode, Handle)
  ERROR 73 ' Feature Unavailable
END SUB

FUNCTION FormatDiskette(DriveNumber, Capacity, BufArray())
  ERROR 73 ' Feature Unavailable
END FUNCTION

SUB FPut(Handle, Source$)
  ERROR 73 ' Feature Unavailable
END SUB

SUB FPutA(Handle, Array(), Start, NumBytes)
  ERROR 73 ' Feature Unavailable
END SUB

SUB FPutAH(Handle, Array(), start, ElSize, NumEls)
  ERROR 73 ' Feature Unavailable
END SUB

SUB FPutR(Handle, Source$, RecNumber&)
  ERROR 73 ' Feature Unavailable
END SUB

SUB FPutRT(Handle, Source AS FLen, RecNumber&, RecSize)
  ERROR 73 ' Feature Unavailable
END SUB

SUB FPutRTA(Handle, Source AS FLen, RecNumber&, RecSize)
  ERROR 73 ' Feature Unavailable
END SUB

SUB FPutT(Handle, Source AS FLen, NumBytes)
  ERROR 73 ' Feature Unavailable
END SUB

SUB FSeek(Handle, Location&)
  ERROR 73 ' Feature Unavailable
END SUB

SUB FStamp(FileName$, NewTime$, NewDate$)
  ERROR 73 ' Feature Unavailable
END SUB

FUNCTION FullName$(partName$)
  s = 1
  DO
    p = InstrTbl(s, partName$, "\/")
    section$ = MID$(partName$, s, p - s)
    IF section$ = ".." THEN 
      c = c + 1
    ELSE
      s = s - 1 ' walk one character back.
      EXIT DO
    END IF
    IF p = -1 THEN EXIT DO
    s = p + 1
  LOOP
  section$ = MID$(partName$, s)
  cwd$ = _CWD$
  FOR x = 1 TO c
    p = InstrTblB(LEN(cwd$), cwd$, "\/")
    IF p > 0 THEN
      cwd$ = LEFT$(cwd$, p - 1)
    ELSE
      EXIT FOR ' error?
    END IF
  NEXT
  IF InstrTblB(LEN(cwd$), cwd$, "\/") <> LEN(cwd$) AND _
    InstrTbl(1, section$, "\/") <> 1 THEN
    IF InstrTbl(1, cwd$, "\") > 0 THEN
      cwd$ = cwd$ + "\"
    ELSE
      cwd$ = cwd$ + "/"
    END IF
  END IF
  FullName$ = cwd$ + section$
END FUNCTION

FUNCTION GetAttr(fileName$)
  IF Exist(fileName$) THEN
    IF INSTR(_OS$, "[WINDOWS]") THEN
      f$ = fileName$
      IF RIGHT$(f$, 1) <> CHR$(0) THEN f$ = f$ + CHR$(0)
      GetAttr = GetFileAttributes(f$)
    ELSE
      ERROR 73 ' Feature Unavailable
    END IF
  ELSE
    GetAttr = -1
  END IF
END FUNCTION

' GetDir will return the current directory for either a specified drive 
' or the default drive. 
FUNCTION GetDir$(drive$)
 
  ' Parameter may be given as either upper or lower case, and only the first character is considered
  ' Returns the complete directory name, minus the drive letter and colon.

  ' _CWD$ (function) returns the current working directory as a STRING value.
  ' _STARTDIR$ (function) returns the user's program calling path as a STRING.

  ch$ = MID$(_CWD$, 1, 1)
  a = ASC(UCASE$(ch$))
  SELECT CASE a
    CASE ASC("A") TO ASC("Z")
      GetDir$ = MID$(_CWD$, 3)
    CASE ELSE
      GetDir$ = _CWD$
  END SELECT

END FUNCTION

FUNCTION GetDisketteType(DriveNumber)
  ' Use GetDriveType?
  ERROR 73 ' Feature Unavailable
END FUNCTION

' GetDrive returns the current default disk drive. 
FUNCTION GetDrive
  ' Drive$ is assigned to a value representing an ASCII character that 
  ' holds the current default drive. GetDrive actually returns an integer 
  ' result, which can be easily turned into a string as shown above.

  ' GetDrive returns a value that represents an upper case ASCII drive 
  ' letter. For example, if the current default drive is A, then GetDrive 
  ' will return the value 65. Likewise, if the current drive is C, 
  ' GetDrive would return 67.

  ' _CWD$ (function) returns the current working directory as a STRING value.
  ' _STARTDIR$ (function) returns the user's program calling path as a STRING.

  IF INSTR(_OS$, "[WINDOWS]") THEN
    ch$ = MID$(_CWD$, 1, 1)
    a = ASC(UCASE$(ch$))
    SELECT CASE a
      CASE 65 TO 90 ' A to Z
        GetDrive = a
      CASE ELSE
        GetDrive = 0
    END SELECT
  ELSE
    ERROR 73 ' Feature Unavailable
  END IF

END FUNCTION

FUNCTION GetVol$(Drive$)
  ERROR 73 ' Feature Unavailable
END FUNCTION

' GoodDrive will quickly determine whether a 
' specified drive letter is valid. 
FUNCTION GoodDrive(drive$)
  ' Drive$ is either an upper or lower case letter that represents the 
  ' drive to check, and Okay receives either -1 if the drive is valid, 
  ' or 0 if it is not. 
  ' Possibly use GetLogicalDrives or GetLogicalDriveStringsW
  ' along with GetDriveType and/or GetDiskFreeSpace/GetDiskFreeSpaceEx.
  CALL DiskInfo(drive$, bytes, sectors, freeClusters&, totalClusters&)
  IF bytes = 0 THEN
    GoodDrive = 0 ' Not good
  ELSE
    GoodDrive = -1 ' Good
  END IF
END FUNCTION

SUB Handle2Name(Handle, FilName AS NameType)
  ERROR 73 ' Feature Unavailable
END SUB

SUB KillDir(DirName$)
  RMDIR DirName$
END SUB

SUB KillFile(FileName$)
  KILL FileName$
END SUB

FUNCTION LastDrive
  ERROR 73 ' Feature Unavailable
END FUNCTION

' LineCount will quickly count all of the lines of text in a specified file.
FUNCTION LineCount(fileName$, buffer$)

  ' The main purpose of LineCount is to report the number of lines in a 
  ' text file, in preparation for dimensioning an array to hold them. 
  ' When a program will be reading a text file into an array, knowing 
  ' this ahead of time can be a big help. The only other possibilities 
  ' would be to read through the entire file once just to count the lines, 
  ' or guess at how large to dimension the array to. 

  ' One important caveat you should be aware of when using 
  ' LineCount is that it merely counts the number of CHR$(13) 
  ' carriage returns in the file. Line feeds are not considered at all. 

  ' fileName$ is the name of the file to examine, and may contain an 
  ' optional drive letter or path name. buffer$ is a temporary work area 
  ' needed by LineCount to hold the file, and count receives the 
  ' number of lines of text. 

  ' If there are more than 32767 lines in the file (very unlikely if you 
  ' think about it), LineCount will return a negative number. Simply 
  ' add 65536 to that number to get the actual count. 

  ' If the file doesn't exist or some other error occurs, LineCount will 
  ' instead receive -1. 

  result = 0

  IF _FileExists(fileName$) THEN
    ff = FREEFILE
    OPEN fileName$ FOR INPUT AS #ff
    DO UNTIL EOF(1)
      LINE INPUT #ff, buffer$
      result = result + 1
    LOOP
    CLOSE #ff
  ELSE
    result = -1
  END IF

  LineCount = result

END FUNCTION

FUNCTION LoadExec(Program$, CmdLine$)
  ERROR 73 ' Feature Unavailable
END FUNCTION

SUB LockFile(Handle, Offset&, Length&)
  ERROR 73 ' Feature Unavailable
END SUB

SUB MakeDir(DirName$)
  MKDIR DirName$
END SUB

SUB NameDir(OldName$, NewName$)
  NAME OldName$ AS NewName$
END SUB

SUB NameFile(OldName$, NewName$)
  NAME OldName$ AS NewName$
END SUB

FUNCTION NetDrive(Drive$)
  ERROR 73 ' Feature Unavailable
END FUNCTION

SUB PutVol(Drive$, Label$)
  ERROR 73 ' Feature Unavailable
END SUB

SUB QBLoad(FileName$, Array(), Element)
  'DEF SEG = VARSEG(Array(0))
    BLOAD FileName$, VARPTR(Array(LBOUND(Array)))
  'END SEG
END SUB

SUB QBSave(FileName$, Array(), Element, NumBytes)
  ERROR 73 ' Feature Unavailable
END SUB

' DCount reports the number of directories that match a particular specification. 
FUNCTION DCount(dirSpec$)
  ' dirSpec$ holds a DOS directory name specification, and Count 
  ' receives the number of matching directories.

  result = 0

  IF INSTR(_OS$, "[WINDOWS]") THEN
    DIM pattern AS STRING
    DIM fd AS Win32_Find_Data
    DIM hFind AS _UNSIGNED _OFFSET
    DIM junk AS LONG
    DIM ffn AS STRING
    DIM p AS INTEGER
    pattern = dirSpec$ + CHR$(0)
    hFind = FindFirstFile(_OFFSET(pattern), _OFFSET(fd))
    IF hFind <> INVALID_HANDLE_VALUE THEN
      DO
        IF (fd.dwfileattributes AND FILE_ATTRIBUTE_DIRECTORY) = FILE_ATTRIBUTE_DIRECTORY THEN
          ffn = fd.cfilename
          p = INSTR(ffn, CHR$(0))
          IF p > 0 THEN ffn = LEFT$(ffn, p - 1)
          IF ffn = "." THEN
          ELSEIF ffn = ".." THEN
          ELSEIF UCASE$(ffn) = "$RECYCLE.BIN" THEN
          ELSEIF INSTR(ffn, "System Volume Information") > 0 THEN
          ELSE
            result = result + 1
          END IF
        END IF
      LOOP UNTIL FindNextFile(hFind, _OFFSET(fd)) = 0
      junk = FindClose(hFind)
    ELSE
      lastError& = GetLastError
      IF lastError& = ERROR_ACCESS_DENIED THEN
        ERROR 70 ' Permission denied
      ELSE
        ERROR 75 ' Path/File access error
      END IF
    END IF
  ELSE
    ERROR 73 ' Advanced Feature / Feature Unavailable
  END IF

  DCount = result

END FUNCTION

' ReadDir obtains a list of directory names from disk, and loads them 
' into a conventional (not fixed-length) string array in one operation. 
SUB ReadDir(array$())
  ' array$(0) holds the search specification to indicate which directory 
  ' names are to be loaded, and subsequent array elements receive each 
  ' directory name. 

  IF INSTR(_OS$, "[WINDOWS]") THEN
    
    DIM pattern AS STRING
    DIM fd AS Win32_Find_Data
    DIM hFind AS _UNSIGNED _OFFSET
    DIM junk AS LONG
    DIM ffn AS STRING
    DIM p AS INTEGER

    pattern = array$(0) + CHR$(0)
    hFind = FindFirstFile(_OFFSET(pattern), _OFFSET(fd))
    IF hFind <> INVALID_HANDLE_VALUE THEN
      index = 1
      DO
        IF (fd.dwfileattributes AND FILE_ATTRIBUTE_DIRECTORY) = FILE_ATTRIBUTE_DIRECTORY THEN
          ffn = fd.cfilename
          p = INSTR(ffn, CHR$(0))
          IF p > 0 THEN ffn = LEFT$(ffn, p - 1)
          IF ffn = "." THEN
          ELSEIF ffn = ".." THEN
          ELSEIF UCASE$(ffn) = "$RECYCLE.BIN" THEN
          ELSEIF INSTR(ffn, "System Volume Information") > 0 THEN
          ELSE
            array$(index) = ffn
            index = index + 1
          END IF
        END IF
      LOOP UNTIL FindNextFile(hFind, _OFFSET(fd)) = 0
      junk = FindClose(hFind)
    ELSE
      lastError& = GetLastError
      IF lastError& = ERROR_ACCESS_DENIED THEN
        ERROR 70 ' Permission denied
      ELSE
        ERROR 75 ' Path/File access error
      END IF
    END IF
  ELSE
    ERROR 73 ' Advanced Feature / Feature Unavailable
  END IF

END SUB

' FCount will report the number of file names that match a particular specification. 
FUNCTION FCount(fileSpec$)

  ' fileSpec$ holds a DOS file name or specification, and Count 
  ' receives the number of matching entries. 

  result = 0

  IF INSTR(_OS$, "[WINDOWS]") THEN
    DIM pattern AS STRING
    DIM fd AS Win32_Find_Data
    DIM hFind AS _UNSIGNED _OFFSET
    DIM junk AS LONG
    pattern = fileSpec$ + CHR$(0)
    hFind = FindFirstFile(_OFFSET(pattern), _OFFSET(fd))
    IF hFind <> INVALID_HANDLE_VALUE THEN
      DO
        IF (fd.dwfileattributes AND FILE_ATTRIBUTE_DIRECTORY) = FILE_ATTRIBUTE_DIRECTORY THEN
        ELSE 
          result = result + 1
        END IF
      LOOP UNTIL FindNextFile(hFind, _OFFSET(fd)) = 0
      junk = FindClose(hFind)
    ELSE
      lastError& = GetLastError
      IF lastError& = ERROR_FILE_NOT_FOUND THEN
        ' no files available, result remains 0
      ELSEIF lastError& = ERROR_ACCESS_DENIED THEN
        ERROR 70 ' Permission denied
      ELSE
        PRINT lastError&
        ERROR 75 ' Path/File access error
      END IF
    END IF
  ELSE
    ERROR 73 ' Advanced Feature / Feature Unavailable
  END IF

  FCount = result

END FUNCTION

' ReadFile obtains a list of file names from disk, and loads them into 
' a conventional (not fixed-length) string array in one operation. 
SUB ReadFile(array$())

  ' array$(0) holds the search specification to indicate which file names
  ' are to be loaded, and subsequent array elements receive each name.

  IF INSTR(_OS$, "[WINDOWS]") THEN
    
    DIM pattern AS STRING
    DIM fd AS Win32_Find_Data
    DIM hFind AS _UNSIGNED _OFFSET
    DIM junk AS LONG
    DIM ffn AS STRING
    DIM p AS INTEGER

    pattern = array$(0) + CHR$(0)
    hFind = FindFirstFile(_OFFSET(pattern), _OFFSET(fd))
    IF hFind <> INVALID_HANDLE_VALUE THEN
      index = 1
      DO
        IF (fd.dwfileattributes AND FILE_ATTRIBUTE_DIRECTORY) = FILE_ATTRIBUTE_DIRECTORY THEN
        ELSE 
          ffn = fd.cfilename
          p = INSTR(ffn, CHR$(0))
          IF p > 0 THEN ffn = LEFT$(ffn, p - 1)
          'TODO: Adjusting to 12 characters for legacy purposes.
          IF LEN(ffn) < 12 THEN ffn = LEFT$(ffn + SPACE$(12), 12)
          array$(index) = ffn
          index = index + 1
        END IF
      LOOP UNTIL FindNextFile(hFind, _OFFSET(fd)) = 0
      junk = FindClose(hFind)
    ELSE
      lastError& = GetLastError
      IF lastError& = ERROR_FILE_NOT_FOUND THEN
        ' no files available, result remains 0
      ELSEIF lastError& = ERROR_ACCESS_DENIED THEN
        ERROR 70 ' Permission denied
      ELSE
        PRINT lastError&
        ERROR 75 ' Path/File access error
      END IF
    END IF
  ELSE
    ERROR 73 ' Advanced Feature / Feature Unavailable
  END IF

END SUB

SUB ReadDirT(Spec$, Array())
  ERROR 73 ' Feature Unavailable
END SUB

SUB ReadFileI(Array$())
  ' 1234567890123456789012345678901234567 
  ' namename.ext sizesize mm-dd-yy hh:rrm* <---- either "a" or "p" 
  ERROR 73 ' Feature Unavailable
END SUB

SUB ReadFileT(spec$, array() AS STRING * 12, first)
  IF INSTR(_OS$, "[WINDOWS]") THEN
    
    DIM pattern AS STRING
    DIM fd AS Win32_Find_Data
    DIM hFind AS _UNSIGNED _OFFSET
    DIM junk AS LONG
    DIM ffn AS STRING
    DIM p AS INTEGER

    pattern = spec$ 'array$(0) + CHR$(0)
    hFind = FindFirstFile(_OFFSET(pattern), _OFFSET(fd))
    IF hFind <> INVALID_HANDLE_VALUE THEN
      index = first ' 1
      DO
        IF (fd.dwfileattributes AND FILE_ATTRIBUTE_DIRECTORY) = FILE_ATTRIBUTE_DIRECTORY THEN
        ELSE 
          ffn = fd.cfilename
          p = INSTR(ffn, CHR$(0))
          IF p > 0 THEN ffn = LEFT$(ffn, p - 1)
          'LSET array(index).S = ffn
          LSET array(index) = ffn
          index = index + 1
        END IF
      LOOP UNTIL FindNextFile(hFind, _OFFSET(fd)) = 0
      junk = FindClose(hFind)
    ELSE
      lastError& = GetLastError
      IF lastError& = ERROR_FILE_NOT_FOUND THEN
        ' no files available, result remains 0
      ELSEIF lastError& = ERROR_ACCESS_DENIED THEN
        ERROR 70 ' Permission denied
      ELSE
        PRINT lastError&
        ERROR 75 ' Path/File access error
      END IF
    END IF
  ELSE
    ERROR 73 ' Advanced Feature / Feature Unavailable
  END IF
END SUB

SUB ReadFileX(Spec$, DirSize&, Array() AS FullInfo, first)
  ERROR 73 ' Feature Unavailable
END SUB

SUB ReadSect(Drive$, Info$, Sector)
  ERROR 73 ' Feature Unavailable
END SUB

FUNCTION ReadTest(Drive$)
  ERROR 73 ' Feature Unavailable
END FUNCTION

FUNCTION Removable(Drive$)
  ERROR 73 ' Feature Unavailable
END FUNCTION

FUNCTION ScanFile&(FileName$, Text$, Start&)
  ERROR 73 ' Feature Unavailable
END FUNCTION

FUNCTION SearchPath$(FileName$)
  ERROR 73 ' Feature Unavailable
END FUNCTION

SUB SetAttr(FileName$, Attribute)
  ERROR 73 ' Feature Unavailable
END SUB

SUB SetCmd(NewCommand$)
  ERROR 73 ' Feature Unavailable
END SUB

' SetDrive allows changing the current default drive. 
SUB SetDrive(drive$)
  ' drive$ is either an upper or lower case letter of the drive to be 
  ' made the current default. 
  d$ = UCASE$(LEFT$(drive$, 1))
  IF ASC(d$) >= 65 AND ASC(d$) <= 90 THEN
    CHDIR d$ + ":"
  ELSE
    ERROR 5 ' Illegal Function Call
  END IF
END SUB

' SetError allows a BASIC program to set or clear the DOSError and 
' WhichError functions. 
SUB SetError(errNum)
  'TODO: Need to figure out how to handle setting of an error
  ' so that, somehow, SYSTEM and/or END can be called
  ' before exiting the application so that the error set
  ' can be exposed to the caller (externally - os level).
END SUB

SUB SetLevel(ErrValue)
  ERROR 73 ' Feature Unavailable
END SUB

FUNCTION ShareThere
  ERROR 73 ' Feature Unavailable
END FUNCTION

SUB SplitName (workName$, drive$, path$, fileName$, ext$) STATIC

  drive$ = ""                                    ' clear out any old junk
  path$ = ""
  fileName$ = ""
  ext$ = ""

  IF LEN(workName$) = 0 THEN EXIT SUB            ' there's nothing to do, exit
  fileName$ = workName$                          ' assume there's a name only

  FOR x = LEN(workName$) TO 1 STEP -1           ' walk backwards
    thisChar = ASC(MID$(workName$, x))         ' isolate this character
    IF thisChar = 58 OR thisChar = 92 THEN       '   ":" or "\"
      path$ = LEFT$(workName$, X)               ' separate the path
      fileName$ = MID$(workName$, x + 1)        '    from the name
      EXIT FOR
    END IF
  NEXT

  IF MID$(path$, 2, 1) = ":" THEN                ' if there's a drive letter
    drive$ = LEFT$(path$, 1)                     ' isolate the drive
    path$ = MID$(path$, 3)                       ' and the path
  END IF

  dot = INSTR(fileName$, ".")                   ' see if there's an extension
  IF dot THEN                                   ' there is
    ext$ = MID$(fileName$, dot)                 ' and the extension
    fileName$ = LEFT$(fileName$, dot - 1)       ' separate the name
  END IF

  IF LEN(drive$) = 0 THEN                        ' if no drive use the default
    drive$ = CHR$(GetDrive)
  END IF

  IF LEN(path$) = 0 THEN                         ' if no path use the default
    path$ = GetDir$(drive$)
    IF path$ <> "\" THEN path$ = path$ + "\"
  END IF

  drive$ = drive$ + ":"                          ' add a trailing colon

END SUB

FUNCTION Unique$(Path$)
  ERROR 73 ' Feature Unavailable
END FUNCTION

SUB UnLockFile(Handle, Offset&, Length&)
  ERROR 73 ' Feature Unavailable
END SUB

FUNCTION Valid(FileName$)
  ERROR 73 ' Feature Unavailable
END FUNCTION

' WhichError reports which error if any occurred during the last call 
' to a QuickPak: Professional DOS routine.
FUNCTION WhichError
  
  ' WhichError returns O if there was no error, or an error code if 
  ' there was. 

  ' All of the QuickPak Professional routines assign a value to the 
  ' DOSError and WhichError functions to indicate their success or 
  ' failure. Rather than requiring you to set up a separate error 
  ' handling procedure and use ON ERROR, you can simply query 
  ' these functions after performing any QuickPak Professional DOS 
  ' operation. WhichError is discussed in the section entitled 
  ' "Eliminating ON ERROR". 
  
  ' The table on the following page shows all of the possible DOS 
  ' errors and the corresponding numbers that WhichError returns. 
  
  ' Also see the complimentary function DOSError

  WhichError = 0 'TODO: Need to implement. 

END FUNCTION

SUB WriteSect(Drive$, Info$, Sector)
  ERROR 73 ' Feature Unavailable
END SUB

SUB WriteSect2(Drive$, Info$, Sector)
  ERROR 73 ' Feature Unavailable
END SUB

FUNCTION WriteTest(Drive$)
  ERROR 73 ' Feature Unavailable
END FUNCTION

' ****************************************
' Chapter 4 - Functions
' ****************************************

FUNCTION Bin2Num(binary$)
  b$ = RIGHT$("0000000000000000" + binary$, 16)
  result& = VAL(MID$(b$, 16, 1))
  FOR x = LEN(b$) - 1 TO 2 STEP - 1
    v = VAL(MID$(b$, x, 1))
    IF v > 0 THEN
      v = 16 - x
      result& = result& + (2 ^ v)
    END IF
  NEXT
  'IF INSTR(b$, "0") = 0 THEN
  '  result& = -1
  'ELSE
  IF MID$(b$, 1, 1) = "1" THEN
    result& = -(32768 - result&) 
  END IF
  Bin2Num = CINT(result&)
END FUNCTION

' Num2Bin will convert a number into an equivalent binary string with 
' a fixed length of 16 digits. 
FUNCTION Num2Bin$(number)
  n& = number
  IF n& < O THEN n& = n& + 65536 
  IF n& = 0 THEN
    Num2Bin$ = "0000000000000000"
  ELSEIF n& > 0 THEN
    result$ = ""
    i# = 2 ^ CLNG(LOG(n&) / LOG(2) + 0.1)
    DO WHILE i# >= 1
      c& = FIX(n& / i#)
      result$ = result$ + LTRIM$(STR$(c&))
      n& = n& - i# * c&
      i# = i# / 2
    LOOP
    Num2Bin$ = RIGHT$("0000000000000000" + result$, 16)
  END IF
END FUNCTION

' Num2Bin2 will convert a number into an equivalent binary string with 
' only as many digits as required to represent the number. 
FUNCTION Num2Bin2$(number)
  n& = number
  IF n& < O THEN n& = n& + 65536 
  IF n& = 0 THEN
    Num2Bin2$ = "0"
  ELSEIF n& > 0 THEN
    result$ = ""
    i# = 2 ^ CLNG(LOG(n&) / LOG(2) + 0.1)
    DO WHILE i# >= 1
      c& = FIX(n& / i#)
      result$ = result$ + LTRIM$(STR$(c&))
      n& = n& - i# * c&
      i# = i# / 2
    LOOP
    Num2Bin2$ = result$
  END IF
END FUNCTION

FUNCTION QPHex$(Value, NumDigits)
  ERROR 73 ' Feature Unavailable
END FUNCTION

' ****************************************
' Chapter 5 - Menu/Input Routines
' ****************************************

SUB AMenu(array$(), first, item, count, scanCode, normColor, hiLiteColor, numRows, numCols, gap, ulRow, ulCol)
  'TODO: Fix "tagging" functionality - see DEMOCM.BAS for example of functionality.
  w = LEN(array$(first))                ' width of each column.
  IF scanCode <> 3 THEN
    DO
      IF item > first + ((numRows * numCols) - 1) THEN
        first = first + (numRows * numCols)
      ELSE
        EXIT DO
      END IF
    LOOP
  END IF
  DO
    DO
      IF item < first THEN                ' current item before the display range?
        first = first - numRows          ' scroll display to the left.
      ELSEIF item > first + ((numRows * numCols) - 1) THEN ' current item beyond the display range?
        first = first + numRows          ' scroll display to the right.
      ELSE
        EXIT DO
      END IF
    LOOP
    FOR rr = 0 TO numRows - 1         ' for each display row,
      FOR cc = 0 TO numCols - 1       ' for each display column,
        index = first + rr + (cc * numRows) ' determine element index,
        IF index = item THEN clr = hiLiteColor ELSE clr = normColor ' determine color,
        IF index <= UBOUND(array$) THEN text$ = array$(index) ELSE text$ = SPACE$(w) ' determine text (can be blank),
        QPrintRC text$, ulRow + rr, ulCol + (cc * (w + gap)), clr ' render text.
      NEXT
    NEXT
    IF scanCode = 9999 THEN EXIT SUB 'TODO: For testing...
    WHILE inkey$ <> "": WEND              ' not sure needed.
    DO
      scanCode = MGetKey(row, col)     ' scanCode might be returned to caller.
      SELECT CASE scanCode
        CASE -72 ' Up
          IF item > 1 THEN               ' if current more than min,
            item = item - 1             ' decrement.
          END IF
          EXIT DO
        CASE -80 ' Down
          IF item < UBOUND(array$) THEN  ' if current less than max,
            item = item + 1             ' increment.
          END IF
          EXIT DO
        CASE -75 ' Left
          IF item - numRows > 0 THEN    ' more columns to the left?
            item = item - numRows      ' shift columns right.
          ELSEIF item > 1 THEN           ' if not shifted (above),
            item = 1                     ' set current item to first.
          END IF
          EXIT DO
        CASE -77 ' Right
          IF item + numRows <= UBOUND(array$) THEN ' more columns to the right?
            item = item + numRows                 ' shift columns left.
          ELSEIF item < UBOUND(array$) THEN         ' if not shifted (above),
            item = UBOUND(array$)                   ' set current item to last.
          END IF
          EXIT DO
        CASE ELSE                         ' any other key,
          count = item                  ' set count on exit to be the currently highlighted item,
          EXIT SUB                        ' return to caller.
      END SELECT
    LOOP
  LOOP
END SUB

SUB AMenuT(array() AS STRING * 12, first, item, length, count, scanCode, normColor, hiLiteColor, numRows, numCols, gap, ulRow, ulCol)
  w = length 'LEN(array$(first))                ' width of each column.
  IF scanCode <> 3 THEN
    DO
      IF item > first + ((numRows * numCols) - 1) THEN
        first = first + (numRows * numCols)
      ELSE
        EXIT DO
      END IF
    LOOP
  END IF
  DO
    DO
      IF item < first THEN                ' current item before the display range?
        first = first - numRows          ' scroll display to the left.
      ELSEIF item > first + ((numRows * numCols) - 1) THEN ' current item beyond the display range?
        first = first + numRows          ' scroll display to the right.
      ELSE
        EXIT DO
      END IF
    LOOP
    FOR rr = 0 TO numRows - 1         ' for each display row,
      FOR cc = 0 TO numCols - 1       ' for each display column,
        index = first + rr + (cc * numRows) ' determine element index,
        IF index = item THEN clr = hiLiteColor ELSE clr = normColor ' determine color,
        IF index <= UBOUND(array$) THEN text$ = array$(index) ELSE text$ = SPACE$(w) ' determine text (can be blank),
        QPrintRC text$, ulRow + rr, ulCol + (cc * (w + gap)), clr ' render text.
      NEXT
    NEXT
    IF scanCode = 9999 THEN EXIT SUB 'TODO: For testing...
    WHILE inkey$ <> "": WEND              ' not sure needed.
    DO
      scanCode = MGetKey(row, col)     ' scanCode might be returned to caller.
      SELECT CASE scanCode
        CASE -72 ' Up
          IF item > 1 THEN               ' if current more than min,
            item = item - 1             ' decrement.
          END IF
          EXIT DO
        CASE -80 ' Down
          IF item < UBOUND(array$) THEN  ' if current less than max,
            item = item + 1             ' increment.
          END IF
          EXIT DO
        CASE -75 ' Left
          IF item - numRows > 0 THEN    ' more columns to the left?
            item = item - numRows      ' shift columns right.
          ELSEIF item > 1 THEN           ' if not shifted (above),
            item = 1                     ' set current item to first.
          END IF
          EXIT DO
        CASE -77 ' Right
          IF item + numRows <= UBOUND(array$) THEN ' more columns to the right?
            item = item + numRows                 ' shift columns left.
          ELSEIF item < UBOUND(array$) THEN         ' if not shifted (above),
            item = UBOUND(array$)                   ' set current item to last.
          END IF
          EXIT DO
        CASE ELSE                         ' any other key,
          count = item                  ' set count on exit to be the currently highlighted item,
          EXIT SUB                        ' return to caller.
      END SELECT
    LOOP
  LOOP
END SUB

SUB ASCIIPick(char, color1, color2, exitCode)

  prevChar = char

  ulRow = CSRLIN
  ulCol = POS(0)
  lrRow = ulRow + 17
  lrCol = ulCol + 34
  CALL Box0(ulRow, ulCol, lrRow, lrCol, 2, color1)

  DO

    d$ = RIGHT$("00" + LTRIM$(STR$(char)), 2)
    h$ = RIGHT$("0" + HEX$(char), 2)
    CALL QPrintRC(CHR$(181) + " ASCII Code: Dec  " + d$ + "  Hex  " + h$ + " " + CHR$(198), ulRow + 17, ulCol + 1, color1)

    'prevControlChr = _CONTROLCHR ' <----------- QB64 definately get's this wrong...
    'IF NOT prevControlChr THEN _CONTROLCHR OFF
    FOR r = 1 TO 16
      FOR c = 1 TO 16
        ch = ((r - 1) * 16) + (c - 1)
        ch$ = CHR$(ch)
        IF char = ch THEN clr = color2 ELSE clr = color1
        CALL QPrintRC(ch$, ulRow + r, ulCol + (c * 2), clr)
      NEXT
    NEXT
    'IF NOT prevControlChr THEN _CONTROLCHR ON

    IF exitCode = -1 THEN EXIT SUB

    DO

      scanCode = MGetKey(row, col) ' scanCode might be returned to caller.
    
      SELECT CASE scanCode
        CASE -72 ' Up
          char = char - 16: EXIT DO
        CASE -80 ' Down
          char = char + 16: EXIT DO
        CASE -75 ' Left
          char = char - 1: EXIT DO
        CASE -77 ' Right
          char = char + 1: EXIT DO
        CASE -71 ' Home ' Diagonal UL
          char = char - 17: EXIT DO
        CASE -79 ' End  ' Diagonal DL
          char = char + 15: EXIT DO
        CASE -73 ' PgUp ' Diagonal UR
          char = char - 15: EXIT DO
        CASE -81 ' PgDn ' Diagonal DR
          char = char + 17: EXIT DO
        CASE 8, 9, 32 TO 126
          char = scanCode: EXIT DO
        CASE 13 ' Enter
          exitCode = 0: EXIT SUB
        CASE 1000 ' Mouse click
          r = row - (ulRow + 1): c = (col - ulCol) \ 2
          char = ((r * 16) + c) - 1
          exitCode = 2: EXIT SUB
        CASE 27
          char = prevChar: exitCode = 2: EXIT SUB
        CASE ELSE                         ' any other key,
      END SELECT
    LOOP

    IF char < 0 THEN char = char + 256
    IF char > 255 THEN char = char - 256

  LOOP

END SUB

SUB MASCIIPick(char, color1, color2, exitCode)
  CALL ASCIIPick(char, color1, color2, exitCode)
END SUB

SUB ColorPick(colr, boxColor, exitCode)

  prevClr = colr

  ulRow = CSRLIN
  ulCol = POS(0)
  lrRow = ulRow + 17
  lrCol = ulCol + 33

  CALL MPaintBox (ulRow, ulCol, lrRow, lrCol, boxColor)
  CALL Box0 (ulRow, ulCol, lrRow, lrCol, 2, boxColor)

  DO

    FOR r = 1 TO 16
      FOR c = 1 TO 8
        CALL QPrintRC (CHR$(177), ulRow + r, ulCol + (c * 4), boxColor)
      NEXT
    NEXT

    CALL SplitColor(boxColor, fg, bg)
    arrowColr = OneColor(0, bg)    

    FOR c = 1 TO 8
      FOR r = 1 TO 16
        temp = (((c - 1) * 16) + r) - 1
        CALL QPrintRC (RIGHT$("  " + STR$(temp), 3), ulRow + r, ulCol + (c * 4) - 3, temp)
        IF temp = colr THEN
          CALL QPrintRC (RIGHT$("  " + STR$(temp), 3), ulRow + r, ulCol + (c * 4) - 3, temp + 128)
          CALL QPrintRC (CHR$(17), ulRow + r, ulCol + (c * 4), arrowColr)
        END IF
      NEXT
    NEXT

    WHILE INKEY$ <> "": WEND              ' not sure needed.
    DO

      scanCode = MGetKey(row, column) ' scanCode might be returned to caller.

      SELECT CASE scanCode
        CASE -72 ' Up
          colr = colr - 1: EXIT DO
        CASE -80 ' Down
          colr = colr + 1: EXIT DO
        CASE -75 ' Left
          colr = colr - 16: EXIT DO
        CASE -77 ' Right
          colr = colr + 16: EXIT DO
        CASE -71 ' Home
          colr = 0: EXIT DO
        CASE -79 ' End
          colr = 127: EXIT DO
        CASE -73 ' PgUp
          colr = colr - (colr MOD 16): EXIT DO
        CASE -81 ' PgDn
          colr = colr - (colr MOD 16) + 15: EXIT DO
        CASE 13 ' Enter
          exitCode = 0: EXIT SUB
        ' CASE 1000 ' Mouse click
        '   r = row - (ulRow + 1): c = (col - ulCol) \ 2
        '   colr = ((r * 16) + c) - 1
        '   exitCode = 2: EXIT SUB
        CASE 27
          colr = prevClr: exitCode = 2: EXIT SUB
        CASE ELSE                         ' any other key,
      END SELECT

    LOOP

    IF colr < 0 THEN colr = colr + 128
    IF colr > 127 THEN colr = colr - 128

  LOOP

END SUB

SUB MColorPick(colr, boxColor, exitCode)
  CALL ColorPick(colr, boxColor, exitCode)
END SUB

SUB DirFile(array$(), first, count, scanCode, msgColor, fileColor, hiLiteColor, boxColor)

  'TODO: Take functionality in AMenu and embed it within this method.
  'TODO: Once embeded AMenu functionality done, need to update the currently selected filename "label".

  startItem = first

  CALL QPrintRC (STR$(count) +  " file(s) found", 8, 6, msgColor)

  ulRow = 10
  ulCol = 6
  lrRow = 18
  lrCol = 77
  CALL MPaintBox (ulRow, ulCol, lrRow, lrCol, fileColor)
  CALL Box0 (ulRow, ulCol, lrRow, lrCol, 1, boxColor)

  CALL QPrintRC ("Filename : " + "*UNKNOWN*", 20, 7, msgColor)
  CALL QPrintRC ("Use cursor keys to select file then press <ENTER>", 24, 4, msgColor)

  ulRow = ulRow + 1
  ulCol = ulCol + 2
  gap = 2
  rows = 7
  cols = 5
  CALL AMenu (array$(), first, startItem, count, scanCode, fileColor, hiLiteColor, rows, cols, gap, ulRow, ulCol)

END SUB

SUB Editor(ed$, activeLength, scanCode, numOnly, isCapsOn, normalColor, editColor, row, column) STATIC
  'TODO: Handle numOnly
  'TODO: Handle isCapsOn
  IF scanCode = 1 THEN
    'p = *what is was at last exit*
  ELSEIF scanCode = 2 THEN
    p = column
  ELSE
    p = 1
    ulRow = row
    ulCol = column
    originalEd$ = ed$
  END IF
  insert = 0
  LOCATE , , 1, 7, 7 ' single line cursor, on.
  DO
    LOCATE ulRow, ulCol + p - 1
    QPrintRC ed$, ulRow, ulCol, editColor
    WHILE INKEY$ <> "": WEND              ' not sure needed.
    DO
      scanCode = MGetKey(row, column) ' scanCode might be returned to caller.
      SELECT CASE scanCode
        CASE -83 ' Del
          ed$ = LEFT$(ed$, p - 1) + MID$(ed$, p + 1) + " "
          EXIT DO
        CASE -82 ' Ins
          insert = NOT insert
          IF insert THEN
            'LOCATE , , 1, 5, 7 ' quarter height cursor, on.
            LOCATE , , 1, 3, 7 ' half height cursor, on.
          ELSE
            LOCATE , , 1, 7, 7 ' single line cursor, on.
          END IF
        CASE 8 ' Backspace
          IF p = 1 THEN ' If pressed at beginning of the line, exit.
            QPrintRC ed$, ulRow, ulCol, normalColor
            activeLength = LEN(RTRIM$(ed$))
            LOCATE , , 0
            EXIT SUB
          END IF
          p = p -1: ed$ = LEFT$(ed$, p - 1) + MID$(ed$, p + 1) + " ": EXIT DO
        CASE -46 ' ALT+C
          p = 1: ed$ = SPACE$(LEN(ed$)): EXIT DO
        CASE -19 ' ALT+R
          ed$ = originalEd$
          ' IF LEN(RTRIM$(ed$)) > 0 THEN p = LEN(RTRIM$(ed$)) + 1 ELSE p = 1
          ' Removed the above line as it appears the original does not reset the cursor position.
          EXIT DO
        CASE -71 ' Home
          p = 1: EXIT DO
        CASE -79 ' End
          IF LEN(RTRIM$(ed$)) > 0 THEN p = LEN(RTRIM$(ed$)) + 1
          EXIT DO
        CASE -75 ' Left
          p = p - 1: EXIT DO
        CASE -77 ' Right
          p = p + 1: EXIT DO
        CASE 32 TO 126
          ch$ = CHR$(scanCode)
          IF numOnly THEN
            SELECT CASE scanCode
              CASE 45
              CASE 46
              CASE 48 TO 57
              CASE ELSE
                ch$ = ""
            END SELECT
          END IF
          IF ch$ <> "" THEN
            IF insert THEN ' insert
              ed$ = LEFT$(LEFT$(ed$, p - 1) + ch$ + MID$(ed$, p), LEN(originalEd$))
            ELSE ' overwrite
              MID$(ed$, p, 1) = ch$
            END IF
            p = p + 1
            EXIT DO
          END IF
        'CASE 13, 27 ' Enter, Esc
        CASE ELSE
          'QPrintRC STR$(scanCode) + "   ", 1, 1, 7
          QPrintRC ed$, ulRow, ulCol, normalColor
          activeLength = LEN(RTRIM$(ed$))
          LOCATE , , 0
          EXIT SUB
      END SELECT
    LOOP
    IF p < 1 THEN p = 1     
    IF p > LEN(ed$) THEN p = LEN(ed$)
    'QPrintRC STR$(p) + "   ", 2, 1, 7
  LOOP
END SUB

SUB Lts2Menu(Item$(), PromptParam$(), Choice, Colr)
  ERROR 73 ' Feature Unavailable
END SUB

SUB LtsMenu(Item$(), Choice, Colr)
  ERROR 73 ' Feature Unavailable
END SUB

' MAMenu is a full-featured multi-column menu routine, which allows
' selecting items either with the keyboard or a mouse. This is a mouse-aware
' version of the original AMenu routine, which is described elsewhere.
SUB MAMenu(array$(), first, selection, start, count, scanCode, normColor, hiLiteColor, numRows, numCols, gap, row, column)
  w = LEN(array$(start))                ' width of each column.
  ulRow = row                           ' store menu location because row and column
  ulCol = column                        ' are replaced with mouse coords on return
  IF scanCode <> 3 THEN
    DO
      IF selection > start + ((numRows * numCols) - 1) THEN
        start = start + (numRows * numCols)
      ELSE
        EXIT DO
      END IF
    LOOP
  END IF
  DO
    DO
      IF selection < start THEN         ' current item before the display range?
        start = start - numRows        ' scroll display to the left.
      ELSEIF selection > start + ((numRows * numCols) - 1) THEN ' current item beyond the display range?
        start = start + numRows        ' scroll display to the right.
      ELSE
        EXIT DO
      END IF
    LOOP
    FOR rr = 0 TO numRows - 1           ' for each display row,
      FOR cc = 0 TO numCols - 1         ' for each display column,
        index = start + rr + (cc * numRows) ' determine element index,
        IF index = selection THEN clr = hiLiteColor ELSE clr = normColor ' determine color,
        IF index <= UBOUND(array$) THEN text$ = array$(index) ELSE text$ = SPACE$(w) ' determine text (can be blank),
        QPrintRC text$, ulRow + rr, ulCol + (cc * (w + gap)), clr ' render text.
      NEXT
    NEXT
    IF scanCode = 9999 THEN EXIT SUB     'TODO: For testing...
    WHILE INKEY$ <> "": WEND              ' not sure needed.
    DO
      scanCode = MGetKey(row, column) ' scanCode might be returned to caller.
      SELECT CASE scanCode
        CASE -72 ' Up
          IF selection > 1 THEN          ' if current more than min,
            selection = selection - 1   ' decrement.
          END IF
          EXIT DO
        CASE -80 ' Down
          IF selection < UBOUND(array$) THEN  ' if current less than max,
            selection = selection + 1        ' increment.
          END IF
          EXIT DO
        CASE -75 ' Left
          IF selection - numRows > 0 THEN    ' more columns to the left?
            selection = selection - numRows ' shift columns right.
          ELSEIF selection > 1 THEN           ' if not shifted (above),
            selection = 1                     ' set current item to first.
          END IF
          EXIT DO
        CASE -77 ' Right
          IF selection + numRows <= UBOUND(array$) THEN ' more columns to the right?
            selection = selection + numRows            ' shift columns left.
          ELSEIF selection < UBOUND(array$) THEN         ' if not shifted (above),
            selection = UBOUND(array$)                   ' set current item to last.
          END IF
          EXIT DO
        CASE ELSE                         ' any other key,
          EXIT SUB                        ' return to caller.
      END SELECT
    LOOP
  LOOP
END SUB

SUB MAMenuT(Array$(), First, Selection, Start, Length, Count, ScanCode, NormalColor, Hilight, NumRows, NumCols, Gap, Row, Column)
  ERROR 73 ' Feature Unavailable
END SUB

SUB MaskIn(Mask$, Text$, Mski)
  ERROR 73 ' Feature Unavailable
END SUB

SUB MEditor(ed$, activeLength, scanCode, numOnly, isCapsOn, normalColor, editColor, row, column, currentColumn)
  column = currentColumn
  CALL Editor(ed$, activeLength, scanCode, numOnly, isCapsOn, normalColor, editColor, row, column)
END SUB

SUB MenuVert(Array$(), First, NumLines, ScanCode, Choice, NormalColr, HiLiteColor, Row, Column)
  'TODO: Pretty much looks like a single column version of AMenu.
  ERROR 73 ' Feature Unavailable
END SUB

' MGetKey first clears the keyboard buffer of any pending keys, and 
' then waits until either a key or mouse button has been pressed. This 
' is a "mouse-aware" version of the QuickPak Professional WaitKey routine. 
FUNCTION MGetKey(row, col)
  ' scanCode is returned holding the key or mouse button that was 
  ' pressed, and row and col indicate the location of the 
  ' mouse cursor at the time the mouse button was pressed. 
  WHILE INKEY$ <> "": WEND
  DO: CALL GetCursor(x, y, button): LOOP UNTIL button = 0
  DO
    CALL GetCursor(x, y, button)
    IF _PIXELSIZE = 0 THEN
      col = (x \ 8) + 1
      row = (y \ 8) + 1
    END IF
    IF (button AND 1) = 1 THEN MGetKey = 1000: EXIT DO
    IF (button AND 2) = 2 THEN MGetKey = 1001: EXIT DO
    IF (button AND 4) = 4 THEN MGetKey = 1002: EXIT DO
    a$ = INKEY$
    IF a$ <> "" THEN
      IF LEN(a$) = 1 THEN
        MGetKey = ASC(a$)
      ELSE
        MGetKey = -ASC(RIGHT$(a$, 1))
      END IF
      EXIT DO
    END IF
  LOOP
END FUNCTION

SUB MMenuVert(Array$(), First, Selection, Start, ScanCode, NormalColr, Hilight, NumRows, Row, Column)
  ERROR 73 ' Feature Unavailable
END SUB

SUB Spread(Wks$(), Format$(), ColumnWidths(), Wide, Rows, Action)
  ERROR 73 ' Feature Unavailable
END SUB

SUB YesNo(YN$, PromptParam$, ScanCode, NormalColor, EditColor, Row, Column)
  ERROR 73 ' Feature Unavailable
END SUB

' ****************************************
' Chapter 6 - Keyboard / Mouse Routines
' ****************************************

FUNCTION AltKey
  ' See ALTKEY.ASM
  LALT& = 100308
  RALT& = 100307
  AltKey = _KEYDOWN(LALT&) OR _KEYDOWN(RALT&)
END FUNCTION

' ButtonPress will report how many times a specified mouse button 
' was pressed since the last time it was called. It also returns the X/Y 
' coordinates where the mouse cursor was located when that button 
' was last pressed. 
SUB ButtonPress (button, status, count, x, y)

  ' NOTE: it appears that button press count is monitored "outside" of
  '       this method; it is reset within this method to 0 (I think?), 
  '       but will need to figure out a way to determine the number of
  '       presses (clicks) some other way.

  ' button is the button of interest, with a 1 indicating button 1,  
  ' 2 meaning button 2, and 3 for button 3 (if the mouse has a third button). 

  ' status is the current button status, and has the same meaning as 
  ' the information returned by the GetCursor mouse routine. 

    button1 = _MOUSEBUTTON(1)
    button2 = _MOUSEBUTTON(2)
    button3 = _MOUSEBUTTON(3)
    status = 0
    IF button = 1 AND button1 THEN status = 1
    IF button = 2 AND button2 THEN status = status + 2
    IF button = 3 AND button3 THEN status = status + 4

  ' Count tells how many times the button has been pressed since 
  ' ButtonPress was last called. X and Y hold the mouse cursor 
  ' position at the time the button was pressed. Use the GetCursor 
  ' routine to determine the current mouse cursor location. 

  IF _MOUSEINPUT THEN 
    ' WHILE _MOUSEBUTTON(button)
    '   IF button = 1 THEN count1 = count1 + 1
    '   IF button = 2 THEN count2 = count2 + 1
    '   IF button = 3 THEN count3 = count3 + 1
    ' WEND
    IF _MOUSEBUTTON(1) THEN count1 = count1 + 1
    IF _MOUSEBUTTON(2) THEN count2 = count2 + 1
    IF _MOUSEBUTTON(3) THEN count3 = count3 + 1
    IF _PIXELSIZE = 0 THEN
      col = _MOUSEX
      row = _MOUSEY
      x = (col - 1) * 8
      y = (row - 1) * 8
    ELSE
      x = _MOUSEX
      y = _MOUSEY
    END IF
    lastX = x
    lastY = y
  ELSE
    x = lastX
    y = lastY
  END IF
  
  IF button = 1 THEN count = count1: count1 = 0
  IF button = 2 THEN count = count2: count2 = 0
  IF button = 3 THEN count = count3: count3 = 0

END SUB

FUNCTION CapsLock
  ERROR 73 ' Feature Unavailable
END FUNCTION

SUB CapsOff
  ERROR 73 ' Feature Unavailable
ENd SUB

SUB CapsOn
  ERROR 73 ' Feature Unavailable
END SUB

' ClearBuf will quickly clear the keyboard of any key strokes that are 
' currently pending. 
SUB ClearBuf
  'WHILE INKEY$ <> "": WEND 
  _KEYCLEAR
END SUB

FUNCTION CtrlKey
  ERROR 73 ' Feature Unavailable
END FUNCTION

' GetCursor reports the current location of the mouse cursor, and 
' which mouse buttons are currently depressed. 
SUB GetCursor (x, y, button) STATIC
  ' x and y return holding the current mouse cursor coordinates, 
  ' and button is bit coded to indicate which buttons are currently 
  ' down. 
  IF _MOUSEINPUT THEN
    IF _PIXELSIZE = 0 THEN
      col = _MOUSEX
      row = _MOUSEY
      x = (col - 1) * 8
      y = (row - 1) * 8
    ELSE
      x = _MOUSEX
      y = _MOUSEY
    END IF
    button1 = _MOUSEBUTTON(1)
    button2 = _MOUSEBUTTON(2)
    button3 = _MOUSEBUTTON(3)
    button = 0
    IF button1 THEN button = 1
    IF button2 THEN button = button + 2
    IF button3 THEN button = button + 4
    lastX = x
    lastY = y
    lastButton = button
  ELSE
    x = lastX
    y = lastY
    button = lastButton
  END IF
END SUB

' GetCursorT reports the current location of the mouse cursor, and 
' which mouse buttons are currently depressed.
SUB GetCursorT(row, col, button)
  ' col and row return holding the current mouse coordinates, and 
  ' button is bit-coded to indicate which buttons are currently being pressed. 
  CALL GetCursor(x, y, button)
  IF _PIXELSIZE = 0 THEN
    col = (x \ 8) + 1
    row = (y \ 8) + 1
  END IF
END SUB

' GrafCursor greatly simplifies defining the shape of the mouse 
' cursor for use in graphics mode. 
SUB GrafCursor(x, y, cursor$)
  ' x and y define the cursor "hot spot", and cursor$ is either a 
  ' conventional or fixed-length string that contains the new cursor shape. 

  ' https://learn.microsoft.com/en-us/windows/win32/menurc/using-cursors

  ' NOT IMPLEMENTED

END SUB

SUB HideCursor
  _MOUSEHIDE
END SUB

' InitMouse is used both to determine if a mouse is present in the host 
' PC, and to reset the mouse driver software to its default values. 
SUB InitMouse(there)
  ' there receives -1 if a mouse is present, or O if no mouse is installed. 
  there = -1 ' we are working on modern platforms, of course there is a mouse.
END SUB

FUNCTION InStat
  ERROR 73 ' Feature Unavailable
END FUNCTION

SUB Keyboard(Row, Column, Color1, Color2, Mode)
  ERROR 73 ' Feature Unavailable
END SUB

' KeyDown reports if any keys are currently being pressed. 
FUNCTION KeyDown

  ' Set to -1 (True) if a key is currently being pressed, or 
  ' 0 if no keys are pressed. 

  bksp = _KEYDOWN(8)
  tb = _KEYDOWN(9)
  entr = _KEYDOWN(13)
  esc = _KEYDOWN(27) ' ESC

  f1 = _KEYDOWN(15104) ' F1
  f2 = _KEYDOWN(15360) ' F2
  f3 = _KEYDOWN(15616) ' F3
  f4 = _KEYDOWN(15872) ' F4
  f5 = _KEYDOWN(16128) ' F5
  f6 = _KEYDOWN(16384) ' F6
  f7 = _KEYDOWN(16640) ' F7
  f8 = _KEYDOWN(16896) ' F8
  f9 = _KEYDOWN(17152) ' F9
  f10 = _KEYDOWN(17408) ' F10
  f11 = _KEYDOWN(34048) ' F11
  f12 = _KEYDOWN(34304) ' F12
  ins = _KEYDOWN(20992) ' INS
  hm = _KEYDOWN(18176) ' HOME
  pgup = _KEYDOWN(18688) ' PGUP
  del = _KEYDOWN(21248) ' DEL
  ed = _KEYDOWN(20224) ' END
  pgdn = _KEYDOWN(20736) ' PGDN
  up = _KEYDOWN(18432) ' UP
  dn = _KEYDOWN(20480) ' DN
  lt = _KEYDOWN(19200) ' LEFT
  rt = _KEYDOWN(19712) ' RIGHT
  num = _KEYDOWN(100300) ' Num Lock
  caps = _KEYDOWN(100301) ' Caps Lock
  rshift = _KEYDOWN(100303) ' Right Shift
  lshift = _KEYDOWN(100304) ' Left Shift
  rctrl = _KEYDOWN(100305) ' Right Control
  lctrl = _KEYDOWN(100306) ' Left Control
  ralt = _KEYDOWN(100307) ' Right Alt
  lalt = _KEYDOWN(100308) ' Left Alt

  atoz = 0
  FOR i = 32 TO 126
    IF _KEYDOWN(i) THEN atoz = 1: EXIT FOR
  NEXT

  accum& = bksp + tb + entr + esc
  accum& = accum& + f1 + f2 + f3 + f4 + f5 + f6 + f7 + f8 + f9 + f10 + f11 + f12
  accum& = accum& + hm + pgup + del + ed + pgdn + up + dn + lt + rt
  accum& = accum& + num + caps + rshift + lshift + rctrl + lctrl + ralt + lalt
  accum& = accum& + atoz

  IF accum& THEN
    KeyDown = -1
  ELSE
    KeyDown = 0
  END IF

END FUNCTION

SUB Motion(Value)
  ERROR 73 ' Feature Unavailable
END SUB

SUB Mouse(AX, BX, CX, DX)
  ERROR 73 ' Feature Unavailable
END SUB

' MouseRange will return a range number that tells where the mouse 
' cursor is located, based on an array of screen coordinates. 
SUB MouseRange(array() AS Area, start, numEls, row, col, button, rangeNum)
  ' array() / start is the first element in a special TYPE array, and 
  ' numEls is the number of elements in that array. row and 
  ' col return the current location of the mouse cursor, button 
  ' indicates which mouse button is currently depressed, and 
  ' rangeNum holds the range within which the cursor is located.
  rangeNum = 0 ' no current window
  row = -1: col = -1 
  CALL GetCursorT(row, col, button)
  IF button > 0 THEN
    FOR entry = numEls TO start STEP - 1
      IF row >= array(entry).Y1 AND row <= array(entry).Y2 THEN
        IF col >= array(entry).X1 AND col <= array(entry).X2 THEN
          IF array(entry).RN = -1 THEN
            rangeNum = entry
          ELSE
            rangeNum = array(entry).RN
          END IF
          EXIT FOR
        END IF
      END IF
    NEXT
  END IF
END SUB

SUB MouseRange1(array() AS Area, start, numEls, row, col, button, rangeNum)
  rangeNum = 0 ' no current window
  row = -1: col = -1 
  CALL GetCursorT(row, col, button)
  FOR entry = numEls TO start STEP - 1
    IF row >= array(entry).Y1 AND row <= array(entry).Y2 THEN
      IF col >= array(entry).X1 AND col <= array(entry).X2 THEN
        IF array(entry).RN = -1 THEN
          rangeNum = entry
        ELSE
          rangeNum = array(entry).RN
        END IF
        EXIT FOR
      END IF
    END IF
  NEXT
END SUB

' MouseRangeG works in the same way as MouseRange, 
' but all parameters are given and returned as pixels 
' instead of rows and columns. 
SUB MouseRangeG(array() AS Area, start, numEls, x, y, button, rangeNum)
  rangeNum = 0 ' no current window
  x = -1: y = -1 
  CALL GetCursor(x, y, button)
  IF button > 0 THEN
    FOR entry = numEls TO start STEP - 1
      IF y >= array(entry).Y1 AND y <= array(entry).Y2 THEN
        IF x >= array(entry).X1 AND x <= array(entry).X2 THEN
          IF array(entry).RN = -1 THEN
            rangeNum = entry
          ELSE
            rangeNum = array(entry).RN
          END IF
          EXIT FOR
        END IF
      END IF
    NEXT
  END IF
END SUB

SUB MouseRangeG1(array() AS Area, start, numEls, x, y, button, rangeNum)
  rangeNum = 0 ' no current window
  x = -1: y = -1 
  CALL GetCursor(x, y, button)
  FOR entry = numEls TO start STEP - 1
    IF y >= array(entry).Y1 AND y <= array(entry).Y2 THEN
      IF x >= array(entry).X1 AND x <= array(entry).X2 THEN
        IF array(entry).RN = -1 THEN
          rangeNum = entry
        ELSE
          rangeNum = array(entry).RN
        END IF
        EXIT FOR
      END IF
    END IF
  NEXT
END SUB

FUNCTION MBuffSize
  'ERROR 73 ' Feature Unavailable
END FUNCTION

SUB MGetState(Buffer$)
  'ERROR 73 ' Feature Unavailable
END SUB

SUB MSetState(Buffer$)
  'ERROR 73 ' Feature Unavailable
END SUB

' MouseTrap will establish the allowable range of movement for the mouse cursor. 
SUB MouseTrap(ulRow, ulCol, lrRow, lrCol)
  ' https://learn.microsoft.com/en-us/windows/win32/api/winuser/nf-winuser-clipcursor
  ' https://learn.microsoft.com/en-us/windows/win32/api/winuser/nf-winuser-getclipcursor
  ' https://learn.microsoft.com/en-us/windows/win32/menurc/using-cursors

  EXIT SUB 'NOTE: Disabling functionality.

  DIM rec AS Rectangle
  IF _PIXELSIZE = 0 THEN
    rec.left = (ulCol - 1) * 8
    rec.top = (ulRow - 1) * 8
    rec.bottom = lrRow * 8
    rec.right = lrcol * 8
  ELSE
    rec.left = ulCol
    rec.top = ulRow
    rec.bottom = lrRow
    rec.right = lrcol
  END IF
  work = ClipCursor(rec)

END SUB

' NumLock will quickly tell if the NumLock key is currently depressed. 
FUNCTION NumLock
  ' Active receives -1 if the NumLock key is currently down, or O if it is not. 
  NumLock = _NUMLOCK
END FUNCTION

' NumOff turns off the NumLock key status. 
SUB NumOff
  _NUMLOCK OFF
END SUB

' NumOn turns on the NumLock key status. 
SUB NumOn
  _NUMLOCK ON
END SUB

' PeekBuf provides a handy way to determine what key if any is the 
' next one pending in the keyboard buffer, without actually removing 
' it as INKEY$ does. 
FUNCTION PeekBuf
  ' Char receives the ASCII value of the pending key if it is a normal 
  ' key, 0 if no keys are pending at all, or a negative value representing 
  ' an extended key's scan code. 
  PeekBuf = INP(&H60)
END FUNCTION

SUB RptKey(Char, Count)
  ERROR 73 ' Feature Unavailable
END SUB

FUNCTION ScrlLock
  ERROR 73 ' Feature Unavailable
END FUNCTION

SUB SetCursor(x, y)
  ' https://learn.microsoft.com/en-us/windows/win32/menurc/using-cursors
  _MOUSEMOVE x, y
END SUB

FUNCTION ShiftKey
  KEY_LSHIFT& = 100304
  KEY_RSHIFT& = 100303
  ShiftKey = _KEYDOWN(KEY_LSHIFT&) OR _KEYDOWN(KEY_RSHIFT&)
END FUNCTION

SUB ShowCursor
  _MOUSESHOW
END SUB

SUB StuffBuf(X$)
  ' User32 (Windows) SendInput https://learn.microsoft.com/en-us/windows/win32/api/winuser/nf-winuser-sendinput API
  'ERROR 73 ' Feature Unavailable
END SUB

' TextCursor provides an easy way to initialize the mouse cursor in 
' text mode, and define its color. 
SUB TextCursor(FG, BG)
  ' NOTE: I'm not sure that this is required (or is even possible)
  '       within the context of QB64 - for now, just stub.
END SUB

' FUNCTION WaitKey
'   WHILE INKEY$ <> "": WEND ' Clear any pending key strokes.
'   WHILE INKEY$ = "": WEND ' Wait for a key.
'   ' TODO: Return the key value.
' END FUNCTION

' WaitKey first clears the keyboard buffer of any keys that may be 
' pending, and then waits until a key is pressed. 
' SUB WaitKey
'   WHILE INKEY$ <> "": WEND ' Clear any pending key strokes.
'   WHILE INKEY$ = "": WEND ' Wait for a key.
' END SUB

FUNCTION WaitKey
  WHILE INKEY$ <> "": WEND ' Clear any pending key strokes.
  DO ' Wait for a key.
    a$ = INKEY$
    IF a$ <> "" THEN
      IF LEN(a$) = 1 THEN
        WaitKey = ASC(a$)
      ELSE
        WaitKey = -ASC(RIGHT$(a$, 1))
      END IF
      EXIT DO
    END IF
  LOOP
END SUB

SUB WaitKeyS
  WHILE INKEY$ <> "": WEND ' Clear any pending key strokes.
  DO ' Wait for a key.
    a$ = INKEY$
    IF a$ <> "" THEN
      EXIT DO
    END IF
  LOOP
END SUB

FUNCTION WaitScan
  ERROR 73 ' Feature Unavailable
END FUNCTION

' WaitUp halts a program's execution until no mouse buttons are being depressed. 
SUB WaitUp
  DO
    Call GetCursor(x, y, button)
  LOOP WHILE button
END SUB

' **************************************
' Chapter 7 - Miscellaneous Routines
' **************************************

FUNCTION AddUSI(X, Y)
  ' See ADDUSI.ASM
  ERROR 73 ' Feature Unavailable
END FUNCTION

SUB BCopy(src AS _MEM, dest AS _MEM, numBytes, direction)
'SUB BCopy(fromSeg, fromAddr, toSeg, toAddr, numBytes, direction)

  ' FromSeg% and FromAddr% indicate the source location of the 
  ' block, and ToSeg% and ToAddr% tell where to copy it to. 
  ' NumBytes% is, well, you can figure that one out. Direction% is 
  ' either O to copy in the forward direction, or -1 to copy backwards. 

  DIM totalSize AS _OFFSET: totalSize = numEls * size
  
  IF direction = 0 THEN
    _MEMCOPY src, src.OFFSET, totalSize TO dest, dest.OFFSET
  ELSE
    ' Not really sure what this means.
    ' Also, of the included examples that use BCopy, 
    ' **ALL** of them are passing a 0 for this param.
    ERROR 73 ' Feature Unavailable
  END IF

END SUB

' BCopyT will copy one or more elements in a TYPE array to 
' another array, or to any location in memory. Alternately, BCopyT 
' can be used to move any contiguous block of memory, even if the 
' number of bytes exceeds 65536. 
SUB BCopyT(src AS _MEM, dest AS _MEM, elSize, numEls)
'SUB BCopyT(SEG fromEl, SEG toEl, elSize, numEls) 
'SUB BCopyT(fromSeg, fromAdr, toSeg, toAdr%, numBytes, numEls) 
'SUB BCopyT(src AS _MEM, srcEl, dest AS _MEM, destEl, elSize, numEls)

  ' FromEl is the starting element of the source array and ToEl is the 
  ' starting element in the destination array. El Size% is the size of each 
  ' element in bytes, or a special code (see below). NumEls% is the 
  ' number of elements to be copied. 
  '
  ' With the alternate call form, FromSeg%, FromAdr%, ToSeg%, and 
  ' ToAdr% define the source and destination segments and addresses. 
  ' NumBytes % then tells how many bytes are to be copied. 

  ' PRINT v.OFFSET; " the beginning of the memory block as _OFFSET"
  ' PRINT v.SIZE; " the largest available region of memory of the ELEMENT in bytes as _OFFSET"
  ' PRINT v.ELEMENTSIZE; " the byte size of the elements within the blocks AS _OFFSET"
  ' PRINT "     ^----- represents the memory block 'left', from the current element to max"

  ' PRINT v.TYPE; " the type (represented as bits combined to form a value"
  ' IF v.TYPE AND 1 THEN PRINT "   BIT 01: _BYTE"
  ' IF v.TYPE AND 2 THEN PRINT "   BIT 02: INTEGER"
  ' IF v.TYPE AND 4 THEN PRINT "   BIT 03: LONG or SINGLE"
  ' IF v.TYPE AND 8 THEN PRINT "   BIT 04: DOUBLE or _INTEGER64"
  ' IF v.TYPE AND 16 THEN PRINT "   BIT 05: Not Defined"
  ' IF v.TYPE AND 32 THEN PRINT "   BIT 06: _FLOAT"
  ' IF v.TYPE AND 64 THEN PRINT "   BIT 07: Not Defined"
  ' IF v.TYPE AND 128 THEN PRINT "   BIT 08: 'integer type'"
  ' IF v.TYPE AND 256 THEN PRINT "   BIT 09: 'floating point type'"
  ' IF v.TYPE AND 512 THEN PRINT "   BIT 10: string (fixed or variable length)"
  ' IF v.TYPE AND 1024 THEN PRINT "   BIT 11: _UNSIGNED"
  ' IF v.TYPE AND 2048 THEN PRINT "   BIT 12: _MEMIMAGE"
  ' IF v.TYPE AND 4096 THEN PRINT "   BIT 13: _MEM TYPE structure"
  ' IF v.TYPE AND 8192 THEN PRINT "   BIT 14: _OFFSET"
  ' IF v.TYPE AND 16384 THEN PRINT "   BIT 15: _MEMNEW(size) or _MEMNEW(offset_size)"
  ' IF v.TYPE AND 32768 THEN PRINT "   BIT 16: UDT (TYPE...END TYPE)"
  ' IF v.TYPE AND 65536 THEN PRINT "   BIT 17: an array of data"

  SELECT CASE elSize
    CASE -1 : size = 2 ' 2-byte integer 
    CASE -2 : size = 4 ' 4-byte long integer
    CASE -3 : size = 4 ' 4-byte single precision
    CASE -4 : size = 8 ' 8-byte double precision
    CASE IS > 0: size = elSize
    CASE ELSE
      EXIT SUB
  END SELECT

  'DIM srcOffset AS _OFFSET: srcOffset = src.OFFSET + ((srcEl - 1) * size)
  'DIM destOffset AS _OFFSET: destOffset = dest.OFFSET + ((destEl - 1) * size)
  DIM totalSize AS _OFFSET: totalSize = numEls * size
  
  _MEMCOPY src, src.OFFSET, totalSize TO dest, dest.OFFSET

END SUB

SUB BLPrint(LPTNumber, X$, ErrorCount)
  ERROR 73 ' Feature Unavailable
END SUB

' Chime provides five different types of beep tones, and five short 
' attention-getting trill sounds.
SUB Chime(number)

  SELECT CASE number
    CASE 1: QPSound 100, 5
    CASE 2: QPSound 200, 5
    CASE 3: QPSound 400, 5
    CASE 4: QPSound 800, 5
    CASE 5: QPSound 1600, 5
    CASE 6
      QPSound 659, 1
      QPSound 523, 1
      QPSound 659, 1
      QPSound 523, 1
    CASE 7
      FOR i = 300 TO 750 STEP 50
        QPSound i, 1
      NEXT
    CASE 8
      FOR i = 1000 TO 1700 STEP 100
        QPSound i, 1
      NEXT
    CASE 9
      FOR i = 1 TO 6
        QPSound 200 * i, 1
      NEXT
    CASE 10
      QPSound 220, 1
      QPSound 330, 1
      QPSound 440, 1
      QPSound 660, 1
      QPSound 880, 1
      QPSound 1319, 1
      QPSound 1760, 1
    CASE ELSE
  END SELECT

END SUB

SUB Clock(Row, Column, Colr, Mode)
  ERROR 73 ' Feature Unavailable
END SUB

SUB Clock24(Row, Column, Colr, Mode)
  ERROR 73 ' Feature Unavailable
END SUB

' Compare will compare any two blocks of memory, and report if they are the same. 
FUNCTION Compare(segAdr1 AS _MEM, segAdr2 AS _MEM, numBytes)
'FUNCTION Compare(Seg1, Adr1, Seg2, Adr2, NumBytes)

  SELECT CASE numBytes
    CASE -1: size = 2
    CASE -2: size = 4
    CASE -3: size = 4
    CASE -4: size = 8
    CASE ELSE: size = numBytes
  END SELECT

  s1$ = SPACE$(size)
  s2$ = SPACE$(size)
  _MEMGET segAdr1, segAdr1.OFFSET, s1$
  _MEMGET segAdr2, segAdr2.OFFSET, s2$
  Compare = (s1$ = s2$)

END FUNCTION

' CompareT will compare any two TYPE variables, and report if they are the same. 
FUNCTION CompareT(type1 AS _MEM, type2 AS _MEM, numBytes)
  s1$ = SPACE$(numBytes)
  s2$ = SPACE$(numBytes)
  _MEMGET type1, type1.OFFSET, s1$
  _MEMGET type2, type2.OFFSET, s2$
  CompareT = (s1$ = s2$)
END FUNCTION

' Date2Num converts a date in string form to an equivalent integer variable. 
FUNCTION Date2Num (dat$) STATIC

  d$ = dat$

  REDIM dyMth(13)            ' DyMth() holds number of days into the year
  ' RESTORE                     '   for a given month
  ' FOR c = 1 TO 13
  '   READ dyMth(C)
  ' NEXT
  ' DATA 0, 31, 59, 90, 120, 151, 181, 212, 243, 273, 304, 334, 365

  dyMth(1) = 0
  dyMth(2) = 31
  dyMth(3) = 59
  dyMth(4) = 90
  dyMth(5) = 120
  dyMth(6) = 151
  dyMth(7) = 181
  dyMth(8) = 212
  dyMth(9) = 243
  dyMth(10) = 273
  dyMth(11) = 304
  dyMth(12) = 334
  dyMth(13) = 365

  p = 1 ' pointer
  c$ = "" ' collector
  part = 1 ' 3 parts; 1) month, 2) day, 3) year
  collect = 0 ' 
  DO
    IF p > LEN(dat$) THEN
      ch$ = ""
    ELSE
      ch$ = MID$(dat$, p, 1) ' current character
    END IF
    SELECT CASE ch$
      CASE "1", "2", "3", "4", "5", "6", "7", "8", "9", "0"
        c$ = c$ + ch$
        IF part < 3 AND LEN(c$) = 2 THEN collect = -1
      CASE ELSE
        IF LEN(c$) > 0 THEN collect = -1
    END SELECT
    IF collect <> 0 THEN
      SELECT CASE part
        CASE 1: month = VAL(c$): c$ = "": part = part + 1
        CASE 2: day = VAL(c$): c$ = "": part = part + 1
        CASE 3: year = VAL(c$): EXIT DO
        CASE ELSE
      END SELECT
      collect = 0
    END IF
    p = p + 1
  LOOP

  'NOTE: remarked out the three lines below in favor of a more complete parser (above)

  ' year = VAL(MID$(dat$, 7))                  ' Read year
  IF year >= 1900 THEN year = year - 1900

  'month = VAL(LEFT$(dat$, 2))                ' Extract Month #
  'day = VAL(MID$(dat$, 4, 2))                ' Extract Day #

  days = (year - 80!) * 365
  IF year >= 80 THEN
    adDays = (year - 77) \ 4
  ELSE
    adDays = (year - 80) \ 4
  END IF

  days = days + adDays                    ' Add a day for each Leap Year
  'LeapYr below is 0 when true!
  leapYr = year MOD 4                      ' Find Leap year flag
  IF year = 0 THEN leapYr = 1    'EW 12-13-95: 1900 <> leap year, 2000 is
  days = days + dyMth(month) + day      ' Add # of days into year

  ' If leap year, add 1 day
  IF leapYr = 0 AND month > 2 THEN days = days + 1
  Date2Num = days

END FUNCTION

FUNCTION DayName$(day)
  SELECT CASE day
    CASE 1: DayName$ = "Sun"
    CASE 2: DayName$ = "Mon"
    CASE 3: DayName$ = "Tue"
    CASE 4: DayName$ = "Wed"
    CASE 5: DayName$ = "Thu"
    CASE 6: DayName$ = "Fri"
    CASE 7: DayName$ = "Sat"
    CASE ELSE
      DayName$ = ""
  END SELECT
END FUNCTION

SUB DirTree(Tree$(), FullPath$(), Levels)
  ERROR 73 ' Feature Unavailable
END SUB

FUNCTION EDate2Num(Dat$)
  ERROR 73 ' Feature Unavailable
END FUNCTION

' As its name implies, Empty is an empty procedure that does absolutely
' nothing. However, Empty is invaluable when timing BASIC functions, 
' precisely because it takes such little time to execute. 
SUB Empty(dummy)
  ' do nothing.
END SUB

FUNCTION ENum2Date$(Days)
  ERROR 73 ' Feature Unavailable
END FUNCTION

SUB Extended
  ERROR 73 ' Feature Unavailable
END SUB

FUNCTION Factorial#(Number)
  SELECT CASE number
    CASE 0: Factorial# = 1.0                           
    CASE 1: Factorial# = 1.0                           
    CASE 2: Factorial# = 2.0                           
    CASE 3: Factorial# = 6.0                           
    CASE 4: Factorial# = 24.0                          
    CASE 5: Factorial# = 120.0                         
    CASE 6: Factorial# = 720.0                         
    CASE 7: Factorial# = 5040.0                        
    CASE 8: Factorial# = 40320.0                       
    CASE 9: Factorial# = 362880.0                      
    CASE 10: Factorial# = 3628800.0                    
    CASE 11: Factorial# = 39916800.0                   
    CASE 12: Factorial# = 479001600.0                  
    CASE 13: Factorial# = 6227020800.0                 
    CASE 14: Factorial# = 87178291200.0                
    CASE 15: Factorial# = 1307674368000.0              
    CASE 16: Factorial# = 20922789888000.0             
    CASE 17: Factorial# = 355687428096000.0            
    CASE 18: Factorial# = 6402373705728000.0           
    CASE 19: Factorial# = 1.21645100408832E+17         
    CASE 20: Factorial# = 2.43290200817664E+18         
    CASE 21: Factorial# = 5.109094217170944E+19        
    CASE 22: Factorial# = 1.124000727777608E+21        
    CASE 23: Factorial# = 2.585201673888498E+22        
    CASE 24: Factorial# = 6.204484017332394E+23        
    CASE 25: Factorial# = 1.551121004333098E+25        
    CASE 26: Factorial# = 4.032914611266057E+26        
    CASE 27: Factorial# = 1.088886945041835E+28        
    CASE 28: Factorial# = 3.048883446117138E+29        
    CASE 29: Factorial# = 8.841761993739701E+30        
    CASE 30: Factorial# = 2.652528598121911E+32        
    CASE 31: Factorial# = 8.222838654177924E+33        
    CASE 32: Factorial# = 2.631308369336936E+35        
    CASE 33: Factorial# = 8.683317618811889E+36        
    CASE 34: Factorial# = 2.952327990396041E+38        
    CASE 35: Factorial# = 1.033314796638614E+40        
    CASE 36: Factorial# = 3.719933267899013E+41        
    CASE 37: Factorial# = 1.376375309122635E+43        
    CASE 38: Factorial# = 5.23022617466601E+44         
    CASE 39: Factorial# = 2.039788208119745E+46        
    CASE 40: Factorial# = 8.15915283247898E+47         
    CASE 41: Factorial# = 3.34525266131638E+49         
    CASE 42: Factorial# = 1.40500611775288E+51         
    CASE 43: Factorial# = 6.041526306337384E+52        
    CASE 44: Factorial# = 2.65827157478845E+54         
    CASE 45: Factorial# = 1.196222208654802E+56        
    CASE 46: Factorial# = 5.502622159812089E+57        
    CASE 47: Factorial# = 2.586232415111683E+59        
    CASE 48: Factorial# = 1.241391559253607E+61        
    CASE 49: Factorial# = 6.082818640342679E+62        
    CASE 50: Factorial# = 3.041409320171338E+64        
    CASE 51: Factorial# = 1.551118753287382E+66        
    CASE 52: Factorial# = 8.06581751709439E+67         
    CASE 53: Factorial# = 4.274883284060024E+69        
    CASE 54: Factorial# = 2.308436973392413E+71        
    CASE 55: Factorial# = 1.269640335365826E+73        
    CASE 56: Factorial# = 7.109985878048632E+74        
    CASE 57: Factorial# = 4.052691950487723E+76        
    CASE 58: Factorial# = 2.350561331282879E+78        
    CASE 59: Factorial# = 1.386831185456898E+80        
    CASE 60: Factorial# = 8.32098711274139E+81         
    CASE 61: Factorial# = 5.075802138772246E+83        
    CASE 62: Factorial# = 3.146997326038794E+85        
    CASE 63: Factorial# = 1.98260831540444E+87         
    CASE 64: Factorial# = 1.268869321858841E+89        
    CASE 65: Factorial# = 8.247650592082472E+90        
    CASE 66: Factorial# = 5.443449390774432E+92        
    CASE 67: Factorial# = 3.647111091818871E+94        
    CASE 68: Factorial# = 2.48003554243683E+96         
    CASE 69: Factorial# = 1.711224524281413E+98        
    CASE 70: Factorial# = 1.197857166996989E+100       
    CASE 71: Factorial# = 8.504785885678624E+101       
    CASE 72: Factorial# = 6.123445837688612E+103       
    CASE 73: Factorial# = 4.470115461512686E+105       
    CASE 74: Factorial# = 3.307885441519387E+107       
    CASE 75: Factorial# = 2.48091408113954E+109        
    CASE 76: Factorial# = 1.885494701666051E+111       
    CASE 77: Factorial# = 1.451830920282859E+113       
    CASE 78: Factorial# = 1.132428117820629E+115       
    CASE 79: Factorial# = 8.94618213078298E+116        
    CASE 80: Factorial# = 7.15694570462638E+118        
    CASE 81: Factorial# = 5.797126020747369E+120       
    CASE 82: Factorial# = 4.753643337012843E+122       
    CASE 83: Factorial# = 3.94552396972066E+124        
    CASE 84: Factorial# = 3.314240134565354E+126       
    CASE 85: Factorial# = 2.817104114380549E+128       
    CASE 86: Factorial# = 2.422709538367274E+130       
    CASE 87: Factorial# = 2.107757298379527E+132       
    CASE 88: Factorial# = 1.854826422573984E+134       
    CASE 89: Factorial# = 1.650795516090847E+136       
    CASE 90: Factorial# = 1.485715964481761E+138       
    CASE 91: Factorial# = 1.352001527678403E+140       
    CASE 92: Factorial# = 1.243841405464131E+142       
    CASE 93: Factorial# = 1.156772507081641E+144       
    CASE 94: Factorial# = 1.087366156656743E+146       
    CASE 95: Factorial# = 1.032997848823906E+148       
    CASE 96: Factorial# = 9.916779348709491E+149       
    CASE 97: Factorial# = 9.619275968248216E+151       
    CASE 98: Factorial# = 9.426890448883248E+153       
    CASE 99: Factorial# = 9.332621544394415E+155       
    CASE 100: Factorial# = 9.332621544394418E+157      
    CASE 101: Factorial# = 9.42594775983836E+159       
    CASE 102: Factorial# = 9.614466715035125E+161      
    CASE 103: Factorial# = 9.902900716486178E+163      
    CASE 104: Factorial# = 1.029901674514563E+166      
    CASE 105: Factorial# = 1.081396758240291E+168      
    CASE 106: Factorial# = 1.146280563734709E+170      
    CASE 107: Factorial# = 1.226520203196137E+172      
    CASE 108: Factorial# = 1.324641819451829E+174      
    CASE 109: Factorial# = 1.443859583202494E+176      
    CASE 110: Factorial# = 1.588245541522742E+178      
    CASE 111: Factorial# = 1.762952551090246E+180      
    CASE 112: Factorial# = 1.974506857221075E+182      
    CASE 113: Factorial# = 2.231192748659814E+184      
    CASE 114: Factorial# = 2.543559733472186E+186      
    CASE 115: Factorial# = 2.925093693493014E+188      
    CASE 116: Factorial# = 3.393108684451899E+190      
    CASE 117: Factorial# = 3.96993716080872E+192       
    CASE 118: Factorial# = 4.68452584975429E+194       
    CASE 119: Factorial# = 5.574585761207606E+196      
    CASE 120: Factorial# = 6.689502913449135E+198      
    CASE 121: Factorial# = 8.094298525273444E+200      
    CASE 122: Factorial# = 9.875044200833601E+202      
    CASE 123: Factorial# = 1.214630436702533E+205      
    CASE 124: Factorial# = 1.506141741511141E+207      
    CASE 125: Factorial# = 1.882677176888926E+209      
    CASE 126: Factorial# = 2.372173242880048E+211      
    CASE 127: Factorial# = 3.012660018457662E+213      
    CASE 128: Factorial# = 3.856204823625808E+215      
    CASE 129: Factorial# = 4.974504222477287E+217      
    CASE 130: Factorial# = 6.466855489220473E+219      
    CASE 131: Factorial# = 8.471580690878813E+221      
    CASE 132: Factorial# = 1.118248651196004E+224      
    CASE 133: Factorial# = 1.487270706090685E+226      
    CASE 134: Factorial# = 1.99294274616152E+228       
    CASE 135: Factorial# = 2.690472707318049E+230      
    CASE 136: Factorial# = 3.659042881952548E+232      
    CASE 137: Factorial# = 5.012888748274988E+234      
    CASE 138: Factorial# = 6.917786472619482E+236      
    CASE 139: Factorial# = 9.615723196941089E+238      
    CASE 140: Factorial# = 1.346201247571752E+241      
    CASE 141: Factorial# = 1.898143759076171E+243      
    CASE 142: Factorial# = 2.695364137888163E+245      
    CASE 143: Factorial# = 3.854370717180069E+247      
    CASE 144: Factorial# = 5.550293832739308E+249      
    CASE 145: Factorial# = 8.047926057471989E+251      
    CASE 146: Factorial# = 1.174997204390911E+254      
    CASE 147: Factorial# = 1.72724589045464E+256       
    CASE 148: Factorial# = 2.556323917872864E+258      
    CASE 149: Factorial# = 3.808922637630569E+260      
    CASE 150: Factorial# = 5.713383956445857E+262      
    CASE 151: Factorial# = 8.627209774233244E+264      
    CASE 152: Factorial# = 1.311335885683453E+267      
    CASE 153: Factorial# = 2.006343905095684E+269      
    CASE 154: Factorial# = 3.089769613847352E+271      
    CASE 155: Factorial# = 4.789142901463393E+273      
    CASE 156: Factorial# = 7.471062926282892E+275      
    CASE 157: Factorial# = 1.172956879426413E+278      
    CASE 158: Factorial# = 1.853271869493735E+280      
    CASE 159: Factorial# = 2.946702272495036E+282      
    CASE 160: Factorial# = 4.714723635992061E+284      
    CASE 161: Factorial# = 7.590705053947223E+286      
    CASE 162: Factorial# = 1.229694218739449E+289      
    CASE 163: Factorial# = 2.004401576545303E+291      
    CASE 164: Factorial# = 3.287218585534299E+293      
    CASE 165: Factorial# = 5.423910666131583E+295      
    CASE 166: Factorial# = 9.003691705778434E+297      
    CASE 167: Factorial# = 1.503616514864998E+300      
    CASE 168: Factorial# = 2.526075744973199E+302      
    CASE 169: Factorial# = 4.269068009004706E+304      
    CASE 170: Factorial# = 7.257415615308004E+306      
    CASE ELSE 
      Factorial# = -1.0
  END SELECT
END FUNCTION

SUB FileView(FileName$, Ky, Action, FVInfo AS FVInfo, Buffer(), first)
  ERROR 73 ' Feature Unavailable
END SUB

FUNCTION FudgeFactor&
  FudgeFactor& = 33814
END FUNCTION

FUNCTION GetCPU
  GetCPU = 486 ' matches DOSBOX
END FUNCTION

FUNCTION GetDS
  ERROR 73 ' Feature Unavailable
END FUNCTION

SUB GetEquip(floppies, parallels, serials)
  floppies = 1  ' matches DOSBOX
  parallels = 3 ' matches DOSBOX
  serials = 2   ' matches DOSBOX
END SUB

SUB LockUp
  DO:LOOP
END SUB

FUNCTION MathChip
  MathChip = -1
END FUNCTION

' MaxInt compares two integer variables, and returns the value of the 
' higher one. MaxLong is similar, but is intended for use with long 
' integers. 
FUNCTION MaxInt (num1, num2)
  IF num1 > num2 THEN 
    MaxInt = num1 
  ELSE 
    MaxInt = num2 
  END IF 
END FUNCTION

FUNCTION MaxLong& (Num1&, Num2&)
  IF Num1& > Num2& THEN 
    MaxLong& = Num1& 
  ELSE 
    MaxLong& = Num2& 
  END IF 
END FUNCTION

' MidStrRest is a specialized version of the string manager
' routines StringRest, which are designed to save a MID$ 
' portion of a string array. 
SUB MidStrRest (buffer$, strNumber, storage())
  ERROR 73 ' Feature Unavailable
END SUB

SUB MidStrSave (array$(), element, numEls, FirstChar, numChars, storage())
  ERROR 73 ' Feature Unavailable
END SUB

SUB StringSave (array$(), stringElement, array(), integerElement, numStrings)
  ERROR 73 ' Feature Unavailable
END SUB

SUB Get1Str(work$, array(), element, stringNumber)
  ERROR 73 ' Feature Unavailable
END SUB

FUNCTION StringSize&(array$(), start, numStringEls)
  c& = 0
  FOR x = start TO start + numStringEls - 1
    c& = c& + LEN(array$(x)) '+ 2 to handle CRLF????
  NEXT
  StringSize& = c&
END FUNCTION

' MinInt compares two integer variables, and returns the value of the 
' smaller one.
FUNCTION MinInt (num1, num2)
  IF num1 < num2 THEN 
    MinInt = num1 
  ELSE 
    MinInt = num2 
  END IF 
END FUNCTION

' MinInt compares two long integer variables, and returns the value 
' of the smaller one.
FUNCTION MinLong& (num1&, num2&)
  IF num1& < num2& THEN 
    MinLong& = num1& 
  ELSE 
    MinLong& = num2& 
  END IF 
END FUNCTION

FUNCTION MonthName$(Month)
  ERROR 73 ' Feature Unavailable
END FUNCTION

SUB MsgBox(Message$, Wide, Cfn)
  ERROR 73 ' Feature Unavailable
END SUB

FUNCTION Num2Date$ (days) STATIC

   REDIM dyMth(13)            ' DyMth holds the number of days into the year
   RESTORE
   FOR c = 1 TO 13            ' for a given month
     READ dyMth(C)
   NEXT
   DATA 0, 31, 59, 90, 120, 151, 181, 212, 243, 273, 304, 334, 365

   IF days > 0 THEN sd = 1 ELSE sd = -1
   year = ((days - sd - ((days + 1401) \ 1461)) \ 365) ' Find year number

   IF days > 0 THEN
     year = 80 + year
     sy = 77
   ELSE
     year = 79 + year
     sy = 80
   END IF
                                                     ' Find days into year
   daysInYr = ABS((((year - 80!) * 365) + ((year - sy) \ 4)) - days)

   ' LeapYr below is 0 when true!
   leapYr = year MOD 4                             ' See if its a Leap Year
   IF year = 0 THEN leapYr = 1   'EW 12-13-95: 1900 <> leap year, 2000 is

   month = 1                                        ' Loop to find month number
   ad = 0: ad2 = 0
   WHILE daysInYr < dyMth(month) + ad2 OR daysInYr > dyMth(month + 1) + ad
     ad2 = ad
     month = month + 1
     IF leapYr = 0 AND month > 1 THEN ad = 1
   WEND

   day = daysInYr - dyMth(month)                  ' Find days into month
   IF leapYr = 0 AND month > 2 THEN day = day - 1

   year = year + 1900
   yr$ = RIGHT$(STR$(year), LEN(STR$(year)) - 1)    ' Get year portion
   IF LEN(yr$) < 2 THEN yr$ = "0" + yr$

   mo$ = RIGHT$(STR$(month), LEN(STR$(month)) - 1)  ' Get month portion
   IF LEN(mo$) < 2 THEN mo$ = "0" + mo$

   da$ = RIGHT$(STR$(day), LEN(STR$(day)) - 1)      ' Find day portion
   IF LEN(da$) < 2 THEN da$ = "0" + da$

   dat$ = mo$ + "-" + da$ + "-" + yr$                 ' Make date string

   Num2Date$ = dat$

END FUNCTION

FUNCTION Num2Day(d)
  dd = d
                                      ' 12/31/1979 (0) was a Monday (2)
  dd = dd + 1                       ' adjust for the turnover point is
  dd = dd MOD 7                     ' modulus 7
  IF dd < 0 THEN                     ' is it a negative value?  
    dd = 7 + dd                     ' add this fudge
  END IF
  dd = dd + 1                       ' adjust 0-6 to 1-7
  Num2Day = dd                      ' return result
END FUNCTION

' Time2Num converts a time in string form to an equivalent number 
' of seconds after midnight. 
FUNCTION Num2Time$(time&)
  s& = time&
  h& = s& \ 3600: s& = s& - (h& * 3600)
  m& = s& \ 60: s& = s& - (m& * 60)
  Num2Time$ = RIGHT$("0" + LTRIM$(STR$(h&)), 2) + ":" + RIGHT$("0" + LTRIM$(STR$(m&)), 2) + ":" + RIGHT$("0" + LTRIM$(STR$(s&)), 2)
END FUNCTION

' Pause will pause a program's execution for a specified period of 
' time to a resolution as small as 1/18th of a second. 
SUB Pause(ticks)
  resolution! = 1 / 18.2
  _DELAY ticks * resolution!
END SUB

' Pause2 will pause a program's execution for a specified number of microseconds. 
SUB Pause2(microseconds)
  _DELAY microseconds / 1000000
END SUB

' Pause3 provides a simple method for obtaining delays with a resolution
' of 1 millisecond, without having to reprogram the PC's timer chips
SUB Pause3 (milliseconds, fudg&)
  ' milliseconds is the desired number of milliseconds to delay, 
  ' and fudg& was previously obtained using the FudgeFactor function. 
  _DELAY milliseconds / 1000
END SUB

' PDQTimer is an integer-only TIMER replacement that avoids the 
' inclusion of BASIC's floating point code in your programs. 
FUNCTION PDQTimer&
  ' The documentation sample suggests that the resolution is in 1/10th of a second.
  PDQTimer& = INT(TIMER * 10)
END FUNCTION

FUNCTION Peek1(segment, address)
  SELECT CASE segment
    CASE 0
      SELECT CASE address
        CASE &H463 ' Color Monitor?
          ' IF Peek1(0, &H463) <> &HB4 THEN ColorMon = 1   ' see what monitor is active
        CASE &H417 ' Capslock and Numlock status?
          result = 0
          IF _CAPSLOCK THEN result = result + &H40
          IF _NUMLOCK THEN result = result + &H20
          Peek1 = result
          ' CapStatus = Peek1(0, &H417) AND &H40        'get BIOS status of Caps Lock
          ' NumStatus = Peek1(0, &H417) AND &H20        'get BIOS status of Num Lock
          ' &H40 Capslock Active
          ' &H20 Numlock Active
        CASE ELSE
          ERROR 73 ' Feature Unavailable
      END SELECT
    CASE ELSE
      ERROR 73 ' Feature Unavailable
  END SELECT
END FUNCTION

FUNCTION Peek2(Segment, Address)
  ERROR 73 ' Feature Unavailable
END FUNCTION

SUB Poke1(Segment, Address, Byte)
  ERROR 73 ' Feature Unavailable
END SUB

SUB Poke2(Segment, Address, Word)
  ERROR 73 ' Feature Unavailable
END SUB

FUNCTION Power(Y, N)
  Power = x ^ N
END FUNCTION

FUNCTION Power2(N)
  Power2 = 2 ^ N
END FUNCTION

FUNCTION PRNReady(LPTNumber)
  ERROR 73 ' Feature Unavailable
END FUNCTION

SUB PSwap
  ERROR 73 ' Feature Unavailable
END SUB

SUB QPCli
  ERROR 73 ' Feature Unavailable
END SUB

SUB QPSti
  ERROR 73 ' Feature Unavailable
END SUB

SUB QPPlay(Tune$)
  ERROR 73 ' Feature Unavailable
END SUB

' QPSound is nearly identical to BASIC's SOUND statement, but provides
' a considerable reduction in the amount of code added to a program. 
SUB QPSound(frequency, duration)
  ' The only real difference between QPSound and BASIC's SOUND is 
  ' that the sound is played in the "foreground" only. Where BASIC's 
  ' SOUND returns to your program immediately and continues to play 
  ' the tone in the background, QPSound waits until it has completed 
  ' before returning. QPSound is demonstrated in the QPSOUND.BAS 
  ' example program. 
  SOUND frequency, duration
  SOUND 20000, 1
END SUB

FUNCTION QPSegAdr&(Any$)
  ERROR 73 ' Feature Unavailable
END FUNCTION

FUNCTION QPSSeg(Any$)
  ERROR 73 ' Feature Unavailable
END FUNCTION

FUNCTION QPUSI(LongInt&)
  ERROR 73 ' Feature Unavailable
END FUNCTION

SUB Reboot
  ERROR 73 ' Feature Unavailable
END SUB

SUB ShiftIL(IntVar, NumBits)
  ERROR 73 ' Feature Unavailable
END SUB

SUB ShiftIR(IntVar, NumBits)
  ERROR 73 ' Feature Unavailable
END SUB

SUB ShiftLL(IntVar&, NumBits)
  ERROR 73 ' Feature Unavailable
END SUB

SUB ShiftLR(IntVar&, NumBits)
  ERROR 73 ' Feature Unavailable
END SUB

FUNCTION Soundex$(Word$)
  ERROR 73 ' Feature Unavailable
END FUNCTION

SUB SysTime(T$)
  ERROR 73 ' Feature Unavailable
END SUB

' Time2Num converts a time in string form to an equivalent number 
' of seconds after midnight. 
FUNCTION Time2Num&(t$)
  h$ = LEFT$(t$, 2)
  IF MID$(t$, 3, 1) = ":" THEN m$ = MID$(t$, 4, 2) ELSE m$ = MID$(t$, 3, 2)
  s$ = RIGHT$(t$, 2)
  Time2Num& = (VAL(h$) * 3600) + (VAL(m$) * 60) + VAL(s$)
END FUNCTION

FUNCTION Times2(Number)
  ERROR 73 ' Feature Unavailable
END FUNCTION

' Traplnt will constrain an incoming value to within a specified upper and lower limit. 
FUNCTION TrapInt(value, loLimit, hiLimit)
  IF value < loLimit THEN TrapInt = loLimit: EXIT FUNCTION
  IF value > hiLimit THEN TrapInt = hiLimit: EXIT FUNCTION
  TrapInt = value
END FUNCTION

SUB ViewFile(FileName$, Wide, High, Colr, HiBit, Action)
  ERROR 73 ' Feature Unavailable
END SUB

SUB VLAdd(Value1#, Value2#, Sum#, ErrFlag)
  ERROR 73 ' Feature Unavailable
ENd SUB

SUB VLDiv(Dividend#, Divisor#, Quotient#, Remainder#, ErrFlag)
  ERROR 73 ' Feature Unavailable
END SUB

SUB VLMul(Value1#, Value2#, Product#, ErrFlag)
  ERROR 73 ' Feature Unavailable
END SUB

SUB VLPack(Number$, Value#, ErrFlag)
  ERROR 73 ' Feature Unavailable
END SUB

SUB VLSub(Value1#, Value2#, Difference#, ErrFlag)
  ERROR 73 ' Feature Unavailable
END SUB

SUB VLUnpack(Alias#, Number$, ErrFlag)
  ERROR 73 ' Feature Unavailable
END SUB

' WeekDay will return the day of the week (1 through 7) given a 
' legal DOS date in a string form. 
FUNCTION WeekDay(dy$)
  WeekDay = Num2Day(Date2Num(dy$))
END FUNCTION

' ****************************************
' Chapter 8 - String Manipulation Routines
' ****************************************

' ASCII obtains the ASCII value for a string exactly as BASIC's ASC 
' function does, but it will not cause an "Illegal Function Call" error 
' if the string is null. 
FUNCTION ASCII (char$)
  ' See ASCII.ASM
  IF LEN(char$) THEN ASCII = ASC(char$) ELSE ASCII = -1
END SUB

' Blanks will report the number of leading blanks in the specified 
' string. Both CHR$(32) and the CHR$(0) "null" character are recognized. 
FUNCTION Blanks(work$)
  ' NumBlanks receives the number of leading blank and/or CHR$(0) 
  ' bytes in Work$. 
  IF work$ = "" THEN
    result = 0
  ELSE
    result = LEN(work$)
    FOR index = 1 TO LEN(work$)
      SELECT CASE ASC(MID$(work$, index, 1))
        CASE 0, 32
        CASE ELSE
          result = index: EXIT FOR
      END SELECT
    NEXT
  END IF
  Blanks = result
END FUNCTION

' Compact compresses a string by removing all embedded blanks.
FUNCTION Compact$(old$)
  result$ = ""
  FOR index = 1 TO LEN(old$)
    ch$ = MID$(old$, index, 1)
    SELECT CASE ch$
      CASE " "
      CASE ELSE
        result$ = result$ + ch$
    END SELECT
  NEXT
  old$ = result$ ' to match original behavior; see docs.
  Compact$ = result$
END FUNCTION

SUB Encrypt(X$, PassWord$)
  ERROR 73 ' Feature Unavailable
END SUB

SUB Encrypt2(X$, PassWord$)
  ERROR 73 ' Feature Unavailable
END SUB

FUNCTION Far2Str$(Segment, Address)
  ERROR 73 ' Feature Unavailable
END FUNCTION

' FUsing accepts an incoming number and image string, and returns 
' it as a formatted string much like BASIC's PRINT USING would. 
FUNCTION FUsing$ (number$, image$)
  
  ' Number is any number whether integer, single, or double precision, 
  ' and Image$ indicates how the result is to be formatted. If the 
  ' number will not fit within the allotted space, the first digit of the 
  ' returned string will be replaced with a percent sign (  ) . 

  ' It is very important that you not include any blank spaces within the 
  ' image string. For example "##.##" is perfectly legal, while 
  ' "## .##" will not work as expected. 

  ' The table below summarizes FUsing's capabilities: 

  '     # represents each digit position 
  '     . specifies a decimal point 
  '     + causes the sign of the number ( + or -) to be added (the 
  '       sign must be the first character in the field) 
  '    ** replaces leading spaces in the field with asterisks
  '    $$ adds a dollar sign to the left of the number  
  '   **$ combines the effects of ** and $$ 
  '     , specifies that commas are to be added to the formatted string
  
  ' FUsing is demonstrated in the DEMOCM.BAS example program. 
 
  ' Although BASIC accepts multiple commas in the image string, 
  ' FUsing requires only one. If there is a decimal point within the 
  ' string, the comma must be placed just before it. Otherwise, the 
  ' comma must be the last character. 

  result$ = ""

  number# = VAL(number$)
  format$ = image$

  IF INSTR(format$, "#") = 0 THEN using$ = format$ + "#"

  leadingPlus = LEFT$(format$, 1) = "+"
  dollarSign = INSTR(format$, "$") > 0
  doubleDollarSign = INSTR(format$, "$$") > 0
  asteriskFillDollarSign = INSTR(format$, "**$") > 0

  exponential = INSTR(format$, "^^^^") > 0
  trailingMinus = RIGHT$(format$, 1) = "-"
  hundreds = INSTR(format$, ",") > 0
  float = INSTR(format$, ".") > 0
  precision = 0

  IF float THEN
    positionStart = INSTR(format$, ".")
    positionEnd = positionStart + 1
    DO
      SELECT CASE MID$(format$, positionEnd, 1)
        CASE "#": positionEnd = positionEnd + 1
        CASE ELSE
          positionEnd = positionEnd -1
          EXIT DO
      END SELECT
      IF positionEnd > LEN(format$) THEN
        positionEnd = positionEnd - 1
        EXIT DO
      END IF
    LOOP
    precision = positionEnd - positionStart
  END IF

  length = _INSTRREV(format$, "#") - INSTR(format$, "#") + 1
  IF INSTR(format$, ".") > 0 AND INSTR(format$, ".") = INSTR(format$, "#") - 1 THEN
    ' Numeric format stars with a period...
    length = length + 1
  END IF
  IF asteriskFillDollarSign THEN
    length = length + 1
  ELSEIF asteriskFill THEN
    length = length + 2
  END IF
  IF exponential THEN length = length + 4
  IF NOT float THEN number# = CINT(number#)
  sign$ = " "
  IF number# < 0 THEN
    sign$ = "-"
  ELSEIF leadingPlus THEN
    sign$ = "+"
  END IF
  IF dollarSign THEN length = length + 1

  value$ = LTRIM$(STR$(ABS(number#)))

  IF float THEN
    IF INSTR(value$, ".") = 0 THEN ' a whole number, just extend decimal place as desired
      value$ = value$ + "." + STRING$(precision, "0")
    ELSE
      DO
        SELECT CASE LEN(value$) - _INSTRREV(value$, ".") 
          CASE IS > precision
            value$ = LEFT$(value$, LEN(value$) - 1)
          CASE IS < precision
            value$ = value$ + "0"
          CASE ELSE
            EXIT DO
        END SELECT
      LOOP
    END IF
  END IF
  IF hundreds THEN
    index = INSTR(value$, ".")
    IF index = 0 THEN index = LEN(value$) ELSE index = index - 1
    DO
      index = index - 3
      IF index < 1 THEN EXIT DO
      IF MID$(value$, index, 1) <> "," THEN
        value$ = LEFT$(value$, index) + "," + RIGHT$(value$, LEN(value$) - index)
        index = index
      END IF
    LOOP
  END IF

  IF exponential THEN
    numericOnly$ = MID$(format$, INSTR(format$, "#"), _INSTRREV(format$, "#") - INSTR(format$, "#") + 1)
    CALL ReplaceString (numericOnly$, "#", "0")
    IF INSTR(format$, ".") > 0 AND INSTR(format$, ".") = INSTR(format$, "#") - 1 THEN
      numericOnly$ = "." + numericOnly$
    ELSE
      WHILE MID$(numericOnly$, 2, 1) = "0"
        numericOnly$ = MID$(numericOnly$, 2)
        IF LEN(numericOnly$) = 1 THEN EXIT WHILE
      WEND
    END IF
    value$ = LTRIM$(STR$(number#)) + "E+00"
  END IF

  IF length < LEN(value$) THEN result$ = result$ + ""

  IF length > LEN(value$) THEN
    IF asteriskFill THEN
      IF sign$ <> " " THEN
        result$ = result$ + STRING$(length - LEN(value$) + 1, "*")
      ELSE
        result$ = result$ + STRING$(length - LEN(value$), "*")
      END IF
    ELSE
      result$ = result$ + STRING$(length - LEN(value$), " ")
    END IF
  END IF
  IF NOT trailingMinus AND sign$ <> " " THEN result$ = result$ + sign$
  IF dollarSign THEN result$ = result$ + "$"
  result$ = result$ + value$
  IF trailingMinus THEN result$ = result$ + sign$

  FUsing$ = result$

END FUNCTION

' InCount will quickly report how many times one string occurs 
' within another, and the case-sensitive search string may contain 
' any number of "?" wild cards. 
FUNCTION InCount(Source$, SearchValue$)
  result = 0
  pos1 = 1
  DO
    p = QInstr(pos1, Source$, SearchValue$)
    IF p > 0 THEN
      result = result + 1
      pos1 = p + LEN(SearchValue$)
    ELSE
      EXIT DO
    END IF
  LOOP
  InCount = result
END FUNCTION

' InCount2 will quickly report how many times one string occurs 
' within another, and the case-insensitive search string may contain 
' any number of "?" wild cards. 
FUNCTION InCount2(source$, searchValue$)
  result = 0
  pos1 = 1
  DO
    p = QInstr2(pos1, source$, searchValue$)
    IF p > 0 THEN
      result = result + 1
      pos1 = p + LEN(searchValue$)
    ELSE
      EXIT DO
    END IF
  LOOP
  InCount2 = result
END FUNCTION

FUNCTION InCountTbl(Source$, Table$)
  ERROR 73 ' Feature Unavailable
END FUNCTION

FUNCTION InstrTbl(start, source$, table$)
  l = LEN(source$)
  c = start
  DO
    IF c > l THEN EXIT DO
    ch$ = MID$(source$, c, 1)
    FOR x = 1 TO LEN(table$)
      m$ = MID$(table$, x, 1)
      IF ch$ = m$ THEN
        InstrTbl = c: EXIT FUNCTION
      END IF
    NEXT
    c = c + 1
  LOOP
  InstrTbl = -1
END FUNCTION

FUNCTION InstrTbl2(start, source$, table$)
  l = LEN(source$)
  c = start
  DO
    IF c > l THEN EXIT DO
    ch$ = LCASE$(MID$(source$, c, 1))
    FOR x = 1 TO LEN(table$)
      m$ = LCASE$(MID$(table$, x, 1))
      IF ch$ = m$ THEN
        InstrTbl2 = c: EXIT FUNCTION
      END IF
    NEXT
    c = c + 1
  LOOP
  InstrTbl2 = -1
END FUNCTION

FUNCTION InstrTblB(start, source$, table$)
  l = LEN(source$)
  c = start
  DO
    IF c < 1 THEN EXIT DO
    ch$ = MID$(source$, c, 1)
    FOR x = 1 TO LEN(table$)
      m$ = MID$(table$, x, 1)
      IF ch$ = m$ THEN
        InstrTblB = c: EXIT FUNCTION
      END IF
    NEXT
    c = c - 1
  LOOP
  InstrTblB = -1
END FUNCTION

FUNCTION InstrTblB2(start, source$, table$)
  l = LEN(source$)
  c = start
  DO
    IF c < 1 THEN EXIT DO
    ch$ = LCASE$(MID$(source$, c, 1))
    FOR x = 1 TO LEN(table$)
      m$ = LCASE$(MID$(table$, x, 1))
      IF ch$ = m$ THEN
        InstrTblB2 = c: EXIT FUNCTION
      END IF
    NEXT
    c = c - 1
  LOOP
  InstrTblB2 = -1
END FUNCTION

FUNCTION LongestStr(Array$())
  ERROR 73 ' Feature Unavailable
END FUNCTION

SUB LowASCII(X$)
  ERROR 73 ' Feature Unavailable
END SUB

SUB Lower(value$)
  value$ = LCASE$(value$)
END SUB

SUB LowerTbl(Work$, Table$)
  ERROR 73 ' Feature Unavailable
END SUB

FUNCTION MidChar(Work$, Position)
  ERROR 73 ' Feature Unavailable
END SUB

SUB MidCharS(Work$, Postion, Char)
  ERROR 73 ' Feature Unavailable
END SUB

FUNCTION NotInstr(Start, Searched$, Table$)
  ERROR 73 ' Feature Unavailable
END FUNCTION

' Null will report if the specified string is either null, or is filled only 
' with blank or CHR$(0) characters. 
FUNCTION Null(work$)
  result = -1
  IF work$ <> "" THEN
    FOR index = 1 TO LEN(work$)
      SELECT CASE ASC(MID$(work$, index, 1))
        CASE 0, 32
        CASE ELSE
          result = 0: EXIT FOR
      END SELECT
    NEXT
  END IF
  Null = result
END FUNCTION

' ParseString accepts a string containing delimited information, and 
' returns portions of that string each time it is invoked. 
FUNCTION ParseString$(curPos, work$, table$)
  ' curPos tells where in the string to begin processing, work$ is the 
  ' string being read, and delimitTbl$ is a table of one or more delimiting 
  ' characters. result$ then receives the next delimited component from work$. 

  IF curPos > LEN(work$) THEN ParseString$ = "": EXIT FUNCTION
  IF curPos < 1 THEN curPos = 1

  match = InstrTbl(curPos, work$, table$)

  IF match < 1 THEN curPos = LEN(work$) + 1: ParseString$ = "": EXIT FUNCTION

  ParseString$ = MID$(work$, curPos, match - curPos)
  curPos = match + 1

END FUNCTION

FUNCTION PMatch (work$)

  l = LEN(work$)

  IF l = 0 THEN PMatch = -1: EXIT FUNCTION

  c = 2: p = 0

  DO

    If c > l THEN EXIT DO

    ch$ = MID$(work$, c, 1)

    IF ch$ = "(" THEN
      p = p + 1
    ELSEIF ch$ = ")" THEN
      IF p > 0 THEN 
        p = p - 1
      ELSE
        PMatch = c: EXIT FUNCTION
      END IF
    END IF
    c = c + 1

  LOOP

  PMatch = -1

END FUNCTION

SUB ProperName(Work$)
  ERROR 73 ' Feature Unavailable
END SUB

' QInstr serves the same purpose as BASIC's INSTR function, 
' except it accepts any number of "?" wild cards.
FUNCTION QInstr(startPosition, sourceValue$, searchValue$)

  ' Setting position to 0 will return 0; matching QB behavior.
  IF startPosition = 0 THEN QInstr = 0: EXIT FUNCTION

  position = startPosition
  DO
    segment$ = MID$(sourceValue$, position, LEN(searchValue$))
    IF LEN(segment$) <> LEN(searchValue$) THEN EXIT DO
    isMatch = 1 ' assume we are going to find a match
    FOR index = 1 TO LEN(searchValue$) ' test against each character in search value
      character$ = MID$(searchValue$, index, 1) ' determine character
      IF character$ <> "?" THEN ' if not a wildcard,
        IF MID$(segment$, index, 1) <> character$ THEN isMatch = 0 : EXIT FOR
      END IF
    NEXT
    IF isMatch THEN QInstr = position : EXIT FUNCTION
    position = position + 1
  LOOP

  QInstr = 0

END FUNCTION

' QInstr2 serves the same purpose as BASIC's INSTR function, except 
' it accepts any number of "?" wild cards and it ignores capitalization 
' when examining the strings.
FUNCTION QInstr2(startPosition, sourceValue$, searchValue$)

  ' Setting position to 0 will return 0; matching QB behavior.
  IF startPosition = 0 THEN QInstr2 = 0: EXIT FUNCTION

  position = startPosition
  DO
    segment$ = LCASE$(MID$(sourceValue$, position, LEN(searchValue$)))
    IF LEN(segment$) <> LEN(searchValue$) THEN EXIT DO
    isMatch = 1
    FOR index = 1 TO LEN(searchValue$)
      character$ = LCASE$(MID$(searchValue$, index, 1))
      IF character$ <> "?" THEN
        IF MID$(segment$, index, 1) <> character$ THEN isMatch = 0 : EXIT FOR
      END IF
    NEXT
    IF isMatch THEN QInstr2 = position : EXIT FUNCTION
    position = position + 1
  LOOP

  QInstr2 = 0

END FUNCTION

' QlnstrB is similar to the QuickPak Professional Qlnstr function, 
' except it scans the source string backwards looking for a specified 
' substring. Like Qlnstr, function accepts any number of "?" wild 
' cards to match any character. 
FUNCTION QInstrB(startPosition, sourceValue$, searchValue$)

  ' Setting position to 0 will return 0; matching QB behavior.
  IF startPosition = 0 THEN QInstrB = 0: EXIT FUNCTION

  position = startPosition
  DO
    segment$ = MID$(sourceValue$, position, LEN(searchValue$))
    IF LEN(segment$) <> LEN(searchValue$) THEN EXIT DO
    isMatch = 1
    FOR index = 1 TO LEN(searchValue$)
      character$ = MID$(searchValue$, index, 1)
      IF character$ <> "?" THEN
        IF MID$(segment$, index, 1) <> character$ THEN isMatch = 0 : EXIT FOR
      END IF
    NEXT
    IF isMatch THEN QInstrB = position : EXIT FUNCTION
    position = position - 1
    IF position < 1 THEN EXIT DO
  LOOP

  QInstrB = 0

END FUNCTION

FUNCTION QInstrB2(startPosition, sourceValue$, searchValue$)

  ' Setting position to 0 will return 0; matching QB behavior.
  IF startPosition = 0 THEN QInstrB2 = 0: EXIT FUNCTION

  position = startPosition
  DO
    segment$ = LCASE$(MID$(sourceValue$, position, LEN(searchValue$)))
    IF LEN(segment$) <> LEN(searchValue$) THEN EXIT DO
    isMatch = 1
    FOR index = 1 TO LEN(searchValue$)
      character$ = LCASE$(MID$(searchValue$, index, 1))
      IF character$ <> "?" THEN
        IF MID$(segment$, index, 1) <> character$ THEN isMatch = 0 : EXIT FOR
      END IF
    NEXT
    IF isMatch THEN QInstrB2 = position : EXIT FUNCTION
    position = position - 1
    IF position < 1 THEN EXIT DO
  LOOP

  QInstrB2 = 0

END FUNCTION

SUB QInstrH(Segment, Address, SearchValue$, NumBytes&)
  ERROR 73 ' Feature Unavailable
END SUB

FUNCTION QPLeft$(text$, numChars)
  QPLeft$ = LEFT$(text$, numChars)
END FUNCTION

FUNCTION QPMid$(text$, startChar, numChars)
  IF numChars = -1 THEN
    QPMid$ = MID$(text$, startChar)
  ELSE
    QPMid$ = MID$(text$, startChar, numChars)
  END IF
END FUNCTION

FUNCTION QPRight$(text$, numChars)
  QPRight$ = RIGHT$(text$, numChars)
END FUNCTION

' QPLen serves the same purpose as BASIC's LEN function, but it is considerably faster.
FUNCTION QPLen(text$)
  QPLen = LEN(text$)
END FUNCTION

FUNCTION QPSadd(Work$)
  ERROR 73 ' Feature Unavailable
END FUNCTION

FUNCTION QPStrI$(IntVar)
  QPStrI$ = LTRIM$(STR$(IntVar))
END FUNCTION

FUNCTION QPStrL$(LongInt&)
  QPStrL$ = LTRIM$(STR$(LongInt&))
END FUNCTION

FUNCTION QPTrim$(inputValue$)
  QPTrim$ = QPLTrim$(QPRTrim$(inputValue$))
END FUNCTION

FUNCTION QPLTrim$(inputValue$)
  result$ = inputvalue$
  DO
    IF LEN(result$) = 0 THEN EXIT DO
    ch$ = LEFT$(result$, 1)
    SELECT CASE ch$
      CASE CHR$(0), " " ', CHR$(9), CHR$(13), CHR$(10)
        result$ = RIGHT$(result$, LEN(result$) - 1)
      CASE ELSE: EXIT DO
    END SELECT
  LOOP
  QPLTrim$ = result$
END FUNCTION

FUNCTION QPRTrim$(inputValue$)
  result$ = inputvalue$
  DO
    IF LEN(result$) = 0 THEN EXIT DO
    ch$ = RIGHT$(result$, 1)
    SELECT CASE ch$
      CASE CHR$(0), " " ', CHR$(9), CHR$(13), CHR$(10)
        result$ = LEFT$(result$, LEN(result$) - 1)
      CASE ELSE: EXIT DO
    END SELECT
  LOOP
  QPRTrim$ = result$
END FUNCTION

FUNCTION QPValI (X$)
  QPValI = VAL(X$)
END FUNCTION

FUNCTION QPValL&(Work$)
  ERROR 73 ' Feature Unavailable
END FUNCTION

SUB RemCtrl(X$, Replace$)
  ERROR 73 ' Feature Unavailable
END SUB

' ReplaceChar replaces all occurrences of a specified character in a 
' string with a different character.
SUB ReplaceChar(sourceValue$, oldValue$, newValue$)
  oldChar$ = LEFT$(oldValue$, 1)
  newChar$ = LEFT$(newValue$, 1)
  ReplaceString sourceValue$, oldChar$, newChar$
END SUB

' ReplaceChar2 replaces all occurrences of a specified character in a 
' string with a different character while ignoring capitalization. 
SUB ReplaceChar2(sourceValue$, oldValue$, newValue$)
  oldChar$ = LEFT$(oldValue$, 1)
  newChar$ = LEFT$(newValue$, 1)
  ReplaceString2 sourceValue$, oldChar$, newChar$
END SUB

' SUB ReplaceCharT(typeVar as Any, typeLength, oldChar, newChar)
' END SUB

' SUB ReplaceCharT2(typeVar as Any, typeLength, oldChar, newChar)
' END SUB

' ReplaceString replaces all occurrences of a specified string with a 
' different string (case-sensitive). Both the string being searched 
' for and its replacement may be any length.
SUB ReplaceString (sourceValue$, oldValue$, newValue$) STATIC
  oldLen = LEN(oldValue$)
  newLen = LEN(newValue$)
  pointer = 1
Again:
  pointer = QInstr(pointer, sourceValue$, oldValue$)' case-sensitive
  IF pointer THEN
    sourceValue$ = LEFT$(sourceValue$, pointer - 1) + newValue$ + MID$(sourceValue$, pointer + oldLen)
    pointer = pointer + newLen
    GOTO Again
  END IF
END SUB

' ReplaceString2 replaces all occurrences of a specified string with a 
' different string (case-insensitive). Both the string being searched 
' for and its replacement may be any length.
SUB ReplaceString2 (sourceValue$, oldValue$, newValue$) STATIC
  oldLen = LEN(oldValue$)
  newLen = LEN(newValue$)
  pointer = 1
Again:
  pointer = QInstr2(pointer, sourceValue$, oldValue$)' case-insensitive
  IF pointer THEN
    sourceValue$ = LEFT$(sourceValue$, pointer - 1) + newValue$ + MID$(sourceValue$, pointer + oldLen)
    pointer = pointer + newLen
    GOTO Again
  END IF
END SUB

SUB ReplaceTbl(Work$, Table$)
  ERROR 73 ' Feature Unavailable
END SUB

SUB Sequence(work$)
  p = LEN(work$)
  DO
    IF p < 1 THEN 
      IF carry THEN
        ' handle "overflow"
        FOR p = 1 TO LEN(work$)
          ch = ASC(MID$(work$, p, 1))
          SELECT CASE ch
            CASE 48 TO 57: MID$(work$, p, 1) = CHR$(48)
            CASE 97 TO 122: MID$(work$, p, 1) = CHR$(97)
            CASE 65 TO 90: MID$(work$, p, 1) = CHR$(65)
            CASE ELSE
          END SELECT
        NEXT
        EXIT DO          
      END IF
      EXIT DO
    END IF
    carry = 0
    ch = ASC(MID$(work$, p, 1))
    SELECT CASE ch
      CASE 48 TO 57
        IF ch = 57 THEN
          ch = 48: carry = -1
        ELSE
          ch = ch + 1
        END IF
        MID$(work$, p, 1) = CHR$(ch)
      CASE 97 TO 122
        IF ch = 122 THEN
          ch = 97: carry = -1
        ELSE
          ch = ch + 1
        END IF
        MID$(work$, p, 1) = CHR$(ch)
      CASE 65 TO 90
        IF ch = 90 THEN
          ch = 65: carry = -1
        ELSE
          ch = ch + 1
        END IF
        MID$(work$, p, 1) = CHR$(ch)
      CASE ELSE
        carry = -1
    END SELECT
    p = p - 1
    IF NOT carry THEN EXIT DO
  LOOP
END SUB

SUB Translate(x$)
  FOR p = 1 TO LEN(x$)
    c = ASC(MID$(x$, p, 1))
    SELECT CASE c
      CASE 196: MID$(x$, p, 1) = "-"
      CASE 205, 240: MID$(x$, p, 1) = "="
      CASE 176, 177, 178, 179, 186, 220, 221, 222, 223: MID$(x$, p, 1) = "|"
      CASE 218, 194, 191, 195, 197, 180, 192, 193, 217, 201, 203, 187, 204, 208, 185, 200, 202, 188: MID$(x$, p, 1) = "+"
      CASE IS > 127: MID$(x$, p, 1) = "+"
      CASE ELSE
    END SELECT
  NEXT
END SUB

SUB Upper(value$)
  value$ = UCASE$(value$)
END SUB

SUB UpperTbl(Work$, Table$)
  ERROR 73 ' Feature Unavailable
END SUB

' ****************************************
' Chapter 9 - Video Routines
' ****************************************

' APrint will quickly print any portion of a conventional (not 
' fixed-length) string array, and contain the display within a specified 
' area of the screen. 
SUB APrint(array$(), first, numEls, firstChar, numChars, colr, page)
  'BUG: The VERTMENU.BAS file makes a call where colr is -1;
  '     however, it appears to be not using the current "basic" fg/bg but
  '     the value from "somewhere else". Testing combined with COLOR, PRINT
  '     MQPrint, QPrintRC, etc. and -1 for colr does not seem to be affected
  '     by any of these. COLOR, for example, seems to be completely ignored 
  '     which doesn't seem to match what the documentation states.
  ' NOTE: page is currently not implemented.
  ' If page is -1, use current page.
  IF page > -1 THEN SCREEN , , page, page
  row = CSRLIN
  col = POS(0)
  FOR element = first to first + numEls - 1
    value$ = MID$(array$(element), firstChar, numChars)
    QPrintRC value$ + SPACE$(numChars - LEN(value$)), row, col, colr
    row = row + 1
  NEXT
END SUB

' APrint0 will quickly print any portion of a conventional (not 
' fixed-length) string array, and contain the display within a specified 
' area of the screen. 
SUB APrint0(array$(), first, numEls, firstChar, numChars, colr)
  CALL APrint(array$(), first, numEls, firstChar, numChars, colr, 0)
END SUB

' APrintT will quickly print any portion of a fixed-length string array 
' or the string component of a TYPE array, and contain the display 
' within a specified area of the screen. 
'SUB APrintT(array() AS FLen, first, elSize, numEls, firstChar, numChars, colr, page)
SUB APrintT(src AS _MEM, elSize, numEls, firstChar, numChars, colr, page)

  ' array$(first) is the first element to be included, and elSize% is the 
  ' total length in bytes of each element. 
  '
  ' numEls% is the total number of elements to print, firstChar% is 
  ' the first character in each string to be displayed, and numChars% 
  ' is the number of characters to print. 
  '
  ' colr% specifies the display color, coded in the format used by 
  ' QuickPak Professional. If -1 is used for colr%, the current screen 
  ' colors will be maintained. 
  ' 
  ' page% indicates the video page to write to, which is relevant only 
  ' when a color monitor is installed. If page% is set to -1, APrintT 
  ' will use the current page. 
  '
  ' Printing always begins at the current cursor location.

  DIM offset AS _OFFSET: offset = src.OFFSET
  'DIM s AS STRING ' * elSize

  IF page > -1 THEN SCREEN , , page, page
  row = CSRLIN
  col = POS(0)
  FOR x = 1 TO numEls
    s$ = SPACE$(elSize)
    _MEMGET src, offset, s$
    value$ = MID$(s$, firstChar, numChars)
    QPrintRC value$ + SPACE$(numChars - LEN(value$)), row, col, colr
    row = row + 1
    offset = offset + elSize
  NEXT

  ' DIM s$(LBOUND(array) TO UBOUND(array))
  ' FOR x = LBOUND(array) TO UBOUND(array)
  '   s$(x) = array(x).S
  ' NEXT
  ' CALL APrint(s$(), first, numEls, firstChar, numChars, colr, page)

END SUB

' APrintT0 will quickly print any portion of a fixed-length string 
' array or the string component of a TYPE array, and contain the 
' display within a specified area of the screen. 
SUB APrintT0(array() AS FLen, first, elSize, numEls, firstChar, numChars, colr)
  CALL APrintT0(array(), first, elSize, numEls, firstChar, numChars, colr)
END SUB

' ArraySize will quickly calculate how many elements are needed in an
' integer array that is intended to hold a portion of the display screen.
FUNCTION ArraySize(ulRow, ulCol, lrRow, lrCol)
  ArraySize = (lrRow - ulRow + 1) * (lrCol - ulCol + 1)
END FUNCTION

' Box will quickly draw a box frame on the screen. 
SUB Box(ulRow, ulCol, lrRow, lrCol, char, colr, page)
  ' NOTE: page isn't currently implemented
  ' If page = -1 then use current active page.
  SELECT CASE char
    CASE 1 ' single line all around
      ' first row
      QPrintRC CHR$(218), ulRow, ulCol, colr
      QPrintRC STRING$((lrCol - ulCol) - 1, 196), ulRow, ulCol + 1, colr
      QPrintRC CHR$(191), ulRow, lrCol, colr
      ' middle
      FOR r = ulRow + 1 TO lrRow - 1
        QPrintRC CHR$(179), r, ulCol, colr
        QPrintRC CHR$(179), r, lrCol, colr
      NEXT
      ' last row
      QPrintRC CHR$(192), lrRow, ulCol, colr
      QPrintRC STRING$((lrCol - ulCol) - 1, 196), lrRow, ulCol + 1, colr
      QPrintRC CHR$(217), lrRow, lrCol, colr
    CASE 2 ' double line all around
      ' first row
      QPrintRC CHR$(201), ulRow, ulCol, colr
      QPrintRC STRING$((lrCol - ulCol) - 1, 205), ulRow, ulCol + 1, colr
      QPrintRC CHR$(187), ulRow, lrCol, colr
      ' middle
      FOR r = ulRow + 1 TO lrRow - 1
        QPrintRC CHR$(186), r, ulCol, colr
        QPrintRC CHR$(186), r, lrCol, colr
      NEXT
      ' last row
      QPrintRC CHR$(200), lrRow, ulCol, colr
      QPrintRC STRING$((lrCol - ulCol) - 1, 205), lrRow, ulCol + 1, colr
      QPrintRC CHR$(188), lrRow, lrCol, colr
    CASE 3 ' double line horizontally, single line vertically
      ' first row
      QPrintRC CHR$(213), ulRow, ulCol, colr
      QPrintRC STRING$((lrCol - ulCol) - 1, 205), ulRow, ulCol + 1, colr
      QPrintRC CHR$(184), ulRow, lrCol, colr
      ' middle
      FOR r = ulRow + 1 TO lrRow - 1
        QPrintRC CHR$(179), r, ulCol, colr
        QPrintRC CHR$(179), r, lrCol, colr
      NEXT
      ' last row
      QPrintRC CHR$(212), lrRow, ulCol, colr
      QPrintRC STRING$((lrCol - ulCol) - 1, 205), lrRow, ulCol + 1, colr
      QPrintRC CHR$(190), lrRow, lrCol, colr
    CASE 4 ' single line horizontally, double line vertically
      ' first row
      QPrintRC CHR$(214), ulRow, ulCol, colr
      QPrintRC STRING$((lrCol - ulCol) - 1, 196), ulRow, ulCol + 1, colr
      QPrintRC CHR$(183), ulRow, lrCol, colr
      ' middle
      FOR r = ulRow + 1 TO lrRow - 1
        QPrintRC CHR$(186), r, ulCol, colr
        QPrintRC CHR$(186), r, lrCol, colr
      NEXT
      ' last row
      QPrintRC CHR$(211), lrRow, ulCol, colr
      QPrintRC STRING$((lrCol - ulCol) - 1, 196), lrRow, ulCol + 1, colr
      QPrintRC CHR$(189), lrRow, lrCol, colr
    CASE ELSE ' ASCII character will be used for entire box
      ' first row
      QPrintRC CHR$(char), ulRow, ulCol, colr
      QPrintRC STRING$((lrCol - ulCol) - 1, char), ulRow, ulCol + 1, colr
      QPrintRC CHR$(char), ulRow, lrCol, colr
      ' middle
      FOR r = ulRow + 1 TO lrRow - 1
        QPrintRC CHR$(char), r, ulCol, colr
        QPrintRC CHR$(char), r, lrCol, colr
      NEXT
      ' last row
      QPrintRC CHR$(char), lrRow, ulCol, colr
      QPrintRC STRING$((lrCol - ulCol) - 1, char), lrRow, ulCol + 1, colr
      QPrintRC CHR$(char), lrRow, lrCol, colr
  END SELECT
END SUB

' Box0 will quickly draw a box frame on the screen.
SUB Box0(ulRow, ulCol, lrRow, lrCol, char, colr)
  CALL Box(ulRow, ulCol, lrRow, lrCol, char, colr, 0)
END SUB

' BPrint will print either a conventional or fixed-length string at the 
' current cursor position through DOS. 
SUB BPrint(text$)
  prevControlChr = _CONTROLCHR ' <----------- QB64 definately get's this wrong...
  IF prevControlChr THEN _CONTROLCHR ON
  temp$ = text$
  CALL ReplaceChar(temp$, CHR$(13), "")
  PRINT temp$;
  IF prevControlChr THEN _CONTROLCHR OFF
END SUB

' ClearEOL (Clear to End of Line) erases the current screen line 
' starting at the current cursor position. 
SUB ClearEOL(clr)
  ' colr specifies the display color. 
  ' If -1 is used for Colr, the current screen 
  ' colors will be maintained. 
  r = CSRLIN
  c = POS(0)
  columns = _WIDTH
  QPrintRC Space$(columns - c), r, c, clr 
END SUB

SUB ClearScr (ulRow, ulCol, lrRow, lrCol, colr, page)
  ' NOTE: page is currently not implemented.
  ' page of -1 is "current page"
  FOR r = ulRow TO lrRow
    FOR c = ulCol TO lrCol
      QPrintRC " ", r, c, colr
    NEXT
  NEXT
END SUB

SUB ClearScr0 (ulRow, ulCol, lrRow, lrCol, colr)
  FOR r = ulRow TO lrRow
    FOR c = ulCol TO lrCol
      QPrintRC " ", r, c, colr
    NEXT
  NEXT
END SUB

' FillScrn will fill any rectangular portion of the display screen with 
' the specified character. 
SUB FillScrn(ulRow, ulCol, lrRow, lrCol, colr, char, page)
  ' NOTE: page is currently not implemented.
  ' If page = -1 then current active page is used.
  FOR r = ulRow TO lrRow
    QPrintRC STRING$(lrCol - ulCol + 1, char), r, ulCol, colr
  NEXT
END SUB

' Fil1Scrn0 will fill any rectangular portion of the display screen with 
' the specified character. 
SUB FillScrn0(ulRow, ulCol, lrRow, lrCol, colr, char)
  CALL FillScrn (ulRow, ulCol, lrRow, lrCol, colr, char, 0)
END SUB

' GetVMode will report the current video mode, the currently active 
' display page, the page size, and the number of rows and columns. 
SUB GetVMode (mode, page, pageSize, rows, columns)
  mode = 3 ' matches DOSBOX
  page = 0 'TODO: Need to handle, but the default is 0.
  pageSize = 4096 ' matches DOSBOX
  columns = _WIDTH
  rows = _HEIGHT
END SUB

FUNCTION Monitor
  ' NOTE: The documentation for QPrintAny() and Monitor don't appear to align????
  Monitor = 7 ' VGA adapter with a color monitor.
END FUNCTION

FUNCTION EGAMem ()
  EGAMem = 4 ' Assuming VGA and matching what is reported in DOSBOX.
END FUNCTION

' ChatGPT conversion????
' SUB MakeMono(ArrayAdr AS LONG, NumEls AS LONG)
'   DIM Array(NumEls)
'   FOR i = 1 TO NumEls
'   Array(i) = PEEK(ArrayAdr + i - 1)
'   IF (Array(i) AND 7) <> 0 THEN
'   Array(i) = (Array(i) AND 248) OR 7
'   END IF
'   NEXT
' END SUB

' MakeMono will convert the colors on a text screen held in an 
' integer array to those suitable for display on a monochrome monitor. 
SUB MakeMono(array(), element, size)
  IF size < 1 THEN EXIT SUB
  ' element is the location in the array() array where the screen 
  ' begins, and size is the size of the screen in characters. 
  FOR index = element TO element + size - 1
    ' clr = element(index) AND &H00FF ' split color
    ' 'ch = ((element(index) AND &HFF00) \ 256) AND &H00FF ' split character
    ' CALL SplitColor(clr, fg, bg)

    ' If the text foreground color is black (inverse), then the color is left unchanged.
    ' Otherwise the background is cleared to black, and the 
    ' foreground is set to white. However, the intensity and flashing color 
    ' attributes are left unchanged. 
    IF (array(i) AND 7) <> 0 THEN
      array(index) = (array(index) AND 248) OR 7
    END IF
  NEXT
END SUB

' MPaintBox is similar to PaintBox, except it always turns off the 
' mouse cursor before painting the screen. When it is finished the 
' cursor is turned back on. 
SUB MPaintBox (ulRow, ulCol, lrRow, lrCol, colr)
  ' Paint a portion of the screen; leaving text intact (only change color).
  CALL PaintBox0 (ulRow, ulCol, lrRow, lrCol, colr)
END SUB

SUB MPRestore(ulRow, ulCol, lrRow, lrCol, originalWidth, element(), start)

  w = lrCol - ulCol + 1
  h = lrRow - ulRow + 1

  index = start '+ LBOUND(element)  ' not really sure why the +1 is needed???
                                      ' but I've verified that index of 1 is the correct starting
                                      ' element for a saved array.
  r = 0
  DO
    FOR c = 0 TO w - 1
      ' clr = element(index + c) AND &H00FF ' split color
      ' ch = ((element(index + c) AND &HFF00) \ 256) AND &H00FF ' split character
      ch = element(index + c) AND &H00FF ' split color
      clr = ((element(index + c) AND &HFF00) \ 256) AND &H00FF ' split character
      QPrintRC CHR$(ch), ulRow + r, ulCol + c, clr
    NEXT
    r = r + 1: index = index + originalWidth
  LOOP UNTIL r => h OR index => UBOUND(element)

END SUB

' MQPrint is similar to QPrint, except it always turns off the mouse cursor
' before printing. When it is finished the cursor is turned back on. 
SUB MQPrint (txt$, colr)
  ofg = -1: obg = -1
  IF colr = -1 THEN
    ' Maintain existing color...
  ELSE
     ofg = _DEFAULTCOLOR: obg = _BACKGROUNDCOLOR
     SplitColor colr, fg, bg
     COLOR fg, bg
  END IF
  pr = CSRLIN
  pc = POS(0)
  prevControlChr = _CONTROLCHR ' <----------- QB64 definately get's this wrong...
  IF NOT prevControlChr THEN _CONTROLCHR OFF
  PRINT txt$;
  IF NOT prevControlChr THEN _CONTROLCHR ON
  LOCATE pr, pc
  IF ofg <> -1 AND obg <> -1 THEN
    COLOR ofg, obg
  END IF
END SUB

' MScrnRest is similar to ScrnRest, except it always turn off 
' the mouse cursor while it is working. 
SUB MScrnRest (ulRow, ulCol, lrRow, lrCol, element())
  ScrnRest0 ulRow, ulCol, lrRow, lrCol, element()
END SUB

' MScrnSave is similar to ScrnSave, except it always turn off 
' the mouse cursor while it is working. 
SUB MScrnSave (ulRow, ulCol, lrRow, lrCol, element())
  'TODO: Capture the region for restoration later.
  ScrnSave0 ulRow, ulCol, lrRow, lrCol, element()
END SUB

FUNCTION OneColor (fg, bg)
  OneColor = (fg AND 16) * 8 + ((bg AND 7) * 16) + (fg AND 15)
END FUNCTION

' PaintBox will paint any rectangular area of the screen, without 
' disturbing the text that is already present. 
SUB PaintBox (ulRow, ulCol, lrRow, lrCol, colr, page)
  ' NOTE: page isn't currently used.
  ' If page = -1 then current active screen should be used.
  FOR r = ulRow TO lrRow
    FOR c = ulCol TO lrCol
      ch = SCREEN(r, c)
      QPrintRC CHR$(ch), r, c, colr
    NEXT
  NEXT
END SUB

' PaintBox0 will paint any rectangular area of the screen, without 
' disturbing the text that is already present. 
SUB PaintBox0 (ulRow, ulCol, lrRow, lrCol, colr)
  CALL PaintBox (ulRow, ulCol, lrRow, lrCol, colr, 0)
END SUB

SUB PUsing (number$, image$, color1, color2, page, row, column)
  ' number$ is any number whether integer, single, or double precision, 
  ' and image$ indicates how the result is to be formatted. Image$ may 
  ' contain both leading and trailing text as shown below.
  ' color1 and color2 indicate the colors for the text and numeric 
  ' portions of image$ respectively. Either color may be set to -1 to 
  ' maintain the current screen colors.   
  ' page tells PUsing what screen page to print to, which may 
  ' optionally be given as -1 to use the current page. 
  ' row and column specify where the printing is to be located on 
  ' the screen. 
  CALL QPrintRC (FUsing$(number$, image$), row, column, color2)
  'TODO: page is currently not honored.
  'TODO: color1 needs to be implemented.
  'TODO: "raw text" (non formatted) is currently not printed (ignored by FUsing$)
END SUB

SUB QPrint (text$, colr, page)
  ofg = -1: obg = -1
  IF colr = -1 THEN
    ' Maintain existing color...
  ELSE
    ofg = _DEFAULTCOLOR: obg = _BACKGROUNDCOLOR
    SplitColor colr, fg, bg
    COLOR fg, bg
  END IF
  pr = CSRLIN
  pc = POS(0)
  prevControlChr = _CONTROLCHR ' <----------- QB64 definately get's this wrong...
  IF NOT prevControlChr THEN _CONTROLCHR OFF
  PRINT text$;
  IF NOT prevControlChr THEN _CONTROLCHR ON
  LOCATE pr, pc
  IF ofg <> -1 AND obg <> -1 THEN
    COLOR ofg, obg
  END IF
END SUB

SUB QPrint0 (text$, colr)
  ofg = -1: obg = -1
  IF colr = -1 THEN
    ' Maintain existing color...
  ELSE
     ofg = _DEFAULTCOLOR: obg = _BACKGROUNDCOLOR
     SplitColor colr, fg, bg
     COLOR fg, bg
  END IF
  pr = CSRLIN
  pc = POS(0)
  prevControlChr = _CONTROLCHR ' <----------- QB64 definately get's this wrong...
  IF NOT prevControlChr THEN _CONTROLCHR OFF
  PRINT text$;
  IF NOT prevControlChr THEN _CONTROLCHR ON
  LOCATE pr, pc
  IF ofg <> -1 AND obg <> -1 THEN
    COLOR ofg, obg
  END IF
END SUB

' QPrintAny provides a simple way for a BASIC program to utilize 
' two monitors at the same time. 
SUB QPrintAny (txt$, clr, monCode, row, column)
  ' NOTE: monCode is currently not active.
  '       1 - Monochrome monitor at segment &HB000
  '       2 - CGA monitor at segment &HB800
  '       3 - EGA or VGA monitor at segment &HB800
  ofg = -1: obg = -1
  IF clr = -1 THEN
    ' Maintain existing color...
  ELSE
     ofg = _DEFAULTCOLOR: obg = _BACKGROUNDCOLOR
     SplitColor clr, fg, bg
     COLOR fg, bg
  END IF
  pr = CSRLIN
  pc = POS(0)
  LOCATE row, column
  prevControlChr = _CONTROLCHR ' <----------- QB64 definately get's this wrong...
  IF NOT prevControlChr THEN _CONTROLCHR OFF
  PRINT txt$;
  IF NOT prevControlChr THEN _CONTROLCHR ON
  LOCATE pr, pc
  IF ofg <> -1 AND obg <> -1 THEN
    COLOR ofg, obg
  END IF
END SUB

SUB QPrintRC (txt$, r, c, clr)
  IF r < 1 OR r > 25 OR c < 1 OR c > 80 THEN EXIT SUB
  ofg = -1: obg = -1
  IF clr = -1 THEN
    ' Maintain existing color...
  ELSE
     ofg = _DEFAULTCOLOR: obg = _BACKGROUNDCOLOR
     SplitColor clr, fg, bg
     COLOR fg, bg
  END IF
  pr = CSRLIN
  pc = POS(0)
  LOCATE r, c
  prevControlChr = _CONTROLCHR ' <----------- QB64 definately get's this wrong...
  IF NOT prevControlChr THEN _CONTROLCHR OFF
  PRINT txt$;
  IF NOT prevControlChr THEN _CONTROLCHR ON
  LOCATE pr, pc
  IF ofg <> -1 AND obg <> -1 THEN
    COLOR ofg, obg
  END IF
END SUB

' ReadScrn will quickly read characters from the display screen, and 
' store them in a specified string variable. 
SUB ReadScrn (row, column, x$, page)
  ' row and column tell ReadScrn where on the screen the 
  ' characters are located, x$ receives the screen contents, and page 
  ' indicates which video page to read. If Page is set to -1, then 
  ' ReadScrn will read from the currently active screen page. 
  ' The number of characters to be read is specified by the length of X$.
  FOR c = column TO column + LEN(x$) - 1
    MID$(x$, c - column + 1, 1) = CHR$(SCREEN(row, c))
  NEXT
END SUB

' ReadScrn0 will quickly read characters from the display screen, 
' and store them in a specified string variable. 
SUB ReadScrn0 (row, column, x$)
  ' Row and Column tell ReadScrn0 where on the screen the 
  ' characters are located, and X$ receives the screen contents. 
  ' The number of characters to read is specified by the length of X$. 
  CALL ReadScrn (row, column, x$, 0)
END SUB

' ScrnRest will restore a screen that had previously been saved with 
' ScrnSave or ScrnSave0. 
SUB ScrnRest (ulRow, ulCol, lrRow, lrCol, element(), page)
  ' NOTE: page is currently not implemented
  rows = (lrRow - ulRow) + 1
  cols = (lrCol - ulCol) + 1
  FOR r = 0 TO rows - 1
    FOR c = 0 TO cols - 1
      index = LBOUND(element) + ((r * cols) + c)
      ' clr = element(index) AND &H00FF ' split color
      ' ch = ((element(index) AND &HFF00) \ 256) AND &H00FF ' split character
      ch = element(index) AND &H00FF ' split color
      clr = ((element(index) AND &HFF00) \ 256) AND &H00FF ' split character
      QPrintRC CHR$(ch), ulRow + r, ulCol + c, clr
    NEXT
  NEXT
END SUB

' ScrnRest0 will restore a screen that had previously been saved with 
' ScrnSave or ScrnSave0. 
SUB ScrnRest0 (ulRow, ulCol, lrRow, lrCol, element())
  ScrnRest ulRow, ulCol, lrRow, lrCol, element(), 0
END SUB

' ScrnSave will save all or part of a text screen into an integer array, 
' to allow restoring it again at a later time. 
SUB ScrnSave (ulRow, ulCol, lrRow, lrCol, element(), page)
  ' NOTE: page is currently not implemented
  rows = (lrRow - ulRow) + 1
  cols = (lrCol - ulCol) + 1
  FOR r = 0 TO rows - 1
    FOR c = 0 TO cols - 1
      index = LBOUND(element) + ((r * cols) + c)
      ' ch = SCREEN(ulRow + r, ulCol + c, 0)
      ' clr = SCREEN(ulRow + r, ulCol + c, 1)
      clr = SCREEN(ulRow + r, ulCol + c, 0)
      ch = SCREEN(ulRow + r, ulCol + c, 1)
      element(index) = (ch * 256) + clr ' combine
    NEXT
  NEXT
END SUB

' ScrnSave will save all or part of a text screen into an integer array, 
' to allow restoring it again at a later time. 
SUB ScrnSave0 (ulRow, ulCol, lrRow, lrCol, element())
  ScrnSave ulRow, ulCol, lrRow, lrCol, element(), 0
END SUB

' ScrollD will scroll any portion of the display screen down a 
' specified number of lines.
SUB ScrollD(ulRow, ulCol, lrRow, lrCol, lines, page)
  
  ' NOTE: page is currently not implemented.
  ' If page = -1 then current screen will be scrolled.

  tr = (lrRow - ulRow) + 1
  IF tr < lines THEN
    ' If the number of lines to scroll is greater than the area to scroll, just clear.
    CALL ClearScr (ulRow, ulCol, lrRow, lrCol, -1, page)
  ELSE
    DIM array(ArraySize(ulRow + lines, ulCol, lrRow, lrCol))
    CALL ScrnSave (ulRow, ulCol, lrRow - lines, lrCol, array(), page)
    CALL ScrnRest (ulRow + lines, ulCol, lrRow, lrCol, array(), page)
    CALL ClearScr (ulRow, ulCol, ulRow + (lines - 1), lrCol, -1, page)
  END IF

END SUB

' ScrollL will scroll any portion of the display screen left a 
' specified number of columns.
SUB ScrollL(ulRow, ulCol, lrRow, lrCol, columns, page)

  ' NOTE: page is currently not implemented.
  ' If page = -1 then current screen will be scrolled.

  tc = (lrCol - ulCol) + 1
  IF tc < columns THEN
    ' If the number of columns to scroll is greater than the area to scroll, just clear.
    CALL ClearScr (ulRow, ulCol, lrRow, lrCol, -1, page)
  ELSE
    DIM array(ArraySize(ulRow, ulCol + columns, lrRow, lrCol))
    CALL ScrnSave (ulRow, ulCol + columns, lrRow, lrCol, array(), page)
    CALL ScrnRest (ulRow, ulCol, lrRow, lrCol - columns, array(), page)
    CALL ClearScr (ulRow, lrCol - (columns - 1), lrRow, lrCol, -1, page)
  END IF

END SUB

' ScrollR will scroll any portion of the display screen right a 
' specified number of columns.
SUB ScrollR(ulRow, ulCol, lrRow, lrCol, columns, page)

  ' NOTE: page is currently not implemented.
  ' If page = -1 then current screen will be scrolled.

  tc = (lrCol - ulCol) + 1
  IF tc < columns THEN
    ' If the number of columns to scroll is greater than the area to scroll, just clear.
    CALL ClearScr (ulRow, ulCol, lrRow, lrCol, -1, page)
  ELSE
    DIM array(ArraySize(ulRow, ulCol, lrRow, lrCol - columns))
    CALL ScrnSave (ulRow, ulCol, lrRow, lrCol - columns, array(), page)
    CALL ScrnRest (ulRow, ulCol + columns, lrRow, lrCol, array(), page)
    CALL ClearScr (ulRow, ulCol, lrRow, ulCol + (columns - 1), -1, page)
  END IF

END SUB

' ScrollU will scroll any portion of the display screen up a 
' specified number of lines.
SUB ScrollU(ulRow, ulCol, lrRow, lrCol, lines, page)

  ' NOTE: page is currently not implemented.
  ' If page = -1 then current screen will be scrolled.

  tr = (lrRow - ulRow) + 1
  IF tr < lines THEN
    ' If the number of lines to scroll is greater than the area to scroll, just clear.
    CALL ClearScr (ulRow, ulCol, lrRow, lrCol, -1, page)
  ELSE
    DIM array(ArraySize(ulRow, ulCol, lrRow - lines, lrCol))
    CALL ScrnSave (ulRow + lines, ulCol, lrRow, lrCol, array(), page)
    CALL ScrnRest (ulRow, ulCol, lrRow - lines, lrCol, array(), page)
    CALL ClearScr (lrRow - (lines - 1), ulCol, lrRow, lrCol, -1, page)
  END IF

END SUB

SUB SplitColor (colr, fg, bg)
  fg = (colr AND 128) \ 8 + (colr AND 15) 
  bg = (colr AND 112) \ 16 
END SUB

' Chapter Next

FUNCTION BitShift (value, cmd$, bits)
  mult = 2
  SELECT CASE bits
    CASE 1 ' already set
    CASE 2: mult = 4
    CASE 3: mult = 8
    CASE 4: mult = 16
    CASE 5: mult = 32
    CASE 6: mult = 64
    CASE 7: mult = 128
    CASE 8: mult = 256
    CASE 9: mult = 512
    CASE 10: mult = 1024
    CASE 11: mult = 2048
    CASE 12: mult = 4096
    CASE 13: mult = 8192
    CASE 14: mult = 16384
    CASE 15: mult = 32768
    CASE 16: mult = 65536
    CASE ELSE
  END SELECT
  IF cmd$ = "<<" THEN ' "value" has to be shifted "bits" bit(s) to the left.
    ' formula: x = x * 2 ^ y
    BitShift = ((value * mult) AND &HFFFF)
  ELSEIF cmd$ = ">>" THEN ' "value" has to be shifted "bits" bit(s) to the right.
    ' formula: x = x / 2 ^ y
    BitShift = value \ mult
  END IF
END FUNCTION

' FUNCTION FRE(value$)
'   RETURN 32768
' END FUNCTION