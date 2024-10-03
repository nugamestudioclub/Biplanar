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


    LDA x_pos+1    ; top left corner
    LSR
    LSR
    LSR
    LSR
    STA R0
    LDA y_pos+1
    AND #$0f
    CLC
    ADC R0
    TAX
    STA tilemap,X
    BEQ :+
    ;collision stuff goes here
:
    ;code continues here

    