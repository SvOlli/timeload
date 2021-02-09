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
   .byte $00,$00,$9e,"2067,"
systxt:
   .byte "00820",$00,$00,$00

main:
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

   lda   #<msgtxt1
   ldy   #>msgtxt1
   jsr   TXTOUT
   lda   #<systxt
   ldy   #>systxt
   jsr   TXTOUT
   lda   #','
   jsr   CHROUT
   lda   #$22
   jsr   CHROUT
   lda   #<msgtxt2
   ldy   #>msgtxt2
   jmp   TXTOUT

msgtxt1:
   .byte $0d,"you can now time your load using",$0d
   .byte "sys ",$00
   
msgtxt2:
   .byte "<filename>",$0d
   .byte "(device is the last used)",$0d,$00

start:
   jsr   CHKCOM
   jsr   FRMEVL
   jsr   FRESTR
   ; A now contains length of string
   ; $22/$23 vector to string
   ldx   $22
   ldy   $23
   jsr   SETNAM
   lda   #$01
   ldx   $ba
   ldy   #$08
   jsr   SETLFS
   lda   #$00
   sta   $DC0B
   sta   $DC0A
   sta   $DC09
   sta   $DC08
   sta   $DC08
   jsr   LOAD
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
   jmp   CHROUT
end:
