arch gba.thumb

//==============================================================================
// Relocation hacks
//==============================================================================

// Move the weird box font from 0xFCE6C
org $80B3274; dd m2_font_relocate

//==============================================================================
// Font hacks
//==============================================================================

org $8AFED84; incbin m2-mainfont1-empty.bin
org $8B0F424; incbin m2-mainfont2-empty.bin
org $8B13424; incbin m2-mainfont3-empty.bin
org $8B088A4; incbin m2-shifted-cursor.bin

//==============================================================================
// Control code hacks
//==============================================================================

org $80CA2BC; bl m2_customcodes.check_main
org $80C90A2; bl m2_customcodes.check_status

//==============================================================================
// VWF hacks
//==============================================================================

org $80C96F0; push {lr}; bl m2_vwf.print_string_relative; pop {pc}

// Main entry
org $80CA448; push {lr}; bl m2_vwf.main; b $80CA46C

// Status entry
org $80C9116; push {lr}; bl m2_vwf.status; b $80C9144

// Goods entry
org $80BFB3E; bl m2_goods.entry; b $80BFB78 // unfocused
org $80BF0E2; bl m2_goods.entry2; b $80BF11A // focused
org $80C0162; bl m2_goods.entry2; b $80C0192 // giving item
org $80B999C; bl m2_goods.highlight

// Goods -- skip drawing equip symbols
org $80BFB98; b $80BFBCC
org $80BF134; b $80BF15E
org $80C01B2; b $80C01DC

// Goods -- dirty flags
org $80BF91E; bl m2_goods.dirty1
org $80BF8FC; bl m2_goods.dirty2
org $80B8540; bl m2_goods.dirty3
org $80BFC0E; bl m2_goods.clean
org $80C01F2; bl m2_goods.clean
org $80BF054; bl m2_goods.dirty4
org $80BFF34; bl m2_goods.dirty1
org $80BFF12; bl m2_goods.dirty2
org $80C00D4; bl m2_goods.dirty5
org $80C0260; bl m2_goods.dirty6

// Goods -- redrawing
org $80BA688; bl m2_goods.redraw // pressing B from Give window; redraw old Goods window
org $80B9CF8; bl m2_vwf.main_redraw // selecting the Use option; need to redraw the main menu

// PSI -- dirty flags
org $80B8CD2; bl m2_vwf.psi_menu_clear
org $80B8CEA; bl m2_vwf.psi_menu_draw
org $80B85F0; bl m2_vwf.psi_menu_dirty1
org $80C4048; bl m2_vwf.psi_menu_dirty2
org $80C4080; bl m2_vwf.psi_menu_dirty2

// Menu select entry
org $80B7FC6; bl m2_vwf.print_string_relative

// Selection menu entry
org $80C1CE0
bl      m2_customcodes.check_selection_menu
b       $80C1D10
bl      m2_vwf.selection_menu
b       $80C1D0A

org $80C1D18; bne $80C1CE6

// Disable coordinate incrementing
org $80CA48E; nop // X

// Disable menu redrawing
org $80B7E4E; nop; nop // Talk
org $80B81FA; nop; nop // Check

// Save the current tilebase
org $80BDA44; push {lr}; bl m2_vwf.save_tilebase

// Pixel-X resets
org $80BE4E0; bl m2_vwf.x_reset0 // Menu window
org $80BE45E; bl m2_vwf.x_reset3 // Cash window
org $80C9854; bl m2_vwf.x_reset1
org $80C9CBE; bl m2_vwf.x_reset2
org $80C9D5C; bl m2_vwf.x_reset2
org $80CA1FC; bl m2_vwf.x_reset2
org $80CA270; bl m2_vwf.x_reset1
org $80CA30A; bl m2_vwf.x_reset2
org $80CA332; bl m2_vwf.x_reset1
org $80C8F26; bl m2_vwf.x_reset4 // Newline after a menu selection
org $80C888C; bl m2_vwf.x_resetall // Use goods menu
org $80B9B34; bl m2_vwf.x_reset5 // Pressing Help!
// Possible other places: 80BE370, 80BE436,

// Erase a tile
org $80CA560; bl m2_vwf.erase_tile_short // short, one-liner windows
org $80CA8C4; bl m2_vwf.erase_tile_short2
org $80C8F2A; bl m2_vwf.erase_tile_main // main version

// Copy a tile upwards
org $80CA60E; bl m2_vwf.copy_tile

// Re-draw the status screen after exiting the PSI sub-menu
org $80BACFC; bl m2_formatting.status_redraw
org $80BADE6; bl m2_formatting.status_redraw

// PP cost: only print once
org $80B8B56; bl m2_vwf.ppcost_once
org $80B8B98; bl m2_vwf.ppcost_once2

// VWFs for printing character names
org $80D2EF0; ldrb r0,[r6,#0] // allows for 5 letters!
org $80D2F24
mov     r1,r6
mov     r2,r7
mov     r0,r4
bl      m2_vwf.weld_entry
b       $80D2F52

org $80D2F5A; nop

//==============================================================================
// Formatting hacks
//==============================================================================

// Cash window
org $80B785C; mov r0,#0xC // allocate 3 extra bytes for our positioning code
org $80B8A08; bl m2_formatting.format_cash
org $80B8A24; b $80B8A2E // skip the game's adding the $ and double-zero to the cash window

// Status window
org $80CA78A; mov r0,#0x60 // integer-to-char change 
org $80CA7AC; mov r2,#0x69 // integer-to-char change
org $80CA7EC; sub r1,#0xA0 // integer-to-char change

incsrc m2-status-initial.asm
incsrc m2-status-switch.asm

// Make the PSI type window bigger
org $80B7820; mov r1,#4 // X
org $80B7824; mov r3,#6 // width

// Greek letters
org $8B1B907; db $8B // alpha
org $8B1B90A; db $8C // beta
org $8B1B90D; db $8D // gamma
org $8B1B910; db $8E // sigma
org $8B1B913; db $8F // omega

// PSI stuff
org $80C21E4; bl m2_vwf.print_string_relative
org $80C21C4; bl m2_vwf.print_string_relative
org $80C2258; bl m2_vwf.print_string_relative
org $80C2270; bl m2_vwf.print_string_relative
org $80C22AC; bl m2_vwf.print_string_relative
org $80C22C4; bl m2_vwf.print_string_relative
org $80C203E; mov r1,#0x14 // new entry length
org $80C21B4; mov r1,#0x14
org $80C224A; mov r1,#0x14
org $80C229E; mov r1,#0x14

// PSI -- set clean/dirty flags
org $80BAD1A; bl m2_vwf.psi_clear1
org $80BAD28; bl m2_vwf.psi_clean1
org $80BE658; bl m2_vwf.cursor_dirty1
org $80BE764; bl m2_vwf.cursor_dirty1

// PSI help -- set clean/dirty flags
org $80BADCE; bl m2_vwf.psi_help_clear1
org $80BADD4; bl m2_vwf.psi_help_clean1
org $80C476A; bl m2_vwf.psi_help_dirty1
org $80C48B4; bl m2_vwf.psi_help_dirty1
org $80C4644; bl m2_vwf.psi_help_dirty2
org $80C4582; bl m2_vwf.psi_help_dirty2

// PSI target strings
org $80B8B12; mov r0,#0x14

// PSI Rockin
org $80C2192; mov r3,#8 // Y
org $80C219E
mov     r2,#0x71
bl      m2_formatting.status1

// Make PP cost use correct number values
org $80CA732
add     r1,#0x60

// Make PP cost use the correct space value if there's only one digit
org $80CA712
mov     r0,#0x50

// Fix PSI target offset calculation
org $80B8B08
mov     r1,#100
mul     r1,r2
nop
nop

// Enemy name length:

// Start of battle
org $80DB04E; add sp,#-0x20
org $80DB058; mov r2,#0x1D
org $80DB08C; mov r2,#0x19
org $80DB116; mov r1,#0x1D
org $80DB15A; add sp,#0x20

// Bash target
org $80DCD02; add sp,#-0x20
org $80DCD0C; mov r2,#0x1B
org $80DCD64; mov r2,#0x19
org $80DCDA2; mov r1,#0x1D

org $80DCDA8; add sp,#0x20

//==============================================================================
// Data files
//==============================================================================

org $8B2C000

// Box font relocation
m2_font_relocate:
incbin m2-font-relocate.bin

// Co-ordinate table
m2_coord_table:
incbin m2-coord-table.bin

// EB fonts
m2_font_table:
dd     m2_font_main
dd     m2_font_saturn

m2_font_main:
incbin m2-font-main.bin

m2_font_saturn:
incbin m2-font-saturn.bin

// EB font heights
m2_height_table:
db     $02, $02, $01, $00    // last byte for alignment

// EB font widths
m2_widths_table:
dd     m2_widths_main
dd     m2_widths_saturn

m2_widths_main:
incbin m2-widths-main.bin

m2_widths_saturn:
// tba

//==============================================================================
// Misc
//==============================================================================

org $2027FC0
m2_custom_wram:

//==============================================================================
// Code files
//==============================================================================

org $80FCE6C
incsrc m2-vwf.asm
incsrc m2-formatting.asm
incsrc m2-customcodes.asm
incsrc m2-goods.asm