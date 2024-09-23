.segment "ZEROPAGE"
    R0:            .res 1
    R1:            .res 1
    R2:            .res 1
    R3:            .res 1
    vram_index:    .res 1
    frame_counter: .res 1
    x_scroll:      .res 2
    y_scroll:      .res 2
    oam_index:     .res 1
    controller:    .res 1
    x_pos:         .res 2
    y_pos:         .res 2
    x_vel:         .res 2
    y_vel:         .res 2

.segment "RAM"
.segment "PRG_RAM"