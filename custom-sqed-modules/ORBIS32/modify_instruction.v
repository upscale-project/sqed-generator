// use along with input constraints to the formal tool

module modify_instruction (qic_qimux_instruction,
                           is_lw,
                           is_sw,
                           is_aluimm,
			   is_alureg,
                           simm16,
                           rD,
                           rA,
                           rB,
			   opcode6,
			   opcode4,
			   opcode2,
			   opcode4EXT,

                           qed_instruction);

   input [31:0] qic_qimux_instruction;
   wire [31:0]  instruction;
   assign instruction = qic_qimux_instruction;

   input [4:0] 	rD;
   input [4:0]  rA;
   input [4:0]  rB;
   input [5:0]  opcode6;
   input [3:0]  opcode4;
   input [1:0]  opcode2;
   input [3:0]  opcode4EXT;

   input [15:0] simm16;  // signed imm for I type or instructions using rd, rs1 only

   input 	is_lw;
   input 	is_sw;
   input 	is_aluimm;
   input 	is_alureg; // includes mult instructions

   output [31:0] qed_instruction;
   
   wire [31:0]   ins_lw;
   wire [31:0]   ins_sw;
   wire [31:0]   ins_alureg;
   wire [31:0]   ins_aluimm;

   wire [4:0]    new_rD;
   wire [4:0]    new_rA;
   wire [4:0]    new_rB;
  
   assign new_rD  = (rD  == 5'b00000) ? rD  : {1'b1, rD[3:0]};
   assign new_rA = (rA == 5'b00000) ? rA : {1'b1, rA[3:0]};
   assign new_rB = (rB == 5'b00000) ? rB : {1'b1, rB[3:0]};
   
   assign ins_alureg = {opcode6, new_rD, new_rA, new_rB, instruction[10], opcode2, instruction[7:4], opcode4}; 
   assign ins_aluimm = {opcode6, new_rD, new_rA, simm16}; 
  
   assign ins_lw    = {opcode6, new_rD, new_rA, 2'b01, simm16[13:0]};
   assign ins_sw    = {opcode6, 2'b01, instruction[23:21], new_rA, new_rB, instruction[10:0]}; 

   assign qed_instruction = is_lw ? ins_lw : (is_sw ? ins_sw : (is_alureg ? ins_alureg : 
								(is_aluimm ? ins_aluimm : instruction)));
      
endmodule // modify_instruction

                           
