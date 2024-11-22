NMI:
    INC frame_counter
    LDA #$02           ; OAM DMA
    STA OAMDMA

setscroll:
    LDA x_scroll
    STA PPUSCROLL
    LDA y_scroll
    STA PPUSCROLL

    LDX #$00
vrambuffer:
    LDA VRAMBUF,X
    INX
    CMP #$FF        ; End of VRAM buffer
    BEQ vrambufferdone
    CMP #$40
    BCS @sequential
    STA PPUADDR
    INX
    LDA VRAMBUF,X
    STA PPUADDR
    INX
    LDA VRAMBUF,X
    STA PPUDATA
    INX
    JMP vrambuffer
@sequential:
    TAY
    LDA PPUCTRL
    CPY #$80
    BCC @horizontal
@vertical:
    ORA #$04
    BNE @updateseq
@horizontal:
    AND #$FB
@updateseq:
    STA PPUCTRL
    TYA
    AND #$3F
    STA PPUADDR
    LDA VRAMBUF,X
    STA PPUADDR
    INX
    LDA VRAMBUF,X
    INX
    TAY
@updateloop:
    LDA (NAME_UPD_ADR),X
	INX
	STA PPU_DATA
	DEY
	BNE @updateloop
    JMP vrambuffer

vrambufferdone:
    LDA #$00
    STA vram_index
    RTI