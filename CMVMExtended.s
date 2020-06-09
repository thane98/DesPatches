.arm.little
.open "code.bin",0x100000

; Unused/replaced functions
debug_Tick equ 0x42128C

; Hooks
CMVM_UnusedInstruction3A equ 0x3DA26C
DoInstruction_Resume equ 0x3DB654
MainSeqInitialize_Hook equ 0x1B61E0
MainSeqInitialize_Resume equ 0x1B61E4

; Functions
Person_GetByPID equ 0x44A6DC
Event_ScriptLoad equ 0x422398
Chapter_Get equ 0x4D95C8
Castle_Get equ 0x44544C
Castle_GetData equ 0x44545C
Castle_People_GetByPerson equ 0x492A5C
MapSetBGM equ 0x397BC0
MapUpdateBGM equ 0x399188

; Misc
SizeLimit equ 0x178

; Extend CMVM with custom functionality.
; This adds a new global script (DGlobal.cmb)
; and a new opcode to invoke custom code from scripts.

.org CMVM_UnusedInstruction3A
    ; Repurpose an unused CMVM instruction to execute custom code.
    .word CustomCMVMFunc

.org MainSeqInitialize_Hook
    ; Load an additional global script.
    b LoadGlobalScript


.org debug_Tick
.area SizeLimit
CustomCMVMFunc:
    push {r0-r7, lr}
    bl PopCMVMStack
    cmp r0, #4
    bge CustomCMVMFuncComplete
    adr r1, CustomCMVMFuncTable
    ldr r0, [r1, r0, LSL 2]
    bx r0

CustomCMVMFuncComplete:
    pop {r0-r7, lr}
    b DoInstruction_Resume

CustomCMVMFuncTable:
    .word CastleSetDoneTalking
    .word CastleGetDoneTalking
    .word SetMapBGM
    .word ChapterSetNext

CastleSetDoneTalking:
    bl PopCMVMStack
    mov r5, r0
    bl PopCMVMStack
    mov r6, r0
    mov r0, #1
    bl IncCMVMPC
    mov r0, r6
    bl CastleGetPeopleFromPID
    cmp r0, #0
    beq CustomCMVMFuncComplete
    mov r1, r5
    strb r1, [r0, #0x34]
    b CustomCMVMFuncComplete


CastleGetDoneTalking:
    bl PopCMVMStack
    mov r5, r0
    mov r0, #1
    bl IncCMVMPC
    mov r0, r5
    bl CastleGetPeopleFromPID
    cmp r0, #0
    beq CustomCMVMFuncComplete
    ldrb r0, [r0, #0x34]
    bl PushCMVMStack
    b CustomCMVMFuncComplete


SetMapBGM:
    mov r0, #1
    bl IncCMVMPC
    bl PopCMVMStack
    bl MapSetBGM
    bl MapUpdateBGM
    b CustomCMVMFuncComplete


ChapterSetNext:
    bl PopCMVMStack
    mov r5, r0
    bl PopCMVMStack
    mov r6, r0
    mov r0, #1
    bl IncCMVMPC

    mov r0, r6
    bl Chapter_Get
    cmp r0, #0
    beq CustomCMVMFuncComplete
    str r5, [r0, #0xA]
    str r5, [r0, #0xB]
    str r5, [r0, #0xC]
    b CustomCMVMFuncComplete


CastleGetPeopleFromPID:
    push {r4-r5, lr}
    mov r4, r0

    ; Get Castle::People
    bl Castle_Get
    bl Castle_GetData
    ldr r0, [r0, #0xC]
    mov r5, r0

    ; Get the castle people data by PID.
    mov r0, r4
    bl Person_GetByPID
    mov r1, r0
    mov r0, r5
    bl Castle_People_GetByPerson
    pop {r4-r5, pc}


; Helpers for manipulating CMVM.
PopCMVMStack:
    ldr r0, [r4, #0x18]
    sub r0, r0, #4
    str r0, [r4, #0x18]
    ldr r0, [r0, #0]
    bx lr

PushCMVMStack:
    ldr r1, [r4, #0x18]
    str r0, [r1]
    add r1, r1, #4
    str r1, [r4, #0x18]
    bx lr

IncCMVMPC:
    ldr r1, [r4, #0x10]
    add r1, r0, r1
    str r1, [r4, #0x10]
    bx lr

; Load an additional global script.
LoadGlobalScript:
    bl Event_ScriptLoad
    adr r0, GlobalScriptName
    bl Event_ScriptLoad
    b MainSeqInitialize_Resume

GlobalScriptName:
    .sjis "DGlobal"

.endarea

.close