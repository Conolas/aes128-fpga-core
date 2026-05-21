module inv_subbytes(

    input  [127:0] data_in,
    output [127:0] data_out

);

    genvar i;

    generate

        for(i = 0; i < 16; i = i + 1)
        begin

            inv_sbox S(

                .in(data_in[(127-(i*8)) -: 8]),
                .out(data_out[(127-(i*8)) -: 8])

            );

        end

    endgenerate

endmodule