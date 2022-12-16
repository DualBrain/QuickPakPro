' ********** READDIRS.BAS

' Utility to search through all levels of sub-directories for matching files

' Copyright (c) 1987 Ethan Winer
' Modifications (c) 2022 Cory Smith

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
_TITLE "READDIRS" 'NOTE: Moving title above resize causes resize to fail (without an error???)
'BUG: It would be nice specify the icon here, but... having to require full path or placing it in the qb64 folder is problematic. 
'NOTE: The above boiler plate must be first in execution (top of file).
'BUG:  Also appears to not work as an $INCLUDE; suggesting something might
'      be wrong with the implementation of $INCLUDE.
' **************************
' * BOILER PLATE END
' **************************

DEFINT A-Z

'$INCLUDE: 'PRO.BI'

DECLARE SUB CleanUp ()
DECLARE SUB Display (T)
DECLARE FUNCTION DCount (dSpec$)
DECLARE FUNCTION FCount (fSpec$)
DECLARE SUB FileInfo (fSpec$, SEG ArrayEl)
DECLARE FUNCTION GetDir$ (drive$)
DECLARE FUNCTION GetDrive% ()
DECLARE SUB DiskInfo (drive$, bps, sc, ac, tc)
DECLARE FUNCTION Padder$ (x)
DECLARE SUB ReadDir (array$())
DECLARE SUB ReadFile (array$())
DECLARE SUB SetDrive (drive$)

'We SHOULD be using "SEG Element$" instead of "BYVAL Segment, BYVAL Address",
'in ReadFileT, but a "design decision" in QB 4 prevents this from working.

CLEAR , , 2000          'recursive subprogram Display needs extra stack space

START:

CLS
srch$ = "*.*"           ' used for finding all directory names
fullInfo = 0            ' use zero to suppress full file info (and run faster)
DIM iArray(8)           ' holds each file's size, date, time, and attribute

PRINT "This program searches an entire disk for a specified file."
PRINT "You may also use the DOS wildcards to search for a group of files."
PRINT
PRINT TAB(5); "Enter file spec (ie C:*.bas), or press Enter for *.* ";
LINE INPUT spec$
IF spec$ = "" THEN spec$ = srch$

IF INSTR(spec$, "\") THEN
  PRINT
  PRINT "Do not specify a directory.  This program searches ALL directories"
  PRINT "Press a key: ";
  CALL WaitKeyS
  GOTO START
END IF

CLS
LOCATE 25, 1: PRINT "Press any key to pause, or ESC to exit";
LOCATE 1, 1

IF MID$(spec$, 2, 1) = ":" THEN                 'a drive was specified
  drive$ = LEFT$(spec$, 1)                     'isolate the drive letter
  spec$ = MID$(spec$, 3)                       'and the file specification
END IF

original$ = GetDir$(drive$)                     'save current directory
drive = GetDrive%                               'and the current drive
IF LEN(drive$) THEN SetDrive drive$             'drive was given, change to it
CHDIR "\"                                       'start searching in the root

totalCount = 0                                  'total number of files found
tabLevel = 2                                    'amount to tab when printing
Display tabLevel                                'display all matching files
CleanUp                                         'restore original path & drive

PRINT totalCount; "File(s) Found"
'TODO: DiskInfo is currently not implemented.
DiskInfo drive$, bytesPerSector, sectorsPerCluster, availableClusters, totalClusters
PRINT

PRINT USING "##,###,### Bytes Free "; CLNG(bytesPerSector) * CLNG(sectorsPerCluster) * CLNG(availableClusters)
PRINT USING "##,###,### Total Disk Space "; CLNG(bytesPerSector) * CLNG(sectorsPerCluster) * CLNG(totalClusters)

PRINT GetDir$(drive$)
PRINT GetDrive%

SUB CleanUp STATIC
  SHARED drive, drive$, original$
  'COMMENT: The following to lines seem backward to me...
  CHDIR original$                             'back to original directory
  IF LEN(drive$) THEN SetDrive CHR$(drive)    'and drive
END SUB

SUB Display (t)

  SHARED drive, drive$, spec$, srch$, totalCount, fullInfo, iArray()

  IF t > 40 THEN                               ' 20 levels is enough, agreed?
    PRINT "Too many levels"
    EXIT SUB
  END IF

  'curntDir$ = SPACE$(64)                      ' make room for directory name
  curntDir$ = GetDir$("")                      ' get directory, current drive
  curntDir$ = RTRIM$(curntDir$)                ' strip trailing blanks

  fCnt = FCount(spec$)                         ' count matching files
                                               '  0 means count normal files
  totalCount = totalCount + fCnt               ' add to the accumulator
  DIM fArray$(0 TO fCnt)                       ' dimension array accordingly
  fArray$(0) = spec$
  ReadFile farray$()                           ' read the names
                                               '  0 means read normal files
  IF LEN(drive$) THEN                          ' print the drive being used
    PRINT UCASE$(drive$);                      '  if appropriate
  ELSE                                         '  else print original drive
    PRINT CHR$(drive);
  END IF
  PRINT ":"; curntDir$                         ' print current directory

  FOR X = 1 TO fCnt                            ' for each file
    PRINT TAB(T); fArray$(X);                  ' tab in T spaces and print it

    IF fullInfo THEN                           ' if they want the big picture
      'TODO: FileInfo is currently not implemented.
      FileInfo fArray$(x), iArray(0)
      ' calculate the file size from two integer words
      lw& = IArray(6): IF lw& < 0 THEN lw& = lw& + 65536
      hw& = IArray(7): IF hw& < 0 THEN hw& = hw& + 65536
      PRINT USING "#########,"; lw& + 65536 * hw&;
      PRINT SPC(2);

      PRINT Padder$(iArray(1)); "/"; Padder$(iArray(2)); "/"; Padder$(iArray(0)); SPC(2);
      PRINT Padder$(iArray(3)); ":"; Padder$(iArray(4)); ":"; Padder$(iArray(5)); SPC(2);
      IF iArray(8) AND 1 THEN PRINT "Read-Only ";
      IF iArray(8) AND 2 THEN PRINT "Hidden ";
      IF iArray(8) AND 4 THEN PRINT "System ";
      IF iArray(8) AND 16 THEN PRINT "Subdirectory "; ' this isn't needed
      IF iArray(8) AND 32 THEN PRINT "Archive";
    END IF
    PRINT

    x$ = INKEY$                                ' see if they pressed a key
    IF x$ <> "" THEN                           ' pause on any keypress, or
      IF x$ = CHR$(27) THEN                    ' abort upon Escape, but first
        CleanUp                                ' put everything back to normal
        END
      ELSE
        WHILE INKEY$ = "": WEND                ' wait for another key
      END IF
    END IF
  NEXT

  PRINT : PRINT                                ' add a couple of blank lines
  dCnt = DCount(srch$)                         ' count dirs under this one
       
  IF dCnt THEN                                 ' if there are any, then

    DIM dArray$(0 TO dCnt)                     ' dimension array for dir names
    dArray$(0) = srch$
    ReadDir dArray$()
                                               ' get all dirs under this one
    IF curntDir$ = "\" THEN                    ' if we're in the root, use a
      prefix$ = ""                             ' blank, otherwise use the
    ELSE                                       ' current directory
      prefix$ = CurntDir$
    END IF

    FOR x = 1 TO dCnt                          ' for each directory,
      CHDIR prefix$ + "\" + dArray$(x)         ' change to it
      Display t + 5                            ' and do this routine again
    NEXT

  END IF

END SUB

' strip leading space, pad w/leading zero if needed
FUNCTION Padder$ (x)       
  IF LEN(STR$(x)) = 2 THEN
    Padder$ = "0" + RIGHT$(STR$(x), 1)
  ELSE
    Padder$ = RIGHT$(STR$(x), 2)
  END IF
END FUNCTION

'$INCLUDE: 'PRO.BAS'