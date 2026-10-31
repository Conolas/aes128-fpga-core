`timescale 1ns/1ps

module aes_top(
    input          clk,
    input          reset,
    input          start,
    output         done,
    output         match,
    output [127:0] cipher_text,
    output [127:0] recovered_plaintext
);

    localparam [127:0] PLAIN_TEXT = 128'h48454C4C4F20574F524C440000000000;
    localparam [127:0] KEY        = 128'h000102030405060708090A0B0C0D0E0F;
    
    wire [127:0] k0, k1, k2, k3, k4, k5, k6, k7, k8, k9, k10;
    key_schedule KS(.key(KEY),
                    .k0(k0), .k1(k1), .k2(k2), .k3(k3), .k4(k4), .k5(k5),
                    .k6(k6), .k7(k7), .k8(k8), .k9(k9), .k10(k10));

    reg [3:0]   round;
    reg [127:0] round_key;
    always @(*) begin
        case (round)
            4'd1:  round_key = k1;   4'd2:  round_key = k2;
            4'd3:  round_key = k3;   4'd4:  round_key = k4;
            4'd5:  round_key = k5;   4'd6:  round_key = k6;
            4'd7:  round_key = k7;   4'd8:  round_key = k8;
            4'd9:  round_key = k9;   4'd10: round_key = k10;
            default: round_key = k0;
        endcase
    end
    
    reg  [127:0] state_reg;
    wire         is_round10 = (round == 4'd10);

    wire [127:0] enc_out, enc_sb, enc_sr, enc_mc;
    aes_encrypt_round_v2 ENC(
        .state_in(state_reg), .round_key(round_key), .last_round(is_round10),
        .subbytes_debug(enc_sb), .shiftrows_debug(enc_sr), .mixcolumns_debug(enc_mc),
        .state_out(enc_out)
    );

    wire [127:0] dec_out, dec_imc, dec_isr, dec_isb;
    aes_decrypt_round_v2 DEC(
        .state_in(state_reg), .round_key(round_key), .first_round(is_round10),
        .inv_mixcolumns_debug(dec_imc), .inv_shiftrows_debug(dec_isr),
        .inv_subbytes_debug(dec_isb), .state_out(dec_out)
    );
    
    localparam [2:0] S_IDLE = 3'd0, S_ENC = 3'd1, S_DEC = 3'd2, S_DONE = 3'd3;
    reg [2:0]   state;
    reg [127:0] cipher_reg;
    wire [127:0] dec_ark = state_reg ^ round_key;    // decrypt's AddRoundKey stage

    always @(posedge clk) begin
        if (reset) begin
            state      <= S_IDLE;
            round      <= 4'd0;
            state_reg  <= 128'd0;
            cipher_reg <= 128'd0;
        end else begin
            case (state)
                S_IDLE, S_DONE: begin
                    if (start) begin
                        state_reg <= PLAIN_TEXT ^ k0;     // initial AddRoundKey
                        round     <= 4'd1;
                        state     <= S_ENC;
                    end
                end

                S_ENC: begin
                    state_reg <= enc_out;
                    if (round == 4'd10) begin             // encryption finished
                        cipher_reg <= enc_out;
                        round      <= 4'd10;              // decrypt starts at round 10
                        state      <= S_DEC;
                    end else
                        round <= round + 4'd1;
                end

                S_DEC: begin
                    if (round == 4'd1) begin
                        state_reg <= dec_out ^ k0;        // final XOR with k0
                        state     <= S_DONE;
                    end else begin
                        state_reg <= dec_out;
                        round     <= round - 4'd1;
                    end
                end

                default: state <= S_IDLE;
            endcase
        end
    end
    
    assign cipher_text         = cipher_reg;
    assign recovered_plaintext = state_reg;
    assign done                = (state == S_DONE);
    assign match               = done && (state_reg == PLAIN_TEXT);

endmodule