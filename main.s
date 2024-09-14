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
    rc0:          .res 1
    vramindex:    .res 1
    framecounter: .res 1
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

    LDX #$00

    JSR vblankwait

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
    LDX framecounter
    LDA #$01
    STA rc0
    LDA #$20
    JSR writevram

    JMP forever     ; an infinite loop when init code is run

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
NMI:
    INC framecounter
    LDA #$02           ; OAM DMA
    STA $4014

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
    STA vramindex
    RTI
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

vblankwait:
    BIT $2002      ; returns bit 7 of ppustatus reg, which holds the vblank status with 0 being no vblank, 1 being vblank
    BPL vblankwait
    RTS

nmiwait:
    LDA framecounter
:
    CMP framecounter
    BEQ :-
    RTS

writevram:         ; adds a write to the vram buffer (A: VRAM address MSB X: VRAM address LSB rc0: value)
    LDY vramindex
    STA $0300,Y
    INY
    TXA
    STA $0300,Y
    INY
    LDA rc0
    STA $0300,Y
    INY
    STY vramindex
    LDA #$FF
    STA $0300,Y
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