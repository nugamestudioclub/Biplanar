.segment "ZEROPAGE"           ; The first page of internal RAM
    R0:            .res 1     ; Scratch Registers
    R1:            .res 1
    R2:            .res 1
    R3:            .res 1
    R4:            .res 1
    R5:            .res 1
    R6:            .res 1
    R7:            .res 1
    R8:            .res 1
    R9:            .res 1
    R10:           .res 1
    R11:           .res 1
    R12:           .res 1
    R13:           .res 1
    R14:           .res 1
    R15:           .res 1
    ppu_ctrl:      .res 1     ; A CPU side mirror of the PPUCTRL register
    vram_index:    .res 1     ; Current index of the VRAM buffer
    vram_pointer:  .res 2     ; The 16-bit memory address of the start of the VRAM buffer
    frame_counter: .res 1     ; General purpose frame counter
    x_scroll:      .res 2     ; X position of screen scroll (LSB: pixel position, MSB: screen number)
    y_scroll:      .res 2     ; Y position of screen scroll (LSB: pixel position, MSB: screen number)
    oam_index:     .res 1     ; Current index of the OAM buffer
    controller:    .res 1     ; Controller input
    player_dir:    .res 1     ; Facing direction of the player
    dimension:     .res 1     ; The current dimension of the player (0: light world, 1: dark world)
    swapped:       .res 1     ; Whether the dimension has just been swapped
    swap_held:     .res 1     ; Whether the swap dimension button was held last frame
    x_pos:         .res 2     ; X position of the player (LSB: subpixel position, MSB: pixel position)
    y_pos:         .res 2     ; Y position of the player (LSB: subpixel position, MSB: pixel position)
    x_vel:         .res 2     ; X velocity of the player (LSB: subpixel velocity, MSB: pixel velocity)
    y_vel:         .res 2     ; Y velocity of the player (LSB: subpixel velocity, MSB: pixel velocity)

    x_eject:       .res 1     ; The amount to push the player out of a block on the x axis after they collide
    y_eject:       .res 1     ; The amount to push the player out of a block on the y axis after they collide
    collision:     .res 1     ; Whether a collision has occured
    on_ground:     .res 1     ; Whether the player is on the ground
    jumping:       .res 1     ; Whether the jump button was held last frame
    on_wall:       .res 1     ; Whether the player is sliding down a wall
    player_anim:   .res 2     ; The memory location of the current player animation
    p_anim_frame   .res 1     ; The current frame of the player's animation


.segment "RAM"                ; The rest of internal RAM after ZP, the OAM buffer, and the VRAM buffer
    tilemap:       .res 240   ; A map that stores which tiles are solid
    tilemap2:      .res 240
.segment "PRG_RAM0"            ; Extra cartridge RAM
.segment "PRG_RAM1"            ; Extra cartridge RAM