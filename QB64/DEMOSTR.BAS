' ********* DEMOSTR.BAS - demonstrates storing string arrays in far memory

' Copyright (c) 1988 Ethan Winer
' Modifications (c) 2022 Cory Smith

' This program shows how to copy an entire string array to far memory and
' back again.  Integer arrays are used for the storage because they may be
' dimensioned and erased as necessary.  Also, integer arrays are easily
' saved to disk (or EMS memory) and reloaded later to afford even more string
' memory. See the discussion in the manual appendix for an example of this.
'
' Besides being able to process an entire string array, a BASIC function is
' also provided to retrieve a single string from the integer storage array.
' Each of the routines is described below, and the following demonstration
' program shows these techniques in context.
'
' Five subroutines and five functions are employed as follows.  First,
' the StringSize function is used to determine the number of elements the
' integer array must be dimensoned to.  Next, StringSave is used to copy
' the string array into the integer array.  Finally, the BASIC subprogram
' StringRestore is called to create space in each string array element, and
' copy the string data from the integer array back into the string array.
'
' StringRestore calls upon the assembler StringRest routine and GetNext
' function to do the real work, however creating space in each string
' element must be done in BASIC.  GetNext retrieves the length of the next
' string element in sequence, so StringRestore will know how much space
' it is to reserve.
'
' Once room has been set aside in each string element, StringRest copies the
' entire integer array in one operation.  Also, the NumStrings function is
' provided to determine how many elements are stored in an integer array.
' This would be useful for an array that has just been loaded from disk.
'
' The BASIC function Get1String$ is provided to retrieve a single string
' from the integer storage array.  It uses the assembler function StrLength
' to know how long the string is.  Get1String is designed as a function so
' it may be used in an assignment or PRINT statement.  For example:
'
'     PRINT Get1String$(Array%(0), StringNumber%))
'  or
'     X$ = LEFT$(Get1String$(Array%(0), StringNumber%), 10)
'
' Understand that the array is used merely as a block of memory.  The string
' data is stored sequentially, and each element is terminated with a CRLF
' word, just as it would be in a normal text file.  Thus, any integer array
' that has been written to disk will be a normal ASCII text file.

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
_TITLE "DEMOSTR" 'NOTE: Moving title above resize causes resize to fail (without an error???)
'BUG: It would be nice specify the icon here, but... having to require full path or placing it in the qb64 folder is problematic. 
'NOTE: The above boiler plate must be first in execution (top of file).
'BUG:  Also appears to not work as an $INCLUDE; suggesting something might
'      be wrong with the implementation of $INCLUDE.
' **************************
' * BOILER PLATE END
' **************************

DEFINT A-Z

'$INCLUDE: 'PRO.BI'

' Notice that some of the assembler routines use BYVAL or SEG.  Because they
' have been declared that way, the BYVAL and SEG options are not used when
' they are called.  If you call these routines from your own programs and do
' not declare them, you MUST use SEG or BYVAL as part of the call.  All of
' the functions below are assembler, except as noted.

DECLARE FUNCTION DOSError% ()
DECLARE FUNCTION ErrorMsg$ (ErrNumber)
DECLARE FUNCTION FindLastSM& (SEG Element, NumBytes AS ANY)
DECLARE FUNCTION FLof& (Handle)
DECLARE FUNCTION Get1String$ (Array(), StrNumber)               'BASIC
DECLARE FUNCTION NumStrings% (SEG Element, NumBytes AS ANY)
DECLARE FUNCTION StringSize& (BYVAL Address, NumEls)
DECLARE FUNCTION WhichError% ()

DECLARE SUB StringSave (BYVAL Address, SEG Element, NumEls)
DECLARE SUB StringRestore (Array$(), Array())                   'BASIC
DECLARE SUB Sub1String (New$, SEG Element, NumBytes AS ANY, StrNumber)

CLS
LOCATE , , 0
numStr = 1000                           ' number of string elements to use
REDIM array$(1 TO numStr)               ' create a string array
PRINT "Creating random string data, stand by ";

'----- Load the string array with random nonsense

FOR x = 1 TO numStr
  array$(x) = SPACE$(RND * 20 + 1)    ' create a random length string element
  FOR y = 1 TO LEN(array$(x))         ' fill it with random characters
    MID$(array$(x), y) = CHR$(RND * 25 + 65)
  NEXT
  IF x MOD 50 = 0 THEN
    PRINT ". ";                      ' print a dot every fifty elements
    array$(x) = "This is element number" + STR$(x)   ' and mark for testing
  END IF
NEXT
array$(numStr) = "This is the very last string"    ' to identify this element
PRINT

'----- Use the assembler StringSize&() function to see how many bytes
'      will be needed in the integer array, and then dimension the array
'      to half the number of bytes (2 bytes per element).

numBytes& = StringSize&(VARPTR(array$(1)), numStr)
REDIM array(1 TO numBytes& / 2 + 1)             ' +1 for safety

'----- Copy the string array into the integer array.

t! = TIMER
StringSave VARPTR(array$(1)), array(1), numStr
t! = TIMER - t!
PRINT USING "#.## seconds to copy the string array to an integer array"; t!

'----- Save the integer array to disk to prove all of this is actually working

PRINT "Saving the array to disk"
CALL FCreate("$trMgr.Txt")                      ' create the output file
IF DOSError% THEN
  PRINT ErrorMsg$(WhichError%); " error creating the file."
  END
END IF

CALL FOpen("$trMgr.Txt", handle)                ' open it for QP Pro binary
CALL FPutA(handle, SEG array(1), numBytes&)
IF DOSError% THEN
  PRINT ErrorMsg$(WhichError%); " error saving the string array."
  END
END IF
CALL FClose(handle)                             ' close the file

'----- Open the file, REDIM the integer array, and read in the saved text

PRINT "Loading the array back again"
CALL FOpen("$trMgr.Txt", handle)
numBytes& = FLof&(handle)                  ' FLof reports the file size
REDIM Array(1 TO (numBytes& / 2) + 100)    ' + 100 allows Sub1String to replace
                                           '   a string with a longer one later
CALL FGetA(handle, SEG array(1), numBytes&)
CALL FClose(handle)
numStr = NumStrings%(array(1), numBytes&)
CALL KillFile("$trMgr.Txt")                ' clean up by erasing the file

'----- Show how to replace a single string in the far integer array

Sub1String "This replaces what was in element 999", array(1), numBytes&, 999

'----- Erase the string array, and then restore it to prove this all worked.

REDIM array$(1 TO NumStr)

t! = TIMER
StringRestore array$(), array()
IF DOSError% THEN                   ' the only error StringRestore reports is
  PRINT ErrorMsg$(WhichError%)      '   not enough elements in the string array
  END                               ' that won't happen in this demo, but we
END IF                              '   want to show how to test for it
t! = TIMER - t!
PRINT USING "#.## seconds to restore the string array from the integer array"; t!

'----- This shows how to retrieve a single string from the integer array.

t! = TIMER
PRINT "{"; Get1String$(Array(), numStr); "}"    ' get the last string element
t! = TIMER - t!
PRINT USING "#.## seconds to retrieve the last string"; t!

'----- Print the entire string array after it was brought back from storage.

PRINT "Press any key to view the array, or Escape to end";
IF INPUT$(1) = CHR$(27) THEN END

PRINT
FOR x = 1 TO numStr
   PRINT x; "{"; array$(x); "}"
   x$ = INKEY$                         ' see if they pressed a key
   IF LEN(x$) THEN                     ' they did
     IF x$ = CHR$(27) THEN END         ' end if Escape
     WHILE INKEY$ = "": WEND           ' otherwise just pause
   END IF
NEXT

'$INCLUDE: 'PRO.BAS'