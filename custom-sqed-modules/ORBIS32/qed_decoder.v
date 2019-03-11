// decoder for OpenRISC
// supports ORBIS32 ISA
// used along with strict input constraints to ifu_qed_instruction (specified for the formal tool)

module qed_decoder (/*AUTOARG*/
   // Outputs
   is_lw, is_sw, is_aluimm, is_alureg, rD, rA, rB, simm16, opcode6, opcode4, opcode2, opcode4EXT,
   // Inputs
   ifu_qed_instruction
   );

   input  [31:0] ifu_qed_instruction;
   wire   [31:0] instruction;
   assign instruction = ifu_qed_instruction;
   
   output [4:0]  rD;
   output [4:0]  rA;
   output [4:0]  rB;

   output [5:0]  opcode6;
   output [3:0]  opcode4;
   output [1:0]  opcode2;
   output [3:0]  opcode4EXT;
   output [15:0] simm16;
  	
   // determine which format to use
   output 	is_lw;
   output 	is_sw;
   output 	is_aluimm;
   output 	is_alureg; // includes mult instructions

   // op, for all formats
   assign opcode6 = instruction[31:26];
   assign rD = instruction[25:21];
   assign rA = instruction[20:16];
   assign rB = instruction[15:11];
   assign opcode2 = instruction[9:8];
   assign opcode4 = instruction[3:0];
   assign opcode4EXT = instruction[9:6];
   assign simm16 = instruction[15:0];

   assign is_lw = (instruction[15:14]==2'b00) && ((opcode6 == 6'b100100) || (opcode6 == 6'b100011) || (opcode6 == 6'b100110) || (opcode6 == 6'b100101) || (opcode6 == 6'b100010) || (opcode6 == 6'b100001));
   assign is_sw = ((opcode6 == 6'b110110) || (opcode6 == 6'b110111) || (opcode6 == 6'b110101));
   assign is_alureg = (opcode6 == 6'b111000);
   assign is_aluimm = ((opcode6 == 6'b100111) || (opcode6 == 6'b101001) || (opcode6 == 6'b101100) || (opcode6 == 6'b101010) || (opcode6 == 6'b101011) || (opcode6 == 6'b101110));
        
endmodule // qed_decoder


