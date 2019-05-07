module qed_decoder (
// Outputs
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
shamt,
// Inputs
ifu_qed_instruction);

  input [31:0] ifu_qed_instruction;

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

  assign shamt = ifu_qed_instruction[24:20];
  assign simm12 = ifu_qed_instruction[31:20];
  assign rd = ifu_qed_instruction[11:7];
  assign imm5 = ifu_qed_instruction[11:7];
  assign funct3 = ifu_qed_instruction[14:12];
  assign opcode = ifu_qed_instruction[6:0];
  assign funct7 = ifu_qed_instruction[31:25];
  assign simm7 = ifu_qed_instruction[31:25];
  assign rs1 = ifu_qed_instruction[19:15];
  assign rs2 = ifu_qed_instruction[24:20];

  assign is_lw = (opcode == 7'b0000011) && (funct3 == 3'b010);
  assign is_sw = (opcode == 7'b0100011) && (funct3 == 3'b010);
  assign is_alureg = (opcode == 7'b0110011);
  assign is_aluimm = (opcode == 7'b0010011);

endmodule