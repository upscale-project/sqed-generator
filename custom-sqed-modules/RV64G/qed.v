`include "qed.vh"

module qed (/*AUTOARG*/
   // Outputs
   qed_ifu_instruction, vld_out,
   // Inputs
   rst, ena,
     clk,
    ifu_qed_instruction, exec_dup, stall_IF  // stall_IF will avoid state change in the i_cache 
   );

   input rst;
   input ena;
   input clk;
   input exec_dup;
   input stall_IF;
   input [31:0] ifu_qed_instruction;
   output [31:0] qed_ifu_instruction;
   output        vld_out;
   
   wire [4:0] 	 rd;
   wire [4:0] 	 rs1;
   wire [4:0] 	 rs2;
   wire [6:0] 	 opcode;
   wire [11:0] 	 simm12;  // signed imm for I type or instructions using rd, rs1 only like LW 
   wire [2:0] 	 funct3;
   wire [6:0] 	 funct7;
   wire [5:0] 	 funct7_64; //Karthik
   wire [4:0] 	 imm5;  // lower order imm bits for S type instruction
   wire [6:0] 	 simm7; // higher order bits (including sign bits) of imm operand for S type instruction
   wire [4:0] 	 shamt; // shift amount for immediate shift operations
   wire [5:0] 	 shamt_64; //Karthik
   wire 	 is_lw;
   wire 	 is_sw;
   wire 	 is_aluimm;
   wire		 is_aluimm_64; //Karthik One of 3 RV64I shifts
   wire 	 is_alureg; // includes mult instructions
   wire		 is_jalr;

   wire [31:0]	 qed_instruction;
   wire [31:0] 	 qic_qimux_instruction;

   qed_decoder dec (.ifu_qed_instruction(qic_qimux_instruction),
                    /*AUTOINST*/
                    // Outputs
                    .is_lw          (is_lw),
                    .is_sw          (is_sw),
		    .is_alureg      (is_alureg),
		    .is_aluimm      (is_aluimm),
                    .is_aluimm_64   (is_aluimm_64),
		    .is_jalr	    (is_jalr), 
                    .rd             (rd),
                    .rs1            (rs1),
                    .rs2            (rs2),
                    .simm12         (simm12),
		    .opcode         (opcode),
		    .funct7         (funct7),
		    .funct7_64      (funct7_64),
		    .funct3         (funct3),
		    .imm5           (imm5),
		    .shamt          (shamt),
                    .shamt_64       (shamt_64),
                    .simm7          (simm7)
		    );

   modify_instruction minst (
                             // Outputs
                             .qed_instruction   (qed_instruction),
                             // Inputs
                             .qic_qimux_instruction(qic_qimux_instruction),
                             .is_lw      (is_lw),
                             .is_sw      (is_sw),
                             .is_aluimm  (is_aluimm),
                             .is_aluimm_64   (is_aluimm_64),
                             .is_alureg  (is_alureg),
  			     .is_jalr    (is_jalr),
                             .rd         (rd),
                             .rs1        (rs1),
                             .rs2        (rs2),
                             .simm12     (simm12),
			     .opcode     (opcode),
			     .funct3     (funct3),
			     .funct7     (funct7),
			     .funct7_64     (funct7_64),
			     .imm5       (imm5),
			     .shamt      (shamt),
			     .shamt_64      (shamt_64),
                             .simm7      (simm7));

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
   
endmodule
