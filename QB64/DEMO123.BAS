' ********** DEMO123.BAS - demonstrates reading/writing files in Lotus 123 format

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
_TITLE "DEMO123" 'NOTE: Moving title above resize causes resize to fail (without an error???)
'BUG: It would be nice specify the icon here, but... having to require full path or placing it in the qb64 folder is problematic. 
'NOTE: The above boiler plate must be first in execution (top of file).
'BUG:  Also appears to not work as an $INCLUDE; suggesting something might
'      be wrong with the implementation of $INCLUDE.
' **************************
' * BOILER PLATE END
' **************************

' This program provides an example of both reading and creating files that
' may be processed by Lotus 123.  As such, it is not intended to serve as a
' complete set of tools, rather it merely shows the steps that are needed.
'
' If you select "Create" when this program is run, it will write a worksheet
' file named SAMPLE.WKS suitable for reading into any version of Lotus 123.
' This sample file contains an assortment of labels and values.  If you select
' "Read", the program will prompt for the name of a worksheet file.  Either
' type the name of an existing Lotus file, or press Enter to see a list of
' worksheet files.  We have not provided any sample files, so you must provide
' your own, or first create one using this program.
'
' This program was derived from an article that appeared in PC Magazine in
' the December 13, 1988 issue (Volume 7, Number 21).  Press F2 to view the
' "Subprogram" named Doc123 for a brief discussion of the Lotus file format.
' All of the research for this program was provided by Philip Martin Valley.
'
' NOTE: to read and write files for Lotus 1-2-3 version 3.0 change the file
' extension to .WK1 and set the version number to 1030.  Thanks to Marcus
' Lyon of London, England for this tip.

DEFINT A-Z

'$INCLUDE: 'PRO.BI'

DECLARE FUNCTION Exist% (FileSpec$)
DECLARE SUB GetFormat (Frmat, Row, Column)
DECLARE SUB WriteColWidth (Column, ColWidth)
DECLARE SUB WriteInteger (Row, Column, ColWidth, Temp)
DECLARE SUB WriteLabel (Row, Column, ColWidth, Msg$)
DECLARE SUB WriteNumber (Row, Column, ColWidth, Fmt$, Number#)

DIM SHARED cellFmt AS STRING * 1        ' allows reading one byte
DIM SHARED colNum(40)                   ' maximum number of columns to write
DIM SHARED fileNum                      ' the file number to use

CLS
PRINT "Read an existing 123 file or Create a sample file (R/C)? ";
LOCATE , , 1
DO
  x$ = UCASE$(INKEY$)
LOOP UNTIL x$ = "R" OR x$ = "C"
LOCATE , , 0
PRINT x$

IF x$ = "R" THEN        ' ***** read an existing file

   DO
     INPUT "Lotus file to read (press Enter to display a list): ", fileName$
     IF fileName$ = "" THEN
       IF Exist%("*.WK?") THEN
         FILES "*.WK?"
       ELSE
         PRINT "No sample files, press Enter and then select Create sample."
         INPUT "", bs$
         RUN
       END IF
     END IF
   LOOP UNTIL LEN(fileName$)

   IF INSTR(fileName$, ".") = 0 THEN fileName$ = fileName$ + ".WKS"
   PRINT

   fileNum = FREEFILE                       ' obtain next available file handle
   OPEN fileName$ FOR BINARY AS #fileNum    ' open the file for Binary access

   DO UNTIL opcode = 1                  ' until Lotus "End of File" Opcode

      GET fileNum, , opcode             ' get the next opcode
      GET fileNum, , length             ' and length of the data that follows
  
      SELECT CASE opcode                ' handle the data according to its type

        CASE 0                          ' Beginning of file record and version
          GET fileNum, , temp           ' Temp holds the version number

          IF temp < 1028 OR temp > 1030 THEN  ' test this if the file might
            PRINT "NOT a Lotus File!"         '   not be a valid Lotus file
            END
          END IF

          PRINT "Beginning of file:  Lotus "; ' Version number is the only
            SELECT CASE temp                  '   information in this record
              CASE 1028
                PRINT "123 version 1.0 or 1A"
              CASE 1029
                PRINT "Symphony version 1.0"
              CASE 1030
                PRINT "123 version 2.0, 2.1, or Symphony version 1.1"
            END SELECT
     
        CASE 12                 ' Blank - NOTE: Lotus saves blank cells only
                                '   if they are formatted or protected
          CALL GetFormat(frmat, row, column)
          PRINT "Blank:      Format ="; frmat, "Row ="; row, "Col ="; column

        CASE 13                ' Integer
          CALL GetFormat(frmat, row, column)
          GET fileNum, , temp
          PRINT "Integer:    Format ="; frmat, "Row ="; row, "Col ="; column, "Value ="; temp

        CASE 14                ' Floating point
          CALL GetFormat(frmat, row, column)
          GET fileNum, , number#
          PRINT "Number:     Format ="; frmat, "Row ="; row, "Col ="; column, "Value ="; number#
     
        CASE 15                ' Label
          CALL GetFormat(frmat, row, column)
          info$ = SPACE$(length - 6)    ' create a string to hold the label
                                        ' 6 is subtracted to exclude the
                                        '   Format, Column, Row, and 0 bytes
                                        '   that were included in the original
                                        '   length byte (already gotten by the
                                        '   GetFormat routine)
          GET fileNum, , info$          ' get the label text
          GET fileNum, , cellFmt$       ' gobble up the trailing CHR$(0) byte
          PRINT "Label:      Format ="; frmat, "Row ="; row, "Col ="; column, info$
     
        CASE 16                ' Formula
          CALL GetFormat(frmat, row, column)
          GET fileNum, , number#        ' get the cell's value
          GET fileNum, , length         ' get length of formula "text"
          SEEK fileNum, SEEK(fileNum) + length   ' skip over the formula
                                        ' the formula is "tokenized" in reverse
                                        ' Polish notation - not a pretty story
        PRINT "Formula:    Format ="; frmat, "Row ="; row, "Col ="; column, number#
     
        CASE ELSE               ' anything else merely relates to the way the
                                '   spreadsheet operates (recalc order, print
                                '   ranges, and so forth)
          dummy$ = SPACE$(length)       ' skip over the unwanted record
          GET fileNum, , dummy$
          PRINT "Opcode: "; opcode      ' show its Opcode just for fun

      END SELECT
  
      '------ pause when the screen fills
      IF CSRLIN > 21 THEN
        PRINT : PRINT "Press <ESC> to end or any other key for more . . ."
        DO
          k$ = INKEY$
        LOOP UNTIL LEN(k$)
        IF k$ = CHR$(27) THEN EXIT DO
        CLS
      END IF

      cntr = cntr + 1           ' track how many 123 records have been read

   LOOP

   PRINT "Number of Records Processed ="; Cntr
   CLOSE

ELSE    '***** write a sample file

   fileNum = FREEFILE           ' get the next available file number
   OPEN "SAMPLE.WKS" FOR BINARY AS #fileNum

   temp = 0                     ' OpCode for Start of File
   PUT fileNum, , temp
   temp = 2                     ' data length is 2 (for the following integer)
   PUT fileNum, , temp
   temp = 1028                  ' the Lotus version number
   PUT fileNum, , temp          ' (Lotus version 1 = 1028; version 2 = 1030)

   row = 0                      ' row numbers in Lotus begin with 0, not 1
   DO
      CALL WriteLabel(row, 0, 16, "This is a Label")    ' a label
      CALL WriteLabel(row, 1, 12, "So's This")          ' another label
      CALL WriteInteger(row, 2, 7, 12345)               ' an integer
      CALL WriteNumber(row, 3, 9, "C2", 57.23#)         ' a number:  $57.23
      CALL WriteNumber(row, 4, 9, "F5", 12.3456789#)    ' another number
      CALL WriteInteger(row, 6, 9, 99)          ' it's okay to skip a column
      row = row + 1                             ' go on to the next row
   LOOP WHILE row < 6

   '----- Write the "End of File" record and close the file
   temp = 1                ' OpCode for End of File
   PUT fileNum, , temp
   temp = 0                ' its Data length is zero
   PUT fileNum, , temp

   CLOSE

END IF

SUB Doc123    'Dummy sub to separate this discussion from the example programs
  '
  ' All Lotus 123 files are intended to be read sequentially using a Binary file
  ' access.  A Lotus file is comprised of individual records, and each record
  ' may have a varying length.  The length of a record depends on its contents,
  ' though most records contain a fixed-length header which describes the
  ' information that follows.
  '
  ' A Lotus 123 file may contain as many as 63 different types of records.
  ' However, this program accommodates only those that would be of interest in
  ' a BASIC program.  These are Beginning of File, End of File, Integer values,
  ' Floating point values, Text labels, and the double precision values embedded
  ' within a Formula record.  The format used by the actual formulas is quite
  ' complex, and is not addressed in this discussion.  A complete description of
  ' all of the record types is contained in the excellent book, "File Formats
  ' for Popular PC Software" written by Jeff Walden, and published by Wiley
  ' Press.  (ISBN number 0-471-83671-0)
  '
  ' Other records that will not be covered here are those that pertain to the
  ' structure of the worksheet itself.  For example, range names, printer setup
  ' strings, macro definitions, and so forth.  These are described fully in the
  ' above mentioned book.
  '
  ' Regardless of the type of record being considered, each follows the exact
  ' same format:
  '
  '     Opcode, Length, Data
  '
  ' The Opcode is always a two-byte integer which identifies the type of data
  ' that will follow.  For example, an Opcode of 15 indicates that the data in
  ' the record will be treated by 123 as a text label.  The Length is also an
  ' integer, and it tells the number of bytes in the Data section that follows.
  '
  ' All of the records that pertain to a cell contain a five-byte header at the
  ' beginning of the data section.  These five bytes are included within the
  ' Length byte for the data.  The first header byte contains the formatting
  ' information, such as the number of decimal positions to display.  The next
  ' two bytes together contain the cell's row, and the following two bytes hold
  ' the cell's column.
  '
  ' This header is present only in records that refer to a cell's contents.  For
  ' example, the Beginning and End of File records do not contain a header, nor
  ' do those records that describe the worksheet.  Some records such as labels
  ' and formulas will have a varying length, while those that contain numbers
  ' will be fixed depending on the type of number.  Floating point values are
  ' always eight bytes long, and are in the same IEEE format used by QuickBASIC
  ' 4.0 and later.  Likewise, an integer value will always have a length of two
  ' bytes.  Because the Length word includes the five-byte header size, the total
  ' length for these examples would be 13 and 7 respectively.
  '
  ' It is important to understand that internally, rows and columns are based at
  ' zero.  Even though 123 considers the leftmost row to be number 1, it is
  ' stored in the file as a zero.  Likewise, the first column as displayed by
  ' 123 is labelled "A", but is identified in the file as column 0.  It is thus
  ' up to your program to translate the columns to the alphabetic format if you
  ' intend to display them as Lotus does.
  '
  ' In the sample read program, the same steps are performed for each record.
  ' That is, GET is used to read the record's type, length, and data.  If the
  ' record type indicates that it pertains to a worksheet cell, then the five-
  ' byte header will also be read using the GetFormat subprogram.  Opcodes that
  ' are not supported by this program are simply displayed, so you will see that
  ' they were encountered.
  '
  ' The sample write program performs simple formatting, and also ensures that
  ' a column-width record is written only once.  The table below shows the
  ' makeup of the formatting byte used in Lotus files:
  '
  '                      7  6  5  4  3  2  1  0      <-------- bits
  '                      ^  ^  ^  ^  ^  ^  ^  ^
  '                      |  |  |  |  |  |  |  |
  ' protected if set ----+  |  |  |  +--+--+--+--- number of digits
  '                         +--+--+--------------- type of format (see below)
  '
  '
  '                         0  0  0      fixed number of digits
  '                         0  0  1      exponential notation
  '                         0  1  0      currency
  '                         0  1  1      percent
  '                         1  0  0      flag to add commas when displaying
  '                         1  0  1      unused
  '                         1  1  0      unused
  '                         1  1  1      other format
  '
END SUB

SUB GetFormat (frmat, row, column)
  GET fileNum, , cellFmt$: frmat = ASC(cellFmt$)
  GET fileNum, , column
  GET fileNum, , row
END SUB

SUB WriteColWidth (column, colWidth)
  IF NOT colNum(column) THEN            ' if width record not already written
    IF colWidth = 0 THEN colWidth = 9   ' default to 9 if no value
    temp = 8
    PUT fileNum, , temp
    temp = 3
    PUT fileNum, , temp
    PUT fileNum, , column
    temp$ = CHR$(colWidth)
    PUT fileNum, , temp$
    colNum(column) = -1                 ' show we did this one for later
  END IF
END SUB

SUB WriteInteger (row, column, colWidth, integ)

  temp = 13                     ' OpCode for an integer
  PUT fileNum, , temp
  temp = 7                      ' Length + 5 byte header
  PUT fileNum, , temp
  temp$ = CHR$(127)             ' the format portion of the header
  PUT fileNum, , temp$          ' (use CHR$(255) for a protected field)
  PUT fileNum, , column
  PUT fileNum, , row
  PUT fileNum, , integ

  CALL WriteColWidth(column, colWidth)

END SUB

SUB WriteLabel (row, column, colWidth, msg$)

  IF LEN(msg$) > 240 THEN msg$ = LEFT$(msg$, 240)   ' 240 is maximum length

  temp = 15                     ' OpCode for a label
  PUT fileNum, , temp
  temp = LEN(msg$) + 7          ' Length + 5-byte header + "'" + CHR$(0) byte
  PUT fileNum, , temp
  temp$ = CHR$(127)             ' 127 is default format for unprotected cell
  PUT fileNum, , temp$
  PUT fileNum, , column
  PUT fileNum, , row
  temp$ = "'" + msg$ + CHR$(0)  'NOTE:  "'" means label will be left aligned

  PUT fileNum, , temp$
  CALL WriteColWidth(column, colWidth)

END SUB

SUB WriteNumber (row, column, colWidth, fmt$, number#)

  IF LEFT$(fmt$, 1) = "F" THEN                  ' fixed ...
    frmat$ = CHR$(0 + VAL(RIGHT$(fmt$, 1)))     ' number of decimal places
  ELSEIF LEFT$(fmt$, 1) = "C" THEN              ' currency ...
    frmat$ = CHR$(32 + VAL(RIGHT$(fmt$, 1)))    ' number of decimal places
  ELSEIF LEFT$(fmt$, 1) = "P" THEN              ' percent ...
    frmat$ = CHR$(48 + VAL(RIGHT$(fmt$, 1)))    ' number of decimal places
  ELSE
    frmat$ = CHR$(127)                          ' use default format
    'frmat$ = CHR$(255)                          ' optional to protect cell
  END IF
     
  temp = 14
  PUT fileNum, , temp
  temp = 13
  PUT fileNum, , temp
  PUT fileNum, , frmat$
  PUT fileNum, , column
  PUT fileNum, , row
  PUT fileNum, , number#
  
  CALL WriteColWidth(column, colWidth)

END SUB

'$INCLUDE: 'PRO.BAS'