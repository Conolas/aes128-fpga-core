`timescale 1ns/1ps

//////////////////////////////////////////////////////////////////////////////////
// TESTBENCH FOR COMPLETE AES SYSTEM
//////////////////////////////////////////////////////////////////////////////////

module aes_system_top_tb;

    // =========================================================
    // INPUTS
    // =========================================================

    reg clk;
    reg reset;

    // =========================================================
    // DUT
    // =========================================================

    aes_system_top DUT(

        .clk(clk),
        .reset(reset)

    );

    // =========================================================
    // CLOCK GENERATION
    // =========================================================

    initial
    begin

        clk = 0;

        forever #5 clk = ~clk;

    end

    // =========================================================
    // TEST SEQUENCE
    // =========================================================

    initial
    begin

        // ============================================
        // INITIAL RESET
        // ============================================

        reset = 1'b1;

        #20;

        reset = 1'b0;

        // ============================================
        // WAIT FOR SIGNALS TO STABILIZE
        // ============================================

        #100;

        // ============================================
        // DISPLAY COMPLETE AES FLOW
        // ============================================

        $display("\n");
        $display("======================================================");
        $display("                 AES SYSTEM OUTPUT                    ");
        $display("======================================================");

        // =====================================================
        // INPUTS
        // =====================================================

        $display("PLAINTEXT               = %h", DUT.plain_text);
        $display("KEY                     = %h", DUT.key);

        $display("------------------------------------------------------");

        // =====================================================
        // ENCRYPTION STAGES
        // =====================================================

        $display("ENCRYPTION STAGES");
        $display("");

        $display("SUBBYTES OUTPUT         = %h", DUT.enc_subbytes);

        $display("SHIFTROWS OUTPUT        = %h", DUT.enc_shiftrows);

        $display("MIXCOLUMNS OUTPUT       = %h", DUT.enc_mixcolumns);

        $display("CIPHERTEXT              = %h", DUT.cipher_text);

        $display("------------------------------------------------------");

        // =====================================================
        // DECRYPTION STAGES
        // =====================================================

        $display("DECRYPTION STAGES");
        $display("");

        $display("INVMIXCOLUMNS OUTPUT    = %h",
                  DUT.dec_invmixcolumns);

        $display("INVSHIFTROWS OUTPUT     = %h",
                  DUT.dec_invshiftrows);

        $display("INVSUBBYTES OUTPUT      = %h",
                  DUT.dec_invsubbytes);

        $display("RECOVERED PLAINTEXT     = %h",
                  DUT.recovered_plaintext);

        $display("------------------------------------------------------");

        // =====================================================
        // ASCII DISPLAY
        // =====================================================

        $display("RECOVERED ASCII TEXT    = %s",
                  DUT.recovered_plaintext);

        $display("======================================================");
        $display("\n");

        // ============================================
        // FINISH
        // ============================================

        #50;

        $stop;

    end

    // =========================================================
    // LIVE MONITOR
    // =========================================================

    initial
    begin

        $monitor(

        "TIME=%0t | PT=%h | CT=%h | RPT=%h",

        $time,

        DUT.plain_text,
        DUT.cipher_text,
        DUT.recovered_plaintext

        );

    end

endmodule