.arm.little
.open "code.bin",0x100000

; Unused / Replaced Functions
debug_AddItem equ 0x421404

; Hooks
MoveUnitPeopleTalkCase_Hook equ 0x498DD4
MoveUnitButlerTalkCase_Hook equ 0x498BEC
MoveUnitAmiiboLoadUnit_Hook equ 0x498E78
CreateAmiiboSequence_Hook_1 equ 0x45BB20
CreateAmiiboSequence_Hook_2 equ 0x45BB54
CreateAmiiboSequence_Resume equ 0x45BB88
AmiiboPostTalk equ 0x491150
AmiiboPostTalk_End equ 0x491260

; Functions / Reused Code
Person_GetByCharID equ 0x44A6F8
UnitPool_GetFromPerson equ 0x4F5D24
strncpy equ 0x11B0DC
snprintf equ 0x10FBF8
MoveUnitAmiiboCase equ 0x498E78



.org CreateAmiiboSequence_Hook_1
    ; This called a function to determine the amiibo type.
    ; No reason to do that now since this isn't used.
    mov r0, #0

.org CreateAmiiboSequence_Hook_2
    ; Change what script is loaded.
    b SetupAmiiboSequenceRedirect

.org MoveUnitAmiiboLoadUnit_Hook
    ; Converting actor -> unit is bugged with our changes.
    ; This uses an alternative approach to make it work.
    bl LoadUnitFromActorByCharID

.org AmiiboPostTalk
    ; Make this a no-op.
    b AmiiboPostTalk_End

.org MoveUnitPeopleTalkCase_Hook
    ; Redirect talk events to amiibo.
    b MoveUnitAmiiboCase

.org MoveUnitButlerTalkCase_Hook
    b MoveUnitAmiiboCase



.org debug_AddItem
.area 0x140
LoadUnitFromActorByCharID:
    push {lr}
    adr r1, DefaultCharID
    ldr r1, [r1]
    cmp r0, #0
    beq LoadUnitFromActorByCharID_Default
    ldrh r0, [r0, #0x1A]
    cmp r0, r1
    bgt LoadUnitFromActorByCharID_Default
    b LoadUnitFromActorByCharID_Commit

LoadUnitFromActorByCharID_Default:
    mov r0, r1

LoadUnitFromActorByCharID_Commit:
    bl Person_GetByCharID
    bl UnitPool_GetFromPerson
    nop
    pop {pc}

DefaultCharID:
    .word 0x10A



; Redirect amiibo sequence to a different script and function.
.align 4
SetupAmiiboSequenceRedirect:
    mov r0, r5
    cmp r0, #0
    beq SetupAmiiboSequenceRedirect_LoadDefaultCharacter

    ldr r0, [r0, #0x9C]
    cmp r0, #0
    beq SetupAmiiboSequenceRedirect_LoadDefaultCharacter

    ldr r0, [r0, #0x8]
    cmp r0, #0
    beq SetupAmiiboSequenceRedirect_LoadDefaultCharacter

    add r3, r0, #4
    b SetupAmiiboSequenceRedirect_Commit


SetupAmiiboSequenceRedirect_LoadDefaultCharacter:
    adr r3, DefaultCharacterName


SetupAmiiboSequenceRedirect_Commit:
    add r0, r4, #0x5C
    mov r1, #0x20
    adr r2, CastleScriptFunctionNameTemplate
    bl snprintf

    add r0, r4, #0x3C
    adr r1, CastleScriptName
    mov r2, #0x20
    bl strncpy
    b CreateAmiiboSequence_Resume

CastleScriptName:
    .sjis "DCastle"

CastleScriptFunctionNameTemplate:
    .sjis "des::%s"

DefaultCharacterName:
    .sjis "Flora"

.endarea
.close
