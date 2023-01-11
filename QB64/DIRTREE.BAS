' ********* DIRTREE.BAS - returns an entire directory tree in a string array

' Copyright (c) 1990 Crescent Software
' written by Don Malin
' Modified (c) 2023 Cory Smith

' **************************
' * BOILER PLATE BEGIN
' **************************
$Resize:Stretch
CHDIR _STARTDIR$ ' Moved this line above resize to (hopefully) give more init time to window
IF _DesktopHeight => 2160 THEN mult = 4 ELSE IF _DesktopHeight => 1440 THEN mult = 2 ELSE mult = 1
DO: LOOP UNTIL _SCREENEXISTS ' Not sure if necessary; however, there does seem to be some sort of timing issue around getting hwnd
hwnd = _WindowHandle: x = 100: y = 100: w = 640 * mult: h = 480 * mult ' inlined _WindowHandle (next line) because 1 out of every 4 or 5 executions, would encounter an invalid window handle (1400)
IF INSTR(_OS$, "[WINDOWS]") THEN success = MoveWindow(_WindowHandle, x, y, w, h, 1) ELSE success = -1 ' Now that _WindowHandle is inlined, invalid window handle (1400) issue has yet to be reproduced - will have to continue to test
IF success = 0 THEN PRINT "FAILED TO RESIZE - "; GetLastError; " ("; hwnd; ")": CALL WaitKeyS
_TITLE "DIRTREE" 'NOTE: Moving title above resize causes resize to fail (without an error???)
'BUG: It would be nice specify the icon here, but... having to require full path or placing it in the qb64 folder is problematic. 
'NOTE: The above boiler plate must be first in execution (top of file).
'BUG:  Also appears to not work as an $INCLUDE; suggesting something might
'      be wrong with the implementation of $INCLUDE.
' **************************
' * BOILER PLATE END
' **************************

DEFINT A-Z

'$INCLUDE: 'PRO.BI'

' TYPE Dirs
'   DName AS STRING * 12
' END TYPE

DECLARE FUNCTION DCount% (dirSpec$)
DECLARE FUNCTION NotInstr% (stPos%, text$, table$)

DECLARE SUB DirTree (tree$(), fullPath$(), ptr%)
DECLARE SUB InsertStr (BYVAL address, Ins$, numEls)
DECLARE SUB ReadDirT (spec$, SEG element AS Dirs)

CONST MAXDIRS = 250                     ' this sets the maximum levels

DIM tree$(MAXDIRS)
DIM fullPath$(MAXDIRS)

tree$(1) = "C:\bas\"                        ' you MUST seed the first element
levels = 1                              ' and the number of directory levels

DirTree tree$(), fullPath$(), levels    ' DirTree returns the number of levels

FOR x = 1 TO levels                     ' print the directory tree
  PRINT tree$(X); TAB(40); fullPath$(x) ' show both arrays DirTree returns
  IF x MOD 23 = 0 THEN                  ' if the screen is full
    LOCATE 25, 1                        ' prompt for more on the bottom
    PRINT "Press a key to see more";    ' and wait for a key press
    WHILE INKEY$ = "": WEND
    LOCATE CSRLIN - 1, 1                ' nudge the cursor to where it was
  END IF
NEXT

SUB DirTree (tree$(), fullPath$(), ptr)
   
  STATIC spec$, pad$, temp$, n, last, level, segment
  
  IF LEN(spec$) = 0 THEN                ' if we haven't been here before
    level = 1                           ' do some initializing
    last = MAXDIRS
    pad$ = SPACE$(63)
    spec$ = SPACE$(65)
    n = 1
  ELSE
    n = INSTR(spec$, "*")
    LSET spec$ = LEFT$(spec$, n - 1)
  END IF

  MID$(spec$, n) = RTRIM$(MID$(tree$(ptr), NotInstr%(1, tree$(ptr), " " + CHR$(179) + CHR$(195) + CHR$(192) + CHR$(196))))
  n = INSTR(spec$, " ")
  IF MID$(spec$, n - 1, 1) <> "\" THEN
    MID$(spec$, n) = "\*.*"
  ELSE
    MID$(spec$, n) = "*.*"
  END IF

  prevSpec$ = spec$

  dirCnt = DCount%(RTRIM$(spec$))

  IF dirCnt THEN
    'REDIM dArray(1 TO dirCnt) AS Dirs
    'ReadDirT RTRIM$(spec$), dArray(1)

    REDIM dArray$(0 TO dirCnt)
    dArray$(0) = spec$
    ReadDir dArray$(), 1

    temp$ = LEFT$(spec$, INSTR(spec$, "*") - 1)

    FOR n = 1 TO dirCnt
      LSET pad$ = ""
      FOR temp = 0 TO level - 2
        temp2 = ASC(MID$(tree$(ptr + n - 1), temp * 4 + 1, 1))
        IF temp2 = 179 OR temp2 = 195 THEN
          MID$(pad$, temp * 4 + 1) = CHR$(179)
        END IF
      NEXT

      IF n = dirCnt THEN
        MID$(pad$, temp * 4 + 1) = CHR$(192) + CHR$(196) + CHR$(196) + CHR$(196)
      ELSE
        MID$(pad$, temp * 4 + 1) = CHR$(195) + CHR$(196) + CHR$(196) + CHR$(196)
      END IF

      MID$(pad$, level * 4 + 1) = dArray$(n) 'dArray(n).DName
      ins$ = RTRIM$(pad$)
      'InsertStr VARPTR(tree$(ptr + n)), ins$, last - n - ptr
      InsertStr tree$(), ptr + n, ins$, last - n - ptr
      
      LSET pad$ = temp$ + dArray$(n) 'dArray(n).DName
      ins$ = RTRIM$(pad$)
      'InsertStr VARPTR(fullPath$(ptr + n)), ins$, last - n - ptr
      InsertStr fullPath$(), ptr + n, ins$, last - n - ptr

    NEXT

    ERASE dArray$

    temp = ptr
    DO
      level = level + 1
      LSET spec$ = prevSpec$
      ptr = ptr + 1
      temp2 = ptr
      DirTree tree$(), fullPath$(), ptr
      dirCnt = dirCnt + ptr - temp2
    LOOP UNTIL ptr > dirCnt + temp - 1

  END IF

  level = level - 1

  IF level = 0 THEN                   ' if this is the highest level, free
    spec$ = ""                        ' up the memory used by these strings
    prevSpec$ = ""
    pad$ = ""
  END IF

END SUB

'$INCLUDE: 'PRO.BAS'