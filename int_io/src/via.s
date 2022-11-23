.include "inc/macro.inc"
.include "inc/via.inc"

.P816
.i16
.a16

.code

setup_via:
        php
        acc8
        ; disable all interrupts on 6522
        lda #%01111111
        sta VIA_IER

        ; set CB1 to to a positive active edge
        lda #%00010000
        sta VIA_PCR

        ; set shift register to shift in under external control on CB1
        lda #SR_IN_EXT
        sta VIA_ACR

        ; enable SR interrupt
        lda #(VIA_IER_SET | VIA_IER_SR)
        sta VIA_IER

        ; reset SR interrupt flag and counter
        lda VIA_SR
        plp
        rts
