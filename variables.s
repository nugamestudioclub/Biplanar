.segment "ZEROPAGE"           ; The first page of internal RAM
    R0:            .res 1     ; Scratch Registers
    R1:            .res 1
    R2:            .res 1
    R3:            .res 1
    vram_index:    .res 1     ; Current index of the VRAM buffer
    frame_counter: .res 1     ; General purpose frame counter
    x_scroll:      .res 2     ; X position of screen scroll (LSB: pixel position, MSB: screen number)
    y_scroll:      .res 2     ; Y position of screen scroll (LSB: pixel position, MSB: screen number)
    oam_index:     .res 1     ; Current index of the OAM buffer
    controller:    .res 1     ; Controller input
    x_pos:         .res 2     ; X position of the player (LSB: subpixel position, MSB: pixel position)
    y_pos:         .res 2     ; Y position of the player (LSB: subpixel position, MSB: pixel position)
    x_vel:         .res 2     ; X velocity of the player (LSB: subpixel velocity, MSB: pixel velocity)
    y_vel:         .res 2     ; Y velocity of the player (LSB: subpixel velocity, MSB: pixel velocity)

.segment "RAM"                ; The rest of internal RAM after ZP, the OAM buffer, and the VRAM buffer
    tilemap:       .res 240   ; A map that stores which tiles are solid
.segment "PRG_RAM"            ; Extra cartridge RAM