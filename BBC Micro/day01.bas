MODE 7
PROCbanner
INPUT "Source filename >" file$
IF file$ <> "" THEN PROCexec(file$)
n=0: prev1=0: prev2=0: prev3=0
count1=0: count2=0
REPEAT
n=n+1
PRINT n;:INPUT" >" depth
IF n>1 AND depth>prev1 THEN count1=count1+1
IF n>3 AND depth>prev3 THEN count2=count2+1
PROCreport
prev3=prev2
prev2=prev1
prev1=depth
UNTIL FALSE
DEF PROCreport
LOCAL vpos%: vpos%=VPOS: PROCtextwnd(FALSE)
PRINT TAB(0,2);"Part 1: ";count1
PRINT TAB(0,3);"Part 2: ";count2
PROCtextwnd(TRUE): PRINT TAB(0,vpos%);
ENDPROC
DEF PROCbanner
VDU 135,157,129,141: PRINT "2021/01       Sonar Sweep"
VDU 135,157,129,141: PRINT "2021/01       Sonar Sweep"
PROCtextwnd(TRUE)
ENDPROC
DEF PROCexec(file$)
LOCAL cmd$,cmd%: cmd$ = "EXEC "+file$
DIM cmd% LEN(cmd$): $cmd% = cmd$
X% = cmd% MOD &100: Y% = cmd% DIV &100: CALL &FFF7
ENDPROC
DEF PROCtextwnd(switch%)
VDU 28,0,24,39
IF switch% VDU 5 ELSE VDU 0
ENDPROC
