`timescale 1ns/1ps
module aes_top_tb;
    reg  clk = 0, reset = 1, start = 0;
    wire done, match;
    wire [127:0] cipher_text, recovered_plaintext;

    aes_top DUT(.clk(clk), .reset(reset), .start(start),
                    .done(done), .match(match),
                    .cipher_text(cipher_text),
                    .recovered_plaintext(recovered_plaintext));

    always #5 clk = ~clk;

    initial begin
        #25 reset = 0;
        #20 start = 1;
        #10 start = 0;
        wait (done);
        #10;
                $display("---------------- ENCRYPTION ----------------");
        $display("plaintext        : %h", 128'h48454C4C4F20574F524C440000000000);
        $display("after AddRoundKey: %h", DUT.enc_in);
        $display("after SubBytes   : %h", DUT.enc_subbytes);
        $display("after ShiftRows  : %h", DUT.enc_shiftrows);
        $display("after MixColumns : %h", DUT.enc_mixcolumns);
        $display("ciphertext (^key): %h", DUT.enc_out);
        $display("---------------- DECRYPTION ----------------");
        $display("ciphertext       : %h", DUT.cipher_reg);
        $display("after AddRoundKey: %h", DUT.dec_addroundkey);
        $display("after InvMixCols : %h", DUT.dec_invmixcolumns);
        $display("after InvShiftRow: %h", DUT.dec_invshiftrows);
        $display("after InvSubBytes: %h", DUT.dec_invsubbytes);
        $display("plaintext (^key) : %h", DUT.dec_out);
        $display("cipher    = %h", cipher_text);
        $display("recovered = %h", recovered_plaintext);
        if (match && cipher_text == 128'h3B25800C7F90E1B92C282B803B9EA046)
            $display("PASS");
        else
            $display("FAIL");
        $finish;
    end
endmodule