' (c) 2023 Cory Smith

#INCLUDE ONCE "PRO.BI"
'#INCLUDE ONCE "fbgfx.bi"

'PRINT ExeName
'PRINT DCount("d:\test\*.*")
'PRINT DCount("d:\github\*.*")
'PRINT FCount("d:\github\*.*")

'Var drive = "C"
'Dim bytes As Short, sectors As Short, freeClusters As ULong, totalClusters As uLong
'DiskInfo drive, bytes, sectors, freeClusters, totalClusters
'PRINT sectors, bytes, freeclusters, totalClusters
'PRINT sectors * bytes * freeClusters
'PRINT DiskSize(drive)
'PRINT DiskRoom(drive)

' Dim errCode As Short
' Var file1 = "d:\test\a.txt"
' 'Var file2 = "d:\test\b.txt"
' Var file2 = "d:\test\c.txt"
' Var result = FileComp(file1, file2, errCode)

' PRINT result, errCode

'PRINT Hex(FB.SC_ALT)
'PRINT Hex(FB.SC_ESCAPE)

' Note: the following **only** works in the "classic" *Command Prompt* console window; not others (such as Windows Terminal).
Do
  LOCATE 1, 1: PRINT AltKey
  LOCATE 2, 1: PRINT CapsLock
  LOCATE 3, 1: PRINT CtrlKey
  LOCATE 4, 1: PRINT NumLock
  LOCATE 5, 1: PRINT ScrlLock
  LOCATE 6, 1: PRINT ShiftKey
  If MultiKey(&h1) Then Exit Do ' ESC
Loop