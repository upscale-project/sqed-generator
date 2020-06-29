// Copyright (c) Stanford University
// 
// This source code is patent protected and being made available under the
// terms explained in the ../LICENSE-Academic and ../LICENSE-GOV files.
//
// Author: Mario J Srouji
// Email: msrouji@stanford.edu

module qed (
// Outputs
vld_out,
qed_ifu_instruction,
// Inputs
ena,
ifu_qed_instruction,
clk,
exec_dup,
stall_IF,
rst);

  input ena;
  input [31:0] ifu_qed_instruction;
  input clk;
  input exec_dup;
  input stall_IF;
  input rst;

  output vld_out;
  output [31:0] qed_ifu_instruction;
  wire [1:0] opcode2;
  wire [3:0] opcode4;
  wire [5:0] opcode6;
  wire [7:0] opcodeFP;
  wire [15:0] simm16;
  wire [3:0] opcode4EXT;
  wire [4:0] rD;
  wire [4:0] rA;
  wire [4:0] rB;

  wire IS_I;
  wire IS_LW;
  wire IS_R;
  wire IS_SW;

  wire [31:0] qed_instruction;
  wire [31:0] qic_qimux_instruction;

  qed_decoder dec (.ifu_qed_instruction(qic_qimux_instruction),
                   .opcode2(opcode2),
                   .opcode4(opcode4),
                   .opcode6(opcode6),
                   .opcodeFP(opcodeFP),
                   .simm16(simm16),
                   .opcode4EXT(opcode4EXT),
                   .rD(rD),
                   .rA(rA),
                   .rB(rB),
                   .IS_I(IS_I),
                   .IS_LW(IS_LW),
                   .IS_R(IS_R),
                   .IS_SW(IS_SW));

  modify_instruction minst (.qed_instruction(qed_instruction),
                            .qic_qimux_instruction(qic_qimux_instruction),
                            .opcode2(opcode2),
                            .opcode4(opcode4),
                            .opcode6(opcode6),
                            .opcodeFP(opcodeFP),
                            .simm16(simm16),
                            .opcode4EXT(opcode4EXT),
                            .rD(rD),
                            .rA(rA),
                            .rB(rB),
                            .IS_I(IS_I),
                            .IS_LW(IS_LW),
                            .IS_R(IS_R),
                            .IS_SW(IS_SW));

  qed_instruction_mux imux (.qed_ifu_instruction(qed_ifu_instruction),
                            .ifu_qed_instruction(ifu_qed_instruction),
                            .qed_instruction(qed_instruction),
                            .exec_dup(exec_dup),
                            .ena(ena));

  qed_i_cache qic (.qic_qimux_instruction(qic_qimux_instruction),
                   .vld_out(vld_out),
                   .clk(clk),
                   .rst(rst),
                   .exec_dup(exec_dup),
                   .IF_stall(stall_IF),
                   .ifu_qed_instruction(ifu_qed_instruction));

endmodule