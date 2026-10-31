`timescale 1ns/1ps

//////////////////////////////////////////////////////////////////////////////////
// AES DECRYPT ROUND
//////////////////////////////////////////////////////////////////////////////////

module aes_decrypt_round_v2(

    input [127:0] state_in,
    input [127:0] round_key,
    input         first_round,     // 1 = round 10 (first decrypt round): skip InvMixColumns

    output [127:0] inv_subbytes_debug,
    output [127:0] inv_shiftrows_debug,
    output [127:0] inv_mixcolumns_debug,

    output [127:0] state_out

);

    // =========================================================
    // INTERNAL SIGNALS
    // =========================================================

    wire [127:0] addroundkey_out;
    wire [127:0] inv_mixcolumns_out;
    wire [127:0] inv_shiftrows_out;
    wire [127:0] inv_subbytes_out;
    wire [127:0] after_imc_or_skip = first_round ? addroundkey_out : inv_mixcolumns_out;

    // =========================================================
    // ADD ROUND KEY
    // =========================================================

    assign addroundkey_out = state_in ^ round_key;

    // =========================================================
    // INVERSE MIXCOLUMNS
    // =========================================================

    InvMixColumns IMC(

        .data_in(addroundkey_out),
        .data_out(inv_mixcolumns_out)

    );

    // =========================================================
    // INVERSE SHIFTROWS
    // =========================================================

    inv_shiftrows ISR(
        .data_in(after_imc_or_skip),     // was inv_mixcolumns_out
        .data_out(inv_shiftrows_out)
    );
      


    // =========================================================
    // INVERSE SUBBYTES
    // =========================================================

    inv_subbytes ISB(

        .data_in(inv_shiftrows_out),
        .data_out(inv_subbytes_out)

    );

    // =========================================================
    // FINAL OUTPUT
    // =========================================================

    assign state_out = inv_subbytes_out;

    // =========================================================
    // DEBUG SIGNALS
    // =========================================================

    assign inv_mixcolumns_debug = inv_mixcolumns_out;
    assign inv_shiftrows_debug  = inv_shiftrows_out;
    assign inv_subbytes_debug   = inv_subbytes_out;

endmodule