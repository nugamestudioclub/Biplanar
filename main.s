.include "defines.s"
.include "romheader.s"
.include "variables.s"
.include "famistudio_ca65.s"

.segment "FIXED"


.include "init.s"
.include "loop.s"
.include "nmi.s"
.include "ppulib.s"
.include "physics.s"
.include "data.s"
.include "musicdatatest.s"

.segment "VECTORS"
    .word  NMI
    .word  RESET
    .word  0
.segment "CHARS"
    .incbin "game.chr"