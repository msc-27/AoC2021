DIM shellgap%(6)
FOR I%=0 TO 6: READ shellgap%(I%): NEXT
DATA 1,4,9,20,46,103,233: REM Tokuda 1992
MODE 7
PROCbanner
INPUT "Name of input file >" file$
IF file$ <> "" THEN exec = FNexec(file$) ELSE exec = 0
PRINT "Enter positions separated by commas >";
DIM pos%(1000): N%=0
REPEAT
val% = 0
REPEAT
ch$ = GET$: PRINT ch$;
IF ch$ >= "0" AND ch$ <= "9" THEN val% = val% * 10 + VAL(ch$)
UNTIL ch$ < "0" OR ch$ > "9"
pos%(N%) = val%: N%=N%+1
UNTIL ASC(ch$) = 13: VDU 10
PRINT"Sorting..."
PROCsort
median% = pos%(N% DIV 2)
PRINT "Median position = "; median%
part1% = 0
FOR I% = 0 TO N%-1: part1% = part1% + ABS(pos%(I%) - median%): NEXT
vpos = VPOS: PROCtextwnd(FALSE)
PRINT TAB(9,2); "Min. at "; median%; " with cost "; part1%
PROCtextwnd(TRUE): PRINT TAB(0,vpos);
sum% = 0
FOR I% = 0 TO N%-1: sum% = sum% + pos%(I%): NEXT
mean = sum% / N%
@%=&20200: PRINT "Mean position = "; mean: @%=10
minpos% = INT(mean)
part2% = FNpart2(minpos%): try2% = FNpart2(minpos%+1)
IF try2% < part2% THEN part2% = try2%: minpos% = minpos% + 1
vpos = VPOS: PROCtextwnd(FALSE)
PRINT TAB(9,3); "Min. at "; minpos%; " with cost "; part2%
PROCtextwnd(TRUE): PRINT TAB(0,vpos);
END
REM Shellsort
DEF PROCsort
LOCAL step%, off%
FOR step% = 6 TO 0 STEP -1
G% = shellgap%(step%)
IF 2*G% > N% NEXT
FOR off% = 0 TO G%-1
FOR I% = off%+G% TO N%-1 STEP G%
T% = pos%(I%)
FOR J% = I% TO G% STEP -G%
K% = J%
IF pos%(J%-G%) > T% THEN pos%(J%) = pos%(J%-G%) ELSE J% = 0
NEXT
IF J% >= 0 THEN pos%(J%) = T% ELSE pos%(K%) = T%
NEXT:NEXT:NEXT
ENDPROC
DEF FNpart2(point%)
LOCAL cost%, dist%
FOR I% = 0 TO N%-1
dist% = ABS(pos%(I%) - point%)
cost% = cost% + (dist% * (dist%+1)) DIV 2
NEXT: =cost%
DEF PROCbanner
VDU 134,141: PRINT "2021/07   The Treachery of Whales"
VDU 134,141: PRINT "2021/07   The Treachery of Whales"
VDU 130: PRINT "Part 1:": VDU 130: PRINT "Part 2:"
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
IF flag VDU 5 ELSE VDU 0
ENDPROC
