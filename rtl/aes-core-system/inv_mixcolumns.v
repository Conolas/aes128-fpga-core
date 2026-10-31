`timescale 1ns/1ps
// =============================================================================
// inv_mixcolumns.v  -- AES InvMixColumns on a 128-bit state
//
// Based on your original InvMixColumns.v.  The GF(2^8) helper functions
// (xtime, mul9, mul11, mul13, mul14) are kept EXACTLY as you wrote them.
//
// What changed and why:
//   * Module renamed InvMixColumns -> inv_mixcolumns (same style as the other
//     modules; Verilog is case sensitive and mixed names cause mistakes).
//   * Removed the `wire [7:0] s [0:15]` / `o [0:15]` arrays.  Yosys (the
//     synthesis tool in the OpenROAD flow) does not reliably accept arrays of
//     wires driven by `assign`.  Vivado does, which is why it worked on FPGA.
//     Each column is now handled with plain 8-bit wires (a0..a3) inside a
//     generate loop, so the same code works in every tool.
//   * Same maths: out = [14 11 13 9; 9 14 11 13; 13 9 14 11; 11 13 9 14] * col
// =============================================================================
module InvMixColumns(
    input  [127:0] data_in,
    output [127:0] data_out
);

    // Multiply by 2 in GF(2^8)  (unchanged from your code)
    function [7:0] xtime;
        input [7:0] b;
        begin
            xtime = (b[7]) ? ((b << 1) ^ 8'h1B) : (b << 1);
        end
    endfunction

    // Multiply by 9 (unchanged)
    function [7:0] mul9;
        input [7:0] b;
        begin
            mul9 = xtime(xtime(xtime(b))) ^ b;
        end
    endfunction

    // Multiply by 11 (unchanged)
    function [7:0] mul11;
        input [7:0] b;
        begin
            mul11 = xtime(xtime(xtime(b))) ^ xtime(b) ^ b;
        end
    endfunction

    // Multiply by 13 (unchanged)
    function [7:0] mul13;
        input [7:0] b;
        begin
            mul13 = xtime(xtime(xtime(b))) ^ xtime(xtime(b)) ^ b;
        end
    endfunction

    // Multiply by 14 (unchanged)
    function [7:0] mul14;
        input [7:0] b;
        begin
            mul14 = xtime(xtime(xtime(b))) ^ xtime(xtime(b)) ^ xtime(b);
        end
    endfunction

    genvar c;
    generate
        for (c = 0; c < 4; c = c + 1) begin : col
            // the four bytes of column c (byte 0 is the most significant)
            wire [7:0] a0 = data_in[127 - 32*c -: 8];
            wire [7:0] a1 = data_in[119 - 32*c -: 8];
            wire [7:0] a2 = data_in[111 - 32*c -: 8];
            wire [7:0] a3 = data_in[103 - 32*c -: 8];

            assign data_out[127 - 32*c -: 8] = mul14(a0) ^ mul11(a1) ^ mul13(a2) ^ mul9(a3);
            assign data_out[119 - 32*c -: 8] = mul9(a0)  ^ mul14(a1) ^ mul11(a2) ^ mul13(a3);
            assign data_out[111 - 32*c -: 8] = mul13(a0) ^ mul9(a1)  ^ mul14(a2) ^ mul11(a3);
            assign data_out[103 - 32*c -: 8] = mul11(a0) ^ mul13(a1) ^ mul9(a2)  ^ mul14(a3);
        end
    endgenerate

endmodule