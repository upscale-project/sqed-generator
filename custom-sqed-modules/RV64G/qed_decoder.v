// decoder for RISCV
// only supports a subset of R,I,S type instructions see riscv-spec-v2.1.pdf
// used along with strict input constraints to ifu_qed_instruction (specified for the formal tool)

module qed_decoder (/*AUTOARG*/
   // Outputs
   is_lw, is_sw,is_aluimm,is_aluimm_64, is_alureg, is_jalr, rd, rs1, rs2, opcode, simm12, funct3, funct7, funct7_64,
   imm5,simm7, shamt, shamt_64,
   // Inputs
   ifu_qed_instruction
   );
                 
   input  [31:0] ifu_qed_instruction;
   wire   [31:0] instruction;
   assign instruction = ifu_qed_instruction;
   
   output [4:0]  rd;
   output [4:0]  rs1;
   output [4:0]  rs2;
   output [6:0]  opcode;
   output [11:0] simm12;  // signed imm for I type or instructions using rd, rs1 only like LW 
   output [2:0] funct3;
   output [6:0] funct7;
   output [5:0] funct7_64; //funct7 for special RV64I shifts
   output [4:0] imm5;  // lower order imm bits for S type instruction
   output [6:0] simm7; // higher order bits (including sign bits) of imm operand for S type instruction
   output [4:0] shamt; // shift amount for immediate shift operations
   output [5:0] shamt_64; //shift for special RV64I shifts
   	
   // determine which format to use
   output 	is_lw;
   output 	is_sw;
   output 	is_aluimm;
   output 	is_aluimm_64;
   output 	is_alureg; // includes mult instructions
   output  	is_jalr; 

   // op, for all formats
   assign opcode = instruction[6:0];
   assign rd = instruction[11:7];
   assign rs1 = instruction[19:15];
   assign rs2 = instruction[24:20];
   assign simm12 = instruction[31:20];
   assign simm7 = instruction[31:25];
   assign imm5 = instruction[11:7];
   assign shamt = instruction[24:20];
   assign shamt_64 = instruction[25:20]; //Karthik
   assign funct3 = instruction[14:12];
   assign funct7 = instruction[31:25];
   assign funct7_64 = instruction[31:26]; //Karthik

   // these constraints taken from riscv-spec-v2.1.pdf (pg. 54)
   assign is_lw = (((opcode==7'b0000011)||(opcode==7'b0000111))&&(funct3==3'b010)) || ((opcode==7'b0000111)&&(funct3==3'b011)); // Karthik add: FLW and FLD
   assign is_sw = (((opcode==7'b0100011)||(opcode==7'b0100111))&&(funct3==3'b010)) || ((opcode==7'b0100111)&&(funct3==3'b011)); // Karthik add: FSW and FSD
   assign is_alureg = (opcode==7'b0110011)||(opcode==7'b1010011); //Karthik add: FP operations
   assign is_aluimm = (opcode==7'b0010011); 
   assign is_aluimm_64 = (opcode==7'b0010011) && (((funct7_64==7'b000000) && (funct3==3'b001)) || ((funct7_64==7'b000000) && (funct3==3'b101)) || ((funct7_64==7'b010000) && (funct3==3'b101))); // Karthik SLLI, SRLI, and SRAI are different now for 64 bit data
     
   assign is_jalr = (opcode==7'b1100111);  
endmodule // qed_decoder


