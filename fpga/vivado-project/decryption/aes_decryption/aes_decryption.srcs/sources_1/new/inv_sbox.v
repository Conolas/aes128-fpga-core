module inv_sbox(

    input [7:0] in,
    output [7:0] out

);

    reg [7:0] inv_sbox_mem [0:255];

    initial
    begin

        $readmemh("inv_sbox.mem", inv_sbox_mem);

    end

    assign out = inv_sbox_mem[in];

endmodule