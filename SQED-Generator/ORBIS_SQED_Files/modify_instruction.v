// Copyright (c) Stanford University
// 
// This source code is patent protected and being made available under the
// terms explained in the ../LICENSE-Academic and ../LICENSE-GOV files.
//
// Author: Mario J Srouji
// Email: msrouji@stanford.edu

module qed_decoder (
// Outputs
IS_SW,
opcode2,
opcode4,
opcode6,
opcodeFP,
opcode4EXT,
simm16,
rD,
IS_R,
rA,
rB,
IS_I,
IS_LW,
// Inputs
ifu_qed_instruction);

  input [31:0] ifu_qed_instruction;

  output IS_SW;
  output [1:0] opcode2;
  output [3:0] opcode4;
  output [5:0] opcode6;
  output [7:0] opcodeFP;
  output [3:0] opcode4EXT;
  output [15:0] simm16;
  output [4:0] rD;
  output IS_R;
  output [4:0] rA;
  output [4:0] rB;
  output IS_I;
  output IS_LW;

  assign opcode2 = ifu_qed_instruction[9:8];
  assign opcode4 = ifu_qed_instruction[3:0];
  assign opcode6 = ifu_qed_instruction[31:26];
  assign opcodeFP = ifu_qed_instruction[7:0];
  assign simm16 = ifu_qed_instruction[15:0];
  assign opcode4EXT = ifu_qed_instruction[9:6];
  assign rD = ifu_qed_instruction[25:21];
  assign rA = ifu_qed_instruction[20:16];
  assign rB = ifu_qed_instruction[15:11];

  assign IS_I = ((opcode6 == 6'b100111) || (opcode6 == 6'b101001) || (opcode6 == 6'b101100) || (opcode6 == 6'b101010) || (opcode6 == 6'b101011) || (opcode6 == 6'b101110));
  assign IS_LW = (instruction[15:14] == 2'b00) && ((opcode6 == 6'b100100) || (opcode6 == 6'b100011) || (opcode6 == 6'b100110) || (opcode6 == 6'b100101) || (opcode6 == 6'b100010) || (opcode6 == 6'b100001));
  assign IS_R = (opcode6 == 6'b111000);
  assign IS_SW = ((opcode6 == 6'b110110) || (opcode6 == 6'b110111) || (opcode6 == 6'b110101));

endmodule