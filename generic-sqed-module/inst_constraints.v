module inst_constraint (
// Inputs
clk,
instruction);

  input clk;
  input [31:0] instruction;

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

  wire MULH;
  wire SUB;
  wire SW;
  wire SRAI;
  wire MUL;
  wire ANDI;
  wire LW;
  wire MULHU;
  wire SRA;
  wire XOR;
  wire SLT;
  wire SRL;
  wire MULHSU;
  wire ADD;
  wire XORI;
  wire AND;
  wire SLL;
  wire SLTIU;
  wire SRLI;
  wire SLTI;
  wire SLTU;
  wire SLLI;
  wire ORI;
  wire NOP;
  wire OR;
  wire ADDI;

  assign shamt = instruction[24:20];
  assign simm12 = instruction[31:20];
  assign rd = instruction[11:7];
  assign imm5 = instruction[11:7];
  assign funct3 = instruction[14:12];
  assign opcode = instruction[6:0];
  assign funct7 = instruction[31:25];
  assign simm7 = instruction[31:25];
  assign rs1 = instruction[19:15];
  assign rs2 = instruction[24:20];

  assign MULH = (funct3 == 3'b001) && (opcode == 7'b0110011) && (funct7 == 7'b0000001);
  assign SUB = (funct3 == 3'b000) && (opcode == 7'b0110011) && (funct7 == 7'b0100000);
  assign SW = (funct3 == 3'b010) && (opcode == 7'b0100011) && (rs1 == 5'b00000);
  assign SRAI = (funct3 == 3'b101) && (opcode == 7'b0010011) && (funct7 == 7'b0100000);
  assign MUL = (funct3 == 3'b000) && (opcode == 7'b0110011) && (funct7 == 7'b0000001);
  assign ANDI = (funct3 == 3'b111) && (opcode == 7'b0010011);
  assign LW = (funct3 == 3'b010) && (opcode == 7'b0000011) && (rs1 == 5'b00000);
  assign MULHU = (funct3 == 3'b011) && (opcode == 7'b0110011) && (funct7 == 7'b0000001);
  assign SRA = (funct3 == 3'b101) && (opcode == 7'b0110011) && (funct7 == 7'b0100000);
  assign XOR = (funct3 == 3'b100) && (opcode == 7'b0110011) && (funct7 == 7'b0000000);
  assign SLT = (funct3 == 3'b010) && (opcode == 7'b0110011) && (funct7 == 7'b0000000);
  assign SRL = (funct3 == 3'b101) && (opcode == 7'b0110011) && (funct7 == 7'b0000000);
  assign MULHSU = (funct3 == 3'b010) && (opcode == 7'b0110011) && (funct7 == 7'b0000001);
  assign ADD = (funct3 == 3'b000) && (opcode == 7'b0110011) && (funct7 == 7'b0000000);
  assign XORI = (funct3 == 3'b100) && (opcode == 7'b0010011);
  assign AND = (funct3 == 3'b111) && (opcode == 7'b0110011) && (funct7 == 7'b0000000);
  assign SLL = (funct3 == 3'b001) && (opcode == 7'b0110011) && (funct7 == 7'b0000000);
  assign SLTIU = (funct3 == 3'b011) && (opcode == 7'b0010011);
  assign SRLI = (funct3 == 3'b101) && (opcode == 7'b0010011) && (funct7 == 7'b0000000);
  assign SLTI = (funct3 == 3'b010) && (opcode == 7'b0010011);
  assign SLTU = (funct3 == 3'b011) && (opcode == 7'b0110011) && (funct7 == 7'b0000000);
  assign SLLI = (funct3 == 3'b001) && (opcode == 7'b0010011) && (funct7 == 7'b0000000);
  assign ORI = (funct3 == 3'b110) && (opcode == 7'b0010011);
  assign NOP = (opcode == 7'b1111111);
  assign OR = (funct3 == 3'b110) && (opcode == 7'b0110011) && (funct7 == 7'b0000000);
  assign ADDI = (funct3 == 3'b000) && (opcode == 7'b0010011);

endmodule