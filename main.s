.include "defines.s"
.include "romheader.s"
.include "variables.s"
.include "famistudio_ca65.s"

.segment "DATA_MUSIC"
.include "biplanar_feb18.s"

.segment "FIXED"


.include "init.s"
.include "loop.s"
.include "nmi.s"
.include "ppulib.s"
.include "physics.s"
.include "data.s"


.segment "VECTORS"
    .word  NMI
    .word  RESET
    .word  0
.segment "CHARS"
    .incbin "game.chr"