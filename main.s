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
.include "nmi.s"


mainloop:           ; the main game tick loop
    JSR nmiwait     ; wait until next frame


    LDA #$01        ; read controller
    STA JOY1
    STA controller  ; initialize the controller variable to $01 so that once the 8 button values are shifted in, 1 will be placed into the carry
    LSR a
    STA JOY1
:
    LDA JOY1
    LSR a           ; move the button value from bit 0 of A to the carry flag
    ROL controller  ; move the button value from the carry flag to bit 0 of the controller variable, shifting the other buttons as a result
    BCC :-          ; the carry flag will be 1 if the controller variable has been shifted left 8 times, indicating that all 8 buttons have been read



    LDA controller  ; right button
    AND #%00000001
    BEQ @noright
    CLC             ; increase the X velocity by an acceleration amount of 0.25
    LDA x_vel+0
    ADC #$40
    STA x_vel+0
    LDA x_vel+1
    ADC #$00
    STA x_vel+1
    JMP applyvelocity
@noright:
    LDA controller  ; left button
    AND #%00000010
    BEQ @noleft
    SEC             ; decrease the X velocity by an acceleration amount of 0.25
    LDA x_vel+0
    SBC #$40
    STA x_vel+0
    LDA x_vel+1
    SBC #$00
    STA x_vel+1
    JMP applyvelocity
@noleft:
    LDA x_vel+0
    BNE applydrag
    LDA x_vel+1
    BNE applydrag
    JMP applyvelocity
applydrag:
    LDA x_vel+1
    BMI @negative
    SEC
    LDA x_vel+0
    SBC #$40
    STA x_vel+0
    LDA x_vel+1
    SBC #$00
    STA x_vel+1
    JMP applyvelocity
@negative:
    CLC
    LDA x_vel+0
    ADC #$40
    STA x_vel+0
    LDA x_vel+1
    ADC #$00
    STA x_vel+1
applyvelocity:


    CLC             ; apply X velocity
    LDA x_pos+0
    ADC x_vel+0
    STA x_pos+0
    LDA x_pos+1
    ADC x_vel+1
    STA x_pos+1

    CLC             ; apply Y velocity
    LDA y_pos+0
    ADC y_vel+0
    STA y_pos+0
    LDA y_pos+1
    ADC y_vel+1
    STA y_pos+1


    JSR oamclear

    LDA #$00
    STA R0
    LDA x_pos+1
    STA R1
    LDA y_pos+1
    STA R2
    LDA #%10000000
    STA R3
    JSR oamsprite

    JMP mainloop


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