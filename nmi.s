NMI:
    INC frame_counter
    LDA #$02           ; OAM DMA
    STA $4014

setscroll:
    LDA x_scroll
    STA PPUSCROLL
    LDA y_scroll
    STA PPUSCROLL

    LDX #$00
vrambuffer:
    LDA $0300,X
    CMP #$FF        ; End of VRAM buffer
    BEQ vrambufferdone
    STA PPUADDR
    INX
    LDA $0300,X
    STA PPUADDR
    INX
    LDA $0300,X
    STA PPUDATA
    INX
    JMP vrambuffer

vrambufferdone:
    LDA #$00
    STA vram_index
    RTI