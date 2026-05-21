`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 20.05.2026 13:07:52
// Design Name: 
// Module Name: InvMixColumns
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module InvMixColumns(
    input [127:0] data_in,
    output [127:0] data_out
    );
    
    //Multiply byte by 2 in Galois Field
    function [7:0] xtime;
        input [7:0] b;
            begin
                xtime = (b[7]) ? ((b<<1)^8'h1B) : (b<<1); 
            end
    endfunction
    
    //Multiply byte by 9 in Galois Field    
        function [7:0] mul9;
            input [7:0] b;
                begin
                    mul9=xtime(xtime(xtime(b)))^b;
                end
       endfunction
       
   //Multiply byte by 11 in Galois Field
        function [7:0] mul11;
            input [7:0] b;
                begin
                    mul11=xtime(xtime(xtime(b))) ^ xtime(b) ^ b;
                end
        endfunction
        
   //Multiply byte by 13 in Galois Field
       function [7:0] mul13;
            input [7:0] b;
                begin
                    mul13=xtime(xtime(xtime(b))) ^ xtime(xtime(b)) ^ b;
                end
        endfunction
   
   //Multiply byte by 14 in Galois Field
      function [7:0] mul14;
            input [7:0] b;
                begin
                    mul14=xtime(xtime(xtime(b))) ^ xtime(xtime(b)) ^ xtime(b);
                end
        endfunction
        
    wire [7:0] s [0:15];
    wire [7:0] o [0:15];
    
    //Split bytes for Input
    genvar i;
    generate
        for(i=0;i<16;i=i+1)
            begin: byte_split
                assign s[i]=data_in[127 -i*8 -: 8];
            end
    endgenerate
    
    //Column 0
    assign o[0]=mul14(s[0])^mul11(s[1])^mul13(s[2])^mul9(s[3]);
    assign o[1]=mul9(s[0])^mul14(s[1])^mul11(s[2])^mul13(s[3]);
    assign o[2]=mul13(s[0])^mul9(s[1])^mul14(s[2])^mul11(s[3]);
    assign o[3]=mul11(s[0])^mul13(s[1])^mul9(s[2])^mul14(s[3]);
    
    //Column1
    assign o[4]=mul14(s[4])^mul11(s[5])^mul13(s[6])^mul9(s[7]);
    assign o[5]=mul9(s[4])^mul14(s[5])^mul11(s[6])^mul13(s[7]);
    assign o[6]=mul13(s[4])^mul9(s[5])^mul14(s[6])^mul11(s[7]);
    assign o[7]=mul11(s[4])^mul13(s[5])^mul9(s[6])^mul14(s[7]);
    
    //Column2
    assign o[8]=mul14(s[8])^mul11(s[9])^mul13(s[10])^mul9(s[11]);
    assign o[9]=mul9(s[8])^mul14(s[9])^mul11(s[10])^mul13(s[11]);
    assign o[10]=mul13(s[8])^mul9(s[9])^mul14(s[10])^mul11(s[11]);
    assign o[11]=mul11(s[8])^mul13(s[9])^mul9(s[10])^mul14(s[11]);
    
    //Column3
    assign o[12]=mul14(s[12])^mul11(s[13])^mul13(s[14])^mul9(s[15]);
    assign o[13]=mul9(s[12])^mul14(s[13])^mul11(s[14])^mul13(s[15]);
    assign o[14]=mul13(s[12])^mul9(s[13])^mul14(s[14])^mul11(s[15]);
    assign o[15]=mul11(s[12])^mul13(s[13])^mul9(s[14])^mul14(s[15]);
    
   // Join bytes for output

// Join bytes for output

generate

    for(i = 0; i < 16; i = i + 1)
    begin : byte_join

        assign data_out[127 - i*8 -: 8] = o[i];

    end

endgenerate
        
endmodule
