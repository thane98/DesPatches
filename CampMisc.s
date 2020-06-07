.arm.little
.open "code.bin",0x100000

; Hooks
CastleSeq_CheckElapsedTime_Hook_1 equ 0x49ba4c
CastleSeq_CheckElapsedTime_Hook_2 equ 0x49b91c
CastleSeq_CheckElapsedTime_Hook_3 equ 0x49bab4
DefaultButler_1 equ 0x47f4fc
DefaultButler_2 equ 0x47f50c

; Force the castle to act as if time has always passed.
.org CastleSeq_CheckElapsedTime_Hook_1
    nop
.org CastleSeq_CheckElapsedTime_Hook_2
    nop
.org CastleSeq_CheckElapsedTime_Hook_3
    mov r0, #40


; Make Flora the "butler".
; This is to avoid bugs with not spawning a butler.
.org DefaultButler_1
    .sjis "PID_Flora"
.org DefaultButler_2
    .sjis "PID_Flora"

.close
