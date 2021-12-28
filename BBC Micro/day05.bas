REM Geometrical approach: find unique intersections of each line with all
REM subsequent lines. Slow but the best I can manage without assembly.
MODE 7
PROCbanner
DIM h_lin 200*12: DIM v_lin 200*12: DIM dn_lin 200*12: DIM up_lin 200*12
REM h_lin stores horizontal lines as y, x1, x2 where x1 < x2
REM v_lin stores vertical lines as x, y1, y2 where y1 < y2
REM dn_lin stores "down" diagonals (NW-SE) as x1, y1, len where x1 < x2
REM up_lin stores "up" diagonals (SW-NE) as x1, y1, len where x1 < x2
h_n%=0: v_n%=0: dn_n%=0: up_n%=0
DIM xect 1000: REM flags for intersection points
INPUT "Name of input file >" file$
IF file$ <> "" exec = FNexec(file$) ELSE exec = 0
N%=0
REPEAT
PRINT N%+1;: INPUT LINE "> " line$
IF line$<>"" PROCstore(line$): N%=N%+1
UNTIL FNend_input
IF N%=0 END
time% = TIME
DIM total%(2): flag%=253
IF h_n% PROCdo_horiz
IF v_n% PROCdo_vert
IF dn_n% PROCdo_down
IF up_n% > 1 PROCdo_up
time% = TIME - time%
PRINT "Elapsed time post-input: ";
PRINT ;time% DIV 6000; "m "; (time% MOD 6000) DIV 100; "s"
END
REM Increment flag value. Reset array if it wraps around.
DEF PROCnext_flag
flag% = flag% + 2: IF flag% < 255 ENDPROC
LOCAL i%
flag% = 1: FOR i% = 0 TO 999 STEP 4: xect!i% = 0: NEXT
ENDPROC
REM For each horizontal line, find unique intersections
REM with all subsequent lines of all types.
REM Store each line's parameters in Y%, X%, W% for use by sub-procedures
DEF PROCdo_horiz
FOR I% = 1 TO h_n%
PROCnext_flag
C%=0: O% = (I%-1) * 12
Y% = h_lin!O%: X% = h_lin!(O%+4): W% = h_lin!(O%+8)
PRINT "Horizontal line "; I%; "/"; h_n%
IF I% < h_n% PROCdo_HH
IF v_n% PROCdo_HV
PRINT C%; " unique H/V intersections"
PROCreport(1)
IF dn_n% PROCdo_HD
IF up_n% PROCdo_HU
PRINT C%; " unique total intersections"
PROCreport(2)
NEXT: ENDPROC
REM Find other horizontal lines with the same Y-value.
DEF PROCdo_HH
FOR J% = I%*12 TO (h_n%-1)*12 STEP 12
IF Y% = h_lin!J% PROCxectHH
NEXT: ENDPROC
REM Check two horizontal lines with matching Y-values for overlap.
DEF PROCxectHH
L% = h_lin!(J%+4): IF X% > L% THEN L% = X%
R% = h_lin!(J%+8): IF W% < R% THEN R% = W%
IF L% > R% ENDPROC
FOR K% = L% TO R%: PROCmark(K%): NEXT
ENDPROC
REM Check a horizontal line for intersections with all vertical lines.
DEF PROCdo_HV
FOR J% = 0 TO (v_n%-1)*12 STEP 12
A% = v_lin!J%
IF A%>=X% AND A%<=W% IF Y%>=v_lin!(J%+4) IF Y%<=v_lin!(J%+8) PROCmark(A%)
NEXT: ENDPROC
REM Check a horizontal line for intersections with all down diagonals.
DEF PROCdo_HD
FOR J% = 0 TO (dn_n%-1)*12 STEP 12
A% = dn_lin!(J%): B% = dn_lin!(J%+4): L% = dn_lin!(J%+8)
IF Y% >= B% AND Y% <= B%+L% THEN D% = A%+Y%-B%: IF D% >= X% AND D% <= W% PROCmark(D%)
NEXT: ENDPROC
REM Check a horizontal line for intersections with all up diagonals.
DEF PROCdo_HU
FOR J% = 0 TO (up_n%-1)*12 STEP 12
A% = up_lin!(J%): B% = up_lin!(J%+4): L% = up_lin!(J%+8)
IF Y% <= B% AND Y% >= B%-L% THEN D% = A%+B%-Y%: IF D% >= X% AND D% <= W% PROCmark(D%)
NEXT: ENDPROC
REM For each vertical line, find unique intersections
REM with all subsequent vertical and diagonal lines.
REM Store each line's parameters in Y%, X%, W% for use by sub-procedures
DEF PROCdo_vert
FOR I% = 1 TO v_n%
PROCnext_flag
C%=0: O% = (I%-1) * 12
X% = v_lin!O%: Y% = v_lin!(O%+4): Z% = v_lin!(O%+8)
PRINT "Vertical line "; I%; "/"; v_n%
IF I% < v_n% PROCdo_VV
PRINT C%; " unique vert. intersections"
PROCreport(1)
IF dn_n% PROCdo_VD
IF up_n% PROCdo_VU
PRINT C%; " unique total intersections"
PROCreport(2)
NEXT: ENDPROC
REM Find other vertical lines with the same X-value.
DEF PROCdo_VV
FOR J% = I%*12 TO (v_n%-1)*12 STEP 12
IF X% = v_lin!J% PROCxectVV
NEXT: ENDPROC
REM Check two vertical lines with matching X-values for overlap.
DEF PROCxectVV
L% = v_lin!(J%+4): IF Y% > L% THEN L% = Y%
R% = v_lin!(J%+8): IF Z% < R% THEN R% = Z%
IF L% > R% ENDPROC
FOR K% = L% TO R%: PROCmark(K%): NEXT
ENDPROC
REM Check a vertical line for intersections with all down diagonals.
DEF PROCdo_VD
FOR J% = 0 TO (dn_n%-1)*12 STEP 12
A% = dn_lin!(J%): B% = dn_lin!(J%+4): L% = dn_lin!(J%+8)
IF X% >= A% AND X% <= A%+L% THEN D% = B%+X%-A%: IF D% >= Y% AND D% <= Z% PROCmark(D%)
NEXT: ENDPROC
REM Check a vertical line for intersections with all up diagonals.
DEF PROCdo_VU
FOR J% = 0 TO (up_n%-1)*12 STEP 12
A% = up_lin!(J%): B% = up_lin!(J%+4): L% = up_lin!(J%+8)
IF X% >= A% AND X% <= A%+L% THEN D% = B%+A%-X%: IF D% >= Y% AND D% <= Z% PROCmark(D%)
NEXT: ENDPROC
REM For each down diagonal, find unique intersections
REM with all subsequent diagonals.
REM Store each line's parameters in X%, Y%, L%, U% for use in sub-procs
REM U% holds the down diagonal's value in the "up" axis (up = x - y)
DEF PROCdo_down
FOR I% = 1 TO dn_n%
PROCnext_flag
C%=0: O% = (I%-1) * 12
X% = dn_lin!O%: Y% = dn_lin!(O%+4): L% = dn_lin!(O%+8)
U% = X% - Y%
PRINT "Down diagonal line "; I%; "/"; dn_n%
IF I% < dn_n% PROCdo_DD
IF up_n% PROCdo_DU
PRINT C%; " unique intersections"
PROCreport(2)
NEXT: ENDPROC
REM Find other down diagonals with the same up-value.
DEF PROCdo_DD
FOR J% = I%*12 TO (dn_n%-1)*12 STEP 12
V% = dn_lin!J% - dn_lin!(J%+4)
IF U% = V% PROCxectDD
NEXT: ENDPROC
REM Check two down diagonals with the same up-value for overlap.
DEF PROCxectDD
A% = dn_lin!J%: B% = A% + dn_lin!(J%+8)
IF X% > A% THEN A% = X%
IF X%+L% < B% THEN B% = X%+L%
IF A% > B% ENDPROC
FOR K% = A% TO B%: PROCmark(K%): NEXT
ENDPROC
REM Check a down diagonal for intersections with all up diagonals.
REM First check to make sure the diagonals have the same "parity".
DEF PROCdo_DU
FOR J% = 0 TO (up_n%-1)*12 STEP 12
A% = up_lin!J%: B% = up_lin!(J%+4): D% = A%+B%
IF ((D% EOR U%) AND 1) = 0 PROCxectDU
NEXT: ENDPROC
REM Check a down and up diagonal with the same "parity" for intersection.
REM Work in transformed coordinates: up = x - y; down = x + y
DEF PROCxectDU
M% = up_lin!(J%+8)
IF U% < A%-B% OR U% > A%-B%+M%+M% ENDPROC
IF D% < X%+Y% OR D% > X%+Y%+L%+L% ENDPROC
PROCmark((U%+D%) DIV 2)
ENDPROC
REM For each up diagonal, find unique intersections
REM with subsequent up diagonals.
REM First check for matching down-values.
DEF PROCdo_up
FOR I% = 1 TO up_n%-1
PROCnext_flag
C%=0: O% = (I%-1) * 12
X% = up_lin!O%: Y% = up_lin!(O%+4): L% = up_lin!(O%+8)
D% = X% + Y%
PRINT "Up diagonal line "; I%; "/"; up_n%
FOR J% = I%*12 TO (up_n%-1)*12 STEP 12
E% = up_lin!J% + up_lin!(J%+4)
IF D% = E% PROCxectUU
NEXT
PRINT C%; " unique intersections"
PROCreport(2)
NEXT: ENDPROC
REM Check two up-diagonals with matching down-values for overlap.
DEF PROCxectUU
A% = up_lin!J%: B% = A% + up_lin!(J%+8)
IF X% > A% THEN A% = X%
IF X%+L% < B% THEN B% = X%+L%
IF A% > B% ENDPROC
FOR K% = A% TO B%: PROCmark(K%): NEXT
ENDPROC
REM Mark an intersection point on the current line, denoted by the
REM X-value of the point, or the Y-value in the case of a vertical line.
REM If not yet flagged, flag it and add one to the count.
REM If already flagged, "overflag" it and subtract one from the count.
REM Such points will be revisited and counted later.
DEF PROCmark(pos%)
IF xect?pos% < flag% THEN xect?pos% = flag%: C%=C%+1: ENDPROC
IF xect?pos% = flag% THEN xect?pos% = flag%+1: C%=C%-1: ENDPROC
ENDPROC
DEF PROCreport(part%)
total%(part%) = total%(part%) + C%
LOCAL vpos: vpos = VPOS: PROCtextwnd(FALSE)
PRINT TAB(9, part%+1); total%(part%)
PROCtextwnd(TRUE): PRINT TAB(0,vpos);
ENDPROC
DEF FNend_input: IF exec THEN =EOF#exec ELSE =(line$="")
DEF PROCstore(line$)
LOCAL x1%,y1%,x2%,y2%
x1%=VAL(line$): I%=INSTR(line$,",")+1
y1%=VAL(MID$(line$,I%)): I%=INSTR(line$,">",I%)+2
x2%=VAL(MID$(line$,I%)): I%=INSTR(line$,",",I%)+1
y2%=VAL(MID$(line$,I%))
IF y1%=y2% PROCstore_orth(h_lin,h_n%,y1%,x1%,x2%): h_n%=h_n%+1: ENDPROC
IF x1%=x2% PROCstore_orth(v_lin,v_n%,x1%,y1%,y2%): v_n%=v_n%+1: ENDPROC
IF x1%>x2% THEN T%=x1%: x1%=x2%: x2%=T%: T%=y1%: y1%=y2%: y2%=T%
IF y1%<=y2% PROCstore_line(dn_lin,dn_n%,x1%,y1%,x2%-x1%): dn_n%=dn_n%+1
IF y1%>y2% PROCstore_line(up_lin,up_n%,x1%,y1%,x2%-x1%): up_n%=up_n%+1
ENDPROC
DEF PROCstore_orth(tab,index%,a%,b%,c%)
IF b% > c% THEN T%=b%: b%=c%: c%=T%
PROCstore_line(tab,index%,a%,b%,c%)
ENDPROC
DEF PROCstore_line(tab,index%,a%,b%,c%)
I% = index% * 12
tab!I% = a%: tab!(I%+4) = b%: tab!(I%+8) = c%
ENDPROC
DEF PROCbanner
VDU 134,157,132,141: PRINT "2021/05   Hydrothermal Venture"
VDU 134,157,132,141: PRINT "2021/05   Hydrothermal Venture"
VDU 130: PRINT "Part 1:"
VDU 130: PRINT "Part 2:"
PROCtextwnd(TRUE)
ENDPROC
DEF FNexec(file$)
LOCAL cmd$,cmd%: cmd$ = "EXEC "+file$
DIM cmd% LEN(cmd$): $cmd% = cmd$
X% = cmd% MOD &100: Y% = cmd% DIV &100: CALL &FFF7
Y%=&FF: X%=0: A%=&C6: =(USR(&FFF4) AND &FF00) DIV &100
ENDPROC
DEF PROCtextwnd(flag)
VDU 28,0,24,39: IF flag VDU 5 ELSE VDU 0
ENDPROC
