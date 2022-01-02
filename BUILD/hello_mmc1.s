;
; File generated by cc65 v 2.18 - Git c0a873e
;
	.fopt		compiler,"cc65 v 2.18 - Git c0a873e"
	.setcpu		"6502"
	.smart		on
	.autoimport	on
	.case		on
	.debuginfo	off
	.importzp	sp, sreg, regsave, regbank
	.importzp	tmp1, tmp2, tmp3, tmp4, ptr1, ptr2, ptr3, ptr4
	.macpack	longbranch
	.forceimport	__STARTUP__
	.import		_pal_bg
	.import		_pal_spr
	.import		_ppu_wait_nmi
	.import		_ppu_off
	.import		_ppu_on_all
	.import		_oam_clear
	.import		_oam_spr
	.import		_music_play
	.import		_music_pause
	.import		_sfx_play
	.import		_sample_play
	.import		_pad_poll
	.import		_bank_spr
	.import		_vram_adr
	.import		_vram_put
	.import		_vram_write
	.import		_get_pad_new
	.export		_bankLevel
	.export		_bankBuffer
	.export		_banked_call
	.export		_bank_push
	.export		_bank_pop
	.import		_set_prg_bank
	.import		_set_chr_bank_0
	.export		_arg1
	.export		_arg2
	.export		_pad1
	.export		_pad1_new
	.export		_char_state
	.export		_song
	.export		_sound
	.export		_pauze
	.export		_wram_array
	.export		_palette
	.export		_TEXT0
	.export		_function_bank0
	.export		_TEXT1
	.export		_function_bank2
	.export		_function_bank1
	.export		_TEXT2
	.export		_TEXT3
	.export		_function_bank3
	.export		_TEXT4
	.export		_function_bank4
	.export		_TEXT5
	.export		_TEXT5B
	.export		_function_2_bank5
	.export		_function_bank5
	.export		_TEXT6
	.export		_function_bank6
	.export		_text
	.export		_draw_sprites
	.export		_main

.segment	"RODATA"

_palette:
	.byte	$0F
	.byte	$00
	.byte	$10
	.byte	$30
	.byte	$00
	.byte	$00
	.byte	$00
	.byte	$00
	.byte	$00
	.byte	$00
	.byte	$00
	.byte	$00
	.byte	$00
	.byte	$00
	.byte	$00
	.byte	$00
.segment	"BANK0"
_TEXT0:
	.byte	$42,$41,$4E,$4B,$30,$00
.segment	"BANK1"
_TEXT1:
	.byte	$42,$41,$4E,$4B,$31,$00
.segment	"BANK2"
_TEXT2:
	.byte	$42,$41,$4E,$4B,$32,$00
.segment	"BANK3"
_TEXT3:
	.byte	$42,$41,$4E,$4B,$33,$00
.segment	"BANK4"
_TEXT4:
	.byte	$42,$41,$4E,$4B,$34,$00
.segment	"BANK5"
_TEXT5:
	.byte	$42,$41,$4E,$4B,$35,$00
_TEXT5B:
	.byte	$41,$4C,$53,$4F,$20,$54,$48,$49,$53,$00
.segment	"BANK6"
_TEXT6:
	.byte	$42,$41,$4E,$4B,$36,$00
.segment	"CODE"
_text:
	.byte	$42,$41,$43,$4B,$20,$49,$4E,$20,$46,$49,$58,$45,$44,$20,$42,$41
	.byte	$4E,$4B,$2C,$20,$37,$00

.segment	"BSS"

_bankLevel:
	.res	1,$00
_bankBuffer:
	.res	10,$00
.segment	"ZEROPAGE"
_arg1:
	.res	1,$00
_arg2:
	.res	1,$00
_pad1:
	.res	1,$00
_pad1_new:
	.res	1,$00
_char_state:
	.res	1,$00
_song:
	.res	1,$00
_sound:
	.res	1,$00
_pauze:
	.res	1,$00
.segment	"XRAM"
_wram_array:
	.res	8192,$00

; ---------------------------------------------------------------
; void __near__ banked_call (unsigned char bankId, void (*method)(void))
; ---------------------------------------------------------------

.segment	"CODE"

.proc	_banked_call: near

.segment	"CODE"

;
; void banked_call(unsigned char bankId, void (*method)(void)) {
;
	jsr     pushax
;
; bank_push(bankId);
;
	ldy     #$02
	lda     (sp),y
	jsr     _bank_push
;
; (*method)();
;
	ldy     #$01
	lda     (sp),y
	tax
	dey
	lda     (sp),y
	jsr     callax
;
; bank_pop();
;
	jsr     _bank_pop
;
; }
;
	jmp     incsp3

.endproc

; ---------------------------------------------------------------
; void __near__ bank_push (unsigned char bankId)
; ---------------------------------------------------------------

.segment	"CODE"

.proc	_bank_push: near

.segment	"CODE"

;
; void bank_push(unsigned char bankId) {
;
	jsr     pusha
;
; bankBuffer[bankLevel] = bankId;
;
	ldy     #$00
	lda     (sp),y
	ldy     _bankLevel
	sta     _bankBuffer,y
;
; ++bankLevel;
;
	inc     _bankLevel
;
; set_prg_bank(bankId);
;
	ldy     #$00
	lda     (sp),y
	jsr     _set_prg_bank
;
; }
;
	jmp     incsp1

.endproc

; ---------------------------------------------------------------
; void __near__ bank_pop (void)
; ---------------------------------------------------------------

.segment	"CODE"

.proc	_bank_pop: near

.segment	"CODE"

;
; --bankLevel;
;
	dec     _bankLevel
;
; if (bankLevel > 0) {
;
	beq     L0012
;
; set_prg_bank(bankBuffer[bankLevel-1]);
;
	ldx     #$00
	lda     _bankLevel
	sec
	sbc     #$01
	bcs     L0017
	dex
L0017:	sta     ptr1
	txa
	clc
	adc     #>(_bankBuffer)
	sta     ptr1+1
	ldy     #<(_bankBuffer)
	lda     (ptr1),y
	jmp     _set_prg_bank
;
; }
;
L0012:	rts

.endproc

; ---------------------------------------------------------------
; void __near__ function_bank0 (void)
; ---------------------------------------------------------------

.segment	"BANK0"

.proc	_function_bank0: near

.segment	"BANK0"

;
; ppu_off();
;
	jsr     _ppu_off
;
; vram_adr(NTADR_A(1,4));
;
	ldx     #$20
	lda     #$81
	jsr     _vram_adr
;
; vram_write(TEXT0,sizeof(TEXT0));
;
	lda     #<(_TEXT0)
	ldx     #>(_TEXT0)
	jsr     pushax
	ldx     #$00
	lda     #$06
	jsr     _vram_write
;
; ppu_on_all();
;
	jmp     _ppu_on_all

.endproc

; ---------------------------------------------------------------
; void __near__ function_bank2 (void)
; ---------------------------------------------------------------

.segment	"BANK2"

.proc	_function_bank2: near

.segment	"BANK2"

;
; ppu_off();
;
	jsr     _ppu_off
;
; vram_adr(NTADR_A(1,8));
;
	ldx     #$21
	lda     #$01
	jsr     _vram_adr
;
; vram_write(TEXT2,sizeof(TEXT2));
;
	lda     #<(_TEXT2)
	ldx     #>(_TEXT2)
	jsr     pushax
	ldx     #$00
	lda     #$06
	jsr     _vram_write
;
; ppu_on_all();
;
	jmp     _ppu_on_all

.endproc

; ---------------------------------------------------------------
; void __near__ function_bank1 (void)
; ---------------------------------------------------------------

.segment	"BANK1"

.proc	_function_bank1: near

.segment	"BANK1"

;
; ppu_off();
;
	jsr     _ppu_off
;
; vram_adr(NTADR_A(1,6));
;
	ldx     #$20
	lda     #$C1
	jsr     _vram_adr
;
; vram_write(TEXT1,sizeof(TEXT1));
;
	lda     #<(_TEXT1)
	ldx     #>(_TEXT1)
	jsr     pushax
	ldx     #$00
	lda     #$06
	jsr     _vram_write
;
; ppu_on_all();
;
	jsr     _ppu_on_all
;
; banked_call(BANK_2, function_bank2);
;
	lda     #$02
	jsr     pusha
	lda     #<(_function_bank2)
	ldx     #>(_function_bank2)
	jmp     _banked_call

.endproc

; ---------------------------------------------------------------
; void __near__ function_bank3 (void)
; ---------------------------------------------------------------

.segment	"BANK3"

.proc	_function_bank3: near

.segment	"BANK3"

;
; ppu_off();
;
	jsr     _ppu_off
;
; vram_adr(NTADR_A(1,10));
;
	ldx     #$21
	lda     #$41
	jsr     _vram_adr
;
; vram_write(TEXT3,sizeof(TEXT3));
;
	lda     #<(_TEXT3)
	ldx     #>(_TEXT3)
	jsr     pushax
	ldx     #$00
	lda     #$06
	jsr     _vram_write
;
; vram_put(0);
;
	lda     #$00
	jsr     _vram_put
;
; vram_put(arg1); // these args were passed via globals
;
	lda     _arg1
	jsr     _vram_put
;
; vram_put(arg2);
;
	lda     _arg2
	jsr     _vram_put
;
; ppu_on_all();
;
	jmp     _ppu_on_all

.endproc

; ---------------------------------------------------------------
; void __near__ function_bank4 (void)
; ---------------------------------------------------------------

.segment	"BANK4"

.proc	_function_bank4: near

.segment	"BANK4"

;
; ppu_off();
;
	jsr     _ppu_off
;
; vram_adr(NTADR_A(1,12));
;
	ldx     #$21
	lda     #$81
	jsr     _vram_adr
;
; vram_write(TEXT4,sizeof(TEXT4));
;
	lda     #<(_TEXT4)
	ldx     #>(_TEXT4)
	jsr     pushax
	ldx     #$00
	lda     #$06
	jsr     _vram_write
;
; ppu_on_all();
;
	jmp     _ppu_on_all

.endproc

; ---------------------------------------------------------------
; void __near__ function_2_bank5 (void)
; ---------------------------------------------------------------

.segment	"BANK5"

.proc	_function_2_bank5: near

.segment	"BANK5"

;
; vram_adr(NTADR_A(8,14));
;
	ldx     #$21
	lda     #$C8
	jsr     _vram_adr
;
; vram_write(TEXT5B,sizeof(TEXT5B));
;
	lda     #<(_TEXT5B)
	ldx     #>(_TEXT5B)
	jsr     pushax
	ldx     #$00
	lda     #$0A
	jmp     _vram_write

.endproc

; ---------------------------------------------------------------
; void __near__ function_bank5 (void)
; ---------------------------------------------------------------

.segment	"BANK5"

.proc	_function_bank5: near

.segment	"BANK5"

;
; ppu_off();
;
	jsr     _ppu_off
;
; vram_adr(NTADR_A(1,14));
;
	ldx     #$21
	lda     #$C1
	jsr     _vram_adr
;
; vram_write(TEXT5,sizeof(TEXT5));
;
	lda     #<(_TEXT5)
	ldx     #>(_TEXT5)
	jsr     pushax
	ldx     #$00
	lda     #$06
	jsr     _vram_write
;
; function_2_bank5();
;
	jsr     _function_2_bank5
;
; ppu_on_all();
;
	jmp     _ppu_on_all

.endproc

; ---------------------------------------------------------------
; void __near__ function_bank6 (void)
; ---------------------------------------------------------------

.segment	"BANK6"

.proc	_function_bank6: near

.segment	"BANK6"

;
; ppu_off();
;
	jsr     _ppu_off
;
; vram_adr(NTADR_A(1,16));
;
	ldx     #$22
	lda     #$01
	jsr     _vram_adr
;
; vram_write(TEXT6,sizeof(TEXT6));
;
	lda     #<(_TEXT6)
	ldx     #>(_TEXT6)
	jsr     pushax
	ldx     #$00
	lda     #$06
	jsr     _vram_write
;
; vram_put(0);
;
	lda     #$00
	jsr     _vram_put
;
; vram_put(wram_array[0]); // testing the $6000-7fff area
;
	lda     _wram_array
	jsr     _vram_put
;
; vram_put(wram_array[2]); // should print A, C
;
	lda     _wram_array+2
	jsr     _vram_put
;
; ppu_on_all();
;
	jmp     _ppu_on_all

.endproc

; ---------------------------------------------------------------
; void __near__ draw_sprites (void)
; ---------------------------------------------------------------

.segment	"CODE"

.proc	_draw_sprites: near

.segment	"CODE"

;
; bank_spr(1);
;
	lda     #$01
	jsr     _bank_spr
;
; oam_clear();
;
	jsr     _oam_clear
;
; oam_spr(0x50,0x10,0,0);
;
	jsr     decsp3
	lda     #$50
	ldy     #$02
	sta     (sp),y
	lda     #$10
	dey
	sta     (sp),y
	lda     #$00
	dey
	sta     (sp),y
	jsr     _oam_spr
;
; oam_spr(0x58,0x10,1,0);
;
	jsr     decsp3
	lda     #$58
	ldy     #$02
	sta     (sp),y
	lda     #$10
	dey
	sta     (sp),y
	tya
	dey
	sta     (sp),y
	tya
	jsr     _oam_spr
;
; oam_spr(0x50,0x18,0x10,0);
;
	jsr     decsp3
	lda     #$50
	ldy     #$02
	sta     (sp),y
	lda     #$18
	dey
	sta     (sp),y
	lda     #$10
	dey
	sta     (sp),y
	tya
	jsr     _oam_spr
;
; oam_spr(0x58,0x18,0x11,0);
;
	jsr     decsp3
	lda     #$58
	ldy     #$02
	sta     (sp),y
	lda     #$18
	dey
	sta     (sp),y
	lda     #$11
	dey
	sta     (sp),y
	tya
	jmp     _oam_spr

.endproc

; ---------------------------------------------------------------
; void __near__ main (void)
; ---------------------------------------------------------------

.segment	"CODE"

.proc	_main: near

.segment	"CODE"

;
; song = 0;
;
	lda     #$00
	sta     _song
;
; music_play(song);
;
	jsr     _music_play
;
; wram_array[0] = 'A'; // put some values at $6000-7fff
;
	lda     #$41
	sta     _wram_array
;
; wram_array[2] = 'C'; // for later testing
;
	lda     #$43
	sta     _wram_array+2
;
; draw_sprites();
;
	jsr     _draw_sprites
;
; ppu_off(); // screen off
;
	jsr     _ppu_off
;
; pal_bg(palette); // load the BG palette
;
	lda     #<(_palette)
	ldx     #>(_palette)
	jsr     _pal_bg
;
; pal_spr(palette); // load the sprite palette
;
	lda     #<(_palette)
	ldx     #>(_palette)
	jsr     _pal_spr
;
; ppu_on_all(); // turn on screen
;
	jsr     _ppu_on_all
;
; banked_call(BANK_0, function_bank0);
;
	lda     #$00
	jsr     pusha
	lda     #<(_function_bank0)
	ldx     #>(_function_bank0)
	jsr     _banked_call
;
; banked_call(BANK_1, function_bank1);
;
	lda     #$01
	jsr     pusha
	lda     #<(_function_bank1)
	ldx     #>(_function_bank1)
	jsr     _banked_call
;
; arg1 = 'G'; // must pass arguments with globals
;
	lda     #$47
	sta     _arg1
;
; arg2 = '4';
;
	lda     #$34
	sta     _arg2
;
; banked_call(BANK_3, function_bank3);
;
	lda     #$03
	jsr     pusha
	lda     #<(_function_bank3)
	ldx     #>(_function_bank3)
	jsr     _banked_call
;
; banked_call(BANK_4, function_bank4);
;
	lda     #$04
	jsr     pusha
	lda     #<(_function_bank4)
	ldx     #>(_function_bank4)
	jsr     _banked_call
;
; banked_call(BANK_5, function_bank5);
;
	lda     #$05
	jsr     pusha
	lda     #<(_function_bank5)
	ldx     #>(_function_bank5)
	jsr     _banked_call
;
; banked_call(BANK_6, function_bank6);
;
	lda     #$06
	jsr     pusha
	lda     #<(_function_bank6)
	ldx     #>(_function_bank6)
	jsr     _banked_call
;
; ppu_off(); // screen off
;
	jsr     _ppu_off
;
; vram_adr(NTADR_A(1,18));
;
	ldx     #$22
	lda     #$41
	jsr     _vram_adr
;
; vram_write(text,sizeof(text)); // code running from the fixed bank
;
	lda     #<(_text)
	ldx     #>(_text)
	jsr     pushax
	ldx     #$00
	lda     #$16
	jsr     _vram_write
;
; set_prg_bank(0); 
;
	lda     #$00
	jsr     _set_prg_bank
;
; vram_adr(NTADR_A(1,20));
;
	ldx     #$22
	lda     #$81
	jsr     _vram_adr
;
; vram_write(TEXT0,sizeof(TEXT0)); // this array is in bank 0
;
	lda     #<(_TEXT0)
	ldx     #>(_TEXT0)
	jsr     pushax
	ldx     #$00
	lda     #$06
	jsr     _vram_write
;
; ppu_on_all(); // turn on screen
;
	jsr     _ppu_on_all
;
; ppu_wait_nmi();
;
L0108:	jsr     _ppu_wait_nmi
;
; pad1 = pad_poll(0);
;
	lda     #$00
	jsr     _pad_poll
	sta     _pad1
;
; pad1_new = get_pad_new(0);
;
	lda     #$00
	jsr     _get_pad_new
	sta     _pad1_new
;
; if(pad1_new & PAD_START){
;
	and     #$10
	beq     L014A
;
; ++char_state;
;
	inc     _char_state
;
; char_state = char_state & 3; // keep 0-3
;
	lda     _char_state
	and     #$03
	sta     _char_state
;
; set_chr_bank_0(char_state); // switch the BG bank
;
	jsr     _set_chr_bank_0
;
; sample_play(1);
;
	lda     #$01
	jsr     _sample_play
;
; if(pad1_new & PAD_A){
;
L014A:	lda     _pad1_new
	and     #$80
	beq     L014B
;
; ++song;
;
	inc     _song
;
; song = song & 1; // keep 0 or 1
;
	lda     _song
	and     #$01
	sta     _song
;
; music_play(song);
;
	jsr     _music_play
;
; if(pad1_new & PAD_B){
;
L014B:	lda     _pad1_new
	and     #$40
	beq     L014C
;
; ++sound;
;
	inc     _sound
;
; sound = sound & 1; // keep 0 or 1
;
	lda     _sound
	and     #$01
	sta     _sound
;
; sfx_play(sound, 0);
;
	jsr     pusha
	lda     #$00
	jsr     _sfx_play
;
; if(pad1_new & PAD_SELECT){
;
L014C:	lda     _pad1_new
	and     #$20
	beq     L0108
;
; ++pauze;
;
	inc     _pauze
;
; pauze = pauze & 1; // keep 0 or 1
;
	lda     _pauze
	and     #$01
	sta     _pauze
;
; music_pause(pauze);
;
	jsr     _music_pause
;
; while (1){ // infinite loop
;
	jmp     L0108

.endproc

