`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/15/2021 06:40:11 PM
// Design Name: 
// Module Name: top_demo
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


module top_demo
(
  // input
  input  logic [7:0] sw,
  input  logic [3:0] btn,
  input  logic       sysclk_125mhz,
  input  logic       rst,
  // output  
  output logic [7:0] led,
  output logic sseg_ca,
  output logic sseg_cb,
  output logic sseg_cc,
  output logic sseg_cd,
  output logic sseg_ce,
  output logic sseg_cf,
  output logic sseg_cg,
  output logic sseg_dp,
  output logic [3:0] sseg_an
);
  
  logic [16:0] CURRENT_COUNT;
  logic [16:0] NEXT_COUNT;
  logic        smol_clk;
  logic [63:0] key;
  logic [63:0] plaintext;
  logic encrypt;
  assign encrypt = sw[7];
  logic [63:0] ciphertext;
  logic [15:0] out;
  assign key = 64'h133457799bbcdff1;
  assign plaintext = (sw[7])? 64'h123456abcd132536:64'hf77bcd7dfe57e119;
  //assign key = 64'h433e4529462a4a62;
  //assign key = 64'h3b3898371520f75e;
  //assign key = 64'h0e329232ea6d0d73;
  assign led[0] = ~{key[0]^key[8]^key[16]^key[24]^key[32]^key[40]^key[48]^key[56]};
  
//assign led[0] = key[4];
//assign led[1] = key[8];
//assign led[2] = key[16];
//assign led[3] = key[32];
//assign led[4] = key[40];
//assign led[5] = key[48];
//assign led[6] = key[56];
//assign led[7] = key[64];

  always_comb begin
  case(sw[3:0])
  
  
  4'b0000 : out[15:0] = plaintext[15:0];
  4'b0001 : out[15:0] = plaintext [31:16];
  4'b0010 : out[15:0] = plaintext [47:32];
  4'b0011 : out[15:0] = plaintext [63:48];
  4'b0100 : out[15:0] = ciphertext [15:0];
  4'b0101 : out[15:0] = ciphertext [31:16];
  4'b0110 : out[15:0] = ciphertext [47:32];
  4'b0111 : out[15:0] = ciphertext [63:48];
  4'b1000 : out[15:0] = key [15:0];
  4'b1001 : out[15:0] = key [31:16];
  4'b1010 : out[15:0] = key [47:32];
  4'b1011 : out[15:0] = key [63:48];
  default : out = 16'b0;
  endcase
  end

  
  
  // Place TicTacToe instantiation here
  DES stupid (key, plaintext, encrypt, ciphertext);

  
  // 7-segment display
  segment_driver driver(
  .clk(smol_clk),
  .rst(btn[3]),
  .digit0(out[3:0]),
  .digit1(out[7:4]),
  .digit2(out[11:8]),
  .digit3(out[15:12]),
  .decimals({1'b0, btn[2:0]}),
  .segment_cathodes({sseg_dp, sseg_cg, sseg_cf, sseg_ce, sseg_cd, sseg_cc, sseg_cb, sseg_ca}),
  .digit_anodes(sseg_an)
  );

// Register logic storing clock counts
  always@(posedge sysclk_125mhz)
  begin
    if(btn[3])
      CURRENT_COUNT = 17'h00000;
    else
      CURRENT_COUNT = NEXT_COUNT;
  end
  
  // Increment logic
  assign NEXT_COUNT = CURRENT_COUNT == 17'd100000 ? 17'h00000 : CURRENT_COUNT + 1;

  // Creation of smaller clock signal from counters
  assign smol_clk = CURRENT_COUNT == 17'd100000 ? 1'b1 : 1'b0;

endmodule
