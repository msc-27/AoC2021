max_indices%=50
MODE 7
PROCbanner
DIM board 100 * 25: DIM line 100 * 10: DIM won 100
FOR I%=0 TO 999 STEP 4: line!I%=0: NEXT
FOR I%=0 TO 99 STEP 4: won!I%=0: NEXT
DIM index 100 * max_indices% * 2: DIM indpos 100
FOR I%=0 TO 99 STEP 4: indpos!I% = 0: NEXT
DIM row_ind%(24), row_bit%(24), col_ind%(24), col_bit%(24)
FOR I%=0 TO 24
READ row_ind%(I%), row_bit%(I%), col_ind%(I%), col_bit%(I%)
NEXT
DATA 0,1,5,1, 0,2,6,1, 0,4,7,1, 0,8,8,1, 0,16,9,1
DATA 1,1,5,2, 1,2,6,2, 1,4,7,2, 1,8,8,2, 1,16,9,2
DATA 2,1,5,4, 2,2,6,4, 2,4,7,4, 2,8,8,4, 2,16,9,4
DATA 3,1,5,8, 3,2,6,8, 3,4,7,8, 3,8,8,8, 3,16,9,8
DATA 4,1,5,16,4,2,6,16,4,4,7,16,4,8,8,16,4,16,9,16
DIM draws 100: DIM drawn 100
FOR I%=0 TO 99 STEP 4: drawn!I%=0: NEXT
INPUT "Name of input file >" file$
IF file$ <> "" THEN exec = FNexec(file$) ELSE exec = 0
PRINT "Draw list > ";
D%=0
REPEAT
n$=""
REPEAT
ch$=GET$: PRINT ch$;: n$=n$+ch$
UNTIL ch$<"0" OR ch$>"9"
draws?D% = VAL(n$): D%=D%+1
UNTIL ASC(ch$)=13: VDU 10
n_boards%=0: done=FALSE
REPEAT
INPUT "Blank line > " line$
FOR row%=0 TO 4
PRINT "Board "; n_boards%+1; " row "; row%+1;
INPUT " > " line$
IF line$<>"" PROCstore(line$,n_boards%,row%) ELSE done=TRUE: row%=9
NEXT
IF row%=5 THEN n_boards%=n_boards%+1
IF exec THEN IF EOF#exec THEN done=TRUE
UNTIL done
IF n_boards%=0 END
n_won%=0: turn%=-1
REPEAT
turn%=turn%+1: drawn?(draws?turn%) = TRUE
PRINT "Turn "; turn%+1; ": number "; draws?turn%
win% = FNplay(draws?turn%)
IF win%<>-1 AND n_won%=1 PROCreport(win%, draws?turn%, 1)
UNTIL n_won% = n_boards%
PROCreport(win%, draws?turn%, 2)
END
DEF PROCstore(line$,brd%,row%)
LOCAL col%,val%,off%
I%=1
FOR col% = 0 TO 4
val% = VAL(MID$(line$,I%))
board?(brd%*25 + row%*5 + col%) = val%
off% = val% * max_indices%*2 + indpos?val%
index?off% = brd%
index?(off%+1) = row%*5 + col%
indpos?val% = indpos?val% + 2
I% = INSTR(line$," ",I%)
IF I%<>0 THEN REPEAT: I%=I%+1: UNTIL MID$(line$,I%,1)<>" "
NEXT
ENDPROC
DEF FNplay(val%)
LOCAL win%,pos%,brd%,loc%,test%
win%=-1: pos%=0
IF indpos?val%=0 THEN =win%
REPEAT
brd% = index?(val%*100 + pos%)
loc% = index?(val%*100 + pos% + 1)
test%=FALSE
IF won?brd%=0 THEN test% = FNmark(brd%,loc%)
IF test% THEN win%=brd%: won?brd%=TRUE: n_won%=n_won%+1
IF test% PRINT "Board ";brd%+1; " won."
pos%=pos%+2
UNTIL pos% = indpos?val%
=win%
DEF FNmark(brd%,loc%)
LOCAL ind%,bit%
ind% = row_ind%(loc%) + brd%*10
bit% = row_bit%(loc%)
line?ind% = line?ind% OR bit%
IF line?ind% = 31 THEN =TRUE
ind% = col_ind%(loc%) + brd%*10
bit% = col_bit%(loc%)
line?ind% = line?ind% OR bit%
IF line?ind% = 31 THEN =TRUE
=FALSE
DEF PROCreport(brd%,val%,part)
LOCAL vpos: vpos=VPOS: PROCtextwnd(FALSE)
PRINT TAB(0, part+1);: VDU 131-part
PRINT "Board ";brd%+1; " wins ";
IF part=1 PRINT "first"; ELSE PRINT "last";
PRINT " with score "; FNscore(brd%)*val%
PROCtextwnd(TRUE): PRINT TAB(0,vpos);
ENDPROC
DEF FNscore(brd%)
LOCAL score%,val%: score%=0
FOR I%=brd%*25 TO brd%*25+24
val% = board?I%
IF drawn?val%=0 THEN score% = score% + val%
NEXT
=score%
DEF PROCbanner
FOR I%=1 TO 2
VDU 129,157,131,141: PRINT "2021/04       Giant Squid"
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
