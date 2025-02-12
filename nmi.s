NMI:
    PHP
    PHA
    INC frame_counter
    LDA #$02           ; OAM DMA
    STA OAMDMA

    LDY #$00
vrambuffer:
    LDA (vram_pointer),Y
    INY
    CMP #$FF        ; End of VRAM buffer
    BEQ vrambufferdone
    CMP #$40
    BCS @sequential
    STA PPUADDR
    INY
    LDA (vram_pointer),Y
    STA PPUADDR
    INY
    LDA (vram_pointer),Y
    STA PPUDATA
    INY
    JMP vrambuffer
@sequential:
    TAX
    LDA ppu_ctrl
    CPX #$80
    BCC @horizontal
@vertical:
    ORA #$04
    BNE @updateseq
@horizontal:
    AND #$FB
@updateseq:
    STA ppu_ctrl
    STA PPUCTRL
    TXA
    AND #$3F
    STA PPUADDR
    LDA (vram_pointer),Y
    STA PPUADDR
    INY
    LDA (vram_pointer),Y
    INY
    TAX
@updateloop:
    LDA (vram_pointer),Y
	INY
	STA PPUDATA
	DEX
	BNE @updateloop
    JMP vrambuffer

vrambufferdone:
    LDA #$00
    STA vram_index

setscroll:
    LDA ppu_ctrl
    STA PPUCTRL
    LDA x_scroll
    STA PPUSCROLL
    LDA y_scroll
    STA PPUSCROLL
    PLA
    PLP
    RTI