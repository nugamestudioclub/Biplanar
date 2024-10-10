.include "defines.s"
.include "romheader.s"
.include "variables.s"

.segment "FIXED"


.include "init.s"
.include "loop.s"
.include "nmi.s"
.include "ppulib.s"
.include "physics.s"


palettedata:
    .byte $30, $10, $00, $0f, $30, $10, $00, $0f, $30, $10, $00, $0f, $30, $10, $00, $0f
    .byte $30, $0f, $06, $38, $30, $10, $00, $0f, $30, $10, $00, $0f, $30, $10, $00, $0f

.segment "VECTORS"
    .word  NMI
    .word  RESET
    .word  0
.segment "CHARS"
    .incbin "mario.chr"