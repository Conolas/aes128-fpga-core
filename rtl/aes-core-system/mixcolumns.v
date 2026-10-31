module mixcolumns(

input [127:0] data_in,
output [127:0] data_out

);

// =========================================================
// XTIME FUNCTION
// =========================================================

function [7:0] xtime;

    input [7:0] b;

    begin

        if(b[7] == 1'b1)
            xtime = (b << 1) ^ 8'h1B;
        else
            xtime = (b << 1);

    end

endfunction

// =========================================================
// MUL3 FUNCTION
// =========================================================

function [7:0] mul3;

    input [7:0] b;

    begin

        mul3 = xtime(b) ^ b;

    end

endfunction

// =========================================================
// COLUMN 0
// =========================================================

wire [7:0] s0, s1, s2, s3;
wire [7:0] y0, y1, y2, y3;

assign s0 = data_in[127:120];
assign s1 = data_in[119:112];
assign s2 = data_in[111:104];
assign s3 = data_in[103:96];

assign y0 = xtime(s0) ^ mul3(s1) ^ s2 ^ s3;
assign y1 = s0 ^ xtime(s1) ^ mul3(s2) ^ s3;
assign y2 = s0 ^ s1 ^ xtime(s2) ^ mul3(s3);
assign y3 = mul3(s0) ^ s1 ^ s2 ^ xtime(s3);

// =========================================================
// COLUMN 1
// =========================================================

wire [7:0] s4, s5, s6, s7;
wire [7:0] y4, y5, y6, y7;

assign s4 = data_in[95:88];
assign s5 = data_in[87:80];
assign s6 = data_in[79:72];
assign s7 = data_in[71:64];

assign y4 = xtime(s4) ^ mul3(s5) ^ s6 ^ s7;
assign y5 = s4 ^ xtime(s5) ^ mul3(s6) ^ s7;
assign y6 = s4 ^ s5 ^ xtime(s6) ^ mul3(s7);
assign y7 = mul3(s4) ^ s5 ^ s6 ^ xtime(s7);

// =========================================================
// COLUMN 2
// =========================================================

wire [7:0] s8, s9, s10, s11;
wire [7:0] y8, y9, y10, y11;

assign s8  = data_in[63:56];
assign s9  = data_in[55:48];
assign s10 = data_in[47:40];
assign s11 = data_in[39:32];

assign y8  = xtime(s8) ^ mul3(s9) ^ s10 ^ s11;
assign y9  = s8 ^ xtime(s9) ^ mul3(s10) ^ s11;
assign y10 = s8 ^ s9 ^ xtime(s10) ^ mul3(s11);
assign y11 = mul3(s8) ^ s9 ^ s10 ^ xtime(s11);

// =========================================================
// COLUMN 3
// =========================================================

wire [7:0] s12, s13, s14, s15;
wire [7:0] y12, y13, y14, y15;

assign s12 = data_in[31:24];
assign s13 = data_in[23:16];
assign s14 = data_in[15:8];
assign s15 = data_in[7:0];

assign y12 = xtime(s12) ^ mul3(s13) ^ s14 ^ s15;
assign y13 = s12 ^ xtime(s13) ^ mul3(s14) ^ s15;
assign y14 = s12 ^ s13 ^ xtime(s14) ^ mul3(s15);
assign y15 = mul3(s12) ^ s13 ^ s14 ^ xtime(s15);

// =========================================================
// FINAL OUTPUT
// =========================================================

assign data_out = {

    y0,
    y1,
    y2,
    y3,

    y4,
    y5,
    y6,
    y7,

    y8,
    y9,
    y10,
    y11,

    y12,
    y13,
    y14,
    y15

};

endmodule