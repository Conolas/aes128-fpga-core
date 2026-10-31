`timescale 1ns/1ps

module key_expand_step(
    input  [127:0] key_in,     // previous round key
    input  [7:0]   rcon,       // round constant
    output [127:0] key_out     // next round key
);

    // the key is 4 words of 32 bits
    wire [31:0] w0 = key_in[127:96];
    wire [31:0] w1 = key_in[95:64];
    wire [31:0] w2 = key_in[63:32];
    wire [31:0] w3 = key_in[31:0];

    // RotWord: rotate the last word left by one byte
    wire [31:0] rot = {w3[23:0], w3[31:24]};

    // SubWord: run its 4 bytes through your sbox
    wire [31:0] sub;
    sbox S0(.in(rot[31:24]), .out(sub[31:24]));
    sbox S1(.in(rot[23:16]), .out(sub[23:16]));
    sbox S2(.in(rot[15:8]),  .out(sub[15:8]));
    sbox S3(.in(rot[7:0]),   .out(sub[7:0]));

    // XOR the round constant into the top byte
    wire [31:0] t = {sub[31:24] ^ rcon, sub[23:0]};

    // each new word = old word XOR the new word before it
    wire [31:0] n0 = w0 ^ t;
    wire [31:0] n1 = w1 ^ n0;
    wire [31:0] n2 = w2 ^ n1;
    wire [31:0] n3 = w3 ^ n2;

    assign key_out = {n0, n1, n2, n3};

endmodule