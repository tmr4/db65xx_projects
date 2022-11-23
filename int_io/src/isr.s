.include "inc/acia.inc"
.include "inc/int_io.inc"
.include "inc/isr.inc"
.include "inc/macro.inc"
.include "inc/via.inc"

.P816
.i16
.a16

.code

io_irq:
        pha
        phx
        phy

acia1_isr:
        php
        reg8
        lda ACIA_STATUSR
        and #RDRF_MASK
        beq via1_SR_isr

        lda SERIAL_INDEX_IN
        tax
        lda ACIA_RDATAR
        sta SERIAL_BUFFER,x
        inx
        txa
        sta SERIAL_INDEX_IN
        jmp irq_done

via1_SR_isr:
        lda VIA_IFR
        and #VIA_IER_SR
        beq irq_done

        lda KB_INDEX_IN
        tax
        lda VIA_SR
        sta KEYBOARD_BUFFER,x
        inx
        txa
        sta KB_INDEX_IN

irq_done:
        plp
        ply
        plx
        pla
        rti
