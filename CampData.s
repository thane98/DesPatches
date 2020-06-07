.arm.little
.open "code.bin",0x100000

; Unused / Replaced functions
Jukebox_GetBGMLabel equ 0x494620
DebugMenuItem_ABTick equ 0x42182C

; Hooks
LilithFoodPath equ 0x6A3DAB
Castle_Cut_GetCID_Hook equ 0x469854
Castle_Cut_GetCID_Resume equ 0x469858


.org Castle_Cut_GetCID_Hook
    b RedirectCastleCIDLoad

.org LilithFoodPath
    ; Install a new data file by hijacking an unused one.
    .sjis "castle/DesCas.bin.lz"


.org Jukebox_GetBGMLabel
    adr r0, DefaultCastleMusic
    bx lr

DefaultCastleMusic:
    .sjis "STRM_EVT_DIFFERENT_C1"


.org DebugMenuItem_ABTick
.area 0x38

RedirectCastleCIDLoad:
    adr r0, DesCasPointerAddressTerrain
    ldr r0, [r0]
    ldr r0, [r0]
    ldr r0, [r0]
    ; TODO: This always selects data for chapter 1.
    ;       Need to add chapter num * entry size later.
    ldr r3, [r0, #4]
    b Castle_Cut_GetCID_Resume

DesCasPointerAddressTerrain:
    .word 0x6d2024

.endarea
.close