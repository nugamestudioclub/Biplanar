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

;; Takes in x,y of thing colliding and the hight and width of the hitbox. Only rectangular collsions. Check if any overlap between player and hitbox: will be some math. Figure out. The hard part is the eject amount.
.proc sp_collision ;; Collides the player with another sprite. Params:  - R0: x of sprite to check  - R1: y of sprite to check  - R2: width of sprite to check  - R3: height of sprite to check     Mutates: R2, R3, R4, R5
;; Player boundries
p_left    := x_pos+1
p_right   := R4 ; Not until initialized!
p_top     := y_pos+1
p_bottom  := R5 ; Not until initialized!

;; Sprite boundries
s_left    := R0
s_right   := R2 ; Not until initialized! at this point, R2 is the sprite width!
s_top     := R1
s_bottom  := R3 ; Not until initialized! at this point, R3 is the sprite hight!

;; Initializing state
    ; LDA #$00
    ; STA x_eject
    ; STA y_eject
    ; STA collision // will want to check collision eventually, see if collide with both

;; Initializing player right and bottom
    LDA p_left
    CLC
    ADC #PLAYERWIDTH-1
    STA p_right       ; right edge
    LDA p_top
    CLC
    ADC #PLAYERHEIGHT-1
    STA p_bottom      ; bottom edge

;; Initializing sprite right and bottom
    LDA s_left
    CLC
    ADC #s_right-1    ; s_right is currently the sprite width
    STA s_right       ; s_right is now the sprite right edge
    LDA s_top
    CLC
    ADC #s_bottom-1   ; s_bottom is currently the sprite height
    STA p_bottom      ; s_bottom is now the sprite bottom edge

    ;; Compare p_right to s_left, branch to end if p_right < s_left
    LDA p_right
    CMP s_left
    BCC @end
    ;; Compare s_right to p_left, branch to end if s_right < p_left 
    LDA s_right
    CMP p_left
    BCC @end
    ;; Compare p_bottom to s_top, branch to end if p_bottom < s_top
    LDA p_bottom
    CMP s_top
    BCC @end
    ;; Compare s_bottom to p_top, branch to end if s_bottom < p_top
    LDA s_bottom
    CMP p_top
    BCC @end

    LDA #$01
    STA p_is_dead ;; TEMPORARY: kill player on sprite collision

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