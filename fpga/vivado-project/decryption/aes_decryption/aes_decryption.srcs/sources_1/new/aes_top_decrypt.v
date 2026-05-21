`timescale 1ns/1ps

//////////////////////////////////////////////////////////////////////////////////
// AES DECRYPTION TOP MODULE
//////////////////////////////////////////////////////////////////////////////////

module aes_decrypt_top(

    input clk,
    input reset

);

    // =========================================================
    // INTERNAL SIGNALS
    // =========================================================

    reg  [127:0] cipher_text;
    reg  [127:0] key;

    wire [127:0] round_key;

    wire [127:0] inv_subbytes_debug;
    wire [127:0] inv_shiftrows_debug;
    wire [127:0] inv_mixcolumns_debug;

    wire [127:0] plain_text;

    wire done;

    // =========================================================
    // INITIAL VALUES
    // =========================================================

    initial
    begin

        // Ciphertext generated from encryption

        cipher_text =
        128'hBC2AAB09E408011F7021CB8E3C862F8A;

        // AES Key

        key =
        128'h000102030405060708090A0B0C0D0E0F;

    end

    // =========================================================
    // ROUND KEY
    // =========================================================

    assign round_key = key;

    // =========================================================
    // AES DECRYPT ROUND
    // =========================================================

    AES_decrypt_round DECRYPT(

        .state_in(cipher_text),
        .round_key(round_key),

        .inv_subbytes_debug(inv_subbytes_debug),
        .inv_shiftrows_debug(inv_shiftrows_debug),
        .inv_mixcolumns_debug(inv_mixcolumns_debug),

        .state_out(plain_text)

    );

    // =========================================================
    // DONE
    // =========================================================

    assign done = 1'b1;

    // =========================================================
    // ILA
    // =========================================================

    ila_0 ILA (

        .clk(clk),

        // Ciphertext input
        .probe0(cipher_text),

        // InvSubBytes output
        .probe1(inv_subbytes_debug),

        // InvShiftRows output
        .probe2(inv_shiftrows_debug),

        // InvMixColumns output
        .probe3(inv_mixcolumns_debug),

        // Final plaintext
        .probe4(plain_text),

        // Round key
        .probe5(round_key),

        // Done
        .probe6(done)

    );

endmodule