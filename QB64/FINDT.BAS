' ********** FINDT.BAS - demos searching a fixed-length array for a sub-string

' Copyright (c) 1988 Ethan Winer
' Modifications (c) 2023 Cory Smith

' There are four versions of Find to locate a string or sub-string in an array.
' This demo shows only the case-insensitive versions.
'
'   FindT searches forward and is case-sensitive
'   FindT2 also searches forward, but ignores capitalization
'   FindTB searches backwards and honors capitalization
'   FindTB2 searches backwards and ignores capitalization
'
' Notes:
'
'   Because FindTB and FindTB2 know which element they are starting with, they
'   are able to return the element number at which the match was found.  But
'   FindT and FindT2 can't not know how large the array is, so thet are set up
'   to instead return the number of elements that were searched.  All four
'   routines use -1 to indicate that a match was not found, however Find and
'   FindT2 will report 0 if the match was made on the element they started
'   searching with.  If you start on, say, element 10 and FindT (or FindT2)
'   found a match at element 12, they would return 2 meaning two elements
'   BEYOND the current one were examined.  The examples below show all of
'   this in context.

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
_TITLE "FINDT" 'NOTE: Moving title above resize causes resize to fail (without an error???)
'BUG: It would be nice specify the icon here, but... having to require full path or placing it in the qb64 folder is problematic. 
'NOTE: The above boiler plate must be first in execution (top of file).
'BUG:  Also appears to not work as an $INCLUDE; suggesting something might
'      be wrong with the implementation of $INCLUDE.
' **************************
' * BOILER PLATE END
' **************************

DEFINT A-Z

'$INCLUDE: 'PRO.BI'

DECLARE SUB FindT2 (BYVAL segment, BYVAL address, elSize, element, srch$)
DECLARE SUB FindTB2 (BYVAL segment, BYVAL address, elSize, element, srch$)

size = 5000
elSize = 20
REDIM array(size) AS STRING * 20

FOR x = 0 TO 10
  READ array$(x)
NEXT
array(size) = "Find me hiding here"

DATA "Smith, Harold"
DATA "Rogers, Maude"
DATA "Smith, Arthur"
DATA "Sureta Escobar"
DATA "Rogers, Carl J."
DATA "Rubin, Fenster"
DATA "Smythson, Wendy"
DATA "Plant, Gail H."
DATA "Smith Barney & Co."
DATA "Ericson, Sven"
DATA "Babbage, Charles"

CLS
LINE INPUT "Enter a string to search for (hint - try sm?th): "; srch$
PRINT "Search forward or backward (F/B)? ";

DO
  fDir$ = UCASE$(INKEY$)
LOOP UNTIL fDir$ = "F" OR fDir$ = "B"

PRINT fDir$
PRINT

IF fDir$ = "F" THEN

  '----- Search forward

  start = 0                    'start searching at the first element
  elements = size              'search the entire array

DIM block AS _MEM 

Forward:
  'FindT2 VARSEG(array$(start)), VARPTR(array$(start)), elSize, elements, srch$
  block = _MEM(array$(start))
  FindT2 block, elSize, elements, srch$
  _MEMFREE block
						  
  ' First see if it was there.  FindT2 returns -1 if it isn't found, but also
  ' check to be sure it didn't happen to match some garbage in memory that
  ' looked like Search$.
  IF elements = -1 OR start + elements > size THEN
    PRINT "Not Found"
    END
  END IF

  start = start + elements      ' calculate the element number it was found at
                                ' Elements returns with how far it searched,
                                '   not an actual element number

  PRINT start; TAB(7); array$(start)   ' print the matching element
  IF start = size THEN END             ' it was found at the last element -
		                              		 '   don't ask if they want to continue
  PRINT
  PRINT "Continue searching? (Y/N) ";

  DO
    x$ = UCASE$(INKEY$)
  LOOP UNTIL x$ = "Y" OR x$ = "N"

  PRINT x$
  PRINT
  IF x$ <> "Y" THEN END

  elements = size - start      ' consider only the remaining part of the array
  start = start + 1            ' continue from the next element
  IF elements <= size GOTO Forward     ' continue search only if there's more

ELSE

  '----- Search backwards

  elements = size              ' search entire array starting at the beginning

Backward:
  'FindTB2 VARSEG(array$(elements)), VARPTR(array$(elements)), elSize, elements, srch$
  block = _MEM(array$(LBOUND(elements)))
  FindTB2 block, elSize, elements, srch$
  _MEMFREE block

  IF elements = -1 THEN        ' Find returns -1 if it isn't found
    PRINT "Not Found"
    END
  END IF

  PRINT elements; TAB(7); array$(elements)
  IF elements = 0 THEN END     ' it was at the first element - don't ask
				                       '   if they want to continue

  PRINT "Continue searching? (Y/N) ";

  DO
    x$ = UCASE$(INKEY$)
  LOOP UNTIL x$ = "Y" OR x$ = "N"

  PRINT x$
  PRINT
  IF x$ <> "Y" THEN END

  elements = elements - 1      ' continue with the previous element
  GOTO Backward

END IF

'$INCLUDE: 'PRO.BAS'