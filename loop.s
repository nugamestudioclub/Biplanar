mainloop:              ; the main game tick loop
    JSR nmiwait        ; wait until next frame


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
    AND #%00000001
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
    CMP #$04
    BCC gravity
    LDA #$00
    STA x_vel+0
    LDA #$04
    STA x_vel+1
    JMP gravity
@noright:
    LDA controller     ; left button
    AND #%00000010
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
    CMP #$FD
    BCS gravity
    LDA #$00
    STA x_vel+0
    LDA #$FC
    STA x_vel+1
    JMP gravity
@noleft:
    JSR applydrag

gravity:
    LDA y_vel+1
    BMI applygravity
    CMP #$05
    BCS :+
applygravity:
    CLC
    LDA controller
    AND #%10000000
    BNE lowgrav
    LDA #$C0
    JMP gravready
lowgrav:
    LDA #$40
gravready:
    ADC y_vel+0
    STA y_vel+0
    LDA y_vel+1
    ADC #$00
    STA y_vel+1
    JMP handlejump
:
    LDA #$00
    STA y_vel+0
    LDA #$05
    STA y_vel+1

handlejump:
    LDA on_ground
    BEQ applyvelocity
    LDA controller
    AND #%10000000
    BEQ releasejump
    LDA jumping
    BNE applyvelocity
    LDX #$00
    STX on_ground
    INX
    STX jumping
    LDA #$F9
    STA y_vel+1
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

    JSR bg_collision   ; X collision
    LDA collision
    BEQ :+
    LDA #$00
    STA x_vel+1
    STA x_vel+0
    STA x_pos+0
    LDA x_pos+1
    SEC
    SBC x_eject
    STA x_pos+1
:

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



    JSR oamclear       ; draw sprites

    LDA frame_counter  ; player sprite
    LSR
    LSR
    AND #%00000110
    CMP #$06
    BNE :+
    LDA #$02
:
    STA R0
    LDA x_pos+1
    STA R1
    LDA y_pos+1
    STA R2
    LDA #%00000000
    ORA player_dir
    STA R3
    JSR oamsprite

    JMP mainloop