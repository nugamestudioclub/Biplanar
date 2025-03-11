lightpalette:
    .byte $00, $0f, $2d, $10, $00, $10, $00, $0f, $00, $10, $00, $0f, $00, $10, $00, $0f
    .byte $00, $0f, $06, $38, $00, $10, $00, $0f, $00, $10, $00, $0f, $00, $10, $00, $0f

lightupdate:
    .byte $7F, $00, $20
    .byte $00, $0f, $2d, $10, $00, $10, $00, $0f, $00, $10, $00, $0f, $00, $10, $00, $0f
    .byte $00, $0f, $06, $38, $00, $10, $00, $0f, $00, $10, $00, $0f, $00, $10, $00, $0f
    ; dark platforms
    .byte $62, $84, $06
    .byte $0d, $0d, $0d, $0d, $0d, $0d
    .byte $62, $a4, $06
    .byte $0d, $0d, $0d, $0d, $0d, $0d
    .byte $60, $c4, $06
    .byte $0d, $0d, $0d, $0d, $0d, $0d
    .byte $60, $e4, $06
    .byte $0d, $0d, $0d, $0d, $0d, $0d
    ; light platform
    .byte $61, $94, $06
    .byte $00, $01, $01, $01, $01, $02
    .byte $61, $b4, $06
    .byte $06, $07, $07, $07, $07, $08
    .byte $FF


darkupdate:
    .byte $7F, $00, $20
    .byte $16, $0f, $06, $26, $16, $10, $00, $0f, $16, $10, $00, $0f, $16, $10, $00, $0f
    .byte $16, $20, $21, $38, $16, $10, $00, $0f, $16, $10, $00, $0f, $16, $10, $00, $0f
    ; dark platforms
    .byte $62, $84, $06
    .byte $00, $01, $01, $01, $01, $02
    .byte $62, $a4, $06
    .byte $06, $07, $07, $07, $07, $08
    .byte $60, $c4, $06
    .byte $00, $01, $01, $01, $01, $02
    .byte $60, $e4, $06
    .byte $06, $07, $07, $07, $07, $08
    ; light platform
    .byte $61, $94, $06
    .byte $0d, $0d, $0d, $0d, $0d, $0d
    .byte $61, $b4, $06
    .byte $0d, $0d, $0d, $0d, $0d, $0d
    .byte $FF

; metatile palette
meta_ul:            ; top left corner
    .byte $0D, $00, $01, $01, $00, $01, $01, $01
meta_ur:            ; top right corner
    .byte $0D, $01, $01, $02, $01, $01, $02, $01
meta_dl:            ; bottom left corner
    .byte $0D, $03, $04, $04, $06, $07, $07, $01
meta_dr:            ; bottom right corner
    .byte $0D, $04, $04, $05, $07, $07, $08, $01
meta_col:           ; collision type
    .byte $00, $80, $80, $80, $80, $80, $80, $01

meta_map:
    .byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    .byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    .byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    .byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    .byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    .byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    .byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $04, $05, $06, $00, $00, $00
    .byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    .byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    .byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    .byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $07, $07, $00, $00, $00, $00
    .byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    .byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    .byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    .byte $01, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $03
meta_map2:
    .byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    .byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    .byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    .byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    .byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    .byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    .byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    .byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    .byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    .byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    .byte $00, $00, $00, $00, $00, $00, $01, $00, $00, $00, $00, $00, $00, $00, $00, $00
    .byte $00, $00, $00, $00, $00, $00, $02, $00, $00, $00, $00, $00, $00, $00, $00, $00
    .byte $00, $00, $00, $00, $00, $00, $02, $00, $00, $00, $00, $00, $00, $00, $00, $00
    .byte $00, $00, $00, $00, $00, $00, $02, $00, $00, $00, $00, $00, $00, $00, $00, $00
    .byte $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01

test_metasprite:
    .byte $03 * 4 ; Number of sprites multiplied by 4 (number of times to loop)
    .byte $00 ; Sprite 1 Tile index
    .byte $00 ; Sprite 1 X offset
    .byte $00 ; Sprite 1 Y offset
    .byte $00 ; Sprite 1 Attributes
    .byte $02 ; Sprite 2 Tile index
    .byte $08 ; Sprite 2 X offset
    .byte $00 ; Sprite 2 Y offset
    .byte $00 ; Sprite 2 Attributes
    .byte $02 ; Sprite 3 Tile index
    .byte $00 ; Sprite 3 X offset
    .byte $10 ; Sprite 3 Y offset
    .byte $00 ; Sprite 3 Attributes

idle_anim:
    .byte $04, $00, $02, $04, $02

running_anim:
    .byte $04, $06, $08, $0A, $0C

sliding_anim:
    .byte $02, $0E, $10

dark_tiles1:
    .byte $32, $03, $04, $05, $06
    .byte $6A, $03, $00, $00, $00
    .byte $A3, $03, $04, $05, $06
    .byte $FF