// constraints for OpenRISC ORBIS32 instructions

module inst_constraint_ORBIS32(clk, 
                       instruction);
   
   input        clk;
   input [31:0] instruction;

   wire [4:0]  rD;
   wire [4:0]  rA;
   wire [4:0]  rB;
   wire [5:0]  opcode6;
   wire [1:0] opcode2;
   wire [3:0] opcode4;
   wire [15:0] simm16;  // immediate for instructions using rD, rA only like LW 
   
   wire [3:0] opcode4EXT; //extra opcode for EXT instructions

   // Basic Arithmetic Instructions
   wire       ADD;
   wire       AND;
   wire       DIV;
   wire       DIVU;
   wire       EXTBS;
   wire       EXTBZ;
   wire       EXTHS;
   wire       EXTHZ;
   wire       EXTWS;
   wire       EXTWZ;
   wire       FF1;
   wire       FL1;
   wire       MUL;	
   wire       MULU;
   wire       OR;  
   wire       ROR; 
   wire       SLL; 
   wire       SRA;
   wire       SRL; 
   wire       SUB;
   wire       XOR;

   // Immediate instructions
   wire       ADDI;
   wire       ANDI;
   wire       MOVHI;
   wire       MULI;
   wire       ORI; 
   wire       SLLI; 
   wire       SRAI;
   wire       SRLI;
   wire       XORI;

   // mem ops
   wire       LBS;
   wire       LBZ;
   wire       LHS;
   wire       LHZ;
   wire       LWS;
   wire       LWZ;
   wire       SB;
   wire       SH;
   wire       SW;

   assign opcode6 = instruction[31:26];
   assign rD = instruction[25:21];
   assign rA = instruction[20:16];
   assign rB = instruction[15:11];
   assign opcode2 = instruction[9:8];
   assign opcode4 = instruction[3:0];
   assign simm16 = instruction[15:0];

   assign opcode4EXT = instruction[9:6];
   assign opcodeFP = instruction[7:0];
   
   wire         FORMAT_R;
   assign FORMAT_R = ((rD < 16) && (rA < 16) && (rB < 16));
   
   assign ADD = (FORMAT_R && (opcode6 == 6'b111000) && (opcode2 == 2'b00) && (opcode4 == 4'b0000));
   assign AND = (FORMAT_R && (opcode6 == 6'b111000) && (opcode2 == 2'b00) && (opcode4 == 4'b0011));  
   assign DIV = (FORMAT_R && (opcode6 == 6'b111000) && (opcode2 == 2'b11) && (opcode4 == 4'b1001));
   assign DIVU = (FORMAT_R && (opcode6 == 6'b111000) && (opcode2 == 2'b11) && (opcode4 == 4'b1010));
   assign FF1 = (FORMAT_R && (opcode6 == 6'b111000) && (opcode2 == 2'b00) && (opcode4 == 4'b1111));
   assign FL1 = (FORMAT_R && (opcode6 == 6'b111000) && (opcode2 == 2'b01) && (opcode4 == 4'b1111));
   assign MUL = (FORMAT_R && (opcode6 == 6'b111000) && (opcode2 == 2'b11) && (opcode4 == 4'b0110));
   assign MULU = (FORMAT_R && (opcode6 == 6'b111000) && (opcode2 == 2'b11) && (opcode4 == 4'b1011));
   assign OR = (FORMAT_R && (opcode6 == 6'b111000) && (opcode2 == 2'b00) && (opcode4 == 4'b0100));
   assign ROR = (FORMAT_R && (opcode6 == 6'b111000) && (opcode2 == 2'b11) && (opcode4 == 4'b1000));
   assign SUB = (FORMAT_R && (opcode6 == 6'b111000) && (opcode2 == 2'b00) && (opcode4 == 4'b0010));
   assign XOR = (FORMAT_R && (opcode6 == 6'b111000) && (opcode2 == 2'b00) && (opcode4 == 4'b0101));

   assign SLL = (FORMAT_R && (opcode6 == 6'b111000) && (opcode4EXT == 4'b0000) && (opcode4 == 4'b1000));
   assign SRA = (FORMAT_R && (opcode6 == 6'b111000) && (opcode4EXT == 4'b0010) && (opcode4 == 4'b1000));
   assign SRL = (FORMAT_R && (opcode6 == 6'b111000) && (opcode4EXT == 4'b0001) && (opcode4 == 4'b1000));

   assign EXTBS = (FORMAT_R && (opcode6 == 6'b111000) && (opcode4EXT == 4'b0001) && (opcode4 == 4'b1100));
   assign EXTBZ = (FORMAT_R && (opcode6 == 6'b111000) && (opcode4EXT == 4'b0011) && (opcode4 == 4'b1100));
   assign EXTHS = (FORMAT_R && (opcode6 == 6'b111000) && (opcode4EXT == 4'b0000) && (opcode4 == 4'b1100));
   assign EXTHZ = (FORMAT_R && (opcode6 == 6'b111000) && (opcode4EXT == 4'b0010) && (opcode4 == 4'b1100));
   assign EXTWS = (FORMAT_R && (opcode6 == 6'b111000) && (opcode4EXT == 4'b0000) && (opcode4 == 4'b1101));
   assign EXTWZ = (FORMAT_R && (opcode6 == 6'b111000) && (opcode4EXT == 4'b0001) && (opcode4 == 4'b1101));

   wire 	allowed_alu_R;
   assign allowed_alu_R = (ADD || AND || DIV || DIVU  || FF1 || FL1 || MUL || MULU || OR || ROR || XOR || SUB || SLL || SRA || SRL || EXTBS || EXTBZ || EXTHS || EXTHZ || EXTWS || EXTWZ);
   
   // Immediate Operations
   wire         FORMAT_I;
   assign FORMAT_I = ((rD < 16) && (rA < 16));

   assign ADDI = (FORMAT_I && (opcode6 == 6'b100111));
   assign ANDI = (FORMAT_I && (opcode6 == 6'b101001));
   assign MULI = (FORMAT_I && (opcode6 == 6'b101100));
   assign ORI = (FORMAT_I && (opcode6 == 6'b101010));
   assign XORI = (FORMAT_I && (opcode6 == 6'b101011));

   assign SLLI = (FORMAT_I && (opcode6 == 6'b101110) && (instruction[7:6]==2'b00));
   assign SRAI = (FORMAT_I && (opcode6 == 6'b101110) && (instruction[7:6]==2'b10));
   assign SRLI = (FORMAT_I && (opcode6 == 6'b101110) && (instruction[7:6]==2'b01));

   wire 	allowed_alu_I;
   assign allowed_alu_I = (ADDI || ANDI || MULI || ORI || XORI || SLLI || SRAI || SRLI);

   // Load and Store Commands
   assign LBS = (FORMAT_I && (opcode6 == 6'b100100) && (rA == 5'b00000) && (instruction[15:14]==2'b00));
   assign LBZ = (FORMAT_I && (opcode6 == 6'b100011) && (rA == 5'b00000) && (instruction[15:14]==2'b00));
   assign LHS = (FORMAT_I && (opcode6 == 6'b100110) && (rA == 5'b00000) && (instruction[15:14]==2'b00));
   assign LHZ = (FORMAT_I && (opcode6 == 6'b100101) && (rA == 5'b00000) && (instruction[15:14]==2'b00));
   assign LWS = (FORMAT_I && (opcode6 == 6'b100010) && (rA == 5'b00000) && (instruction[15:14]==2'b00));
   assign LWZ = (FORMAT_I && (opcode6 == 6'b100001) && (rA == 5'b00000) && (instruction[15:14]==2'b00));

   assign SB = ((opcode6 == 6'b110110) && (rA == 5'b00000) && (rB<16) && (instruction[25:24]==2'b00));
   assign SH = ((opcode6 == 6'b110111) && (rA == 5'b00000) && (rB<16) && (instruction[25:24]==2'b00));
   assign SW = ((opcode6 == 6'b110101) && (rA == 5'b00000) && (rB<16) && (instruction[25:24]==2'b00));

   wire 	allowed_mem;
   assign allowed_mem = (LBS || LBZ || LHS || LHZ || LWS || LWZ || SB || SH || SW);

   // NOP to stall the fetch stage
   wire 	NOP;
   assign NOP = (instruction == {8'b00010101,24'd0});

   // Single-Precision Floating Point
   wire 	FORMAT_FP;
   assign FORMAT_FP = ((rD < 16) && (rA < 16) && (rB < 16) && (opcode6 == 6'b110010));

   assign FADD = (FORMAT_FP && (opcodeFP == 8'b00000000));
   assign FDIV = (FORMAT_FP && (opcodeFP == 8'b00000011));
   assign FTOI = (FORMAT_FP && (opcodeFP == 8'b00000101) && (rB == 5'b00000));
   assign ITOF = (FORMAT_FP && (opcodeFP == 8'b00000100) && (rB == 5'b00000));
   assign FMUL = (FORMAT_FP && (opcodeFP == 8'b00000010));
   assign FREM = (FORMAT_FP && (opcodeFP == 8'b00000110));
   assign FSUB = (FORMAT_FP && (opcodeFP == 8'b00000001));

   assign allowed_fp = (FADD | FDIV | FTOI | ITOF | FMUL | FREM | FSUB);

   assume_allowed_instructions: assume property (@ (posedge clk) (allowed_alu_R | allowed_alu_I | allowed_fp | NOP));
      
endmodule

