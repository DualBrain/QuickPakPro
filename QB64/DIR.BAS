' temp sample to test file functions.

'$INCLUDE: 'QPPRO.BI'

spec$ = "C:\BAS\*.*" '"C:*.*"

'count= FCount%("D:\LOTUS\*.WK1")
filecount = FCount%(spec$)
PRINT filecount

dircount = DCount%(spec$)
PRINT dircount

DIM dArray$(0 TO dircount)
dArray$(0) = spec$
CALL ReadDir(dArray$())

FOR x = 1 TO UBOUND(dArray$)
  PRINT "\" + dArray$(x)
NEXT

DIM array$(0 TO filecount)

array$(0) = spec$
CALL ReadFile(array$())

FOR x = 1 TO UBOUND(array$)
  PRINT array$(x)
NEXT

'$INCLUDE: 'QPPRO.BAS'