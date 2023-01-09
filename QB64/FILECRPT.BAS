' ******** FILECRPT.BAS - encrypts a file with a password

' Copyright (c) 1988 Ethan Winer
' Modifications (c) 2023 Cory Smith

' IMPORTANT: Do NOT forget your password!

DEFINT A-Z

DECLARE FUNCTION DOSError% ()
DECLARE FUNCTION Exist% (fileName$)
DECLARE FUNCTION FLof& (handle)
DECLARE SUB Encrypt (secret$, passWord$)
DECLARE SUB FClose (handle)
DECLARE SUB FGet (handle, destination$)
DECLARE SUB FOpen (fileName$, handle)
DECLARE SUB FPut (handle, source$)
DECLARE SUB FSeek (handle, offset&)

' ********** FILECRPT.BAS - encrypts and decrypts files using a password
'
' Copyright (c) 1987 Ethan Winer
' Modifications (c) 2023 Cory Smith
'
SUB FileCrypt (fileName$, pWord$) STATIC

  secondKey$ = CHR$(196) + "A2" + CHR$(241) + CHR$(222) + ","

  passWord$ = pWord$                  ' don't actually change the password
  Encrypt passWord$, secondKey$       ' double encrypt the password copy
  l = LEN(passWord$)                  ' remember the length of PassWord$

  FOpen fileName$, handle             ' open the file for QuickPak binary
  IF DOSError% THEN EXIT SUB          ' it's not there or drive door is open

  fileSz& = FLof&(handle)           ' find how long the file is
  bufSize = 4096                    ' 4096 evenly holds four sectors
  IF fileSz& < bufSize THEN         ' but we can't use more than FileSz&
    bufSize = fileSz&               ' so use that instead
  END IF

  bufSize = bufSize - (fileSz& MOD l)       ' LEN(Buffer$) must be an even
                                              '   multiple of LEN(PassWord$)
  IF bufSize = 0 THEN                         ' it's a very small file, use
    bufSize = fileSz&                       '   FileSz& instead
  END IF

  buffer$ = SPACE$(bufSize)             ' create a buffer to hold the file
  done& = 0                             ' Done& tracks how much we've done

  DO
    FGet handle, buffer$                ' get this portion of the file
    Encrypt buffer$, passWord$          ' encrypt it
    FSeek handle, done&                 ' seek back to the start of this block
    FPut handle, buffer$                ' write out the encrypted data
    done& = done& + LEN(buffer$)        ' track what we've already done

    IF fileSz& - done& < LEN(buffer$) THEN  ' less than LEN(Buffer$) remains
      buffer$ = ""                            ' this shouldn't be necessary
      buffer$ = SPACE$(filSiz& - done&)     ' adjust buffer to what remains
    END IF

  LOOP WHILE LEN(buffer$) AND NOT DOSError%   ' loop while there's still more to do
                                              '   and no errors have occurred
  FClose handle                               ' close the file

END SUB                                       ' see ya later, oscillator