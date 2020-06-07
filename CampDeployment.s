.arm.little
.open "code.bin",0x100000

; Hooks
CastleAssignEvent_Hook_1 equ 0x492b7c
CastleAssignEvent_Hook_2 equ 0x4937f4
CastleAssignEvent_Shopkeepers_Loop equ 0x4936cc
CastleAssignEvent_Shopkeepers equ 0x49377c
CastleAssignEvent_Conversations equ 0x493960

.org CastleAssignEvent_Shopkeepers
    ; Only use generic shopkeepers.
    mov r0, #0

.org CastleAssignEvent_Hook_1
    ; Skip straight to assigning shopkeepers.
    b CastleAssignEvent_Shopkeepers_Loop

.org CastleAssignEvent_Hook_2
    ; Skip to normal conversations (no speech bubble).
    b CastleAssignEvent_Conversations

.org CastleAssignEvent_Conversations
    ; Always deploy all characters in the army.
    ; 40 is arbitrary. Increase it if you have more
    ; characters than that.
    nop
    mov r4, #0
    mov r5, #40

.close