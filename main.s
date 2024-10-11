.include "defines.s"
.include "romheader.s"
.include "variables.s"

.segment "FIXED"


.include "init.s"
.include "loop.s"
.include "nmi.s"
.include "ppulib.s"
.include "physics.s"


lightpalette:
    .byte $21, $10, $07, $0f, $21, $10, $00, $0f, $21, $10, $00, $0f, $21, $10, $00, $0f
    .byte $21, $0f, $06, $38, $21, $10, $00, $0f, $21, $10, $00, $0f, $21, $10, $00, $0f
darkpalette:
    .byte $06, $10, $00, $0f, $06, $10, $00, $0f, $06, $10, $00, $0f, $06, $10, $00, $0f
    .byte $06, $20, $21, $38, $06, $10, $00, $0f, $06, $10, $00, $0f, $06, $10, $00, $0f

.segment "VECTORS"
    .word  NMI
    .word  RESET
    .word  0
.segment "CHARS"
    .incbin "mario.chr"