#INCLUDE ONCE "PRO.BI"

CLS

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

  Type Thing
    A As Short
    B As Short
  End Type

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