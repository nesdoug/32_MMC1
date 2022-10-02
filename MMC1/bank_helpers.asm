

;.define NO_CHR_BANK 255

.segment "ZEROPAGE"
	PRG_BANK: .res 1
	CHR_BANK0: .res 1
	CHR_BANK1: .res 1
	MIRROR: .res 1
 
	.exportzp PRG_BANK, CHR_BANK0, CHR_BANK1, MIRROR

.segment "CODE"

.export _set_prg_bank, _get_prg_bank, _set_chr_bank_0, _set_chr_bank_1
.export _split_chr_bank_0, _split_chr_bank_1
.export _set_mirroring, _set_mmc1_ctrl, reset_mmc1



reset_mmc1:
.byte $ff
	
; sets the bank at $8000-bfff
_set_prg_bank:
    sta PRG_BANK
	inc reset_mmc1
    mmc1_register_write MMC1_PRG
    rts

; returns the current bank at $8000-bfff	
_get_prg_bank:
    lda PRG_BANK
	ldx #0
    rts

; sets the first CHR bank
_set_chr_bank_0:
	sta CHR_BANK0
    rts

; sets the second CHR bank	
_set_chr_bank_1:
	sta CHR_BANK1
    rts

;for split screens, call this mid screen
;to change the #0 tileset
_split_chr_bank_0:
	inc reset_mmc1
	mmc1_register_write MMC1_CHR0
	rts
	
;for split screens, call this mid screen
;to change the #1 tileset
_split_chr_bank_1:
	inc reset_mmc1
	mmc1_register_write MMC1_CHR1
	rts	

_set_mirroring:
    ; Limit this to mirroring bits, so we can add our bytes safely.
    and #%00000011
    ; Now, set this to have 4k chr banking, and not mess up which prg bank is which.
    ora #%00011100
	sta MIRROR
    rts
	
; write all 5 bits of the $8000 control register
; in case you want to change the MMC1 settings besides mirroring (not recommended)
_set_mmc1_ctrl:
	and #$1f ;remove upper 3 bits
	sta MIRROR
	inc reset_mmc1
	mmc1_register_write MMC1_CTRL
	rts
	
	
	