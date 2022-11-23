.import __ACIA_START__
.global setup_acia
.global acia_write

RDRF_MASK = %00001000   ; receiver data register full

;-------------------------------------------------------------------------
; 65c51 ACIA #1 Registers
;-------------------------------------------------------------------------

; RWB = HIGH
ACIA_STATUSR = __ACIA_START__ + 1
ACIA_RDATAR  = __ACIA_START__

; RWB = LOW
ACIA_PRESET = __ACIA_START__ + 1
ACIA_TDATAR = __ACIA_START__

ACIA_COMDR = __ACIA_START__ + 2
ACIA_CONTR = __ACIA_START__ + 3
