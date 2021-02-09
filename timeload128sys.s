TXTOUT  := $55E2                                                
FRMNUM  := $77D7                                                
FRMEVL  := $77EF
CHKCOM  := $795C
FRESTR  := $877E 
GETADR  := $8815 
SETLFS  := $FFBA
SETNAM  := $FFBD
CHROUT  := $FFD2
LOAD    := $FFD5
SETBNK  := $FF68

   .word main-2
   .byte $00,$00,$9e,"7191,,,,,"
systxt:
   .byte "02816",$00,$00,$00

main:
   lda   #$00
   sta   $ff00  ; set MMU to BASIC/KERNAL/IO Bank 0
   jsr   CHKCOM
   jsr   FRMNUM
   jsr   GETADR
   ldy   #$00
:
   lda   start,y
   sta   ($16),y
   iny
   cpy   #<(end-start)
   bne   :-

   lda   #<msgtxt1
   ldy   #>msgtxt1
   jsr   TXTOUT
   lda   #<systxt
   ldy   #>systxt
   jsr   TXTOUT
   lda   #<msgcolons
   ldy   #>msgcolons
   jsr   TXTOUT
   lda   #$22
   jsr   CHROUT
   lda   #<msgtxt2
   ldy   #>msgtxt2
   jmp   TXTOUT

msgtxt1:
   .byte $0d,"you can now time your load using",$0d
   .byte "sys ",$00

msgcolons:
   .byte ",,,,,",$22
msgtxt2:
   .byte "<filename>",$0d
   .byte "(device is the last used)",$0d,$00

start:
   lda   #$00
   sta   $ff00  ; set MMU to BASIC/KERNAL/IO Bank 0
   lda   #$05
   sta   $d506  ; Common RAM lower 4K Bank 0

   jsr   CHKCOM
   jsr   FRMEVL
   jsr   FRESTR
   ; A now contains length of string
   ; $24/$25 vector to string
   pha
   lda   #$00
   sta   $ff00
   pla
   ldx   $24
   ldy   $25
   jsr   SETNAM
   lda   #$00   ; load/verify bank (RAM 0)
   ldx   #$01   ; filename bank (RAM 1)
   jsr   SETBNK
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
