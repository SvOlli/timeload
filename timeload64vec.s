LOADVEC   := $0330
NEW       := $A641 
TXTOUT    := $AB1E
FRMNUM    := $AD8A
FRMEVL    := $AD9E
CHKCOM    := $AEFD
FRESTR    := $B6A3
GETADR    := $B7F7
SETLFS    := $FFBA
SETNAM    := $FFBD
CHROUT    := $FFD2
LOAD      := $FFD5

   .word main-2
   .byte $00,$00,$9e,"2067,00820",$00,$00,$00

main:
   lda   LOADVEC+0
   sta   loadcall+1
   lda   LOADVEC+1
   sta   loadcall+2

   jsr   CHKCOM
   jsr   FRMNUM
   jsr   GETADR
   ldy   #$00
:
   lda   start,y
   sta   ($14),y
   iny
   cpy   #<(end-start)
   bne   :-
   
   lda   $14
   sta   LOADVEC+0
   lda   $15
   sta   LOADVEC+1

   lda   #<msg
   ldy   #>msg
   jsr   TXTOUT
   lda   loadcall+2
   jsr   hex2
   lda   loadcall+1
   jsr   hex2
   jmp   NEW

hex2:
   pha
   lsr
   lsr
   lsr
   lsr
   jsr   :+
   pla
   and   #$0f
:
   ora   #$30
   cmp   #$3a
   bcc   :+
   adc   #$06
:
   jmp   CHROUT

msg:
   .byte "timing load @ $",$00

start:
   pha
   lda   #$00
   sta   $DC0B
   sta   $DC0A
   sta   $DC09
   sta   $DC08
   sta   $DC08
   pla
loadcall:
   jsr   $ffff
   php
   sta   $DC0B
   lda   #$0d
   jsr   CHROUT
   lda   $DC0A
   pha
   lsr
   lsr
   lsr
   lsr
   ora   #$30
   jsr   CHROUT
   pla
   and   #$0F
   ora   #$30
   jsr   CHROUT
   lda   #':'
   jsr   CHROUT
   lda   $DC09
   pha
   lsr
   lsr
   lsr
   lsr
   ora   #$30
   jsr   CHROUT
   pla
   and   #$0F
   ora   #$30
   jsr   CHROUT
   lda   #'.'
   jsr   CHROUT
   lda   $DC08
   and   #$0F
   ora   #$30
   jsr   CHROUT
   plp
   rts
end:
