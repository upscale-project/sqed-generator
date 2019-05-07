module qed (
// Outputs
qed_ifu_instruction,
vld_out,
// Inputs
ifu_qed_instruction,
rst,
ena,
clk,
exec_dup,
stall_IF);

  output [31:0] qed_ifu_instruction;
  output vld_out;

  input [31:0] ifu_qed_instruction;
  output rst;
  output ena;
  output clk;
  output exec_dup;
  output stall_IF;

  wire [4:0] shamt;
  wire [11:0] simm12;
  wire [4:0] rd;
  wire [4:0] imm5;
  wire [2:0] funct3;
  wire [6:0] opcode;
  wire [6:0] funct7;
  wire [6:0] simm7;
  wire [4:0] rs1;
  wire [4:0] rs2;

  wire is_lw;
  wire is_sw;
  wire is_aluimm;
  wire is_alureg;

  wire [31:0] qed_instruction;
  wire [31:0] qic_qimux_instruction;

  qed_decoder dec (.shamt(shamt),
                   .simm12(simm12),
                   .rd(rd),
                   .imm5(imm5),
                   .funct3(funct3),
                   .opcode(opcode),
                   .funct7(funct7),
                   .simm7(simm7),
                   .rs1(rs1),
                   .rs2(rs2),
                   .is_lw(is_lw),
                   .is_sw(is_sw),
                   .is_alureg(is_alureg),
                   .is_aluimm(is_aluimm));

  modify_instruction minst (.qed_instruction(qed_instruction),
                            .qic_qimux_instruction(qic_qimux_instruction),
                            .shamt(shamt),
                            .simm12(simm12),
                            .rd(rd),
                            .imm5(imm5),
                            .funct3(funct3),
                            .opcode(opcode),
                            .funct7(funct7),
                            .simm7(simm7),
                            .rs1(rs1),
                            .rs2(rs2),
                            .is_lw(is_lw),
                            .is_sw(is_sw),
                            .is_alureg(is_alureg),
                            .is_aluimm(is_aluimm));

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
                   .IF_stall(IF_stall),
                   .ifu_qed_instruction(ifu_qed_instruction));

endmodule