module modify_instruction (
// Outputs
qed_instruction,
// Inputs
qic_qimux_instruction,
is_lw,
is_sw,
is_aluimm,
is_alureg,
rd,
rs1,
rs2,
opcode,
simm12,
funct3,
funct7,
imm5,
simm7,
shamt);

  output [31:0] qed_instruction;

  input [31:0] qic_qimux_instruction;
  output is_lw;
  output is_sw;
  output is_aluimm;
  output is_alureg;
  output [4:0] rd;
  output [4:0] rs1;
  output [4:0] rs2;
  output [6:0] opcode;
  output [11:0] simm12;
  output [2:0] funct3;
  output [6:0] funct7;
  output [4:0] imm5;
  output [6:0] simm7;
  output [4:0] shamt;

  wire [31:0] ins_lw;
  wire [31:0] ins_sw;
  wire [31:0] ins_alureg;
  wire [31:0] ins_aluimm;

  wire [4:0] new_rd;
  wire [4:0] new_rs1;
  wire [4:0] new_rs2;
  wire [11:0] new_simm12;
  wire [6:0] new_simm7;

  assign new_rd = (rd == 5'b00000) ? rd : {1'b1, rd[3:0]};
  assign new_rs1 = (rs1 == 5'b00000) ? rs1 : {1'b1, rs1[3:0]};
  assign new_rs2 = (rs2 == 5'b00000) ? rs2 : {1'b1, rs2[3:0]};
  assign new_simm12 = {2'b01, simm12[9:0]};
  assign new_simm7 = {2'b01, simm7[4:0]};

  assign ins_lw = {new_simm12, 5'b00000, funct3, new_rd, opcode};
  assign ins_sw = {new_simm7, new_rs2, 5'b00000, funct3, imm5, opcode};
  assign ins_aluimm = {simm12, new_rs1, funct3, new_rd, opcode};
  assign ins_alureg = {funct7, new_rs2, new_rs1, funct3, new_rd, opcode};

  assign qed_instruction = is_lw ? ins_lw : (is_sw ? ins_sw : (is_alureg ? ins_alureg : (is_aluimm ? ins_aluimm : instruction)));

endmodule