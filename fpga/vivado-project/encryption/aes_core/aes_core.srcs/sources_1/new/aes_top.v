`timescale 1ns/1ps

//////////////////////////////////////////////////////////////////////////////////
// AES TOP
//////////////////////////////////////////////////////////////////////////////////

module aes_top(

    input clk,
    input reset

);

    // =========================================================
    // INTERNAL SIGNALS
    // =========================================================

    reg  [127:0] state;

    wire [127:0] round_out;
    wire [127:0] round_key;

    wire [127:0] subbytes_debug;
    wire [127:0] shiftrows_debug;
    wire [127:0] mixcolumns_debug;

    // =========================================================
    // INPUT DATA
    // =========================================================

    reg [127:0] plain_text;
    reg [127:0] key;

    // =========================================================
    // OUTPUTS
    // =========================================================

    wire [127:0] cipher_text;
    wire done;

    // =========================================================
    // INITIAL VALUES
    // =========================================================

    initial
    begin

        plain_text =
        128'h48454C4C4F20574F524C440000000000;

        key =
        128'h000102030405060708090A0B0C0D0E0F;

        // Initial AddRoundKey
        state =
        128'h48454C4C4F20574F524C440000000000 ^
        128'h000102030405060708090A0B0C0D0E0F;

    end

    // =========================================================
    // ROUND KEY
    // =========================================================

    assign round_key = key;

    // =========================================================
    // AES ROUND
    // =========================================================

    AES_round ROUND(

        .state_in(state),
        .round_key(round_key),

        .subbytes_debug(subbytes_debug),
        .shiftrows_debug(shiftrows_debug),
        .mixcolumns_debug(mixcolumns_debug),

        .state_out(round_out)

    );

    // =========================================================
    // CIPHERTEXT
    // =========================================================

    assign cipher_text = round_out;

    // =========================================================
    // DONE SIGNAL
    // =========================================================

    assign done = 1'b1;

    // =========================================================
    // ILA
    // =========================================================

    ila_0 ILA (

        .clk(clk),

        // plaintext
        .probe0(plain_text),

        // subbytes
        .probe1(subbytes_debug),

        // shiftrows
        .probe2(shiftrows_debug),

        // mixcolumns
        .probe3(mixcolumns_debug),

        // ciphertext
        .probe4(cipher_text),

        // round key
        .probe5(round_key),

        // done
        .probe6(done)

    );

endmodule
