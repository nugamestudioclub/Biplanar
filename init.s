RESET:
    SEI             ; disable IRQs
    CLD             ; disable decimal mode
    LDX #$40
    STX JOY2        ; disable APU frame counter IRQ - disable sound
    LDX #$ff
    TXS             ; setup stack starting at FF as it decrements instead if increments
    INX             ; overflow X reg to $00
    STX PPUCTRL     ; disable NMI - PPUCTRL reg
    STX PPUMASK     ; disable rendering - PPUMASK reg
    STX $4010       ; disable DMC IRQs


:
    STX MAPCMD      ; init CHR banks
    STX MAPDATA
    INX
    CPX #$08
    BNE :-

    LDX #$00


    LDY #BNKPRG0     ; init PRG banks
    STY MAPCMD
    LDA #%11000001
    STA MAPDATA
    INY
:
    STY MAPCMD
    STX MAPDATA
    INY
    INX
    CPX #$03
    BNE :-

    LDA #MIRROR
    STA MAPCMD
    LDA #$00        ; horizontal mirroring
    STA MAPDATA

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
    STA PPUADDR
    LDA #$00
    STA PPUADDR
    LDX #$00
    LDY #$00
:
    STA PPUDATA
    INX
    BNE :-
    INY
    CPY #$08
    BNE :-

loadpalettes:
    LDA PPUSTATUS   ; read PPU status to reset PPU address
    LDA #$3F        ; Set PPU address to BG palette RAM ($3F00)
    STA PPUADDR
    LDA #$00
    STA PPUADDR

    LDX #$00
:
    LDA lightpalette,X
    STA PPUDATA
    INX
    CPX #$20
    BNE :-      ; using anonymous label, don't use these too often unless travelling very small distances in code

initppu:
    LDA #$02            ; OAM DMA
    STA OAMDMA
    NOP
    LDA #<VRAMBUF
    STA vram_pointer+0
    LDA #>VRAMBUF
    STA vram_pointer+1

    LDA #<meta_map
    STA R0
    LDA #>meta_map
    STA R1
    LDA #$00
    JSR drawscreen

    LDA #<meta_map2
    STA R0
    LDA #>meta_map2
    STA R1
    LDA #$01
    JSR drawscreen




    LDA #$FF      ; init VRAM buffer
    STA $0300

    CLI                 ; clear interrups so NMI can be called
    LDA #%10110000
    STA ppu_ctrl
    STA PPUCTRL         ; the left most bit of $2000 sets wheteher NMI is enabled or not

    LDA #%00011110      ; enable background and sprites
    STA PPUMASK

clearwram:
    LDA #$00
    STA $6000, x
    INX
    BNE clearwram
    LDA #BNKPRG0
    STA MAPCMD
    LDA #%11000000
    STA MAPDATA

clearwram2:
    LDA #$00
    STA $6000, x
    INX
    BNE clearwram2

initmusic:
    LDA #$01
    LDX #.LOBYTE(music_data_untitled)
    LDY #.HIBYTE(music_data_untitled)
    JSR famistudio_init

    LDA #BNKPRG0
    STA MAPCMD
    LDA #%11000001
    STA MAPDATA

    LDA #$01
    LDX #.LOBYTE(music_data_untitled)
    LDY #.HIBYTE(music_data_untitled)
    JSR famistudio_init

initgame:
    LDA #$80        ; init player position
    STA x_pos+1
    STA y_pos+1

    LDA .LOBYTE(idle_anim)
    STA player_anim+0
    LDA .HIBYTE(idle_anim)
    STA player_anim+1

    LDA #BNKPRG0
    STA MAPCMD
    LDA #%11000000
    STA MAPDATA
    LDA #$00
    JSR famistudio_music_play

    LDA #BNKPRG0
    STA MAPCMD
    LDA #%11000001
    STA MAPDATA
    LDA #$01
    JSR famistudio_music_play