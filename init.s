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
    LDA #%10010000      
    STA $2000           ; the left most bit of $2000 sets wheteher NMI is enabled or not

    LDA #%00011110      ; enable background and sprites
    STA $2001

initgame:
    LDA #$80        ; init player position
    STA x_pos+1
    STA y_pos+1