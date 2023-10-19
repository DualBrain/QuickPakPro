' (c) 2023 Cory Smith

#INCLUDE ONCE "PRO.BI"

PRINT ExeName
'PRINT DCount("d:\test\*.*")
PRINT DCount("d:\github\*.*")
PRINT FCount("d:\github\*.*")

Var drive = "C"
'Dim bytes As Short, sectors As Short, freeClusters As ULong, totalClusters As uLong
'DiskInfo drive, bytes, sectors, freeClusters, totalClusters
'PRINT sectors, bytes, freeclusters, totalClusters
'PRINT sectors * bytes * freeClusters
'PRINT DiskSize(drive)
'PRINT DiskRoom(drive)

Dim errCode As Short
Var file1 = "d:\test\a.txt"
'Var file2 = "d:\test\b.txt"
Var file2 = "d:\test\c.txt"
Var result = FileComp(file1, file2, errCode)

PRINT result, errCode