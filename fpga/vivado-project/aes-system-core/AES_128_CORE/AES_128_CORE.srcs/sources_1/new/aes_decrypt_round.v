`timescale 1ns/1ps

//////////////////////////////////////////////////////////////////////////////////
// AES DECRYPT ROUND
//////////////////////////////////////////////////////////////////////////////////

module aes_decrypt_round(

    input [127:0] state_in,
    input [127:0] round_key,

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

        .data_in(inv_mixcolumns_out),
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

    assign state_out = inv_subbytes_out ^ round_key;

    // =========================================================
    // DEBUG SIGNALS
    // =========================================================

    assign inv_mixcolumns_debug = inv_mixcolumns_out;
    assign inv_shiftrows_debug  = inv_shiftrows_out;
    assign inv_subbytes_debug   = inv_subbytes_out;

endmodule