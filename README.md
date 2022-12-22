# QuickPak Professional for QB64

The QuickPak Professional add-on was the absolute *best* product for writing professional applications using QB4.5/PDS7.1 in the late-1980s and early-1990s. It was touted as *The Most Comprehensive Collection of BASIC Tools Ever Produced*.

The original QuickPak Professional for QB4.5/PDS7.1/VBDOS1.0 was released into the *public domain* around the end of 2018 by [Gene Buckle](https://github.com/geneb). This project serves to resurrect much of the functionality (where possible) for use with QB64 v2.1+.

You can find the original [here](http://annex.retroarchive.org/crescent/index.html) along with a [PDF copy of the manual](http://annex.retroarchive.org/crescent/QuickPak%20Professional.pdf). You can also access the [original repo here](https://github.com/geneb/QuickPak-Pro-DOS).

We also want to thank [Gene Buckle](https://github.com/geneb) for making this all possible as well as to Ethan Winer for creating the product in the first place.

## Conversion Status

| File       | Status  | File       | Status  
| ---------- | ------- | ---------- | ------- |
|AMENU.BAS   | EXE     |APRINT.BAS  | EXE     |
|APRINTT.BAS | EXE     |ASCCHART.BAS| INCLUDE |
|ASCIIPIK.BAS| EXE     |ASSEMBLY.BAS| EXE     |
|BCOPYT.BAS  |         |BIGPRINT.BAS| EXE     |
|BITS.BAS    | EXE     |BLPRINT.BAS |         |
|BPRINT.BAS  | EXE     |CALC.BAS    | INCLUDE |
|CALENDAR.BAS| INCLUDE |CAPNUM.BAS  | INCLUDE |
|CLEARSCR.BAS| EXE     |COLORPIK.BAS| EXE     |
|COLORS.BAS  | EXE     |COMPARE.BAS |         |
|DATA.BAS    |         |DATE2DAY.BAS| EXE     |
|DATEIN.BAS  | INCLUDE |DAYNAME.BAS | EXE     |
|DECLARE.BAS | INCLUDE |DEFCNF.BI   | INCLUDE |
|DEMO123.BAS |         |DEMOCM.BAS  | EXE     |
|DEMOCOMP.BAS|         |DEMOCOPY.BAS|         |
|DEMOCRPT.BAS|         |DEMODATE.BAS| EXE     |
|DEMODIA2.BAS| EXE     |DEMODIAL.BAS| EXE     |
|DEMODIAP.BAS| EXE     |DEMOEDIT.BAS| EXE     |
|DEMOEMS.BAS |         |DEMOEMS2.BAS|         |
|DEMOEVAL.BAS| EXE     |DEMOFAST.BAS|         |
|DEMOFC.BAS  |         |DEMOGAS.BAS | EXE     |
|DEMOIN.BAS  | EXE     |DEMOLTS.BAS |         |
|DEMOMAIN.BAS| EXE     |DEMOMASK.BAS|         |
|DEMOMENU.BAS| EXE     |DEMOMGR.BAS |         |
|DEMOPICK.BAS| EXE     |DEMOPLMS.BAS| EXE     |
|DEMOPOP.BAS | EXE     |DEMOPULL.BAS| EXE     |
|DEMORK.BAS  |         |DEMOSCAN.BAS|         |
|DEMOSCRL.BAS| EXE     |DEMOSECT.BAS|         |
|DEMOSORT.BAS|         |DEMOSS.BAS  |         |
|DEMOSTR.BAS |         |DEMOTSRT.BAS|         |
|DEMOVERT.BAS| EXE     |DEMOVIEW.BAS|         |
|DEMOVRTT.BAS|         |DEMOXMS.BAS |         |
|DIALOG.BAS  | INCLUDE |DIRTREE.BAS |         |
|DISKINFO.BAS|         |EDIT.BAS    | EXE     |
|EGABSAVE.BAS|         |EVALUATE.BAS| INCLUDE |
|EXENAME.BAS | EXE     |EXIST.BAS   |         |
|FAPPEND.BAS |         |FASTFILE.BAS|         |
|FGETAH.BAS  |         |FGETR.BAS   |         |
|FGETRT.BAS  |         |FILECOMP.BAS|         |
|FILECOPY.BAS|         |FILECRPT.BAS|         |
|FILEINFO.BAS|         |FILESORT.BAS|         |
|FILEVIEW.BAS|         |FILL.BAS    |         |
|FILLSCRN.BAS| EXE     |FIND.BAS    | EXE     |
|FINDLAST.BAS| EXE     |FINDT.BAS   |         |
|FLINPUT.BAS |         |FLUSH.BAS   |         |
|FNOTHER.BAS | EXE     |FNSPREAD.BAS| EXE     |
|FORMAT.BAS  |         |FULLNAME.BAS| EXE     |
|GASGAUGE.BAS| INCLUDE |GET1STR.BAS |         |
|GETATTR.BAS |         |GETCMOS.BAS |         |
|GETCOLOR.BAS| EXE     |GETDIR.BAS  | EXE     |
|GETEQUIP.BAS| EXE     |GETVMODE.BAS| EXE     |
|GRAFCURS.BAS|         |HAND2NAM.BAS|         |
|HCOPY.BAS   |         |HUGE.BAS    |         |
|IMINMAX.BAS | EXE     |INCOUNT.BAS | EXE     |
|INSERT.BAS  |         |INSERTT.BAS |         |
|INSTALL.BAS |         |INSTAT.BAS  |         |
|INSTRTBL.BAS|         |ISORTI.BAS  |         |
|ISORTI2.BAS |         |ISORTSTR.BAS|         |
|ISORTT.BAS  |         |KEYDOWN.BAS | EXE     |
|KEYS.BAS    | EXE     |KEYSORT.BAS |         |
|KEYSTAT.BAS |         |LINCOUNT.BAS|         |
|LOADEXEC.BAS|         |LOCKFILE.BAS|         |
|LONGSTR.BAS |         |LTS2MENU.BAS|         |
|LTSMENU.BAS |         |MAINMENU.BAS|         |
|MAKEQLB.BAS |         |MARQUEE.BAS | EXE     |
|MASKIN.BAS  |         |MIDSTRSR.BAS|         |
|MINMAX.BAS  | EXE     |MONITOR.BAS | EXE     |
|MOUSE.BAS   | EXE     |MOUSECM.BAS | EXE     |
|MPREST.BAS  | EXE     |MRANGE.BAS  | EXE     |
|MRANGEG.BAS | EXE     |MSGBOX.BAS  | INCLUDE |
|NUMIN.BAS   | INCLUDE |PAINTBOX.BAS| EXE     |
|PARSE.BAS   | EXE     |PARSESTR.BAS| EXE     |
|PAUSE3.BAS  | EXE     |PICKLIST.BAS| INCLUDE |
|PRO.BAS     | PRO.LIB |PRO.BI      | PRO.LIB |
|PRTSC.BAS   |         |PULLDNMS.BAS| INCLUDE |
|PULLDOWN.BAS| INCLUDE |PUTVOL.BAS  |         |
|QD.BAS      |         |QEDIT.BAS   | INCLUDE |
|QEDIT7.BAS  |         |QEDITS.BAS  |         |
|QEDITYPE.BI | INCLUDE |QINSTR.BAS  | EXE     |
|QINSTRH.BAS |         |QPLEFT.BAS  | EXE     |
|QPSOLVER.BAS| EXE     |QPSOUND.BAS | EXE     |
|QPTRIM.BAS  | EXE     |QSORT.BAS   | EXE     |
|READDIRS.BAS| EXE     |READDIRT.BAS|         |
|READFILE.BAS| EXE     |READFILI.BAS|         |
|READFILT.BAS|         |READFILX.BAS|         |
|READSECT.BAS|         |REPLACE.BAS | EXE     |
|RPTKEY.BAS  |         |RWTEST.BAS  |         |
|SCANFILE.BAS|         |SCIFORM.BAS | EXE     |
|SCRNDUMP.BAS|         |SCRNSR.BAS  | EXE     |
|SCROLL.BAS  | EXE     |SCROLLIN.BAS| INCLUDE |
|SEARCH.BAS  | EXE     |SEQUENCE.BAS| EXE     |
|SETATTR.BAS |         |SETCNF.BI   | INCLUDE |
|SHIFT.BAS   |         |SORTI.BAS   |         |
|SORTSTR.BAS | EXE     |SORTT.BAS   |         |
|SOUNDEX.BAS |         |SPELLNUM.BAS| EXE     |
|SPLITNAM.BAS| EXE     |SPREAD.BAS  |         |
|SRCHPATH.BAS|         |STRREST.BAS |         |
|STUFFBUF.BAS|         |TEST.BAS    | EXE     |
|TEXTIN.BAS  | INCLUDE |TEXTSORT.BAS|         |
|TIME.BAS    | EXE     |TRANSLAT.BAS| EXE     |
|UNIQUE.BAS  |         |VALID.BAS   |         |
|VERTMENT.BAS|         |VERTMENU.BAS| INCLUDE |
|VIEWFILE.BAS|         |VIRTUAL.BAS |         |
|VLONG.BAS   |         |WEEKDAY.BAS | EXE     |
|WINDOMGR.BAS|         |WINDOW.BAS  |         |
|WIPES.BAS   | EXE     |WORDWRAP.BAS| EXE     |
|YESNOB.BAS  | INCLUDE |            |         |

Files marked with *INCLUDE* are meant to be included, while files marked as *EXE* are to be compiled as an executable (stand-alone example). The replacement of the PRO.LIB functionality is implemented in the *PRO.BAS* and *PRO.BI* source files.

## Code Formatting Guidelines

- Attempt to retain/augment all existing comments (preserving some the history).
- Indent depth: 2 spaces.
- Variables are camel-case.
- Functions/Subs are pascal-case.
- GOSUB routine starts immediately after the GOSUB label.
- RETURN is aligned with routine.
