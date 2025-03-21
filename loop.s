mainloop:              ; the main game tick loop
    JSR nmiwait        ; wait until next frame

    LDA #BNKPRG0
    STA MAPCMD
    LDA #%11000001
    STA MAPDATA
    JSR famistudio_update

    LDA dimension
    EOR #$01
    STA dimension

    LDA #BNKPRG0
    STA MAPCMD
    LDA #%11000000
    STA MAPDATA
    JSR famistudio_update

    LDA dimension
    EOR #$01
    STA dimension

    LDA #$01        ; read controller
    STA JOY1
    STA controller     ; initialize the controller variable to $01 so that once the 8 button values are shifted in, 1 will be placed into the carry
    LSR a
    STA JOY1
:
    LDA JOY1
    LSR a              ; move the button value from bit 0 of A to the carry flag
    ROL controller     ; move the button value from the carry flag to bit 0 of the controller variable, shifting the other buttons as a result
    BCC :-             ; the carry flag will be 1 if the controller variable has been shifted left 8 times, indicating that all 8 buttons have been read



    LDA controller     ; right button
    AND #BUTTON_RIGHT
    BEQ @noright
    LDA #$00
    STA player_dir
    CLC                ; increase the X velocity by an acceleration amount of 0.25
    LDA x_vel+0
    ADC #MOVEACCEL
    STA x_vel+0
    LDA x_vel+1
    ADC #$00
    STA x_vel+1
    BMI gravity
    CMP #MOVESPEED
    BCC gravity
    LDA #$00
    STA x_vel+0
    LDA #MOVESPEED
    STA x_vel+1
    JMP gravity
@noright:
    LDA controller     ; left button
    AND #BUTTON_LEFT
    BEQ @noleft
    LDA #$40
    STA player_dir
    SEC                ; decrease the X velocity by an acceleration amount of 0.25
    LDA x_vel+0
    SBC #MOVEACCEL
    STA x_vel+0
    LDA x_vel+1
    SBC #$00
    STA x_vel+1
    BPL gravity
    CMP #(MOVESPEED ^ $FF)+2
    BCS gravity
    LDA #$00
    STA x_vel+0
    LDA #(MOVESPEED ^ $FF)+1
    STA x_vel+1
    JMP gravity
@noleft:
    JSR applydrag

    LDA on_wall         ; If we aren't on a wall, just go to gravity.
    BEQ gravity         ;

    LDA player_dir      ; If the player is facing right...
    BEQ wall_left
    DEC x_vel+1         ; Increment the MSB (Pixel vel) of x_vel by 1
    JMP gravity
wall_left:              ; Otherwise (when the player is facing left)...
    INC x_vel+1         ; Decrement the MSB (Pixel vel) of x_vel by 1


gravity:
    LDA #FALLSPEED
    STA R0
    LDA on_wall
    BEQ :+
    LDA #SLIDESPEED
    STA R0
:

    LDA y_vel+1
    BMI applygravity
    CMP R0
    BCS terminal_velocity
applygravity:
    LDA controller
    AND #BUTTON_A
    BNE lowgrav
    LDA #HIGHGRAV
    JMP gravready
lowgrav:
    LDA #LOWGRAV
gravready:
    CLC
    ADC y_vel+0
    STA y_vel+0
    LDA y_vel+1
    ADC #$00
    STA y_vel+1
    JMP handlejump
terminal_velocity:
    LDA #$00
    STA y_vel+0
    LDA R0
    STA y_vel+1

handlejump:
    LDA on_ground
    ORA on_wall
    BEQ applyvelocity
    LDA controller
    AND #BUTTON_A
    BEQ releasejump
    LDA jumping
    BNE applyvelocity
    LDA #$01
    STA jumping
    LDA #$00
    STA y_vel+0
    LDA #(JUMPVELOCITY ^ $FF)+1
    STA y_vel+1
    LDA on_wall
    BEQ applyvelocity
    LDA #$00
    STA x_vel+0
    LDA player_dir
    BEQ @left
    LDA #WALLJUMPVEL
    STA x_vel+1
    JMP applyvelocity
@left:
    LDA #(WALLJUMPVEL ^ $FF)+1
    STA x_vel+1
    JMP applyvelocity
releasejump:
    LDA #$00
    STA jumping


applyvelocity:
    CLC                ; apply X velocity
    LDA x_pos+0
    ADC x_vel+0
    STA x_pos+0
    LDA x_pos+1
    ADC x_vel+1
    STA x_pos+1

    LDA #$00
    STA on_wall


    LDA #$00           ; dimension switch
    STA swapped
    LDX #<VRAMBUF
    LDY #>VRAMBUF
    LDA controller
    AND #BUTTON_B
    BEQ releaseswap
    LDA swap_held
    BNE @setbuffer
    LDA #$01
    STA swap_held
    STA swapped
    LDA dimension
    EOR #$01
    STA dimension
    LDA #BNKPRG0
    STA MAPCMD
    LDA #%11000000
    AND dimension
    STA MAPDATA
    LDA #$80
    STA famistudio_pulse1_prev
    STA famistudio_pulse2_prev
    LDA dimension
    BNE @darkworld
@lightworld:
    LDA #<light_col
    STA R0
    LDA #>light_col
    STA R1
    JSR applycolbuffer
    LDX #<light_vram
    LDY #>light_vram
    BNE @setbuffer
@darkworld:
    LDA #<dark_col
    STA R0
    LDA #>dark_col
    STA R1
    JSR applycolbuffer
    LDX #<dark_vram
    LDY #>dark_vram
@setbuffer:
    STX vram_pointer+0
    STY vram_pointer+1
    JSR bg_collision
    LDA collision      ; If we collide on dimention switch, the player is dead.
    STA p_is_dead
    
    JMP player_collision

releaseswap:
    STA swap_held
    
player_collision:
    JSR bg_collision   ; X collision
    LDA collision
    BEQ @no_x_col
    LDA #$01
    STA on_wall
    LDA #$00
    STA x_vel+1
    STA x_vel+0
    LDX player_dir
    BNE @backwards
    LDA #$C0
@backwards:
    STA x_pos+0
    LDA x_pos+1
    SEC
    SBC x_eject
    STA x_pos+1
    JMP apply_y_vel
@no_x_col:
    LDA on_wall
    BEQ apply_y_vel
    SEC
    LDA x_pos+0
    SBC x_vel+0
    STA x_pos+0
    LDA x_pos+1
    SBC x_vel+1
    STA x_pos+1
    LDA #$00
    STA x_vel+1
    STA x_vel+0
apply_y_vel:
    CLC                ; apply Y velocity
    LDA y_pos+0
    ADC y_vel+0
    STA y_pos+0
    LDA y_pos+1
    ADC y_vel+1
    STA y_pos+1

    JSR bg_collision   ; Y collision
    LDA collision
    BEQ :+
    LDA #$00
    STA y_vel+1
    STA y_vel+0
    LDA #$C0
    STA y_pos+0
    LDA y_pos+1
    SEC
    SBC y_eject
    STA y_pos+1
:


drawplayer:
    JSR oamclear       ; draw sprites

    LDA on_wall
    BNE @sliding
    LDA on_ground
    BNE @grounded
    LDA y_vel+1
    CMP #$F9
    BNE :+
    LDA #$12
    JMP @draw_sprite
:
    CMP #$FE
    BCS @peak
    CMP #$FA
    BCS @upward
    CMP #$03
    BCC @peak
    LDA #$18
    JMP @draw_sprite
@upward:
    LDA #$14
    JMP @draw_sprite
@peak:
    LDA #$16
    JMP @draw_sprite

@grounded:
    LDA x_vel+1; set player animation
    BNE @running
    LDA #.LOBYTE(idle_anim)
    LDX #.HIBYTE(idle_anim)
    BNE @set_anim
@running:
    LDA #.LOBYTE(running_anim)
    LDX #.HIBYTE(running_anim)
    BNE @set_anim
@sliding:
    LDA #.LOBYTE(sliding_anim)
    LDX #.HIBYTE(sliding_anim)
@set_anim:
    STA player_anim+0
    STX player_anim+1


    LDA frame_counter  ; player sprite
    AND #%00000111
    BNE :+
    INC p_anim_frame
:
    LDY #$00
    LDA p_anim_frame
    CMP (player_anim), y
    BCC :+
    STY p_anim_frame
:
    LDY p_anim_frame
    INY
    LDA (player_anim), y
@draw_sprite:
    STA R0
    LDA x_pos+1
    STA R1
    LDA y_pos+1
    STA R2
    LDA #%00000000
    ORA player_dir
    STA R3
    JSR oamsprite


    ; Uncomment for metasprite test
    ; LDA #.LOBYTE(test_metasprite)   ; Load the memory address of test_metasprite into R4 and R5, so that it is passed to oammetasprite
    ; STA R4
    ; LDA #.HIBYTE(test_metasprite)
    ; STA R5
    ; LDA #128                        ; Use 128 as the X and Y pos parameters in oammetasprite
    ; STA R6
    ; STA R7
    ; JSR oammetasprite
    
    LDA p_is_dead                     ; If the player is dead, RESET
    BEQ :+
    JMP RESET
:
    JMP mainloop