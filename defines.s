; Constants
OAMBUF    = $0200   ; The location in memory of the sprite buffer in CPU memory that gets copied into OAM every frame
VRAMBUF   = $0300   ; The location in memory of the VRAM write buffer in CPU memory that stores changes to VRAM that are made each frame

; Registers
PPUCTRL   = $2000   ; VPHB SINN -> NMI enable (V), PPU master/slave (P), sprite height (H), background tile select (B), sprite tile select (S), increment mode (I), nametable select (NN)
PPUMASK   = $2001   ; BGRs bMmG -> color emphasis (BGR), sprite enable (s), background enable (b), sprite left column enable (M), background left column enable (m), greyscale (G)
PPUSTATUS = $2002   ; VSO- ---- -> vblank (V), sprite 0 hit (S), sprite overflow (O); read resets write pair for $2005/$2006
OAMADDR   = $2003   ; aaaa aaaa -> OAM read/write address
OAMDATA   = $2004   ; dddd dddd -> OAM data read/write
PPUSCROLL = $2005   ; xxxx xxxx -> fine scroll position (two writes: X scroll, Y scroll)
PPUADDR   = $2006   ; aaaa aaaa -> PPU read/write address (two writes: most significant byte, least significant byte)
PPUDATA   = $2007   ; dddd dddd -> PPU data read/write

OAMDMA    = $4014   ; aaaa aaaa -> OAM DMA high address
SNDCHN    = $4015   ; ---D NT21 -> Control: DMC enable, length counter enables: noise, triangle, pulse 2, pulse 1 (write)
                    ; IF-D NT21 -> Status: DMC interrupt, frame interrupt, length counter status: noise, triangle, pulse 2, pulse 1 (read)
JOY1      = $4016   ; Controller 1 Read
JOY2      = $4017   ; Controller 2 Read
                    ; SD-- ---- -> Frame counter: 5-frame sequence, disable frame interrupt (write)

BUTTON_A      = 1 << 7
BUTTON_B      = 1 << 6
BUTTON_SELECT = 1 << 5
BUTTON_START  = 1 << 4
BUTTON_UP     = 1 << 3
BUTTON_DOWN   = 1 << 2
BUTTON_LEFT   = 1 << 1
BUTTON_RIGHT  = 1 << 0

MAPCMD    = $8000   ; ---- CCCC -> The mapper command number to execute
MAPDATA   = $A000   ; PPPP PPPP -> The parameter for the mapper command


; Mapper Commands:
BNKCHR0   = $00     ; BBBB BBBB -> CHR0 Bank Select (B)
BNKCHR1   = $01     ; BBBB BBBB -> CHR1 Bank Select (B)
BNKCHR2   = $02     ; BBBB BBBB -> CHR2 Bank Select (B)
BNKCHR3   = $03     ; BBBB BBBB -> CHR3 Bank Select (B)
BNKCHR4   = $04     ; BBBB BBBB -> CHR4 Bank Select (B)
BNKCHR5   = $05     ; BBBB BBBB -> CHR5 Bank Select (B)
BNKCHR6   = $06     ; BBBB BBBB -> CHR6 Bank Select (B)
BNKCHR7   = $07     ; BBBB BBBB -> CHR7 Bank Select (B)
BNKPRG0   = $08     ; ERBB BBBB -> RAM enable (E), ROM/RAM select (R), PRG0 Bank Select (B)
BNKPRG1   = $09     ; --BB BBBB -> PRG1 Bank Select (B)
BNKPRG2   = $0A     ; --BB BBBB -> PRG2 Bank Select (B)
BNKPRG3   = $0B     ; --BB BBBB -> PRG3 Bank Select (B)
MIRROR    = $0C     ; ---- --MM -> Nametable mirroring configuration (M): 0 = Vertical, 1 = Horizontal, 2 = One-Screen A, 3 = One-Screen B
IRQCTRL   = $0D     ; C--- ---T -> IRQ counter enable (C), IRQ enable (T)
IQRLOW    = $0E     ; LLLL LLLL -> IRQ counter low byte
IRQHIGH   = $0F     ; HHHH HHHH -> IRQ counter high byte

PLAYERWIDTH  = $08
PLAYERHEIGHT = $10

WALLJUMPVEL  = $03  ; the x velocity applied when the player wall jumps in pixels
JUMPVELOCITY = $07  ; the y velocity applied when the player jumps in pixels
MOVEACCEL    = $40  ; the acceleration applied by movement each frame in subpixels
MOVEDRAG     = $40  ; the deceleration applied by drag each frame in subpixels
LOWGRAV      = $40  ; the acceleration applied by gravity each frame while holding jump in subpixels
HIGHGRAV     = $C0  ; the acceleration applied by gravity each frame in subpixels
FALLSPEED    = $05  ; the terminal velocity when falling in pixels
SLIDESPEED   = $02  ; the terminal velocity when sliding down a wall in pixels
MOVESPEED    = $04  ; the max horizontal move speed in pixels
