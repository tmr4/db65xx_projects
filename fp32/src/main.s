.include "inc/fp32.inc"
.include "inc/macro.inc"

.P816

putc := $f001
getc := $f004

.zeropage
FPSP:   .word 0

.bss
buffer: .res 256

.rodata
value: .asciiz "1.1234"     ; IEEE-754 3F8FCB92
message: .asciiz "Loading 1.1234 onto floating point stack ..."

.code

str2fp32_test:
    reg16
    ldx FPSP                ; Load x with the stack pointer.
    lda #value              ; Store the address of the string in A.
    ldy #6                  ; Store the string length.
    jsr str2fp32            ; Call the routine.
    stx FPSP                ; Store the stack pointer.
    rts

main:
    reg8
    ldx #$FF                ; Initialize the stack.
    txs
    cld                     ; Clear decimal arithmetic mode.
    cli                     ; Clear interrupt enable bit.

    clc                     ; shift processor to native mode
    xce

    ldx #0
    ldy #0
print:
    lda message,x
    beq @1
    jsr print_char
    inx
    bra print

@1:
    lda #$0d
    jsr print_char

    reg16
    ldx #$0300              ; Initialize the floating point stack register.
    stx FPSP                ; This is defined in fp32.asm

    jsr str2fp32_test

    reg8
loop:
    jsr get_char
    beq loop
    cmp #$08
    bne @2
    cpy #0
    beq loop
    dey
    bra loop
@2:
    sta buffer,y
    iny
    bra loop

print_char:
    sta putc
    rts

get_char:
    lda getc
    rts

.segment "VECTORS"

; Native Mode Vectors
.word $0000     ; Reserved
.word $0000     ; Reserved
.word $0000     ; COP
.word $0000     ; BRK
.word $0000     ; ABORT
.word $0000     ; NMI
.word $0000     ; Reserved
.word $0000     ; IRQ

; Emulation Mode Vectors
.word $0000     ; Reserved
.word $0000     ; Reserved
.word $0000     ; COP
.word $0000     ; Reserved
.word $0000     ; ABORT
.word $0000     ; NMI
.word main      ; RESET
.word $0000     ; IRQ/BRK
