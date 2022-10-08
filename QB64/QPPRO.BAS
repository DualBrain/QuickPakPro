' *********** QPPRO.BAS - added value functionality for QB64
'                         inspired by QuickPak Professional 
'                         for QB45/PDS71/VBDOS10

' Copyright (c) 2022 Cory Smith

' ****************************************
' Chapter 2 - Array Routines 
' ****************************************

SUB AddInt(Array%(), Start%, Value%, NumEls%)
  ' See ADDINT.ASM
END SUB

SUB DeleteStr(Array$(), Element%, NumEls%)
END SUB

SUB DeleteT(Array(), Element%, ElSize%, NumEls%)
END SUB

SUB DimBits(Array$, NumEls%)
END SUB

SUB Fill2(Array%(), Start%, Value%, NumEls%)
END SUB

SUB Fill4(Array!(), Start%, Value!, NumEls%)
END SUB

SUB Fill8(Array#(), Start%, Value#, NumEls%)
END SUB

SUB Find(Array$, Start%, NumEls%, SearchValue$)
END SUB

SUB Find2(Array$, Start%, NumEls%, SearchValue$)
END SUB

SUB FindB(Array$(), CurEl%, SearchValue$)
END SUB

SUB FindB2(Array$(), CurEl%, SearchValue$)
END SUB

SUB FindExact(Array$(), Start%, NumEls%, SearchValue$)
END SUB

SUB FindT(Array$(), Start%, ElSize%, NumEls%, SearchValue$)
END SUB

SUB FindT2(Array$(), Start%, ElSize%, NumEls%, SearchValue$)
END SUB

SUB FindTB(Array$(), Start%, ElSize%, CurEl%, SearchValue$)
END SUB

SUB FindTB2(Array$(), Start%, ElSize%, CurEl%, SearchValue$)
END SUB

' FindLast scans a conventional (not fixed-length) string array 
' backwards looking for the last non-blank element. 
FUNCTION FindLast% (Array$(), Size%)
  NumEls% = Size% 'UBOUND(Array$)
  FOR el = NumEls% TO LBOUND(Array$)
    IF Array$(el) <> "" THEN
      FindLast% = el
      EXIT FUNCTION
    END IF
  NEXT
  FineLast% = NumEls%
END FUNCTION

FUNCTION GetBit%(Array$, Element%)
END FUNCTION

FUNCTION IMaxD%(Array#(), Start%, NumEls%)
END FUNCTION

FUNCTION IMaxI%(Array%(), Start%, NumEls%)
END FUNCTION

FUNCTION IMaxL%(Array&(), Start%, NumEls%)
END FUNCTION

FUNCTION IMaxS%(Array!(), Start%, NumEls%)
END FUNCTION

FUNCTION IMaxC%(Array(), Start%, NumEls%)
END FUNCTION

FUNCTION IMinD%(Array#(), Start%, NumEls%)
END FUNCTION

FUNCTION IMinI%(Array%(), Start%, NumEls%)
END FUNCTION

FUNCTION IMinL%(Array&(), Start%, NumEls%)
END FUNCTION

FUNCTION IMinS%(Array!(), Start%, NumEls%)
END FUNCTION

FUNCTION IMinC%(Array(), Start%, NumEls%)
END FUNCTION

SUB InitInt(Array%(), Start%, Value%, NumEls%)
END SUB

SUB InsertStr(Array$(), Element%, Ins$, NumEls%)
END SUB

SUB InsertT(Array(), Element%, ElSize%, NumEls%)
END SUB

SUB ISortD(Array#(), Start%, Ndx%(), NumEls%, Dir%)
END SUB

SUB ISortI(Array%(), Start%, Ndx%(), NumEls%, Dir%)
END SUB

SUB ISortL(Array&(), Start%, Ndx%(), NumEls%, Dir%)
END SUB

SUB ISortS(Array!(), Start%, Ndx%(), NumEls%, Dir%)
END SUB

SUB ISortC(Array(), Start%, Ndx%(), NumEls%, Dir%)
END SUB

SUB ISortStr(Array$(), Start%, Ndx%(), NumEls%, Dir%)
END SUB

SUB ISortStr2(Array$(), Start%, Ndx%(), NumEls%, Dir%)
END SUB

SUB ISortStrT(Array$(), Start%, Ndx%(), NumEls%, Dir%, ElSize%, MemberOffset%, MemberSize%)
END SUB

SUB ISortStrT2(Array(), Start%, Ndx%(), NumEls%, Dir%, ElSize%, MemberOffset%, MemberSize%)
END SUB

SUB KeySort(Array(), Start%, ElSize%, NumEls%, Table%(,), NumKey%)
END SUB

FUNCTION MaxD#(Array#(), Start%, NumEls%)
END FUNCTION

FUNCTION MaxI&(Array%(), Start%, NumEls%)
END FUNCTION

FUNCTION MaxL&(Array&(), Start%, NumEls%)
END FUNCTION

FUNCTION MaxS!(Array!(), Start%, NumEls%)
END FUNCTION

FUNCTION MaxC(Array(), Start%, NumEls%)
END FUNCTION

FUNCTION MinD#(Array#(), Start%, NumEls%)
END FUNCTION

FUNCTION MinI&(Array%(), Start%, NumEls%)
END FUNCTION

FUNCTION MinL&(Array&(), Start%, NumEls%)
END FUNCTION

FUNCTION MinS!(Array!(), Start%, NumEls%)
END FUNCTION

FUNCTION MinC(Array(), Start%, NumEls%)
END FUNCTION

SUB Search(Array(), Start%, NumEls%, Match, Found%, Direction%, MatchCode%, VarType%)
END SUB

SUB SearchT(Array(), Start%, NumEls%, Match, Found%, Dir%, Code%, StructSize%, MemberOf%, MemberSize%)
END SUB

SUB SearchT2(Array(), Start%, NumEls%, Match, Found%, Dir%, Code%, StructSize%, MemberOf%, MemberSize%)
END SUB

SUB SetBit(Array$, Element%, Bit%)
END SUB

SUB SortD(Array#(), Start%, NumEls%, Dir%)
END SUB

SUB SortI(Array%(), Start%, NumEls%, Dir%)
END SUB

SUB SortL(Array&(), Start%, NumEls%, Dir%)
END SUB

SUB SortS(Array!(), Start%, NumEls%, Dir%)
END SUB

SUB SortC(Array(), Start%, NumEls%, Dir%)
END SUB

SUB SortStr(Array$(), Start%, NumEls%, Dir%)
END SUB

SUB SortStr2(Array$(), Start%, NumEls%, Dir%)
END SUB

SUB SortStrT(Array$, Start%, NumEls%, Dir%, MemberOffset%, MemberSize%)
END SUB

SUB SortStrT2(Array$, Start%, NumEls%, Dir%, MemberOffset%, MemberSize%)
END SUB

' ****************************************
' Chapter 3 - DOS Services
' ****************************************

SUB CDir(NewDir$)
  CHDIR NewDir$
END SUB

SUB ClipFile(FileName$, NewLength&)
END SUB

FUNCTION DCount%(DirSpec$)
END FUNCTION

SUB DiskInfo(Drive$, Byte%, Sectors%, FreeClusters&, TotalClusters&)
END SUB

FUNCTION DiskRoom&(Drive$)
END FUNCTION

FUNCTION DiskSize&(Drive$)
END FUNCTION

FUNCTION DosError%
  'TODO: 
  DosError% = 0 ' No error.
END FUNCTION

FUNCTION DOSVer%
  DOSVer% = 611 ' Fixed as DOS 6.11
END FUNCTION

FUNCTION ErrorMsg$(ErrorNumber%)
END FUNCTION

FUNCTION ExeName$
END FUNCTION

FUNCTION Exist%(FileName$)
  Exist% = _FileExists(FileName$)
END FUNCTION

FUNCTION FastLoadInt%(FileName$)
END FUNCTION

SUB FastLoadStr(Array$())
END SUB

SUB FastSave(FileName$, Text$())
END SUB

SUB FClose(Handle%)
  CLOSE #Handle%
END SUB

SUB FCopy(Source$, Dest$, Buffer$, ErrCode%)
END SUB

FUNCTION FCount%(FileSpec$)
END FUNCTION

SUB FCreate(FileName$)
  ff = FREEFILE
  OPEN FileName$ FOR OUTPUT AS #ff
  CLOSE #ff
END SUB

FUNCTION FEof%(Handle%)
  FEof% = EOF(Handle%)
END FUNCTION

SUB FFlush(Handle%)
END SUB

SUB FGet(Handle%, Destination$)
END SUB

SUB FGetA(Handle%, Array(), Element%, NumBytes%)
END SUB

SUB FGetFH(FileName$, Array(), Start%, ElSize%, NumEls%)
END SUB

SUB FGetR(Handle%, Destination$, RecNumber&)
END SUB

SUB FGetRT(Handle%, Destination, RecNumber&, RecSize%)
END SUB

SUB FGetRTA(Handle%, Destination, RecNumber&, RecSize%)
END SUB

SUB FGetT(Handle%, Destination, NumBytes%)
END SUB

FUNCTION FileComp%(File1$, File2$, ErrCode%)
END FUNCTION

SUB FileCopy(Source$, Dest$, Copied%, ErrCode%)
END SUB

SUB FileCrypt(FileName$, PassWord$)
END SUB

SUB FileInfo(FileName$, TypeVar)
END SUB

FUNCTION FileSize&(FileName$)
END FUNCTION

SUB FileSort(DataFile$, IndexFile$, First&, Last&, Table%(), RecLength%)
END SUB

FUNCTION FLInput$(Handle%, Buffer$)
END FUNCTION

FUNCTION FLoc&(Handle%)
  FLoc& = LOC(Handle%)
END FUNCTION

FUNCTION FLof&(Handle%)
  FLof& = LOF(Handle%)
END FUNCTION

SUB FOpen(FileName$, Handle%)
END SUB

SUB FOpenS(FileName$, Handle%)
END SUB

SUB FOpenAll(FileName$, AccessMode%, ShareMode%, Handle%)
END SUB

FUNCTION FormatDiskette%(DriveNumber%, Capacity%, BufArray%)
END FUNCTION

SUB FPut(Handle%, Source$)
END SUB

SUB FPutA(Handle%, Array(), Start%, NumBytes%)
END SUB

SUB FPutAH(Handle%, Array(), ElSize%, NumEls%)
END SUB

SUB FPutR(Handle%, Source$, RecNumber&)
END SUB

SUB FPutRT(Handle%, Source, RecNumber&, RecSize%)
END SUB

SUB FPutRTA(Handle%, Source, RecNumber&, RecSize%)
END SUB

SUB FPutT(Handle%, Source, NumBytes%)
END SUB

SUB FSeek(Handle%, Location&)
END SUB

SUB FStamp(FileName$, NewTime$, NewDate$)
END SUB

FUNCTION FullName$(PartName$)
END FUNCTION

FUNCTION GetAttr%(FileName$)
END FUNCTION

FUNCTION GetDir$(Drive$)
END FUNCTION

FUNCTION GetDisketteType%(DriveNumber%)
END FUNCTION

FUNCTION GetDrive%
END FUNCTION

FUNCTION GetVol$(Drive$)
END FUNCTION

FUNCTION GoodDrive%(Drive$)
END FUNCTION

SUB Handle2Name(Handle%, FilName)
END SUB

SUB KillDir(DirName$)
  RMDIR DirName$
END SUB

SUB KillFile(FileName$)
  KILL FileName$
END SUB

FUNCTION LastDrive%
END FUNCTION

FUNCTION LineCount%(FileName$, Buffer$)
END FUNCTION

FUNCTION LoadExec%(Program$, CmdLine$)
END FUNCTION

SUB LockFile(Handle%, Offset&, Length&)
END SUB

SUB MakeDir(DirName$)
  MKDIR DirName$
END SUB

SUB NameDir(OldName$, NewName$)
  NAME OldName$ AS NewName$
END SUB

SUB NameFile(OldName$, NewName$)
  NAME OldName$ AS NewName$
END SUB

FUNCTION NetDrive%(Drive$)
END FUNCTION

SUB PutVol(Drive$, Label$)
END SUB

SUB QBLoad(FileName$, Array%(), Element%)
  'DEF SEG = VARSEG(Array(0))
    BLOAD FileName$, VARPTR(Array(LBOUND(Array)))
  'END SEG
END SUB

SUB QBSave(FileName$, Array%(), Element%, NumBytes%)
END SUB

SUB ReadDir(Array$())
END SUB

SUB ReadDirT(Spec$, Array())
END SUB

SUB ReadFile(Array$())
END SUB

SUB ReadFileI(Array$())
END SUB

SUB ReadFileT(Spec$, Array())
END SUB

SUB ReadFileX(Spec$, DirSize&, Array())
END SUB

SUB ReadSect(Drive$, Info$, Sector%)
END SUB

FUNCTION ReadTest%(Drive$)
END FUNCTION

FUNCTION Removable%(Drive$)
END FUNCTION

FUNCTION ScanFile&(FileName$, Text$, Start&)
END FUNCTION

FUNCTION SearchPath$(FileName$)
END FUNCTION

SUB SetAttr(FileName$, Attribute%)
END SUB

SUB SetCmd(NewCommand$)
END SUB

SUB SetDrive(Drive$)
END SUB

SUB SetError(ErrNum%)
END SUB

SUB SetLevel(ErrValue%)
END SUB

FUNCTION ShareThere%
END FUNCTION

SUB SplitName(WorkName$, Drive$, Path$, FileName$, Extension$)
END SUB

FUNCTION Unique$(Path$)
END FUNCTION

SUB UnLockFile(Handle%, Offset&, Length&)
END SUB

FUNCTION Valid%(FileName$)
END FUNCTION

FUNCTION WhichError%
END FUNCTION

SUB WriteSect(Drive$, Info$, Sector%)
END SUB

SUB WriteSect2(Drive$, Info$, Sector%)
END SUB

FUNCTION WriteTest%(Drive$)
END FUNCTION

' ****************************************
' Chapter 4 - Functions
' ****************************************

FUNCTION Bit2Num%(Binary$)
END FUNCTION

FUNCTION C2F!(CTemp!)
END FUNCTION

FUNCTION Delimit%(Work$, Table$)
END FUNCTION

FUNCTION Eval#(Number$)
END FUNCTION

FUNCTION ExpandTab$(Original$, NumSpaces%)
END FUNCTION

FUNCTION F2C!(FTemp!)
END FUNCTION

FUNCTION LastFirst$(OldName$)
END FUNCTION

FUNCTION LastLast$(OldName$)
END FUNCTION

FUNCTION Num2Bin$(Number%)
END FUNCTION

FUNCTION Num2Bin2(Number%)
END FUNCTION

FUNCTION Pad$(Number!, Digits%)
END FUNCTION

SUB Parse(Work$, Delim$, Array$())
END SUB

FUNCTION ParseStr$(List$)
END FUNCTION

FUNCTION QPHex$(Value, NumDigits%)
END FUNCTION

FUNCTION Rand!(ValLower!, ValUpper!)
END FUNCTION

FUNCTION ShrinkTab$(Original$, NumSpaces%)
END FUNCTION

FUNCTION Signed%(US&)
END FUNCTION

FUNCTION UnParseStr$(Code$)
END FUNCTION

FUNCTION UnSigned&(S%)
END FUNCTION

FUNCTION QPACOS#(X#)
END FUNCTION

FUNCTION QPASIN#(X#)
END FUNCTION

FUNCTION QPATAN2#(X#, Y#)
END FUNCTION

FUNCTION QPLOG10#(X#)
END FUNCTION

FUNCTION QPROUND$(Number#, Places%)
END FUNCTION

FUNCTION QPFV#(pmt#, intr#, term%)
END FUNCTION

FUNCTION QPFVN#(fv#, pmt#, intr#)
END FUNCTION

FUNCTION QPFVP#(fv#, intr#, term%)
END FUNCTION

FUNCTION QPFVD#(pmt#, intr#, term%)
END FUNCTION

FUNCTION QPFVND#(fv#, pmt#, intr#)
END FUNCTION

FUNCTION QPFVPD#(fv#, intr#, term#)
END FUNCTION

FUNCTION QPPMT#(pv#, intr#, term%, bal#)
END FUNCTION

FUNCTION QPPV#(pmt#, intr#, term%, bal#)
END FUNCTION

FUNCTION QPPVN#(pmt#, intr#, pv#, bal#)
END FUNCTION

FUNCTION QPPMTD#(pv#, intr#, term%, bal#)
END FUNCTION

FUNCTION QPPVD#(pmt#, intr#, term%, bal#)
END FUNCTION

FUNCTION QPPVND#(pmt#, intr#, pv#, bal#)
END FUNCTION

FUNCTION QPCINT#(pv#, intr#, term%)
END FUNCTION

FUNCTION QPCTERM#(pv#, fv#, intr#)
END FUNCTION

FUNCTION QPIRR#(intr#, Array#())
END FUNCTION

FUNCTION QPNPV#(intr#, Array#())
END FUNCTION

FUNCTION QPRATE#(pv#, fv#, term%)
END FUNCTION

FUNCTION QPDDB#(cost#, sal#, life%, per%, m!)
END FUNCTION

FUNCTION QPSLN#(cost#, sal#, life%)
END FUNCTION

FUNCTION QPSYD#(cost#, sal#, life%, per%)
END FUNCTION

FUNCTION QPAVG#(Array#())
END FUNCTION

FUNCTION QPCOUNT%(Array#())
END FUNCTION

FUNCTION QPMAX#(Array#())
END FUNCTION

FUNCTION QPMIN#(Array#())
END FUNCTION

FUNCTION QPSUM#(Array#())
END FUNCTION

FUNCTION QPVAR#(Array#()) 
END FUNCTION

FUNCTION QPSTD#(Array#())
END FUNCTION

' ****************************************
' Chapter 5 - Menu/Input Routines
' ****************************************

SUB AMenu(Array$(), Start%, StartItem%, Count%, ScanCode%, NormColor%, HiLiteColor%, NumRows%, NumCols%, Gap%, ULRow%, ULCol%)
END SUB

SUB AMenuT(Array(), Start%, StartItem%, Length%, Count%, ScanCode%, NormColor%, HiLiteColor%, NumRows%, NumCols%, Gap%, ULRow%, ULCol%)
END SUB

SUB ASCIIPick(Char%, Color1%, Color2%, ExitCode%)
END SUB

SUB MASCIIPick(Char%, Color1%, Color2%, ExitCode%)
END SUB

SUB ColorPick(Colr%, BoxColor%, ExitCode%)
END SUB

SUB MColorPick(Colr%, BoxColor%, ExitCode%)
END SUB

SUB DateIn(D$, ExitCode%, Colr%)
END SUB

SUB DirFile(Array$(), Count%, ScanCode%, MsgColor%, FileColor%, HiLiteColor%, BoxColor%)
END SUB

SUB Editor(Ed$, ActiveLength%, ScanCode%, NumOnly%, IsCapsOn%, NormalColor%, EditColor%, Row%, Column%)
END SUB

SUB Lts2Menu(Item$(), Prompt$(), Choice%, Colr%)
END SUB

SUB LtsMenu(Item$(), Choice%, Colr%)
END SUB

' MAMenu is a full-featured multi-column menu routine, which 
' allows selecting items either with the keyboard or a mouse. This is 
' a mouse-aware version of the original AMenu routine, which is 
' described elsewhere.
'SUB MAMenu (Address%, Selection%, Start%, Count%, ExitCode%, FileColr%, HiLiteColr%, Rows%, Columns%, Spacing%, Row%, Column%)
SUB MAMenu(Array$(), Selection%, Start%, Count%, ScanCode%, NormalColor%, Hilight%, NumRows%, NumCols%, Gap%, Row%, Column%)
END SUB

SUB MAMenuT(Array$(), Selection%, Start%, Length%, Count%, ScanCode%, NormalColor%, Hilight%, NumRows%, NumCols%, Gap%, Row%, Column%)
END SUB

SUB MaskIn(Mask$, Text$, Mski)
END SUB

SUB MEditor(Ed$, ActiveLength%, ScanCode%, NumOnly%, IsCapsOn%, NormalColor%, EditColor%, Row%, Column%, CurrentColumn%)
END SUB

SUB MenuVert(Array$(), NumLines%, ScanCode%, Choice%, NormalColr%, HiLiteColor%, Row%, Column%)
END SUB

FUNCTION MGetKey%(Row%, Col%)
END FUNCTION

SUB MMenuVert(Array$(), Selection%, Start%, ScanCode%, NormalColr%, Hilight%, NumRows%, Row%, Column%)
END SUB

SUB NumIn(Number#, Max%, Places%, ExitCode%, Colr%)
END SUB

SUB PickList(Item$(), Picked%(), NPicked%, Cnf)
END SUB

SUB PullDnMS(Choice$(), Stat%(), Menu%, Choice%, Ky$, Action%)
END SUB

SUB QEdit(Array$(), Ky$, Action%, Ed)
END SUB

SUB ScrollIn(Edit$, Start%, Wide%, MaxLen%, Filter%, Ky%, EdClr%, NormalClr%)
END SUB

SUB Spread(Wks$(), Format$(), ColumnWidths%(), Wide%, Rows%, Action%)
END SUB

SUB TextIn(Text$, Max%, NumOnly%, IsCapsOn%, ExitCode%, Colr%)
END SUB

SUB VertMenu(Item$(), Choice%, MaxLen%, BoxBot%, Ky$, Action%, Cnf)
END SUB

SUB YesNo(YN$, Prompt$, ScanCode%, NormalColor%, EditColor%, Row%, Column%)
END SUB

SUB YesNoB(YN$, ExitCode%, Colr%)
END SUB

' ****************************************
' Chapter 6 - Keyboard / Mouse Routines
' ****************************************

FUNCTION AltKey%
  ' See ALTKEY.ASM
  LALT& = 100308
  RALT& = 100307
  AltKey% = _KEYDOWN(LALT&) OR _KEYDOWN(RALT&)
END FUNCTION

' ButtonPress will report how many times a specified mouse button 
' was pressed since the last time it was called. It also returns the X/Y 
' coordinates where the mouse cursor was located when that button 
' was last pressed. 
SUB ButtonPress (button%, status%, count%, x%, y%)

  ' button% is the button of interest, with a 1 indicating button 1,  
  ' 2 meaning button 2, and 3 for button 3 (if the mouse has a third button). 

  ' status% is the current button status, and has the same meaning as 
  ' the information returned by the GetCursor mouse routine. 

    button1% = _MOUSEBUTTON(1)
    button2% = _MOUSEBUTTON(2)
    button3% = _MOUSEBUTTON(3)
    status% = 0
    IF button% = 1 AND button1% THEN status% = 1
    IF button% = 2 AND button2% THEN status% = status% + 2
    IF button% = 3 AND button3% THEN status% = status% + 4

  ' Count% tells how many times the button has been pressed since 
  ' ButtonPress was last called. X% and Y% hold the mouse cursor 
  ' position at the time the button was pressed. Use the GetCursor 
  ' routine to determine the current mouse cursor location. 

  IF _MOUSEINPUT THEN 
    ' WHILE _MOUSEBUTTON(button%)
    '   IF button% = 1 THEN count1% = count1% + 1
    '   IF button% = 2 THEN count2% = count2% + 1
    '   IF button% = 3 THEN count3% = count3% + 1
    ' WEND
    IF _MOUSEBUTTON(button%) THEN
      IF button% = 1 THEN count1% = count1% + 1
      IF button% = 2 THEN count2% = count2% + 1
      IF button% = 3 THEN count3% = count3% + 1
    END IF
    col% = _MOUSEX
    row% = _MOUSEY
    x% = (col% - 1) * 8
    y% = (row% - 1) * 8
    lastX% = x%
    lastY% = y%
  ELSE
    x% = lastX%
    y% = lastY%
  END IF
  
  IF button% = 1 THEN count% = count1%: count1% = 0
  IF button% = 2 THEN count% = count2%: count2% = 0
  IF button% = 3 THEN count% = count3%: count3% = 0

END SUB

FUNCTION CapsLock
END FUNCTION

SUB CapsOff
ENd SUB

SUB CapsOn
END SUB

SUB ClearBuf
END SUB

FUNCTION CtrlKey%
END FUNCTION

' GetCursor reports the current location of the mouse cursor, and 
' which mouse buttons are currently depressed. 
SUB GetCursor (x%, y%, button%) STATIC
  ' x% and y% return holding the current mouse cursor coordinates, 
  ' and button% is bit coded to indicate which buttons are currently 
  ' down. 
  IF _MOUSEINPUT THEN
    col% = _MOUSEX
    row% = _MOUSEY
    x% = (col% - 1) * 8
    y% = (row% - 1) * 8
    button1% = _MOUSEBUTTON(1)
    button2% = _MOUSEBUTTON(2)
    button3% = _MOUSEBUTTON(3)
    button% = 0
    IF button1% THEN button% = 1
    IF button2% THEN button% = button% + 2
    IF button3% THEN button% = button% + 4
    lastX% = x%
    lastY% = y%
    lastButton% = button%
  ELSE
    x% = lastX%
    y% = lastY%
    button% = lastButton%
  END IF
END SUB

SUB GetCursorT(Col%, Row%, Button%)
END SUB

SUB GrafCursor(X%, Y%, Cursor%)
END SUB

SUB HideCursor
  _MOUSEHIDE
END SUB

' InitMouse is used both to determine if a mouse is present in the host 
' PC, and to reset the mouse driver software to its default values. 
SUB InitMouse(there%)
  ' there% receives -1 if a mouse is present, or O if no mouse is installed. 
  there% = -1 ' we are working on modern platforms, of course there is a mouse.
END SUB

FUNCTION InStat%
END FUNCTION

SUB Keyboard(Row%, Column%, Color1%, Color2%, Mode%)
END SUB

FUNCTION KeyDown%
END FUNCTION

SUB Motion(Value%)
END SUB

SUB Mouse(AX%, BX%, CX%, DX%)
END SUB

SUB MouseRange(Array(), NumEls%, Row%, Col%, Button%, RangeNum%)
END SUB

FUNCTION MBuffSize%
END FUNCTION

SUB MGetState(Buffer$)
END SUB

SUB MSetState(Buffer$)
END SUB

' MouseTrap will establish the allowable range of movement for the mouse cursor. 
SUB MouseTrap(ulRow%, ulCol%, lrRow%, lrCol%)
END SUB

FUNCTION NumLock%
END FUNCTION

SUB NumOff
END SUB

SUB NumOn
END SUB

FUNCTION PeekBuf%
END FUNCTION

SUB RptKey(Char%, Count%)
END SUB

FUNCTION ScrlLock%
END FUNCTION

SUB SetCursor(X%, Y%)
END SUB

FUNCTION ShiftKey%
END FUNCTION

SUB ShowCursor
  _MOUSESHOW
END SUB

SUB StuffBuf(X$)
END SUB

SUB TextCursor(FG%, BG%)
END SUB

' FUNCTION WaitKey%
'   WHILE INKEY$ <> "": WEND ' Clear any pending key strokes.
'   WHILE INKEY$ = "": WEND ' Wait for a key.
'   ' TODO: Return the key value.
' END FUNCTION

' WaitKey first clears the keyboard buffer of any keys that may be 
' pending, and then waits until a key is pressed. 
SUB WaitKey
  WHILE INKEY$ <> "": WEND ' Clear any pending key strokes.
  WHILE INKEY$ = "": WEND ' Wait for a key.
END SUB

FUNCTION WaitScan%
END FUNCTION

SUB WaitUp
  DO
    Call GetCursor(X%, Y%, Button%)
  LOOP WHILE Button%
END SUB

' **************************************
' Chapter 7 - Miscellaneous Routines
' **************************************

FUNCTION AddUSI%(X%, Y%)
  ' See ADDUSI.ASM
END FUNCTION

SUB ASCIIChart(ULRow%, ULCol%, Height%)
END SUB

SUB BCopy(FromSeg%, FromAddr%, ToSeg%, ToAddr%, NumBytes%, Direction%)
END SUB

SUB BCopyT(FromEl, ToEl, ElSize%, NumEls%)
END SUB

SUB BLPrint(LPTNumber%, X$, ErrorCount%)
END SUB

SUB Calc(ULRow%, ULCol%, FG%, BG%)
END SUB

SUB Calendar(Month%, Day%, Year%, ULRow%, ULCol%, Color1%, Color2%, Action%)
END SUB

SUB Chime(Number%)
END SUB

SUB Clock(Row%, Column%, Colr%, Mode%)
END SUB

SUB Clock24(Row%, Column%, Colr%, Mode%)
END SUB

FUNCTION Compare%(Seg1%, Adr1%, Seg2%, Adr2%, NumBytes%)
END FUNCTION

FUNCTION CompareT%(Type1, Type2, NumBytes%)
END FUNCTION

FUNCTION Date2Day%(D$)
END FUNCTION

FUNCTION Date2Num%(D$)
END FUNCTION

FUNCTION DayName$(Day%)
END FUNCTION

SUB DirTree(Tree$(), FullPath$(), Levels%)
END SUB

FUNCTION EDate2Num%(Dat$)
END FUNCTION

SUB Empty(dummy%)
END SUB

FUNCTION ENum2Date%(Days%)
END FUNCTION

FUNCTION Evaluate#(Expression$)
END FUNCTION

SUB Extended
END SUB

FUNCTION Factorial#(Number%)
END FUNCTION

SUB FileView(FileName$, Ky%, Action%, FVInfo, Buffer%())
END SUB

FUNCTION FudgeFactor&
  'TODO: 
  FudgeFactor& = 33814
END FUNCTION

FUNCTION GetCPU%
END FUNCTION

FUNCTION GetDS%
END FUNCTION

SUB GetEquip(Floppies%, Parallels%, Serials%)
END SUB

SUB LockUp
  DO:LOOP
END SUB

SUB Marquee(X$, Row%, Colr%)
END SUB

FUNCTION MathChip%
END FUNCTION

' MaxInt compares two integer variables, and returns the value of the 
' higher one. MaxLong is similar, but is intended for use with long 
' integers. 
FUNCTION MaxInt% (Num1%, Num2%)
  IF Num1% > Num2% THEN 
    MaxInt% = Num1% 
  ELSE 
    MaxInt% = Num2% 
  END IF 
END FUNCTION

FUNCTION MaxLong& (Num1&, Num2&)
  IF Num1& > Num2& THEN 
    MaxLong& = Num1& 
  ELSE 
    MaxLong& = Num2& 
  END IF 
END FUNCTION

' MinInt compares two integer variables, and returns the value of the 
' smaller one. MinLong is similar, but is intended for use with long 
' integers. 
FUNCTION MinInt% (Num1%, Num2%)
  IF Num1% < Num2% THEN 
    MinInt% = Num1% 
  ELSE 
    MinInt% = Num2% 
  END IF 
END FUNCTION

FUNCTION MinLong& (Num1&, Num2&)
  IF Num1% < Num2& THEN 
    MinLong& = Num1& 
  ELSE 
    MinLong& = Num2& 
  END IF 
END FUNCTION

FUNCTION MonthName$(Month%)
END FUNCTION

SUB MsgBox(Message$, Wide%, Cfn)
END SUB

FUNCTION Num2Date$(Day%)
END FUNCTION

FUNCTION Num2Day%(D%)
END FUNCTION

FUNCTION Num2Time$(Time&)
END FUNCTION

SUB Pause(Ticks%)
END SUB

SUB Pause2(Microseconds%)
END SUB

' Pause3 provides a simple method for obtaining delays with a 
' resolution of 1 millisecond, without having to reprogram the PC's 
' timer chips. 
SUB Pause3 (MillaSec%, Fudg&)
  ' MilliSeconds % is the desired number of milliseconds to delay, and 
  ' Fudge& was previously obtained using the QuickPak Professional 
  ' FudgeFactor function. 
  _DELAY MillaSec% / 1000
END SUB

FUNCTION PDQTimer&
END FUNCTION

FUNCTION Peek1%(segment%, address%)
  SELECT CASE segment%
    CASE 0
      SELECT CASE address%
        CASE &H463 ' Color Monitor?
          ' IF Peek1%(0, &H463) <> &HB4 THEN ColorMon = 1   ' see what monitor is active
        CASE &H417 ' Capslock and Numlock status?
          result% = 0
          IF _CAPSLOCK THEN result% = result% + &H40
          IF _NUMLOCK THEN result% = result% + &H20
          Peek1% = result%
          ' CapStatus = Peek1%(0, &H417) AND &H40        'get BIOS status of Caps Lock
          ' NumStatus = Peek1%(0, &H417) AND &H20        'get BIOS status of Num Lock
          ' &H40 Capslock Active
          ' &H20 Numlock Active
        CASE ELSE
      END SELECT
    CASE ELSE
  END SELECT
END FUNCTION

FUNCTION Peek2%(Segment%, Address%)
END FUNCTION

SUB Poke1(Segment%, Address%, Byte%)
END SUB

SUB Poke2(Segment%, Address%, Word%)
END SUB

FUNCTION Power(Y, N)
  Power = x ^ N
END FUNCTION

FUNCTION Power2(N)
  Power2 = 2 ^ N
END FUNCTION

FUNCTION PRNReady%(LPTNumber%)
END FUNCTION

SUB PSwap
END SUB

SUB QPCli
END SUB

SUB QPSti
END SUB

SUB QPPlay(Tune$)
END SUB

SUB QPSound(Frequency%, Duration%)
  SOUND Frequency%, Duration%
END SUB

FUNCTION QPSegAdr&(Any$)
END FUNCTION

FUNCTION QPSSeg%(Any$)
END FUNCTION

FUNCTION QPUSI%(LongInt&)
END FUNCTION

SUB Reboot
END SUB

SUB ShiftIL(IntVar%, NumBits%)
END SUB

SUB ShiftIR(IntVar%, NumBits%)
END SUB

SUB ShiftLL(IntVar&, NumBits%)
END SUB

SUB ShiftLR(IntVar&, NumBits%)
END SUB

FUNCTION Soundex$(Word$)
END FUNCTION

SUB SysTime(T$)
END SUB

FUNCTION Time2Num&(T$)
END FUNCTION

FUNCTION Times2%(Number%)
END FUNCTION

FUNCTION TrapInt%(Value%, LoLimit%, HiLimit%)
END FUNCTION

SUB ViewFile(FileName$, Wide%, High%, Colr%, HiBit%, Action%)
END SUB

SUB VLAdd(Value1#, Value2#, Sum#, ErrFlag%)
ENd SUB

SUB VLDiv(Dividend#, Divisor#, Quotient#, Remainder#, ErrFlag%)
END SUB

SUB VLMul(Value1#, Value2#, Product#, ErrFlag%)
END SUB

SUB VLPack(Number$, Value#, ErrFlag%)
END SUB

SUB VLSub(Value1#, Value2#, Difference#, ErrFlag%)
END SUB

SUB VLUnpack(Alias#, Number$, ErrFlag%)
END SUB

FUNCTION WeekDay%(D$)
END FUNCTION

SUB WordWrap(Message$, Wide%)
END SUB

' ****************************************
' Chapter 8 - String Manipulation Routines
' ****************************************

' ASCII obtains the ASCII value for a string exactly as BASIC's ASC 
' function does, but it will not cause an "Illegal Function Call" error 
' if the string is null. 
FUNCTION ASCII% (Char$)
  ' See ASCII.ASM
  ASCII% = ASC(Char$)
END SUB

FUNCTION Blanks%(Work$)
END FUNCTION

FUNCTION Compact$(Old$)
END FUNCTION

SUB Encrypt(X$, PassWord$)
END SUB

SUB Encrypt2(X$, PassWord$)
END SUB

FUNCTION Far2Str$(Segment%, Address%)
END FUNCTION

FUNCTION FUsing$(Number$, Image$)
END FUNCTION

FUNCTION InCount%(Source$, SearchValue$)
END FUNCTION

FUNCTION InCount2%(Source$, SearchValue$)
END FUNCTION

FUNCTION InCountTbl%(Source$, Table$)
END FUNCTION

FUNCTION InstrTbl%(Start%, Source$, Table$)
END FUNCTION

FUNCTION InstrTbl2%(Start%, Source$, Table$)
END FUNCTION

FUNCTION InstrTblB%(Start%, Source$, Table$)
END FUNCTION

FUNCTION InstrTblB2%(Start%, Source$, Table$)
END FUNCTION

FUNCTION LongestStr%(Array$())
END FUNCTION

SUB LowASCII(X$)
END SUB

SUB Lower(value$)
  value$ = LCASE$(value$)
END SUB

SUB LowerTbl(Work$, Table$)
END SUB

FUNCTION MidChar%(Work$, Position%)
END SUB

SUB MidCharS(Work$, Postion%, Char%)
END SUB

FUNCTION NotInstr%(Start%, Searched$, Table$)
END FUNCTION

FUNCTION Null%(Work$)
END FUNCTION

FUNCTION ParseString$(CurPos%, Work$, DelimitValue$)
END FUNCTION

SUB ProperName(Work$)
END SUB

' QInstr serves the same purpose as BASIC's INSTR function, 
' except it accepts any number of "?" wild cards.
FUNCTION QInstr%(startPosition%, sourceValue$, searchValue$)
  IF startPosition% = 0 THEN QInstr% = 0: EXIT FUNCTION
  QInstr% = INSTR(startPosition%, sourceValue$, searchValue$)
END FUNCTION

' QInstr2 serves the same purpose as BASIC's INSTR function, except 
' it accepts any number of "?" wild cards and it ignores capitalization 
' when examining the strings.
FUNCTION QInstr2%(startPosition%, sourceValue$, searchValue$)
  IF startPosition% = 0 THEN QInstr2% = 0: EXIT FUNCTION
  sourceLowered$ = sourceValue$: Lower(sourceLowered$)
  searchLowered$ = searchValue$: Lower(searchLowered$)
  QInstr2% = INSTR(startPosition%, sourceLowered$, searchLowered$)
END FUNCTION

FUNCTION QInstrB%(StartPos%, Source$, SearchValue$)
END FUNCTION

FUNCTION QInstrB2%(StartPos%, Source$, SearchValue$)
END FUNCTION

SUB QInstrH(Segment%, Address%, SearchValue$, NumBytes&)
END SUB

FUNCTION QPLeft$(text$, numChars%)
  QPLeft$ = LEFT$(text$, numChars%)
END FUNCTION

FUNCTION QPMid$(text$, startChar%, numChars%)
  QPMid$ = MID$(text$, startChar%, numChars%)
END FUNCTION

FUNCTION QPRight$(text$, numChars%)
  QPRight$ = RIGHT$(text$, numChars%)
END FUNCTION

' QPLen serves the same purpose as BASIC's LEN function, but it is considerably faster.
FUNCTION QPLen%(text$)
  QPLen% = LEN(text$)
END FUNCTION

FUNCTION QPSadd%(Work$)
END FUNCTION

FUNCTION QPStrI$(IntVar%)
END FUNCTION

FUNCTION QPStrL$(LongInt&)
END FUNCTION

FUNCTION QPTrim$(inputValue$)
  QPTrim$ = QPLTrim$(QPRTrim$(inputValue$))
END FUNCTION

FUNCTION QPLTrim$(inputValue$)
  result$ = inputvalue$
  DO
    IF LEN(result$) = 0 THEN EXIT DO
    ch$ = LEFT$(result$, 1)
    SELECT CASE ch$
      CASE CHR$(0), " " ', CHR$(9), CHR$(13), CHR$(10)
        result$ = RIGHT$(result$, LEN(result$) - 1)
      CASE ELSE: EXIT DO
    END SELECT
  LOOP
  QPLTrim$ = result$
END FUNCTION

FUNCTION QPRTrim$(inputValue$)
  result$ = inputvalue$
  DO
    IF LEN(result$) = 0 THEN EXIT DO
    ch$ = RIGHT$(result$, 1)
    SELECT CASE ch$
      CASE CHR$(0), " " ', CHR$(9), CHR$(13), CHR$(10)
        result$ = LEFT$(result$, LEN(result$) - 1)
      CASE ELSE: EXIT DO
    END SELECT
  LOOP
  QPRTrim$ = result$
END FUNCTION

FUNCTION QPValI% (X$)
  QPValI% = VAL(X$)
END FUNCTION

FUNCTION QPValL&(Work$)
END FUNCTION

SUB RemCtrl(X$, Replace$)
END SUB

' ReplaceChar replaces all occurrences of a specified character in a 
' string with a different character.
SUB ReplaceChar(sourceValue$, oldValue$, newValue$)
  oldChar$ = LEFT$(oldValue$, 1)
  newChar$ = LEFT$(newValue$, 1)
  ReplaceString sourceValue$, oldChar$, newChar$
END SUB

' ReplaceChar2 replaces all occurrences of a specified character in a 
' string with a different character while ignoring capitalization. 
SUB ReplaceChar2(sourceValue$, oldValue$, newValue$)
  oldChar$ = LEFT$(oldValue$, 1)
  newChar$ = LEFT$(newValue$, 1)
  ReplaceString2 sourceValue$, oldChar$, newChar$
END SUB

' SUB ReplaceCharT(typeVar as Any, typeLength%, oldChar%, newChar%)
' END SUB

' SUB ReplaceCharT2(typeVar as Any, typeLength%, oldChar%, newChar%)
' END SUB

' ReplaceString replaces all occurrences of a specified string with a 
' different string (case-sensitive). Both the string being searched 
' for and its replacement may be any length.
SUB ReplaceString (sourceValue$, oldValue$, newValue$) STATIC

    oldLen = LEN(oldValue$)
    newLen = LEN(newValue$)
    pointer = 1

Again:
    pointer = QInstr%(pointer, sourceValue$, oldValue$)' case-sensitive

    IF pointer THEN
       sourceValue$ = LEFT$(sourceValue$, pointer - 1) + newValue$ + MID$(sourceValue$, pointer + oldLen)
       pointer = pointer + newLen
       GOTO Again
    END IF

END SUB

' ReplaceString2 replaces all occurrences of a specified string with a 
' different string (case-insensitive). Both the string being searched 
' for and its replacement may be any length.
SUB ReplaceString2 (sourceValue$, oldValue$, newValue$) STATIC

    oldLen = LEN(oldValue$)
    newLen = LEN(newValue$)
    pointer = 1

Again:
    pointer = QInstr2%(pointer, sourceValue$, oldValue$)' case-insensitive

    IF pointer THEN
       sourceValue$ = LEFT$(sourceValue$, pointer - 1) + newValue$ + MID$(sourceValue$, pointer + oldLen)
       pointer = pointer + newLen
       GOTO Again
    END IF

END SUB

SUB ReplaceTbl(Work$, Table$)
END SUB

SUB Sequence(Work$)
END SUB

FUNCTION SpellNumber$(number$)
END SUB

SUB Translate(X$)
END SUB

SUB Upper(value$)
  value$ = UCASE$(value$)
END SUB

SUB UpperTbl(Work$, Table$)
END SUB

' ****************************************
' Chapter 9 - Video Routines
' ****************************************

' ArraySize will quickly calculate how many elements are needed in an
' integer array that is intended to hold a portion of the display screen.
FUNCTION ArraySize%(ulRow%, ulCol%, lrRow%, lrCol%)
  ArraySize% = (lrRow% - ulRow% + 1) * (lrCol% - ulCol% + 1)
END FUNCTION

' BPrint will print either a conventional or fixed-length string at the 
' current cursor position through DOS. 
SUB BPrint(X$)
  PRINT X$;
END SUB

SUB ClearScr (ulRow%, ulCol%, lrRow%, lrCol%, colr%, page%)
  ' NOTE: page% is currently not implemented.
  ' page% of -1 is "current page"
  FOR r = ulRow% TO lrRow%
    FOR c = ulCol% TO lrCol%
      QPRINTRC " ", r, c, colr%
    NEXT
  NEXT
END SUB

SUB ClearScr0 (ulRow%, ulCol%, lrRow%, lrCol%, colr%)
  FOR r = ulRow% TO lrRow%
    FOR c = ulCol% TO lrCol%
      QPRINTRC " ", r, c, colr%
    NEXT
  NEXT
END SUB

' GetVMode will report the current video mode, the currently active 
' display page, the page size, and the number of rows and columns. 
SUB GetVMode (mode%, page%, pageSize%, rows%, columns%)
  'TODO: Need to implement other values.
  columns% = _WIDTH
  rows% = _HEIGHT
END SUB

FUNCTION Monitor%
  ' NOTE: The documentation for QPrintAny() and Monitor% don't appear to align????
  Monitor% = 7 ' VGA adapter with a color monitor.
END FUNCTION

' MPaintBox is similar to PaintBox, except it always turns off the 
' mouse cursor before painting the screen. When it is finished the 
' cursor is turned back on. 
SUB MPaintBox (ulRow%, ulCol%, lrRow%, lrCol%, colr%)
  ' Paint a portion of the screen; leaving text intact (only change color).
  FOR r = ulRow% TO lrRow%
    FOR c = ulCol% TO lrCol%
      ch = SCREEN(r, c)
      QPrintRC CHR$(ch), r, c, colr%
    NEXT
  NEXT
END SUB

' MQPrint is similar to QPrint, except it always turns off the mouse cursor
' before printing. When it is finished the cursor is turned back on. 
SUB MQPrint (txt$, colr%)
  ofg% = -1: obg% = -1
  IF colr% = -1 THEN
    ' Maintain existing color...
  ELSE
     ofg% = _DEFAULTCOLOR: obg% = _BACKGROUNDCOLOR
     SplitColor colr%, fg%, bg%
     COLOR fg%, bg%
  END IF
  PRINT txt$;
  IF ofg% <> -1 AND obg% <> -1 THEN
    COLOR ofg%, obg%
  END IF
END SUB

' MScrnRest is similar to ScrnRest, except it always turn off 
' the mouse cursor while it is working. 
SUB MScrnRest (ulRow%, ulCol%, lrRow%, lrCol%, element%())
  ScrnRest0 ulRow%, ulCol%, lrRow%, lrCol%, element%()
END SUB

' MScrnSave is similar to ScrnSave, except it always turn off 
' the mouse cursor while it is working. 
SUB MScrnSave (ulRow%, ulCol%, lrRow%, lrCol%, element%())
  'TODO: Capture the region for restoration later.
  ScrnSave0 ulRow%, ulCol%, lrRow%, lrCol%, element%()
END SUB

FUNCTION OneColor% (fg%, bg%)
  OneColor% = (fg% AND 16) * 8 + ((bg% AND 7) * 16) + (fg% AND 15)
END FUNCTION

SUB QPrint (text$, colr%, page%)
  ofg% = -1: obg% = -1
  IF colr% = -1 THEN
    ' Maintain existing color...
  ELSE
     ofg% = _DEFAULTCOLOR: obg% = _BACKGROUNDCOLOR
     SplitColor colr%, fg%, bg%
     COLOR fg%, bg%
  END IF
  PRINT text$;
  IF ofg% <> -1 AND obg% <> -1 THEN
    COLOR ofg%, obg%
  END IF
END SUB

SUB QPrint0 (text$, colr%)
  ofg% = -1: obg% = -1
  IF colr% = -1 THEN
    ' Maintain existing color...
  ELSE
     ofg% = _DEFAULTCOLOR: obg% = _BACKGROUNDCOLOR
     SplitColor colr%, fg%, bg%
     COLOR fg%, bg%
  END IF
  PRINT text$;
  IF ofg% <> -1 AND obg% <> -1 THEN
    COLOR ofg%, obg%
  END IF
END SUB

' QPrintAny provides a simple way for a BASIC program to utilize 
' two monitors at the same time. 
SUB QPrintAny (txt$, clr%, monCode%, row%, column%)
  ' NOTE: monCode% is currently not active.
  '       1 - Monochrome monitor at segment &HB000
  '       2 - CGA monitor at segment &HB800
  '       3 - EGA or VGA monitor at segment &HB800
  ofg% = -1: obg% = -1
  IF clr% = -1 THEN
    ' Maintain existing color...
  ELSE
     ofg% = _DEFAULTCOLOR: obg% = _BACKGROUNDCOLOR
     SplitColor clr%, fg%, bg%
     COLOR fg%, bg%
  END IF
  LOCATE row%, column%
  PRINT txt$;
  IF ofg% <> -1 AND obg% <> -1 THEN
    COLOR ofg%, obg%
  END IF
END SUB

SUB QPrintRC (TXT$, R%, C%, CLR%)
  OFG% = -1: OBG% = -1
  IF CLR% = -1 THEN
    ' Maintain existing color...
  ELSE
     OFG% = _DEFAULTCOLOR: OBG% = _BACKGROUNDCOLOR
     SplitColor CLR%, FG%, BG%
     COLOR FG%, BG%
  END IF
  LOCATE R%, C%
  PRINT TXT$;
  IF OFG% <> -1 AND OBG% <> -1 THEN
    COLOR OFG%, OBG%
  END IF
END SUB

' ScrnRest will restore a screen that had previously been saved with 
' ScrnSave or ScrnSave0. 
SUB ScrnRest (ulRow%, ulCol%, lrRow%, lrCol%, element%(), page%)
  ' NOTE: page% is currently not implemented
  cols% = lrCol% - ulCol%
  rows% = lrRow% - ulRow%
  FOR c% = 0 TO cols%
    FOR r% = 0 TO rows%
      index% = (r% * cols%) + c%
      clr% = element%(index%) AND &H00FF ' split color
      ch% = ((element%(index%) AND &HFF00) \ 256) AND &H00FF ' split character
      QPrintRC CHR$(ch%), ulRow% + r%, ulCol% + c%, clr%
    NEXT
  NEXT
END SUB

' ScrnRest0 will restore a screen that had previously been saved with 
' ScrnSave or ScrnSave0. 
SUB ScrnRest0 (ulRow%, ulCol%, lrRow%, lrCol%, element%())
  ScrnRest ulRow%, ulCol%, lrRow%, lrCol%, element%(), 0
END SUB

' ScrnSave will save all or part of a text screen into an integer array, 
' to allow restoring it again at a later time. 
SUB ScrnSave (ulRow%, ulCol%, lrRow%, lrCol%, element%(), page%)
  ' NOTE: page% is currently not implemented
  cols% = lrCol% - ulCol%
  rows% = lrRow% - ulRow%
  FOR c% = 0 TO cols%
    FOR r% = 0 TO rows%
      index% = (r% * cols%) + c%
      ch% = SCREEN(ulRow% + r%, ulCol% + c%, 0)
      clr% = SCREEN(ulRow% + r%, ulCol% + c%, 1)
      element%(index%) = (ch% * 256) + clr% ' combine
    NEXT
  NEXT
END SUB

' ScrnSave will save all or part of a text screen into an integer array, 
' to allow restoring it again at a later time. 
SUB ScrnSave0 (ulRow%, ulCol%, lrRow%, lrCol%, element%())
  ScrnSave ulRow%, ulCol%, lrRow%, lrCol%, element%(), 0
END SUB

SUB SplitColor (colr%, fg%, bg%)
  fg% = (colr% AND 128) \ 8 + (colr% AND 15) 
  bg% = (colr% AND 112) \ 16 
END SUB

' Chapter Next

FUNCTION BitShift% (value%, cmd$, bits%)
  mult% = 2
  SELECT CASE bits%
    CASE 1 ' already set
    CASE 2: mult% = 4
    CASE 3: mult% = 8
    CASE 4: mult% = 16
    CASE 5: mult% = 32
    CASE 6: mult% = 64
    CASE 7: mult% = 128
    CASE 8: mult% = 256
    CASE 9: mult% = 512
    CASE 10: mult% = 1024
    CASE 11: mult% = 2048
    CASE 12: mult% = 4096
    CASE 13: mult% = 8192
    CASE 14: mult% = 16384
    CASE 15: mult% = 32768
    CASE 16: mult% = 65536
    CASE ELSE
  END SELECT
  IF cmd$ = "<<" THEN ' "value%" has to be shifted "bits%" bit(s) to the left.
    ' formula: x = x * 2 ^ y
    BitShift% = ((value% * mult%) AND &HFFFF)
  ELSEIF cmd$ = ">>" THEN ' "value%" has to be shifted "bits%" bit(s) to the right.
    ' formula: x = x / 2 ^ y
    BitShift% = value% \ mult%
  END IF
END FUNCTION