// Contains functions to help with working with multiple PRG/CHR banks
// NOTE! These functions need to be located in the fixed bank $c000-ffff


// call a function in a different bank

void banked_call(unsigned char bankId, void (*method)(void)) {
    bank_push(bankId);

    (*method)();

    bank_pop();
}



// Internal function used by banked_call(), don't call this directly.
// Switch to the given bank, and keep track of the 
// current bank, so that we may jump back to it as needed.

void bank_push(unsigned char bankId) {
//    bankBuffer[bankLevel] = bankId;
	bankBuffer[bankLevel] = get_prg_bank();
    ++bankLevel;
    set_prg_bank(bankId);
}


// Internal function used by banked_call(), don't call this directly.
// Go back to the previous bank

void bank_pop(void) {
    
    if (bankLevel != 0) {
		--bankLevel;
        set_prg_bank(bankBuffer[bankLevel]);
    }
}

