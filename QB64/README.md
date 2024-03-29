# QuickPak Professional for QB64

This is a work-in-progress project that is fairly complete (within the restrictions/limitations of QB64). One of the desired goals is to write the equivalent functionality using QB64 directly; instead of, for example, using C/C++ to create a separate library.

## Progress

| File       |         |   | File       |         |   | File       |         |
| ---------- | ------- | - | ---------- | ------- | - | ---------- | ------- |
|AMENU.BAS   | EXE     |   |APRINT.BAS  | EXE     |   |APRINTT.BAS | EXE     |
|ASCCHART.BAS| INCLUDE |   |ASCIIPIK.BAS| EXE     |   |ASSEMBLY.BAS| EXE     |
|BCOPYT.BAS  | EXE     |   |BIGPRINT.BAS| EXE     |   |BITS.BAS    | EXE     |
|BLPRINT.BAS | N/A     |   |BPRINT.BAS  | EXE     |   |CALC.BAS    | INCLUDE |
|CALENDAR.BAS| INCLUDE |   |CAPNUM.BAS  | INCLUDE |   |CLEARSCR.BAS| EXE     |
|COLORPIK.BAS| EXE     |   |COLORS.BAS  | EXE     |   |COMPARE.BAS | EXE     |
|DATA.BAS    | N/A     |   |DATE2DAY.BAS| EXE     |   |DATEIN.BAS  | INCLUDE |
|DAYNAME.BAS | EXE     |   |DECLARE.BAS | INCLUDE |   |DEFCNF.BI   | INCLUDE |
|DEMO123.BAS | EXE     |   |DEMOCM.BAS  | EXE     |   |DEMOCOMP.BAS| EXE     |
|DEMOCOPY.BAS| EXE     |   |DEMOCRPT.BAS| EXE     |   |DEMODATE.BAS| EXE     |
|DEMODIA2.BAS| EXE     |   |DEMODIAL.BAS| EXE     |   |DEMODIAP.BAS| EXE     |
|DEMOEDIT.BAS| EXE     |   |DEMOEMS.BAS | N/A     |   |DEMOEMS2.BAS| N/A     |
|DEMOEVAL.BAS| EXE     |   |DEMOFAST.BAS| EXE     |   |DEMOFC.BAS  | EXE     |
|DEMOGAS.BAS | EXE     |   |DEMOIN.BAS  | EXE     |   |DEMOLTS.BAS | EXE     |
|DEMOMAIN.BAS| EXE     |   |DEMOMASK.BAS| EXE     |   |DEMOMENU.BAS| EXE     |
|DEMOMGR.BAS | EXE     |   |DEMOPICK.BAS| EXE     |   |DEMOPLMS.BAS| EXE     |
|DEMOPOP.BAS | EXE     |   |DEMOPULL.BAS| EXE     |   |DEMORK.BAS  | EXE     |
|DEMOSCAN.BAS| EXE     |   |DEMOSCRL.BAS| EXE     |   |DEMOSECT.BAS|         |
|DEMOSORT.BAS|         |   |DEMOSS.BAS  |         |   |DEMOSTR.BAS | EXE     |
|DEMOTSRT.BAS|         |   |DEMOVERT.BAS| EXE     |   |DEMOVIEW.BAS| EXE     |
|DEMOVRTT.BAS|         |   |DEMOXMS.BAS | N/A     |   |DIALOG.BAS  | INCLUDE |
|DIRTREE.BAS | EXE     |   |DISKINFO.BAS|         |   |EDIT.BAS    | EXE     |
|EGABSAVE.BAS|         |   |EVALUATE.BAS| INCLUDE |   |EXENAME.BAS | EXE     |
|EXIST.BAS   | EXE     |   |FAPPEND.BAS | EXE     |   |FASTFILE.BAS| INCLUDE |
|FGETAH.BAS  |         |   |FGETR.BAS   |         |   |FGETRT.BAS  |         |
|FILECOMP.BAS| INCLUDE |   |FILECOPY.BAS| INCLUDE |   |FILECRPT.BAS| INCLUDE |
|FILEINFO.BAS| EXE     |   |FILESORT.BAS|         |   |FILEVIEW.BAS|         |
|FILL.BAS    | EXE     |   |FILLSCRN.BAS| EXE     |   |FIND.BAS    | EXE     |
|FINDLAST.BAS| EXE     |   |FINDT.BAS   | EXE     |   |FLINPUT.BAS | EXE     |
|FLUSH.BAS   |         |   |FNOTHER.BAS | EXE     |   |FNSPREAD.BAS| EXE     |
|FORMAT.BAS  | N/A     |   |FULLNAME.BAS| EXE     |   |GASGAUGE.BAS| INCLUDE |
|GET1STR.BAS | INCLUDE |   |GETATTR.BAS | EXE     |   |GETCMOS.BAS |         |
|GETCOLOR.BAS| EXE     |   |GETDIR.BAS  | EXE     |   |GETEQUIP.BAS| EXE     |
|GETVMODE.BAS| EXE     |   |GRAFCURS.BAS|         |   |HAND2NAM.BAS|         |
|HCOPY.BAS   |         |   |HUGE.BAS    |         |   |IMINMAX.BAS | EXE     |
|INCOUNT.BAS | EXE     |   |INSERT.BAS  | EXE     |   |INSERTT.BAS | EXE     |
|INSTALL.BAS |         |   |INSTAT.BAS  |         |   |INSTRTBL.BAS|         |
|ISORTI.BAS  |         |   |ISORTI2.BAS |         |   |ISORTSTR.BAS|         |
|ISORTT.BAS  |         |   |KEYDOWN.BAS | EXE     |   |KEYS.BAS    | EXE     |
|KEYSORT.BAS |         |   |KEYSTAT.BAS | EXE     |   |LINCOUNT.BAS| EXE     |
|LOADEXEC.BAS| EXE     |   |LOCKFILE.BAS|         |   |LONGSTR.BAS | EXE     |
|LTS2MENU.BAS| INCLUDE |   |LTSMENU.BAS | INCLUDE |   |MAINMENU.BAS| INCLUDE |
|MAKEQLB.BAS |         |   |MARQUEE.BAS | EXE     |   |MASKIN.BAS  | INCLUDE |
|MIDSTRSR.BAS|         |   |MINMAX.BAS  | EXE     |   |MONITOR.BAS | EXE     |
|MOUSE.BAS   | EXE     |   |MOUSECM.BAS | EXE     |   |MPREST.BAS  | EXE     |
|MRANGE.BAS  | EXE     |   |MRANGEG.BAS | EXE     |   |MSGBOX.BAS  | INCLUDE |
|NUMIN.BAS   | INCLUDE |   |PAINTBOX.BAS| EXE     |   |PARSE.BAS   | EXE     |
|PARSESTR.BAS| EXE     |   |PAUSE3.BAS  | EXE     |   |PICKLIST.BAS| INCLUDE |
|PRO.BAS     | PRO.LIB |   |PRO.BI      | PRO.LIB |   |PRTSC.BAS   |         |
|PULLDNMS.BAS| INCLUDE |   |PULLDOWN.BAS| INCLUDE |   |PUTVOL.BAS  |         |
|QD.BAS      |         |   |QEDIT.BAS   | INCLUDE |   |QEDIT7.BAS  |         |
|QEDITS.BAS  | INCLUDE |   |QEDITYPE.BI | INCLUDE |   |QINSTR.BAS  | EXE     |
|QINSTRH.BAS |         |   |QPLEFT.BAS  | EXE     |   |QPSOLVER.BAS| EXE     |
|QPSOUND.BAS | EXE     |   |QPTRIM.BAS  | EXE     |   |QSORT.BAS   | EXE     |
|READDIRS.BAS| EXE     |   |READDIRT.BAS|         |   |READFILE.BAS| EXE     |
|READFILI.BAS|         |   |READFILT.BAS|         |   |READFILX.BAS|         |
|READSECT.BAS|         |   |REPLACE.BAS | EXE     |   |RPTKEY.BAS  |         |
|RWTEST.BAS  |         |   |SCANFILE.BAS| INCLUDE |   |SCIFORM.BAS | EXE     |
|SCRNDUMP.BAS| N/A     |   |SCRNSR.BAS  | EXE     |   |SCROLL.BAS  | EXE     |
|SCROLLIN.BAS| INCLUDE |   |SEARCH.BAS  | EXE     |   |SEQUENCE.BAS| EXE     |
|SETATTR.BAS |         |   |SETCNF.BI   | INCLUDE |   |SHIFT.BAS   | EXE     |
|SORTI.BAS   |         |   |SORTSTR.BAS | EXE     |   |SORTT.BAS   |         |
|SOUNDEX.BAS | EXE     |   |SPELLNUM.BAS| EXE     |   |SPLITNAM.BAS| EXE     |
|SPREAD.BAS  |         |   |SRCHPATH.BAS| INCLUDE |   |STRREST.BAS | INCLUDE |
|STUFFBUF.BAS|         |   |TEST.BAS    | EXE     |   |TEXTIN.BAS  | INCLUDE |
|TEXTSORT.BAS|         |   |TIME.BAS    | EXE     |   |TRANSLAT.BAS| EXE     |
|UNIQUE.BAS  | INCLUDE |   |VALID.BAS   | EXE     |   |VERTMENT.BAS|         |
|VERTMENU.BAS| INCLUDE |   |VIEWFILE.BAS| INCLUDE |   |VIRTUAL.BAS |         |
|VLONG.BAS   |         |   |WEEKDAY.BAS | EXE     |   |WINDOMGR.BAS| INCLUDE |
|WINDOW.BAS  |         |   |WIPES.BAS   | EXE     |   |WORDWRAP.BAS| EXE     |
|YESNOB.BAS  | INCLUDE |   |            |         |   |            |         |

Files marked with *INCLUDE* are meant to be included, while files marked as *EXE* are to be compiled as an executable (stand-alone example). The replacement of the PRO.LIB functionality is implemented in the *PRO.BAS* and *PRO.BI* source files. (Files marked with *N/A* are either hardware specific and/or simply "not possible" with the current release of QB64 (v2.1). If you disagree, please discuss.)
