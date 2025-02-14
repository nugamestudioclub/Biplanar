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
    STA VRAMBUF,Y
    TAX
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

drawscreen:         ; draws a full screen of metatiles (A: Screen Number (0: Screen A, 1: Screen B), R0: metamap address LSB, R1: metamap address MSB)
    LDX #$20
    TAY
    STA R3
    BEQ :+
    LDX #$24
:
    STX PPUADDR
    LDA #$00
    STA PPUADDR
    STA R2
    TAY
@loadloop:
    LDA (R0),Y
    TAX
    LDA R3
    BNE :+
    LDA meta_col,X
    STA tilemap,Y
    JMP @placetiles
:
    LDA meta_col,X
    STA tilemap2,Y
@placetiles:
    LDA R2
    BNE @bottomhalf
    LDA meta_ul,X
    STA PPUDATA
    LDA meta_ur,X
    STA PPUDATA
    JMP @continue
@bottomhalf:
    LDA meta_dl,X
    STA PPUDATA
    LDA meta_dr,X
    STA PPUDATA
@continue:
    INY
    TYA
    AND #$0F
    BNE @next
    LDA R2
    EOR #$01
    STA R2
    BEQ @next
    TYA
    SEC
    SBC #$10
    TAY
@next:
    LDA R2
    BNE @loadloop
    CPY #$F0
    BNE @loadloop
    RTS