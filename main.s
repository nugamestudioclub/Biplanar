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
.segment "SRAM"
.segment "WRAM"
.segment "STARTUP"
.segment "CODE"

RESET:
    SEI             ; disable IRQs
    CLD             ; disable decimal mode
    LDX #$40
    STX $4017       ; disable APU frame counter IRQ - disable sound
    LDX #$ff
    TXS             ; setup stack starting at FF as it decrements instead if increments
    INX             ; overflow X reg to $00
    STX $2000       ; disable NMI - PPUCTRL reg
    STX $2001       ; disable rendering - PPUMASK reg
    STX $4010       ; disable DMC IRQs


:
    STX $8000       ; init CHR banks
    STX $A000
    INX
    CPX #$08
    BNE :-

    LDX #$00


    LDY #$08       ; init PRG banks
    STY $8000
    LDA #%11000000
    STA $A000
    INY
:
    STY $8000
    STX $A000
    INY
    INX
    CPX #$03
    BNE :-

    LDA #$0C
    STA $8000
    LDA #$00
    STA $A000

    JSR vblankwait


    LDX #$00

clearmem:
    LDA #$00        ; can also do TXA as x is $#00
    STA $0000, x
    STA $0100, x
    STA $0300, x
    STA $0400, x
    STA $0500, x
    STA $0600, x
    STA $0700, x
    LDA #$fe
    STA $0200, x    ; Set aside space in RAM for sprite data
    INX 
    BNE clearmem

    JSR vblankwait

clearvram:
    LDA #$20
    STA $2006
    LDA #$00
    STA $2006
    LDX #$00
    LDY #$00
:
    STA $2007
    INX
    BNE :-
    INY
    CPY #$08
    BNE :-

loadpalettes:
    LDA $2002   ; read PPU status to reset PPU address
    LDA #$3F    ; Set PPU address to BG palette RAM ($3F00)
    STA $2006
    LDA #$00
    STA $2006

    LDX #$00
:
    LDA palettedata,X
    STA $2007
    INX
    CPX #$20
    BNE :-      ; using anonymous label, don't use these too often unless travelling very small distances in code

initppu:
    LDA #$02            ; OAM DMA
    STA $4014
    NOP

    LDA #$FF      ; init VRAM buffer
    STA $0300

    CLI                 ; clear interrups so NMI can be called
    LDA #%10000000      
    STA $2000           ; the left most bit of $2000 sets wheteher NMI is enabled or not

    LDA #%00011110      ; enable background and sprites
    STA $2001


forever:
    JSR nmiwait

    JMP forever     ; an infinite loop when init code is run

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
NMI:
    INC frame_counter
    LDA #$02           ; OAM DMA
    STA $4014

setscroll:
    LDA x_scroll
    STA $2005
    LDA y_scroll
    STA $2005

    LDX #$00
vrambuffer:
    LDA $0300,X
    CMP #$FF        ; End of VRAM buffer
    BEQ vrambufferdone
    STA $2006
    INX
    LDA $0300,X
    STA $2006
    INX
    LDA $0300,X
    STA $2007
    INX
    JMP vrambuffer

vrambufferdone:
    LDA #$00
    STA vram_index
    RTI
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

vblankwait:
    BIT $2002      ; returns bit 7 of ppustatus reg, which holds the vblank status with 0 being no vblank, 1 being vblank
    BPL vblankwait
    RTS

nmiwait:
    LDA frame_counter
:
    CMP frame_counter
    BEQ :-
    RTS

writevram:         ; adds a write to the vram buffer (A: VRAM address MSB, X: VRAM address LSB, Y: value)
    STY R0
    LDY vram_index
    STA $0300,Y
    INY
    TXA
    STA $0300,Y
    INY
    LDA R0
    STA $0300,Y
    INY
    STY vram_index
    LDA #$FF
    STA $0300,Y
    RTS

drawsprite:      ; adds a sprite to OAM (R0: Tile Index, R1: X Position, R2: Y Position, R3: Attribute Byte)
    LDY R2
    DEY          ; correct for Y offset
    TYA
    LDX oam_index
    STA $0200,X
    INX
    LDA R1
    STA $0200,X
    INX
    LDA R0
    STA $0200,X
    INX
    LDA R3
    STA $0200,X
    INX
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