.arm.little
.open "code.bin",0x100000

; Unused / Replaced functions
DebugMenuItem_DrawItem equ 0x53D298

; Hooks
Reposition_Hook equ 0x472A60
Reposition_Resume equ 0x472A64

; Functions / Reused code snippets
CastleActor_SetPos equ 0x48FF00


.org Reposition_Hook
    b ReassignPositions


.org DebugMenuItem_DrawItem
.area 0xD4

ReassignPositions:
    push {r4, lr}

    ; Convert actor -> person
    ; Abort if we hit null.
    cmp r8, #0
    beq ReassignPositions_Complete
    ldr r0, [r8, #0x20]
    cmp r0, #0
    beq ReassignPositions_Complete
    ldr r0, [r0, #0x9C]
    cmp r0, #0
    beq ReassignPositions_Complete

    ; Validate the ID.
    ldrh r1, [r0, #0x24]
    cmp r1, #0xFE
    ble ReassignPositions_Complete
    adr r2, ReassignPositionIDCutoff
    ldr r2, [r2]
    cmp r1, r2
    bgt ReassignPositions_Complete
    sub r1, #0xFF

    ; Locate the reassign position data.
    adr r0, ReassignPositionDataAddress
    ldr r0, [r0]
    ldr r0, [r0]
    ldr r0, [r0]
    ; TODO: This always selects data for chapter 1.
    ;       Need to add chapter num * entry size later.
    add r0, r0, 12

    ; Adjust the map position.
    ; Tricky part: to adjust the position, we need to change s0-s3.
    ; armips doesn't support floating point ops, so we need a workaround.
    ; This uses .word to place floating point ops without using the assembler.
    ldr r2, [r0, r1, LSL 3]
    add r0, #4
    ldr r3, [r0, r1, LSL 3]
    cmp r2, #0
    cmpne r3, #0
    beq ReassignPositions_Complete
    mov r0, r2
    mov r1, r3
    .word 0xEE000A10
    .word 0xEE011A10

ReassignPositions_Complete:
    pop {r4, lr}
    mov r0, r8
    b Reposition_Resume

ReassignPositionIDCutoff:
    .word 0x109
ReassignPositionDataAddress:
    .word 0x6d2024

.endarea
.close
