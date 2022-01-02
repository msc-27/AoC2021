MODE 7
PROCbanner
INPUT "Name of input file >" file$
IF file$ <> "" THEN exec = FNexec(file$) ELSE exec = 0
DIM num%(1000), cpy%(1000), freq%(31)
n=0: len=0
REPEAT
PRINT n+1;: INPUT "> " line$
IF line$ <> "" PROCstore
UNTIL FNend_input
IF n=0 END
gam=0: eps=0
FOR I% = 1 TO len
gam = gam * 2: eps = eps * 2
IF freq%(I%) > n/2 THEN gam=gam+1 ELSE eps=eps+1
NEXT
PRINT "gamma = ";gam;"  epsilon = ";eps
vpos=VPOS: PROCtextwnd(FALSE)
PRINT TAB(0,2);CHR$(130);"Power consumption = ";gam * eps
PROCtextwnd(TRUE): PRINT TAB(0,vpos);
PRINT "Finding oxygen rating..."
oxy = FNfind(TRUE)
PRINT "Oxygen rating = ";oxy
PRINT "Finding CO2 scrubber rating..."
co2 = FNfind(FALSE)
PRINT "CO2 scrubber rating = ";co2
vpos=VPOS: PROCtextwnd(FALSE)
PRINT TAB(0,3);CHR$(130);"Life support rating = ";oxy * co2
PROCtextwnd(TRUE): PRINT TAB(0,vpos);
END
DEF FNend_input: IF exec THEN =EOF#exec ELSE =(line$ = "")
DEF PROCstore
V%=0: n=n+1
IF len=0 THEN len = LEN(line$)
FOR I% = 1 TO len
V%=V%*2
IF MID$(line$,I%,1) = "1" THEN V%=V%+1: freq%(I%) = freq%(I%) + 1
NEXT
num%(n) = V%
ENDPROC
DEF FNfind(cond%)
FOR I% = 1 TO n: cpy%(I%)=num%(I%): NEXT
c1 = freq%(1)
cand%=n: pow% = 2 ^ (len-1)
REPEAT
PRINT "Candidates remaining: ";cand%
IF c1 >= cand%/2 THEN m%=pow% ELSE m%=0
c1=0: cand2%=0
npow% = pow% DIV 2
FOR I% = 1 TO cand%
IF ((cpy%(I%) AND pow%) = m%) = cond% PROCadd_cand
NEXT
cand% = cand2%: pow% = npow%
UNTIL cand% = 1
=cpy%(1)
DEF PROCadd_cand
cand2% = cand2% + 1: cpy%(cand2%) = cpy%(I%)
IF (cpy%(I%) AND npow%) THEN c1=c1+1
ENDPROC
DEF PROCbanner
FOR I%=1 TO 2
VDU 135,157,129,141: PRINT "2021/03    Binary Diagnostic"
NEXT: PROCtextwnd(TRUE)
ENDPROC
DEF FNexec(file$)
LOCAL cmd$,cmd%: cmd$ = "EXEC "+file$ 
DIM cmd% LEN(cmd$): $cmd% = cmd$
X% = cmd% MOD &100: Y% = cmd% DIV &100: CALL &FFF7
Y%=&FF: X%=0: A%=&C6: =(USR(&FFF4) AND &FF00) DIV &100
DEF PROCtextwnd(flag)
VDU 28,0,24,39: IF flag VDU 5 ELSE VDU 0
ENDPROC
