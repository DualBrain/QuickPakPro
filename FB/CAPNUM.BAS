' ********** CAPNUM.BAS - prints status of Cap and NumLock keys

' Copyright (c) 1987 Ethan Winer
' Modifications (c) 2023 Cory Smith

#INCLUDE "PRO.BI" ' Peek1, QPrint

SUB CapNum STATIC

  Dim capStatus As Short, numStatus As Short, h As Short, v As Short, cap As Short, num As Short

  capStatus = Peek1(0, &H417) AND &H40   ' get BIOS status of Caps Lock
  numStatus = Peek1(0, &H417) AND &H20   ' get BIOS status of Num Lock
  h = POS(0): v = CSRLIN                 ' save cursor position

  IF cap = capStatus GOTO QNumCheck      ' no change since last check

  cap = capStatus                        ' save Caps status
  LOCATE 25, 69                          ' position to print status msg

  IF capStatus THEN                      ' print or erase message
    QPrint " CAP ", 112, -1              ' 112 = black on white
  ELSE
    QPrint SPACE$(5), 7, -1              ' 7 = white on black
  END IF

QNumCheck:
  IF num = numStatus GOTO QCapNumExit    ' no change since last check

  num = numStatus                        ' save Num status
  LOCATE 25, 75                          ' position to print status msg

  IF numStatus THEN                      ' print or erase message
    QPrint " NUM ", 112, -1
  ELSE
    QPrint SPACE$(5), 7, -1
  END IF

QCapNumExit:
  LOCATE v, h                            ' restore cursor position

END SUB