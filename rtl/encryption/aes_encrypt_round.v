module aes_encrypt_round(

    input [127:0] state_in,
    input [127:0] round_key,

    output [127:0] subbytes_debug,
    output [127:0] shiftrows_debug,
    output [127:0] mixcolumns_debug,

    output [127:0] state_out

);

    // =========================================================
    // INTERNAL SIGNALS
    // =========================================================

    wire [127:0] subbytes_out;
    wire [127:0] shiftrows_out;
    wire [127:0] mixcolumns_out;

    // =========================================================
    // SUBBYTES
    // =========================================================

    subbytes SB(

        .data_in(state_in),
        .data_out(subbytes_out)

    );

    // =========================================================
    // SHIFTROWS
    // =========================================================

    shiftrows SR(

        .data_in(subbytes_out),
        .data_out(shiftrows_out)

    );

    // =========================================================
    // MIXCOLUMNS
    // =========================================================

    mixcolumns MC(

        .data_in(shiftrows_out),
        .data_out(mixcolumns_out)

    );

    // =========================================================
    // FINAL XOR
    // =========================================================

    assign state_out = mixcolumns_out ^ round_key;

    // =========================================================
    // DEBUG SIGNALS
    // =========================================================

    assign subbytes_debug   = subbytes_out;
    assign shiftrows_debug  = shiftrows_out;
    assign mixcolumns_debug = mixcolumns_out;

endmodule