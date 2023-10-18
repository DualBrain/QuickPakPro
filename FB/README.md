# QuickPak Professional for FreeBASIC

This is a **work-in-progress project**. One of the desired goals with this project is to rewrite as much functionality as possible leveraging FB directly; meaning avoiding using a separate C/C++ library.

## Progress

| File       |         |   | File       |         |   | File       |         |
| ---------- | ------- | - | ---------- | ------- | - | ---------- | ------- |
|AMENU.BAS   |         |   |APRINT.BAS  |         |   |APRINTT.BAS |         |
|ASCCHART.BAS|         |   |ASCIIPIK.BAS|         |   |ASSEMBLY.BAS|         |
|BCOPYT.BAS  |         |   |BIGPRINT.BAS|         |   |BITS.BAS    | EXE     |
|BLPRINT.BAS |         |   |BPRINT.BAS  |         |   |CALC.BAS    |         |
|CALENDAR.BAS|         |   |CAPNUM.BAS  |         |   |CLEARSCR.BAS|         |
|COLORPIK.BAS|         |   |COLORS.BAS  |         |   |COMPARE.BAS |         |
|DATA.BAS    |         |   |DATE2DAY.BAS|         |   |DATEIN.BAS  |         |
|DAYNAME.BAS |         |   |DECLARE.BAS |         |   |DEFCNF.BI   |         |
|DEMO123.BAS |         |   |DEMOCM.BAS  |         |   |DEMOCOMP.BAS|         |
|DEMOCOPY.BAS|         |   |DEMOCRPT.BAS|         |   |DEMODATE.BAS|         |
|DEMODIA2.BAS|         |   |DEMODIAL.BAS|         |   |DEMODIAP.BAS|         |
|DEMOEDIT.BAS|         |   |DEMOEMS.BAS |         |   |DEMOEMS2.BAS|         |
|DEMOEVAL.BAS|         |   |DEMOFAST.BAS|         |   |DEMOFC.BAS  |         |
|DEMOGAS.BAS |         |   |DEMOIN.BAS  |         |   |DEMOLTS.BAS |         |
|DEMOMAIN.BAS|         |   |DEMOMASK.BAS|         |   |DEMOMENU.BAS|         |
|DEMOMGR.BAS |         |   |DEMOPICK.BAS|         |   |DEMOPLMS.BAS|         |
|DEMOPOP.BAS |         |   |DEMOPULL.BAS|         |   |DEMORK.BAS  |         |
|DEMOSCAN.BAS|         |   |DEMOSCRL.BAS|         |   |DEMOSECT.BAS|         |
|DEMOSORT.BAS|         |   |DEMOSS.BAS  |         |   |DEMOSTR.BAS |         |
|DEMOTSRT.BAS|         |   |DEMOVERT.BAS|         |   |DEMOVIEW.BAS|         |
|DEMOVRTT.BAS|         |   |DEMOXMS.BAS |         |   |DIALOG.BAS  |         |
|DIRTREE.BAS |         |   |DISKINFO.BAS|         |   |EDIT.BAS    |         |
|EGABSAVE.BAS|         |   |EVALUATE.BAS|         |   |EXENAME.BAS |         |
|EXIST.BAS   |         |   |FAPPEND.BAS |         |   |FASTFILE.BAS|         |
|FGETAH.BAS  |         |   |FGETR.BAS   |         |   |FGETRT.BAS  |         |
|FILECOMP.BAS|         |   |FILECOPY.BAS|         |   |FILECRPT.BAS|         |
|FILEINFO.BAS|         |   |FILESORT.BAS|         |   |FILEVIEW.BAS|         |
|FILL.BAS    | EXE     |   |FILLSCRN.BAS|         |   |FIND.BAS    | EXE     |
|FINDLAST.BAS|         |   |FINDT.BAS   | EXE     |   |FLINPUT.BAS |         |
|FLUSH.BAS   |         |   |FNOTHER.BAS |         |   |FNSPREAD.BAS|         |
|FORMAT.BAS  |         |   |FULLNAME.BAS|         |   |GASGAUGE.BAS|         |
|GET1STR.BAS |         |   |GETATTR.BAS |         |   |GETCMOS.BAS |         |
|GETCOLOR.BAS|         |   |GETDIR.BAS  |         |   |GETEQUIP.BAS|         |
|GETVMODE.BAS|         |   |GRAFCURS.BAS|         |   |HAND2NAM.BAS|         |
|HCOPY.BAS   |         |   |HUGE.BAS    |         |   |IMINMAX.BAS | EXE     |
|INCOUNT.BAS |         |   |INSERT.BAS  | EXE     |   |INSERTT.BAS |         |
|INSTALL.BAS |         |   |INSTAT.BAS  |         |   |INSTRTBL.BAS|         |
|ISORTI.BAS  |         |   |ISORTI2.BAS |         |   |ISORTSTR.BAS| EXE     |
|ISORTT.BAS  | EXE*    |   |KEYDOWN.BAS |         |   |KEYS.BAS    |         |
|KEYSORT.BAS | EXE*    |   |KEYSTAT.BAS |         |   |LINCOUNT.BAS|         |
|LOADEXEC.BAS|         |   |LOCKFILE.BAS|         |   |LONGSTR.BAS |         |
|LTS2MENU.BAS|         |   |LTSMENU.BAS |         |   |MAINMENU.BAS|         |
|MAKEQLB.BAS |         |   |MARQUEE.BAS |         |   |MASKIN.BAS  |         |
|MIDSTRSR.BAS|         |   |MINMAX.BAS  |         |   |MONITOR.BAS |         |
|MOUSE.BAS   |         |   |MOUSECM.BAS |         |   |MPREST.BAS  |         |
|MRANGE.BAS  |         |   |MRANGEG.BAS |         |   |MSGBOX.BAS  |         |
|NUMIN.BAS   |         |   |PAINTBOX.BAS|         |   |PARSE.BAS   |         |
|PARSESTR.BAS|         |   |PAUSE3.BAS  |         |   |PICKLIST.BAS|         |
|PRO.BAS     | PRO.LIB |   |PRO.BI      | PRO.LIB |   |PRTSC.BAS   |         |
|PULLDNMS.BAS|         |   |PULLDOWN.BAS|         |   |PUTVOL.BAS  |         |
|QD.BAS      |         |   |QEDIT.BAS   |         |   |QEDIT7.BAS  |         |
|QEDITS.BAS  |         |   |QEDITYPE.BI |         |   |QINSTR.BAS  |         |
|QINSTRH.BAS |         |   |QPLEFT.BAS  |         |   |QPSOLVER.BAS|         |
|QPSOUND.BAS |         |   |QPTRIM.BAS  |         |   |QSORT.BAS   |         |
|READDIRS.BAS|         |   |READDIRT.BAS|         |   |READFILE.BAS|         |
|READFILI.BAS|         |   |READFILT.BAS|         |   |READFILX.BAS|         |
|READSECT.BAS|         |   |REPLACE.BAS |         |   |RPTKEY.BAS  |         |
|RWTEST.BAS  |         |   |SCANFILE.BAS|         |   |SCIFORM.BAS |         |
|SCRNDUMP.BAS|         |   |SCRNSR.BAS  |         |   |SCROLL.BAS  |         |
|SCROLLIN.BAS|         |   |SEARCH.BAS  | EXE     |   |SEQUENCE.BAS|         |
|SETATTR.BAS |         |   |SETCNF.BI   |         |   |SHIFT.BAS   |         |
|SORTI.BAS   |         |   |SORTSTR.BAS | EXE     |   |SORTT.BAS   | EXE*    |
|SOUNDEX.BAS |         |   |SPELLNUM.BAS|         |   |SPLITNAM.BAS|         |
|SPREAD.BAS  |         |   |SRCHPATH.BAS|         |   |STRREST.BAS |         |
|STUFFBUF.BAS|         |   |TEST.BAS    |         |   |TEXTIN.BAS  |         |
|TEXTSORT.BAS|         |   |TIME.BAS    |         |   |TRANSLAT.BAS|         |
|UNIQUE.BAS  |         |   |VALID.BAS   |         |   |VERTMENT.BAS|         |
|VERTMENU.BAS|         |   |VIEWFILE.BAS|         |   |VIRTUAL.BAS |         |
|VLONG.BAS   |         |   |WEEKDAY.BAS |         |   |WINDOMGR.BAS|         |
|WINDOW.BAS  |         |   |WIPES.BAS   |         |   |WORDWRAP.BAS|         |
|YESNOB.BAS  |         |   |            |         |   |            |         |

Files marked with *INCLUDE* are meant to be included, while files marked as *EXE* are to be compiled as an executable (stand-alone example). The replacement of the PRO.LIB functionality is implemented in the *PRO.BAS* and *PRO.BI* source files. (Files marked with *N/A* are either hardware specific and/or simply "not possible" with the current release of FB. If you disagree, please discuss. Items marked with an asterisks *most likely need additional testing/improvements*.)

## Future Possibility

Given the flexibility of FB, the thought has crossed my mind that the FB edition *might* be something that could be utilized with QB64; will explore this more once the FB edition is *more complete*.

Placing a few links here for me to explore things a bit further as the project continues to grow:

- [EXTERN...END EXTERN](https://www.freebasic.net/wiki/KeyPgExternBlock)
- [Creating FB bindings for C libraries](https://www.freebasic.net/wiki/DevBindingCreation)
- [QB64.com C-Libraries](https://qb64.com/wiki/C-Libraries)
