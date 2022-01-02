V%=FALSE
MODE 7: PROCbanner
DIM basin_size%(3), basin_off%(3)
FOR I%=0 TO 2: basin_size%(I%) = 1: basin_off%(I%) = 0: NEXT
DIM cave% 102*102-1
DIM set1% 200: DIM set2% 200: REM fringe sets for BFS
INPUT "Visual solution? (Y/N) >" vis$
IF ASC(vis$) = ASC("Y") OR ASC(vis$) = ASC("y") V% = TRUE
INPUT "Name of input file >" file$
IF file$ <> "" THEN exec = FNexec(file$) ELSE exec = 0
N%=0
REPEAT
PRINT N%+1;: INPUT "> " line$
IF line$ <> "" PROCstore
UNTIL FNend_input
height% = N%
FOR I%=1 TO width%: cave%?I% = 9: NEXT
FOR I%=(height%+1)*(width%+2)+1 TO (height%+2)*(width%+2)-2: cave%?I% = 9: NEXT
IF V% MODE 5: PROCvis_setup
risk% = 0
FOR O% = width%+3 TO (height%+1)*(width%+2)-2
IF cave%?O% <> 9 PROCtest
NEXT
END
DEF FNend_input: IF exec THEN =EOF#exec ELSE =(line$ = "")
DEF PROCstore
N%=N%+1
width% = LEN(line$): O% = N% * (width%+2)
cave%?O% = 9
FOR I%=1 TO width%: cave%?(O%+I%) = VAL(MID$(line$,I%,1)): NEXT
cave%?(O%+width%+1) = 9
ENDPROC
DEF PROCtest
LOCAL h%: h% = cave%?O%
IF cave%?(O%-1) <= h% ENDPROC
IF cave%?(O%+1) <= h% ENDPROC
IF cave%?(O%-width%-2) <= h% ENDPROC
IF cave%?(O%+width%+2) <= h% ENDPROC
Y%=O% DIV (width%+2) - 1: X%=O% MOD (width%+2) - 1
PRINT "(";X%;",";Y%;") "; cave%?O% + 1; " size ";
IF V% PLOT 69, X%*8, (height%-1-Y%)*8: PLOT 65,0,4
risk% = risk% + cave%?O% + 1
LOCAL count%, n_fringe%, fringe%, newset%, cell%
count%=0: n_fringe%=1: fringe% = set1%: newset% = set2%
!fringe% = O%: cave%?O% = 9
REPEAT
count% = count% + n_fringe%: N%=0
FOR cell% = 0 TO (n_fringe%-1)*2 STEP 2
P% = fringe%!cell% AND &FFFF
IF cave%?(P%-1) < 9 PROCexpand(newset%,P%-1,10)
IF cave%?(P%+1) < 9 PROCexpand(newset%,P%+1,10)
IF cave%?(P%-width%-2) < 9 PROCexpand(newset%,P%-width%-2,10)
IF cave%?(P%+width%+2) < 9 PROCexpand(newset%,P%+width%+2,10)
NEXT
n_fringe% = N%: T% = fringe%: fringe% = newset%: newset% = T%
UNTIL n_fringe% = 0
PRINT ;count%
PROCreport_risk
IF count% > basin_size%(2) PROCbasin(count%)
ENDPROC
DEF PROCexpand(set%,off%,new%)
cave%?off% = new%: set%!(N%*2) = off%: N%=N%+1
IF NOT V% ENDPROC
X% = ((off% MOD (width%+2)) - 1) * 8
Y% = (height% - off% DIV (width%+2)) * 8
PLOT 71,X%,Y%: PLOT 67,0,4
ENDPROC
DEF PROCbasin(count%)
PROCinsert(2, count%)
IF count% > basin_size%(1) PROCinsert(1, count%)
IF count% > basin_size%(0) PROCinsert(0, count%)
PROCreport_basins
IF NOT V% ENDPROC
IF basin_off%(3) PROCrepaint(basin_off%(3), 11, 10)
GCOL 0,130: PROCrepaint(O%, 10, 11): GCOL 0,128
ENDPROC
DEF PROCinsert(pos%, count%)
basin_size%(pos%+1) = basin_size%(pos%)
basin_off%(pos%+1) = basin_off%(pos%)
basin_size%(pos%) = count%: basin_off%(pos%) = O%
ENDPROC
DEF PROCrepaint(off%, old%, new%)
LOCAL count%, n_fringe%, fringe%, newset%, cell%
count%=0: n_fringe%=1: fringe% = set1%: newset% = set2%
!fringe% = off%
REPEAT
count% = count% + n_fringe%: N%=0
FOR cell% = 0 TO (n_fringe%-1)*2 STEP 2
P% = fringe%!cell% AND &FFFF
IF cave%?(P%-1) = old% PROCexpand(newset%,P%-1,new%)
IF cave%?(P%+1) = old% PROCexpand(newset%,P%+1,new%)
IF cave%?(P%-width%-2) = old% PROCexpand(newset%,P%-width%-2,new%)
IF cave%?(P%+width%+2) = old% PROCexpand(newset%,P%+width%+2,new%)
NEXT
n_fringe% = N%: T% = fringe%: fringe% = newset%: newset% = T%
UNTIL n_fringe% = 0
ENDPROC
DEF PROCreport_basins
LOCAL vpos%
vpos% = VPOS: PROCtextwnd(FALSE)
IF V% PRINT TAB(0,2);: ELSE PRINT TAB(0,3);
PRINT ;basin_size%(0);" * ";basin_size%(1);" * ";basin_size%(2)
PRINT "= "; basin_size%(0) * basin_size%(1) * basin_size%(2)
PROCtextwnd(TRUE): PRINT TAB(0,vpos%);
ENDPROC
DEF PROCreport_risk
LOCAL vpos: vpos=VPOS: PROCtextwnd(FALSE)
IF V% PRINT TAB(0,1);: ELSE PRINT TAB(0,2);
PRINT "Total risk: "; risk%
PROCtextwnd(TRUE): PRINT TAB(0,vpos);
ENDPROC
DEF PROCbanner
FOR I%=1 TO 2
VDU 141,129: PRINT "2021/09       Smoke Basin"
NEXT: PROCtextwnd(TRUE)
ENDPROC
DEF PROCvis_setup
VDU 19,2,4;0;: REM colour 2 = blue
COLOUR 1: PRINT "2021/09 Smoke Basin"
COLOUR 3: PROCtextwnd(TRUE)
VDU 24,0;96; width% * 8 - 1; height% * 8 + 95;
VDU 29,0;96;
GCOL 0,129: CLG: GCOL 0,128
ENDPROC
DEF PROCtextwnd(flag)
VDU 28,0: IF V% VDU 31,19 ELSE VDU 24,39
IF NOT flag VDU 0: ENDPROC
IF V% VDU 29 ELSE VDU 6
ENDPROC
DEF FNexec(file$)
LOCAL cmd$,cmd%: cmd$ = "EXEC "+file$
DIM cmd% LEN(cmd$): $cmd% = cmd$
X% = cmd% MOD &100: Y% = cmd% DIV &100: CALL &FFF7
Y%=&FF: X%=0: A%=&C6: =(USR(&FFF4) AND &FF00) DIV &100
