MODE 7
PROCbanner: PROCasm_add64: PROCasm_print_u64
DIM count 10*8-1: DIM sum 7: REM storage for 64-bit integers
FOR I%=0 TO 79 STEP 4: count!I%=0: NEXT
INPUT "Name of input file >" name$
IF name$<>"" PROCexec(name$)
PRINT "Enter fish timers separated by commas."
REPEAT
ch$=GET$: PRINT ch$;
ind=VAL(ch$)*8: count!ind = count!ind + 1
ch$=GET$: PRINT ch$;
UNTIL ASC(ch$)=13: VDU 10
FOR iter = 1 TO 80: PROCiter: NEXT: PROCreport(1,80)
FOR iter = 81 TO 256: PROCiter: NEXT: PROCreport(2,256)
END
DEF PROCiter
REM add new fish: count(9) = count(0)
count!72 = count!0: count!76 = count!4
REM reset the zero fish: count(7) += count(0)
CALL add64, count?56, count?0
REM next iteration: shift counts
FOR I% = 0 TO 68 STEP 4: count!I% = count!(I%+8): NEXT
IF iter MOD 10 = 0 PROCstatus
ENDPROC
DEF PROCprint_sum
sum!0 = count!0: sum!4 = count!4
FOR I%=8 TO 64 STEP 8: CALL add64, ?sum, count?I%: NEXT
CALL print_u64, ?sum
ENDPROC
DEF PROCstatus
PRINT "After ";SPC(3-LEN(STR$(iter)));iter;" days: ";
PROCprint_sum:PRINT " fish"
ENDPROC
DEF PROCreport(part,days)
LOCAL vpos: vpos=VPOS: PROCtextwnd(FALSE)
PRINT TAB(0,1+part);"Population after ";days;" days: ";:PROCprint_sum
PROCtextwnd(TRUE): PRINT TAB(0,vpos);
ENDPROC
DEF PROCbanner
VDU 141,132,157,131: PRINT "2021/06      Lanternfish"
VDU 141,132,157,131: PRINT "2021/06      Lanternfish"
PROCtextwnd(TRUE)
ENDPROC
DEF PROCtextwnd(flag)
VDU 28,0,24,39: IF flag VDU 5 ELSE VDU 0
ENDPROC
DEF PROCasm_add64
dst=&80: src=&82: DIM code 35
FOR I% = 0 TO 2 STEP 2
P% = code
[OPT I%
.add64
LDA &601:STA dst:LDA &602:STA dst+1
LDA &604:STA src:LDA &605:STA src+1
LDY #0:LDX #8:CLC
.loop LDA (dst),Y:ADC (src),Y:STA (dst),Y:INY:DEX:BNE loop:RTS
] NEXT
ENDPROC
DEF PROCasm_print_u64
DIM code 258
ptr=&80:lkptr=&82:val=&70:ldz=&7D:dgt=&7E:ctr=&7F
FOR I% = 0 TO 2 STEP 2
P%=code
[ OPT I%
.lkup
EQUD &89E80000:EQUD &8AC72304:EQUD &A7640000:EQUD &DE0B6B3
EQUD &5D8A0000:EQUD &1634578:EQUD &6FC10000:EQUD &2386F2
EQUD &A4C68000:EQUD &38D7E:EQUD &107A4000:EQUD &5AF3
EQUD &4E72A000:EQUD &918:EQUD &D4A51000:EQUD &E8
EQUD &4876E800:EQUD &17:EQUD &540BE400:EQUD 2
EQUD &3B9ACA00:EQUD 0:EQUD &5F5E100:EQUD 0
EQUD &989680:EQUD 0:EQUD &F4240:EQUD 0
EQUD 100000:EQUD 0:EQUD 10000:EQUD 0
EQUD 1000:EQUD 0:EQUD 100:EQUD 0:EQUD 10:EQUD 0
.print_u64
LDA &601:STA ptr:LDA &602:STA ptr+1
LDA #lkup MOD &100:STA lkptr:LDA #lkup DIV &100:STA lkptr+1
LDY #7:.copy LDA (ptr),Y:STA val,Y:DEY:BPL copy
STY ldz:LDA #19:STA ctr
.digit LDA #0:STA dgt
.find LDY #7
.comp LDA val,Y:CMP (lkptr),Y:BCC found:BNE sub:DEY:BPL comp
.sub LDY #0:LDX #8
.sub2 LDA val,Y:SBC (lkptr),Y
STA val,Y:INY:DEX:BNE sub2:INC dgt:BPL find
.found LDA dgt:BNE print:LDX ldz:BMI skip
.print INC ldz:ORA #&30:JSR &FFEE
.skip LDA lkptr:CLC:ADC #8:STA lkptr:BCC next:INC lkptr+1
.next LDA val:DEC ctr:BEQ print:BPL digit:RTS
] NEXT
ENDPROC
DEF PROCexec(file$)
LOCAL cmd$,cmd%: cmd$ = "EXEC "+file$
DIM cmd% LEN(cmd$): $cmd% = cmd$
X% = cmd% MOD &100: Y% = cmd% DIV &100: CALL &FFF7
ENDPROC
