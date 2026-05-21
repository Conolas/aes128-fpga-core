`timescale 1ns/1ps

//////////////////////////////////////////////////////////////////////////////////
// FINAL AES SYSTEM TOP MODULE
//
// FLOW:
//
// PLAINTEXT
//    ↓
// ENCRYPTION
//    ↓
// CIPHERTEXT
//    ↓
// DECRYPTION
//    ↓
// RECOVERED PLAINTEXT
//
//////////////////////////////////////////////////////////////////////////////////

module aes_system_top(

    input clk,
    input reset

);

    // =========================================================
    // INPUT DATA
    // =========================================================

    reg [127:0] plain_text;
    reg [127:0] key;
    wire [127:0] addroundkey_encrypt;

    // =========================================================
    // ENCRYPTION DEBUG SIGNALS
    // =========================================================

    wire [127:0] enc_subbytes;
    wire [127:0] enc_shiftrows;
    wire [127:0] enc_mixcolumns;

    // =========================================================
    // DECRYPTION DEBUG SIGNALS
    // =========================================================

    wire [127:0] dec_invmixcolumns;
    wire [127:0] dec_invshiftrows;
    wire [127:0] dec_invsubbytes;

    // =========================================================
    // MAIN DATA SIGNALS
    // =========================================================

    wire [127:0] cipher_text;
    wire [127:0] recovered_plaintext;

    wire done;

    // =========================================================
    // INITIAL VALUES
    // =========================================================

    initial
    begin

        // "HELLO WORLD"

        plain_text =
        128'h48454C4C4F20574F524C440000000000;

        // AES KEY

        key =
        128'h000102030405060708090A0B0C0D0E0F;

    end

    // =========================================================
    // ENCRYPTION MODULE
    // =========================================================
assign addroundkey_encrypt = plain_text ^ key;

    aes_encrypt_round ENCRYPT(

        .state_in(addroundkey_encrypt),
        .round_key(key),

        .subbytes_debug(enc_subbytes),
        .shiftrows_debug(enc_shiftrows),
        .mixcolumns_debug(enc_mixcolumns),

        .state_out(cipher_text)

    );

    // =========================================================
    // DECRYPTION MODULE
    // =========================================================

    aes_decrypt_round DECRYPT(

        .state_in(cipher_text),
        .round_key(key),

        .inv_mixcolumns_debug(dec_invmixcolumns),
        .inv_shiftrows_debug(dec_invshiftrows),
        .inv_subbytes_debug(dec_invsubbytes),

        .state_out(recovered_plaintext)

    );

    // =========================================================
    // DONE
    // =========================================================

    assign done = 1'b1;

    // =========================================================
    // ILA
    // =========================================================
reg [127:0] recovered_plaintext_reg;
reg [127:0] cipher_text_reg;

always @(posedge clk)
begin
    recovered_plaintext_reg <= recovered_plaintext;
    cipher_text_reg <= cipher_text;
end
    ila_0 ILA (

        .clk(clk),

        // =====================================================
        // ENCRYPTION STAGES
        // =====================================================

        .probe0(plain_text),
        .probe1(enc_subbytes),
        .probe2(enc_shiftrows),
        .probe3(enc_mixcolumns),
        .probe4(cipher_text_reg),

        // =====================================================
        // DECRYPTION STAGES
        // =====================================================

        .probe5(dec_invmixcolumns),
        .probe6(dec_invshiftrows),
        .probe7(dec_invsubbytes),
        .probe8(recovered_plaintext_reg),

        // =====================================================
        // CONTROL SIGNALS
        // =====================================================

        .probe9(key),
        .probe10(done),
        .probe11(clk),
        .probe12(reset)

    );

endmodule