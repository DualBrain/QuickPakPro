' ********** QPSOUND.BAS - demonstrates sounds without using PLAY or SOUND

' Copyright (c) 1989 Ethan Winer
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
_TITLE "QPSOUND" 'NOTE: Moving title above resize causes resize to fail (without an error???)
'BUG: It would be nice specify the icon here, but... having to require full path or placing it in the qb64 folder is problematic. 
'NOTE: The above boiler plate must be first in execution (top of file).
'BUG:  Also appears to not work as an $INCLUDE; suggesting something might
'      be wrong with the implementation of $INCLUDE.
' **************************
' * BOILER PLATE END
' **************************

DEFINT A-Z

'$INCLUDE: 'PRO.BI'

DECLARE SUB Chime (number)
DECLARE SUB Pause (ticks)
DECLARE SUB QPSound (frequency, duration)

CLS

' ---- demo number one - glide tones

Pause 1                         ' this synchronizes QPSound to the system clock
                                ' you would need this only with a duration of 1,
PRINT "Glide tones"             ' and then only if you care that the first
PRINT                           ' sound might be a bit short
FOR s = 50 TO 2000 STEP 50
  QPSound s, 1
  QPSound s * 2, 1
NEXT
Pause 15                        ' wait a bit before the next demo

' ---- demo number two - PLAY via DATA statements for pitch and frequency

PRINT "How much is that thing over there?"
PRINT
READ numNotes
FOR x = 1 TO numNotes
  READ pitch, length
  QPSound pitch, length
NEXT
Pause 15
DATA 10                         : ' number of notes to play
DATA 392, 4, 523, 4, 392, 4     : ' how much you want for that there dog?
DATA 330, 4, 262, 6, 440, 2
DATA 392, 2, 330, 2, 392, 4, 294, 8

' ---- demo number three - PLAY via DATA statements for pitch and frequency

PRINT "Ms. PackMan"
PRINT
READ numNotes
FOR x = 1 TO numNotes
  READ pitch, length
  IF pitch THEN               ' this lets you use a pitch of zero to pause
    QPSound pitch, length
  ELSE
    Pause length
  END IF
NEXT
Pause 15
DATA 23
DATA 262, 2, 294, 2, 330, 2, 262, 2, 294, 4, 349, 4
DATA 330, 2, 349, 2, 392, 2, 330, 2, 294, 4, 349, 4
DATA 330, 2, 349, 2, 392, 2, 330, 2
DATA 349, 2, 392, 2, 440, 2, 494, 2
DATA 523, 4, 494, 4, 523, 4

' ---- demo number four shows the ten sounds produced by Chime

FOR x = 1 TO 10                 ' demo the canned chime sounds
  PRINT "Chime sound number"; x
  Chime x
  Pause 10
NEXT

' The table below shows musical pitches and their corresponding frequencies.
' This lets you construct DATA statements for use with QPSound in a manner
' similar to programming melodies with BASIC's PLAY statement.
'
'               Oct 1   Oct 2   Oct 3   Oct 4   Oct 5   Oct 6   Oct 7
'███████────┐
'         C │     65     131     262     523    1047    2093    4186
'───────────┤
'         B │     62     123     247     494     988    1976    3951
'███████────┤
'         A │     55     110     220     440     880    1760    3520
'███████────┤
'         G │     49      98     196     392     784    1568    3136
'███████────┤
'         F │     44      87     175     349     698    1397    2794
'───────────┤
'         E │     41      82     165     330     659    1319    2637
'███████────┤
'         D │     37      73     147     294     587    1175    2349
'███████────┤
'         C │     33      65     131     262     523    1047    2093
'───────────┤

'$INCLUDE: 'PRO.BAS'