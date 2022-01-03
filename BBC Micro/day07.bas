MODE 7: PROCbanner
INPUT "Name of input file >" f$
IF f$<>"" THEN exec=FNexec(f$) ELSE exec=0
PRINT "Enter positions separated by commas >";
DIM pos%(1000): N%=0
REPEAT: val%=0
REPEAT: ch$=GET$: PRINT ch$;
IF ch$>="0" AND ch$<="9" THEN val%=val%*10+VAL(ch$)
UNTIL ch$<"0" OR ch$>"9"
pos%(N%)=val%: N%=N%+1
UNTIL ASC(ch$)=13: VDU 10: IF exec THEN *EXEC
med%=FNmedian: PRINT "Median position = ";med%
prt1%=0: sum%=0: FOR I%=0 TO N%-1
prt1%=prt1%+ABS(pos%(I%)-med%): sum%=sum%+pos%(I%): NEXT
vpos=VPOS: PROCtextwnd(FALSE)
PRINT TAB(9,2);"Min. at ";med%;" with cost ";prt1%
PROCtextwnd(TRUE): PRINT TAB(0,vpos);
mean=sum% / N%: @%=&20200: PRINT "Mean position = ";mean: @%=10
min%=INT(mean): prt2%=FNpart2(min%): try2%=FNpart2(min%+1)
IF try2% < prt2% THEN prt2%=try2%: min%=min%+1
vpos=VPOS: PROCtextwnd(FALSE)
PRINT TAB(9,3);"Min. at ";min%;" with cost ";prt2%
PROCtextwnd(TRUE): PRINT TAB(0,vpos);:END
DEF FNmedian
LOCAL a%,b%,piv%: a%=0: b%=N%-1
REPEAT: piv%=FNpiv(a%,b%)
IF piv% < N% DIV 2 THEN a%=piv%+1
IF piv% > N% DIV 2 THEN b%=piv%-1
UNTIL piv%=N% DIV 2: =pos%(piv%)
DEF FNpiv(a%,b%)
IF a%=b% THEN =a%
LOCAL val%,ptr%: val%=pos%(b%): ptr%=a%
FOR I%=a% TO b%-1
IF pos%(I%) < val% THEN T%=pos%(I%): pos%(I%)=pos%(ptr%): pos%(ptr%)=T%: ptr%=ptr%+1
NEXT
pos%(b%)=pos%(ptr%): pos%(ptr%)=val%: =ptr%
DEF FNpart2(p%)
LOCAL cst%,dst%: FOR I%=0 TO N%-1
dst%=ABS(pos%(I%)-p%): cst%=cst%+(dst%*(dst%+1)) DIV 2
NEXT: =cst%
DEF PROCbanner
FOR I%=1 TO 2
VDU 134,141: PRINT "2021/07   The Treachery of Whales": NEXT
VDU 130: PRINT "Part 1:": VDU 130: PRINT "Part 2:"
PROCtextwnd(TRUE)
ENDPROC
DEF FNexec(f$)
LOCAL cmd$,cmd: cmd$="EXEC "+f$
DIM cmd LEN(cmd$): $cmd=cmd$
X%=cmd MOD &100: Y%=cmd DIV &100: CALL &FFF7
Y%=&FF: X%=0: A%=&C6: =(USR(&FFF4) AND &FF00) DIV &100
ENDPROC
DEF PROCtextwnd(f)
VDU 28,0,24,39: IF f VDU 5 ELSE VDU 0
ENDPROC
