.include "defines.s"

.segment "HEADER"       ; Setting up the header, needed for emulators to understand what to do with the file, not needed for actual cartridges
    .byte "NES"         ; The beginning of the HEADER of iNES header
    .byte $1a           ; Signature of iNES header that the emulator will look for
    .byte $02           ; 2 * 16KB PRG (program) ROM
    .byte $01           ; 1 * 8KB CHR ROM 
    .byte %01010010     ; mapper and mirroring - no mapper here due to no bank switching, no mirroring - using binary as it's easier to control
    .byte %01001000     ; mapper and NES 2.0 Signature
    .byte $0
    .byte $0
    .byte $70
    .byte $0
    .byte $0
    .byte $0
    .byte $0
    .byte $0
.segment "ZEROPAGE"
    R0:            .res 1
    R1:            .res 1
    R2:            .res 1
    R3:            .res 1
    vram_index:    .res 1
    frame_counter: .res 1
    x_scroll:      .res 2
    y_scroll:      .res 2
    oam_index:     .res 1
    controller:    .res 1
    x_pos:         .res 2
    y_pos:         .res 2
    x_vel:         .res 2
    y_vel:         .res 2
.segment "RAM"
.segment "PRG_RAM"
.segment "FIXED"


.include "init.s"
.include "loop.s"
.include "nmi.s"


vblankwait:
    BIT PPUSTATUS   ; returns bit 7 of ppustatus reg, which holds the vblank status with 0 being no vblank, 1 being vblank
    BPL vblankwait
    RTS

nmiwait:
    LDA frame_counter
:
    CMP frame_counter
    BEQ :-
    RTS

writevram:          ; adds a write to the vram buffer (A: VRAM address MSB, X: VRAM address LSB, Y: value)
    STY R0
    LDY vram_index
    STA VRAMBUF,Y
    INY
    TXA
    STA VRAMBUF,Y
    INY
    LDA R0
    STA VRAMBUF,Y
    INY
    STY vram_index
    LDA #$FF
    STA VRAMBUF,Y
    RTS

oamsprite:          ; adds a sprite to OAM (R0: Tile Index, R1: X Position, R2: Y Position, R3: Attribute Byte)
    LDY R2
    DEY             ; correct for Y offset
    TYA
    LDX oam_index
    STA OAMBUF,X
    INX
    LDA R0
    STA OAMBUF,X
    INX
    LDA R3
    STA OAMBUF,X
    INX
    LDA R1
    STA OAMBUF,X
    INX
    STX oam_index
    RTS

oamclear:           ; clears OAM
    LDX #$00
    LDA #$FF        ; this Y coordinate puts the sprite off screen
:
    STA OAMBUF,X
    INX
    INX
    INX
    INX
    BNE :-
    STX oam_index
    RTS


palettedata:
    .byte $30, $10, $00, $0f, $30, $10, $00, $0f, $30, $10, $00, $0f, $30, $10, $00, $0f
    .byte $30, $10, $00, $0f, $30, $10, $00, $0f, $30, $10, $00, $0f, $30, $10, $00, $0f

.segment "VECTORS"
    .word  NMI
    .word  RESET
    .word  0
.segment "CHARS"
    .incbin "mario.chr"