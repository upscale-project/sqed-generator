// Constraints for RV64G RISC-V Instructions

module inst_constraint_RV64G(clk, 
                       instruction);
   
   input        clk;
   input [31:0] instruction;


   wire [4:0] rd;
   wire [4:0]  rs1;
   wire [4:0]  rs2;
   wire [6:0]  opcode;
   wire [11:0] simm12;  // signed imm for I type or instructions using rd, rs1 only like LW 
   wire [2:0] funct3;
   wire [6:0] funct7;
   wire [5:0] funct7_64shift; // Karthik : needed because RV64I has changes for shift immediates
   wire [4:0] imm5;  // lower order imm bits for S type instruction
   wire [6:0] simm7; // higher order bits (including sign bits) of imm operand for S type instruction
   wire [4:0] shamt; // shift amount for immediate shift operations
   wire [5:0] shamt_64shift; // Karthik : needed because RV64I has changes for shift immediates

   // R format alu instructions
   wire       ADD;
   wire       SUB;
   wire       SLL;
   wire       SLT;
   wire       SLTU;
   wire       XOR;
   wire       SRL;
   wire       SRA;
   wire       OR;
   wire       AND;
   wire       MUL;
   wire       MULH;
   wire       MULHSU;
   wire       MULHU;

   // I format alu instructions
   wire       ADDI;
   wire       SLTI;
   wire       SLTIU;
   wire       XORI;
   wire       ORI;
   wire       ANDI;
   wire       SLLI;
   wire       SRLI;
   wire       SRAI;

   // mem ops
   wire       LW;
   wire       SW;

   // Floating Point Operations
   wire FLW;
   wire FSW;
   wire FADDS;
   wire FSUBS;
   wire FMULS;
   wire FDIVS;
   wire FSQRTS;
   wire FMINS;
   wire FMAXS;
   wire FEQS;
   wire FLTS;
   wire FLES;

   // Double Precision Floating Point Operations
   wire FLD;
   wire FSD;
   wire FADDD;
   wire FSUBD;
   wire FMULD;
   wire FDIVD;
   wire FSQRTD;
   wire FMIND;
   wire FMAXD;
   wire FEQD;
   wire FLTD;
   wire FLED;

   assign opcode = instruction[6:0];
   assign rd = instruction[11:7];
   assign rs1 = instruction[19:15];
   assign rs2 = instruction[24:20];
   assign simm12 = instruction[31:20];
   assign simm7 = instruction[31:25];
   assign imm5 = instruction[11:7];
   assign shamt = instruction[24:20];
   assign shamt_64shift = instruction[25:20]; //Karthik
   assign funct3 = instruction[14:12];
   assign funct7 = instruction[31:25];
   assign funct7_64shift = instruction[31:26]; //Karthik
   
   wire         FORMAT_R;
   assign FORMAT_R = ( (rd < 16) && (rs1 < 16) && (rs2 < 16));
   
   assign ADD = (FORMAT_R && (opcode == 7'b0110011) && (funct7 == 7'b0000000) && (funct3 == 3'b000));
   assign SUB = (FORMAT_R && (opcode == 7'b0110011) && (funct7 == 7'b0100000) && (funct3 == 3'b000));
   assign SLL = (FORMAT_R && (opcode == 7'b0110011) && (funct7 == 7'b0000000) && (funct3 == 3'b001));
   assign SLT = (FORMAT_R && (opcode == 7'b0110011) && (funct7 == 7'b0000000) && (funct3 == 3'b010));
   assign SLTU = (FORMAT_R && (opcode == 7'b0110011) && (funct7 == 7'b0000000) && (funct3 == 3'b011));
   assign XOR = (FORMAT_R && (opcode == 7'b0110011) && (funct7 == 7'b0000000) && (funct3 == 3'b100));
   assign SRL = (FORMAT_R && (opcode == 7'b0110011) && (funct7 == 7'b0000000) && (funct3 == 3'b101));
   assign SRA = (FORMAT_R && (opcode == 7'b0110011) && (funct7 == 7'b0100000) && (funct3 == 3'b101));
   assign OR = (FORMAT_R && (opcode == 7'b0110011) && (funct7 == 7'b0000000) && (funct3 == 3'b110));
   assign AND = (FORMAT_R && (opcode == 7'b0110011) && (funct7 == 7'b0000000) && (funct3 == 3'b111));

   assign MUL = (FORMAT_R && (opcode == 7'b0110011) && (funct7 == 7'b0000001) && (funct3 == 3'b000));
   assign MULH = (FORMAT_R && (opcode == 7'b0110011) && (funct7 == 7'b0000001) && (funct3 == 3'b001));
   assign MULHSU = (FORMAT_R && (opcode == 7'b0110011) && (funct7 == 7'b0000001) && (funct3 == 3'b010));
   assign MULHU = (FORMAT_R && (opcode == 7'b0110011) && (funct7 == 7'b0000001) && (funct3 == 3'b011));

   wire 	allowed_alu_R;
   assign allowed_alu_R = (ADD || SUB || SLL || SLT || SLTU || XOR || SRL || SRA || OR || AND || MUL || MULH || MULHSU || MULHU);
   
   wire         FORMAT_I;
   assign FORMAT_I = ( (rd < 16) && (rs1 < 16) );

   assign ADDI = (FORMAT_I && (opcode == 7'b0010011) && (funct3 == 3'b000));
   assign SLTI = (FORMAT_I && (opcode == 7'b0010011) && (funct3 == 3'b010));
   assign SLTIU = (FORMAT_I && (opcode == 7'b0010011) && (funct3 == 3'b011));
   assign XORI = (FORMAT_I && (opcode == 7'b0010011) && (funct3 == 3'b100));
   assign ORI = (FORMAT_I && (opcode == 7'b0010011) && (funct3 == 3'b110));
   assign ANDI = (FORMAT_I && (opcode == 7'b0010011) && (funct3 == 3'b111));
   assign SLLI = (FORMAT_I && (opcode == 7'b0010011) && (funct7_64shift == 7'b000000) && (funct3 == 3'b001)); // Karthik Update RV64I
   assign SRLI = (FORMAT_I && (opcode == 7'b0010011) && (funct7_64shift == 7'b000000) && (funct3 == 3'b101)); // Karthik Update RV64I
   assign SRAI = (FORMAT_I && (opcode == 7'b0010011) && (funct7_64shift == 7'b010000) && (funct3 == 3'b101)); // Karthik Update RV64I

   wire 	allowed_alu_I;
   assign allowed_alu_I = (ADDI || SLTI || SLTIU || XORI || ORI || ANDI || SLLI || SRLI || SRAI);

   // lw and sw constraints => to allow for finite memory instantiated in dmem by ridecore (dmem reduced to an array of 256, so as to reduce the formal tool runtime)
   assign LW = ((rs1 == 5'b00000) && (rd < 16) && (opcode == 7'b0000011) && (funct3 == 3'b010) && (instruction[31:25] == 7'b0));
   assign SW = ((rs1 == 5'b00000) && (rs2 < 16) && (opcode == 7'b0100011) && (funct3 == 3'b010) && (instruction[31:25] == 7'b0));

   wire 	allowed_mem;
   assign allowed_mem = (LW || SW);

   // NOP to stall the fetch stage (stalling is done by making valid_instruction 0)
   wire 	NOP;
   assign NOP = (opcode == 7'b1111111) && (instruction[31:7] == 25'b0);

   wire 	FORMAT_FPS; //Karthik: Single Precision FP
   assign FORMAT_FPS = ( (rd < 16) && (rs1 < 16) && (rs2 < 16) && ((funct3==3'b000)||(funct3==3'b001)||(funct3==3'b010)||(funct3==3'b011)||(funct3==3'b100)));

   assign FLW = ((rs1 == 5'b00000) && (rd < 16) && (opcode == 7'b0000111) && (funct3 == 3'b010) && (instruction[31:25] == 7'b0));
   assign FSW = ((rs1 == 5'b00000) && (rs2 < 16) && (opcode == 7'b0100111) && (funct3 == 3'b010) && (instruction[31:25] == 7'b0));
   assign FADDS = FORMAT_FPS && (opcode == 7'b1010011) && (funct7 == 7'b0000000);
   assign FSUBS = FORMAT_FPS && (opcode == 7'b1010011) && (funct7 == 7'b0000100);
   assign FMULS = FORMAT_FPS && (opcode == 7'b1010011) && (funct7 == 7'b0001000);
   assign FDIVS = FORMAT_FPS && (opcode == 7'b1010011) && (funct7 == 7'b0001100);
   assign FSQRTS = FORMAT_FPS && (opcode == 7'b1010011) && (rs2 == 5'b00000) && (funct7 == 7'b0101100);
   assign FMINS = FORMAT_FPS && (opcode == 7'b1010011) && (funct3 == 3'b000) && (funct7 == 7'b0010100);
   assign FMAXS = FORMAT_FPS && (opcode == 7'b1010011) && (funct3 == 3'b001) && (funct7 == 7'b0010100);
   assign FEQS = FORMAT_FPS && (opcode == 7'b1010011) && (funct3 == 3'b010) && (funct7 == 7'b1010000);
   assign FLTS = FORMAT_FPS && (opcode == 7'b1010011) && (funct3 == 3'b001) && (funct7 == 7'b1010000);
   assign FLES = FORMAT_FPS && (opcode == 7'b1010011) && (funct3 == 3'b000) && (funct7 == 7'b1010000);

   wire 	allowed_fps;
   assign allowed_fps = (FLW || FSW || FADDS || FSUBS || FMULS || FDIVS || FSQRTS || FMINS || FMAXS || FEQS || FLTS || FLES);

   wire 	FORMAT_FPD; //Karthik: Double Precision FP
   assign FORMAT_FPD = ( (rd < 16) && (rs1 < 16) && (rs2 < 16) && ((funct3==3'b000)||(funct3==3'b001)||(funct3==3'b010)||(funct3==3'b011)||(funct3==3'b100)));
   
   assign FLD = ((rs1 == 5'b00000) && (rd < 16) && (opcode == 7'b0000111) && (funct3 == 3'b011) && (instruction[31:25] == 7'b0));
   assign FSD = ((rs1 == 5'b00000) && (rs2 < 16) && (opcode == 7'b0100111) && (funct3 == 3'b011) && (instruction[31:25] == 7'b0));
   assign FADDD = FORMAT_FPD && (opcode == 7'b1010011) && (funct7 == 7'b0000001);
   assign FSUBD = FORMAT_FPD && (opcode == 7'b1010011) && (funct7 == 7'b0000101);
   assign FMULD = FORMAT_FPD && (opcode == 7'b1010011) && (funct7 == 7'b0001001);
   assign FDIVD = FORMAT_FPD && (opcode == 7'b1010011) && (funct7 == 7'b0001101);
   assign FSQRTD = FORMAT_FPD && (opcode == 7'b1010011) && (rs2 == 5'b00000) && (funct7 == 7'b0101101);
   assign FMIND = FORMAT_FPD && (opcode == 7'b1010011) && (funct3 == 3'b000) && (funct7 == 7'b0010101);
   assign FMAXD = FORMAT_FPD && (opcode == 7'b1010011) && (funct3 == 3'b001) && (funct7 == 7'b0010101);
   assign FEQD = FORMAT_FPD && (opcode == 7'b1010011) && (funct3 == 3'b010) && (funct7 == 7'b1010001);
   assign FLTD = FORMAT_FPD && (opcode == 7'b1010011) && (funct3 == 3'b001) && (funct7 == 7'b1010001);
   assign FLED = FORMAT_FPD && (opcode == 7'b1010011) && (funct3 == 3'b000) && (funct7 == 7'b1010001);

   wire allowed_fpd;
   assign allowed_fpd = (FLD || FSD || FADDD || FSUBD || FMULD || FDIVD || FSQRTD || FMIND || FMAXD || FEQD || FLTD || FLED);

   assume_allowed_instructions: assume property (@ (posedge clk) (allowed_alu_I | allowed_alu_R | NOP | allowed_fps | allowed_fpd));   
endmodule

