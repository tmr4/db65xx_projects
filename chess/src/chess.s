        ;
        ; Toledo Atomchess 6502 for Atari VCS/2600
        ;
        ; by Óscar Toledo G. (nanochess)
        ;
        ; © Copyright 2017 Óscar Toledo Gutiérrez
        ;
        ; Creation date: Jan/02/2017. Ported from Toledo Atomchess x86.
        ; Revision date: Jan/04/2017. Working board display logic and selection.
        ; Revision date: Jan/05/2017. Avoid player to move non-white pieces or
        ;                             bug when fire bounces. Now using another
        ;                             color for black pieces. Small optimization.
        ; Revision date: Jan/13/2017. Solved bug where it would answer with move
        ;                             after checkmate. Some more comments.
        ; Revision date: Jan/15/2017. Added size optimizations by Peter Ferrie,
        ;                             19 bytes saved. Also I've optimized my
        ;                             graphical/input interface for further 18
        ;                             bytes.
        ; Revision date: Jan/16/2017. Saved 2 bytes more in playfield setup for
        ;                             squares (Ferrie). Taken note of which
        ;                             instructions can trigger the oVerflow flag.
        ;                             Now can be assembled for visual6502.org
        ; Revision date: Jul/08/2017. Redesigned display code to use venetian blinds
        ;                             technique in Atari VCS display, it allows for
        ;                             30hz flicker so pieces will look steady. Now
        ;                             cursor can turn around the chessboard and also
        ;                             saves bytes. Support for Supercharger.
        ; Revision date: Nov/14/2017. Saved 5 bytes more in some loops (Ferrie).
        ;
        ; Revision date: Nov/27/2022. CC65 port for text based I/O (TRobertson).
        ;                             Ported to cc65, removed Atari code and
        ;                             modified I/O addresses.
        ;                             Permission granted by Oscar Toledo,
        ;                             https://github.com/nanochess/Atomchess-6502
        ;

        ; Features:
        ; * Computer plays legal basic chess movements
        ; * Move with algebraic notation
        ; * Search depth of 2-ply
        ; * Promotion of pawns only to queen
        ; * No castling
        ; * No en passant
        ;
        ; Assemble with cc65 from https://github.com/cc65/cc65
        ; Tested with db65xx from https://marketplace.visualstudio.com/items?itemName=TRobertson.db65xx

putc := $f001
getc := $f004

score   = $80        ; Current score
side    = $81        ; Current side
offset  = $82        ; Current offset
total   = $83        ; Current total
origin  = $84        ; Current origin square
target  = $85        ; Current target square

frame   = $86        ; Current frame

cursorx = $87        ; Current X position of cursor
cursory = $88        ; Current Y position of cursor

pSWCHA  = $89        ; Previous value of SWCHA
pINPT4  = $8A        ; Previous value of INPT4

        ; Reused locations
bitmap0 = $82        ; Index into bitmap (0)
bitmap1 = $83        ; Index into bitmap (1)
bitmap2 = $81        ; Index into bitmap (2)
bitmap3 = $8b        ; Index into bitmap (3)
even    = $80        ; Marks even/odd

board   = $8c        ; 78 bytes used, there should be space for 12+12+10 bytes of stack

.code

START:
        sei          ; Disable interruptions
        cld          ; Disable decimal mode

        ; Clean up the memory
        ldx #$ff
        txs
        lda #$00     ; Load zero in accumulator
        ldx #$80     ; ...copy in X
sr0:    sta 0,X      ; Save in address 0 plus X
        inx          ; Increment X
        cpx #$8c
        bne sr0      ; Repeat until X is zero.
        tax          ; x is zero

sr1:    ldy #8
        lda #$00
sr3:    sta board,x
        inx
        dey
        bne sr3
        lda #$07
        sta board,x
        inx
        sta board,x
        inx
        cpx #8*10
        bne sr1
        tax          ; a was $07, so x = $07
sr2:    lda initial,x
        sta board,x
        ora #$08
        sta board+70,x
        inc board+10,x
        lda #$09
        sta board+60,x
        dex
        bpl sr2
        lsr          ; lda #4, but A was $09 / 2 = $04
        sta cursorx
        sta cursory

        ;
        ; Main loop
        ;
sr21:
        jsr kernel
        jsr read_coor
        lda board,y
        and #8          ; Check for white piece
        beq sr21        ; If no, jump and restart selection logic
sr11:   jsr read_coor
        lda board,y
        and #8          ; Check for white piece
        bne sr11        ; If yes, restart target square logic
        jsr sr28        ; Make movement
        jsr kernel
        jsr play        ; Computer play
        jmp sr21

        ;
        ; Start chess playing code, this code is the end of loop but it's here
        ; to save bytes ;)
        ;
sr14:   inc offset
        dec total
        bne sr12
sr17:   inx
        cpx #78
        bne sr7
        pla
        tay
        pla
        tsx
        cpx #$ff-2      ; Top call? (2 bytes of return address)
        bne sr24
        ldx score
        cpx #$c0+19     ; Illegal move? (always in check)
        bmi sr24        ; Yes, doesn't move
        tax
sr28:   lda board,x     ; Do move
        cmp #1
        beq sr32
        cmp #9          ; Is it pawn?
        bne sr30
sr32:   cpy #10         ; Reaching border?
        bcc sr31
        cpy #70
        bcc sr30
sr31:   eor #5          ; Make it queen
sr30:   sta board,y
        lda #0          ; Clear origin square
        sta board,x
sr24:   rts

        ;
        ; Computer plays :)
        ;
play:   lda #$c0        ; Current score (-64)
        sta score
        pha             ; Origin square of best movement (currently none)
        pha             ; Target square of best movement
        ldx #0          ; x points to current square
sr7:    lda board,x     ; Read square
        beq sr17        ; Ignore if empty square
        eor side        ; XOR with current playing side
        cmp #7          ; Ignore if frontier
        bcs sr17
        cmp #1          ; Is it pawn?
        bne sr25        ; Carry will be 1 always because 1<=A<=6
        ldy side        ; Is it playing black?
        beq sr25        ; Yes, jump
        lda #0          ; Make it zero for white
sr25:   tay
        adc #3          ; Adds 4 because carry is 1 (see above)
        and #$0c
        sta total       ; Total movements of piece
        lda offsets,y
        sta offset      ; Next offset for movement
sr12:   stx target      ; Restart target square
sr9:    ldy offset
        lda displacement,y
        clc
        adc target      ; Next target square
        cmp #78         ; Out of board?
        bcs sr14
        sta target

        cpy #16
        tay
        lda board,y     ; Content of target square
        beq sr10        ; Jump if empty square
        bcc sr27        ; Jump if isn't not pawn
        lda total
        cmp #3          ; Straight movement?
        bcc sr17        ; Yes, avoid and cancels any double square movement
sr27:   lda board,y
        eor side
        sec
        sbc #9          ; Valid capture?
        cmp #6
        bcs sr29        ; No, avoid (too far for sr18, use sr29 as bridge)
        cmp #5
        bne sr20        ; Jump if not captured king
        pla             ; Ignore values
        pla
        tsx
        lda #$3f-18     ; Maximum score minus two queens...
        cpx #$f1        ; ...if not in first response.
        bne sr26
        lda #$3f        ; Maximum score (probably checkmate/stalemate)
sr26:   sta score
        rts

sr29:   bcs sr18        ; Avoid movement if pawn is going diagonal
                        ; Next comparison does movement if two squares ahead
                        ; (already validated)
        ;
        ; Enters here if piece is going to empty square
        ;
sr10:   bcc sr20        ; If isn't pawn, jump and do movement
        lda total
        cmp #2          ; Pawn going one square ahead?
        bne sr29        ; Jump if not case.

sr15:   txa
        ;sec            ; Carry set already because comparison was equal
        sbc #20
        cmp #40         ; Moving from center of board?
        bcs sr20        ; Jump if moving pawn from start square, autovalidates
        dec total       ; Or not, avoid going two squares ahead.
        ;bcc sr20       ; Fall along

        ; Save all state
sr20:   lda offset      ; Offset for movement
        pha
        lda total       ; Total directions left
        pha
        lda board,y     ; Content of target square
        pha
        tya             ; Target square
        pha
        lda board,x     ; Content of origin square
        pha
        txa             ; Origin square
        sta origin
        pha
        lda board,y
        and #7
        tay
        lda scores,y    ; Score for capture
        tsx
        cpx #255-10*3+1 ; Depth limit (2-ply)
;        cpx #255-10*2+1 ; Depth limit (1-ply)
        bcc sr22
        pha
        lda score       ; Current score
        pha
        ldx origin
        ldy target
        jsr sr28        ; Do move
        lda side
        eor #8          ; Change side (doesn't save in stack because lack of space)
        sta side
        jsr play
        lda side
        eor #8          ; Change side
        sta side
        pla
        tax             ; Current score in x
        pla
        sec             ; Take capture score and substract adversary score
        sbc score
        stx score       ; Restore current score
sr22:   cmp score       ; Better score?
        clc
        bmi sr23        ; No, jump
        sta score       ; Update score
        bne sr33        ; Better score? yes, jump
        lda frame       ; Equal score, randomize move
        ror
        ror             ; If carry = 1 then will update move
        .byte $24       ; BIT to jump next bye.
sr33:   sec
sr23:   pla             ; Restore board
        tax
        pla
        sta board,x
        pla
        sta target
        tay
        pla
        sta board,y
        pla
        sta total
        pla
        sta offset
        bcc sr18
        pla
        pla
        txa             ; Save current best movement
        pha
        tya
        pha

sr18:   lda board,x
        and #7
        cmp #1          ; Was it pawn?
        beq sr16        ; Yes, end sequence, choose next movement
        cmp #5          ; Knight or king?
        bcs sr16        ; End sequence, choose next movement
        lda board,y     ; To empty square?
        bne sr16
        jmp sr9         ; Yes, follow line of squares

sr16:   jmp sr14

kernel:
        jsr headers
        lda #$38
        sta bitmap0
        ldx #0
kn0:    lda bitmap0
        sta putc
        lda #$20
        sta putc
        ldy #8
kn1:    txa
        pha
        lda board,x
        tax
        lda letters,x
        sta putc
        lda #$20
        sta putc
        pla
        tax
        inx
        dey
        bne kn1
        lda bitmap0
        sta putc
        lda #$0d
        sta putc
        dec bitmap0
        inx
        inx
        cpx #80
        bne kn0
        jsr headers
        rts

headers:
        ldx #0
kn2:    lda header,x
        sta putc
        lda #$20
        sta putc
        inx
        cpx #9
        bne kn2
        lda #$0d
        sta putc
        rts

.rodata
header:
        .byte $20,$41,$42,$43,$44,$45,$46,$47
        .byte $48

letters:
        .byte $2e,$70,$72,$62,$71,$6e,$6b,$00
        .byte $00,$50,$52,$42,$51,$4e,$4b

.code
        ;
        ; Read a coordinate choosen by cursor
        ; Moves y to x, y contains new coordinate.
        ;
read_coor:
        tya
        tax
        jsr readkey
        sta even
        jsr readkey
        eor #$ff    ; 1-8 converted to $fe-$f7
        clc
        adc #$09    ; row
        asl         ; x2
        sta bitmap0
        asl         ; x4
        asl         ; x8
        adc bitmap0 ; x10
        adc even    ; +column
        tay
        dey
        rts

readkey:
        lda getc
        beq readkey
        and #$0f
        rts

.rodata
initial:
        .byte $02,$05,$03,$04,$06,$03,$05,$02

scores:
        .byte 0,1,5,3,9,3

offsets:
        .byte 16,20,8,12,8,0,8

displacement:
        .byte 256-21,256-19,256-12,256-8,8,12,19,21
        .byte 256-10,10,256-1,1
        .byte 9,11,256-9,256-11
        .byte 256-11,256-9,256-10,256-20
        .byte 9,11,10,20

        .segment "VECTORS"
        .word $0000
        .word START
        .word $0000
