; CURRENTLY NOW WORKING!
LOADVEC                 := $0330
TXTOUT                  := $55E2
FRMNUM                  := $77D7
FRMEVL                  := $77EF
CHKCOM                  := $795C
FRESTR                  := $877E 
GETADR                  := $8815 
SETLFS                  := $FFBA
SETNAM                  := $FFBD
CHROUT                  := $FFD2
LOAD                    := $FFD5
SETBNK                  := $FF68
NEW                     := $51D6

   .word main-2
   .byte $00,$00,$9e,"7191,,,,,02816",$00,$00,$00

main:
   lda   LOADVEC+0
   sta   loadcall+1
   lda   LOADVEC+1
   sta   loadcall+2

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
   
   lda   $16
   sta   LOADVEC+0
   lda   $17
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
   sta   $ff00	; set MMU to BASIC/KERNAL/IO Bank 0
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
