mainloop:           ; the main game tick loop
    JSR nmiwait     ; wait until next frame


    LDA #$01        ; read controller
    STA JOY1
    STA controller  ; initialize the controller variable to $01 so that once the 8 button values are shifted in, 1 will be placed into the carry
    LSR a
    STA JOY1
:
    LDA JOY1
    LSR a           ; move the button value from bit 0 of A to the carry flag
    ROL controller  ; move the button value from the carry flag to bit 0 of the controller variable, shifting the other buttons as a result
    BCC :-          ; the carry flag will be 1 if the controller variable has been shifted left 8 times, indicating that all 8 buttons have been read



    LDA controller  ; right button
    AND #%00000001
    BEQ @noright
    CLC             ; increase the X velocity by an acceleration amount of 0.25
    LDA x_vel+0
    ADC #$40
    STA x_vel+0
    LDA x_vel+1
    ADC #$00
    STA x_vel+1
    CMP #$04
    BCC applyvelocity
    LDA #$00
    STA x_vel+0
    LDA #$04
    STA x_vel+1
    JMP applyvelocity
@noright:
    LDA controller  ; left button
    AND #%00000010
    BEQ @noleft
    SEC             ; decrease the X velocity by an acceleration amount of 0.25
    LDA x_vel+0
    SBC #$40
    STA x_vel+0
    LDA x_vel+1
    SBC #$00
    STA x_vel+1
    CMP #$FD
    BCS applyvelocity
    LDA #$FF
    STA x_vel+0
    LDA #$FC
    STA x_vel+1
    JMP applyvelocity
@noleft:
    LDA x_vel+0
    BNE applydrag
    LDA x_vel+1
    BNE applydrag
    JMP applyvelocity
applydrag:
    LDA x_vel+1
    BMI @negative
    BNE :+          ; positive velocity drag
    LDA x_vel+0
    CMP #$80
    BCS :+
    LDA #$00
    STA x_vel+0
    JMP applyvelocity
:
    SEC
    LDA x_vel+0
    SBC #$80
    STA x_vel+0
    LDA x_vel+1
    SBC #$00
    STA x_vel+1
    JMP applyvelocity
@negative:          ; negative velocity drag
    CMP #$FF
    BNE :+
    LDA x_vel+0
    CMP #81
    BCC :+
    LDA #$00
    STA x_vel+0
    STA x_vel+1
:
    CLC
    LDA x_vel+0
    ADC #$80
    STA x_vel+0
    LDA x_vel+1
    ADC #$00
    STA x_vel+1
applyvelocity:
    CLC             ; apply X velocity
    LDA x_pos+0
    ADC x_vel+0
    STA x_pos+0
    LDA x_pos+1
    ADC x_vel+1
    STA x_pos+1

    CLC             ; apply Y velocity
    LDA y_pos+0
    ADC y_vel+0
    STA y_pos+0
    LDA y_pos+1
    ADC y_vel+1
    STA y_pos+1


    JSR oamclear

    LDA #$00
    STA R0
    LDA x_pos+1
    STA R1
    LDA y_pos+1
    STA R2
    LDA #%10000000
    STA R3
    JSR oamsprite

    JMP mainloop