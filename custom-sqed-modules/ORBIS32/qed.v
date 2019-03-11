`include "qed.vh"

module qed (
   // Outputs
   qed_ifu_instruction, vld_out,
   // Inputs
   rst, ena,
   clk, 
   ifu_qed_instruction, exec_dup, stall_IF
   );

   input rst;
   input ena;

   input clk;
   input exec_dup;
   input stall_IF;

   input [31:0] ifu_qed_instruction;
   output [31:0] qed_ifu_instruction;
   output        vld_out;
   
   wire [4:0] 	 rD;
   wire [4:0] 	 rA;
   wire [4:0] 	 rB;
   wire [5:0] 	 opcode6;
   wire [3:0]    opcode4;
   wire [1:0]    opcode2;

   wire [15:0] 	 simm16;  // signed imm for I type or instructions using rD, rA only
   wire [3:0] 	 opcode4EXT;

   wire 	 is_lw;
   wire 	 is_sw;
   wire 	 is_aluimm;
   wire 	 is_alureg; // includes mult instructions

   wire [31:0]	 qed_instruction;
   wire [31:0] 	 qic_qimux_instruction;

   qed_decoder dec (.ifu_qed_instruction(qic_qimux_instruction),
                    /*AUTOINST*/
                    // Outputs
                    .is_lw          (is_lw),
                    .is_sw          (is_sw),
		    .is_alureg      (is_alureg),
		    .is_aluimm      (is_aluimm),
                    .rD             (rD),
                    .rA             (rA),
                    .rB             (rB),
                    .simm16         (simm16),
		    .opcode6        (opcode6),
		    .opcode4        (opcode4),
		    .opcode2        (opcode2),
		    .opcode4EXT     (opcode4EXT));

   modify_instruction minst (
                             // Outputs
                             .qed_instruction   (qed_instruction),
                             // Inputs
                             .qic_qimux_instruction(qic_qimux_instruction),
                             .is_lw      (is_lw),
                             .is_sw      (is_sw),
                             .is_aluimm  (is_aluimm),
                             .is_alureg  (is_alureg),
                             .simm16     (simm16),
                             .rD         (rD),
                             .rA         (rA),
                             .rB         (rB),
			     .opcode6    (opcode6),
			     .opcode4    (opcode4),
			     .opcode2    (opcode2),
			     .opcode4EXT (opcode4EXT));

   qed_instruction_mux imux (/*AUTOINST*/
                             // Outputs
                             .qed_ifu_instruction(qed_ifu_instruction),
                             // Inputs
                             .ifu_qed_instruction(ifu_qed_instruction),
                             .qed_instruction   (qed_instruction),
			     .exec_dup          (exec_dup),
                             .ena               (ena));

   qed_i_cache qic (/*AUTOINST*/
                    // Outputs
                    .qic_qimux_instruction(qic_qimux_instruction),
		    .vld_out(vld_out),
                    // Inputs
                    .clk                (clk),
                    .rst                (rst),
		    .exec_dup(exec_dup),
		    .IF_stall(stall_IF),
                    .ifu_qed_instruction(ifu_qed_instruction));
   
endmodule // qed
