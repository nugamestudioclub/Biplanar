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

oammetasprite:      ; add all of the sprites in a metasprite into OAM using oamsprite
                    ; Uses all of the registers for OAM sprite (R0-R3), and its paramaters are:
                    ; (R4: Metasprite pointer low byte, R5: Metasprite pointer high byte, R6: Metasprite X Position, R7: Metasprite Y Position)
                    ; It also uses R8 and R9 for scratch work.

    LDY #$00
    LDA (R4), Y     ; Loads the first byte of the metasprite into A. This is the number of sprites in the metasprite, multiplied by 4.
                    ; This is the value of y when we want to stop looping.
    STA R8          ; R8 Stores this value.
:                   ; Begin loop
    INY
    LDA (R4), Y     ; load tile index
    STA R0          ; Pass to oamsprite
    INY
    LDA (R4), Y     ; load sprite x offset
    CLC
    ADC R6          ; Add the x position of the metasprite
    STA R1          ; Pass sprite x position to oamsprite
    INY
    LDA (R4), Y     ; load sprite y offset
    CLC
    ADC R7          ; Add the y position of the metasprite
    STA R2          ; Pass sprite y position to oamsprite
    INY
    LDA (R4), Y     ; load sprite attribute
    STA R3          ; Pass to oamsprite
    STY R9          ; Temproarily store y in R9, as oamsprite will mutate it
    JSR oamsprite
    LDY R9          ; Bring y back
    CPY R8          ; Branch if y ≠ the strored value to branch at
    BNE :-
    ;loop end
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

loadcolbuffer:      ; Load the given swap data into the collision swap buffers (R0: swap data address LSB, R1: swap data address MSB)
    LDY #$00

@loadloop:
    LDA (R0),Y      ; Tilemap index of the start of the update
    CMP #$FF
    BEQ @done
    STA light_col,Y
    STA dark_col,Y
    STA R2

    INY
    LDA (R0),Y      ; Length of the update
    STA R3
@innerloop:
    INY
    LDA (R0),Y
    TAX
    LDA meta_col,X
    STA dark_col,Y
    LDX R2
    LDA meta_col,X
    STA light_col,X
    INX
    STX R2

    DEC R3
    BNE @innerloop
    BEQ @loadloop
@done:
    RTS
