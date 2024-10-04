bg_collision:       ; collides the player with the background tiles
    LDA #$00
    STA x_eject
    STA y_eject
    STA collision
    STA on_ground
    LDA x_pos+1
    CLC
    ADC #$PLAYERWIDTH-1
    STA R0          ; right edge
    LDA Y_pos+1
    CLC
    ADC #$PLAYERHEIGHT-1
    STA R1          ; bottom edge


    LDA x_pos+1     ; top left corner
    LSR
    LSR
    LSR
    LSR
    STA R2
    LDA y_pos+1
    AND #$0f
    CLC
    ADC R2
    TAX
    STA tilemap,X
    BEQ :+
    INC collision
    LDA x_pos+1
    AND #$0f
    SEC
    SBC #$10
    STA x_eject
    LDA y_pos+1
    AND #$0f
    SEC
    SBC #$10
    STA y_eject
:
    LDA R0          ; top right corner
    LSR
    LSR
    LSR
    LSR
    STA R2
    LDA y_pos+1
    AND #$0f
    CLC
    ADC R2
    TAX
    STA tilemap,X
    BEQ :+
    INC collision
    LDA R0
    AND #$0f
    CLC
    ADC #$01
    STA x_eject
    LDA y_pos+1
    AND #$0f
    SEC
    SBC #$10
    STA y_eject
:
    LDA x_pos+1     ; bottom left corner
    LSR
    LSR
    LSR
    LSR
    STA R2
    LDA R1
    AND #$0f
    CLC
    ADC R2
    TAX
    STA tilemap,X
    BEQ :+
    INC collision
    INC on_ground
    LDA x_pos+1
    AND #$0f
    SEC
    SBC #$10
    STA x_eject
    LDA R1
    AND #$0f
    CLC
    ADC #$01
    STA y_eject
:
    LDA R0          ; bottom right corner
    LSR
    LSR
    LSR
    LSR
    STA R2
    LDA R1
    AND #$0f
    CLC
    ADC R2
    TAX
    STA tilemap,X
    BEQ :+
    INC collision
    INC on_ground
    LDA R0
    AND #$0f
    CLC
    ADC #$01
    STA x_eject
    LDA R1
    AND #$0f
    CLC
    ADC #$01
    STA y_eject
:
    RTS