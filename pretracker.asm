;**************************************************
;*    ----- Pretracker V1.5 Playroutine -----	  *
;**************************************************
; BlitzBasic wrapper around PreTracker 1.5 by Abyss
; https://www.pouet.net/prod.php?which=91409
;
; Wrapper by E-Penguin
;
		
		include	"blitz.i"

pretplayerlib equ 189

		libheader pretplayerlib,0,0,0,0
				
		afunction long
			args	long
			libs
			subs	_PreT_SongInit_stub,0,0
		name	"PreTSongInit","Pretracker pointer, returns chipmem size",0

		astatement
			args	long
			libs
			subs	_PreT_PlayerInit_stub,0,0
		name	"PreTPlayerInit","Initialise player, chipmem pointer",0

		astatement
			args	
			libs
			subs	_PreT_PlayerTick_stub,0,0
		name	"PreTPlayerTick","run player",0
        
        astatement
			args	word
			libs
			subs	_PreT_StartSong_stub,0,0
		name	"PreTStartSong","start player song",0
        
        astatement
			args	word,word,word,word
			libs
			subs	_PreT_PlaySfx_stub,0,0
		name	"PreTPlaySfx","start sfx, voiceNum, sfxNum, duration, volume",0
        
		astatement
			args	
			libs
			subs	_PreT_Stop_stub,0,0
		name	"PreTStop","stop song",0
        
        astatement
			args	word
			libs
			subs	_PreT_SetVolume_stub,0,0
		name	"PreTSetVolume","Set volume, volume",0

		libfin ; End of Blitz library header

storeAddressRegisters	macro
	movem.l a4-a6,-(sp) ; Save registers for Blitz 2
	endm
    
restoreAddressRegisters	macro
	movem.l (sp)+,a4-a6	; Restore registers for Blitz
	rts ;Return to Blitz
	endm

; D0 - song pointer    
_PreT_SongInit_stub:
    storeAddressRegisters
    lea	player(pc),a6
    lea	myPlayer,a0
    lea	mySong,a1
    move.l d0,a2 ; a2 = song pointer
    add.l	(0,a6),a6
    jsr	(a6)		; songInit returns in D0 needed chipmem size
    restoreAddressRegisters

; D0 - chipmem pointer
_PreT_PlayerInit_stub:
    storeAddressRegisters
    lea	player(pc),a6
	lea	myPlayer,a0
	move.l d0,a1 ; a1 = chipmem pointer
	lea	mySong,a2
	add.l	(4,a6),a6
	jsr	(a6)		; playerInit
    restoreAddressRegisters

_PreT_PlayerTick_stub:
    storeAddressRegisters
    lea	player(pc),a6
	lea	myPlayer,a0
	add.l	(8,a6),a6
	jsr	(a6)		; playerTick
    restoreAddressRegisters

; D0 - current song
_PreT_StartSong_stub:
    storeAddressRegisters
    lea	player(pc),a6
	lea	myPlayer,a0
	add.l	(12,a6),a6
	jsr	(a6)		; start song
    restoreAddressRegisters

; D0 - channel (0-3)
; D1 - fx id
; D2 - duration (frames to mute music on channel)
; D3 - volume (0-64)
_PreT_PlaySfx_stub:
    storeAddressRegisters
    lea	player(pc),a6
	lea	myPlayer,a0
	add.l	(16,a6),a6
	jsr	(a6)		; playFx
    restoreAddressRegisters

_PreT_Stop_stub:
    storeAddressRegisters
    lea	player(pc),a6
	lea	myPlayer,a0
	add.l	(20,a6),a6
	jsr	(a6)		; stop
    restoreAddressRegisters

; D0 - volume (0-64)
_PreT_SetVolume_stub:
    storeAddressRegisters
    lea	player(pc),a6
	lea	myPlayer,a0
	add.l	(24,a6),a6
	jsr	(a6)		; setVolume
    restoreAddressRegisters

; Pretracker v1.5 player blob
player	incbin	"player.bin"

; Placeholders for structures used by player
;   section bss,bss
mySong	ds.w	2048/2
myPlayer	ds.l	8*1024/4
