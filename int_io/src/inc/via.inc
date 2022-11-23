.import __VIA_START__
.global setup_via

;***************************************
; 65c22 VIA Constants
;***************************************

VIA_IER_CLEAR   = %00000000
VIA_IER_SET     = %10000000
VIA_IER_TIMER1  = %01000000
VIA_IER_TIMER2  = %00100000
VIA_IER_CB1     = %00010000
VIA_IER_CB2     = %00001000
VIA_IER_SR      = %00000100
VIA_IER_CA1     = %00000010
VIA_IER_CA2     = %00000001

; shift register control (shift in or out on CB2)
SR_DISABLE  = %00000000   ; shift register disabled
SR_IN_T2    = %00000100   ; shift in under control of T2
SR_IN_CLK   = %00001000   ; shift in under control of system clock
SR_IN_EXT   = %00001100   ; shift in under control of external clock (CB1)
SR_OUT_FREE = %00010000   ; shift out, free running
SR_OUT_T2   = %00010100   ; shift out under control of T2
SR_OUT_CLK  = %00011000   ; shift out under control of system clock
SR_OUT_EXT  = %00011100   ; shift out under control of external clock (CB1)

;-------------------------------------------------------------------------
; 65c22 VIA #1 Registers
;-------------------------------------------------------------------------

; 6522 registers
VIA_PORTB = __VIA_START__ + 0  ; register B: read/write (PB0-7)
VIA_PORTA = __VIA_START__ + 1
VIA_DDRB  = __VIA_START__ + 2  ; register B data direction: set on per bit basis, 1 for output, 0 for input
VIA_DDRA  = __VIA_START__ + 3  ; register A data direction:
VIA_T1CL  = __VIA_START__ + 4
VIA_T1CH  = __VIA_START__ + 5
VIA_T2CL  = __VIA_START__ + 8
VIA_T2CH  = __VIA_START__ + 9
VIA_SR    = __VIA_START__ + $a
VIA_ACR   = __VIA_START__ + $b  ; auxilary control register: bit 0 PA - high, enable latching; low, disable latching
VIA_PCR   = __VIA_START__ + $c  ; peripheral control register
VIA_IFR   = __VIA_START__ + $d  ; interrupt flags register
VIA_IER   = __VIA_START__ + $e  ; interrupt enable register
