`timescale 1ns/1ps

module key_schedule(
    input  [127:0] key,
    output [127:0] k0, k1, k2, k3, k4, k5, k6, k7, k8, k9, k10
);

    assign k0 = key;                       // round 0 uses the original key

    key_expand_step X1  (.key_in(k0), .rcon(8'h01), .key_out(k1));
    key_expand_step X2  (.key_in(k1), .rcon(8'h02), .key_out(k2));
    key_expand_step X3  (.key_in(k2), .rcon(8'h04), .key_out(k3));
    key_expand_step X4  (.key_in(k3), .rcon(8'h08), .key_out(k4));
    key_expand_step X5  (.key_in(k4), .rcon(8'h10), .key_out(k5));
    key_expand_step X6  (.key_in(k5), .rcon(8'h20), .key_out(k6));
    key_expand_step X7  (.key_in(k6), .rcon(8'h40), .key_out(k7));
    key_expand_step X8  (.key_in(k7), .rcon(8'h80), .key_out(k8));
    key_expand_step X9  (.key_in(k8), .rcon(8'h1B), .key_out(k9));
    key_expand_step X10 (.key_in(k9), .rcon(8'h36), .key_out(k10));

endmodule