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
    STX VRAMBUF,Y
    INY
    LDA R0
    STA VRAMBUF,Y
    INY
    STY vram_index
    LDA #$FF
    STA VRAMBUF,Y
    RTS

drawscreen:         ; draws a full screen of metatiles 

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