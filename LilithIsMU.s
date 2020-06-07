.arm.little
.open "code.bin",0x100000

; Unused / Replaced Functions
DebugMenuItem_UpDownTick equ 0x42170C

; Hooks
UnitGetPlayer equ 0x4F6340
CastleSeqInitialize_Hook equ 0x49A990
CastleSeqInitialize_Resume equ 0x49A994

; Functions / Reused code snippets
Person_GetByPID equ 0x44A6DC
UnitPool_GetFromPerson equ 0x4F5D24


.org CastleSeqInitialize_Hook
    b ChangePlayerSprite


.org UnitGetPlayer
    push {r4, lr}
    mov r4, r0
    adr r0, NewPlayerPID
    bl Person_GetByPID
    bl UnitPool_GetFromPerson
    pop {r4, pc}

NewPlayerPID:
    .sjis "PID_Lilith"


.org DebugMenuItem_UpDownTick
.area 0x50

ChangePlayerSprite:
    push    {r1-r4, lr}

    adr     r0, NewCastleSprite
    bl      Person_GetByPID
    bl      UnitPool_GetFromPerson 

    pop     {r1-r4, lr}
    b       CastleSeqInitialize_Resume

NewCastleSprite:
    .sjis "PID_Lilith"

.endarea
.close