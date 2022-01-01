DIM part2 100*8-1: n2%=0: REM 100 64-bit integers
DIM score 7: REM accumulator for part 2
DIM stack 255
DIM p1%(4): p1%(0)=0: p1%(1)=3: p1%(2)=57: p1%(3)=1197: p1%(4)=25137
PROCasm_accum: PROCasm_partition: PROCasm_print_u64
use_asm=TRUE: REM fast parsing routine
IF use_asm PROCasm_parse
MODE 3: PROCbanner
INPUT "Name of input file >" file$
IF file$ <> "" THEN exec = FNexec(file$) ELSE exec = 0
N%=0: part1% = 0: line$ = STRING$(255," ")
REPEAT
N%=N%+1: PRINT ;N%;: INPUT LINE ": " line$
IF line$ <> "" PROCprocess
UNTIL FNend_input
PROCmedian
vpos=VPOS: PROCtextwnd(FALSE)
PRINT TAB(25,3);: CALL print_u64, ?score
PROCtextwnd(TRUE): PRINT TAB(0,vpos);
END
DEF FNend_input: IF exec THEN =EOF#exec ELSE =(line$ = "")
DEF PROCprocess
LOCAL score%: score% = FNparse
IF score% THEN PROCpart1(score%) ELSE PROCpart2
ENDPROC
DEF FNparse
LOCAL ch%,corr%: corr%=0: stk_ptr%=0
IF use_asm CALL parse, line$, stk_ptr%, corr%: =p1%(corr%)
FOR I% = 1 TO LEN(line$): ch% = ASC(MID$(line$,I%))
IF ch%=40 OR ch%=60 OR ch%=91 OR ch%=123 PROCpush(ch%)
IF ch%=41 IF FNpop <> 40 THEN corr%=1: I%=255
IF ch%=62 IF FNpop <> 60 THEN corr%=4: I%=255
IF ch%=93 IF FNpop <> 91 THEN corr%=2: I%=255
IF ch%=125 IF FNpop <> 123 THEN corr%=3: I%=255
NEXT: =p1%(corr%)
DEF PROCpush(n%)
stack?stk_ptr% = n%: stk_ptr% = stk_ptr% + 1
ENDPROC
DEF FNpop
IF stk_ptr% = 0 THEN =0
stk_ptr% = stk_ptr% - 1: =stack?stk_ptr%
DEF PROCpart1(score%)
PRINT "Corrupted: score "; score%
vpos=VPOS: PROCtextwnd(FALSE)
part1% = part1% + score%: PRINT TAB(19,2); part1%
PROCtextwnd(TRUE): PRINT TAB(0,vpos);
ENDPROC
DEF PROCpart2
LOCAL ch%: score!0 = 0: score!4 = 0
REPEAT: ch% = FNpop
IF ch%=40 THEN A%=1
IF ch%=60 THEN A%=4
IF ch%=91 THEN A%=2
IF ch%=123 THEN A%=3
IF ch% THEN Z% = USR(accum_score)
UNTIL ch%=0
part2!(n2%*8) = score!0: part2!(n2%*8+4) = score!4: n2%=n2%+1
PRINT "Incomplete: score ";: CALL print_u64, ?score: PRINT
ENDPROC
DEF PROCmedian: REM put median of part2 in score
LOCAL med: med = part2 + (n2% DIV 2)*8
!lft = part2: !rght = part2 + (n2%-1)*8
REPEAT: CALL partition: piv = !dst AND &FFFF
IF piv < med THEN !lft = piv+8
IF piv > med THEN !rght = piv-8
UNTIL piv = med
score!0 = piv!0: score!4 = piv!4
ENDPROC
DEF PROCbanner
COLOUR 129: COLOUR 0: PRINT "2021/10";SPC(29);"Syntax Scoring";SPC(30)
COLOUR 128: COLOUR 1: PRINT"Total error score: "
PRINT"Middle completion score: "
PROCtextwnd(TRUE)
ENDPROC
DEF FNexec(file$)
LOCAL cmd$,cmd%: cmd$ = "EXEC "+file$
DIM cmd% LEN(cmd$): $cmd% = cmd$
X% = cmd% MOD &100: Y% = cmd% DIV &100: CALL &FFF7
Y%=&FF: X%=0: A%=&C6: =(USR(&FFF4) AND &FF00) DIV &100
DEF PROCtextwnd(flag)
VDU 28,0,24,79: IF flag VDU 5 ELSE VDU 0
ENDPROC
DEF PROCasm_accum
cpy=&70: DIM code 55
FOR I%=0 TO 2 STEP 2: P%=code: [ OPT I%
.accum_score \ calc. score*5+A
CLC:ADC score:STA cpy:LDY #7:LDX #1
.copy LDA score,X:ADC #0:STA cpy,X:INX:DEY:BNE copy \ cpy = score + A
LDA #&FE: .mul4 LDY #8:LDX #0
.mul2 ROL score,X:INX:DEY:BNE mul2:ADC #1:BNE mul4 \ score = score*4
CLC:LDY #8:LDX #0
.add LDA score,X:ADC cpy,X:STA score,X:INX:DEY:BNE add:RTS
] NEXT
ENDPROC
DEF PROCasm_partition: REM main function for median search
lft=&80:rght=&84:src=&88:dst=&8A
DIM code 97: FOR I%=0 TO 2 STEP 2: P%=code: [ OPT I%
.partition \ Pivot around rght; final pivot position in dst
LDA lft+1:STA dst+1:STA src+1:LDA lft:STA dst:STA src
CMP rght:BNE part_main:LDA lft+1:CMP rght+1:BEQ ret
.part_main LDY #7
.cmp LDA (src),Y:CMP (rght),Y:BCC swap:BNE next:DEY:BPL cmp
.swap LDY #7: .swap1 LDA (src),Y:TAX:LDA (dst),Y:STA (src),Y
TXA:STA (dst),Y:DEY:BPL swap1
LDA dst:CLC:ADC #8:STA dst:BCC next:INC dst+1
.next LDA src:CLC:ADC #8:STA src:BCC next1:INC src+1
.next1 CMP rght:BNE part_main:LDA src+1:CMP rght+1:BNE part_main
LDY #7: .swap_piv LDA (rght),Y:TAX:LDA (dst),Y:STA (rght),Y
TXA:STA (dst),Y:DEY:BPL swap_piv: .ret RTS
] NEXT
ENDPROC
DEF PROCasm_parse
vptr=&80:sptr=&82:len=&70:index=&71
DIM code 142: FOR I%=0 TO 2 STEP 2: P%=code: [ OPT I%
.parse LDA &601:STA vptr:LDA &602:STA vptr+1
LDY #0:LDA (vptr),Y:STA sptr:INY:LDA (vptr),Y:STA sptr+1
INY:INY:LDA (vptr),Y:STA len
LDA &607:STA vptr:LDA &608:STA vptr+1:LDX #0:LDY #0
.char LDA (sptr),Y:STY index
CMP #40:BEQ push:CMP #60:BEQ push:CMP #91:BEQ push:CMP #123:BNE close
.push STA stack,X:INX:BNE next
.close TAY:DEX:LDA stack,X
CPY #41:BNE close2:CMP #40:BEQ next:LDA #1:BNE end
.close2 CPY #62:BNE close3:CMP #60:BEQ next:LDA #4:BNE end
.close3 CPY #93:BNE close4:CMP #91:BEQ next:LDA #2:BNE end
.close4 CMP #123:BEQ next:LDA #3:BNE end
.next LDY index:INY:CPY len:BNE char:LDA #0
.end LDY #0:STA (vptr),Y
LDA &604:STA vptr:LDA &605:STA vptr+1:TXA:STA (vptr),Y:RTS
] NEXT
ENDPROC
DEF PROCasm_print_u64
DIM code 258
ptr=&80:lkptr=&82:val=&70:ldz=&7D:dgt=&7E:ctr=&7F
FOR I%=0 TO 2 STEP 2: P%=code: [ OPT I%
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
