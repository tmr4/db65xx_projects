.include "inc/acia.inc"
.include "inc/int_io.inc"
.include "inc/debug.inc"
.include "inc/delay.inc"
.include "inc/isr.inc"
.include "inc/macro.inc"
.include "inc/via.inc"

.P816
.i16
.a16

.zeropage
blk:                    .word 0

.bss
KB_INDEX_IN:            .word 0
KB_INDEX_OUT:           .word 0
SERIAL_INDEX_IN:        .word 0
SERIAL_INDEX_OUT:       .word 0
KEYBOARD_BUFFER:        .res $100
SERIAL_BUFFER:          .res $100
block_buffer:           .res $400
buffer:                 .res 256

.code

reset:
        clc
        xce
        reg16

        sei

        ldx #$2fff
        txs

        jsr setup_via
        jsr setup_acia

        lda #0
        sta SERIAL_INDEX_IN
        sta SERIAL_INDEX_OUT
        sta KB_INDEX_IN
        sta KB_INDEX_OUT

        lda #$0d
        jsr putc
        ldx #0
@1:     lda message,x
        beq @done
        jsr putc
        xba
        jsr putc
        inx
        inx
        bra @1
@done:
        lda #$0d
        jsr putc

        cli

        ldx #0
@loop:
        txa
        jsr get_blk
        jsr print_blk
        lda #$0d
        jsr putc
        lda #$0d
        jsr putc
        inx
        cpx #8
        bne @loop

        ldy #0
loop:
        jsr getc
        beq loop
        cmp #$08
        bne @1
        cpy #0
        beq loop
        dey
        jsr putc
        lda #' '
        jsr putc
        lda #$08
        jsr putc
        bra loop
@1:
        sta buffer,y
        jsr putc
        iny
        cpy #$100
        bne loop
        ldy #0
        bra loop

next_keyboard_buffer_char:
        lda #0
        phx
        phy
        php
        reg8
        lda KB_INDEX_OUT
        cmp KB_INDEX_IN

        beq @buf_empty

@buf_full:
        tax
        lda KEYBOARD_BUFFER,x
        pha
        inx
        txa
        sta KB_INDEX_OUT
        pla
        plp
        ply
        plx
        clc
        rts

@buf_empty:
        plp
        ply
        plx
        sec
        rts
.a16
.i16

next_buffer_char:
        lda #0
        phx
        phy
        php
        reg8

        lda SERIAL_INDEX_IN
        sec
        sbc SERIAL_INDEX_OUT
        beq @buf_empty

@buf_full:
        lda SERIAL_INDEX_OUT
        tax
        lda SERIAL_BUFFER,x
        pha
        inx
        txa
        sta SERIAL_INDEX_OUT
        pla
        plp
        ply
        plx
        clc
        rts

@buf_empty:
        plp
        ply
        plx
        sec
        rts

.i16
.a16

getc:
.if DEBUG
        ; *** This WAI instruction isn't needed for the hardware build
        ; but is needed for the db65xx simulator to signal the it
        ; to trip an interrupt.
        wai
.endif
        jsr next_keyboard_buffer_char
        bcs getc
        rts

putc:
        jsr acia_write
        rts

get_blk:
        pha

        lda #$1b        ; ESC key
        jsr putc
        lda #'B'
        jsr putc
        pla             ; block #
        jsr putc

        ldy #$0

@getblk_delay:
.if !DEBUG
        bra @loop
.else
        ; *** This WAI instruction isn't needed for the hardware build
        ; but is needed for the db65xx simulator to signal the it
        ; to trip an interrupt.
        wai
.endif
@loop:
        jsr next_buffer_char
        bcs @getblk_delay

        sta block_buffer,y
        iny
        cpy #$400
        bcc @loop

        rts

print_blk:
        ldy #$0
@loop:
        lda block_buffer,y
        jsr putc
        iny
        cpy #$400
        bcc @loop
        rts

.rodata
message: .asciiz "Loading loremlpsum.txt ..."

.segment "VECTORS"
.word $0000
.word $0000
.word $0000
.word $0000
.word $0000
.word $0000
.word $0000
.word io_irq
.word $0000
.word $0000
.word $0000
.word $0000
.word $0000
.word $0000
.word reset
.word io_irq
