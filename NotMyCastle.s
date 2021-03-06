.arm.little
.open "code.bin",0x100000

; Hooks
CastleLowerDrawer_DrawButtons equ 0x200BF4
CastleLowerDrawer_Draw_DrawTimeCall equ 0x200c50
DrawCastleInfo_CastleName equ 0x2002bc
DrawCastleInfo_DVPText equ 0x200424
DrawCastleInfo_DVPIcon equ 0x200458
DrawCastleInfo_DVPBar equ 0x2002F4
SetupCastleInfo_AfterNameItem equ 0x200ACC
SetupCastleInfo_AfterDVPItem equ 0x200B18
CrystalDrawIcon equ 0x20075C
CrystalNeedFlash equ 0x466C24
CastleHelpFrameDraw_Loop equ 0x542ED8
ButlerMenuCreateBind equ 0x44D5B8
MoveUnitRelianceMenuCheck equ 0x498f58
MoveUnitLinkMenuCheck equ 0x498f60
EnterSeq_Tutorial equ 0x47f520
EnterSeq_TutorialNotice equ 0x47f340
EnterSeq_TutorialAfterLilith equ 0x47f424

; Functions/Used Code Blocks
MoveUnitAmiiboCase equ 0x498E78

; These changes disable and hide unneeded My Castle features.
; In particular, this disables everything related to customization.

; Disable the tutorial.
.org EnterSeq_Tutorial
    nop
    nop
    nop
.org EnterSeq_TutorialNotice
    nop
.org EnterSeq_TutorialAfterLilith
    bx lr

.org MoveUnitRelianceMenuCheck
    ; Disable the bookshelf.
    mov r0, #-1

.org MoveUnitLinkMenuCheck
    ; Disable the crystal ball.
    mov r0, #-1

.org CastleLowerDrawer_DrawButtons
    ; Hide the card/castle/army buttons and disable their functionality.
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop

.org DrawCastleInfo_DVPText
    nop
.org DrawCastleInfo_DVPIcon
    nop
.org DrawCastleInfo_DVPBar
    nop

.org CastleLowerDrawer_Draw_DrawTimeCall
    nop

.org SetupCastleInfo_AfterNameItem
    ; Disable DVP item interaction.
    b SetupCastleInfo_AfterDVPItem

.org CrystalDrawIcon
    ; Don't make the crystal glow on the map.
    nop

.org CrystalNeedFlash
    ; Disable balloons for the crystal.
    mov r0, #0
    bx lr

.org CastleHelpFrameDraw_Loop
    ; Hide the castle menu button prompt.
    cmp r4, #4

.org ButlerMenuCreateBind
    ; Disable the butler / castle menu sequence
    bx lr

.org DrawCastleInfo_CastleName
    nop

.Close
