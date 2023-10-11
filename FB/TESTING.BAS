#INCLUDE ONCE "PRO.BI"

CLS

Type Thing
  A As Short
  B As Short
End Type

Type NameNumber
  Name As String * 20
  Number As Short
End Type

' AddInt
IF False Then
  Dim a(100) As Short
  FOR i As Short = 0 To 100
    a(i) = i
  NEXT
  PRINT a(10)
  AddInt(@a(1), 100, 100)
  PRINT a(10)
End If

' DeleteStr
If False Then
  Dim stringArray(10) As String
  For i As Short = 0 To 10
    stringArray(i) = "Element" + STR$(i)
  Next
  PRINT stringArray(6)
  PRINT stringArray(10)
  DeleteStr @stringArray(5), 5
  PRINT stringArray(6)
  PRINT stringArray(10)
End If

' DeleteT
IF False Then

  Dim ta(10) AS Thing

  FOR i As Short = 0 TO 10
    ta(i).A = I
    ta(i).B = 100 + I
  NEXT

  PRINT ta(6).a
  PRINT ta(10).a
  Var element = 5
  Var elSize = LEN(Thing) '-1
  Var numEls = 5
  'DeleteT VARPTR(ta(element)), elSize, numEls
  DeleteT @ta(element), elSize, numEls
  PRINT ta(6).a
  PRINT ta(10).a
End If

' Fill2
If False Then
  Dim a(100) As Short
  FOR i As Short = 0 To 100
    a(i) = i
  NEXT
  PRINT a(10)
  Fill2(@a(5), 3, 20)
  PRINT a(10)
End If

' Fill4
If False Then
  Dim a(100) As Long
  FOR i As Short = 0 To 100
    a(i) = i
  NEXT
  PRINT a(10)
  Fill4(@a(5), 3, 20)
  PRINT a(10)
End If

' Fill8
If False Then
  Dim a(100) As Double
  FOR i As Short = 0 To 100
    a(i) = i
  NEXT
  PRINT a(10)
  Fill8(@a(5), 3, 20)
  PRINT a(10)
End If

' Find / Find2
If False Then

  Dim a(10) As String
  For x As Integer = 0 To 10
    a(x) = "Element" + STR$(x)
  Next

  Dim numEls As Short = 11
  Find2 @a(0), numEls, "5"
  PRINT numEls

End If

' FindB / FindB2
If False Then

  Dim a(10) As String
  For x As Integer = 0 To 10
    a(x) = "Element" + STR$(x)
  Next

  Dim curEl As Short = 9 'UBOUND(a)
  FindB2 @a(curEl), curEl, "0"
  PRINT curEl

End If

' FindExact
If False Then

  Dim a(10) As String
  For x As Integer = 0 To 10
    a(x) = "Element" + STR$(x)
  Next

  Dim numEls As Short = UBOUND(a) + 1
  FindExact @a(0), numEls, "3"
  PRINT numEls

End If

' FindT / FindT2
If false Then

  Dim a(10) As String * 20
  For x As Integer = 0 To 10
    a(x) = "Element" + STR$(x)
  Next

  Dim numEls As Short = UBOUND(a) + 1
  FindT @a(0), 20, numEls, "t3"
  PRINT numEls

End If

' FindTB / FindTB2
If false Then

  Dim a(10) As String * 40
  For x As Integer = 0 To 10
    a(x) = "Element " + STR$(x)
  Next

  Dim curEl As Short = UBOUND(a)
  FindTB2 @a(curEl), 40, curEl, "t 3"
  PRINT curEl

End If

' FindLast
If False Then

  Dim a(10) As String
  For x As Integer = 0 To 10
    a(x) = "Element " + STR$(x)
  Next

  a(9) = ""
  a(10) = ""

  Dim numEls As Short = UBOUND(a)
  Var last = FindLast(@a(numEls), numEls)
  PRINT last

End If

' GetBit/SetBit
If False Then
  ' TODO
End If

' IMaxX/IMinX
If False Then
  ' TODO
End If

' InitInt
If false Then

  Dim ndx(10) As Short
  InitInt @ndx(0), 0, 11

  FOR i As Short = 0 To 10
    PRINT ndx(i)
  Next

End If

' InsertStr
If False Then

  Dim a(10) As String
  For x As Short = 0 To 10
    a(x) = "Element " + STR$(x)
  Next

  InsertStr @a(5), "Testing", 5

  For x As Short = 0 To 10
    PRINT a(x)
  Next

End If

' InsertT
If False Then

  Dim a(10) As Thing

  For i As Short = 0 To 10
    a(i).a = i
    a(i).b = i
  Next

  InsertT @a(5), 4, 5

  For i As Short = 0 To 10
    PRINT i; a(i).a; a(i).b
  Next

End If

' ISortD/I/L/S/C
IF false Then

  Dim a(3) As Double
  a(0) = 100
  a(1) = 10
  a(2) = 30
  a(3) = 5
  'a(4) = 1000
  'a(5) = 2

  Dim ndx(UBOUND(a)) As Short

  ISortD @a(lbound(a)), @ndx(lbound(ndx)), ubound(a) + 1, 1
  
  For i As Short = 0 To ubound(a)
    PRINT i; ndx(i); a(ndx(i))
  Next

End If

' ISortStr/2
IF false Then

  Dim a(3) As String
  a(0) = "a 100"
  a(1) = "10"
  a(2) = "b 30"
  a(3) = "B 5"
  'a(4) = "b 1000"
  'a(5) = "a 35"

  Dim ndx(UBOUND(a)) As Short

  ISortStr2 @a(lbound(a)), @ndx(lbound(ndx)), ubound(a) + 1, 0
  
  For i As Short = 0 To ubound(a)
    PRINT i; ndx(i); " "; a(ndx(i))
  Next

End If

' KeySort
If false then

  Dim a(3) As NameNumber
  a(0).Name = "b": a(0).Number = 3
  a(1).Name = "D": a(1).Number = 1
  a(2).Name = "c": a(2).Number = 4
  a(3).Name = "B": a(3).Number = 1

  Dim key(1 TO 2, 1 TO 3) As Short
  key(1, 1) = 22: key(1, 2) = -1: key(1, 3) = 0 ' Number
  key(2, 1) = 0: key(2, 2) = 20: key(2, 3) = 0 ' Name

  KeySort @a(0), Len(NameNumber), UBOUND(a) + 1, key(), 2

  For i As Short = 0 To UBOUND(a)
    PRINT a(i).Name; a(i).Number
  Next

End If

' SortT/SortT2
If false Then

  Dim a(3) As NameNumber
  a(0).Name = "b"
  a(1).Name = "A"
  a(2).Name = "c"
  a(3).Name = "B"

  Dim ndx(3) As Short
  InitInt(@ndx(0), 0, UBOUND(ndx) + 1)

  ISortT2 @a(0), @ndx(0), 4, 0, Len(NameNumber), 0, 20

  For index As Short = 0 To 3
    PRINT a(ndx(index)).Name
  NEXT

End If

' SortD
If false Then

  Dim a(5) As Double
  a(0) = 1.2
  a(1) = 0.5
  a(2) = 35.0
  a(3) = 42.0
  a(4) = 0.1
  a(5) = 100.0

  SortD @a(0), Ubound(a) + 1, 1

  For i As Short = 0 To UBound(a)
    PRINT a(i)
  Next

End If

' SortStr/SortStr2
If false Then

  Dim a(5) As String
  a(0) = "Zbx3"
  a(1) = "d35x"
  a(2) = "bbb"
  a(3) = "1200"
  a(4) = "Bax3"
  a(5) = "1000"

  SortStr2 @a(0), UBOUND(a) + 1, 0

  For i As Short = 0 To UBOUND(a)
    PRINT a(i)
  Next

End If

' SortT/SortT2
If false Then

  Dim a(3) As NameNumber
  a(0).Name = "b"
  a(1).Name = "A"
  a(2).Name = "c"
  a(3).Name = "B"

  SortT2 @a(0), UBOUND(a) + 1, 1, Len(NameNumber), 0, 20

  For i As Short = 0 To UBOUND(a)
    PRINT a(i).Name
  Next

End If

' Search
If false Then

  Dim a(5) As Double
  a(0) = 1.2
  a(1) = 0.5
  a(2) = 35.0
  a(3) = 42.0
  a(4) = 0.1
  a(5) = 100.0

  Dim found As Short
  Search @a(0), UBOUND(a) + 1, .1, found, -1, 0
  PRINT found

  'SortD @a(0), Ubound(a) + 1, 1

  ' For i As Short = 0 To UBound(a)
  '   PRINT a(i)
  ' Next

End If

' SearchT/2
If true Then

  Dim a(3) As NameNumber
  a(0).Name = "Name 3": a(0).Number = 3
  a(1).Name = "Name 1": a(0).Number = 1
  a(2).Name = "Name 2": a(0).Number = 2
  a(3).Name = "Name 6": a(0).Number = 6

  Dim found As Short = 0
  SearchT2 @a(0), UBOUND(a) + 1, "name 2", found, 0, 0, Len(NameNumber), 0, 20
  'Dim s As Short = 2
  'SearchT @a(0), UBOUND(a) + 1, s, found, 0, 0, Len(NameNumber), 22, -1
  PRINT found

End If