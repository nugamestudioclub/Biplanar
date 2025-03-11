.proc bg_collision  ; collides the player with the background tiles
left    := x_pos+1
right   := R0
top     := y_pos+1
bottom  := R1
    LDA #$00
    STA x_eject
    STA y_eject
    STA collision
    STA on_ground
    LDA left
    CLC
    ADC #PLAYERWIDTH-1
    STA right       ; right edge
    LDA top
    CLC
    ADC #PLAYERHEIGHT-1
    STA bottom      ; bottom edge


    LDA left        ; top left corner
    LSR A
    LSR A
    LSR A
    LSR A
    STA R2          ; The lower 4 bits store the x position of the tile in the tile map
    LDA top
    AND #$f0        ; The upper 4 bits store the y position of the tile in the tile map
    CLC
    ADC R2
    TAX             ; X is now the index of the tile contianing the player's top-left corner
    LDA tilemap,X
    BPL :+          ; if the tile has collision (It's MSB is 1 and thus is considered negative), collide
    INC collision
    LDA left
    AND #$0f
    SEC
    SBC #$10
    STA x_eject
    LDA top
    AND #$0f
    SEC
    SBC #$10
    STA y_eject
    BVC @top_right
:
    AND #$01         ; Death collision: if the tile is $01, the player is dead.
    BEQ @top_right
    STA p_is_dead

@top_right:
    LDA right       ; top right corner
    LSR A
    LSR A
    LSR A
    LSR A
    STA R2
    LDA top
    AND #$f0
    CLC
    ADC R2
    TAX
    LDA tilemap,X
    BPL :+
    INC collision
    LDA right
    AND #$0f
    CLC
    ADC #$01
    STA x_eject
    LDA top
    AND #$0f
    SEC
    SBC #$10
    STA y_eject
    BVC @bot_left
:
    AND #$01         ; Death collision: if the tile is $01, the player is dead.
    BEQ @bot_left
    STA p_is_dead

@bot_left:
    LDA left        ; bottom left corner
    LSR A
    LSR A
    LSR A
    LSR A
    STA R2
    LDA bottom
    AND #$f0
    CLC
    ADC R2
    TAX
    LDA tilemap,X
    BPL :+
    INC collision
    INC on_ground
    LDA left
    AND #$0f
    SEC
    SBC #$10
    STA x_eject
    LDA bottom
    AND #$0f
    CLC
    ADC #$01
    STA y_eject
    BVC @bot_right
:
    AND #$01         ; Death collision: if the tile is $01, the player is dead.
    BEQ @bot_right
    STA p_is_dead

@bot_right:
    LDA right       ; bottom right corner
    LSR A
    LSR A
    LSR A
    LSR A
    STA R2
    LDA bottom
    AND #$f0
    CLC
    ADC R2
    TAX
    LDA tilemap,X
    BPL :+
    INC collision
    INC on_ground
    LDA right
    AND #$0f
    CLC
    ADC #$01
    STA x_eject
    LDA bottom
    AND #$0f
    CLC
    ADC #$01
    STA y_eject
    BVC @end
:
    AND #$01         ; Death collision: if the tile is $01, the player is dead.
    BEQ @end
    STA p_is_dead

@end:
    RTS
.endproc



applydrag:
    LDA x_vel+0
    BNE :+
    LDA x_vel+1
    BNE :+
    RTS
:
    LDA x_vel+1
    BMI @negative
    BNE :+             ; positive velocity drag
    LDA x_vel+0
    CMP #MOVEDRAG
    BCS :+
    LDA #$00
    STA x_vel+0
    RTS
:
    SEC
    LDA x_vel+0
    SBC #MOVEDRAG
    STA x_vel+0
    LDA x_vel+1
    SBC #$00
    STA x_vel+1
    RTS
@negative:             ; negative velocity drag
    CMP #$FF
    BNE :+
    LDA x_vel+0
    CMP #MOVEDRAG+1
    BCC :+
    LDA #$00
    STA x_vel+0
    STA x_vel+1
:
    CLC
    LDA x_vel+0
    ADC #MOVEDRAG
    STA x_vel+0
    LDA x_vel+1
    ADC #$00
    STA x_vel+1
    RTS