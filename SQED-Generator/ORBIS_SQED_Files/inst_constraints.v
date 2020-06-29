// Copyright (c) Stanford University
// 
// This source code is patent protected and being made available under the
// terms explained in the ../LICENSE-Academic and ../LICENSE-GOV files.
//
// Author: Mario J Srouji
// Email: msrouji@stanford.edu

module inst_constraint (
// Inputs
instruction,
clk);

  input [31:0] instruction;
  input clk;

  wire [1:0] opcode2;
  wire [3:0] opcode4;
  wire [5:0] opcode6;
  wire [7:0] opcodeFP;
  wire [15:0] simm16;
  wire [3:0] opcode4EXT;
  wire [4:0] rD;
  wire [4:0] rA;
  wire [4:0] rB;

  wire FORMAT_I;
  wire ALLOWED_I;
  wire MULI;
  wire ANDI;
  wire SRLI;
  wire SRAI;
  wire SLLI;
  wire ORI;
  wire XORI;
  wire ADDI;

  wire FORMAT_LW;
  wire ALLOWED_LW;
  wire LWZ;
  wire LBS;
  wire LWS;
  wire LBZ;
  wire LHS;
  wire LHZ;

  wire FORMAT_R;
  wire ALLOWED_R;
  wire SUB;
  wire EXTBZ;
  wire FF1;
  wire MUL;
  wire DIV;
  wire EXTBS;
  wire EXTHZ;
  wire EXTWZ;
  wire ROR;
  wire MULU;
  wire SRA;
  wire XOR;
  wire SRL;
  wire SLL;
  wire ADD;
  wire DIVU;
  wire EXTWS;
  wire AND;
  wire FL1;
  wire EXTHS;
  wire OR;

  wire FORMAT_SW;
  wire ALLOWED_SW;
  wire SB;
  wire SH;
  wire SW;

  assign opcode2 = instruction[9:8];
  assign opcode4 = instruction[3:0];
  assign opcode6 = instruction[31:26];
  assign opcodeFP = instruction[7:0];
  assign simm16 = instruction[15:0];
  assign opcode4EXT = instruction[9:6];
  assign rD = instruction[25:21];
  assign rA = instruction[20:16];
  assign rB = instruction[15:11];

  assign FORMAT_I = (rD < 16) && (rA < 16);
  assign MULI = FORMAT_I && (opcode6 == 6'b101100);
  assign ANDI = FORMAT_I && (opcode6 == 6'b101001);
  assign SRLI = FORMAT_I && (instruction[7:6] == 2'b01) && (opcode6 == 6'b101110);
  assign SRAI = FORMAT_I && (instruction[7:6] == 2'b10) && (opcode6 == 6'b101110);
  assign SLLI = FORMAT_I && (instruction[7:6] == 2'b00) && (opcode6 == 6'b101110);
  assign ORI = FORMAT_I && (opcode6 == 6'b101010);
  assign XORI = FORMAT_I && (opcode6 == 6'b101011);
  assign ADDI = FORMAT_I && (opcode6 == 6'b100111);
  assign ALLOWED_I = MULI || ANDI || SRLI || SRAI || SLLI || ORI || XORI || ADDI;

  assign FORMAT_LW = (rD < 16) && (rA < 16);
  assign LWZ = FORMAT_LW && (instruction[15:14] == 2'b00) && (rA == 5'b00000) && (opcode6 == 6'b100001);
  assign LBS = FORMAT_LW && (instruction[15:14] == 2'b00) && (rA == 5'b00000) && (opcode6 == 6'b100100);
  assign LWS = FORMAT_LW && (instruction[15:14] == 2'b00) && (rA == 5'b00000) && (opcode6 == 6'b100010);
  assign LBZ = FORMAT_LW && (instruction[15:14] == 2'b00) && (rA == 5'b00000) && (opcode6 == 6'b100011);
  assign LHS = FORMAT_LW && (instruction[15:14] == 2'b00) && (rA == 5'b00000) && (opcode6 == 6'b100110);
  assign LHZ = FORMAT_LW && (instruction[15:14] == 2'b00) && (rA == 5'b00000) && (opcode6 == 6'b100101);
  assign ALLOWED_LW = LWZ || LBS || LWS || LBZ || LHS || LHZ;

  assign FORMAT_R = (rD < 16) && (rA < 16) && (rB < 16);
  assign SUB = FORMAT_R && (opcode2 == 2'b00) && (opcode4 == 4'b0101) && (opcode6 == 6'b111000);
  assign EXTBZ = FORMAT_R && (opcode4 == 4'b1100) && (opcode4EXT == 4'b0011) && (opcode6 == 6'b111000);
  assign FF1 = FORMAT_R && (opcode2 == 2'b00) && (opcode4 == 4'b1111) && (opcode6 == 6'b111000);
  assign MUL = FORMAT_R && (opcode2 == 2'b11) && (opcode4 == 4'b0110) && (opcode6 == 6'b111000);
  assign DIV = FORMAT_R && (opcode2 == 2'b11) && (opcode4 == 4'b1001) && (opcode6 == 6'b111000);
  assign EXTBS = FORMAT_R && (opcode4 == 4'b1100) && (opcode4EXT == 4'b0001) && (opcode6 == 6'b111000);
  assign EXTHZ = FORMAT_R && (opcode4 == 4'b1100) && (opcode4EXT == 4'b0010) && (opcode6 == 6'b111000);
  assign EXTWZ = FORMAT_R && (opcode4 == 4'b1101) && (opcode4EXT == 4'b0001) && (opcode6 == 6'b111000);
  assign ROR = FORMAT_R && (opcode2 == 2'b11) && (opcode4 == 4'b1000) && (opcode6 == 6'b111000);
  assign MULU = FORMAT_R && (opcode2 == 2'b11) && (opcode4 == 4'b1011) && (opcode6 == 6'b111000);
  assign SRA = FORMAT_R && (opcode4 == 4'b1000) && (opcode4EXT == 4'b0010) && (opcode6 == 6'b111000);
  assign XOR = FORMAT_R && (opcode2 == 2'b00) && (opcode4 == 4'b0101) && (opcode6 == 6'b111000);
  assign SRL = FORMAT_R && (opcode4 == 4'b1000) && (opcode4EXT == 4'b0001) && (opcode6 == 6'b111000);
  assign SLL = FORMAT_R && (opcode4 == 4'b1000) && (opcode4EXT == 4'b0000) && (opcode6 == 6'b111000);
  assign ADD = FORMAT_R && (opcode2 == 2'b00) && (opcode4 == 4'b0000) && (opcode6 == 6'b111000);
  assign DIVU = FORMAT_R && (opcode2 == 2'b11) && (opcode4 == 4'b1010) && (opcode6 == 6'b111000);
  assign EXTWS = FORMAT_R && (opcode4 == 4'b1101) && (opcode4EXT == 4'b0000) && (opcode6 == 6'b111000);
  assign AND = FORMAT_R && (opcode2 == 2'b00) && (opcode4 == 4'b0011) && (opcode6 == 6'b111000);
  assign FL1 = FORMAT_R && (opcode2 == 2'b01) && (opcode4 == 4'b1111) && (opcode6 == 6'b111000);
  assign EXTHS = FORMAT_R && (opcode4 == 4'b1100) && (opcode4EXT == 4'b0000) && (opcode6 == 6'b111000);
  assign OR = FORMAT_R && (opcode2 == 2'b00) && (opcode4 == 4'b0100) && (opcode6 == 6'b111000);
  assign ALLOWED_R = SUB || EXTBZ || FF1 || MUL || DIV || EXTBS || EXTHZ || EXTWZ || ROR || MULU || SRA || XOR || SRL || SLL || ADD || DIVU || EXTWS || AND || FL1 || EXTHS || OR;

  assign FORMAT_SW = (rA < 16) && (rB < 16);
  assign SB = FORMAT_SW && (instruction[25:24] == 2'b00) && (rB < 16) && (rA == 5'b00000) && (opcode6 == 6'b110110);
  assign SH = FORMAT_SW && (instruction[25:24] == 2'b00) && (rB < 16) && (rA == 5'b00000) && (opcode6 == 6'b110111);
  assign SW = FORMAT_SW && (instruction[25:24] == 2'b00) && (rB < 16) && (rA == 5'b00000) && (opcode6 == 6'b110101);
  assign ALLOWED_SW = SB || SH || SW;

  always @(posedge clk) begin
    assume property (ALLOWED_I || ALLOWED_LW || ALLOWED_R || ALLOWED_SW);
  end

endmodule