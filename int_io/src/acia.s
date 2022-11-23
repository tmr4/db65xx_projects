.include "inc/acia.inc"
.include "inc/debug.inc"
.include "inc/delay.inc"
.include "inc/macro.inc"

.P816
.i16
.a16

.code

setup_acia:
        php
        acc8
        sta ACIA_PRESET
        lda ACIA_STATUSR
        lda ACIA_RDATAR

        lda #%00011110
        sta ACIA_CONTR

        lda #%00001001
        sta ACIA_COMDR
        plp
        rts

acia_write:
.if !DEBUG
        jsr serial_delay
.endif
        php
        acc8
        sta ACIA_TDATAR         ; write byte to transmit data register
        plp
        rts


acia_read:
        php
        acc8
        clc
        lda ACIA_STATUSR        ; check if receiver data register is full
        and #RDRF_MASK
        beq @done
        lda ACIA_RDATAR
        plp
        sec
        rts
@done:
        plp
        clc
        rts
